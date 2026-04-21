Reviewer: Codex
Role: release truth
Gate: 03
Pass: 01
Verdict: APPROVED

The packet now carries Step 2 selected preview/TestFlight builds into Step 4 and Step 5, so the stale hard-coded Step 5 build identity is removed while the durable truth boundary remains unchanged: `1.0.0 (3)` is still the latest installable artifact, `1.0.0 (4)` and `1.0.0 (5)` remain in-flight references only, the required audit log exists, and the latest Gate 1 and Gate 2 passes each contain four `Approval: APPROVE` review files. From a release-truth standpoint, nothing blocks honest advancement to done once `result.md` and `state.json` are written to match this reviewed state.

Approval: APPROVE
