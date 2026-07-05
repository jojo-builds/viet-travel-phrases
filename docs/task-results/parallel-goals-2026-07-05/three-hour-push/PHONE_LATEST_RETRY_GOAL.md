# Exact-Current Phone Retry Goal

## Objective

Keep trying to prove exact-current `main` on Jojo's newly active iPhone, without leaking device, signing, Team, profile, or certificate identifiers.

Current known state:

- earlier phone worker could not see a usable paired physical destination;
- simulator fallback succeeded on an older app-code commit;
- current `main` now includes additional app-code fixes after that fallback.

The goal is to get the latest `main` installed and launched on the phone if the device becomes available. If not available, produce a clean current blocker report and a simulator fallback receipt.

## Constraints

- Build only from `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Do not build feature branches to the phone.
- Do not touch or merge paywall.
- Keep signing local. Do not write personal signing identifiers into repo files, docs, logs, or final reports.
- If credentials, certificates, Apple account prompts, or destructive device actions are required, stop and report the blocker.

## Suggested Flow

- Confirm current branch and commit.
- Run the repo's phone build helper or documented device-build skill path.
- If the phone is not available, wait and retry periodically during the work window.
- If install succeeds but launch is blocked because the phone is locked, report install success and launch blocker separately.
- If physical proof remains unavailable, build/launch exact-current `main` on a simulator as fallback and say clearly that this is not physical-device proof.

## Report

Write:

`docs/task-results/parallel-goals-2026-07-05/three-hour-push/phone-latest-retry-report.md`

Include:

- current `main` commit attempted;
- physical build/install/launch result;
- fallback simulator result, if used;
- signing hygiene status;
- exact next step Jojo should take, if blocked.
