# Queue runtime-contract audit

## Helper behavior after hardening
- `E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py` now requires both:
  - repo-level `runtime-review-path.json` production readiness for ordinary meaningful work
  - current-shell `SPEAKLOCAL_REVIEW_RUNTIME=subagents`
- `E:\AI\SpeakLocal-App-Family\.agent\QUEUE_START.md` and `E:\AI\SpeakLocal-App-Family\.agent\AUTOMATION.md` separately require workers to set that env var only after honestly checking for a callable `spawn_agent` surface in the current session.

## Validation command
```powershell
Remove-Item Env:SPEAKLOCAL_REVIEW_RUNTIME -ErrorAction SilentlyContinue
Invoke-SpeakLocalQueueTool claim-next --dry-run --session-id 't061-postproof-dry-run-2' --label 'T-061 post-proof dry run 2'
```

## Observed result
```json
{
  "status": "blocked",
  "reason": "review-runtime-not-verified-in-worker-session",
  "detail": "This queue lane only admits meaningful work after the current worker session exports SPEAKLOCAL_REVIEW_RUNTIME=subagents."
}
```

## Repair command
```powershell
Invoke-SpeakLocalQueueTool repair
```

## Observed repair result
```json
{
  "status": "ok",
  "changes": [],
  "indexStats": {
    "queuedCount": 8,
    "reclaimableCount": 0,
    "inProgressCount": 0,
    "blockedCount": 20,
    "draftCount": 1,
    "recentlyCompletedCount": 38
  }
}
```

## Contract conclusion
- Meaningful queue work no longer relies on repo metadata alone.
- A worker that has not exported the required current-shell affirmation now blocks before any meaningful task is claimed.
- Launcher docs still require that affirmation to be set only after the worker honestly checks for a callable `spawn_agent` surface.
- The helper does not independently validate `spawn_agent` availability; it enforces the current-shell affirmation while the launcher surfaces carry the exact capability-check requirement.
- T-061 therefore remains blocked: the queue no longer has the old downgrade path, but the nested worker runtime still cannot satisfy the successful four-task proof required by the spec.
