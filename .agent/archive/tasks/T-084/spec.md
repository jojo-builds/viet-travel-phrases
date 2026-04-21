# Task Spec: T-084

## Title
Desktop Codex automation pilot, Germany residual-tail completion and holdout isolation

## Objective
Finish the remaining meaningful Germany prep-lane tail after T-078 by clearing the practical unresolved rows that still merit effort, isolating any low-fit or rewrite-blocked leftovers explicitly, and leaving the lane in an honest near-complete prep state without claiming runtime graduation.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-078/result.md`
- `content-draft/german/README.md`
- `content-draft/german/source-notes.md`
- `content-draft/german/phrase-source.csv`
- `content-draft/german/first-wave-priority.csv`
- `content-draft/german/research-backlog.md`

## Task type
- translation authoring
- residual-tail reduction
- prep-lane hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-084/**`
- `content-draft/german/**`

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
- Start from the `13`-row residual tail left by `T-078`.
- `coffee-shop-4` stays deferred unless a materially stronger Germany-fit rewrite is found.
- Keep medical, transit, and service-wording cautions explicit instead of flattening uncertainty away.
- If the practical remaining set is genuinely smaller than `24`, clear the full high-value remainder and document any intentional residual holdouts honestly.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/german/README.md`
- `content-draft/german/source-notes.md`
- `content-draft/german/phrase-source.csv`
- `content-draft/german/first-wave-priority.csv`
- `content-draft/german/research-backlog.md`
- `.agent/tasks/T-084/logs/residual-tail-audit.md`
- `.agent/tasks/T-084/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-084/reviews/` for each required gate

## Concrete requirement
- clear the full currently meaningful Germany residual set unless a row is explicitly deferred for stronger rewrite or expert review
- leave the lane with a smaller and more honest residual queue than the current `13`-row tail
- keep pronunciation and review flags honest on sensitive rows

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-german-language-risk-review.md`
3. `03-translation-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify required output files exist
- verify `content-draft/german/phrase-source.csv` parses as CSV after edits
- verify `content-draft/german/first-wave-priority.csv` parses as CSV after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- the Germany prep lane residual tail is materially reduced or honestly isolated
- review-risk posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
