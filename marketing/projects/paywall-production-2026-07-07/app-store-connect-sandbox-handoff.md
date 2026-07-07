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
- Fresh rerun after HTTPS repair used result bundle `/tmp/speaklocal-paywall-storekit-latest.xcresult`: total 2 tests, skipped 2, failed 0, result `Skipped`.
- Local tooling checked after that rerun:
  - `xcrun storekit --help` fails because this Xcode install does not include the `storekit` command-line utility.
  - `xcodebuild -help` exposes no StoreKit-specific launch/test flag.
  - XcodeGen accepts `test.storeKitConfiguration` in a temp spec but does not emit a StoreKit reference in the generated `TestAction`, so adding it would be a no-op.
- Apple Developer Forums currently tracks this class of `xcodebuild` / iOS 26.5 StoreKitTest issue at https://developer.apple.com/forums/thread/826971.
- Next proof path: rerun the same tests from Xcode IDE after a normal Run sync, on a fixed/older simulator runtime if available, or through sandbox/TestFlight.

## Current Native Paywall State

- Branch UI now includes a small `Preview real trip moments` section with coffee, place, and repair examples before the benefit rows.
- Full app access remains gated after onboarding unless an active entitlement, cached active entitlement, or debug/test bypass is present.
- Fresh access-state result bundle: `/tmp/speaklocal-paywall-access-latest-rerun.xcresult`, total 22 tests, failed 0.
- Fresh UI result bundle: `/tmp/speaklocal-paywall-ui-latest.xcresult`, total 5 tests, failed 0, first and scrolled screenshots exported.
- Fresh screenshot caveat: the local StoreKit view still renders `Subscription Unavailable`, so screenshots are layout/preview/fallback proof only.

## App Store Connect Setup Checklist

Jojo/private-account gates:

- Apple ID login and 2FA.
- Paid Apps Agreement acceptance if missing.
- Banking and tax forms if missing.
- Final approval for product ID, price, trial, localization, and submission.

Current account-access check from this session:

- No App Store Connect API environment variables were present.
- No expected App Store Connect API key files were found in narrow local credential paths.
- The in-app browser could not load App Store Connect within two attempts.
- `curl -I -L --max-time 20 https://appstoreconnect.apple.com/login` returned HTTP `200`, so the public login page is reachable, but authenticated Apple-side setup is not accessible from this session.

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
10. Upload a paywall screenshot only after the product state is working; the current branch screenshots are internal fallback/preview proof.
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

Current check on 2026-07-07 after GitHub Pages repair:

```sh
env HTTPS_PROXY= HTTP_PROXY= ALL_PROXY= curl -I -L --max-time 30 https://speaklocal.app/feedback/
env HTTPS_PROXY= HTTP_PROXY= ALL_PROXY= curl -I -L --max-time 30 https://speaklocal.app/privacy/
env HTTPS_PROXY= HTTP_PROXY= ALL_PROXY= curl -I -L --max-time 30 https://speaklocal.app/terms/
openssl s_client -servername speaklocal.app -connect speaklocal.app:443 </dev/null 2>/dev/null | openssl x509 -noout -subject -ext subjectAltName
```

Result:

- All three HTTPS routes returned HTTP `200` with SSL verify result `0` in direct checks.
- Certificate subject is `CN=speaklocal.app`.
- Subject Alternative Name includes `DNS:speaklocal.app` and `DNS:www.speaklocal.app`.
- GitHub Pages API reports status `built`, `https_enforced: true`, and certificate state `approved`.

Interpretation:

- The previous App Store URL submission blocker is fixed for direct external checks.
- If a local proxy or CDN edge still shows the previous `*.github.io` certificate immediately after the repair, wait for edge propagation and rerun the direct checks above before treating it as a new blocker.

## App Review Notes Draft

Use only after sandbox/TestFlight proof exists:

> SpeakLocal Vietnam uses an auto-renewable monthly subscription for full app access. The app offers a 7-day free trial, then renews monthly at the App Store-confirmed local price. The paywall includes Restore, Support, Terms, and Privacy links. The app is a curated Vietnam travel companion with food, places, phrase pages, supported playable audio, Search, Saved, and Practice. It is not a generic translator or language course.
