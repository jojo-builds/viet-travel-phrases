Approval: APPROVE

Claim-lock semantics satisfy the Gate 1 spec: `claim-next` skips active write-lock conflicts in dry-run and real paths, exact and `/**` descendant conflicts are covered, task-local locks do not block unrelated tasks, and conflict output is clear via `skippedLockConflicts`.
