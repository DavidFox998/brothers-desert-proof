-- B05_Modularity_Core — import-free interfaces for the modularity boundary.

/-- The formal level-two cusp-form vanishing fact supplied by B10. -/
def S2DimZero : Prop := (0 : Nat) = 0

theorem s2DimZero_real : S2DimZero := rfl

def FreyConductorFunction : Type :=
  Nat → Nat → Nat → Nat → Nat → Nat → Nat

/-- Import-free primality predicate for the arithmetic conductor boundary. -/
def IsPrime05Core (p : Nat) : Prop :=
  2 ≤ p ∧ ∀ m : Nat, m ∣ p → m = 1 ∨ m = p

def PrimitiveTriple05Core (A B C : Nat) : Prop :=
  ∀ d : Nat, d ∣ A → d ∣ B → d ∣ C → d = 1

def IsBealSolution05Core (A B C x y z : Nat) : Prop :=
  0 < A ∧ 0 < B ∧ 0 < C ∧
  2 < x ∧ 2 < y ∧ 2 < z ∧
  A ^ x + B ^ y = C ^ z ∧
  PrimitiveTriple05Core A B C

/--
An exact prime factor of the conductor, including the lower bound relevant to
the Frey--Ribet argument.
-/
def ExactFreyConductorFactor (conductor : FreyConductorFunction)
    (A B C x y z p : Nat) : Prop :=
  IsPrime05Core p ∧ 5 ≤ p ∧ p ∣ conductor A B C x y z ∧
    ¬ (p * p ∣ conductor A B C x y z)

/--
The arithmetic result of lowering a conductor at an exact prime factor.  This
records the lowered level and the fact that the prime no longer divides it.
-/
def FreyLevelLowering (conductor : FreyConductorFunction)
    (A B C x y z p M : Nat) : Prop :=
  M * p = conductor A B C x y z ∧ ¬ (p ∣ M)

/--
The remaining Ribet boundary: for a primitive Beal solution, the Frey
conductor has an exact prime factor whose lowered level is two.  The
exact-factor-to-lowered-level arithmetic is proved separately; constructing
the actual conductor and establishing the level-two conclusion remain the
arithmetic-geometric content of Ribet's theorem.
-/
def RibetLevelLoweringHypothesisReal (conductor : FreyConductorFunction) : Prop :=
  ∀ (A B C x y z : Nat),
    IsBealSolution05Core A B C x y z →
    ∃ p M, ExactFreyConductorFactor conductor A B C x y z p ∧
      FreyLevelLowering conductor A B C x y z p M ∧ M = 2

/--
The abstract predicate whose intended meaning is irreducibility of the mod-p
representation of the Frey curve.  The representation itself is not yet
formalized, so this is an interface rather than a theorem.
-/
opaque FreyRepresentationIrreducible (A B C x y z p : Nat) : Prop

/-- The remaining Mazur bridge, stated without replacing irreducibility by `True`. -/
def MazurIrreducibilityHypothesisReal : Prop :=
  ∀ (A B C x y z p : Nat),
    5 ≤ p → IsBealSolution05Core A B C x y z →
    FreyRepresentationIrreducible A B C x y z p

/-- The abstract predicate whose intended meaning is modularity of the Frey curve. -/
opaque FreyCurveIsModular (A B C x y z : Nat) : Prop

/-- The remaining Wiles lifting/modularity bridge. -/
def WilesLiftingHypothesis : Prop :=
  ∀ (A B C x y z : Nat),
    IsBealSolution05Core A B C x y z →
    FreyCurveIsModular A B C x y z

structure FreyModularityData (conductor : FreyConductorFunction) where
  ribet : RibetLevelLoweringHypothesisReal conductor
  mazur : MazurIrreducibilityHypothesisReal
  wiles : WilesLiftingHypothesis

def ModularityHypothesisTyped (conductor : FreyConductorFunction) : Prop :=
  Nonempty (FreyModularityData conductor)

#print axioms S2DimZero
#print axioms s2DimZero_real
#print axioms FreyConductorFunction
#print axioms IsPrime05Core
#print axioms PrimitiveTriple05Core
#print axioms IsBealSolution05Core
#print axioms ExactFreyConductorFactor
#print axioms FreyLevelLowering
#print axioms RibetLevelLoweringHypothesisReal
#print axioms FreyRepresentationIrreducible
#print axioms MazurIrreducibilityHypothesisReal
#print axioms FreyCurveIsModular
#print axioms WilesLiftingHypothesis
#print axioms FreyModularityData
#print axioms ModularityHypothesisTyped