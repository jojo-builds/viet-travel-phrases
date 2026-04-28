# Gate 2 Pass 1: Recovery Policy Review
## Summary
The happy-path behavior is directionally right: recovery is isolated behind an explicit `recovery-handoff` command, `state.json` remains the authoritative original/recovery link, and the validated `T-139/T-141` and `T-140/T-142` backfills preserve the original tasks as interrupted history in the normal case. I do not think it is safe to advance yet, because the retry path after a mid-sequence write failure can still break that lifecycle-truth contract.

## Key Risks
- `.agent/queue_tool.py:2545-2574` creates the recovery task before durably flipping the original to `blocked` / `interrupted-awaiting-recovery`. If `recovery-handoff-block-original` fails, a retry goes through `.agent/queue_tool.py:2419-2478`, which only syncs `recovery` metadata and `lastUpdated`; it does not normalize the original task’s `status`, `phase`, or blockers. That can leave the original task `in_progress` while a recovery successor already exists, contradicting `.agent/QUEUE_MAINTENANCE.md:58` and `.agent/AUTOMATION.md:39`.
- The helper explicitly tells operators to retry the command after a write failure, so this is the intended convergence path, not a corner-case manual repair path. Until that retry path restores the original task to interrupted blocked history, lifecycle truth can remain split across two active-looking tasks.

## Recommendation
Block for one more fix. The policy split, dry-run qualification, and legacy dedupe/backfill behavior all look solid, but the write/retry sequence needs to guarantee convergence back to one blocked original plus one recovery successor before this is safe enough for final review.

Approval: BLOCK
