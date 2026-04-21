# Stale Lock Recovery Proof

## Goal
Prove that a dead-process main queue lock is cleaned up and does not strand the helper.

## Evidence
- Raw capture: `.agent/tasks/T-048/logs/stale-lock-recovery-raw.json`

## Setup
- Wrote `.agent/coordination/.queue-locks/queue-mutation.lock` with dead PID `8084`.
- Used valid JSON content so the test exercised stale-owner recovery rather than malformed-file fallback.

## Command
```text
py .agent\queue_tool.py claim-next --session-id "t048-stale-lock-254675dc-fc0f-4524-800b-95de1de95f21" --label "T-048 stale lock proof" --review-runtime no-review-subagents --lock-timeout-seconds 5
```

## Observed result
- The helper returned `status: ok` and `result: no_task`.
- The task scan still stayed on the safe unsupported-runtime path.
- The raw capture reports `afterExists: false` and `after: LOCK_ABSENT`.

## Why this matters
- A dead prior owner no longer strands the queue lane behind a stale main mutation lock.
- Stale cleanup is proven on the real lock file surface, not only through reasoning over code paths.

## Note
- An earlier malformed-lock experiment produced structured timeout behavior with invalid metadata. That was a separate safety check, not the stale-owner success proof used for this artifact.
