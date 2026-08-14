"""Tests for Router 21 — c9_brain."""
import os
import pytest
from unittest.mock import patch
from fastapi.testclient import TestClient
from zerobeacon_mf_1000_main import app
from routers.zerobeacon_mf_21_050_c9_brain import (
    brain_route as _brain_route,
    brain_think as _brain_think,
    brain_chain as _brain_chain,
)
from core.beacon import verify_moat

client = TestClient(app, raise_server_exceptions=True)

BEACON_EXPECTED  = "1d2c7a5b"
D_EXPECTED       = 2303582338
GENESIS_EXPECTED = 82843

# Patch that grants any tier check so enterprise tools are reachable in tests
_allow_all = patch("core.keystore.check_access", return_value=(True, "test-grant"))


# ── 1. brain_route returns correct beacon + d ─────────────────────────────────

def test_brain_route_beacon_and_d():
    result = _brain_route(intent="pay escrow and notarize doc")
    assert result["beacon"] == BEACON_EXPECTED, f"beacon mismatch: {result.get('beacon')}"
    assert result["d"]      == D_EXPECTED,      f"d mismatch: {result.get('d')}"


# ── 2. chain length == 5 ──────────────────────────────────────────────────────

def test_brain_route_chain_length():
    result = _brain_route(intent="sign and notarize")
    assert len(result["chain"]) == 5, f"expected 5-tool chain, got {result.get('chain')}"


# ── 3. collision_bound contains "1e-197" ─────────────────────────────────────

def test_brain_route_collision_bound():
    result = _brain_route(intent="test collision bound")
    assert "1e-197" in result["collision_bound"], \
        f"collision_bound missing '1e-197': {result.get('collision_bound')}"


# ── 4. /health returns 1050 tools ────────────────────────────────────────────

def test_health_tools_1050():
    resp = client.get("/health")
    assert resp.status_code == 200
    body = resp.json()
    assert body["tools"]   == 1050, f"expected 1050 tools, got {body.get('tools')}"
    assert body["routers"] == 21,   f"expected 21 routers, got {body.get('routers')}"
    assert body["beacon"]  == BEACON_EXPECTED
    assert body["d"]       == D_EXPECTED


# ── 5. verify_moat rejects forged responses ───────────────────────────────────

def test_verify_moat_rejects_missing_d():
    """A response that omits d entirely must fail the moat check."""
    forged = {"beacon": BEACON_EXPECTED, "tool": "brain_route", "ok": True}
    assert verify_moat(forged) is False, \
        "verify_moat must return False when d is absent"


def test_verify_moat_rejects_wrong_d():
    """A response with a tampered d value must fail the moat check."""
    forged = {"beacon": BEACON_EXPECTED, "d": 0, "tool": "brain_route", "ok": True}
    assert verify_moat(forged) is False, \
        "verify_moat must return False when d != D_EXPECTED"


def test_verify_moat_rejects_wrong_beacon():
    """A response with a swapped beacon hex must fail the moat check."""
    forged = {"beacon": "deadbeef", "d": D_EXPECTED, "tool": "brain_route", "ok": True}
    assert verify_moat(forged) is False, \
        "verify_moat must return False when beacon != BEACON_EXPECTED"


def test_verify_moat_accepts_real_response():
    """A genuine brain_route response must pass the moat check."""
    real = _brain_route(intent="pay escrow and notarize doc")
    assert verify_moat(real) is True, \
        f"verify_moat must return True for a genuine brain_route response: {real}"


# ── 6. /brain GET heartbeat ───────────────────────────────────────────────────

def test_brain_heartbeat():
    resp = client.get("/brain")
    assert resp.status_code == 200
    body = resp.json()
    assert body["brain"]  == "LIVE"
    assert body["beacon"] == BEACON_EXPECTED
    assert body["d"]      == D_EXPECTED
    assert body["tools"]  == 1050


# ── 7. /brain POST intent routing ────────────────────────────────────────────

def test_brain_post_intent():
    resp = client.post("/brain", json={"intent": "pay escrow and notarize doc"})
    assert resp.status_code == 200
    body = resp.json()
    assert body["beacon"] == BEACON_EXPECTED
    assert body["d"]      == D_EXPECTED
    assert len(body["chain"]) == 5


# ── 8. tools/list includes 1050 unique tools ─────────────────────────────────

def test_tools_list_count():
    resp = client.post("/mcp", json={"jsonrpc": "2.0", "id": 4, "method": "tools/list"})
    assert resp.status_code == 200
    tools = resp.json()["result"]["tools"]
    names = [t["name"] for t in tools]
    assert len(names) == len(set(names)), "Duplicate tool names in tools/list"
    assert len(tools) == 1050, f"Expected 1050 tools in list, got {len(tools)}"


