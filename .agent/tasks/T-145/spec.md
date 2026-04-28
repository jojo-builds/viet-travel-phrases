# Task Spec: T-145

## Title
Viet modular answer-page content model and high-value phrase-hub enrichment packet

## Objective
Implement the first meaningful Viet content pass that supports the new AI-shaped listing-page direction with real structured answer data. The goal is not just to describe a future schema, but to land an additive answer-content seam plus a substantial set of enriched Viet phrase hubs that use different module sets depending on phrase type.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-145/brief.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `content-draft/viet/README.md`
- `content-draft/viet/relation-authoring-notes.md`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/phrase-source.csv`

## Task type
- viet content-system enrichment
- answer-page module modeling
- relation-ready phrase-hub authoring

## Scope
### Allowed write scopes
- `.agent/tasks/T-145/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\VIET_PREMIUM_EXPANSION_PLAN.md` only if durable branch truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\PHRASE_RELATIONSHIP_MODEL.md` only if the branch maintains a mirrored durable copy and truth genuinely changes
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\V2_CONTENT_MODEL.md` only if the branch maintains a mirrored durable copy and truth genuinely changes

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\**`

### Must not touch
- `.agent/coordination/queue-index.json` after claim unless this task explicitly needs a final best-effort sync note
- app UI shell files under `liquid-glass-native`
- `ops/**`
- `docs/operations/**`
- unrelated future-language prep lanes

## Source-of-truth notes
- The new UI direction is now confirmed: listing pages are AI-shaped answer pages, not flat phrase details.
- Not every phrase type should use the same answer-section mix.
- The Viet lane already has relation-ready sidecar work and large raw-row growth; this task should extend that content logic rather than reinventing a second disconnected system.
- A blocker only counts as real if it requires user intervention or a real external dependency; ordinary authoring ambiguity should be resolved inside the task.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md`
- `.agent/tasks/T-145/logs/viet-answer-page-model-notes.md`
- `.agent/tasks/T-145/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-145/reviews/` for each required gate

## Concrete requirements
- define an additive answer-page sidecar seam for Viet that can support different section/module mixes by phrase type without turning into freeform prose blobs
- use a small set of practical phrase classes, for example:
  - greetings / social
  - urgent help / medical
  - repair / clarification
  - practical service / navigation
- author a meaningful real sample, not a toy sample:
  - enrich at least `24` Viet phrase hubs across at least `3` phrase classes
  - each enriched hub must have a clear module mix and real linked-phrase/navigation intent
- strengthen phrase-to-phrase mapping where needed so the enriched hubs can support:
  - best default
  - quick say / shortest backup
  - alternate or situational phrasing
  - local-reality guidance where appropriate
  - follow-up / next-step links
- the sidecar must stay additive:
  - phrase text truth stays in `phrase-source.csv`
  - answer-page structure and module content live in the additive sample seam
- keep the content practical and traveler-realistic, especially for high-value medical/help pages
- do not try to write giant article essays for every phrase; keep sections compact and app-usable
- if needed, add lightweight markers in `phrase-source.csv` notes so enriched hubs are traceable from row truth

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-module-model-review.md`
2. `02-traveler-utility-review.md`
3. `03-relation-depth-review.md`
4. `04-scope-and-authoring-safety-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`:
- a JSON parse/shape validation for `content-draft/viet/answer-page-sample-v1.json`
- a CSV sanity audit that confirms the enriched sample families/rows exist in `phrase-source.csv`
- a relation cross-check that all linked family ids in the new sample resolve cleanly
- any existing Viet branch validation already appropriate for content truth if the task changes generated/runtime-adjacent files

Also verify:
- at least `24` phrase hubs were enriched
- at least `3` phrase classes have distinct module mixes
- the content reads as practical answer-page data, not generic textbook notes
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Viet has a real additive answer-page content seam
- the seam supports different phrase-type layouts/modules instead of forcing one repeated page shape
- at least `24` high-value Viet phrase hubs are enriched with real modular answer content
- relation mapping is materially stronger for those hubs
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo/branch truth docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because of ordinary authoring ambiguity if bounded content decisions and review can resolve it
- do not block on UI implementation details; this task is about real content structure and real Viet answer data
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
