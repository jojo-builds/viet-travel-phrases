# SpeakLocal v2.2 BATCH_009 - Hoi An A - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_009` in the final handoff block. Put `SpeakLocal v2.2 BATCH_009 - Hoi An A - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hoian-place-an-bang
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Biển An Bàng
- `english_name`: An Bang Beach
- `place_kind`: beach
- `source_notes`: Existing city-library; Vietnam Tourism Hoi An.
- `target_hero_image`: HeroCityHoianPlaceAnBangBeach
- `legacy_summary`: An Bang Beach is Hoi An's easy coast escape: sand, basket boats, seafood shacks, and sea air after the lantern streets and old-town crowds.
- `legacy_context`: An Bang Beach matters because it widens Hoi An beyond the Ancient Town. The day can shift from yellow walls and tailor shops to waves, sand, and a slower seafood lunch.
- `legacy_sections_compact`: Why go: An Bang Beach is worth picturing because it gives Hoi An a sea-air pause after the old-town lanes. It is the easy beach name to know for sand, basket boats, and a slower coastal meal. | What you'll get: Expect a relaxed beach edge with gentle waves, basket boats, seafood places, sun beds, and morning light. It feels more open and breezy than the Ancient Town. | Say it locally: Say Biển An Bàng for An Bang Beach. Biển means beach or sea, so the first word helps you hear why this name belongs to the coast. | Worth it if: Worth it if you want a simple beach break without leaving the Hoi An area. It is especially good for morning swims, seafood, or a lazy afternoon. | Before you go: Before you go, think of An Bang as a change of pace rather than a landmark checklist stop. Sunscreen, sandals, and a flexible lunch plan matter more than timing it perfectly.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hoian-place-an-hoi-island
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Đảo An Hội
- `english_name`: An Hoi Island
- `place_kind`: neighborhood
- `source_notes`: Existing city-library; Hoi An local references.
- `target_hero_image`: HeroCityHoianPlaceAnHoiIsland
- `legacy_summary`: An Hoi Island is worth recognizing because neighborhoods turn Hoi An from landmarks into lived-in areas. Expect lantern-lit riverside island street with low buildings.
- `legacy_context`: For An Hoi Island, Hoi An's neighborhood story comes through neighborhood identity, cafes, lanes, and small shops, alongside Cam Thanh coconut-waterway life.
- `legacy_sections_compact`: Why go: An Hoi Island is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: lanes, small shops, hotel edges, and evening walks, alongside Cam Thanh coconut-waterway life. | What you'll get: At An Hoi Island, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: lantern-lit riverside island street with low buildings, with neighborhood identity, cafes, lanes, and small shops, alongside Cam Thanh coconut-waterway life. | Say it locally: Say Đảo An Hội for An Hoi Island. The local name is easier to remember once it sits beside evening walks, neighborhood identity, cafes, and lanes, alongside Cam Thanh coconut-waterway life. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: small shops, hotel edges, evening walks, and neighborhood identity, alongside Cam Thanh coconut-waterway life. | Before you go: An Hoi Island works best when the name is tied to the reason for going, not memorized as an abstract label. Picture lantern-lit riverside island street with low buildings with cafes, lanes, small shops, and hotel edges, alongside Cam Thanh coconut-waterway life.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hoian-place-ancient-town
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Phố cổ Hội An
- `english_name`: Hoi An Ancient Town
- `place_kind`: neighborhood
- `source_notes`: Existing city-library; Vietnam Tourism Hoi An; UNESCO.
- `target_hero_image`: HeroCityHoianPlaceAncientTown
- `legacy_summary`: Hoi An Ancient Town is the lantern-lit old core people come to Hoi An for: yellow houses, tiled roofs, assembly halls, river walks, shops, and evening glow.
- `legacy_context`: Hoi An Ancient Town matters because it holds the city's most recognizable atmosphere in one walkable area: heritage houses, lantern streets, river edges, and small storefronts.
- `legacy_sections_compact`: Why go: Hoi An Ancient Town is worth recognizing because it is the image most people carry into the trip: yellow walls, lanterns, tiled roofs, old houses, river walks, and a gentle evening pace. | What you'll get: Expect pedestrian lanes, shopfronts, tailors, temples, assembly halls, old houses, and lanterns reflected near the river. It is compact, busy, and still beautiful when you let it unfold slowly. | Say it locally: Say Phố cổ Hội An for Hoi An Ancient Town. Phố cổ means old town, so the local name tells you exactly what kind of place you are asking about. | Worth it if: Worth it if you want the classic Hoi An walk: heritage streets, lantern light, small shops, river edges, and a place that rewards wandering rather than rushing. | Before you go: Before you go, expect crowds in the prettiest hours. The old town is still best when you leave room for side streets, early mornings, and unplanned pauses.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hoian-place-bach-dang-boat-pier
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Bến thuyền Bạch Đằng
- `english_name`: Bach Dang boat pier
- `place_kind`: port
- `source_notes`: Local map and Hoi An river references.
- `target_hero_image`: HeroCityHoianPlaceBachDangBoatPier
- `legacy_summary`: Bach Dang boat pier is worth knowing in Hoi An because it brings the city opening onto a river route rather than a road route into the trip. Expect river steps, boat noses, skyline edges, and the change from street movement to water movement.
- `legacy_context`: For Bach Dang boat pier, Hoi An's river landing story comes through river steps, boarding points, boats, and bridges, alongside lantern-street Hoi An.
- `legacy_sections_compact`: Why go: Bach Dang boat pier is worth knowing because it gives Hoi An a specific river landing scene: river steps, boarding points, boats, and bridges, alongside lantern-street Hoi An. | What you'll get: At Bach Dang boat pier, you get the city opening onto a river route rather than a road route: river steps, boat noses, skyline edges, and the change from street movement to water movement, with river steps, boarding points, boats, and bridges, alongside lantern-street Hoi An. | Say it locally: Say Bến thuyền Bạch Đằng for Bach Dang boat pier. The local name is easier to remember once it sits beside bridges, skyline views, waterfront movement, and river steps, alongside lantern-street Hoi An. | Worth it if: Worth it if Bach Dang boat pier gives your itinerary a clearer image: bridges, skyline views, waterfront movement, and river steps, alongside lantern-street Hoi An. | Before you go: Bach Dang boat pier works best when the name is tied to the reason for going, not memorized as an abstract label. Picture river steps, boat noses, skyline edges, and the change from street movement to water movement with waterfront movement, river steps, boarding points, and boats, alongside lantern-street Hoi An.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hoian-place-bach-dang-street
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Đường Bạch Đằng ở Hội An
- `english_name`: Bach Dang Street
- `place_kind`: street
- `source_notes`: UNESCO river and old-town context; local map references.
- `target_hero_image`: HeroCityHoianPlaceBachDangStreet
- `legacy_summary`: Bach Dang Street is worth recognizing because a named street can make Hoi An feel walkable before arrival. Expect riverside street with boats and yellow buildings, blue-hour lantern reflections.
- `legacy_context`: For Bach Dang Street, Hoi An's street story comes through scooters, crossings, cafe edges, and neighborhood movement, alongside Thu Bon river light.
- `legacy_sections_compact`: Why go: Bach Dang Street is worth recognizing because streets shape how Hoi An feels on the ground: street signs, shopfronts, scooters, and crossings, alongside Thu Bon river light. | What you'll get: At Bach Dang Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: riverside street with boats and yellow buildings, blue-hour lantern reflections, with scooters, crossings, cafe edges, and neighborhood movement, alongside Thu Bon river light. | Say it locally: Say Đường Bạch Đằng ở Hội An for Bach Dang Street. The local name is easier to remember once it sits beside neighborhood movement, street signs, shopfronts, and scooters, alongside Thu Bon river light. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: crossings, cafe edges, neighborhood movement, and street signs, alongside Thu Bon river light. | Before you go: Bach Dang Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture riverside street with boats and yellow buildings, blue-hour lantern reflections with neighborhood movement, street signs, shopfronts, and scooters, alongside Thu Bon river light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
