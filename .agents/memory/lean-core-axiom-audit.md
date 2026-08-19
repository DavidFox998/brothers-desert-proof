---
name: Lean core axiom audit
description: Why an import-free declaration can still depend on a standard axiom in Lean 4.12.
---

For a genuinely axiom-free Lean 4.12 definition, avoid using `Nat.gcd` in the
core declaration: `#print axioms` reports that `Nat.gcd` depends on `propext`,
even when the file has no imports.

**Why:** “zero imports” only limits the module dependencies; it does not
guarantee that core-library declarations have no axiomatic dependencies.
The Beal primitive/common-divisor formulation was used instead of a gcd
equality so the core statement could pass an actual axiom audit.

**How to apply:** Keep foundational definitions in an import-free core module
using direct arithmetic witnesses where needed. Put bridges to convenience
definitions such as `Nat.gcd` in a Mathlib wrapper, and have CI run
`#print axioms` plus an explicit check for `propext`, `Classical.choice`,
`Quot.sound`, and `sorryAx`.