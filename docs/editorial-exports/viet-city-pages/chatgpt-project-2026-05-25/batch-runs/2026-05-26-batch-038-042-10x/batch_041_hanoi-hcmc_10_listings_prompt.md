You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_041` in the final handoff block. Put `SpeakLocal v2.2 BATCH_041 - Hanoi/Saigon - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hanoi-place-water-puppet-theatre
- `ledger_row`: 195
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Nhà hát Múa rối Thăng Long
- `english_name`: Thang Long Water Puppet Theatre
- `place_kind`: experience
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceWaterPuppetTheatre
- `legacy_summary`: Thang Long Water Puppet Theatre is worth knowing in Hanoi because it brings living performance culture rather than a static monument into the trip. Expect exterior theatre sign near Hoan Kiem with evening street lights.
- `legacy_context`: For Thang Long Water Puppet Theatre, Hanoi's performance venue story comes through cultural memory, stage light, music, and masks, alongside Hanoi's quieter gallery-and-stage rhythm.
- `legacy_sections_compact`: Why go: Thang Long Water Puppet Theatre is worth knowing because it gives Hanoi a specific performance venue scene: theatre doors, evening streets, cultural memory, and stage light, alongside Hanoi's quieter gallery-and-stage rhythm. | What you'll get: At Thang Long Water Puppet Theatre, you get living performance culture rather than a static monument: exterior theatre sign near Hoan Kiem with evening street lights, with theatre doors, evening streets, cultural memory, and stage light, alongside Hanoi's quieter gallery-and-stage rhythm. | Say it locally: Say Nhà hát Múa rối Thăng Long for Thang Long Water Puppet Theatre. The local name is easier to remember once it sits beside stage light, music, masks, and theatre doors, alongside Hanoi's quieter gallery-and-stage rhythm. | Worth it if: Worth it if Thang Long Water Puppet Theatre gives your itinerary a clearer image: evening streets, cultural memory, stage light, and music, alongside Hanoi's quieter gallery-and-stage rhythm. | Before you go: Thang Long Water Puppet Theatre works best when the name is tied to the reason for going, not memorized as an abstract label. Picture exterior theatre sign near Hoan Kiem with evening street lights with masks, theatre doors, evening streets, and cultural memory, alongside Hanoi's quieter gallery-and-stage rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-weekend-night-market
- `ledger_row`: 196
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chợ đêm phố cổ Hà Nội
- `english_name`: Hanoi Weekend Night Market
- `place_kind`: market
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceWeekendNightMarket
- `legacy_summary`: Hanoi Weekend Night Market is worth knowing in Hanoi because it brings the city shifting from daytime movement into food, lights, and browsing into the trip. Expect Old Quarter night market street with stalls, lights, pedestrians.
- `legacy_context`: For Hanoi Weekend Night Market, Hanoi's night market story comes through small gifts, warm lights, river edges, and evening crowds, alongside Hanoi's market-side street life.
- `legacy_sections_compact`: Why go: Hanoi Weekend Night Market is worth knowing because it gives Hanoi a specific night market scene: small gifts, warm lights, river edges, and evening crowds, alongside Hanoi's market-side street life. | What you'll get: At Hanoi Weekend Night Market, you get the city shifting from daytime movement into food, lights, and browsing: Old Quarter night market street with stalls, lights, pedestrians, with river edges, evening crowds, lanterns, and food smoke, alongside Hanoi's market-side street life. | Say it locally: Say Chợ đêm phố cổ Hà Nội for Hanoi Weekend Night Market. The local name is easier to remember once it sits beside warm lights, river edges, evening crowds, and lanterns, alongside Hanoi's market-side street life. | Worth it if: Worth it if Hanoi Weekend Night Market gives your itinerary a clearer image: food smoke, small gifts, warm lights, and river edges, alongside Hanoi's market-side street life. | Before you go: Hanoi Weekend Night Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Old Quarter night market street with stalls, lights, pedestrians with warm lights, river edges, evening crowds, and lanterns, alongside Hanoi's market-side street life.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-west-lake
- `ledger_row`: 197
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Hồ Tây
- `english_name`: West Lake
- `place_kind`: nature
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceWestLake
- `legacy_summary`: West Lake is worth knowing in Hanoi because it brings the city turning walkable around water instead of only traffic and streets into the trip. Expect wide West Lake view with shoreline cafes and sunset haze.
- `legacy_context`: For West Lake, Hanoi's lake story comes through bridges, neighborhood views, water, and walking paths, alongside Hanoi's lake-and-temple side.
- `legacy_sections_compact`: Why go: West Lake is worth knowing because it gives Hanoi a specific lake scene: water, walking paths, cafe edges, and shade, alongside Hanoi's lake-and-temple side. | What you'll get: At West Lake, you get the city turning walkable around water instead of only traffic and streets: wide West Lake view with shoreline cafes and sunset haze, with cafe edges, shade, bridges, and neighborhood views, alongside Hanoi's lake-and-temple side. | Say it locally: Say Hồ Tây for West Lake. The local name is easier to remember once it sits beside neighborhood views, water, walking paths, and cafe edges, alongside Hanoi's lake-and-temple side. | Worth it if: Worth it if West Lake gives your itinerary a clearer image: shade, bridges, neighborhood views, and water, alongside Hanoi's lake-and-temple side. | Before you go: West Lake works best when the name is tied to the reason for going, not memorized as an abstract label. Picture wide West Lake view with shoreline cafes and sunset haze with shade, bridges, neighborhood views, and water, alongside Hanoi's lake-and-temple side.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-west-lake-loop
- `ledger_row`: 198
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Vòng Hồ Tây
- `english_name`: West Lake loop
- `place_kind`: nature
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceWestLakeLoop
- `legacy_summary`: West Lake loop is worth knowing in Hanoi because it brings the city turning walkable around water instead of only traffic and streets into the trip. Expect lakeside path around West Lake with scooters and sunset.
- `legacy_context`: For West Lake loop, Hanoi's lake story comes through neighborhood views, water, walking paths, and cafe edges, alongside the capital's old civic rhythm.
- `legacy_sections_compact`: Why go: West Lake loop is worth knowing because it gives Hanoi a specific lake scene: shade, bridges, neighborhood views, and water, alongside the capital's old civic rhythm. | What you'll get: At West Lake loop, you get the city turning walkable around water instead of only traffic and streets: lakeside path around West Lake with scooters and sunset, with walking paths, cafe edges, shade, and bridges, alongside the capital's old civic rhythm. | Say it locally: Say Vòng Hồ Tây for West Lake loop. The local name is easier to remember once it sits beside bridges, neighborhood views, water, and walking paths, alongside the capital's old civic rhythm. | Worth it if: Worth it if West Lake loop gives your itinerary a clearer image: cafe edges, shade, bridges, and neighborhood views, alongside the capital's old civic rhythm. | Before you go: West Lake loop works best when the name is tied to the reason for going, not memorized as an abstract label. Picture lakeside path around West Lake with scooters and sunset with bridges, neighborhood views, water, and walking paths, alongside the capital's old civic rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-womens-museum
- `ledger_row`: 199
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bảo tàng Phụ nữ Việt Nam
- `english_name`: Vietnamese Women's Museum
- `place_kind`: museum
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceWomensMuseum
- `legacy_summary`: Vietnamese Women's Museum is worth a stop if you want Hanoi to feel more layered than the streets outside. Expect Vietnamese Women's Museum entry area, street trees.
- `legacy_context`: For Vietnamese Women's Museum, Hanoi's cultural stop story comes through display cases, gallery rooms, artifacts, and quiet light, alongside Hanoi's museum-and-courtyard side.
- `legacy_sections_compact`: Why go: Vietnamese Women's Museum is worth a stop when you want more than scenery: rooms, objects, art, and memory inside the city's story, with memory, local history, display cases, and gallery rooms, alongside Hanoi's museum-and-courtyard side. | What you'll get: At Vietnamese Women's Museum, you get rooms, objects, art, and memory inside the city's story: Vietnamese Women's Museum entry area, street trees, with memory, local history, display cases, and gallery rooms, alongside Hanoi's museum-and-courtyard side. | Say it locally: Say Bảo tàng Phụ nữ Việt Nam for Vietnamese Women's Museum. The local name is easier to remember once it sits beside quiet light, memory, local history, and display cases, alongside Hanoi's museum-and-courtyard side. | Worth it if: Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: gallery rooms, artifacts, quiet light, and memory, alongside Hanoi's museum-and-courtyard side. | Before you go: Vietnamese Women's Museum works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Vietnamese Women's Museum entry area, street trees with gallery rooms, artifacts, quiet light, and memory, alongside Hanoi's museum-and-courtyard side.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hanoi-place-xoi-xeo
- `ledger_row`: 200
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Xôi xéo ở Hà Nội
- `english_name`: Sticky rice with mung bean
- `place_kind`: dish
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlaceXoiXeo
- `legacy_summary`: Sticky rice with mung bean is worth trying in Hanoi because it gives the trip a flavor to imagine before arrival. Expect yellow sticky rice with mung bean and fried shallots in banana leaf.
- `legacy_context`: For Sticky rice with mung bean, Hanoi's food story comes through texture, small meal rituals, flavor, and herbs, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Sticky rice with mung bean is worth trying because it turns Hanoi into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with texture, small meal rituals, flavor, and herbs, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Sticky rice with mung bean, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: yellow sticky rice with mung bean and fried shallots in banana leaf, with sauce, steam, texture, and small meal rituals, alongside Hanoi's steam-and-herb food streets. | Say it locally: Say Xôi xéo ở Hà Nội for Sticky rice with mung bean. The local name is easier to remember once it sits beside herbs, sauce, steam, and texture, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if you want a food memory rather than only a label: small meal rituals, flavor, herbs, and sauce, alongside Hanoi's steam-and-herb food streets. | Before you go: Sticky rice with mung bean works best when the name is tied to the reason for going, not memorized as an abstract label. Picture yellow sticky rice with mung bean and fried shallots in banana leaf with small meal rituals, flavor, herbs, and sauce, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hanoi-place-yen-so-park
- `ledger_row`: 201
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Công viên Yên Sở
- `english_name`: Yen So Park
- `place_kind`: park
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceYenSoPark
- `legacy_summary`: Yen So Park is worth knowing in Hanoi because it brings everyday city life in open air without a formal attraction into the trip. Expect large green Hanoi park with lakeside path and open grass.
- `legacy_context`: For Yen So Park, Hanoi's park story comes through evening light, walking paths, trees, and family time, alongside the capital's open-air pauses.
- `legacy_sections_compact`: Why go: Yen So Park is worth knowing because it gives Hanoi a specific park scene: shade, open lawns, evening light, and walking paths, alongside the capital's open-air pauses. | What you'll get: At Yen So Park, you get everyday city life in open air without a formal attraction: large green Hanoi park with lakeside path and open grass, with trees, family time, shade, and open lawns, alongside the capital's open-air pauses. | Say it locally: Say Công viên Yên Sở for Yen So Park. The local name is easier to remember once it sits beside family time, shade, open lawns, and evening light, alongside the capital's open-air pauses. | Worth it if: Worth it if Yen So Park gives your itinerary a clearer image: family time, shade, open lawns, and evening light, alongside the capital's open-air pauses. | Before you go: Yen So Park works best when the name is tied to the reason for going, not memorized as an abstract label. Picture large green Hanoi park with lakeside path and open grass with walking paths, trees, family time, and shade, alongside the capital's open-air pauses.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hcmc-place-ben-thanh-metro-station
- `ledger_row`: 214
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Ga Bến Thành
- `english_name`: Ben Thanh Metro Station
- `place_kind`: station
- `source_notes`: Visit HCMC portal
- `target_hero_image`: HeroCityHcmcPlaceBenThanhMetroStation
- `legacy_summary`: Ben Thanh Metro Station is worth recognizing because travel days still carry the mood of Saigon. Expect station facade, route boards, waiting benches, and local streets just outside.
- `legacy_context`: For Ben Thanh Metro Station, Saigon's station story comes through onward roads, station doors, route boards, and waiting benches, alongside Nguyen Hue city light.
- `legacy_sections_compact`: Why go: Ben Thanh Metro Station is worth recognizing because travel days still carry the city's mood: route boards, waiting benches, city light, and local signs, alongside Nguyen Hue city light. | What you'll get: At Ben Thanh Metro Station, you get the handoff between travel days, city days, trains, buses, rides, and local names: station facade, route boards, waiting benches, and local streets just outside, with route boards, waiting benches, city light, and local signs, alongside Nguyen Hue city light. | Say it locally: Say Ga Bến Thành for Ben Thanh Metro Station. The local name is easier to remember once it sits beside waiting benches, city light, local signs, and onward roads, alongside Nguyen Hue city light. | Worth it if: Worth it if Ben Thanh Metro Station gives your itinerary a clearer image: waiting benches, city light, local signs, and onward roads, alongside Nguyen Hue city light. | Before you go: Ben Thanh Metro Station works best when the name is tied to the reason for going, not memorized as an abstract label. Picture station facade, route boards, waiting benches, and local streets just outside with waiting benches, city light, local signs, and onward roads, alongside Nguyen Hue city light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hcmc-place-bep-me-in
- `ledger_row`: 215
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bếp Mẹ Ỉn
- `english_name`: Bep Me In
- `place_kind`: restaurant
- `source_notes`: local named-restaurant source
- `target_hero_image`: HeroCityHcmcPlaceBepMeIn
- `legacy_summary`: Bep Me In is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect cozy Saigon restaurant table with clay pots and herbs.
- `legacy_context`: For Bep Me In, Saigon's restaurant story comes through house dishes, menu details, staff rhythm, and drinks, alongside Ben Thanh market energy.
- `legacy_sections_compact`: Why go: Bep Me In is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with evening meal energy, tables, house dishes, and menu details, alongside Ben Thanh market energy. | What you'll get: At Bep Me In, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: cozy Saigon restaurant table with clay pots and herbs, with evening meal energy, tables, house dishes, and menu details, alongside Ben Thanh market energy. | Say it locally: Say Bếp Mẹ Ỉn for Bep Me In. The local name is easier to remember once it sits beside menu details, staff rhythm, drinks, and evening meal energy, alongside Ben Thanh market energy. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside Ben Thanh market energy. | Before you go: Bep Me In works best when the name is tied to the reason for going, not memorized as an abstract label. Picture cozy Saigon restaurant table with clay pots and herbs with tables, house dishes, menu details, and staff rhythm, alongside Ben Thanh market energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hcmc-place-binh-tay-market
- `ledger_row`: 216
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Chợ Bình Tây
- `english_name`: Binh Tay Market
- `place_kind`: market
- `source_notes`: existing-city-library; Vietnam Travel HCMC
- `target_hero_image`: HeroCityHcmcPlaceBinhTayMarket
- `legacy_summary`: Binh Tay Market is worth browsing because it shows Saigon through stalls, snacks, goods, color, and everyday buying rhythm. Expect Binh Tay Market courtyard with yellow facade and stalls.
- `legacy_context`: For Binh Tay Market, Saigon's market story comes through bags, local shopping movement, market aisles, and produce colors, alongside Saigon street energy.
- `legacy_sections_compact`: Why go: Binh Tay Market is worth browsing because it shows everyday Saigon: bags, local shopping movement, market aisles, and produce colors, alongside Saigon street energy. | What you'll get: At Binh Tay Market, you get everyday shopping, snacks, gifts, bargaining, and local rhythm: Binh Tay Market courtyard with yellow facade and stalls, with snack counters, bargaining rhythm, bags, and local shopping movement, alongside Saigon street energy. | Say it locally: Say Chợ Bình Tây for Binh Tay Market. The local name is easier to remember once it sits beside local shopping movement, market aisles, produce colors, and snack counters, alongside Saigon street energy. | Worth it if: Worth it if you like seeing daily life through browsing, snacks, color, small goods, and local rhythm: bargaining rhythm, bags, local shopping movement, and market aisles, alongside Saigon street energy. | Before you go: Binh Tay Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Binh Tay Market courtyard with yellow facade and stalls with bargaining rhythm, bags, local shopping movement, and market aisles, alongside Saigon street energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
