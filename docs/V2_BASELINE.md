# V2 Baseline

## Product audience baseline

- SpeakLocal v2 is a native curated destination travel companion for the excited pre-trip traveler, not a general translator and not an academic language-learning app.
- The primary user is planning or seriously considering a Vietnam trip and wants the country to feel more vivid and less intimidating before arrival through food, cities, menus, culture, pronunciation, and useful everyday phrases.
- The app should still work in-country, but that utility is the payoff for pre-trip preparation. Google Translate, Apple Translate, and general-purpose AI own arbitrary live translation; SpeakLocal should own curated Vietnam discovery plus practical phrase readiness.
- For Vietnam, the strongest app signals should be food and coffee, city/place exploration, menu and drink vocabulary, things to do, noun-first browse paths, culturally respectful phrase hubs, audio-first pronunciation, and saved/practice loops that help the traveler build a personal trip phrase set.
- Arrival, transport, repair, health, and emergency flows remain important, but they should be presented as reachable support surfaces rather than the emotional lead of the product.

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
  - native app config product IDs
  - native StoreKit subscription / restore adapter
  - StoreKit entitlement sync plus on-device persistence
  - dev validation unlock only when the real store path is unavailable
- A real Viet content boundary on top of that seam:
  - 19 runtime scenarios
  - 1782 authored intent families / visible clusters
  - 177 starter visible intent families
  - 1605 premium visible intent families
  - 1800 source phrase rows
  - 1793 canonical phrase pages
  - 11728 relation rows
  - 4318 bundled audio assets
  - 778 planned missing-audio phrase rows
  - 0 release-blocking missing-audio rows
  - starter vs premium tagging in the real pack
  - website preview exports generated from approved starter/default-first slices

## Current content reality

- Viet is no longer just the old thin starter surface.
- Viet now ships a materially stronger generated native graph:
  - current starter visible intent families: 177
  - current premium visible intent families: 1605
  - current total visible intent families / clusters: 1782
  - current source phrase rows: 1800
  - current canonical phrase pages: 1793
  - current relation rows: 11728
  - current audio posture: 4318 bundled audio assets, 778 planned missing-audio phrase rows, 0 release-blocking missing-audio rows
  - older `150 / 750 / 900` and `200 / 1000` planning shapes are historical references only unless a future task deliberately reopens them
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

- the native resource generation pattern
- the family-aware phrase schema
- starter vs premium filtering behavior
- the grouped scenario UI
- native StoreKit premium-provider expectations
- the `7-day free trial, then $4.99/month` subscription surface
- the `SpeakLocal Philippines` build name

Tagalog still needs separate work for:

- real 18-category content authoring
- real starter vs premium content decisions
- website preview approvals for Tagalog slices
- Tagalog App Store Connect product confirmation
- Tagalog device proof later

## Before Viet v2 can ship confidently

- package a fresh native preview build that includes the current generated Viet graph
- confirm the Viet monthly subscription in App Store Connect at `7-day free trial, then $4.99/month`
- run real purchase / restore / restart / gating validation on physical iOS hardware
- capture the evidence honestly in `docs/operations/*`
- keep the current planned missing-audio queue honest and benchmark continuity before any stronger same-speaker quality claim
- treat any future move beyond the generated `177 / 1605 / 1782` family boundary as a deliberate new scope decision, not as implied current work
- keep the earlier shared-search device-proof debt honest in `docs/operations/*`
