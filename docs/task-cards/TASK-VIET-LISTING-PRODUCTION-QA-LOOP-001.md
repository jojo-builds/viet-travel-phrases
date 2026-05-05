# TASK-VIET-LISTING-PRODUCTION-QA-LOOP-001

## Task Done

Run a bounded self-improving QA loop over SpeakLocal Vietnam listing pages until rendered iOS pages feel production-ready across representative and random page types, or stop with exact remaining blockers. The task is not done when validators pass; it is done when real simulator pages pass the adult-traveler review standard.

## Context

Recent fixes improved many pages, but rendered screenshots still exposed systemic problems after green audits: wrong page-type routing, repeated hero content, vague section labels, random `Browse more` shelves, city/country hubs acting like phrase feeds, sticky controls covering content, and pages that sound like content architecture instead of an adult travel phrasebook.

Use the current repo as source of truth. Use existing authored sources, generated resources, validators, task results, and the `speaklocal-listing-pages` skill. Do not generate broad AI prose across the catalog.

## Worker Judgment

Behave like a product QA engineer with the simulator open:

- build;
- screenshot real pages;
- judge them like a tired first-time traveler;
- identify the pattern;
- fix the generator/template/renderer/router/source issue;
- regenerate;
- rebuild;
- screenshot again;
- repeat.

Prefer systemic fixes over one-off page edits. A one-off edit is appropriate only when the issue is truly page-specific.

## Required Outcome

Run up to `8` major iterations or up to `8` hours. Stop earlier only if the acceptance criteria pass.

Every major iteration must include:

1. Regenerate Viet catalog/resources, SQLite, and practice metadata as needed.
2. Run automated validators.
3. Build and launch the native iOS app in the simulator.
4. Capture screenshots for fixed representative pages and random stratified pages.
5. Inspect top, middle, bottom, and sticky-player/audio states where relevant.
6. Classify issues as `BLOCKER`, `MAJOR`, or `MINOR`.
7. Fix root causes in templates, generators, renderers, relationship routing, page classification, validators, hero fallback, safe-area behavior, or practice metadata.
8. Repeat until acceptance passes or the runtime cap is reached.

### Product Standard

SpeakLocal listing pages should feel like an adult travel phrasebook and audio guide:

- clean;
- intuitive;
- audio-first;
- useful before a trip;
- fast in-country;
- not a grammar lesson;
- not a travel blog;
- not a database feed;
- not AI filler.

The best page usually has less prose: clean title, English meaning, audio, short context when helpful, useful rows, and the right CTA.

### Fixed Representative Pages

Inspect these every major iteration:

- `Tôi không hiểu`
- `Bàn này còn trống`
- `Bà Nà Hills`
- `Cầu Rồng`
- `Đường Nguyễn Văn Linh`
- `Anăn Sài Gòn`
- `Bún chả Hương Liên`
- `Phở Bát Đàn`
- `Bún bò Huế`
- `Cao lầu`
- `Bưu điện Thành phố ở đâu?`
- `Shopping`
- `Da Nang`
- `All Vietnam`
- `Hotel check-in`
- `Airport arrival`
- `Taxi/Grab pickup`

### Random Stratified Sampling

Do not optimize only for known screenshots. Use fixed random seeds and report them.

Each major iteration should sample random pages across page intent types:

- `simple_phrase`
- `traveler_may_hear`
- `derived_place_phrase`
- `street`
- `landmark_micro_place`
- `macro_attraction_journey`
- `restaurant`
- `dish`
- `topic_hub`
- `city_hub`
- `country_hub`
- `practical_flow`

If any category fails, sample additional pages from that category in the next iteration.

## Boundaries

- Do not run a broad LLM rewrite.
- Do not create 3,000 unique generated essays.
- Do not generate separate scenario conversations.
- Do not duplicate phrase text into a parallel content universe.
- Do not claim production-ready from validator counts alone.
- Do not ask Jojo to inspect CSVs or raw patch files.
- Do not change signing, provisioning, or project settings unless a native build requirement truly demands it and the result contract calls that out.
- Preserve canonical Vietnamese, canonical English, page IDs, pronunciation/audio IDs, and source-owned data flow unless the task finds and documents an explicit defect.
- If a new recurring listing-page failure class is discovered, update `/Users/jojolim/.codex/skills/speaklocal-listing-pages/SKILL.md` before closeout.

## Validation

Run the repo's relevant generation, validation, and native proof commands discovered during the task. At minimum, expect:

- Viet catalog/listing/SQLite regeneration as needed;
- practice metadata/deck regeneration or check if practice-facing output changes;
- SQLite fixture validation;
- city/country/listing validators;
- canonical content audit;
- page quality audit;
- relevant Node tests;
- broad scan for banned/internal/patronizing wording;
- native simulator build;
- simulator screenshot capture for representative pages;
- `git diff --check`.

The rendered review must check:

- correct page type;
- natural headings;
- no duplicate hero content in `Meaning`, `Quick say`, or `Say this`;
- relevant first rows;
- page-type-aware `Browse more`;
- no dead speaker controls;
- no sticky player/speed-control overlap;
- no bottom nav/search overlap;
- correct or neutral hero imagery;
- page-type-specific Practice CTA labels;
- practice metadata references existing phrase IDs.

## Acceptance Criteria

Only say `production-ready` if all are true:

1. Automated validators pass.
2. No `BLOCKER` issues in fixed representative pages.
3. No `BLOCKER` issues in the final random sample.
4. No `MAJOR` issues across at least three inspected pages per intent type.
5. At least `50` random pages are inspected in the final pass.
6. At least `3` clean pages per intent type are inspected.
7. At least `10` clean random pages in a row pass in the final pass.
8. No visible disabled speaker controls render in production rows.
9. No sticky player, speed control, bottom nav, or floating search overlap hides content.
10. No generic unrelated hero imagery appears on specific place pages.
11. No city/country hub random phrase-feed behavior remains.
12. No dish-as-destination rows remain.
13. No repeated hero content appears in `Meaning`, `Quick say`, or `Say this`.
14. Practice CTA labels are page-type specific.
15. Practice metadata seeds reference existing phrase IDs.

If the runtime cap is reached first, stop safely, commit the largest safe completed subset, and report `not production-ready yet` with exact remaining blockers/majors and screenshot evidence.

## Result Contract

Write `docs/task-results/TASK-VIET-LISTING-PRODUCTION-QA-LOOP-001.md` with:

- iteration count;
- what failed and what was fixed each iteration;
- validation commands and outcomes;
- screenshot folder path;
- inspected page list with page ID, page type, screenshot paths, verdict, issues, and fixes;
- final fixed probe verdicts;
- random sample list and seeds;
- practice metadata examples for `Cầu Rồng`, `Bà Nà Hills`, `Đường Nguyễn Văn Linh`, `Anăn Sài Gòn`, `Shopping`, `Da Nang`, and `Tôi không hiểu`;
- missing-audio priority report;
- hero image/fallback report;
- fallback-template pages report;
- hidden-audio-controls report;
- remaining manual-review flags;
- final verdict: `production-ready` or `not production-ready yet`;
- final `git status --short`.

Commit only task-owned source/generator/renderer/validator/resource/proof/result artifacts. If no production fixes are safe, commit the review/report artifacts and exact blockers.
