# SpeakLocal Front-End QA Goal - 2026-07-04

Start time: 2026-07-04 21:15 PST
Minimum requested run: 8 hours
Branch/check-out: `main` in `/Users/jojolim/Developer/products/speaklocal/app-family`
Paywall: excluded unless Jojo explicitly includes it

## Objective

Run a traveler-style front-end bug hunt across the current SpeakLocal Vietnam native iOS app. Treat this as launch-readiness QA, not a smoke test. Move through the app the way a real user would, click buttons, use controls, navigate forward/backward, save and unsave content, play audio, search, practice, and inspect top/bottom glass chrome across representative pages.

Fix safe, repo-evidenced bugs as they are found. Preserve the existing premium visual design; do not remove glass, panels, imagery, or functionality to make a bug disappear.

## Required Coverage

- Home: vertical scroll, horizontal shelves, phrase cards, city cards, bottom toolbar, search island, saved state, audio dock, lag/jank watch.
- Browse root: travel situations, city cards, phrase-family cards, search entry, tab switching, bottom chrome.
- Browse collections: airport, hotel, eating out, food, drink, getting around, shopping, polite repair, essentials, first-day, and any other visible category routes.
- Top glass/admin section menus: confirm section dropdown, in-page rail/section jumps, audio speed/menu controls, and consistency between menu guides, city pages, and multi-section travel situation pages.
- City pages: Da Nang, Hanoi, Saigon/HCMC, Hoi An, Hue; sections, cards, place pages, city phrase routes, image/backdrop behavior, audio, saved state.
- Food and drink menus: section dropdown, menu item pages, item audio, order phrase audio, category filtering, saved state, search results.
- Listing/detail pages: hero title, English/pronunciation, audio dock, breakdown carousel, phrase rows, related rows, Explore next, save/unsave, back/forward navigation.
- Search: open from bottom search island, type realistic queries, clear, no-results, broad scrollable results, exact phrase, food/menu, city/place, noisy travel queries, result navigation.
- Saved: empty state, save from multiple surfaces, unsave, persistence after tab switches and app relaunch.
- Practice: entrypoints, mode selection, round flow, answer controls, completion/reset behavior, audio in practice if exposed.
- Navigation/chrome: back, forward, swipe back/forward, bottom tab switching, search morph, static glass controls, safe-area/bottom inset.
- Accessibility/minimum touch: speaker buttons, close/back controls, section chips/dropdowns, tap targets that should be reachable.

## Evidence Rules

- Keep screenshots under `docs/task-results/frontend-qa-2026-07-04/screenshots/`.
- Keep xcodebuild `.xcresult` bundles or logs under `docs/task-results/frontend-qa-2026-07-04/runtime/` or `logs/`.
- For each issue, record: surface, steps, observed behavior, expected behavior, severity, fix status, validation.
- Do not call the app launch-ready from validators alone; front-end evidence and phone proof matter.
- If app code changes, rerun focused tests and build/install/launch `main` on Jojo's physical iPhone when available.

## Bug Severity

- `P0`: crash, launch blocker, data loss, unusable major route.
- `P1`: launch-blocking front-end failure, broken core navigation, unplayable visible audio with speaker icon, major visual regression, clipped unreadable primary copy.
- `P2`: important UX bug, inconsistent chrome, broken secondary route, notable jank, bad state persistence.
- `P3`: polish follow-up that should not block a first release.

## Stop Conditions

Stop only when the eight-hour minimum has been satisfied and the required coverage has been walked, fixed, and validated, or when a true blocker prevents further progress. True blockers include unavailable signing/device access, user-only credentials, destructive cleanup decisions, paid-service decisions, unclear product/legal/language decisions, or repeated validation failure after a concrete fix attempt.
