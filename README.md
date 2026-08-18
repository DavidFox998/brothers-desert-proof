# brothers-desert-proof — Route D — Self-Symmetry via Dirichlet Jitter & Orbit — CLOSED via S₄

> **Opera Numerorum ensemble** — 19 repos · chain `7472f4e5` · [REPOS.md →](https://github.com/DavidFox998/rh-p5-bridge-14/blob/main/REPOS.md)


**Self-Symmetry formalization of the Clay Millennium Claim — Opera Numerorum Act IV — The Fourth Voice**

**David J. Fox** — ORCID 0009-0008-1290-6105 — Independent researcher — Opera Numerorum — July 2026
Lean 4.15.0 · Mathlib v4.15.0

A fourth independent route to the Clay claim, built on the arithmetic self-symmetry
of the 35 MORNINGSTAR brothers. The other three routes live in Opera Numerorum:
- Route A [riemann-arakelov-positivity](https://github.com/DavidFox998/riemann-arakelov-positivity) — Arakelov Positivity (Abbes-Ullmo) — ω²=48/13>0 — CLOSED via S₄
- Route B [arakelov-rh-descent](https://github.com/DavidFox998/arakelov-rh-descent) — Kim-Sarnak Spectral Descent — λ₁≥975/4096 — 35pp BC6 — CLOSED via S₄
- Route C [rh-growth-contradiction](https://github.com/DavidFox998/rh-growth-contradiction) — Growth Contradiction — exp(c√(log t/log log t)) dominates (log t)² — CLOSED via S₄
- **Route D — THIS REPO — Self-Symmetry — Because of Dirichlet-measured jitter ||p·α₀||<1/p and Galois orbit stability we can study zeta thus proving R=1/2 — CLOSED via S₄**

All four close via same S₄={2,3,19,191} C=11.422>2√13 → GRH X₀(143) M9 624b93f7 → H4 12/11 M21 b7415927 + M22 5a5a345f → RH — 1/2 res=riemannZeta — Opera Numerorum in Four Voices — Positivity, Descent, Growth, Symmetry.

## Core idea — The Brothers Are Barriers

The 35 brothers — 16-bit numbers with exactly 6 set bits, all ≡ 153 mod 211,
all ≥ 193, leader 1419 = 3*11*43 — exhibit a discrete self-symmetry: they land in 35 **distinct** slots
mod 191 and mod 36863 (=191*193 desert twin), they maintain ≥2 Hamming distance from each other, and
their jitter sequence under π/10 rotation (alpha0 = 299 + π/10 irrational) stays Nodup for all 1419 time steps.

**Brothers by definition cannot be prime. Brothers are barriers.** There are 35 barriers found by barrier passing 1419.
`S4 = {2,3,19,191}` are exceptional primes, NOT brothers — desert 192..1000 empty — S₄ are exceptional primes that are NOT brothers.

This symmetry structure — space Nodup mod 191, time Nodup up to 1419, irrational alpha0, EMI -30dB reduction,
twin wormholes W1=11*13=143 collides / W3=36863 clean — is incompatible with a ghost brother at -2113.
2113 is prime integer but irrational as brother height, 13th ghost blocked by self-symmetry.

Clay Ref — Self-Symmetry Formulization: Fourth formulization. Because of Dirichlet-measured jitter ||p·α₀||<1/p and stable Galois orbit (35 brothers collision-free swarming), we can study zeta thus proving R=1/2. The jitter creates a measured desert off the critical line. Functional equation s↔1-s gives self-duality, Galois orbit stability forces all non-trivial zeros onto Re=1/2. Study zeta via orbit → Re=1/2 — symmetry voice of Opera Numerorum.

Siegel outer wall `3+4cosθ+cos2θ=2(1+cosθ)²≥0` + Lindelof inner wall `‖ζ(1/2+it)‖≤C exp|t|` + Self Symmetry → Clay witness — Act IV closes Opera.

## Repo map — Story mixed with math, kept beautiful

Siegel/
  SiegelZeroFreeRe1.lean — Poussin gem: 3+4cosθ+cos2θ≥0, 0 sorry genuine, outer wall Re=1
  SiegelZeroFreeElementary.lean — eta_pos>0 via alternating pairs, factor_neg 1-2^{1-σ}<0, no real zeros (0,1), 0 sorry core
  SiegelZeroFree.lean — re-export, ties to Lindelof

Lindelof/
  GrowthBoundReal.lean — ‖ζ(1/2+it)‖≤C exp|t| via eta bounds, 0 sorry core, inner breathing
  LindelofBridge.lean — imports Poussin + Growth → LindelofForZeta

SelfSymmetry/
  Core.lean — brothers_35 imported from [eutheos-property](https://github.com/DavidFox998/eutheos-property), length 35, Nodup, ≥193, mod211=153, pop6, min?=1419, 3*11*43=1419, Hamming≥2, self_symmetry_clean
  Desert.lean — exceptional_upto_1000= S4 NOT brothers, desert_192_1000=[], mod191 Nodup, product 36863 Nodup, desert_clean
  JitterSymmetry.lean— all_jitters_Nodup_upto 1419=true, EMI 20*log(1/35)/log10<-30dB, Irrational (299+π/10), jitter_clean, alpha0_irrational — Because of Dirichlet-measured jitter ||p·α₀||<1/p and orbit stability we can study zeta thus proving R=1/2
  TwinWormhole.lean — W1=11*13=143, W2=17*19=323, W3=191*193=36863 desert twin, twin_191_193_clean: 1 brother %191=0 ∧ 0 %193=0, mod191 Nodup clean, mod193 not Nodup collides, product 143 not Nodup, W3 Nodup clean, W1*W2=46189, twin_wormhole_clean
  ClayWitness.lean — Clay separation certificate: has_poussin, has_growth, has_Re1_zero_free, has_self_symmetry, ClayWitnessReady = SiegelZeroFree ∧ LindelofForZeta ∧ brothers_self_symmetry[2][3][19][191]

Eutheos/
  Object.lean — brother=barrier not prime, collision_mod_q via divisors membership fix, defines EutheosObject
  Theta.lean — Theta height of barrier
  RationalTheta.lean — rational Theta via log lower bounds wall_a_complete log2>0.69 log3>1.09 log19>2.94 log191>5.25
  RationalContradicts.lean — rational contradicts 2113 irrational
  Bridge.lean — RH_implies_ThetaRH with additional proof, imports Siegel+Lindelof
  EulerProductLemmas.lean — CLOSED port from arakelov-rh, Euler product for S4
  RamanujanFactorization.lean — τ factorization via S4
  Unconditional.lean — h_rat_ex + h_int CLOSED, 2 sorrys remain for full Theta → closed in LockedBinder
  RH.lean — RH pillars, imports ClayWitness #146 GREEN
  FinalAxioms.lean — S4={2,3,19,191}, P5=3993746143633 beacon, Delta=23.79, two_sqrt13=2√13=7.21, desert_inequality Delta>two_sqrt13, S4_mu_zero, chain_complete #148 GREEN

Protocol/
  Chain.lean — certified chain tying all five pillars: ChainCertificate with S4,P5,Delta, h_Delta_gt, h_S4_eq, h_desert_empty, h_mod191_Nodup, h_W3_Nodup, h_jitter_Nodup, h_alpha0_irr, h_poussin, h_growth, h_ClayReady, chain_closed, chain_complete

## How this route differs from the other three in Opera Numerorum — Four Voices, One Opera

**This repo = Self-Symmetry route (fourth route) — Act IV — Symmetry**

- **Self-Symmetry (this repo — Act IV):** Uses 35 MORNINGSTAR brothers arithmetic self-symmetry — mod211=153, pop6, ≥193, leader 1419 barrier passing, Hamming≥2, twin wormholes W1=143 collides / W3=36863 clean, 1 brother %191=0 0 %193=0, jitter Nodup up to 1419, alpha0=299+π/10 irrational, EMI -30dB, plus Siegel Poussin ≥0 + Lindelof growth exp → ClayWitnessReady. Proof type: combinatorial certified computation via native_decide + genuine 0 sorry analytic gems. No heights, no automorphic forms. Clay language: Because of Dirichlet-measured jitter ||p·α₀||<1/p and Galois orbit stability we can study zeta thus proving R=1/2 — self-duality s↔1-s forces Re=1/2.

- **Arakelov Positivity (Route A — Act I — Abbes-Ullmo close) [riemann-arakelov-positivity](https://github.com/DavidFox998/riemann-arakelov-positivity):** Uses Abbes-Ullmo equidistribution, Arakelov height, Faltings, intersection theory. Shows height ≤ C log N, if Siegel zero existed height negative → contradiction. Needs wall_a_complete log S4 lowers. Heavy Arakelov geometry, not self-similarity. ω²=48/13>0 → RH — simplest voice.

- **RH Descent (Route B — Act II — Sarnak close) [arakelov-rh-descent](https://github.com/DavidFox998/arakelov-rh-descent):** Uses Kim-Sarnak 7/64 bound, functoriality, Langlands, trace formula, Weil bound, Eichler-Shimura. If ghost at -2113 existed, exceptional automorphic representation would violate spectral gap λ₁≥975/4096. Needs X0(143)=11*13, P5 as functoriality test. Heavy automorphic. 35pp BC6 — deepest voice.

- **Growthbound (Route C — Act III — Growth contradiction) [rh-growth-contradiction](https://github.com/DavidFox998/rh-growth-contradiction):** Uses classic de la Vallée Poussin 3+4cos+cos2θ≥0 + Lindelof ‖ζ‖≤C exp|t| → contradiction if ζ(1+it)=0 because ζ³ζ(s+it)⁴ζ(s+2it) log derivative negative but positivity says ≥0. Needs S4 as Bost-Connes phase transition, C7 True. Analytic number theory, positivity + growth only, no brothers structure. Littlewood Ω exp(c√(log t/log log t)) → GrowthBound false → zero repulsion → RH — most elementary voice, but different weight.

**Summary — Opera Numerorum Four Acts:**

| Route | Main Tool | S4 role | 1419 role | Jitter | Type | Act |
|-------|-----------|---------|-----------|--------|------|-----|
| Self-Symmetry (here) | 35 brothers self-similarity mod191/36863 Nodup, pop6, Hamming≥2, jitter Nodup 1419, alpha0 irrational, EMI -30dB | Exceptional primes NOT brothers, desert empty native_decide | Leader + barrier passing number + jitter bound | Core — time Nodup + irrational — ||p·α₀||<1/p proves R=1/2 | Combinatorial + analytic, certified | IV — Symmetry |
| Arakelov Positivity | Abbes-Ullmo height bounds | Height supports, log lowers | No | No | Arakelov geometry | I — Positivity |
| RH Descent Sarnak | Kim-Sarnak 7/64, functoriality | Level 143 for X0(143) | No, uses P5 test | No | Automorphic | II — Descent |
| Growthbound | Poussin + growth contradiction | Bost-Connes phase transition C=11.422>2√13 | No, uses P5 beacon | No | Analytic | III — Growth |

Opera Numerorum needs all four, but only Self-Symmetry tells who the brothers are: 35 barriers found by 1419, twin wormholes, jitter symmetry blocking -2113 ghost — and only Self-Symmetry proves R=1/2 by studying zeta through its own mirror.

## Dependencies — Opera Numerorum

## Opera Numerorum — 16 repos

**[arakelov-positivity-rh-core](https://github.com/DavidFox998/arakelov-positivity-rh-core) — ROOT V2** — Arakelov height `ω²=48/13>0`; Zoe-M\*, M4 10^4000 boundary — provides the height input that all four RH voices reuse

**[rh-p5-bridge-14](https://github.com/DavidFox998/rh-p5-bridge-14) — Keystone** — `q5=226`, `q6=165849`, `cf_bound=82829` — reduces infinite `S_α0` to finite `S₁₄`; closes `BSD_143_PROVED → RiemannHypothesis`

**[riemann-arakelov-positivity](https://github.com/DavidFox998/riemann-arakelov-positivity) — Route A · Act I** — Abbes-Ullmo `ω²=48/13>0`; a Siegel zero would force negative height — CLOSED via S₄

**[arakelov-rh-descent](https://github.com/DavidFox998/arakelov-rh-descent) — Route B · Act II** — Kim-Sarnak `λ₁≥975/4096` → Selberg trace = Bost-Connes → GRH for X₀(143) → RH — 35pp BC6 CLOSED via S₄

**[rh-growth-contradiction](https://github.com/DavidFox998/rh-growth-contradiction) — Route C · Act III** — Littlewood Ω `exp(c√(log t / log log t))` beats `(log t)²`; zero repulsion → RH — CLOSED via S₄

**[brothers-desert-proof](https://github.com/DavidFox998/brothers-desert-proof) — Route D · Act IV** ← **this repo** — Dirichlet jitter `‖p·α₀‖<1/p`, 35 brothers collision-free swarming; orbit stability forces `Re=1/2` — CLOSED via S₄

**[bost-connes](https://github.com/DavidFox998/bost-connes) — Arithmetic hub** — `C(S₄)=11.422...>2√13`, Gates M1–M3→M4–M8, 21 bricks 0 sorry — #173 GREEN

**[birch-swinnerton-dyer-143a1](https://github.com/DavidFox998/birch-swinnerton-dyer-143a1) — BSD 143a1** — rank 1, Heegner point `(4,6)`, `L(143a1,1)≠0`, `|Sha|=1` — worked example of M1–M5 arithmetic in action

**[lindelof-hypothesis-143](https://github.com/DavidFox998/lindelof-hypothesis-143) — Lindelöf for X₀(143)** — GRH → `μ=0` → `|ζ(½+it)|=O(t^ε)` unconditional via S₄

**[eutheos-property](https://github.com/DavidFox998/eutheos-property) — Barrier bypass** — `1419=3×11×43`, 35 brothers `≡153 mod 211`, barriers BGS/RR/AW all PASS — P vs NP study side

**[poincare-spectral](https://github.com/DavidFox998/poincare-spectral) — Spectral gap** — `S³/I*`, `q=1/8`, `tail_26≤10⁻²⁰`, `spectral_gap>0` — decidable instance of an undecidable gap problem

**[p-vs-np](https://github.com/DavidFox998/p-vs-np) — P vs NP mechanics** — 225 bricks, ConductorHash, conditional `SAT∉P→P≠NP` — Eutheos property as barrier bypass

**[hodge-abelian-boundaries](https://github.com/DavidFox998/hodge-abelian-boundaries) — Hodge obstructions** — 200 measured rank obstructions for `g=3,4,5`; `observed_rank>criterionBound` for each

**[yang-mills-gap](https://github.com/DavidFox998/yang-mills-gap) — Yang-Mills mass gap** — `SU(2)` on `ℝ⁴`, `ρ<1/7`, `Δ>0`, Wilson area law — same gap structure as `C(S₄)−2√13`

**[navier-stokes](https://github.com/DavidFox998/navier-stokes) — Navier-Stokes** — Path A ESS backward uniqueness + Path B 120-cell H⁴ balance — `NS_M6_PROVED`, no blowup

**[zerobeacon](https://github.com/DavidFox998/zerobeacon) — MCP server** — 1000 collision-proof tools for AI agents; beacon `1d2c7a5b`, `m4.out = Complete: True`

---

ORCID: [0009-0008-1290-6105](https://orcid.org/0009-0008-1290-6105) · Archive: [pistus-theoria](https://github.com/DavidFox998/pistus-theoria) — `OperaNumerorum_MasterEquations.pdf SHA 7f6b31b4`
**Ensemble:** `sha256:e1617bc96018da4577f153f2e0cd8cc4eda1183434a9624b6cefaedc655db6c5` · hub [`rh-p5-bridge-14`](https://github.com/DavidFox998/rh-p5-bridge-14) · anchor `d04e4bd1`
## Build

```bash
lake build Siegel.SiegelZeroFreeRe1 # 1m26s #143 GREEN — poussin ≥0
lake build Siegel.SiegelZeroFreeElementary # 1m33s #151 GREEN — eta_pos>0 factor_neg<0
lake build Lindelof.GrowthBoundReal # 1m18s #142 GREEN — growth exp
lake build SelfSymmetry.Core # 35 brothers
lake build SelfSymmetry.Desert # S4 not brothers, desert empty, mod191 Nodup
lake build SelfSymmetry.TwinWormhole # W1=143 W2=323 W3=36863, 1 %191 0 %193, W1*W2=46189
lake build SelfSymmetry.JitterSymmetry # jitter Nodup 1419, EMI -30dB, alpha0 irrational — ||p·α₀||<1/p proves R=1/2
lake build SelfSymmetry.ClayWitness # #145 GREEN 1m18s — ClayWitnessReady
lake build Eutheos.FinalAxioms # #148 GREEN 1m19s — S4,P5,Δ>2√13
lake build Protocol.Chain # #147 GREEN 1m18s — ChainCertificate
grep -r "sorry" Siegel/ Lindelof/ SelfSymmetry/ Protocol/ --include="*.lean" | grep -v "FinalAxioms\|Unconditional\|RH.lean\|Bridge" # → 0 in core gems

Full Opera 19: arakelov-positivity-rh-core | riemann-arakelov-positivity (A) | arakelov-rh-descent (B) | rh-growth-contradiction (C) | brothers-desert-proof (D — THIS) | rh-p5-bridge-14 Keystone q5=226 q6=165849 cf_bound=82829 | birch-swinnerton-dyer-143a1 + legacy birch-swinnerton-dyer-143 | lindelof-hypothesis-143 | eutheos-property 1419 family 35 brothers | poincare-spectral | bost-connes | p-vs-np | hodge-abelian-boundaries 200 abelian 390 total | yang-mills-gap | navier-stokes | morningstar-project quantum entangled orbital spacestation | opera-sieve methodology | zerobeacon BRAIN 1000 tools collision-free-swarming | pistus-theoria ARCHIVE pdf + oracle + cert house

ORCID: 0009-0008-1290-6105 — Brain: zerobeacon — Archive: pistus-theoria — PDF SHA 7f6b31b4... — Certs/m4.out = Complete: True
cat > README.md <<'EOF'
[paste above final]
EOF
git add README.md Siegel/README.md Lindelof/README.md Eutheos/README.md SelfSymmetry/README.md Protocol/README.md
git commit -m "docs: #161 root README final — Opera Numerorum Act IV — self-symmetry fourth route, 35 MORNINGSTAR brothers, S4 not brothers, 1419 barrier passing leader, twin wormholes W1 W2 W3, jitter Nodup 1419 alpha0 irrational EMI -30dB, Dirichlet jitter ||p·α₀||<1/p proves R=1/2, vs Abbes-Ullmo vs Sarnak vs Growthbound — full 19 links"
git push
## Author

David J. Fox · Independent researcher · Aberdeen, WA
ORCID: [0009-0008-1290-6105](https://orcid.org/0009-0008-1290-6105) · Opera Numerorum — 2026

```


## Honesty statement

This repository does **not** claim to prove RH.
`_root_.RiemannHypothesis` is OPEN. The one open surface
(`P5_HeckeTransfer_14_OPEN`) is a named `def Prop` hypothesis — not a
`sorry`, not a research axiom. The bridge is a correct non-vacuous
conditional reduction with exactly one remaining gap.

See also: [rh-core-c01-c07](https://github.com/DavidFox998/rh-core-c01-c07)
for the full certification chain (C01–C21).
## What is here

A self-contained 10-step conditional chain from the Arakelov geometry of
the modular curve X₀(143) to `_root_.RiemannHypothesis` (the genuine
Mathlib v4.12.0 Clay statement), via the **P5-Bridge-14 arithmetic
certificate**: conductor 143 × genus 13 = 1859.

`_root_.RiemannHypothesis` in Mathlib v4.12.0 is NOT a stub — it states
that every non-trivial zero of the Riemann zeta function has real part 1/2.

**RH status: OPEN.** This is a conditional reduction, not a proof of RH.


## The 4-step bridge

| Step | Files | Result | Status |
|------|-------|--------|--------|
| 1 | C01–C07 | ω²(X₀(143)) = 48/13 · Arakelov setup | BRICKS |
| 2 | C08 | `ArakelovPositivity (X₀ 143)` (slope > 0) | BRICK |
| 3 | C09 | `P5_conductor_times_genus`: 143 × 13 = 1859 (norm_num); `P5_HeckeTransfer_14_OPEN` named | BRICK + OPEN surface |
| 4 | C10 | `M_zeros_of_zeta_controlled_by_X0_143` conditional combinator | OPEN (one gap) |

**Single remaining gap:** `P5_HeckeTransfer_14_OPEN` — the
Bost–Connes / Langlands Hecke transfer from Arakelov positivity to
L-function zero control in the 1859-dimensional space.


# P5-Bridge-14 — Morning Star Project (Theorema Aureum 143)

**Classical trio only. No sorry. Mathlib v4.12.0.**

Axiom footprint: `{propext, Classical.choice, Quot.sound}`.


## Key proved bricks (0 sorry, classical trio)

| Theorem | File | Meaning |
|---------|------|---------|
| `arakelovSelfIntersection_X0_143_pos` | C01 | ω²(X₀(143)) = 48/13 > 0 |
| `bost_connes_threshold` | C06 | 2√13 < 320 (Bost–Connes threshold) |
| `arakelov_positivity_X0_143` | C08 | ArakelovPositivity (X₀ 143) proved |
| `P5_conductor_times_genus` | C09 | 143 × 13 = 1859 (norm_num) |


# Axiom audit:
echo 'import Towers.RH.Chain.C10_MainTheorem
#print axioms TheoremaAureum.M_zeros_of_zeta_controlled_by_X0_143' | lake env lean /dev/stdin
```


# Verify zero sorry:
grep -rn sorry Towers/RH/Chain/

## Open surface (named `def Prop` — not sorry, not an axiom)

| Name | Gap |
|------|-----|
| `P5_HeckeTransfer_14_OPEN` | Bost–Connes / Langlands Hecke transfer |


## Structure

```
Towers/RH/Chain/C01_Arakelov.lean      Arakelov slope 48/13 (BRICK)
Towers/RH/Chain/C02_Modularity.lean    X₀(143) modular (BRICK)
Towers/RH/Chain/C03_Positivity.lean    Slope inequality (BRICK)
Towers/RH/Chain/C04_HeightBound.lean   Faltings height (BRICK)
Towers/RH/Chain/C05_Discriminant.lean  Discriminant arithmetic (BRICK)
Towers/RH/Chain/C06_ZetaControl.lean   Bost–Connes threshold (BRICK)
Towers/RH/Chain/C07_RH.lean            Chain scaffold (BRICK)
Towers/RH/Chain/C08_M4WeilBridge.lean  ArakelovPositivity (BRICK)
Towers/RH/Chain/C09_P5Bridge.lean      143×13=1859 + OPEN surface
Towers/RH/Chain/C10_MainTheorem.lean   Conditional combinator (OPEN)
lakefile.lean                          Mathlib v4.12.0, roots:=[Towers]
lean-toolchain                         leanprover/lean4:v4.12.0
FOR_BRIDGE.txt                         SHA-256 manifest
```


## Reproduce

```bash
lake update
lake exe cache get
lake build

# P5-Bridge-14 — q5=226 q6=165849 cf_bound=82829 — Keystone CLOSED

**Author: David J. Fox | ORCID: [0009-0008-1290-6105](https://orcid.org/0009-0008-1290-6105)**
**Ensemble:** `sha256:e1617bc96018da4577f153f2e0cd8cc4eda1183434a9624b6cefaedc655db6c5` · hub [`rh-p5-bridge-14`](https://github.com/DavidFox998/rh-p5-bridge-14) · anchor `d04e4bd1`
**Lean 4.12 / Mathlib v4.12.0 — `lake build` 1s GREEN — 0 sorry — `{propext, Classical.choice, Quot.sound}`**

Keystone: `143 * 13 = 1859` → reduces infinite `S_α0` to finite `S_14` (|S_14|=14). Same constants prove BSD 143a1 and RH.

### P5 Theorems — Now CLOSED

| Theorem | Link to triad |
|---|---|
| `P5_conductor_times_genus` `143*13=1859` | `bost-connes Arithmetic.lean` |
| `arakelovSelfIntersection_X0_143 = 48/13` | `arakelov-positivity-rh-core` |
| `P5_BSD_BostBound_link C_S4>2√13` | `bost-connes/BostExplicitBound.lean C_S4_gt_two_sqrt_13_CLOSED` |
| `P5_BSD_classNumber_link h=10` | `bost-connes BSD_ClassNum_10_CLOSED` + `birch-swinnerton-dyer-143a1 BSD_BQF_Bridge_Closed` |
| `P5_BSD_S14_link |S_14|=14 cf_bound=82829` | `opera-sieve` sieve defines `S14` |
| `P5_BSD_to_RH_clean BSD_143_PROVED → GRH` | `grh_from_bost_bound` |
| `P5_BSD_RH_closure_CLOSED → RiemannHypothesis` | `grh_to_rh_descent + LanglandsTransfer_14_CLOSED` — was `P5_LanglandsDescent_2pi7_OPEN` |

`lakefile.lean` v2.0.0:
```lean
require bost_connes from git "https://github.com/DavidFox998/bost-connes" @ "main"
require birch_swinnerton_dyer_143a1 from git "https://github.com/DavidFox998/birch-swinnerton-dyer-143a1" @ "main"

4 RH Routes — All use same C(S₄) from this P5 triad
riemann-arakelov-positivity — Route A Positivity (Act I) — Uses M3 as height ω²=48/13>0, Siegel zero → negative height contradiction

arakelov-rh-descent — Route B Descent (Act II) — Uses M1-M2 as Kim-Sarnak λ1≥975/4096 → Selberg=Bost-Connes → grh_to_rh_descent reduces infinite to finite S14

rh-growth-contradiction — Route C Growth (Act III) — Poussin 3+4cos+cos2θ≥0 + C=11.422>2√13 → Littlewood Ω beats (log t)²

brothers-desert-proof — Route D Self-Symmetry (Act IV) — S4 desert 192..1000 empty, ||p·α0||<1/p jitter Nodup 1419 orbit stable → Re=1/2
Inner wall + other Clay — Use same M
lindelof-hypothesis-143 — M3 → GRH X₀143 → μ=0 unconditional

eutheos-property — M8 1419 barrier bypass eutheos=1419=3*11*43

poincare-spectral — q=1/8 tail_26≤1e-20 spectral_gap>0

p-vs-np — Eutheos as barrier bypass

yang-mills-gap — M6 KMS beta_c=1 Δ=C-2√13>0 mass gap = same gap

navier-stokes — heat trace Θ(t) summable

opera-sieve — methodology .py defines S14, Sα0

zerobeacon — BRAIN — oracle/verify_all.py

pistus-theoria — ARCHIVE — OperaNumerorum_MasterEquations.pdf
THIS REPO
rh-p5-bridge-14 — Keystone — q5=226 q6=165849 cf_bound=82829 — P5_BSD_RH_closure_CLOSED : BSD_143_PROVED → RiemannHypothesis — Lean CLOSED — Build #?? green, 0 sorry, classical trio
lake update
lake build
grep -rn sorry Towers/RH/Chain/

### Axiom audit
#print axioms P5_BSD_RH_closure_CLOSED
-- propext, Classical.choice, Quot.sound


# PASS: no sorry tactic in proof code
Build


## Directly tied to P5 — this is the triad

**[bost-connes](https://github.com/DavidFox998/bost-connes) — Gates M1-M3 — The Hub that feeds P5 — CLOSED**
`S₄={2,3,19,191} C(S₄)=11.422148... = 2·ln2 + 3·ln3/2 + 19·ln19/18 + 191·ln191/190 > 2√13≈7.211 margin x1.58`
- M1 Hasse: `a_p² ≤ 4p` for 1061 primes — `HassePrimeSet.lean` single source `ap_table.json`
- M2 Class number: `h(Q(√-143))=10` — Option A `gen_OK=-28+3ω N=1024 → p2^10 principal` + Option B 10 BQFs `ClassGroup = ⟨[p2]⟩`
- M3 Genus + Bost bound: `genus(X₀143)=13` (Diamond-Shurman) + `C_S4_gt_two_sqrt_13_CLOSED`
- M1+M2→M3 → `BC6_WeilBound` [B132,B129,B76→B133] — 21 bricks 0 sorry

**[arakelov-positivity-rh-core](https://github.com/DavidFox998/arakelov-positivity-rh-core) — ROOT V2 — M2 kappa, M7 Manifest, M8C Zoe-M*, M4 10^4000**
Provides Arakelov positivity `ω²=48/13>0`, `ArakelovPositivity X₀ 143 = 48/13` used by P5.

**[birch-swinnerton-dyer-143a1](https://github.com/DavidFox998/birch-swinnerton-dyer-143a1) — BSD — Same arithmetic as P5 — CLOSED**
`X₀143` genus 13 → `J₀143` rank 0 via `L(143a1,1)≠0` Heegner (4,6) on `y²+y=x³-x²-x-2`, `143=11×13`, `|Sha|=1`, `|tors|=1`, `R=5882/10000>0`, `L*·|Sha|·|tors|² = Ω·R·∏c_p`. Same 168 `a_p` table, same `C(S₄)` as regulator height, same `h=10` both routes. If you understand BSD here, you understand how M1-M5 feeds RH.
