# SpeakLocal Vietnam Paywall Local Hardening Report

Date: 2026-07-06 (Asia/Manila)
Branch: `feature/paywall`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`
Status: local paywall lane hardened; not merged to `main`

## Summary

This pass moved the paywall lane closer to a real revenue-ready build, but it is still blocked on Apple-side proof before it should ship.

Local work completed:

- synced current local `main` into `feature/paywall` and resolved the branch-local merge conflicts
- hardened the subscription bypass so `--subscription-bypass` is ignored outside debug policy
- updated paywall copy to a value-first subscription offer without stale inventory counts
- removed manual trial/price hardclaims from the surrounding SwiftUI copy; Apple's StoreKit purchase surface owns exact trial eligibility and billing details
- replaced Apple generic privacy links with SpeakLocal-owned support, terms, and privacy links
- added unit/UI coverage for release-bypass behavior, legal links, App Store-owned offer wording, unavailable-product messaging, hittable legal actions, and current paywall text
- fixed paywall safe-area/layout issues caught during screenshot review: Dynamic Island overlap, clipped legal footer links, and lower-page text peeking under the footer

## Local Product State

Local StoreKit config:

- file: `native-ios/Config/StoreKit/SpeakLocalPaywall.storekit`
- product ID: `app.speaklocal.vietnam.subscription.monthly`
- subscription group: `SpeakLocal Vietnam`
- recurring period: monthly, `P1M`
- display price: `4.99`
- introductory offer: free, one week, `P1W`

Visible paywall framing:

- headline: `Keep the full Vietnam companion for your trip`
- primary action language: `View subscription options`
- benefits: food/coffee/places/phrase pages, playable Vietnamese audio, Search/Browse/Save/Practice
- exact trial eligibility, price, and billing terms are left to StoreKit/App Store surfaces rather than duplicated in manual copy

## Validation Receipt

First local proof pass:

- `SubscriptionAccessStateTests`: passed before the final pricing-copy helper was added
- `SubscriptionGateUITests`: `4` tests, `0` failures, result bundle `/tmp/speaklocal-paywall-ui-derived-2/Logs/Test/Test-SpeakLocalNative-2026.07.06_10-29-19-+0800.xcresult`
- Release simulator build: succeeded before final copy helper

Final local proof pass after all final edits:

- `SubscriptionAccessStateTests`: `20` tests, `0` failures, result bundle `/tmp/speaklocal-paywall-final-derived/Logs/Test/Test-SpeakLocalNative-2026.07.06_11-12-31-+0800.xcresult`
- `SubscriptionGateUITests`: `4` tests, `0` failures, result bundle `/tmp/speaklocal-paywall-final-derived/Logs/Test/Test-SpeakLocalNative-2026.07.06_11-12-49-+0800.xcresult`
- Release simulator build: `BUILD SUCCEEDED`, derived data `/tmp/speaklocal-paywall-final-derived`
- StoreKit config sanity: passed for product ID, monthly period, `4.99` display price, and free one-week intro offer
- static guards: `node scripts/guard-native-only.js`, `node native-ios/scripts/guard-native-chrome.js`, `node native-ios/scripts/audit-visible-product-language.js`, and `git diff --check` all passed
- forced simulator screenshot proof after visual fixes: `docs/task-results/paywall-readiness-2026-07-06/paywall-forced-simulator-2026-07-06.png`

## Review / Risk Status

Still blocked before public paywall release:

- App Store Connect must contain the matching subscription group/product, price, intro offer, localizations, and review metadata.
- Sandbox or TestFlight must prove purchase success, restore success, force-close/relaunch entitlement persistence, locked/unlocked gate behavior, cancellation/expiration behavior, and the product sheet state.
- Public Support, Privacy, and Terms URLs have local generated site sources in `site/`, but `https://speaklocal.app/feedback/`, `https://speaklocal.app/privacy/`, and `https://speaklocal.app/terms/` timed out from this machine during this pass and still need live public URL proof before App Store submission.
- Jojo still needs to confirm whether the first public release should ship non-paywall first or hold for paywall day one.
- Whole-app gate versus a starter/free layer remains a product decision. The current paywall lane gates the native app shell once onboarding is complete unless entitlement/cached access/debug policy opens it.

Apple references checked for this pass:

- https://developer.apple.com/app-store/subscriptions/
- https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode
- https://developer.apple.com/help/app-store-connect/manage-subscriptions/offer-auto-renewable-subscriptions/
- https://developer.apple.com/help/app-store-connect/test-in-app-purchases/overview-of-testing-in-sandbox/
- https://developer.apple.com/help/app-store-connect/test-a-beta-version/testing-subscriptions-and-in-app-purchases-in-testflight/

## Recommendation

Do not merge this lane into `main` yet. Commit the local hardening work in `feature/paywall`, keep `main` as the non-paywall phone truth, then finish App Store Connect/TestFlight proof when Jojo is available for credentials and Apple-side decisions.
