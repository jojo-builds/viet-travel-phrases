# Unsupported Runtime Proof

## Goal
Prove that a runtime without the nested meaningful-review workflow skips meaningful tasks cleanly and returns structured `no_task` output instead of claiming stranded work.

## Evidence
- Raw real-claim capture: `.agent/tasks/T-048/logs/unsupported-runtime-real-raw.json`
- Raw dry-run capture: `.agent/tasks/T-048/logs/unsupported-runtime-dry-raw.json`

## Commands
```text
py .agent\queue_tool.py claim-next --session-id "t048-proof-unsupported-real-aabe2183-c962-4bec-8cbf-d45ddd4ba82f" --label "T-048 unsupported real proof" --review-runtime no-review-subagents
py .agent\queue_tool.py claim-next --session-id "t048-proof-unsupported-dry-a20b07ba-6c28-4874-acd6-7b9b5f013b92" --label "T-048 unsupported dry proof" --review-runtime no-review-subagents --dry-run
```

## Observed result
- Both runs returned `status: ok` and `result: no_task`.
- Neither run claimed or modified a meaningful task.
- Both runs reported `repairChanges: []`.
- Both runs returned `skippedIneligible` entries for `T-030` through `T-037`.
- Each skipped task carried the same reason: the meaningful review workflow was unavailable in `no-review-subagents`.

## Why this matters
- The helper now enforces the runtime-capability gate on the claim path itself.
- Repeated unsupported-lane runs therefore fail safe as queue scans, not as accidental task claims.

## Notes
- These captures were taken before seeding the new proof tasks so the `no_task` result reflects a drained proof lane rather than queue churn.
