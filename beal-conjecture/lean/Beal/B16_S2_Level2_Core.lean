-- B16_S2_Level2_Core — zero-import level-two cusp-form boundary.

/--
Core records only the proposition supplied by the level-two modular-form
boundary.  Its analytic meaning and the dimension calculation stay in B16's
wrapper.
-/
opaque LevelTwoNoCuspForm : Prop

/--
If the wrapper supplies both the no-cusp-form certificate and a level-two
Frey cusp-form witness, the two propositions contradict one another.
-/
theorem ribet_level_two_contradiction
    (hNoCusp : LevelTwoNoCuspForm)
    (hLevelTwoFreyForm : ¬ LevelTwoNoCuspForm) : False :=
  hLevelTwoFreyForm hNoCusp

#print axioms LevelTwoNoCuspForm
#print axioms ribet_level_two_contradiction