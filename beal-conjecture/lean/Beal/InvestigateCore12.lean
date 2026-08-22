-- Investigation 12: Test propext-free arithmetic lemmas
-- Important: #print axioms @X syntax needs @

#print axioms Nat.add_sub_cancel
#print axioms Nat.mul_add
#print axioms Nat.mul_le_mul_left

-- Test: minimal approach for p*(n+1)-p = p*n
example (p n : Nat) (hp : 0 < p) : p * (n + 1) - p = p * n := by
  cases n with
  | zero => simp [Nat.mul_one, Nat.sub_self]
  | succ m => 
    rw [Nat.mul_add, Nat.mul_one]
    rw [Nat.add_sub_cancel]

#print axioms Nat.sub_self
