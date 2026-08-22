-- Investigation 10: Try avoid propext via if_pos/if_neg which may be propext-free?
-- Also investigate Quot.sound dependency.

#print axioms if_pos
#print axioms if_neg
#print axioms Nat.lt_irrefl
#print axioms Nat.le_of_lt_succ
#print axioms Nat.not_lt

-- Check if simp itself introduces propext
-- And check omega
example (p n : Nat) (hp : 0 < p) : p * (n + 1) - p = p * n := by
  ring_nf
  omega

#print axioms @Nat.succ_lt_succ

-- More fundamental: does `if` require propext to eliminate?
-- In Lean 4, ite requires a Decidable instance.
-- For Nat comparisons, Nat.decLt is Decidable and doesn't need propext.
-- But simp using ite lemmas might introduce propext.

-- Let's try using if_pos directly:
example (p n : Nat) (hp : 0 < p) (hp0 : p ≠ 0) (h : ¬ (p * (n+1) < p)) : 
    (if p * (n + 1) < p then 0 else (0 : Nat) + 1) = 0 + 1 := by
  exact if_neg h

#print axioms @if_pos
#print axioms @if_neg

-- These seem promising. Let me check the full myDiv proof more carefully.

def myDiv2 (N p : Nat) : Nat :=
  if hp : p = 0 then 0
  else if h : N < p then 0
  else myDiv2 (N - p) p + 1
termination_by N

-- Test: can we prove myDiv2 (p*k) p = k propext-free?
theorem myDiv2_mul (p k : Nat) (hp : 0 < p) : myDiv2 (p * k) p = k := by
  induction k with
  | zero =>
    simp [myDiv2, Nat.not_eq_zero_of_lt hp]
    unfold myDiv2
    have : p ≠ 0 := Nat.not_eq_zero_of_lt hp
    simp [this]
  | succ n ih =>
    unfold myDiv2
    have hp0 : ¬ (p = 0) := Nat.not_eq_zero_of_lt hp
    have hlt : ¬ (p * (n + 1) < p) := by nlinarith
    rw [dif_neg hp0, dif_neg hlt]
    have hsub : p * (n + 1) - p = p * n := by
      have : p * (n + 1) = p * n + p := by ring
      omega
    rw [hsub, ih]

#print axioms myDiv2_mul
