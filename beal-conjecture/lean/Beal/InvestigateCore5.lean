-- Investigation 5: Can we avoid propext entirely for N/p * p = N?
-- The issue: Nat.mod_add_div uses propext via ite_cond_eq_true/and_self.
-- Let's check if there's a propext-free path.

-- Option A: Use Nat.eq_mul_of_div_eq_right or similar
#check @Nat.eq_mul_of_div_eq_right
-- Probably doesn't exist in core

-- Option B: Try omega/decide on small cases
-- omega can prove arithmetic without propext if it works from hypotheses

-- Check if omega tactic itself introduces propext
example (N p : Nat) (h : p ∣ N) (hp : 2 ≤ p) : N / p * p = N := by
  exact Nat.div_mul_cancel h

#print axioms Nat.div_add_mod
-- Nat.div_add_mod : n * (m / n) + m % n = m -- this might be the one
-- Wait, I saw Nat.mod_add_div above. Let me check the other direction.

-- Let's investigate: does Nat.mod_add_div really need propext or is there a version that doesn't?
-- The proof uses ite_cond_eq_true which uses propext.

-- Option C: Can we prove it purely by kernel recursion?
-- Define our own divides-based proof:

theorem my_div_mul (p N k : Nat) (h : N = p * k) (hp : 0 < p) : N / p * p = N := by
  rw [h, Nat.mul_div_cancel_left k hp, Nat.mul_comm]

#print axioms my_div_mul

-- Nat.mul_div_cancel_left: does it need propext?
#print axioms Nat.mul_div_cancel_left
