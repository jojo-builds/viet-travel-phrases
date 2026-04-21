# T-100 Device-Proof Handoff

Date: 2026-04-21
Task: `T-100`

## Current aligned evidence boundary

- Durable validation baseline remains `2026-04-16`.
- Latest installable preview artifact remains `ae55c880-0d6b-49b5-ba5e-64d82787eb25` at `1.0.0 (3)`.
- Current in-flight preview reference remains `39b7fbfd-909c-48fe-9317-f8be2c5e6e02` at `1.0.0 (4)`.
- Current in-flight store / TestFlight reference remains `5f61efeb-661d-426b-a280-aed866dcb5c2` at `1.0.0 (5)`.
- EAS-confirmed App Store Connect reference remains app ID `6761904350` plus an API key already on file.

## Missing proof that still blocks Viet

1. Preview install proof for build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`, or an exact install failure state tied to that build.
2. Store / TestFlight proof for build `5f61efeb-661d-426b-a280-aed866dcb5c2`, or an exact blocking state.
3. Apple-side purchase-lane proof for the Viet non-consumable plus Sandbox account path, or the exact Apple-side blocker that still prevents that lane.
4. Physical iOS evidence for App Store sheet appearance, purchase, restore, relaunch persistence, and locked-vs-unlocked gating on the live `150 / 750 / 900` boundary.
5. Bounded shared-search smoke on Viet + Tagalog if the same device lane can cover it, or an explicit note that the search blocker remains open.
6. Cross-file sync back into `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, `LATEST_VALIDATION.md`, `TESTING_RUNBOOK.md`, and `ops/apps/viet.json` if any gate state or blocker wording changes.

## Tightening decisions in this task

- Preserved the existing honesty boundary: no repo surface now implies install, TestFlight, purchase, restore, or device proof that does not exist.
- Added the missing latest-installable preview artifact reference to `ops/apps/viet.json` so the operator-facing JSON no longer skips the durable install baseline.
- Added the missing shared-search carry-forward item to the `APP_STATUS.md` evidence package so it matches `CURRENT_BLOCKERS.md`, `TESTING_RUNBOOK.md`, and `ops/apps/viet.json`.
- Tightened sync wording so blocker-wording changes trigger the same cross-file refresh as gate-state changes.
- Refreshed the handoff packet to `2026-04-21` without changing any evidence claims and marked `E:\AI\Viet-Travel-Phrases` as a compatibility alias rather than the preferred repo root in operator-facing docs.

## Non-changes

- No app code, site content, staged build files, or content-draft files changed.
- No new build, App Store Connect, install, TestFlight, purchase, restore, or device validation evidence was created.
