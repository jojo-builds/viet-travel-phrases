# TASK-NATIVE-HERO-MASTHEAD-FADE-CROP-001

## Summary

Adjusted the native listing masthead image rendering so page-specific hero images can keep their natural crop and fade smoothly into the phrase page background.

The immediate fix targets the Bà Nà Hills page, where the Golden Bridge asset was rendering as a hard image strip with little visible fade. The default Vietnam masthead still keeps the existing lifted crop used by the Xin chào page.

## Changes

- `HeroMastheadImage` now resolves the default vertical crop by image name.
- `HeroBaNaHills` uses a neutral crop offset so the Golden Bridge remains visible.
- The masthead fade now spans the full image area and finishes with a stronger bottom blend into `PhrasePageStyle.pageBackground`.
- No content, audio, project signing, or generated Viet resources were changed.

## Proof

- Bà Nà Hills hero proof: `docs/task-results/assets/TASK-NATIVE-HERO-MASTHEAD-FADE-CROP-001/ba-na-hero.png`
- Xin chào regression proof: `docs/task-results/assets/TASK-NATIVE-HERO-MASTHEAD-FADE-CROP-001/xin-chao-hero.png`

## Validation

- `git diff --check`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`

