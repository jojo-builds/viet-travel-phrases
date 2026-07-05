You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_039` in the final handoff block. Put `SpeakLocal v2.2 BATCH_039 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need, even 10+ minutes. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Batch 033-037 audit tightening for this 10-listing run:
- Start the final answer with the batch title and then the first listing. Do not add a `Source basis`, `Source grounding`, `Grounding note`, citation, or setup paragraph before the first listing.
- Do not include Markdown links, source chips, citation cards, pasted-text chips, clickable Google Doc/Sheet references, or `utm_source=chatgpt.com` links anywhere in final output, including implementation notes.
- Keep phrase cards to 2-3, and only use ready-audio reusable traveler-action phrases. Place-name audio is pronunciation/name support by default, not a visible phrase card.
- Do not create one-off phrases for a single attraction, restaurant, dish, object, or transportation node. Mark them as hidden/planned instead.
- Do not number visible listing headings. Use the place heading directly, not `1. Place Name`.
- Do not wrap phrase-card Vietnamese in quotation marks unless the phrase itself truly contains a quote.
- Visible copy and implementation notes must not say `useful because`, `reference line`, `destination`, `anchor`, `canonical model`, `content role`, `this page helps`, or `the job is`.
- Keep `check_catalog`, `not_run`, scores, source notes, freshness risks, QA notes, and schema/process terms out of Reader View.
- Vary headings across all ten listings. Do not default to `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`. If two headings in this batch share that scaffold, revise one before final.
- For station, airport, route, and street pages, choose the exact traveler moment first so the copy does not collapse into repeated command headings.
- Write travel copy, not a database note. Short, observed, specific, calm. The first paragraph should sound like a person at the place or table, not a catalog deciding where a page belongs.
- Keep implementation notes compact and import-facing: IDs, phrase/audio status, mention candidates, freshness risks, and handoff block only. Do not turn notes into a schema dump.
- If current venue facts might be stale, keep that risk in internal source/freshness notes instead of visible copy.
- Because this batch has 10 listings, avoid over-explaining. Each listing should be readable for Jojo review without screenshots.
- Before final output, do one display sweep for numbered headings, quote-wrapped phrase cards, process terms in Reader View, and repeated station/route scaffolds.
- If you cannot produce the full batch, output `BLOCKED_STUB` and the blocker instead of a partial response.

# New Chat Prompt for This Project

Pick city listings from the ledger whose status is `not_started` or `voice_rejected_rewrite`. Codex has provided an exact claimed batch list, so use those rows only and do not pick replacements.

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

