# SpeakLocal v2.2 BATCH_016 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_016` in the final handoff block. Put `SpeakLocal v2.2 BATCH_016 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Batch 003-012 audit tightening for this run:
- Keep phrase cards to 2-3, and only use ready-audio reusable traveler-action phrases. Place-name audio is pronunciation/name support by default, not a visible phrase card.
- Do not create one-off phrases for a single attraction, restaurant, dish, or object. Mark them as hidden/planned instead.
- Visible copy must not say `useful because`, `reference line`, `destination`, `anchor`, `content role`, `this page helps`, or `the job is`.
- Vary headings. Do not default to `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`. If two headings in this batch share that scaffold, revise one before final.
- Write travel copy, not a database note. Short, observed, specific, calm.
- If current venue facts might be stale, keep that risk in internal source/freshness notes instead of visible copy.
- If you cannot produce the full batch, output `BLOCKED_STUB` and the blocker instead of a partial response.

# New Chat Prompt for This Project

Pick 5 city listings from the ledger whose status is `not_started` or `voice_rejected_rewrite`. Use 10 only when Jojo asks or all listings are easy/low-research. If Codex provides an exact claimed batch list, use those rows only and do not pick replacements.

Before writing, read:
- the v2.2 Source Bundle,
- the Copy Ledger and Catalogs spreadsheet,
- the Canonical 31 examples inside the source bundle,
- the Phrase Picker Ready Audio tab,
- the Menu Catalog tab if any listing is food, drink, cafe, restaurant, dessert, market, or shop related.

For each listing, write one v2.2 app-detail draft. Use existing ready-audio phrase IDs when possible. Use existing menu/catalog items when natural. Do not invent facts. Do not write like a QA form.

Output in a readable review format first, not JSON. Start with a clean reader view that contains only app-visible copy. Put schema fields, self-score, QA, source notes, freshness notes, phrase/audio status, and Mentioned Here mapping after the reader view.

Self-score each draft against v2.2 voice and revise the weakest visible lines before final output. The score is an internal drafting aid only; the output remains draft/review material for later Jojo/Codex approval, import, and production validation.

Batch 003-012 audit tightening:
- Phrase cards are for reusable traveler actions, not place-name recognition. Even if a place-name audio row exists, keep it as pronunciation/name support unless the traveler would naturally say that exact name to staff or a driver in this moment and no reusable ready-audio phrase fits.
- Vary headings. Do not default to `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`. If two headings in a batch share that scaffold, revise one before final.
- If a score is below 28/30, or if the first screen sounds like a planning database, revise the visible heading and first paragraph once before outputting the final answer.
- Keep public URLs and `utm_source=chatgpt.com` links out of the final batch unless explicitly requested. Source labels are enough for review.
- If the session cannot output the full batch, say `BLOCKED_STUB` and why instead of giving a partial response.

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

### 1. city-danang-place-domestic-terminal
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Nhà ga quốc nội Đà Nẵng
- `english_name`: Da Nang Domestic Terminal
- `place_kind`: airport
- `source_notes`: Airport and transport sources.
- `target_hero_image`: HeroCityDanangPlaceDomesticTerminal
- `legacy_summary`: Da Nang Domestic arrival hall is a first glimpse of the coastal city returning home to itself: Vietnamese signs, families with bags, warm air outside the doors, and the beach road waiting beyond the airport.
- `legacy_context`: For Da Nang Domestic arrival hall, Da Nang's arrival story comes through waiting halls, the first local name, arrival doors, and city signs, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: This is a quieter arrival scene inside Da Nang: domestic visitors, short flights, local signs, and the feeling that the city is close enough to begin almost immediately. | What you'll get: Da Nang Domestic arrival hall matters because even a simple airport sub-place can make the first minutes feel oriented, local, and connected to the coastal city outside. | Say it locally: Say Nhà ga quốc nội Đà Nẵng for Da Nang Domestic arrival hall. The local name is easier to remember once it sits beside first roads, waiting halls, the first local name, and arrival doors, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if Da Nang Domestic arrival hall gives your itinerary a clearer image: city signs, warm air, first roads, and waiting halls, alongside Da Nang's seafood-and-mountain day. | Before you go: Da Nang Domestic arrival hall works best when the name is tied to the reason for going, not memorized as an abstract label. Picture arrival hall doors, warm air, local signs, and the first road into the city with the first local name, arrival doors, city signs, and warm air, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-dong-dinh-museum
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bảo tàng Đồng Đình
- `english_name`: Dong Dinh Museum
- `place_kind`: museum
- `source_notes`: Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceDongDinhMuseum
- `legacy_summary`: Dong Dinh Museum is a private garden-house stop on the Sơn Trà side of Đà Nẵng, good for shade, old houses, ceramics, fishing-life objects, and a slower cultural pause.
- `legacy_context`: Dong Dinh Museum is a private garden-house stop on the Sơn Trà side of Đà Nẵng. Go for shade, old houses, ceramics, fishing-life objects, and a slower pause before or after Lady Buddha, not a checklist museum hour.
- `legacy_sections_compact`: Quiet Culture On Sơn Trà: Dong Dinh Museum is a private garden-house stop on the Sơn Trà side of Đà Nẵng. Go for shade, old houses, ceramics, fishing-life objects, and a slower pause before or after Lady Buddha, not a checklist museum hour. | Useful Phrases:  | Garden First, Gallery Second: The first memory may be trees, stone, water, and shade before any display case. That retreat from beach-and-bridge traffic is part of the visit. | Two Stories Are Enough: Move slowly enough to notice old house materials, ceramic pieces, fishing-life objects, and ethnography rooms. A short visit works better when you choose two threads instead of trying to read every label. | Best As A Peninsula Pairing: It fits best into a Sơn Trà or Lady Buddha route. Crossing town just for one small museum can feel thin unless quiet is the reason you came.
- `notes`: 2026-05-24 pilot was mechanically/native validated, but Jojo rejected the voice; rewrite before import.

