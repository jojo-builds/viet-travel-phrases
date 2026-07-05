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
- Latest exact-current physical-phone proof for app-code payload `b93edb9a6`: build and install succeeded on Jojo's active physical iPhone; launch was blocked because the phone was locked. Repo signing files stayed clean.
- Current app-code payload is the 2026-07-05 non-paywall launch-readiness checkpoint plus route/back, rapid audio tap, active-playback hardening, frontend QA proof receipts, Practice-era copy cleanup, full V2.2 render proof receipts, semantic product-language follow-up, and Practice scenario test-identifier cleanup through `b93edb9a6`.
- The 2026-06-16 post-merge validation passed native guards, Viet content/resource validators, focused simulator unit tests, targeted UI tests, and physical iPhone build/install/launch.
- Jojo's previous test iPhone is now away for Apple service. The new active iPhone was visible to device tooling on 2026-07-04, Developer Mode is enabled, and Xcode sees it as a valid iOS destination.
- After Xcode account sign-in, Apple Program License Agreement acceptance, and automatic provisioning refresh, the 2026-07-04 current-`main` debug build, install, and launch all passed on the new phone.
- Repo signing files stayed clean after the new-phone build; signing remained local.
- The same 2026-07-04 launch-readiness working tree restored the original Home lifted/glass panel styling while moving scroll-driven photo-backdrop/chrome updates out of the full Home content tree; focused Home tests and the full `BrowseSearchUITests` suite (`60` tests, `0` failures) passed afterward.
- The 2026-07-04/05 audio remediation and deep visual QA pass cleared the known bundled-audio coverage queue in the launch-readiness working tree: `5353` audio manifest entries validated and the regenerated SQLite report shows `0` missing-audio rows. A fresh physical-phone build, install, and launch passed for that regenerated payload; human listen spot-checks are still recommended.
- The 2026-07-04/05 frontend QA bug hunt completed a full final `SpeakLocalNativeUITests` sweep with `132` tests executed, `1` intentional skip, and `0` failures, plus `259` retained screenshot/proof files. It covered Home, Browse, Search, Saved, Practice, navigation, audio controls, city/menu/listing surfaces, top/bottom chrome, and production listing proof paths. A follow-up Practice saved-match header clearance issue from physical-phone review is tracked as `FQA-019` and has targeted red/green, full Practice, screenshot proof, and physical iPhone build/install/launch proof.
- The 2026-07-05 parallel launch-readiness push added current-main App Store screenshot proof, a static audio release audit, focused post-fix Browse/Search/Practice/audio UI validation, and exact-current phone build/install proof.
- The 2026-07-05/06 eight-hour front-end/product-language follow-up fixed stale Practice-era labels, tightened the visible/source-backed product-language audit, proved broad Browse/Search/Practice/back-forward/admin/audio/listing/city surfaces, and left paywall isolated.
- Paywall remains intentionally excluded from `main` until Jojo explicitly approves that lane and real purchase/restore/relaunch proof passes. `feature/paywall` has green hosted StoreKit/XCTest readiness at commit `453d6f55a`, but it is not merged.

## Evidence Boundary

This document does not claim a new App Store/TestFlight release. It records the repo direction and active app surface after the native-only cleanup, 2026-06-16 non-paywall merge sweep, 2026-06-16 launch-readiness bug-hunt merge, 2026-07-04 new-phone launch-readiness validation, 2026-07-04/05 frontend QA bug hunt, and 2026-07-05 non-paywall launch-readiness checkpoint.
