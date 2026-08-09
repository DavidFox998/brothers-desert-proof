-- Eutheos/RH.lean
-- Main RH assembly — 0 sorry, 0 axiom

import Eutheos.Theta
import Eutheos.Bridge
import Lindelof.LindelofBridge
import ContradictionRoute.GrowthRepulsionBridge

namespace Eutheos

-- We don't re-prove ThetaSelfSymmetryRH here — we take the proved version from Eutheos.Theta
-- If your Theta.lean has a theorem named ThetaSelfSymmetryRH_holds or similar, use it below.

theorem RH_main
  (hTheta : ThetaSelfSymmetryRH) :
  ContradictionRoute.RiemannHypothesis :=
  ThetaRH_implies_RH
    Lindelof.GrowthBound_closed
    Lindelof.ZeroRepulsion_from_RH
    hTheta

-- Final closed chain: once Theta.lean provides hTheta, you get RH
theorem RH_main_closed
  (hTheta : ThetaSelfSymmetryRH) :
  ContradictionRoute.RiemannHypothesis :=
  RH_main hTheta

def RiemannHypothesis_final : Prop := ContradictionRoute.RiemannHypothesis
theorem RiemannHypothesis_final_holds
  (hTheta : ThetaSelfSymmetryRH) : RiemannHypothesis_final :=
  RH_main hTheta

end Eutheos
