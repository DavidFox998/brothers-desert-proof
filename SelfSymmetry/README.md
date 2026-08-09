
---

35 Islands in the Void

The desert void is empty except for 35 islands. Those islands are the brothers.

**Why 35 brothers?** Because when you take the number **1419** and ask "which numbers bypass all barriers?", you get exactly 35 numbers. `1419` itself is the smallest — the leader, the first ambassador. It factors as `3*11*43`.

All 35 brothers share a secret:
- They are all ≥193 (desert starts at 193)
- They all leave remainder 153 when divided by 211: `b %211 =153`
- They all have exactly 6 ones in binary: `popcount=6`
- Any two differ in at least 2 bits: `min_hamming ≥2` — they are error-correcting

**S4 = {2,3,19,191}— the only primes up to 1000 where the Bost-Connes algebra has a phase transition. Desert 192..999 has no exceptional primes — empty.

**Twin Wormholes:**
Take twin primes: `(11,13) → 143`, `(17,19) → 323`, `(191,193) → 36863`.

- Mod 191: 35 brothers have 35 distinct residues — **Nodup clean**. Exactly 1 brother divisible by 191.
- Mod 193: collides — not Nodup. 0 brothers divisible by 193.
- Mod 143 (=11*13): collides — not Nodup.
- Mod 36863 (=191*193 desert twin): Nodup clean — product injectivity.

This means `191`-> `193` is outside. The wormhole `W3=36863` is the desert twin that cleanly separates brothers — it is the wormhole that lets you travel from S4 prime 191 to outside.

`W1*W2 = 143*323 = 46189` — arithmetic checked by `native_decide`.

**2113 and 13th brother:** 35 brothers exist, 12 are around 143, the 13th would be at -2113 ghost if Siegel zero existed. `2113` is prime irrational — cannot be brother by definition (brothers composite, pop6), so it stays ghost.

**`Core.lean` — Foundation from eutheos-property**
```lean
theorem core_brothers_35 : brothers_35.length = 35 := by native_decide
theorem core_brothers_Nodup : brothers_35.Nodup := by native_decide
theorem core_brothers_desert : brothers_35.all (· ≥193) = true := by native_decide
theorem core_brothers_mod211 : brothers_35.all (· %211 =153) = true := by native_decide
theorem core_brothers_pop6 : all popcount=6 := by native_decide
theorem core_leader : min? = some 1419 := by native_decide
theorem core_leader_factor : 3*11*43=1419 := by native_decide
theorem core_hamming_ge2 : 2 ≤ min_hamming := by native_decide
