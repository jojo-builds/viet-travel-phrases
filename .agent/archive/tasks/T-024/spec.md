# Task Spec: T-024

## Title
Desktop Codex automation pilot, shared search normalization audit and bounded family-shell fix pass

## Objective
Audit the current Viet and Tagalog shared-search behavior in repo truth, identify bounded normalization or localization gaps that can be fixed safely inside the family shell, and leave behind a small verified fix pass plus honest device-proof notes for anything that still requires hardware validation.

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
- docs/LANGUAGE_PREP_WORKFLOW.md
- docs/operations/CURRENT_BLOCKERS.md
- docs/operations/LATEST_VALIDATION.md
- app/family/** search-related sources
- content-draft/viet/**
- content-draft/tagalog/**

## Task type
- bounded shared-shell audit
- implementation fix pass
- search-proof hardening

## Scope
### Allowed write scopes
- .agent/tasks/T-024/**
- .agent/coordination/queue-index.json
- app/family/**
- docs/operations/**

### Allowed read scopes
- docs/**
- ops/**
- content-draft/viet/**
- content-draft/tagalog/**
- content-draft/thai/**
- content-draft/japanese/**
- content-draft/turkish/**
- content-draft/spanish/**
- content-draft/italian/**

### Must not touch
- site/**
- release/build/TestFlight files
- unrelated research lanes outside search/shared-shell scope

## Source-of-truth notes
- Keep scope bounded to search normalization, shared-search copy, query handling, and evidence notes.
- Do not claim hardware proof from simulator/repo inspection alone.
- If no safe fix is needed, leave behind an honest audit artifact instead of forcing churn.

## Required outputs
Create or update these files:
- app/family/** within the bounded search scope if a real fix is justified
- docs/operations/LATEST_VALIDATION.md
- docs/operations/CURRENT_BLOCKERS.md
- .agent/tasks/T-024/logs/search-audit.md
- .agent/tasks/T-024/result.md
- exactly 4 review artifacts for each required review gate under .agent/tasks/T-024/reviews/

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. 01-search-utility-review.md
2. 02-localization-risk-review.md
3. 03-bounded-fix-review.md
4. 04-contract-scope-review.md

Gate 1 before edits, Gate 2 after the audit/fix pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify audit artifact exists
- run the smallest relevant validation/test commands for touched search/shared-shell surfaces and capture them in the result
- verify latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify scope stayed bounded to the family search/shared-shell area and docs/operations notes

## Definition of done
- shared-search truth is either improved or more honestly documented in a bounded way
- required outputs exist
- all 3 review gates passed with unanimous 4-subagent approval
- task state and result artifact agree on completion status

## Required result contract
Before stopping, write .agent/tasks/T-024/result.md with the standard task result shape.
