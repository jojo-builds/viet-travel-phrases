# SpeakLocal v2.2 BATCH_029 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_029` in the final handoff block. Put `SpeakLocal v2.2 BATCH_029 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-tien-sa-port
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cảng Tiên Sa
- `english_name`: Tien Sa Port
- `place_kind`: port
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceTienSaPort
- `legacy_summary`: Tien Sa Port is worth recognizing because it opens Da Nang toward water, crossings, islands, or the next route. Expect waterfront boarding, sea air, and the move between city streets and island routes.
- `legacy_context`: For Tien Sa Port, Da Nang's port story comes through markets, mountain roads, seafood stops, and central-Vietnam day trips.
- `legacy_sections_compact`: Why go: Tien Sa Port is worth recognizing because it opens Da Nang toward water, crossings, and the next stretch of the trip: markets, mountain roads, seafood stops, and central-Vietnam day trips. | What you'll get: At Tien Sa Port, you get the trip turning toward islands, boats, ferries, and coastal travel: waterfront boarding, sea air, and the move between city streets and island routes, with markets, mountain roads, seafood stops, and central-Vietnam day trips. | Say it locally: Say Cảng Tiên Sa for Tien Sa Port. The local name is easier to remember once it sits beside central-Vietnam day trips, beaches, bridges, and markets. | Worth it if: Worth it if Tien Sa Port gives your itinerary a clearer image: mountain roads, seafood stops, central-Vietnam day trips, and beaches. | Before you go: Tien Sa Port works best when the name is tied to the reason for going, not memorized as an abstract label. Picture waterfront boarding, sea air, and the move between city streets and island routes with central-Vietnam day trips, beaches, bridges, and markets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-tran-hung-dao-street
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Đường Trần Hưng Đạo
- `english_name`: Tran Hung Dao Street
- `place_kind`: street
- `source_notes`: Vietnam Tourism Da Nang mentions Dragon Bridge viewing side; local map.
- `target_hero_image`: HeroCityDanangPlaceTranHungDaoStreet
- `legacy_summary`: Tran Hung Dao Street is worth recognizing because a named street can make Da Nang feel walkable before arrival. Expect east-bank riverside street with bridge view and scooters, blue-hour lights.
- `legacy_context`: For Tran Hung Dao Street, Da Nang's street story comes through street signs, shopfronts, scooters, and crossings, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Tran Hung Dao Street is worth recognizing because streets shape how Da Nang feels on the ground: scooters, crossings, cafe edges, and neighborhood movement, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Tran Hung Dao Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: east-bank riverside street with bridge view and scooters, blue-hour lights, with cafe edges, neighborhood movement, street signs, and shopfronts, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Đường Trần Hưng Đạo for Tran Hung Dao Street. The local name is easier to remember once it sits beside neighborhood movement, street signs, shopfronts, and scooters, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: crossings, cafe edges, neighborhood movement, and street signs, alongside Da Nang's seafood-and-mountain day. | Before you go: Tran Hung Dao Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture east-bank riverside street with bridge view and scooters, blue-hour lights with neighborhood movement, street signs, shopfronts, and scooters, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-tran-thi-ly-bridge
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cầu Trần Thị Lý
- `english_name`: Tran Thi Ly Bridge
- `place_kind`: landmark
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceTranThiLyBridge
- `legacy_summary`: Tran Thi Ly Bridge is worth knowing in Da Nang because it brings architecture, views, local pride, and history in visual form into the trip. Expect cable-stayed bridge silhouette over Han River in late afternoon, clean urban skyline.
- `legacy_context`: For Tran Thi Ly Bridge, Da Nang's landmark story comes through architecture, views, local pride, and history, alongside bridge-and-beach Da Nang.
- `legacy_sections_compact`: Why go: Tran Thi Ly Bridge is worth knowing because it gives Da Nang a specific landmark scene: local pride, history, city light, and landmark memory, alongside bridge-and-beach Da Nang. | What you'll get: At Tran Thi Ly Bridge, you get architecture, views, local pride, and history in visual form: cable-stayed bridge silhouette over Han River in late afternoon, clean urban skyline, with city light, landmark memory, architecture, and views, alongside bridge-and-beach Da Nang. | Say it locally: Say Cầu Trần Thị Lý for Tran Thi Ly Bridge. The local name is easier to remember once it sits beside landmark memory, architecture, views, and local pride, alongside bridge-and-beach Da Nang. | Worth it if: Worth it if Tran Thi Ly Bridge gives your itinerary a clearer image: history, city light, landmark memory, and architecture, alongside bridge-and-beach Da Nang. | Before you go: Tran Thi Ly Bridge works best when the name is tied to the reason for going, not memorized as an abstract label. Picture cable-stayed bridge silhouette over Han River in late afternoon, clean urban skyline with landmark memory, architecture, views, and local pride, alongside bridge-and-beach Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-trung-vuong-theatre
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Nhà hát Trưng Vương
- `english_name`: Trung Vuong Theatre
- `place_kind`: experience
- `source_notes`: Da Nang Fantasticity; local map.
- `target_hero_image`: HeroCityDanangPlaceTrungVuongTheatre
- `legacy_summary`: Trung Vuong Theatre is worth knowing in Da Nang because it brings living performance culture rather than a static monument into the trip. Expect city theatre entry area at dusk with soft marquee glow.
- `legacy_context`: For Trung Vuong Theatre, Da Nang's performance venue story comes through cultural memory, stage light, music, and masks, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: Trung Vuong Theatre is worth knowing because it gives Da Nang a specific performance venue scene: music, masks, theatre doors, and evening streets, alongside central-Vietnam beach rhythm. | What you'll get: At Trung Vuong Theatre, you get living performance culture rather than a static monument: city theatre entry area at dusk with soft marquee glow, with music, masks, theatre doors, and evening streets, alongside central-Vietnam beach rhythm. | Say it locally: Say Nhà hát Trưng Vương for Trung Vuong Theatre. The local name is easier to remember once it sits beside evening streets, cultural memory, stage light, and music, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if Trung Vuong Theatre gives your itinerary a clearer image: masks, theatre doors, evening streets, and cultural memory, alongside central-Vietnam beach rhythm. | Before you go: Trung Vuong Theatre works best when the name is tied to the reason for going, not memorized as an abstract label. Picture city theatre entry area at dusk with soft marquee glow with stage light, music, masks, and theatre doors, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-vincom-plaza
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Vincom Plaza Đà Nẵng
- `english_name`: Vincom Plaza Da Nang
- `place_kind`: market
- `source_notes`: Local map.
- `target_hero_image`: HeroCityDanangPlaceVincomPlaza
- `legacy_summary`: Vincom Plaza Da Nang is worth knowing in Da Nang because it brings modern shopping and a polished indoor break from heat, rain, or street movement into the trip. Expect modern mall exterior from across the street, city frontage, cloudy daylight.
- `legacy_context`: For Vincom Plaza Da Nang, Da Nang's shopping stop story comes through easy meetups, storefronts, indoor food counters, and city-center corners, alongside bridge-and-beach Da Nang.
- `legacy_sections_compact`: Why go: Vincom Plaza Da Nang is worth knowing because it gives Da Nang a specific shopping stop scene: city-center corners, cool air, easy meetups, and storefronts, alongside bridge-and-beach Da Nang. | What you'll get: At Vincom Plaza Da Nang, you get modern shopping and a polished indoor break from heat, rain, or street movement: modern mall exterior from across the street, city frontage, cloudy daylight, with indoor food counters, city-center corners, cool air, and easy meetups, alongside bridge-and-beach Da Nang. | Say it locally: Say Vincom Plaza Đà Nẵng for Vincom Plaza Da Nang. The local name is easier to remember once it sits beside storefronts, indoor food counters, city-center corners, and cool air, alongside bridge-and-beach Da Nang. | Worth it if: Worth it if Vincom Plaza Da Nang gives your itinerary a clearer image: city-center corners, cool air, easy meetups, and storefronts, alongside bridge-and-beach Da Nang. | Before you go: Vincom Plaza Da Nang works best when the name is tied to the reason for going, not memorized as an abstract label. Picture modern mall exterior from across the street, city frontage, cloudy daylight with storefronts, indoor food counters, city-center corners, and cool air, alongside bridge-and-beach Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
