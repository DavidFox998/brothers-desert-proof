---
name: Smithery owner updates
description: Reliable handling of Smithery server visibility changes after updating the Replit-managed API key.
---

Smithery server-management PATCH requests should use the Replit-managed `SMITHERY_API_KEY` through the secure runtime rather than assuming an already-running shell has refreshed environment values. After a successful update, re-query the public registry with a cache-busting request and confirm that the intended server changed while neighboring listings did not.

**Why:** A refreshed Replit secret was available to the secure runtime but an existing shell process continued returning 403, and the public registry briefly served stale visibility data after the successful update.

**How to apply:** For future Smithery visibility or metadata changes, target the exact qualified name, avoid delete when unlisting is sufficient, use the secure runtime for the API call, and verify public search results after propagation.