---
name: brothers-desert-proof Step A status
description: Which sorries remain in SiegelZeroFreeElementary.lean and why
---

**Repo:** DavidFox998/brothers-desert-proof  
**File:** Siegel/SiegelZeroFreeElementary.lean  
**Last commit:** eb364b3

**Proved (no sorry):**
- `lfunction_eq_eta_factor`: ZMod.LFunction altChar s = (1 − 2^{1−s}) · ζ(s) for Re(s) > 1 — the full Step A algebraic identity. Wired into `eta_identity` via `hA`.
- All Step B infrastructure (analytic continuation, identity theorem, preconnectedness).

**Remaining sorry (1 total):**
- `hasSum_alternating_Dirichlet` (Step D, Abelian theorem): requires Dirichlet-series partial summation (`tendstoLocallyUniformlyOn_of_dirichlet`) which is not in Mathlib v4.15.0. Genuine Mathlib gap — no workaround available without upstream contribution.

**Why Step A worked:** The key helpers were `Complex.summable_one_div_nat_cpow` (used in the `hζ_sum` summability shortcut), `tsum_even_add_odd` (forward direction), `mul_cpow_ofReal_nonneg` for factoring 2^s, and `zeta_eq_tsum_one_div_nat_add_one_cpow` to identify the ζ tsum.
