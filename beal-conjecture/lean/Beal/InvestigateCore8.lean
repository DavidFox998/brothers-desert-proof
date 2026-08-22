-- Investigation 8: propext-free strong induction proof of N/p * p = N
-- Using only Nat.div_eq (propext-free) and structural properties

-- Key insight from Nat.div_eq:
-- x / y = if 0 < y ∧ y ≤ x then (x - y) / y + 1 else 0
-- This is definitional / computable. The ite rewriting still needs propext.

-- But maybe we can use Nat.decideEq or decide for specific cases?
-- Or perhaps kernel-recursive proof that avoids ite rewriting?

-- Let me check: what IS the minimal axiom set for Lean 4.12 kernel?
#print axioms rfl  -- should show empty

-- Let's see if we can prove div*mul through a custom recursion
-- that stays propext-free.

-- The problem: to prove N/p * p = N from ∃ k, N = p * k,
-- we need to show p * k / p = k.
-- By Nat.div_eq: p*k / p = if 0 < p ∧ p ≤ p*k then (p*k - p)/p + 1 else 0
-- This requires: knowing 0 < p (ok from hp), p ≤ p*k (ok from k≥1 when k>0)
-- The ite rewriting step: Nat.div_eq gives us the equation but to REWRITE
-- inside the ite, we need to reduce the condition, which uses propext through
-- ite_cond_eq_true.

-- FINDING: The propext dependence in Nat.mul_div_cancel originates in
-- Nat.add_mul_div_right, which traces through Nat.mod_add_div or similar.
-- Specifically the culprit is the proof of Nat.mod_add_div using
-- ite_cond_eq_true (from congr) which needs propext to rewrite 
-- Boolean-to-Prop coercions.

-- Is there a way around this? In principle, a DIRECT computation-style proof
-- could avoid propext by only using:
-- 1. Nat.div as a definition (computation)  
-- 2. Well-founded recursion (no propext)
-- 3. Nat arithmetic lemmas that don't use propext

-- Let's check Nat.zero_add, Nat.add_succ etc. - pure structural:
#print axioms Nat.add_succ  -- should be propext-free
#print axioms Nat.succ_add  -- should be propext-free

-- The propext-free path:
-- Theorem: p*k / p = k proved by induction on k
theorem my_mul_div_cancel_aux (p k : Nat) (hp : 0 < p) : p * k / p = k := by
  induction k with
  | zero => 
    simp [Nat.mul_zero, Nat.zero_div]
  | succ n ih =>
    rw [Nat.mul_succ]
    rw [show p * n + p = p + p * n from by ring]
    rw [Nat.add_div_left _ hp]
    rw [ih]

#print axioms my_mul_div_cancel_aux

-- If this works propext-free, we can derive:
theorem my_div_mul_cancel (p N : Nat) (hp : 0 < p) (h : p ∣ N) : N / p * p = N := by
  obtain ⟨k, hk⟩ := h
  rw [hk, Nat.mul_div_cancel_left k hp, Nat.mul_comm]

-- Wait, Nat.mul_div_cancel_left needs propext. Let me use my_mul_div_cancel_aux:
theorem my_div_mul_cancel2 (p N : Nat) (hp : 0 < p) (h : p ∣ N) : N / p * p = N := by
  obtain ⟨k, hk⟩ := h
  subst hk
  rw [Nat.mul_comm p k, Nat.mul_div_cancel _ hp]

#print axioms my_div_mul_cancel2
