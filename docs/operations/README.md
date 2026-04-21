# Operations Read First

Use this folder for exact live operational truth about the current app family when the question is about:

- publish/release status
- authoritative repo and compatibility path
- Viet vs Tagalog current variant status
- exact run/test commands
- latest validation snapshot
- current blockers to dual-variant testing

Read in this order:

1. `APP_STATUS.md`
2. `CURRENT_BLOCKERS.md`
3. `TESTING_RUNBOOK.md`
4. `VIET_TESTFLIGHT_EXECUTION_PACKET.md` for the exact next Viet operator checklist
5. `LATEST_VALIDATION.md`
6. `VARIANT_MATRIX.md`

## File ownership

- `APP_STATUS.md`
  - entrypoint for the current Viet and Tagalog operational snapshot, latest installable artifact, and the current handoff order
- `VARIANT_MATRIX.md`
  - compact cross-variant comparison only
- `TESTING_RUNBOOK.md`
  - repo-owned build/test sequence, lane split, and repo sync targets
- `VIET_TESTFLIGHT_EXECUTION_PACKET.md`
  - single ordered operator checklist for the next Viet preview/TestFlight/App Store Connect/device-proof lane
- `LATEST_VALIDATION.md`
  - evidence that already exists; not the next-step authority
- `CURRENT_BLOCKERS.md`
  - open blockers only; not the execution checklist
- `ops/apps/*.json`
  - dashboard and onboarding summary only; not a replacement for the operational docs in this folder

## Current Viet handoff order

1. Open `APP_STATUS.md` to confirm the live repo snapshot, latest installable artifact, and the current pending gates.
2. Check `CURRENT_BLOCKERS.md` to see which gates are still open before starting a new build/test pass.
3. Use `TESTING_RUNBOOK.md` for the repo-owned sequence and post-run sync targets.
4. Use `VIET_TESTFLIGHT_EXECUTION_PACKET.md` as the single ordered checklist for the next real operator pass.
5. Use `LATEST_VALIDATION.md` only to see what evidence already exists and what still had not been proven at the time of the last validation snapshot.

Authority notes:

- This folder is the authoritative operational-truth pack for the current live app family.
- Preferred live app session root:
  - `E:\AI\SpeakLocal-App-Family`
- Preferred OpenClaw/Codex workspace root:
  - `C:\Users\Administrator\.openclaw\workspace\projects\speaklocal-app-family`
- Current physical backing repo during transition:
  - `E:\AI\Viet-Travel-Phrases`
- Compatibility workspace alias during transition:
  - `C:\Users\Administrator\.openclaw\workspace\projects\viet-travel-phrases`
- Do not answer live operational questions from archived planning roots or older architecture notes when these operational docs cover them.
- The three older OpenClaw Viet execution docs remain useful historical reference inputs, but they are no longer the primary checklist authority now that this folder carries `VIET_TESTFLIGHT_EXECUTION_PACKET.md`.
- `ops/apps/*.json` is stage/readiness truth for dashboard visibility only. It must not be used as a replacement for operational runbooks, validation logs, or release notes.
- `ops/apps/*.json` may summarize `testingGates`, `hardBlock`, and pending rollout debt, but the exact evidence for those summaries still lives in this folder.
- When a manifest gate is `pending` or `passed`, its `testingGates.*.evidenceRef` should point back into this folder.
- Device-only testing, Apple login, App Store Connect mapping, and similar human-only stops should appear in the manifest as `blocked:human` plus an active `hardBlock`, but the real evidence still belongs here.
- Build-environment failures should appear in the manifest as `blocked:validation` plus `hardBlock.type=build-environment`, but the real evidence still belongs here.

Maintenance rule:

- Update only the matching operational doc when a task changes release status, variant status, run/test commands, latest validation truth, or current blockers.
- Do not mirror routine task churn here.
- Do not mirror the task registry here.
