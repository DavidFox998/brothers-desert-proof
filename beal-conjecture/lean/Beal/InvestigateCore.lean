-- Investigation file: import-free proofs about p ∣ N, ¬(p*p ∣ N) → (N/p)*p = N and N/p ≠ N
-- Also: radical definition

-- ============================================================
-- Part 1: Local prime predicate (same style as existing files)
-- ============================================================

def IsPrimeCore (p : Nat) : Prop :=
  2 ≤ p ∧ ∀ m, m ∣ p → m = 1 ∨ m = p

-- ============================================================
-- Part 2: Theorem (N / p) * p = N from p ∣ N (no propext needed)
-- ============================================================

-- Nat.div_mul_cancel : p ∣ N → N / p * p = N  (this is in Lean 4 core)
-- Let's check what's available in core Lean without imports

-- Attempt 1: use Nat.div_mul_cancel directly (core theorem)
theorem div_mul_eq_of_dvd (p N : Nat) (h : p ∣ N) : N / p * p = N :=
  Nat.div_mul_cancel h

-- Attempt 2: prove via the witness in the divisibility definition
theorem div_mul_eq_of_dvd' (p N : Nat) (h : p ∣ N) : N / p * p = N := by
  obtain ⟨k, hk⟩ := h
  rw [hk]
  rw [Nat.mul_div_cancel_left]
  · ring
  · omega

-- ============================================================
-- Part 3: Theorem N / p ≠ N from p ∣ N, ¬(p*p ∣ N), IsPrimeCore p
-- ============================================================

-- Key insight: if N/p = N, then p * (N/p) = p * N ≥ p * N > N (for p ≥ 2)
-- But we know (N/p) * p = N. So p * N = N => (p-1)*N = 0 => p=1 or N=0.
-- Since p ≥ 2 and N > 0 (from p ∣ N with p ≥ 2), contradiction.

-- First: from p ∣ N and p ≥ 2, N > 0
theorem pos_of_prime_dvd (p N : Nat) (hp : IsPrimeCore p) (h : p ∣ N) : 0 < N := by
  obtain ⟨hp2, _⟩ := hp
  obtain ⟨k, hk⟩ := h
  by_contra h0
  push_neg at h0
  interval_cases N
  simp at hk
  omega

-- Now: N/p ≠ N
theorem div_ne_self_of_prime_exact (p N : Nat)
    (hp : IsPrimeCore p) (hdvd : p ∣ N) (hnsq : ¬ (p * p ∣ N)) :
    N / p ≠ N := by
  obtain ⟨hp2, _⟩ := hp
  -- From p ∣ N we know N = (N/p) * p
  have heq : N / p * p = N := Nat.div_mul_cancel hdvd
  intro heqN
  -- If N/p = N, then N * p = N
  rw [heqN] at heq
  -- heq : N * p = N
  have hpos : 0 < N := pos_of_prime_dvd p N ⟨hp2, _⟩ hdvd
  -- N * p = N means p = 1 (since N > 0), contradicts p ≥ 2
  have hp1 : p = 1 := by
    have : N * p = N * 1 := by linarith [heq]
    exact Nat.eq_of_mul_eq_mul_left hpos this
  omega

-- ============================================================
-- Part 4: Alternative direct proof sketch using omega/decide
-- ============================================================

-- Simpler: if (N/p)*p = N and N/p = N, then N*p = N, so N*(p-1)=0, 
-- but p≥2 so p-1≥1, so N=0. But p∣N and p≥2 means N≥p≥2. Contradiction.

theorem div_ne_self_simple (p N : Nat)
    (hp2 : 2 ≤ p) (hdvd : p ∣ N) :
    N / p ≠ N := by
  have heq : N / p * p = N := Nat.div_mul_cancel hdvd
  -- N > 0 since p ∣ N and p ≥ 2
  obtain ⟨k, hk⟩ := hdvd
  have hkpos : 0 < k := by
    by_contra h
    push_neg at h
    interval_cases k
    simp at hk
    linarith [hk]
  intro heqN
  rw [heqN] at heq
  -- heq: N * p = N, so N * (p - 1) = 0
  have hN : 0 < N := by linarith [hk]
  nlinarith

-- ============================================================
-- Part 5: Radical (product of distinct prime divisors) — import-free
-- ============================================================

-- A "radical" over Nat requires listing distinct prime divisors and taking product.
-- Without Multiset/List from Mathlib, we need Lean core's List.
-- Lean 4 core does have List, Nat.primeFactors requires Finset (Mathlib).
-- We can define a computational version using Nat.minFac recursively.

-- Lean 4 core: Nat.minFac is available (it's in Init)
-- Nat.minFac n returns the smallest prime factor of n (or n itself if prime/1)

-- Recursive radical definition (import-free using fuel):
def radicalAux (n fuel : Nat) : Nat :=
  match fuel with
  | 0 => 1
  | Nat.succ f =>
    if n ≤ 1 then 1
    else
      let p := Nat.minFac n
      if n % p = 0 then
        -- divide out ALL factors of p, then recurse
        let n' := n / p
        let rest := radicalAux (n' / (if n' % p = 0 then
          -- keep dividing by p until p does not divide
          -- We need a helper for this
          1 else 1)) f
        p * radicalAux (n / p ^ (Nat.log p n + 1)) f  -- placeholder
      else 1

-- The above gets complicated. Let's use a cleaner approach:
-- radical via Nat.factors (available in Lean 4 core Init.Data.Nat.Factors? No.)
-- Actually Nat.factors is NOT in core lean4 without mathlib.

-- Simpler approach: define radical as a Prop (squarefree kernel), not a Nat value:
def IsRadicalOf (R N : Nat) : Prop :=
  -- R divides N
  R ∣ N ∧
  -- every prime that divides R also divides N
  (∀ p, IsPrimeCore p → p ∣ R → p ∣ N) ∧
  -- every prime that divides N also divides R
  (∀ p, IsPrimeCore p → p ∣ N → p ∣ R) ∧
  -- R is squarefree
  (∀ p, IsPrimeCore p → ¬ (p * p ∣ R))

-- This is import-free and axiom-free as a definition.

-- Can we prove existence? In general, constructing rad(N) as a Nat 
-- requires classical logic or decidability of prime factorization.
-- Without imports, Nat.minFac IS available in Lean 4 core (in Init).

-- Let's check: is Nat.minFac in scope without imports?
#check Nat.minFac  -- Should work in Lean 4 core

-- ============================================================
-- Part 6: Check axioms
-- ============================================================
#print axioms IsPrimeCore
#print axioms div_mul_eq_of_dvd
#print axioms div_ne_self_of_prime_exact
#print axioms div_ne_self_simple
#print axioms IsRadicalOf
