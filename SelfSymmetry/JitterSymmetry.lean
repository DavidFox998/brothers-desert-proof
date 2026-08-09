-- SelfSymmetry/JitterSymmetry.lean
-- π/10 jitter stays Nodup for all 1419 time steps
import Family.Brothers1419
import Family.DirichletJitterTime
import Mathlib.Data.Real.Irrational

namespace SelfSymmetry

open Eutheos

/-! ## Jitter self-symmetry -/

-- Prove Irrational (π/10) from Irrational (299 + π/10)
private theorem pi_div_ten_irrational : Irrational (Real.pi / 10) := by
  by_contra h
  -- if π/10 = q ∈ ℚ, then 299 + π/10 = 299 + q ∈ ℚ
  have h2 : Irrational (299 + Real.pi / 10) := alpha0_irrational
  apply h2
  obtain ⟨q, hq⟩ := h
  refine ⟨299 + q, ?_⟩
  rw [← hq]
  push_cast
  rfl

-- Now lift to whatever Brothers1419 defines alpha0 as (π/10)
theorem jitter_alpha0_irrational : Irrational alpha0 := by
  -- alpha0 = π/10 in Brothers1419
  have h_def : alpha0 = Real.pi / 10 := by
    unfold alpha0
    rfl
  rw [h_def]
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
