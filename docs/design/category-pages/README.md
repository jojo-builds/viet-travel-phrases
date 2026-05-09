# SpeakLocal Category Page System Design Packet

This packet designs Browse-owned category and city collection pages for SpeakLocal Vietnam. It is a visual design artifact only: no SwiftUI app code was changed.

## Recommendation

Browse city and category cards should open rich collection pages, not Search results. Search can still surface a category result, but tapping it should hand off to the Browse collection page.

The corrected visual direction intentionally reuses the approved Browse/Search packet style: real or hyper-real Vietnam photography, large serif page titles, soft white Liquid Glass cards, restrained Vietnam red/green accents, and the locked bottom admin/search chrome.

## Jojo Steering Locked In

- Category and city mastheads should use real-life, hyper-realistic, or photo-like imagery. No abstract gradient, no generic illustrated header, no website hero art.
- City hubs should use recognizable local places: Hanoi can use Hoan Kiem Lake or the Old Quarter, Da Nang can use Dragon Bridge or My Khe Beach, Hoi An can use lantern streets, Hue can use Imperial City, and Saigon / Ho Chi Minh City can use Ben Thanh Market, Nguyen Hue, or the Central Post Office area.
- Category pages should use real traveler scenes: airport terminal, hotel lobby or beach resort, food table or street-food stall, market or shopping mall, pharmacy counter, SIM shop, taxi pickup, and so on.
- Avoid specific commercial hotel, mall, airline, or shop branding unless the product has licensed imagery. Use recognizable place types and public landmarks instead.
- Melo should stay out of Browse/Search utility category pages by default. It can appear later as a small, polished companion in practice, unlock, or empty/supportive states.

## Screen Set

| Screen | Asset | Purpose |
| --- | --- | --- |
| Hanoi city hub | `assets/hanoi-city-hub.png` | Shows a city Browse page with first-day shelves, street-name entry, and practice entry. |
| Airport category | `assets/airport-category.png` | Shows subcategories, starter phrase group, and Practice Airport placement. |
| Food category | `assets/food-category.png` | Shows ordering/allergy/payment grouping and Practice Food. |
| Hotel category | `assets/hotel-category.png` | Shows hotel desk phrases, subcategories, saved state, and Practice Hotel. |
| Generic template | `assets/generic-category-template.png` | Uses Shopping as the concrete example for the reusable category template. |
| Search category result | `assets/search-category-result.png` | Shows Search finding a category without replacing Browse as the category surface. |
| Contact sheet | `assets/category-page-system-contact-sheet.png` | One-page overview of the system. |

## Full Category Image Inventory

These are the image directions that should be used when the app expands from this packet into the full Browse category system. Current inventory reviewed: five city hubs from `content-draft/viet/city-library/v1.json` and nineteen scenario categories from `native-ios/Resources/viet-phrase-catalog.json`.

| Collection | Image direction |
| --- | --- |
| Hanoi | Hoan Kiem Lake, Turtle Tower, Old Quarter street corner, or Temple of Literature. |
| Saigon / Ho Chi Minh City | Ben Thanh Market, Nguyen Hue walking street, Central Post Office, or District 1 street scene. |
| Da Nang | Dragon Bridge, My Khe Beach, Marble Mountains, or Han River view. |
| Hoi An | Ancient Town lantern street, Japanese Covered Bridge area, or riverside boats at dusk. |
| Hue | Imperial City / Ngo Mon Gate, Perfume River, or Thien Mu Pagoda. |
| Polite Basics | Calm cafe, hotel desk, or small-shop greeting moment. |
| When You Don't Understand | Traveler at an information desk, cafe counter, or station help window using a phone politely. |
| Transport | Taxi / ride pickup, bus station, train platform, or motorbike street scene. |
| Hotel Accommodation | Unbranded hotel lobby, check-in desk, resort exterior, or luggage drop scene. |
| Food & Drink | Pho table, banh mi counter, coffee shop, or street-food stall. |
| Money, Numbers & Prices | Market stall payment, VND cash, QR/card payment, or price tag close-up. |
| Directions & Navigation | Street corner with signs, phone map near a landmark, or station wayfinding. |
| Airport Border Arrival | Arrivals hall, baggage claim, immigration corridor, or airport pickup area. |
| Health & Pharmacy | Vietnam pharmacy counter or clinic desk, calm and non-emergency. |
| Problems & Help | Hotel front desk, tourist information counter, or calm help interaction. |
| Time, Dates & Booking | Reservation desk, phone booking, timetable board, or calendar/travel plan scene. |
| Shopping | Ben Thanh-style market, Hoi An shopfront, Vincom-style mall corridor, or souvenir stall. |
| Phone, Internet & Power | SIM shop, phone counter, cafe charging table, or portable charger scene. |
| Bathroom & Personal Needs | Clean mall/restroom wayfinding sign or discreet public facility corridor. |
| Emergency & Safety | Calm hospital/police/help signage, emergency contact card, or safe well-lit street. |
| Social Small Talk | Cafe table, market chat, or friendly greeting at a local counter. |
| Sightseeing & Activities | Landmark ticket booth, tour dock, temple entrance, or day-trip pickup. |
| Local Services & Everyday Tasks | Laundry shop, tailor, barber, repair counter, or parcel/local service desk. |
| City Guides | Map plus landmark scene, passport/travel notebook, or city-specific landmark collage. |

## Implementation Notes

- Add a Browse collection route for category and city hubs. Bottom Browse remains selected on these pages.
- Browse cards should push the collection route for `airport`, `hotel`, `food`, city IDs like `hanoi`, and future categories.
- Category pages should group phrase rows by subcategory, then open canonical phrase pages for individual rows.
- Place "Practice this category" after the starter phrase group so users understand the practice pool before starting.
- Search should add a category result card type above phrase matches when a query strongly matches a category or city.
- Tapping a Search category result should open the Browse collection route, preserving Search as discovery rather than the category page itself.
- The Vietnamese phrase copy in the mockups is illustrative design copy. Content-side phrase data should supply canonical strings.

## Visual Guardrails

- Use `docs/design/NATIVE_VISUAL_REFERENCE.md` before implementation.
- Preserve the locked bottom admin/search chrome from the 2026-05-01 references and the approved Browse/Search packet.
- Keep Melo out of category/search utility surfaces for now.
- Keep category pages calm and useful for first-time travelers: phrase groups first, dense-but-readable rows, and no generic feature-tour copy.
- The image-generation standard for future category pages is captured in `prompt-packet.md` and the app-level hero rules in `docs/design/hero-image-style-guide.md`.
- City masthead source images now live in `assets/city-masthead-sources/` and are prepared for the app by `native-ios/scripts/prepare-viet-city-mastheads.swift`. Do not regenerate city hubs with procedural/vector shape scripts; the shipped mastheads should remain photo-like and city-specific.
- Do not use procedural/PIL/vector shape scripts for category, country, compact phrase, place, restaurant, dish, street, or city mastheads. If a specific owned photo-style image is not ready, use a premium realistic fallback and queue the specific asset instead of shipping a cartoon placeholder.

## Local Review

Open `index.html` to review the gallery. The PNGs are image-model design artifacts, not HTML/CSS renders. Future iterations should regenerate from `prompt-packet.md`, then replace the selected assets and contact sheet.
