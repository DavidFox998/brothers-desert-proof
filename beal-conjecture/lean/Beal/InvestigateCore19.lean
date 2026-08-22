-- Investigation 19: Use the equation lemma myDiv.eq_1 directly

theorem my_add_sub_cancel_right (n p : Nat) : n + p - p = n := by
  induction p with
  | zero => rw [Nat.add_zero, Nat.sub_zero]
  | succ m ih => rw [Nat.add_succ, Nat.succ_sub_succ_eq_sub]; exact ih

theorem my_mul_sub (p n : Nat) : p * (n + 1) - p = p * n := by
  rw [Nat.mul_add, Nat.mul_one, my_add_sub_cancel_right]

theorem not_mul_succ_lt_self (p k : Nat) (hp : 0 < p) : ¬ (p * (k + 1) < p) := by
  intro h
  have h1 : p * 1 ≤ p * (k + 1) := Nat.mul_le_mul_left p (Nat.succ_le_succ (Nat.zero_le k))
  rw [Nat.mul_one] at h1
  exact Nat.lt_irrefl p (Nat.lt_of_le_of_lt h1 h)

def myDiv (N p : Nat) : Nat :=
  if p = 0 ∨ N < p then 0
  else myDiv (N - p) p + 1
termination_by N
decreasing_by
  rename_i h
  have hp : p ≠ 0 := fun e => h (Or.inl e)
  have hge : p ≤ N := Nat.le_of_not_lt (fun e => h (Or.inr e))
  exact Nat.sub_lt (Nat.lt_of_lt_of_le (Nat.pos_of_ne_zero hp) hge) (Nat.pos_of_ne_zero hp)

-- Use the equation lemma:
-- myDiv.eq_1 : myDiv N p = if p = 0 ∨ N < p then 0 else myDiv (N - p) p + 1

theorem myDiv_lt (N p : Nat) (h : p = 0 ∨ N < p) : myDiv N p = 0 := by
  rw [myDiv.eq_1, if_pos h]

theorem myDiv_ge (N p : Nat) (h : ¬ (p = 0 ∨ N < p)) : myDiv N p = myDiv (N - p) p + 1 := by
  rw [myDiv.eq_1, if_neg h]

#print axioms myDiv_lt
#print axioms myDiv_ge

-- myDiv_lt uses if_pos which is propext-free. But does ∨ introduce issues?
-- Actually: the issue might be that `h : p = 0 ∨ N < p` uses ∨ 
-- and `if_pos` needs `Decidable (p = 0 ∨ N < p)`.
-- Does the `if` in myDiv.eq_1 have a Decidable instance?

-- Wait: our definition uses `if p = 0 ∨ N < p then...`
-- The ∨ of two Decidable props is Decidable. 
-- Nat.decEq for p = 0, and Nat.decLt for N < p.
-- So the Decidable instance is constructed propext-free? Let's check.

-- The real issue: does propext.eq_1 itself use propext?
#print axioms myDiv.eq_1

-- If myDiv.eq_1 is propext-free but if_pos for OR uses propext...
-- Let's check:
#print axioms @Or.decidable  -- if this exists
