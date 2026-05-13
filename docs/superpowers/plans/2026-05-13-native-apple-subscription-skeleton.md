# Native Apple Subscription Skeleton Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the smallest native Apple subscription foundation for the paywall lane: StoreKit 2 entitlement truth, Apple-native placeholder subscription UI, onboarding/paywall root gate, and local testing seams.

**Architecture:** `SpeakLocalNativeApp` owns a root `AccessGate` before `AppShellView`. `SubscriptionStore` wraps StoreKit 2 product loading, purchase/restore, current entitlements, and transaction updates. `SubscriptionAccessState` keeps the pure entitlement/gate decisions testable without StoreKit, while the paywall itself uses Apple's `SubscriptionStoreView` as the placeholder UI.

**Tech Stack:** SwiftUI, StoreKit 2, Xcode StoreKit configuration, XCTest, existing XcodeGen project.

---

### Task 1: Test The Subscription Gate State

**Files:**
- Create: `native-ios/App/Models/SubscriptionAccessState.swift`
- Create: `native-ios/Tests/SubscriptionAccessStateTests.swift`
- Modify: `native-ios/project.yml`

- [x] **Step 1: Write the failing tests**

Create `native-ios/Tests/SubscriptionAccessStateTests.swift` with tests that assert: active entitlement opens the app, debug bypass opens the app in DEBUG flows, inactive entitlement after onboarding shows paywall, inactive entitlement before onboarding shows onboarding, loading with cached active access opens the app as a temporary continuity state, and failed/no cache shows paywall after onboarding.

- [x] **Step 2: Run test to verify it fails**

Run:

```bash
cd native-ios
xcodegen generate
xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/SubscriptionAccessStateTests
```

Expected: compile failure because `SubscriptionAccessState` does not exist yet.

- [x] **Step 3: Implement the pure state reducer**

Create `native-ios/App/Models/SubscriptionAccessState.swift` with:
- `SubscriptionEntitlementStatus`: `loading`, `active`, `inactive`, `failed`
- `SubscriptionGateDestination`: `app`, `onboarding`, `paywall`
- `SubscriptionAccessSnapshot`
- `SubscriptionAccessDecision.resolve(_:)`

- [x] **Step 4: Run test to verify it passes**

Run the same focused test command. Expected: `SubscriptionAccessStateTests` passes.

### Task 2: Add StoreKit 2 Subscription Store

**Files:**
- Create: `native-ios/App/Models/SubscriptionStore.swift`
- Test: `native-ios/Tests/SubscriptionAccessStateTests.swift`

- [x] **Step 1: Extend tests around cached state serialization**

Add tests for storing and loading `CachedSubscriptionAccess` with product ID and timestamp, so launch continuity is testable without StoreKit.

- [x] **Step 2: Run test to verify it fails**

Run `SubscriptionAccessStateTests`. Expected: compile failure because cache types do not exist.

- [x] **Step 3: Implement StoreKit wrapper**

Create `SubscriptionStore` as a `@MainActor ObservableObject` using:
- `Product.products(for:)`
- `product.purchase()`
- `Transaction.currentEntitlements`
- `Transaction.updates`
- `AppStore.sync()`

Use product ID `app.speaklocal.vietnam.subscription.monthly` for this branch skeleton. Keep cached active access as a temporary launch hint only; StoreKit refresh remains the authority.

- [x] **Step 4: Run focused tests**

Run `SubscriptionAccessStateTests`. Expected: pass.

### Task 3: Add Apple-Native Placeholder Gate And Paywall

**Files:**
- Modify: `native-ios/App/SpeakLocalNativeApp.swift`
- Create: `native-ios/App/Views/AccessGateView.swift`
- Create: `native-ios/App/Views/SubscriptionPaywallView.swift`

- [x] **Step 1: Add UI test seams first**

Add UI assertions in an existing UI test or new `native-ios/UITests/SubscriptionGateUITests.swift` for launch arguments:
- `--subscription-bypass` opens the app
- `--force-subscription-paywall` shows the paywall
- `--reset-subscription-onboarding` clears local onboarding state

- [x] **Step 2: Run UI test to verify it fails**

Run the new focused UI test. Expected: fails because launch args and views do not exist.

- [x] **Step 3: Implement root gate and Apple placeholder**

Change `SpeakLocalNativeApp` to launch `AccessGateView`. Add:
- 2 simple placeholder onboarding screens
- `SubscriptionStoreView(groupID:)` when available, backed by product ID fallback actions if needed
- visible `Start 7-day free trial`, `Restore`, `Terms`, `Privacy` labels/links
- DEBUG-only bypass button or launch argument

- [x] **Step 4: Run UI test**

Run the focused UI test. Expected: pass.

### Task 4: Add Local StoreKit Config

**Files:**
- Create: `native-ios/Config/StoreKit/SpeakLocalPaywall.storekit`
- Modify: `native-ios/project.yml` if the config must be copied into the project/scheme

- [x] **Step 1: Add StoreKit config with one monthly auto-renewable subscription**

Use one subscription group and one product:
- Product ID: `app.speaklocal.vietnam.subscription.monthly`
- Duration: monthly
- Introductory offer: 7-day free trial
- Price placeholder: `$4.99`

- [x] **Step 2: Regenerate project**

Run:

```bash
cd native-ios
xcodegen generate
```

Expected: generated project includes the new Swift files and remains signing-clean.

### Task 5: Validate The Skeleton

**Files:**
- Existing native project files only.

- [x] **Step 1: Run scope checks**

Run:

```bash
git diff --check
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj
```

Expected: no whitespace errors; project files changed only because new sources/config were intentionally registered.

- [x] **Step 2: Run focused native tests**

Run:

```bash
cd native-ios
xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/SubscriptionAccessStateTests
```

Expected: tests pass.

- [x] **Step 3: Run focused build**

Run:

```bash
cd native-ios
xcodebuild build -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Expected: build passes.

---

## Self-Review

- Spec coverage: Native-only Apple methods are covered through SwiftUI, StoreKit 2, and Xcode StoreKit config. Third-party billing/IAP tools are intentionally out of scope.
- Placeholder scan: no implementation placeholders are left in the plan; placeholder UI means intentionally generic paywall copy, not missing plumbing.
- Type consistency: state and store names are consistent across tasks.
