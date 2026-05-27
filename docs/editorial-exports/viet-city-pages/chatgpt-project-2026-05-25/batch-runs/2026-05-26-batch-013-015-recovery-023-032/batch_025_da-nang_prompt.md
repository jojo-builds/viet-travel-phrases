# SpeakLocal v2.2 BATCH_025 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_025` in the final handoff block. Put `SpeakLocal v2.2 BATCH_025 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need, even 10+ minutes. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Batch 013-022 audit tightening for this run:
- Start the final answer with the batch title and then the first listing. Do not add a `Source basis`, `Source grounding`, `Grounding note`, citation, or setup paragraph before the first listing.
- Do not include Markdown links, source chips, citation cards, pasted-text chips, clickable Google Doc/Sheet references, or `utm_source=chatgpt.com` links anywhere in final output, including implementation notes.
- Keep phrase cards to 2-3, and only use ready-audio reusable traveler-action phrases. Place-name audio is pronunciation/name support by default, not a visible phrase card.
- Do not create one-off phrases for a single attraction, restaurant, dish, or object. Mark them as hidden/planned instead.
- Visible copy must not say `useful because`, `reference line`, `destination`, `anchor`, `content role`, `this page helps`, or `the job is`.
- Vary headings. Do not default to `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`. If two headings in this batch share that scaffold, revise one before final.
- Write travel copy, not a database note. Short, observed, specific, calm.
- Keep implementation notes compact and import-facing: IDs, phrase/audio status, mention candidates, freshness risks, and handoff block only. Do not turn notes into a schema dump.
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
- Do not include Markdown links, citation/source chips, pasted-text chips, or clickable Google Doc/Sheet references anywhere in the final batch output, including implementation notes. Start with the batch title, not a "source grounding" paragraph.
- Keep implementation notes compact and import-facing. Use plain source labels only.
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

