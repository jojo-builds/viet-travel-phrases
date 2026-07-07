# Paywall Review Gate

Date: 2026-07-07
Branch: `feature/paywall`

## Marketer Lens

Verdict: acceptable branch direction, not public-launch complete.

- The strongest current narrative is `Trip Companion Gate`: a curated Vietnam companion, not a translator or school course.
- The 7-day trial / $4.99 monthly working offer is clear, but public copy must keep the App Store in charge of eligibility, local price, renewal date, and cancellation.
- The top value line now scopes audio as `supported playable audio`.
- Follow-up: add product-context visuals or a preview policy before asking cold users to trust the full gate.

## iOS Developer Lens

Verdict: branch implementation is materially stronger, but purchase proof remains blocked.

- Paywall layout now uses native SwiftUI glass styling, stable wrapping footer links, a first-viewport trial section, and focused UI tests.
- `SubscriptionStoreView` is present and restore remains available.
- Focused StoreKit config validator and StoreKitTest hooks were added.
- Current screenshots still show `Subscription Unavailable`, so they prove fallback rendering/layout, not a purchasable subscription.

## App Store Reviewer Lens

Verdict: do not submit yet.

- Visible Support, Terms, and Privacy links exist, but the public `speaklocal.app` HTTPS certificate currently fails validation.
- There is no App Store Connect product-status, sandbox purchase, restore, relaunch entitlement, cancellation/expiration, or TestFlight proof.
- StoreKitTest purchase automation is skipped on this Mac because the only installed simulator runtime is iOS 26.5 and `xcodebuild` hits the known `SKInternalErrorDomain Code=3` class of StoreKitTest failure.

## Skeptical Traveler Lens

Verdict: value promise is plausible but needs concrete preview/proof before conversion confidence.

- Food, coffee, city/place, phrase pages, Search, Saved, Practice, and supported audio are believable from current native-app truth.
- The paywall still asks for trust before the user sees enough app substance unless the production preview policy changes.
- Strongest follow-up: let users inspect a small curated preview before trial, then gate Save/Practice/deep access.

## Fixed From Review

- Changed top value line from broad `playable audio` to `supported playable audio`.
- Changed disclosure from generic `$4.99/month` to `$4.99/month in the U.S.` with App Store local-pricing confirmation.
- Renamed the main UI test away from placeholder language.
- Added StoreKitTest coverage that can become live proof when the local runtime/tooling allows it.
- Added fresh first and scrolled screenshot artifacts.

## Remaining Hard Blocks

- Public legal/support URLs must pass HTTPS validation.
- App Store Connect subscription product must be created/confirmed with final Jojo-approved offer metadata.
- Sandbox/TestFlight proof must show purchase, unlock, restore, relaunch persistence, and expiration/cancellation behavior.
- Visual proof must eventually show a purchasable StoreKit product, not `Subscription Unavailable`.
