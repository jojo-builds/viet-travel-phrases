You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_036` in the final handoff block. Put `SpeakLocal v2.2 BATCH_036 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hanoi-place-literature-museum
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bảo tàng Văn học Việt Nam
- `english_name`: Vietnam Literature Museum
- `place_kind`: museum
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceLiteratureMuseum
- `legacy_summary`: Vietnam Literature Museum gives Hanoi a quieter cultural stop: Vietnamese writing, authors, books, memory, and gallery rooms that connect the capital to its literary life.
- `legacy_context`: Vietnam Literature Museum brings Hanoi's literary side into focus through books, author rooms, Vietnamese text, and quiet cultural memory.
- `legacy_sections_compact`: Why go: This is Hanoi through words and memory, where literature becomes a travel texture beside lakes, old streets, bookstores, and cafe tables. | What you'll get: The museum matters because Hanoi is not only food streets and lakes, it is also a literary capital with writers, memory, publishing, and study woven into the city. | Say it locally: Hear Bảo tàng Văn học Việt Nam with Hanoi's literary side in mind: books, writers, quiet rooms, and the capital's reading culture. | Worth it if: worth it if you want quiet cultural discovery: books, author rooms, Vietnamese text, gallery pauses, and the literary side of Hanoi. | Before you go: Bảo tàng Văn học Việt Nam belongs beside books, author portraits, quiet rooms, and Hanoi's reading culture. Picture museum facade with Vietnamese signs, book-themed gallery rooms.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-long-bien-bridge
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Cầu Long Biên
- `english_name`: Long Bien Bridge
- `place_kind`: landmark
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceLongBienBridge
- `legacy_summary`: Long Bien Bridge is worth knowing in Hanoi because it brings architecture, views, local pride, and history in visual form into the trip. Expect steel truss Long Bien Bridge over Red River, motorbikes, soft haze.
- `legacy_context`: For Long Bien Bridge, Hanoi's landmark story comes through local pride, history, city light, and landmark memory, alongside Hanoi's market-side street life.
- `legacy_sections_compact`: Why go: Long Bien Bridge is worth knowing because it gives Hanoi a specific landmark scene: city light, landmark memory, architecture, and views, alongside Hanoi's market-side street life. | What you'll get: At Long Bien Bridge, you get architecture, views, local pride, and history in visual form: steel truss Long Bien Bridge over Red River, motorbikes, soft haze, with architecture, views, local pride, and history, alongside Hanoi's market-side street life. | Say it locally: Say Cầu Long Biên for Long Bien Bridge. The local name is easier to remember once it sits beside views, local pride, history, and city light, alongside Hanoi's market-side street life. | Worth it if: Worth it if Long Bien Bridge gives your itinerary a clearer image: views, local pride, history, and city light, alongside Hanoi's market-side street life. | Before you go: Long Bien Bridge works best when the name is tied to the reason for going, not memorized as an abstract label. Picture steel truss Long Bien Bridge over Red River, motorbikes, soft haze with history, city light, landmark memory, and architecture, alongside Hanoi's market-side street life.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-long-bien-market
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chợ Long Biên
- `english_name`: Long Bien Market
- `place_kind`: market
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceLongBienMarket
- `legacy_summary`: Long Bien Market is worth browsing because it shows Hanoi through stalls, snacks, goods, color, and everyday buying rhythm. Expect wholesale fruit market near Long Bien Bridge, crates, early-morning light.
- `legacy_context`: For Long Bien Market, Hanoi's market story comes through bargaining rhythm, bags, local shopping movement, and market aisles, alongside Hanoi's market-side street life.
- `legacy_sections_compact`: Why go: Long Bien Market is worth browsing because it shows everyday Hanoi: produce colors, snack counters, bargaining rhythm, and bags, alongside Hanoi's market-side street life. | What you'll get: At Long Bien Market, you get everyday shopping, snacks, gifts, bargaining, and local rhythm: wholesale fruit market near Long Bien Bridge, crates, early-morning light, with local shopping movement, market aisles, produce colors, and snack counters, alongside Hanoi's market-side street life. | Say it locally: Say Chợ Long Biên for Long Bien Market. The local name is easier to remember once it sits beside market aisles, produce colors, snack counters, and bargaining rhythm, alongside Hanoi's market-side street life. | Worth it if: Worth it if you like seeing daily life through browsing, snacks, color, small goods, and local rhythm: bags, local shopping movement, market aisles, and produce colors, alongside Hanoi's market-side street life. | Before you go: Long Bien Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture wholesale fruit market near Long Bien Bridge, crates, early-morning light with snack counters, bargaining rhythm, bags, and local shopping movement, alongside Hanoi's market-side street life.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-manzi-art-space
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Manzi
- `english_name`: Manzi Art Space
- `place_kind`: attraction
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceManziArtSpace
- `legacy_summary`: Manzi Art Space is worth knowing in Hanoi because it brings the contemporary creative side of the city shown through art, rooms, and cafe pauses into the trip. Expect intimate Hanoi art gallery cafe, framed works, warm interior.
- `legacy_context`: For Manzi Art Space, Hanoi's gallery stop story comes through creative neighborhood texture, framed works, quiet rooms, and cafe tables, alongside Hanoi's food-and-cafe rhythm.
- `legacy_sections_compact`: Why go: Manzi Art Space is worth knowing because it gives Hanoi a specific gallery stop scene: quiet rooms, cafe tables, local artists, and soft light, alongside Hanoi's food-and-cafe rhythm. | What you'll get: At Manzi Art Space, you get the contemporary creative side of the city shown through art, rooms, and cafe pauses: intimate Hanoi art gallery cafe, framed works, warm interior, with creative neighborhood texture, framed works, quiet rooms, and cafe tables, alongside Hanoi's food-and-cafe rhythm. | Say it locally: Say Manzi for Manzi Art Space. The local name is easier to remember once it sits beside framed works, quiet rooms, cafe tables, and local artists, alongside Hanoi's food-and-cafe rhythm. | Worth it if: Worth it if Manzi Art Space gives your itinerary a clearer image: framed works, quiet rooms, cafe tables, and local artists, alongside Hanoi's food-and-cafe rhythm. | Before you go: Manzi Art Space works best when the name is tied to the reason for going, not memorized as an abstract label. Picture intimate Hanoi art gallery cafe, framed works, warm interior with framed works, quiet rooms, cafe tables, and local artists, alongside Hanoi's food-and-cafe rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-mien-luon
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Miến lươn ở Hà Nội
- `english_name`: Eel glass noodles
- `place_kind`: dish
- `source_notes`: MICHELIN Vietnam 2025
- `target_hero_image`: HeroCityHanoiPlaceMienLuon
- `legacy_summary`: Eel glass noodles is worth trying in Hanoi because it gives the trip a flavor to imagine before arrival. Expect bowl of eel glass noodles with herbs and crispy eel.
- `legacy_context`: For Eel glass noodles, Hanoi's food story comes through steam, texture, small meal rituals, and flavor, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: Eel glass noodles is worth trying because it turns Hanoi into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with steam, texture, small meal rituals, and flavor, alongside old-lane Hanoi. | What you'll get: At Eel glass noodles, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: bowl of eel glass noodles with herbs and crispy eel, with small meal rituals, flavor, herbs, and sauce, alongside old-lane Hanoi. | Say it locally: Say Miến lươn ở Hà Nội for Eel glass noodles. The local name is easier to remember once it sits beside sauce, steam, texture, and small meal rituals, alongside old-lane Hanoi. | Worth it if: Worth it if you want a food memory rather than only a label: flavor, herbs, sauce, and steam, alongside old-lane Hanoi. | Before you go: Eel glass noodles works best when the name is tied to the reason for going, not memorized as an abstract label. Picture bowl of eel glass noodles with herbs and crispy eel with sauce, steam, texture, and small meal rituals, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hanoi-place-mien-luon-chan-cam
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Miến lươn Chân Cầm
- `english_name`: Mien Luon Chan Cam
- `place_kind`: restaurant
- `source_notes`: MICHELIN Vietnam 2025
- `target_hero_image`: HeroCityHanoiPlaceMienLuonChanCam
- `legacy_summary`: Mien Luon Chan Cam is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect bowl of eel vermicelli soup with herbs in Hanoi noodle shop.
- `legacy_context`: For Mien Luon Chan Cam, Hanoi's restaurant story comes through menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Mien Luon Chan Cam is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Mien Luon Chan Cam, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: bowl of eel vermicelli soup with herbs in Hanoi noodle shop, with menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi's steam-and-herb food streets. | Say it locally: Say Miến lươn Chân Cầm for Mien Luon Chan Cam. The local name is easier to remember once it sits beside staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if the meal itself should be one of the day's memories: house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's steam-and-herb food streets. | Before you go: Mien Luon Chan Cam works best when the name is tied to the reason for going, not memorized as an abstract label. Picture bowl of eel vermicelli soup with herbs in Hanoi noodle shop with house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hanoi-place-my-dinh-bus-station
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bến xe Mỹ Đình
- `english_name`: My Dinh Bus Station
- `place_kind`: station
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceMyDinhBusStation
- `legacy_summary`: My Dinh Bus Station is Hanoi's western onward-road hub, where bags, route signs, waiting benches, and city-edge streets point toward the next part of northern Vietnam.
- `legacy_context`: For My Dinh Bus Station, Hanoi's station story comes through city light, local signs, onward roads, and station doors, alongside the arrival edge of the capital.
- `legacy_sections_compact`: Why go: This is a different arrival edge from the railway station: wider roads, bus routes, local signs, and the feeling of Hanoi stretching toward the suburbs and beyond. | What you'll get: My Dinh matters because it shows Hanoi as a travel hub, not only an old quarter: buses, signs, onward roads, and the wider north all connect here. | Say it locally: Say Bến xe Mỹ Đình for My Dinh Bus Station. The local name is easier to remember once it sits beside local signs, onward roads, station doors, and route boards, alongside the arrival edge of the capital. | Worth it if: Worth it if My Dinh Bus Station gives your itinerary a clearer image: waiting benches, city light, local signs, and onward roads, alongside the arrival edge of the capital. | Before you go: My Dinh Bus Station works best when the name is tied to the reason for going, not memorized as an abstract label. Picture station facade, route boards, waiting benches, and local streets just outside with waiting benches, city light, local signs, and onward roads, alongside the arrival edge of the capital.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hanoi-place-nang-cafe
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Cà phê Năng
- `english_name`: Nang Cafe
- `place_kind`: cafe
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlaceNangCafe
- `legacy_summary`: Nang Cafe is worth saving for Hanoi's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect small Hanoi phin coffee on wooden table, narrow cafe interior.
- `legacy_context`: For Nang Cafe, Hanoi's cafe story comes through design details, soft pauses, cafe views, and coffee counters, alongside Hanoi coffeehouse culture.
- `legacy_sections_compact`: Why go: Nang Cafe is worth saving when you want Hanoi's cafe culture, not just caffeine: cafe views, coffee counters, iced glasses, and street stools, alongside Hanoi coffeehouse culture. | What you'll get: At Nang Cafe, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: small Hanoi phin coffee on wooden table, narrow cafe interior, with iced glasses, street stools, design details, and soft pauses, alongside Hanoi coffeehouse culture. | Say it locally: Say Cà phê Năng for Nang Cafe. The local name is easier to remember once it sits beside coffee counters, iced glasses, street stools, and design details, alongside Hanoi coffeehouse culture. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: soft pauses, cafe views, coffee counters, and iced glasses, alongside Hanoi coffeehouse culture. | Before you go: Nang Cafe works best when the name is tied to the reason for going, not memorized as an abstract label. Picture small Hanoi phin coffee on wooden table, narrow cafe interior with soft pauses, cafe views, coffee counters, and iced glasses, alongside Hanoi coffeehouse culture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hanoi-place-national-museum-history
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bảo tàng Lịch sử Quốc gia
- `english_name`: Vietnam National Museum of History
- `place_kind`: museum
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceNationalMuseumHistory
- `legacy_summary`: Vietnam National Museum of History is worth a stop if you want Hanoi to feel more layered than the streets outside. Expect ochre museum building with arched windows and palms, Hanoi.
- `legacy_context`: For Vietnam National Museum of History, Hanoi's cultural stop story comes through artifacts, quiet light, memory, and local history, alongside Hanoi's quieter gallery-and-stage rhythm.
- `legacy_sections_compact`: Why go: Vietnam National Museum of History is worth a stop when you want more than scenery: rooms, objects, art, and memory inside the city's story, with memory, local history, display cases, and gallery rooms, alongside Hanoi's quieter gallery-and-stage rhythm. | What you'll get: At Vietnam National Museum of History, you get rooms, objects, art, and memory inside the city's story: ochre museum building with arched windows and palms, Hanoi, with memory, local history, display cases, and gallery rooms, alongside Hanoi's quieter gallery-and-stage rhythm. | Say it locally: Say Bảo tàng Lịch sử Quốc gia for Vietnam National Museum of History. The local name is easier to remember once it sits beside local history, display cases, gallery rooms, and artifacts, alongside Hanoi's quieter gallery-and-stage rhythm. | Worth it if: Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: quiet light, memory, local history, and display cases, alongside Hanoi's quieter gallery-and-stage rhythm. | Before you go: Vietnam National Museum of History works best when the name is tied to the reason for going, not memorized as an abstract label. Picture ochre museum building with arched windows and palms, Hanoi with gallery rooms, artifacts, quiet light, and memory, alongside Hanoi's quieter gallery-and-stage rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hanoi-place-nem-cua-be
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Nem cua bể ở Hà Nội
- `english_name`: Crab spring rolls
- `place_kind`: dish
- `source_notes`: MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlaceNemCuaBe
- `legacy_summary`: Crab spring rolls is worth trying in Hanoi because it gives the trip a flavor to imagine before arrival. Expect square crab spring rolls with herbs and dipping sauce, Hanoi.
- `legacy_context`: For Crab spring rolls, Hanoi's food story comes through steam, texture, small meal rituals, and flavor, alongside Hanoi's food-and-cafe rhythm.
- `legacy_sections_compact`: Why go: Crab spring rolls is worth trying because it turns Hanoi into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with small meal rituals, flavor, herbs, and sauce, alongside Hanoi's food-and-cafe rhythm. | What you'll get: At Crab spring rolls, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: square crab spring rolls with herbs and dipping sauce, Hanoi, with herbs, sauce, steam, and texture, alongside Hanoi's food-and-cafe rhythm. | Say it locally: Say Nem cua bể ở Hà Nội for Crab spring rolls. The local name is easier to remember once it sits beside texture, small meal rituals, flavor, and herbs, alongside Hanoi's food-and-cafe rhythm. | Worth it if: Worth it if you want a food memory rather than only a label: texture, small meal rituals, flavor, and herbs, alongside Hanoi's food-and-cafe rhythm. | Before you go: Crab spring rolls works best when the name is tied to the reason for going, not memorized as an abstract label. Picture square crab spring rolls with herbs and dipping sauce, Hanoi with sauce, steam, texture, and small meal rituals, alongside Hanoi's food-and-cafe rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

