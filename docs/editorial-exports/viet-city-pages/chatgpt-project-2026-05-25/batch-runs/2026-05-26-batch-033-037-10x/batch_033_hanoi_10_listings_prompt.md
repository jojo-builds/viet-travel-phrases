You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_033` in the final handoff block. Put `SpeakLocal v2.2 BATCH_033 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need, even 10+ minutes. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Batch 013-032 audit tightening for this 10-listing run:
- Start the final answer with the batch title and then the first listing. Do not add a `Source basis`, `Source grounding`, `Grounding note`, citation, or setup paragraph before the first listing.
- Do not include Markdown links, source chips, citation cards, pasted-text chips, clickable Google Doc/Sheet references, or `utm_source=chatgpt.com` links anywhere in final output, including implementation notes.
- Keep phrase cards to 2-3, and only use ready-audio reusable traveler-action phrases. Place-name audio is pronunciation/name support by default, not a visible phrase card.
- Do not create one-off phrases for a single attraction, restaurant, dish, object, or transportation node. Mark them as hidden/planned instead.
- Visible copy and implementation notes must not say `useful because`, `reference line`, `destination`, `anchor`, `canonical model`, `content role`, `this page helps`, or `the job is`.
- Vary headings across all ten listings. Do not default to `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`. If two headings in this batch share that scaffold, revise one before final.
- Write travel copy, not a database note. Short, observed, specific, calm. The first paragraph should sound like a person at the place or table, not a catalog deciding where a page belongs.
- Keep implementation notes compact and import-facing: IDs, phrase/audio status, mention candidates, freshness risks, and handoff block only. Do not turn notes into a schema dump.
- If current venue facts might be stale, keep that risk in internal source/freshness notes instead of visible copy.
- Because this batch has 10 listings, avoid over-explaining. Each listing should be readable for Jojo review without screenshots.
- If you cannot produce the full batch, output `BLOCKED_STUB` and the blocker instead of a partial response.

# New Chat Prompt for This Project

Pick city listings from the ledger whose status is `not_started` or `voice_rejected_rewrite`. Use 10 only when Jojo asks or all listings are easy/low-research. Codex has provided an exact claimed batch list, so use those rows only and do not pick replacements.

Before writing, read:
- the v2.2 Source Bundle,
- the Copy Ledger and Catalogs spreadsheet,
- the Canonical 31 examples inside the source bundle,
- the Phrase Picker Ready Audio tab,
- the Menu Catalog tab if any listing is food, drink, cafe, restaurant, dessert, market, or shop related.

For each listing, write one v2.2 app-detail draft. Use existing ready-audio phrase IDs when possible. Use existing menu/catalog items when natural. Do not invent facts. Do not write like a QA form.

Output in a readable review format first, not JSON. Start with a clean reader view that contains only app-visible copy. Put schema fields, self-score, QA, source notes, freshness notes, phrase/audio status, and Mentioned Here mapping after the reader view.

Self-score each draft against v2.2 voice and revise the weakest visible lines before final output. The score is an internal drafting aid only; the output remains draft/review material for later Jojo/Codex approval, import, and production validation.

End with this Codex handoff block:

