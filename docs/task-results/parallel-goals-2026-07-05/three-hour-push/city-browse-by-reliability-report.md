# City Browse-by Reliability Report

Date: 2026-07-05
Branch checked: `main`
Commit checked: `4f6462906`
Simulator: `SpeakLocal Browse`

## Result

Current `main` passes the focused city Browse-by reliability matrix. I did not create a feature lane and did not leave any app or test-code diff.

The strongest current hypothesis is that the mixed QA signal came from a stale pre-fix build/test result. Current `main` has the expected reliability shape:

- city Browse-by card taps call `selectCityBrowseGroup`, set the selected city card, and scroll directly to `BrowseCityBrowseScrollID.group(filter.id)` with the city jump viewport anchor in `native-ios/App/Views/BrowseCollectionPageView.swift:539`;
- each city noun group has a direct non-lazy scroll marker immediately before the rendered group in `native-ios/App/Views/BrowseCollectionPageView.swift:1144`;
- the UI tests cover Da Nang card jump, Hoi An restaurant jump, top-admin clearance, and top-section-menu jump behavior in `native-ios/UITests/BrowseSearchUITests.swift:746`.

## Repro Steps Verified

1. Launch `--browse-city danang`.
2. Tap `BrowseCollection.CityFilter.danang.browse.landmarks`.
3. Confirm the matching `BrowseCollection.CityGroup.danang.browse.landmarks` appears and clears the top admin chrome.
4. Launch `--browse-city hoian`.
5. Tap `BrowseCollection.CityFilter.hoian.browse.restaurants`.
6. Confirm the matching `BrowseCollection.CityGroup.hoian.browse.restaurants` appears and clears the top admin chrome.
7. Launch `--browse-city danang`, scroll until `BrowseCollection.TopSectionPill` appears, choose `Restaurants`, then confirm the pill value and `BrowseCollection.CityGroup.danang.browse.restaurants`.

## Validation

Passed:

- `git diff --check`
- `node scripts/guard-native-only.js`
- Focused UI matrix, 4 tests / 0 failures:
  - `testCityBrowseCardSelectionJumpsToMatchingSection`
  - `testHoiAnBrowseByRestaurantCardJumpsToMatchingSection`
  - `testCityBrowseCardJumpClearsTopAdminChrome`
  - `testBrowseCityTopSectionPillJumpsToNounGroup`
  - xcresult: `native-ios/artifacts/DerivedData-city-browse-main/Logs/Test/Test-SpeakLocalNative-2026.07.05_20-22-40-+0800.xcresult`
- Screenshot proof reruns:
  - `testHoiAnBrowseByRestaurantCardJumpsToMatchingSection`, 1 test / 0 failures
    - xcresult: `native-ios/artifacts/DerivedData-city-browse-main/Logs/Test/Test-SpeakLocalNative-2026.07.05_20-28-38-+0800.xcresult`
  - `testBrowseCityTopSectionPillJumpsToNounGroup`, 1 test / 0 failures
    - xcresult: `native-ios/artifacts/DerivedData-city-browse-main/Logs/Test/Test-SpeakLocalNative-2026.07.05_20-30-46-+0800.xcresult`

Proof screenshots:

- `docs/task-results/parallel-goals-2026-07-05/three-hour-push/city-browse-by-reliability-proof/hoian-restaurants-after-browse-by-jump.png`
- `docs/task-results/parallel-goals-2026-07-05/three-hour-push/city-browse-by-reliability-proof/danang-restaurants-top-section-pill-jump.png`

## Files Changed

No app code changed.

New report/proof artifacts only:

- `docs/task-results/parallel-goals-2026-07-05/three-hour-push/city-browse-by-reliability-report.md`
- `docs/task-results/parallel-goals-2026-07-05/three-hour-push/city-browse-by-reliability-proof/hoian-restaurants-after-browse-by-jump.png`
- `docs/task-results/parallel-goals-2026-07-05/three-hour-push/city-browse-by-reliability-proof/danang-restaurants-top-section-pill-jump.png`

Temporary screenshot hooks were added to `native-ios/UITests/BrowseSearchUITests.swift` only during proof capture and then fully removed. Final `git diff -- native-ios/UITests/BrowseSearchUITests.swift` is empty.

## Merge Safety

Safe to merge as a report/proof artifact. No feature branch or app-code merge is required for this goal, and paywall remains isolated on `feature/paywall`.
