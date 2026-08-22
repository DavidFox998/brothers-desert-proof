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

/--
The standard associativity theorem for `Nat` carries `propext` in Lean 4.12.
This structural recursion is its strictly zero-axiom replacement.
-/
theorem mul_assoc_zero (a b c : Nat) : (a * b) * c = a * (b * c) := by
  induction c with
  | zero => rfl
  | succ c ih =>
    calc
      (a * b) * Nat.succ c = (a * b) * c + a * b := Nat.mul_succ _ _
      _ = a * (b * c) + a * b := congrArg (fun t => t + a * b) ih
      _ = a * (b * c + b) := (Nat.mul_add _ _ _).symm
      _ = a * (b * Nat.succ c) :=
        congrArg (fun t => a * t) (Nat.mul_succ _ _).symm

theorem ne_zero_of_two_lt {n : Nat} (h : 2 < n) : n ≠ 0 := by
  intro hzero
  subst n
  exact (Nat.not_succ_le_zero 2 h).elim

theorem four_le_pow_of_two_le {n k : Nat} (hn : 2 ≤ n) (hk : 2 ≤ k) :
    4 ≤ n ^ k := by
  cases n with
  | zero => exact (Nat.not_succ_le_zero 1 hn).elim
  | succ n =>
    cases n with
    | zero => exact (Nat.not_succ_le_self 1 hn).elim
    | succ n =>
      cases k with
      | zero => exact (Nat.not_succ_le_zero 1 hk).elim
      | succ k =>
        cases k with
        | zero => exact (Nat.not_succ_le_self 1 hk).elim
        | succ d =>
          have hnpos : 0 < Nat.succ (Nat.succ n) := Nat.zero_lt_succ _
          have hpowpos : 0 < (Nat.succ (Nat.succ n)) ^ d := Nat.pow_pos hnpos
          have hpowone : 1 ≤ (Nat.succ (Nat.succ n)) ^ d :=
            Nat.succ_le_of_lt hpowpos
          have hnat : 2 ≤ Nat.succ (Nat.succ n) :=
            Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le _))
          have htwo : 2 ≤ (Nat.succ (Nat.succ n)) ^ d * Nat.succ (Nat.succ n) := by
            calc
              2 = 1 * 2 := rfl
              _ ≤ (Nat.succ (Nat.succ n)) ^ d * Nat.succ (Nat.succ n) :=
                Nat.mul_le_mul hpowone hnat
          have hpow : (Nat.succ (Nat.succ n)) ^ Nat.succ (Nat.succ d) =
              ((Nat.succ (Nat.succ n)) ^ d * Nat.succ (Nat.succ n)) *
                Nat.succ (Nat.succ n) := by
            calc
              (Nat.succ (Nat.succ n)) ^ Nat.succ (Nat.succ d) =
                  (Nat.succ (Nat.succ n)) ^ Nat.succ d * Nat.succ (Nat.succ n) :=
                Nat.pow_succ _ _
              _ = ((Nat.succ (Nat.succ n)) ^ d * Nat.succ (Nat.succ n)) *
                  Nat.succ (Nat.succ n) :=
                congrArg (fun t => t * Nat.succ (Nat.succ n)) (Nat.pow_succ _ _)
          calc
            4 = 2 * 2 := rfl
            _ ≤ ((Nat.succ (Nat.succ n)) ^ d * Nat.succ (Nat.succ n)) *
                Nat.succ (Nat.succ n) :=
              Nat.mul_le_mul htwo hnat
            _ = (Nat.succ (Nat.succ n)) ^ Nat.succ (Nat.succ d) := hpow.symm

theorem two_ne_pow_of_two_le {n k : Nat} (hn : 2 ≤ n) (hk : 2 ≤ k)
    (h : 1 + 1 = n ^ k) : False := by
  have hfour : 4 ≤ n ^ k := four_le_pow_of_two_le hn hk
  have htwoeq : 2 = n ^ k := h
  have hfourtwo : 4 ≤ 2 := htwoeq.symm ▸ hfour
  have hthreetwo : 3 ≤ 2 := Nat.le_trans (Nat.le_succ 3) hfourtwo
  exact (Nat.not_succ_le_self 2 hthreetwo).elim

