# Viet Native Device / TestFlight Execution Packet

Last updated: 2026-05-13
Authority lane: exact native iPhone and TestFlight evidence packet

## Use This Doc For

- the ordered evidence packet for a native iPhone pass
- the TestFlight lane when Apple-side purchase behavior must be proven
- the return fields that should be folded back into repo truth

Status and blockers live in:

- `APP_STATUS.md`
- `CURRENT_BLOCKERS.md`
- `LATEST_VALIDATION.md`
- `ops/apps/viet.json` for compact dashboard summary only

## Current Truth Boundary

- Active app surface: `native-ios/`
- Development machine: Jojo's MacBook
- Bundle ID: `com.jojobuilds.viettravelphrases`
- Product ID: `com.jojobuilds.viettravelphrases.premiumunlock`
- Legacy Expo/EAS/React Native build paths: archive only, not an active lane

Do not upgrade any build, purchase, restore, or device-proof truth unless fresh evidence is actually captured during the run.

## Step 1. Confirm The Repo Snapshot

From `/Users/jojolim/Developer/products/speaklocal/app-family`:

```sh
git rev-parse --short HEAD
git status --short
node scripts/guard-native-only.js
```

Record:

- commit hash
- branch
- whether the worktree is clean
- whether native-only guardrails pass

## Step 2. Native Simulator Preflight

Run a native build before touching the physical iPhone:

```sh
xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build CODE_SIGNING_ALLOWED=NO
```

If the pass includes visible UI changes, capture simulator screenshots for the changed screens.

## Step 3. Physical iPhone Install

Only build the physical iPhone from `main` unless Jojo explicitly asks for a branch build.

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family \
  /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Record:

- installed commit hash
- device name/model if reported
- build/install/launch result
- whether launch was blocked by a locked or unavailable phone
- signing hygiene result

## Step 4. Native Smoke Set

Run the screens relevant to the change. For broad builds, include:

- Home
- Browse
- Search
- one phrase listing page
- one city page
- Messages
- Saved
- bottom chrome navigation
- audio playback

For search work, smoke at least:

- `hello`
- `passport`
- `tickets`
- `driver cant find me`
- `zzzzz`

## Step 5. StoreKit / TestFlight Lane

Only run this lane when the native paywall or Apple-side purchase behavior is under test.

Before purchase proof:

- confirm App Store Connect product state for `com.jojobuilds.viettravelphrases.premiumunlock`
- confirm sandbox account and storefront
- confirm the build under test is the native SwiftUI app
- install via TestFlight or the agreed native release path

Run:

1. premium/paywall screen renders current product truth
2. tap purchase CTA
3. capture real App Store sheet or exact failure state
4. if purchase succeeds, verify immediate unlock
5. force-close and relaunch for entitlement persistence
6. delete/reinstall or otherwise prove restore

If no real App Store sheet appears, record the exact blocker. Do not imply purchase success.

## Required Return Packet

Use these exact headings:

1. Repo snapshot
   - `branch`
   - `commit`
   - `worktreeState`
   - `nativeOnlyGuardState`
2. Simulator preflight
   - `buildCommand`
   - `buildState`
   - `testState`
   - `screenshotPaths`
3. Physical device install
   - `installedCommit`
   - `device`
   - `installState`
   - `launchState`
   - `signingHygieneState`
4. Manual smoke
   - `screensChecked`
   - `audioState`
   - `searchState`
   - `issuesFound`
5. StoreKit/TestFlight state
   - `buildNumber`
   - `testflightState`
   - `productStatus`
   - `purchaseState`
   - `restoreState`
6. Repo sync decision
   - `docsToUpdate`
   - `blockersToUpdate`
   - `nextBuildNeeded`
