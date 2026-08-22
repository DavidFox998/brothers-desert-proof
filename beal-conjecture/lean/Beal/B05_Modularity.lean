import Beal.B05_Modularity_Core
import Beal.B10_RibetReal
import Beal.B14_FreyConductor
import Mathlib.Tactic

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
    {conductor : FreyConductorFunction} {A B C x y z p : Nat}
    (hFactor : ExactFreyConductorFactor conductor A B C x y z p) :
    ∃ M, FreyLevelLowering conductor A B C x y z p M := by
  rcases hFactor with ⟨_, _, hDivides, hNotSquareDivides⟩
  exact BealRibet10.level_lowering_of_exact ⟨hDivides, hNotSquareDivides⟩

/--
The import-free B05 solution certificate converts to the established Mathlib
wrapper precisely at this boundary.
-/
theorem isBealSolution05Core_to_wrapper {A B C x y z : Nat}
    (h : IsBealSolution05Core A B C x y z) :
    IsBealSolution A B C x y z := by
  rcases h with ⟨hA, hB, hC, hx, hy, hz, hEquation, hPrimitive⟩
  refine ⟨hA, hB, hC, hx, hy, hz, hEquation, ?_⟩
  apply gcd_eq_one_of_primitiveTripleCore
  intro d hDivA hDivB hDivC
  exact hPrimitive d hDivA hDivB hDivC

/--
The conductor computation is the remaining Ribet input.  Once it returns the
solution-tied equality `N = 2p`, the exact factor and lowered level `M = 2`
are elementary arithmetic, not an additional Ribet axiom.
-/
theorem ribet_level_lowering_of_conductor_computation
    (hConductor : BealFreyConductor.FreyConductorComputation) :
    RibetLevelLoweringHypothesisReal BealFreyConductor.FreyConductorReal := by
  intro A B C x y z hSolutionCore
  have hSolution : IsBealSolution A B C x y z :=
    isBealSolution05Core_to_wrapper hSolutionCore
  rcases hConductor A B C x y z hSolution with ⟨p, hpFive, hpPrime, hN⟩
  have hpPos : 0 < p :=
    Nat.lt_of_lt_of_le (by decide : 0 < 5) hpFive
  have hpNotDvdTwo : ¬ p ∣ 2 := by
    intro hpDividesTwo
    have hpLeTwo : p ≤ 2 :=
      Nat.le_of_dvd (by decide : 0 < 2) hpDividesTwo
    omega
  refine ⟨p, 2, ?_, ?_, rfl⟩
  · refine ⟨?_, hpFive, ?_, ?_⟩
    · simpa [IsPrime05Core, IsPrime10Core] using hpPrime
    · refine ⟨2, ?_⟩
      simpa [Nat.mul_comm] using hN
    · intro hpSquare
      rcases hpSquare with ⟨q, hSquare⟩
      apply hpNotDvdTwo
      refine ⟨q, ?_⟩
      have hCancelled : 2 = p * q := by
        apply Nat.mul_left_cancel hpPos
        calc
          p * 2 = 2 * p := Nat.mul_comm p 2
          _ = BealFreyConductor.FreyConductorReal A B C x y z := hN.symm
          _ = p * p * q := hSquare
          _ = p * (p * q) := Nat.mul_assoc p p q
      exact hCancelled
  · exact ⟨hN.symm, hpNotDvdTwo⟩

/-- The representation-theoretic Mazur bridge remains an explicit assumption. -/
axiom mazur_irreducibility_axiom : MazurIrreducibilityHypothesisReal

/-- The modularity-lifting/Wiles bridge remains an explicit assumption. -/
axiom wiles_lifting_axiom : WilesLiftingHypothesis

/--
Assemble the typed modularity package from the three remaining named bridges.
The separately proved `S₂(2)=0` fact records the B10 endpoint, but is not
presented as a proof of the conductor computation.
-/
theorem modularity_hypothesis_of_bridges
    (hConductor : BealFreyConductor.FreyConductorComputation)
    (hMazur : MazurIrreducibilityHypothesisReal)
    (hWiles : WilesLiftingHypothesis) :
    ModularityHypothesisTyped BealFreyConductor.FreyConductorReal :=
  ⟨⟨ribet_level_lowering_of_conductor_computation hConductor, hMazur, hWiles⟩⟩

/--
The current global modularity package names the conductor computation, Mazur,
and Wiles assumptions explicitly.  Its factorization dependencies are the
approved B14 Mathlib wrapper boundary.
-/
theorem modularity_hypothesis_with_assumptions :
    ModularityHypothesisTyped BealFreyConductor.FreyConductorReal :=
  modularity_hypothesis_of_bridges BealFreyConductor.frey_conductor_computation
    mazur_irreducibility_axiom
    wiles_lifting_axiom

#print axioms s2_dim_zero_from_b10
#print axioms lower_frey_conductor_of_exact_factor
#print axioms isBealSolution05Core_to_wrapper
#print axioms ribet_level_lowering_of_conductor_computation
#print axioms modularity_hypothesis_of_bridges
#print axioms modularity_hypothesis_with_assumptions

end BealModularity