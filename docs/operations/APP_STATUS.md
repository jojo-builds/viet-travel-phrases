# App Status

Last updated: 2026-04-21
Authority lane: live app operational truth

## Live app status

- Live app: `Viet Travel Phrasebook`
- Publish status: published / accepted by Apple for distribution
- Accepted version: `1.0.0 (2)`
- Durable acceptance checkpoint: by `2026-04-11`
- Repo build naming for the next line now resolves to `SpeakLocal Vietnam`

## Authority paths

- Canonical session root: `E:\AI\SpeakLocal-App-Family`
- Canonical workspace path: `C:\Users\Administrator\.openclaw\workspace\projects\speaklocal-app-family`
- Compatibility alias still present during transition: `E:\AI\Viet-Travel-Phrases`
- Current live app code root for commands below: `E:\AI\SpeakLocal-App-Family\app`

## Use this doc for

- current live operational snapshot
- latest installable artifact and install-lane truth
- the current ordered handoff path

Do not use this doc as the literal build or device execution checklist. `TESTING_RUNBOOK.md` owns the repo-side sequence, and `VIET_TESTFLIGHT_EXECUTION_PACKET.md` owns the exact operator checklist for the next real Viet pass.

## 2026-04-21 truth-sync note

- The repo rescue on `2026-04-21` restored the missing family preflight helpers, rebuilt the Tagalog generated pack from current draft truth, and re-ran the full repo-local validation bundle successfully.
- The same rescue pass also removed the hardcoded legacy-root mirror from the family-pack builder path and normalized the main content/validation scripts to resolve roots from the live script/app context instead of reinforcing `E:\AI\Viet-Travel-Phrases` as a write target.
- That rescue-state validation is durable repo-side evidence only. It does not add new preview-install, TestFlight, App Store Connect, purchase, or device proof.
- This refresh re-read and tightened the same Viet device-proof handoff packet only. It did not add new durable validation evidence.
- The later `2026-04-18` Viet purchase-surface audit and `2026-04-20` Tagalog search-copy rerun now count here only as bounded repo-side honesty evidence. They did not change install, TestFlight, purchase-lane, or physical-device readiness.
- The latest durable validation snapshot still remains `2026-04-16`; see `LATEST_VALIDATION.md`.
- The latest installable preview artifact still remains build `1.0.0 (3)` with EAS build ID `ae55c880-0d6b-49b5-ba5e-64d82787eb25`.
- Build `1.0.0 (4)` (`39b7fbfd-909c-48fe-9317-f8be2c5e6e02`) and build `1.0.0 (5)` (`5f61efeb-661d-426b-a280-aed866dcb5c2`) are still tracked here as in-flight references only until fresh install/TestFlight/device evidence is captured.
- The next human pass still needs the exact six-item return packet defined in `VIET_TESTFLIGHT_EXECUTION_PACKET.md`, with the same six headings and stable field labels. Do not reinterpret or restate that packet here.

## Current Viet build/test handoff order

1. Confirm the current snapshot and latest installable artifact here.
2. Check `CURRENT_BLOCKERS.md` for the unresolved gates that still prevent durable build/test proof.
3. Use `TESTING_RUNBOOK.md` for the repo-owned sequence and repo sync targets.
4. Use `VIET_TESTFLIGHT_EXECUTION_PACKET.md` for the single ordered operator checklist covering preview/TestFlight/App Store Connect/device-proof execution.
5. Use `LATEST_VALIDATION.md` only for the last durable evidence snapshot.

Lane split still in force:

- internal preview build = install and locked-state preflight
- TestFlight plus Sandbox Apple Account = durable purchase / restore / restart proof

## Current operational truth

- Viet is the only release-distributed variant today.
- Tagalog remains a second-app candidate and is not a released App Store app.
- The shared v2 premium baseline now includes:
  - a real live Viet 900-family content pack
  - a real family iOS one-time purchase / restore adapter through `expo-iap`
  - truthful unsupported-mode messaging instead of fake restore success
  - Expo config resolving `SpeakLocal Vietnam` / `SpeakLocal Philippines`
  - repo-side Viet presentation updated toward visible situation-first discovery, pressure-safe quick retrieval, and clearer premium/readiness explanation before the next preview build
