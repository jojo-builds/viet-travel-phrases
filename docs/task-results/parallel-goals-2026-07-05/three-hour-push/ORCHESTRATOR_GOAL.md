# SpeakLocal Three-Hour Parallel Launch Push

Date: 2026-07-05
Owner: orchestrator
Repo truth: `/Users/jojolim/Developer/products/speaklocal/app-family`
Live app branch: `main`
Paywall branch: `feature/paywall` stays isolated unless Jojo explicitly requests merge.

## Objective

Use the next three hours to push SpeakLocal Vietnam toward launch without requiring Jojo. Work should be useful even if no single item reaches final release. Prefer concrete evidence, committed safe improvements, and durable handoffs over vague exploration.

## Current Baseline

- `main` is at `b101ed419 Record current launch validation status`.
- `main` is ahead of origin.
- Untracked proof artifacts exist under `docs/task-results/**`; do not delete or stage them unless the worker owns the output.
- `feature/paywall` is synced to current `main` and has three paywall commits not merged into `main`.
- Exact-current physical iPhone proof is still pending because the previous attempt did not find an available paired device.

## Parallel Lanes

1. Phone/device readiness and exact-current `main` proof.
2. Paywall StoreKit validation and revenue-gate hardening in `feature/paywall`.
3. App Store and launch asset prep under `marketing/`.
4. Traveler-grade visual/function QA on current `main`, with safe bug fixes in a separate lane if needed.

## Shared Rules

- Do not merge paywall into `main`.
- Do not build feature branches to Jojo's phone unless explicitly told.
- Keep raw device IDs, phone names, Team IDs, provisioning IDs, and certificate details out of docs and chat.
- If app code changes, use a feature worktree, validate there, commit, and leave a clear merge recommendation.
- If work is read-only or docs/marketing only, write a durable report under this folder or the relevant `marketing/` folder.
- Use native iOS only. Do not route through Expo, React Native, Metro, or `app/`.
- Prefer current repo evidence over stale chat context.
- Continue within the lane for the full run if the primary task finishes early: expand QA coverage, add proof, or tighten the handoff.

## End State Wanted

At the end of the run, the orchestrator should know:

- whether the latest `main` is installed/launched on the current iPhone, or the exact blocker if not;
- whether the paywall lane is technically ready for Jojo to test, and what still needs App Store Connect/product input;
- what launch/App Store assets or plans are ready to use;
- what visual/function bugs were found, fixed, or remain as launch blockers.
