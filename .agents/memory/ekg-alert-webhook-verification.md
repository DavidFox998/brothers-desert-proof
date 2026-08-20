---
name: EKG alert webhook verification
description: Operational rule for keeping the EKG smoke-test alert paths independently deliverable.
---

The primary heartbeat EKG alert and the cold-start beat-rate alert must be
verified independently. Both are Slack-compatible notifications and are
intended to use the same maintained team-alert destination unless an explicit
operational decision changes one of them.

**Why:** The jobs use distinct GitHub Actions secret names, so one alert path
can silently become invalid while the other remains healthy.

**How to apply:** After changing either alert destination, manually dispatch
the repository's EKG alert-webhook verification workflow. Treat a successful
run as requiring a passing job for each alert path; do not infer the cold-start
destination is healthy from the primary alert alone.