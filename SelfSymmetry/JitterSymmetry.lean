-- SelfSymmetry/JitterSymmetry.lean
-- π/10 jitter stays Nodup for all 1419 time steps
import Family.Brothers1419
import Family.DirichletJitterTime

namespace SelfSymmetry

open Eutheos

/-! ## Jitter self-symmetry -/

-- From Irrational (299 + π/10) we get Irrational (π/10)
private theorem pi_div_ten_irrational : Irrational (Real.pi / 10) := by
  intro ⟨q, hq⟩
  have h2 : Irrational (299 + Real.pi / 10) := alpha0_irrational
  apply h2
  refine ⟨299 + q, ?_⟩
  -- (299 + q : ℚ) as ℝ = 299 + (π/10)
  rw [← hq]
  push_cast
  ring

-- alpha0 = π/10 in Brothers1419, definitionally
theorem jitter_alpha0_irrational : Irrational alpha0 := by
  have h_eq : alpha0 = Real.pi / 10 := rfl
  rw [h_eq]
  exact pi_div_ten_irrational

-- 35 jitter values stay distinct across all 1420 time steps
theorem jitter_Nodup_1419 : all_jitters_Nodup_upto 1419 = true := by native_decide

-- EMI reduction: spreading 35 brothers gives > 30 dB attenuation
theorem jitter_emi_reduction :
    (20 : ℝ) * Real.log (1 / 35) / Real.log 10 < -30 := emi_reduction_db

/-! ## Jitter certificate -/
theorem jitter_clean :
    all_jitters_Nodup_upto 1419 = true ∧
    Irrational alpha0 :=
  ⟨by native_decide, jitter_alpha0_irrational⟩

end SelfSymmetry
