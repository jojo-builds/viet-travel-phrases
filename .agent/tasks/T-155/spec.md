# Task Spec: T-155

## Title
Tagalog answer-page expansion pack 2 and flagship listing-hub deepening packet

## Objective
Take the new Tagalog answer-page sidecar beyond its first `24`-hub proof set and turn it into a stronger core library. This task should both widen answer-page coverage and deepen the flagship Tagalog hubs so the second language starts looking structurally serious rather than merely prepared.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-155/brief.md`
- `.agent/tasks/T-153/result.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/answer-page-sample-v1.json`
- `content-draft/tagalog/relation-sample-v1.json`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/relation-authoring-notes.md`

## Task type
- tagalog answer-page expansion
- flagship listing-hub deepening
- relation-ready content growth

## Scope
### Allowed write scopes
- `.agent/tasks/T-155/**`
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
- the Viet expansion lane
- the Liquid Glass UI lanes
- `ops/**`
- `docs/operations/**`
- unrelated future-language lanes

## Source-of-truth notes
- `T-153` established the first Tagalog answer-page sidecar at `24` hubs across `4` phrase classes.
- The next gap is that Tagalog still needs a much stronger core set and deeper flagship pages.
- This pass should preserve the disciplined additive model while making Tagalog clearly more ready for future runtime use.

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
- `.agent/tasks/T-155/logs/tagalog-answer-page-expansion-pack-2-notes.md`
- `.agent/tasks/T-155/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-155/reviews/` for each required gate

## Concrete requirements
- expand Tagalog answer-page coverage from `24` to at least `50` enriched hubs
- expand active Tagalog phrase classes from `4` to at least `6`
- add at least `90` new or newly resolved/supporting phrase rows across the expanded hub set
- materially deepen at least `10` existing flagship Tagalog hubs
- ensure the expanded set covers a stronger mix of:
  - greetings / social
  - urgent help / medical
  - repair / clarification
  - practical service / navigation
  - money / transaction
  - hotel / accommodation or food / drink
- keep the sidecar additive and relation-disciplined
- rebuild the Tagalog pack and leave the branch pack-valid
- keep answer-page modules compact and traveler-realistic rather than essay-like

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-hub-expansion-review.md`
2. `02-traveler-utility-review.md`
3. `03-relation-depth-review.md`
4. `04-scope-and-runtime-handoff-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app`:
- JSON parse/shape validation for `..\content-draft\tagalog\answer-page-sample-v1.json`
- JSON parse/shape validation for `..\content-draft\tagalog\relation-sample-v1.json`
- CSV sanity audit confirming the expanded hubs and supporting rows exist in `..\content-draft\tagalog\phrase-source.csv`
- relation cross-check that all newly linked family ids resolve cleanly
- `npm run build:tagalog-pack`
- `npm run validate:family`
- `npm run validate:premium-boundary`
- `npm run validate:premium-expansion`

Also verify:
- at least `50` enriched hubs exist
- at least `6` phrase classes have distinct module mixes
- at least `90` supporting/newly resolved rows were added for the expanded hub set
- at least `10` existing flagship hubs were materially deepened
- the content reads like practical answer-page data rather than generic textbook notes
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Tagalog answer-page coverage is materially deeper than the first proof set
- flagship Tagalog pages are stronger and less generic
- relation mapping is stronger across the expanded hub set
- Tagalog pack build and validators pass
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo/branch truth docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because Tagalog can still get even deeper later
- do not block on UI implementation details; this is a content/database packet
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
