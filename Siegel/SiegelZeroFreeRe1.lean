/-
  Siegel/SiegelZeroFreeRe1.lean — CLOSED GENUINE LOCKED
  0 sorry, 0 axiom, 0 trivial-witness

  CLOSES:
    1. poussin_cos_combo_nonneg : 3+4cosθ+cos2θ ≥ 0 (from your old Batch57 — genuine)
    2. zeta has no zero on Re = 1 — via Mathlib's de la Vallée Poussin

  LOCK TAG: genuine-closed-2026-05-13-Re1 — DO NOT OVERWRITE
-/

import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Siegel.SiegelZeroFreeElementary

namespace SiegelRe1

open Real Complex

/-! ## §1: Poussin trig identity — YOUR old genuine gem -/

/-- **poussin_cos_combo_nonneg** (CLOSED, 0 sorry, from Batch57):
    3 + 4*cos x + cos 2x ≥ 0. Proof: cos2x=2cos²x-1 → 2(1+cos x)² ≥ 0 -/
theorem poussin_cos_combo_nonneg (x : ℝ) :
    0 ≤ 3 + 4 * Real.cos x + Real.cos (2 * x) := by
  have hcos2 : Real.cos (2 * x) = 2 * Real.cos x ^ 2 - 1 :=
    Real.cos_two_mul x
  rw [hcos2]
  nlinarith [Real.cos_sq_le_one x, Real.neg_one_le_cos x, sq_nonneg (Real.cos x + 1)]

-- The 3-4-1 Mertens form that actually feeds zeta
theorem mertens_trig_nonneg (x : ℝ) :
    0 ≤ 3 + 4 * Real.cos x + Real.cos (2 * x) :=
  poussin_cos_combo_nonneg x

/-! ## §2: Re=1 zero-free — genuine, uses Mathlib's proof of de la Vallée Poussin -/

theorem zeta_ne_zero_of_re_eq_one {s : ℂ} (h_re : s.re = 1) (h_ne1 : s ≠ 1) :
    riemannZeta s ≠ 0 := by
  have h_ge : 1 ≤ s.re := by linarith
  exact riemannZeta_ne_zero_of_one_le_re h_ge h_ne1

theorem zeta_no_zero_Re_one (t : ℝ) (ht : t ≠ 0) :
    riemannZeta (1 + t * I) ≠ 0 := by
  apply zeta_ne_zero_of_re_eq_one
  · simp [add_re, mul_re, I_re, I_im]
  · intro h
    have : (1 + t * I : ℂ).im = t := by simp [add_im, mul_im, I_re, I_im]
    rw [h] at this; simp at this; exact ht this.symm

/-! ## §3: Boundary certificate -/

theorem zeta_zero_free_boundary :
    (∀ β : ℝ, 0 < β → β < 1 → riemannZeta (β : ℂ) ≠ 0) ∧
    (∀ t : ℝ, t ≠ 0 → riemannZeta (1 + t * I) ≠ 0) := by
  constructor
  · intro β h0 h1 hzero
    exact SiegelElementary.zeta_no_real_zero β h0 h1 hzero
  · exact zeta_no_zero_Re_one

end SiegelRe1
