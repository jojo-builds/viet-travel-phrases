# Current Blockers

Last updated: 2026-05-18
Authority lane: live app operational truth

Use this doc for blocker state only. Use `TESTING_RUNBOOK.md` for native validation commands.

## Current Blockers To Shipping The Current Native App

1. Native paywall / StoreKit proof is not complete.
   - The paywall feature lane exists separately and should not merge to `main` until Jojo explicitly approves it.
   - Required proof before shipping paywall: purchase, restore, relaunch persistence, locked/unlocked gating, and clear App Store Connect product state.

2. Mixed historical docs may still mention Expo/EAS as archive context.
   - Active implementation authority now says native iOS only.
   - If a worker finds an operational doc directing new app work through Expo/React Native, update or remove that instruction before proceeding.

3. Audio continuity remains an honest quality watch item.
   - Current native resources include bundled audio coverage.
   - Do not claim perfect same-speaker uniformity unless a fresh native audio-quality pass proves it.

## Not Current Blockers

- Expo/EAS packaging drift is no longer an active app-development blocker because the app product surface is now native SwiftUI/Xcode.
- React Native/Metro preview issues are no longer product blockers because that app shell is no longer active.
- Physical iPhone build/install/launch is refreshed for current `main`.
- Hero image asset validation passed in the 2026-05-18 merge sweep with the strict unique city-place asset gate.
