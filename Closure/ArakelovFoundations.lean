-- Closure/ArakelovFoundations.lean
-- Vendored closed Abbes-Ullmo / Arakelov positivity results for Route D.
--
-- Source: Closure.RouteCClosed (namespace RouteC, 0 sorry, 0 axiom).
-- RouteD imports THIS file instead of reaching directly into RouteCClosed,
-- so the dependency graph stays explicit: RouteD → ArakelovFoundations → RouteCClosed.
--
-- Clay rule: all results here are 0 sorry, 0 axiom — proofs are delegated
-- to Closure.RouteCClosed, not re-proved or re-axiomatized.

import Closure.RouteCClosed
import Mathlib.Analysis.SpecialFunctions.Sqrt

namespace ArakelovFoundations

open Real

-- ============================================================
-- Re-exported Abbes-Ullmo / SelbergWeil BC6 results
-- ============================================================

/-- Hasse-Weil bound for the only elliptic factor a₁ of X₀(143).
    Proved in RouteCClosed via Deligne 1974 for N=143.  0 sorry. -/
theorem hasse_closed : RouteC.HasseBound_143a1 :=
  RouteC.hasse_bound_143a1_proved

/-- C_S4 > 2√13 — SelbergWeil BC6 numerical certificate for X₀(143), g=13.
    Proves the Arakelov pairing positivity threshold.  0 sorry. -/
theorem c_s4_gt_2sqrt13 : (RouteC.C_S4_cert : ℝ) > 2 * Real.sqrt 13 :=
  RouteC.C_S4_cert_gt_2sqrt13

/-- C_S4 > 2√32 — covers all 140 elliptic curves of genus ≤ 32.  0 sorry. -/
theorem c_s4_gt_2sqrt32 : (RouteC.C_S4_cert : ℝ) > 2 * Real.sqrt 32 :=
  RouteC.C_S4_cert_gt_2sqrt32

/-- C_S5 > 2√408 — companion certificate for the S5 Selberg sum.  0 sorry. -/
theorem c_s5_gt_2sqrt408 : (RouteC.C_S5_cert : ℝ) > 2 * Real.sqrt 408 :=
  RouteC.C_S5_cert_gt_2sqrt408

/-- Gate 1: all three arithmetic conditions at once.  0 sorry. -/
theorem gate1_closed :
    RouteC.HasseBound_143a1 ∧
    (RouteC.C_S4_cert : ℝ) > 2 * Real.sqrt 13 ∧
    (RouteC.C_S4_cert : ℝ) > 2 * Real.sqrt 32 :=
  RouteC.gate1_arithmetic_closed

end ArakelovFoundations
