# SpeakLocal-App-Family

Status: canonical implementation repo for the SpeakLocal app family

Canonical session roots:

- Native iOS app work: `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
- Full repo, content, docs, generators, and migration work: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Reusable Codex skill work: `/Users/jojolim/Developer/labs/skill-labs`

Legacy Windows roots retained for archive/migration lookup only:

- `E:\AI\SpeakLocal-App-Family`
- `C:\Users\Administrator\.openclaw\workspace\projects\speaklocal-app-family`
- `E:\AI\Viet-Travel-Phrases`
- `C:\Users\Administrator\.openclaw\workspace\projects\viet-travel-phrases`

Do not open `/Users/jojolim/Documents/New project` for app work; it is not this repo.

Operator entrypoint:

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
- authored content packs and website-preview exports
- language-pack onboarding
- app definition, premium wiring, and release truth

Current reality summary:

- The Mac is now the primary day-to-day native iOS development machine.
- `native-ios/` is the active SwiftUI/Xcode app lane for SpeakLocal Vietnam.
- The native app is generated from `native-ios/project.yml` and runs as `SpeakLocalNative`.
- The current flagship native flow is the Liquid Glass-style `Xin chào` listing page plus canonical deeper phrase pages, search, back/forward navigation, bottom chrome, bundled audio, and authored Tier 1 listing pages.
- Authored Tier 1 listing-page content lives in `content-draft/viet/listing-pages/**` and is bundled into `native-ios/Resources/viet-authored-listing-pages.json`.
- Listing pages should follow the `speaklocal-listing-pages` skill: thoughtful offline "Different ways to say [phrase] in Vietnam" answer pages, not generic generated filler.
- Viet remains the only live App Store app today.
- Tagalog remains a locally validated second-app candidate, not a released app.
- The existing Expo app under `app/` remains a bridge/reference lane and still contains useful live-app/premium/content work, but it is not the final native UX target.
- The shared v2 family UI and premium seam include a real iOS one-time purchase / restore path under `app/`.
- Viet now has a live 900-family v2 content-pack milestone:
  - 18 live travel categories
  - 900 authored intent families / visible entries
  - 150 starter visible entries
  - 750 premium visible entries
  - 919 approved phrase rows
  - 919 approved rows currently marked `audioStatus=ready`
  - 0 approved rows currently marked `audioStatus=planned`
  - website-preview exports generated from approved starter/default-first slices
  - the latest installable preview build predates this `2026-04-16` pack, so a fresh native preview build is still required before device proof
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
- Premium remains app-first for now. Do not treat website premium, shared entitlements, login/account architecture, or code redemption as current product truth.
- Tagalog shares the same draft-to-generated-pack builder path and now also inherits the family StoreKit plumbing, but still only carries the earlier 10-scenario / 70-phrase surface, has not been device-proven, and now has a stronger prep surface for the next v2 pass (`content-draft/tagalog/first-wave-priority.csv` plus `risk-review.md`).
- Future prep lanes are now in two states rather than one:
  - `thai` has durable research plus an initial scaffold
  - `japanese`, `turkish`, `spanish`, and `italian` each now have durable research plus a ranked first-wave authoring shortlist for the next translation task
- Those future lanes are still planning truth only. None of them are runtime-ready, audio-ready, or approved for registry wiring yet.
