# Tagalog Completion Brief

Superseded as the default next execution target by `docs/SEARCH_ROLLOUT_BRIEF.md`.
Keep this brief for Tagalog-specific preview, release, and fuller device-validation follow-up only.

## Canonical session root

- `E:\AI\SpeakLocal-App-Family`

## What is already true

- The shared app-family seam is already implemented.
- Tagalog already exists as a real second app candidate through:
  - pack adapter
  - presentation config
  - storage namespace
  - bundled-audio path
- Tagalog already resolves through the same runtime/build registry seam as Viet.
- TypeScript and Expo config resolution already work for Tagalog from this repo.
- Tagalog now has:
  - a 10-scenario / 70-phrase runtime pack
  - Tagalog draft artifacts with stable phrase IDs and audio keys
  - generated bundled mp3 audio plus a Tagalog-local registry and manifest
  - an additive `preview-tagalog` EAS profile
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

## Required next-session work

1. advance `testingGates.runtimeManualSmoke` by running the real shared-search smoke on the current Tagalog preview build
2. advance `testingGates.deviceWalkthrough` by capturing the fuller durable walkthrough for the corrected Tagalog build
3. clear the active device-access hard block only after both of those gates are captured in durable operational truth
4. update operational truth and the compact operator manifest summary after those gates change
5. if future remote builds are needed before the canonical repo-path issue is fixed, use the standalone app-root build directory workaround
6. keep Tagalog-specific release ops separate from the new shared-search family milestone until the device-only block is fully cleared

## Validation expectations

Run from `E:\AI\SpeakLocal-App-Family\app`:

- `npm run build:tagalog-pack`
- `npm run validate:family`
- `npx --no-install tsc --noEmit`
- `npx expo config --type public --json`
- `npx expo export --platform ios --output-dir .expo-export-viet-check`
- `$env:EXPO_PUBLIC_APP_VARIANT='tagalog'; npx --no-install tsc --noEmit`
- `$env:EXPO_PUBLIC_APP_VARIANT='tagalog'; npx expo config --type public --json`
- `$env:EXPO_PUBLIC_APP_VARIANT='tagalog'; npx expo export --platform ios --output-dir .expo-export-tagalog-check`
- `npx eas-cli credentials:configure-build -p ios -e preview-tagalog`

If another Tagalog preview build is needed before the canonical repo-path EAS packaging issue is fixed:

1. copy `E:\AI\SpeakLocal-App-Family\app` to a standalone app-root folder such as `E:\AI\SpeakLocal-EAS-Build`
2. from that standalone folder, run `npm ci`
3. from that standalone folder, run `$env:EXPO_PUBLIC_APP_VARIANT='tagalog'; npx eas-cli build --platform ios --profile preview-tagalog --non-interactive`

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
