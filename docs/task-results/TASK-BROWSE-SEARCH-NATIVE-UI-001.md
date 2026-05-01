# TASK-BROWSE-SEARCH-NATIVE-UI-001 Result

## Status

done

## Commit Hash

Recorded in the worker final reply after commit creation. The committed result file cannot know its own final Git hash before it is staged and committed.

## Native Browse Implemented

- Added a real `AppRoute.browse` root destination.
- Wired the bottom dock Browse item to the Browse route instead of opening `Xin chào`.
- Added a native Browse screen with masthead, situation cards, city shortcuts, Start here cards, compact Browse/search shortcut, phrase families, by-city shelf, and returning-user shelves that only appear when saved, practice, or recent state exists.
- Browse cards resolve through canonical `PhraseCatalog` pages rather than creating duplicate destination pages.

## Native Search Implemented

- Search now opens as a useful unfocused landing page with suggested needs, popular chips, city shortcuts, and likely-next rows.
- The keyboard appears only when the user taps the Search field or the explicit focused launch path is used for proof.
- Search supports results, filters, situation matches, city matches, related searches, and no-match recovery.
- Search chips and city chips prefill the query without forcing keyboard focus.
- The `train refund` recovery path presents try-instead chips, nearby travel needs, and Browse recovery.

## Simulator Proof Screenshots

- `docs/task-results/assets/TASK-BROWSE-SEARCH-NATIVE-UI-001/browse-default.png`
- `docs/task-results/assets/TASK-BROWSE-SEARCH-NATIVE-UI-001/browse-scrolled.png`
- `docs/task-results/assets/TASK-BROWSE-SEARCH-NATIVE-UI-001/search-default-no-keyboard.png`
- `docs/task-results/assets/TASK-BROWSE-SEARCH-NATIVE-UI-001/search-focused-keyboard.png`
- `docs/task-results/assets/TASK-BROWSE-SEARCH-NATIVE-UI-001/search-results-hotel.png`
- `docs/task-results/assets/TASK-BROWSE-SEARCH-NATIVE-UI-001/search-empty-recovery.png`

Proof was captured on the iPhone 17 Pro simulator after installing and launching the native app.

## Validation Commands And Outcomes

- `cd native-ios && xcodegen generate` -> passed.
- `git diff --check` -> passed for the scoped Browse/Search files and generated project file.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build` -> passed.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeTests/AppChromeTests` -> passed; 53 tests, 0 failures.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests` -> passed; 3 tests, 0 failures.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test` -> ran; failed outside the Browse/Search task scope.

## Full Suite Failures Observed

The full native suite still has failures in the dirty generated-content/resource state present in this worktree:

- `PhrasePageFixtureTests` -> 38 failures around missing generated catalog/detail fixture content and changed search-priority expectations.
- `SQLiteLanguagePackRepositoryTests` -> 2 failures: source phrase count expected `750` but observed `2100`, and the authored section list now includes `when-to-use` and `good-to-know`.
- `BackSwipeUITests` -> 2 tests failed with 6 assertions around legacy detail/back-swipe text expectations.

The new `BrowseSearchUITests` passed inside the full run.

## Known Gaps

- City chips intentionally prefill Search instead of opening city detail pages.
- Returning-user Browse shelves are empty for first-run users until saved, practice, or recent page state exists.
- Full-suite fixture failures should be handled by the existing content/resource task lane, not by this Browse/Search UI task.

## Recommended Next Task

Create a native Browse/Search polish task for city detail pages, tighter Browse dock tap UI coverage, and final copy/spacing passes after the generated content-resource worktree is reconciled.
