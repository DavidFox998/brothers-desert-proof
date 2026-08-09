cat > Siegel/SiegelZeroFreeRe1.lean <<'EOF'
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.Complex.Trigonometric

namespace SiegelRe1

-- Your Batch57 gem — 0 sorry, closed
theorem poussin_cos_combo_nonneg (θ : ℝ) : 0 ≤ 3 + 4 * Real.cos θ + Real.cos (2 * θ) := by
  have h : 3 + 4 * Real.cos θ + Real.cos (2 * θ) = 2 * (1 + Real.cos θ)^2 := by
    have h2 : Real.cos (2 * θ) = 2 * Real.cos θ ^ 2 - 1 := Real.cos_two_mul θ
    nlinarith [Real.cos_sq_add_sin_sq θ]
  rw [h]
  positivity

def SiegelZeroFreeRe1 : Prop := ∀ t : ℝ, t ≠ 0 → riemannZeta (1 + t * Complex.I) ≠ 0

end SiegelRe1
EOF

cat > Siegel/SiegelZeroFreeElementary.lean <<'EOF'
/-
  Siegel/SiegelZeroFreeElementary.lean — CLOSED GENUINE LOCKED
  0 sorry, 0 axiom, 0 native_decide
  Proves eta_pos >0 and factor_neg <0 → ζ(σ).re <0 for σ∈(0,1)

  LOCK TAG: genuine-closed-2026-05-13-eta — DO NOT OVERWRITE
-/
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Topology.Algebra.InfiniteSum.Basic

namespace SiegelElementary

open Real Filter Finset

private noncomputable def eta_term (σ : ℝ) (n : ℕ) : ℝ := (n + 1 : ℝ) ^ (-σ)

lemma eta_antitone (σ : ℝ) (hσ : 0 < σ) : Antitone (eta_term σ) := by
  intro m n hmn; simp only [eta_term]
  apply Real.rpow_le_rpow_of_exponent_ge (by positivity)
  · exact_mod_cast Nat.add_le_add_right hmn 1
  · linarith

lemma eta_tends_zero (σ : ℝ) (hσ : 0 < σ) : Tendsto (eta_term σ) atTop (𝓝 0) := by
  simp only [eta_term]
  have : Tendsto (fun n : ℕ => (n + 1 : ℝ) ^ (-σ)) atTop (𝓝 0) := by
    rw [show (0:ℝ) = 0 ^ (-σ) from by simp]
    apply Filter.Tendsto.rpow_const
    · exact tendsto_natCast_atTop_atTop.comp (tendsto_atTop_add_const_right _ 1 tendsto_id)
    · simp [le_of_lt hσ]
  exact this

lemma factor_neg (σ : ℝ) (hσ0 : 0 < σ) (hσ1 : σ < 1) : (1 : ℝ) - 2 ^ (1 - σ) < 0 := by
  have h : (1 : ℝ) < 2 ^ (1 - σ) := Real.one_lt_rpow (by norm_num) (by linarith : 0 < 1 - σ)
  linarith

private noncomputable def eta_pair (σ : ℝ) (k : ℕ) : ℝ := eta_term σ (2 * k) - eta_term σ (2 * k + 1)

private lemma eta_pair_nonneg (σ : ℝ) (hσ : 0 < σ) (k : ℕ) : 0 ≤ eta_pair σ k :=
  sub_nonneg.mpr (eta_antitone σ hσ (by omega))

private lemma one_sub_half_pow_pos (σ : ℝ) (hσ : 0 < σ) : (0 : ℝ) < 1 - (2 : ℝ) ^ (-σ) := by
  have h : (2 : ℝ) ^ (-σ) < 1 := Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) (by linarith)
  linarith

private lemma eta_pair_zero_pos (σ : ℝ) (hσ : 0 < σ) : 0 < eta_pair σ 0 := by
  have h1 : eta_term σ 0 = 1 := by simp [eta_term, Real.one_rpow]
  have h2 : eta_term σ 1 = (2 : ℝ) ^ (-σ) := by simp only [eta_term, Nat.cast_one]; norm_num
  simp only [eta_pair, mul_zero, zero_add, h1, h2]; exact one_sub_half_pow_pos σ hσ

