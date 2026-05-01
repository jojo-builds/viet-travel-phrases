# SpeakLocal Category Page Prompt Packet

Use this packet to regenerate or extend the category page visual system. The goal is production-quality iPhone screenshot art for native SwiftUI implementation reference, not a website prototype.

## Global Prompt Rules

Use these constraints on every generated screen:

- Use case: `ui-mockup`.
- Asset type: production-quality visual design mockup, single iPhone 17 Pro Max portrait screenshot.
- Match the approved SpeakLocal Vietnam native iOS Liquid Glass style: pale scenic masthead fading into white content, large black editorial serif titles, frosted translucent cards, soft shadows, restrained Vietnam red and green accents, and generous readable spacing.
- Preserve the real app chrome direction: iPhone status bar / dynamic island, circular back button when pushed, and locked bottom admin/search chrome matching the 2026-05-01 references in `docs/design/NATIVE_VISUAL_REFERENCE.md`.
- Use real-life, hyper-realistic, or photo-like Vietnam imagery for every masthead. Do not use abstract gradients, cartoon headers, generic SaaS art, or website-style hero blocks.
- Keep text legible. Do not crowd phrase rows. Do not let bottom chrome cover tappable content.
- Search can discover a category, but Browse owns city/category collection pages.
- No Melo on Browse/Search utility surfaces unless a future task explicitly asks for a subtle production-ready companion.

## Real Image Direction Standard

Every city or category needs a masthead image that feels like a real travel context:

- City pages: famous local landmarks or distinctive streetscapes.
- Practical categories: real service locations such as airports, hotels, markets, pharmacies, SIM shops, taxis, or stations.
- Sensitive categories: calm, non-alarming, useful imagery. No panic visuals, gore, police drama, or fear-forward emergencies.
- Avoid unlicensed brand logos and named commercial signage unless the product owns or licenses the image.

## Screen Prompts Used

### Hanoi City Hub

```text
Use case: ui-mockup.
Asset type: production-quality visual design mockup, single iPhone 17 Pro Max portrait screenshot.
Primary request: Create a high-fidelity native iOS Liquid Glass screenshot for the SpeakLocal Vietnam Browse collection page "Hanoi".
Scene/backdrop: hyper-realistic Hanoi masthead with Hoan Kiem Lake, Turtle Tower, soft morning haze, and subtle Old Quarter travel mood. The image should feel like a real place, not an illustration.
Layout: iPhone status bar, circular glass back button, large editorial title "Hanoi", helper copy "First-day phrases, street names, and local moments." Use soft white Liquid Glass cards over white content. Bottom Browse/admin chrome remains locked and selected.
Content: city chips "Old Quarter", "Lake", "Street names"; section "Start in Hanoi" with cards "Hotel arrival", "Local greetings", "Street names"; a "Practice Hanoi" module after the starter group; lower shelf "Useful near you" with phrase rows. First-time traveler tone.
Avoid: mascot, generic website hero, flat vector map, fake app chrome, clutter.
```

### Airport Category

```text
Use case: ui-mockup.
Asset type: production-quality visual design mockup, single iPhone 17 Pro Max portrait screenshot.
Primary request: Create a high-fidelity SpeakLocal Vietnam Browse category page for "Airport".
Scene/backdrop: hyper-realistic Vietnam airport arrivals hall with soft daylight, luggage belt / terminal glass / airplane context, no airline branding.
Layout: native iOS Liquid Glass, back button, title "Airport", helper copy "Arrival, baggage, border, and the ride into town." Bottom Browse/admin chrome selected.
Content: subcategory cards "Immigration", "Baggage", "Taxi pickup", "SIM & cash"; starter phrase group with Vietnamese/English rows; "Practice Airport" module after starter phrases; lower shelf for saved and next phrases.
Avoid: search-results layout, mascot, aggressive red, dense survey feeling.
```

### Food Category

```text
Use case: ui-mockup.
Asset type: production-quality visual design mockup, single iPhone 17 Pro Max portrait screenshot.
Primary request: Create a high-fidelity SpeakLocal Vietnam Browse category page for "Food".
Scene/backdrop: hyper-realistic Vietnamese food scene with pho, herbs, iced coffee, and a warm street-food or cafe setting. It should look appetizing and real.
Layout: native iOS Liquid Glass with large "Food" title, readable white cards, restrained red/green accents, bottom Browse/admin chrome selected.
Content: subcategory cards "Ordering", "Allergies", "Payment", "Coffee"; starter phrase rows; "Practice Food" module; lower shelf for useful restaurant phrases.
Avoid: cartoon food, generic restaurant stock look, mascot, website layout.
```

### Hotel Category

