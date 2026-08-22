-- Investigation 13: Find propext-free path for add_sub_cancel
-- Nat.add_sub_cancel : n + m - m = n  uses propext? Surprising.
-- Let's find why and if there's a way around it.

#print Nat.add_sub_cancel
-- Check what it reduces to

-- Alternative: use Nat.Nat.succ_sub_succ_eq_sub or Nat.succ_sub
#print axioms Nat.succ_sub_succ_eq_sub

-- What about Nat.sub_add_cancel?
#print axioms Nat.sub_add_cancel

-- Let's check a minimal subtraction fact:
#print axioms Nat.zero_sub
#print axioms Nat.sub_zero
#print axioms Nat.succ_sub_succ_eq_sub

-- Actually, Nat.add_sub_cancel being propext-dependent is suspicious.
-- Let me check if the proof the kernel has uses the right path:
#print Nat.add_sub_cancel
