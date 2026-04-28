# Task Spec: T-154

## Title
Viet flagship phrase-cluster harvest, retained-row promotion, and answer-page deepening packet

## Objective
Deepen the most important Viet listing pages by harvesting the real phrase clusters behind them and saving the genuinely useful rows into authored truth. This task should turn the new completeness standard into concrete Viet content: keep the rows that matter, reject decorative synonyms, and strengthen the answer-page and relation graph around those retained rows.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-154/brief.md`
- `.agent/tasks/T-152/result.md`
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
- viet flagship-cluster harvest
- retained-row promotion
- answer-page deepening

## Scope
### Allowed write scopes
- `.agent/tasks/T-154/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\V2_CONTENT_MODEL.md` only if mirrored branch truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\PHRASE_RELATIONSHIP_MODEL.md` only if mirrored branch truth changes

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
- `T-152` proved the broader Viet answer-page structure at `80` answer-page-ready hubs and `7` active phrase classes.
- The next product gap is not generic coverage; it is whether the most important pages preserve the real phrase cluster behind the intent.
- AI can always produce more variants, but this task must keep only rows that improve traveler utility, social safety, likely conversation flow, or next-step usefulness.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md`
- `.agent/tasks/T-154/logs/viet-flagship-cluster-harvest-notes.md`
- `.agent/tasks/T-154/logs/viet-flagship-cluster-triage-ledger.md`
- `.agent/tasks/T-154/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-154/reviews/` for each required gate

## Concrete requirements
- focus on at least `15` flagship Viet intent pages, including a mix of:
  - `hello`
  - `yes`
  - `no`
  - `thank you`
  - `sorry / excuse me`
  - `I don't understand`
  - `how much is this?`
  - `take me here`
  - `I need a doctor`
  - `where is the bathroom?`
  - `can I pay by card?`
  - `I have a reservation`
- for each targeted page, harvest and triage candidate rows as if prompted by a question like `Different ways to say [PHRASE] in Vietnam`
- retain rows when they add real traveler utility, including:
  - meaningful politeness or hierarchy shift
  - confirmation vs agreement distinction
  - distinct traveler context
  - likely reply, repair, escalation, or next-step value
  - local-real-world usage difference
- reject or demote rows that are decorative synonyms without real utility difference
- add at least `90` new or newly resolved/supporting phrase rows across the targeted flagship cluster set
- materially deepen at least `12` existing flagship answer hubs
- ensure each targeted flagship page has stronger relation rails for likely reply, next step, repair, or escalation where appropriate
- record a compact keep/reject rationale in the triage ledger for the harvested candidate groups so the retained rows are auditable
- keep answer-page modules compact and app-usable; do not turn the pages into long essays

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-flagship-cluster-review.md`
2. `02-traveler-utility-review.md`
3. `03-keep-reject-discipline-review.md`
4. `04-scope-and-authoring-safety-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`:
- JSON parse/shape validation for `content-draft/viet/answer-page-sample-v1.json`
- JSON parse/shape validation for `content-draft/viet/relation-sample-v1.json`
- CSV sanity audit confirming the retained rows exist in `phrase-source.csv`
- relation cross-check that all newly linked family ids and phrase ids resolve cleanly

Also verify:
- at least `15` flagship intent pages were audited through the cluster-harvest flow
- at least `90` new or newly resolved/supporting rows were retained
- at least `12` existing flagship hubs were materially deepened
- the triage ledger clearly distinguishes kept vs rejected candidate patterns
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Viet flagship pages preserve a materially richer phrase cluster
- useful candidate rows are saved into durable authored truth rather than left as disposable reasoning
- relation mapping is stronger for the flagship hub set
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo/branch truth docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because AI could always generate more candidate rows later
- do not block on audio generation itself; this task is about retained row truth and listing-page depth
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
