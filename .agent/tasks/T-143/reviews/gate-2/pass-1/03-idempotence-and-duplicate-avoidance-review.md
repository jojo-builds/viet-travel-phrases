# Gate 2 Pass 1: Idempotence And Duplicate Avoidance Review
## Summary
The normal-path duplicate prevention looks solid: the command runs under the queue mutation lock, uses a stable per-original dedupe key, scans existing task metadata before allocating a new task id, and the legacy backfill examples show `T-139 -> T-141` and `T-140 -> T-142` resolving cleanly through machine-readable recovery metadata. But I do not think it is strong enough for final review yet, because the retry path is not fully idempotent after a partial write.

## Key Risks
- `.agent/queue_tool.py:2389-2417`, `.agent/queue_tool.py:2449-2458`, `.agent/queue_tool.py:2588-2596` create a real convergence gap: if task metadata is written successfully but `desktop-app-recovery.json` fails to persist, the command returns `retry`, yet the next run will short-circuit to `already_recovered` as soon as it sees symmetric task metadata. That means retry does not repair the missing ledger entry, so the operation is duplicate-safe but not fully idempotent.
- The same gap exists in both the new-task creation flow and the legacy backfill flow, so this is not just a corner around `T-125`; it affects the exact dedupe/backfill model this task is supposed to prove.

## Recommendation
Block advancement to final review until retrying an existing recovery relationship can also heal missing recovery-ledger state instead of immediately returning `already_recovered`. Once repeated runs converge on both task metadata and ledger consistency, I’d be comfortable approving.

Approval: BLOCK
