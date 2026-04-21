# Task Spec: T-095

## Title
Desktop Codex automation pilot, Spain pronunciation-rule validation and small-tail triage pass

## Objective
Tighten the Spain prep lane by validating that the current pronunciation-normalization posture still holds on the latest draft set, then use that pass to triage the remaining small social and pharmacy-adjacent tail into explicit next, later-review, or deferred buckets.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-006/result.md`
- `.agent/tasks/T-013/result.md`
- `content-draft/spanish/README.md`
- `content-draft/spanish/source-notes.md`
- `content-draft/spanish/phrase-source.csv`
- `content-draft/spanish/first-wave-priority.csv`
- `content-draft/spanish/research-backlog.md`

## Task type
- prep-lane quality hardening
- pronunciation-rule validation
- residual-tail triage

## Scope
### Allowed write scopes
- `.agent/tasks/T-095/**`
- `content-draft/spanish/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**`
- `content-draft/thai/**`
- `content-draft/japanese/**`
- `content-draft/turkish/**`
- `content-draft/italian/**`
- `app/family/**`

### Must not touch
- `app/**`
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes

## Source-of-truth notes
- Keep the lane prep-only. Do not imply runtime readiness.
- Preserve Spain-focused traveler Spanish rather than generic all-market wording.
- Treat bargaining, medical, and culturally weak rows as explicit review decisions, not quota-filling translations.
- The remaining live tail may be smaller than the usual `24`-row floor, so a smaller batch is acceptable only if the actual bounded high-value set is smaller and the residual ledger becomes clearer.

## Required outputs
Create or update these files:
- `content-draft/spanish/README.md`
- `content-draft/spanish/source-notes.md`
- `content-draft/spanish/phrase-source.csv`
- `content-draft/spanish/first-wave-priority.csv`
- `content-draft/spanish/research-backlog.md`
- `.agent/tasks/T-095/logs/spanish-tail-audit.md`
- `.agent/tasks/T-095/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-095/reviews/` for each required gate

## Concrete requirement
- validate the pronunciation-normalization posture against the currently drafted Spain lane
- triage the remaining small-talk and pharmacy-adjacent tail into explicit next, later-review, or deferred buckets with honest reasons
- leave the lane with a cleaner residual contract so a future worker does not need to rediscover the same tail decisions

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-translation-quality-review.md`
2. `02-spain-fit-review.md`
3. `03-tail-ledger-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify the changed Spanish CSV surfaces still parse cleanly
- verify no app, site, ops, or unrelated language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Spain lane has a clearer pronunciation-rule stance and a cleaner residual-tail contract than before
- every changed surface stays inside `content-draft/spanish/**` plus task artifacts
- the next Spain worker can pick up from an explicit narrowed tail instead of broad re-triage
- all 3 mandatory review gates passed with unanimous 4-subagent approval
