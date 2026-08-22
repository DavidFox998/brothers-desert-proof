-- B15_X0_10_Wrapper — explicit X₀(10) functions and local certificates.
--
-- This is deliberately the modular-curve boundary.  In particular it does
-- not import B14 or define a radical/factorization function.

import Beal.B05_Modularity_Core
import Beal.B15_X0_10_Core
import Mathlib.Data.Rat.Defs
import Mathlib.NumberTheory.Padics.PadicVal.Basic

namespace BealX0_10

/--
The `E₁` coordinate of the `R₄(10)` parametrization in the convention of
González-Jiménez--Lario, §17.1:

`j(E₁) = (t⁶ - 4t⁵ + 16t + 16)³ / ((t - 4)t⁵(t + 1)²)`.
-/
def R4_10_j_E1 (t : ℚ) : ℚ :=
  (t ^ 6 - 4 * t ^ 5 + 16 * t + 16) ^ 3 /
    ((t - 4) * t ^ 5 * (t + 1) ^ 2)

/--
The companion `E₁₀` coordinate of the `R₄(10)` parametrization:

`j(E₁₀) =
 (t⁶ + 236t⁵ + 1440t⁴ + 1920t³ + 3840t² + 256t + 256)³ /
 ((t + 1)⁵(t - 4)¹⁰t²)`.
-/
def R4_10_j_E10 (t : ℚ) : ℚ :=
  (t ^ 6 + 236 * t ^ 5 + 1440 * t ^ 4 + 1920 * t ^ 3 +
      3840 * t ^ 2 + 256 * t + 256) ^ 3 /
    ((t + 1) ^ 5 * (t - 4) ^ 10 * t ^ 2)

/-- The j-invariant of `Y² = X(X - Aˣ)(X + Bʸ)`. -/
def frey_j (A B x y : Nat) : ℚ :=
  256 *
      (((A : ℚ) ^ x) ^ 2 + (A : ℚ) ^ x * (B : ℚ) ^ y +
        ((B : ℚ) ^ y) ^ 2) ^ 3 /
    ((A : ℚ) ^ (2 * x) * (B : ℚ) ^ (2 * y) *
      ((A : ℚ) ^ x + (B : ℚ) ^ y) ^ 2)

/--
Membership in the non-cuspidal `E₁` j-image of the displayed `R₄(10)` map.
The excluded values are precisely the visible poles of the coordinate.
-/
def FreyJInR4_10Image (A B C x y z : Nat) : Prop :=
  ∃ t : ℚ, t ≠ 0 ∧ t ≠ -1 ∧ t ≠ 4 ∧
    frey_j A B x y = R4_10_j_E1 t

/--
The explicit 2-adic lower bound retained at the B15 modular-curve boundary.
It is deliberately a valuation statement, not a factorization or radical
predicate.
-/
def FreyV2ProductAtLeastThree (A B C x y z : Nat) : Prop :=
  (3 : ℤ) ≤ padicValRat 2 ((A ^ x * B ^ y * C ^ z : Nat) : ℚ)

/--
The local input used by the `R₄(10)` valuation tables.  The first conjunct is
the import-free mod-eight conclusion already available for the all-odd Frey
branch; the second is the stronger product valuation condition.
-/
def R4_10FreyLocalData (A B C x y z : Nat) : Prop :=
  8 ∣ A ^ x + B ^ y ∧ FreyV2ProductAtLeastThree A B C x y z

/--
Certificate distilled from Proposition 17 and Table 31 of
González-Jiménez--Lario: after their valuation cases are checked, an
admissible Frey j-invariant cannot equal the non-cuspidal `R₄(10)` E₁
coordinate.

This is an explicit wrapper-level certificate input, rather than an axiom:
the source's valuation-table verification is the remaining mathematical
artifact to supply here.  It keeps that work out of zero-axiom Core.
-/
def R4_10ValuationTables17_31 : Prop :=
  ∀ A B C x y z : Nat,
    IsBealSolution05Core A B C x y z →
    R4_10FreyLocalData A B C x y z →
    ¬ FreyJInR4_10Image A B C x y z

/--
The modular-curve bridge: a rational 10-isogeny of the Frey curve supplies a
non-cuspidal point in the selected `R₄(10)` j-image.  This belongs in the
wrapper because it refers to the explicit rational parametrization.
-/
def FreyRational10ToR4_10Image : Prop :=
  ∀ A B C x y z : Nat,
    FreyRational10Isogeny15Core A B C x y z →
    FreyJInR4_10Image A B C x y z

/--
Wrapper proof of the Core-facing certificate.  All modular-curve formulas,
the rational image, and the valuation-table input remain on the B15 side of
the architectural boundary.
-/
theorem frey_j_not_in_image
    (hTables : R4_10ValuationTables17_31)
    {A B C x y z : Nat}
    (hBeal : IsBealSolution05Core A B C x y z)
    (hLocal : R4_10FreyLocalData A B C x y z) :
    ¬ FreyJInR4_10Image A B C x y z :=
  hTables A B C x y z hBeal hLocal

theorem x0_10_no_Frey_of_valuation_tables
    (hTables : R4_10ValuationTables17_31)
    (hImage : FreyRational10ToR4_10Image)
    {A B C x y z : Nat}
    (hBeal : IsBealSolution05Core A B C x y z)
    (hLocal : R4_10FreyLocalData A B C x y z) :
    X0_10_no_Frey A B C x y z := by
  intro hTen
  exact frey_j_not_in_image hTables hBeal hLocal (hImage A B C x y z hTen)

#print axioms R4_10_j_E1
#print axioms R4_10_j_E10
#print axioms frey_j
#print axioms FreyJInR4_10Image
#print axioms FreyV2ProductAtLeastThree
#print axioms R4_10FreyLocalData
#print axioms R4_10ValuationTables17_31
#print axioms FreyRational10ToR4_10Image
#print axioms frey_j_not_in_image
#print axioms x0_10_no_Frey_of_valuation_tables

end BealX0_10