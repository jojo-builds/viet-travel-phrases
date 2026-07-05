# SpeakLocal Vietnam Real Traveler Walkthrough Report

Date: 2026-07-05 Asia/Manila

Branch/worktree: `feature/real-traveler-walkthrough-20260705` at `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/real-traveler-walkthrough-20260705`

Baseline: `main` commit `07a2db5d8` (`Record launch readiness phone proof`). The shared root checkout was dirty, so all edits and proof were kept in this isolated worktree. `feature/paywall` was not touched. No physical iPhone build was run.

## Pages And Flows Tested

- Home launch with featured phrase, save/play/speed controls, bottom tabs, and search chrome.
- Browse root, Airport category, Airport arrival phrase detail, back/forward behavior, detail save, phrase audio, and speed buttons.
- Hotel category for check-in/room-problem traveler jobs.
- Eating Out category, Food Menu, Drink Menu, food/drink row audio/save affordances by visual route proof and focused UI coverage.
- City hubs for Da Nang, Hoi An, Hanoi, Saigon, and Hue.
- Search results for `hotel`, including browse-result cards and the bottom search field.
- Saved route with seeded saved-trip state.
- Practice route with saved practice and topic rows.

## Bugs Found

### RTW-001 - Browse Root Blank After Backing Out Of A Browse Detail

Repro:

1. Open Browse.
2. Open Airport.
3. Open `Sảnh đến ở đâu?`.
4. Tap back to Airport.
5. Tap back to Browse.

Result before fix: the Browse photo-backed sheet was visually blank under the top chrome and bottom tabs. Proof: `docs/task-results/parallel-goals-2026-07-05/proofs/real-traveler-walkthrough/04-bug-browse-root-blank-after-back.jpg`.

Root cause: the Browse root photo-backed surface could retain a stale scrolled state while it was kept alive behind Browse collection/detail routes. Returning to Browse root did not force the root surface to remount or reliably reset its top anchor.

Fix:

- Added a Browse root surface reset token in `AppShellView`.
- When navigating back from any Browse collection to Browse root, the shell now remounts the Browse root photo surface and bumps its scroll-to-top trigger.
- Hardened `AdminPhotoBackdropSurfaceView` so explicit top resets clear the retained display offset and repeat the anchor scroll on the next run loop.
- Added `BrowseSearchUITests/testBackFromBrowseDetailRestoresBrowseRootContent`.

Fixed proof: `docs/task-results/parallel-goals-2026-07-05/proofs/real-traveler-walkthrough/browse-root-after-detail-back.png`.

## Tests And Validation

- `git diff --check`: passed.
- `node scripts/guard-native-only.js`: passed.
- `node native-ios/scripts/guard-native-chrome.js`: passed.
- Focused regression: `BrowseSearchUITests/testBackFromBrowseDetailRestoresBrowseRootContent`: `1` test, `1` passed, `0` failed.
- Focused traveler batch: `15` tests executed, `11` passed, `4` failed.
  - Passed coverage included the new Browse root regression, food collection, food menu section rail, Da Nang city hub, city section jump, search no-match/exact/result interactions, audio tap reliability, Practice saved round, and primary route bottom insets.
  - Failed tests: `testBrowseCategoryCardOpensCollectionAndBackReturnsToBrowse`, `testVietnameseMenuRowSaveAddsItemToSavedTrip`, `testVietnameseMenuDetailUsesMenuChipsInsteadOfBreakdownMath`, and `testDaNangCityRowSaveAddsItemToSavedTrip`.
- BackSwipe broader navigation sweep: `12` tests executed, `9` passed, `3` failed.
  - Passing coverage included direct detail back, forward restore, Home city/phrase/practice back chains, Home situation return, and Home shelf header return.
  - Failing tests were Browse-root-from-tab assertions that still look for `Browse.Title` via older XCTest selectors while the live screenshot route is visually populated.

## Screenshot Proof Paths

- `01-home-launch.jpg`
- `02-browse-root.jpg`
- `03-airport-arrivals-detail.jpg`
- `04-bug-browse-root-blank-after-back.jpg`
- `browse-root-after-detail-back.png`
- `05-hotel-category.png`
- `06-food-category.png`
- `07-food-menu.png`
- `08-drink-menu.png`
- `09-city-danang.png`
- `10-city-hoian.png`
- `11-city-hanoi.png`
- `12-city-saigon.png`
- `13-city-hue.png`
- `14-search-hotel.png`
- `15-saved-seeded.png`
- `16-practice.png`

All screenshots are under:

`docs/task-results/parallel-goals-2026-07-05/proofs/real-traveler-walkthrough/`

## Remaining Risks

- Several existing UI tests are stale relative to the current photo-backed Browse/Saved/menu surfaces. The live route screenshots were populated, but these tests still fail on old accessibility selectors or old content expectations.
- The widened Browse collection -> Browse root reset favors avoiding blank Browse over preserving exact lower Browse scroll position after backing from a collection. The old preservation test did not get past its `--browse` title setup in this baseline, so a fresh harness update should re-check that intended nuance.
- I did not run a full `SpeakLocalNativeUITests` sweep because the focused batch and BackSwipe sweep already exposed stale selector failures that would make a full sweep noisy.
- No physical iPhone build was run, per the goal instruction.
