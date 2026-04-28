# Task Spec: T-149

## Title
Viet answer-page expansion pack 2 with supporting phrase growth and deeper traveler copy

## Objective
Expand the Viet answer-page content model beyond the first proof set so the listing-page system has significantly more real coverage. This task should add more enriched hubs, more phrase support where needed, and stronger traveler-realistic copy across the highest-value travel situations.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-149/brief.md`
- `.agent/tasks/T-145/result.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `content-draft/viet/README.md`
- `content-draft/viet/answer-page-sample-v1.json`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/relation-authoring-notes.md`

## Task type
- viet answer-page content expansion
- phrase-row growth
- traveler copy enrichment

## Scope
### Allowed write scopes
- `.agent/tasks/T-149/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\V2_CONTENT_MODEL.md` only if mirrored branch truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\PHRASE_RELATIONSHIP_MODEL.md` only if mirrored branch truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\VIET_PREMIUM_EXPANSION_PLAN.md` only if durable branch truth changes

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\**`

### Must not touch
- `.agent/coordination/queue-index.json` after claim unless this task explicitly needs a final best-effort sync note
- app UI files on the Liquid Glass branch
- `ops/**`
- `docs/operations/**`
- unrelated language prep lanes

## Source-of-truth notes
- `T-145` established the first modular answer-page seam with `24` hubs across `4` phrase classes.
- This task should deepen that system substantially rather than invent a second content format.
- The goal is more real coverage and more supporting phrase depth, especially where listing pages need practical alternates, repair steps, and next actions.
- A blocker only counts as real if it requires user intervention or a real external dependency; ordinary authoring ambiguity should be resolved inside the task.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md`
- `.agent/tasks/T-149/logs/viet-answer-page-expansion-pack-2-notes.md`
- `.agent/tasks/T-149/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-149/reviews/` for each required gate

## Concrete requirements
- expand the answer-page sample from `24` hubs to at least `48` enriched hubs
- keep at least `4` phrase classes active and allow additional classes if they materially help
- add meaningful phrase-row support where needed:
  - at least `80` new or newly resolved/supporting phrase rows across the expanded hubs
  - rows may include alternates, follow-ups, repair steps, situational versions, or nearby next-need phrases
- ensure the expansion materially improves the kinds of pages the user is building now, especially:
  - greetings/social
  - urgent help/medical
  - repair/clarification
  - service/navigation
  - optionally food/service or money/practical travel if they fit cleanly
- keep answer-page modules compact and app-usable
- do not produce essay-style content blobs
- strengthen linked phrase navigation and avoid shallow dead-end hubs
- keep the content traveler-realistic and stress-usable

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-hub-expansion-review.md`
2. `02-traveler-copy-review.md`
3. `03-phrase-depth-and-relations-review.md`
4. `04-scope-and-authoring-safety-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`:
- JSON parse/shape validation for `content-draft/viet/answer-page-sample-v1.json`
- JSON parse/shape validation for `content-draft/viet/relation-sample-v1.json`
- CSV sanity audit confirming the expanded hubs and supporting rows exist in `phrase-source.csv`
- relation cross-check that all newly linked family ids resolve cleanly

Also verify:
- at least `48` enriched hubs exist
- at least `80` supporting/newly resolved rows were added for the expanded hubs
- the content still reads like practical answer-page data rather than generic textbook notes
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Viet answer-page coverage is materially deeper than the first sample set
- the new listing-page system has more real copy and more phrase support behind it
- phrase-to-phrase mapping is stronger across the expanded hub set
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo/branch truth docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because the content could always be even deeper later
- do not block on UI implementation details; this is a content packet
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