### 1. city-hanoi-place-street-food-walk
- `ledger_row`: 175
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Đi bộ ăn vặt Hà Nội
- `english_name`: Hanoi street-food walk
- `place_kind`: experience
- `source_notes`: Vietnam Travel Hanoi; MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlaceStreetFoodWalk
- `legacy_summary`: Hanoi street-food walk is worth knowing in Hanoi because it brings food discovery as a route across the city into the trip. Expect small Hanoi street-food table with multiple dishes and walking shoes nearby.
- `legacy_context`: For Hanoi street-food walk, Hanoi's food walk story comes through the route between bites, small tables, steam, and herbs, alongside Hanoi old-lane texture.
- `legacy_sections_compact`: Why go: Hanoi street-food walk is worth knowing because it gives Hanoi a specific food walk scene: steam, herbs, sidewalk seats, and food lanes, alongside Hanoi old-lane texture. | What you'll get: At Hanoi street-food walk, you get food discovery as a route across the city: small Hanoi street-food table with multiple dishes and walking shoes nearby, with steam, herbs, sidewalk seats, and food lanes, alongside Hanoi old-lane texture. | Say it locally: Say Đi bộ ăn vặt Hà Nội for Hanoi street-food walk. The local name is easier to remember once it sits beside food lanes, the route between bites, small tables, and steam, alongside Hanoi old-lane texture. | Worth it if: Worth it if Hanoi street-food walk gives your itinerary a clearer image: herbs, sidewalk seats, food lanes, and the route between bites, alongside Hanoi old-lane texture. | Before you go: Hanoi street-food walk works best when the name is tied to the reason for going, not memorized as an abstract label. Picture small Hanoi street-food table with multiple dishes and walking shoes nearby with food lanes, the route between bites, small tables, and steam, alongside Hanoi old-lane texture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-ta-hien
- `ledger_row`: 176
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phố Tạ Hiện
- `english_name`: Ta Hien Street
- `place_kind`: street
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceTaHienStreet
- `legacy_summary`: Ta Hien Street is worth knowing in Hanoi because it brings the city shifting into evening social life into the trip. Expect busy Ta Hien evening street with small stools and warm signs.
- `legacy_context`: For Ta Hien Street, Hanoi's evening street story comes through evening crowds, small stools, warm signs, and food smoke, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: Ta Hien Street is worth knowing because it gives Hanoi a specific evening street scene: old lanes, music, evening crowds, and small stools, alongside old-lane Hanoi. | What you'll get: At Ta Hien Street, you get the city shifting into evening social life: busy Ta Hien evening street with small stools and warm signs, with warm signs, food smoke, old lanes, and music, alongside old-lane Hanoi. | Say it locally: Say Phố Tạ Hiện for Ta Hien Street. The local name is easier to remember once it sits beside music, evening crowds, small stools, and warm signs, alongside old-lane Hanoi. | Worth it if: Worth it if Ta Hien Street gives your itinerary a clearer image: food smoke, old lanes, music, and evening crowds, alongside old-lane Hanoi. | Before you go: Ta Hien Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture busy Ta Hien evening street with small stools and warm signs with small stools, warm signs, food smoke, and old lanes, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-tam-vi
- `ledger_row`: 177
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Tầm Vị
- `english_name`: Tam Vi
- `place_kind`: restaurant
- `source_notes`: MICHELIN Vietnam 2025
- `target_hero_image`: HeroCityHanoiPlaceTamVi
- `legacy_summary`: Tam Vi is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect traditional Hanoi dining room with northern Vietnamese dishes, warm wood.
- `legacy_context`: For Tam Vi, Hanoi's restaurant story comes through staff rhythm, drinks, evening meal energy, and tables, alongside old-quarter noodle tables.
- `legacy_sections_compact`: Why go: Tam Vi is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with evening meal energy, tables, house dishes, and menu details, alongside old-quarter noodle tables. | What you'll get: At Tam Vi, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: traditional Hanoi dining room with northern Vietnamese dishes, warm wood, with evening meal energy, tables, house dishes, and menu details, alongside old-quarter noodle tables. | Say it locally: Say Tầm Vị for Tam Vi. The local name is easier to remember once it sits beside drinks, evening meal energy, tables, and house dishes, alongside old-quarter noodle tables. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside old-quarter noodle tables. | Before you go: Tam Vi works best when the name is tied to the reason for going, not memorized as an abstract label. Picture traditional Hanoi dining room with northern Vietnamese dishes, warm wood with tables, house dishes, menu details, and staff rhythm, alongside old-quarter noodle tables.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-tay-ho
- `ledger_row`: 178
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Tây Hồ
- `english_name`: Tay Ho
- `place_kind`: neighborhood
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceTayHo
- `legacy_summary`: Tay Ho is worth recognizing because neighborhoods turn Hanoi from landmarks into lived-in areas. Expect West Lake cafe street in Tay Ho with scooters and lake glimpse.
- `legacy_context`: For Tay Ho, Hanoi's neighborhood story comes through neighborhood identity, cafes, lanes, and small shops, alongside Hoan Kiem and West Lake calm.
- `legacy_sections_compact`: Why go: Tay Ho is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: lanes, small shops, hotel edges, and evening walks, alongside Hoan Kiem and West Lake calm. | What you'll get: At Tay Ho, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: West Lake cafe street in Tay Ho with scooters and lake glimpse, with hotel edges, evening walks, neighborhood identity, and cafes, alongside Hoan Kiem and West Lake calm. | Say it locally: Say Tây Hồ for Tay Ho. The local name is easier to remember once it sits beside cafes, lanes, small shops, and hotel edges, alongside Hoan Kiem and West Lake calm. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: cafes, lanes, small shops, and hotel edges, alongside Hoan Kiem and West Lake calm. | Before you go: Tay Ho works best when the name is tied to the reason for going, not memorized as an abstract label. Picture West Lake cafe street in Tay Ho with scooters and lake glimpse with small shops, hotel edges, evening walks, and neighborhood identity, alongside Hoan Kiem and West Lake calm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-temple-literature
- `ledger_row`: 179
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Văn Miếu
- `english_name`: Temple of Literature
- `place_kind`: landmark
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceTempleLiterature
- `legacy_summary`: Temple of Literature is worth approaching slowly because worship, architecture, incense, and local memory shape the visit. Expect courtyard of Temple of Literature, stone steles, red wooden architecture.
- `legacy_context`: For Temple of Literature, Hanoi's sacred place story comes through incense, courtyards, tiled roofs, and temple gates, alongside the capital's old civic rhythm.
- `legacy_sections_compact`: Why go: Temple of Literature is worth approaching slowly because worship, architecture, incense, and local memory all shape the visit: incense, courtyards, tiled roofs, and temple gates, alongside the capital's old civic rhythm. | What you'll get: At Temple of Literature, you get worship, architecture, local memory, and the quieter rhythm of a spiritual stop: courtyard of Temple of Literature, stone steles, red wooden architecture, with tiled roofs, temple gates, shade, and respectful pauses, alongside the capital's old civic rhythm. | Say it locally: Say Văn Miếu for Temple of Literature. The local name is easier to remember once it sits beside courtyards, tiled roofs, temple gates, and shade, alongside the capital's old civic rhythm. | Worth it if: Worth it if temples, incense, worship, and quiet architecture help the place feel deeper: respectful pauses, incense, courtyards, and tiled roofs, alongside the capital's old civic rhythm. | Before you go: Temple of Literature works best when the name is tied to the reason for going, not memorized as an abstract label. Picture courtyard of Temple of Literature, stone steles, red wooden architecture with courtyards, tiled roofs, temple gates, and shade, alongside the capital's old civic rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hanoi-place-the-note-coffee
- `ledger_row`: 180
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: The Note Coffee
- `english_name`: The Note Coffee
- `place_kind`: cafe
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlaceTheNoteCoffee
- `legacy_summary`: The Note Coffee is best as a short Hanoi ritual near Hoàn Kiếm: order egg coffee or coconut latte, climb to a seat, read a few handwritten notes, and leave one.
- `legacy_context`: The café works when the visit is framed as a memory stop, not a quiet coffee session or undiscovered local room.
- `legacy_sections_compact`: Order, Climb, Leave A Note: The Note Coffee is touristy, but the ritual is simple enough to enjoy. Order a drink, climb to a seat, read a few messages, then leave one of your own. | Four Floors Of Handwriting: Walls, tables, stairs, and ceilings are layered with notes in different languages. It can feel crowded and overstimulating, so the memory matters more than a silent coffee session. | Useful Phrases:  | A Hoàn Kiếm Pause: The café works as a short stop before or after walking around Hoàn Kiếm Lake. One drink and one note are enough before the Old Quarter pulls you back outside. | Go For The Memory: Crowds and narrow stairs are part of the tradeoff. The stop is still worth it when you want a small, readable Hanoi coffee memory rather than a serious café session.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hanoi-place-thong-nhat-park
- `ledger_row`: 181
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Công viên Thống Nhất
- `english_name`: Thong Nhat Park
- `place_kind`: park
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceThongNhatPark
- `legacy_summary`: Thong Nhat Park is worth knowing in Hanoi because it brings everyday city life in open air without a formal attraction into the trip. Expect Hanoi park path around lake with morning walkers.
- `legacy_context`: For Thong Nhat Park, Hanoi's park story comes through walking paths, trees, family time, and shade, alongside the capital's open-air pauses.
- `legacy_sections_compact`: Why go: Thong Nhat Park is worth knowing because it gives Hanoi a specific park scene: family time, shade, open lawns, and evening light, alongside the capital's open-air pauses. | What you'll get: At Thong Nhat Park, you get everyday city life in open air without a formal attraction: Hanoi park path around lake with morning walkers, with family time, shade, open lawns, and evening light, alongside the capital's open-air pauses. | Say it locally: Say Công viên Thống Nhất for Thong Nhat Park. The local name is easier to remember once it sits beside trees, family time, shade, and open lawns, alongside the capital's open-air pauses. | Worth it if: Worth it if Thong Nhat Park gives your itinerary a clearer image: evening light, walking paths, trees, and family time, alongside the capital's open-air pauses. | Before you go: Thong Nhat Park works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi park path around lake with morning walkers with shade, open lawns, evening light, and walking paths, alongside the capital's open-air pauses.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hanoi-place-train-street
- `ledger_row`: 182
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phố đường tàu Hà Nội
- `english_name`: Hanoi Train Street
- `place_kind`: street
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceTrainStreet
- `legacy_summary`: Hanoi Train Street is worth recognizing because a named street can make Hanoi feel walkable before arrival. Expect narrow Hanoi railway street with cafes set back safely.
- `legacy_context`: For Hanoi Train Street, Hanoi's street story comes through shopfronts, scooters, crossings, and cafe edges, alongside Hanoi old-lane texture.
- `legacy_sections_compact`: Why go: Hanoi Train Street is worth recognizing because streets shape how Hanoi feels on the ground: shopfronts, scooters, crossings, and cafe edges, alongside Hanoi old-lane texture. | What you'll get: At Hanoi Train Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: narrow Hanoi railway street with cafes set back safely, with crossings, cafe edges, neighborhood movement, and street signs, alongside Hanoi old-lane texture. | Say it locally: Say Phố đường tàu Hà Nội for Hanoi Train Street. The local name is easier to remember once it sits beside street signs, shopfronts, scooters, and crossings, alongside Hanoi old-lane texture. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: street signs, shopfronts, scooters, and crossings, alongside Hanoi old-lane texture. | Before you go: Hanoi Train Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture narrow Hanoi railway street with cafes set back safely with scooters, crossings, cafe edges, and neighborhood movement, alongside Hanoi old-lane texture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hanoi-place-tran-quoc-pagoda
- `ledger_row`: 183
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chùa Trấn Quốc
- `english_name`: Tran Quoc Pagoda
- `place_kind`: landmark
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceTranQuocPagoda
- `legacy_summary`: Tran Quoc Pagoda is worth approaching slowly because worship, architecture, incense, and local memory shape the visit. Expect red pagoda tower by West Lake, calm water, golden-hour.
- `legacy_context`: For Tran Quoc Pagoda, Hanoi's sacred place story comes through tiled roofs, temple gates, shade, and respectful pauses, alongside Hoan Kiem and West Lake calm.
- `legacy_sections_compact`: Why go: Tran Quoc Pagoda is worth approaching slowly because worship, architecture, incense, and local memory all shape the visit: tiled roofs, temple gates, shade, and respectful pauses, alongside Hoan Kiem and West Lake calm. | What you'll get: At Tran Quoc Pagoda, you get worship, architecture, local memory, and the quieter rhythm of a spiritual stop: red pagoda tower by West Lake, calm water, golden-hour, with shade, respectful pauses, incense, and courtyards, alongside Hoan Kiem and West Lake calm. | Say it locally: Say Chùa Trấn Quốc for Tran Quoc Pagoda. The local name is easier to remember once it sits beside temple gates, shade, respectful pauses, and incense, alongside Hoan Kiem and West Lake calm. | Worth it if: Worth it if temples, incense, worship, and quiet architecture help the place feel deeper: temple gates, shade, respectful pauses, and incense, alongside Hoan Kiem and West Lake calm. | Before you go: Tran Quoc Pagoda works best when the name is tied to the reason for going, not memorized as an abstract label. Picture red pagoda tower by West Lake, calm water, golden-hour with respectful pauses, incense, courtyards, and tiled roofs, alongside Hoan Kiem and West Lake calm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hanoi-place-trang-tien-plaza
- `ledger_row`: 184
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Tràng Tiền Plaza
- `english_name`: Trang Tien Plaza
- `place_kind`: market
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceTrangTienPlaza
- `legacy_summary`: Trang Tien Plaza is worth knowing in Hanoi because it brings modern shopping and a polished indoor break from heat, rain, or street movement into the trip. Expect Trang Tien Plaza corner facade, scooters, elegant colonial-style building.
- `legacy_context`: For Trang Tien Plaza, Hanoi's shopping stop story comes through cool air, easy meetups, storefronts, and indoor food counters, alongside Hanoi's market-side street life.
- `legacy_sections_compact`: Why go: Trang Tien Plaza is worth knowing because it gives Hanoi a specific shopping stop scene: cool air, easy meetups, storefronts, and indoor food counters, alongside Hanoi's market-side street life. | What you'll get: At Trang Tien Plaza, you get modern shopping and a polished indoor break from heat, rain, or street movement: Trang Tien Plaza corner facade, scooters, elegant colonial-style building, with easy meetups, storefronts, indoor food counters, and city-center corners, alongside Hanoi's market-side street life. | Say it locally: Say Tràng Tiền Plaza for Trang Tien Plaza. The local name is easier to remember once it sits beside storefronts, indoor food counters, city-center corners, and cool air, alongside Hanoi's market-side street life. | Worth it if: Worth it if Trang Tien Plaza gives your itinerary a clearer image: city-center corners, cool air, easy meetups, and storefronts, alongside Hanoi's market-side street life. | Before you go: Trang Tien Plaza works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Trang Tien Plaza corner facade, scooters, elegant colonial-style building with cool air, easy meetups, storefronts, and indoor food counters, alongside Hanoi's market-side street life.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
