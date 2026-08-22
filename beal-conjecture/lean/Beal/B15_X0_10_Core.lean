-- B15_X0_10_Core — zero-import interfaces for the X₀(10) boundary.
--
-- The actual Frey curve, its rational subgroups, and the modular-curve
-- parametrization live in the B15 wrapper.  Core records only the
-- certificate shapes needed to pass their conclusion to later arguments.

/--
An abstract rational cyclic subgroup.  The ambient elliptic curve and its
group law intentionally remain outside Core; `rational` and `cyclic` are the
certified properties supplied by the wrapper.
-/
structure RationalCyclicSubgroup15Core where
  order : Nat
  rational : Prop
  cyclic : Prop

/-- A rational cyclic order-two subgroup selected from full rational 2-torsion. -/
def Full2Torsion15Core (H₂ : RationalCyclicSubgroup15Core) : Prop :=
  H₂.order = 2 ∧ H₂.rational ∧ H₂.cyclic

/-- A rational cyclic kernel of a 5-isogeny. -/
def Rational5Isogeny15Core (H₅ : RationalCyclicSubgroup15Core) : Prop :=
  H₅.order = 5 ∧ H₅.rational ∧ H₅.cyclic

/-- A rational cyclic kernel of a 10-isogeny. -/
def Rational10Isogeny15Core (H₁₀ : RationalCyclicSubgroup15Core) : Prop :=
  H₁₀.order = 10 ∧ H₁₀.rational ∧ H₁₀.cyclic

/--
The certified subgroup product of a rational 2-kernel and a rational
5-kernel.  The wrapper supplies the group-theoretic construction; Core needs
only its order, rationality, and cyclicity certificates.
-/
structure SubgroupProduct15Core
    (H₂ H₅ H₁₀ : RationalCyclicSubgroup15Core) : Prop where
  product_order : H₁₀.order = H₂.order * H₅.order
  product_rational : H₁₀.rational
  product_cyclic : H₁₀.cyclic

/--
The subgroup-product step is elementary once the product subgroup has been
constructed: a rational cyclic subgroup of order `2 * 5` is a rational
10-isogeny kernel.
-/
theorem full2Torsion_mul_5_isogeny_imp_10_isogeny
    {H₂ H₅ H₁₀ : RationalCyclicSubgroup15Core}
    (hFull2 : Full2Torsion15Core H₂)
    (hFive : Rational5Isogeny15Core H₅)
    (hProduct : SubgroupProduct15Core H₂ H₅ H₁₀) :
    Rational10Isogeny15Core H₁₀ := by
  have h₂order : H₂.order = 2 := hFull2.1
  have h₅order : H₅.order = 5 := hFive.1
  refine ⟨?_, hProduct.product_rational, hProduct.product_cyclic⟩
  calc
    H₁₀.order = H₂.order * H₅.order := hProduct.product_order
    _ = 2 * 5 := by rw [h₂order, h₅order]
    _ = 10 := rfl

/--
The B15 wrapper uses its explicit `X₀(10)` j-map and the cited local
valuation tables to discharge this opaque modular-curve predicate.
-/
opaque FreyRational10Isogeny15Core (A B C x y z : Nat) : Prop

/-- Core-facing certificate that the Frey curve has no rational 10-isogeny. -/
def X0_10_no_Frey (A B C x y z : Nat) : Prop :=
  ¬ FreyRational10Isogeny15Core A B C x y z

#print axioms RationalCyclicSubgroup15Core
#print axioms Full2Torsion15Core
#print axioms Rational5Isogeny15Core
#print axioms Rational10Isogeny15Core
#print axioms SubgroupProduct15Core
#print axioms full2Torsion_mul_5_isogeny_imp_10_isogeny
#print axioms FreyRational10Isogeny15Core
#print axioms X0_10_no_Frey