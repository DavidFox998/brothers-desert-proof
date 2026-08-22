-- Investigation 15: Build propext-free proof of myDiv (p*k) p = k
-- using our custom div and propext-free lemmas

-- Propext-free lemmas established:
theorem my_add_sub_cancel_right (n p : Nat) : n + p - p = n := by
  induction p with
  | zero => rw [Nat.add_zero, Nat.sub_zero]
  | succ m ih => rw [Nat.add_succ, Nat.succ_sub_succ_eq_sub]; exact ih

theorem my_mul_sub (p n : Nat) : p * (n + 1) - p = p * n := by
  rw [Nat.mul_add, Nat.mul_one, my_add_sub_cancel_right]

#print axioms my_add_sub_cancel_right
#print axioms my_mul_sub

-- Custom div (propext-free, well-founded):
def myDiv (N p : Nat) : Nat :=
  if h : p = 0 ∨ N < p then 0
  else myDiv (N - p) p + 1
termination_by N
decreasing_by
  rename_i h
  push_neg at h
  obtain ⟨hp, hlt⟩ := h
  exact Nat.sub_lt (Nat.lt_of_lt_of_le (Nat.pos_of_ne_zero hp) (Nat.le_of_not_lt hlt)) 
                   (Nat.pos_of_ne_zero hp)

-- Now prove myDiv (p*k) p = k propext-free using if_pos/if_neg and dif_pos/dif_neg:
-- Need: 
-- (1) p ≠ 0 (from hp : 0 < p)
-- (2) ¬ (p*k < p) when k ≥ 1 (so ¬ (p=0 ∨ p*k < p))

-- Lemma: p ≠ 0 → ¬ (p * (k+1) < p)
theorem not_mul_succ_lt_self (p k : Nat) (hp : 0 < p) : ¬ (p * (k + 1) < p) := by
  intro h
  have : p * 1 ≤ p * (k + 1) := Nat.mul_le_mul_left p (Nat.succ_le_succ (Nat.zero_le k))
  rw [Nat.mul_one] at this
  exact Nat.lt_irrefl p (Nat.lt_of_le_of_lt this h)

#print axioms not_mul_succ_lt_self

-- Now the main theorem:
theorem myDiv_mul_cancel (p k : Nat) (hp : 0 < p) : myDiv (p * k) p = k := by
  induction k with
  | zero =>
    rw [Nat.mul_zero]
    unfold myDiv
    rw [dif_pos (Or.inl (Nat.not_eq_zero_of_lt hp ▸ rfl))]
    -- Hmm, need p ≠ 0 to... wait, dif_pos needs p = 0 ∨ 0 < p
    -- Actually 0 < p, so myDiv 0 p: h = (p=0 ∨ 0 < p)? No, h = (p=0 ∨ 0 < p)?
    -- Wait: condition is p=0 ∨ N < p, so for N=0: 0 < p means 0 < p, and N=0 < p=yes
    sorry
  | succ n ih => sorry

-- The `dif` approach is getting complex. Let's use a cleaner route:
-- prove by cases on the `if` condition directly

-- Alternative: prove a helper that myDiv (p*k) p = k by strong induction on k
-- using that myDiv N p = 0 when N < p, and myDiv N p = myDiv (N-p) p + 1 when N ≥ p

theorem myDiv_lt (N p : Nat) (h : N < p) : myDiv N p = 0 := by
  unfold myDiv
  exact dif_pos (Or.inr h)

theorem myDiv_ge (N p : Nat) (hp : p ≠ 0) (h : ¬ N < p) : myDiv N p = myDiv (N - p) p + 1 := by
  unfold myDiv
  exact dif_neg (by push_neg; exact ⟨hp, h⟩)

#print axioms myDiv_lt
#print axioms myDiv_ge
