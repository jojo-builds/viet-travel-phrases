You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_037` in the final handoff block. Put `SpeakLocal v2.2 BATCH_037 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hanoi-place-ngoc-son-temple
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Đền Ngọc Sơn
- `english_name`: Ngoc Son Temple
- `place_kind`: landmark
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceNgocSonTemple
- `legacy_summary`: Ngoc Son Temple is worth approaching slowly because worship, architecture, incense, and local memory shape the visit. Expect red Huc Bridge leading to Ngoc Son Temple, lake trees, morning.
- `legacy_context`: For Ngoc Son Temple, Hanoi's sacred place story comes through respectful pauses, incense, courtyards, and tiled roofs, alongside Hoan Kiem and West Lake calm.
- `legacy_sections_compact`: Why go: Ngoc Son Temple is worth approaching slowly because worship, architecture, incense, and local memory all shape the visit: respectful pauses, incense, courtyards, and tiled roofs, alongside Hoan Kiem and West Lake calm. | What you'll get: At Ngoc Son Temple, you get worship, architecture, local memory, and the quieter rhythm of a spiritual stop: red Huc Bridge leading to Ngoc Son Temple, lake trees, morning, with courtyards, tiled roofs, temple gates, and shade, alongside Hoan Kiem and West Lake calm. | Say it locally: Say Đền Ngọc Sơn for Ngoc Son Temple. The local name is easier to remember once it sits beside tiled roofs, temple gates, shade, and respectful pauses, alongside Hoan Kiem and West Lake calm. | Worth it if: Worth it if temples, incense, worship, and quiet architecture help the place feel deeper: incense, courtyards, tiled roofs, and temple gates, alongside Hoan Kiem and West Lake calm. | Before you go: Ngoc Son Temple works best when the name is tied to the reason for going, not memorized as an abstract label. Picture red Huc Bridge leading to Ngoc Son Temple, lake trees, morning with tiled roofs, temple gates, shade, and respectful pauses, alongside Hoan Kiem and West Lake calm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-nguyen-huu-huan-street
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phố Nguyễn Hữu Huân
- `english_name`: Nguyen Huu Huan Street
- `place_kind`: street
- `source_notes`: MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlaceNguyenHuuHuanStreet
- `legacy_summary`: Nguyen Huu Huan Street is a Hanoi coffee street, where cafe signs, egg-coffee stops, narrow shopfronts, and Old Quarter movement make the neighborhood feel easy to explore.
- `legacy_context`: For Nguyen Huu Huan Street, Hanoi's street story comes through crossings, cafe edges, neighborhood movement, and street signs, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: This street gives the coffee side of Hanoi a visible shape: close storefronts, upstairs rooms, tiny tables, and the next cup only a short walk away. | What you'll get: Nguyen Huu Huan matters because it turns Hanoi coffee from a single famous cup into a walkable neighborhood scene. | Say it locally: Hear Phố Nguyễn Hữu Huân with the coffee-street image in mind: cafe signs, motorbikes, narrow shopfronts, and egg-coffee stops close together. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: scooters, crossings, cafe edges, and neighborhood movement, alongside old-lane Hanoi. | Before you go: Nguyen Huu Huan Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture narrow Nguyen Huu Huan Street cafe storefronts and motorbikes with cafe edges, neighborhood movement, street signs, and shopfronts, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-night-market-walk
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Đi chợ đêm phố cổ
- `english_name`: Old Quarter night market walk
- `place_kind`: market
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceNightMarketWalk
- `legacy_summary`: Old Quarter night market walk is worth knowing in Hanoi because it brings the city shifting from daytime movement into food, lights, and browsing into the trip. Expect Hanoi Old Quarter night-market pedestrian street, stalls and warm lights.
- `legacy_context`: For Old Quarter night market walk, Hanoi's night market story comes through small gifts, warm lights, river edges, and evening crowds, alongside Hanoi market-morning energy.
- `legacy_sections_compact`: Why go: Old Quarter night market walk is worth knowing because it gives Hanoi a specific night market scene: lanterns, food smoke, small gifts, and warm lights, alongside Hanoi market-morning energy. | What you'll get: At Old Quarter night market walk, you get the city shifting from daytime movement into food, lights, and browsing: Hanoi Old Quarter night-market pedestrian street, stalls and warm lights, with river edges, evening crowds, lanterns, and food smoke, alongside Hanoi market-morning energy. | Say it locally: Say Đi chợ đêm phố cổ for Old Quarter night market walk. The local name is easier to remember once it sits beside food smoke, small gifts, warm lights, and river edges, alongside Hanoi market-morning energy. | Worth it if: Worth it if Old Quarter night market walk gives your itinerary a clearer image: evening crowds, lanterns, food smoke, and small gifts, alongside Hanoi market-morning energy. | Before you go: Old Quarter night market walk works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi Old Quarter night-market pedestrian street, stalls and warm lights with evening crowds, lanterns, food smoke, and small gifts, alongside Hanoi market-morning energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-noi-bai-airport
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Sân bay Nội Bài
- `english_name`: Noi Bai International Airport
- `place_kind`: airport
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceNoiBaiAirport
- `legacy_summary`: Noi Bai International Airport is worth recognizing because it is where the planned trip first becomes Hanoi. Expect glass doors, city light outside, waiting families, and the first turn toward Hanoi.
- `legacy_context`: For Noi Bai International Airport, Hanoi's arrival story comes through waiting halls, the first local name, arrival doors, and city signs, alongside Hanoi's station-side streets.
- `legacy_sections_compact`: Why go: Noi Bai International Airport is worth recognizing before arrival because it is where the trip first turns from plan into Vietnam: arrival doors, city signs, warm air, and first roads, alongside Hanoi's station-side streets. | What you'll get: At Noi Bai International Airport, you get the arrival threshold where bags, signs, and the first ride make Vietnam feel immediate: glass doors, city light outside, waiting families, and the first turn toward Hanoi, with waiting halls, the first local name, arrival doors, and city signs, alongside Hanoi's station-side streets. | Say it locally: Say Sân bay Nội Bài for Noi Bai International Airport. The local name is easier to remember once it sits beside the first local name, arrival doors, city signs, and warm air, alongside Hanoi's station-side streets. | Worth it if: Worth it if Noi Bai International Airport gives your itinerary a clearer image: first roads, waiting halls, the first local name, and arrival doors, alongside Hanoi's station-side streets. | Before you go: Noi Bai International Airport works best when the name is tied to the reason for going, not memorized as an abstract label. Picture glass doors, city light outside, waiting families, and the first turn toward Hanoi with first roads, waiting halls, the first local name, and arrival doors, alongside Hanoi's station-side streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-nuoc-ngam-bus-station
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bến xe Nước Ngầm
- `english_name`: Nuoc Ngam Bus Station
- `place_kind`: station
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlaceNuocNgamBusStation
- `legacy_summary`: Nuoc Ngam Bus Station is worth recognizing because travel days still carry the mood of Hanoi. Expect Hanoi station light, local signs, shaded benches, and onward streets.
- `legacy_context`: For Nuoc Ngam Bus Station, Hanoi's station story comes through station doors, route boards, waiting benches, and city light, alongside Hanoi's station-side streets.
- `legacy_sections_compact`: Why go: Nuoc Ngam Bus Station is worth recognizing because travel days still carry the city's mood: waiting benches, city light, local signs, and onward roads, alongside Hanoi's station-side streets. | What you'll get: At Nuoc Ngam Bus Station, you get the handoff between travel days, city days, trains, buses, rides, and local names: Hanoi station light, local signs, shaded benches, and onward streets, with local signs, onward roads, station doors, and route boards, alongside Hanoi's station-side streets. | Say it locally: Say Bến xe Nước Ngầm for Nuoc Ngam Bus Station. The local name is easier to remember once it sits beside city light, local signs, onward roads, and station doors, alongside Hanoi's station-side streets. | Worth it if: Worth it if Nuoc Ngam Bus Station gives your itinerary a clearer image: route boards, waiting benches, city light, and local signs, alongside Hanoi's station-side streets. | Before you go: Nuoc Ngam Bus Station works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi station light, local signs, shaded benches, and onward streets with route boards, waiting benches, city light, and local signs, alongside Hanoi's station-side streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hanoi-place-old-quarter
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phố cổ Hà Nội
- `english_name`: Old Quarter
- `place_kind`: neighborhood
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceOldQuarter
- `legacy_summary`: Old Quarter is worth recognizing because neighborhoods turn Hanoi from landmarks into lived-in areas. Expect narrow Old Quarter street with shop signs, scooters, and hanging lanterns.
- `legacy_context`: For Old Quarter, Hanoi's neighborhood story comes through neighborhood identity, cafes, lanes, and small shops, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: Old Quarter is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: hotel edges, evening walks, neighborhood identity, and cafes, alongside old-lane Hanoi. | What you'll get: At Old Quarter, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: narrow Old Quarter street with shop signs, scooters, and hanging lanterns, with neighborhood identity, cafes, lanes, and small shops, alongside old-lane Hanoi. | Say it locally: Say Phố cổ Hà Nội for Old Quarter. The local name is easier to remember once it sits beside evening walks, neighborhood identity, cafes, and lanes, alongside old-lane Hanoi. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: small shops, hotel edges, evening walks, and neighborhood identity, alongside old-lane Hanoi. | Before you go: Old Quarter works best when the name is tied to the reason for going, not memorized as an abstract label. Picture narrow Old Quarter street with shop signs, scooters, and hanging lanterns with small shops, hotel edges, evening walks, and neighborhood identity, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hanoi-place-old-quarter-walking-tour
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Tuyến đi bộ Phố cổ
- `english_name`: Old Quarter walking route
- `place_kind`: experience
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceOldQuarterWalkingTour
- `legacy_summary`: Old Quarter walking route is worth knowing in Hanoi because it brings movement across the city as part of the discovery into the trip. Expect from a visitor's eye level Old Quarter walking scene with route and street signs.
- `legacy_context`: For Old Quarter walking route, Hanoi's route story comes through cafe pauses, local movement, the route between named places, and street corners, alongside Hanoi's food-and-cafe rhythm.
- `legacy_sections_compact`: Why go: Old Quarter walking route is worth knowing because it gives Hanoi a specific route scene: street corners, food stops, cafe pauses, and local movement, alongside Hanoi's food-and-cafe rhythm. | What you'll get: At Old Quarter walking route, you get movement across the city as part of the discovery: from a visitor's eye level Old Quarter walking scene with route and street signs, with cafe pauses, local movement, the route between named places, and street corners, alongside Hanoi's food-and-cafe rhythm. | Say it locally: Say Tuyến đi bộ Phố cổ for Old Quarter walking route. The local name is easier to remember once it sits beside cafe pauses, local movement, the route between named places, and street corners, alongside Hanoi's food-and-cafe rhythm. | Worth it if: Worth it if Old Quarter walking route gives your itinerary a clearer image: the route between named places, street corners, food stops, and cafe pauses, alongside Hanoi's food-and-cafe rhythm. | Before you go: Old Quarter walking route works best when the name is tied to the reason for going, not memorized as an abstract label. Picture from a visitor's eye level Old Quarter walking scene with route and street signs with street corners, food stops, cafe pauses, and local movement, alongside Hanoi's food-and-cafe rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hanoi-place-one-pillar-pagoda
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chùa Một Cột
- `english_name`: One Pillar Pagoda
- `place_kind`: landmark
- `source_notes`: Hanoi tourism portal; Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceOnePillarPagoda
- `legacy_summary`: One Pillar Pagoda is worth approaching slowly because worship, architecture, incense, and local memory shape the visit. Expect One Pillar Pagoda reflected in pond.
- `legacy_context`: For One Pillar Pagoda, Hanoi's sacred place story comes through courtyards, tiled roofs, temple gates, and shade, alongside Hanoi's lake-and-temple side.
- `legacy_sections_compact`: Why go: One Pillar Pagoda is worth approaching slowly because worship, architecture, incense, and local memory all shape the visit: temple gates, shade, respectful pauses, and incense, alongside Hanoi's lake-and-temple side. | What you'll get: At One Pillar Pagoda, you get worship, architecture, local memory, and the quieter rhythm of a spiritual stop: One Pillar Pagoda reflected in pond, with courtyards, tiled roofs, temple gates, and shade, alongside Hanoi's lake-and-temple side. | Say it locally: Say Chùa Một Cột for One Pillar Pagoda. The local name is easier to remember once it sits beside incense, courtyards, tiled roofs, and temple gates, alongside Hanoi's lake-and-temple side. | Worth it if: Worth it if temples, incense, worship, and quiet architecture help the place feel deeper: incense, courtyards, tiled roofs, and temple gates, alongside Hanoi's lake-and-temple side. | Before you go: One Pillar Pagoda works best when the name is tied to the reason for going, not memorized as an abstract label. Picture One Pillar Pagoda reflected in pond with incense, courtyards, tiled roofs, and temple gates, alongside Hanoi's lake-and-temple side.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hanoi-place-opera-house
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Nhà hát Lớn Hà Nội
- `english_name`: Hanoi Opera House
- `place_kind`: experience
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceOperaHouse
- `legacy_summary`: Hanoi Opera House is worth knowing in Hanoi because it brings living performance culture rather than a static monument into the trip. Expect Hanoi Opera House facade with scooters and evening lamps, street scene.
- `legacy_context`: For Hanoi Opera House, Hanoi's performance venue story comes through theatre doors, evening streets, cultural memory, and stage light, alongside Hanoi's quieter gallery-and-stage rhythm.
- `legacy_sections_compact`: Why go: Hanoi Opera House is worth knowing because it gives Hanoi a specific performance venue scene: cultural memory, stage light, music, and masks, alongside Hanoi's quieter gallery-and-stage rhythm. | What you'll get: At Hanoi Opera House, you get living performance culture rather than a static monument: Hanoi Opera House facade with scooters and evening lamps, street scene, with theatre doors, evening streets, cultural memory, and stage light, alongside Hanoi's quieter gallery-and-stage rhythm. | Say it locally: Say Nhà hát Lớn Hà Nội for Hanoi Opera House. The local name is easier to remember once it sits beside masks, theatre doors, evening streets, and cultural memory, alongside Hanoi's quieter gallery-and-stage rhythm. | Worth it if: Worth it if Hanoi Opera House gives your itinerary a clearer image: stage light, music, masks, and theatre doors, alongside Hanoi's quieter gallery-and-stage rhythm. | Before you go: Hanoi Opera House works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi Opera House facade with scooters and evening lamps, street scene with masks, theatre doors, evening streets, and cultural memory, alongside Hanoi's quieter gallery-and-stage rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hanoi-place-phan-dinh-phung-street
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phố Phan Đình Phùng
- `english_name`: Phan Dinh Phung Street
- `place_kind`: street
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlacePhanDinhPhungStreet
- `legacy_summary`: Phan Dinh Phung Street is worth recognizing because a named street can make Hanoi feel walkable before arrival. Expect tree-lined Phan Dinh Phung Street with yellow villas and bicycles.
- `legacy_context`: For Phan Dinh Phung Street, Hanoi's street story comes through crossings, cafe edges, neighborhood movement, and street signs, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: Phan Dinh Phung Street is worth recognizing because streets shape how Hanoi feels on the ground: shopfronts, scooters, crossings, and cafe edges, alongside old-lane Hanoi. | What you'll get: At Phan Dinh Phung Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: tree-lined Phan Dinh Phung Street with yellow villas and bicycles, with neighborhood movement, street signs, shopfronts, and scooters, alongside old-lane Hanoi. | Say it locally: Say Phố Phan Đình Phùng for Phan Dinh Phung Street. The local name is easier to remember once it sits beside street signs, shopfronts, scooters, and crossings, alongside old-lane Hanoi. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: cafe edges, neighborhood movement, street signs, and shopfronts, alongside old-lane Hanoi. | Before you go: Phan Dinh Phung Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture tree-lined Phan Dinh Phung Street with yellow villas and bicycles with street signs, shopfronts, scooters, and crossings, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

