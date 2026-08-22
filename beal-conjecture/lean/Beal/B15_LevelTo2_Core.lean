-- B15_LevelTo2_Core — zero-import exact-division reduction.
def ExactDivides15Core (p N : Nat) : Prop :=
  p ∣ N ∧ ¬ (p * p ∣ N)

def CanLowerLevel15Core (N p M : Nat) : Prop :=
  M * p = N ∧ ¬ (p ∣ M)

theorem exact_division_witness15_core {p N : Nat}
    (h : p ∣ N) : ∃ M, M * p = N := by
  rcases h with ⟨M, hM⟩
  exact ⟨M, (Nat.mul_comm M p).trans hM.symm⟩

#print axioms ExactDivides15Core
#print axioms CanLowerLevel15Core
#print axioms exact_division_witness15_core