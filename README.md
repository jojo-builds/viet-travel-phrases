# SpeakLocal-App-Family

Status: canonical implementation repo for the SpeakLocal app family

Canonical session roots:

- Native iOS app work: `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
- Full repo, content, docs, generators, and migration work: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Reusable Codex skill work: `/Users/jojolim/Developer/labs/skill-labs`

Historical pre-Mac roots may appear in old logs or archived docs only. Do not use them for development:

- `E:\AI\SpeakLocal-App-Family`
- `E:\AI\Viet-Travel-Phrases`

Older desktop-agent workspace paths may still appear in archived logs, but they are not active Codex startup roots.

Do not open `/Users/jojolim/Documents/New project` for app work; it is not this repo.

Operator entrypoint:

- use `docs/APP_FAMILY_STRUCTURE.md` for monorepo/native-language-pack structure
- use `native-ios/README.md` and `native-ios/AGENTS.md` for native app sessions in Codex
- use `docs/operations/NATIVE_MAC_CUTOVER.md` for Mac migration/cutover status
- use `docs/operations/APP_STATUS.md` for the live build/test snapshot and current handoff order
- use `docs/operations/CURRENT_BLOCKERS.md` for open gates
- use `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md` as the single ordered checklist for the next human Viet build/TestFlight/device pass
- use `docs/operations/TESTING_RUNBOOK.md` for the repo-owned validation and sync sequence around that operator run

This README is a landing page only, not the execution authority for the Viet build/test lane.

Use this repo for:

- shared app-family implementation
- Viet and Tagalog dual-variant testing
- authored content packs and native resource generation
- language-pack onboarding
- native app definition, premium wiring, and release truth

Current reality summary:

- Jojo's MacBook is the only current development machine for the app.
- `native-ios/` is the only active app product surface. SpeakLocal Vietnam is the current live native proof app.
- The native app is generated from `native-ios/project.yml` and runs as `SpeakLocalNative`.
- Native app-variant planning config now lives in `native-ios/Config/apps/*.json`.
- The long-term native resource target is `native-ios/Resources/LanguagePacks/<language>/`, but current live Viet resources still remain at `native-ios/Resources/*.json` and `native-ios/Resources/Audio/` until a coordinated loader/generator migration.
- The current flagship native flow is the Liquid Glass-style `Xin chào` listing page plus canonical deeper phrase pages, search, back/forward navigation, bottom chrome, bundled audio, and authored canonical phrase pages.
- Authored Viet canonical phrase pages live under `content-draft/viet/canonical-pages/**` and are bundled into `native-ios/Resources/viet-authored-listing-pages.json`.
- Phrase pages should follow the `speaklocal-listing-pages` skill: thoughtful offline "Different ways to say [phrase] in Vietnam" answer pages, not generic generated filler. Lane names such as `tier-one` and `catalog-promoted` describe source origin only; all visible phrase pages should be full-depth canonical pages.
- Viet remains the only live App Store app today.
- Tagalog remains a locally validated second-app candidate, not a released app.
- The legacy Expo/React Native shell has been removed from active repo truth. Historical docs may mention it as archive context only.
- New app UI, Liquid Glass chrome, playback, search, Messages, paywall, and listing work must happen in SwiftUI under `native-ios/`.
- Viet now has a live 900-family v2 content-pack milestone:
  - 18 live travel categories
  - 900 authored intent families / visible entries
  - 150 starter visible entries
  - 750 premium visible entries
  - 919 approved phrase rows
  - 919 approved rows currently marked `audioStatus=ready`
  - 0 approved rows currently marked `audioStatus=planned`
  - native resource exports generated from authored content
  - fresh native device proof should come from the current `native-ios/` build
- Repo build naming now resolves to:
  - `SpeakLocal Vietnam`
  - `SpeakLocal Philippines`
- Repo premium pricing now resolves to:
  - `$4.99` one-time unlock
- Current website direction is now:
  - phone-forward, app-aligned, and responsive on desktop
  - a gateway into the app rather than a separate product
  - per-destination starter/free phrase coverage that should mirror the app's starter layer for that destination
  - destination articles that reinforce and route back into those same starter phrases
- Premium remains native-app-first for now. Do not treat website premium, shared entitlements, login/account architecture, or code redemption as current product truth.
- Tagalog shares the same draft-to-generated-pack builder path and now also inherits the family StoreKit plumbing, but still only carries the earlier 10-scenario / 70-phrase surface, has not been device-proven, and now has a stronger prep surface for the next v2 pass (`content-draft/tagalog/first-wave-priority.csv` plus `risk-review.md`).
- Future prep lanes are now in two states rather than one:
  - `thai` has durable research plus an initial scaffold
  - `japanese`, `turkish`, `spanish`, and `italian` each now have durable research plus a ranked first-wave authoring shortlist for the next translation task
- Those future lanes are still planning truth only. None of them are runtime-ready, audio-ready, or approved for registry wiring yet.
