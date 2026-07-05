# App Status

Last updated: 2026-07-05 (Asia/Manila local)
Authority lane: live app operational truth

## Live App Status

- Live App Store app: `Viet Travel Phrasebook`
- Current active development surface: `native-ios/`
- Current app direction: native SwiftUI/Xcode only
- Legacy Expo/React Native app shell: removed from active repo truth; historical docs may mention it as archive context only

## Authority Paths

- Canonical Mac repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Native iOS app root: `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
- Native config truth: `native-ios/Config/apps/*.json`
- Native bundled resource truth: `native-ios/Resources/`
- Authored content truth: `content-draft/`
- Operations truth: `docs/operations/`

Do not use `/Users/jojolim/Documents/New project` or a resurrected `app/` folder for product work.

## Current Operational Truth

- SpeakLocal Vietnam is the current native proof app.
- The native app includes the SwiftUI shell, listing/detail pages, search, Browse, Home, Practice, local audio playback, bottom chrome, and bundled offline Viet resources.
- Future destination apps should inherit the native shell and language-pack/resource model rather than reintroducing a second app framework.
- Premium/paywall work should use native StoreKit expectations and stay isolated in its feature branch until Jojo says it is ready for `main`.

## Current Build/Test Posture

- Local validation should use the native commands in `docs/operations/TESTING_RUNBOOK.md`.
- Physical iPhone installs should normally come from `main` using `speaklocal-ios-device-build`.
- Feature branches should use dedicated simulator instances unless Jojo explicitly asks to install that branch on his phone.
- Latest completed phone proof used `main` at commit `07a2db5d8` on Jojo's replacement/new active iPhone.
- Current exact `main` head `470016d3e` has fresh simulator/data validation after the 2026-07-05 launch-readiness checkpoint and real-traveler Browse-back merge; physical iPhone build/install/launch proof is pending because no paired iPhone was available to device tooling during the latest attempt.
- The 2026-06-16 post-merge validation passed native guards, Viet content/resource validators, focused simulator unit tests, targeted UI tests, and physical iPhone build/install/launch.
- Jojo's previous test iPhone is now away for Apple service. The new active iPhone was visible to device tooling on 2026-07-04, Developer Mode is enabled, and Xcode sees it as a valid iOS destination.
- After Xcode account sign-in, Apple Program License Agreement acceptance, and automatic provisioning refresh, the 2026-07-04 current-`main` debug build, install, and launch all passed on the new phone.
- Repo signing files stayed clean after the new-phone build; signing remained local.
- The same 2026-07-04 launch-readiness working tree restored the original Home lifted/glass panel styling while moving scroll-driven photo-backdrop/chrome updates out of the full Home content tree; focused Home tests and the full `BrowseSearchUITests` suite (`60` tests, `0` failures) passed afterward.
- The 2026-07-04/05 audio remediation and deep visual QA pass cleared the known bundled-audio coverage queue in the launch-readiness working tree: `5353` audio manifest entries validated and the regenerated SQLite report shows `0` missing-audio rows. A fresh physical-phone build, install, and launch passed for that regenerated payload; human listen spot-checks are still recommended.
- The 2026-07-04/05 frontend QA bug hunt completed a full final `SpeakLocalNativeUITests` sweep with `132` tests executed, `1` intentional skip, and `0` failures, plus `259` retained screenshot/proof files. It covered Home, Browse, Search, Saved, Practice, navigation, audio controls, city/menu/listing surfaces, top/bottom chrome, and production listing proof paths. A follow-up Practice saved-match header clearance issue from physical-phone review is tracked as `FQA-019` and has targeted red/green, full Practice, screenshot proof, and physical iPhone build/install/launch proof.
- Paywall remains intentionally excluded from `main` until Jojo explicitly approves that lane and StoreKit proof passes; `feature/paywall` has been synced forward to current `main` for continued testing.

## Evidence Boundary

This document does not claim a new App Store/TestFlight release. It records the repo direction and active app surface after the native-only cleanup, 2026-06-16 non-paywall merge sweep, 2026-06-16 launch-readiness bug-hunt merge, 2026-07-04 new-phone launch-readiness validation, 2026-07-04/05 frontend QA bug hunt, and 2026-07-05 non-paywall launch-readiness checkpoint.
