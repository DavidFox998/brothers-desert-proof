"""
End-to-end test for the Stripe checkout.session.completed → email flow.

What this covers
----------------
* POST /webhook with a valid-looking checkout.session.completed event
  returns HTTP 200.
* send_api_key_email is called (mocked — no real Resend network traffic).
* It is called with the correct recipient address and a non-empty API key.
* The webhook also returns HTTP 400 when the Stripe signature is missing or
  the webhook secret is not configured.

All tests are fully offline:
  - stripe.Webhook.construct_event is patched so no real signature is needed.
  - send_api_key_email is patched so no real email is sent.
  - No RESEND_API_KEY or STRIPE_SECRET_KEY env vars are required.
"""

import json
import os
from unittest.mock import MagicMock, patch, AsyncMock

import pytest
from fastapi.testclient import TestClient


# ---------------------------------------------------------------------------
# Minimal Stripe event fixture
# ---------------------------------------------------------------------------

def _make_checkout_completed(
    email: str = "buyer@example.com",
    amount_total: int = 1000,          # cents → $10.00 → pro_10 tier
    session_id: str = "cs_test_abc123",
    customer_id: str = "cus_test_xyz",
) -> dict:
    """Return a minimal checkout.session.completed event dict."""
    return {
        "id": "evt_test_001",
        "type": "checkout.session.completed",
        "data": {
            "object": {
                "id": session_id,
                "object": "checkout.session",
                "customer": customer_id,
                "customer_details": {"email": email},
                "amount_total": amount_total,
                "payment_status": "paid",
            }
        },
    }


# ---------------------------------------------------------------------------
# Helpers — construct a fake signed payload (body bytes + header string).
# We don't need a real signature because we patch construct_event.
# ---------------------------------------------------------------------------

def _fake_payload(event: dict) -> bytes:
    return json.dumps(event).encode()


_FAKE_SIG = "t=1700000000,v1=fakesignature"
_FAKE_SECRET = "whsec_test_secret"

# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture()
def client(monkeypatch):
    """
    Return a TestClient for the FastAPI app with:
      - STRIPE_WEBHOOK_SECRET set to a fake value
      - RESEND_API_KEY set to a dummy (so emailer doesn't CRITICAL-log)
      - stripe.Webhook.construct_event patched to skip real signature check
    """
    monkeypatch.setenv("STRIPE_WEBHOOK_SECRET", _FAKE_SECRET)
    monkeypatch.setenv("RESEND_API_KEY", "re_dummy_key_for_tests")
    monkeypatch.setenv("ADMIN_SECRET", "test_admin")

    # Import app here so env vars are already set before the module resolves them.
    import zerobeacon_mf_1000_main as main_mod

    with TestClient(main_mod.app, raise_server_exceptions=True) as tc:
        yield tc


def _post_webhook(client: TestClient, event: dict) -> "Response":  # noqa: F821
    payload = _fake_payload(event)
    return client.post(
        "/webhook",
        content=payload,
        headers={
            "Content-Type": "application/json",
            "Stripe-Signature": _FAKE_SIG,
        },
    )


# ---------------------------------------------------------------------------
# Test 1 — returns HTTP 400 when STRIPE_WEBHOOK_SECRET is not configured
# ---------------------------------------------------------------------------

def test_webhook_returns_400_when_secret_not_configured(monkeypatch):
    monkeypatch.delenv("STRIPE_WEBHOOK_SECRET", raising=False)
    monkeypatch.setenv("RESEND_API_KEY", "re_dummy")
    monkeypatch.setenv("ADMIN_SECRET", "test_admin")

    import zerobeacon_mf_1000_main as main_mod

    with TestClient(main_mod.app, raise_server_exceptions=False) as tc:
        resp = tc.post(
            "/webhook",
            content=b'{"type":"checkout.session.completed"}',
            headers={"Content-Type": "application/json"},
        )
    assert resp.status_code == 400
    assert "webhook secret" in resp.json().get("error", "").lower()


# ---------------------------------------------------------------------------
# Test 2 — returns HTTP 400 when Stripe-Signature is invalid
# ---------------------------------------------------------------------------

def test_webhook_returns_400_on_bad_signature(client):
    import stripe

    event = _make_checkout_completed()
    payload = _fake_payload(event)

    # Do NOT patch construct_event — let the real signature check fail.
    resp = client.post(
        "/webhook",
        content=payload,
        headers={
            "Content-Type": "application/json",
            "Stripe-Signature": "t=0,v1=badsig",
        },
    )
    assert resp.status_code == 400


# ---------------------------------------------------------------------------
# Test 3 — happy path: send_api_key_email is called with correct args
# ---------------------------------------------------------------------------

