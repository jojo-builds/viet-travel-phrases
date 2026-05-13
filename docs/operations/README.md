# Operations Read First

Use this folder for exact live operational truth about the current app family when the question is about:

- publish/release status
- authoritative repo path
- Viet vs Tagalog current variant status
- exact run/test commands
- safe physical iPhone build/install rules
- latest validation snapshot
- current blockers to native app testing

Read in this order:

1. `APP_STATUS.md`
2. `CURRENT_BLOCKERS.md`
3. `TESTING_RUNBOOK.md`
4. `NATIVE_MAC_CUTOVER.md` when the question touches Mac status, Codex carryover, or the native SwiftUI/Xcode transition
5. `IOS_DEVICE_BUILDING.md` when the question touches wired or wireless physical iPhone builds
6. `VIET_TESTFLIGHT_EXECUTION_PACKET.md` for the native iPhone/TestFlight evidence packet
7. `LATEST_VALIDATION.md`
8. `VARIANT_MATRIX.md`

## File ownership

- `APP_STATUS.md`
  - entrypoint for the current Viet and Tagalog operational snapshot and current handoff order
- `VARIANT_MATRIX.md`
  - compact cross-variant comparison only
- `TESTING_RUNBOOK.md`
  - repo-owned build/test sequence, lane split, and repo sync targets
- `NATIVE_MAC_CUTOVER.md`
  - native Mac status, Codex continuity, and the native SwiftUI/Xcode lane
- `IOS_DEVICE_BUILDING.md`
  - safe local physical iPhone build/install rules, including wireless Xcode installs and signing hygiene
- `VIET_TESTFLIGHT_EXECUTION_PACKET.md`
  - native iPhone/TestFlight evidence packet for device and StoreKit proof
- `LATEST_VALIDATION.md`
  - evidence that already exists; not the next-step authority
- `CURRENT_BLOCKERS.md`
  - open blockers only; not the execution checklist
- `ops/apps/*.json`
  - dashboard and onboarding summary only; not a replacement for the operational docs in this folder

## Current Viet handoff order

1. Open `APP_STATUS.md` to confirm the live repo snapshot and current pending gates.
2. Check `CURRENT_BLOCKERS.md` to see which gates are still open before starting a new build/test pass.
3. Use `TESTING_RUNBOOK.md` for the repo-owned sequence and post-run sync targets.
4. Use `IOS_DEVICE_BUILDING.md` for safe physical iPhone build/install rules.
5. Use `VIET_TESTFLIGHT_EXECUTION_PACKET.md` when a native device or TestFlight evidence packet is needed.
6. Use `LATEST_VALIDATION.md` only to see what evidence already exists and what still had not been proven at the time of the last validation snapshot.

Authority notes:

- This folder is the authoritative operational-truth pack for the current live app family.
- Preferred Mac repo root:
  - `/Users/jojolim/Developer/products/speaklocal/app-family`
- Preferred native iOS app-session root:
  - `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
- Historical pre-Mac roots are archive references only and should not be used for current work.
- Do not answer live operational questions from archived planning roots or older architecture notes when these operational docs cover them.
- Older Viet execution docs remain historical reference inputs only; they are no longer checklist authority.
- `ops/apps/*.json` is stage/readiness truth for dashboard visibility only. It must not be used as a replacement for operational runbooks, validation logs, or release notes.
- `ops/apps/*.json` may summarize `testingGates`, `hardBlock`, and pending rollout debt, but the exact evidence for those summaries still lives in this folder.
- When a manifest gate is `pending` or `passed`, its `testingGates.*.evidenceRef` should point back into this folder.
- Device-only testing, Apple login, App Store Connect mapping, and similar human-only stops should appear in the manifest as `blocked:human` plus an active `hardBlock`, but the real evidence still belongs here.
- Build-environment failures should appear in the manifest as `blocked:validation` plus `hardBlock.type=build-environment`, but the real evidence still belongs here.

Maintenance rule:

- Update only the matching operational doc when a task changes release status, variant status, run/test commands, latest validation truth, or current blockers.
- Do not mirror routine task churn here.
- Do not mirror the task registry here.
