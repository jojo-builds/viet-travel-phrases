Reviewer: Codex
Role: operator sequence
Gate: 01
Pass: 01
Verdict: APPROVED

The proposed fix makes the operator flow clearer and safer because Step 2 becomes the single source of truth for whichever preview and TestFlight builds are actually ready after a retry, while Step 4 and Step 5 follow those selected builds instead of stale historical build numbers. That preserves the preview-vs-TestFlight lane split and repo-sync guidance without sending the operator through a mismatched checklist branch.

Approval: APPROVE
