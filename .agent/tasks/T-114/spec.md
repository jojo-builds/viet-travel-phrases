# Task Spec: T-114

## Title
Desktop Codex automation pilot, Tagalog relation-cluster expansion and retrieval handoff hardening pass

## Objective
Extend the new Tagalog relation-ready lane beyond its first starter-core pack so downstream runtime or content work can retrieve one sharper contract for relation clusters, likely replies, and next-step navigation. This should deepen the prep lane without pretending the lane is fully runtime-ready.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `.agent/tasks/T-108/result.md`
- `.agent/tasks/T-109/spec.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/relation-sample-v1.json`
- `content-draft/tagalog/relation-authoring-notes.md`
- `content-draft/tagalog/scenario-plan.json`
- `content-draft/tagalog/risk-review.md`

## Task type
- relation-model hardening
- retrieval handoff expansion
- Tagalog prep-lane deepening

## Scope
### Allowed write scopes
- `.agent/tasks/T-114/**`
- `content-draft/tagalog/**`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `app/family/**` for bounded family-shape reference only
- `site/**` as read-only reference for starter-safe relationship surfaces

### Must not touch
- `app/**` as a write surface
- `site/**` as a write surface
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- Start from the relation and starter-contract work already landed in `T-108` and the current queued handoff in `T-109`.
- Stay prep-only. Do not imply Tagalog is promoted into runtime truth.
- Prefer a stronger reusable retrieval contract over a tiny row-by-row cleanup pass.
- Keep starter versus later-only boundary explicit while expanding relation-ready usefulness.

## Required outputs
Create or update these files:
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/scenario-plan.json`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/relation-sample-v1.json`
- `content-draft/tagalog/relation-authoring-notes.md`
- `.agent/tasks/T-114/logs/tagalog-relation-expansion-audit.md`
- `.agent/tasks/T-114/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-114/reviews/` for each required gate

## Concrete requirement
- expand or reorganize the Tagalog relation-ready authored surface so the lane leaves at least `24` meaningful row outcomes across starter-core, deferred, pickup, and later-only clusters unless bounded repo truth proves the live high-value set is smaller
- make the handoff clearer about anchor phrase, safer shorter form, clearer or more polite alternative when relevant, likely reply branch, and next-step or repair branch when relevant
- keep `first-wave-priority.csv`, `tagalog-v2-first-wave.csv`, and the narrative docs aligned on what is direct pickup versus later-only follow-on
- leave the next implementation or content lane with a retrieval-ready contract that is sharper than the current split across earlier results

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-tagalog-language-risk-review.md`
3. `03-retrieval-handoff-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify every required output file physically exists
- verify `content-draft/tagalog/relation-sample-v1.json` parses as JSON
- verify `content-draft/tagalog/first-wave-priority.csv` and `content-draft/tagalog/tagalog-v2-first-wave.csv` still parse after edits
- verify the final handoff covers at least `24` meaningful row outcomes unless bounded repo truth proves the live high-value set is smaller
- verify `scenario-plan.json` stays valid JSON
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no runtime app/site code files were changed

## Definition of done
- Tagalog has a materially stronger retrieval-ready relation contract than the first starter-core pack alone
- the lane is clearer about direct pickup versus later-only relation work
- downstream runtime or content work can start from one sharper handoff without rereading several older task results
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
