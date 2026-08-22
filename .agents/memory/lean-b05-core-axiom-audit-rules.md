---
name: Lean B05 Core audit rules
description: Durable rules for Core declarations and honest conditional hypotheses in beal-conjecture.
---

## Lasting Core rule

Core declarations must be import-free and each audited declaration must report
that it does not depend on any axioms.

**Why:** the project treats Core as its auditable, trusted arithmetic layer.
Seemingly ordinary Nat operations and proof automation can pull in `propext`,
which violates that boundary.

**How to apply:** in Core types, avoid `Nat.gcd`, `Nat.div`, and `Nat.mod`;
use structural arithmetic and express exact lowering as `N = p * 2`.

## Prime-factor interfaces

An inequality such as `5 ≤ p` is not evidence that `p` is prime. Any
conductor factor intended to play the Ribet prime must carry an import-free
primality predicate as well as its lower bound and exact-divisibility facts.

**Why:** composite exact divisors, such as 6, otherwise satisfy the interface
and make a purported “prime” level-lowering statement overclaim its content.

**How to apply:** use the local Core primality predicate in both exact-factor
and primitive/common-factor hypotheses; unwrap only the divisibility facts for
the arithmetic quotient lemma.

For conditional mathematical statements, curry actual solution hypotheses
before the conclusion:

```lean
∀ data, condition₁ → condition₂ → conclusion
```

Do not group all conditions into a single implication premise. That premise can
hold vacuously for non-solutions and make the claimed conclusion dishonest.
