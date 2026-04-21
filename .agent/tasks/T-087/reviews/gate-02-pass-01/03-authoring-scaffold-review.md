## Summary
- The France prep lane is now an authoring-ready scaffold.
- The next French translation task can start directly from `content-draft/french/first-wave-priority.csv` and `content-draft/french/phrase-source.csv` without another orientation pass.
- The task now leaves behind both the reusable source scaffold and the ranked shortlist the spec required.

## Checks
- `content-draft/french/README.md` explicitly says the lane is prep-only, the scaffold is complete, and the next pass should start from the ranked queue.
- `content-draft/french/source-notes.md` documents the France-specific authoring stance, staged row rewrites, review-sensitive rows, and the first 30-row starter-pack direction.
- `content-draft/french/scenario-plan.json` preserves the shared 10-scenario seam and parses cleanly.
- `content-draft/french/phrase-source.csv` has 70 rows and the blank `target_text` and `pronunciation` fields are clearly scaffold-only.
- `content-draft/french/first-wave-priority.csv` has 70 rows, 30 marked `first-wave-ready`, and includes the required handoff columns.
- `content-draft/french/research-backlog.md` gives the exact next authoring moves and remaining review gates.

## Risks
- `pronunciation` is still intentionally blank, so the next translation pass must establish a consistent helper rule early.
- The spec still references missing `T-019` input, but that is input-hygiene noise rather than a scaffold blocker for the next translation pass.

## Approval
- The updated French lane is authoring-ready and no longer needs another planning pass before translation starts.

Approval: APPROVE
