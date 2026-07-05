# Paywall Readiness Audit

Worker: D
Date: 2026-07-04
Lane: `feature/paywall`
Mode: read-only audit, except this assigned report file

## Summary Verdict And Recommendation

Recommendation: ship the current non-paywall `main` app first. Do not include paywall in the near-term launch unless Jojo deliberately pauses launch work for a separate paywall integration/proof cycle.

The paywall lane contains a real native StoreKit 2 skeleton, not just a note. It adds a root access gate, onboarding placeholder, Apple `SubscriptionStoreView` paywall, local StoreKit config, test launch arguments, unit tests, and UI tests. However, it is not merge-ready today:

- It is stale versus current `main`; current `main` has hundreds of commits not in the paywall lane.
- It touches integration hotspots that also changed on `main`: `native-ios/App/Views/AppShellView.swift`, `native-ios/project.yml`, generated Xcode project files, `AGENTS.md`, `native-ios/AGENTS.md`, and operational docs.
- It has no current 2026-07-04 simulator proof after syncing with latest `main`.
- It has no real App Store/TestFlight purchase, restore, relaunch-persistence, or App Store Connect product-state proof.
- It gates the whole app at launch rather than proving a polished free-versus-premium boundary inside the current traveler experience.

Near-term launch realism: low for including paywall safely. The realistic path is non-paywall launch first, then a dedicated paywall lane refresh, conflict resolution, simulator proof, TestFlight/sandbox proof, and an explicit merge decision.

## Exact Branch And Worktree State

Command evidence from `/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator` and repo root:

- `./scripts/status.sh`
  - `main` is at `07a2db5d8` (`Record launch readiness phone proof`).
  - `main` is ahead of `origin/main` by 20 commits and has active doc/ops edits from the launch-readiness work.
  - `feature/paywall` worktree exists at `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`.
  - `feature/paywall` is at `775687823` (`Merge main into paywall lane`).
- `git status --short --branch` inside `.worktrees/paywall`
  - clean: `## feature/paywall`
- `git cherry -v main feature/paywall`
  - `+ 9198b4af3 Set up paywall feature lane`
  - `+ 641e2b7d2 Add native subscription paywall skeleton`
- `git rev-list --left-right --count main...feature/paywall`
  - `289 6`
  - Interpretation: this lane is materially stale; `main` has 289 commits not in the paywall lane, and paywall has 6 commits including merge commits not in `main`.
- `git merge-base main feature/paywall`
  - `8db32da6f149e5ca410d6810cd9b9a65336f77c0` (`Merge bug-hunt usability`)
  - Current `main` is not an ancestor of `feature/paywall`; `feature/paywall` is not an ancestor of `main`.
- Files changed on both sides since the merge-base:
  - `AGENTS.md`
  - `docs/PRIORITIES.md`
  - `docs/operations/CURRENT_BLOCKERS.md`
  - `docs/operations/LATEST_VALIDATION.md`
  - `native-ios/AGENTS.md`
  - `native-ios/App/Views/AppShellView.swift`
  - `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`
  - `native-ios/project.yml`

Classification: `skip-paywall`, clean but stale, not ready to merge.

## What Paywall Implements Now

Main implementation commit:

- `641e2b7d2 Add native subscription paywall skeleton`

Added/changed surfaces:

- `native-ios/App/Models/SubscriptionAccessState.swift`
  - Defines product ID `app.speaklocal.vietnam.subscription.monthly`.
  - Defines entitlement states: loading, active, inactive, failed.
  - Defines gate destinations: app, onboarding, paywall.
  - Keeps pure gate decision logic testable.
- `native-ios/App/Models/SubscriptionStore.swift`
  - Uses StoreKit 2 APIs: `Product.products(for:)`, `Transaction.currentEntitlements`, `Transaction.updates`, `AppStore.sync()`.
  - Caches active access in `UserDefaults` as a temporary launch-continuity hint.
  - Clears cached access when StoreKit says no entitlement is active.
- `native-ios/App/Views/AccessGateView.swift`
  - Replaces direct app launch with a root access gate.
  - Shows `AppShellView`, onboarding, or paywall depending on entitlement/onboarding/debug state.
  - Supports test/dev launch arguments:
    - `--subscription-bypass`
    - `--force-subscription-onboarding`
    - `--force-subscription-paywall`
    - `--reset-subscription-onboarding`
    - `--clear-subscription-cache`
  - Allows UI tests to bypass the gate unless a forced subscription state is passed.
- `native-ios/App/Views/SubscriptionPaywallView.swift`
  - Uses Apple `SubscriptionStoreView(productIDs:)`.
  - Shows simple placeholder copy: `Start your 7-day free trial`, `Then $4.99/month`.
  - Includes `Restore`, Terms, and Privacy controls.
  - Calls `store.refresh()` after purchase completion and `store.restore()` for restore.
- `native-ios/App/SpeakLocalNativeApp.swift`
  - Launches `AccessGateView()` instead of `AppShellView()`.
- `native-ios/Config/StoreKit/SpeakLocalPaywall.storekit`
  - Local StoreKit config with one monthly auto-renewable subscription:
    - Product ID: `app.speaklocal.vietnam.subscription.monthly`
    - Display price: `4.99`
    - Period: `P1M`
    - Introductory offer: free `P1W`
- `native-ios/project.yml` and generated Xcode project/scheme
  - Add StoreKit config and paywall source/test files.