theorem dvd_pow_of_dvd_base {p n k : Nat} (hd : p ∣ n) (hk : k ≠ 0) :
    p ∣ n ^ k := by
  rcases hd with ⟨q, hq⟩
  cases k with
  | zero => exact (hk rfl).elim
  | succ k =>
    refine ⟨n ^ k * q, ?_⟩
    calc
      n ^ Nat.succ k = n ^ k * n := Nat.pow_succ _ _
      _ = n ^ k * (p * q) := congrArg (fun t => n ^ k * t) hq
      _ = (n ^ k * p) * q := (mul_assoc_zero _ _ _).symm
      _ = (p * n ^ k) * q := congrArg (fun t => t * q) (Nat.mul_comm _ _)
      _ = p * (n ^ k * q) := mul_assoc_zero _ _ _

theorem add_pos_ne_one {u v : Nat} (hu : 0 < u) (hv : 0 < v)
    (h : u + v = 1) : False := by
  have hu1 : 1 ≤ u := Nat.succ_le_of_lt hu
  have hv1 : 1 ≤ v := Nat.succ_le_of_lt hv
  have htwo : 2 ≤ u + v := by
    calc
      2 = 1 + 1 := rfl
      _ ≤ u + v := Nat.add_le_add hu1 hv1
  have htwoone : 2 ≤ 1 := h ▸ htwo
  exact (Nat.not_succ_le_self 1 htwoone).elim

theorem killshot_rad_prime_branch
    {A B C x y z p : Nat}
    (hBeal : IsBealSolution05Core A B C x y z)
    (hRadPrime : RadPrimeCase14 A B C p)
    (hPowers : RadPrimePowerCertificate14Core A B C p) :
    False := by
  rcases hBeal with ⟨_, _, _, hx, hy, hz, hEq, hPrimitive⟩
  rcases hPowers with ⟨a, b, c, hA, hB, hC⟩
  have hpgt : 1 < p := hRadPrime.2.1
  have hp0 : 0 < p := Nat.lt_trans (Nat.zero_lt_succ 0) hpgt
  cases a with
  | zero =>
    cases b with
    | zero =>
      cases c with
      | zero =>
        have h : 1 + 1 = 1 := by
          simpa only [hA, hB, hC, Nat.pow_zero, Nat.one_pow] using hEq
        change Nat.succ (Nat.succ Nat.zero) = Nat.succ Nat.zero at h
        have hzero : Nat.succ Nat.zero = Nat.zero := Nat.succ.inj h
        exact Nat.noConfusion hzero
      | succ c =>
        have hbase : 2 ≤ p ^ Nat.succ c := by
          have hpowpos : 0 < p ^ c := Nat.pow_pos hp0
          have hpowone : 1 ≤ p ^ c := Nat.succ_le_of_lt hpowpos
          calc
            2 = 1 * 2 := rfl
            _ ≤ p ^ c * p := Nat.mul_le_mul hpowone (Nat.succ_le_of_lt hpgt)
            _ = p ^ Nat.succ c := (Nat.pow_succ _ _).symm
        have h : 1 + 1 = (p ^ Nat.succ c) ^ z := by
          simpa only [hA, hB, hC, Nat.pow_zero, Nat.one_pow] using hEq
        exact two_ne_pow_of_two_le hbase (Nat.le_of_lt hz) h
    | succ b =>
      cases c with
      | zero =>
        have h : 1 + (p ^ Nat.succ b) ^ y = 1 := by
          simpa only [hA, hB, hC, Nat.pow_zero, Nat.one_pow] using hEq
        exact add_pos_ne_one (Nat.zero_lt_succ _) (Nat.pow_pos (Nat.pow_pos hp0)) h
      | succ c =>
        have hBdvd : p ∣ (p ^ Nat.succ b) ^ y :=
          dvd_pow_of_dvd_base
            (dvd_pow_self_of_ne_zero (by intro h; exact Nat.noConfusion h))
            (ne_zero_of_two_lt hy)
        have hCdvd : p ∣ (p ^ Nat.succ c) ^ z :=
          dvd_pow_of_dvd_base
            (dvd_pow_self_of_ne_zero (by intro h; exact Nat.noConfusion h))
            (ne_zero_of_two_lt hz)
        rcases hBdvd with ⟨u, hu⟩
        rcases hCdvd with ⟨v, hv⟩
        apply one_add_mul_ne_mul (Nat.succ_le_of_lt hpgt)
        calc
          1 + p * u = 1 + (p ^ Nat.succ b) ^ y :=
            congrArg (fun t => 1 + t) hu.symm
          _ = (p ^ Nat.succ c) ^ z := by
            simpa only [hA, hB, hC, Nat.pow_zero, Nat.one_pow] using hEq
          _ = p * v := hv
  | succ a =>
    cases b with
    | zero =>
      cases c with
      | zero =>
        have h : (p ^ Nat.succ a) ^ x + 1 = 1 := by
          simpa only [hA, hB, hC, Nat.pow_zero, Nat.one_pow] using hEq
        exact add_pos_ne_one (Nat.pow_pos (Nat.pow_pos hp0)) (Nat.zero_lt_succ _) h
      | succ c =>
        have hAdvd : p ∣ (p ^ Nat.succ a) ^ x :=
          dvd_pow_of_dvd_base
            (dvd_pow_self_of_ne_zero (by intro h; exact Nat.noConfusion h))
            (ne_zero_of_two_lt hx)
        have hCdvd : p ∣ (p ^ Nat.succ c) ^ z :=
          dvd_pow_of_dvd_base
            (dvd_pow_self_of_ne_zero (by intro h; exact Nat.noConfusion h))
            (ne_zero_of_two_lt hz)
        rcases hAdvd with ⟨u, hu⟩
        rcases hCdvd with ⟨v, hv⟩
        apply one_add_mul_ne_mul (Nat.succ_le_of_lt hpgt)
        calc
          1 + p * u = 1 + (p ^ Nat.succ a) ^ x :=
            congrArg (fun t => 1 + t) hu.symm
          _ = (p ^ Nat.succ c) ^ z := by
            calc
              1 + (p ^ Nat.succ a) ^ x = (p ^ Nat.succ a) ^ x + 1 :=
                Nat.add_comm _ _
              _ = (p ^ Nat.succ c) ^ z := by
                simpa only [hA, hB, hC, Nat.pow_zero, Nat.one_pow] using hEq
          _ = p * v := hv
    | succ b =>
      cases c with
      | zero =>
        have h : (p ^ Nat.succ a) ^ x + (p ^ Nat.succ b) ^ y = 1 := by
          simpa only [hA, hB, hC, Nat.pow_zero, Nat.one_pow] using hEq
        exact add_pos_ne_one (Nat.pow_pos (Nat.pow_pos hp0))
          (Nat.pow_pos (Nat.pow_pos hp0)) h
      | succ c =>
        have hAdvd : p ∣ p ^ Nat.succ a :=
          dvd_pow_self_of_ne_zero (by intro h; exact Nat.noConfusion h)
        have hBdvd : p ∣ p ^ Nat.succ b :=
          dvd_pow_self_of_ne_zero (by intro h; exact Nat.noConfusion h)
        have hCdvd : p ∣ p ^ Nat.succ c :=
          dvd_pow_self_of_ne_zero (by intro h; exact Nat.noConfusion h)
        have hpone : p = 1 := hPrimitive p
          (by simpa only [hA] using hAdvd)
          (by simpa only [hB] using hBdvd)
          (by simpa only [hC] using hCdvd)
        exact (Nat.ne_of_gt hpgt hpone).elim

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