def test_checkout_completed_triggers_email(client):
    """
    A valid checkout.session.completed event must:
      1. Return HTTP 200 immediately.
      2. Invoke send_api_key_email with the buyer's email and a non-empty key.
    """
    email = "happybuyer@example.com"
    event = _make_checkout_completed(email=email, amount_total=1000)

    import stripe
    import zerobeacon_mf_1000_main as main_mod

    with (
        patch.object(stripe.Webhook, "construct_event", return_value=event),
        patch.object(main_mod, "send_api_key_email", return_value=True) as mock_send,
    ):
        resp = _post_webhook(client, event)

    assert resp.status_code == 200, f"Expected 200, got {resp.status_code}: {resp.text}"

    # Background task should have fired before TestClient returns.
    assert mock_send.called, "send_api_key_email was never called"
    call_kwargs = mock_send.call_args
    # Could be positional or keyword — normalise.
    args   = call_kwargs.args   if call_kwargs.args   else ()
    kwargs = call_kwargs.kwargs if call_kwargs.kwargs else {}

    called_email   = kwargs.get("email",   args[0] if len(args) > 0 else None)
    called_api_key = kwargs.get("api_key", args[1] if len(args) > 1 else None)

    assert called_email == email, (
        f"send_api_key_email called with wrong email: {called_email!r}"
    )
    assert called_api_key, "send_api_key_email called with empty/None api_key"
    assert called_api_key.startswith("zbk_"), (
        f"Expected api_key to start with 'zbk_', got: {called_api_key!r}"
    )


# ---------------------------------------------------------------------------
# Test 4 — tier mapping: $100 payment → pro_100 tier email
# ---------------------------------------------------------------------------

@pytest.mark.parametrize("amount_cents,expected_tier", [
    (1000,   "pro_10"),
    (10000,  "pro_100"),
    (100000, "enterprise_1000"),
])
def test_checkout_tier_mapping(client, amount_cents, expected_tier):
    """send_api_key_email must receive the tier that matches the payment amount."""
    event = _make_checkout_completed(
        email="tiertester@example.com",
        amount_total=amount_cents,
    )

    import stripe
    import zerobeacon_mf_1000_main as main_mod

    with (
        patch.object(stripe.Webhook, "construct_event", return_value=event),
        patch.object(main_mod, "send_api_key_email", return_value=True) as mock_send,
    ):
        resp = _post_webhook(client, event)

    assert resp.status_code == 200
    assert mock_send.called, "send_api_key_email was never called"

    call_kwargs = mock_send.call_args
    args   = call_kwargs.args   if call_kwargs.args   else ()
    kwargs = call_kwargs.kwargs if call_kwargs.kwargs else {}
    called_tier = kwargs.get("tier", args[2] if len(args) > 2 else None)
    assert called_tier == expected_tier, (
        f"For ${amount_cents/100:.0f} expected tier={expected_tier!r}, got {called_tier!r}"
    )


# ---------------------------------------------------------------------------
# Test 5 — free-tier ($0) payment must NOT issue an email
# ---------------------------------------------------------------------------

def test_free_tier_payment_does_not_trigger_email(client):
    """
    A $0 / free checkout must not send an email — the customer has no paid key.
    """
    event = _make_checkout_completed(
        email="freetier@example.com",
        amount_total=0,
    )

    import stripe
    import zerobeacon_mf_1000_main as main_mod

    with (
        patch.object(stripe.Webhook, "construct_event", return_value=event),
        patch.object(main_mod, "send_api_key_email", return_value=True) as mock_send,
    ):
        resp = _post_webhook(client, event)

    assert resp.status_code == 200
    assert not mock_send.called, (
        "send_api_key_email should NOT be called for a free-tier payment"
    )


# ---------------------------------------------------------------------------
# Test 6 — email failure must NOT prevent HTTP 200 (webhook must still ACK)
# ---------------------------------------------------------------------------

def test_email_failure_still_returns_200(client):
    """
    Even when send_api_key_email returns False (Resend down), the webhook
    must return 200 so Stripe does not retry unnecessarily.  The key is
    already stored in the keystore; the customer can retrieve it another way.
    """
    event = _make_checkout_completed(email="unlucky@example.com", amount_total=1000)

    import stripe
    import zerobeacon_mf_1000_main as main_mod

    with (
        patch.object(stripe.Webhook, "construct_event", return_value=event),
        patch.object(main_mod, "send_api_key_email", return_value=False),
    ):
        resp = _post_webhook(client, event)

    assert resp.status_code == 200, (
        f"Webhook must return 200 even when email fails; got {resp.status_code}"
    )
