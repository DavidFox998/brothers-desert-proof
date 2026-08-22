-- Investigation 4: Trace propext dependency deeper
-- Why does Nat.mul_div_cancel' need propext?

#print Nat.mod_eq_zero_of_dvd
#print axioms Nat.mod_eq_zero_of_dvd

#print Nat.mod_add_div
#print axioms Nat.mod_add_div

-- The key is: Nat.mod_eq_zero_of_dvd uses propext?
-- Let's check the chain:
#print axioms Nat.dvd_iff_mod_eq_zero
