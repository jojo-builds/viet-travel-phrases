# SpeakLocal v2.2 BATCH_017 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_017` in the final handoff block. Put `SpeakLocal v2.2 BATCH_017 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-fatfish
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Fatfish
- `english_name`: Fatfish Restaurant & Lounge Bar
- `place_kind`: restaurant
- `source_notes`: Venue and local map sources.
- `target_hero_image`: HeroCityDanangPlaceFatfish
- `legacy_summary`: Fatfish Restaurant & Lounge Bar is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect riverside restaurant terrace with warm lights and Han River blur, street-side details.
- `legacy_context`: For Fatfish Restaurant & Lounge Bar, Da Nang's restaurant story comes through tables, house dishes, menu details, and staff rhythm, alongside bridge-and-beach Da Nang.
- `legacy_sections_compact`: Why go: Fatfish Restaurant & Lounge Bar is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with menu details, staff rhythm, drinks, and evening meal energy, alongside bridge-and-beach Da Nang. | What you'll get: At Fatfish Restaurant & Lounge Bar, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: riverside restaurant terrace with warm lights and Han River blur, street-side details, with drinks, evening meal energy, tables, and house dishes, alongside bridge-and-beach Da Nang. | Say it locally: Say Fatfish for Fatfish Restaurant & Lounge Bar. The local name is easier to remember once it sits beside evening meal energy, tables, house dishes, and menu details, alongside bridge-and-beach Da Nang. | Worth it if: Worth it if the meal itself should be one of the day's memories: staff rhythm, drinks, evening meal energy, and tables, alongside bridge-and-beach Da Nang. | Before you go: Fatfish Restaurant & Lounge Bar works best when the name is tied to the reason for going, not memorized as an abstract label. Picture riverside restaurant terrace with warm lights and Han River blur, street-side details with staff rhythm, drinks, evening meal energy, and tables, alongside bridge-and-beach Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-fine-arts-museum
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bảo tàng Mỹ thuật Đà Nẵng
- `english_name`: Da Nang Fine Arts Museum
- `place_kind`: museum
- `source_notes`: Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceFineArtsMuseum
- `legacy_summary`: Da Nang Fine Arts Museum is a compact downtown culture stop on Lê Duẩn where modern Vietnamese art, folk craft, masks, textiles, wood, ceramics, and regional objects need one floor choice first.
- `legacy_context`: The museum is easier when the visit starts with modern art or folk craft rather than every label in every room.
- `legacy_sections_compact`: Pick Modern Or Folk First: Da Nang Fine Arts Museum is easier if you choose one lens before walking in: modern Vietnamese art or folk craft and regional objects. | A Smaller Art Stop Downtown: The museum sits on Lê Duẩn, away from the river-show version of Đà Nẵng. Expect lacquer, oil, silk, sculpture, masks, textiles, wood, ceramics, and craft traditions. | Useful Phrases:  | Good Before Heat Or Rain: Morning keeps the visit from feeling like emergency air-conditioning. Rain can also make it a useful indoor counterweight to beach plans. | Pair It Centrally: The museum works before Hàn Market, the riverfront, or a nearby coffee stop. Plan for a compact visit unless regional art is already the main interest.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-golden-bridge
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cầu Vàng
- `english_name`: Golden Bridge
- `place_kind`: landmark
- `source_notes`: City library; Vietnam Tourism Da Nang; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceGoldenBridge
- `legacy_summary`: Golden Bridge is the mountaintop pedestrian bridge in Ba Na Hills held by giant stone hands. It is the image many people mean when they talk about the bridge above the clouds near Da Nang.
- `legacy_context`: Golden Bridge is a Ba Na Hills photo landmark, not a normal city bridge: the point is the golden walkway, giant hands, mountain air, and cloud-level view.
- `legacy_sections_compact`: Why go: Golden Bridge is worth knowing because it is the famous Ba Na Hills bridge held by giant stone hands, high above Da Nang rather than across a city river. | What you'll get: At Golden Bridge, expect the golden walkway, mossy-looking hands, mountain gardens, and a wide view that can feel like walking through clouds when the weather cooperates. | Say it locally: Say Cầu Vàng for Golden Bridge. Cầu means bridge and Vàng means gold, so the Vietnamese name stays short even when the full Ba Na Hills plan is bigger. | Worth it if: Worth it if the Ba Na trip is mainly about the iconic photo moment, mountain views, and seeing the bridge that appears in so many Da Nang travel plans. | Before you go: Before you go, keep Golden Bridge tied to Ba Na Hills. It is a sub-stop inside the mountain resort, so the bridge name helps when choosing what to see after the cable car.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-hai-chau-district
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Quận Hải Châu
- `english_name`: Hai Chau District
- `place_kind`: neighborhood
- `source_notes`: Da Nang Fantasticity; local map.
- `target_hero_image`: HeroCityDanangPlaceHaiChauDistrict
- `legacy_summary`: Hai Chau District is worth recognizing because neighborhoods turn Da Nang from landmarks into lived-in areas. Expect central Da Nang street grid near river with shops and trees.
- `legacy_context`: For Hai Chau District, Da Nang's neighborhood story comes through cafes, lanes, small shops, and hotel edges, alongside Han River light.
- `legacy_sections_compact`: Why go: Hai Chau District is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: evening walks, neighborhood identity, cafes, and lanes, alongside Han River light. | What you'll get: At Hai Chau District, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: central Da Nang street grid near river with shops and trees, with small shops, hotel edges, evening walks, and neighborhood identity, alongside Han River light. | Say it locally: Say Quận Hải Châu for Hai Chau District. The local name is easier to remember once it sits beside neighborhood identity, cafes, lanes, and small shops, alongside Han River light. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: hotel edges, evening walks, neighborhood identity, and cafes, alongside Han River light. | Before you go: Hai Chau District works best when the name is tied to the reason for going, not memorized as an abstract label. Picture central Da Nang street grid near river with shops and trees with hotel edges, evening walks, neighborhood identity, and cafes, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-hai-san
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Hải sản ở Đà Nẵng
- `english_name`: Seafood
- `place_kind`: dish
- `source_notes`: Vietnam Tourism Da Nang mentions seafood near beaches; stable local notes.
- `target_hero_image`: HeroCityDanangPlaceHaiSan
- `legacy_summary`: Seafood is worth trying in Da Nang because it gives the trip a flavor to imagine before arrival. Expect fresh seafood spread on ice with coastal restaurant.
- `legacy_context`: For Seafood, Da Nang's food story comes through flavor, herbs, sauce, and steam, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: Seafood is worth trying because it turns Da Nang into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with sauce, steam, texture, and small meal rituals, alongside central-Vietnam beach rhythm. | What you'll get: At Seafood, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: fresh seafood spread on ice with coastal restaurant, with flavor, herbs, sauce, and steam, alongside central-Vietnam beach rhythm. | Say it locally: Say Hải sản ở Đà Nẵng for Seafood. The local name is easier to remember once it sits beside small meal rituals, flavor, herbs, and sauce, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if you want a food memory rather than only a label: steam, texture, small meal rituals, and flavor, alongside central-Vietnam beach rhythm. | Before you go: Seafood works best when the name is tied to the reason for going, not memorized as an abstract label. Picture fresh seafood spread on ice with coastal restaurant with small meal rituals, flavor, herbs, and sauce, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

