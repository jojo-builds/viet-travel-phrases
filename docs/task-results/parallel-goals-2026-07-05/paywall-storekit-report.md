# SpeakLocal Vietnam Paywall / StoreKit Handoff

Date: 2026-07-05
Branch: `feature/paywall`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`

## Status

Recommendation: `FIX_FIRST`

The paywall lane is closer to production-ready locally, but it is not ready to merge to `main`. Local StoreKit configuration, paywall rendering, entitlement-cache safety, and development bypass behavior are improved. Real purchase, restore, App Store sheet behavior, and TestFlight/App Store Connect product state remain unproven.

## What Changed

- Merged current local `main` into `feature/paywall` and resolved conflicts inside the paywall lane only.
- Replaced placeholder onboarding/paywall copy with the current product truth:
  - `7-day free trial`
  - `$4.99/month`
  - full curated Vietnam companion value
  - offline/no-backend/no-runtime-AI simplicity for this pass
- Added expiration-aware cached entitlement continuity:
  - active StoreKit entitlements now cache `expiresAt` when StoreKit provides an expiration date
  - expired cached access no longer qualifies as launch continuity
  - cached access is still allowed during transient StoreKit loading/failure only while usable
- Added a test launch argument to disable the automatic UI-test bypass:
  - `--disable-subscription-ui-test-bypass`
  - this lets local UI tests exercise the real onboarding/paywall locked path
- Added regression coverage intent for:
  - cached access encoding/decoding with expiration
  - usable vs expired cached access
  - paywall value copy
  - onboarding completion relaunching to paywall without the debug bypass

## StoreKit / Product State

Local StoreKit config file:

`native-ios/Config/StoreKit/SpeakLocalPaywall.storekit`

Confirmed local config values:

- product ID: `app.speaklocal.vietnam.subscription.monthly`
- recurring period: `P1M`
- display price: `4.99`
- introductory offer: free, `P1W`
- display name: `SpeakLocal Vietnam Monthly`

The Xcode project scheme still points run StoreKit configuration at:

`Config/StoreKit/SpeakLocalPaywall.storekit`

## Current Gating Truth

Gated:

- The native app shell is gated behind onboarding/paywall unless:
  - StoreKit entitlement is active
  - usable cached entitlement continuity exists while StoreKit refreshes
  - `--subscription-bypass` is used
  - UI tests run without forced subscription state, unless `--disable-subscription-ui-test-bypass` is present

Free today in this lane:

- onboarding screen
- paywall screen
- development/UI-test bypass path

Not implemented yet:

- a true in-app starter/free phrase layer while premium content remains locked
- premium badges/locks inside Browse/Search/detail pages
- granular gating by `accessTier`

That free-tier gap is why this remains `FIX_FIRST` before merge, even though the branch now has a safer StoreKit shell.

## Validation

Passed:

- `git diff --check`
- `node scripts/guard-native-only.js`
- StoreKit config sanity via `plutil`
- simulator build:
  - `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=<SpeakLocal Paywall>' build CODE_SIGNING_ALLOWED=NO`
  - result: `BUILD SUCCEEDED`
- simulator install/launch:
  - installed the built app on dedicated `SpeakLocal Paywall` simulator
  - launched with `--force-subscription-paywall --reset-subscription-onboarding`
  - result: launch succeeded
- screenshot proof:
  - `docs/task-results/parallel-goals-2026-07-05/assets/paywall-forced-simulator.png`
  - confirms paywall copy, `Subscription Unavailable` local state, Restore, Terms, and Privacy render

Red/green TDD evidence:

- red unit-test check failed for the expected missing API before implementation:
  - missing `expiresAt`
  - missing `CachedSubscriptionAccess.isUsable(now:)`
  - compile failures: `3`

Blocked validation:

- focused XCTest execution did not complete after implementation.
- attempted focused unit-test command multiple ways:
  - dedicated simulator by name
  - dedicated simulator by ID
  - simulator reset/erase/boot
  - `-parallel-testing-enabled NO`
  - `-skip-testing:SpeakLocalNativeUITests`
- each post-build test run stalled in the XCTest harness before assertions completed:
  - `waiting for workers to materialize`
  - unfinished simulator install/launch workers
- completed XCTest assertion count after implementation: `0`, because the harness never reached the tests.

Not run:

- physical iPhone build/install/launch. This branch was not installed on Jojo's phone.
- real StoreKit purchase.
- real restore.
- TestFlight/App Store sheet proof.

## Apple / Jojo Required

Requires Apple/App Store Connect/TestFlight or Jojo involvement:

- confirm App Store Connect product exists for `app.speaklocal.vietnam.subscription.monthly`
- confirm subscription group/product state is ready for sandbox/TestFlight
- confirm bundle ID mapping for the native TestFlight build path
- run real purchase flow and capture App Store sheet or exact failure
- verify immediate unlock after successful purchase
- force-close/relaunch to prove entitlement persistence from StoreKit
- delete/reinstall or otherwise prove restore
- decide final free-vs-premium product boundary inside the native app

## Remaining Risks

- Current branch gates the whole app rather than exposing the repo's starter/free layer in-app.
- Local manual `simctl launch` does not attach Xcode's StoreKit session, so the screenshot shows the honest `Subscription Unavailable` state rather than a local purchasable product card.
- XCTest harness is currently a local validation blocker; build and manual simulator launch work, but automated unit/UI execution did not complete.
- App Store legal/compliance wording still needs Jojo/App Store review before customer-facing release.
