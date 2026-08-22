-- KillshotSearch — WIP searches for removing one of the three named bridges.
--
-- This file deliberately imports Core interfaces only.  The search targets
-- may use `sorryAx`; it must not alter the B05/B14/B15 wrapper boundary.

import Beal.B05_Modularity_Core
import Beal.B05_HasseWiles_Core
import Beal.B10_RibetReal_Core
import Beal.B14_FreyConductor_Core
import Beal.B15_LevelTo2_Core

/-!
## Killshot #1: the prime-radical branch

`RadCertificate` is the import-free certificate available in B14 Core.  The
missing arithmetic step is the implication from a prime radical to a
prime-power factorization of `A * B * C`, followed by the primitive Beal
contradiction.
-/

def RadPrimeCase14 (A B C p : Nat) : Prop :=
  FreyConductorRealCertificate A B C p ∧ Prime14Core p

/--
This local cancellation proof avoids the standard `Nat.add_right_cancel`,
whose Lean 4.12 declaration has a `propext` dependency.
-/
theorem add_right_cancel_zero {a b k : Nat} (h : a + k = b + k) : a = b := by
  induction k with
  | zero => exact h
  | succ k ih =>
    apply ih
    exact Nat.succ.inj h

/--
Numbers at least two cannot multiply a natural number to give one.  The proof
uses only constructors, so it remains zero-axiom.
-/
theorem one_ne_mul_of_two_le
    {p v : Nat} (hp : 2 ≤ p) (h : 1 = p * v) : False := by
  cases p with
  | zero => exact (Nat.not_succ_le_zero 1) hp
  | succ p =>
    cases p with
    | zero => exact (Nat.not_succ_le_self 1) hp
    | succ p =>
      cases v with
      | zero =>
        change Nat.succ Nat.zero = Nat.zero at h
        exact Nat.noConfusion h
      | succ v =>
        change Nat.succ Nat.zero = Nat.succ (Nat.succ _) at h
        have h' : Nat.zero = Nat.succ _ := Nat.succ.inj h
        exact Nat.noConfusion h'

