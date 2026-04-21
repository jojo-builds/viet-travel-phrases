# Task Spec: T-028

## Title
Desktop Codex automation pilot, Turkey second first-wave translation pass and unresolved-row reduction

## Objective
Build on the completed Turkey first-wave translation pass by clearing the remaining unresolved high-value first-wave rows, then continuing directly into the next highest-value traveler rows so the lane leaves behind a materially larger chunk of prep-ready Turkish authoring truth instead of another tiny follow-up pass.

This is still prep-only work. Do not wire turkish into the runtime app.

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
- content-draft/turkish/README.md
- content-draft/turkish/source-notes.md
- content-draft/turkish/phrase-source.csv
- content-draft/turkish/first-wave-priority.csv
- content-draft/turkish/research-backlog.md
- research/language-pipeline/turkish/TURKEY-TRAVEL-RESEARCH.md
- .agent/tasks/T-012/result.md

## Task type
- translation
- prep-only authoring
- bounded second-wave first-wave execution

## Scope
### Allowed write scopes
- .agent/tasks/T-028/**
- .agent/coordination/queue-index.json
- content-draft/turkish/**

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
- This task is successful only if the Turkey lane leaves with materially stronger first-wave coverage than after T-012.
- Prefer unresolved high-value rows and rows still marked pending-next-pass before expanding into lower-priority work.
- Rewrite weak baseline English source before literal translation when needed.
- This task changes prep-only authoring truth, not runtime truth.

## Required outputs
Create or update these files:
- content-draft/turkish/phrase-source.csv
- content-draft/turkish/first-wave-priority.csv
- content-draft/turkish/source-notes.md
- content-draft/turkish/research-backlog.md
- .agent/tasks/T-028/result.md
- exactly 4 review artifacts under .agent/tasks/T-028/reviews/

## Concrete execution requirement
This task is not done unless it leaves visible large-batch progress behind.
For this task, that means:
- clear the currently unresolved high-value first-wave rows before expanding into lower-priority work
- then continue into the next highest-value traveler rows from `content-draft/turkish/phrase-source.csv` until at least `24` additional rows total were translated, materially upgraded, or consciously deferred with explicit reasons
- if quality is holding and the remaining bounded batch is still coherent, prefer finishing closer to `24-40` row outcomes rather than stopping at the floor
- `phrase-source.csv` has materially stronger `target_text`, `pronunciation`, `notes`, and `status` coverage than it had after `T-012`
- `first-wave-priority.csv` reflects which unresolved rows were cleared, which remain blocked, and what the next bounded pass should target

## What the task must decide
- which unresolved Turkish first-wave rows can now be fully cleared in this pass
- which next-highest-value post-first-wave traveler rows should be pulled forward immediately once the unresolved first-wave set is exhausted
- which rows still need rewrite, expert review, or later localization decisions
- whether any prior provisional pronunciation or phrasing notes should be tightened for honesty
- what the immediate next Turkish pass should do after this larger translation wave

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. 01-traveler-utility-review.md
2. 02-turkish-language-risk-review.md
3. 03-authoring-readiness-review.md
4. 04-contract-scope-review.md

Gate 1 before edits, Gate 2 after the main pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/turkish/phrase-source.csv` still parses as CSV after edits
- verify `content-draft/turkish/first-wave-priority.csv` still exists and remains non-empty
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under `.agent/tasks/T-028/reviews/`
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**` or runtime-wiring files were changed
- verify the unresolved high-value first-wave rows were cleared or consciously reclassified with explicit reasons
- verify at least `24` total additional rows were explicitly translated, materially improved, or consciously deferred with updated reasons unless the bounded high-value candidate set was fully exhausted and that exhaustion is proven in `result.md`

## Definition of done
- the turkish lane has materially stronger first-wave and immediate next-wave translation coverage than before this task
- unresolved high-value first-wave rows were cleared, not merely reduced, unless a surviving holdout is explicitly justified
- the lane advanced by at least `24` total row outcomes or proved that the bounded high-value candidate set was fully exhausted
- the next lane pass can start from a meaningfully smaller unresolved set without another broad orientation loop
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved and runtime wiring is untouched
- `.agent/tasks/T-028/result.md` states what changed, what was verified, what remains open, and whether the objective was fully met

## Required result contract
Before stopping, write .agent/tasks/T-028/result.md with:
- status: done, partial, or blocked
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step
