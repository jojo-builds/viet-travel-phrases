You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_035` in the final handoff block. Put `SpeakLocal v2.2 BATCH_035 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hanoi-place-hibana-by-koki
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Hibana by Koki
- `english_name`: Hibana by Koki
- `place_kind`: restaurant
- `source_notes`: MICHELIN Vietnam 2025
- `target_hero_image`: HeroCityHanoiPlaceHibanaByKoki
- `legacy_summary`: Hibana by Koki is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect refined teppanyaki counter with chef hands and grill.
- `legacy_context`: For Hibana by Koki, Hanoi's restaurant story comes through house dishes, menu details, staff rhythm, and drinks, alongside Hanoi grill smoke and broth counters.
- `legacy_sections_compact`: Why go: Hibana by Koki is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi grill smoke and broth counters. | What you'll get: At Hibana by Koki, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: refined teppanyaki counter with chef hands and grill, with house dishes, menu details, staff rhythm, and drinks, alongside Hanoi grill smoke and broth counters. | Say it locally: Hibana by Koki usually stays as the venue name. Say it slowly and connect it to the scene around it: tables, house dishes, menu details, and staff rhythm, alongside Hanoi grill smoke and broth counters. | Worth it if: Worth it if the meal itself should be one of the day's memories: drinks, evening meal energy, tables, and house dishes, alongside Hanoi grill smoke and broth counters. | Before you go: Hibana by Koki works best when the name is tied to the reason for going, not memorized as an abstract label. Picture refined teppanyaki counter with chef hands and grill with drinks, evening meal energy, tables, and house dishes, alongside Hanoi grill smoke and broth counters.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-ho-chi-minh-mausoleum
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Lăng Bác
- `english_name`: Ho Chi Minh Mausoleum
- `place_kind`: landmark
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceHoChiMinhMausoleum
- `legacy_summary`: Ho Chi Minh Mausoleum is worth knowing in Hanoi because it brings civic memory, modern history, and the formal side of the capital into the trip. Expect respectful exterior of Ho Chi Minh Mausoleum from the square.
- `legacy_context`: For Ho Chi Minh Mausoleum, Hanoi's civic memorial story comes through respectful movement, broad squares, flags, and formal stone, alongside Ba Dinh's broad public space.
- `legacy_sections_compact`: Why go: Ho Chi Minh Mausoleum is worth knowing because it gives Hanoi a specific civic memorial scene: respectful movement, broad squares, flags, and formal stone, alongside Ba Dinh's broad public space. | What you'll get: At Ho Chi Minh Mausoleum, you get civic memory, modern history, and the formal side of the capital: respectful exterior of Ho Chi Minh Mausoleum from the square, with quiet lines, public memory, respectful movement, and broad squares, alongside Ba Dinh's broad public space. | Say it locally: Say Lăng Bác for Ho Chi Minh Mausoleum. The local name is easier to remember once it sits beside broad squares, flags, formal stone, and quiet lines, alongside Ba Dinh's broad public space. | Worth it if: Worth it if Ho Chi Minh Mausoleum gives your itinerary a clearer image: broad squares, flags, formal stone, and quiet lines, alongside Ba Dinh's broad public space. | Before you go: Ho Chi Minh Mausoleum works best when the name is tied to the reason for going, not memorized as an abstract label. Picture respectful exterior of Ho Chi Minh Mausoleum from the square with public memory, respectful movement, broad squares, and flags, alongside Ba Dinh's broad public space.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-ho-chi-minh-museum
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bảo tàng Hồ Chí Minh
- `english_name`: Ho Chi Minh Museum
- `place_kind`: museum
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceHoChiMinhMuseum
- `legacy_summary`: Ho Chi Minh Museum is worth a stop if you want Hanoi to feel more layered than the streets outside. Expect modern Ho Chi Minh Museum exterior, plaza, Vietnamese flags.
- `legacy_context`: For Ho Chi Minh Museum, Hanoi's cultural stop story comes through artifacts, quiet light, memory, and local history, alongside the cultural stops around old Hanoi.
- `legacy_sections_compact`: Why go: Ho Chi Minh Museum is worth a stop when you want more than scenery: rooms, objects, art, and memory inside the city's story, with display cases, gallery rooms, artifacts, and quiet light, alongside the cultural stops around old Hanoi. | What you'll get: At Ho Chi Minh Museum, you get rooms, objects, art, and memory inside the city's story: modern Ho Chi Minh Museum exterior, plaza, Vietnamese flags, with artifacts, quiet light, memory, and local history, alongside the cultural stops around old Hanoi. | Say it locally: Say Bảo tàng Hồ Chí Minh for Ho Chi Minh Museum. The local name is easier to remember once it sits beside quiet light, memory, local history, and display cases, alongside the cultural stops around old Hanoi. | Worth it if: Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: quiet light, memory, local history, and display cases, alongside the cultural stops around old Hanoi. | Before you go: Ho Chi Minh Museum works best when the name is tied to the reason for going, not memorized as an abstract label. Picture modern Ho Chi Minh Museum exterior, plaza, Vietnamese flags with local history, display cases, gallery rooms, and artifacts, alongside the cultural stops around old Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-hoa-lo-prison
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Nhà tù Hỏa Lò
- `english_name`: Hoa Lo Prison Relic
- `place_kind`: museum
- `source_notes`: Vietnam Travel Hanoi; Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceHoaLoPrison
- `legacy_summary`: Hoa Lo Prison Relic is worth a stop if you want Hanoi to feel more layered than the streets outside. Expect Hoa Lo Prison yellow exterior gate, quiet street.
- `legacy_context`: For Hoa Lo Prison Relic, Hanoi's cultural stop story comes through display cases, gallery rooms, artifacts, and quiet light, alongside the cultural stops around old Hanoi.
- `legacy_sections_compact`: Why go: Hoa Lo Prison Relic is worth a stop when you want more than scenery: rooms, objects, art, and memory inside the city's story, with display cases, gallery rooms, artifacts, and quiet light, alongside the cultural stops around old Hanoi. | What you'll get: At Hoa Lo Prison Relic, you get rooms, objects, art, and memory inside the city's story: Hoa Lo Prison yellow exterior gate, quiet street, with display cases, gallery rooms, artifacts, and quiet light, alongside the cultural stops around old Hanoi. | Say it locally: Say Nhà tù Hỏa Lò for Hoa Lo Prison Relic. The local name is easier to remember once it sits beside local history, display cases, gallery rooms, and artifacts, alongside the cultural stops around old Hanoi. | Worth it if: Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: quiet light, memory, local history, and display cases, alongside the cultural stops around old Hanoi. | Before you go: Hoa Lo Prison Relic works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hoa Lo Prison yellow exterior gate, quiet street with quiet light, memory, local history, and display cases, alongside the cultural stops around old Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-hoan-kiem
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Hồ Hoàn Kiếm
- `english_name`: Hoan Kiem Lake
- `place_kind`: nature
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceHoanKiemLake
- `legacy_summary`: Hoan Kiem Lake is worth knowing in Hanoi because it brings the city turning walkable around water instead of only traffic and streets into the trip. Expect Hoan Kiem Lake with Turtle Tower, red-flower trees, soft late-afternoon light.
- `legacy_context`: For Hoan Kiem Lake, Hanoi's lake story comes through cafe edges, shade, bridges, and neighborhood views, alongside the capital's old civic rhythm.
- `legacy_sections_compact`: Why go: Hoan Kiem Lake is worth knowing because it gives Hanoi a specific lake scene: water, walking paths, cafe edges, and shade, alongside the capital's old civic rhythm. | What you'll get: At Hoan Kiem Lake, you get the city turning walkable around water instead of only traffic and streets: Hoan Kiem Lake with Turtle Tower, red-flower trees, soft late-afternoon light, with bridges, neighborhood views, water, and walking paths, alongside the capital's old civic rhythm. | Say it locally: Say Hồ Hoàn Kiếm for Hoan Kiem Lake. The local name is easier to remember once it sits beside neighborhood views, water, walking paths, and cafe edges, alongside the capital's old civic rhythm. | Worth it if: Worth it if Hoan Kiem Lake gives your itinerary a clearer image: neighborhood views, water, walking paths, and cafe edges, alongside the capital's old civic rhythm. | Before you go: Hoan Kiem Lake works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hoan Kiem Lake with Turtle Tower, red-flower trees, soft late-afternoon light with neighborhood views, water, walking paths, and cafe edges, alongside the capital's old civic rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hanoi-place-hom-market
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chợ Hôm
- `english_name`: Hom Market
- `place_kind`: market
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceHomMarket
- `legacy_summary`: Hom Market is worth browsing because it shows Hanoi through stalls, snacks, goods, color, and everyday buying rhythm. Expect fabric stalls inside Hom Market, bolts of cloth, fluorescent local-market light.
- `legacy_context`: For Hom Market, Hanoi's market story comes through snack counters, bargaining rhythm, bags, and local shopping movement, alongside the capital's produce-and-stall rhythm.
- `legacy_sections_compact`: Why go: Hom Market is worth browsing because it shows everyday Hanoi: snack counters, bargaining rhythm, bags, and local shopping movement, alongside the capital's produce-and-stall rhythm. | What you'll get: At Hom Market, you get everyday shopping, snacks, gifts, bargaining, and local rhythm: fabric stalls inside Hom Market, bolts of cloth, fluorescent local-market light, with bags, local shopping movement, market aisles, and produce colors, alongside the capital's produce-and-stall rhythm. | Say it locally: Say Chợ Hôm for Hom Market. The local name is easier to remember once it sits beside bargaining rhythm, bags, local shopping movement, and market aisles, alongside the capital's produce-and-stall rhythm. | Worth it if: Worth it if you like seeing daily life through browsing, snacks, color, small goods, and local rhythm: bargaining rhythm, bags, local shopping movement, and market aisles, alongside the capital's produce-and-stall rhythm. | Before you go: Hom Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture fabric stalls inside Hom Market, bolts of cloth, fluorescent local-market light with bargaining rhythm, bags, local shopping movement, and market aisles, alongside the capital's produce-and-stall rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hanoi-place-imperial-citadel
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Hoàng thành Thăng Long
- `english_name`: Imperial Citadel of Thang Long
- `place_kind`: landmark
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceImperialCitadel
- `legacy_summary`: Imperial Citadel of Thang Long is worth visiting because it makes history physical through architecture, gates, courtyards, and memory. Expect ancient citadel gate and brick courtyard, warm Hanoi daylight.
- `legacy_context`: For Imperial Citadel of Thang Long, Hanoi's heritage landmark story comes through stone paths, tiled roofs, ceremonial space, and old walls, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: Imperial Citadel of Thang Long is worth visiting because it makes history physical: stone paths, tiled roofs, ceremonial space, and old walls, alongside old-lane Hanoi. | What you'll get: At Imperial Citadel of Thang Long, you get history made physical in architecture, ceremony, and place memory: ancient citadel gate and brick courtyard, warm Hanoi daylight, with stone paths, tiled roofs, ceremonial space, and old walls, alongside old-lane Hanoi. | Say it locally: Say Hoàng thành Thăng Long for Imperial Citadel of Thang Long. The local name is easier to remember once it sits beside tiled roofs, ceremonial space, old walls, and gates, alongside old-lane Hanoi. | Worth it if: Worth it if old walls, gates, courtyards, and public memory are part of the trip you want: tiled roofs, ceremonial space, old walls, and gates, alongside old-lane Hanoi. | Before you go: Imperial Citadel of Thang Long works best when the name is tied to the reason for going, not memorized as an abstract label. Picture ancient citadel gate and brick courtyard, warm Hanoi daylight with old walls, gates, courtyards, and stone paths, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hanoi-place-lam-cafe
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Cà phê Lâm
- `english_name`: Lam Cafe
- `place_kind`: cafe
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceLamCafe
- `legacy_summary`: Lam Cafe is worth saving for Hanoi's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect old Hanoi cafe interior with framed paintings and black coffee.
- `legacy_context`: For Lam Cafe, Hanoi's cafe story comes through cafe views, coffee counters, iced glasses, and street stools, alongside old-quarter cafe rhythm.
- `legacy_sections_compact`: Why go: Lam Cafe is worth saving when you want Hanoi's cafe culture, not just caffeine: cafe views, coffee counters, iced glasses, and street stools, alongside old-quarter cafe rhythm. | What you'll get: At Lam Cafe, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: old Hanoi cafe interior with framed paintings and black coffee, with design details, soft pauses, cafe views, and coffee counters, alongside old-quarter cafe rhythm. | Say it locally: Say Cà phê Lâm for Lam Cafe. The local name is easier to remember once it sits beside coffee counters, iced glasses, street stools, and design details, alongside old-quarter cafe rhythm. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: soft pauses, cafe views, coffee counters, and iced glasses, alongside old-quarter cafe rhythm. | Before you go: Lam Cafe works best when the name is tied to the reason for going, not memorized as an abstract label. Picture old Hanoi cafe interior with framed paintings and black coffee with coffee counters, iced glasses, street stools, and design details, alongside old-quarter cafe rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hanoi-place-lamai-garden
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Lamai Garden
- `english_name`: Lamai Garden
- `place_kind`: restaurant
- `source_notes`: MICHELIN Vietnam 2025
- `target_hero_image`: HeroCityHanoiPlaceLamaiGarden
- `legacy_summary`: Lamai Garden is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect Garden path leading to contemporary Vietnamese restaurant, herbs and warm interior.
- `legacy_context`: For Lamai Garden, Hanoi's restaurant story comes through house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's garden-side calm.
- `legacy_sections_compact`: Why go: Lamai Garden is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with evening meal energy, tables, house dishes, and menu details, alongside Hanoi's garden-side calm. | What you'll get: At Lamai Garden, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: Garden path leading to contemporary Vietnamese restaurant, herbs and warm interior, with house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's garden-side calm. | Say it locally: Lamai Garden usually stays as the venue name. Say it slowly and connect it to the scene around it: drinks, evening meal energy, tables, and house dishes, alongside Hanoi's garden-side calm. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi's garden-side calm. | Before you go: Lamai Garden works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Garden path leading to contemporary Vietnamese restaurant, herbs and warm interior with drinks, evening meal energy, tables, and house dishes, alongside Hanoi's garden-side calm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hanoi-place-lenin-park
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Công viên Lê Nin
- `english_name`: Lenin Park
- `place_kind`: park
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceLeninPark
- `legacy_summary`: Lenin Park is worth knowing in Hanoi because it brings everyday city life in open air without a formal attraction into the trip. Expect small Hanoi park with statue plaza and shade trees.
- `legacy_context`: For Lenin Park, Hanoi's park story comes through family time, shade, open lawns, and evening light, alongside Hanoi's garden-side calm.
- `legacy_sections_compact`: Why go: Lenin Park is worth knowing because it gives Hanoi a specific park scene: walking paths, trees, family time, and shade, alongside Hanoi's garden-side calm. | What you'll get: At Lenin Park, you get everyday city life in open air without a formal attraction: small Hanoi park with statue plaza and shade trees, with family time, shade, open lawns, and evening light, alongside Hanoi's garden-side calm. | Say it locally: Say Công viên Lê Nin for Lenin Park. The local name is easier to remember once it sits beside evening light, walking paths, trees, and family time, alongside Hanoi's garden-side calm. | Worth it if: Worth it if Lenin Park gives your itinerary a clearer image: evening light, walking paths, trees, and family time, alongside Hanoi's garden-side calm. | Before you go: Lenin Park works best when the name is tied to the reason for going, not memorized as an abstract label. Picture small Hanoi park with statue plaza and shade trees with trees, family time, shade, and open lawns, alongside Hanoi's garden-side calm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