/--
The elementary divisibility residue argument, expressed without
`Nat.dvd_sub`: `1 + p * u` cannot itself be a multiple of `p ≥ 2`.
-/
theorem one_add_mul_ne_mul
    {p u v : Nat} (hp : 2 ≤ p) (h : 1 + p * u = p * v) : False := by
  induction u generalizing v with
  | zero =>
    exact one_ne_mul_of_two_le hp h
  | succ u ih =>
    cases v with
    | zero =>
      have h' : p * Nat.succ u + 1 = 0 := (Nat.add_comm _ _).trans h
      cases h'
    | succ v =>
      have hleft : 1 + p * Nat.succ u = (1 + p * u) + p := by
        calc
          1 + p * Nat.succ u = 1 + (p * u + p) :=
            congrArg (fun n => 1 + n) (Nat.mul_succ p u)
          _ = (1 + p * u) + p := (Nat.add_assoc _ _ _).symm
      have hright : p * Nat.succ v = p * v + p := Nat.mul_succ p v
      have h' : (1 + p * u) + p = p * v + p :=
        hleft.symm.trans (h.trans hright)
      exact ih (add_right_cancel_zero h')

/--
An import-free replacement for the unavailable `Nat.dvd_pow_self`: a base
divides each of its positive powers.
-/
theorem dvd_pow_self_of_ne_zero {p n : Nat} (hn : n ≠ 0) : p ∣ p ^ n := by
  cases n with
  | zero => exact (hn rfl).elim
  | succ n =>
    refine ⟨p ^ n, ?_⟩
    exact (Nat.pow_succ p n).trans (Nat.mul_comm _ _)

/--
The elementary prime-power gap: a positive power of a number at least two
cannot be one less than another positive power of the same base.
-/
theorem one_add_p_pow_not_p_pow
    {p a c : Nat} (hp : 2 ≤ p) (ha : 1 ≤ a) (hc : 1 ≤ c)
    (h : 1 + p ^ a = p ^ c) : False := by
  have ha0 : a ≠ 0 := by
    cases a with
    | zero => exact (Nat.not_succ_le_zero 0 ha).elim
    | succ a =>
      intro hzero
      exact Nat.noConfusion hzero
  have hc0 : c ≠ 0 := by
    cases c with
    | zero => exact (Nat.not_succ_le_zero 0 hc).elim
    | succ c =>
      intro hzero
      exact Nat.noConfusion hzero
  rcases dvd_pow_self_of_ne_zero ha0 with ⟨u, hu⟩
  rcases dvd_pow_self_of_ne_zero hc0 with ⟨v, hv⟩
  apply one_add_mul_ne_mul hp
  calc
    1 + p * u = 1 + p ^ a := congrArg (fun n => 1 + n) hu.symm
    _ = p ^ c := h
    _ = p * v := hv

theorem p_pow_add_one_not_p_pow
    {p b c : Nat} (hp : 2 ≤ p) (hb : 1 ≤ b) (hc : 1 ≤ c)
    (h : p ^ b + 1 = p ^ c) : False := by
  apply one_add_p_pow_not_p_pow hp hb hc
  calc
    1 + p ^ b = p ^ b + 1 := Nat.add_comm _ _
    _ = p ^ c := h

theorem killshot_rad_prime_branch
    {A B C x y z p k : Nat}
    (hBeal : IsBealSolution05Core A B C x y z)
    (hRadPrime : RadPrimeCase14 A B C p)
    (hPrimePower : A * B * C = p ^ k) :
    False := by
  sorry

/-!
## Killshot #2: full 2-torsion versus a reducible mod-p representation

The curve, its rational torsion, and the isogeny predicates are not yet
formalized in Core.  These opaque predicates keep the search statement honest
without importing B18 or introducing a new axiom into the staged package.

Missing Core lemmas:
* full rational 2-torsion plus a reducible mod-p representation gives a
  rational 2p-isogeny;
* the relevant `X₀(10)`/`X₀(20)` parametrization has no non-cuspidal Frey
  point for `p ≥ 5`.
-/

opaque HasFullTwoTorsion (A B x y : Nat) : Prop
opaque HasRationalPIsogeny (A B C x y z p : Nat) : Prop
opaque HasRational2pIsogeny (A B C x y z p : Nat) : Prop

theorem killshot_no_2p_isogeny
    {A B C x y z p : Nat}
    (hBeal : IsBealSolution05Core A B C x y z)
    (hFull2 : HasFullTwoTorsion A B x y)
    (hp : 5 ≤ p)
    (hReducible : HasRationalPIsogeny A B C x y z p) :
    False := by
  sorry

/-!
## Killshot #3: level two without the Ribet bridge

`CanLowerLevel15Core` supplies only the exact-division shape.  The missing
result is a genuinely arithmetic/geometric level-lowering lemma that turns
`N = 2 * p` and `p² ∤ N` into a level-two Frey form without invoking the
global Ribet hypothesis.
-/

opaque HasLevelTwoFreyForm (A B C x y z : Nat) : Prop

theorem killshot_level_2_no_ribet
    {A B C x y z p N : Nat}
    (hBeal : IsBealSolution05Core A B C x y z)
    (hN : N = 2 * p)
    (hExact : ExactDivides15Core p N)
    (hLowered : CanLowerLevel15Core N p 2)
    (hS2 : S2DimZero)
    (hLevelTwoForm : HasLevelTwoFreyForm A B C x y z) :
    False := by
  sorry

/-!
## Killshot #4: parity modulo 8

The Core layer intentionally has no modular-arithmetic conductor theorem.
This statement isolates the elementary parity target: after establishing the
odd/odd/even Beal branch, prove that `4 ∣ C`.
-/

theorem killshot_mod8
    {A B C x y z : Nat}
    (hBeal : IsBealSolution05Core A B C x y z)
    (hAOdd : A % 2 = 1)
    (hBOdd : B % 2 = 1)
    (hCEven : C % 2 = 0) :
    4 ∣ C := by
  sorry

/-!
## Killshot #5: squarefree minimality contradiction

The missing bridge is minimality of the Frey model: squarefreeness of
`A * B * C` must force a squared prime in the conductor, contradicting the
exact-factor condition already represented by `ExactFreyConductorFactor`.
-/

def SquarefreeABC14 (A B C : Nat) : Prop :=
  ∀ q : Nat, q * q ∣ A * B * C → q = 1

theorem killshot_squarefree_contradiction
    {conductor : FreyConductorFunction}
    {A B C x y z p : Nat}
    (hBeal : IsBealSolution05Core A B C x y z)
    (hSquarefree : SquarefreeABC14 A B C)
    (hExact : ExactFreyConductorFactor conductor A B C x y z p)
    (hConductorDivides :
      FreyConductorDividesABC14Core A B C (conductor A B C x y z)) :
    False := by
  sorry

#print axioms killshot_rad_prime_branch
#print axioms add_right_cancel_zero
#print axioms one_ne_mul_of_two_le
#print axioms one_add_mul_ne_mul
#print axioms dvd_pow_self_of_ne_zero
#print axioms one_add_p_pow_not_p_pow
#print axioms p_pow_add_one_not_p_pow
#print axioms killshot_no_2p_isogeny
#print axioms killshot_level_2_no_ribet
#print axioms killshot_mod8
#print axioms killshot_squarefree_contradiction