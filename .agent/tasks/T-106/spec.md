# Task Spec: T-106

## Title
Desktop Codex automation pilot, Germany residual-review packet and release-posture closeout

## Objective
Turn the Germany lane's now-small residual set into one final honest handoff packet. Preserve any row that still needs native or expert review, tighten the release-posture notes around those rows, and leave the lane with a cleaner "done for now" posture instead of scattered residual caution.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-078/result.md`
- `.agent/tasks/T-084/result.md`
- `.agent/tasks/T-089/result.md`
- `docs/PRIORITIES.md`
- `content-draft/german/README.md`
- `content-draft/german/source-notes.md`
- `content-draft/german/phrase-source.csv`
- `content-draft/german/first-wave-priority.csv`
- `content-draft/german/research-backlog.md`

## Task type
- residual-tail closeout
- native-review handoff packet
- prep-lane truth cleanup

## Scope
### Allowed write scopes
- `.agent/tasks/T-106/**`
- `content-draft/german/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**`
- `app/family/**` for bounded product-shape reference only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes

## Source-of-truth notes
- Start from the post-`T-089` truth that Germany is mostly resolved and should not be padded with filler work.
- Prefer a sharper handoff packet and explicit residual posture over forcing more translations.
- Keep any service, transit, medical, register, or native-fit caution visible when evidence is still weak.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/german/README.md`
- `content-draft/german/source-notes.md`
- `content-draft/german/phrase-source.csv`
- `content-draft/german/first-wave-priority.csv`
- `content-draft/german/research-backlog.md`
- `.agent/tasks/T-106/logs/german-residual-review-packet.md`
- `.agent/tasks/T-106/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-106/reviews/` for each required gate

## Concrete requirement
- identify every Germany row or caution that still needs native, expert, or later-only review
- convert that residual set into one clean release-posture packet with exact dispositions instead of scattered notes
- leave the lane with a stronger "closed for now unless native review arrives" handoff than it has today

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-german-language-risk-review.md`
3. `03-handoff-integrity-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify required output files exist
- verify `content-draft/german/phrase-source.csv` and `content-draft/german/first-wave-priority.csv` still parse cleanly after edits
- verify no `app/**`, `site/**`, `ops/**`, or runtime-wiring files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Germany lane has one explicit residual-review packet and honest release posture
- remaining cautions are visible and intentionally deferred instead of implied resolved
- all 3 mandatory review gates passed with unanimous 4-subagent approval
