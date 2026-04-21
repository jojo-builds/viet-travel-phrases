# Task Spec: T-099

## Title
Desktop Codex automation pilot, controlled Viet audio follow-up batch and seam ledger update

## Objective
Turn the current Viet audio allowlist into one real bounded follow-up batch instead of leaving it as evidence only. Promote the next highest-value approved rows from planned into app-usable coverage, update the live seam deterministically, and refresh the supporting ledger so release truth stays honest.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-016/result.md`
- `.agent/tasks/T-092/result.md`
- `docs/PRIORITIES.md`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md`
- `content-draft/viet/audio-review/FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md`
- `content-draft/viet/audio-review/RELEASE-POSTURE-RECOMMENDATION.md`
- `app/assets/audio/manifest.json`
- `app/assets/audio/registry.ts`
- `app/family/packs/viet.json`

## Task type
- bounded audio follow-up batch
- live seam update
- audio truth refresh

## Scope
### Allowed write scopes
- `.agent/tasks/T-099/**`
- `content-draft/viet/audio-review/**`
- `app/assets/audio/**`
- `app/family/packs/**`
- `docs/operations/**` only if the changed audio seam truth truly requires a small honesty update

### Allowed read scopes
- `docs/**`
- `ops/**`
- `content-draft/viet/**`
- `app/**`

### Must not touch
- `site/**`
- unrelated language lanes
- release/build/TestFlight files
- broad app-shell work outside the Viet audio seam

## Source-of-truth notes
- Use the current allowlist ledger from `FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md` as the starting pool.
- This must be a meaningful batch, not a tiny proof nibble. Clear the current high-value allowlisted set unless repo truth shows a smaller safe subset is the only honest move.
- Keep continuity claims conservative. This task may improve coverage, but it must not overstate same-speaker or full quality proof.
- If a candidate row should stay out of the batch, record the reason explicitly instead of silently skipping it.

## Required outputs
Create or update these files:
- `content-draft/viet/audio-review/FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md`
- `content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md`
- `app/assets/audio/manifest.json`
- `app/assets/audio/registry.ts`
- `app/family/packs/viet.json`
- `.agent/tasks/T-099/logs/audio-follow-up-batch.md`
- `.agent/tasks/T-099/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-099/reviews/` for each required gate

## Concrete requirement
- execute one real Viet audio follow-up batch from the current allowlist
- update every touched live seam surface consistently if new clips become app-usable
- refresh the allowlist ledger so future workers can see what was promoted, what remains deferred, and why
- keep the final posture honest about any remaining continuity or release confidence limits

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-audio-batch-utility-review.md`
2. `02-continuity-honesty-review.md`
3. `03-seam-integrity-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify touched audio seam files stay internally consistent
- verify no site or unrelated language surfaces changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- one meaningful Viet audio follow-up batch is landed honestly
- the live audio seam and supporting ledger agree
- remaining risk is stated clearly rather than hidden
- all 3 mandatory review gates passed with unanimous 4-subagent approval