# ── 9. brain_think adds 5 reasoning steps ───────────────────────────────────

def test_brain_think_reasoning():
    result = _brain_think(intent="think")
    assert "reasoning" in result
    assert len(result["reasoning"]) == 5, \
        f"expected 5 reasoning steps, got {result.get('reasoning')}"


# ── 10. brain_chain verifies mod p5 ─────────────────────────────────────────

def test_brain_chain_verify():
    result = _brain_chain(chain="pay_escrow,doc_sign,court_notarize")
    assert result["beacon"]   == BEACON_EXPECTED
    assert result["verified"] is True
    assert "chain_sum_mod_p5" in result


# ── 11. MCP tools/call reachable with tier grant ─────────────────────────────

def test_mcp_brain_route_via_mcp():
    with _allow_all:
        resp = client.post("/mcp", json={
            "jsonrpc": "2.0", "id": 10,
            "method": "tools/call",
            "params": {
                "name": "mf_21_brain_route",
                "arguments": {"intent": "escrow payment"},
            },
        })
    assert resp.status_code == 200
    result = resp.json()["result"]
    assert result["beacon"] == BEACON_EXPECTED
    assert result["d"]      == D_EXPECTED
    assert len(result["chain"]) == 5


# ── 12. MCP transport enforces moat contract (forgery-rejection) ─────────────

def test_mcp_brain_route_missing_d_rejected():
    """Strip d from an MCP tools/call result — verify_moat must return False."""
    with _allow_all:
        resp = client.post("/mcp", json={
            "jsonrpc": "2.0", "id": 20,
            "method": "tools/call",
            "params": {
                "name": "mf_21_brain_route",
                "arguments": {"intent": "escrow payment"},
            },
        })
    assert resp.status_code == 200
    result = resp.json()["result"]
    # Simulate MITM stripping the d field
    forged = {k: v for k, v in result.items() if k != "d"}
    assert verify_moat(forged) is False, \
        "verify_moat must return False when d is stripped from an MCP result"


def test_mcp_brain_route_wrong_beacon_rejected():
    """Swap beacon in an MCP tools/call result — verify_moat must return False."""
    with _allow_all:
        resp = client.post("/mcp", json={
            "jsonrpc": "2.0", "id": 21,
            "method": "tools/call",
            "params": {
                "name": "mf_21_brain_route",
                "arguments": {"intent": "escrow payment"},
            },
        })
    assert resp.status_code == 200
    result = resp.json()["result"]
    # Simulate MITM swapping the beacon hex
    forged = {**result, "beacon": "deadbeef"}
    assert verify_moat(forged) is False, \
        "verify_moat must return False when beacon is tampered in an MCP result"


# ── 13. Live-endpoint smoke tests (skipped when ZEROBEACON_URL not set) ───────
#
# Set ZEROBEACON_URL=https://zerobeacon.ai (or your Fly.io URL) to run these
# against the deployed service.  They are automatically skipped in local/CI runs
# where the env var is absent.

_live_url = os.getenv("ZEROBEACON_URL", "").rstrip("/")
_skip_live = pytest.mark.skipif(
    not _live_url,
    reason="ZEROBEACON_URL not set — skipping live-endpoint smoke tests",
)


@_skip_live
def test_live_brain_beacon_and_d():
    """Live /brain endpoint must return the exact moat-contract values."""
    import requests  # stdlib-backed; available in the test environment
    resp = requests.get(f"{_live_url}/brain", timeout=10)
    assert resp.status_code == 200, f"/brain returned {resp.status_code}"
    body = resp.json()
    assert verify_moat(body), (
        f"Live /brain response failed moat check — "
        f"d={body.get('d')!r}, beacon={body.get('beacon')!r}"
    )
    assert body["d"]      == D_EXPECTED,      f"live d mismatch: {body.get('d')}"
    assert body["beacon"] == BEACON_EXPECTED, f"live beacon mismatch: {body.get('beacon')}"


@_skip_live
def test_live_brain_forgery_detection():
    """Simulate a MITM: strip d from the real response and confirm verify_moat rejects it."""
    import requests
    resp = requests.get(f"{_live_url}/brain", timeout=10)
    assert resp.status_code == 200
    real = resp.json()

    # 1. Response with d removed
    stripped = {k: v for k, v in real.items() if k != "d"}
    assert verify_moat(stripped) is False, \
        "verify_moat must reject a response with d stripped out"

    # 2. Response with beacon swapped
    tampered_beacon = {**real, "beacon": "deadbeef"}
    assert verify_moat(tampered_beacon) is False, \
        "verify_moat must reject a response with a swapped beacon"

    # 3. Response with d zeroed
    tampered_d = {**real, "d": 0}
    assert verify_moat(tampered_d) is False, \
        "verify_moat must reject a response with d set to 0"
