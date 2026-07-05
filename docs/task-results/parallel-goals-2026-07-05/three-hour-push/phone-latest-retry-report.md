# Exact-Current Phone Retry Report

Generated: 2026-07-05 20:23:51 PST

## Attempted main commit

- Branch: `main`
- Commit: `4f6462906579e1130a78b8ce6976b0eee3ed9024`
- Scope: current `main` only; no feature branch or paywall merge work was touched.

## Physical phone result

- Device availability: a paired current iPhone was visible to local device tooling.
- Build: succeeded for the physical iPhone using local-only signing overrides.
- Install: succeeded. The latest `main` app bundle was installed on the phone.
- Launch: blocked. iOS refused the launch request because the phone was locked / could not be unlocked by the tool.

This is a successful physical build and install receipt, but not a full physical launch proof.

## Simulator fallback

- Fallback target: `SpeakLocal Launch Runtime` simulator.
- Build/install/launch: succeeded through XcodeBuildMCP `build_run_sim`.
- Bundle launched: `app.speaklocal.vietnam.native`.
- Screenshot receipt: captured successfully by XcodeBuildMCP after launch.

This fallback proves exact-current `main` launches on simulator, but it is not physical-device proof.

## Signing hygiene

- Safe phone-build helper preflight signing scan: passed.
- Safe phone-build helper post-build signing scan: passed.
- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`: clean.
- No personal signing identifiers were written into repo signing files by this retry.

## Next step

Unlock the current iPhone and rerun the launch step or the safe phone helper. The app is already installed from current `main`; the remaining blocker is only physical launch while the phone is unlocked.
