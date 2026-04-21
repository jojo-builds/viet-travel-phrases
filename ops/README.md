# Ops State

This folder holds repo-owned operator state for the SpeakLocal app family.

Use it for:

- app onboarding stage
- testing summary
- hard-block summary
- blocker state
- feature eligibility
- pending feature rollout debt
- next execution step
- dashboard visibility inputs

Do not use it for:

- build identity truth
- runtime registry truth
- release notes
- validation logs
- test runbooks
- full human-action transcripts

Source-of-truth rule:

- `ops/app-manifest-contract.json` is the canonical machine-readable contract for `ops/apps/*.json`
- `ops/apps/*.json` is stage/readiness truth only
- `hardBlock` and `testingGates.*.evidenceRef` are summary pointers only
- pending or passed testing gates must carry a non-empty `evidenceRef`
- pending preview-install or device-only testing follow-up should use `blocked:human` plus an active `hardBlock`
- `testingGates` summarize only the current active shared rollout priority in v1; keep multi-feature rollout detail in `docs/operations/*`
- `docs/operations/*` remains live operational truth
