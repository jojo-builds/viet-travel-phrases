# Task Spec: T-015

## Title
Desktop Codex automation pilot, website starter export seam integrity audit and repair

## Objective
Audit the website starter export seam against current repo truth, repair bounded integrity problems if a safe fix exists, and leave the export surface materially more trustworthy without drifting into a major website redesign.

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
- content-draft/viet/website-preview.json
- site/data/phrase-previews/manifest.json
- site/public/data/phrase-previews/manifest.json
- relevant files under site/data/phrase-previews/
- relevant files under site/public/data/phrase-previews/

## Task type
- audit
- bounded repair
- website export seam integrity

## Scope
### Allowed write scopes
- .agent/tasks/T-015/**
- .agent/coordination/locks.yaml
- .agent/coordination/queue-index.json
- site/data/phrase-previews/**
- site/public/data/phrase-previews/**

### Allowed read scopes
- docs/**
- content-draft/viet/**
- site/**
- app/family/packs/**

### Must not touch
- app/** as a write surface
- ops/**
- docs/operations/**
- broad website strategy docs
- unrelated website conversion copy
- release/build/TestFlight files

## Source-of-truth notes
- This task is about website export seam integrity, not a broader website strategy reset.
- Keep the website tied to current starter/default-first app truth.
- If the seam is already clean, prove that honestly and stop.

## Required outputs
Create or update these files if needed:
- site/data/phrase-previews/manifest.json
- site/public/data/phrase-previews/manifest.json
- .agent/tasks/T-015/result.md
- exactly 4 review artifacts for each required review gate under .agent/tasks/T-015/reviews/

## Concrete execution requirement
This task is not done unless it either repairs a real export-seam integrity problem or leaves behind convincing evidence that the seam is already sound.

## Mandatory 3-review-gate workflow
Each meaningful task must be substantial enough to justify 3 separate review gates. Do not treat a smaller task as complete under this contract.
Use the same 4 Codex subagent review roles in every gate:
1. 01-export-integrity-review.md
2. 02-starter-truth-review.md
3. 03-website-seam-risk-review.md
4. 04-contract-scope-review.md

Gate 1, scope and plan gate
- run before substantial edits
- use the 4 subagents to challenge task framing, export-seam risk, and whether the planned audit path is bounded and worthwhile
- do not start the main execution phase until all 4 subagents explicitly agree the task is ready to proceed

Gate 2, working-output gate
- run after the main audit or repair pass
- use the 4 subagents to challenge manifest integrity, starter-truth alignment, and whether any repair is actually safe
- if any subagent withholds approval, revise the work and rerun Gate 2 until all 4 subagents explicitly agree the task is ready for finalization

Gate 3, completion gate
- run before marking the task done
- use the 4 subagents to challenge contract compliance, validation honesty, and whether the export seam is actually cleaner or honestly proven clean
- do not mark the task done unless all 4 subagents explicitly agree the task is ready to complete

Loop rule for every gate
- each gate must use exactly 4 Codex subagents
- save each pass under .agent/tasks/T-015/reviews/gate-01-pass-01/, gate-02-pass-01/, or gate-03-pass-01/ style folders for this task
- if any subagent does not approve advancement, revise the task and rerun the same gate instead of advancing anyway
- the task must not complete unless all 3 gates eventually pass with unanimous 4-subagent approval

## Required checks
- verify all claimed manifest and payload files physically exist
- verify site/data and site/public manifest surfaces are in sync after any repair
- verify no app/** write changes happened
- verify no unrelated website copy changes happened
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under .agent/tasks/T-015/reviews/
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
The task is done only if all of these are true:
- the website starter export seam is materially cleaner than before, or honestly proven already clean
- any fix stayed tightly inside the export seam
- all 3 mandatory review gates passed, the latest pass of each gate contains exactly 4 subagent review artifacts, and all 4 subagents agreed before advancement or completion
- substantive findings were handled
- .agent/tasks/T-015/result.md states what changed, what was verified, what remains open, and whether the objective was fully met

## Required result contract
Before stopping, write .agent/tasks/T-015/result.md with:
- status: done, partial, or blocked
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step


