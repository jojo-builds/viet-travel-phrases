# Forced Write-Failure Proof

## Goal
Prove that auxiliary coordination-write failures degrade to structured warnings instead of crashing the helper.

## Evidence
- Forced event-log lock capture: `.agent/tasks/T-048/logs/forced-event-lock-result.json`
- Forced queue-index lock capture: `.agent/tasks/T-048/logs/forced-index-lock-result.json`

## Event-log append failure
### Setup
- Held `.agent/coordination/queue-events.jsonl` with an exclusive file lock.

### Command
```text
py .agent\queue_tool.py claim-next --session-id "t048-forced-event-0a56905e-9281-4025-8743-975415fdc87b" --label "T-048 forced event lock" --review-runtime no-review-subagents --dry-run
```

### Observed result
- The helper still returned `status: ok` and `result: no_task`.
- The output included a structured `warnings` entry with:
  - `reason: event-log-write-failed`
  - `operation: append-event`
  - `errorType: PermissionError`
- The run did not crash or emit an unstructured traceback.

## Queue-index rewrite failure
### Setup
- Held `.agent/coordination/queue-index.json` with an exclusive file lock.

### Command
```text
py .agent\queue_tool.py claim-next --session-id "t048-forced-index-c8661c5e-3722-4153-ad1d-771634f79c97" --label "T-048 forced index lock" --review-runtime no-review-subagents
```

### Observed result
- The helper still returned `status: ok` and `result: no_task`.
- The output included a structured `warnings` entry with:
  - `reason: queue-index-write-failed`
  - `operation: write-index`
  - `errorType: PermissionError`
- The run preserved degraded-run evidence without crashing.

## Why this matters
- Event logging and queue-index rewrites are now best-effort auxiliary writes rather than fatal failure points.
- The caller receives durable machine-readable evidence when those writes degrade.

## Note
- The warning detail strings still used the compatibility alias path under `E:\AI\Viet-Travel-Phrases`, which is expected because the helper accepts the alias root as a compatible real path.
