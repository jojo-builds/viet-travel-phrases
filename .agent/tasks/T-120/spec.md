# Task Spec: T-120

## Title
Desktop Codex automation pilot, Spain residual handoff and graduation-boundary packet

## Objective
Take the post-`T-095` Spain lane and turn the remaining small-tail story into one sharper graduation-boundary packet. Resolve the explicit residual choices for the social, pharmacy-adjacent, rewrite-needed, and later-review rows without reopening a broad translation sweep.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-095/result.md`
- `content-draft/spanish/README.md`
- `content-draft/spanish/source-notes.md`
- `content-draft/spanish/phrase-source.csv`
- `content-draft/spanish/first-wave-priority.csv`
- `content-draft/spanish/research-backlog.md`

## Task type
- residual-handoff packet
- graduation-boundary hardening
- Spain prep-lane closeout

## Scope
### Allowed write scopes
- `.agent/tasks/T-120/**`
- `content-draft/spanish/**`

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
- `T-095` already validated the pronunciation-normalization posture and narrowed the Spain lane to a bounded residual set.
- This smaller residual set is allowed because the remaining useful work is genuinely small, but the task still needs to leave a stronger handoff packet rather than a few isolated row edits.
- Stay prep-only and keep Spain-fit caution visible on culturally weak, medical, and rewrite-needed rows.

## Required outputs
Create or update these files:
- `content-draft/spanish/README.md`
- `content-draft/spanish/source-notes.md`
- `content-draft/spanish/phrase-source.csv`
- `content-draft/spanish/first-wave-priority.csv`
- `content-draft/spanish/research-backlog.md`
- `.agent/tasks/T-120/logs/spanish-graduation-packet.md`
- `.agent/tasks/T-120/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-120/reviews/` for each required gate

## Concrete requirement
- adjudicate the remaining residual Spain rows into explicit promote, later-only, native-review-only, rewrite-needed, or retire outcomes with clear reasons
- make all Spain lane docs agree on what is effectively complete versus what should remain unpromoted
- leave one graduation-boundary packet that future planning can read without reopening `T-095`
- keep the result meaningful through better lane-level handoff structure, not just scattered CSV edits

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-spain-fit-risk-review.md`
3. `03-graduation-readiness-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/spanish/phrase-source.csv` and `content-draft/spanish/first-wave-priority.csv` still parse after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or `ops/**` files changed

## Definition of done
- the Spain lane no longer has an ambiguous residual handoff
- future planning can judge graduation posture from one compact packet
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
