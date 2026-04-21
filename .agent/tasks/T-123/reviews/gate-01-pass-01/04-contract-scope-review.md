# Gate 01 Pass 01 - Contract Scope Review

Approval: BLOCK

## Findings
- `historical_live_covered` is not part of the repo's established Viet audio status vocabulary. The draft tooling normalizes `audio_status` to only `ready` or `planned`, so introducing a third token in the CSV would create schema drift instead of a clean historical reconciliation.
- The current evidence already proves the live seam is complete (`919` ready / `919` manifest / `919` registry / `921` physical MP3s / `2` unmapped orphans). That means the historical lane can be made honest without inventing a new lifecycle state.
- Because the new token appears nowhere else in repo truth, it would read like a new operational state rather than a historical annotation, which risks confusing future workers more than it helps.

## Required changes before advancement
- Keep the historical CSV contract compatible by leaving `audio_status=planned` and record the disposition in `notes` plus the review docs.
- If a distinct historical state is still desired, define it first in repo-wide contract docs and update any consumers that parse or normalize `audio_status`; that is out of scope for this gate.
- Ensure the packet wording says the rows are stale historical truth already covered by the live seam, not a new runtime readiness state.
