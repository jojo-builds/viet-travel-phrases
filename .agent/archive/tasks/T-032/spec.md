# Task Spec: T-032

## Title
Desktop Codex automation pilot, Tagalog v2 first-wave translation pass

## Objective
Start the real Tagalog v2 translation lane from the newly tightened authoring-ready source pack, covering the full current first wave instead of another tiny sample. Leave the lane with a materially stronger prep-ready Tagalog source set for later runtime consideration, while preserving honest caution around sensitive rows and pronunciation.

This is prep-only work. Do not wire Tagalog into the runtime app.

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
- content-draft/tagalog/phrase-source.csv
- content-draft/tagalog/first-wave-priority.csv
- content-draft/tagalog/rewrite-notes.md
- .agent/tasks/T-021/result.md

## Scope
### Allowed write scopes
- .agent/tasks/T-032/**
- .agent/coordination/queue-index.json
- content-draft/tagalog/**

### Must not touch
- app/** as a write surface
- site/**
- ops/**
- docs/operations/**
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes

## Concrete execution requirement
- translate or consciously defer the full current `16` row first-wave core set
- preserve explicit holdout and deferred posture for riskier rows unless they can be upgraded honestly
- tighten pronunciation and notes only where confidence is real
- leave a clear next-pass recommendation for holdouts and deferred rows

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate and require unanimous approval before advancement.
