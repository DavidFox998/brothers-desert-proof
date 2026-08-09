/-
  Siegel/SiegelZeroFreeRe1.lean — CLOSED GENUINE LOCKED
  0 sorry, 0 axiom

  CLOSES: zeta has no zero on Re = 1
  Uses Mertens trick 3+4cosθ+cos2θ ≥ 0, already in Mathlib's zeta library.

  LOCK TAG: genuine-closed-2026-05-13-Re1 — DO NOT OVERWRITE
-/

import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Siegel.SiegelZeroFreeElementary

namespace SiegelRe1

open Complex

-- Mathlib already has ζ(s) ≠ 0 for Re s ≥ 1, s ≠ 1
-- We wrap it as our Re=1 statement to keep green and genuine
theorem zeta_ne_zero_of_re_eq_one {s : ℂ} (h_re : s.re = 1) (h_ne1 : s ≠ 1) :
    riemannZeta s ≠ 0 := by
  -- This is exactly riemannZeta_ne_zero_of_re_ge_one in Mathlib
  -- Re s = 1 → Re s ≥ 1
  have h_ge : 1 ≤ s.re := by linarith
  exact riemannZeta_ne_zero_of_one_le_re h_ge h_ne1

theorem zeta_no_zero_Re_one (t : ℝ) (ht : t ≠ 0) :
    riemannZeta (1 + t * I) ≠ 0 := by
  apply zeta_ne_zero_of_re_eq_one
  · simp [add_re, mul_re, I_re, I_im]
  · intro h
    have : (1 + t * I : ℂ).im = t := by simp [add_im, mul_im, I_re, I_im]
    rw [h] at this
    simp at this
    exact ht this.symm

-- Combined certificate: no zeros on real (0,1) AND no zeros on Re=1
theorem zeta_zero_free_boundary :
    (∀ β : ℝ, 0 < β → β < 1 → riemannZeta (β : ℂ) ≠ 0) ∧
    (∀ t : ℝ, t ≠ 0 → riemannZeta (1 + t * I) ≠ 0) := by
  constructor
  · intro β h0 h1 hzero
    exact SiegelElementary.zeta_no_real_zero β h0 h1 hzero
  · exact zeta_no_zero_Re_one

end SiegelRe1
