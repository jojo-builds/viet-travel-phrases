Approval: APPROVE

Dry-run and real claim paths now both run `active_write_lock_conflicts` before selecting a task, and the real path uses a copied claim state before write, so a handled write-block skip does not create the prior phantom active conflict. `skippedLockConflicts` and `skippedWriteBlocked` outputs are explicit enough for operators.