```text
Use case: ui-mockup.
Asset type: production-quality visual design mockup, single iPhone 17 Pro Max portrait screenshot.
Primary request: Create a high-fidelity SpeakLocal Vietnam Browse category page for "Hotel".
Scene/backdrop: hyper-realistic unbranded Vietnam hotel lobby or beach-resort check-in desk with warm light, luggage, plants, and calm travel mood.
Layout: native iOS Liquid Glass, pushed page back button, large "Hotel" title, helper copy "Check in, luggage, room help, breakfast, and checkout." Bottom Browse/admin chrome selected.
Content: subcategory cards "Check-in", "Luggage", "Room help", "Checkout"; starter phrase group; saved state; "Practice Hotel" module after starter phrases; lower shelves.
Avoid: named hotel logos, mascot, generic SaaS cards, fake browser chrome.
```

### Generic Category Template Using Shopping

```text
Use case: ui-mockup.
Asset type: production-quality visual design mockup, single iPhone 17 Pro Max portrait screenshot.
Primary request: Create the reusable SpeakLocal Vietnam category template using "Shopping" as the example.
Scene/backdrop: hyper-realistic Vietnam market / shopping street with lanterns, clothing, souvenirs, produce, and warm daylight. It can feel like Ben Thanh Market or Hoi An shopping, but avoid exact shop branding.
Layout: native iOS Liquid Glass, title "Shopping", helper copy "Prices, sizes, payment, and polite browsing." Bottom Browse/admin chrome selected.
Content: hero promise, subcategory rail, starter phrase group, "Practice Shopping" module, deeper shelves, and canonical phrase rows.
Avoid: abstract icons as the hero, mascot, clutter, website mockup.
```

### Search Category Result

```text
Use case: ui-mockup.
Asset type: production-quality visual design mockup, single iPhone 17 Pro Max portrait screenshot.
Primary request: Create a high-fidelity native iOS Liquid Glass screenshot for SpeakLocal Vietnam Search results showing a category result without replacing Browse.
Scene/backdrop: pale Vietnam scenic masthead fading into white content.
Layout: title "Results for hotel", helper copy "Here are the most helpful matches.", filter chips "All", "Phrases", "Categories", "Cities". Bottom Search chrome shows a raised Home glass circle and expanded frosted search field with query text "hotel"; no keyboard visible.
Content: "Best match" section with red label "Category"; polished category result card with a realistic hotel lobby thumbnail, badge "Browse collection", title "Hotel", subtitle "Check in, bags, room help, breakfast, and checkout phrases.", CTA "Open in Browse", chips "Check-in", "Luggage", "Room help"; below that phrase matches for hotel phrases.
Avoid: making Search the category page, mascot, browser UI, keyboard.
```

## Future Category Image Matrix

| Collection | Masthead image prompt seed |
| --- | --- |
| Hanoi | Hoan Kiem Lake, Turtle Tower, Old Quarter, or Temple of Literature. |
| Saigon / Ho Chi Minh City | Ben Thanh Market, Nguyen Hue, Central Post Office, or District 1 street scene. |
| Da Nang | Dragon Bridge, My Khe Beach, Marble Mountains, or Han River. |
| Hoi An | Lantern street, riverside boats, Ancient Town, or Japanese Covered Bridge area. |
| Hue | Imperial City, Ngo Mon Gate, Perfume River, or Thien Mu Pagoda. |
| Polite Basics | Cafe, hotel desk, small shop, or warm greeting counter. |
| When You Don't Understand | Information desk, station counter, or phone-assisted clarification moment. |
| Transport | Taxi pickup, train platform, bus station, or street transport scene. |
| Hotel Accommodation | Hotel lobby, resort check-in, luggage drop, or room-help context. |
| Food & Drink | Pho, banh mi, coffee, restaurant table, or street-food stall. |
| Money, Numbers & Prices | Market payment, VND cash, QR payment, price tags. |
| Directions & Navigation | Street corner, wayfinding signs, phone map near landmark. |
| Airport Border Arrival | Arrivals hall, baggage claim, immigration corridor, airport pickup. |
| Health & Pharmacy | Pharmacy counter or clinic reception, calm and useful. |
| Problems & Help | Hotel desk, tourist help counter, calm assistance. |
| Time, Dates & Booking | Reservation desk, timetable, calendar, or booking call. |
| Shopping | Market, mall corridor, souvenir stall, or Hoi An shopfront. |
| Phone, Internet & Power | SIM shop, phone counter, charging table, portable charger. |
| Bathroom & Personal Needs | Clean wayfinding sign, mall corridor, discreet restroom context. |
| Emergency & Safety | Calm hospital/police/help signage, emergency contact card. |
| Social Small Talk | Cafe table, market chat, local counter greeting. |
| Sightseeing & Activities | Landmark ticket booth, tour dock, temple entrance, day-trip pickup. |
| Local Services & Everyday Tasks | Laundry shop, tailor, barber, repair counter, parcel desk. |
| City Guides | Map plus landmarks, passport notebook, city-specific travel scene. |
