-- Investigation 14: Check Nat.add_sub_add_right
#print axioms Nat.add_sub_add_right

-- And try to prove our subtraction fact propext-free using 
-- Nat.succ_sub_succ_eq_sub (propext-free) only

-- Key propext-free facts so far:
-- Nat.sub_self : n - n = 0 ✓ propext-free
-- Nat.sub_zero : n - 0 = n ✓ propext-free
-- Nat.succ_sub_succ_eq_sub : (n+1) - (m+1) = n - m ✓ propext-free
-- Nat.zero_sub : 0 - n = 0 ✓ propext-free
-- Nat.mul_add : p*(n+m) = p*n + p*m ✓ propext-free
-- if_pos, if_neg ✓ propext-free
-- Nat.mul_le_mul_left ✓ propext-free
-- Nat.lt_irrefl ✓ propext-free
-- Nat.zero_le ✓ propext-free

-- So: p*(n+1) - p = p*n using ONLY propext-free facts:
-- p*(n+1) = p*n + p*1 = p*n + p  (by mul_add)
-- (p*n + p) - p = p*n            (need add_sub_cancel or equiv)
-- add_sub_cancel uses propext via Nat.add_sub_add_right - let's check:
#print axioms Nat.add_sub_add_right

-- If Nat.add_sub_add_right needs propext too, we need another path.
-- Alternative: prove n + p - p = n by induction on p:
-- Base: n + 0 - 0 = n - 0 = n ✓ (sub_zero)
-- Step: n + (p+1) - (p+1) = (n+p+1) - (p+1) = (n+p) - p = n (by IH, succ_sub_succ)

theorem my_add_sub_cancel_right (n p : Nat) : n + p - p = n := by
  induction p with
  | zero => 
    rw [Nat.add_zero, Nat.sub_zero]
  | succ m ih =>
    rw [Nat.add_succ, Nat.succ_sub_succ_eq_sub]
    exact ih

#print axioms my_add_sub_cancel_right

-- Now prove: p * (n + 1) - p = p * n without propext:
theorem my_mul_sub (p n : Nat) : p * (n + 1) - p = p * n := by
  rw [Nat.mul_add, Nat.mul_one, my_add_sub_cancel_right]

#print axioms my_mul_sub
