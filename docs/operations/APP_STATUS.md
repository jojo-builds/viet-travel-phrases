# App Status

Last updated: 2026-06-16
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
- Latest refreshed phone build/install used current `main`; the native app-code payload was the 2026-06-16 non-paywall, non-Messages merge sweep commit `a8df5ce59`.
- That build installed successfully on the connected physical iPhone; remote launch was blocked because the phone was locked.
- Unlock the phone and open SpeakLocal for fresh launch/manual walkthrough proof from this build.

## Evidence Boundary

This document does not claim a new App Store/TestFlight release. It records the repo direction and active app surface after the native-only cleanup and 2026-06-16 non-paywall merge sweep.
