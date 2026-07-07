# Paywall Production Report

Date: 2026-07-07
Branch/worktree: `feature/paywall` at `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`
Output folder: `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-production-2026-07-07`

## Status

Paywall lane advanced substantially, including the public HTTPS legal/support gate and a small native preview section, but it is not production-ready and must remain isolated from `main`.

## What Changed

- Implemented the recommended `Trip Companion Gate` paywall narrative in SwiftUI.
- Added a first-viewport launch-offer card and moved the StoreKit trial section before the benefit rows.
- Tightened disclosure copy: `Try 7 days free, then $4.99/month in the U.S. The App Store confirms eligibility, local pricing, renewal date, and cancellation before purchase.`
- Scoped audio claims to supported playable audio.
- Kept Restore, Support, Terms, and Privacy visible with footer wrapping.
- Added `Preview real trip moments`, a curated in-paywall preview with coffee, place, and repair examples so a cold user sees concrete app substance before trial.
- Added a StoreKit config validator and tests.
- Added StoreKitTest hooks that skip honestly under the current iOS 26.5 `xcodebuild` StoreKitTest blocker.
- Added a UI proof-capture test that attaches first and scrolled paywall screenshots, including the preview section.
- Fixed the public `speaklocal.app` GitHub Pages HTTPS gate by re-saving the custom domain, forcing a Pages rebuild, restarting certificate provisioning with a remove/re-add cycle, and enabling HTTPS enforcement after GitHub approved the certificate.

## Visual Artifacts

- `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-production-2026-07-07/assets/paywall-trip-companion-forced-2026-07-07.png`
- `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-production-2026-07-07/assets/paywall-trip-companion-scrolled-2026-07-07.png`

Important: the fresh screenshots prove layout, copy, preview examples, footer wrapping, and fallback handling only. They still do not prove a purchasable subscription because the local StoreKit product state remains unavailable.

## Current Gate Map

Accessible before subscription:

- Onboarding.
- Paywall copy, launch-offer card, StoreKit fallback state, Restore, Support, Terms, and Privacy.
- Small curated preview examples embedded in the paywall: coffee order, Hoi An place help, and slow-speech repair.
- Debug-only app bypass for development and UI tests.

Still gated for normal users:

- Main app entry after onboarding.
- Search, Browse, Saved, Practice, phrase pages, city/place guides, and full trip use.
- Entitlement persistence outside debug/test launch arguments.

## Validation Results

- `node --test native-ios/scripts/validate-paywall-storekit-config.test.js native-ios/scripts/audit-visible-product-language.test.js`: passed, 3 tests.
- `node native-ios/scripts/validate-paywall-storekit-config.js`: passed.
- `node native-ios/scripts/audit-visible-product-language.js`: passed.
- `node native-ios/scripts/guard-native-chrome.js`: passed.
- `node scripts/guard-native-only.js`: passed.
- `git diff --check`: passed.
- `xcodebuild ... -resultBundlePath /tmp/speaklocal-paywall-access-latest-rerun.xcresult CODE_SIGNING_ALLOWED=NO -only-testing:SpeakLocalNativeTests/SubscriptionAccessStateTests test`: passed, 22 tests.
- `xcodebuild ... -resultBundlePath /tmp/speaklocal-paywall-ui-latest.xcresult CODE_SIGNING_ALLOWED=NO -only-testing:SpeakLocalNativeUITests/SubscriptionGateUITests test`: passed, 5 tests, screenshots exported.
- Fresh rerun: `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -configuration Debug -destination 'platform=iOS Simulator,id=D4CFA5E1-CB6E-4D54-899F-D85E5C0CCB6F' -derivedDataPath build/DerivedData-Paywall-StoreKit-Latest -resultBundlePath /tmp/speaklocal-paywall-storekit-latest.xcresult CODE_SIGNING_ALLOWED=NO -only-testing:SpeakLocalNativeTests/SubscriptionStoreKitTests test`: succeeded with 2 skipped tests. Result summary: total 2, skipped 2, failed 0, result `Skipped`.
- XcodeBuildMCP `build_run_sim` on `SpeakLocal Paywall`: passed, no warnings/errors.
- `gh api repos/jojo-builds/viet-travel-phrases/pages`: passed, Pages status `built`, `https_enforced: true`, certificate state `approved` for `speaklocal.app` and `www.speaklocal.app`.
- `curl -I -L --max-time 30 https://speaklocal.app/terms/`, `/privacy/`, and `/feedback/` with proxy disabled: passed, HTTP `200`, SSL verify result `0`.
- `openssl s_client -servername speaklocal.app -connect speaklocal.app:443 | openssl x509 -noout -subject -ext subjectAltName`: passed, certificate subject `CN=speaklocal.app`, SAN includes `DNS:speaklocal.app` and `DNS:www.speaklocal.app`.
- `xcrun storekit --help`: blocked, this Xcode install does not include the `storekit` command-line utility.
- `xcodebuild -help | rg -i 'storekit|store kit|subscription|configuration'`: no StoreKit-specific launch/test flag exposed.
- App Store Connect access check: no `APP_STORE` / `APPSTORE` / `ASC` / `APPLE` / `ITC` / `ISSUER` / `AUTH_KEY` / `API_KEY` / `CONNECT` environment variables found, no expected App Store Connect key files found in narrow local credential paths, and the in-app browser could not load App Store Connect within two attempts. Plain `curl -I -L https://appstoreconnect.apple.com/login` returned HTTP `200`, so the public login page is reachable but authenticated account access is not available to this session.

## Remaining Production Blockers

- Legal/support HTTPS gate is fixed for direct external checks:
  - `https://speaklocal.app/feedback/`
  - `https://speaklocal.app/privacy/`
  - `https://speaklocal.app/terms/`
- Local screenshots show `Subscription Unavailable`; a purchasable StoreKit product has not been proven.
- App Store Connect product setup/status, sandbox purchase, restore, relaunch entitlement, cancellation/expiration, and TestFlight proof are still missing.
- Final public trial/price/product metadata require Jojo approval and Apple-side confirmation.
- Current branch now includes a small paywall-embedded preview. It does not expose the full app before subscription.

## App Store Connect Next Steps

1. In App Store Connect, confirm the SpeakLocal Vietnam app record and any missing agreements/tax/banking state.
2. Create or confirm subscription group `SpeakLocal Vietnam Full Access`.
3. Create or confirm monthly subscription product `app.speaklocal.vietnam.subscription.monthly`.
4. Set duration to 1 month and U.S. working price to $4.99.
5. Add a 1-week free trial introductory offer.
6. Add localized subscription name/description grounded in current native app truth.
7. Upload a paywall screenshot only after it shows a working product state.

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
