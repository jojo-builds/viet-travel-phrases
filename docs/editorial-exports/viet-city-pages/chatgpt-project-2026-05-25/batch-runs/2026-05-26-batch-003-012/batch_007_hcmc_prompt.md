# SpeakLocal v2.2 BATCH_007 - Saigon A - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_007` in the final handoff block. Put `SpeakLocal v2.2 BATCH_007 - Saigon A - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Extra anti-drift constraints for this 50-listing test:
- Keep phrase cards to 2-3, and only use ready-audio reusable phrases unless a place-name phrase already has ready audio.
- Do not create one-off phrases for a single attraction, restaurant, or object. Mark them as hidden/planned instead.
- Visible copy must not say `useful because`, `reference line`, `destination`, `anchor`, `content role`, `this page helps`, or `the job is`.
- Write travel copy, not a database note. Short, observed, specific, calm.
- If current venue facts might be stale, keep that risk in internal source/freshness notes instead of visible copy.

# New Chat Prompt for This Project

Use the five city listings in the `Exact batch rows` section below. They have already been claimed for this batch; do not select different rows from the ledger.

Before writing, read:
- the v2.2 Source Bundle,
- the Copy Ledger and Catalogs spreadsheet,
- the Canonical 31 examples inside the source bundle,
- the Phrase Picker Ready Audio tab,
- the Menu Catalog tab if any listing is food, drink, cafe, restaurant, dessert, market, or shop related.

For each listing, write one v2.2 app-detail draft. Use existing ready-audio phrase IDs when possible. Use existing menu/catalog items when natural. Do not invent facts. Do not write like a QA form.

Output in a readable review format first, not JSON. Start with a clean reader view that contains only app-visible copy. Put schema fields, self-score, QA, source notes, freshness notes, phrase/audio status, and Mentioned Here mapping after the reader view.

Self-score each draft against v2.2 voice and revise the weakest visible lines before final output. The score is an internal drafting aid only; the output remains draft/review material for later Jojo/Codex approval, import, and production validation.

Do not rely on Google Drive write access. Output the full batch directly in this chat. A Google Doc is optional; Codex will create or update the readable review doc from the chat output.

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

