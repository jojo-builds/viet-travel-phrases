# SpeakLocal v2.2 BATCH_003 - Da Nang A - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_003` in the final handoff block. Put `SpeakLocal v2.2 BATCH_003 - Da Nang A - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-airport
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Sân bay Đà Nẵng
- `english_name`: Da Nang Airport
- `place_kind`: airport
- `source_notes`: City library; Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceAirport
- `legacy_summary`: Da Nang Airport is worth recognizing because it is where the planned trip first becomes Da Nang. Expect arrival hall doors, warm air, local signs, and the first road into the city.
- `legacy_context`: For Da Nang Airport, Da Nang's arrival story comes through arrival doors, city signs, warm air, and first roads, alongside coastal Da Nang.
- `legacy_sections_compact`: Why go: Da Nang Airport is worth recognizing before arrival because it is where the trip first turns from plan into Vietnam: warm air, first roads, waiting halls, and the first local name, alongside coastal Da Nang. | What you'll get: At Da Nang Airport, you get the arrival threshold where bags, signs, and the first ride make Vietnam feel immediate: arrival hall doors, warm air, local signs, and the first road into the city, with arrival doors, city signs, warm air, and first roads, alongside coastal Da Nang. | Say it locally: Say Sân bay Đà Nẵng for Da Nang Airport. The local name is easier to remember once it sits beside city signs, warm air, first roads, and waiting halls, alongside coastal Da Nang. | Worth it if: Worth it if Da Nang Airport gives your itinerary a clearer image: the first local name, arrival doors, city signs, and warm air, alongside coastal Da Nang. | Before you go: Da Nang Airport works best when the name is tied to the reason for going, not memorized as an abstract label. Picture arrival hall doors, warm air, local signs, and the first road into the city with city signs, warm air, first roads, and waiting halls, alongside coastal Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-an-thuong-street-area
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Khu An Thượng
- `english_name`: An Thuong Area
- `place_kind`: neighborhood
- `source_notes`: Da Nang Fantasticity; local map.
- `target_hero_image`: HeroCityDanangPlaceAnThuongStreetArea
- `legacy_summary`: An Thuong Area is worth recognizing because neighborhoods turn Da Nang from landmarks into lived-in areas. Expect narrow cafe street near the beach with shopfront texture, evening lanterns.
- `legacy_context`: For An Thuong Area, Da Nang's neighborhood story comes through cafes, lanes, small shops, and hotel edges, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: An Thuong Area is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: small shops, hotel edges, evening walks, and neighborhood identity, alongside central-Vietnam beach rhythm. | What you'll get: At An Thuong Area, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: narrow cafe street near the beach with shopfront texture, evening lanterns, with evening walks, neighborhood identity, cafes, and lanes, alongside central-Vietnam beach rhythm. | Say it locally: Say Khu An Thượng for An Thuong Area. The local name is easier to remember once it sits beside neighborhood identity, cafes, lanes, and small shops, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: neighborhood identity, cafes, lanes, and small shops, alongside central-Vietnam beach rhythm. | Before you go: An Thuong Area works best when the name is tied to the reason for going, not memorized as an abstract label. Picture narrow cafe street near the beach with shopfront texture, evening lanterns with hotel edges, evening walks, neighborhood identity, and cafes, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-apec-park
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Công viên APEC
- `english_name`: APEC Park
- `place_kind`: park
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceApecPark
- `legacy_summary`: APEC Park is worth knowing in Da Nang because it brings everyday city life in open air without a formal attraction into the trip. Expect riverside public park with curving riverside canopy and open walkway, afternoon.
- `legacy_context`: For APEC Park, Da Nang's park story comes through evening light, walking paths, trees, and family time, alongside Han River light.
- `legacy_sections_compact`: Why go: APEC Park is worth knowing because it gives Da Nang a specific park scene: shade, open lawns, evening light, and walking paths, alongside Han River light. | What you'll get: At APEC Park, you get everyday city life in open air without a formal attraction: riverside public park with curving riverside canopy and open walkway, afternoon, with shade, open lawns, evening light, and walking paths, alongside Han River light. | Say it locally: Say Công viên APEC for APEC Park. The local name is easier to remember once it sits beside family time, shade, open lawns, and evening light, alongside Han River light. | Worth it if: Worth it if APEC Park gives your itinerary a clearer image: walking paths, trees, family time, and shade, alongside Han River light. | Before you go: APEC Park works best when the name is tied to the reason for going, not memorized as an abstract label. Picture riverside public park with curving riverside canopy and open walkway, afternoon with walking paths, trees, family time, and shade, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-asia-park
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Công viên Châu Á
- `english_name`: Asia Park
- `place_kind`: park
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceAsiaPark
- `legacy_summary`: Asia Park is Da Nang after dark: neon rides, food stalls, families walking under bright lights, and the Sun Wheel rising over the skyline. It shows the city's modern leisure side beside the beaches and bridges.
- `legacy_context`: For Asia Park, Da Nang's park story comes through walking paths, trees, family time, and shade, alongside Han River light.
- `legacy_sections_compact`: Why go: This is Da Nang in a playful night-out mood: a Ferris wheel glow, open paths, snacks, rides, and families stretching the evening along the river side of the city. | What you'll get: Asia Park matters because it shows modern coastal Vietnam, where leisure, skyline, and family nightlife sit beside the older temple, market, and beach images visitors may already know. | Say it locally: Say Công viên Châu Á for Asia Park. The local name is easier to remember once it sits beside trees, family time, shade, and open lawns, alongside Han River light. | Worth it if: Worth it if Asia Park gives your itinerary a clearer image: evening light, walking paths, trees, and family time, alongside Han River light. | Before you go: Asia Park works best when the name is tied to the reason for going, not memorized as an abstract label. Picture amusement park skyline with ferris wheel glow at dusk with shade, open lawns, evening light, and walking paths, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-ba-na-cable-car
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cáp treo Bà Nà
- `english_name`: Ba Na cable car
- `place_kind`: experience
- `source_notes`: Vietnam Tourism Da Nang; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceBaNaCableCar
- `legacy_summary`: Ba Na cable car is worth knowing in Da Nang because it brings taking part in the place through movement, sound, scenery, and local texture into the trip. Expect cable car cabin over dense forest and mist.
- `legacy_context`: For Ba Na cable car, Da Nang's experience story comes through central-Vietnam day trips, beaches, bridges, and markets.
- `legacy_sections_compact`: Why go: Ba Na cable car is worth knowing because it gives Da Nang a specific experience scene: central-Vietnam day trips, beaches, bridges, and markets. | What you'll get: At Ba Na cable car, you get taking part in the place through movement, sound, scenery, and local texture: cable car cabin over dense forest and mist, with mountain roads, seafood stops, central-Vietnam day trips, and beaches. | Say it locally: Say Cáp treo Bà Nà for Ba Na cable car. The local name is easier to remember once it sits beside beaches, bridges, markets, and mountain roads. | Worth it if: Worth it if Ba Na cable car gives your itinerary a clearer image: seafood stops, central-Vietnam day trips, beaches, and bridges. | Before you go: Ba Na cable car works best when the name is tied to the reason for going, not memorized as an abstract label. Picture cable car cabin over dense forest and mist with markets, mountain roads, seafood stops, and central-Vietnam day trips.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
