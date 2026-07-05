# SpeakLocal Vietnam Paywall / StoreKit Readiness Goal

## Objective

Get the native SpeakLocal Vietnam paywall lane as close as possible to production-ready without Jojo present. Work autonomously until the paywall is locally implemented, locally testable, documented, and blocked only by real Apple/App Store Connect/TestFlight facts that require Jojo.

## Workspace

- Canonical repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Target worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`
- Target branch: `feature/paywall`
- Do not merge paywall to `main`.
- Do not build `feature/paywall` onto Jojo's physical iPhone unless a later explicit instruction says to do that exact branch.

## Required Context

Read first:

1. `/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator/AGENTS.md`
2. `/Users/jojolim/Developer/products/speaklocal/app-family/AGENTS.md`
3. `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/AGENTS.md`
4. `docs/DECISIONS.md`
5. `docs/operations/CURRENT_BLOCKERS.md`
6. `docs/operations/TESTING_RUNBOOK.md`
7. `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
8. `docs/VIET_PREMIUM_EXPANSION_PLAN.md`

## Product Truth

- Subscription: Apple-native monthly subscription.
- Product ID: `app.speaklocal.vietnam.subscription.monthly`.
- Price/trial framing: 7-day free trial, then `$4.99/month`.
- No custom backend in this pass.
- No fake purchase or restore success in user-facing flows.
- Paid value is the full curated Vietnam companion: food/menu depth, city/place pages, audio, search, saved, and Practice.

## Work

1. Run the feature branch start gate:
   - `/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh start /Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`
   - If the paywall worktree is dirty, inspect and checkpoint or stop with a clear note before syncing. Never overwrite uncommitted work.
2. Audit the current paywall implementation:
   - StoreKit product loading
   - purchase
   - restore
   - entitlement persistence across relaunch
   - gated locked/unlocked states
   - copy and error states
   - missing App Store Connect/TestFlight requirements
3. Implement safe missing pieces in the paywall worktree only.
4. Add regression coverage for local StoreKit behavior as far as the repo and Xcode allow.
5. Run local validation:
   - `git diff --check`
   - focused unit tests for StoreKit/paywall models
   - focused UI tests for paywall screen, gating, restore, and relaunch persistence if available
   - a simulator build/run if app code changed
6. Produce a handoff receipt at:
   - `docs/task-results/parallel-goals-2026-07-05/paywall-storekit-report.md`

## Stop Conditions

Stop only for:

- App Store Connect credentials or product state that cannot be checked locally.
- A real StoreKit/TestFlight purchase/restore step that requires Jojo.
- Signing secrets or personal identifiers.
- Conflicts involving unrelated user changes.

## Reporting

Send compact updates using:

- `**Status Update**`
- `**Decision Needed**`
- `**Jojo Test Request**`

Final report must include:

- branch/worktree used
- exact paywall status
- what works locally
- what still requires Apple/TestFlight/Jojos involvement
- tests run with counts
- whether paywall is merge-ready, fix-first, or blocked
