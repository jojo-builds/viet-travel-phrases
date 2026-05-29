# SpeakLocal v2.2 BATCH_023 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_023` in the final handoff block. Put `SpeakLocal v2.2 BATCH_023 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-my-an
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Mỹ An
- `english_name`: My An
- `place_kind`: neighborhood
- `source_notes`: Local map.
- `target_hero_image`: HeroCityDanangPlaceMyAn
- `legacy_summary`: My An is worth recognizing because neighborhoods turn Da Nang from landmarks into lived-in areas. Expect low-rise beach neighborhood street with cafes and motorbikes, relaxed midday.
- `legacy_context`: For My An, Da Nang's neighborhood story comes through hotel edges, evening walks, neighborhood identity, and cafes, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: My An is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: hotel edges, evening walks, neighborhood identity, and cafes, alongside central-Vietnam beach rhythm. | What you'll get: At My An, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: low-rise beach neighborhood street with cafes and motorbikes, relaxed midday, with lanes, small shops, hotel edges, and evening walks, alongside central-Vietnam beach rhythm. | Say it locally: Say Mỹ An for My An. The local name is easier to remember once it sits beside cafes, lanes, small shops, and hotel edges, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: cafes, lanes, small shops, and hotel edges, alongside central-Vietnam beach rhythm. | Before you go: My An works best when the name is tied to the reason for going, not memorized as an abstract label. Picture low-rise beach neighborhood street with cafes and motorbikes, relaxed midday with small shops, hotel edges, evening walks, and neighborhood identity, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-my-an-beach
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Biển Mỹ An
- `english_name`: My An Beach
- `place_kind`: beach
- `source_notes`: Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceMyAnBeach
- `legacy_summary`: My An Beach is worth picturing because it changes the trip into coastal Vietnam: sea air, sand, seafood, and open light. Expect quieter beach entry area with umbrellas and low-rise hotels, sunny.
- `legacy_context`: For My An Beach, Da Nang's beach story comes through mountain roads, seafood stops, central-Vietnam day trips, and beaches.
- `legacy_sections_compact`: Why go: My An Beach is worth picturing because it changes the trip into coastal Vietnam: mountain roads, seafood stops, central-Vietnam day trips, and beaches. | What you'll get: At My An Beach, you get coastal Vietnam changing the pace of the trip: quieter beach entry area with umbrellas and low-rise hotels, sunny, with central-Vietnam day trips, beaches, bridges, and markets. | Say it locally: Say Biển Mỹ An for My An Beach. The local name is easier to remember once it sits beside markets, mountain roads, seafood stops, and central-Vietnam day trips. | Worth it if: Worth it if the Vietnam image in your head includes sea air, sand, seafood, and coastal mornings: beaches, bridges, markets, and mountain roads. | Before you go: My An Beach works best when the name is tied to the reason for going, not memorized as an abstract label. Picture quieter beach entry area with umbrellas and low-rise hotels, sunny with seafood stops, central-Vietnam day trips, beaches, and bridges.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-my-khe
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Biển Mỹ Khê
- `english_name`: My Khe Beach
- `place_kind`: beach
- `source_notes`: City library; Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceMyKheBeach
- `legacy_summary`: My Khe Beach is worth picturing because it changes the trip into coastal Vietnam: sea air, sand, seafood, and open light. Expect wide sandy beach with gentle waves and city skyline in distance, sunrise.
- `legacy_context`: For My Khe Beach, Da Nang's beach story comes through markets, mountain roads, seafood stops, and central-Vietnam day trips.
- `legacy_sections_compact`: Why go: My Khe Beach is worth picturing because it changes the trip into coastal Vietnam: markets, mountain roads, seafood stops, and central-Vietnam day trips. | What you'll get: At My Khe Beach, you get coastal Vietnam changing the pace of the trip: wide sandy beach with gentle waves and city skyline in distance, sunrise, with beaches, bridges, markets, and mountain roads. | Say it locally: Say Biển Mỹ Khê for My Khe Beach. The local name is easier to remember once it sits beside mountain roads, seafood stops, central-Vietnam day trips, and beaches. | Worth it if: Worth it if the Vietnam image in your head includes sea air, sand, seafood, and coastal mornings: bridges, markets, mountain roads, and seafood stops. | Before you go: My Khe Beach works best when the name is tied to the reason for going, not memorized as an abstract label. Picture wide sandy beach with gentle waves and city skyline in distance, sunrise with mountain roads, seafood stops, central-Vietnam day trips, and beaches.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-my-quang-ba-mua
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Mỳ Quảng Bà Mua
- `english_name`: My Quang Ba Mua
- `place_kind`: restaurant
- `source_notes`: Venue and local food sources.
- `target_hero_image`: HeroCityDanangPlaceMyQuangBaMua
- `legacy_summary`: My Quang Ba Mua is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect casual noodle restaurant table with yellow noodles and rice crackers.
- `legacy_context`: For My Quang Ba Mua, Da Nang's restaurant story comes through drinks, evening meal energy, tables, and house dishes, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: My Quang Ba Mua is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with tables, house dishes, menu details, and staff rhythm, alongside central-Vietnam beach rhythm. | What you'll get: At My Quang Ba Mua, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: casual noodle restaurant table with yellow noodles and rice crackers, with tables, house dishes, menu details, and staff rhythm, alongside central-Vietnam beach rhythm. | Say it locally: Say Mỳ Quảng Bà Mua for My Quang Ba Mua. The local name is easier to remember once it sits beside evening meal energy, tables, house dishes, and menu details, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if the meal itself should be one of the day's memories: staff rhythm, drinks, evening meal energy, and tables, alongside central-Vietnam beach rhythm. | Before you go: My Quang Ba Mua works best when the name is tied to the reason for going, not memorized as an abstract label. Picture casual noodle restaurant table with yellow noodles and rice crackers with staff rhythm, drinks, evening meal energy, and tables, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-my-quang-dung
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Mỳ Quảng Dung
- `english_name`: My Quang Dung
- `place_kind`: restaurant
- `source_notes`: Local food source.
- `target_hero_image`: HeroCityDanangPlaceMyQuangDung
- `legacy_summary`: My Quang Dung is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect noodle counter with bowls, herbs, lime, and chili, food counter scene.
- `legacy_context`: For My Quang Dung, Da Nang's restaurant story comes through staff rhythm, drinks, evening meal energy, and tables, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: My Quang Dung is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with staff rhythm, drinks, evening meal energy, and tables, alongside central-Vietnam beach rhythm. | What you'll get: At My Quang Dung, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: noodle counter with bowls, herbs, lime, and chili, food counter scene, with staff rhythm, drinks, evening meal energy, and tables, alongside central-Vietnam beach rhythm. | Say it locally: Say Mỳ Quảng Dung for My Quang Dung. The local name is easier to remember once it sits beside drinks, evening meal energy, tables, and house dishes, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside central-Vietnam beach rhythm. | Before you go: My Quang Dung works best when the name is tied to the reason for going, not memorized as an abstract label. Picture noodle counter with bowls, herbs, lime, and chili, food counter scene with tables, house dishes, menu details, and staff rhythm, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
