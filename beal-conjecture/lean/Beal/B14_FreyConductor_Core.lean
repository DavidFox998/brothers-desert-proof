-- B14_FreyConductor_Core — zero-import conductor certificates.
def Divides14Core (d n : Nat) : Prop := ∃ q : Nat, n = d * q

def Prime14Core (p : Nat) : Prop :=
  1 < p ∧ ∀ a b : Nat, p = a * b → a = 1 ∨ b = 1

def FreyConductorSchematic (A B C _ _ _ : Nat) : Nat := A * B * C

/--
The Core layer does not depend on a factorization implementation.  A
certificate records the two properties needed from a radical: it divides its
input, and every prime divisor of the certificate divides that input.
-/
def RadCertificate (n r : Nat) : Prop :=
  Divides14Core r n ∧
    ∀ p : Nat, Prime14Core p → Divides14Core p r → Divides14Core p n

def FreyConductorRealCertificate (A B C r : Nat) : Prop :=
  RadCertificate (A * B * C) r

def FreyConductorDividesABC14Core (A B C N : Nat) : Prop :=
  ∀ p : Nat, Prime14Core p → Divides14Core p N →
    Divides14Core p A ∨ Divides14Core p B ∨ Divides14Core p C

def BealPrimesNotDivideConductor14Core : Prop :=
  ∀ A B C p N : Nat, Prime14Core p →
    ¬ Divides14Core p A → ¬ Divides14Core p B → ¬ Divides14Core p C →
    FreyConductorDividesABC14Core A B C N → ¬ Divides14Core p N

#print axioms Divides14Core
#print axioms Prime14Core
#print axioms FreyConductorSchematic
#print axioms RadCertificate
#print axioms FreyConductorRealCertificate
#print axioms FreyConductorDividesABC14Core
#print axioms BealPrimesNotDivideConductor14Core