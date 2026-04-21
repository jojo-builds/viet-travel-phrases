# Task Spec: T-003

## Title
Desktop Codex automation pilot, Thailand research and prep-only lane bootstrap

## Objective
Pilot the repo-local desktop Codex automation flow on one bounded research task.
Create the first prep-only Thailand lane artifacts needed for future SpeakLocal phrase expansion without wiring Thailand into the runtime app.
The task should leave behind durable research and draft-lane files that make later phrase-authoring work easier.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/AUTOMATION.md`
- `.agent/coordination/locks.yaml`
- `docs/LANGUAGE_PREP_WORKFLOW.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRIORITIES.md`
- `templates/FAMILY_TRAVELER_BASELINE.json`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/scenario-plan.json`
- `content-draft/viet/README.md`
- `research/exec-summary.md`
- `research/competitor-pain-analysis-2026-04-01.md`

## Scope
### Allowed write scopes
- `.agent/tasks/T-003/**`
- `.agent/coordination/locks.yaml`
- `research/language-pipeline/thai/**`
- `content-draft/thai/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/tagalog/**`
- `content-draft/viet/**`
- `content-draft/japanese/**`
- `content-draft/turkish/**`
- `app/family/**` for bounded reference only if needed to understand current pack shape

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- existing `content-draft/viet/**`
- existing `content-draft/tagalog/**`
- runtime registry wiring such as `app/family/appRegistry.js` or `app/family/currentApp.ts`
- release/build/TestFlight files

## Source-of-truth notes
- This is prep-only research, not runtime promotion.
- Keep Thailand out of runtime wiring for now.
- Use the traveler-first, destination-first SpeakLocal model, not generic classroom language learning.
- Favor the shortest socially safe phrase as the likely default surface.
- The baseline shape should stay aligned with the shared 10-scenario traveler seam unless research shows a very strong Thailand-specific reason to adjust wording or emphasis.
- Capture script and search risks honestly because Thai is a non-Latin lane.
- Treat this task as planning or prepared-next truth unless a file created here is clearly durable prep truth.

## Required outputs
Create these files:
- `research/language-pipeline/thai/THAI-TRAVEL-RESEARCH.md`
- `content-draft/thai/README.md`
- `content-draft/thai/source-notes.md`
- `content-draft/thai/scenario-plan.json`
- `content-draft/thai/research-backlog.md`
- `.agent/tasks/T-003/result.md`

## What the research must cover
- destination framing: Thailand / Thai
- traveler-use reality, not academic grammar ordering
- politeness model and when politeness particles or softer variants matter
- script posture and romanization posture for SpeakLocal surfaces
- likely high-value scenarios and whether the standard 10-scenario baseline is still the right skeleton
- likely-reply and repair-layer opportunities
- high-risk or confidence-sensitive phrase areas that should be reviewed carefully later
- concrete recommendation for what a future Thai starter pack should include first

## Required checks
- verify all required output files physically exist
- verify `content-draft/thai/scenario-plan.json` is valid JSON
- verify the scenario plan stays consistent with the shared traveler baseline or clearly explains any Thailand-specific deviation in the notes
- verify no runtime app files were changed
- keep the result artifact compact and evidence-based

## Review gate
Lightweight self-review required.
Challenge these points before finalizing:
- did the task stay prep-only
- did it avoid drifting into runtime implementation
- did it produce durable research artifacts instead of vague notes
- did it capture Thai script and search risk honestly

## Definition of done
- the required output files exist
- the Thai lane is documented as prep-only
- the research is strong enough that a later phrase-authoring task can use it without redoing the whole orientation pass
- the task state and result artifact agree on completion status

## Blocker rule
- do not stop at the first research uncertainty
- if certainty is limited, record the exact unresolved point and still finish the strongest bounded prep artifact you can
- only mark the task blocked if a real external dependency prevents meaningful progress

## Token discipline
- use this spec as the primary contract
- keep `result.md` compact
- do not paste long research dumps into `result.md`
- put the real synthesis into the required research files

## Required result contract
Before stopping, write `result.md` with:
- status: `done`, `partial`, or `blocked`
- truth changed classification
- changed files with one-line reasons
- validation performed
- substantive risks or follow-up cautions
- recommended next step
