# Post-Fix Visual Regression Goal

## Objective

Run a post-fix traveler-grade visual and functional regression pass against exact-current `main` after these commits:

- `2834a52af` - stale photo backdrop route fix
- `48c608b92` - rapid audio tap stabilization merge
- `4f6462906` - active playback stress hardening

The core question is whether the user-visible blockers reported earlier still reproduce on current `main`, especially:

- blank backdrop after Browse detail back;
- blank or empty Search query/result routing;
- city Browse-by cards and section jumps;
- Practice sheet top clearance and controls;
- audio speaker controls remaining hittable after repeated taps;
- top Back/Forward route chrome remaining coherent.

## Constraints

- Work from `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Treat `main` as the app truth.
- Do not touch `feature/paywall` or merge paywall.
- Do not edit app code unless you first create a feature branch/worktree from current `main`.
- Use a dedicated simulator, not the same simulator as another active worker.
- Screenshot proof matters. Accessibility-only proof is not enough for visual claims.
- Do not claim production readiness from a subset of green tests.

## Suggested Validation

- Build and launch `SpeakLocalNative` on a dedicated simulator.
- Capture screenshots for Home, Browse root, a Browse collection after detail back, direct Search query, Search result route, one city page Browse-by jump, Saved, and Practice round sheet.
- Run focused tests where useful:
  - `BrowseSearchUITests/testBackFromBrowseDetailRestoresBrowseRootContent`
  - `BrowseSearchUITests/testFastDoubleBackFromBrowseDetailRestoresBrowseRootContent`
  - `BrowseSearchUITests/testSearchCategoryResultHandsOffToBrowseCollection`
  - `BrowseSearchUITests/testSearchCityResultHandsOffToBrowseCollection`
  - `BrowseSearchUITests/testHoiAnBrowseByRestaurantCardJumpsToMatchingSection`
  - `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound`
  - `AudioTapReliabilityUITests` only if you can give it enough time and preserve logs.

## Report

Write or append a separate report:

`docs/task-results/parallel-goals-2026-07-05/three-hour-push/post-fix-visual-regression-report.md`

Include:

- exact branch and commit tested;
- simulator used;
- screenshots saved;
- tests run and pass/fail/inconclusive status;
- whether earlier blank-route defects still reproduce;
- blockers vs follow-ups;
- any code branch created and whether it was merged.
