/-
  Siegel/SiegelZeroFreeElementary.lean
  ELEMENTARY SIEGEL ZERO REPULSION — eta pair-sum positivity.

  SORRY COUNT: 0
  AXIOM FOOTPRINT: classical trio (propext, funext, choice) via Mathlib imports

  What is proved here (0 sorry):
    eta_antitone   — (n+1)^(-σ) is antitone in n for σ > 0
    eta_tends_zero — (n+1)^(-σ) → 0 for σ > 0
    factor_neg     — 1 - 2^(1-σ) < 0 for σ ∈ (0,1)
    eta_pair_nonneg, eta_pair_zero_pos, eta_pair_partial — pair-telescoping lemmas
    eta_pos        — ∑' k, (η₂ₖ − η₂ₖ₊₁) > 0 for all σ > 0

  What is NOT proved here (pending Lean formalization):
    The connection to ζ(σ).  The eta identity (1−2^{1−σ})·ζ(σ) = η(σ) holds for Re(s)>1
    by algebraic manipulation and extends to Re(s)∈(0,1) by the identity theorem for
    holomorphic functions.  That analytic-continuation step is not yet in Lean; until it is,
    "ζ(σ) < 0 for σ∈(0,1)" is not concluded from the lemmas in this file alone.

  Lean/Mathlib version: v4.15.0 / mathlib4 pin 9837ca9
-/
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics
import Mathlib.Topology.Algebra.InfiniteSum.Order

namespace SiegelElementary

open Real Filter Finset

private noncomputable def eta_term (σ : ℝ) (n : ℕ) : ℝ := (n + 1 : ℝ) ^ (-σ)

/-- (n+1)^(-σ) is antitone in n for σ > 0: a larger index gives a smaller term. -/
lemma eta_antitone (σ : ℝ) (hσ : 0 < σ) : Antitone (eta_term σ) := by
  intro m n hmn
  simp only [eta_term]
  have hm : (0 : ℝ) < (m : ℝ) + 1 := by positivity
  have hn : (0 : ℝ) < (n : ℝ) + 1 := by positivity
  have hmn' : (m : ℝ) + 1 ≤ (n : ℝ) + 1 := by exact_mod_cast Nat.add_le_add_right hmn 1
  rw [Real.rpow_neg (le_of_lt hm), Real.rpow_neg (le_of_lt hn)]
  exact inv_anti₀ (Real.rpow_pos_of_pos hm σ)
    (Real.rpow_le_rpow (le_of_lt hm) hmn' (le_of_lt hσ))

/-- (n+1)^(-σ) → 0 for σ > 0. -/
lemma eta_tends_zero (σ : ℝ) (hσ : 0 < σ) : Tendsto (eta_term σ) atTop (nhds 0) := by
  show Tendsto (fun n : ℕ => ((n : ℝ) + 1) ^ (-σ)) atTop (nhds 0)
  exact (tendsto_rpow_neg_atTop hσ).comp
    (tendsto_atTop_add_const_right _ 1 tendsto_natCast_atTop_atTop)

/-- 1 - 2^(1-σ) < 0 for σ ∈ (0,1): the eta pre-factor is negative there. -/
lemma factor_neg (σ : ℝ) (_ : 0 < σ) (hσ1 : σ < 1) : (1 : ℝ) - 2 ^ (1 - σ) < 0 := by
  have h : (1 : ℝ) < 2 ^ (1 - σ) :=
    Real.one_lt_rpow (by norm_num) (by linarith : 0 < 1 - σ)
  linarith

/-- Consecutive pair difference of eta terms: η₂ₖ − η₂ₖ₊₁ = (2k+1)^{−σ} − (2k+2)^{−σ}. -/
noncomputable def eta_pair (σ : ℝ) (k : ℕ) : ℝ :=
  eta_term σ (2 * k) - eta_term σ (2 * k + 1)

private lemma eta_pair_nonneg (σ : ℝ) (hσ : 0 < σ) (k : ℕ) : 0 ≤ eta_pair σ k :=
  sub_nonneg.mpr (eta_antitone σ hσ (by omega))

private lemma one_sub_half_pow_pos (σ : ℝ) (hσ : 0 < σ) : (0 : ℝ) < 1 - (2 : ℝ) ^ (-σ) := by
  have h : (2 : ℝ) ^ (-σ) < 1 :=
    Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) (by linarith)
  linarith

private lemma eta_pair_zero_pos (σ : ℝ) (hσ : 0 < σ) : 0 < eta_pair σ 0 := by
  have h1 : eta_term σ 0 = 1 := by simp [eta_term, Real.one_rpow]
  have h2 : eta_term σ 1 = (2 : ℝ) ^ (-σ) := by
    simp only [eta_term, Nat.cast_one]; norm_num
  simp only [eta_pair, mul_zero, zero_add, h1, h2]
  exact one_sub_half_pow_pos σ hσ

/-- Even partial sums of the alternating series equal the pair-sum partial sums. -/
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

/-- The tsum of consecutive pair differences of the eta series is positive for all σ > 0.
    This is the verified combinatorial core of the Siegel zero-repulsion argument.
    Connecting this to ζ(σ) < 0 on (0,1) requires the eta identity and analytic continuation
    of the Dirichlet series; those steps are not yet in Lean. -/
theorem eta_pos (σ : ℝ) (hσ : 0 < σ) : 0 < ∑' k : ℕ, eta_pair σ k := by
  obtain ⟨l, hl⟩ :=
    (eta_antitone σ hσ).tendsto_alternating_series_of_tendsto_zero (eta_tends_zero σ hσ)
  have hg_nn : ∀ k, 0 ≤ eta_pair σ k := eta_pair_nonneg σ hσ
  -- The alternating series test gives tendsto of even-indexed partial sums to l.
  -- eta_pair_partial equates those to pair-sum partial sums.
  have hl_pair : Tendsto (fun k => ∑ j ∈ Finset.range k, eta_pair σ j) atTop (nhds l) := by
    simp_rw [eta_pair_partial]
    exact hl.comp (tendsto_atTop_atTop.mpr fun n => ⟨n, fun k hk => by omega⟩)
  -- For non-negative eta_pair, HasSum ↔ Tendsto of partial sums.
  have hg_hs : HasSum (eta_pair σ) l :=
    (hasSum_iff_tendsto_nat_of_nonneg hg_nn l).mpr hl_pair
  -- eta_pair 0 > 0, so the tsum is positive.
  exact hg_hs.tsum_eq ▸ tsum_pos hg_hs.summable hg_nn 0 (eta_pair_zero_pos σ hσ)

/-- The verified core of the Siegel zero-free argument for the eta series:
    consecutive pair differences telescope to a positive sum for every σ > 0. -/
theorem zeta_no_real_zero_core (σ : ℝ) (hσ0 : 0 < σ) : 0 < ∑' k : ℕ, eta_pair σ k :=
  eta_pos σ hσ0

end SiegelElementary
