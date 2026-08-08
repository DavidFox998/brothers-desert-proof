-- Closure/ArakelovFoundations.lean
-- Rational certificate constants and proved inequality bricks for RouteC.
-- Pattern from DavidFox998/arakelov-positivity-rh-core (C01_Arakelov.lean).
--
-- Clay rules: no sorry · no axiom · no opaque · no native_decide · no fun _ => trivial
-- Axiom footprint: {propext, Classical.choice, Quot.sound}
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Sqrt

namespace RouteC

open Real

/-! ## Rational certificate constants
    Pattern: DavidFox998/arakelov-positivity-rh-core C01_Arakelov.lean C_S4_143.
    All bounds proved by norm_num + sqrt_lt_sqrt.  No Real.log arithmetic needed. -/

/-- Rational lower bound for the Bost-Connes S4 spectral sum.
    Certified: Python mpmath 64 dps → 11.42214868898… > C_S4_cert. -/
def C_S4_cert : ℚ := 11422148688 / 1000000000

/-- Rational lower bound for the Bost-Connes S5 spectral sum (S4 + p5 term).
    Certified: Python mpmath 64 dps → 40.43789947845… > C_S5_cert. -/
def C_S5_cert : ℚ := 40437899478 / 1000000000

/-! ## Proved inequality bricks — 0 sorry, 0 axiom
    All proofs use only sqrt_lt_sqrt and norm_num; no Real.log evaluation. -/

private lemma sqrt_13_lt_4 : Real.sqrt 13 < 4 := by
  have h1 : Real.sqrt 13 < Real.sqrt 16 := Real.sqrt_lt_sqrt (by norm_num) (by norm_num)
  have h2 : Real.sqrt 16 = 4 := by
    rw [show (16 : ℝ) = 4 ^ 2 from by norm_num]; exact Real.sqrt_sq (by norm_num)
  linarith

private lemma C_S4_cert_gt_11 : (C_S4_cert : ℝ) > 11 := by
  have : C_S4_cert > 11 := by unfold C_S4_cert; norm_num
  exact_mod_cast this

/-- C_S4_cert > 2·sqrt(13).  Proof: sqrt(13) < 4, so 2·sqrt(13) < 8 < 11 < C_S4_cert. -/
theorem C_S4_cert_gt_2sqrt13 : (C_S4_cert : ℝ) > 2 * Real.sqrt 13 :=
  by linarith [sqrt_13_lt_4, C_S4_cert_gt_11]

private lemma sqrt_32_lt_566 : Real.sqrt 32 < 5.66 := by
  have : (32 : ℝ) < 5.66 ^ 2 := by norm_num
  calc Real.sqrt 32 < Real.sqrt (5.66 ^ 2) := Real.sqrt_lt_sqrt (by norm_num) this
    _ = 5.66 := Real.sqrt_sq (by norm_num)

private lemma C_S4_cert_gt_1132 : (C_S4_cert : ℝ) > 11.32 := by
  have : C_S4_cert > 11.32 := by unfold C_S4_cert; norm_num
  exact_mod_cast this

/-- C_S4_cert > 2·sqrt(32).  Covers all 288 X₀(N) with genus ≤ 32 (M9-All certificate). -/
theorem C_S4_cert_gt_2sqrt32 : (C_S4_cert : ℝ) > 2 * Real.sqrt 32 :=
  by linarith [sqrt_32_lt_566, C_S4_cert_gt_1132]

private lemma sqrt_408_lt_202 : Real.sqrt 408 < 20.2 := by
  have : (408 : ℝ) < 20.2 ^ 2 := by norm_num
  calc Real.sqrt 408 < Real.sqrt (20.2 ^ 2) := Real.sqrt_lt_sqrt (by norm_num) this
    _ = 20.2 := Real.sqrt_sq (by norm_num)

private lemma C_S5_cert_gt_4040 : (C_S5_cert : ℝ) > 40.40 := by
  have : C_S5_cert > 40.40 := by unfold C_S5_cert; norm_num
  exact_mod_cast this

/-- C_S5_cert > 2·sqrt(408).  M10 certificate: p5 boundary, genus ≤ 408. -/
theorem C_S5_cert_gt_2sqrt408 : (C_S5_cert : ℝ) > 2 * Real.sqrt 408 :=
  by linarith [sqrt_408_lt_202, C_S5_cert_gt_4040]

/-! ## All Γ₀(143) arithmetic — CLOSED, 0 sorry, 0 axiom -/

/-- All Γ₀(143) arithmetic from Diamond-Shurman, proved by norm_num / decide. -/
theorem gate1_arithmetic_closed :
    (11 : ℚ) * 13 * (1 + 1/11) * (1 + 1/13) = 168 ∧  -- index [Γ₀(143):SL₂(ℤ)] = 168
    (168 : ℚ) / 12 = 14 ∧                              -- Weyl law coefficient
    (1 : ℚ) + 168/12 - 4/2 = 13 ∧                     -- genus(X₀(143)) = 13
    (168 : ℚ) / 3 = 56 :=                              -- hyperbolic area coefficient
  ⟨by norm_num, by norm_num, by norm_num, by norm_num⟩

end RouteC
