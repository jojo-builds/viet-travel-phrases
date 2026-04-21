# Task Spec: T-016

## Title
Desktop Codex automation pilot, Viet audio continuity benchmark evidence pack and orphan cleanup recommendation

## Objective
Create a durable audio-review evidence pack for the current Viet app seam so later release decisions can stay honest about continuity quality and the 2 ignored legacy orphan MP3s. This task should not regenerate audio or silently change runtime mapping.

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
- docs/PRIORITIES.md
- docs/V2_BASELINE.md
- docs/V2_CONTENT_MODEL.md
- content-draft/viet/README.md
- content-draft/viet/phrase-source.csv
- app/family/packs/viet.generated.ts
- app/assets/audio/** as needed for bounded verification

## Task type
- audit
- evidence pack
- audio seam review

## Scope
### Allowed write scopes
- .agent/tasks/T-016/**
- .agent/coordination/locks.yaml
- .agent/coordination/queue-index.json
- content-draft/viet/audio-review/**

### Allowed read scopes
- docs/**
- content-draft/viet/**
- app/assets/audio/**
- app/family/packs/**

### Must not touch
- app/assets/audio/** as a destructive write surface
- app/family/** as a write surface
- site/**
- ops/**
- docs/operations/**
- release/build/TestFlight files

## Source-of-truth notes
- Current repo truth already says Viet audio is artifact-complete but continuity claims should stay cautious.
- This task should strengthen the evidence, not overstate quality.
- Do not silently alter live audio mapping or runtime behavior here.

## Required outputs
Create these files:
- content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md
- content-draft/viet/audio-review/ORPHAN-ASSET-AUDIT.md
- content-draft/viet/audio-review/RELEASE-POSTURE-RECOMMENDATION.md
- .agent/tasks/T-016/result.md
- exactly 4 review artifacts for each required review gate under .agent/tasks/T-016/reviews/

## Concrete execution requirement
This task is not done unless it leaves behind a sharper, more evidence-based audio posture than before, including a direct recommendation for how to talk about continuity risk and what to do about the ignored orphan files.

## Mandatory 3-review-gate workflow
Each meaningful task must be substantial enough to justify 3 separate review gates. Do not treat a smaller task as complete under this contract.
Use the same 4 Codex subagent review roles in every gate:
1. 01-audio-evidence-review.md
2. 02-runtime-honesty-review.md
3. 03-release-posture-review.md
4. 04-contract-scope-review.md

Gate 1, scope and plan gate
- run before substantial edits
- use the 4 subagents to challenge the audit path, evidence standard, and honesty posture
- do not start the main execution phase until all 4 subagents explicitly agree the task is ready to proceed

Gate 2, working-output gate
- run after the main evidence pack is drafted
- use the 4 subagents to challenge continuity claims, orphan-file reasoning, and whether the recommendation is honest enough for release use
- if any subagent withholds approval, revise the work and rerun Gate 2 until all 4 subagents explicitly agree the task is ready for finalization

Gate 3, completion gate
- run before marking the task done
- use the 4 subagents to challenge contract compliance, evidence sufficiency, and whether the pack is materially more useful than before
- do not mark the task done unless all 4 subagents explicitly agree the task is ready to complete

Loop rule for every gate
- each gate must use exactly 4 Codex subagents
- save each pass under .agent/tasks/T-016/reviews/gate-01-pass-01/, gate-02-pass-01/, or gate-03-pass-01/ style folders for this task
- if any subagent does not approve advancement, revise the task and rerun the same gate instead of advancing anyway
- the task must not complete unless all 3 gates eventually pass with unanimous 4-subagent approval

## Required checks
- verify every required output file physically exists
- verify no runtime mapping or app pack files were modified
- verify the evidence pack explicitly addresses continuity posture and orphan-file disposition
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under .agent/tasks/T-016/reviews/
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
The task is done only if all of these are true:
- Viet audio posture is documented more honestly and concretely than before
- the orphan-file question has a bounded recommendation instead of vague hand-waving
- all 3 mandatory review gates passed, the latest pass of each gate contains exactly 4 subagent review artifacts, and all 4 subagents agreed before advancement or completion
- substantive findings were handled
- .agent/tasks/T-016/result.md states what changed, what was verified, what remains open, and whether the objective was fully met

## Required result contract
Before stopping, write .agent/tasks/T-016/result.md with:
- status: done, partial, or blocked
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step


