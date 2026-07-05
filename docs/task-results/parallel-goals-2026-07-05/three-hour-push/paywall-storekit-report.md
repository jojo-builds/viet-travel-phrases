# SpeakLocal Paywall StoreKit Readiness Report

Date: 2026-07-05
Branch: `feature/paywall`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`
Starting commit: `5bc336f9e`
Final commit: containing `feature/paywall` commit; exact hash recorded in the worker handoff.

## Recommendation

`ready for Jojo test`

The branch is ready for Jojo to review the paywall branch in simulator and to proceed into App Store Connect/TestFlight setup for real StoreKit purchase testing. It is not ready to merge to `main`, and it was not installed on Jojo's physical iPhone.

This recommendation is deliberately narrow: local StoreKit shell, entitlement state, dev bypass, onboarding/paywall UI, and XCTest automation are now working enough for the next paywall test pass. Real purchase, restore, App Store sheet behavior, relaunch persistence from Apple's transaction state, and the final free-vs-premium product boundary still need external setup or product decisions.

## What Works Now

- `feature/paywall` remains branch-local and unmerged into `main`.
- The local StoreKit config still defines the expected placeholder product:
  - product ID: `app.speaklocal.vietnam.subscription.monthly`
  - recurring period: `P1M`
  - introductory offer period: `P1W`
  - display price: `4.99`
- `AccessGateView` routes normal launches through onboarding, paywall, entitlement cache, or bypass logic.
- `SubscriptionStore` still loads products, refreshes current entitlements, caches active access with expiration awareness, handles transaction updates, and exposes restore.
- `--subscription-bypass` still opens the app for development inspection.
- `--disable-subscription-ui-test-bypass` lets UI tests exercise the locked onboarding/paywall path.
- Forced paywall simulator launch renders the paywall screen, Restore, Terms, Privacy, and the honest local `Subscription Unavailable` StoreKit state.

## What Was Fixed

- Fixed the hosted XCTest harness blocker introduced by the app-level paywall gate.
- Root cause: hosted unit tests launch the app process with `XCTestBundlePath=PlugIns/SpeakLocalNativeTests.xctest`, while `XCTestConfigurationFilePath` is empty and `XCInjectBundleInto` is `unused`. The previous detector did not recognize that as the hosted unit-test environment, so the app root could start the subscription gate before XCTest materialized tests.
- Fix: `AccessGateView` now uses an inert hosted-unit-test root view and skips subscription startup only for `SpeakLocalNativeTests` host launches. UI tests and normal app launches still use the real subscription gate.
- Added unit coverage for the observed hosted-test environment shape.

## Simulator / Build / Test Proof

Passed:

- `git diff --check`
- `node scripts/guard-native-only.js`
- StoreKit config sanity via `plutil`
- Focused subscription unit tests:
  - command: `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -configuration Debug -destination 'platform=iOS Simulator,id=D4CFA5E1-CB6E-4D54-899F-D85E5C0CCB6F' -derivedDataPath build/DerivedData-Paywall-Manual CODE_SIGNING_ALLOWED=NO -skip-testing:SpeakLocalNativeUITests -only-testing:SpeakLocalNativeTests/SubscriptionAccessStateTests test`
  - result: `13` tests, `0` failures
  - log: `docs/task-results/parallel-goals-2026-07-05/three-hour-push/test-logs/subscription-access-state-tests-host-bypass.log`
- Focused subscription UI tests:
  - command: `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -configuration Debug -destination 'platform=iOS Simulator,id=D4CFA5E1-CB6E-4D54-899F-D85E5C0CCB6F' -derivedDataPath build/DerivedData-Paywall-Manual CODE_SIGNING_ALLOWED=NO -only-testing:SpeakLocalNativeUITests/SubscriptionGateUITests test`
  - result: `4` tests, `0` failures
  - log: `docs/task-results/parallel-goals-2026-07-05/three-hour-push/test-logs/subscription-gate-ui-tests.log`
- Manual simulator launch with XcodeBuildMCP:
  - simulator: `SpeakLocal Paywall`
  - launch args: `--force-subscription-paywall --reset-subscription-onboarding`
  - result: launch succeeded and `SubscriptionPaywallView` existed
  - screenshot: `docs/task-results/parallel-goals-2026-07-05/three-hour-push/assets/paywall-forced-simulator-2026-07-05.jpg`

Red/green trail:

- Before the detector fix, the same focused unit-test path reproduced the prior harness stall and had to be killed after the app host launched without reaching assertions.
- Inspecting the stuck simulator process showed the actual hosted-test environment keys.
- After adding `XCTestBundlePath` detection and the inert hosted-test root, the focused unit suite reached XCTest assertions and passed.

## Current Gating Truth

Gated in this branch:

- The native app shell is gated behind the subscription onboarding/paywall unless the user has an active StoreKit entitlement, usable cached entitlement continuity, `--subscription-bypass`, or normal UI-test auto-bypass.

Free in this branch:

- subscription onboarding
- subscription paywall
- local development / UI-test bypass path

Not implemented yet:

- granular in-app starter/free phrase browsing while premium content remains locked
- premium lock badges or upsell rows inside Browse, Search, phrase detail, city/place, saved, or Practice routes
- route-level enforcement using the generated `accessTier` data already present in native content models

## App Store Connect / Jojo Decisions Needed

- Confirm the App Store Connect product exists for `app.speaklocal.vietnam.subscription.monthly`.
- Confirm subscription group, display name, price, and introductory offer match Jojo's final decision.
- Confirm bundle ID mapping and TestFlight/native release path for StoreKit sandbox testing.
- Confirm final paywall copy, legal/compliance wording, trial framing, pricing display, and premium benefit claims.
- Decide whether this first paywall release gates the whole native app after onboarding or must expose the starter/free phrase layer inside the app before purchase.

## Still Needs App Store / Sandbox Verification

- Real purchase flow and App Store sheet capture.
- Immediate unlock after successful purchase.
- Force-close/relaunch entitlement persistence from StoreKit transaction state.
- Restore after delete/reinstall or a clean simulator/device state.
- Expired/canceled/revoked subscription behavior with Apple-provided transaction states.

## Phone / Main Boundary

- No merge to `main` was performed.
- No physical iPhone build/install/launch was performed.
- Jojo's phone was not touched by this paywall branch.
