# Task Spec: T-098

## Title
Desktop Codex automation pilot, France first-wave translation pack and pronunciation helper pass

## Objective
Take the France prep lane from scaffold-only to real translated first-wave coverage by drafting the top-ranked rows, filling compact pronunciation helpers consistently, and leaving a tighter next-pass contract instead of a blank translation surface.

This is prep-only work. Do not wire French into runtime truth.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-019/result.md`
- `.agent/tasks/T-087/spec.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/french/README.md`
- `content-draft/french/source-notes.md`
- `content-draft/french/phrase-source.csv`
- `content-draft/french/first-wave-priority.csv`
- `content-draft/french/research-backlog.md`

## Task type
- prep-lane translation pass
- pronunciation helper fill-in
- residual queue tightening

## Scope
### Allowed write scopes
- `.agent/tasks/T-098/**`
- `content-draft/french/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**`
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
- Start from the ranked first wave already staged in `first-wave-priority.csv`.
- Translate the top `30` ranked rows unless the repo truth shows a narrower cleaner stopping point.
- Use France-focused polite everyday French, keep correct spelling in `target_text`, and use pronunciation only as compact traveler support.
- Keep `vous` posture, greeting-first service tone, bill/payment wording, station language, medical wording, and allergy phrasing review-visible where needed.
- If a row such as `coffee-shop-4` still looks weak for France, rewrite or defer it honestly instead of forcing it through.

## Required outputs
Create or update these files:
- `content-draft/french/README.md`
- `content-draft/french/source-notes.md`
- `content-draft/french/phrase-source.csv`
- `content-draft/french/first-wave-priority.csv`
- `content-draft/french/research-backlog.md`
- `.agent/tasks/T-098/logs/french-first-wave-audit.md`
- `.agent/tasks/T-098/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-098/reviews/` for each required gate

## Concrete requirement
- land meaningful translated coverage for the current top French first-wave rows
- fill pronunciation for the rows you touch using one compact helper rule
- leave the next French worker a smaller, clearly labeled remainder instead of a scaffold-only lane

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-translation-quality-review.md`
2. `02-france-fit-review.md`
3. `03-pronunciation-and-search-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify the changed French CSV surfaces still parse cleanly
- verify no app, site, ops, or unrelated language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the French lane now has real first-wave translated coverage plus compact pronunciation help
- every changed surface stays inside `content-draft/french/**` plus task artifacts
- the next French worker can continue from a smaller remainder without redoing scaffold work
- all 3 mandatory review gates passed with unanimous 4-subagent approval
