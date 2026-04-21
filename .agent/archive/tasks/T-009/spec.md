# Task Spec: T-009

## Title
Desktop Codex automation pilot, Tagalog v2 first-wave rewrite and authoring pass

## Objective
Turn the new Tagalog first-wave shortlist into real next-authoring progress, not another planning loop.
This task should take the top first-wave Tagalog rows, rewrite any weak baseline English source where needed, and strengthen the corresponding Tagalog entries so the lane is materially closer to a real v2 authoring pass.

This task must stay inside prep and draft truth. Do not wire new Tagalog runtime behavior or edit app/**.

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
- docs/TAGALOG_COMPLETION_BRIEF.md
- templates/FAMILY_TRAVELER_BASELINE.json
- content-draft/tagalog/README.md
- content-draft/tagalog/source-notes.md
- content-draft/tagalog/phrase-source.csv
- content-draft/tagalog/first-wave-priority.csv
- content-draft/tagalog/risk-review.md
- .agent/tasks/T-008/result.md

## Task type
- rewrite
- prep-only authoring
- bounded translation refinement

## Scope
### Allowed write scopes
- .agent/tasks/T-009/**
- .agent/coordination/locks.yaml
- .agent/coordination/queue-index.json
- content-draft/tagalog/**

### Allowed read scopes
- docs/**
- templates/**
- research/**
- content-draft/viet/**
- content-draft/thai/**
- content-draft/japanese/**
- app/family/** for bounded reference only if needed to understand pack shape

### Must not touch
- app/** as a write surface
- site/**
- ops/**
- docs/operations/**
- runtime registry wiring such as app/family/appRegistry.js or app/family/currentApp.ts
- audio asset generation or mapping files
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- The current Tagalog lane already has drafted phrase rows, but they are not yet a confident v2 pass.
- This task is successful only if the next real Tagalog content pass becomes easier and safer.
- Rewrite weak source rows before polishing target text. Do not translate bad baseline English literally.
- Favor high-value traveler phrases and honest risk flags over fake completeness.

## Required outputs
Create or update these files:
- content-draft/tagalog/phrase-source.csv
- content-draft/tagalog/first-wave-priority.csv
- content-draft/tagalog/source-notes.md
- content-draft/tagalog/research-backlog.md
- content-draft/tagalog/risk-review.md
- .agent/tasks/T-009/result.md
- exactly 4 review artifacts under .agent/tasks/T-009/reviews/

## Concrete execution requirement
This task is not done unless it leaves the next Tagalog v2 pass materially easier.
For this task, that means:
- the top 20-24 shortlisted Tagalog rows were actively reviewed
- flagged weak baseline rows were rewritten before promotion attempts
- phrase-source.csv reflects stronger first-wave wording, notes, and pronunciation posture for those rows
- first-wave-priority.csv reflects any rows that were improved, deferred, or kept flagged

## What the task must decide
- which top first-wave rows are now strong enough to keep as the next Tagalog v2 authoring core
- which rows still need rewrite or expert review
- where mixed English, loanwords, register, or localized-destination phrasing still create risk
- what should happen next after this rewrite pass

## Mandatory 3-review-gate workflow
Each meaningful task must be substantial enough to justify 3 separate review gates. Do not treat a smaller task as complete under this contract.
Use the same 4 Codex subagent review roles in every gate:
1. 01-traveler-utility-review.md
2. 02-tagalog-language-risk-review.md
3. 03-authoring-readiness-review.md
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
- save each pass under .agent/tasks/T-009/reviews/gate-01-pass-01/, gate-02-pass-01/, or gate-03-pass-01/ style folders for this task
- if any subagent does not approve advancement, revise the task and rerun the same gate instead of advancing anyway
- the task must not complete unless all 3 gates eventually pass with unanimous 4-subagent approval

## Required checks
- verify every required output file physically exists
- verify content-draft/tagalog/phrase-source.csv still parses as CSV after edits
- verify content-draft/tagalog/first-wave-priority.csv still exists and remains non-empty
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under .agent/tasks/T-009/reviews/
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no app/** or runtime-wiring files were changed
- verify at least 20 of the top 24 first-wave rows were explicitly touched, improved, or consciously deferred with an updated reason/flag

## Definition of done
The task is done only if all of these are true:
- Tagalog prep truth is materially stronger than before
- the top first-wave rows are better than the inherited draft state
- weak rows were rewritten or honestly left flagged instead of being waved through
- the next Tagalog content task can start from this improved first wave without another broad planning pass
- all 3 mandatory review gates passed, the latest pass of each gate contains exactly 4 subagent review artifacts, and all 4 subagents agreed before advancement or completion
- substantive findings were handled
- prep-only boundary is preserved and runtime wiring is untouched
- .agent/tasks/T-009/result.md states what changed, what was verified, what remains open, and whether the objective was fully met

## Required result contract
Before stopping, write .agent/tasks/T-009/result.md with:
- status: done, partial, or blocked
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step


