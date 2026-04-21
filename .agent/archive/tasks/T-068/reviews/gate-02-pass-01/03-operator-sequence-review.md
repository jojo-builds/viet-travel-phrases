Reviewer: Codex
Role: operator sequence
Gate: 02
Pass: 01
Verdict: APPROVED

Step 2 now clearly establishes the selected preview build and selected TestFlight build as the downstream control point, including the retry/resubmit case, and Step 4 plus Step 5 both consume those selected builds directly. That removes the stale historical build-number drift and keeps the operator on one consistent checklist path.

Approval: APPROVE
