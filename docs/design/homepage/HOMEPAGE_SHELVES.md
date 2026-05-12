# Homepage Shelves

This is the current homepage shelf contract for SpeakLocal Vietnam.

## Product Rule

Homepage shelves are curated entry points into existing Browse routes. Do not create a separate homepage-only category system unless a route truly does not exist.

Each phrase shelf should:

- show a small curated set of homepage-worthy phrase pages first
- end with a `More` card that opens the existing Browse route
- use friendly, beginner-safe phrases before scary or complicated phrases
- keep emergency/help content reachable without making it the first impression

## Shelf Order

1. `Use now`
   - Source: `HomeUseNowCatalog.starterIDs`
   - Purpose: fastest beginner phrases to play immediately.

2. `First hour in Vietnam`
   - Route: `.category("first-day")`
   - Source categories: `airport-border-arrival`, `hotel-accommodation`, `transport`, `directions-navigation`
   - Purpose: airport, pickup, SIM, ATM, hotel arrival.

3. `Food & coffee`
   - Route: `.category("food")`
   - Source categories: `food-drink`, `money-numbers-prices`
   - Purpose: menu, water, coffee, spice/allergy, paying.

4. `When you get stuck`
   - Route: `.category("polite-repair")`
   - Source categories: `understanding-repair`, `polite-basics`, `problems-help`
   - Purpose: repeat, slow down, write it, use English, ask for help.

5. `Taxi & getting around`
   - Route: `.category("getting-around")`
   - Source categories: `transport`, `directions-navigation`
   - Purpose: pickup points, drivers, addresses, taxi help.

6. `Hotel basics`
   - Route: `.category("hotel")`
   - Source categories: `hotel-accommodation`, `time-dates-booking`, `local-services-everyday-tasks`
   - Purpose: reservation, passport, Wi-Fi, checkout, room help.

7. `Money & shopping`
   - Route: `.category("shopping")`
   - Source categories: `shopping`, `money-numbers-prices`, `local-services-everyday-tasks`
   - Purpose: prices, receipts, cards, cash, sizes.

8. `Help & emergency`
   - Route: `.category("emergency")`
   - Source categories: `problems-help`, `health-pharmacy`, `emergency-safety`
   - Purpose: help, pharmacy, doctor, passport, police/hospital basics.

9. `Messages`
   - Source: `HomeContent.practiceScenarios`
   - Purpose: short conversation/story practice.

10. `Start with a situation`
    - Source: existing situation cards
    - Purpose: broad Browse entry points.

11. `Explore by city`
    - Source: `BrowseSearchDestinations.homepageCityShortcuts`
    - Purpose: city guides.

12. Personal shelves
    - `Keep going`, `Saved for later`, and `Message list`
    - Only show when local user state exists.

13. Lower learning shelves
    - `Who are you speaking to?`
    - `Deeper phrase cards`

## Implementation Notes

The source of truth in native iOS is `HomeContent.homepagePhraseShelves` in `native-ios/App/Views/AppShellView.swift`.

Do not use raw low-level tag IDs directly on Home. Use the route plus a curated list of phrase page IDs. The route is for the `More` card; the phrase IDs are the first impression.

