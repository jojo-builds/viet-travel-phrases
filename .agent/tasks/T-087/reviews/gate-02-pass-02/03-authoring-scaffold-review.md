## Summary
- The France lane is authoring-ready for the next translation pass.
- The scaffold files now give a concrete ranked start point, so the next French task can begin immediately without another orientation pass.
- The task now leaves behind both the source scaffold and the ranked first-wave queue the spec asked for.

## Checks
- `content-draft/french/README.md` now states the lane is prep-only, scaffold-complete, and should start from the ranked queue.
- `content-draft/french/source-notes.md` documents the France-specific authoring stance, review-sensitive rows, and first-wave priorities.
- `content-draft/french/phrase-source.csv` has 70 rows and is intentionally scaffold-only with blank French and pronunciation fields.
- `content-draft/french/first-wave-priority.csv` has 70 rows, with 30 marked `first-wave-ready`.
- `content-draft/french/scenario-plan.json` still preserves the shared 10-scenario seam.
- `.agent/tasks/T-087/result.md` exists and records the in-review draft state.

## Risks
- `pronunciation` is still blank by design, so the next translation task still needs a consistent helper rule.
- A few rows remain flagged for later review or rewrite, including the weak-fit `coffee-shop-4` row, but that does not block starting the next pass.

## Approval
- This is enough to start the next French translation task immediately from the ranked first-wave files. No additional orientation pass is needed.

Approval: APPROVE
