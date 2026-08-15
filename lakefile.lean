import Lake
open Lake DSL

package «brothers-desert-proof» where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.15.0"

require «eutheos-property» from git
  "https://github.com/DavidFox998/eutheos-property.git" @ "main"

require «lindelof-hypothesis-143» from git
  "https://github.com/DavidFox998/lindelof-hypothesis-143.git" @ "main"

lean_lib BrothersDesertProof where
  srcDir := "."
  globs := #[
    .submodules `Closure,
    .submodules `ContradictionRoute,
    .submodules `Eutheos,
    .submodules `Lindelof,
    .submodules `MathlibFix,
    .submodules `Protocol,
    .submodules `SelfSymmetry,
    .submodules `Siegel
  ]
