# TASK-VIET-EDITORIAL-READY-IMPORT-001 Result

Status: complete.
Date: 2026-05-03.

## Approved Import Scope

Jojo approved these 13 ready rows for import:

`EP-001`, `EP-002`, `EP-004`, `EP-005`, `EP-006`, `EP-007`, `EP-008`, `EP-009`, `EP-010`, `EP-011`, `EP-013`, `EP-016`, `EP-020`.

Explicitly not approved and not imported:

`EP-003`, `EP-012`, `EP-014`, `EP-015`.

The approval overlay is:

`docs/editorial-exports/viet-canonical-pages/chatgpt-pilot-2026-05-03/approved-imports-TASK-VIET-EDITORIAL-READY-IMPORT-001.json`

## What Changed

- Imported the 13 approved rows through source-owned records only.
- Preserved canonical Vietnamese titles and canonical page IDs.
- Added ready-batch support to the editorial importer so Jojo-approved rows can be imported without changing the original `REVIEW_ONLY` pilot patch.
- Added city-library `editorialImport` support for approved restaurant, dish, place, street, and route-question pages.
- Updated generated city/place copy so the imported pages use page-kind-aware sections instead of generic named-place prose.
- Updated `Dạ, chào anh` through its source-owned catalog-promoted page.
- Added a ready-import validator proving only the approved 13 rows were imported and the four excluded rows stayed out.
- Regenerated Viet catalog, authored listing pages, SQLite fixture/report, audits, audio queue outputs, and practice sample decks.

No audio was generated.
No native Swift UI was edited.

## Final Counts

- Catalog families: `3059`
- Source phrases: `3078`
- SQLite canonical pages: `3070`
- Duplicate canonical page groups: `0`
- Missing planned audio rows: `2126`
- Release-blocking missing audio rows: `0`
- City library pages: `750`
- City phrase tags: `750`
- Practice deck items: `7188`

## Imported Page Samples

- `EP-001` / `Bún chả Hương Liên`: restaurant flow with `At a glance`, `Quick say`, `Break it down`, `What it is`, `Before you go`, `Menu and dietary help`, `Inside the place`, `Good to know`, and `Explore next`.
- `EP-005` / `Bà Nà Hills`: place journey flow with ticket, cable-car, driver-wait, photo, food/drink, and return-pickup linked phrases; no invented literal meaning.
- `EP-009` / `Đường Bạch Đằng`: street pronouncer flow with driver, confirm-location, drop-off, pickup, and wrong-place support.
- `EP-020` / `Dạ, chào anh`: tone cleanup with relationship-word context and no broad title change.

## Validation

Passed:

- `node native-ios/scripts/import-viet-editorial-pilot.js --ready-batch --dry-run`
- `node native-ios/scripts/import-viet-editorial-pilot.js --ready-batch --apply`
- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-viet-editorial-ready-import.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/validate-viet-editorial-pilot-import.js`
- `node native-ios/scripts/validate-viet-editorial-model-support.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `node --check` on touched generator/importer/validator scripts.
- Broad scan for known internal/staging wording across generated resources and touched source lanes: no matches.

Protected path proof:

- `git diff --name-only -- native-ios/App native-ios/Resources/Audio native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` returned no files.

## Reviewer Gate

Focused read-only reviewer gate: APPROVE.

Checked all 13 imported pages for:

- traveler usefulness and page-kind fit;
- preserved canonical Vietnamese titles;
- full article depth;
- visible linked phrase rows;
- no banned/internal wording;
- no half-page or stub imports.

## Remaining Pilot Rows

Not imported by Jojo approval:

- `EP-003`: still needs the Cao lầu canonical identity decision.
- `EP-012`, `EP-014`, `EP-015`: still need a separate title-preserving import decision or revised copy because Jojo excluded them from this approval.

Recommended next task: review only those four excluded rows, decide whether their current canonical Vietnamese titles should stay clipped or receive separate new full-sentence canonical pages, then import only the approved subset.
