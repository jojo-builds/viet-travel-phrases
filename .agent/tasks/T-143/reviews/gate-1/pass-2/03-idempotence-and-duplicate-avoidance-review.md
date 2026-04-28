# Gate 1 Pass 2: Idempotence And Duplicate Avoidance Review
## Summary
This revised contract is strong enough to proceed. It closes the main Pass 1 gaps by moving duplicate authority into machine-readable `state.json` metadata, keeping `repair` non-seeding and `desktop-recover` app/ledger-only, requiring a stable `dedupeKey` plus bidirectional original/recovery links, and preserving the interrupted original as blocked historical truth instead of letting normal reclaim flow reopen it. That matches the current repo truth that `state.json` is authoritative while `queue-index.json` is only a fast-selection aid (`.agent/README.md:21-23`, `.agent/AUTOMATION.md:27`, `.agent/QUEUE_MAINTENANCE.md:40-50`), and it explicitly accounts for the existing manual recovery pairs `T-139 -> T-141` and `T-140 -> T-142`.

## Key Risks
- Approval depends on the implementation treating `recovery.dedupeKey` / `recovery.originalTaskId` as the authoritative pre-allocation lookup. If it falls back to blocker prose, notes, or `queue-index.json`, duplicate prevention will still be brittle.
- The promised single-lock write ordering has to stay intact. If new-task creation and original-task blocking get split across separate mutation windows, retry-after-partial-failure can still mint a duplicate.
- Legacy handling must remain dedupe-first. `T-139` and `T-140` should dry-run as already recovered, with write mode limited to metadata backfill onto `T-141` / `T-142` rather than creating successors.

## Recommendation
Proceed with edits. The contract now gives a sufficiently explicit idempotence model: one task-scoped dedupe key, one-way original-to-historical transition, clear legacy-pair recognition, and dry-run output that surfaces whether any mutation would occur. My approval is contingent on implementing the new recovery command exactly as the contract describes, without letting `repair` or `desktop-recover` become alternate recovery-task creation paths.

Approval: APPROVE
