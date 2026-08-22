---
name: Lean native cache interruptions
description: Native Lake builds interrupted by a timeout can leave stale zero-byte exported objects marked current.
---

An interrupted native Lake rebuild can leave a zero-byte `.c.o.export` cache artifact that Lake later treats as up to date. This presents as an undefined `initialize_*` symbol during executable linking, or as a malformed generated executable.

**Why:** The build trace may survive an interrupted object write, so a rerun can reuse a corrupt native cache entry instead of rebuilding it.

**How to apply:** When a Lean executable link reports one missing initializer after a timed-out native rebuild, inspect that facet's exported object. If it is empty or lacks the symbol, remove its generated artifact and rebuild the exact `Module:c.o.export` facet from the top-level project before retrying the executable.