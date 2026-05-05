# TASK-NATIVE-CITY-TRAVEL-MODE-HUB-001

## Summary

Implemented a native city-page Travel Mode hub for Browse city collections, with Da Nang as the primary acceptance target.

City pages no longer render as the generic collection phrase-feed surface. They now start with traveler situation cards, followed by a city practice card, curated names, curated quick phrases, and lower-priority browse groups.

## What Changed

- Added `BrowseCityHub` metadata to city collection descriptors.
- Added city situation cards with `What are you doing?` as the primary city-page decision point.
- Updated Da Nang copy:
  - `Airport arrivals, beach rides, river landmarks, markets, and day trips.`
  - `Practice a Da Nang day`
  - `Airport pickup, beach drop-off, food, and a ride back.`
- Added curated Da Nang `Names to know` rows for airport, beach, landmarks, and streets.
- Added curated Da Nang `Quick phrases` rows for airport, beach drop-off, Dragon Bridge, taxi help, and bathroom.
- Moved raw city browsing lower under `Browse Da Nang`.
- Added a neutral masthead fallback for city pages without an owned city-specific image, so Da Nang does not show unrelated Vietnam imagery.
- Hid unavailable row audio controls on collection rows by showing a neutral symbol chip instead of a dead speaker button.

## Proof

- Screenshot: [danang-city-hub-top.png](assets/TASK-NATIVE-CITY-TRAVEL-MODE-HUB-001/danang-city-hub-top.png)

## Validation

- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests/testDaNangCityDescriptorUsesTravelModeHubInsteadOfPhraseFeed -only-testing:SpeakLocalNativeTests/AppChromeTests/testBrowseCollectionDescriptorsExposeStarterRowsAndPracticePolicy`
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests/testDaNangCityCollectionRendersTravelModeHub`
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests`
- `git diff --check`

All passed.

## Notes

- This is a native Browse/city-page renderer fix. It does not rewrite authored phrase content, generate audio, regenerate SQLite/resources, or change signing/project settings.
- Situation cards currently route into existing collection routes. City-specific filtered subroutes can be added later if needed.
