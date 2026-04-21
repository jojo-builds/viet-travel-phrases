# Task Spec: T-108

## Title
Desktop Codex automation pilot, Tagalog relation-ready phrase family pack and follow-on graph prep

## Objective
Start Tagalog on the new phrase-relationship direction early by turning a meaningful starter/follow-on slice into relation-ready phrase families. The task should enrich Tagalog source truth so the lane is not just accumulating translated rows, but building navigable phrase-detail/listing units from the start.

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
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/risk-review.md`

## Task type
- phrase-family enrichment
- relation-model prep
- Tagalog handoff hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-108/**`
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
- This task should not just translate or clean up a small row tail.
- Use the new relation-ready direction from the start.
- Tagalog should inherit the relationship model earlier than Viet had to.
- Keep starter versus premium and confidence posture honest.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/relation-sample-v1.json`
- `content-draft/tagalog/relation-authoring-notes.md`
- `.agent/tasks/T-108/logs/tagalog-relation-pack-audit.md`
- `.agent/tasks/T-108/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-108/reviews/` for each required gate

## Concrete requirement
- enrich at least `16` meaningful Tagalog phrase-family clusters with relation-ready structure
- for each cluster, leave honest guidance for shortest form, clearer/polite alternatives when relevant, and likely next-step or repair branches
- leave the lane more implementation-ready for phrase-detail/listing experiences, not just larger in row count

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-tagalog-language-risk-review.md`
3. `03-relationship-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/tagalog/relation-sample-v1.json` parses as JSON
- verify at least 16 phrase-family clusters received relation-ready enrichment
- verify `content-draft/tagalog/tagalog-v2-first-wave.csv` still parses after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no runtime app/site code files were changed

## Definition of done
- Tagalog phrase-family truth is materially more relation-ready than before
- the lane is more useful for future phrase-detail/listing implementation
- the work improves forward navigation potential, not just phrase inventory
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
