# TASK-VIET-PAGE-QUALITY-RECOVERY-001: Recover Every Viet Phrase Page To The Flagship Article Standard

## Task Done

Every current Viet canonical phrase page in the app opens exactly one correct article/listing page, uses the flagship `Xin chào` article pattern as the visual/content standard, has a truthful and useful `Break it down` section, and passes a one-by-one audit proving there are no duplicate phrase pages, no generic fallback pages showing where rich pages should appear, and no bad breakdowns like `one chunk = full phrase`.

If the repo does not currently contain `10,000` Viet phrase sources, do not invent them. Complete every current Viet source/canonical page, record the actual count, and make the generator/validator ready to enforce the same quality bar when the phrase universe grows toward `10,000`.

## Context

Jojo found two serious regressions:

- The current `Xin chào` / Hello page in simulator no longer looks like the accepted flagship page. It looks like a generated/simple page with `Hello` instead of `Hello (universal greeting)` and missing the richer relationship/local sections.
- Some `Break it down` sections are pedagogically wrong. Example: `Không sao đâu` was shown as one card `Không sao đâu = it is okay` and then the full phrase `Không sao đâu = It's okay`. That is not a breakdown; it teaches nothing and should have been caught.

This is no longer a one-page polish task. Treat it as a content/runtime recovery pass across the whole current Viet page universe.

Known source truth:

- `native-ios/App/Models/PhrasePage.swift` contains the original flagship `PhrasePage.xinChao` content and article rhythm.
- `docs/design/NATIVE_VISUAL_REFERENCE.md` contains accepted live native screenshots and visual rules.
- `docs/DECISIONS.md` says `Xin chào` is the flagship visual/content rhythm and every phrase page should resolve through one canonical page identity.
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md` describes the intended SQLite phrase-page graph and the current `900` family / `919` row / `911` canonical page shape.
- `content-draft/viet/canonical-pages/**` is the authored source for canonical Viet phrase pages.
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite` is now the default runtime graph source.
- `native-ios/scripts/generate-viet-sqlite-fixture.js`, `native-ios/scripts/validate-viet-sqlite-fixture.js`, and `native-ios/scripts/generate-authored-tier-one-pages.js` are the likely durable places for generator/validator fixes.

## Worker Judgment

Use GPT-5.5 judgment. Do not make a tiny patch. Do not stop after an audit if you can safely implement. Find the root cause before fixing.

The core product rule is simple: a phrase is a phrase. A traveler who opens a phrase should get one canonical, useful, offline article page. Page depth can vary, but no page should feel like placeholder filler, and no important page should be bypassed by a generic SQLite/generated fallback route.

Use the `speaklocal-listing-pages` skill for page quality. Use `PhrasePage.xinChao` as the concrete example, not vague prose. If current architecture prevents full completion, finish the largest safe subset, block with exact evidence, and leave validators that prevent silent regression.

## Required Outcome

- Root-cause the `Xin chào` regression:
  - determine whether there are multiple IDs/pages for the same phrase;
  - determine why the simulator opens the simpler page instead of the flagship article;
  - fix routing/alias/runtime/rendering so `Xin chào`, `Hello`, `viet-polite-hello`, and `viet-phrase-polite-1` all resolve to the same accepted flagship page behavior.
- Audit every current Viet canonical page one by one:
  - actual page ID;
  - Vietnamese title;
  - English title;
  - source type;
  - article completeness;
  - breakdown quality;
  - duplicate/canonical status;
  - visible audio status;
  - pass/fail notes.
- Repair every current page that can be repaired safely in this pass. Do not limit the work to Tier 1 or the top 150.
- Make `Break it down` a real quality gate:
  - multiword phrases should usually break into meaningful reusable pieces plus the full phrase;
  - a phrase must not render as `single identical chunk = full phrase` unless there is a documented reason it is truly indivisible;
  - chunks must use human learner-facing meanings, not internal labels like `question marker`, `phrase ending`, `key word`, or vague grammar placeholders;
  - idioms should explain the reusable phrase chunk and the softening/final particle where useful;
  - the final full phrase may appear after `=` but should not be the only real card.
- Upgrade generators/fixtures/resources so the app keeps the fix:
  - no hand-only native patch that will be overwritten by generation;
  - generated SQLite/resources and Swift runtime behavior must agree;
  - validators must fail on duplicate canonical phrase pages, broken aliases, and bad breakdown structures.
- Preserve or restore the flagship `Xin chào` article pattern:
  - rich hero/intention;
  - player;
  - `At a glance`;
  - useful quick/standard phrase rows;
  - correct breakdown;
  - variants/local/pronoun/situational sections where relevant;
  - positive local/travel note;
  - canonical Explore next links.
- Produce a Jojo-readable audit/result artifact that clearly says:
  - current page universe count;
  - how many pages are strong/pass;
  - how many were fixed;
  - any remaining blockers and why they are not safely solvable in this pass.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own content sources, generators, SQLite fixture/resource outputs, validators, native runtime mapping/alias fixes, tests, and result/audit docs needed to complete this recovery.
- Do not generate new ElevenLabs audio unless a missing audio control blocks validation and there is already an approved audio-generation workflow. Prefer missing-audio audit output over ad hoc generation.
- Do not redesign the whole visual system. Restore/align to the existing flagship article pattern and current native renderer.
- Do not create duplicate pages to solve missing content. Fix canonical identity.
- Do not invent `10,000` new phrase records if the source data does not exist. Make the current universe complete and the validator scalable.

## Validation

- Add or update automated validators so this class of bug cannot silently return:
  - `Xin chào` canonical aliases all open the flagship article behavior;
  - every current canonical page has a page record and article sections;
  - every current canonical page has a valid `Break it down` section or a documented indivisible exception;
  - no breakdown has exactly one meaningful card that duplicates the full phrase before the full phrase;
  - no user-facing breakdown labels use internal placeholder language;
  - all `detailPageID`/relation/search links resolve to one canonical page;
  - no duplicate canonical Vietnamese phrase pages;
  - visible audio keys resolve or are audited as missing.
- Run the relevant Node generators and validators.
- Run relevant native tests for page routing/search/SQLite/detail pages.
- Build the native app if native files or generated resources changed.
- Capture simulator screenshots for:
  - `Xin chào` reached from Home/Browse/Search;
  - the page that previously showed the bad `Không sao đâu` breakdown;
  - one non-Tier-1/premium page;
  - one long phrase breakdown page.
- Use two focused read-only reviewers before closeout:
  - content/pedagogy reviewer: checks page depth, copy, and breakdown teaching quality;
  - canonical/runtime reviewer: checks page identity, SQLite/resource generation, search/link/audio integrity.

## Result Contract

Write `docs/task-results/TASK-VIET-PAGE-QUALITY-RECOVERY-001.md` with:

- status: done or blocked;
- commit hash;
- root cause of the `Xin chào` regression;
- exact current page universe count;
- audit artifact paths;
- pages fixed count and examples;
- validator/test commands and outcomes;
- simulator screenshot paths;
- remaining blockers, if any;
- peer review outcomes;
- recommended next task.
