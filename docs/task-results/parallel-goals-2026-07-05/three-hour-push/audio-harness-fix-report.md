# Audio Harness Fix Report

Date: 2026-07-05 (Asia/Manila)

## Scope

The post-fix visual worker found a reproducible red UI test on current `main`:

- `AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved`
- Failure: the Drink Menu coffee-row speaker button existed but was never considered hittable.

This was investigated as a test-path failure, not an app design or audio-manifest failure.

## Root Cause

The Drink Menu stress path launched the whole Drink Menu and immediately searched/dragged for the `Cà phê sữa đá` row audio button. Other Drink Menu tests first tap the visible `Coffee` section rail before asserting or interacting with coffee rows.

After the menu section/top-admin work, the direct scroll-only path was brittle. The real traveler path is:

1. open Drink Menu;
2. tap the `Coffee` section rail;
3. tap the coffee row audio button.

## Fix

Updated `native-ios/UITests/AudioTapReliabilityUITests.swift` so the Drink Menu row-audio stress case taps:

- `VietnameseMenu.SectionRail.coffee`
- waits for `VietnameseMenu.SectionTitle.coffee`
- then stresses `VietnameseMenu.Audio.viet-menu-drink-ca-phe-sua-da`

No app runtime code changed.

## Validation

Passed on isolated simulator `SpeakLocal Audio Harness`:

- single reproduced test:
  - `AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved`
  - `1` test, `0` failures
  - result bundle: `/tmp/speaklocal-audio-harness-single-1783255528.xcresult`
- full audio class:
  - `AudioTapReliabilityUITests`
  - `2` tests, `0` failures
  - result bundle: `/tmp/speaklocal-audio-harness-class-1783255691.xcresult`
- combined post-fix focused matrix:
  - `AudioTapReliabilityUITests`
  - `BrowseSearchUITests/testBackFromBrowseDetailRestoresBrowseRootContent`
  - `BrowseSearchUITests/testFastDoubleBackFromBrowseDetailRestoresBrowseRootContent`
  - `BrowseSearchUITests/testSearchCategoryResultHandsOffToBrowseCollection`
  - `BrowseSearchUITests/testSearchCityResultHandsOffToBrowseCollection`
  - `BrowseSearchUITests/testHoiAnBrowseByRestaurantCardJumpsToMatchingSection`
  - `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound`
  - `8` tests, `0` failures
  - result bundle: `/tmp/speaklocal-post-audio-mixed-1783255878.xcresult`

Fresh rerun before committing this report:

- first selector command:
  - `AudioTapReliabilityUITests`
  - `BrowseSearchUITests/testBackFromBrowseDetailRestoresBrowseRootContent`
  - `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound`
  - `4` tests, `0` failures
  - result bundle: `/Users/jojolim/Library/Developer/Xcode/DerivedData/SpeakLocalNative-ckdwludnenwmndfazdhqudhskoxq/Logs/Test/Test-SpeakLocalNative-2026.07.05_21-00-51-+0800.xcresult`
- stale selector correction:
  - the first fresh command used a few stale Browse/Search selector names, so only `4` tests executed; this was treated as under-coverage, not as a full matrix pass
- corrected Browse/Search selector command:
  - `BrowseSearchUITests/testCityBrowseCardJumpClearsTopAdminChrome`
  - `BrowseSearchUITests/testFastDoubleBackFromBrowseDetailRestoresBrowseRootContent`
  - `BrowseSearchUITests/testHoiAnBrowseByRestaurantCardJumpsToMatchingSection`
  - `BrowseSearchUITests/testSearchCategoryResultHandsOffToBrowseCollection`
  - `BrowseSearchUITests/testSearchCityResultHandsOffToBrowseCollection`
  - `5` tests, `0` failures
  - result bundle: `/Users/jojolim/Library/Developer/Xcode/DerivedData/SpeakLocalNative-ckdwludnenwmndfazdhqudhskoxq/Logs/Test/Test-SpeakLocalNative-2026.07.05_21-03-43-+0800.xcresult`

Current focused UI total from the fresh rerun: `9` unique tests, `0` failures.

## Disk Cleanup Note

The first validation attempt hit `No space left on device` while compiling asset catalogs. Generated `/tmp` result/derived-data artifacts and SpeakLocal Xcode DerivedData were cleared, freeing about `9 GB`. No source files or user assets were removed.
