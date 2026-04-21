# Task Spec: T-086

## Title
Desktop Codex automation pilot, Indonesia holdout-management pass and residual queue reduction

## Objective
Continue the Indonesian prep lane after T-080 by clearing the remaining worthwhile unresolved rows, explicitly isolating low-fit or review-sensitive leftovers, and leaving a tighter prep-ready queue instead of a broad ambiguous tail.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-080/result.md`
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/source-notes.md`
- `content-draft/indonesian/phrase-source.csv`
- `content-draft/indonesian/first-wave-priority.csv`
- `content-draft/indonesian/research-backlog.md`

## Task type
- translation authoring
- holdout management
- prep-lane hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-086/**`
- `content-draft/indonesian/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**` for boundary reference only
- `app/family/**` for bounded family-shape reference only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- Start from the `22` non-expert unresolved rows plus the explicit medical holdout left by `T-080`.
- Focus on the highest-value practical remainder first, not filler.
- Keep `permisi` versus `maaf`, payment wording, food-risk language, and medical uncertainty review-visible instead of flattening it away.
- If the meaningful remaining set is smaller than `24`, clear the full currently worthwhile set and document any intentional residual holdouts honestly.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/source-notes.md`
- `content-draft/indonesian/phrase-source.csv`
- `content-draft/indonesian/first-wave-priority.csv`
- `content-draft/indonesian/research-backlog.md`
- `.agent/tasks/T-086/logs/holdout-audit.md`
- `.agent/tasks/T-086/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-086/reviews/` for each required gate

## Concrete requirement
- clear the current worthwhile Indonesian holdout set unless a row is explicitly deferred for stronger rewrite or expert review
- leave the lane with a materially smaller and more honest residual queue than after `T-080`
- keep pronunciation and review posture honest on sensitive rows

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-indonesian-language-risk-review.md`
3. `03-translation-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify required output files exist
- verify `content-draft/indonesian/phrase-source.csv` parses as CSV after edits
- verify `content-draft/indonesian/first-wave-priority.csv` parses as CSV after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- the Indonesia prep lane residual queue is materially reduced or honestly isolated
- risk posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
