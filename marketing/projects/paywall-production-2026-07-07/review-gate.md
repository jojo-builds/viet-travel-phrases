# Paywall Review Gate

Date: 2026-07-07
Branch: `feature/paywall`

## Marketer Lens

Verdict: acceptable branch direction, not public-launch complete.

- The strongest current narrative is `Trip Companion Gate`: a curated Vietnam companion, not a translator or school course.
- The 7-day trial / $4.99 monthly working offer is clear, but public copy must keep the App Store in charge of eligibility, local price, renewal date, and cancellation.
- The top value line now scopes audio as `supported playable audio`.
- The branch now gives cold users a small concrete preview inside the paywall; the next conversion proof gap is a working product-state screenshot and sandbox purchase flow.

## iOS Developer Lens

Verdict: branch implementation is materially stronger, but purchase proof remains blocked.

- Paywall layout now uses native SwiftUI glass styling, stable wrapping footer links, a first-viewport trial section, and focused UI tests.
- `SubscriptionStoreView` is present and restore remains available.
- The paywall includes a native `Preview real trip moments` section while full app access remains gated for normal users.
- Focused StoreKit config validator and StoreKitTest hooks were added.
- Current screenshots still show `Subscription Unavailable`, so they prove fallback rendering/layout, not a purchasable subscription.

## App Store Reviewer Lens

Verdict: do not submit yet.

- Visible Support, Terms, and Privacy links exist and now pass direct HTTPS validation on `speaklocal.app`.
- There is no App Store Connect product-status, sandbox purchase, restore, relaunch entitlement, cancellation/expiration, or TestFlight proof.
- StoreKitTest purchase automation is skipped on this Mac because the only installed simulator runtime is iOS 26.5 and `xcodebuild` hits the known `SKInternalErrorDomain Code=3` class of StoreKitTest failure. Fresh rerun result bundle: `/tmp/speaklocal-paywall-storekit-latest.xcresult`.

## Skeptical Traveler Lens

Verdict: value promise is more concrete, but purchase proof is still missing.

- Food, coffee, city/place, phrase pages, Search, Saved, Practice, and supported audio are believable from current native-app truth.
- The user can now inspect three curated examples before trial.
- Strongest follow-up: prove the real App Store product state and Apple purchase sheet, then tune conversion with product screenshots if needed.

## Fixed From Review

- Changed top value line from broad `playable audio` to `supported playable audio`.
- Changed disclosure from generic `$4.99/month` to `$4.99/month in the U.S.` with App Store local-pricing confirmation.
- Renamed the main UI test away from placeholder language.
- Added StoreKitTest coverage that can become live proof when the local runtime/tooling allows it.
- Added a small curated preview section before the benefit rows.
- Added fresh first and scrolled screenshot artifacts, including preview proof.
- Fixed the public GitHub Pages HTTPS gate for Support, Terms, and Privacy.
- Rechecked local StoreKit CLI/Xcode routes and App Store Connect credential availability; no additional local purchase-proof path was available.

## Remaining Hard Blocks

- App Store Connect subscription product must be created/confirmed with final Jojo-approved offer metadata.
- Sandbox/TestFlight proof must show purchase, unlock, restore, relaunch persistence, and expiration/cancellation behavior.
- Visual proof must eventually show a purchasable StoreKit product, not `Subscription Unavailable`.
