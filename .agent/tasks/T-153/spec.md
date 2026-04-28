# Task Spec: T-153

## Title
Tagalog answer-page sidecar bootstrap and first substantial listing-hub enrichment packet

## Objective
Bring Tagalog onto the same additive answer-page model that Viet is using, while landing a meaningful first set of enriched Tagalog listing-page hubs. The goal is to ensure Tagalog is not just a thin relation pack, but a real participant in the AI-shaped listing-page product direction.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-153/brief.md`
- `.agent/tasks/T-141/result.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/relation-sample-v1.json`
- `content-draft/tagalog/relation-authoring-notes.md`
- `content-draft/tagalog/scenario-plan.json`

## Task type
- tagalog answer-page content bootstrap
- listing-page module modeling
- relation-ready phrase-hub enrichment

## Scope
### Allowed write scopes
- `.agent/tasks/T-153/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\first-wave-priority.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\tagalog-v2-first-wave.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\relation-authoring-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\source-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\packs\tagalog.generated.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\V2_CONTENT_MODEL.md` only if mirrored branch truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\PHRASE_RELATIONSHIP_MODEL.md` only if mirrored branch truth changes

### Allowed read scopes
- `docs/**`
- `content-draft/tagalog/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\**`

### Must not touch
- `.agent/coordination/queue-index.json` after claim unless this task explicitly needs a final best-effort sync note
- the Liquid Glass UI lanes
- the Viet expansion lane
- `ops/**`
- `docs/operations/**`
- unrelated future-language lanes

## Source-of-truth notes
- Tagalog currently has phrase-source truth and a `79`-cluster relation sidecar, but it does not yet have a true answer-page sidecar.
- The product direction now assumes reusable AI-shaped listing pages across languages, not a Viet-only content model.
- This pass should make Tagalog structurally ready for the same listing-page product without waiting for native implementation.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\first-wave-priority.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\tagalog-v2-first-wave.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\relation-authoring-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\source-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\packs\tagalog.generated.ts`
- `.agent/tasks/T-153/logs/tagalog-answer-page-bootstrap-notes.md`
- `.agent/tasks/T-153/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-153/reviews/` for each required gate

## Concrete requirements
- create the first additive `content-draft/tagalog/answer-page-sample-v1.json`
- define at least `4` active Tagalog phrase classes/module mixes, reusing family-model ideas where they fit:
  - `greetings-social`
  - `urgent-help-medical`
  - `repair-clarification`
  - `practical-service-navigation`
- enrich at least `24` Tagalog answer hubs across at least `4` phrase classes
- add at least `72` new or newly resolved/supporting phrase rows across the enriched hub set
- strengthen relation coverage so the enriched hubs can support:
  - default phrase
  - quick/short fallback
  - likely reply
  - next useful phrase
  - repair or escalation path where appropriate
- keep the sidecar additive:
  - phrase wording truth stays in `phrase-source.csv`
  - answer-page structure lives in `answer-page-sample-v1.json`
  - relation truth stays in `relation-sample-v1.json`
- rebuild the Tagalog pack and leave the branch pack-valid
- keep the content practical and traveler-realistic rather than textbook-heavy

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-module-model-review.md`
2. `02-traveler-utility-review.md`
3. `03-relation-depth-review.md`
4. `04-scope-and-runtime-handoff-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app`:
- JSON parse/shape validation for `..\content-draft\tagalog\answer-page-sample-v1.json`
- JSON parse/shape validation for `..\content-draft\tagalog\relation-sample-v1.json`
- CSV sanity audit confirming the enriched hubs and supporting rows exist in `..\content-draft\tagalog\phrase-source.csv`
- relation cross-check that all newly linked family ids resolve cleanly
- `npm run build:tagalog-pack`
- `npm run validate:family`
- `npm run validate:premium-boundary`
- `npm run validate:premium-expansion`

Also verify:
- at least `24` enriched hubs exist
- at least `4` phrase classes have distinct module mixes
- at least `72` supporting/newly resolved rows were added for the enriched hubs
- the content reads like practical answer-page data rather than generic textbook notes
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Tagalog gains a real additive answer-page sidecar
- the Tagalog listing-page system is no longer only a thin relation handoff
- at least `24` meaningful Tagalog hubs are enriched with real modular answer content
- relation mapping is materially stronger for those hubs
- Tagalog pack build and validators pass
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo/branch truth docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because the full long-term Tagalog master library is not finished
- do not block on UI implementation details; this is a content/database packet
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
