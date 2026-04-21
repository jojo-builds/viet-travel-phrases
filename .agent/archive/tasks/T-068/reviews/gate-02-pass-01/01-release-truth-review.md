Reviewer: Codex
Role: release truth
Gate: 02
Pass: 01
Verdict: APPROVED

The edited packet now carries Step 2 selected preview/TestFlight builds into the downstream gating and attach/install steps, so Step 5 no longer hard-codes stale historical build identity. It also preserves the durable truth boundary that `1.0.0 (3)` is still the latest installable artifact and `1.0.0 (4)` / `1.0.0 (5)` remain only in-flight references unless newer evidence is recorded elsewhere.

Approval: APPROVE
