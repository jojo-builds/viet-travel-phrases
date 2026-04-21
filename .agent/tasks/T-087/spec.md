# Task Spec: T-087

## Title
Desktop Codex automation pilot, France first-wave authoring scaffold completion

## Objective
Bring the France prep lane up from research/bootstrap status to an authoring-ready scaffold so the next French translation task can start immediately without redoing orientation work.

This is prep-only work. Do not wire French into the runtime app.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-019/result.md`
- `docs/LANGUAGE_PREP_WORKFLOW.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRIORITIES.md`
- `templates/FAMILY_TRAVELER_BASELINE.json`
- `research/language-pipeline/french/FRANCE-TRAVEL-RESEARCH.md`
- `content-draft/french/README.md`
- `content-draft/french/source-notes.md`
- `content-draft/french/scenario-plan.json`
- `content-draft/french/research-backlog.md`

## Task type
- research synthesis
- planning
- scaffold completion

## Scope
### Allowed write scopes
- `.agent/tasks/T-087/**`
- `research/language-pipeline/french/**`
- `content-draft/french/**`

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
- France already has destination-fit research and prep-only framing from `T-019`, but it still lacks the shortlist scaffolding that makes the next translation task actionable.
- This task is successful only if France becomes immediately ready for the next translation pass.
- Keep register posture honest for traveler-facing French defaults, especially politeness and service phrasing, and do not pretend every pronunciation or search choice is fully settled.

## Required outputs
Create or update these files:
- `content-draft/french/README.md`
- `content-draft/french/source-notes.md`
- `content-draft/french/scenario-plan.json` only if a better France-specific ordering is justified
- `content-draft/french/phrase-source.csv`
- `content-draft/french/first-wave-priority.csv`
- `content-draft/french/research-backlog.md`
- `.agent/tasks/T-087/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-087/reviews/`

## Concrete scaffold requirement
This task is not done unless it leaves both of these behind:
- a reusable `phrase-source.csv` scaffold for the French lane
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
- the first French starter-pack priorities inside the shared 10-scenario seam
- register posture for English-speaking travelers, especially default polite forms and when softer variants matter
- pronunciation and search posture for SpeakLocal surfaces
- which sensitive French rows need expert review later
- how to keep the lane prep-only while still making it genuinely actionable

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-language-risk-review.md`
3. `03-authoring-scaffold-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify every required output file physically exists
- verify `content-draft/french/phrase-source.csv` exists and is non-empty
- verify `content-draft/french/first-wave-priority.csv` exists and is non-empty
- verify `content-draft/french/scenario-plan.json` parses if touched
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under `.agent/tasks/T-087/reviews/`
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**` or runtime-wiring files were changed
- verify the French lane is more authoring-ready than before by checking that the next translation task could start from the new files without another orientation pass

## Definition of done
- French prep truth is materially stronger than before
- the lane now has a real first-wave authoring scaffold
- the shortlist is concrete, ranked, and useful
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- substantive findings were handled
- prep-only boundary is preserved and runtime wiring is untouched
- `.agent/tasks/T-087/result.md` states what changed, what was verified, what remains open, and whether the objective was fully met
