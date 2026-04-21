# Task Spec: T-107

## Title
Desktop Codex automation pilot, Viet phrase relationship schema draft and listing-detail handoff pack

## Objective
Define the first relation-ready Viet content contract so the app and website can evolve from flat phrase retrieval into navigable phrase-detail/listing experiences. This task should produce a concrete schema and a small but meaningful Viet sample set that shows how one phrase can lead into shorter, clearer, polite, reply, and next-step related phrases.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `docs/DECISIONS.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `content-draft/viet/README.md`
- `content-draft/viet/source-notes.md`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/website-preview.json`
- `app/family/packs/viet.generated.ts`

## Task type
- content schema design
- relation-model hardening
- Viet runtime/content handoff prep

## Scope
### Allowed write scopes
- `.agent/tasks/T-107/**`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/viet/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/tagalog/**`
- `app/family/**`
- `site/**` as read-only reference for website-safe field needs

### Must not touch
- runtime app code as a write surface in `app/**`
- release/build/TestFlight files
- unrelated non-Viet language lanes except read-only inspection
- billing / purchase / device-proof docs unless directly needed as a bounded reference

## Source-of-truth notes
- This task is about relation-ready content truth and handoff shape, not final UI implementation.
- Do not invent a separate graph database solution in this task.
- Extend the current family/row model with practical relation-ready authored truth.
- Keep the output useful for both app and website starter-safe subsets.

## Required outputs
Create or update these files:
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/viet/README.md`
- `content-draft/viet/source-notes.md`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/relation-authoring-notes.md`
- `.agent/tasks/T-107/logs/relation-schema-audit.md`
- `.agent/tasks/T-107/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-107/reviews/` for each required gate

## Concrete requirement
- define a relation-ready authored shape that can express at least:
  - shortest socially safe form
  - clearer form
  - more polite form
  - likely reply / what-you-may-hear link
  - next-step or repair link
- produce a small but meaningful Viet sample covering at least `12` phrase-family clusters across high-value traveler moments such as greeting, transport, food, money, hotel, and repair
- leave behind a handoff that frontend/runtime work can consume without redoing concept design from scratch

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-viet-language-risk-review.md`
3. `03-schema-handoff-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/viet/relation-sample-v1.json` parses as JSON
- verify the Viet sample covers at least 12 phrase-family clusters
- verify the schema and notes stay aligned with the current family/row model instead of replacing it
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no runtime app code files were changed

## Definition of done
- Viet now has a concrete relation-ready content contract and sample set
- the output is detailed enough that frontend/runtime implementation can start from it directly
- the model strengthens forward-tap/listing behavior rather than acting like a flat phrase DB
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no separate graph-database dependency was introduced
