# Task Spec: T-094

## Title
Desktop Codex automation pilot, Japan next utility translation pack and unresolved-row reduction

## Objective
Take the Japan prep lane through its next meaningful translation pack by converting the highest-value remaining `needs-translation` rows into reviewed traveler-ready draft outputs, while shrinking the unresolved queue honestly instead of pretending low-fit or high-risk rows are finished.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-004/result.md`
- `.agent/tasks/T-011/result.md`
- `.agent/tasks/T-027/result.md`
- `content-draft/japanese/README.md`
- `content-draft/japanese/source-notes.md`
- `content-draft/japanese/phrase-source.csv`
- `content-draft/japanese/first-wave-priority.csv`
- `content-draft/japanese/research-backlog.md`

## Task type
- prep-lane translation pass
- unresolved-row reduction
- pronunciation and review-flag hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-094/**`
- `content-draft/japanese/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**`
- `content-draft/thai/**`
- `content-draft/turkish/**`
- `content-draft/spanish/**`
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
- Keep the lane prep-only. This is not runtime promotion.
- Default to polite everyday Japanese and keep natural Japanese script in `target_text`.
- Use `pronunciation` only as traveler support, not a substitute for Japanese script.
- Clear a meaningful batch, usually at least `24` row outcomes unless the live bounded set is genuinely smaller.
- Preserve or strengthen explicit review flags for medical, emergency, or culturally low-fit wording rather than forcing low-confidence translations through.

## Required outputs
Create or update these files:
- `content-draft/japanese/README.md`
- `content-draft/japanese/source-notes.md`
- `content-draft/japanese/phrase-source.csv`
- `content-draft/japanese/first-wave-priority.csv`
- `content-draft/japanese/research-backlog.md`
- `.agent/tasks/T-094/logs/translation-pack-audit.md`
- `.agent/tasks/T-094/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-094/reviews/` for each required gate

## Concrete requirement
- complete the next high-value Japanese utility pack from the current unresolved queue
- leave behind at least `24` row outcomes across translated, deferred, or later-review decisions unless the actual bounded candidate set is smaller
- tighten the residual queue so the next worker can start from a smaller, clearly labeled remainder instead of re-triaging the whole lane

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-translation-quality-review.md`
2. `02-japan-fit-review.md`
3. `03-unresolved-ledger-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify the changed Japanese CSV surfaces still parse cleanly
- verify no app, site, ops, or unrelated language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Japanese lane has a materially smaller unresolved queue and more honest reviewed coverage than before
- every changed surface stays inside `content-draft/japanese/**` plus task artifacts
- the next Japanese worker can start from the narrowed remainder without broad re-orientation
- all 3 mandatory review gates passed with unanimous 4-subagent approval
