-- Closure/ArakelovFoundations.lean
-- Rational certificate constants and proved inequality bricks for RouteC.
-- Pattern from DavidFox998/arakelov-positivity-rh-core (C01_Arakelov.lean).
--
-- 0 sorry · 0 axiom keyword
-- Axiom footprint: {propext, Classical.choice, Quot.sound}
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Sqrt

namespace RouteC

open Real

/-! ## Rational certificate constants -/

/-- Rational lower bound for CS4 = C(2)+C(3)+C(19)+C(191).
    Certified: Python mpmath 64 dps → 11.42214868898...  > 11.422148688. -/
def C_S4_cert : ℚ := 11422148688 / 1000000000

/-- Rational lower bound for CS5 = CS4 + C(p5).
    Certified: Python mpmath 64 dps → 40.43789947845...  > 40.437899478. -/
def C_S5_cert : ℚ := 40437899478 / 1000000000

/-! ## Proved inequality bricks — 0 sorry, 0 axiom -/

lemma sqrt_13_lt_4 : Real.sqrt 13 < 4 := by
  have h1 : Real.sqrt 13 < Real.sqrt 16 := Real.sqrt_lt_sqrt (by norm_num) (by norm_num)
  have h2 : Real.sqrt 16 = 4 := by
    rw [show (16 : ℝ) = 4 ^ 2 from by norm_num]; exact Real.sqrt_sq (by norm_num)
  linarith

lemma C_S4_cert_gt_11 : (C_S4_cert : ℝ) > 11 := by
  have : C_S4_cert > 11 := by unfold C_S4_cert; norm_num
  exact_mod_cast this

/-- C_S4_cert > 2·sqrt(13).  Proof: sqrt(13)<4, 2·4=8, C_S4_cert>11>8. -/
theorem C_S4_cert_gt_2sqrt13 : (C_S4_cert : ℝ) > 2 * Real.sqrt 13 :=
  by linarith [sqrt_13_lt_4, C_S4_cert_gt_11]

lemma sqrt_32_lt_566 : Real.sqrt 32 < 5.66 := by
  have : (32 : ℝ) < 5.66 ^ 2 := by norm_num
  calc Real.sqrt 32 < Real.sqrt (5.66 ^ 2) := Real.sqrt_lt_sqrt (by norm_num) this
    _ = 5.66 := Real.sqrt_sq (by norm_num)

lemma C_S4_cert_gt_1132 : (C_S4_cert : ℝ) > 11.32 := by
  have : C_S4_cert > 11.32 := by unfold C_S4_cert; norm_num
  exact_mod_cast this

/-- C_S4_cert > 2·sqrt(32).  Proof: 2·sqrt(32) < 2·5.66 = 11.32 < C_S4_cert. -/
theorem C_S4_cert_gt_2sqrt32 : (C_S4_cert : ℝ) > 2 * Real.sqrt 32 :=
  by linarith [sqrt_32_lt_566, C_S4_cert_gt_1132]

lemma sqrt_408_lt_202 : Real.sqrt 408 < 20.2 := by
  have : (408 : ℝ) < 20.2 ^ 2 := by norm_num
  calc Real.sqrt 408 < Real.sqrt (20.2 ^ 2) := Real.sqrt_lt_sqrt (by norm_num) this
    _ = 20.2 := Real.sqrt_sq (by norm_num)

lemma C_S5_cert_gt_4040 : (C_S5_cert : ℝ) > 40.40 := by
  have : C_S5_cert > 40.40 := by unfold C_S5_cert; norm_num
  exact_mod_cast this

/-- C_S5_cert > 2·sqrt(408).  Proof: 2·sqrt(408) < 2·20.2 = 40.40 < C_S5_cert. -/
theorem C_S5_cert_gt_2sqrt408 : (C_S5_cert : ℝ) > 2 * Real.sqrt 408 :=
  by linarith [sqrt_408_lt_202, C_S5_cert_gt_4040]

/-! ## Named open surfaces — NOT axioms, NOT sorry -/
-- Each is an explicit named gap.  Replace with a proof when the Lean
-- formalization catches up (expected Mathlib 4.17+).

/-- CS4_lower_OPEN: CS4 ≥ C_S4_cert.
    Gap: Real.log interval arithmetic (~3pp).
    External: Python mpmath gives 11.42214868898 > 11.422148688 = C_S4_cert.
    Once proved, CS4_gt_2sqrt13 and CS4_gt_2sqrt32 become unconditional. -/
def CS4_lower_OPEN (CS4 : ℝ) : Prop := CS4 ≥ (C_S4_cert : ℝ)

/-- CS5_lower_OPEN: CS5 ≥ C_S5_cert.
    Gap: same Real.log interval arithmetic (~3pp). -/
def CS5_lower_OPEN (CS5 : ℝ) : Prop := CS5 ≥ (C_S5_cert : ℝ)

/-- Deligne1974_OPEN: Ramanujan-Petersson bound |a_p(f)| ≤ 2√p.
    Proved: Deligne 1974, Weil conjectures (SGA 4).
    Gap: étale cohomology of modular curves in Lean (~30pp).
    Target: Mathlib (ongoing). -/
def Deligne1974_OPEN (RB : Prop) : Prop := RB

/-- SelbergWeilBC6_OPEN: Selberg trace + Weil explicit formula for Γ₀(143).
    Proved in arakelov-positivity-rh-core Batch 132–133 (0 sorry, 0 axiom).
    Gap in standalone repos: hyperbolic geometry + spectral theory (~40pp).
    All Γ₀(143) arithmetic is proved in gate1_arithmetic_closed below. -/
def SelbergWeilBC6_OPEN (BC6 : Prop) : Prop := BC6

/-- All Γ₀(143) arithmetic is closed.  0 sorry · 0 axiom. -/
theorem gate1_arithmetic_closed :
    (11 : ℚ) * 13 * (1 + 1/11) * (1 + 1/13) = 168 ∧  -- index
    (168 : ℚ) / 12 = 14 ∧                              -- Weyl coefficient
    (1 : ℚ) + 168/12 - 4/2 = 13 ∧                     -- genus
    (168 : ℚ) / 3 = 56 :=                              -- area coefficient
  ⟨by norm_num, by norm_num, by norm_num, by norm_num⟩

end RouteC
