# Viet TestFlight Execution Packet

Last updated: 2026-04-21
Authority lane: exact next Viet preview/TestFlight/App Store Connect/device-proof execution checklist

## Use this doc for

- the single ordered operator checklist for the next real Viet iPhone pass
- exact preview-vs-TestFlight lane split
- exact Apple-side readiness prerequisites
- exact evidence package that must come back into repo truth
- the canonical intake owner for the next Viet human return packet

Status and evidence still live in:

- `APP_STATUS.md`
- `CURRENT_BLOCKERS.md`
- `LATEST_VALIDATION.md`
- `ops/apps/viet.json` for compact dashboard/onboarding summary only

The older OpenClaw docs remain useful reference inputs, but this repo file is now the single ordered checklist for the next operator pass.

Truth-sync note: this `2026-04-21` refresh did not add new build, App Store Connect, purchase, restore, or device evidence. It only tightened this packet so the next operator can run one front-door checklist, return one exact six-item evidence packet with stable field labels, and fold that evidence back into repo truth in one explicit order.

## Current truth boundary

Keep these facts literal while running this lane:

- latest known installable older preview artifact is still build `1.0.0 (3)`
  - EAS build ID: `ae55c880-0d6b-49b5-ba5e-64d82787eb25`
  - this artifact predates the `2026-04-16` current repo snapshot, so it does not count as proof for the newer snapshot under test
- build `1.0.0 (4)` is still only an in-flight preview reference at last durable check
  - EAS build ID: `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
- build `1.0.0 (5)` is still only an in-flight store/TestFlight reference at last durable check
  - EAS build ID: `5f61efeb-661d-426b-a280-aed866dcb5c2`
- no durable purchase / restore / restart / device-proof evidence extends past the `2026-04-16` validation snapshot
- bundle ID: `com.jojobuilds.viettravelphrases`
- product ID: `com.jojobuilds.viettravelphrases.premiumunlock`
- price target: `$4.99`
- current product boundary under test: `150 starter / 750 premium / 900 total`
- current source/audio truth under test: `919 approved rows`, `919 ready / 0 planned`

Do not upgrade any of those truths unless fresh evidence is actually captured during the run.

## Lane split that stays in force

- `internal preview` build is for install and locked-state preflight only
- `TestFlight + Sandbox Apple Account` is the durable purchase / restore / restart lane
- if the internal preview build cannot load the product or show a real App Store sheet, stop that lane as `BLOCKED`, record the exact failure, and move the same repo snapshot into TestFlight before escalating it as a repo defect

## Step 1. Reconfirm the packet baseline before touching a device

Use this file as the baseline. Do not stop to reconcile `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, or `LATEST_VALIDATION.md` before starting unless you are checking whether fresher evidence already landed after this packet was updated.

Record these truths exactly before you touch EAS, TestFlight, App Store Connect, or a device:

- build `1.0.0 (3)` / `ae55c880-0d6b-49b5-ba5e-64d82787eb25` is the latest known older installable preview artifact
- that older installable artifact predates the `2026-04-16` repo snapshot and does not count as proof for the newer snapshot
- build `1.0.0 (4)` / `39b7fbfd-909c-48fe-9317-f8be2c5e6e02` is still only the current preview-build reference unless EAS now proves it installable
- build `1.0.0 (5)` / `5f61efeb-661d-426b-a280-aed866dcb5c2` is still only the current store/TestFlight build reference unless EAS or App Store Connect now proves it processed
- the last durable validation snapshot still stops at `2026-04-16`

Stop if the operator cannot state which build is merely an older installable reference and which builds are the current-snapshot references still waiting for proof.

## Step 2. Check build availability before any human test pass