This is an elementary Core proof, not a conductor theorem.  Lean 4.12's
convenient modular-arithmetic and power-divisibility lemmas carry `propext`,
so the parity argument is developed directly from Nat remainder recursion and
explicit factor witnesses.
-/

def EvenTwo (n : Nat) : Prop := ∃ q, n = 2 * q

def OddTwo (n : Nat) : Prop := ∃ q, n = 2 * q + 1

theorem sub_add_two_of_two_le {n : Nat} (h : 2 ≤ n) : n - 2 + 2 = n := by
  cases n with
  | zero => exact (Nat.not_succ_le_zero 1 h).elim
  | succ n =>
    cases n with
    | zero => exact (Nat.not_succ_le_self 1 h).elim
    | succ n => rfl

theorem odd_two_of_mod_eq_one {n : Nat} (h : n % 2 = 1) : OddTwo n := by
  induction n using Nat.strongRecOn with
  | _ n ih =>
    cases n with
    | zero =>
      change 0 = 1 at h
      exact Nat.noConfusion h
    | succ n =>
      cases n with
      | zero => exact ⟨0, rfl⟩
      | succ n =>
        have hle : 2 ≤ Nat.succ (Nat.succ n) :=
          Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le _))
        have hsub : (Nat.succ (Nat.succ n) - 2) % 2 = 1 :=
          (Nat.mod_eq_sub_mod hle).symm.trans h
        have hlt : Nat.succ (Nat.succ n) - 2 < Nat.succ (Nat.succ n) :=
          Nat.sub_lt (Nat.zero_lt_succ _) (Nat.zero_lt_succ _)
        rcases ih (Nat.succ (Nat.succ n) - 2) hlt hsub with ⟨q, hq⟩
        refine ⟨Nat.succ q, ?_⟩
        calc
          Nat.succ (Nat.succ n) = Nat.succ (Nat.succ n) - 2 + 2 :=
            (sub_add_two_of_two_le hle).symm
          _ = (2 * q + 1) + 2 := congrArg (fun t => t + 2) hq
          _ = 2 * Nat.succ q + 1 := by
            calc
              (2 * q + 1) + 2 = 2 * q + (1 + 2) := Nat.add_assoc _ _ _
              _ = (2 * q + 2) + 1 := by rfl
              _ = 2 * Nat.succ q + 1 :=
                congrArg (fun t => t + 1) (Nat.mul_succ _ _).symm