### 1. city-danang-place-nen
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Nén Đà Nẵng
- `english_name`: Nen Da Nang
- `place_kind`: restaurant
- `source_notes`: City library; MICHELIN search/listing source.
- `target_hero_image`: HeroCityDanangPlaceNen
- `legacy_summary`: Nen Da Nang is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect contemporary Vietnamese tasting-table setting with herbs and ceramics.
- `legacy_context`: For Nen Da Nang, Da Nang's restaurant story comes through menu details, staff rhythm, drinks, and evening meal energy, alongside bridge-and-beach Da Nang.
- `legacy_sections_compact`: Why go: Nen Da Nang is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with tables, house dishes, menu details, and staff rhythm, alongside bridge-and-beach Da Nang. | What you'll get: At Nen Da Nang, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: contemporary Vietnamese tasting-table setting with herbs and ceramics, with menu details, staff rhythm, drinks, and evening meal energy, alongside bridge-and-beach Da Nang. | Say it locally: Say Nén Đà Nẵng for Nen Da Nang. The local name is easier to remember once it sits beside house dishes, menu details, staff rhythm, and drinks, alongside bridge-and-beach Da Nang. | Worth it if: Worth it if the meal itself should be one of the day's memories: evening meal energy, tables, house dishes, and menu details, alongside bridge-and-beach Da Nang. | Before you go: Nen Da Nang works best when the name is tied to the reason for going, not memorized as an abstract label. Picture contemporary Vietnamese tasting-table setting with herbs and ceramics with evening meal energy, tables, house dishes, and menu details, alongside bridge-and-beach Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-ngu-hanh-son-district
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Quận Ngũ Hành Sơn
- `english_name`: Ngu Hanh Son District
- `place_kind`: neighborhood
- `source_notes`: Vietnam Tourism Da Nang; local map.
- `target_hero_image`: HeroCityDanangPlaceNguHanhSonDistrict
- `legacy_summary`: Ngu Hanh Son District is worth recognizing because neighborhoods turn Da Nang from landmarks into lived-in areas. Expect road toward limestone hills with beach district buildings in distance.
- `legacy_context`: For Ngu Hanh Son District, Da Nang's neighborhood story comes through hotel edges, evening walks, neighborhood identity, and cafes, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Ngu Hanh Son District is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: hotel edges, evening walks, neighborhood identity, and cafes, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Ngu Hanh Son District, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: road toward limestone hills with beach district buildings in distance, with lanes, small shops, hotel edges, and evening walks, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Quận Ngũ Hành Sơn for Ngu Hanh Son District. The local name is easier to remember once it sits beside evening walks, neighborhood identity, cafes, and lanes, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: small shops, hotel edges, evening walks, and neighborhood identity, alongside Da Nang's seafood-and-mountain day. | Before you go: Ngu Hanh Son District works best when the name is tied to the reason for going, not memorized as an abstract label. Picture road toward limestone hills with beach district buildings in distance with small shops, hotel edges, evening walks, and neighborhood identity, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-nguyen-hien-dinh-tuong-theatre
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Nhà hát Tuồng Nguyễn Hiển Dĩnh
- `english_name`: Nguyen Hien Dinh Tuong Theatre
- `place_kind`: experience
- `source_notes`: Da Nang Fantasticity; venue source.
- `target_hero_image`: HeroCityDanangPlaceNguyenHienDinhTuongTheatre
- `legacy_summary`: Nguyen Hien Dinh Tuong Theatre is worth knowing in Da Nang because it brings living performance culture rather than a static monument into the trip. Expect traditional theatre facade and stage curtains, warm interior light.
- `legacy_context`: For Nguyen Hien Dinh Tuong Theatre, Da Nang's performance venue story comes through masks, theatre doors, evening streets, and cultural memory, alongside coastal Da Nang.
- `legacy_sections_compact`: Why go: Nguyen Hien Dinh Tuong Theatre is worth knowing because it gives Da Nang a specific performance venue scene: stage light, music, masks, and theatre doors, alongside coastal Da Nang. | What you'll get: At Nguyen Hien Dinh Tuong Theatre, you get living performance culture rather than a static monument: traditional theatre facade and stage curtains, warm interior light, with stage light, music, masks, and theatre doors, alongside coastal Da Nang. | Say it locally: Say Nhà hát Tuồng Nguyễn Hiển Dĩnh for Nguyen Hien Dinh Tuong Theatre. The local name is easier to remember once it sits beside cultural memory, stage light, music, and masks, alongside coastal Da Nang. | Worth it if: Worth it if Nguyen Hien Dinh Tuong Theatre gives your itinerary a clearer image: theatre doors, evening streets, cultural memory, and stage light, alongside coastal Da Nang. | Before you go: Nguyen Hien Dinh Tuong Theatre works best when the name is tied to the reason for going, not memorized as an abstract label. Picture traditional theatre facade and stage curtains, warm interior light with theatre doors, evening streets, cultural memory, and stage light, alongside coastal Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-nguyen-van-linh-street
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Đường Nguyễn Văn Linh
- `english_name`: Nguyen Van Linh Street
- `place_kind`: street
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceNguyenVanLinhStreet
- `legacy_summary`: Nguyen Van Linh Street is worth recognizing because a named street can make Da Nang feel walkable before arrival. Expect broad city avenue with motorbikes and planted median, motion blur.
- `legacy_context`: For Nguyen Van Linh Street, Da Nang's street story comes through crossings, cafe edges, neighborhood movement, and street signs, alongside coastal Da Nang.
- `legacy_sections_compact`: Why go: Nguyen Van Linh Street is worth recognizing because streets shape how Da Nang feels on the ground: crossings, cafe edges, neighborhood movement, and street signs, alongside coastal Da Nang. | What you'll get: At Nguyen Van Linh Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: broad city avenue with motorbikes and planted median, motion blur, with shopfronts, scooters, crossings, and cafe edges, alongside coastal Da Nang. | Say it locally: Say Đường Nguyễn Văn Linh for Nguyen Van Linh Street. The local name is easier to remember once it sits beside cafe edges, neighborhood movement, street signs, and shopfronts, alongside coastal Da Nang. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: scooters, crossings, cafe edges, and neighborhood movement, alongside coastal Da Nang. | Before you go: Nguyen Van Linh Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture broad city avenue with motorbikes and planted median, motion blur with street signs, shopfronts, scooters, and crossings, alongside coastal Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-non-nuoc-beach
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Biển Non Nước
- `english_name`: Non Nuoc Beach
- `place_kind`: beach
- `source_notes`: City library; Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceNonNuocBeach
- `legacy_summary`: Non Nuoc Beach is worth picturing because it changes the trip into coastal Vietnam: sea air, sand, seafood, and open light. Expect quiet beach below limestone hills, white sand, soft cloudy daylight.
- `legacy_context`: For Non Nuoc Beach, Da Nang's beach story comes through seafood stops, central-Vietnam day trips, beaches, and bridges.
- `legacy_sections_compact`: Why go: Non Nuoc Beach is worth picturing because it changes the trip into coastal Vietnam: seafood stops, central-Vietnam day trips, beaches, and bridges. | What you'll get: At Non Nuoc Beach, you get coastal Vietnam changing the pace of the trip: quiet beach below limestone hills, white sand, soft cloudy daylight, with seafood stops, central-Vietnam day trips, beaches, and bridges. | Say it locally: Say Biển Non Nước for Non Nuoc Beach. The local name is easier to remember once it sits beside bridges, markets, mountain roads, and seafood stops. | Worth it if: Worth it if the Vietnam image in your head includes sea air, sand, seafood, and coastal mornings: central-Vietnam day trips, beaches, bridges, and markets. | Before you go: Non Nuoc Beach works best when the name is tied to the reason for going, not memorized as an abstract label. Picture quiet beach below limestone hills, white sand, soft cloudy daylight with bridges, markets, mountain roads, and seafood stops.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
