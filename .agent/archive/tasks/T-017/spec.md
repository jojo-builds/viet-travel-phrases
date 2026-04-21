# Task Spec: T-017

## Title
Desktop Codex automation pilot, Indonesia research and prep-only lane bootstrap

## Objective
Create the first prep-only Indonesia lane artifacts needed for future SpeakLocal phrase expansion without wiring Indonesia into the runtime app.
The task should leave behind durable research and draft-lane files that make later phrase-authoring work easier.

## Repo / Working Surface
- repo root: E:\AI\SpeakLocal-App-Family
- working cwd: E:\AI\SpeakLocal-App-Family

## Read first
- AGENTS.md
- .agent/README.md
- .agent/QUEUE_START.md
- .agent/AUTOMATION.md
- .agent/coordination/queue-index.json
- .agent/coordination/locks.yaml
- docs/LANGUAGE_PREP_WORKFLOW.md
- docs/V2_CONTENT_MODEL.md
- docs/PRIORITIES.md
- templates/FAMILY_TRAVELER_BASELINE.json
- content-draft/tagalog/README.md
- content-draft/tagalog/source-notes.md
- content-draft/tagalog/scenario-plan.json
- content-draft/viet/README.md
- research/exec-summary.md
- research/competitor-pain-analysis-2026-04-01.md

## Task type
- research
- prep-only authoring bootstrap
- future-language lane setup

## Scope
### Allowed write scopes
- .agent/tasks/T-017/**
- .agent/coordination/locks.yaml
- .agent/coordination/queue-index.json
- research/language-pipeline/indonesian/**
- content-draft/indonesian/**

### Allowed read scopes
- docs/**
- templates/**
- research/**
- content-draft/tagalog/**
- content-draft/viet/**
- content-draft/thai/**
- content-draft/japanese/**
- content-draft/turkish/**
- content-draft/spanish/**
- content-draft/italian/**
- app/family/**

### Must not touch
- app/** as a write surface
- site/**
- ops/**
- docs/operations/**
- existing content-draft/viet/**
- existing content-draft/tagalog/**
- runtime registry wiring such as app/family/appRegistry.js or app/family/currentApp.ts
- release/build/TestFlight files

## Source-of-truth notes
- This is prep-only research, not runtime promotion.
- Keep Indonesia out of runtime wiring for now.
- Use the traveler-first, destination-first SpeakLocal model, not generic classroom language learning.
- Favor the shortest socially safe phrase as the likely default surface.
- The baseline shape should stay aligned with the shared 10-scenario traveler seam unless research shows a very strong Indonesia-specific reason to adjust wording or emphasis.
- Capture script, pronunciation, and search risks honestly.
- Treat this task as planning or prepared-next truth unless a file created here is clearly durable prep truth.

## Required outputs
Create these files:
- research/language-pipeline/indonesian/INDONESIA-TRAVEL-RESEARCH.md
- content-draft/indonesian/README.md
- content-draft/indonesian/source-notes.md
- content-draft/indonesian/scenario-plan.json
- content-draft/indonesian/research-backlog.md
- .agent/tasks/T-017/result.md
- exactly 4 review artifacts for each required review gate under .agent/tasks/T-017/reviews/

## What the research must cover
- destination framing: Indonesia / Indonesian
- traveler-use reality, not academic grammar ordering
- politeness model and when softer or more local variants matter
- script posture, romanization posture, and search posture for SpeakLocal surfaces
- likely high-value scenarios and whether the standard 10-scenario baseline is still the right skeleton
- likely-reply and repair-layer opportunities
- high-risk or confidence-sensitive phrase areas that should be reviewed carefully later
- concrete recommendation for what a future Indonesian starter pack should include first

## Mandatory 3-review-gate workflow
Each meaningful task must be substantial enough to justify 3 separate review gates. Do not treat a smaller task as complete under this contract.
Use the same 4 Codex subagent review roles in every gate:
1. 01-traveler-utility-review.md
2. 02-language-risk-review.md
3. 03-authoring-scaffold-review.md
4. 04-contract-scope-review.md

Gate 1, scope and plan gate
- run before substantial edits
- use the 4 subagents to challenge task framing, research plan, destination fit, and risk posture
- do not start the main execution phase until all 4 subagents explicitly agree the task is ready to proceed

Gate 2, working-output gate
- run after the main research and scaffold pass
- use the 4 subagents to challenge traveler utility, language-risk honesty, and whether the lane is genuinely easier to author next
- if any subagent withholds approval, revise the work and rerun Gate 2 until all 4 subagents explicitly agree the task is ready for finalization

Gate 3, completion gate
- run before marking the task done
- use the 4 subagents to challenge contract compliance, prep-only boundary, and whether the actual objective is met
- do not mark the task done unless all 4 subagents explicitly agree the task is ready to complete

Loop rule for every gate
- each gate must use exactly 4 Codex subagents
- save each pass under .agent/tasks/T-017/reviews/gate-01-pass-01/, gate-02-pass-01/, or gate-03-pass-01/ style folders for this task
- if any subagent does not approve advancement, revise the task and rerun the same gate instead of advancing anyway
- the task must not complete unless all 3 gates eventually pass with unanimous 4-subagent approval

## Required checks
- verify all required output files physically exist
- verify content-draft/indonesian/scenario-plan.json is valid JSON
- verify the scenario plan stays consistent with the shared traveler baseline or clearly explains any Indonesia-specific deviation in the notes
- verify no runtime app files were changed
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under .agent/tasks/T-017/reviews/
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
The task is done only if all of these are true:
- the required output files exist
- the indonesian lane is documented as prep-only
- the research is strong enough that a later phrase-authoring task can use it without redoing the whole orientation pass
- all 3 mandatory review gates passed, the latest pass of each gate contains exactly 4 subagent review artifacts, and all 4 subagents agreed before advancement or completion
- substantive findings were handled
- the task state and result artifact agree on completion status

## Required result contract
Before stopping, write .agent/tasks/T-017/result.md with:
- status: done, partial, or blocked
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step