theorem even_or_odd_two (n : Nat) : EvenTwo n ∨ OddTwo n := by
  induction n with
  | zero =>
    left
    exact ⟨0, rfl⟩
  | succ n ih =>
    rcases ih with hEven | hOdd
    · rcases hEven with ⟨q, hq⟩
      right
      refine ⟨q, ?_⟩
      calc
        Nat.succ n = Nat.succ (2 * q) := congrArg Nat.succ hq
        _ = 2 * q + 1 := rfl
    · rcases hOdd with ⟨q, hq⟩
      left
      refine ⟨Nat.succ q, ?_⟩
      calc
        Nat.succ n = Nat.succ (2 * q + 1) := congrArg Nat.succ hq
        _ = (2 * q + 1) + 1 := rfl
        _ = 2 * q + 2 := rfl
        _ = 2 * Nat.succ q := (Nat.mul_succ _ _).symm

theorem mul_collect_zero (a b c d : Nat) :
    (a * b) * (c * d) = (a * c) * (b * d) := by
  calc
    (a * b) * (c * d) = ((a * b) * c) * d :=
      (mul_assoc_zero _ _ _).symm
    _ = (a * (b * c)) * d :=
      congrArg (fun t => t * d) (mul_assoc_zero _ _ _)
    _ = (a * (c * b)) * d :=
      congrArg (fun t => t * d) (congrArg (fun t => a * t) (Nat.mul_comm _ _))
    _ = ((a * c) * b) * d :=
      congrArg (fun t => t * d) (mul_assoc_zero _ _ _).symm
    _ = (a * c) * (b * d) := mul_assoc_zero _ _ _

theorem odd_two_mul {a b : Nat} (ha : OddTwo a) (hb : OddTwo b) :
    OddTwo (a * b) := by
  rcases ha with ⟨r, hr⟩
  rcases hb with ⟨s, hs⟩
  refine ⟨2 * r * s + s + r, ?_⟩
  calc
    a * b = (2 * r + 1) * b := congrArg (fun t => t * b) hr
    _ = (2 * r + 1) * (2 * s + 1) :=
      congrArg (fun t => (2 * r + 1) * t) hs
    _ = (2 * r + 1) * (2 * s) + (2 * r + 1) * 1 := Nat.mul_add _ _ _
    _ = (2 * r + 1) * (2 * s) + (2 * r + 1) :=
      congrArg (fun t => (2 * r + 1) * (2 * s) + t) (Nat.mul_one _)
    _ = (2 * s) * (2 * r + 1) + (2 * r + 1) :=
      congrArg (fun t => t + (2 * r + 1)) (Nat.mul_comm _ _)
    _ = ((2 * s) * (2 * r) + (2 * s) * 1) + (2 * r + 1) :=
      congrArg (fun t => t + (2 * r + 1)) (Nat.mul_add _ _ _)
    _ = ((2 * s) * (2 * r) + 2 * s) + (2 * r + 1) :=
      congrArg (fun t => ((2 * s) * (2 * r) + t) + (2 * r + 1)) (Nat.mul_one _)
    _ = ((2 * 2) * (s * r) + 2 * s) + (2 * r + 1) :=
      congrArg (fun t => (t + 2 * s) + (2 * r + 1)) (mul_collect_zero _ _ _ _)
    _ = ((2 * 2) * (r * s) + 2 * s) + (2 * r + 1) :=
      congrArg (fun t => (t + 2 * s) + (2 * r + 1))
        (congrArg (fun t => (2 * 2) * t) (Nat.mul_comm _ _))
    _ = (2 * (2 * (r * s)) + 2 * s) + (2 * r + 1) :=
      congrArg (fun t => (t + 2 * s) + (2 * r + 1)) (mul_assoc_zero _ _ _)
    _ = (2 * (2 * r * s) + 2 * s) + (2 * r + 1) :=
      congrArg (fun t => (t + 2 * s) + (2 * r + 1))
        (congrArg (fun t => 2 * t) (mul_assoc_zero _ _ _).symm)
    _ = (2 * (2 * r * s) + (2 * s + (2 * r + 1))) := Nat.add_assoc _ _ _
    _ = ((2 * (2 * r * s) + 2 * s) + 2 * r) + 1 :=
      (Nat.add_assoc _ _ _).symm
    _ = (2 * (2 * r * s) + (2 * s + 2 * r)) + 1 :=
      congrArg (fun t => t + 1) (Nat.add_assoc _ _ _)
    _ = (2 * (2 * r * s) + 2 * (s + r)) + 1 :=
      congrArg (fun t => (2 * (2 * r * s) + t) + 1) (Nat.mul_add _ _ _).symm
    _ = 2 * (2 * r * s + (s + r)) + 1 :=
      congrArg (fun t => t + 1) (Nat.mul_add _ _ _).symm
    _ = 2 * (2 * r * s + s + r) + 1 :=
      congrArg (fun t => 2 * t + 1) (Nat.add_assoc _ _ _).symm

