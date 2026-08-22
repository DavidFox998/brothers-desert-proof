-- Investigation 6: Go even deeper - why does Nat.mul_div_cancel_left need propext?
#print Nat.mul_div_cancel_left
#print axioms Nat.mul_div_cancel_left

-- Check Nat.div_eq (the definitional equation for Nat.div)
#print Nat.div_eq  -- Does this use propext?
#print axioms Nat.div_eq

-- Is there ANY Nat division theorem that doesn't need propext in Lean 4.12?
-- Let's check Nat.Div (the typeclass-based one)
#check @Nat.div

-- What about GCD?
#print axioms Nat.gcd

-- What about Nat.recAux or strong recursion?
-- Let's check if the issue is fundamentally in how Lean defines Nat.div

-- Try to see if we can compute N/p * p = N by case analysis
-- without using any library theorems

-- Manual proof attempt: prove by induction that if N = p * k, then p * k / p = k
theorem mul_div_self (p k : Nat) (hp : 0 < p) : p * k / p = k := by
  induction k with
  | zero => simp
  | succ n ih =>
    rw [Nat.mul_succ, Nat.add_div_right _ hp, ih]

#print axioms mul_div_self
