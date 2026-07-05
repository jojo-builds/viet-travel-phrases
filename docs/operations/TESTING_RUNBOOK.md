# Testing Runbook

Last updated: 2026-05-13
Authority lane: live native iOS build and validation truth

## Use This Doc For

- repo-owned validation commands
- native iOS build/test handoff order
- feature branch sync and physical iPhone install rules
- post-run operational-doc sync targets

## Current Development Truth

SpeakLocal app development now happens on Jojo's MacBook from:

`/Users/jojolim/Developer/products/speaklocal/app-family`

The active app product surface is:

`/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`

Do not use Windows paths, Expo, React Native, Metro, EAS, or a resurrected `app/` directory for current app work. Historical logs may mention those paths, but they are not development instructions.

## Codex Native Loop

The Codex desktop app exposes native actions through:

- `.codex/environments/environment.toml`
- `script/build_and_run.js`
- `script/build_and_run.sh`

Preferred local loop:

1. Use `Native Build` for a simulator build.
2. Use `Native Test` for native Xcode tests.
3. Use branch-specific simulators for manual UI proof.
4. Build `main` on Jojo's physical iPhone when app code changes and should be tested on-device.

Equivalent commands from the repo root:

```sh
node script/build_and_run.js build
node script/build_and_run.js test
node script/build_and_run.js doctor
```

## Current Validation Commands

Run only the commands that match the change. For broad app/content changes, use this order from the repo root:

```sh
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/sync-viet-audio.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/guard-native-chrome.js
node scripts/guard-native-only.js
git diff --check
xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' build CODE_SIGNING_ALLOWED=NO
```

For focused app changes, also run the relevant Xcode test target or UI smoke test for that surface.

## Validation Interpretation

- Native generation commands rebuild and validate the bundled resources used by the SwiftUI app.
- Native Xcode build/test output is the gate for app behavior.
- Visible UI changes need native simulator screenshots or physical iPhone proof, not web previews.
- `node native-ios/scripts/guard-native-chrome.js` must pass after native chrome changes; it blocks the recurring opaque top-white shield regression.
- `node scripts/guard-native-only.js` must pass after workflow or repo-structure changes.

## Branch And Device Policy

1. `main` is the app Jojo expects to test on his phone.
2. Feature branches/worktrees are temporary parallel lanes.
3. A feature lane should start by syncing from the latest local `main` when clean.
4. A finished feature lane should be committed, validated enough for scope, then merged into `main`.
5. Before merging into `main`, merge current `main` into the feature lane and resolve conflicts there.
6. Only build `main` on Jojo's physical iPhone by default.
7. Build a feature branch on the physical iPhone only if Jojo explicitly asks to test that branch before merge.

Use the workflow skill/helper for branch work:

```sh
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh status
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh start <feature-slug-or-path>
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh finish <feature-slug-or-path>
```

## Physical iPhone Build

After app changes are merged to `main`, build from the primary checkout:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family \
  /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Report:

- installed `main` commit hash
- build/install/launch result
- whether the phone was locked or unavailable
- signing hygiene result

## Native TestFlight / StoreKit Lane

Use TestFlight only when the goal is Apple-side behavior that cannot be proven locally, such as StoreKit purchase, restore, or App Store sheet behavior.

Before a durable purchase test:

- confirm the bundle ID is `com.jojobuilds.viettravelphrases`
- confirm the product ID is `app.speaklocal.vietnam.subscription.monthly`
- confirm App Store Connect metadata and sandbox-account readiness
- archive/export from the native Xcode project or the agreed native release path
- record the exact build number, device model, iOS version, and Apple-side product state

Do not use EAS or Expo build commands for this app.

## Website Checks

The `site/` folder is a separate website surface. Website tasks may validate and publish `site/`, but they do not define app runtime truth.

When a task edits `site/`, validate:

1. route-pair parity for edited `foo.html` and `foo/index.html` pages
2. local link integrity across `site/**/*.html`
3. direct-serve preview-data parity under `site/data/` and `site/public/data/`
4. website artifact validation:

```sh
pwsh -NoProfile -File ./scripts/website/Test-SpeakLocalWebsiteArtifact.ps1
```

5. local smoke with:

```sh
python3 -m http.server 4173 --directory site
```

Website preview data must come from current native/content source paths, not from a React Native app pack.

## Evidence Minimum

For native app work, close with:

- branch and commit hash
- files changed
- validation commands and results
- simulator screenshot paths when UI changed
- physical iPhone result when built to device
- remaining risks or blockers

## Current Operational Limits

- StoreKit purchase/restore still needs fresh native-device proof when the paywall lane is ready.
- Audio quality and continuity should be reviewed through native resources, not legacy audio folders.
- Historical Expo/EAS issues are no longer app-development blockers.
