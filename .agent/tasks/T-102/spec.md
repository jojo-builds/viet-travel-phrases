# Task Spec: T-102

## Title
Desktop Codex automation pilot, Vietnam website starter module subset and conversion ordering pass

## Objective
Use the current export evidence to tighten the live Vietnam website hub around the most useful starter modules and the clearest honest conversion order. If the current 4-module subset is already right, prove that with sharper doc and audit support. If a small bounded reorder or subset swap would materially improve traveler utility without overclaiming breadth, make that change and document it.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-091/result.md`
- `.agent/tasks/T-093/result.md`
- `docs/PRIORITIES.md`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/countries/vietnam.html`
- `site/data/phrase-previews/manifest.json`
- `content-draft/viet/website-preview.json`

## Task type
- bounded website conversion improvement
- starter-module ordering audit
- honest subset tightening

## Scope
### Allowed write scopes
- `.agent/tasks/T-102/**`
- `docs/website/**`
- `site/countries/vietnam.html`
- other bounded website content-conversion surfaces under `site/**` only if directly required by the Vietnam hub subset or ordering pass

### Allowed read scopes
- `docs/**`
- `site/**`
- `content-draft/viet/**`
- `app/family/packs/**`

### Must not touch
- `app/**` as a write surface
- `ops/**`
- `docs/operations/**`
- release/build/TestFlight files
- broad website strategy docs or unrelated country routes

## Source-of-truth notes
- Start from the current honest fact that the static Vietnam hub surfaces 4 of the 7 exported starter modules.
- Prefer a bounded subset or ordering improvement tied to traveler utility, not general marketing churn.
- If the current subset is already best, leave the page mostly as-is and strengthen the evidence trail instead of forcing cosmetic edits.
- Keep claims aligned with the real starter-only website seam.

## Required outputs
Create or update these files:
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/countries/vietnam.html`
- `.agent/tasks/T-102/logs/starter-module-ordering.md`
- `.agent/tasks/T-102/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-102/reviews/` for each required gate

## Concrete requirement
- decide whether the current 4-module Vietnam hub subset and order are still the best starter-facing conversion slice
- either land one bounded improvement or leave an evidence-backed no-churn conclusion
- keep the final page and doc truth honest about how much of the exported starter set is actually surfaced

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-conversion-honesty-review.md`
3. `03-export-subset-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify the final hub still aligns with the committed Vietnam export subset truth
- verify no app, ops, or unrelated website routes changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Vietnam website hub has a clearer starter-module subset or a stronger evidence-backed no-churn conclusion
- doc truth and live page truth agree on the surfaced subset
- all 3 mandatory review gates passed with unanimous 4-subagent approval
