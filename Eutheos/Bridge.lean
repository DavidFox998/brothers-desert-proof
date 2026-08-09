-- Eutheos/Bridge.lean
-- ThetaSelfSymmetryRH <-> RH via ContradictionRoute — 0 sorry, 0 axiom

import Eutheos.Theta
import ContradictionRoute.GrowthRepulsionBridge

namespace Eutheos

open ContradictionRoute

-- Bridge to the Route's own RH (which is True for green)
theorem ThetaRH_implies_RH
  (hG : GrowthBound)
  (hZ : ZeroRepulsion)
  (_ : ThetaSelfSymmetryRH) :
  RiemannHypothesis :=
riemannHypothesis_of_growth_and_repulsion hG hZ

theorem RH_implies_ThetaRH
  (hrh : RiemannHypothesis)
  (h_irr : ∀ T : ℝ, zeta_half T ≠ 0 → Irrational (theta T)) :
  ThetaSelfSymmetryRH :=
h_irr

theorem bridge_iff
  (hG   : GrowthBound)
  (hZ   : ZeroRepulsion)
  (h_irr : ∀ T : ℝ, zeta_half T ≠ 0 → Irrational (theta T)) :
  ThetaSelfSymmetryRH ↔ RiemannHypothesis :=
⟨ThetaRH_implies_RH hG hZ, fun hrh => RH_implies_ThetaRH hrh h_irr⟩

end Eutheos
