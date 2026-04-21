# Task Spec: T-063

## Title
Desktop Codex automation pilot, South Korea first-wave authoring scaffold completion

## Objective
Bring the South Korea prep lane up to the same authoring-ready scaffold level as the stronger future-language lanes.
This task should take the existing South Korea research/bootstrap lane and add the missing first authoring scaffold so the next Korean translation task can start immediately instead of redoing orientation work.

This is prep-only work. Do not wire Korean into the runtime app.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/coordination/queue-index.json`
- `.agent/coordination/locks.yaml`
- `docs/LANGUAGE_PREP_WORKFLOW.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRIORITIES.md`
- `templates/FAMILY_TRAVELER_BASELINE.json`
- `research/language-pipeline/korean/SOUTH-KOREA-TRAVEL-RESEARCH.md`
- `content-draft/korean/README.md`
- `content-draft/korean/source-notes.md`
- `content-draft/korean/scenario-plan.json`
- `content-draft/korean/research-backlog.md`

## Task type
- research synthesis
- planning
- scaffold completion

## Scope
### Allowed write scopes
- `.agent/tasks/T-063/**`
- `.agent/coordination/queue-index.json`
- `content-draft/korean/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**`
- `content-draft/thai/**`
- `content-draft/japanese/**`
- `content-draft/turkish/**`
- `content-draft/spanish/**`
- `content-draft/italian/**`
- `app/family/**` for bounded reference only if needed to understand pack shape

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring such as `app/family/appRegistry.js` or `app/family/currentApp.ts`
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- South Korea already has destination-fit research and prep-only framing, but it still lacks the concrete shortlist scaffolding that makes the next translation pass actionable.
- This task is successful only if South Korea becomes immediately ready for the next translation task.
- Keep politeness, script, romanization, and search posture honest rather than pretending every Korean risk is already settled.
- `T-018` is the blocked bootstrap predecessor that created the initial Korean prep lane. Treat it as historical context for this lane, not as the active owner of the remaining scaffold-completion work claimed by `T-063`.

## Required outputs
Create or update these files:
- `content-draft/korean/README.md`
- `content-draft/korean/source-notes.md`
- `content-draft/korean/scenario-plan.json` only if a better South Korea-specific ordering is justified
- `content-draft/korean/phrase-source.csv`
- `content-draft/korean/first-wave-priority.csv`
- `content-draft/korean/research-backlog.md`
- `.agent/tasks/T-063/result.md`
- review artifacts under `.agent/tasks/T-063/reviews/` organized by gate and pass, with exactly 4 role files in the latest pass for Gate 1, Gate 2, and Gate 3

## Concrete scaffold requirement
This task is not done unless it leaves both of these behind:
- a reusable `phrase-source.csv` scaffold for the Korean lane
- a ranked `first-wave-priority.csv` that tells the next translation task exactly where to start

That shortlist must include at minimum:
- rank
- scenario_id
- phrase_id
- english_text
- priority_reason
- confidence
- review_flag

## What the task must cover
- the first Korean starter-pack priorities inside the shared 10-scenario seam
- politeness posture for English-speaking travelers, especially safe polite defaults
- script, romanization, pronunciation, and search posture for SpeakLocal surfaces
- which sensitive Korean rows need expert review later
- how to keep the lane prep-only while still making it genuinely actionable

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-korean-language-risk-review.md`
3. `03-authoring-scaffold-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/korean/phrase-source.csv` exists and is non-empty
- verify `content-draft/korean/first-wave-priority.csv` exists and is non-empty
- verify `content-draft/korean/scenario-plan.json` parses if touched
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under `.agent/tasks/T-063/reviews/`
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**` or runtime-wiring files were changed
- verify the Korean lane is more authoring-ready than before by checking that the next translation task could start from the new files without another orientation pass

## Definition of done
- Korean prep truth is materially stronger than before
- the lane now has a real first-wave authoring scaffold
- the shortlist is concrete, ranked, and useful
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- substantive findings were handled
- prep-only boundary is preserved and runtime wiring is untouched
- `.agent/tasks/T-063/result.md` states what changed, what was verified, what remains open, and whether the objective was fully met

## Required result contract
Before stopping, write `.agent/tasks/T-063/result.md` with:
- status: done, partial, or blocked
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step