- Current real Viet content/audio counts remain:
  - 18 live categories
  - 900 authored intent families / visible entries
  - 150 starter visible entries
  - 750 premium visible entries
  - 919 approved phrase rows
  - 919 approved rows currently marked `audioStatus=ready`
  - 0 approved rows currently marked `audioStatus=planned`
  - the app runtime seam now maps 919 current-pack Viet clips through `app/assets/audio/registry.ts` and `app/assets/audio/manifest.json`
  - 921 Viet MP3 files physically sit in `app/assets/audio`, including 2 legacy unreferenced extras on disk (`problems-5.mp3`, `problems-7.mp3`) that runtime mapping now ignores
  - generated website-safe phrase/audio module exports from approved Viet starter/default-first slices
  - sampled audio QA on `2026-04-15` judged the new ElevenLabs lane internally coherent but only `mixed` against the older bundled audio
  - the `2026-04-16` controlled continuity benchmark then judged the current mixed lane acceptable for current product use and the next product/device phase, but still not clean enough for same-speaker or perfect-uniformity claims
  - the website preview export now copies approved ready clips into the site-owned `/data/phrase-audio/` path, and the staging surface serves those URLs directly after publish
- Tagalog still remains on the earlier thin 10-scenario / 70-phrase content surface.
- The shared search rollout is still locally implemented across Viet and Tagalog, but the remaining device-proof gates are still open.
- The v2 premium baseline is still not ship-ready because:
  - the latest installable preview build predates the current `2026-04-16` 900-family + audio completion pass
  - the Viet non-consumable still needs App Store Connect confirmation at `com.jojobuilds.viettravelphrases.premiumunlock`
  - the new purchase / restore flow has not yet been proven on a physical iOS device
  - the current 900-family content + premium surfaces have not yet been walked on device in a durable way
  - the broader mixed-lane audio continuity benchmark now exists at a `CAUTION` result, so the remaining audio risk is honest release framing and any later tiny manual-review watchlist rather than missing-file coverage or a missing benchmark
- Current repo-side pre-build app posture now includes:
  - visible `Situations` labeling instead of older category-first discovery on the main Viet tab/home surfaces
  - a high-stress situation priority grid for arrival, transport, money, food, pharmacy, emergencies, phone/SIM trouble, and misunderstanding repair
  - pressure-safe quick phrases mapped to those same moments
  - scenario and premium surfaces that now expose the live `150 / 750 / 900` boundary and current audio-truth cues more directly
- Direct remote EAS builds from the canonical repo path still hit a project-root packaging bug, so the reliable preview-build path remains a standalone app-root copy such as `E:\AI\SpeakLocal-EAS-Build`.
- The `2026-04-16` execution lane also established the current Apple/EAS handoff facts:
  - a fresh standalone preview build launched from `E:\AI\SpeakLocal-EAS-Build-20260416-viet-preview-r1` with build `4`
  - a separate standalone store/TestFlight build launched from the same snapshot with build `5`
  - EAS confirmed App Store Connect app ID `6761904350` plus an App Store Connect API key already configured for submit
  - production `autoIncrement` in canonical `eas.json` is not usable with the current `app.config.js` setup inside the disposable staging root, so the store/TestFlight lane now depends on an explicit staged build-number bump rather than trusting auto-increment there
  - `--what-to-test` must stay out of the auto-submit command on the current Expo plan because EAS rejected it as an Enterprise-only changelog feature

## Latest preview build

- Fresh Viet iOS preview build completed on `2026-04-15` from standalone root `E:\AI\SpeakLocal-EAS-Build-20260415-viet-preview-r1`.
- EAS build ID: `ae55c880-0d6b-49b5-ba5e-64d82787eb25`
- EAS build page: `https://expo.dev/accounts/jayopsai/projects/viet-travel-phrases/builds/ae55c880-0d6b-49b5-ba5e-64d82787eb25`
- Install artifact: `https://expo.dev/artifacts/eas/nwAYWtd6JPjQ7RFELZLBWe.ipa`
- Build profile: `preview`
- Resolved app identity:
  - name: `SpeakLocal Vietnam`
  - bundle ID: `com.jojobuilds.viettravelphrases`
  - product ID: `com.jojobuilds.viettravelphrases.premiumunlock`
  - app version / build: `1.0.0 (3)`
