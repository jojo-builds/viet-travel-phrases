# SpeakLocal-App-Family

Status: canonical implementation repo for the SpeakLocal app family

Canonical session roots:

- `E:\AI\SpeakLocal-App-Family`
- `C:\Users\Administrator\.openclaw\workspace\projects\speaklocal-app-family`

Compatibility aliases during transition:

- `E:\AI\Viet-Travel-Phrases`
- `C:\Users\Administrator\.openclaw\workspace\projects\viet-travel-phrases`

Operator entrypoint:

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

- Viet remains the only live App Store app today.
- Tagalog remains a locally validated second-app candidate, not a released app.
- The shared v2 family UI and premium seam now include a real iOS one-time purchase / restore path under `app/`.
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
