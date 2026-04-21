# Task Spec: T-121

## Title
Desktop Codex automation pilot, Turkey graduation-boundary and native-review closure packet

## Objective
Take the post-`T-104` Turkish lane and convert the remaining residual story into one sharper graduation-boundary packet. Resolve the final practical, rewrite-needed, and native-review holdouts without reopening another broad translation batch, and leave one compact closure packet that future planning can retrieve quickly.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-104/result.md`
- `content-draft/turkish/README.md`
- `content-draft/turkish/source-notes.md`
- `content-draft/turkish/phrase-source.csv`
- `content-draft/turkish/first-wave-priority.csv`
- `content-draft/turkish/research-backlog.md`

## Task type
- residual-handoff packet
- graduation-boundary hardening
- Turkey prep-lane closeout

## Scope
### Allowed write scopes
- `.agent/tasks/T-121/**`
- `content-draft/turkish/**`

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
- `T-104` already did the real residual-tail closure work and should have left only a bounded final handoff surface.
- This smaller residual packet is allowed because the remaining useful set is genuinely narrow, but the output still needs to improve lane-level retrieval and closure clarity rather than just move a couple rows around.
- Stay prep-only and keep visible caution around medical, bargaining, and weak-fit social wording.

## Required outputs
Create or update these files:
- `content-draft/turkish/README.md`
- `content-draft/turkish/source-notes.md`
- `content-draft/turkish/phrase-source.csv`
- `content-draft/turkish/first-wave-priority.csv`
- `content-draft/turkish/research-backlog.md`
- `.agent/tasks/T-121/logs/turkish-graduation-packet.md`
- `.agent/tasks/T-121/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-121/reviews/` for each required gate

## Concrete requirement
- adjudicate the remaining Turkish residual rows into explicit promote, later-only, native-review-only, rewrite-needed, or retire outcomes with clear reasons
- make all Turkish lane docs agree on what is effectively complete versus what should remain unpromoted
- leave one graduation-boundary packet that future planning can read without reopening `T-104`
- keep the result meaningful through better handoff structure, not just a tiny follow-up edit pass

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-turkey-fit-risk-review.md`
3. `03-graduation-readiness-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/turkish/phrase-source.csv` and `content-draft/turkish/first-wave-priority.csv` still parse after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or `ops/**` files changed

## Definition of done
- the Turkish lane no longer has an ambiguous residual handoff
- future planning can judge graduation posture from one compact packet
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