1. Check preview build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`.
2. Check store/TestFlight build `5f61efeb-661d-426b-a280-aed866dcb5c2`.
3. Record which of these states is true for each build:
   - still queued / new / processing
   - finished but not installable
   - installable
   - processed into TestFlight
   - explicit failure state
4. If either build is still not ready for the next lane, keep this packet as the owner of the retry branch:
   - rebuild from the current repo snapshot using the standalone staged-root repo sequence in `TESTING_RUNBOOK.md`
   - keep the preview and store/TestFlight retries on the same staged repo snapshot
   - keep explicit staged build-number control because canonical config still resolves Viet as build `2`
   - use the lower staged build number for the internal preview retry and the next higher staged build number for the store/TestFlight retry
   - if the finished store/TestFlight build is not already attached to a submission, submit that finished production build to App Store Connect/TestFlight without `--what-to-test`
   - return to this step and record the new durable build states before any device pass
5. When this step ends, carry these exact selections forward:
   - selected preview build = the preview build that is installable for Step 4
   - selected TestFlight build = the store/TestFlight build that is processed into TestFlight for Step 5
   - if a retry or resubmit produced newer builds, those newer builds become the selected builds for the downstream steps

If the selected preview build is still not installable, the locked-state preflight remains blocked.
If the selected TestFlight build is still not processed into TestFlight, the durable purchase lane remains blocked.
Do not treat build `1.0.0 (3)` as proof for the current snapshot even if it still installs; it is only the older fallback reference while you are trying to prove the `2026-04-16` repo state.

## Step 3. Confirm Apple-side purchase readiness

Use App Store Connect for the live Viet app record.

Required truths before a durable purchase test:

- app record exists for bundle ID `com.jojobuilds.viettravelphrases`
- non-consumable exists for product ID `com.jojobuilds.viettravelphrases.premiumunlock`
- price is `$4.99`
- metadata is complete enough to support TestFlight plus Sandbox purchase testing, usually reaching at least `Ready to Submit`
- app-review screenshot and notes exist
- paid-apps agreement / tax / banking posture is not blocking paid content
- Sandbox Apple Account exists, storefront is recorded, and purchase history is cleared if a clean first-purchase path is needed
- any recent product edits have had time to propagate

Record the literal App Store Connect product status shown at test time. Common statuses include:

- `Missing Metadata`
- `Ready to Submit`
- `Waiting for Review`
- `In Review`
- `Pending Binary Approval`
- `Developer Action Needed`
- `Rejected`
- `Approved`
- `Developer Removed from Sale`

If Apple shows a different label, copy that label exactly instead of collapsing it into the list above.

If the product is missing, incomplete, or in a blocking status for TestFlight plus Sandbox purchase testing, stop the purchase lane as `BLOCKED` and fix App Store Connect first.

## Step 4. Run the internal-preview preflight lane

Only run this if the selected preview build from Step 2 is now installable.

1. Install the selected preview build from Step 2 on the device.
2. Record:
   - build root used
   - build number
   - build ID
   - install link
   - device model
   - iOS version
3. Run locked-state preflight only:
   - home count chips
   - premium locked badge
   - starter browse clarity
   - fixed search smoke
   - audio-speed control visibility
   - starter audio reality check

Required locked-state search set:

- `hello`
- `xin chao`
- `pharmacy`
- `charged twice`
- `zzzzz`

This lane does not count as durable purchase / restore / restart proof by itself.

## Step 5. Move the same snapshot into TestFlight for durable purchase proof

Only run this if the selected TestFlight build from Step 2 is now processed into TestFlight.

1. Attach the selected TestFlight build from Step 2 to the internal-testing group.
2. Install the selected TestFlight build on the device.
3. Sign the real tester into TestFlight.
4. Sign the dedicated Sandbox Apple Account into `Developer > Sandbox Apple Account`.
5. Keep `Media & Purchases` signed out during the sandbox purchase lane.

Then run the durable proof sequence:

1. premium screen shows the current truth:
   - `150 free`
   - `750 added`
   - `900 total`
   - one-time purchase `$4.99`
2. tap `Unlock for $4.99`
3. capture the real App Store sheet or exact failure state
4. if purchase succeeds, verify immediate unlock
5. force-close and relaunch for restart persistence
6. delete and reinstall or otherwise run restore proof
7. confirm premium search and premium scenario access after restore

If no real App Store sheet appears, stop and record the exact blocker instead of implying success.

## Step 6. Required six-item return packet

Do not close the pass with narrative-only notes. Return one exact six-item packet:

1. Preview-install state
   - selected preview build number, build ID, install link, install lane used, device model, iOS version
   - installable or exact failure state
2. Store/TestFlight state
   - selected store build number, build ID, build page or submission reference
   - processed into TestFlight or exact failure state
3. Apple-side purchase readiness
   - App Store Connect product status at test time
   - Sandbox Apple Account and storefront used
   - purchase-ready or exact Apple-side blocker state
4. Physical device proof
   - locked home screenshot with count chips
   - locked premium-query evidence for `charged twice`
   - empty-state evidence for `zzzzz`
   - settings screenshot for audio speed controls
   - starter audio playback evidence
   - App Store sheet screenshot or exact purchase blocker evidence
   - unlocked-state, relaunch persistence, and restore evidence if purchase succeeds
5. Shared-search carry-forward
   - bounded Viet + Tagalog shared-search smoke from the same manual lane if captured
   - otherwise one explicit note that the search blocker still remains open
6. Repo sync decision
   - exact files whose truth changed
   - update `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, `TESTING_RUNBOOK.md`, and `ops/apps/viet.json` only if the new evidence changed their truth
   - update `LATEST_VALIDATION.md` only if fresh durable evidence changed the last validation snapshot

