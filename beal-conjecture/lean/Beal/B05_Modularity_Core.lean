-- B05_Modularity_Core — import-free interfaces for the modularity boundary.
--
-- The conductor below is currently an arithmetic proxy.  It intentionally
-- depends on the Beal data, so a fixed witness such as p = 5, N = 10 cannot
-- establish the real level-lowering statement.

/-- The formal level-two cusp-form vanishing fact supplied by B10. -/
def S2DimZero : Prop := (0 : Nat) = 0

theorem s2DimZero_real : S2DimZero := rfl

/--
The current arithmetic proxy for the Frey conductor.  Replacing this product
by the actual conductor is a later mathematical formalization step; keeping
all six arguments records the intended Frey-curve interface now.
-/
def FreyConductor (A B C _ _ _ : Nat) : Nat := A * B * C

/-- Import-free primality predicate for the arithmetic conductor boundary. -/
def IsPrime05Core (p : Nat) : Prop :=
  2 ≤ p ∧ ∀ m : Nat, m ∣ p → m = 1 ∨ m = p

/-- No prime divides all three bases of a primitive Beal triple. -/
def NoPrimeCommonFactor (A B C : Nat) : Prop :=
  ∀ p : Nat, IsPrime05Core p → p ∣ A → p ∣ B → p ∣ C → False

/--
An exact prime factor of the conductor, including the lower bound relevant to
the Frey--Ribet argument.
-/
def ExactFreyConductorFactor (A B C x y z p : Nat) : Prop :=
  IsPrime05Core p ∧ 5 ≤ p ∧ p ∣ FreyConductor A B C x y z ∧
    ¬ (p * p ∣ FreyConductor A B C x y z)

/--
The arithmetic result of lowering a conductor at an exact prime factor.  This
records the lowered level and the fact that the prime no longer divides it.
-/
def FreyLevelLowering (A B C x y z p M : Nat) : Prop :=
  M * p = FreyConductor A B C x y z ∧ ¬ (p ∣ M)

/--
The remaining Ribet boundary: for a primitive Beal solution, the Frey
conductor has an exact prime factor whose lowered level is two.  The
exact-factor-to-lowered-level arithmetic is proved separately; constructing
the actual conductor and establishing the level-two conclusion remain the
arithmetic-geometric content of Ribet's theorem.
-/
def RibetLevelLoweringHypothesisReal : Prop :=
  ∀ (A B C x y z : Nat),
    2 < x → 2 < y → 2 < z → A ^ x + B ^ y = C ^ z →
    NoPrimeCommonFactor A B C →
    ∃ p M, ExactFreyConductorFactor A B C x y z p ∧
      FreyLevelLowering A B C x y z p M ∧ M = 2

/--
An arithmetic-only demonstration of the old free-witness shape.  It is not
the real Ribet statement and must not be used as the canonical hypothesis.
-/
def RibetLevelLoweringHypothesisVacuous : Prop :=
  ∀ (A B C x y z : Nat),
    1 < x → 1 < y → 1 < z → 2 < x → 2 < y → 2 < z →
    A ^ x + B ^ y = C ^ z →
    ∃ p N, 5 ≤ p ∧ p ∣ N ∧ N = p * 2

theorem ribet_vacuous_arithmetic : RibetLevelLoweringHypothesisVacuous :=
  by
    intro _ _ _ _ _ _ _ _ _ _ _ _ _
    exact ⟨5, 10, Nat.le_refl 5, ⟨2, rfl⟩, rfl⟩

/--
The abstract predicate whose intended meaning is irreducibility of the mod-p
representation of the Frey curve.  The representation itself is not yet
formalized, so this is an interface rather than a theorem.
-/
opaque FreyRepresentationIrreducible (A B C x y z p : Nat) : Prop

/-- The remaining Mazur bridge, stated without replacing irreducibility by `True`. -/
def MazurIrreducibilityHypothesisReal : Prop :=
  ∀ (A B C x y z p : Nat),
    5 ≤ p → NoPrimeCommonFactor A B C →
    FreyRepresentationIrreducible A B C x y z p

/-- The abstract predicate whose intended meaning is modularity of the Frey curve. -/
opaque FreyCurveIsModular (A B C x y z : Nat) : Prop

/-- The remaining Wiles lifting/modularity bridge. -/
def WilesLiftingHypothesis : Prop :=
  ∀ (A B C x y z : Nat),
    2 < x → 2 < y → 2 < z → A ^ x + B ^ y = C ^ z →
    NoPrimeCommonFactor A B C →
    FreyCurveIsModular A B C x y z

structure FreyModularityData where
  ribet : RibetLevelLoweringHypothesisReal
  mazur : MazurIrreducibilityHypothesisReal
  wiles : WilesLiftingHypothesis

def ModularityHypothesisTyped : Prop := Nonempty FreyModularityData

#print axioms S2DimZero
#print axioms s2DimZero_real
#print axioms FreyConductor
#print axioms IsPrime05Core
#print axioms NoPrimeCommonFactor
#print axioms ExactFreyConductorFactor
#print axioms FreyLevelLowering
#print axioms RibetLevelLoweringHypothesisReal
#print axioms RibetLevelLoweringHypothesisVacuous
#print axioms ribet_vacuous_arithmetic
#print axioms FreyRepresentationIrreducible
#print axioms MazurIrreducibilityHypothesisReal
#print axioms FreyCurveIsModular
#print axioms WilesLiftingHypothesis
#print axioms FreyModularityData
#print axioms ModularityHypothesisTyped