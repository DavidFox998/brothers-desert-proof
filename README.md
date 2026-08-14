# ZeroBeacon.ai — 1050 MCP Tools

**1050 beacon-anchored MCP tools** across 4 groups, with a FREE tier that needs no API key.

## Tool groups

| Group | Tools | Purpose |
|---|---|---|
| Market Router | 1–300 | Market data, routing, escrow |
| Math Engine | 301–700 | Arithmetic, Arakelov, Riemann |
| Amplum Everyday | 701–1000 | Productivity, general-purpose |
| Brain Router | 1001–1050 | Routes all 1000 tools + 49 meta-tools (chain, think, swarm, consensus) |

## Tiers

| Tier | Tools | Price | How to get it |
|---|---|---|---|
| **FREE** | 1–100, no API key required | Free | Install and use immediately |
| **PRO** | 1–400 | $10 / month | Stripe checkout at [zerobeacon.ai](https://zerobeacon.ai) |
| **PRO+** | 1–800 | $100 / month | Stripe checkout at [zerobeacon.ai](https://zerobeacon.ai) |
| **ENTERPRISE** | All 1000 tools | $1,000 / research | [zerobeacon.ai/pricing](https://zerobeacon.ai/pricing) |

Pass your key as the `X-API-Key` header after checkout.

## Install (Claude Desktop / any MCP host)

```json
{
  "mcpServers": {
    "zerobeacon": {
      "type": "http",
      "url": "https://zerobeacon.ai/mcp",
      "headers": { "X-API-Key": "YOUR_KEY_HERE" }
    }
  }
}
```

For the FREE tier, omit the `X-API-Key` header entirely.

## Beacon fingerprint

```
d=2303582338 · beacon=1d2c7a5b · ω²=48/13>0 verified
```

This fingerprint is anchored in every tool response and verifiable on-chain.

---

## Math proof (internal — brothers-desert-proof)

This repo also contains a Lean 4 formalization of the Clay Millennium separation claim
built on arithmetic self-symmetry of the 35 MORNINGSTAR brothers.

**Core idea:** The 35 brothers — 16-bit numbers with exactly 6 set bits, all ≡ 153 mod 211,
all ≥ 193 — exhibit discrete self-symmetry incompatible with a polynomial-time circuit
collapsing the GapMCSP gap (L = 2240 vs threshold = 33), giving an independent witness
for the Clay separation claim.

```
SelfSymmetry/
  Core.lean           — brothers imported, basic self-symmetry facts
  Desert.lean         — desert structure, exceptional set S4, p5 boundary
  JitterSymmetry.lean — π/10 jitter Nodup, EMI reduction, Hilbert gate
  TwinWormhole.lean   — twin-prime product injectivity (W1,W2,W3)
  ClayWitness.lean    — Clay separation certificate (GapMCSP gap)
Protocol/
  Chain.lean          — certified chain tying all five repos
```

Dependencies: [mathlib4 v4.15.0](https://github.com/leanprover-community/mathlib4),
[eutheos-property](https://github.com/DavidFox998/eutheos-property),
[p5-boundary](https://github.com/DavidFox998/p5-boundary).

**0 sorry**, ever. `native_decide` for finite arithmetic certificates.
