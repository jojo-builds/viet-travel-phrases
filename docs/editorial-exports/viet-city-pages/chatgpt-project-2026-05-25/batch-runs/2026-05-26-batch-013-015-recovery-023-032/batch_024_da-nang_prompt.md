# SpeakLocal v2.2 BATCH_024 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_024` in the final handoff block. Put `SpeakLocal v2.2 BATCH_024 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-nam-danh-seafood
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Hải sản Năm Đảnh
- `english_name`: Nam Danh Seafood
- `place_kind`: restaurant
- `source_notes`: Local food source.
- `target_hero_image`: HeroCityDanangPlaceNamDanhSeafood
- `legacy_summary`: Nam Danh Seafood is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect Seafood table with clams, grilled fish, and plastic stools, neighborhood setting.
- `legacy_context`: For Nam Danh Seafood, Da Nang's restaurant story comes through house dishes, menu details, staff rhythm, and drinks, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Nam Danh Seafood is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with evening meal energy, tables, house dishes, and menu details, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Nam Danh Seafood, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: Seafood table with clams, grilled fish, and plastic stools, neighborhood setting, with evening meal energy, tables, house dishes, and menu details, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Hải sản Năm Đảnh for Nam Danh Seafood. The local name is easier to remember once it sits beside drinks, evening meal energy, tables, and house dishes, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside Da Nang's seafood-and-mountain day. | Before you go: Nam Danh Seafood works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Seafood table with clams, grilled fish, and plastic stools, neighborhood setting with menu details, staff rhythm, drinks, and evening meal energy, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-nam-house
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Nam House Cafe
- `english_name`: Nam House Cafe
- `place_kind`: cafe
- `source_notes`: Local cafe source.
- `target_hero_image`: HeroCityDanangPlaceNamHouse
- `legacy_summary`: Nam House Cafe is worth saving for Da Nang's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect vintage Vietnamese cafe interior with plants and patterned tiles.
- `legacy_context`: For Nam House Cafe, Da Nang's cafe story comes through street stools, design details, soft pauses, and cafe views, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: Nam House Cafe is worth saving when you want Da Nang's cafe culture, not just caffeine: street stools, design details, soft pauses, and cafe views, alongside central-Vietnam beach rhythm. | What you'll get: At Nam House Cafe, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: vintage Vietnamese cafe interior with plants and patterned tiles, with coffee counters, iced glasses, street stools, and design details, alongside central-Vietnam beach rhythm. | Say it locally: Nam House Cafe usually stays as the venue name. Say it slowly and connect it to the scene around it: design details, soft pauses, cafe views, and coffee counters, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: iced glasses, street stools, design details, and soft pauses, alongside central-Vietnam beach rhythm. | Before you go: Nam House Cafe works best when the name is tied to the reason for going, not memorized as an abstract label. Picture vintage Vietnamese cafe interior with plants and patterned tiles with cafe views, coffee counters, iced glasses, and street stools, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-nam-o-fish-sauce-village
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Làng nghề nước mắm Nam Ô
- `english_name`: Nam O fish sauce village
- `place_kind`: experience
- `source_notes`: Da Nang Fantasticity sources; local craft source.
- `target_hero_image`: HeroCityDanangPlaceNamOFishSauceVillage
- `legacy_summary`: Nam O fish sauce village is a coastal Da Nang craft stop tied to the traditional making of nước mắm. Save it for wooden barrels, salty air, anchovy sauce, and a food tradition that sits behind everyday Vietnamese meals.
- `legacy_context`: Nam O fish sauce village is about craft and flavor, not a generic countryside stop: fish, salt, barrels, coastal weather, and the condiment that quietly shapes Vietnamese cooking.
- `legacy_sections_compact`: Why go: Nam O fish sauce village is worth knowing because it turns fish sauce from a bottle on the table into a coastal craft: anchovies, salt, barrels, time, and village know-how. | What you'll get: At Nam O fish sauce village, expect a food-craft setting rather than a polished attraction: coastal lanes, sauce barrels, local products, and the smell of fish sauce in the place where it is made. | Say it locally: Say Làng nghề nước mắm Nam Ô for Nam O fish sauce village. Làng nghề means craft village and nước mắm means fish sauce, so the phrase explains exactly why the stop exists. | Worth it if: Worth it if food is part of the reason for coming to Vietnam and you want to see the coastal craft behind a flavor that appears in dipping sauces, marinades, and everyday meals. | Before you go: Before you go, remember that this is a craft-village page. The point is not shopping in general; it is understanding why Nam Ô is tied to fish sauce.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-nam-o-reef
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Rạn Nam Ô
- `english_name`: Nam O Reef
- `place_kind`: nature
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceNamOReef
- `legacy_summary`: Nam O Reef is worth knowing in Da Nang because it brings the city opening beyond buildings and traffic into the trip. Expect rocky reef with tidal pools and fishing village shoreline, golden morning light.
- `legacy_context`: For Nam O Reef, Da Nang's nature stop story comes through green edges, paths, shade, and water, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Nam O Reef is worth knowing because it gives Da Nang a specific nature stop scene: green edges, paths, shade, and water, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Nam O Reef, you get the city opening beyond buildings and traffic: rocky reef with tidal pools and fishing village shoreline, golden morning light, with shade, water, weather, and quieter space beyond traffic, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Rạn Nam Ô for Nam O Reef. The local name is easier to remember once it sits beside quieter space beyond traffic, green edges, paths, and shade, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if you want the trip to open beyond dense streets into water, shade, weather, or green edges: water, weather, quieter space beyond traffic, and green edges, alongside Da Nang's seafood-and-mountain day. | Before you go: Nam O Reef works best when the name is tied to the reason for going, not memorized as an abstract label. Picture rocky reef with tidal pools and fishing village shoreline, golden morning light with water, weather, quieter space beyond traffic, and green edges, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-nem-lui
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Nem lụi ở Đà Nẵng
- `english_name`: Lemongrass pork skewers
- `place_kind`: dish
- `source_notes`: Central Vietnam food sources.
- `target_hero_image`: HeroCityDanangPlaceNemLui
- `legacy_summary`: Lemongrass pork skewers is worth trying in Da Nang because it gives the trip a flavor to imagine before arrival. Expect grilled pork skewers with herbs, rice paper, and peanut sauce, warm street-food lighting.
- `legacy_context`: For Lemongrass pork skewers, Da Nang's food story comes through flavor, herbs, sauce, and steam, alongside Han River light.
- `legacy_sections_compact`: Why go: Lemongrass pork skewers is worth trying because it turns Da Nang into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with flavor, herbs, sauce, and steam, alongside Han River light. | What you'll get: At Lemongrass pork skewers, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: grilled pork skewers with herbs, rice paper, and peanut sauce, warm street-food lighting, with flavor, herbs, sauce, and steam, alongside Han River light. | Say it locally: Say Nem lụi ở Đà Nẵng for Lemongrass pork skewers. The local name is easier to remember once it sits beside herbs, sauce, steam, and texture, alongside Han River light. | Worth it if: Worth it if you want a food memory rather than only a label: small meal rituals, flavor, herbs, and sauce, alongside Han River light. | Before you go: Lemongrass pork skewers works best when the name is tied to the reason for going, not memorized as an abstract label. Picture grilled pork skewers with herbs, rice paper, and peanut sauce, warm street-food lighting with herbs, sauce, steam, and texture, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
