status: done

truth changed classification:
- planning
- new prep-only Turkish research and draft-lane truth only

changed files:
- `research/language-pipeline/turkish/TURKEY-TRAVEL-RESEARCH.md` - durable Turkey / Turkish synthesis covering destination framing, traveler-use reality, politeness, pronunciation posture, search implications, risks, and starter-pack direction.
- `content-draft/turkish/README.md` - marks the lane as authoring-oriented rather than untouched scaffold only.
- `content-draft/turkish/source-notes.md` - records the first-authoring posture, including Turkish script/search risk and top-down translation sequencing.
- `content-draft/turkish/scenario-plan.json` - reorders quick phrases and updates scenario tips around Turkey-specific utility without changing the shared scenario seam.
- `content-draft/turkish/first-wave-priority.csv` - concrete ranked starter shortlist the next translation task can use immediately.
- `content-draft/turkish/research-backlog.md` - captures the remaining work before runtime graduation.
- `.agent/tasks/T-005/reviews/01-traveler-utility-review.md` - traveler-utility gate.
- `.agent/tasks/T-005/reviews/02-language-risk-review.md` - language-risk gate.
- `.agent/tasks/T-005/reviews/03-authoring-scaffold-review.md` - scaffold-readiness gate.
- `.agent/tasks/T-005/reviews/04-contract-scope-review.md` - scope/contract gate.
- `.agent/tasks/T-005/state.json` - tracked claim, drafting, review, and validation phases.
- `.agent/coordination/locks.yaml` - mirrored active task phase/status in the shared lock surface.
- `.agent/tasks/T-005/result.md` - compact completion record required by the task contract.

validation performed:
- verified every required output file exists at the required paths
- verified `content-draft/turkish/first-wave-priority.csv` exists and is non-empty (`32` rows)
- parsed `content-draft/turkish/scenario-plan.json` successfully with `ConvertFrom-Json`
- verified exactly `4` review files exist under `.agent/tasks/T-005/reviews/`
- checked prohibited surfaces after the claim timestamp and found no writes under `app/**`, `site/**`, `ops/**`, or `docs/operations/**`
- confirmed the lane is more authoring-ready than before because the next translation task can now start from the ranked CSV plus the research/backlog posture instead of redoing orientation

review findings and what was fixed:
- traveler-utility review passed after confirming quick phrases and the ranked shortlist were shifted toward apology, thanks, price, taxi, hotel, payment, and repair language
- language-risk review passed with explicit review flags preserved for medical, localization, bargaining, and Turkish casing/pronunciation risks
- authoring-scaffold review passed because the ranked CSV, research synthesis, and backlog now form a usable next-authoring package
- contract-scope review passed after confirming all edits stayed within allowed write scopes
- during validation I tightened the research doc's Turkish orthography guidance so the ASCII fallback descriptions were still unambiguous

substantive risks or follow-up cautions:
- the lane is still prep-only; translation coverage, pronunciation coverage, audio posture, and runtime search behavior are still open
- the first Turkish runtime graduation should not happen before native review on politeness defaults plus high-risk medical/police/allergy wording
- the family-orchestration skill references helper scripts that are not present at the documented root, so this task used direct file inspection and JSON validation instead

recommended next step:
- translate the top 20-30 rows from `content-draft/turkish/first-wave-priority.csv` into `content-draft/turkish/phrase-source.csv`, marking any Turkey-specific rewrites inline as you go
