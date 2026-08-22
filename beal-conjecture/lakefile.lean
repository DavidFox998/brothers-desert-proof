import Lake
open Lake DSL

package beal_conjecture where
  -- keep name as repo

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.12.0"

@[default_target]
lean_lib Beal where
  srcDir := "lean"

lean_lib lean where
  srcDir := "lean"

lean_exe audit_b14_b05_boundary where
  root := `AuditB14B05Boundary
  supportInterpreter := true

lean_exe check_zero_axiom_core where
  root := `CheckZeroAxiomCore
  supportInterpreter := true
