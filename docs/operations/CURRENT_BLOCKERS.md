# Current Blockers

Last updated: 2026-06-16
Authority lane: live app operational truth

Use this doc for blocker state only. Use `TESTING_RUNBOOK.md` for native validation commands.

## Current Blockers To Shipping The Current Native App

1. Native paywall / StoreKit proof is not complete if this release must include paywall.
   - The paywall feature lane exists separately and should not merge to `main` until Jojo explicitly approves it.
   - Local simulator proof exists for onboarding, paywall rendering, subscription gating decisions, and the dev bypass path.
   - Required proof before shipping paywall: real purchase, restore, relaunch persistence, locked/unlocked entitlement behavior, and clear App Store Connect product state.
   - If Jojo ships the current non-paywall native app payload, this is not a blocker for that non-paywall release.

2. Mixed historical docs may still mention Expo/EAS as archive context.
   - Active implementation authority now says native iOS only.
   - If a worker finds an operational doc directing new app work through Expo/React Native, update or remove that instruction before proceeding.

3. Audio continuity remains an honest quality watch item.
   - Current native resources include bundled audio coverage.
   - Do not claim perfect same-speaker uniformity unless a fresh native audio-quality pass proves it.

## Resolved Current Gates

- Fresh physical iPhone launch proof is no longer blocked by a locked phone.
  - Current `main` commit `93c08cf64` built, installed, and launched successfully on the connected physical iPhone.
  - Post-build signing scan passed; repo signing files stayed clean.
  - The merged launch-readiness lane also passed focused simulator unit/UI validation and content/resource validators before the phone build.

## Not Current Blockers

- Expo/EAS packaging drift is no longer an active app-development blocker because the app product surface is now native SwiftUI/Xcode.
- React Native/Metro preview issues are no longer product blockers because that app shell is no longer active.
- Physical iPhone build/install/launch is refreshed for current `main` at `93c08cf64`.
- Hero image asset validation passed in the 2026-05-18 merge sweep with the strict unique city-place asset gate.
