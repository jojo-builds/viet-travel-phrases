# Task Spec: T-111

## Title
Desktop Codex automation pilot, Italy next utility translation pack and holdout cleanup

## Objective
Resume the Italy lane from its earlier first-wave translation truth. Clear the best remaining practical rows in one meaningful batch, tighten any rewrite-needed holdouts, and leave a smaller cleaner unresolved tail instead of the older pending-next-pass cluster.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-014/result.md`
- `docs/PRIORITIES.md`
- `content-draft/italian/README.md`
- `content-draft/italian/source-notes.md`
- `content-draft/italian/phrase-source.csv`
- `content-draft/italian/first-wave-priority.csv`
- `content-draft/italian/research-backlog.md`

## Task type
- next translation pack
- unresolved-row reduction
- prep-lane handoff tightening

## Scope
### Allowed write scopes
- `.agent/tasks/T-111/**`
- `content-draft/italian/**`

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
- Start from the current Italy lane instead of recreating older shortlist logic.
- Prefer clearing the full currently worthwhile practical set, not a tiny conservative batch.
- Keep coffee, bargaining, directions, medical, or register-sensitive holdouts visibly flagged when confidence is still weak.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/italian/README.md`
- `content-draft/italian/source-notes.md`
- `content-draft/italian/phrase-source.csv`
- `content-draft/italian/first-wave-priority.csv`
- `content-draft/italian/research-backlog.md`
- `.agent/tasks/T-111/logs/italian-next-pack-audit.md`
- `.agent/tasks/T-111/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-111/reviews/` for each required gate

## Concrete requirement
- land at least 24 row outcomes unless the currently unresolved high-value set is genuinely smaller after bounded verification
- rewrite or defer any still-weak rows instead of forcing low-confidence translations
- leave the Italy lane with a materially smaller unresolved queue and a sharper next handoff

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-italian-language-risk-review.md`
3. `03-row-selection-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify required output files exist
- verify `content-draft/italian/phrase-source.csv` and `content-draft/italian/first-wave-priority.csv` still parse cleanly after edits
- verify no `app/**`, `site/**`, `ops/**`, or runtime-wiring files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Italy lane has a real next utility pack landed and a smaller honest unresolved tail
- any remaining sensitive rows are clearly flagged for later rewrite or review
- all 3 mandatory review gates passed with unanimous 4-subagent approval
