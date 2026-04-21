# Task Spec: T-013

## Title
Desktop Codex automation pilot, Spain first-wave translation pass

## Objective
Turn the spanish lane from a ranked shortlist into real first-wave translation coverage.
This task should translate the strongest first-wave rows into the lane's phrase-source.csv, rewrite any weak baseline English source before literal translation, and leave the lane materially closer to a real prepared-next authoring pass.

This is still prep-only work. Do not wire spanish into the runtime app.

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
- content-draft/spanish/README.md
- content-draft/spanish/source-notes.md
- content-draft/spanish/phrase-source.csv
- content-draft/spanish/first-wave-priority.csv
- content-draft/spanish/research-backlog.md
- research/language-pipeline/spanish/SPAIN-TRAVEL-RESEARCH.md
- .agent/tasks/T-006/result.md

## Task type
- translation
- prep-only authoring
- bounded first-wave execution

## Scope
### Allowed write scopes
- .agent/tasks/T-013/**
- .agent/coordination/locks.yaml
- .agent/coordination/queue-index.json
- content-draft/spanish/**

### Allowed read scopes
- docs/**
- templates/**
- research/**
- content-draft/viet/**
- content-draft/tagalog/**
- content-draft/thai/**
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
- This task is successful only if the lane leaves with stronger first-wave translation coverage than before.
- Do not translate bad English source blindly. Rewrite flagged weak-fit rows before literal translation.
- Keep the destination-first SpeakLocal model and preserve honest risk flags on sensitive language.
- This task changes prep-only authoring truth, not runtime truth.

## Required outputs
Create or update these files:
- content-draft/spanish/phrase-source.csv
- content-draft/spanish/first-wave-priority.csv
- content-draft/spanish/source-notes.md
- content-draft/spanish/research-backlog.md
- .agent/tasks/T-013/result.md
- exactly 4 review artifacts under .agent/tasks/T-013/reviews/

## Concrete execution requirement
This task is not done unless it leaves visible first-wave translation progress behind.
For this task, that means:
- at least the top 20 first-wave rows are translated or consciously deferred with an explicit reason
- phrase-source.csv has stronger target_text, pronunciation, notes, and status coverage for the first wave
- first-wave-priority.csv reflects any rows that were improved, deferred, or kept flagged

## What the task must decide
- which first-wave rows are now strong enough for the next bounded authoring phase
- which rows still need rewrite, expert review, or later localization decisions
- how pronunciation guidance should be handled for the translated rows without pretending every uncertainty is solved
- what the immediate next pass should do after this translation wave

## Mandatory 3-review-gate workflow
Each meaningful task must be substantial enough to justify 3 separate review gates. Do not treat a smaller task as complete under this contract.
Use the same 4 Codex subagent review roles in every gate:
1. 01-traveler-utility-review.md
2. 02-language-risk-review.md
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
- save each pass under .agent/tasks/T-013/reviews/gate-01-pass-01/, gate-02-pass-01/, or gate-03-pass-01/ style folders for this task
- if any subagent does not approve advancement, revise the task and rerun the same gate instead of advancing anyway
- the task must not complete unless all 3 gates eventually pass with unanimous 4-subagent approval

## Required checks
- verify every required output file physically exists
- verify content-draft/spanish/phrase-source.csv still parses as CSV after edits
- verify content-draft/spanish/first-wave-priority.csv still exists and remains non-empty
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under .agent/tasks/T-013/reviews/
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no app/** or runtime-wiring files were changed
- verify at least 20 of the top 24 first-wave rows were explicitly translated, improved, or consciously deferred with updated reasons/flags

## Definition of done
The task is done only if all of these are true:
- the spanish lane has materially stronger first-wave translation coverage than before
- weak source rows were rewritten or honestly left flagged instead of being hand-waved through
- the next lane pass can start from this improved first wave without another broad orientation loop
- all 3 mandatory review gates passed, the latest pass of each gate contains exactly 4 subagent review artifacts, and all 4 subagents agreed before advancement or completion
- substantive findings were handled
- prep-only boundary is preserved and runtime wiring is untouched
- .agent/tasks/T-013/result.md states what changed, what was verified, what remains open, and whether the objective was fully met

## Required result contract
Before stopping, write .agent/tasks/T-013/result.md with:
- status: done, partial, or blocked
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step