```markdown
## Codex handoff block

- `batch_id: ...`
- `page_ids: ...`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: ...`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
- `visible_copy_risks: ...`
- `source_freshness_risks: ...`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```


## Exact batch rows

### 1. city-hanoi-place-cho-buoi-market
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chợ Bưởi
- `english_name`: Buoi Market
- `place_kind`: market
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceChoBuoiMarket
- `legacy_summary`: Cho Buoi Market shows Hanoi's everyday buying rhythm: plant stalls, household goods, small vendors, narrow lanes, and the practical life that keeps a neighborhood moving.
- `legacy_context`: For Buoi Market, Hanoi's market story comes through snack counters, bargaining rhythm, bags, and local shopping movement, alongside Hanoi market-morning energy.
- `legacy_sections_compact`: Why go: This is not a polished souvenir stop, it is Hanoi as a local market scene, with plants, goods, signs, and vendors giving the city a lived-in texture. | What you'll get: Cho Buoi matters because it widens Hanoi beyond monuments and cafes into the daily neighborhood economy visitors pass through on the ground. | Say it locally: Hear Chợ Bưởi with a neighborhood market morning in mind: plant stalls, household goods, small vendors, and scooters edging past narrow lanes. | Worth it if: Worth it if you like seeing daily life through browsing, snacks, color, small goods, and local rhythm: local shopping movement, market aisles, produce colors, and snack counters, alongside Hanoi market-morning energy. | Before you go: Buoi Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi market lane with plants and household goods with bargaining rhythm, bags, local shopping movement, and market aisles, alongside Hanoi market-morning energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-coffee-hop
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Đi cà phê Hà Nội
- `english_name`: Hanoi coffee hop
- `place_kind`: experience
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceCoffeeHop
- `legacy_summary`: A Hanoi coffee hop turns the city into a sequence of cups: egg coffee, iced milk coffee, tiny stools, upstairs cafes, and street views between stops.
- `legacy_context`: For Hanoi coffee hop, Hanoi's route story comes through street corners, food stops, cafe pauses, and local movement, alongside old-quarter cafe rhythm.
- `legacy_sections_compact`: Why go: This is Hanoi through pauses rather than landmarks: one cafe table, then another, with sweetness, ice, old streets, and conversation making the city feel close. | What you'll get: The coffee hop matters because Hanoi's cafe culture is a travel experience of its own, mixing French-era habits, local sweetness, small spaces, and slow observation. | Say it locally: Hear Đi cà phê Hà Nội while imagining a gentle cafe route: egg coffee, iced milk coffee, tiny stools, upstairs rooms, and Old Quarter street views. | Worth it if: Worth it if Hanoi coffee hop gives your itinerary a clearer image: cafe pauses, local movement, the route between named places, and street corners, alongside old-quarter cafe rhythm. | Before you go: Hanoi coffee hop works best when the name is tied to the reason for going, not memorized as an abstract label. Picture sequence of Hanoi coffee cups on cafe tables, street view with food stops, cafe pauses, local movement, and the route between named places, alongside old-quarter cafe rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-cong-ca-phe-trieu-viet-vuong
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Cộng Cà Phê
- `english_name`: Cong Ca Phe
- `place_kind`: cafe
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlaceCongCaPheTrieuVietVuong
- `legacy_summary`: Cong Ca Phe is worth saving for Hanoi's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect retro-style Vietnamese cafe with green chairs and phin coffee.
- `legacy_context`: For Cong Ca Phe, Hanoi's cafe story comes through coffee counters, iced glasses, street stools, and design details, alongside Hanoi coffeehouse culture.
- `legacy_sections_compact`: Why go: Cong Ca Phe is worth saving when you want Hanoi's cafe culture, not just caffeine: soft pauses, cafe views, coffee counters, and iced glasses, alongside Hanoi coffeehouse culture. | What you'll get: At Cong Ca Phe, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: retro-style Vietnamese cafe with green chairs and phin coffee, with coffee counters, iced glasses, street stools, and design details, alongside Hanoi coffeehouse culture. | Say it locally: Say Cộng Cà Phê for Cong Ca Phe. The local name is easier to remember once it sits beside iced glasses, street stools, design details, and soft pauses, alongside Hanoi coffeehouse culture. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: cafe views, coffee counters, iced glasses, and street stools, alongside Hanoi coffeehouse culture. | Before you go: Cong Ca Phe works best when the name is tied to the reason for going, not memorized as an abstract label. Picture retro-style Vietnamese cafe with green chairs and phin coffee with design details, soft pauses, cafe views, and coffee counters, alongside Hanoi coffeehouse culture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-cyclo-old-quarter
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Xích lô phố cổ
- `english_name`: Old Quarter cyclo ride
- `place_kind`: experience
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceCycloOldQuarter
- `legacy_summary`: Old Quarter cyclo ride is worth knowing in Hanoi because it brings movement across the city as part of the discovery into the trip. Expect cyclo passing Old Quarter storefronts, passenger view.
- `legacy_context`: For Old Quarter cyclo ride, Hanoi's route story comes through the route between named places, street corners, food stops, and cafe pauses, alongside Hanoi old-lane texture.
- `legacy_sections_compact`: Why go: Old Quarter cyclo ride is worth knowing because it gives Hanoi a specific route scene: cafe pauses, local movement, the route between named places, and street corners, alongside Hanoi old-lane texture. | What you'll get: At Old Quarter cyclo ride, you get movement across the city as part of the discovery: cyclo passing Old Quarter storefronts, passenger view, with cafe pauses, local movement, the route between named places, and street corners, alongside Hanoi old-lane texture. | Say it locally: Say Xích lô phố cổ for Old Quarter cyclo ride. The local name is easier to remember once it sits beside cafe pauses, local movement, the route between named places, and street corners, alongside Hanoi old-lane texture. | Worth it if: Worth it if Old Quarter cyclo ride gives your itinerary a clearer image: the route between named places, street corners, food stops, and cafe pauses, alongside Hanoi old-lane texture. | Before you go: Old Quarter cyclo ride works best when the name is tied to the reason for going, not memorized as an abstract label. Picture cyclo passing Old Quarter storefronts, passenger view with cafe pauses, local movement, the route between named places, and street corners, alongside Hanoi old-lane texture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-dinh-cafe
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Cà phê Đinh
- `english_name`: Dinh Cafe
- `place_kind`: cafe
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceDinhCafe
- `legacy_summary`: Cà phê Đinh is the small upstairs egg-coffee stop near Hoàn Kiếm Lake where the entrance, climb, second-floor room, and hot cà phê trứng are part of the ritual.
- `legacy_context`: Đinh Café works when the visit is a compact Hanoi coffee pause with a physical arrival sequence, not just another egg-coffee checklist.
- `legacy_sections_compact`: Find The Upstairs Room First: Cà phê Đinh is about the approach as much as the drink. Find the Đinh Tiên Hoàng entrance, go upstairs, then order. | Old Quarter, Lake Edge: The room is tight, older, and close to Hoàn Kiếm Lake, with a small coffee counter and little cups. It is not polished, and that is part of the point. | Useful Phrases:  | Still Worth The Climb: The climb into a small second-floor room over Đinh Tiên Hoàng can make the cup feel connected to old Hanoi rather than just another coffee stop. | Keep It Short Near Hoàn Kiếm: The café works as a short pause before or after a lake walk. If the room is full, nearby coffee stops can keep the day moving.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hanoi-place-dong-da
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Đống Đa
- `english_name`: Dong Da
- `place_kind`: neighborhood
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceDongDa
- `legacy_summary`: Dong Da is worth recognizing because neighborhoods turn Hanoi from landmarks into lived-in areas. Expect Hanoi urban district street in Dong Da with local shops.
- `legacy_context`: For Dong Da, Hanoi's neighborhood story comes through lanes, small shops, hotel edges, and evening walks, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: Dong Da is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: lanes, small shops, hotel edges, and evening walks, alongside old-lane Hanoi. | What you'll get: At Dong Da, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: Hanoi urban district street in Dong Da with local shops, with hotel edges, evening walks, neighborhood identity, and cafes, alongside old-lane Hanoi. | Say it locally: Say Đống Đa for Dong Da. The local name is easier to remember once it sits beside small shops, hotel edges, evening walks, and neighborhood identity, alongside old-lane Hanoi. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: small shops, hotel edges, evening walks, and neighborhood identity, alongside old-lane Hanoi. | Before you go: Dong Da works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi urban district street in Dong Da with local shops with cafes, lanes, small shops, and hotel edges, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hanoi-place-dong-xuan
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chợ Đồng Xuân
- `english_name`: Dong Xuan Market
- `place_kind`: market
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceDongXuanMarket
- `legacy_summary`: Dong Xuan Market is worth browsing because it shows Hanoi through stalls, snacks, goods, color, and everyday buying rhythm. Expect Dong Xuan Market facade with stalls and scooters, daytime.
- `legacy_context`: For Dong Xuan Market, Hanoi's market story comes through snack counters, bargaining rhythm, bags, and local shopping movement, alongside Hanoi's market-side street life.
- `legacy_sections_compact`: Why go: Dong Xuan Market is worth browsing because it shows everyday Hanoi: market aisles, produce colors, snack counters, and bargaining rhythm, alongside Hanoi's market-side street life. | What you'll get: At Dong Xuan Market, you get everyday shopping, snacks, gifts, bargaining, and local rhythm: Dong Xuan Market facade with stalls and scooters, daytime, with snack counters, bargaining rhythm, bags, and local shopping movement, alongside Hanoi's market-side street life. | Say it locally: Say Chợ Đồng Xuân for Dong Xuan Market. The local name is easier to remember once it sits beside produce colors, snack counters, bargaining rhythm, and bags, alongside Hanoi's market-side street life. | Worth it if: Worth it if you like seeing daily life through browsing, snacks, color, small goods, and local rhythm: local shopping movement, market aisles, produce colors, and snack counters, alongside Hanoi's market-side street life. | Before you go: Dong Xuan Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Dong Xuan Market facade with stalls and scooters, daytime with bargaining rhythm, bags, local shopping movement, and market aisles, alongside Hanoi's market-side street life.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hanoi-place-egg-coffee
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Cà phê trứng ở Hà Nội
- `english_name`: Egg coffee
- `place_kind`: drink
- `source_notes`: Vietnam Travel Hanoi; Cafe Giang official site
- `target_hero_image`: HeroCityHanoiPlaceEggCoffee
- `legacy_summary`: Egg coffee is Hanoi's creamy cafe treat: strong coffee under a thick whipped egg foam, usually served slowly in an old-school room or upstairs cafe.
- `legacy_context`: Egg coffee matters because it makes Hanoi cafe culture feel distinct from a normal caffeine stop: richer, slower, and tied to old-quarter coffee rooms.
- `legacy_sections_compact`: Why go: Egg coffee is worth knowing because it is one of Hanoi's most distinctive cafe rituals: strong coffee softened by a thick, sweet egg cream. | What you'll get: Expect a small cup, a rich foam cap, bitter coffee underneath, and a slower cafe mood. It is more dessert-like than an everyday iced coffee. | Say it locally: Say Cà phê trứng for egg coffee. Cà phê means coffee, and trứng means egg, so the phrase is literal once you hear the pieces. | Worth it if: Worth it if you want a sweet cafe stop that feels specific to Hanoi, especially between old-quarter walks or after a heavy meal. | Before you go: Before you go, expect richness. One cup is usually enough, and the room can be as memorable as the drink.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hanoi-place-ethnology-museum
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bảo tàng Dân tộc học
- `english_name`: Vietnam Museum of Ethnology
- `place_kind`: museum
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceEthnologyMuseum
- `legacy_summary`: The Vietnam Museum of Ethnology opens Hanoi into a wider Vietnam: textiles, tools, ritual objects, stilt houses, and outdoor architecture from communities across the country.
- `legacy_context`: For Vietnam Museum of Ethnology, Hanoi's cultural stop story comes through artifacts, quiet light, memory, and local history, alongside Hanoi's quieter gallery-and-stage rhythm.
- `legacy_sections_compact`: Why go: This is a culture stop where Vietnam becomes more than one city or one postcard: galleries, craft objects, village-house forms, and the many ethnic traditions behind the country as a whole. | What you'll get: The museum matters because it helps a visitor understand Vietnam as many cultures, materials, homes, rituals, and landscapes, not just the places on a route. | Say it locally: Hear Bảo tàng Dân tộc học with the wider Vietnam story in mind: textiles, tools, stilt-house forms, ritual objects, and courtyard paths. | Worth it if: Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: quiet light, memory, local history, and display cases, alongside Hanoi's quieter gallery-and-stage rhythm. | Before you go: Vietnam Museum of Ethnology works best when the name is tied to the reason for going, not memorized as an abstract label. Picture museum courtyard with traditional stilt-house architecture with gallery rooms, artifacts, quiet light, and memory, alongside Hanoi's quieter gallery-and-stage rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hanoi-place-french-quarter
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Khu phố Pháp
- `english_name`: French Quarter
- `place_kind`: neighborhood
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceFrenchQuarter
- `legacy_summary`: French Quarter is worth recognizing because neighborhoods turn Hanoi from landmarks into lived-in areas. Expect wide French Quarter boulevard with colonial facades and scooters.
- `legacy_context`: For French Quarter, Hanoi's neighborhood story comes through evening walks, neighborhood identity, cafes, and lanes, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: French Quarter is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: evening walks, neighborhood identity, cafes, and lanes, alongside old-lane Hanoi. | What you'll get: At French Quarter, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: wide French Quarter boulevard with colonial facades and scooters, with small shops, hotel edges, evening walks, and neighborhood identity, alongside old-lane Hanoi. | Say it locally: Say Khu phố Pháp for French Quarter. The local name is easier to remember once it sits beside lanes, small shops, hotel edges, and evening walks, alongside old-lane Hanoi. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: neighborhood identity, cafes, lanes, and small shops, alongside old-lane Hanoi. | Before you go: French Quarter works best when the name is tied to the reason for going, not memorized as an abstract label. Picture wide French Quarter boulevard with colonial facades and scooters with neighborhood identity, cafes, lanes, and small shops, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

