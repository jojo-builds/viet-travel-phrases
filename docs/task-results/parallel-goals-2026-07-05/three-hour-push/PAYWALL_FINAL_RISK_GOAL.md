# Paywall Final Risk Goal

Date: 2026-07-05
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`

## Objective

Do a read-only/low-risk paywall readiness pass while keeping `feature/paywall` isolated from `main`.

## Constraints

- Do not merge paywall.
- Do not edit app runtime code unless a tiny test/report fix is clearly needed and safe.
- Do not use paid services or real purchases.
- Do not include raw device IDs, phone names, Team IDs, provisioning IDs, certificate details, or App Store credentials in reports.

## Work

1. Inspect `feature/paywall` and current `main` relationship.
2. Confirm what StoreKit/XCTest proof exists and what still needs real-device or App Store Connect proof.
3. Identify the fastest revenue-safe path:
   - ship non-paywall first, then paywall update;
   - or finish paywall before initial release.
4. Produce a compact report at `docs/task-results/parallel-goals-2026-07-05/three-hour-push/paywall-final-risk-report.md`.

## Validation

- Run `git cherry -v main feature/paywall`.
- Run the smallest honest paywall test/guard that does not require real purchase credentials.
- Record exact commands and outcomes.

## Stop Conditions

Stop if the task would require credentials, App Store Connect changes, destructive git operations, real purchases, or a merge decision from Jojo.
