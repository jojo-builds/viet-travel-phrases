# Worker Goal: Paywall StoreKit Readiness

Run time target: at least 3 hours or until the paywall lane is technically ready for Jojo testing and fully documented.

## Objective

Advance `feature/paywall` as far as possible without merging it into `main`: StoreKit configuration, purchase/restore behavior, entitlement state, premium gating, and simulator proof.

## Starting Context

- Paywall worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`
- Branch: `feature/paywall`
- Baseline: `5bc336f9e Merge current main status into paywall lane`
- `git cherry -v main feature/paywall` should show the paywall-only commits.

## Required Reading

Read:

- `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall/AGENTS.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall/native-ios/AGENTS.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall/docs/operations/README.md`
- relevant StoreKit/paywall implementation files discovered with `rg "StoreKit|Paywall|Entitlement|Subscription|premium" native-ios/App native-ios/Tests native-ios`

## Work Plan

1. Run the feature start gate:
   `/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh start paywall`
2. Confirm the paywall worktree is on `feature/paywall` and has no unrelated dirty files.
3. Audit paywall code paths:
   - product loading;
   - free vs premium access;
   - purchase and restore actions;
   - StoreKit test configuration;
   - failure/loading/cancel states;
   - premium content route gates.
4. Run focused simulator build/tests. Use a paywall-specific simulator if doing UI work.
5. Fix safe technical issues in the paywall lane only.
6. Commit finished paywall work on `feature/paywall` if changed.

## Constraints

- Do not merge paywall into `main`.
- Do not build paywall to Jojo's physical phone.
- Do not make App Store Connect or pricing decisions for Jojo.
- Do not invent product IDs if the repo already has expected IDs; if product IDs need Jojo/App Store Connect, document exactly what is needed.

## Output

Write a report to:

`/Users/jojolim/Developer/products/speaklocal/app-family/docs/task-results/parallel-goals-2026-07-05/three-hour-push/paywall-storekit-report.md`

Include:

- branch and commit;
- what works now;
- what was fixed;
- simulator/build/test proof;
- exact App Store Connect or Jojo decisions still needed;
- recommendation: `ready for Jojo test`, `fix first`, or `blocked on external setup`.
