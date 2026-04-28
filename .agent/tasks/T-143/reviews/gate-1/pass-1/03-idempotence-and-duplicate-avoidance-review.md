# Gate 1 Pass 1: Idempotence And Duplicate Avoidance Review
## Summary
Safe implementation needs a true idempotent handoff model keyed to the original interrupted task, not a best-effort repair step. The current queue surface treats `queue-index.json` as rebuildable selection aid rather than lifecycle truth, and the existing recovery ledger is for desktop-app restart episodes, not per-task recovery ownership (`.agent/QUEUE_MAINTENANCE.md:39-50`, `.agent/queue_tool.py:160-181`, `.agent/queue_tool.py:921-975`). That means duplicate avoidance must come from authoritative task metadata and/or a task-scoped ledger entry tied to the original task id.

It also must not reuse the normal stale-task reclaim path for this feature. Today stale `in_progress` work is normalized back into reclaimable state and then can be claimed again as the same task (`.agent/queue_tool.py:999-1064`, `.agent/queue_tool.py:1596-1674`), but the recovery model here explicitly requires the original task to remain historical truth while a fresh recovery task carries the closeout (`.agent/tasks/T-143/spec.md:83-89`, `.agent/tasks/T-141/spec.md:66-70`, `.agent/tasks/T-142/spec.md:62-66`).

## Key Risks
- Duplicate suppression will be brittle if it relies on `queue-index.json` or prose in blockers/recovery notes. Neither is authoritative enough for repeated hourly runs.
- The existing recovery ledger is restart-scoped, not original-task-scoped. Reusing it without a durable `originalTaskId -> recoveryTaskId` mapping will not guarantee idempotence.
- If the generator leaves the original task reclaimable even briefly, `claim-next` can reopen it and create parallel work against both the original and the recovery task.
- If task creation, original-state transition, and ledger/index updates are not crash-safe under one queue mutation lock, a partial failure can mint a second recovery packet on retry.
- T-139 and T-140 already have manual recoveries through T-141 and T-142; the new path must detect and no-op on already-recovered originals instead of generating another successor (`.agent/tasks/T-139/state.json:31-33`, `.agent/tasks/T-140/state.json:31-33`).

## Recommendation
Block until the implementation contract explicitly guarantees:
- one machine-readable dedupe key based on the original interrupted task id;
- bidirectional original/recovery linking so reruns return the existing recovery task instead of allocating a new id;
- one-way state transition where the original becomes non-claimable historical truth and the recovery task becomes the only active follow-up;
- retry behavior that converges after partial failure instead of duplicating work;
- compatibility recognition for the already-existing manual pairs `T-139 -> T-141` and `T-140 -> T-142`.

Approval: BLOCK
