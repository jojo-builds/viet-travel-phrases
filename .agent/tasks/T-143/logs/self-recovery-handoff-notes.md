# Self-Recovery Handoff Notes

- Added an explicit `recovery-handoff` queue-tool command instead of widening `repair` or `desktop-recover`.
- Recovery handoff dedupe now uses machine-readable task `state.json` metadata keyed as `interrupted-recovery:<originalTaskId>`.
- Fresh recovery generation is limited to meaningful tasks that are stale/reclaimable and show durable landed-work evidence from task-local result, review, or log artifacts.
- Existing manual recovery pairs can be recognized conservatively, inspected in dry-run, and backfilled with authoritative recovery metadata without generating duplicates.
- The write order is intentionally one-way under the queue mutation lock: detect existing recovery first, write any new recovery task packet, then flip the original task into blocked interrupted history, then refresh queue-index and the recovery ledger summary.
- If a recovery successor already exists, write mode now repairs every incomplete support surface on retry: task metadata, original-task interrupted history, and recovery-ledger linkage all converge instead of short-circuiting after the first successful write.
- Dry-run output is the operator safety surface: it reports qualification, salvage evidence, dedupe key, existing or proposed recovery task id, and whether write mode would mutate anything, including explicit `writeModeAction` / repair flags for existing-recovery cases.
