# Gate 2 Pass 1: Operator Clarity Review
## Summary
The command/docs split is mostly clear enough: `README`, `QUEUE_REPAIR`, `QUEUE_MAINTENANCE`, and `AUTOMATION` consistently separate cheap `repair`, app-only `desktop-recover`, and interrupted-task `recovery-handoff` ([.agent/README.md](/E:/AI/SpeakLocal-App-Family/.agent/README.md:20), [.agent/QUEUE_REPAIR.md](/E:/AI/SpeakLocal-App-Family/.agent/QUEUE_REPAIR.md:32), [.agent/QUEUE_MAINTENANCE.md](/E:/AI/SpeakLocal-App-Family/.agent/QUEUE_MAINTENANCE.md:50), [.agent/AUTOMATION.md](/E:/AI/SpeakLocal-App-Family/.agent/AUTOMATION.md:34)). I am blocking on one remaining operator-facing mismatch: legacy `already_recovered` dry-runs do not clearly tell the operator that write mode would backfill recovery metadata.

## Key Risks
- [.agent/tasks/T-143/logs/self-recovery-handoff-notes.md](/E:/AI/SpeakLocal-App-Family/.agent/tasks/T-143/logs/self-recovery-handoff-notes.md:8) says dry-run reports whether write mode would mutate anything, and [.agent/QUEUE_MAINTENANCE.md](/E:/AI/SpeakLocal-App-Family/.agent/QUEUE_MAINTENANCE.md:53) says `already_recovered` may still need metadata backfill. But [.agent/queue_tool.py](/E:/AI/SpeakLocal-App-Family/.agent/queue_tool.py:2395) returns `result: "already_recovered"` with `wouldMutate: false` for all dry-runs, including legacy-source pairs. For `T-139`/`T-140`-style cases, that hides the actual write-mode behavior operators need to understand before choosing the non-dry-run command.
- This was the main open clarity risk from Gate 1 ([.agent/tasks/T-143/reviews/gate-1/pass-2/04-operator-clarity-review.md](/E:/AI/SpeakLocal-App-Family/.agent/tasks/T-143/reviews/gate-1/pass-2/04-operator-clarity-review.md:6)), so leaving it ambiguous now weakens the promised dry-run-first safety model.

## Recommendation
Block advancement to final review until the dry-run output for legacy recovered pairs explicitly distinguishes “already recovered, no write needed” from “already recovered, write mode would backfill metadata.” The docs are otherwise in good shape, but the CLI should make that one decision point unambiguous.

Approval: BLOCK
