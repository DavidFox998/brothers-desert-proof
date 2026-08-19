---
name: Smithery registry propagation
description: How to verify Smithery tool inventory after republishing a remote MCP server.
---

Smithery's `GET /servers/{qualifiedName}` payload can temporarily retain a prior tool array even after a successful external release has scanned the current upstream. Treat the release logs' capability count and the public server page as the confirmation of the updated listing.

**Why:** The server-summary API cache lagged a completed scan, while the public listing had already updated to the newly discovered inventory.

**How to apply:** After republishing a remote MCP URL, inspect the latest release log for the discovered capability count. If the summary API disagrees, verify the public listing before republishing again; do not change the upstream merely to chase the stale summary response.