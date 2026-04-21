# Meaningful-Capable Proof

## Goal
Prove that the same helper path becomes claimable when the runtime is meaningful-capable.

## Evidence
- Raw dry-run capture: `.agent/tasks/T-048/logs/meaningful-capable-dry-raw.json`

## Command
```text
py .agent\queue_tool.py claim-next --session-id "t048-proof-meaningful-dry-ab340375-4bb3-4208-b080-617a55e276a1" --label "T-048 meaningful dry proof" --dry-run
```

## Observed result
- The helper returned `status: ok` and `result: dry-run-claimable`.
- The selected candidate was reclaimable meaningful task `T-030`.
- The output showed `taskClass: meaningful` and `proofTask: false`.
- `skippedIneligible` was empty.
- `repairChanges` was empty.

## Why this matters
- The runtime gate is selective rather than globally blocking.
- Unsupported runtimes skip the meaningful backlog, while a meaningful-capable runtime can still see the same backlog as eligible through the identical helper surface.