### 1. city-hcmc-place-akuna
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Akuna
- `english_name`: Akuna
- `place_kind`: restaurant
- `source_notes`: MICHELIN Vietnam 2025; MICHELIN HCMC guide
- `target_hero_image`: HeroCityHcmcPlaceAkuna
- `legacy_summary`: Akuna is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect fine-dining counter with Vietnamese ingredients, polished Saigon interior.
- `legacy_context`: For Akuna, Saigon's restaurant story comes through evening meal energy, tables, house dishes, and menu details, alongside Saigon street energy.
- `legacy_sections_compact`: Why go: Akuna is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with house dishes, menu details, staff rhythm, and drinks, alongside Saigon street energy. | What you'll get: At Akuna, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: fine-dining counter with Vietnamese ingredients, polished Saigon interior, with staff rhythm, drinks, evening meal energy, and tables, alongside Saigon street energy. | Say it locally: Akuna usually stays as the venue name. Say it slowly and connect it to the scene around it: menu details, staff rhythm, drinks, and evening meal energy, alongside Saigon street energy. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside Saigon street energy. | Before you go: Akuna works best when the name is tied to the reason for going, not memorized as an abstract label. Picture fine-dining counter with Vietnamese ingredients, polished Saigon interior with tables, house dishes, menu details, and staff rhythm, alongside Saigon street energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hcmc-place-an-dong-market
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Chợ An Đông
- `english_name`: An Dong Market
- `place_kind`: market
- `source_notes`: Visit HCMC portal
- `target_hero_image`: HeroCityHcmcPlaceAnDongMarket
- `legacy_summary`: An Dong Market is worth knowing in Saigon because it brings shopping culture built around clothes, fabric, gifts, small counters, and browsing into the trip. Expect multi-level local market with fabric and clothing stalls, Saigon.
- `legacy_context`: For An Dong Market, Saigon's shopping market story comes through small counters, bags, gifts, and browsing lanes, alongside Saigon street energy.
- `legacy_sections_compact`: Why go: An Dong Market is worth knowing because it gives Saigon a specific shopping market scene: gifts, browsing lanes, clothing racks, and fabric stacks, alongside Saigon street energy. | What you'll get: At An Dong Market, you get shopping culture built around clothes, fabric, gifts, small counters, and browsing: multi-level local market with fabric and clothing stalls, Saigon, with gifts, browsing lanes, clothing racks, and fabric stacks, alongside Saigon street energy. | Say it locally: Say Chợ An Đông for An Dong Market. The local name is easier to remember once it sits beside browsing lanes, clothing racks, fabric stacks, and small counters, alongside Saigon street energy. | Worth it if: Worth it if An Dong Market gives your itinerary a clearer image: bags, gifts, browsing lanes, and clothing racks, alongside Saigon street energy. | Before you go: An Dong Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture multi-level local market with fabric and clothing stalls, Saigon with browsing lanes, clothing racks, fabric stacks, and small counters, alongside Saigon street energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hcmc-place-anan-saigon
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Anăn Sài Gòn
- `english_name`: Anan Saigon
- `place_kind`: restaurant
- `source_notes`: existing-city-library; MICHELIN Vietnam 2025
- `target_hero_image`: HeroCityHcmcPlaceAnanSaigon
- `legacy_summary`: Anan Saigon is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect contemporary Vietnamese restaurant table with herbs and small plates.
- `legacy_context`: For Anan Saigon, Saigon's restaurant story comes through house dishes, menu details, staff rhythm, and drinks, alongside Ben Thanh market energy.
- `legacy_sections_compact`: Why go: Anan Saigon is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with evening meal energy, tables, house dishes, and menu details, alongside Ben Thanh market energy. | What you'll get: At Anan Saigon, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: contemporary Vietnamese restaurant table with herbs and small plates, with evening meal energy, tables, house dishes, and menu details, alongside Ben Thanh market energy. | Say it locally: Say Anăn Sài Gòn for Anan Saigon. The local name is easier to remember once it sits beside tables, house dishes, menu details, and staff rhythm, alongside Ben Thanh market energy. | Worth it if: Worth it if the meal itself should be one of the day's memories: drinks, evening meal energy, tables, and house dishes, alongside Ben Thanh market energy. | Before you go: Anan Saigon works best when the name is tied to the reason for going, not memorized as an abstract label. Picture contemporary Vietnamese restaurant table with herbs and small plates with tables, house dishes, menu details, and staff rhythm, alongside Ben Thanh market energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hcmc-place-ao-dai-museum
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bảo tàng Áo Dài
- `english_name`: Ao Dai Museum
- `place_kind`: museum
- `source_notes`: Visit HCMC portal; Ao Dai Museum named-place source
- `target_hero_image`: HeroCityHcmcPlaceAoDaiMuseum
- `legacy_summary`: Ao Dai Museum is worth a stop if you want Saigon to feel more layered than the streets outside. Expect Ao dai display in garden-like museum space, colorful silk.
- `legacy_context`: For Ao Dai Museum, Saigon's cultural stop story comes through display cases, gallery rooms, artifacts, and quiet light, alongside Ben Thanh market energy.
- `legacy_sections_compact`: Why go: Ao Dai Museum is worth a stop when you want more than scenery: rooms, objects, art, and memory inside the city's story, with display cases, gallery rooms, artifacts, and quiet light, alongside Ben Thanh market energy. | What you'll get: At Ao Dai Museum, you get rooms, objects, art, and memory inside the city's story: Ao dai display in garden-like museum space, colorful silk, with display cases, gallery rooms, artifacts, and quiet light, alongside Ben Thanh market energy. | Say it locally: Say Bảo tàng Áo Dài for Ao Dai Museum. The local name is easier to remember once it sits beside quiet light, memory, local history, and display cases, alongside Ben Thanh market energy. | Worth it if: Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: gallery rooms, artifacts, quiet light, and memory, alongside Ben Thanh market energy. | Before you go: Ao Dai Museum works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Ao dai display in garden-like museum space, colorful silk with local history, display cases, gallery rooms, and artifacts, alongside Ben Thanh market energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hcmc-place-bach-dang-waterbus-station
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bến tàu thủy Bạch Đằng
- `english_name`: Bach Dang Waterbus Station
- `place_kind`: port
- `source_notes`: Visit HCMC portal
- `target_hero_image`: HeroCityHcmcPlaceBachDangWaterbusStation
- `legacy_summary`: Bach Dang Waterbus Station is worth knowing in Saigon because it brings the city opening onto a river route rather than a road route into the trip. Expect river steps, boat noses, skyline edges, and the change from street movement to water movement.
- `legacy_context`: For Bach Dang Waterbus Station, Saigon's river landing story comes through bridges, skyline views, waterfront movement, and river steps, alongside Saigon river lights.
- `legacy_sections_compact`: Why go: Bach Dang Waterbus Station is worth knowing because it gives Saigon a specific river landing scene: bridges, skyline views, waterfront movement, and river steps, alongside Saigon river lights. | What you'll get: At Bach Dang Waterbus Station, you get the city opening onto a river route rather than a road route: river steps, boat noses, skyline edges, and the change from street movement to water movement, with boarding points, boats, bridges, and skyline views, alongside Saigon river lights. | Say it locally: Say Bến tàu thủy Bạch Đằng for Bach Dang Waterbus Station. The local name is easier to remember once it sits beside river steps, boarding points, boats, and bridges, alongside Saigon river lights. | Worth it if: Worth it if Bach Dang Waterbus Station gives your itinerary a clearer image: river steps, boarding points, boats, and bridges, alongside Saigon river lights. | Before you go: Bach Dang Waterbus Station works best when the name is tied to the reason for going, not memorized as an abstract label. Picture river steps, boat noses, skyline edges, and the change from street movement to water movement with river steps, boarding points, boats, and bridges, alongside Saigon river lights.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
