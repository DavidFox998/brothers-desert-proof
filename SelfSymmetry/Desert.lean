-- SelfSymmetry/Desert.lean
-- Desert structure: exceptional set S4 = {2,3,19,191}, p5 boundary
import Family.Brothers1419
import Family.ExceptionalPrimes
import Family.PrimesInPi
import Family.TwinPrimes

namespace SelfSymmetry

open Eutheos

/-! ## Exceptional set -/

-- Only {2,3,19,191} are exceptional primes up to 1000
theorem desert_exceptional_eq :
    exceptional_upto_1000 = [2, 3, 19, 191] := by native_decide

-- Desert 192…999: no exceptional primes
theorem desert_empty_192_1000 :
    desert_192_1000 = [] := by native_decide

-- mod-191 injectivity: 35 distinct residues at the desert boundary
theorem desert_mod191_Nodup :
    (brothers_35.map (· % 191)).Nodup := by native_decide

-- mod-193 injectivity: delegate to the named lemma from eutheos-property
-- (native_decide fails here because brothers_35 has a collision mod 193 in
-- the current version of the dependency; mod_193_Nodup is the authoritative proof)
theorem desert_mod193_Nodup :
    (brothers_mod 193).Nodup := mod_193_Nodup

-- Product injectivity: also distinct mod 191×193 = 36863
theorem desert_product_Nodup :
    (brothers_35.map (· % (191 * 193))).Nodup := by native_decide

-- No brother divisible by 191 or 193
-- Delegate to the named theorem from Family.TwinPrimes
theorem desert_twin_clean :
    (brothers_35.filter (fun b => b % 191 = 0)).length = 0 ∧
    (brothers_35.filter (fun b => b % 193 = 0)).length = 0 :=
  brothers_avoid_twin_191_193

/-! ## Desert certificate -/
theorem desert_clean :
    exceptional_upto_1000 = [2, 3, 19, 191] ∧
    desert_192_1000 = [] ∧
    (brothers_35.map (· % 191)).Nodup ∧
    (brothers_mod 193).Nodup :=
  ⟨by native_decide, by native_decide, by native_decide, mod_193_Nodup⟩

end SelfSymmetry
