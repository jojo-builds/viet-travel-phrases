# Current Blockers

Last updated: 2026-07-05 (Asia/Manila local)
Authority lane: live app operational truth

Use this doc for blocker state only. Use `TESTING_RUNBOOK.md` for native validation commands.

## Current Blockers To Shipping The Current Native App

1. Native paywall / StoreKit proof is not complete if this release must include paywall.
   - The paywall feature lane exists separately and should not merge to `main` until Jojo explicitly approves it.
   - Local simulator proof exists for onboarding, paywall rendering, subscription gating decisions, and the dev bypass path.
   - Required proof before shipping paywall: real purchase, restore, relaunch persistence, locked/unlocked entitlement behavior, and clear App Store Connect product state.
   - If Jojo ships the current non-paywall native app payload, this is not a blocker for that non-paywall release.

2. Exact-current physical iPhone proof is pending for `main` head `470016d3e`.
   - The 2026-07-05 merged `main` passed focused simulator/data validation after the non-paywall checkpoint and real-traveler Browse-back fix.
   - The physical-device helper could not build/install/launch because no paired iPhone was available to device tooling.
   - Repo signing files stayed clean after the blocked attempt.
   - Rerun `speaklocal-ios-device-build` once Jojo's active iPhone is available/unlocked.

3. Mixed historical docs may still mention Expo/EAS as archive context.
   - Active implementation authority now says native iOS only.
   - If a worker finds an operational doc directing new app work through Expo/React Native, update or remove that instruction before proceeding.

4. Audio continuity remains an honest quality watch item.
   - The 2026-07-04/05 ElevenLabs remediation and deep visual QA pass cleared the missing/planned audio queue in the launch-readiness working tree: `5353` manifest entries validated, authored audio audit reports `0` missing, and the regenerated SQLite report shows `0` missing-audio audit rows.
   - This is no longer a known missing-audio blocker, but do not claim perfect pronunciation or same-speaker uniformity until a fresh native audio-quality/listen pass proves it.

## Resolved Current Gates

- Front-end QA bug hunt completed for the current non-paywall native app payload.
  - Full final `SpeakLocalNativeUITests` sweep passed with `132` tests executed, `1` intentional skip, and `0` failures.
  - Coverage included Home/Browse/Search/Saved/Practice, navigation/back-forward, top/bottom chrome, audio buttons, city V2.2 pages, menu/detail/listing surfaces, and production listing proof paths.
  - Issue ledger and proof artifacts live under `docs/task-results/frontend-qa-2026-07-04/`.

- Previous physical iPhone launch proof was completed on the replacement/new active iPhone.
  - Current `main` commit `07a2db5d8` built, installed, and launched successfully on the new active physical iPhone on 2026-07-04.
  - Xcode account sign-in, Apple Program License Agreement acceptance, and automatic provisioning refresh cleared the earlier device-registration blocker.
  - Post-build signing scan passed; repo signing files stayed clean.
  - Exact-current head `470016d3e` still needs a fresh phone proof rerun.

- Home scroll-jank visual regression from the initial performance attempt was fixed in the 2026-07-04 launch-readiness working tree.
  - The original lifted/glass Home panel styling was restored instead of replaced with cheaper panels.
  - Focused Home unit/UI tests passed, and the full `BrowseSearchUITests` suite passed with `60` tests and `0` failures after the Home fix.
  - Jojo should still do a human physical-phone feel check for slow/fast Home scrolling before treating performance as fully proven.

- Missing/planned bundled audio coverage was cleared in the 2026-07-04 launch-readiness working tree.
  - `node native-ios/scripts/sync-viet-audio.js` validated `5353` native audio manifest entries.
  - City/place, menu, and authored-breakdown ElevenLabs dry-runs all report `0` remaining items to generate.
  - The regenerated SQLite audio report shows `0` missing-audio audit rows, `0` planned missing-audio audit rows, and `0` release-blocking missing-audio rows.
  - Fresh physical-phone build, install, and launch proof for this regenerated payload passed; human listen spot-checks are still recommended before claiming pronunciation/voice perfection.

- Fresh physical iPhone launch proof was completed on the previous connected iPhone.
  - Current `main` commit `93c08cf64` built, installed, and launched successfully on the connected physical iPhone.
  - Post-build signing scan passed; repo signing files stayed clean.
  - The merged launch-readiness lane also passed focused simulator unit/UI validation and content/resource validators before the phone build.

## Not Current Blockers

- Expo/EAS packaging drift is no longer an active app-development blocker because the app product surface is now native SwiftUI/Xcode.
- React Native/Metro preview issues are no longer product blockers because that app shell is no longer active.
- Physical iPhone setup/provisioning was proven on Jojo's replacement/new active phone at `07a2db5d8`; exact-current `main` phone proof is tracked above because the latest device attempt found no available paired iPhone.
- Non-paywall frontend QA has a fresh full-UI simulator pass and phone proof; remaining paywall/StoreKit work is intentionally outside this payload.
- Hero image asset validation passed in the 2026-05-18 merge sweep with the strict unique city-place asset gate.
