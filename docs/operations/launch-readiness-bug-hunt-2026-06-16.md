# Viet Launch Readiness Bug Hunt - 2026-06-16

## Summary

Recommendation: **PASS_WITH_FOLLOW_UPS** for the simulator-tested native Vietnam app paths in this feature lane.

Branch: `feature/launch-readiness-bug-hunt-20260616`
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/launch-readiness-bug-hunt-20260616`
Objective baseline main commit: `90a9f6437`
Validated feature-lane pre-commit head: `414fe53ce` plus the working-tree fixes described here
Simulator: `SpeakLocal Launch Bug Hunt`, iPhone 17 Pro, iOS 26.5
Physical iPhone: not used, by assignment. Final `main` device proof remains an orchestrator responsibility after merge.
Paywall: excluded, by assignment.

No launch-blocking issue remains in the tested simulator paths. The bug hunt found and fixed four safe issues: awkward relationship-form Practice copy, production QA `--check` artifact writes, stale city V2.2 test expectations, and Vietnamese menu bottom-scroll clearance validation.

## Walkthrough Coverage

Manual simulator coverage used the dedicated simulator and fresh screenshots for:

- Home first launch: hero/backdrop readability, shelf hierarchy, bottom chrome, static top chrome.
- Browse root: category cards, city cards, label wrapping, bottom chrome separation.
- Browse Eating Out: category route, subcategory cards, phrase rows, first audio tap.
- Detail page: coffee article route with hero, audio dock, At a glance, Break it down.
- Search: opened from detail, typed `hotel`, verified keyboard/result readability, opened hotel collection.
- City/place: Da Nang city top, dense landmarks rows, Ba Na Hills detail page, V2.2 heading/phrase rows.
- Practice: root page, topic/start flow, wrong-pair/completion surface, Saved-to-Practice launch.
- Saved: seeded returning-user shelves and Start Practicing route.
- Settings/More: audio speed, Send Feedback, Contact Support, Privacy Policy, Terms of Use.
- Audio/chrome: inline audio and repeated breakdown audio taps; bottom chrome and top shield regression checks.

Screenshots:

- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/01-home-initial.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/02-browse-root.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/03-browse-eating-out.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/04-detail-coffee.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/05-search-hotel-results.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/06-city-danang-top.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/07-city-danang-landmarks.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/08-place-ba-na-hills.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/09-practice-root.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/10-practice-round-awkward-copy.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/11-practice-complete-awkward-copy.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/12-saved-root.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/13-more-settings.jpg`
- `docs/operations/launch-readiness-bug-hunt-2026-06-16-assets/14-practice-copy-fixed-detail.jpg`

## Fixed Issues

### SAFE_FIX_NOW: Practice Relationship Copy

Observed Practice round/completion copy used awkward English such as `How are you, older man?`.

Fix:

- Updated source copy to `How are you? (to an older man)`, `How are you? (to an older woman)`, and `How are you? (to someone younger)`.
- Regenerated native catalog, authored listing pages, audio audit, breakdown audit, and SQLite fixture from source.
- Added `native-ios/scripts/viet-practice-copy.test.js`.
- Updated related search-only and listing-backdrop audit fixtures so validators match the current source contract.

Proof:

- Screenshot `14-practice-copy-fixed-detail.jpg` shows the fixed direct detail label.
- `node --test ./native-ios/scripts/audit-viet-listing-production-qa.test.js ./native-ios/scripts/viet-practice-copy.test.js` passed.
- `node native-ios/scripts/validate-viet-search-only-surfacing.js` passed.

### SAFE_FIX_NOW: Production QA Check Mode Wrote Artifacts

Reproduced `node native-ios/scripts/audit-viet-listing-production-qa.js --check` rewriting `docs/content-audits/viet-listing-production-qa-001/summary.json`.

Fix:

- Changed `native-ios/scripts/audit-viet-listing-production-qa.js` so `--check` validates without calling `writeOutputs`.
- Added `native-ios/scripts/audit-viet-listing-production-qa.test.js`.

Proof:

- `node native-ios/scripts/audit-viet-listing-production-qa.js --check` now reports `checked` and leaves the summary artifact clean.

### SAFE_FIX_NOW: Vietnamese Menu Bottom Clearance

Focused UI testing found `BottomInsetUITests.testRepresentativeCollectionAndDetailRoutesKeepBottomContentAboveSystemTabBar` could not validate the Vietnamese food menu bottom sentinel. The menu page had bottom padding but no addressable clearance scroll target.

Fix:

- Added `AppBottomClearanceScrollTarget` after the Vietnamese menu bottom sentinel in both standard and photo-backdrop menu layouts, replacing unaddressable bottom padding with a scroll target that preserves visual clearance.

Proof:

- `SpeakLocalNativeUITests/BottomInsetUITests` passed: 2 passed, 0 failed.

### SAFE_FIX_NOW: City V2.2 Unit Fixture Drift

Focused unit tests found stale expected headings/snippets for four V2.2 city pages, while the current strict-production source validator passed all 520 entries.

Fix:

- Updated `native-ios/Tests/AppChromeTests.swift` expected headings/snippets/phrase IDs to match current `speaklocal.place.app-detail.v2.2` source truth.

Proof:

- Focused `SpeakLocalNativeTests` run passed: 29 passed, 0 failed, 1 skipped.

## Follow-Ups

- Search implementation still has main-actor work that should be profiled on device before a stronger performance claim. No search typing lag was observed in the tested simulator paths.
- First audio playback still does some synchronous setup; repeated breakdown audio taps did not hang in UI testing.
- Browse/Home descriptor first render and Saved/Practice state fanout are worth profiling before App Store submission, but no user-visible jank was reproduced here.
- Page-level hero audio has planned missing rows. Current validation reports 0 release-blocking visible-audio misses and 778 planned missing-audio audit rows.
- Search query `how are you older man` can still surface place-name matches containing `man`; the visible title copy is now fixed, so this is a ranking follow-up rather than a launch blocker.
- Some accessibility snapshots expose selectable body text as text-field-like nodes and Practice sheet snapshots include underlying root elements. No visible blocker was found; run a dedicated accessibility audit later.

## Validation

Node/resource validation:

- `node native-ios/scripts/audit-viet-listing-production-qa.js --check` - passed; 1793 pages, 0 blockers, 0 majors.
- `node --test ./native-ios/scripts/audit-viet-listing-production-qa.test.js ./native-ios/scripts/viet-practice-copy.test.js` - passed; 2 tests.
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production` - passed; 520 pass, 0 revise, 0 fail.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` - passed; 1793 canonical pages, 11728 relations, 0 release-blocking missing-audio rows.
- `node native-ios/scripts/validate-tier-one-listing-pages.js` - passed; 150 strong, 0 thin/awkward/placeholder.
- `node native-ios/scripts/validate-vietnamese-menu-copy.js` - passed; 355 handwritten menu item pages.
- `node native-ios/scripts/validate-viet-search-only-surfacing.js` - passed; 315 rows, 315 generated relations, 315 section items.
- `node native-ios/scripts/guard-native-chrome.js` - passed.
- `node scripts/guard-native-only.js` - passed.
- `git diff --check` - passed.

XcodeBuildMCP simulator validation:

- `build_run_sim` - passed after fixes.
  - Build log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/build_run_sim_2026-06-16T03-57-48-093Z_pid74122_81429287.log`
  - Runtime log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/app.speaklocal.vietnam.native_2026-06-16T03-57-55-327Z_helperpid34151_ownerpid74122_aaf63fb8.log`
  - OS log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/app.speaklocal.vietnam.native_oslog_2026-06-16T03-57-55-992Z_helperpid34254_ownerpid74122_0f93bd8b.log`
- Focused unit tests - passed; 29 passed, 0 failed, 1 skipped.
  - Log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-06-16T03-48-09-926Z_pid74122_6b5142d9.log`
- `SpeakLocalNativeUITests/BottomInsetUITests` - passed; 2 passed, 0 failed.
  - Log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-06-16T03-54-45-490Z_pid74122_3a5db6a5.log`
- Targeted UI slices for audio, Browse/Search, Browse-launched Practice, and Saved Practice - passed; 5 passed, 0 failed.
  - Log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-06-16T03-56-08-767Z_pid74122_ae1e5c58.log`

Known failed-then-fixed evidence:

- Initial UI run found the Vietnamese food-menu bottom sentinel failure.
  - Log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-06-16T03-48-46-385Z_pid74122_dfcabc6b.log`
- Initial focused unit run found stale V2.2 fixture expectations.
  - Log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-06-16T03-46-21-616Z_pid74122_5c3128a2.log`

## Ship Recommendation

Ship recommendation for this feature-lane simulator pass: **PASS_WITH_FOLLOW_UPS**.

The tested app paths are launch-ready enough to merge after review. No hard blocker remains from the simulator walkthrough. Before final App Store confidence, orchestrator should merge the lane, build current `main` on Jojo's physical iPhone when available, and refresh operational release truth from `main`.