### 3. city-danang-place-dragon-bridge
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cầu Rồng
- `english_name`: Dragon Bridge
- `place_kind`: landmark
- `source_notes`: City library; Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceDragonBridge
- `legacy_summary`: Dragon Bridge is the Đà Nẵng landmark with one useful choice: stand close for spray and crowd energy, or stay on the riverbank for the cleaner view of the dragon and skyline.
- `legacy_context`: Dragon Bridge makes sense as a riverfront decision, especially on show nights when timing, side choice, and crowd position matter more than the bridge facts.
- `legacy_sections_compact`: Choose Dry Or Close: Dragon Bridge is easy to overcomplicate. Stand near the bridge if spray is part of the fun; stay on the riverbank for the cleaner dragon-head view. | Better From The Riverbank: The bridge itself is traffic and crowds. The riverbank gives you the skyline, reflections, and enough distance to understand the dragon shape. | Useful Phrases:  | Arrive Before The Show: On show nights, choose your side before phones fill the rail. The close view is more physical; the promenade view is easier to photograph. | A Riverfront Connector: Dragon Bridge pairs naturally with the Hàn River walk, Love Bridge, or Sơn Trà Night Market. It is a short civic ritual, not a whole evening by itself.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-dragon-bridge-fire-show
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Màn phun lửa Cầu Rồng
- `english_name`: Dragon Bridge fire show
- `place_kind`: experience
- `source_notes`: Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceDragonBridgeFireShow
- `legacy_summary`: The Dragon Bridge fire show is Da Nang's riverfront spectacle: crowds along the Han River, the dragon head glowing after dark, and bursts of fire and water over the bridge.
- `legacy_context`: The Dragon Bridge fire show brings Da Nang's riverfront energy into focus through crowds, bridge lights, scooters, skyline, and bursts of fire and water.
- `legacy_sections_compact`: Why go: This is not a theater night, it is the city gathering outside, with river railings, scooters, families, skyline lights, and the bridge turning into the show. | What you'll get: The fire show matters because it turns Da Nang's most recognizable bridge into a shared weekend ritual, part landmark, part street gathering, part skyline memory. | Say it locally: Say Màn phun lửa Cầu Rồng for Dragon Bridge fire show. The local name is easier to remember once it sits beside evening streets, cultural memory, stage light, and music, alongside coastal Da Nang. | Worth it if: worth it if you want riverfront waiting, evening crowds, bridge views, photos, scooters, skyline lights, and the sudden fire-and-water burst. | Before you go: Rồng phun lửa belongs beside Han River crowds, evening bridge light, and the shared moment when Da Nang looks up at the dragon. Picture Dragon Bridge breathing fire from a riverfront promenade, crowd silhouettes.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-dragon-carp-statue
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Tượng Cá Chép Hóa Rồng
- `english_name`: Dragon Carp Statue
- `place_kind`: landmark
- `source_notes`: Da Nang Fantasticity; local map.
- `target_hero_image`: HeroCityDanangPlaceDragonCarpStatue
- `legacy_summary`: Dragon Carp Statue is worth knowing in Da Nang because it brings architecture, views, local pride, and history in visual form into the trip. Expect dragon-carp statue fountain by Han River with bridge lights behind, evening.
- `legacy_context`: For Dragon Carp Statue, Da Nang's landmark story comes through local pride, history, city light, and landmark memory, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: Dragon Carp Statue is worth knowing because it gives Da Nang a specific landmark scene: city light, landmark memory, architecture, and views, alongside central-Vietnam beach rhythm. | What you'll get: At Dragon Carp Statue, you get architecture, views, local pride, and history in visual form: dragon-carp statue fountain by Han River with bridge lights behind, evening, with city light, landmark memory, architecture, and views, alongside central-Vietnam beach rhythm. | Say it locally: Say Tượng Cá Chép Hóa Rồng for Dragon Carp Statue. The local name is easier to remember once it sits beside history, city light, landmark memory, and architecture, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if Dragon Carp Statue gives your itinerary a clearer image: views, local pride, history, and city light, alongside central-Vietnam beach rhythm. | Before you go: Dragon Carp Statue works best when the name is tied to the reason for going, not memorized as an abstract label. Picture dragon-carp statue fountain by Han River with bridge lights behind, evening with views, local pride, history, and city light, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

