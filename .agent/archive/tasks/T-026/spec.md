# Task Spec: T-026

## Title
Desktop Codex automation pilot, Vietnam website starter export regression guardrail audit

## Objective
Add a bounded regression-focused audit around the Vietnam website starter export seam so future pack/export changes are easier to verify, without reopening the already-complete no-repair conclusion from T-015.

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
- docs/V2_CONTENT_MODEL.md
- site/data/phrase-previews/**
- site/public/data/phrase-previews/**
- content-draft/viet/website-preview.json
- .agent/tasks/T-015/result.md

## Task type
- export guardrail audit
- regression-hardening
- bounded website seam documentation

## Scope
### Allowed write scopes
- .agent/tasks/T-026/**
- .agent/coordination/queue-index.json
- site/data/phrase-previews/**
- site/public/data/phrase-previews/**
- docs/** within website-export truth only

### Allowed read scopes
- content-draft/viet/**
- app/family/packs/**
- site/**

### Must not touch
- app/** as a write surface
- ops/**
- docs/operations/**
- release/build/TestFlight files
- unrelated content-draft lanes

## Source-of-truth notes
- This is a guardrail task, not a broad website strategy pass.
- Preserve the current starter-on-web boundary.
- If no code/data change is warranted, leave behind a durable audit artifact and validation recipe instead of inventing churn.

## Required outputs
Create or update these files:
- .agent/tasks/T-026/logs/regression-audit.md
- .agent/tasks/T-026/result.md
- any bounded site/data/phrase-previews/** or site/public/data/phrase-previews/** artifacts only if a real guardrail improvement is justified
- exactly 4 review artifacts for each required review gate under .agent/tasks/T-026/reviews/

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. 01-export-regression-review.md
2. 02-starter-boundary-review.md
3. 03-guardrail-value-review.md
4. 04-contract-scope-review.md

Gate 1 before edits, Gate 2 after the audit/guardrail pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify regression audit artifact exists
- verify latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify any touched files stay inside the export seam and starter boundary

## Definition of done
- the website export seam is easier to re-verify after future changes, or the current limitation is more honestly documented
- required outputs exist
- all 3 review gates passed with unanimous 4-subagent approval
- task state and result artifact agree on completion status

## Required result contract
Before stopping, write .agent/tasks/T-026/result.md with the standard task result shape.
