-- Investigation 3: Check propext dependency of Nat.div_mul_cancel
-- and find propext-free paths

-- The kernel proof of Nat.div_mul_cancel uses:
-- Nat.mul_comm, Nat.mul_div_cancel'
-- Let's check Nat.mul_div_cancel'

#print Nat.mul_div_cancel'
-- Does it use propext?

-- Try proving div_mul_cancel from scratch using only Nat primitives
-- that don't require propext.

-- Actually let's check what Lean 4.12 core theorems we have:
#check @Nat.mul_div_cancel'
#print axioms Nat.mul_div_cancel'
#print axioms Nat.div_mul_cancel
