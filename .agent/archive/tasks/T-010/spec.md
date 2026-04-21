# Task Spec: T-010

## Title
Desktop Codex automation pilot, Thailand first-wave authoring scaffold completion

## Objective
Bring the Thai prep lane up to the same authoring-ready scaffold level as the stronger future-language lanes.
This task should take the existing Thai research/bootstrap lane and add the missing first authoring scaffold so the next Thai translation task can start immediately instead of redoing orientation work.

This is prep-only work. Do not wire Thai into the runtime app.

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
- research/language-pipeline/thai/THAI-TRAVEL-RESEARCH.md
- content-draft/thai/README.md
- content-draft/thai/source-notes.md
- content-draft/thai/scenario-plan.json
- content-draft/thai/research-backlog.md
- .agent/tasks/T-003/result.md

## Task type
- research synthesis
- planning
- scaffold completion

## Scope
### Allowed write scopes
- .agent/tasks/T-010/**
- .agent/coordination/locks.yaml
- .agent/coordination/queue-index.json
- research/language-pipeline/thai/**
- content-draft/thai/**

### Allowed read scopes
- docs/**
- templates/**
- research/**
- content-draft/viet/**
- content-draft/tagalog/**
- content-draft/japanese/**
- content-draft/turkish/**
- content-draft/spanish/**
- content-draft/italian/**
- app/family/** for bounded reference only if needed to understand pack shape

### Must not touch
- app/** as a write surface
- site/**
- ops/**
- docs/operations/**
- runtime registry wiring such as app/family/appRegistry.js or app/family/currentApp.ts
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- Thai now has durable research, but it still lacks the concrete shortlist scaffolding that the other stronger future lanes gained.
- This task is successful only if Thai becomes immediately ready for the next translation task.
- Thai script, pronunciation, and audio posture still need honest caution. Do not pretend those are solved.

## Required outputs
Create or update these files:
- content-draft/thai/README.md
- content-draft/thai/source-notes.md
- content-draft/thai/scenario-plan.json only if better Thai-specific priorities are justified
- content-draft/thai/phrase-source.csv
- content-draft/thai/first-wave-priority.csv
- content-draft/thai/research-backlog.md
- .agent/tasks/T-010/result.md
- exactly 4 review artifacts under .agent/tasks/T-010/reviews/

## Concrete scaffold requirement
This task is not done unless it leaves both of these behind:
- a reusable phrase-source.csv scaffold for the Thai lane
- a ranked first-wave-priority.csv that tells the next translation task exactly where to start

That shortlist must include at minimum:
- rank
- scenario_id
- phrase_id
- english_text
- priority_reason
- confidence
- review_flag

## What the task must cover
- the first Thai starter-pack priorities inside the shared 10-scenario seam
- script and pronunciation posture for English-speaking travelers
- how the next translation pass should treat tone and romanization risk
- which sensitive Thai rows need expert review later
- how to keep the lane prep-only while still making it genuinely actionable

## Mandatory 3-review-gate workflow
Each meaningful task must be substantial enough to justify 3 separate review gates. Do not treat a smaller task as complete under this contract.
Use the same 4 Codex subagent review roles in every gate:
1. 01-traveler-utility-review.md
2. 02-thai-language-risk-review.md
3. 03-authoring-scaffold-review.md
4. 04-contract-scope-review.md

Gate 1, scope and plan gate
- run before substantial edits
- use the 4 subagents to challenge task framing, scope discipline, risk posture, and the planned approach
- do not start the main execution phase until all 4 subagents explicitly agree the task is ready to proceed

Gate 2, working-output gate
- run after the main working draft or artifact pass
- use the 4 subagents to challenge quality, correctness, language risk, usefulness, and whether the work is genuinely stronger than before
- if any subagent withholds approval, revise the work and rerun Gate 2 until all 4 subagents explicitly agree the task is ready for finalization

Gate 3, completion gate
- run before marking the task done
- use the 4 subagents to challenge contract compliance, final quality, validation honesty, and whether the actual objective is met
- do not mark the task done unless all 4 subagents explicitly agree the task is ready to complete

Loop rule for every gate
- each gate must use exactly 4 Codex subagents
- save each pass under .agent/tasks/T-010/reviews/gate-01-pass-01/, gate-02-pass-01/, or gate-03-pass-01/ style folders for this task
- if any subagent does not approve advancement, revise the task and rerun the same gate instead of advancing anyway
- the task must not complete unless all 3 gates eventually pass with unanimous 4-subagent approval

## Required checks
- verify every required output file physically exists
- verify content-draft/thai/phrase-source.csv exists and is non-empty
- verify content-draft/thai/first-wave-priority.csv exists and is non-empty
- verify content-draft/thai/scenario-plan.json parses if touched
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under .agent/tasks/T-010/reviews/
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no app/** or runtime-wiring files were changed
- verify the Thai lane is more authoring-ready than before by checking that the next translation task could start from the new files without another orientation pass

## Definition of done
The task is done only if all of these are true:
- Thai prep truth is materially stronger than before
- the lane now has a real first-wave authoring scaffold
- the shortlist is concrete, ranked, and useful
- all 3 mandatory review gates passed, the latest pass of each gate contains exactly 4 subagent review artifacts, and all 4 subagents agreed before advancement or completion
- substantive findings were handled
- prep-only boundary is preserved and runtime wiring is untouched
- .agent/tasks/T-010/result.md states what changed, what was verified, what remains open, and whether the objective was fully met

## Required result contract
Before stopping, write .agent/tasks/T-010/result.md with:
- status: done, partial, or blocked
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step


