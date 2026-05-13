# Tagalog Completion Brief

Status: historical brief, not a current execution packet.

Tagalog remains useful planning context, but this document describes an older Expo/EAS validation lane. Current app work is MacBook-only and native iOS-only. Do not run Expo, EAS, Metro, or `app/` commands from this brief.

## Current session root

- Current Mac root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Active native app root: `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
- Legacy Windows roots are archive context only and must not be used for new work.

## What is already true

- The shared app-family seam is already implemented.
- Tagalog already exists as a real second app candidate through:
  - pack adapter
  - presentation config
  - storage namespace
  - bundled-audio path
- Tagalog already resolves through the same runtime/build registry seam as Viet.
- Older TypeScript/Expo config checks were historical validation only, not current app truth.
- Tagalog now has:
  - a 10-scenario / 70-phrase runtime pack
  - Tagalog draft artifacts with stable phrase IDs and audio keys
  - generated bundled mp3 audio plus a Tagalog-local registry and manifest
  - a historical `preview-tagalog` EAS profile from the retired Expo lane
  - a repo-local family parity validator

## What Tagalog still lacks

- a manifest summary that advances `testingGates.runtimeManualSmoke` from `pending` to `passed`
- a manifest summary that advances `testingGates.deviceWalkthrough` from `pending` to `passed`
- a fuller durable on-device walkthrough using the successful `preview-tagalog` build beyond the confirmed install / baseline UI identity
- a real device walkthrough for audio, favorites, and end-to-end flows captured in durable validation truth
- later release-ops separation beyond preview such as Tagalog App Store Connect mapping

## Current operator-state target

- `stage: testing`
- `testingGates.localValidation: passed`
- `testingGates.previewBuild: passed`
- `testingGates.previewInstall: passed`
- `testingGates.runtimeManualSmoke: pending`
- `testingGates.deviceWalkthrough: pending`
- `releaseStatus: preview-only`
- `pendingFeatureRollouts: [search]`
- `blockerTag: blocked:human`
- `hardBlock.active: true`
- `hardBlock.type: device-access`
- keep Tagalog release-transition work deferred until the current device-only shared-search block clears

## Native Follow-Up Shape

If Tagalog is reactivated, create a native language-pack task that:

1. keeps source work in `content-draft/tagalog` and `ops/apps/tagalog.json`
2. generates native resources under `native-ios/Resources/LanguagePacks/`
3. adds or updates `native-ios/Config/apps/philippines.json`
4. validates with native scripts and Xcode tests
5. captures simulator or iPhone proof from `native-ios/`

## Validation expectations

Use the native validation runbook in `docs/operations/TESTING_RUNBOOK.md`. Do not use the removed Expo/React Native app shell for Tagalog validation.

If the session materially changes audio, content wiring, or app readiness truth, also update:

- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `ops/apps/tagalog.json`

Use `ops/apps/tagalog.json` for compact `stage` / `testingGates` / `hardBlock` summary only.
Keep the exact evidence for those fields in `docs/operations/*`.

## Durable docs to update in that session

- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/DECISIONS.md` if the audio/content contract changes
- `docs/operations/*` if operational truth changes
- `ops/apps/tagalog.json`
