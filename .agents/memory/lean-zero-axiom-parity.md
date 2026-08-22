---
name: Lean zero-axiom parity
description: Keeping elementary parity and divisibility proofs audit-clean in Lean 4.12 Core modules.
---

For strict Core arithmetic, do not rely on Lean 4.12's convenient modular
arithmetic, multiplicative power, or broad divisibility transport lemmas.
Several of them audit with `propext` (and some related convenience results
carry further classical dependencies).

**Why:** A proof about `% 2`, odd powers, or divisibility by eight can look
elementary while silently breaking the project's zero-axiom contract through
those library lemmas.

**How to apply:** Build parity from explicit `2 * q` / `2 * q + 1` witnesses.
When a remainder hypothesis is unavoidable, use the audit-clean remainder
reduction recursion (`Nat.mod_eq_sub_mod`) and prove only the small
subtraction cancellation needed. Propagate parity through multiplication and
powers with direct induction, and give explicit witnesses for divisibility.