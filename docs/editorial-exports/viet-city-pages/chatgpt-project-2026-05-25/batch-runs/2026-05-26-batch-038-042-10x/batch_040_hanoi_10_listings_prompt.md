You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_040` in the final handoff block. Put `SpeakLocal v2.2 BATCH_040 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hanoi-place-trang-tien-street
- `ledger_row`: 185
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phố Tràng Tiền
- `english_name`: Trang Tien Street
- `place_kind`: street
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceTrangTienStreet
- `legacy_summary`: Trang Tien Street is worth recognizing because a named street can make Hanoi feel walkable before arrival. Expect Trang Tien Street with bookshops, trees, and scooters.
- `legacy_context`: For Trang Tien Street, Hanoi's street story comes through scooters, crossings, cafe edges, and neighborhood movement, alongside Hanoi old-lane texture.
- `legacy_sections_compact`: Why go: Trang Tien Street is worth recognizing because streets shape how Hanoi feels on the ground: scooters, crossings, cafe edges, and neighborhood movement, alongside Hanoi old-lane texture. | What you'll get: At Trang Tien Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: Trang Tien Street with bookshops, trees, and scooters, with cafe edges, neighborhood movement, street signs, and shopfronts, alongside Hanoi old-lane texture. | Say it locally: Say Phố Tràng Tiền for Trang Tien Street. The local name is easier to remember once it sits beside crossings, cafe edges, neighborhood movement, and street signs, alongside Hanoi old-lane texture. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: shopfronts, scooters, crossings, and cafe edges, alongside Hanoi old-lane texture. | Before you go: Trang Tien Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Trang Tien Street with bookshops, trees, and scooters with crossings, cafe edges, neighborhood movement, and street signs, alongside Hanoi old-lane texture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-trieu-viet-vuong-coffee-street
- `ledger_row`: 186
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phố cà phê Triệu Việt Vương
- `english_name`: Trieu Viet Vuong Coffee Street
- `place_kind`: street
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceTrieuVietVuongCoffeeStreet
- `legacy_summary`: Trieu Viet Vuong Coffee Street is worth recognizing because a named street can make Hanoi feel walkable before arrival. Expect Hanoi coffee street with many cafe signs and scooters under trees.
- `legacy_context`: For Trieu Viet Vuong Coffee Street, Hanoi's street story comes through cafe edges, neighborhood movement, street signs, and shopfronts, alongside Hanoi coffeehouse culture.
- `legacy_sections_compact`: Why go: Trieu Viet Vuong Coffee Street is worth recognizing because streets shape how Hanoi feels on the ground: scooters, crossings, cafe edges, and neighborhood movement, alongside Hanoi coffeehouse culture. | What you'll get: At Trieu Viet Vuong Coffee Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: Hanoi coffee street with many cafe signs and scooters under trees, with cafe edges, neighborhood movement, street signs, and shopfronts, alongside Hanoi coffeehouse culture. | Say it locally: Say Phố cà phê Triệu Việt Vương for Trieu Viet Vuong Coffee Street. The local name is easier to remember once it sits beside crossings, cafe edges, neighborhood movement, and street signs, alongside Hanoi coffeehouse culture. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: shopfronts, scooters, crossings, and cafe edges, alongside Hanoi coffeehouse culture. | Before you go: Trieu Viet Vuong Coffee Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi coffee street with many cafe signs and scooters under trees with shopfronts, scooters, crossings, and cafe edges, alongside Hanoi coffeehouse culture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-truc-bach-lake
- `ledger_row`: 187
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Hồ Trúc Bạch
- `english_name`: Truc Bach Lake
- `place_kind`: nature
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceTrucBachLake
- `legacy_summary`: Truc Bach Lake is worth knowing in Hanoi because it brings the city turning walkable around water instead of only traffic and streets into the trip. Expect Truc Bach Lake with lakeside cafes and calm water.
- `legacy_context`: For Truc Bach Lake, Hanoi's lake story comes through bridges, neighborhood views, water, and walking paths, alongside the capital's old civic rhythm.
- `legacy_sections_compact`: Why go: Truc Bach Lake is worth knowing because it gives Hanoi a specific lake scene: bridges, neighborhood views, water, and walking paths, alongside the capital's old civic rhythm. | What you'll get: At Truc Bach Lake, you get the city turning walkable around water instead of only traffic and streets: Truc Bach Lake with lakeside cafes and calm water, with cafe edges, shade, bridges, and neighborhood views, alongside the capital's old civic rhythm. | Say it locally: Say Hồ Trúc Bạch for Truc Bach Lake. The local name is easier to remember once it sits beside neighborhood views, water, walking paths, and cafe edges, alongside the capital's old civic rhythm. | Worth it if: Worth it if Truc Bach Lake gives your itinerary a clearer image: shade, bridges, neighborhood views, and water, alongside the capital's old civic rhythm. | Before you go: Truc Bach Lake works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Truc Bach Lake with lakeside cafes and calm water with neighborhood views, water, walking paths, and cafe edges, alongside the capital's old civic rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-turtle-tower
- `ledger_row`: 188
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Tháp Rùa
- `english_name`: Turtle Tower
- `place_kind`: landmark
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceTurtleTower
- `legacy_summary`: Turtle Tower is the quiet landmark at the center of Hoan Kiem Lake, giving Hanoi a small, iconic silhouette of water, legend, reflection, and old-city calm.
- `legacy_context`: Turtle Tower brings Hanoi's lake-and-legend story into focus through Hoan Kiem water, reflections, trees, and old-city calm.
- `legacy_sections_compact`: Why go: This is Hanoi's lake memory in one image: Turtle Tower sitting apart on the water while trees, walkers, and Old Quarter streets gather around the lake edge. | What you'll get: Turtle Tower matters because it gives Hoan Kiem Lake its most recognizable symbol, tying Hanoi's old center to legend, water, and public memory. | Say it locally: Hear Tháp Rùa with Hoan Kiem Lake in mind: water reflections, trees, legend, and the old center of Hanoi. | Worth it if: worth it if you want Hoan Kiem Lake orientation: water reflections, walking paths, trees, Old Quarter edges, and the tower in the middle of the view. | Before you go: Tháp Rùa belongs beside Hoan Kiem water, lake trees, reflections, and Hanoi's old-city calm. Picture Turtle Tower on Hoan Kiem Lake at sunset, water reflections.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-udam
- `ledger_row`: 189
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Ưu Đàm
- `english_name`: Uu Dam
- `place_kind`: restaurant
- `source_notes`: MICHELIN Vietnam 2025
- `target_hero_image`: HeroCityHanoiPlaceUdam
- `legacy_summary`: Uu Dam is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect serene vegetarian Vietnamese restaurant table with herbs and clay bowls.
- `legacy_context`: For Uu Dam, Hanoi's restaurant story comes through drinks, evening meal energy, tables, and house dishes, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Uu Dam is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with drinks, evening meal energy, tables, and house dishes, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Uu Dam, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: serene vegetarian Vietnamese restaurant table with herbs and clay bowls, with menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi's steam-and-herb food streets. | Say it locally: Say Ưu Đàm for Uu Dam. The local name is easier to remember once it sits beside house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if the meal itself should be one of the day's memories: evening meal energy, tables, house dishes, and menu details, alongside Hanoi's steam-and-herb food streets. | Before you go: Uu Dam works best when the name is tied to the reason for going, not memorized as an abstract label. Picture serene vegetarian Vietnamese restaurant table with herbs and clay bowls with staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hanoi-place-vietnam-art-gallery
- `ledger_row`: 190
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Vietnam Art Gallery
- `english_name`: Vietnam Art Gallery
- `place_kind`: attraction
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceVietnamArtGallery
- `legacy_summary`: Vietnam Art Gallery is worth knowing in Hanoi because it brings the contemporary creative side of the city shown through art, rooms, and cafe pauses into the trip. Expect modern Vietnamese gallery rooms, lacquer paintings, quiet white gallery walls.
- `legacy_context`: For Vietnam Art Gallery, Hanoi's gallery stop story comes through soft light, creative neighborhood texture, framed works, and quiet rooms, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: Vietnam Art Gallery is worth knowing because it gives Hanoi a specific gallery stop scene: framed works, quiet rooms, cafe tables, and local artists, alongside old-lane Hanoi. | What you'll get: At Vietnam Art Gallery, you get the contemporary creative side of the city shown through art, rooms, and cafe pauses: modern Vietnamese gallery rooms, lacquer paintings, quiet white gallery walls, with cafe tables, local artists, soft light, and creative neighborhood texture, alongside old-lane Hanoi. | Say it locally: Vietnam Art Gallery usually stays as the venue name. Say it slowly and connect it to the scene around it: creative neighborhood texture, framed works, quiet rooms, and cafe tables, alongside old-lane Hanoi. | Worth it if: Worth it if Vietnam Art Gallery gives your itinerary a clearer image: creative neighborhood texture, framed works, quiet rooms, and cafe tables, alongside old-lane Hanoi. | Before you go: Vietnam Art Gallery works best when the name is tied to the reason for going, not memorized as an abstract label. Picture modern Vietnamese gallery rooms, lacquer paintings, quiet white gallery walls with local artists, soft light, creative neighborhood texture, and framed works, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hanoi-place-vietnam-circus
- `ledger_row`: 191
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Rạp Xiếc Trung ương
- `english_name`: Vietnam Central Circus
- `place_kind`: experience
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceVietnamCircus
- `legacy_summary`: Vietnam Central Circus is worth knowing in Hanoi because it brings living performance culture rather than a static monument into the trip. Expect Circus building exterior at dusk with Hanoi street activity.
- `legacy_context`: For Vietnam Central Circus, Hanoi's performance venue story comes through music, masks, theatre doors, and evening streets, alongside the cultural stops around old Hanoi.
- `legacy_sections_compact`: Why go: Vietnam Central Circus is worth knowing because it gives Hanoi a specific performance venue scene: cultural memory, stage light, music, and masks, alongside the cultural stops around old Hanoi. | What you'll get: At Vietnam Central Circus, you get living performance culture rather than a static monument: Circus building exterior at dusk with Hanoi street activity, with theatre doors, evening streets, cultural memory, and stage light, alongside the cultural stops around old Hanoi. | Say it locally: Say Rạp Xiếc Trung ương for Vietnam Central Circus. The local name is easier to remember once it sits beside masks, theatre doors, evening streets, and cultural memory, alongside the cultural stops around old Hanoi. | Worth it if: Worth it if Vietnam Central Circus gives your itinerary a clearer image: stage light, music, masks, and theatre doors, alongside the cultural stops around old Hanoi. | Before you go: Vietnam Central Circus works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Circus building exterior at dusk with Hanoi street activity with masks, theatre doors, evening streets, and cultural memory, alongside the cultural stops around old Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hanoi-place-vietnam-fine-arts-museum
- `ledger_row`: 192
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bảo tàng Mỹ thuật Việt Nam
- `english_name`: Vietnam Fine Arts Museum
- `place_kind`: museum
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceVietnamFineArtsMuseum
- `legacy_summary`: Vietnam Fine Arts Museum is worth a stop if you want Hanoi to feel more layered than the streets outside. Expect yellow colonial museum building, art banners, shaded courtyard.
- `legacy_context`: For Vietnam Fine Arts Museum, Hanoi's cultural stop story comes through gallery rooms, artifacts, quiet light, and memory, alongside Hanoi's quieter gallery-and-stage rhythm.
- `legacy_sections_compact`: Why go: Vietnam Fine Arts Museum is worth a stop when you want more than scenery: rooms, objects, art, and memory inside the city's story, with quiet light, memory, local history, and display cases, alongside Hanoi's quieter gallery-and-stage rhythm. | What you'll get: At Vietnam Fine Arts Museum, you get rooms, objects, art, and memory inside the city's story: yellow colonial museum building, art banners, shaded courtyard, with quiet light, memory, local history, and display cases, alongside Hanoi's quieter gallery-and-stage rhythm. | Say it locally: Say Bảo tàng Mỹ thuật Việt Nam for Vietnam Fine Arts Museum. The local name is easier to remember once it sits beside memory, local history, display cases, and gallery rooms, alongside Hanoi's quieter gallery-and-stage rhythm. | Worth it if: Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: artifacts, quiet light, memory, and local history, alongside Hanoi's quieter gallery-and-stage rhythm. | Before you go: Vietnam Fine Arts Museum works best when the name is tied to the reason for going, not memorized as an abstract label. Picture yellow colonial museum building, art banners, shaded courtyard with artifacts, quiet light, memory, and local history, alongside Hanoi's quieter gallery-and-stage rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hanoi-place-vietnam-military-history-museum
- `ledger_row`: 193
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bảo tàng Lịch sử Quân sự Việt Nam
- `english_name`: Vietnam Military History Museum
- `place_kind`: museum
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceVietnamMilitaryHistoryMuseum
- `legacy_summary`: Vietnam Military History Museum is worth a stop if you want Hanoi to feel more layered than the streets outside. Expect outdoor military museum display with flag tower behind it.
- `legacy_context`: For Vietnam Military History Museum, Hanoi's cultural stop story comes through memory, local history, display cases, and gallery rooms, alongside Hanoi's quieter gallery-and-stage rhythm.
- `legacy_sections_compact`: Why go: Vietnam Military History Museum is worth a stop when you want more than scenery: rooms, objects, art, and memory inside the city's story, with artifacts, quiet light, memory, and local history, alongside Hanoi's quieter gallery-and-stage rhythm. | What you'll get: At Vietnam Military History Museum, you get rooms, objects, art, and memory inside the city's story: outdoor military museum display with flag tower behind it, with memory, local history, display cases, and gallery rooms, alongside Hanoi's quieter gallery-and-stage rhythm. | Say it locally: Say Bảo tàng Lịch sử Quân sự Việt Nam for Vietnam Military History Museum. The local name is easier to remember once it sits beside local history, display cases, gallery rooms, and artifacts, alongside Hanoi's quieter gallery-and-stage rhythm. | Worth it if: Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: quiet light, memory, local history, and display cases, alongside Hanoi's quieter gallery-and-stage rhythm. | Before you go: Vietnam Military History Museum works best when the name is tied to the reason for going, not memorized as an abstract label. Picture outdoor military museum display with flag tower behind it with quiet light, memory, local history, and display cases, alongside Hanoi's quieter gallery-and-stage rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hanoi-place-vietnam-national-tuong-theatre
- `ledger_row`: 194
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Nhà hát Tuồng Việt Nam
- `english_name`: Vietnam National Tuong Theatre
- `place_kind`: experience
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceVietnamNationalTuongTheatre
- `legacy_summary`: Vietnam National Tuong Theatre is worth knowing in Hanoi because it brings living performance culture rather than a static monument into the trip. Expect traditional Vietnamese theatre stage masks and red curtain, evening.
- `legacy_context`: For Vietnam National Tuong Theatre, Hanoi's performance venue story comes through evening streets, cultural memory, stage light, and music, alongside Hanoi's museum-and-courtyard side.
- `legacy_sections_compact`: Why go: Vietnam National Tuong Theatre is worth knowing because it gives Hanoi a specific performance venue scene: evening streets, cultural memory, stage light, and music, alongside Hanoi's museum-and-courtyard side. | What you'll get: At Vietnam National Tuong Theatre, you get living performance culture rather than a static monument: traditional Vietnamese theatre stage masks and red curtain, evening, with masks, theatre doors, evening streets, and cultural memory, alongside Hanoi's museum-and-courtyard side. | Say it locally: Say Nhà hát Tuồng Việt Nam for Vietnam National Tuong Theatre. The local name is easier to remember once it sits beside music, masks, theatre doors, and evening streets, alongside Hanoi's museum-and-courtyard side. | Worth it if: Worth it if Vietnam National Tuong Theatre gives your itinerary a clearer image: music, masks, theatre doors, and evening streets, alongside Hanoi's museum-and-courtyard side. | Before you go: Vietnam National Tuong Theatre works best when the name is tied to the reason for going, not memorized as an abstract label. Picture traditional Vietnamese theatre stage masks and red curtain, evening with cultural memory, stage light, music, and masks, alongside Hanoi's museum-and-courtyard side.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
