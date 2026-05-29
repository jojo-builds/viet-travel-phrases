You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_034` in the final handoff block. Put `SpeakLocal v2.2 BATCH_034 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hanoi-place-french-quarter-walk
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Đi bộ khu phố Pháp
- `english_name`: French Quarter walk
- `place_kind`: experience
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceFrenchQuarterWalk
- `legacy_summary`: French Quarter walk is worth knowing in Hanoi because it brings movement across the city as part of the discovery into the trip. Expect wide Hanoi French Quarter sidewalk with colonial buildings and trees.
- `legacy_context`: For French Quarter walk, Hanoi's route story comes through food stops, cafe pauses, local movement, and the route between named places, alongside Hanoi old-lane texture.
- `legacy_sections_compact`: Why go: French Quarter walk is worth knowing because it gives Hanoi a specific route scene: local movement, the route between named places, street corners, and food stops, alongside Hanoi old-lane texture. | What you'll get: At French Quarter walk, you get movement across the city as part of the discovery: wide Hanoi French Quarter sidewalk with colonial buildings and trees, with local movement, the route between named places, street corners, and food stops, alongside Hanoi old-lane texture. | Say it locally: Say Đi bộ khu phố Pháp for French Quarter walk. The local name is easier to remember once it sits beside the route between named places, street corners, food stops, and cafe pauses, alongside Hanoi old-lane texture. | Worth it if: Worth it if French Quarter walk gives your itinerary a clearer image: food stops, cafe pauses, local movement, and the route between named places, alongside Hanoi old-lane texture. | Before you go: French Quarter walk works best when the name is tied to the reason for going, not memorized as an abstract label. Picture wide Hanoi French Quarter sidewalk with colonial buildings and trees with food stops, cafe pauses, local movement, and the route between named places, alongside Hanoi old-lane texture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-gia
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Gia
- `english_name`: Gia
- `place_kind`: restaurant
- `source_notes`: MICHELIN Vietnam 2025; MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlaceGia
- `legacy_summary`: Gia is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect elegant contemporary Vietnamese dining counter, muted Hanoi interior.
- `legacy_context`: For Gia, Hanoi's restaurant story comes through drinks, evening meal energy, tables, and house dishes, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Gia is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with drinks, evening meal energy, tables, and house dishes, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Gia, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: elegant contemporary Vietnamese dining counter, muted Hanoi interior, with menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi's steam-and-herb food streets. | Say it locally: Gia usually stays as the venue name. Say it slowly and connect it to the scene around it: staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if the meal itself should be one of the day's memories: staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi's steam-and-herb food streets. | Before you go: Gia works best when the name is tied to the reason for going, not memorized as an abstract label. Picture elegant contemporary Vietnamese dining counter, muted Hanoi interior with house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-gia-lam-station
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Ga Gia Lâm
- `english_name`: Gia Lam Railway Station
- `place_kind`: station
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlaceGiaLamStation
- `legacy_summary`: Gia Lam Railway Station is worth recognizing because travel days still carry the mood of Hanoi. Expect Hanoi station light, local signs, shaded benches, and onward streets.
- `legacy_context`: For Gia Lam Railway Station, Hanoi's station story comes through station doors, route boards, waiting benches, and city light, alongside the first roads into Hanoi.
- `legacy_sections_compact`: Why go: Gia Lam Railway Station is worth recognizing because travel days still carry the city's mood: local signs, onward roads, station doors, and route boards, alongside the first roads into Hanoi. | What you'll get: At Gia Lam Railway Station, you get the handoff between travel days, city days, trains, buses, rides, and local names: Hanoi station light, local signs, shaded benches, and onward streets, with local signs, onward roads, station doors, and route boards, alongside the first roads into Hanoi. | Say it locally: Say Ga Gia Lâm for Gia Lam Railway Station. The local name is easier to remember once it sits beside onward roads, station doors, route boards, and waiting benches, alongside the first roads into Hanoi. | Worth it if: Worth it if Gia Lam Railway Station gives your itinerary a clearer image: onward roads, station doors, route boards, and waiting benches, alongside the first roads into Hanoi. | Before you go: Gia Lam Railway Station works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi station light, local signs, shaded benches, and onward streets with onward roads, station doors, route boards, and waiting benches, alongside the first roads into Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-giang-cafe
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Cà phê Giảng
- `english_name`: Cafe Giang
- `place_kind`: cafe
- `source_notes`: Cafe Giang official site
- `target_hero_image`: HeroCityHanoiPlaceGiangCafe
- `legacy_summary`: Cà phê Giảng is the original-feeling Hanoi egg coffee stop: a narrow Old Quarter entrance, small tables, hot cà phê trứng, and a cup that drinks closer to dessert.
- `legacy_context`: Giảng works when the visit is one clear coffee ritual, not a long café session or a broad Hanoi food history lesson.
- `legacy_sections_compact`: Start Hot And Classic At The Source: Cà phê Giảng is where egg coffee becomes more than a novelty. Find the Old Quarter entrance and order hot cà phê trứng first. | Small Cups, Close Tables: Expect a busy, old-school room rather than a polished lounge. The point is the little cup: dark coffee under thick egg cream. | Useful Phrases:  | After The Lake Walk: Mid-morning or late afternoon keeps the stop small and warm. The cup is still worth it when treated like dessert rather than a normal caffeine errand. | Old Quarter Coffee Starting Point: Nguyễn Hữu Huân has become one of Hanoi’s coffee streets. Giảng is the history-heavy starting point before comparing other egg-coffee shops.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-giap-bat-bus-station
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bến xe Giáp Bát
- `english_name`: Giap Bat Bus Station
- `place_kind`: station
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlaceGiapBatBusStation
- `legacy_summary`: Giap Bat Bus Station is worth recognizing because travel days still carry the mood of Hanoi. Expect station awnings, city signs, bags, and the first view back into Hanoi.
- `legacy_context`: For Giap Bat Bus Station, Hanoi's station story comes through waiting benches, city light, local signs, and onward roads, alongside the first roads into Hanoi.
- `legacy_sections_compact`: Why go: Giap Bat Bus Station is worth recognizing because travel days still carry the city's mood: local signs, onward roads, station doors, and route boards, alongside the first roads into Hanoi. | What you'll get: At Giap Bat Bus Station, you get the handoff between travel days, city days, trains, buses, rides, and local names: station awnings, city signs, bags, and the first view back into Hanoi, with station doors, route boards, waiting benches, and city light, alongside the first roads into Hanoi. | Say it locally: Say Bến xe Giáp Bát for Giap Bat Bus Station. The local name is easier to remember once it sits beside city light, local signs, onward roads, and station doors, alongside the first roads into Hanoi. | Worth it if: Worth it if Giap Bat Bus Station gives your itinerary a clearer image: route boards, waiting benches, city light, and local signs, alongside the first roads into Hanoi. | Before you go: Giap Bat Bus Station works best when the name is tied to the reason for going, not memorized as an abstract label. Picture station awnings, city signs, bags, and the first view back into Hanoi with onward roads, station doors, route boards, and waiting benches, alongside the first roads into Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hanoi-place-hang-bac-street
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phố Hàng Bạc
- `english_name`: Hang Bac Street
- `place_kind`: street
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceHangBacStreet
- `legacy_summary`: Hang Bac Street is worth recognizing because a named street can make Hanoi feel walkable before arrival. Expect Old Quarter street storefronts on Hang Bac, silver shop signs.
- `legacy_context`: For Hang Bac Street, Hanoi's street story comes through street signs, shopfronts, scooters, and crossings, alongside Hanoi's food-and-cafe rhythm.
- `legacy_sections_compact`: Why go: Hang Bac Street is worth recognizing because streets shape how Hanoi feels on the ground: street signs, shopfronts, scooters, and crossings, alongside Hanoi's food-and-cafe rhythm. | What you'll get: At Hang Bac Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: Old Quarter street storefronts on Hang Bac, silver shop signs, with scooters, crossings, cafe edges, and neighborhood movement, alongside Hanoi's food-and-cafe rhythm. | Say it locally: Say Phố Hàng Bạc for Hang Bac Street. The local name is easier to remember once it sits beside crossings, cafe edges, neighborhood movement, and street signs, alongside Hanoi's food-and-cafe rhythm. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: crossings, cafe edges, neighborhood movement, and street signs, alongside Hanoi's food-and-cafe rhythm. | Before you go: Hang Bac Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Old Quarter street storefronts on Hang Bac, silver shop signs with crossings, cafe edges, neighborhood movement, and street signs, alongside Hanoi's food-and-cafe rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hanoi-place-hang-da-market
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chợ Hàng Da
- `english_name`: Hang Da Market
- `place_kind`: market
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceHangDaMarket
- `legacy_summary`: Hang Da Market is worth browsing because it shows Hanoi through stalls, snacks, goods, color, and everyday buying rhythm. Expect Hang Da Market exterior with local shops and scooters.
- `legacy_context`: For Hang Da Market, Hanoi's market story comes through snack counters, bargaining rhythm, bags, and local shopping movement, alongside Hanoi market-morning energy.
- `legacy_sections_compact`: Why go: Hang Da Market is worth browsing because it shows everyday Hanoi: bags, local shopping movement, market aisles, and produce colors, alongside Hanoi market-morning energy. | What you'll get: At Hang Da Market, you get everyday shopping, snacks, gifts, bargaining, and local rhythm: Hang Da Market exterior with local shops and scooters, with market aisles, produce colors, snack counters, and bargaining rhythm, alongside Hanoi market-morning energy. | Say it locally: Say Chợ Hàng Da for Hang Da Market. The local name is easier to remember once it sits beside local shopping movement, market aisles, produce colors, and snack counters, alongside Hanoi market-morning energy. | Worth it if: Worth it if you like seeing daily life through browsing, snacks, color, small goods, and local rhythm: local shopping movement, market aisles, produce colors, and snack counters, alongside Hanoi market-morning energy. | Before you go: Hang Da Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hang Da Market exterior with local shops and scooters with local shopping movement, market aisles, produce colors, and snack counters, alongside Hanoi market-morning energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hanoi-place-hang-gai-street
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phố Hàng Gai
- `english_name`: Hang Gai Street
- `place_kind`: street
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceHangGaiStreet
- `legacy_summary`: Hang Gai Street is worth recognizing because a named street can make Hanoi feel walkable before arrival. Expect silk shop windows on Hang Gai Street, scooters, warm afternoon.
- `legacy_context`: For Hang Gai Street, Hanoi's street story comes through neighborhood movement, street signs, shopfronts, and scooters, alongside Hanoi old-lane texture.
- `legacy_sections_compact`: Why go: Hang Gai Street is worth recognizing because streets shape how Hanoi feels on the ground: shopfronts, scooters, crossings, and cafe edges, alongside Hanoi old-lane texture. | What you'll get: At Hang Gai Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: silk shop windows on Hang Gai Street, scooters, warm afternoon, with shopfronts, scooters, crossings, and cafe edges, alongside Hanoi old-lane texture. | Say it locally: Say Phố Hàng Gai for Hang Gai Street. The local name is easier to remember once it sits beside street signs, shopfronts, scooters, and crossings, alongside Hanoi old-lane texture. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: cafe edges, neighborhood movement, street signs, and shopfronts, alongside Hanoi old-lane texture. | Before you go: Hang Gai Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture silk shop windows on Hang Gai Street, scooters, warm afternoon with cafe edges, neighborhood movement, street signs, and shopfronts, alongside Hanoi old-lane texture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hanoi-place-hanoi-flag-tower
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Cột cờ Hà Nội
- `english_name`: Hanoi Flag Tower
- `place_kind`: landmark
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceHanoiFlagTower
- `legacy_summary`: Hanoi Flag Tower is worth visiting because it makes history physical through architecture, gates, courtyards, and memory. Expect Hanoi Flag Tower with Vietnamese flag against blue sky.
- `legacy_context`: For Hanoi Flag Tower, Hanoi's heritage landmark story comes through stone paths, tiled roofs, ceremonial space, and old walls, alongside Ba Dinh's broad public space.
- `legacy_sections_compact`: Why go: Hanoi Flag Tower is worth visiting because it makes history physical: gates, courtyards, stone paths, and tiled roofs, alongside Ba Dinh's broad public space. | What you'll get: At Hanoi Flag Tower, you get history made physical in architecture, ceremony, and place memory: Hanoi Flag Tower with Vietnamese flag against blue sky, with gates, courtyards, stone paths, and tiled roofs, alongside Ba Dinh's broad public space. | Say it locally: Say Cột cờ Hà Nội for Hanoi Flag Tower. The local name is easier to remember once it sits beside courtyards, stone paths, tiled roofs, and ceremonial space, alongside Ba Dinh's broad public space. | Worth it if: Worth it if old walls, gates, courtyards, and public memory are part of the trip you want: old walls, gates, courtyards, and stone paths, alongside Ba Dinh's broad public space. | Before you go: Hanoi Flag Tower works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi Flag Tower with Vietnamese flag against blue sky with old walls, gates, courtyards, and stone paths, alongside Ba Dinh's broad public space.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hanoi-place-hanoi-railway-station
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Ga Hà Nội
- `english_name`: Hanoi Railway Station
- `place_kind`: station
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceHanoiRailwayStation
- `legacy_summary`: Hanoi Railway Station is a classic capital arrival scene: yellow facade, route boards, bags, shaded platforms, and streets leading back into old Hanoi.
- `legacy_context`: For Hanoi Railway Station, Hanoi's station story comes through city light, local signs, onward roads, and station doors, alongside Hanoi's station-side streets.
- `legacy_sections_compact`: Why go: This is Hanoi through train travel, where the station facade and nearby streets make the city feel connected to longer journeys north and south. | What you'll get: Hanoi Railway Station matters because it gives the capital a travel-day threshold, linking city time with rail routes, local signs, and the next leg of the trip. | Say it locally: Say Ga Hà Nội for Hanoi Railway Station. The local name is easier to remember once it sits beside waiting benches, city light, local signs, and onward roads, alongside Hanoi's station-side streets. | Worth it if: Worth it if Hanoi Railway Station gives your itinerary a clearer image: waiting benches, city light, local signs, and onward roads, alongside Hanoi's station-side streets. | Before you go: Hanoi Railway Station works best when the name is tied to the reason for going, not memorized as an abstract label. Picture station facade, route boards, waiting benches, and local streets just outside with station doors, route boards, waiting benches, and city light, alongside Hanoi's station-side streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

