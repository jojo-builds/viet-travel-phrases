# App Store Connect And Sandbox Handoff

Date: 2026-07-07
Target product ID: `app.speaklocal.vietnam.subscription.monthly`
Do not submit or charge real purchases from this packet.

## Current Local StoreKit State

Repo-local StoreKit config:

- File: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall/native-ios/Config/StoreKit/SpeakLocalPaywall.storekit`
- Product ID: `app.speaklocal.vietnam.subscription.monthly`
- Subscription period: `P1M`
- Display price: `4.99`
- Introductory offer: `free`, `P1W`

Durable validator added:

```sh
node native-ios/scripts/validate-paywall-storekit-config.js
```

Expected result:

```text
Paywall StoreKit config passed: app.speaklocal.vietnam.subscription.monthly P1M 4.99 free P1W
```

Focused StoreKitTest automation added in the branch:

- File: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall/native-ios/Tests/SubscriptionStoreKitTests.swift`
- Intent: load the local monthly trial product and prove a local purchase activates `SubscriptionStore`.
- Current CLI result on 2026-07-07: both StoreKitTest cases skipped because `xcodebuild test` against the only installed runtime, iOS 26.5, returned `SKInternalErrorDomain Code=3` and no products. The skip is deliberate so CI stays honest instead of recording a false failure as app logic.
- Apple Developer Forums currently tracks this class of `xcodebuild` / iOS 26.5 StoreKitTest issue at https://developer.apple.com/forums/thread/826971.
- Next proof path: rerun the same tests from Xcode IDE after a normal Run sync, on a fixed/older simulator runtime if available, or through sandbox/TestFlight.

## App Store Connect Setup Checklist

Jojo/private-account gates:

- Apple ID login and 2FA.
- Paid Apps Agreement acceptance if missing.
- Banking and tax forms if missing.
- Final approval for product ID, price, trial, localization, and submission.

Codex/orchestrator setup path after Jojo is present:

1. Open App Store Connect.
2. Confirm app record for SpeakLocal Vietnam.
3. Create or confirm subscription group: `SpeakLocal Vietnam Full Access`.
4. Create or confirm subscription: `SpeakLocal Vietnam Monthly`.
5. Use product ID: `app.speaklocal.vietnam.subscription.monthly`.
6. Set duration: 1 month.
7. Set price: USD $4.99.
8. Add introductory offer: free trial, 1 week.
9. Add subscription localization using native-truth copy.
10. Upload a paywall screenshot from the implemented native branch.
11. Save only after Jojo confirms any Apple-side product decisions.

## Sandbox / TestFlight Proof Matrix

Required before merging paywall to `main`:

| Proof | Required Evidence |
| --- | --- |
| Fresh install locked state | Screenshot/video showing paywall before purchase |
| Trial purchase | Apple purchase sheet completes successfully in sandbox/TestFlight |
| Unlock | App opens after verified entitlement |
| Relaunch persistence | Force quit/relaunch remains unlocked while entitlement is active |
| Restore | Fresh install + restore returns unlocked state for subscribed account |
| Cancellation/expiration | Sandbox/TestFlight expiration returns app to locked state |
| Legal/support links | Support, Terms, and Privacy open from paywall |
| Product metadata | App Store Connect product, price, intro offer, group, localization, and status recorded |

Apple note from current docs:

- TestFlight subscription renewals are accelerated; Apple says subscriptions renew daily up to 6 times in a 1-week period during TestFlight subscription testing.
- Some sandbox/product metadata changes can take time to appear, so record timestamps when waiting on Apple-side propagation.

## Public URL Gate

Paywall links:

- Support: `https://speaklocal.app/feedback/`
- Privacy: `https://speaklocal.app/privacy/`
- Terms: `https://speaklocal.app/terms/`

Current check on 2026-07-07:

```sh
curl -I -L --max-time 20 https://speaklocal.app/feedback/
curl -I -L --max-time 20 https://speaklocal.app/privacy/
curl -I -L --max-time 20 https://speaklocal.app/terms/
```

Result:

- All three requests reached a TLS gate but failed certificate validation.
- Error class: `SSL: no alternative certificate subject name matches target host name 'speaklocal.app'`.

Interpretation:

- This remains an App Store submission blocker.
- It now looks like a live HTTPS certificate/hostname configuration issue, not merely missing local page content.

## App Review Notes Draft

Use only after sandbox/TestFlight proof exists:

> SpeakLocal Vietnam uses an auto-renewable monthly subscription for full app access. The app offers a 7-day free trial, then renews monthly at the App Store-confirmed local price. The paywall includes Restore, Support, Terms, and Privacy links. The app is a curated Vietnam travel companion with food, places, phrase pages, supported playable audio, Search, Saved, and Practice. It is not a generic translator or language course.
