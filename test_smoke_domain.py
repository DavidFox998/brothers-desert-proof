"""
Post-deploy uptime smoke test for the branded ZeroBeacon domain.

This test verifies public reachability and identity.  It intentionally does
not require an exact installed tool count: a deployment can legitimately lag
behind a catalog release.  Exact registry totals belong in the local catalog
contract tests.
"""

import requests


DOMAIN = "https://zerobeacon.ai"
MOAT_P1 = 3000105001
BEACON_URL = f"{DOMAIN}/api/mf/01/beacon?p={MOAT_P1}"
HEALTH_URL = f"{DOMAIN}/health"
EXPECTED_SITE = DOMAIN
EXPECTED_BEACON = "1d2c7a5b"
EXPECTED_D = 2303582338
MIN_HEALTHY_TOOL_COUNT = 1000
TIMEOUT = 30


def _get_json(url: str) -> dict:
    response = requests.get(url, timeout=TIMEOUT)
    assert response.status_code == 200, (
        f"Expected HTTP 200 from {url}, got {response.status_code}. "
        f"Body: {response.text[:300]}"
    )
    return response.json()


def test_branded_domain_beacon_status():
    """The public beacon endpoint must return HTTP 200."""
    _get_json(BEACON_URL)


def test_branded_domain_beacon_site_field():
    """The beacon response must identify the canonical branded domain."""
    data = _get_json(BEACON_URL)
    assert data.get("site") == EXPECTED_SITE, (
        f"site mismatch: expected {EXPECTED_SITE!r}, got {data.get('site')!r}"
    )


def test_branded_domain_beacon_identity():
    """The beacon response must retain the canonical beacon constants."""
    data = _get_json(BEACON_URL)
    assert data.get("p") == MOAT_P1
    assert data.get("beacon") == EXPECTED_BEACON
    assert data.get("d") == EXPECTED_D
    assert data.get("ok") is True


def test_health_status():
    """The public health endpoint must return HTTP 200."""
    _get_json(HEALTH_URL)


def test_health_ok_flag():
    """/health must explicitly report an operational status."""
    data = _get_json(HEALTH_URL)
    assert data.get("ok") is True
    assert data.get("status") == "ok"


def test_health_site_and_identity():
    """/health must retain the canonical domain and beacon identity."""
    data = _get_json(HEALTH_URL)
    assert data.get("site") == EXPECTED_SITE
    assert data.get("beacon") == EXPECTED_BEACON
    assert data.get("d") == EXPECTED_D


def test_health_tool_count_is_plausible():
    """A healthy deployment must expose a numeric production-scale catalog."""
    data = _get_json(HEALTH_URL)
    tools = data.get("tools")
    assert isinstance(tools, int) and tools >= MIN_HEALTHY_TOOL_COUNT, (
        f"/health returned an invalid tool count: {tools!r}; "
        f"expected an integer >= {MIN_HEALTHY_TOOL_COUNT}"
    )