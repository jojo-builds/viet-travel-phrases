# Task Spec: T-134

## Title
Desktop Codex automation pilot, Viet country-route follow-on ladder and off-hub support honesty packet

## Objective
Tighten the Vietnam country-route conversion seam one more step so the public page pair, the follow-on support framing, and the website seam doc all agree on one honest ladder: what is surfaced directly on-web now, what appears only as off-hub follow-on support, and when the traveler should go deeper into the app instead of assuming broader live website coverage.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-115/result.md`
- `.agent/tasks/T-127/result.md`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- `content-draft/viet/website-preview.json`

## Task type
- website conversion hardening
- country-route follow-on contract tightening
- off-hub support honesty packet

## Scope
### Allowed write scopes
- `.agent/tasks/T-134/**`
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- bounded related include or data surfaces under `site/**` only if required to keep the country-route pair and seam doc truthful and aligned

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `site/**`
- `app/family/packs/**` as read-only starter-shape reference only

### Must not touch
- `app/**` as a write surface
- `ops/**`
- `docs/operations/**`
- release/build/TestFlight files
- unrelated country pages or broad website strategy surfaces outside the Vietnam country-route conversion seam
- manual edits to generated preview JSON when source or exporter truth should drive the fix instead

## Source-of-truth notes
- `T-115` tightened the situation-first conversion path.
- `T-127` tightened route-pair trust parity and clarified that essentials, repair, and food are follow-on support rather than equal on-hub coverage.
- The remaining gap is the exact public contract for those off-hub follow-on modules: they should not visually or verbally over-promise live website parity, but they also should not leave the traveler unclear about where to go next.
- Keep the approved on-hub subset honest at arrival, transport, money, and phone unless bounded repo truth clearly supports a stronger wording adjustment.
- Do not imply fresh device proof, full-library website access, or broader starter export coverage than the repo currently supports.

## Required outputs
Create or update these files:
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `.agent/tasks/T-134/logs/viet-follow-on-ladder-audit.md`
- `.agent/tasks/T-134/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-134/reviews/` for each required gate

## Concrete requirement
- leave one explicit contract for how off-hub follow-on support modules are presented on the Vietnam country-route pair without reading like equal live on-web module coverage
- tighten the traveler decision ladder around when to stay on the public route, when to click through to bounded phrase/article support, and when the app is the honest next step for deeper coverage
- make `docs/website/PHRASE_AUDIO_DELIVERY.md` agree with the final country-route contract so future website edits do not drift back into fuzzy promises
- keep route-pair parity intact between `site/countries/vietnam.html` and `site/countries/vietnam/index.html`
- keep the work meaningful and synthesis-heavy, not a thin wording cleanup

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-ladder-review.md`
2. `02-conversion-honesty-review.md`
3. `03-off-hub-contract-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify required output files exist
- verify route-pair parity still holds between `site/countries/vietnam.html` and `site/countries/vietnam/index.html`
- verify the final copy and seam doc agree on the same on-hub versus off-hub support contract
- verify the final copy stays honest about current public website scope versus deeper app-only coverage
- verify no `app/**`, `ops/**`, `docs/operations/**`, or unrelated country pages changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Vietnam country-route pair leaves a materially clearer next-step ladder for public visitors
- off-hub follow-on support no longer reads like equal live web coverage
- the website seam doc and country-route pair tell the same honest story
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no export-plumbing, app-surface, or ops-truth drift was introduced
