# App Store Screenshot Storyboard

Date: 2026-07-05
Status: storyboard ready, final captures pending
Target: iPhone 6.9-inch portrait first

## Apple Spec Notes

Apple requires 1 to 10 screenshots in JPEG, JPG, or PNG formats. For 6.9-inch iPhone displays, accepted portrait screenshot sizes include 1260 x 2736, 1290 x 2796, and 1320 x 2868 pixels. If 6.9-inch screenshots are accepted and look clean, use them as the primary set before creating optional fallback sizes.

Every final screenshot must be captured from the current native iOS app or clearly marked as draft. Do not use old Expo, web, or mock app surfaces.

## Capture Principles

- Use current native `main`.
- Use real routes and supported app states.
- Keep overlay text short and aligned away from phrase text, audio buttons, search fields, and bottom chrome.
- Use warm, premium, native-iOS framing rather than fear-led travel copy.
- Do not imply arbitrary translation, full fluency, emergency authority, cloud sync, or all-content audio coverage.

## Recommended 7-Screenshot Set

| # | Caption | Audience Segment | User Problem / Moment | Native Screen | Required Evidence | Claim Risk | Success Metric | Next Action |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `Plan Vietnam with phrases you can hear` | Pre-trip traveler | Wants the trip to feel more concrete before arrival | Home with bottom chrome, search island, useful shelf content | Current Home screenshot | `NEEDS_SCREENSHOT` | First-impression conversion | Capture fresh 6.9-inch Home |
| 2 | `Know what to eat and how to ask` | Food-curious traveler | Menu names feel unfamiliar | Food or menu detail page with supported audio and useful context | Current food/menu page, audio affordance visible | `NEEDS_SCREENSHOT`; avoid all-menu completeness claim | Screenshot swipe depth, food hook conversion | Choose final dish/page with app proof |
| 3 | `Search the trip moment` | Practical planner | Knows situation, not exact phrase | Search query such as `hotel`, `coffee`, or `taxi` | Current Search results and route behavior | `NEEDS_SCREENSHOT`; no arbitrary translator claim | Search-driven installs | Capture search result screen |
| 4 | `Explore places with useful phrases` | Itinerary builder | Has place names but little context | City/place detail page such as Dragon Bridge, Ben Thanh, or Bà Nà Hills | Current city/place detail with save/useful phrase area | `NEEDS_SCREENSHOT`; no comprehensive guide claim | Place/story engagement | Select final route from current app |
| 5 | `Save what matters for your trip` | Planner building a trip pocket | Wants a personal set of useful pages | Saved surface with seeded realistic content | Saved state proof from current app | `NEEDS_SCREENSHOT`; no cloud sync claim | Save-oriented conversion | Capture seeded Saved state |
| 6 | `Practice before you land` | Beginner who dislikes classes | Wants rehearsal without school pressure | Native Practice round or saved-practice flow | Current Practice screenshot | `NEEDS_SCREENSHOT`; avoid fluency/course claims | Practice-open conversion | Capture Practice state |
| 7 | `Help moments stay easy to find` | Traveler wanting calm support | Wants pharmacy/health/help phrases nearby | Health, pharmacy, help, or support phrase/detail page | Current supported route with calm framing | `NEEDS_SCREENSHOT`; no emergency/medical reliability claim | Trust and retention | Choose non-dramatic support screen |

## Deferred Paywall Screenshot

Caption: `Try the full Vietnam companion first`

Status: `FUTURE / DO NOT PUBLISH`, `NEEDS_STOREKIT_PROOF`, `NEEDS_APP_STORE_CONNECT`

Required before use:

- Approved current paywall route on `main`.
- StoreKit purchase, restore, relaunch, and gating proof.
- Support, privacy, terms, and restore actions visible.
- Trial terms match App Store Connect.

## Screenshot Request To Native QA Agent

Use this exact request when asking for capture help:

Capture a fresh 6.9-inch portrait App Store screenshot set from current native iOS `main` for SpeakLocal Vietnam. Required screens: Home, food/menu detail with supported audio, Search results for a real trip query, city/place detail, Saved seeded state, Practice round, and one calm support/help phrase page. Use a clean demo state, avoid paywall unless StoreKit proof is complete, and save full-resolution PNGs plus a contact sheet. Mark every route, simulator/device, commit hash, and capture command in the receipt.
