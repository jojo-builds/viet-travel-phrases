# Paywall Production Report

Date: 2026-07-07
Branch/worktree: `feature/paywall` at `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`
Output folder: `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-production-2026-07-07`

## Status

Paywall lane advanced substantially, but it is not production-ready and must remain isolated from `main`.

## What Changed

- Implemented the recommended `Trip Companion Gate` paywall narrative in SwiftUI.
- Added a first-viewport launch-offer card and moved the StoreKit trial section before the benefit rows.
- Tightened disclosure copy: `Try 7 days free, then $4.99/month in the U.S. The App Store confirms eligibility, local pricing, renewal date, and cancellation before purchase.`
- Scoped audio claims to supported playable audio.
- Kept Restore, Support, Terms, and Privacy visible with footer wrapping.
- Added a StoreKit config validator and tests.
- Added StoreKitTest hooks that skip honestly under the current iOS 26.5 `xcodebuild` StoreKitTest blocker.
- Added a UI proof-capture test that attaches first and scrolled paywall screenshots.

## Visual Artifacts

- `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-production-2026-07-07/assets/paywall-trip-companion-forced-2026-07-07.png`
- `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-production-2026-07-07/assets/paywall-trip-companion-scrolled-2026-07-07.png`

Important: both fresh screenshots still show `Subscription Unavailable`. They prove layout, copy, footer wrapping, and fallback handling only. They do not prove a purchasable subscription.

## Validation Results

- `node --test native-ios/scripts/validate-paywall-storekit-config.test.js native-ios/scripts/audit-visible-product-language.test.js`: passed, 3 tests.
- `node native-ios/scripts/validate-paywall-storekit-config.js`: passed.
- `node native-ios/scripts/audit-visible-product-language.js`: passed.
- `node native-ios/scripts/guard-native-chrome.js`: passed.
- `node scripts/guard-native-only.js`: passed.
- `git diff --check`: passed.
- `xcodebuild ... -only-testing:SpeakLocalNativeTests/SubscriptionAccessStateTests test CODE_SIGNING_ALLOWED=NO`: passed, 21 tests.
- `xcodebuild ... -only-testing:SpeakLocalNativeUITests/SubscriptionGateUITests/testForceSubscriptionPaywallShowsTripCompanionGate test`: passed, 1 test.
- `xcodebuild ... -only-testing:SpeakLocalNativeUITests/SubscriptionGateUITests/testCaptureSubscriptionPaywallProofScreenshots -resultBundlePath /tmp/speaklocal-paywall-proof.xcresult test`: passed, 1 test, screenshots exported.
- `xcodebuild ... -only-testing:SpeakLocalNativeTests/SubscriptionStoreKitTests test`: passed with 2 skipped StoreKitTest cases due current `xcodebuild`/iOS 26.5 StoreKitTest blocker.
- `xcodebuild ... -only-testing:SpeakLocalNativeUITests/SubscriptionGateUITests test`: passed, 5 tests.
- XcodeBuildMCP `build_run_sim` on `SpeakLocal Paywall`: passed, no warnings/errors.

## Remaining Production Blockers

- Legal/support URLs fail HTTPS certificate validation:
  - `https://speaklocal.app/feedback/`
  - `https://speaklocal.app/privacy/`
  - `https://speaklocal.app/terms/`
- Local screenshots show `Subscription Unavailable`; a purchasable StoreKit product has not been proven.
- App Store Connect product setup/status, sandbox purchase, restore, relaunch entitlement, cancellation/expiration, and TestFlight proof are still missing.
- Final public trial/price/product metadata require Jojo approval and Apple-side confirmation.
- Current gate is still whole-app oriented. Recommended production preview policy is: allow a small curated preview of app substance, then require trial/subscription for Save, Practice, deep search/browse, and full trip use.

## App Store Connect Next Steps

1. Fix `speaklocal.app` HTTPS certificate/hostname so Support, Terms, and Privacy open cleanly.
2. In App Store Connect, confirm the SpeakLocal Vietnam app record and any missing agreements/tax/banking state.
3. Create or confirm subscription group `SpeakLocal Vietnam Full Access`.
4. Create or confirm monthly subscription product `app.speaklocal.vietnam.subscription.monthly`.
5. Set duration to 1 month and U.S. working price to $4.99.
6. Add a 1-week free trial introductory offer.
7. Add localized subscription name/description grounded in current native app truth.
8. Upload a paywall screenshot only after it shows a working product state.

## Sandbox/TestFlight Proof Next Steps

1. Install a build with the App Store Connect product available.
2. Fresh install: prove locked/paywall state.
3. Start trial in sandbox/TestFlight: capture Apple purchase sheet and successful completion.
4. Confirm entitlement unlock and app entry.
5. Force quit/relaunch: confirm entitlement persists.
6. Fresh install + Restore: confirm access returns.
7. Cancel/expire in sandbox/TestFlight: confirm app returns to locked/paywall state.
8. Open Support, Terms, and Privacy from the paywall on-device.

## Sources Refreshed

- Apple introductory offers: https://developer.apple.com/help/app-store-connect/manage-subscriptions/set-up-introductory-offers-for-auto-renewable-subscriptions/
- Apple auto-renewable subscriptions: https://developer.apple.com/help/app-store-connect/manage-subscriptions/offer-auto-renewable-subscriptions/
- Apple TestFlight subscription testing: https://developer.apple.com/help/app-store-connect/test-a-beta-version/testing-subscriptions-and-in-app-purchases-in-testflight/
- Apple StoreKitTest CLI blocker discussion: https://developer.apple.com/forums/thread/826971
- RevenueCat 2026 subscription report: https://www.revenuecat.com/state-of-subscription-apps/
