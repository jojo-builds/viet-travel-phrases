# Homepage Shelves

This is the current homepage shelf contract for SpeakLocal Vietnam.

## Product Rule

Homepage shelves are curated entry points into existing Browse routes. Do not create a separate homepage-only category system unless a route truly does not exist.

Each phrase shelf should:

- show a small curated set of homepage-worthy phrase pages first
- end with a `More` card that opens the existing Browse route
- use friendly, beginner-safe phrases before scary or complicated phrases
- keep emergency/help content reachable without making it the first impression

## Visual Rhythm

The homepage should feel like a mixed discovery feed, closer to a streaming app than a repeated database list. Do not render every shelf with the same card treatment.

Use the existing card families deliberately:

- quick two-row audio tiles for instant beginner phrases
- spotlight phrase cards plus compact rows for first-hour and hotel basics
- realistic image cards for city discovery
- medium two-column audio grids for food, coffee, money, and shopping
- circular message contacts for guided conversations
- wide phrase rows for transport and help
- image-backed situation rows for Browse entry points
- large player cards lower on the page for deeper phrase practice

Personal shelves are state-gated. `Keep going`, `Saved for later`, and `Message list` must not appear on a fresh first launch; they should show only after local recent/saved/practice state exists.

## First-Launch Shelf Order

1. `Use now`
   - Source: `HomeUseNowCatalog.starterIDs`
   - Layout: two-row quick audio carousel.
   - Purpose: fastest beginner phrases to play immediately.

2. `First hour in Vietnam`
   - Route: `.category("first-day")`
   - Source categories: `airport-border-arrival`, `hotel-accommodation`, `transport`, `directions-navigation`
   - Layout: spotlight phrase card plus compact phrase rows.
   - Purpose: airport, pickup, SIM, ATM, hotel arrival.

3. `Explore by city`
   - Source: `BrowseSearchDestinations.homepageCityShortcuts`
   - Layout: realistic image city cards.
   - Purpose: city guides and location-led discovery.

4. `Food & coffee`
   - Route: `.category("food")`
   - Source categories: `food-drink`, `money-numbers-prices`
   - Layout: medium two-column audio grid plus a wide `More` row.
   - Purpose: menu, water, coffee, spice/allergy, paying.

5. `Messages`
   - Source: `HomeContent.practiceScenarios`
   - Layout: circular message contact rail.
   - Purpose: short conversation/story practice.

6. `Taxi & getting around`
   - Route: `.category("getting-around")`
   - Source categories: `transport`, `directions-navigation`
   - Layout: wide phrase rows plus a wide `More` row.
   - Purpose: pickup points, drivers, addresses, taxi help.

7. `Start with a situation`
   - Source: existing situation cards
   - Layout: image-backed rows.
   - Purpose: broad Browse entry points.

8. `When you get stuck`
   - Route: `.category("polite-repair")`
   - Source categories: `understanding-repair`, `polite-basics`, `problems-help`
   - Layout: compact quick audio tiles.
   - Purpose: repeat, slow down, write it, use English, ask for help.

9. `Hotel basics`
   - Route: `.category("hotel")`
   - Source categories: `hotel-accommodation`, `time-dates-booking`, `local-services-everyday-tasks`
   - Layout: spotlight phrase card plus compact phrase rows.
   - Purpose: reservation, passport, Wi-Fi, checkout, room help.

10. `Who are you speaking to?`
    - Source: `PhrasePage.xinChao.localGreetings`
    - Layout: relationship list card.
    - Purpose: relationship-aware hellos without making the user hunt.

11. `Money & shopping`
   - Route: `.category("shopping")`
   - Source categories: `shopping`, `money-numbers-prices`, `local-services-everyday-tasks`
   - Layout: medium two-column audio grid plus a wide `More` row.
   - Purpose: prices, receipts, cards, cash, sizes.

12. `Help & emergency`
   - Route: `.category("emergency")`
   - Source categories: `problems-help`, `health-pharmacy`, `emergency-safety`
   - Layout: wide phrase rows plus a wide `More` row.
   - Purpose: help, pharmacy, doctor, passport, police/hospital basics.

13. `Deeper phrase cards`
    - Source: `HomeContent.featuredIDs`
    - Layout: large player cards.
    - Purpose: slower, richer phrase practice after the quick entry shelves.

## Returning-User Inserts

When local user state exists, insert personal shelves directly after the hero/header and before `Use now`:

1. `Keep going`
2. `Saved for later`
3. `Message list`

These shelves are intentionally omitted on a clean first launch so new users do not see fake history or empty state furniture.

## Implementation Notes

The source of truth in native iOS is `HomeContent.homepagePhraseShelves` in `native-ios/App/Views/AppShellView.swift`.

Do not use raw low-level tag IDs directly on Home. Use the route plus a curated list of phrase page IDs. The route is for the `More` card; the phrase IDs are the first impression.
