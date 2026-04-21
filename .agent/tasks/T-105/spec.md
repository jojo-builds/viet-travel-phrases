# Task Spec: T-105

## Title
Desktop Codex automation pilot, France second translation wave and residual-risk isolation pass

## Objective
Build directly on the new French top-30 translation pack by translating the next substantial practical slice, then isolate whatever still needs expert, medical, or rewrite treatment into a smaller explicit residual handoff. The lane should leave this pass with more than a scaffold, but without hiding France-fit or medical caution debt.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-019/result.md`
- `.agent/tasks/T-098/result.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/french/README.md`
- `content-draft/french/source-notes.md`
- `content-draft/french/phrase-source.csv`
- `content-draft/french/first-wave-priority.csv`
- `content-draft/french/research-backlog.md`

## Task type
- prep-lane translation follow-up
- second-wave expansion
- residual-risk isolation

## Scope
### Allowed write scopes
- `.agent/tasks/T-105/**`
- `content-draft/french/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `app/family/**` for bounded product-shape reference only

### Must not touch
- `app/**`
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes

## Source-of-truth notes
- Start from the `40` remaining queued or deferred French rows after `T-098`.
- Prefer a meaningful second-wave outcome, usually at least `24` row dispositions, rather than a tiny conservative slice.
- Keep `french-simple-problems-6` visibly sensitive for later expert medical review unless stronger proof emerges in current lane truth.
- If `french-coffee-shop-4` still does not fit France naturally, keep it deferred or retire it instead of forcing a weak translation.

## Required outputs
Create or update these files:
- `content-draft/french/README.md`
- `content-draft/french/source-notes.md`
- `content-draft/french/phrase-source.csv`
- `content-draft/french/first-wave-priority.csv`
- `content-draft/french/research-backlog.md`
- `.agent/tasks/T-105/logs/french-second-wave-audit.md`
- `.agent/tasks/T-105/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-105/reviews/` for each required gate

## Concrete requirement
- translate the next meaningful French wave from rank `31` onward or leave explicit row-by-row reasons when a row should stay deferred
- reduce the remaining French queue materially while keeping pronunciation helpers and France-fit notes coherent
- leave one explicit residual handoff for expert-review, rewrite-needed, or later-only rows

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-france-coverage-review.md`
2. `02-pronunciation-and-fit-review.md`
3. `03-residual-risk-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify touched French CSV surfaces still parse cleanly
- verify no app, site, ops, or unrelated language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the French lane now has a meaningful second-wave translation outcome instead of stopping at the first 30 rows
- remaining French risk rows are isolated more explicitly than before
- all 3 mandatory review gates passed with unanimous 4-subagent approval
