-- Investigation 2: What does Nat.div_mul_cancel depend on?
-- And can we prove N/p * p = N without propext?

-- First, check what's in scope without imports
#check Nat.div_mul_cancel
#print Nat.div_mul_cancel

-- Check if Nat.dvd_antisymm needs propext
#check @Nat.dvd_antisymm

-- Core arithmetic without propext
-- Nat.dvd is defined as ∃ k, n = m * k
-- Nat.div_mul_cancel states: m ∣ n → n / m * m = n
-- Let's see if this is proved using propext in the kernel

-- Try a manual proof using only Nat.div_def
#check Nat.div_def
#check @Nat.div_add_mod
