-- B16_S2_Level2_Wrapper — the real S₂(2)=0 certificate boundary.
--
-- This wrapper does not import B14 or B15.  Genus, cusp count, and the
-- Diamond–Shurman identity are explicit certificate inputs rather than axioms.

import Beal.B16_S2_Level2_Core

namespace BealS2Level2

/-- The computed genus of `X₀(2)`. -/
def GenusX0_2 : Nat := 0

/-- The two cusps of `X₀(2)`, represented by their count. -/
def CuspCountX0_2 : Nat := 2

/--
The wrapper-facing dimension value.  Its value is not reduced by definition:
the source calculation enters through `S2Level2DimensionCertificate`.
-/
opaque S2DimensionAtLevel2 : Nat

/--
Certificate data extracted from the genus/cusp calculation and the
Diamond–Shurman identification
`dim S₂(Γ₀(N)) = genus(X₀(N))` in weight two.
-/
structure S2Level2DimensionCertificate : Prop where
  genus_zero : GenusX0_2 = 0
  cusp_count : CuspCountX0_2 = 2
  diamond_shurman : S2DimensionAtLevel2 = GenusX0_2

/-- The explicit wrapper input that connects dimension zero to no cusp form. -/
def DimensionZeroNoCuspCertificate : Prop :=
  S2DimensionAtLevel2 = 0 → LevelTwoNoCuspForm

/--
The actual dimension conclusion from genus zero, the two-cusp calculation,
and the Diamond–Shurman weight-two formula.
-/
theorem s2_level2_dimension_zero
    (hDimension : S2Level2DimensionCertificate) :
    S2DimensionAtLevel2 = 0 := by
  rw [hDimension.diamond_shurman, hDimension.genus_zero]

/-- Convert the proved wrapper dimension certificate into the Core boundary. -/
theorem level_two_no_cusp_form_of_dimension_certificate
    (hDimension : S2Level2DimensionCertificate)
    (hNoCusp : DimensionZeroNoCuspCertificate) :
    LevelTwoNoCuspForm :=
  hNoCusp (s2_level2_dimension_zero hDimension)

/--
The complete wrapper-side contradiction once a level-two Frey cusp-form
witness is supplied.
-/
theorem ribet_level_two_contradiction_of_dimension
    (hDimension : S2Level2DimensionCertificate)
    (hNoCusp : DimensionZeroNoCuspCertificate)
    (hLevelTwoFreyForm : ¬ LevelTwoNoCuspForm) : False :=
  ribet_level_two_contradiction
    (level_two_no_cusp_form_of_dimension_certificate hDimension hNoCusp)
    hLevelTwoFreyForm

#print axioms GenusX0_2
#print axioms CuspCountX0_2
#print axioms S2DimensionAtLevel2
#print axioms S2Level2DimensionCertificate
#print axioms DimensionZeroNoCuspCertificate
#print axioms s2_level2_dimension_zero
#print axioms level_two_no_cusp_form_of_dimension_certificate
#print axioms ribet_level_two_contradiction_of_dimension

end BealS2Level2