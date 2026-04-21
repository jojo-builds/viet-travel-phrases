## Summary
- The French prep lane is now concrete enough for the next translation task to start immediately.
- The scaffold has a full 70-row source sheet, a ranked 30-row first-wave queue, and France-specific authoring notes that remove the need for another orientation pass.
- The lane now reads like a real handoff rather than a research-only bundle.

## Checks
- `content-draft/french/phrase-source.csv` exists and has 70 rows.
- `content-draft/french/first-wave-priority.csv` exists and has 70 rows, with 30 marked `first-wave-ready`.
- `content-draft/french/scenario-plan.json` parses and preserves the shared 10-scenario seam.
- The queue is useful, not just descriptive: it ranks starter rows across polite basics, repair, hotel check-in, taxi or routing, payment, and price checking.
- The notes and backlog clearly state the lane is prep-only, non-runtime-wired, and ready for translation work.

## Risks
- `target_text` and `pronunciation` are still blank by design, so the next pass still needs a consistent pronunciation rule before completion.
- Sensitive rows are correctly deferred or flagged, so the first translation pass should stay inside the ranked queue instead of widening scope.
- `phrase-source.csv` is still a scaffold sheet, so the next authoring task should keep `first-wave-priority.csv` beside it for rank order and review routing.

## Approval
- The updated French scaffold is materially useful for immediate authoring handoff and does not require another orientation pass.

Approval: APPROVE
