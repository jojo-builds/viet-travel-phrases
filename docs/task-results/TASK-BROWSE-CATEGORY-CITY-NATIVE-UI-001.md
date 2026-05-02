# TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001 Result

## Status

done

## Commit Hash

Recorded in the worker final reply after commit creation. The committed result file cannot know its own final Git hash before it is staged and committed.

## Native Browse Collections Implemented

- Added real `AppRoute.browseCollection(BrowseCollectionRoute)` destinations for category and city collection pages.
- Browse category and city cards now open Browse-owned collection pages instead of phrase-detail stand-ins or plain Search results.
- Collection pages include asset-catalog mastheads, subcategory cards, starter phrase rows, Practice entry, and Explore shelves.
- Bottom chrome stays on Browse for collection pages, and phrase rows continue to open canonical phrase pages.

## Search Handoff Implemented

- Search now surfaces a `Best match` Browse collection card above phrase rows when a query strongly matches a category or city.
- Opening a collection from Search closes Search and hands off to the Browse collection route.
- City and category Search results share the same Browse collection pages as Browse cards.

## Performance Notes

- Collection descriptors are cached by `BrowseCollectionRoute`, so page grouping and starter/explore row shaping happen once per route open instead of during SwiftUI body recomputation.
- City collection rows use a narrow SQLite adapter cached by city ID, returning lightweight row models from the bundled database with a `PhraseCatalog` fallback.
- `BrowseCollectionPageView` receives explicit value inputs and renders with `LazyVStack` / `LazyHStack`; no SQLite queries, sorting, filtering, or row grouping run inside the collection view body.
- Mastheads are bundled asset-catalog PNGs cropped/downsampled for screen-top display; there is no network image loading or runtime image generation.

## Simulator Proof Screenshots

- `docs/task-results/assets/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001/browse-root.png`
- `docs/task-results/assets/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001/airport-category.png`
- `docs/task-results/assets/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001/hotel-category.png`
- `docs/task-results/assets/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001/food-category.png`
- `docs/task-results/assets/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001/hanoi-city.png`
- `docs/task-results/assets/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001/collection-scrolled.png`
- `docs/task-results/assets/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001/search-hotel-category.png`
- `docs/task-results/assets/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001/search-hanoi-city.png`
- `docs/task-results/assets/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001/practice-entry.png`

Proof was captured on the iPhone 17 Pro simulator after installing and launching the native app.

## Validation Commands And Outcomes

- `cd native-ios && xcodegen generate` -> passed.
- `git diff --check` -> passed.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build` -> passed.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeTests/AppChromeTests -only-testing:SpeakLocalNativeTests/LocalUserIntentStoreTests` -> passed; 66 tests, 0 failures.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests` -> passed; 7 tests, 0 failures.
- Screenshot proof harness -> passed; 1 screenshot-only UI test, 0 failures. The temporary harness was removed before the scoped commit.

## Known Gaps

- Dedicated new mastheads were added for Airport, Hotel, Food, Shopping, and Hanoi. Secondary categories and cities still use existing/fallback mastheads until the full image inventory lands.
- Search collection matching is intentionally lightweight local matching, not a new ranking engine.
- The full native suite was not rerun for this task; targeted route, Search handoff, Practice policy, UI, screenshot, and build validation passed. The worktree also contains unrelated generated-content/resource drift outside this task.

## Recommended Next Task

Add the remaining city/category masthead inventory and expand collection descriptors across all nineteen scenario categories after the current generated-content/resource drift is reconciled.
