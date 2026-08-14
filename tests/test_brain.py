"""Tests for Router 21 — c9_brain."""
import pytest
from unittest.mock import patch
from fastapi.testclient import TestClient
from zerobeacon_mf_1000_main import app
from routers.zerobeacon_mf_21_050_c9_brain import (
    brain_route as _brain_route,
    brain_think as _brain_think,
    brain_chain as _brain_chain,
)

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


# ── 5. Forged response (no d) is rejected ────────────────────────────────────

def test_forged_response_missing_d():
    forged = {"beacon": BEACON_EXPECTED, "tool": "brain_route", "ok": True}
    assert "d" not in forged, "forged payload should not contain d"
    assert forged.get("d") != D_EXPECTED, \
        "Forged response must not satisfy the d==D_EXPECTED moat check"


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