- Tests:
  - `native-ios/Tests/SubscriptionAccessStateTests.swift`
    - Covers active entitlement, debug bypass, inactive onboarding/paywall decisions, cached loading continuity, failed/no-cache behavior, cache coding, and UI-test environment detection.
  - `native-ios/UITests/SubscriptionGateUITests.swift`
    - Covers bypass launch, forced onboarding placeholder, forced paywall placeholder.

Current main already has updated product truth aligning with monthly subscription direction:

- `docs/DECISIONS.md` says Viet v2 uses Apple-native monthly subscription through StoreKit: 7-day free trial, then `$4.99/month`.
- `docs/VIET_PREMIUM_EXPANSION_PLAN.md` preserves product ID `app.speaklocal.vietnam.subscription.monthly` and the same trial/monthly target.
- `strategy/v2-conversion-assets-2026-04-14.md` now frames the subscription and App Store Connect confirmation work around the same product ID.

## Existing Proof

Branch-local historical evidence in `.worktrees/paywall/docs/operations/LATEST_VALIDATION.md` says a 2026-05-21 paywall sync/build pass previously had:

- `git diff --check` passed.
- XcodeBuildMCP simulator build on `SpeakLocal Paywall 26.5` passed.
- `xcodebuild -only-testing:SpeakLocalNativeTests/SubscriptionAccessStateTests test` passed: 10 tests, 0 failures.
- `xcodebuild -only-testing:SpeakLocalNativeUITests/SubscriptionGateUITests test` passed: 3 tests, 0 failures.
- Manual simulator checks showed no-entitlement onboarding, Continue to paywall, forced paywall with Apple-native shell/Restore/Terms/Privacy, and bypass path.
- It also recorded that local/direct simulator launch still showed `Subscription Unavailable`, so real purchase/restore/relaunch proof remained Apple-side/TestFlight or StoreKit-session work.
- No physical iPhone build was installed from paywall in that pass.

That proof is useful history, but it is not current enough for a July 4 merge decision because the lane is now far behind `main`.

Fresh checks in this audit:

- `git diff --check main...feature/paywall`: passed for the branch-unique paywall patch.
- `git diff --check main..feature/paywall`: failed with whitespace findings in older docs/strategy content when comparing raw current `main` to the stale branch. I would treat this as a stale-branch integration warning, not a narrow paywall-code bug.
- No simulator build, UI test, TestFlight test, or physical iPhone build was run during this read-only audit.

## Missing Proof And Gates Before Merge

Must happen before this can be safely considered for `main`:

1. Refresh paywall onto current `main` in the paywall worktree, preserving both feature intents.
   - Do not take whole files from paywall or main in hotspots like `AppShellView.swift`, `project.yml`, or generated project files.
   - Regenerate the Xcode project from current `project.yml` after integration.
2. Re-run branch validation after sync.
   - `git diff --check`
   - native-only guard if project/workflow files changed
   - focused unit tests for `SubscriptionAccessStateTests`
   - focused UI tests for `SubscriptionGateUITests`
   - full native build on a dedicated simulator such as `SpeakLocal Paywall`
3. Re-prove the actual app experience after sync.
   - Natural first launch with no entitlement.
   - Continue from onboarding to paywall.
   - Forced paywall.
   - Subscription bypass path for internal QA.
   - App opens after active entitlement.
   - Locked/inactive state blocks premium or app access according to the intended product boundary.
4. Prove Apple-side behavior.
   - Confirm App Store Connect product state for `app.speaklocal.vietnam.subscription.monthly`.
   - Confirm 7-day trial and `$4.99/month` price are live/approved.
   - Use TestFlight or agreed native release path.
   - Capture real purchase sheet or exact failure.
   - Verify purchase unlock.
   - Force-close/relaunch and verify entitlement persistence.
   - Delete/reinstall or otherwise prove restore.
5. Make a deliberate product decision about gating.
   - Current paywall branch gates the whole app at launch.
   - Launch may prefer a non-paywall app, a free-first app with premium boundaries, or a whole-app trial gate; that needs explicit confirmation before shipping.
6. Legal/support copy confirmation.
   - Paywall currently links to Apple standard EULA and Apple privacy URL.
   - Shipping copy should match the actual app privacy/support/legal surfaces and App Store metadata.

## Risks If Rushing Paywall

- Merge risk: the branch is stale enough that a quick merge could regress current launch-readiness work, generated resources, project configuration, app chrome, or recent Practice/Browse/Home changes.
- Store risk: local StoreKit config does not prove App Store Connect product readiness, sandbox purchase behavior, restore, or relaunch entitlement persistence.
- UX risk: whole-app gating may block a successful non-paywall launch or hide the freshly validated traveler experience behind placeholder onboarding/paywall copy.
- Review risk: subscription terms, privacy/terms links, trial copy, and pricing must exactly match App Store configuration.
- QA risk: the branch has historical simulator proof, but no fresh July 4 proof against current `main`.
- Operational risk: building paywall to Jojo's physical phone would replace the normal `main` build under the same bundle ID; this audit intentionally did not do that.

## Final Recommendation

Ship current non-paywall `main` first. Keep `feature/paywall` excluded for this launch-readiness push.

Paywall should become its own follow-up launch lane with a clear proof plan:

1. Sync with current `main`.
2. Resolve native/project conflicts carefully.
3. Rebuild and retest in a dedicated simulator.
4. Prove App Store Connect/TestFlight purchase, restore, and relaunch persistence.
5. Then make a conscious merge decision.

## Files Edited

I edited only this assigned report:

- `docs/task-results/launch-readiness-audit-2026-07-04/paywall-readiness-audit.md`

I did not merge paywall, did not build paywall to Jojo's physical phone, and did not edit app code.
