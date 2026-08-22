# Beal Conjecture — a formal instrument in *Opera Numerorum*

[![beal-conjecture CI](https://github.com/DavidFox998/beal-conjecture/actions/workflows/main.yml/badge.svg)](https://github.com/DavidFox998/beal-conjecture/actions)

This repository is one chamber of David Fox's *Opera Numerorum*: a growing
collection of machine-checked arithmetic, geometry, and analysis in Lean 4.
It studies the Beal Conjecture through a sequence of formal layers, from
elementary divisibility to the elliptic-curve language suggested by the Frey
construction.

The aim is not to make a green build look like a finished theorem. The aim is
to make each mathematical dependency visible, inspectable, and worthy of
trust.

> **Important status**
>
> This repository is a formalization scaffold, not a completed proof of
> Beal's Conjecture. Lean accepts the declarations currently present, but
> several later layers are still explicit scaffolding for mathematics that has
> not yet been formalized here. A compiled interface is not the same thing as
> a proved modularity or level-lowering theorem.

## Beal formalization status: `v1.0-zero-sorry-staged`

This is the status of the staged Beal development as of the current
zero-placeholder milestone. The milestone is intentionally stronger than
"the files compile" and intentionally weaker than "Beal's Conjecture is
proved". Every remaining deep mathematical dependency is named, typed, and
kept at a visible boundary.

### Build and audit status

The focused staged package builds successfully:

```text
lake build Beal.B15_X0_10_Wrapper \
           Beal.B16_S2_Level2_Wrapper \
           Beal.KillshotSearch
```

The repository-wide literal-placeholder check is empty:

```text
grep -r "sorry" lean/
# no output: no literal `sorry` token in Lean code or comments
```

The Core audit executable `check_zero_axiom_core` reports zero axioms for the
audited B05, B14, B15, and B16 Core declarations, including the opaque
certificate propositions. The strict Core surface contains no Mathlib
factorization, division, real-number, modular-form, or elliptic-curve
implementation.

Wrapper audits are deliberately a different question. Ordinary Mathlib
transport in the approved wrapper calculations can report
`propext`, `Classical.choice`, and `Quot.sound`; these are documented rather
than hidden. The B14 wrapper additionally exposes the explicit
`frey_conductor_computation` input, while B05 exposes the named
`mazur_irreducibility_axiom` and `wiles_lifting_axiom` inputs. None of these
are `sorryAx`, and none is silently counted as a Core theorem.

### What the staged package proves

The formal development starts from the primitive Beal shape

\[
A^x+B^y=C^z,\qquad A,B,C>0,\qquad x,y,z>2,
\]

with the primitive condition represented in Core by an explicit common-divisor
witness and in the public wrapper by
\[
\operatorname{Nat.gcd}(A,\operatorname{Nat.gcd}(B,C))=1.
\]

The B01 conversion theorems
`primitiveTripleCore_of_gcd_eq_one`,
`gcd_eq_one_of_primitiveTripleCore`,
`isBealSolution_wrapper_to_core`,
`isBealSolutionCore_to_wrapper`,
`bealConjecture_wrapper_to_core`, and
`bealConjectureCore_to_wrapper` show that the two representations describe the
same primitive-solution interface. B02 defines the Frey discriminant and
proves `freyΔ_ne_zero_of_solution` for positive solutions. B03 proves the
elementary exact-division consequences:
`exactDivides_of_dvd_not_sq`, `divideOut_of_exact`, and
`squarefree_of_primitive_gcd`.

The later staged theorem inventory is:

1. **Import-free arithmetic and typed modularity interfaces (B05).**
   `IsBealSolution05Core` records positivity, exponents greater than two, the
   Beal equation, and primitive-triple data without importing Mathlib.
   `ExactFreyConductorFactor` records that a prime \(p\geq5\) divides the
   conductor exactly once, and `FreyLevelLowering` records the lowered level.
   The theorem `lower_frey_conductor_of_exact_factor` proves the arithmetic
   factor-removal step once that exact-factor certificate is available.

   The remaining global bridges are named rather than disguised:

   - `RibetLevelLoweringHypothesisReal` asks for the solution-tied exact
     conductor factor and level-two lowering.
   - `MazurIrreducibilityHypothesisReal` asks for irreducibility of the
     abstract Frey representation for \(p\geq5\).
   - `WilesLiftingHypothesis` asks for modularity of the abstract Frey curve.

   `modularity_hypothesis_of_bridges` assembles those three typed bridges.
   The backwards-compatible public package
   `modularity_hypothesis_with_assumptions` supplies them through the named
   inputs `frey_conductor_computation`,
   `mazur_irreducibility_axiom`, and `wiles_lifting_axiom`. This is a typed
   conditional package, not a first-principles proof of Ribet, Mazur, or
   Wiles in this repository.

2. **B14: the sole factorization/radical-prime boundary.**
   The wrapper defines the Mathlib radical
   `Rad n` and proves `rad_dvd_self` and `prime_factor_of_rad`.
   The theorem `radical_prime_imp_prime_power` is the closed finite
   factorization bridge: if \(A,B,C>0\) and
   \[
   \operatorname{Rad}(ABC)=p
   \]
   for a prime \(p\), then it constructs
   `RadPrimePowerCertificate14Core A B C p`, namely witnesses
   \(a,b,c\) with \(A=p^a\), \(B=p^b\), and \(C=p^c\).

   The theorem `frey_conductor_to_rad_prime_power` cancels the leading factor
   \(2\) from the concrete conductor formula
   \[
   N=2\,\operatorname{Rad}(ABC)=2p
   \]
   and feeds the resulting radical identity into the closed factorization
   bridge. This is the part of B14 that is closed.

   The separate `FreyConductorComputation` declaration remains an explicit
   deep arithmetic input: it asserts that a Beal solution supplies a prime
   \(p\geq5\) with the displayed conductor value. It is represented by
   `frey_conductor_computation`, not by `sorry`, and is the reason the
   solution-tied conductor theorem must still be described as staged.

3. **B15: the sole \(X_0(10)\), \(R_4(10)\) boundary.**
   The import-free Core contains only certificate shapes for rational cyclic
   subgroups, full rational 2-torsion, rational 5-isogenies, rational
   10-isogenies, and their subgroup product. The theorem
   `full2Torsion_mul_5_isogeny_imp_10_isogeny` proves the elementary order
   calculation: a rational cyclic product of order \(2\cdot5\) is a rational
   10-isogeny. The Core exposes the resulting no-Frey proposition as
   `X0_10_no_Frey`.

   The wrapper records both displayed \(R_4(10)\) \(j\)-coordinates,
   `R4_10_j_E1` and `R4_10_j_E10`, and the Frey invariant
   `frey_j`. It defines:

   - `FreyJInR4_10Image`, the non-cuspidal rational \(j\)-image condition;
   - `FreyV2ProductAtLeastThree`, the explicit 2-adic lower bound;
   - `R4_10FreyLocalData`, combining that valuation condition with
     \(8\mid A^x+B^y\);
   - `FreyRational10ToR4_10Image`, the rational-10-isogeny-to-\(j\)-image
     bridge;
   - `R4_10ValuationTables17_31`, the certificate-shaped form of the
     González-Jiménez--Lario Proposition 17 / Tables 17 and 31 argument.

   `frey_j_not_in_image` and
   `x0_10_no_Frey_of_valuation_tables` compose those inputs into the Core
   no-Frey conclusion. The valuation cases, Tate-algorithm details, and
   rational-isogeny-to-\(j\)-map theorem are not silently asserted as proved:
   `R4_10ValuationTables17_31` and
   `FreyRational10ToR4_10Image` remain explicit B15 wrapper certificate
   inputs. This is an honest staged boundary, not a placeholder proof.

4. **B16: the sole \(S_2(\Gamma_0(2))=0\) boundary.**
   The import-free Core defines carriers for level-two modular data and
   weight-two cusp-form witnesses, and keeps
   `LevelTwoNoCuspFormCore` opaque. The theorem
   `ribet_level_two_contradiction_core` is a genuine contradiction rule:
   it needs both a no-cusp certificate and an explicit opposing
   `¬ LevelTwoNoCuspFormCore` witness. An opaque proposition by itself is not
   allowed to manufacture `False`.

   The wrapper retains the cited source calculation as
   `S2_Gamma0_2_DimensionCertificate`, consisting of:

   - `X0_2_genus_zero`, the genus \(g(X_0(2))=0\);
   - `num_cusps_X0_2`, the two-cusp count;
   - the Diamond--Shurman identity identifying the weight-two dimension with
     the genus.

   From that certificate, `S2_Gamma0_2_dimension_zero` proves
   `S2DimensionAtLevel2 = 0`. The separate
   `DimensionZeroNoCuspCertificate` converts dimension zero into the opaque
   Core no-cusp proposition, and
   `x0_2_no_Frey_of_dimension_zero` performs that conversion.
   Finally, `ribet_level_two_contradiction_of_dimension` composes the wrapper
   data with the explicit opposing level-two Frey-form witness. The genus,
   cusp-count, and full dimension calculation are therefore visible
   certificate inputs, not fabricated Core axioms.

5. **The killshot search.**
   `KillshotSearch.lean` imports only Core interfaces and contains five
   independent attempts to bypass the modularity route:

   - The prime-radical branch is closed conditionally by
     `killshot_rad_prime_branch`, using the B14
     `RadPrimePowerCertificate14Core`.
   - The \(2p\)-isogeny route is recorded by
     `killshot_no_2p_isogeny`; its missing geometric implications remain
     explicit through `HasFullTwoTorsion`, `HasRationalPIsogeny`,
     `HasRational2pIsogeny`, and opposing hypotheses.
   - The level-two alternative is recorded by
     `killshot_level_2_no_ribet`; it requires explicit
     `HasLevelTwoFreyForm` and its negation rather than claiming the missing
     level-lowering theorem.
   - `killshot_mod8` is a closed zero-axiom parity proof. For odd \(A\) and
     \(B\), it proves
     \[
     8\mid A^x+B^y
     \]
     from the Beal equation and \(x,y,z>2\), by developing parity and power
     divisibility directly from Nat recursion and explicit witnesses.
   - `frey_discriminant_is_square` proves the Frey identity
     \[
     \Delta=16(A^xB^yC^z)^2=(4A^xB^yC^z)^2.
     \]
     `killshot_rad_prime_power_contradiction` then records the already-closed
     radical-prime-power contradiction. Squarefreeness and the exact-conductor
     predicates do not yet imply that radical certificate, so that implication
     is not claimed.

6. **B21: the Fermat corollary.**
   The Core and wrapper record the elementary implication from a primitive
   Fermat solution \(a^n+b^n=c^n\), \(n>2\), to a primitive Beal solution.
   The theorems `beal_implies_fermat21_core`,
   `beal_implies_fermat_full21_core`, `beal_implies_fermat`,
   `beal_conjecture_to_21_core`, `beal_implies_fermat_full_core`, and
   `beal_implies_fermat_full` express that corollary. They do not use Fermat's
   Last Theorem as a premise and do not turn the conditional Beal scaffold
   into a completed proof.

### Staged boundaries and their meaning

| Boundary | Current status | What is checked | What remains an explicit input |
| --- | --- | --- | --- |
| **B14** | Closed arithmetic factorization boundary | `Rad` divisibility, prime-factor extraction, prime radical \(\Rightarrow\) prime-power certificate, and conductor \(2\)-cancellation | The solution-tied Frey conductor computation `frey_conductor_computation` |
| **B15** | Honest \(X_0(10)\)/\(R_4(10)\) certificate boundary | \(j\)-map definitions, local-data shape, Core subgroup-product theorem, and certificate composition | González-Jiménez--Lario valuation cases and rational 10-isogeny-to-\(j\)-image bridge |
| **B16** | Honest \(S_2(\Gamma_0(2))=0\) certificate boundary | Core contradiction rule and wrapper composition of genus/dimension/no-cusp certificates | The source genus/cusp/dimension calculation and its no-cusp conversion |
| **B05** | Typed modularity boundary | Exact-factor arithmetic and assembly of typed bridges | Ribet/conductor computation, Mazur irreducibility, and Wiles lifting/modularity |

The wrappers contain certificate inputs because Mathlib does not currently
provide the checked \(R_4(10)\) Kodaira-valuation argument, the full Tate
algorithm calculation needed here, or the complete weight-two
\(S_2(\Gamma_0(2))\) dimension theorem in the exact form required by this
development. Keeping those facts as explicit hypotheses is preferable to
proving a weaker statement under a misleading name.

### Publication and future work

This staged code is suitable as an auditable Lean supplement to a paper
submission: the verified arithmetic and logical composition are separated
from the cited mathematical certificates, and the remaining obligations are
visible to a referee. It is not a completed machine-checked proof of Beal's
Conjecture. Any paper using the package should cite the underlying sources
for the B14 conductor input, the B15 \(R_4(10)\) valuation certificate, and
the B16 Diamond--Shurman dimension certificate.

The two replacement tasks are queued and currently blocked by the project
concurrency limit, but they do not block publication of this staged
milestone:

- **Task #371 — PENDING:** replace the Frey conductor proxy/input with the
  real level-lowering proof.
- **Task #375 — PENDING:** turn the cited \(X_0(10)\) valuation table into a
  checked theorem.

These are long-horizon formalization tasks. Their eventual completion will
replace wrapper certificates with checked theorems; it will not change the
zero-sorry methodology or the Core/wrapper separation.

## The wider work: *Opera Numerorum* and four routes toward RH

The Beal development is not itself a proof of the Riemann Hypothesis. It is
part of a wider program in which different mathematical languages are used to
approach the same landscape: Arakelov geometry, automorphic forms, spectral
gaps, arithmetic dynamics, and growth of zeta functions.

The program currently has four distinct routes toward RH. They are separate
formalization paths, not four paragraphs of one hidden proof. Their value is
that independent viewpoints can meet at common arithmetic data and expose one
another's assumptions.

### Route A — Act I: positivity

[`riemann-arakelov-positivity`](https://github.com/DavidFox998/riemann-arakelov-positivity)
turns positivity on the modular curve \(X_0(143)\) into an arithmetic
inequality. Its architecture centers on
\[
g(X_0(143))=13,\qquad \omega^2=\frac{48}{13},
\]
and the finite set
\[
S_4=\{2,3,19,191\}.
\]
The intended chain is Arakelov positivity, a GRH statement for the relevant
finite data, a Bost-type bound, and finally RH. Each arrow is a mathematical
obligation; the repository is where the current formal status of those
obligations must be checked.

### Route B — Act II: descent

[`arakelov-rh-descent`](https://github.com/DavidFox998/arakelov-rh-descent)
approaches the same territory through a spectral gap on \(X_0(143)\), with
\[
\lambda_1\geq \frac{975}{4096}
\]
as the stated Kim–Sarnak input. The route passes through Selberg-type
spectral information and the Bost–Connes viewpoint before returning to the
same finite arithmetic gate.

### Route C — Act III: growth

[`rh-growth-contradiction`](https://github.com/DavidFox998/rh-growth-contradiction)
takes a contradiction route. It compares the growth permitted by a proposed
zeta bound with Littlewood's \(\Omega\)-phenomenon, and studies zero
repulsion through the \(p=5\) bridge. Its language is not geometric descent
but the tension between analytic growth and the distribution of zeros.

### Route D — Act IV: the brothers' desert

[`brothers-desert-proof`](https://github.com/DavidFox998/brothers-desert-proof)
is the fourth line of attack. It is intentionally kept as a separate route:
its hypotheses, reductions, and audit trail should be read in its own
repository rather than silently imported into this Beal development.

### Shared anchors

The routes repeatedly meet around the finite arithmetic datum
\[
S_4=\{2,3,19,191\},\qquad C(S_4)\approx 11.422>2\sqrt{13}.
\]
The current core and bridge repositories are:

- [`arakelov-positivity-rh-core`](https://github.com/DavidFox998/arakelov-positivity-rh-core) —
  the common RH core, including the B158 architecture and its 18 sub-atoms.
- [`rh-p5-bridge-14`](https://github.com/DavidFox998/rh-p5-bridge-14) —
  the \(p=5\) numerical bridge around \(143\cdot13=1859\), \(S_{14}=14\),
  \(q_5=226\), and \(h=10\).

These links describe the architecture of the program. They should not be
read as a claim that this README, or this Beal repository alone, has closed
RH.

## What is Beal?

Beal's Conjecture is an assertion about the rarest kind of coincidence in
elementary number theory: three perfect powers adding to a perfect power when
all three exponents exceed two.

For positive integers \(A,B,C\) and integers \(x,y,z>2\), suppose
\[
A^x+B^y=C^z.
\]
The conjecture says that \(A,B,C\) cannot be pairwise free of a common
factor. In the compact conventional form,
\[
\gcd(A,B,C)>1.
\]
Equivalently, there is no **primitive** solution:
\[
\gcd(A,B,C)=1.
\]
In this repository the public Lean wrapper writes the condition as
\[
\operatorname{Nat.gcd}(A,\operatorname{Nat.gcd}(B,C))=1
\]
when it describes a putative primitive solution.

That is the heart of the conjecture—not the prize associated with it. The
beauty of Beal is that it asks a very small equation to carry a very large
amount of arithmetic structure. A solution would have to reconcile
divisibility, the geometry of a Frey elliptic curve, modular forms, Galois
representations, and the descent of a conductor. The equation is elementary;
the obstruction it predicts is not.

The connection to Fermat's Last Theorem is immediate and illuminating. If
\[
a^n+b^n=c^n,\qquad n>2,
\]
were a primitive positive solution, then it would be a Beal solution with
\(x=y=z=n\). Thus Beal would imply Fermat's Last Theorem. The B21 layer records
this implication as a corollary. It does not use Fermat as a premise, and it
does not turn the conditional implication into a proof of Beal.

## Layout of the formal development

The repository is a 21-layer tower:

```text
lean/
├── Beal.lean                         # root import: every core, then wrapper
└── Beal/
    ├── B01_Def_Core.lean             # import-free foundational predicates
    ├── B01_Def.lean                  # public Nat.gcd API and bridges
    ├── B02_Frey_Core.lean
    ├── B02_Frey.lean
    ├── ...
    ├── B20_BealConjectureDone_Core.lean
    ├── B20_BealConjectureDone.lean
    ├── B21_FermatCorollary_Core.lean
    └── B21_FermatCorollary.lean
```

Every layer has two faces:

1. **The core** is deliberately import-free. It uses Lean's foundational
   propositions and explicit witness predicates. Where a convenient
   Mathlib definition might conceal a dependency, the core spells out the
   relevant relation directly.
2. **The wrapper** is the Mathlib-facing interface. It preserves familiar
   names and statements for downstream work. In particular, B01 and B21 keep
   the conventional `Nat.gcd` formulation while proving conversions to and
   from the primitive common-divisor witnesses used by the cores.

The principal mathematical movement through the tower is:

| Layers | Mathematical role |
| --- | --- |
| B01–B02 | Beal solutions, primitivity, and the Frey discriminant |
| B03–B05 | conductor, modularity interfaces, and the Hasse-bound layer |
| B06–B10 | bridges between the Frey data, Galois language, and level lowering |
| B11–B15 | epsilon, Ribet, conductor, and descent interfaces |
| B16–B20 | the final assembly interfaces; some are still scaffolding |
| B21 | the constructive Beal-to-Fermat corollary bridge |

The word *interface* matters. A Lean declaration can make the type of a
mathematical step precise before the deep theorem supplying that step has
been formalized. That is useful engineering and honest mathematics only when
the distinction remains visible.

## Methodology: audit the boundary, not just the theorem name

The project uses a core/wrapper discipline so that a reader can ask two
different questions:

- What does the statement require at the foundational level?
- What convenience, quotient, or classical machinery enters the public API?

CI checks the following:

- all B01–B21 core modules are import-free;
- core declarations have no axioms;
- strict wrapper theorems contain no `Classical.choice`, `Quot.sound`, or
  `sorryAx`;
- `propext` is allowed where ordinary proposition extensionality enters;
- the exact trusted real-number boundary remains isolated and documented.

### The real-number boundary

`BealHasseWiles.BSD_HasseFull_143_CLOSED` preserves a historical theorem about
the concrete type `ℝ`. In Lean 4.12 and Mathlib, the implementation of the
real numbers passes through quotient and completion constructions. Even an
elementary order proof can therefore report
\[
[\texttt{propext},\ \texttt{Classical.choice},\ \texttt{Quot.sound}].
\]

This is not silently mixed into the strict integer audit. It is recorded as a
trusted Mathlib transport boundary, checked for its exact dependency budget,
and rejected if `sorryAx` appears. The import-free B05 core and the strict
integer theorem remain available for the part of the argument that does not
need the concrete implementation of `ℝ`.

## Status: what “green” means here

“Green” means that the current Lean source elaborates, its declared
dependencies are visible, and the relevant audit checks pass. It does **not**
mean that every named historical theorem—especially modularity, Ribet
level-lowering, or the final contradiction—has been reconstructed from first
principles in this repository.

The next honest frontier is to replace scaffolding propositions in B11–B20
with precise mathematical hypotheses and proofs, while preserving the same
audit discipline. A future theorem should become stronger because its
mathematics has been supplied, not because its name has been moved farther down
the tower.

## Build and audit

The project uses Lean 4.12.0 and Mathlib:

```bash
export PATH="$HOME/.elan/bin:$PATH"
lake exe cache get
lake build Beal
```

The CI workflow additionally checks imports, `#print axioms` output, the
strict wrapper budget, and the documented real-number exception.

## Related work

The surrounding *Opera Numerorum* includes formal work on:

- BSD and the \(143a1\) elliptic curve;
- Bost–Connes and the finite \(S_4\) gate;
- the canonical arithmetic sieve;
- the Lindelöf Hypothesis;
- Yang–Mills, Navier–Stokes, and P vs NP;
- the ZeroBeacon MCP catalog.

Each repository has its own scope and audit boundary. The intended relation is
composition by explicit statements and certificates, not an invisible web of
imports.

## References

- Andrew Beal (1997) — the Beal Conjecture.
- Gerhard Frey (1986) — the Frey curve and the bridge from Diophantine
  equations to elliptic curves.
- Kenneth Ribet (1990) — level lowering.
- Barry Mazur (1978) — irreducibility phenomena for Galois representations.
- Andrew Wiles (1995) — modularity and Fermat's Last Theorem.
- [`ImperialCollegeLondon/FLT`](https://github.com/ImperialCollegeLondon/FLT) —
  inspiration for formalization, not a dependency of this repository.

Maintained by DavidFox998 as part of *Opera Numerorum*: mathematics made
auditable, with the beauty left visible.