# TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001 Result

Status: done

Implementation commit: `3675b9770ea9b7481c80d0d83af59152033020ec`

## What Changed

- Added a production-safe, app-owned generated Dragon Bridge hero asset:
  - `native-ios/Resources/Assets.xcassets/HeroDragonBridge.imageset/hero-dragon-bridge.png`
  - `native-ios/Resources/Assets.xcassets/HeroDragonBridge.imageset/Contents.json`
- Wired Dragon Bridge page metadata to `HeroDragonBridge`:
  - `content-draft/viet/city-library/v1.json`
  - `native-ios/Resources/viet-authored-listing-pages.json`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- Updated the Dragon Bridge validator so this hero is now required for source, authored resource, SQLite, and asset-catalog coverage.
- Captured simulator proof:
  - `docs/task-results/assets/TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001/dragon-bridge-hero-simulator.png`

## Asset Source And Ownership

- Source: Codex built-in image generation, not a scraped or third-party web photo.
- Original generated file: `/Users/jojolim/.codex/generated_images/019dd8a5-b9f2-7812-b54f-fbc8f75e3e6f/ig_07a6e835132ec8740169f97235d5a48191adfb42d46636298e.png`
- Repository asset: `native-ios/Resources/Assets.xcassets/HeroDragonBridge.imageset/hero-dragon-bridge.png`
- Asset dimensions: `853 x 1844`.
- Visual inspection: Dragon Bridge-specific Da Nang river scene; no watermark, no baked-in text, no logos, no uncertain external-photo dependency.

## Phone Proof

- Simulator: iPhone 17 Pro, `91BDCCB0-0728-40AB-8150-B6DCB96BE799`
- Launch route: `--detail-page viet-phrase-city-danang-place-dragon-bridge`
- Phone test term: `Cầu Rồng`
- Proof screenshot shows the Dragon Bridge hero above the `Cầu Rồng` / `Dragon Bridge` page.

## Validation

Clean task-only verification worktree:

- `node native-ios/scripts/validate-viet-dragon-bridge-landmark-copy.js` passed.
- `node native-ios/scripts/validate-viet-city-library.js` passed: 750 pages.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed.
- `node native-ios/scripts/validate-tier-one-listing-pages.js` passed: 150 strong, 0 failing rows.
- `node native-ios/scripts/audit-viet-canonical-content.js --check` passed: 3070 canonical pages, all PASS.
- `node scripts/practice/generate-viet-practice-deck.js --check` passed: 7186 items.
- `git diff --check` passed.

Main worktree verification:

- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination id=91BDCCB0-0728-40AB-8150-B6DCB96BE799 -derivedDataPath /tmp/speaklocal-dragonbridge-derivedData build` passed.
- `git diff --cached --check` passed before commit.
- `git diff --check` passed before commit.
- Staged scope check confirmed no changes under:
  - `native-ios/Resources/Audio`
  - `native-ios/project.yml`
  - `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`

## Scope Notes

- No audio was generated or changed.
- No signing, provisioning, or Xcode project settings were changed.
- Canonical page IDs and titles were preserved:
  - canonical phrase ID: `city-danang-place-dragon-bridge`
  - authored page ID: `viet-family-city-danang-place-dragon-bridge`
  - runtime canonical page ID: `viet-phrase-city-danang-place-dragon-bridge`

The live worktree still contains unrelated unstaged city-library/generator output that was intentionally left out of this commit:

```text
 M content-draft/viet/canonical-pages/tier-one/_tier-one-index.json
 M native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json
 M native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite
 M native-ios/Resources/viet-authored-audio-audit.json
 M native-ios/Resources/viet-authored-listing-pages.json
 M native-ios/scripts/generate-authored-tier-one-pages.js
 M native-ios/scripts/repair-viet-breakdown-glosses.js
 M native-ios/scripts/validate-viet-city-library.js
```
