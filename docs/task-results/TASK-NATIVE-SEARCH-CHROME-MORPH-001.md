# TASK-NATIVE-SEARCH-CHROME-MORPH-001 Result

## Status

Done. The expanded Search field and bottom admin chrome now share a safer morph layer policy so Search owns the active glass morph while the dock yields or returns underneath it.

## Commit Hash

`7e5f678c`

## Root Cause

- The route behavior was correct, but the visual layering treated the returning admin dock as higher priority than the Search glass.
- During Search to Home or Browse, the dock could appear above the still-shrinking Search field, making two Liquid Glass surfaces look like they were racing or overlapping.
- The previous chrome z-index values were inline literals, so the intended Search-over-dock layering was not test-pinned.

## Animation Behavior Changed

- `AppChromeLayout` now owns explicit morph z-index values for the dock, search origin button, search field/island, and keyboard dismiss button.
- The Search field/collapsed Search island sits above the returning dock during both expansion and collapse.
- The left return icon remains below the Search field but above the dock, preserving the previous admin-route icon behavior without letting it cover the text field.
- Keyboard-up Search remains unchanged: no wordy Cancel button, no duplicate clear button, and the existing compact dismiss/clear button stays above the Search field when focused.
- The bottom chrome hit-test envelope from the previous task remains intact.

## Files Changed

- `native-ios/App/Design/NativeGlass.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/Tests/AppChromeTests.swift`
- `native-ios/UITests/AdminChromeUITests.swift`
- `docs/task-results/TASK-NATIVE-SEARCH-CHROME-MORPH-001.md`
- `docs/task-results/assets/TASK-NATIVE-SEARCH-CHROME-MORPH-001/*.png`

## Simulator Proof Artifacts

- `docs/task-results/assets/TASK-NATIVE-SEARCH-CHROME-MORPH-001/home-collapsed.png`
- `docs/task-results/assets/TASK-NATIVE-SEARCH-CHROME-MORPH-001/home-search-expanded.png`
- `docs/task-results/assets/TASK-NATIVE-SEARCH-CHROME-MORPH-001/home-return-immediate.png`
- `docs/task-results/assets/TASK-NATIVE-SEARCH-CHROME-MORPH-001/home-return-final.png`
- `docs/task-results/assets/TASK-NATIVE-SEARCH-CHROME-MORPH-001/browse-collapsed.png`
- `docs/task-results/assets/TASK-NATIVE-SEARCH-CHROME-MORPH-001/browse-search-expanded.png`
- `docs/task-results/assets/TASK-NATIVE-SEARCH-CHROME-MORPH-001/browse-return-immediate.png`
- `docs/task-results/assets/TASK-NATIVE-SEARCH-CHROME-MORPH-001/browse-return-final.png`

All proof screenshots are simulator PNGs at 1206 x 2622. The immediate-return screenshots are best-effort XCTest frames after tapping the origin icon; the stronger proof for the mid-transition policy is the new z-index unit test plus the UI round-trip coverage.

## Validation

- `git status --short` before edits: unrelated modified content audit files were present and left untouched.
- Red test check: `AppChromeTests/testSearchChromeMorphKeepsSearchGlassAboveReturningDock` failed before production constants existed with missing `AppChromeLayout` members.
- `xcodegen generate`: skipped; no new Swift files or project membership changes.
- `git diff --check`: passed.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`: passed.
- Focused unit check for `testSearchChromeMorphKeepsSearchGlassAboveReturningDock`: passed.
- Proof UI test `AdminChromeUITests/testSearchChromeMorphHomeAndBrowseProofScreenshots`: passed and generated eight screenshots.
- Targeted native suite passed: `AppChromeTests` 69 tests, `AdminChromeUITests` 6 tests, `BackSwipeUITests` 3 tests, all 0 failures.

## Self-Review Outcome

PASS. The change is scoped to shared chrome layering and proof/test code. Search glass now renders above dock glass during the morph, the origin icon remains route-specific for Home, Browse, Saved, and Practice, bottom chrome hit testing was not weakened, and keyboard-up Search behavior was not redesigned. No generated content resources, SQLite data, audio files, mascot assets, signing settings, or project files were changed.

## Remaining Risks

- XCTest cannot deterministically freeze a true mid-animation frame; the proof harness captures stable before/expanded/immediate/final frames and pins the actual overlap prevention as a z-order policy.
- A quick physical-device visual pass is still useful because this was originally noticed by eye.

## Final `git status --short`

```text
 M content-draft/viet/canonical-pages/tier-one/_tier-one-index.json
 M content-draft/viet/city-library/v1.json
 M content-draft/viet/practice/practice-deck.sample.json
 M docs/content-audits/viet-canonical-content-audit-001/README.md
 M docs/content-audits/viet-canonical-content-audit-001/issue-summary.json
 M native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json
 M native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite
 M native-ios/Resources/viet-authored-audio-audit.json
 M native-ios/Resources/viet-authored-listing-pages.json
 M native-ios/Resources/viet-phrase-catalog.json
 M native-ios/scripts/generate-authored-tier-one-pages.js
 M native-ios/scripts/generate-viet-catalog.js
 M native-ios/scripts/generate-viet-sqlite-fixture.js
 M native-ios/scripts/sqlite/001_initial.sql
 M native-ios/scripts/validate-viet-city-library.js
 M native-ios/scripts/validate-viet-sqlite-fixture.js
 M prototypes/practice-quiz/practice-deck.sample.json
 M scripts/practice/generate-viet-practice-deck.js
```

All entries above are unrelated pre-existing or concurrent content/resource/practice work and were left unstaged. No scoped Search chrome morph changes remain uncommitted.
