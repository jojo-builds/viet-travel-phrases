## Summary
- The updated French lane is concrete enough for the next translation task to start immediately.
- It now has a full 70-row source scaffold, a ranked first-wave queue with 30 `first-wave-ready` rows, and lane notes that clearly preserve the prep-only boundary.
- The scaffold is actionable instead of descriptive.

## Checks
- `content-draft/french/phrase-source.csv` is present, non-empty, and has 70 rows.
- `content-draft/french/first-wave-priority.csv` is present, non-empty, and has 70 rows with 30 `first-wave-ready`.
- `content-draft/french/scenario-plan.json` parses and still preserves the shared 10-scenario seam.
- The next pass has a clear starting order and row-level review flags.
- The notes and backlog are explicit about polite French posture, search and pronunciation handling, and which rows stay review-sensitive.

## Risks
- `target_text` and `pronunciation` remain blank by design, so the next pass still needs to apply a consistent pronunciation-helper convention.
- A few sensitive rows remain deferred or flagged, which is correct, but the next authoring pass should stay within the ranked first wave rather than widening scope.
- `coffee-shop-4` is still intentionally weak-fit and should stay rewrite-or-retire before any translation attempt.

## Approval
- The French scaffold is approved for the next authoring pass without another orientation cycle.

Approval: APPROVE
