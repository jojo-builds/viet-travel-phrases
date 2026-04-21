## Summary
- The task package is ready to finalize to `done` from a contract and scope perspective.
- The French prep lane now has the required scaffold artifacts, stayed within the prep-only boundary, and the latest Gate 1 and Gate 2 passes are both unanimously approved.
- The task-local result is intentionally still `in_review` because this is the final pre-completion review.

## Checks
- `content-draft/french/README.md`, `source-notes.md`, `scenario-plan.json`, `phrase-source.csv`, `first-wave-priority.csv`, and `research-backlog.md` are present and consistent with a prep-only authoring lane.
- `content-draft/french/phrase-source.csv` and `content-draft/french/first-wave-priority.csv` are populated and non-empty.
- `content-draft/french/scenario-plan.json` parses cleanly and still preserves the shared 10-scenario seam.
- `.agent/tasks/T-087/reviews/gate-01-pass-02/` contains exactly 4 review files, and all 4 explicitly say `Approval: APPROVE`.
- `.agent/tasks/T-087/reviews/gate-02-pass-02/` contains exactly 4 review files, and all 4 explicitly say `Approval: APPROVE`.
- The evidence in `result.md` is consistent with the work staying in `content-draft/french/**` and `.agent/tasks/T-087/**`, with no French runtime wiring touched.

## Risks
- `result.md` is still a draft, but that is intentional for this final review and does not block finalization.
- The scope conclusion relies on task-local evidence and reviewed artifacts rather than a repository-wide diff.

## Approval
- The package is contract-scope clean and ready to finalize.

Approval: APPROVE
