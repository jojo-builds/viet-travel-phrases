# Paywall Final Risk Report

Date: 2026-07-05
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
Paywall lane: `feature/paywall`
Paywall worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`

## Recommendation

Ship the current non-paywall native app first, then ship paywall as an update after Apple-side subscription proof is complete.

Reason: `feature/paywall` has a useful native StoreKit skeleton and green local XCTest proof, but it still lacks the revenue-critical proof that only App Store Connect/TestFlight/sandbox or a real device StoreKit path can provide: purchase, restore, relaunch persistence, locked/unlocked gating, and confirmed production product state. Waiting for paywall before the initial release is only worth it if Jojo wants the first public build to be subscription-gated from day one.

## Branch Relationship

- `main` head inspected: `abd3f3a6e1`
- `feature/paywall` head inspected: `453d6f55ac`
- merge base inspected: `b101ed4195`
- `feature/paywall` worktree was clean before and after this pass.
- No merge, rebase, start-gate sync, app-runtime edit, device build, real purchase, paid service, or App Store Connect change was performed.
- `main` had pre-existing dirty task-result/proof files; I only added this report.

Command:

```sh
git cherry -v main feature/paywall
```

Outcome:

```text
+ 9198b4af34e033cc1ce9f12af166d545024272c3 Set up paywall feature lane
+ 641e2b7d2c2722e638474a184136e2f973011952 Add native subscription paywall skeleton
+ dc76fd5bea8441e570cc57463c9f6a033e4ce84d Harden paywall StoreKit readiness
+ 453d6f55ac4f505e3c26145fd9f8a0df0e195af9 Fix paywall StoreKit test host readiness
```

Interpretation: paywall remains outside `main`.

## Existing Paywall Proof

The paywall lane already contains:

- `SubscriptionAccessState` decision logic and cached-access tests.
- `SubscriptionStore` using StoreKit 2 product loading, current entitlements, transaction updates, cache, and restore.
- `AccessGateView` with onboarding, paywall, app, debug bypass, forced test states, and hosted-unit-test host bypass.
- `SubscriptionPaywallView` using Apple's subscription UI surface with fallback/restore affordances.
- StoreKit config for product `app.speaklocal.vietnam.subscription.monthly`, monthly period `P1M`, display price `4.99`, and introductory offer `P1W`.
- prior task report: `docs/task-results/parallel-goals-2026-07-05/three-hour-push/paywall-storekit-report.md`

Config command:

```sh
jq '.subscriptionGroups[] | {id, name, subscriptions: [.subscriptions[] | {productID, referenceName, type, displayPrice, recurringSubscriptionPeriod, introductoryOffer}]}' native-ios/Config/StoreKit/SpeakLocalPaywall.storekit
```

Outcome: parsed successfully and confirmed one recurring subscription in group `SpeakLocal Vietnam`: `app.speaklocal.vietnam.subscription.monthly`, `4.99`, `P1M`, with free introductory offer `P1W`.

## Fresh Validation

First attempted command:

```sh
xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' -derivedDataPath /tmp/speaklocal-paywall-risk-derived-1783257173 CODE_SIGNING_ALLOWED=NO -skip-testing:SpeakLocalNativeUITests -only-testing:SpeakLocalNativeTests/SubscriptionAccessStateTests test
```

Outcome: failed before tests because the generic `iPhone 17 Pro` destination matched multiple renamed simulators. No paywall assertions ran.

Rerun command:

```sh
xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -configuration Debug -destination 'platform=iOS Simulator,name=SpeakLocal Paywall,OS=26.5' -derivedDataPath /tmp/speaklocal-paywall-risk-derived-1783257173 CODE_SIGNING_ALLOWED=NO -skip-testing:SpeakLocalNativeUITests -only-testing:SpeakLocalNativeTests/SubscriptionAccessStateTests test
```

Outcome:

```text
SubscriptionAccessStateTests passed.
Executed 13 tests, with 0 failures.
** TEST SUCCEEDED **
```

This is the smallest honest local paywall guard: it proves entitlement/onboarding/paywall routing, cache expiration behavior, debug/UI-test bypass detection, and hosted-unit-test detection without requiring purchase credentials.

## Remaining Paywall Risks

- Real purchase flow and App Store sheet behavior are unproven.
- Restore is wired in code, but restore success/failure needs sandbox/device proof.
- Relaunch persistence from Apple's actual transaction state is unproven.
- Expired, canceled, revoked, and grace-period subscription states are unproven.
- App Store Connect product, subscription group, price, trial, metadata, and bundle mapping still need confirmation outside this repo.
- Current branch gates the whole app after onboarding; it does not yet implement a free starter layer with route-level premium locks.
- Final paywall copy, benefit framing, legal wording, and first-release gating strategy still need Jojo/product approval.

## Fastest Revenue-Safe Path

Best default: release the current non-paywall native app first, because current `main` has broad non-paywall validation and paywall is explicitly excluded. Then finish paywall in `feature/paywall` with App Store Connect/TestFlight/sandbox proof and ship it as an update.

Alternate path: hold initial release for paywall only if Jojo decides subscription gating is mandatory for day-one launch. That path needs App Store Connect setup, sandbox/TestFlight purchase proof, restore proof, relaunch proof, and a product decision on whole-app gate vs starter/free layer before merge.
