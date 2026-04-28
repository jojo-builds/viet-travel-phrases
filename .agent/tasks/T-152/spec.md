# Task Spec: T-152

## Title
Viet flagship answer-hub deepening, phrase-class expansion, and cross-link growth packet

## Objective
Take the current Viet answer-page system from a meaningful proof set to a stronger core library that better matches the product vision. This task should both widen coverage and deepen the highest-value flagship listing pages so the Viet lane stops feeling thin on the exact pages users are most likely to open first.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-152/brief.md`
- `.agent/tasks/T-151/result.md`
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
- flagship listing-page deepening
- phrase-class and relation-graph enrichment

## Scope
### Allowed write scopes
- `.agent/tasks/T-152/**`
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
- app UI shell files on the Liquid Glass branch
- `ops/**`
- `docs/operations/**`
- unrelated language prep lanes

## Source-of-truth notes
- `T-151` left Viet at `50` enriched answer hubs, `99` relation clusters, `95` supporting/newly resolved rows, and `82` newly marked rows.
- That is real progress, but still nowhere near enough to claim the Viet listing-page system is complete.
- The most important product gap now is that top pages still need deeper answer content and more connected utility.
- This pass should improve the exact areas the user cares about:
  - richer `hello` and social pages
  - stronger urgent-help and pharmacy flows
  - more useful money, hotel, food, and service contexts
  - more believable tap-forward "Wikipedia effect" linking

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md`
- `.agent/tasks/T-152/logs/viet-flagship-answer-hub-deepening-notes.md`
- `.agent/tasks/T-152/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-152/reviews/` for each required gate

## Concrete requirements
- expand the answer-page sample from `50` hubs to at least `80` enriched hubs
- expand active phrase classes from `4` to at least `7`
- add at least `3` new practical phrase classes from the following set:
  - `money-transaction`
  - `food-drink`
  - `hotel-accommodation`
  - `shopping`
  - `bathroom-personal-needs`
  - `time-booking`
- deeply upgrade at least `15` flagship hubs that already matter most to traveler utility, including a mix of:
  - greetings / social openers
  - urgent help / medical
  - misunderstanding repair
  - transport / directions
  - money / payment
  - hotel / service
- add at least `120` new or newly resolved/supporting phrase rows across the expanded and deepened hub set
- ensure the strengthened graph materially reduces dead-end hubs:
  - at least `40` enriched hubs must expose a credible next-step, repair, escalation, or nearby-useful path
- keep modules compact and app-usable
- do not write essay-like content blobs
- keep copy traveler-realistic, especially for "what actually works" situations under stress
- if existing flagship hubs are still too textbook, rewrite them toward practical traveler utility rather than preserving weak copy

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-flagship-hub-depth-review.md`
2. `02-phrase-class-coverage-review.md`
3. `03-traveler-utility-and-links-review.md`
4. `04-scope-and-authoring-safety-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`:
- JSON parse/shape validation for `content-draft/viet/answer-page-sample-v1.json`
- JSON parse/shape validation for `content-draft/viet/relation-sample-v1.json`
- CSV sanity audit confirming the expanded hubs and supporting rows exist in `phrase-source.csv`
- relation cross-check that all newly linked family ids resolve cleanly

Also verify:
- at least `80` enriched hubs exist
- at least `7` active phrase classes exist
- at least `120` supporting/newly resolved rows were added for the expanded and deepened hubs
- at least `15` flagship hubs were materially deepened rather than only counted as coverage
- the content reads like practical answer-page data rather than generic textbook notes
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Viet answer-page coverage is much stronger than the current proof set
- the flagship listing pages feel materially richer and less generic
- the phrase-class system is broader and more realistic
- phrase-to-phrase mapping is stronger across the expanded hub set
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo/branch truth docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because even deeper future work is still possible
- do not block on UI implementation details; this is a content/database packet
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
