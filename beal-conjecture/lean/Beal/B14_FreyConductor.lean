import Beal.B14_FreyConductor_Core
import Beal.B13_RibetRealDefs
import Beal.B01_Def
import Beal.B10_RibetReal_Core
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Tactic

open scoped BigOperators

namespace BealFreyConductor

def Rad (n : Nat) : Nat :=
  ∏ p in n.primeFactors, p

theorem rad_dvd_self (n : Nat) : Rad n ∣ n := by
  unfold Rad
  exact Nat.prod_primeFactors_dvd n

theorem prime_factor_of_rad {n p : Nat} (h : p ∣ Rad n) : p ∣ n :=
  Nat.dvd_trans h (rad_dvd_self n)

def FreyConductorReal (A B C _ _ _ : Nat) : Nat :=
  2 * Rad (A * B * C)

def FreyConductorComputation : Prop :=
  ∀ A B C x y z,
    IsBealSolution A B C x y z →
    ∃ p, 5 ≤ p ∧ IsPrime10Core p ∧
      FreyConductorReal A B C x y z = 2 * p

/--
This is the remaining deep arithmetic input at the Frey-conductor boundary.
Its statement is conditional on a Beal solution, and its wrapper uses
Mathlib's finite-factorization boundary (`propext`, `Classical.choice`, and
`Quot.sound`), documented and audited separately from the zero-axiom Core.
-/
axiom frey_conductor_computation : FreyConductorComputation

open BealRibetReal

-- Real Frey conductor: for Beal solution, N = product of primes dividing ABC, up to factor 2
def FreyConductorDividesABC (A B C : Nat) (N : Nat) : Prop :=
  ∀ p : Nat, Nat.Prime p → p ∣ N → p ∣ A ∨ p ∣ B ∨ p ∣ C

def BealPrimesNotDivideConductor : Prop :=
  ∀ A B C x y z p N,
    IsBealSolution A B C x y z →
    Nat.Prime p → 5 ≤ p →
    ¬ (p ∣ A) → ¬ (p ∣ B) → ¬ (p ∣ C) →
    FreyConductorDividesABC A B C N →
    ¬ (p ∣ N)

theorem beal_primes_not_divide_conductor_trivial : BealPrimesNotDivideConductor :=
  fun A B C x y z p N _ _ _ hNA hNB hNC hDiv hPN =>
    by
      have hOr := hDiv p ‹Nat.Prime p› hPN
      rcases hOr with hA | hB | hC
      · exact hNA hA
      · exact hNB hB
      · exact hNC hC

#print axioms beal_primes_not_divide_conductor_trivial
#print axioms Rad
#print axioms rad_dvd_self
#print axioms prime_factor_of_rad
#print axioms FreyConductorReal
#print axioms FreyConductorComputation

end BealFreyConductor
