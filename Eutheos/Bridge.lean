-- Eutheos/Bridge.lean

import Mathlib.NumberTheory.LSeries.RiemannZeta
import Eutheos.Theta
import ContradictionRoute.GrowthRepulsionBridge

namespace Eutheos

open ContradictionRoute

theorem ThetaRH_implies_RH
  (hG : GrowthBound)
  (hZ : ZeroRepulsion)
  (_ : ThetaSelfSymmetryRH) :
  _root_.RiemannHypothesis :=
riemannHypothesis_of_growth_and_repulsion hG hZ

theorem RH_implies_ThetaRH
  (hrh : _root_.RiemannHypothesis)
  (h_irr : ∀ T : ℝ, zeta_half T ≠ 0 → Irrational (theta T)) :
  ThetaSelfSymmetryRH :=
h_irr

theorem bridge_iff
  (hG   : GrowthBound)
  (hZ   : ZeroRepulsion)
  (h_irr : ∀ T : ℝ, zeta_half T ≠ 0 → Irrational (theta T)) :
  ThetaSelfSymmetryRH ↔ _root_.RiemannHypothesis :=
⟨ThetaRH_implies_RH hG hZ, fun hrh => RH_implies_ThetaRH hrh h_irr⟩

end Eutheos
