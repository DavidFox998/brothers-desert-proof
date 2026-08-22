-- Investigation 11: Narrow down propext dependency for myDiv
-- The issue may be in nlinarith or omega introducing propext
-- Let's isolate: does nlinarith use propext?

-- First: check if_pos and if_neg are propext-free (confirmed above)
-- Check dif_pos, dif_neg
#print axioms @dif_neg
#print axioms @dif_pos

-- Check nlinarith 
example (p n : Nat) (hp : 0 < p) : ¬ (p * (n + 1) < p) := by
  nlinarith [Nat.zero_le n]

-- Check what Quot.sound is doing here
-- Quot.sound is needed for quotient types, which appear in... what?
-- Could be Decidable instance for propositional equality

-- Manual proof without nlinarith:
example (p n : Nat) (hp : 0 < p) : ¬ (p * (n + 1) < p) := by
  intro h
  have : p * (n + 1) ≥ p * 1 := Nat.mul_le_mul_left p (Nat.succ_le_succ (Nat.zero_le n))
  rw [Nat.mul_one] at this
  exact Nat.lt_irrefl p (Nat.lt_of_le_of_lt this h)

#print axioms Nat.mul_le_mul_left
#print axioms Nat.succ_le_succ
#print axioms Nat.zero_le

-- Check omega specifically
example (p n : Nat) (hp : 0 < p) : p * (n + 1) - p = p * n := by
  cases n with
  | zero => simp [Nat.mul_one, Nat.sub_self]
  | succ m => 
    rw [Nat.mul_add, Nat.mul_one]
    rw [Nat.add_sub_cancel]

#print axioms @Nat.add_sub_cancel
