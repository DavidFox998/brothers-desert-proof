-- Investigation 16: Fix the custom div and prove the helper lemmas correctly

-- Propext-free established lemmas:
theorem my_add_sub_cancel_right (n p : Nat) : n + p - p = n := by
  induction p with
  | zero => rw [Nat.add_zero, Nat.sub_zero]
  | succ m ih => rw [Nat.add_succ, Nat.succ_sub_succ_eq_sub]; exact ih

theorem my_mul_sub (p n : Nat) : p * (n + 1) - p = p * n := by
  rw [Nat.mul_add, Nat.mul_one, my_add_sub_cancel_right]

-- Propext-free non-lt:
theorem not_mul_succ_lt_self (p k : Nat) (hp : 0 < p) : ¬ (p * (k + 1) < p) := by
  intro h
  have h1 : p * 1 ≤ p * (k + 1) := Nat.mul_le_mul_left p (Nat.succ_le_succ (Nat.zero_le k))
  rw [Nat.mul_one] at h1
  exact Nat.lt_irrefl p (Nat.lt_of_le_of_lt h1 h)

-- Custom div with decidable condition:
def myDiv (N p : Nat) : Nat :=
  if p = 0 then 0
  else if N < p then 0
  else myDiv (N - p) p + 1
termination_by N
decreasing_by
  rename_i hp hlt
  have hp' : 0 < p := Nat.pos_of_ne_zero hp
  have hge : p ≤ N := Nat.le_of_not_lt hlt
  exact Nat.sub_lt (Nat.lt_of_lt_of_le hp' hge) hp'

-- Helper: myDiv N p = 0 when N < p and p ≠ 0
theorem myDiv_lt (N p : Nat) (hp : p ≠ 0) (h : N < p) : myDiv N p = 0 := by
  unfold myDiv
  rw [if_neg hp, if_pos h]

-- Helper: myDiv N p = myDiv (N-p) p + 1 when p ≠ 0 and p ≤ N
theorem myDiv_ge (N p : Nat) (hp : p ≠ 0) (h : ¬ N < p) : myDiv N p = myDiv (N - p) p + 1 := by
  unfold myDiv
  rw [if_neg hp, if_neg h]

#print axioms myDiv_lt
#print axioms myDiv_ge

-- Now the main theorem: myDiv (p*k) p = k
theorem myDiv_mul_cancel (p k : Nat) (hp : 0 < p) : myDiv (p * k) p = k := by
  have hp0 : p ≠ 0 := Nat.not_eq_zero_of_lt hp
  induction k with
  | zero =>
    rw [Nat.mul_zero]
    rw [myDiv_lt 0 p hp0 hp]
  | succ n ih =>
    have hge : ¬ (p * (n + 1) < p) := not_mul_succ_lt_self p n hp
    rw [myDiv_ge _ p hp0 hge, my_mul_sub, ih]

#print axioms myDiv_mul_cancel
