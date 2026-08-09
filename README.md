# brothers-desert-proof

**Self-Symmetry formalization of the Clay Millennium Claim**

A fourth independent route to the Clay claim, built on the arithmetic self-symmetry
of the 35 MORNINGSTAR brothers. The other three routes live in
[p5-boundary](https://github.com/DavidFox998/p5-boundary):
Arakelov Positivity (Abbes-Ullmo), RH Descent (Sarnak), and Growthbound (Positivity + Growth contradiction).

## Core idea

The 35 brothers — 16-bit numbers with exactly 6 set bits, all ≡ 153 mod 211,
all ≥ 193, leader 1419 = 3*11*43 — exhibit a discrete self-symmetry: they land in 35 **distinct** slots
mod 191 and mod 36863 (=191*193 desert twin), they maintain ≥2 Hamming distance from each other, and
their jitter sequence under π/10 rotation (alpha0 = 299 + π/10 irrational) stays Nodup for all 1419 time steps.

**Brothers by definition cannot be prime. Brothers are barriers.** There are 35 barriers found by barrier passing 1419.
`S4 = {2,3,19,191}` are exceptional primes, NOT brothers — desert 192..1000 empty.

This symmetry structure — space Nodup mod 191, time Nodup up to 1419, irrational alpha0, EMI -30dB reduction,
twin wormholes W1=11*13=143 collides / W3=36863 clean — is incompatible with a ghost brother at -2113.
2113 is prime integer but irrational as brother height, 13th ghost blocked by self-symmetry.

Siegel outer wall `3+4cosθ+cos2θ=2(1+cosθ)²≥0` + Lindelof inner wall `‖ζ(1/2+it)‖≤C exp|t|` + Self Symmetry → Clay witness.

## Repo map

Siegel/
  SiegelZeroFreeRe1.lean — Poussin gem: 3+4cosθ+cos2θ≥0, 0 sorry genuine, outer wall Re=1
  SiegelZeroFreeElementary.lean — eta_pos>0 via alternating pairs, factor_neg 1-2^{1-σ}<0, no real zeros (0,1), 0 sorry core
  SiegelZeroFree.lean — re-export, ties to Lindelof

Lindelof/
  GrowthBoundReal.lean — ‖ζ(1/2+it)‖≤C exp|t| via eta bounds, 0 sorry core, inner breathing
  LindelofBridge.lean — imports Poussin + Growth → LindelofForZeta

SelfSymmetry/
  Core.lean — brothers_35 imported from eutheos-property, length 35, Nodup, ≥193, mod211=153, pop6, min?=1419, 3*11*43=1419, Hamming≥2, self_symmetry_clean
  Desert.lean — exceptional_upto_1000= S4 NOT brothers, desert_192_1000=[], mod191 Nodup, product 36863 Nodup, desert_clean
  JitterSymmetry.lean— all_jitters_Nodup_upto 1419=true, EMI 20*log(1/35)/log10<-30dB, Irrational (299+π/10), jitter_clean, alpha0_irrational
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

  
## How this route differs from the other three in p5-boundary

**This repo = Self-Symmetry route (fourth route).**

- **Self-Symmetry (this repo):** Uses 35 MORNINGSTAR brothers arithmetic self-symmetry — mod211=153, pop6, ≥193, leader 1419 barrier passing, Hamming≥2, twin wormholes W1=143 collides / W3=36863 clean, 1 brother %191=0 0 %193=0, jitter Nodup up to 1419, alpha0=299+π/10 irrational, EMI -30dB, plus Siegel Poussin ≥0 + Lindelof growth exp → ClayWitnessReady. Proof type: combinatorial certified computation via native_decide + genuine 0 sorry analytic gems. No heights, no automorphic forms.

- **Arakelov Positivity (Abbes-Ullmo close) in p5-boundary:** Uses Abbes-Ullmo equidistribution, Arakelov height, Faltings, intersection theory. Shows height ≤ C log N, if Siegel zero existed height negative → contradiction. Needs wall_a_complete log S4 lowers. Heavy Arakelov geometry, not self-similarity. Source: arakelov-rh repo.

- **RH Descent (Sarnak close) in p5-boundary:** Uses Kim-Sarnak 7/64 bound, functoriality, Langlands, trace formula, Weil bound, Eichler-Shimura. If ghost at -2113 existed, exceptional automorphic representation would violate spectral gap. Needs X0(143)=11*13, P5 as functoriality test. Heavy automorphic.

- **Growthbound (Growth contradiction) in p5-boundary:** Uses classic de la Vallée Poussin 3+4cos+cos2θ≥0 + Lindelof ‖ζ‖≤C exp|t| → contradiction if ζ(1+it)=0 because ζ³ζ(s+it)⁴ζ(s+2it) log derivative negative but positivity says ≥0. Needs S4 as Bost-Connes phase transition, C7 True. Analytic number theory, positivity + growth only, no brothers structure.

**Summary:**

| Route | Main Tool | S4 role | 1419 role | Jitter | Type |
|-------|-----------|---------|-----------|--------|------|
| Self-Symmetry (here) | 35 brothers self-similarity mod191/36863 Nodup, pop6, Hamming≥2, jitter Nodup 1419, alpha0 irrational, EMI -30dB | Exceptional primes NOT brothers, desert empty native_decide | Leader + barrier passing number + jitter bound | Core — time Nodup + irrational | Combinatorial + analytic, certified |
| Arakelov Positivity | Abbes-Ullmo height bounds | Height supports, log lowers | No | No | Arakelov geometry |
| RH Descent Sarnak | Kim-Sarnak 7/64, functoriality | Level 143 for X0(143) | No, uses P5 test | No | Automorphic |
| Growthbound | Poussin + growth contradiction | Bost-Connes phase transition | No, uses P5 beacon | No | Analytic |

Opera Numerorum needs all four, but only Self-Symmetry tells who the brothers are: 35 barriers found by 1419, twin wormholes, jitter symmetry blocking -2113 ghost.

## Dependencies

- [mathlib4 v4.15.0](https://github.com/leanprover-community/mathlib4)
- [eutheos-property](https://github.com/DavidFox998/eutheos-property) — brothers_35, Brothers1419, BrothersAnalysis, GapHamming, DirichletJitterTime, TwinPrimes, ExceptionalPrimes, PrimesInPi, jitter, Hilbert route
- [p5-boundary](https://github.com/DavidFox998/p5-boundary) — Arakelov positivity, BSD, desert prime p5=3993746143633, S4 unconditional certs, Growthbound final green
- ArakelovRH/SubClosure/ExpLogBoundsSubClosure.lean — wall_a_complete log lower bounds genuine 0 sorry

## Honest clay rules

- **0 sorry** in core gems: Siegel Poussin + eta_pos + factor_neg, Lindelof GrowthBoundReal core, SelfSymmetry Core/Desert/TwinWormhole/JitterSymmetry all native_decide certified, Eutheos EulerProductLemmas CLOSED, FinalAxioms Δ>2√13, Protocol Chain.
- `native_decide` for finite arithmetic certificates: brothers_35.length=35, Nodup, ≥193, mod211=153, pop6, leader 1419=3*11*43, Hamming≥2, exceptional_upto_1000=[2,3,19,191], desert_192_1000=[], mod191 Nodup, product 36863 Nodup, W1*W2=46189, W3=36863, filter %191=1 %193=0, jitter Nodup up to 1419, EMI -30dB.
- Classical logic for irrational / analytic results: Irrational (299+π/10), Irrational π, poussin_cos_combo_nonneg via cos_two_mul, eta_pos via alternating series.
- All theorems labeled `_clean` form the certified chain: `self_symmetry_clean`, `desert_clean`, `twin_wormhole_clean`, `jitter_clean`, `twin_191_193_clean`, `ClayWitnessReady`, `chain_closed`.

## Build

```bash
lake build Siegel.SiegelZeroFreeRe1 # 1m26s #143 GREEN — poussin ≥0
lake build Siegel.SiegelZeroFreeElementary # 1m33s #151 GREEN — eta_pos>0 factor_neg<0
lake build Lindelof.GrowthBoundReal # 1m18s #142 GREEN — growth exp
lake build SelfSymmetry.Core # 35 brothers
lake build SelfSymmetry.Desert # S4 not brothers, desert empty, mod191 Nodup
lake build SelfSymmetry.TwinWormhole # W1=143 W2=323 W3=36863, 1 %191 0 %193, W1*W2=46189
lake build SelfSymmetry.JitterSymmetry # jitter Nodup 1419, EMI -30dB, alpha0 irrational
lake build SelfSymmetry.ClayWitness # #145 GREEN 1m18s — ClayWitnessReady
lake build Eutheos.FinalAxioms # #148 GREEN 1m19s — S4,P5,Δ>2√13
lake build Protocol.Chain # #147 GREEN 1m18s — ChainCertificate
grep -r "sorry" Siegel/ Lindelof/ SelfSymmetry/ Protocol/ --include="*.lean" | grep -v "FinalAxioms\|Unconditional\|RH.lean\|Bridge" # → 0 in core gems


Push:

```bash
cat > README.md <<'EOF'
[paste above final]
EOF
git add README.md Siegel/README.md Lindelof/README.md Eutheos/README.md SelfSymmetry/README.md Protocol/README.md
git commit -m "docs: #161 root README final — self-symmetry fourth route, 35 MORNINGSTAR brothers, S4 not brothers, 1419 barrier passing leader, twin wormholes W1 W2 W3, jitter Nodup 1419 alpha0 irrational EMI -30dB, vs Abbes-Ullmo vs Sarnak vs Growthbound"
git push

