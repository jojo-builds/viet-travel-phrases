# Task Spec: T-119

## Title
Desktop Codex automation pilot, France residual handoff and graduation-boundary packet

## Objective
Take the post-`T-105` French lane and convert the remaining residual story into one sharper graduation-boundary packet. Resolve the explicit residual choices for the six later-social rows, the native-review row, and the rewrite-needed row without turning this into another broad translation batch.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-105/result.md`
- `content-draft/french/README.md`
- `content-draft/french/source-notes.md`
- `content-draft/french/phrase-source.csv`
- `content-draft/french/first-wave-priority.csv`
- `content-draft/french/research-backlog.md`

## Task type
- residual-handoff packet
- graduation-boundary hardening
- France prep-lane closeout

## Scope
### Allowed write scopes
- `.agent/tasks/T-119/**`
- `content-draft/french/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**`
- `app/family/**` as read-only reference only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated language lanes except read-only comparison

## Source-of-truth notes
- `T-105` already translated rank `31` through `62` and left one bounded `8`-row residual handoff.
- This smaller set is allowed because the remaining useful set is genuinely bounded, but the output must still improve the lane-level handoff rather than just tweak a few rows.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/french/README.md`
- `content-draft/french/source-notes.md`
- `content-draft/french/phrase-source.csv`
- `content-draft/french/first-wave-priority.csv`
- `content-draft/french/research-backlog.md`
- `.agent/tasks/T-119/logs/french-residual-packet.md`
- `.agent/tasks/T-119/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-119/reviews/` for each required gate

## Concrete requirement
- adjudicate the remaining residual rows into explicit promote, later-only, native-review-only, rewrite-needed, or retire outcomes with clear reasons
- make all French lane docs agree on what is effectively complete versus what should remain unpromoted
- leave one graduation-boundary packet that future planning can read without reopening `T-105`
- keep the result meaningful through better handoff structure, not just isolated CSV edits

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-french-language-risk-review.md`
3. `03-graduation-readiness-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/french/phrase-source.csv` and `content-draft/french/first-wave-priority.csv` still parse after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or `ops/**` files changed

## Definition of done
- the France lane no longer has an ambiguous residual handoff
- future planning can judge graduation posture from one compact packet
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
