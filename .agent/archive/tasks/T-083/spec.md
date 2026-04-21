# Task Spec: T-083

## Title
Desktop Codex automation pilot, controlled Viet audio follow-up batch

## Objective
Use the existing Viet audio evidence and current live source truth to promote the next highest-value allowlisted Viet rows from planned toward app-usable coverage, without overstating continuity quality or reopening broad audio regeneration.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `.agent/tasks/T-016/result.md`
- `.agent/tasks/T-074/result.md`
- `content-draft/viet/audio-review/` relevant summary files
- `app/assets/audio/**` only as needed for bounded mapping checks
- `app/family/packs/**` only as needed for bounded row and mapping checks

## Task type
- bounded audio batch
- validation-backed content promotion
- prep-to-runtime seam hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-083/**`
- `app/assets/audio/**`
- `app/family/packs/**`
- `content-draft/viet/audio-review/**`
- `docs/operations/**`

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `app/**`
- `ops/**`

### Must not touch
- `site/**`
- unrelated language lanes
- release/build/TestFlight files
- broad app-shell changes outside the bounded audio seam

## Source-of-truth notes
- Keep this batch controlled and allowlisted. Do not turn it into a broad regen lane.
- Preserve the current caution-level continuity posture unless new evidence truly supports stronger claims.
- Favor rows that materially improve the live traveler experience.

## Required outputs
Create or update these files:
- `content-draft/viet/audio-review/` bounded batch notes or evidence files as needed
- `.agent/tasks/T-083/logs/audio-batch-audit.md`
- `.agent/tasks/T-083/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-083/reviews/` for each required gate

## Concrete requirement
- leave behind at least 24 meaningful row outcomes unless the bounded allowlist is genuinely smaller
- keep continuity and readiness language honest
- verify changed mappings/assets remain internally consistent

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-audio-risk-review.md`
3. `03-seam-integrity-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify required output files exist
- verify all touched audio and mapping surfaces remain internally consistent
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no unrelated language or website files changed

## Definition of done
- the next bounded Viet audio batch materially improves live traveler value
- continuity posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
