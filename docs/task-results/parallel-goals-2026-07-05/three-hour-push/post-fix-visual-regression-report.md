# Post-Fix Visual Regression Report

Date: 2026-07-05 (Asia/Manila)

## Scope

Ran a post-fix visual and functional regression pass against exact-current `main` after:

- `2834a52af` - stale photo backdrop route fix
- `48c608b92` - rapid audio tap stabilization merge
- `4f6462906` - active playback stress hardening

No app-code branch was created. No app code was edited.

## Tested Build

- Branch: `main`
- Commit: `4f6462906579e1130a78b8ce6976b0eee3ed9024`
- Simulator: `SpeakLocal Post Fix Visual`
- Simulator: `SpeakLocal Post Fix Visual`
- Build/install/launch: passed via XcodeBuildMCP `build_run_sim`
- Build log: `docs/task-results/parallel-goals-2026-07-05/three-hour-push/post-fix-visual-regression-proof/test-logs/build-run-sim.log`

## Screenshot Proof

Saved under `docs/task-results/parallel-goals-2026-07-05/three-hour-push/post-fix-visual-regression-proof/`:

- `01-home.jpg` - Home render
- `02-browse-root.jpg` - Browse root
- `03-browse-collection-after-detail-back.jpg` - Eating Out collection after opening a detail and returning
- `04-search-coffee-results.jpg` - direct Search query for `coffee`
- `05-search-result-routed-drink-menu.jpg` - Search result routed to Drink Menu Browse page
- `06-hoi-an-city-route-top.jpg` - Hoi An city route top state
- `07-hoi-an-restaurants-section-jump.jpg` - Hoi An city section jump to `Restaurants`
- `08-saved.jpg` - Saved screen empty/trip-save state
- `09-practice-round-sheet.jpg` - Practice round sheet
- `10-practice-after-rapid-audio-taps.jpg` - Practice sheet after 8 rapid audio taps across visible speaker controls
- `11-browse-category-direct-launch-empty-ax.jpg` - manual visual evidence for the direct Drink Menu launch used by the failing audio test

## Tests Run

Combined focused run:

- Log: `post-fix-visual-regression-proof/test-logs/focused-ui-plus-audio.log`
- Original MCP result bundle: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/result-bundles/test_sim_2026-07-05T12-34-32-006Z_pid28732_3108e25f.xcresult`
- Result: `7` passed, `1` failed

Passed:

- `BrowseSearchUITests/testBackFromBrowseDetailRestoresBrowseRootContent`
- `BrowseSearchUITests/testFastDoubleBackFromBrowseDetailRestoresBrowseRootContent`
- `BrowseSearchUITests/testSearchCategoryResultHandsOffToBrowseCollection`
- `BrowseSearchUITests/testSearchCityResultHandsOffToBrowseCollection`
- `BrowseSearchUITests/testHoiAnBrowseByRestaurantCardJumpsToMatchingSection`
- `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound`
- `AudioTapReliabilityUITests/testBreakdownAudioCardsStayResponsiveAcrossTargetPages`

Failed:

- `AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved`
- Failure: `Element was not hittable: "VietnameseMenu.Audio.viet-menu-drink-ca-phe-sua-da" Any or "Play phrase audio" Button`
- Status after orchestrator update: this red result is pre-test-harness-fix evidence. The orchestrator later reproduced the failure, aligned the Drink Menu stress test with the real user path by tapping the Coffee section rail before stressing the coffee row audio button, and reported green post-fix proof for both the single test and the full `AudioTapReliabilityUITests` class (`2` tests, `0` failures) in the orchestrator lane.

Rerun of failing test only:

- Log: `post-fix-visual-regression-proof/test-logs/audio-row-rerun.log`
- Original MCP result bundle: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/result-bundles/test_sim_2026-07-05T12-38-58-131Z_pid28732_3343fac0.xcresult`
- Result: failed again with the same hittability failure before the orchestrator's test-harness fix.

## Findings

Earlier blank-route defects did not reproduce in the fresh simulator pass:

- Browse detail back: not reproduced. Manual route returned to a populated Eating Out collection, and both focused Browse back tests passed.
- Fast double-back Browse path: focused test passed.
- Blank/empty Search query/result routing: not reproduced. `coffee` query rendered results, and the Search-to-Drink-Menu route opened populated Browse content.
- Search category/city handoff: both focused tests passed.
- Hoi An city Browse-by/section jump: passed in focused test and manual screenshot proof shows `Restaurants` section visible below the top chrome.
- Practice sheet top clearance/controls: passed focused saved-practice test; manual Practice round screenshot shows controls and content visible.
- Top Back/Forward route chrome: manual Browse detail return showed coherent Back/Forward chrome; city section jump retained coherent top chrome.

Audio findings:

- Manual rapid taps on the visible Practice round sheet completed successfully; the visible audio buttons remained present/actionable afterward.
- Breakdown audio reliability test passed.
- Pre-harness-fix row audio evidence was red: the direct Drink Menu row audio test reproducibly failed on `VietnameseMenu.Audio.viet-menu-drink-ca-phe-sua-da` hittability.
- The direct Drink Menu visual route itself was not blank. `11-browse-category-direct-launch-empty-ax.jpg` shows the Drink Menu page, first row, and speaker button visible. This narrowed the issue to test-path/hittability behavior, not a visual blank-page regression.
- Orchestrator follow-up resolved the row-audio test-harness path by tapping the Coffee section rail before stressing the coffee row audio button. The orchestrator reports post-fix audio-class proof is green: single row-audio test passed and full `AudioTapReliabilityUITests` class passed with `2` tests and `0` failures.

## Blockers vs Follow-Ups

Pre-harness-fix blocker:

- `AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved` reproducibly failed during this visual-regression worker's run.

Follow-ups:

- No app-code change was made by this worker.
- Orchestrator reports the row-audio test-harness fix and green post-fix audio-class proof in the main/orchestrator lane.

## Verdict

Post-fix visual regression pass is complete. This worker's audio-row red result is retained as pre-test-harness-fix evidence.

The previously reported blank Browse/Search/city/Practice route defects did not reproduce on exact-current `main` in this simulator pass, and the focused Browse/Search/Practice tests passed. Orchestrator subsequently reported green post-fix proof for the row-audio failure after aligning the Drink Menu stress test with the real Coffee-section user path.
