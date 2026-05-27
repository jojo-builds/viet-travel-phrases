# SpeakLocal v2.2 BATCH_011 - Hue A - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_011` in the final handoff block. Put `SpeakLocal v2.2 BATCH_011 - Hue A - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hue-place-an-cuu-market
- `city_id`: hue
- `city_name`: Hue
- `vietnamese_name`: Chợ An Cựu
- `english_name`: An Cuu Market
- `place_kind`: market
- `source_notes`: References: existing city library; Hue tourism portal specialities.
- `target_hero_image`: HeroCityHuePlaceAnCuuMarket
- `legacy_summary`: An Cuu Market is worth browsing because it shows Hue through stalls, snacks, goods, color, and everyday buying rhythm. Expect Hue market entry area with fresh herbs, scooters, and everyday shoppers.
- `legacy_context`: For An Cuu Market, Hue's market story comes through snack counters, bargaining rhythm, bags, and local shopping movement, alongside citadel-side Hue.
- `legacy_sections_compact`: Why go: An Cuu Market is worth browsing because it shows everyday Hue: bags, local shopping movement, market aisles, and produce colors, alongside citadel-side Hue. | What you'll get: At An Cuu Market, you get everyday shopping, snacks, gifts, bargaining, and local rhythm: Hue market entry area with fresh herbs, scooters, and everyday shoppers, with market aisles, produce colors, snack counters, and bargaining rhythm, alongside citadel-side Hue. | Say it locally: Say Chợ An Cựu for An Cuu Market. The local name is easier to remember once it sits beside local shopping movement, market aisles, produce colors, and snack counters, alongside citadel-side Hue. | Worth it if: Worth it if you like seeing daily life through browsing, snacks, color, small goods, and local rhythm: bargaining rhythm, bags, local shopping movement, and market aisles, alongside citadel-side Hue. | Before you go: An Cuu Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hue market entry area with fresh herbs, scooters, and everyday shoppers with bargaining rhythm, bags, local shopping movement, and market aisles, alongside citadel-side Hue.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hue-place-an-hien-garden-house
- `city_id`: hue
- `city_name`: Hue
- `vietnamese_name`: Nhà vườn An Hiên
- `english_name`: An Hien Garden House
- `place_kind`: landmark
- `source_notes`: References: Hue tourism portal famous places.
- `target_hero_image`: HeroCityHuePlaceAnHienGardenHouse
- `legacy_summary`: An Hien Garden House is worth knowing in Hue because it brings architecture, views, local pride, and history in visual form into the trip. Expect Hue garden-house gate with old trees, tiled roof, and quiet path.
- `legacy_context`: For An Hien Garden House, Hue's landmark story comes through landmark memory, architecture, views, and local pride, alongside Hue river-city memory.
- `legacy_sections_compact`: Why go: An Hien Garden House is worth knowing because it gives Hue a specific landmark scene: history, city light, landmark memory, and architecture, alongside Hue river-city memory. | What you'll get: At An Hien Garden House, you get architecture, views, local pride, and history in visual form: Hue garden-house gate with old trees, tiled roof, and quiet path, with landmark memory, architecture, views, and local pride, alongside Hue river-city memory. | Say it locally: Say Nhà vườn An Hiên for An Hien Garden House. The local name is easier to remember once it sits beside architecture, views, local pride, and history, alongside Hue river-city memory. | Worth it if: Worth it if An Hien Garden House gives your itinerary a clearer image: city light, landmark memory, architecture, and views, alongside Hue river-city memory. | Before you go: An Hien Garden House works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hue garden-house gate with old trees, tiled roof, and quiet path with architecture, views, local pride, and history, alongside Hue river-city memory.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hue-place-ancient-hue-gallery-cuisine
- `city_id`: hue
- `city_name`: Hue
- `vietnamese_name`: Ancient Hue Gallery Cuisine
- `english_name`: Ancient Hue Gallery Cuisine
- `place_kind`: restaurant
- `source_notes`: References: Hue tourism portal restaurants.
- `target_hero_image`: HeroCityHuePlaceAncientHueGalleryCuisine
- `legacy_summary`: Ancient Hue Gallery Cuisine is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect refined Hue dining room with court-style plating, dark timber, and subtle royal motifs.
- `legacy_context`: For Ancient Hue Gallery Cuisine, Hue's restaurant story comes through staff rhythm, drinks, evening meal energy, and tables, alongside Hue river-city memory.
- `legacy_sections_compact`: Why go: Ancient Hue Gallery Cuisine is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with staff rhythm, drinks, evening meal energy, and tables, alongside Hue river-city memory. | What you'll get: At Ancient Hue Gallery Cuisine, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: refined Hue dining room with court-style plating, dark timber, and subtle royal motifs, with staff rhythm, drinks, evening meal energy, and tables, alongside Hue river-city memory. | Say it locally: Ancient Hue Gallery Cuisine usually stays as the venue name. Say it slowly and connect it to the scene around it: drinks, evening meal energy, tables, and house dishes, alongside Hue river-city memory. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside Hue river-city memory. | Before you go: Ancient Hue Gallery Cuisine works best when the name is tied to the reason for going, not memorized as an abstract label. Picture refined Hue dining room with court-style plating, dark timber, and subtle royal motifs with tables, house dishes, menu details, and staff rhythm, alongside Hue river-city memory.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hue-place-ancient-hue-restaurant
- `city_id`: hue
- `city_name`: Hue
- `vietnamese_name`: Ancient Hue Restaurant
- `english_name`: Ancient Hue Restaurant
- `place_kind`: restaurant
- `source_notes`: References: Hue tourism portal restaurants.
- `target_hero_image`: HeroCityHuePlaceAncientHueRestaurant
- `legacy_summary`: Ancient Hue Restaurant is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect Hue garden restaurant with ruong-house timber, lanterns, and set table.
- `legacy_context`: For Ancient Hue Restaurant, Hue's restaurant story comes through house dishes, menu details, staff rhythm, and drinks, alongside imperial Hue.
- `legacy_sections_compact`: Why go: Ancient Hue Restaurant is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with staff rhythm, drinks, evening meal energy, and tables, alongside imperial Hue. | What you'll get: At Ancient Hue Restaurant, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: Hue garden restaurant with ruong-house timber, lanterns, and set table, with staff rhythm, drinks, evening meal energy, and tables, alongside imperial Hue. | Say it locally: Ancient Hue Restaurant usually stays as the venue name. Say it slowly and connect it to the scene around it: drinks, evening meal energy, tables, and house dishes, alongside imperial Hue. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside imperial Hue. | Before you go: Ancient Hue Restaurant works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hue garden restaurant with ruong-house timber, lanterns, and set table with menu details, staff rhythm, drinks, and evening meal energy, alongside imperial Hue.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hue-place-ancient-space-restaurant
- `city_id`: hue
- `city_name`: Hue
- `vietnamese_name`: Không gian xưa
- `english_name`: Ancient Space Restaurant
- `place_kind`: restaurant
- `source_notes`: References: Hue tourism portal restaurants.
- `target_hero_image`: HeroCityHuePlaceAncientSpaceRestaurant
- `legacy_summary`: Ancient Space Restaurant is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect ruong-house restaurant compound with tiled roof, garden path, and Hue meal setting.
- `legacy_context`: For Ancient Space Restaurant, Hue's restaurant story comes through evening meal energy, tables, house dishes, and menu details, alongside royal-city memory.
- `legacy_sections_compact`: Why go: Ancient Space Restaurant is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with house dishes, menu details, staff rhythm, and drinks, alongside royal-city memory. | What you'll get: At Ancient Space Restaurant, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: ruong-house restaurant compound with tiled roof, garden path, and Hue meal setting, with evening meal energy, tables, house dishes, and menu details, alongside royal-city memory. | Say it locally: Say Không gian xưa for Ancient Space Restaurant. The local name is easier to remember once it sits beside tables, house dishes, menu details, and staff rhythm, alongside royal-city memory. | Worth it if: Worth it if the meal itself should be one of the day's memories: drinks, evening meal energy, tables, and house dishes, alongside royal-city memory. | Before you go: Ancient Space Restaurant works best when the name is tied to the reason for going, not memorized as an abstract label. Picture ruong-house restaurant compound with tiled roof, garden path, and Hue meal setting with tables, house dishes, menu details, and staff rhythm, alongside royal-city memory.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