theorem odd_two_pow {a k : Nat} (ha : OddTwo a) : OddTwo (a ^ k) := by
  induction k with
  | zero => exact ⟨0, rfl⟩
  | succ k ih =>
    rw [Nat.pow_succ]
    exact odd_two_mul ih ha

theorem odd_two_add_odd_two_even {a b : Nat}
    (ha : OddTwo a) (hb : OddTwo b) : EvenTwo (a + b) := by
  rcases ha with ⟨r, hr⟩
  rcases hb with ⟨s, hs⟩
  refine ⟨r + s + 1, ?_⟩
  calc
    a + b = (2 * r + 1) + b := congrArg (fun t => t + b) hr
    _ = (2 * r + 1) + (2 * s + 1) :=
      congrArg (fun t => (2 * r + 1) + t) hs
    _ = 2 * r + (1 + (2 * s + 1)) := Nat.add_assoc _ _ _
    _ = 2 * r + ((1 + 2 * s) + 1) :=
      congrArg (fun t => 2 * r + t) (Nat.add_assoc _ _ _).symm
    _ = 2 * r + ((2 * s + 1) + 1) :=
      congrArg (fun t => 2 * r + (t + 1)) (Nat.add_comm _ _)
    _ = 2 * r + (2 * s + (1 + 1)) :=
      congrArg (fun t => 2 * r + t) (Nat.add_assoc _ _ _)
    _ = (2 * r + 2 * s) + (1 + 1) := (Nat.add_assoc _ _ _).symm
    _ = 2 * (r + s) + 2 := by
      rw [Nat.mul_add]
    _ = 2 * Nat.succ (r + s) := (Nat.mul_succ _ _).symm
    _ = 2 * (r + s + 1) := rfl

theorem even_two_ne_odd_two {n : Nat} (he : EvenTwo n) (ho : OddTwo n) : False := by
  rcases he with ⟨a, ha⟩
  rcases ho with ⟨b, hb⟩
  apply one_add_mul_ne_mul (Nat.le_refl 2)
  calc
    1 + 2 * b = 2 * b + 1 := Nat.add_comm _ _
    _ = n := hb.symm
    _ = 2 * a := ha

theorem even_two_of_pow_even {C z : Nat} (h : EvenTwo (C ^ z)) : EvenTwo C := by
  rcases even_or_odd_two C with hEven | hOdd
  · exact hEven
  · exact (even_two_ne_odd_two h (odd_two_pow hOdd)).elim

theorem pow_two_zero (n : Nat) : n ^ 2 = n * n := by
  calc
    n ^ 2 = n ^ 1 * n := Nat.pow_succ _ _
    _ = (n ^ 0 * n) * n := congrArg (fun t => t * n) (Nat.pow_succ _ _)
    _ = (1 * n) * n := rfl
    _ = n * n := congrArg (fun t => t * n) (Nat.one_mul _)

