# T-071 Evidence Pack Audit

Date: 2026-04-20
Task: `T-071`

## Scope

- audited only `docs/operations/**` and `ops/apps/viet.json`
- treated `.agent/tasks/T-022/result.md` and `.agent/tasks/T-068/result.md` as predecessor truth for this rerun
- made no `app/**`, `site/**`, or `content-draft/**` writes

## Durable truth carried forward

- latest durable validation snapshot still remains `2026-04-16`
- latest installable preview artifact still remains build `1.0.0 (3)` with EAS build ID `ae55c880-0d6b-49b5-ba5e-64d82787eb25`
- current in-flight preview reference still remains build `1.0.0 (4)` with EAS build ID `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
- current in-flight store/TestFlight reference still remains build `1.0.0 (5)` with EAS build ID `5f61efeb-661d-426b-a280-aed866dcb5c2`
- repo truth still does not prove preview installability, TestFlight processing, or physical purchase / restore / relaunch / gating proof for the current snapshot
- EAS-confirmed Apple-side setup facts still carried forward:
  - App Store Connect app ID `6761904350`
  - App Store Connect API key on file

## Sync decisions

- refreshed the ops-truth dates in `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, and `TESTING_RUNBOOK.md` to `2026-04-20`
- refreshed `LATEST_VALIDATION.md` to show a `2026-04-20` ops-truth reread without claiming new durable validation evidence
- aligned all touched surfaces on the same evidence minimum:
  - preview install result for build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
  - store/TestFlight result for build `5f61efeb-661d-426b-a280-aed866dcb5c2`
  - Viet non-consumable plus Sandbox purchase-lane readiness or exact blocker
  - physical App Store sheet / purchase / restore / relaunch / locked-vs-unlocked gating evidence
  - exact post-pass sync into ops docs plus `ops/apps/viet.json` if any gate state changes

## Files updated by the sync pass

- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `ops/apps/viet.json`

## Notes

- this pass strengthened operator-facing truth only
- this pass did not run new build, install, TestFlight, or device validation commands