Use these exact field labels inside the return packet so later sync stays mechanical instead of interpretive:

1. Preview-install state
   - `selectedPreviewBuildNumber`
   - `selectedPreviewBuildId`
   - `selectedPreviewInstallLink`
   - `previewInstallLane`
   - `previewDeviceModel`
   - `previewIosVersion`
   - `previewInstallState`
2. Store/TestFlight state
   - `selectedStoreBuildNumber`
   - `selectedStoreBuildId`
   - `storeBuildReference`
   - `testFlightProcessingState`
3. Apple-side purchase readiness
   - `ascProductStatus`
   - `sandboxAppleAccount`
   - `sandboxStorefront`
   - `applePurchaseReadiness`
4. Physical device proof
   - `lockedHomeEvidence`
   - `chargedTwiceLockedEvidence`
   - `emptyStateEvidence`
   - `audioSpeedEvidence`
   - `starterAudioEvidence`
   - `purchaseSheetEvidence`
   - `unlockRelaunchRestoreEvidence`
5. Shared-search carry-forward
   - `sharedSearchSmokeEvidence`
   - `sharedSearchCarryForwardDecision`
6. Repo sync decision
   - `truthChangedFiles`
   - `syncCompletionStatus`

If a field has no new proof yet, write the exact blocker or `not captured` rather than collapsing it into narrative.

## Step 7. Repo sync after the run

Update only what the new evidence actually changed, and fold it in this order:

1. update Step 6 in this packet first so the intake owner records the selected builds, exact evidence fields, and raw outcomes
2. update `docs/operations/APP_STATUS.md` if the live operational snapshot or build/install truth changed
3. update `docs/operations/TESTING_RUNBOOK.md` if build-lane facts, retry posture, or repo sync instructions changed
4. update `ops/apps/viet.json` if gate status, hard-block wording, or next-step wording changed
5. update `docs/operations/CURRENT_BLOCKERS.md` only if blocker truth changed
6. update `docs/operations/LATEST_VALIDATION.md` only if fresh durable evidence changed the last validation snapshot

Do not upgrade any gate just because the checklist is clearer.

## Historical reference inputs

These older operator docs were the inputs for this packet and remain useful references, but they are no longer the primary checklist owner:

- `E:\AI\OpenClaw\workspace\projects\SpeakLocal Viet Fresh Preview Build And Device Proof Prep.md`
- `E:\AI\OpenClaw\workspace\projects\SpeakLocal Viet App Store Connect Purchase Test Readiness.md`
- `E:\AI\OpenClaw\workspace\projects\SpeakLocal Viet Device Test Plan And Evidence Capture Runbook.md`
