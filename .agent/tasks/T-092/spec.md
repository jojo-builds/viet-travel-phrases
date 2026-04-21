# Task Spec: T-092

## Title
Desktop Codex automation pilot, Viet audio continuity ledger refresh and next-batch allowlist hardening

## Objective
Refresh the Viet audio truth so the continuity benchmark, release-posture guidance, and next-batch allowlist all agree on the current repo evidence after the recent controlled follow-up batch. Leave a sharper next-batch ledger without broad regeneration.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-016/result.md`
- `.agent/tasks/T-074/result.md`
- `.agent/tasks/T-083/result.md`
- `content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md`
- `content-draft/viet/audio-review/FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md`
- `content-draft/viet/audio-review/ORPHAN-ASSET-AUDIT.md`
- `content-draft/viet/audio-review/RELEASE-POSTURE-RECOMMENDATION.md`
- `app/family/packs/**` only as needed for bounded row checks
- `app/assets/audio/**` only as needed for bounded asset/mapping checks

## Task type
- bounded audio truth sync
- allowlist hardening
- continuity-ledger refresh

## Scope
### Allowed write scopes
- `.agent/tasks/T-092/**`
- `content-draft/viet/audio-review/**`
- `docs/operations/**`
- `app/family/packs/**` only if a narrowly justified mapping-truth fix is required

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `app/**`
- `ops/**`

### Must not touch
- `site/**`
- unrelated language lanes
- release/build/TestFlight files
- broad audio regeneration or mass asset replacement
- app shell surfaces outside bounded audio/mapping truth

## Source-of-truth notes
- This is a ledger-hardening task, not a broad synthesis lane.
- Keep continuity posture honest. If evidence still supports caution language, preserve it.
- Favor a cleaner allowlist and clearer next-batch guidance over touching large numbers of runtime assets.
- If mapping truth is already correct, update the review docs and logs instead of forcing code churn.

## Required outputs
Create or update these files:
- `content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md`
- `content-draft/viet/audio-review/FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md`
- `content-draft/viet/audio-review/RELEASE-POSTURE-RECOMMENDATION.md`
- `.agent/tasks/T-092/logs/audio-ledger-refresh.md`
- `.agent/tasks/T-092/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-092/reviews/` for each required gate

## Concrete requirement
- reconcile the current continuity benchmark, release posture, and follow-up allowlist against the latest controlled batch evidence
- leave behind a bounded next-batch recommendation that is specific enough for a future worker to act on without redoing orientation
- if a mapping-truth defect is found, either fix the bounded defect or document the exact blocker with evidence

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-audio-utility-review.md`
2. `02-continuity-risk-review.md`
3. `03-allowlist-ledger-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify any touched allowlist rows or mapping references still match on-disk app/audio truth
- verify no unrelated website or non-Viet language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Viet audio evidence surfaces agree on current continuity posture and next-batch guidance
- any repo changes stay bounded to audio-truth surfaces or a narrowly justified mapping fix
- the next worker can act from the updated allowlist without rereading all prior audio tasks
- all 3 mandatory review gates passed with unanimous 4-subagent approval
