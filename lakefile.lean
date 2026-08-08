import Lake
open Lake DSL

package «brothers-desert-proof» where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.15.0"

-- FIXED: was 'require eutheos from git "eutheos-property.git"'
-- Package is named «eutheos-property», so require must match
require «eutheos-property» from git
  "https://github.com/DavidFox998/eutheos-property.git" @ "main"

lean_lib BrothersDesertProof where
  srcDir := "."
  globs := #[
    .one `Closure.ArakelovFoundations,
    .one `Eutheos.Object,
    .one `Eutheos.Theta,
    .one `Eutheos.RationalTheta,
    .one `RouteC.GrowthRepulsionBridge,
    .one `Lindelof.LindelofBridge,
    .one `Eutheos.Bridge,
    .one `Eutheos.RH,
    .one `Eutheos.RamanujanFactorization,
    .one `Eutheos.EulerProductLemmas,
    .one `Route.RouteC,
    .one `Siegel.SiegelZeroFree,
    .one `SelfSymmetry.Core,
    .one `SelfSymmetry.Desert,
    .one `SelfSymmetry.JitterSymmetry,
    .one `SelfSymmetry.TwinWormhole,
    .one `SelfSymmetry.ClayWitness,
    .one `Protocol.Chain
  ]
