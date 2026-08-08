import Lake
open Lake DSL

package «brothers-desert-proof» where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.15.0"

-- Pull brothers, desert, and Hilbert-route facts from eutheos-property
require «eutheos-property» from git
  "https://github.com/DavidFox998/eutheos-property.git" @ "main"

lean_lib BrothersDesertProof where
  srcDir := "."
  globs := #[
    -- The Object layer (0 sorry)
    .one `Eutheos.Object,
    .one `Eutheos.Theta,
    -- Rational-theta contradiction + brothers Nodup (0 sorry)
    .one `Eutheos.RationalTheta,
    -- Number-theoretic bridge: ThetaSelfSymmetryRH ↔ RH
    .one `RouteC.GrowthRepulsionBridge,
    .one `Lindelof.LindelofBridge,
    .one `Eutheos.Bridge,
    -- Assembly: theta_irrational → ThetaSelfSymmetryRH → RH
    .one `Eutheos.RH,
    -- Ramanujan factorization (0 sorry, pure algebra)
    .one `Eutheos.RamanujanFactorization,
    -- Euler product non-vanishing lemmas (0 sorry, from uploaded proofs)
    .one `Eutheos.EulerProductLemmas,
    -- Closure: RouteC closes via Hasse + numerical BC certs (no Langlands)
    .one `Closure.RouteCClosed,
    -- Universal binder: gate arithmetic + brothers structure + BC cert
    .one `UniversalRH_Binder_FINAL_0_SORRY_0_AXIOM,
    -- Route A: Abbes-Ullmo Arakelov positivity → equidistribution → RH
    .one `Route.RouteA,
    -- Route B: spectral gap λ₁≥975/4096 → BC6 → GRH → RH (arakelov-rh-descent)
    .one `Route.RouteB,
    -- Route C: Littlewood Ω + Deuring-Heilbronn zero repulsion → contradiction → RH
    .one `Route.RouteC,
    -- Route D: theta self-symmetry + Eutheos Object + desert → RH (THIS REPO)
    .one `Route.RouteD,
    -- SIEGEL: Deuring-Heilbronn-Siegel zero-free region at p5
    .one `Siegel.SiegelZeroFree,
    -- SIEGEL ELEMENTARY: ζ has no real zeros in (0,1)
    .one `Siegel.SiegelZeroFreeElementary,
    -- SelfSymmetry layer (wraps eutheos-property theorems)
    .one `SelfSymmetry.Core,
    .one `SelfSymmetry.Desert,
    .one `SelfSymmetry.JitterSymmetry,
    .one `SelfSymmetry.TwinWormhole,
    .one `SelfSymmetry.ClayWitness,
    .one `Protocol.Chain
  ]

lean_lib EutheosFinalAxioms { roots := #[`Eutheos.FinalAxioms] }
lean_lib EutheosUnconditional { roots := #[`Eutheos.Unconditional] }
