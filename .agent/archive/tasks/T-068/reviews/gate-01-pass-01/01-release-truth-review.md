Reviewer: Codex
Role: release truth
Gate: 01
Pass: 01
Verdict: APPROVED

The proposed change is sufficiently narrow for release truth. It replaces the stale hard-coded Step 5 TestFlight build reference with Step 2 selected-build outputs while preserving the current durable boundary that build `1.0.0 (3)` is still the latest installable artifact and builds `1.0.0 (4)` / `1.0.0 (5)` remain in-flight references unless newer ops evidence is recorded elsewhere.

Approval: APPROVE
