Approval: APPROVE

Gate 1 passes for the multi-automation workflow lane. `claim-next` now serializes the claim transaction without making execution globally single-worker, skips active write-lock conflicts in both dry-run and real claim paths, reports `skippedLockConflicts`, and allows later non-overlapping claims. The bootstrap docs also show `SPEAKLOCAL_REVIEW_RUNTIME=subagents` usage for helper-backed meaningful claims and explain direct-patch fallback lock checks.
