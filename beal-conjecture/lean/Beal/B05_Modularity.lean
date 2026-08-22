import Beal.B05_Modularity_Core
import Beal.B10_RibetReal

namespace BealModularity

/--
The B10 theorem supplies the formal S₂(2)=0 fact used at this boundary.
It does not, by itself, prove the conductor-tied Ribet statement below.
-/
theorem s2_dim_zero_from_b10 : S2DimZero := by
  exact BealRibet10.s2_vanishes_at_2

/--
The proved arithmetic portion of level lowering.  Once an exact prime factor
of the conductor has been established, the lowered level is obtained without
any additional mathematical assumption.
-/
theorem lower_frey_conductor_of_exact_factor
    {A B C x y z p : Nat}
    (hFactor : ExactFreyConductorFactor A B C x y z p) :
    ∃ M, FreyLevelLowering A B C x y z p M := by
  rcases hFactor with ⟨_, _, hDivides, hNotSquareDivides⟩
  exact BealRibet10.level_lowering_of_exact ⟨hDivides, hNotSquareDivides⟩

/--
The actual level-lowering theorem remains an explicit assumption until the
Frey-conductor computation and representation-theoretic Ribet argument have
been formalized.  It now asks explicitly for a lowered level equal to two.
-/
axiom ribet_level_lowering_axiom_real : RibetLevelLoweringHypothesisReal

/-- The representation-theoretic Mazur bridge remains an explicit assumption. -/
axiom mazur_irreducibility_axiom : MazurIrreducibilityHypothesisReal

/-- The modularity-lifting/Wiles bridge remains an explicit assumption. -/
axiom wiles_lifting_axiom : WilesLiftingHypothesis

/--
Assemble the typed modularity package from explicitly supplied bridges.
The S₂ input records the B10 connection without claiming it entails Ribet.
-/
theorem modularity_hypothesis_of_bridges
    (_ : S2DimZero)
    (hRibet : RibetLevelLoweringHypothesisReal)
    (hMazur : MazurIrreducibilityHypothesisReal)
    (hWiles : WilesLiftingHypothesis) :
    ModularityHypothesisTyped :=
  ⟨⟨hRibet, hMazur, hWiles⟩⟩

/--
The current global modularity package.  Its axiom report deliberately names
all three outstanding mathematical bridges.
-/
theorem modularity_hypothesis_with_assumptions : ModularityHypothesisTyped :=
  modularity_hypothesis_of_bridges s2_dim_zero_from_b10
    ribet_level_lowering_axiom_real
    mazur_irreducibility_axiom
    wiles_lifting_axiom

#print axioms s2_dim_zero_from_b10
#print axioms lower_frey_conductor_of_exact_factor
#print axioms modularity_hypothesis_of_bridges
#print axioms modularity_hypothesis_with_assumptions

end BealModularity