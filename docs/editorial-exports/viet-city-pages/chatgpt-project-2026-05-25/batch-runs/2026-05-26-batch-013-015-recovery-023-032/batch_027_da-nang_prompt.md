# SpeakLocal v2.2 BATCH_027 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_027` in the final handoff block. Put `SpeakLocal v2.2 BATCH_027 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-railway-station
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Ga Đà Nẵng
- `english_name`: Da Nang Railway Station
- `place_kind`: station
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceRailwayStation
- `legacy_summary`: Da Nang Railway Station is worth recognizing because travel days still carry the mood of Da Nang. Expect station facade, route boards, waiting benches, and local streets just outside.
- `legacy_context`: For Da Nang Railway Station, Da Nang's station story comes through onward roads, station doors, route boards, and waiting benches, alongside bridge-and-beach Da Nang.
- `legacy_sections_compact`: Why go: Da Nang Railway Station is worth recognizing because travel days still carry the city's mood: route boards, waiting benches, city light, and local signs, alongside bridge-and-beach Da Nang. | What you'll get: At Da Nang Railway Station, you get the handoff between travel days, city days, trains, buses, rides, and local names: station facade, route boards, waiting benches, and local streets just outside, with onward roads, station doors, route boards, and waiting benches, alongside bridge-and-beach Da Nang. | Say it locally: Say Ga Đà Nẵng for Da Nang Railway Station. The local name is easier to remember once it sits beside local signs, onward roads, station doors, and route boards, alongside bridge-and-beach Da Nang. | Worth it if: Worth it if Da Nang Railway Station gives your itinerary a clearer image: waiting benches, city light, local signs, and onward roads, alongside bridge-and-beach Da Nang. | Before you go: Da Nang Railway Station works best when the name is tied to the reason for going, not memorized as an abstract label. Picture station facade, route boards, waiting benches, and local streets just outside with waiting benches, city light, local signs, and onward roads, alongside bridge-and-beach Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-reply-1988
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Reply 1988 Cafe
- `english_name`: Reply 1988 Cafe
- `place_kind`: cafe
- `source_notes`: Local cafe source.
- `target_hero_image`: HeroCityDanangPlaceReply1988
- `legacy_summary`: Reply 1988 Cafe is worth saving for Da Nang's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect retro-style cafe corner with iced coffee and warm wood.
- `legacy_context`: For Reply 1988 Cafe, Da Nang's cafe story comes through street stools, design details, soft pauses, and cafe views, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: Reply 1988 Cafe is worth saving when you want Da Nang's cafe culture, not just caffeine: street stools, design details, soft pauses, and cafe views, alongside central-Vietnam beach rhythm. | What you'll get: At Reply 1988 Cafe, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: retro-style cafe corner with iced coffee and warm wood, with street stools, design details, soft pauses, and cafe views, alongside central-Vietnam beach rhythm. | Say it locally: Reply 1988 Cafe usually stays as the venue name. Say it slowly and connect it to the scene around it: design details, soft pauses, cafe views, and coffee counters, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: iced glasses, street stools, design details, and soft pauses, alongside central-Vietnam beach rhythm. | Before you go: Reply 1988 Cafe works best when the name is tied to the reason for going, not memorized as an abstract label. Picture retro-style cafe corner with iced coffee and warm wood with design details, soft pauses, cafe views, and coffee counters, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-six-on-six
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Six On Six Cafe
- `english_name`: Six On Six Cafe
- `place_kind`: cafe
- `source_notes`: Local cafe source.
- `target_hero_image`: HeroCityDanangPlaceSixOnSix
- `legacy_summary`: Six On Six Cafe is worth saving for Da Nang's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect leafy courtyard cafe with iced coffee and tile floor.
- `legacy_context`: For Six On Six Cafe, Da Nang's cafe story comes through soft pauses, cafe views, coffee counters, and iced glasses, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Six On Six Cafe is worth saving when you want Da Nang's cafe culture, not just caffeine: coffee counters, iced glasses, street stools, and design details, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Six On Six Cafe, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: leafy courtyard cafe with iced coffee and tile floor, with soft pauses, cafe views, coffee counters, and iced glasses, alongside Da Nang's seafood-and-mountain day. | Say it locally: Six On Six Cafe usually stays as the venue name. Say it slowly and connect it to the scene around it: design details, soft pauses, cafe views, and coffee counters, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: iced glasses, street stools, design details, and soft pauses, alongside Da Nang's seafood-and-mountain day. | Before you go: Six On Six Cafe works best when the name is tied to the reason for going, not memorized as an abstract label. Picture leafy courtyard cafe with iced coffee and tile floor with design details, soft pauses, cafe views, and coffee counters, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-son-tra
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bán đảo Sơn Trà
- `english_name`: Son Tra Peninsula
- `place_kind`: nature
- `source_notes`: City library; Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceSonTra
- `legacy_summary`: Son Tra Peninsula is worth knowing in Da Nang because it brings the city opening beyond buildings and traffic into the trip. Expect forested peninsula curving into blue sea, coastal road, wide coastal framing.
- `legacy_context`: For Son Tra Peninsula, Da Nang's nature stop story comes through paths, shade, water, and weather, alongside Han River light.
- `legacy_sections_compact`: Why go: Son Tra Peninsula is worth knowing because it gives Da Nang a specific nature stop scene: quieter space beyond traffic, green edges, paths, and shade, alongside Han River light. | What you'll get: At Son Tra Peninsula, you get the city opening beyond buildings and traffic: forested peninsula curving into blue sea, coastal road, wide coastal framing, with paths, shade, water, and weather, alongside Han River light. | Say it locally: Say Bán đảo Sơn Trà for Son Tra Peninsula. The local name is easier to remember once it sits beside green edges, paths, shade, and water, alongside Han River light. | Worth it if: Worth it if you want the trip to open beyond dense streets into water, shade, weather, or green edges: weather, quieter space beyond traffic, green edges, and paths, alongside Han River light. | Before you go: Son Tra Peninsula works best when the name is tied to the reason for going, not memorized as an abstract label. Picture forested peninsula curving into blue sea, coastal road, wide coastal framing with green edges, paths, shade, and water, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-son-tra-district
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Quận Sơn Trà
- `english_name`: Son Tra District
- `place_kind`: neighborhood
- `source_notes`: Vietnam Tourism Da Nang; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceSonTraDistrict
- `legacy_summary`: Son Tra District is worth recognizing because neighborhoods turn Da Nang from landmarks into lived-in areas. Expect city-meets-peninsula panorama with coast road and green hills, morning haze.
- `legacy_context`: For Son Tra District, Da Nang's neighborhood story comes through cafes, lanes, small shops, and hotel edges, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Son Tra District is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: small shops, hotel edges, evening walks, and neighborhood identity, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Son Tra District, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: city-meets-peninsula panorama with coast road and green hills, morning haze, with cafes, lanes, small shops, and hotel edges, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Quận Sơn Trà for Son Tra District. The local name is easier to remember once it sits beside lanes, small shops, hotel edges, and evening walks, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: neighborhood identity, cafes, lanes, and small shops, alongside Da Nang's seafood-and-mountain day. | Before you go: Son Tra District works best when the name is tied to the reason for going, not memorized as an abstract label. Picture city-meets-peninsula panorama with coast road and green hills, morning haze with hotel edges, evening walks, neighborhood identity, and cafes, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
