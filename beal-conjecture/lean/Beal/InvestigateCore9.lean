-- Investigation 9: Check what Nat.add_div_left needs, find propext-free divide facts

#print axioms Nat.add_div_left
#print axioms Nat.add_div_right

-- These need propext too. Let's trace the origin:
-- Nat.div depends on well-founded recursion which is fine,
-- but proofs about Nat.div go through Nat.mod which uses propext.

-- Can we avoid using Nat.mod entirely?
-- The only path: define our own division by well-founded recursion
-- and prove the cancellation law inside that recursion.

-- Actually, let me check if there's a propext-free proof of 
-- (p + p*n) / p = n + 1 using only Nat.div_eq (propext-free):
-- Nat.div_eq (p + p*n) p = if (0 < p ∧ p ≤ p + p*n) then (p*n)/p + 1 else 0
-- We'd need to reduce the ite, which requires propext.

-- FUNDAMENTAL FINDING: 
-- In Lean 4.12, ALL non-trivial proofs about Nat.div and Nat.mod require propext
-- because the well-founded-recursion-based definitions of Nat.div and Nat.mod
-- are proved correct via Nat.mod_add_div, which internally uses ite_cond_eq_true,
-- which needs propext (specifically: `(a ∧ b) = True → ite (a ∧ b) x y = x`
-- goes through eq_true and propext to rewrite inside ite).

-- Let's verify: is there ANY propext-free div/mod theorem?
-- Check the simplest ones:
#print axioms Nat.zero_div
#print axioms Nat.div_zero  
#print axioms Nat.div_self

-- And check if Nat.div is at least COMPUTED correctly (definitional equality):
-- e.g., 6 / 3 = 2 by native_decide
example : 6 / 3 = 2 := by native_decide
#print axioms @native_decide

example : 6 / 3 = 2 := by decide  
#print axioms @decide

-- native_decide uses native computation - does it need propext?
-- decide uses kernel computation

-- For the THEOREM N/p * p = N with p∣N: 
-- if we use `decide` on a general statement, it would need decidability of ∣
-- and equality, which goes through propext via Decidable instances.

-- CONCLUSION CHECK: is there ANY path that avoids propext for this theorem?
-- Let's try a completely manual proof by well-founded recursion on N:

def myDiv (N p : Nat) : Nat :=
  if p = 0 then 0
  else if N < p then 0
  else myDiv (N - p) p + 1
termination_by N

-- Can we prove myDiv p (p*k) = k without propext?
theorem myDiv_mul (p k : Nat) (hp : 0 < p) : myDiv (p * k) p = k := by
  induction k with
  | zero => 
    unfold myDiv
    simp [Nat.not_eq_zero_of_lt hp]
  | succ n ih =>
    unfold myDiv
    have hp0 : p ≠ 0 := Nat.not_eq_zero_of_lt hp
    simp [hp0]
    rw [show p * (n + 1) - p = p * n from by ring_nf; omega]
    exact ih

#print axioms myDiv_mul
