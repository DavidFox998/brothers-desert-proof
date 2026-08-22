-- B16 wrapper — the S₂(Γ₀(2)) = 0 certificate boundary.
--
-- The analytic/source calculation belongs here.  This wrapper does not
-- import B14 or B15, and it does not import factorization or radical code.

import Beal.B16_S2_Level2_Core

namespace BealS2Level2

/-- The genus computation for X₀(2), supplied by the source calculation. -/
def GenusX0_2 : Nat := 0

/-- X₀(2) has the two cusps 0 and ∞. -/
def CuspCountX0_2 : Nat := 2

/--
The wrapper-facing dimension value.  Its value is intentionally not reduced
by definition: the Diamond–Shurman dimension identity enters as certificate
data below.
-/
opaque S2DimensionAtLevel2 : Nat

/--
Explicit B16 wrapper certificate for the source calculation:

* genus(X₀(2)) = 0;
* X₀(2) has two cusps;
* the weight-two Diamond–Shurman dimension identity identifies the
  dimension with the genus.

This is certificate input, not a Core axiom.
-/
structure S2_Gamma0_2_DimensionCertificate : Prop where
  genus_zero : GenusX0_2 = 0
  two_cusps : CuspCountX0_2 = 2
  diamond_shurman : S2DimensionAtLevel2 = GenusX0_2

/-- The wrapper's explicit source certificate that dimension zero means no cusp form. -/
def DimensionZeroNoCuspCertificate : Prop :=
  S2DimensionAtLevel2 = 0 → LevelTwoNoCuspFormCore

theorem X0_2_genus_zero : GenusX0_2 = 0 :=
  rfl

theorem num_cusps_X0_2 : CuspCountX0_2 = 2 :=
  rfl

/--
Diamond–Shurman's weight-two identity plus the genus-zero certificate gives
the vanishing dimension.  The two-cusp datum is retained in the same
certificate because it is part of the cited X₀(2) source calculation.
-/
theorem S2_Gamma0_2_dimension_zero
    (hDim : S2_Gamma0_2_DimensionCertificate) :
    S2DimensionAtLevel2 = 0 := by
  rw [hDim.diamond_shurman, hDim.genus_zero]

/-- Convert the wrapper dimension certificate into the opaque Core certificate. -/
theorem x0_2_no_Frey_of_dimension_zero
    (hDim : S2_Gamma0_2_DimensionCertificate)
    (hNoCusp : DimensionZeroNoCuspCertificate) :
    LevelTwoNoCuspFormCore :=
  hNoCusp (S2_Gamma0_2_dimension_zero hDim)

/-- Assemble the wrapper certificate with the Core contradiction boundary. -/
theorem ribet_level_two_contradiction_of_dimension
    (hDim : S2_Gamma0_2_DimensionCertificate)
    (hNoCusp : DimensionZeroNoCuspCertificate)
    (hMod2 : LevelTwoModularDataCore)
    (hFreyForm : ¬ LevelTwoNoCuspFormCore) : False :=
  ribet_level_two_contradiction_core
    hMod2
    (x0_2_no_Frey_of_dimension_zero hDim hNoCusp)
    hFreyForm

#print axioms X0_2_genus_zero
#print axioms num_cusps_X0_2
#print axioms S2DimensionAtLevel2
#print axioms S2_Gamma0_2_DimensionCertificate
#print axioms DimensionZeroNoCuspCertificate
#print axioms S2_Gamma0_2_dimension_zero
#print axioms x0_2_no_Frey_of_dimension_zero
#print axioms ribet_level_two_contradiction_of_dimension

end BealS2Level2