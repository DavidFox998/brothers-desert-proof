-- KillshotSearch — WIP searches for removing one of the three named bridges.
--
-- This file deliberately imports Core interfaces only.  Every theorem below
-- is a search target and may use `sorryAx`; it must not alter the B05/B14/B15
-- wrapper boundary.

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
#print axioms killshot_no_2p_isogeny
#print axioms killshot_level_2_no_ribet
#print axioms killshot_mod8
#print axioms killshot_squarefree_contradiction