theorem eight_dvd_even_cube {C q : Nat} (hC : C = 2 * q) : 8 ∣ C ^ 3 := by
  refine ⟨q * q * q, ?_⟩
  calc
    C ^ 3 = (2 * q) ^ 3 := congrArg (fun t => t ^ 3) hC
    _ = ((2 * q) * (2 * q)) * (2 * q) := by
      calc
        (2 * q) ^ 3 = (2 * q) ^ 2 * (2 * q) := Nat.pow_succ _ _
        _ = ((2 * q) * (2 * q)) * (2 * q) :=
          congrArg (fun t => t * (2 * q)) (pow_two_zero _)
    _ = ((2 * 2) * (q * q)) * (2 * q) :=
      congrArg (fun t => t * (2 * q)) (mul_collect_zero _ _ _ _)
    _ = ((2 * 2) * 2) * ((q * q) * q) := mul_collect_zero _ _ _ _
    _ = 8 * (q * q * q) := rfl

theorem eight_dvd_even_pow_from_three (C q t : Nat) (hC : C = 2 * q) :
    8 ∣ C ^ (t + 3) := by
  induction t with
  | zero => exact eight_dvd_even_cube hC
  | succ t ih =>
    rcases ih with ⟨d, hd⟩
    refine ⟨d * C, ?_⟩
    calc
      C ^ (Nat.succ t + 3) = C ^ (t + 3) * C := by
        change C ^ Nat.succ (t + 3) = C ^ (t + 3) * C
        exact Nat.pow_succ _ _
      _ = (8 * d) * C := congrArg (fun u => u * C) hd
      _ = 8 * (d * C) := mul_assoc_zero _ _ _

theorem eight_dvd_even_pow {C z : Nat} (hC : EvenTwo C) (hz : 3 ≤ z) :
    8 ∣ C ^ z := by
  rcases hC with ⟨q, hq⟩
  cases z with
  | zero => exact (Nat.not_succ_le_zero 2 hz).elim
  | succ z =>
    cases z with
    | zero =>
      have htoo : 3 ≤ 2 := Nat.le_trans hz (Nat.le_succ 1)
      exact (Nat.not_succ_le_self 2 htoo).elim
    | succ z =>
      cases z with
      | zero => exact (Nat.not_succ_le_self 2 hz).elim
      | succ t => exact eight_dvd_even_pow_from_three C q t hq

theorem killshot_mod8
    {A B C x y z : Nat}
    (hBeal : IsBealSolution05Core A B C x y z)
    (hAOdd : A % 2 = 1)
    (hBOdd : B % 2 = 1) :
    8 ∣ A ^ x + B ^ y := by
  rcases hBeal with ⟨_, _, _, _, _, hz, hEq, _⟩
  have hAOddTwo : OddTwo A := odd_two_of_mod_eq_one hAOdd
  have hBOddTwo : OddTwo B := odd_two_of_mod_eq_one hBOdd
  have hLeftEven : EvenTwo (A ^ x + B ^ y) :=
    odd_two_add_odd_two_even (odd_two_pow hAOddTwo) (odd_two_pow hBOddTwo)
  have hCPowEven : EvenTwo (C ^ z) := by
    rcases hLeftEven with ⟨q, hq⟩
    exact ⟨q, hEq.symm.trans hq⟩
  have hCEven : EvenTwo C := even_two_of_pow_even hCPowEven
  have hEightC : 8 ∣ C ^ z :=
    eight_dvd_even_pow hCEven (Nat.succ_le_of_lt hz)
  exact hEq.symm ▸ hEightC

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
#print axioms mul_assoc_zero
#print axioms ne_zero_of_two_lt
#print axioms four_le_pow_of_two_le
#print axioms two_ne_pow_of_two_le
#print axioms dvd_pow_of_dvd_base
#print axioms add_pos_ne_one
#print axioms sub_add_two_of_two_le
#print axioms odd_two_of_mod_eq_one
#print axioms even_or_odd_two
#print axioms mul_collect_zero
#print axioms odd_two_mul
#print axioms odd_two_pow
#print axioms odd_two_add_odd_two_even
#print axioms even_two_ne_odd_two
#print axioms even_two_of_pow_even
#print axioms pow_two_zero
#print axioms eight_dvd_even_cube
#print axioms eight_dvd_even_pow_from_three
#print axioms eight_dvd_even_pow
#print axioms killshot_no_2p_isogeny
#print axioms killshot_level_2_no_ribet
#print axioms killshot_mod8
#print axioms killshot_squarefree_contradiction