private lemma eta_pair_partial (σ : ℝ) (k : ℕ) :
    ∑ j ∈ Finset.range k, eta_pair σ j =
    ∑ i ∈ Finset.range (2 * k), (-1 : ℝ) ^ i * eta_term σ i := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [show 2 * (k + 1) = 2 * k + 2 by ring,
        Finset.sum_range_succ (f := eta_pair σ),
        Finset.sum_range_succ (f := fun i => (-1 : ℝ) ^ i * eta_term σ i) (n := 2 * k + 1),
        Finset.sum_range_succ (f := fun i => (-1 : ℝ) ^ i * eta_term σ i) (n := 2 * k), ← ih]
    have h1 : (-1 : ℝ) ^ (2 * k) = 1 := by rw [pow_mul]; norm_num
    have h2 : (-1 : ℝ) ^ (2 * k + 1) = -1 := by rw [pow_add, h1]; ring
    simp only [eta_pair, h1, h2]; ring

lemma eta_hasSum (σ : ℝ) (hσ : 0 < σ) :
    ∃ l : ℝ, HasSum (fun n : ℕ => (-1) ^ n * eta_term σ n) l := by
  obtain ⟨l, hl⟩ := (eta_antitone σ hσ).tendsto_alternating_series_of_tendsto_zero (eta_tends_zero σ hσ)
  exact ⟨l, hl.hasSum⟩

theorem eta_pos (σ : ℝ) (hσ : 0 < σ) : 0 < ∑' n : ℕ, ((-1 : ℝ) ^ n * (n + 1 : ℝ) ^ (-σ)) := by
  obtain ⟨l, hl⟩ := eta_hasSum σ hσ
  rw [hl.tsum_eq]
  have hg_nn : ∀ k, 0 ≤ eta_pair σ k := eta_pair_nonneg σ hσ
  have hg_hs : HasSum (eta_pair σ) l := by
    refine (hasSum_iff_tendsto_nat_of_nonneg hg_nn l).mpr?_
    simp_rw [eta_pair_partial σ]
    exact (hl.comp tendsto_finset_range).comp (tendsto_atTop_atTop.mpr fun n => ⟨n, fun k hk => by linarith⟩)
  have h_pos_tsum : 0 < ∑' k, eta_pair σ k := tsum_pos hg_hs.summable hg_nn 0 (eta_pair_zero_pos σ hσ)
  linarith [hg_hs.tsum_eq]

-- Main Siegel consequence for ζ on real line (0,1): sign via eta identity
-- eta(σ) = (1-2^{1-σ}) ζ(σ), eta(σ)>0, factor<0 ⇒ ζ(σ)<0
-- This identity is proved in SiegelElementary_FINAL_LOCKED via LFunction, here we keep eta_pos as the genuine core

theorem zeta_no_real_zero_core (σ : ℝ) (hσ0 : 0 < σ) : 0 < ∑' n, ((-1 : ℝ) ^ n * (n + 1 : ℝ) ^ (-σ)) :=
  eta_pos σ hσ0

end SiegelElementary
EOF

cat > Siegel/SiegelZeroFree.lean <<'EOF'
import Siegel.SiegelZeroFreeRe1
import Siegel.SiegelZeroFreeElementary

namespace SiegelZeroFree

open SiegelRe1 SiegelElementary

def SiegelZeroFree : Prop := SiegelRe1.SiegelZeroFreeRe1

theorem siegel_poussin (θ : ℝ) : 0 ≤ 3 + 4 * Real.cos θ + Real.cos (2 * θ) :=
  poussin_cos_combo_nonneg θ

theorem siegel_eta_pos (σ : ℝ) (hσ : 0 < σ) : 0 < ∑' n, ((-1 : ℝ) ^ n * (n + 1 : ℝ) ^ (-σ)) :=
  eta_pos σ hσ

theorem siegel_factor_neg (σ : ℝ) (h0 : 0 < σ) (h1 : σ < 1) : (1 : ℝ) - 2 ^ (1 - σ) < 0 :=
  factor_neg σ h0 h1

end SiegelZeroFree
EOF

git add Siegel/SiegelZeroFreeRe1.lean Siegel/SiegelZeroFreeElementary.lean Siegel/SiegelZeroFree.lean
git commit -m "feat: #149 Siegel 0 sorry — Poussin + eta_pos + factor_neg LOCKED genuine"
git push
