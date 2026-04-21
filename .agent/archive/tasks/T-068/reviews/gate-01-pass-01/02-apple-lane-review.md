Reviewer: Codex
Role: apple lane
Gate: 01
Pass: 01
Verdict: APPROVED

The planned fix preserves the lane split by keeping Step 4 tied to the selected preview build and Step 5 tied to the selected TestFlight build after any Step 2 retry or resubmit. Updating the Step 5 attach instruction to use that selected TestFlight build removes the stale `1.0.0 (5)` drift without changing Apple-side readiness requirements or overstating the current build boundary.

Approval: APPROVE
