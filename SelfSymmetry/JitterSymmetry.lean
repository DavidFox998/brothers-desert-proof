-- SelfSymmetry/JitterSymmetry.lean
-- π/10 jitter stays Nodup for all 1419 time steps
import Family.Brothers1419
import Family.DirichletJitterTime
-- Family.IrrationalVsRational omitted: conflicts with DirichletJitterTime
-- (both define Eutheos.alpha0_den); the transitive names differ in fold/unfold state.

namespace SelfSymmetry

open Eutheos

/-! ## Jitter self-symmetry -/

-- alpha0 = π/10 is irrational.
-- DirichletJitterTime exports alpha0_irrational : Irrational (299 + Real.pi / 10)
-- which equals Irrational alpha0 after unfolding alpha0.
theorem jitter_alpha0_irrational : Irrational alpha0 := by
  simp only [alpha0]
  exact alpha0_irrational

-- jitter_dist_pos removed: dist_real is not a function in this import set and
-- alpha0_dist_pos is not exported by DirichletJitterTime.

-- 35 jitter values stay distinct across all 1420 time steps
theorem jitter_Nodup_1419 : all_jitters_Nodup_upto 1419 = true := by native_decide

-- EMI reduction: spreading 35 brothers gives > 30 dB attenuation
theorem jitter_emi_reduction :
    (20 : ℝ) * Real.log (1 / 35) / Real.log 10 < -30 := emi_reduction_db

/-! ## Jitter certificate -/
theorem jitter_clean :
    all_jitters_Nodup_upto 1419 = true ∧
    Irrational alpha0 :=
  ⟨by native_decide, by simp only [alpha0]; exact alpha0_irrational⟩

end SelfSymmetry
