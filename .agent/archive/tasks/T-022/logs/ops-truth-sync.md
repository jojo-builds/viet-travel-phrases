# T-022 Ops Truth Sync Audit

Date: 2026-04-18
Task: `T-022`
Conclusion: refreshed Viet ops truth and evidence expectations without claiming new device, TestFlight, or App Store Connect proof that does not exist in repo truth.

## Inputs reviewed
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `ops/apps/viet.json`
- `.agent/coordination/queue-index.json`
- `.agent/coordination/locks.yaml`
- `.agent/tasks/T-022/spec.md`

## Verified carry-forward truth
- The latest durable validation baseline still remains `2026-04-16`.
- The latest installable preview artifact still remains build `1.0.0 (3)` with EAS build ID `ae55c880-0d6b-49b5-ba5e-64d82787eb25`.
- Preview build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02` at `1.0.0 (4)` and store/TestFlight build `5f61efeb-661d-426b-a280-aed866dcb5c2` at `1.0.0 (5)` are still only the current in-flight references in repo truth.
- Repo truth still shows no durable evidence that build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02` became installable or that build `5f61efeb-661d-426b-a280-aed866dcb5c2` processed into TestFlight.
- The current live Viet truth still remains:
  - `150 starter / 750 premium / 900 total`
  - `919` approved rows
  - `919 ready / 0 planned`
  - bundle ID `com.jojobuilds.viettravelphrases`
  - product ID `com.jojobuilds.viettravelphrases.premiumunlock`
  - ASC app ID `6761904350`

## Sync decisions
- Updated the `Last updated` markers in the four touched ops docs to `2026-04-18`.
- Kept `LATEST_VALIDATION.md` anchored to the real `2026-04-16` validation baseline instead of implying a new validation run.
- Tightened wording in the docs and `ops/apps/viet.json` so the build IDs are clearly framed as in-flight references, not as proven install/TestFlight outcomes.
- Added explicit still-missing evidence wording for preview install proof, TestFlight processing proof, and physical purchase / restore / restart / gating proof.

## Non-goals
- No app, site, or content-draft files were edited.
- No EAS, App Store Connect, or physical-device checks were run in this task.
- No new build status claims were added beyond the existing durable repo truth.
