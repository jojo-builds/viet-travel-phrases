# App Onboarding Stages

Use these stages for `ops/apps/*.json` and dashboard visibility.

Canonical machine-readable contract:

- `ops/app-manifest-contract.json`

Summary rules:

- `ops/apps/*.json` stores compact operator/orchestrator state only.
- `testingGates` and `hardBlock` are summary fields; exact validation evidence, build notes, and human-action outcomes stay in `docs/operations/*`.
- `testingGates.*.evidenceRef` must point at the operational evidence whenever a gate is `pending` or `passed`.
- `featureEligibility` is dashboard-facing and derived. `pendingFeatureRollouts` is the authoritative manifest summary of shared rollout debt.
- In v1, `testingGates` summarize only the current active shared rollout priority. Keep `pendingFeatureRollouts` to one active shared feature in the manifest and keep multi-feature detail in `docs/operations/*`.

## Stages

- `defined`
  - the app identity exists, `ops/apps/<variant>.json` exists, and the lane may still be prep-only
- `runtime-wired`
  - the app is wired into the family seam and can resolve as a runtime variant
- `baseline-valid`
  - the app can pass the current shared baseline checks without claiming device or release readiness yet
- `testing`
  - the app is in active validation or device follow-up; use `testingGates` to show the exact resume point
- `release-ready`
  - the app has cleared the current validation gates and is ready for explicit release-transition work
- `live`
  - the app is release-distributed or App Store accepted, but it may still carry pending rollout debt

## Testing gates

- `localValidation`
  - repo-local machine validation such as TypeScript, family validator, Expo config, and export checks
- `previewBuild`
  - an internal preview build exists when the current milestone needs one
- `previewInstall`
  - the preview build has been installed or otherwise confirmed on device
- `runtimeManualSmoke`
  - the real runtime/manual milestone smoke has been captured
- `deviceWalkthrough`
  - the fuller durable device walkthrough has been captured

Each gate uses:

- `pending`
- `passed`
- `not-applicable`

## Release status

- `not-configured`
- `preview-only`
- `app-store-connect-pending`
- `submission-ready`
- `submitted`
- `live`

## Blocker tags

- `blocked:none`
- `blocked:content`
- `blocked:audio`
- `blocked:release`
- `blocked:core`
- `blocked:decision`
- `blocked:validation`
- `blocked:human`

## Hard block summary

- Set `hardBlock.active=true` only when a human-only, external, or build-environment dependency is the current stop.
- Use `blocked:human` plus an active `hardBlock` for device-only testing, Apple login, Apple credentials, App Store Connect mapping, external review, or similar pauses that require a human or external system.
- Use `blocked:validation` plus an active `hardBlock.type=build-environment` when the current build environment is the active missing capability.
- Keep `hardBlock.detail` concise and `nextHumanAction` limited to the single unblock step.
- Active hard blocks must include `system`, `detail`, and `nextHumanAction`.
- Inactive hard blocks must clear `system`, `detail`, and `nextHumanAction`.
- Keep exact evidence, credentials outcomes, and release notes in `docs/operations/*`.

## Manual gate rule

- For runtime variants, preview and release progression is legal only when the required manual-device gates are satisfied and their evidence is captured in `docs/operations/*`.
- `previewBuild` and `previewInstall` may advance before runtime/manual smoke is complete, but `stage=release-ready` and later release states still require durable manual-device evidence.

## Localization-scope stop

- Prep-lane graduation and search-enabled runtime promotion are not normal continuation work once they extend beyond the currently proven Viet + Tagalog scope.
- Finish translation, pronunciation, audio posture, and localized search copy first.
- Then pause for UX/localization review before runtime wiring or search-enabled rollout on any new language, including Latin-script lanes such as Spanish, Italian, and Turkish.
- Treat non-Latin lanes such as Japanese as a mandatory UX/localization review stop before runtime wiring.

## Legacy mapping

- `preview-built`
  - normalize to `stage: testing`
  - set `testingGates.previewBuild=passed`
  - set `testingGates.previewInstall=pending`
- `preview-installed`
  - normalize to `stage: testing`
  - set `testingGates.previewBuild=passed`
  - set `testingGates.previewInstall=passed`
- `preview-installed-awaiting-full-device-walkthrough`
  - normalize to `stage: testing`
  - keep `releaseStatus: preview-only`
  - set `testingGates.previewBuild=passed`
  - set `testingGates.previewInstall=passed`
  - set `testingGates.deviceWalkthrough=pending`
- `device-tested`
  - normalize to `stage: testing`
  - set `testingGates.deviceWalkthrough=passed`
- `not release-ready`
  - keep the exact prose in `docs/operations/*`
  - summarize the manifest with `releaseStatus` plus the matching `testingGates` and `hardBlock`

## Required readiness fields

- `contentReadiness`
- `audioReadiness`
- `baselineParity`
- `featureEligibility`
- `testingGates`
- `hardBlock`
- `pendingFeatureRollouts`
- `featureIntakeStatus`
- `releaseStatus`
- `blockerTag`
- `blockerDetail`
- `nextStep`

## Terminal state

An app is terminal only when all of the following are true:

- `stage: live`
- `releaseStatus: live`
- `runtimeManualSmoke: passed`
- `deviceWalkthrough: passed`
- `pendingFeatureRollouts: []`
- `featureIntakeStatus: frozen`
- `hardBlock.active: false`

`stage: release-ready` is legal only after `runtimeManualSmoke: passed` plus `deviceWalkthrough: passed`.
