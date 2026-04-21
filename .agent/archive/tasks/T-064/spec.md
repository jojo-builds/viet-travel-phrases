# Task Spec: T-064

## Title
Desktop Codex automation pilot, Indonesia first-wave authoring scaffold completion

## Objective
Bring the Indonesia prep lane up to the same authoring-ready scaffold level as the stronger future-language lanes.
This task should take the existing Indonesia research/bootstrap lane and add the missing first authoring scaffold so the next Indonesian translation task can start immediately instead of redoing orientation work.

This is prep-only work. Do not wire Indonesian into the runtime app.

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
- `research/language-pipeline/indonesian/INDONESIA-TRAVEL-RESEARCH.md`
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/source-notes.md`
- `content-draft/indonesian/scenario-plan.json`
- `content-draft/indonesian/research-backlog.md`

## Task type
- research synthesis
- planning
- scaffold completion

## Scope
### Allowed write scopes
- `.agent/tasks/T-064/**`
- `.agent/coordination/queue-index.json`
- `content-draft/indonesian/**`

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
- Indonesian research synthesis unless a bounded consistency fix is required by the new scaffold outputs

## Source-of-truth notes
- Indonesia already has destination-fit research and prep-only framing, but it still lacks the concrete shortlist scaffolding that makes the next translation pass actionable.
- This task is successful only if Indonesia becomes immediately ready for the next translation task.
- Keep register, pronunciation, and search posture honest rather than pretending every Indonesian variant question is already resolved.

## Required outputs
Create or update these files:
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/source-notes.md`
- `content-draft/indonesian/scenario-plan.json` only if a better Indonesia-specific ordering is justified
- `content-draft/indonesian/phrase-source.csv`
- `content-draft/indonesian/first-wave-priority.csv`
- `content-draft/indonesian/research-backlog.md`
- `.agent/tasks/T-064/result.md`
- Gate 1 latest-pass review set with exactly 4 review artifacts under `.agent/tasks/T-064/reviews/`
- Gate 2 latest-pass review set with exactly 4 review artifacts under `.agent/tasks/T-064/reviews/`
- Gate 3 latest-pass review set with exactly 4 review artifacts under `.agent/tasks/T-064/reviews/`

## Concrete scaffold requirement
This task is not done unless it leaves both of these behind:
- a reusable `phrase-source.csv` scaffold for the Indonesian lane
- a ranked `first-wave-priority.csv` that tells the next translation task exactly where to start

That shortlist must include at minimum:
- rank
- scenario_id
- phrase_id
- english_text
- priority_reason
- confidence
- review_flag

## Phrase-source contract
`content-draft/indonesian/phrase-source.csv` must be a reusable row-level scaffold, not a theme list.

Minimum requirements:
- columns: `phrase_id,scenario_id,audio_key,english_text,target_text,pronunciation,context,emoji,notes,status`
- cover the shared 10-scenario seam and any justified Indonesia-specific supplemental rows
- keep stable Indonesian lane IDs for every row
- leave `target_text` and `pronunciation` blank when later translation work still owns them
- use `notes` and `status` to expose rewrite-before-translation debt, later-review flags, or first-wave promotion decisions instead of hiding them
- every `phrase_id` selected in `first-wave-priority.csv` must resolve to a row in `phrase-source.csv` with matching `english_text`

## What the task must cover
- the first Indonesian starter-pack priorities inside the shared 10-scenario seam
- traveler-facing politeness defaults and when softer or more local variants matter
- pronunciation and search posture for SpeakLocal surfaces
- which sensitive Indonesian rows need expert review later
- how to keep the lane prep-only while still making it genuinely actionable

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-indonesian-language-risk-review.md`
3. `03-authoring-scaffold-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/indonesian/phrase-source.csv` exists and is non-empty
- verify `content-draft/indonesian/first-wave-priority.csv` exists and is non-empty
- verify `content-draft/indonesian/scenario-plan.json` parses if touched
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under `.agent/tasks/T-064/reviews/`
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**` or runtime-wiring files were changed
- verify the Indonesian lane is more authoring-ready than before by checking that the next translation task could start from the new files without another orientation pass

## Definition of done
- Indonesian prep truth is materially stronger than before
- the lane now has a real first-wave authoring scaffold
- the shortlist is concrete, ranked, and useful
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- substantive findings were handled
- prep-only boundary is preserved and runtime wiring is untouched
- `.agent/tasks/T-064/result.md` states what changed, what was verified, what remains open, and whether the objective was fully met

## Required result contract
Before stopping, write `.agent/tasks/T-064/result.md` with:
- status: done, partial, or blocked
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step
