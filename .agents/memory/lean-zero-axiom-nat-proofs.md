---
name: Lean zero-axiom Nat proofs
description: Lean 4.12 standard Nat arithmetic lemmas and omega can introduce audited axioms.
---

For a declaration that must pass a strict zero-axiom audit in this Lean 4.12 project, do not assume that a theorem about `Nat` is axiom-free.

**Why:** `Nat.dvd_sub`, `Nat.le_of_dvd`, `Nat.pow_add`, cancellation lemmas, and `omega` can introduce `propext` and sometimes `Quot.sound` into the declaration's transitive axiom report.

**How to apply:** For elementary zero-axiom arithmetic, prefer direct induction, constructor discrimination, equality transport, and explicit divisibility witnesses. Run `#print axioms` on each new theorem rather than relying on the apparent purity of its statement.