- Expo/EAS credentials were usable for this build:
  - remote iOS credentials resolved successfully
  - provisioning profile stayed active for the registered device lane
- Standalone-root note:
  - the preview copy was bumped to iOS build `3` so the internal install lane is less likely to collide with the accepted live `1.0.0 (2)` app already on device
- This build is available for attempted physical iPhone install and runtime preflight through the Expo build page above, but repo truth still does not contain durable install or device evidence for it, and it predates the `2026-04-16` current repo snapshot.
- The safest Apple-documented purchase-proof lane is still a TestFlight build plus a Sandbox Apple Account after the App Store Connect product is confirmed.
- After the latest small-iPhone feedback flagged clarity, hierarchy, and audio-trust problems, the canonical repo received a focused follow-up UI pass and then a larger `2026-04-16` Viet 900-family + audio completion pass.
- The canonical repo now also includes a situation-first pre-build app pass so the next native preview can test the current home, quick-access, scenario, and premium shape rather than the older thinner-pack assumptions.
- That newer live repo truth is not in a fresh installable iPhone artifact yet. The next device retest depends on build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02` becoming installable or on a newer equivalent preview artifact from the same repo truth.

## Current in-flight builds

- Internal preview build launched on `2026-04-16` from `E:\AI\SpeakLocal-EAS-Build-20260416-viet-preview-r1`:
  - EAS build ID: `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
  - build page: `https://expo.dev/accounts/jayopsai/projects/viet-travel-phrases/builds/39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
  - build profile: `preview`
  - app version / build: `1.0.0 (4)`
  - current state at last durable check: `in queue`
- Store/TestFlight build launched on `2026-04-16` from the same staged snapshot after bumping the staged build number again:
  - EAS build ID: `5f61efeb-661d-426b-a280-aed866dcb5c2`
  - build page: `https://expo.dev/accounts/jayopsai/projects/viet-travel-phrases/builds/5f61efeb-661d-426b-a280-aed866dcb5c2`
  - build profile: `production`
  - app version / build: `1.0.0 (5)`
  - current state at last durable check: `new`
- The store build has not been processed into TestFlight yet, so there is still no installable current-repo TestFlight artifact.
- The auto-submit scheduling attempt for the store build failed only because `--what-to-test` was passed. Re-run submit without that flag after the build finishes if EAS does not attach the submission automatically.
- As of `2026-04-21`, repo truth still contains no newer durable evidence that either in-flight build changed state.

## Current evidence package still required

Use `VIET_TESTFLIGHT_EXECUTION_PACKET.md` for the exact six-item return packet. The intake owner there is authoritative for `Preview-install state`, `Store/TestFlight state`, `Apple-side purchase readiness`, `Physical device proof`, `Shared-search carry-forward`, and `Repo sync decision`. When fresh evidence lands, fold it back in this order: update the execution packet first, then mirror `APP_STATUS.md`, then `TESTING_RUNBOOK.md` if the build lane or sync contract changed, then `ops/apps/viet.json`, then `CURRENT_BLOCKERS.md` only if blocker truth changed, and `LATEST_VALIDATION.md` only if fresh durable evidence changed the last validation snapshot.

## Next queued preview-build prep

This section is summary truth only. For the exact standalone-root commands and evidence package, use `VIET_TESTFLIGHT_EXECUTION_PACKET.md`.

- Canonical `E:\AI\SpeakLocal-App-Family\app` still resolves Viet as `1.0.0 (2)` when inspected through `$env:EXPO_PUBLIC_APP_VARIANT='viet'; npx expo config --json`.
- The prior successful standalone preview build only became installable because its staged `app.config.js` was bumped to build `3`.
- The `2026-04-16` staged build lane therefore used:
  - fresh dated standalone root `E:\AI\SpeakLocal-EAS-Build-20260416-viet-preview-r1`
  - staged `ios.buildNumber = '4'` for the internal preview build
  - staged `ios.buildNumber = '5'` for the separate store/TestFlight build
  - `npm ci` plus staged `npx expo config --json` confirmation inside that standalone root
  - `EAS_NO_VCS=1` because the disposable staging root does not carry the canonical repo's `.git` metadata
- Preview-build, preview-install, TestFlight processing, Apple-side purchase readiness, and device-proof gates all remain pending until the exact evidence package above is captured.
