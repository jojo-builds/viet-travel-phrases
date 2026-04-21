# Task Spec: T-023

## Title
Desktop Codex automation pilot, Viet purchase-surface honesty and small-screen shell audit

## Objective
Audit the current Viet app-shell purchase and locked-state surfaces with extra attention to small-screen clarity, honest upgrade framing, and purchase/restore guidance, then apply only bounded Viet-shell fixes if repo truth shows a real problem.

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
- docs/operations/CURRENT_BLOCKERS.md
- app/family/** Viet-specific shell and premium surfaces
- content-draft/viet/** where needed for count/truth references

## Task type
- bounded app-shell audit
- Viet-specific UX honesty hardening
- small-screen clarity pass

## Scope
### Allowed write scopes
- .agent/tasks/T-023/**
- .agent/coordination/queue-index.json
- app/family/** within Viet-shell and purchase-surface scope
- docs/operations/** for honest validation notes tied to the audit

### Allowed read scopes
- docs/**
- ops/**
- content-draft/viet/**

### Must not touch
- site/**
- release/build/TestFlight files as generated artifacts
- unrelated task folders outside .agent/tasks/T-023/**
- broad shared-search work that belongs in ios_family_shared_ui

## Source-of-truth notes
- Keep this task Viet-specific, not a whole-family shell rewrite.
- Do not claim physical device proof from repo inspection.
- Prefer bounded copy/layout/state-truth improvements over speculative redesign.

## Required outputs
Create or update these files:
- app/family/** within the bounded Viet-shell purchase/locked-state scope if a real fix is justified
- docs/operations/LATEST_VALIDATION.md
- .agent/tasks/T-023/logs/shell-audit.md
- .agent/tasks/T-023/result.md
- exactly 4 review artifacts for each required review gate under .agent/tasks/T-023/reviews/

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. 01-purchase-honesty-review.md
2. 02-small-screen-clarity-review.md
3. 03-viet-shell-scope-review.md
4. 04-contract-scope-review.md

Gate 1 before edits, Gate 2 after the audit/fix pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify shell-audit artifact exists
- run the smallest relevant validation/test commands for any touched app-family files and capture them in the result
- verify latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify scope stayed bounded to the Viet-shell purchase/locked-state area plus honest ops notes

## Definition of done
- Viet purchase/locked-state shell truth is either improved or more honestly documented in a bounded way
- required outputs exist
- all 3 review gates passed with unanimous 4-subagent approval
- task state and result artifact agree on completion status

## Required result contract
Before stopping, write .agent/tasks/T-023/result.md with the standard task result shape.
