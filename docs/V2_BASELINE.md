# V2 Baseline

## What now exists

- Shared shell implementation now verified in repo across Viet and Tagalog:
  - stronger home hero and search hierarchy
  - bottom-docked phrasebook search with keyboard-aware offset handling and scroll-collapse behavior
  - richer category browsing cards with inline starter-vs-premium counts
  - clearer separation between category cards, intent-family headers, primary phrase cards, and nearby variants
  - lighter subtle play/save controls on active phrase surfaces with 44px touch targets
  - neutral audio-ready vs audio-planned treatment that no longer reads like a premium lock state
  - grouped scenario/category screens with inline premium depth preview inside live category flows
  - a shared premium plan screen
  - saved phrases that retain category and intent-family context
- Device-proof note:
  - the shared shell behavior is now implemented and locally validated in repo truth, but the small-iPhone physical walkthrough and native purchase proof still remain open in `docs/operations/*`
- A real family premium seam:
  - app registry product IDs
  - `expo-iap` plugin wired in Expo config
  - iOS one-time purchase / restore adapter
  - StoreKit entitlement sync plus on-device persistence
  - dev validation unlock only when the real store path is unavailable
- A real Viet content boundary on top of that seam:
  - 18 live categories
  - 900 authored intent families / visible entries
  - 150 starter visible entries
  - 750 premium visible entries
  - 919 approved phrase rows
  - 919 approved rows currently marked `audioStatus=ready`
  - 0 approved rows currently marked `audioStatus=planned`
  - starter vs premium tagging in the real pack
  - website preview exports generated from approved starter/default-first slices

## Current content reality

- Viet is no longer just the old thin starter surface.
- Viet now ships a materially stronger 900-family v2 milestone:
  - current starter visible entries: 150
  - current premium visible entries: 750
  - current total visible entries: 900
  - current approved phrase rows: 919
  - current audio posture: 919 ready / 0 planned
  - future expansion beyond this milestone is an explicit future-only `200 / 1000` option, not the current live boundary
- Tagalog still carries the earlier thin pack:
  - 10 scenarios
  - 70 phrases

## Current content model

- Scenario remains the runtime category container.
- Intent family is the visible decision unit inside each category.
- One family contains:
  - one `say-first` primary phrase
  - optional compact nearby variants
  - optional usage note / `youMayHear`
  - starter or premium access based on the family primary
- Visible entry counts are family-primary counts, not raw phrase-row counts.
- Website preview exports are curated from approved starter slices, not dumped from the full app runtime.

For the fuller schema details, see `docs/V2_CONTENT_MODEL.md`.

## Tagalog inheritance

Tagalog now inherits automatically:

- the generated-pack builder path
- the family-aware phrase schema
- starter vs premium filtering behavior
- the grouped scenario UI
- the website-preview export tooling
- the `expo-iap` plugin and shared premium provider seam
- the `$4.99` one-time unlock surface
- the `SpeakLocal Philippines` build name

Tagalog still needs separate work for:

- real 18-category content authoring
- real starter vs premium content decisions
- website preview approvals for Tagalog slices
- Tagalog App Store Connect product confirmation
- Tagalog device proof later

## Before Viet v2 can ship confidently

- package a fresh native preview build that includes the current 900-family pack
- confirm the Viet non-consumable in App Store Connect at `$4.99`
- run real purchase / restore / restart / gating validation on physical iOS hardware
- capture the evidence honestly in `docs/operations/*`
- keep the current `919 ready / 0 planned` audio coverage honest and benchmark continuity before any stronger same-speaker quality claim
- treat any future move beyond `150 / 750 / 900` as a deliberate new scope decision, not as implied current work
- keep the earlier shared-search device-proof debt honest in `docs/operations/*`
