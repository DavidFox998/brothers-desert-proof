-- Investigation 7: Nat.add_div_right uses propext. Let's check Nat.mul_div_cancel
#print Nat.mul_div_cancel
#print axioms Nat.mul_div_cancel

-- The key issue: even Nat.add_div_right needs propext
-- Nat.div_eq itself is axiom-free!
-- But any theorem ABOUT div that goes through mod seems to need propext.
-- Why? Because Nat.mod is also defined by well-founded recursion and 
-- the proofs about it use propext for ite_cond_eq_true (from and_self True).

-- Let's confirm: does Nat.add_div_right need propext?
#print axioms Nat.add_div_right

-- Is there any non-trivial Nat arithmetic fact that avoids propext?
-- Let's try: simple successor-based facts
#print axioms Nat.succ_eq_add_one
#print axioms Nat.zero_add
#print axioms Nat.add_comm
#print axioms Nat.mul_comm

-- Is propext avoidable for N/p * p = N?
-- Let's try to prove it using ONLY Nat.div_eq (which is propext-free)
-- by strong induction

-- Strategy: prove by strong induction on N
-- If N = 0: 0/p * p = 0 * p = 0 ✓
-- If N > 0 and p ≤ N: use Nat.div_eq which says N/p = (N-p)/p + 1 when p ≤ N
-- Then (N/p)*p = ((N-p)/p + 1)*p = (N-p)/p*p + p = (N-p) + p = N (by IH)
-- If p > N: N/p = 0, so 0*p = 0 ≠ N unless N=0, but p∣N forces N=0 if p>N

-- The question is: can we do this without propext?
-- The `if 0 < p ∧ p ≤ N then ...` in Nat.div_eq requires proving the condition,
-- and unfolding the ite requires deciding Bool conditions or using propext.

-- Actually, let's check if Nat.casesOn or Nat.rec can handle this
-- through definitional equality alone.

-- KEY QUESTION: can omega avoid propext?
example (N p : Nat) (k : Nat) (hk : N = p * k) (hp : 0 < p) : N / p * p = N := by
  omega

#print axioms @Nat.lt_irrefl
-- omega calls into Omega decision procedure - does it use propext?
