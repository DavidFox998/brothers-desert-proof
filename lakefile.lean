import Lake
open Lake DSL

package «brothers-desert-proof» where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.15.0"

require «eutheos-property» from git
  "https://github.com/DavidFox998/eutheos-property.git" @ "main"

-- YOUR #49 GREEN Lindelöf repo — so we can import Lindelof_143_TRUE genuine
require «lindelof-hypothesis-143» from git
  "https://github.com/DavidFox998/lindelof-hypothesis-143.git" @ "main"

lean_lib BrothersDesertProof where
  srcDir := "."
  globs := #[
    -- Foundations / Family
    .one `Family.Brothers1419,
    .one `Family.TwinPrimes,
    .one `Family.DirichletJitterTime,
    .one `Closure.ArakelovFoundations,
    .one `Eutheos.Object,
    .one `Eutheos.Theta,
    .one `Eutheos.RationalTheta,
    .one `Eutheos.RamanujanFactorization,
    .one `Eutheos.EulerProductLemmas,
    .one `Eutheos.Bridge,
    .one `Eutheos.RH,
    -- Lindelöf bridges — YOUR new files
    .one `Lindelof.LindelofBridge,
    .one `Lindelof.GrowthBoundReal,
    -- Siegel zero-free
    .one `Siegel.SiegelZeroFree,
    .one `Siegel.SiegelZeroFreeElementary,
    .one `Siegel.SiegelZeroFreeRe1,
    -- SelfSymmetry
    .one `SelfSymmetry.Core,
    .one `SelfSymmetry.Desert,
    .one `SelfSymmetry.JitterSymmetry,
    .one `SelfSymmetry.TwinWormhole,
    .one `SelfSymmetry.ClayWitness,
    -- Routes
    .one `Protocol.Chain,
    .one `ContradictionRoute.LanglandsWeilTransfer,
    .one `ContradictionRoute.GrowthRepulsionBridge
  ]

-- Also build the lindelof lib so #49 is checked
lean_lib Lindelof143 where
  srcDir := "."
  globs := #[.sub `Lindelof]
