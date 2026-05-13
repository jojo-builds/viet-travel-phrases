# Latest Validation

Last updated: 2026-05-13
Authority lane: latest durable native iOS validation evidence

## Use This Doc For

- the latest durable validation evidence that already exists
- what still needs proof after the native-only cleanup

Do not use this file as the execution checklist. `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, `TESTING_RUNBOOK.md`, and `IOS_DEVICE_BUILDING.md` own the current handoff path.

## Current Native-Only Cleanup Evidence

This cleanup records the repo direction that `native-ios/` is the only active app product surface.

Validated or prepared in this pass:

- the legacy Expo/React Native `app/` tree was removed from active repo truth
- Codex run actions were redirected to native Xcode build/test/doctor commands
- native audio validation was redirected to `native-ios/Resources/Audio` and `native-ios/Resources/viet-audio-manifest.json`
- active operational docs were rewritten to stop directing workers to Windows, Expo, React Native, Metro, EAS, or `app/`
- `scripts/guard-native-only.js` was added as a structural guardrail

Fresh command evidence from this pass:

- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `python3 scripts/check-family-consistency.py --repo-root "$PWD"`
  - passed: native family consistency check
- `node native-ios/scripts/sync-viet-audio.js`
  - passed: validated `3910` native audio manifest entries in `native-ios/Resources/Audio`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `3078` source phrases, `3070` canonical pages, `20413` relations, `0` release-blocking missing-audio rows, `0` banned file matches
- `git diff --check`
  - passed
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build CODE_SIGNING_ALLOWED=NO`
  - passed
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeTests/AppChromeTests -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests CODE_SIGNING_ALLOWED=NO`
  - passed: `158` tests, `0` failures

Known pre-existing test debt:

- `PhrasePageFixtureTests/testAuthoredAudioAuditOnlyHasPlannedCityMissingAudio` fails on current `main` before this cleanup. The failure is the legacy fixture/resource path, not a new native-only cleanup regression.
- Broader `PhrasePageFixtureTests` also still contains tests that explicitly disable the default SQLite runtime. That suite should be retired or rewritten as a native SQLite/content-fixture suite in a dedicated follow-up.

## Last Known Native App Truth

- Active app root: `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
- Bundle ID: `com.jojobuilds.viettravelphrases`
- Product ID: `com.jojobuilds.viettravelphrases.premiumunlock`
- Current language pack under active development: Viet
- Tagalog remains a future native language-pack candidate unless Jojo explicitly reactivates that lane.

## Remaining Proof Needed

- Fresh physical iPhone install from current `main` after native-only cleanup is merged.
- Fresh StoreKit purchase/restore/relaunch proof when the native paywall branch is ready.
- Fresh screenshots for any native UI work that changes visible app behavior.

## Historical Evidence Boundary

Older validation snapshots may mention Windows paths, Expo, EAS, React Native, or an `app/` folder. Those records are archive context only. They do not define the current app build path.
