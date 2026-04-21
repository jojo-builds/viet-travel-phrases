# Task Spec: T-122

## Title
Desktop Codex automation pilot, Japan starter-handoff and graduation-boundary packet

## Objective
Take the post-`T-101` Japan lane and convert the current starter-slice and deferred-tail story into one sharper graduation-boundary packet. Resolve the remaining deferred, rewrite-needed, native-review, and later-only choices without reopening another broad translation pass, and leave one compact handoff future planning can retrieve directly.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-101/result.md`
- `content-draft/japanese/README.md`
- `content-draft/japanese/source-notes.md`
- `content-draft/japanese/phrase-source.csv`
- `content-draft/japanese/first-wave-priority.csv`
- `content-draft/japanese/research-backlog.md`

## Task type
- residual-handoff packet
- graduation-boundary hardening
- Japan prep-lane closeout

## Scope
### Allowed write scopes
- `.agent/tasks/T-122/**`
- `content-draft/japanese/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
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
- `T-101` already converted the raw unresolved queue into a bounded starter-slice and deferred-row story.
- This smaller residual packet is allowed because the remaining useful set is genuinely narrow, but the output still needs to leave a stronger retrieval packet rather than just restating the current tail.
- Stay prep-only and keep visible caution around medical, bargaining, and weak-fit social phrasing.

## Required outputs
Create or update these files:
- `content-draft/japanese/README.md`
- `content-draft/japanese/source-notes.md`
- `content-draft/japanese/phrase-source.csv`
- `content-draft/japanese/first-wave-priority.csv`
- `content-draft/japanese/research-backlog.md`
- `.agent/tasks/T-122/logs/japan-graduation-packet.md`
- `.agent/tasks/T-122/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-122/reviews/` for each required gate

## Concrete requirement
- adjudicate the remaining Japan residual rows into explicit promote, later-only, native-review-only, rewrite-needed, or retire outcomes with clear reasons
- make all Japan lane docs agree on the starter handoff, deferred boundary, and effective prep-lane completion posture
- leave one graduation-boundary packet that future planning can read without reopening `T-101`
- keep the result meaningful through better handoff structure, not just a tiny curation touch-up

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-japan-fit-risk-review.md`
3. `03-graduation-readiness-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/japanese/phrase-source.csv` and `content-draft/japanese/first-wave-priority.csv` still parse after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or `ops/**` files changed

## Definition of done
- the Japan lane no longer has an ambiguous residual handoff
- future planning can judge graduation posture from one compact packet
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
