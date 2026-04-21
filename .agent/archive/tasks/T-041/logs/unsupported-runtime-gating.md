# Unsupported runtime gating evidence

- Session: `8c4d8e27-9ac5-4b23-9862-bbd97b549245`
- Label: `queue-burnin-r2-edgehunter-20260419-0958`
- Claimed task: `T-041`
- Claimed via: `py .agent\queue_tool.py claim-next --session-id "8c4d8e27-9ac5-4b23-9862-bbd97b549245" --label "queue-burnin-r2-edgehunter-20260419-0958" --review-runtime no-review-subagents`

## Required checks

### 1) Health
Command:
```text
py .agent\queue_tool.py health
```

Observed:
- `reclaimableCount: 1`
- Reclaimable task surfaced as `T-030` with `phase-stale-awaiting-reclaim`
- `malformedInProgressCount: 0`
- Queue snapshot during run: `queuedCount: 11`, `inProgressCount: 4`, `blockedCount: 13`

### 2) Unsupported-runtime dry-run claim
Command:
```text
py .agent\queue_tool.py claim-next --session-id "8c4d8e27-9ac5-4b23-9862-bbd97b549245-dryrun" --label "queue-burnin-r2-edgehunter-dryrun" --review-runtime no-review-subagents --dry-run
```

Observed:
- Helper returned `result: "dry-run-claimable"`
- Next eligible task was proof task `T-044`
- `skippedIneligible` was empty for this specific dry run because a proof task was available ahead of any remaining meaningful queued work
- No shared queue mutation occurred from the dry run

## Queue-events evidence relevant to edge cases
- Recent earlier burn-in entries show unsupported-runtime dry runs returning `no_task` with meaningful tasks listed under `skippedIneligible` when only meaningful work remained.
- Recent live entries around this run show multiple proof tasks (`T-040` to `T-043`) being claimed quickly by parallel lanes. This means dry-run outcomes depend on momentary proof-task availability and are not stable across seconds.

## Edge-case findings
1. The spec says to record whether meaningful tasks are skipped cleanly, but this run's dry run landed on a proof task before it had to skip anything. The helper behavior still looks clean, but the evidence is indirect unless the queue happens to contain only meaningful candidates.
2. Fast concurrent claims make the queue snapshot highly time-sensitive. A dry run can truthfully report `dry-run-claimable` one second and `no_task` with `skippedIneligible` the next, without any bug.
3. `health` reports reclaimable state cleanly, but it does not explain why a task is stale beyond the issue token. Operators still need queue events or task state for exact cause.
4. The task spec allows reading `queue-events.jsonl` but not `queue-index.json`; that is workable here, but slightly brittle when reconciling why a dry-run target changed.

## Overall
The unsupported-runtime gate appears to behave safely in this run. Proof work remained claimable, shared state stayed intact, and the queue surface exposed at least one reclaimable task without malformed ownership.