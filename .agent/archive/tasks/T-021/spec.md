# Task Spec: T-021

## Title
Desktop Codex automation pilot, Tagalog v2 shortlist rewrite and authoring-ready source pass

## Objective
Turn the current Tagalog v2 shortlist and risk-review work into a stronger authoring-ready prep surface by rewriting weak source lines, tightening confidence notes, and leaving behind a bounded source pack that the next Tagalog translation pass can use directly.

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
- docs/LANGUAGE_PREP_WORKFLOW.md
- content-draft/tagalog/README.md
- content-draft/tagalog/source-notes.md
- content-draft/tagalog/scenario-plan.json
- content-draft/tagalog/first-wave-priority.csv
- content-draft/tagalog/risk-review.md
- content-draft/viet/README.md

## Task type
- prep-only authoring refinement
- source rewrite
- readiness hardening

## Scope
### Allowed write scopes
- .agent/tasks/T-021/**
- .agent/coordination/queue-index.json
- content-draft/tagalog/**

### Allowed read scopes
- docs/**
- templates/**
- research/**
- content-draft/viet/**
- content-draft/thai/**
- content-draft/japanese/**
- app/family/**

### Must not touch
- app/**
- site/**
- ops/**
- docs/operations/**
- runtime registry wiring
- audio asset generation or mapping files outside draft notes
- release/build/TestFlight files
- unrelated edits under other language lanes

## Source-of-truth notes
- This is prep-only Tagalog v2 strengthening, not runtime promotion.
- Keep the current runtime Tagalog pack honest while building a better next authoring surface under content-draft/tagalog/**.
- Favor bounded, traveler-first rewrites over broad planning.
- Leave behind durable notes that make the next translation/authoring lane easier.

## Required outputs
Create or update these files:
- content-draft/tagalog/README.md
- content-draft/tagalog/source-notes.md
- content-draft/tagalog/first-wave-priority.csv
- content-draft/tagalog/rewrite-notes.md
- .agent/tasks/T-021/result.md
- exactly 4 review artifacts for each required review gate under .agent/tasks/T-021/reviews/

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. 01-traveler-utility-review.md
2. 02-language-risk-review.md
3. 03-authoring-scaffold-review.md
4. 04-contract-scope-review.md

Gate 1 before substantial edits.
Gate 2 after the rewrite/source-hardening pass.
Gate 3 before marking the task done.

Each gate must loop until all 4 subagents explicitly approve advancement, and the task must not be marked done unless all 3 gates pass unanimously.

## Required checks
- verify required output files exist
- verify CSV shape stays parseable
- verify rewrites stay prep-only and do not claim runtime graduation
- verify latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no app or site files were changed

## Definition of done
- Tagalog v2 now has a more authoring-ready bounded source surface, not just a shortlist plus broad risk notes
- required files exist and are internally consistent
- prep-only boundary remains explicit
- all 3 review gates passed with unanimous 4-subagent approval
- task state and result artifact agree on completion status

## Required result contract
Before stopping, write .agent/tasks/T-021/result.md with the standard task result shape.
