# SpeakLocal v2.2 BATCH_022 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_022` in the final handoff block. Put `SpeakLocal v2.2 BATCH_022 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-marble-mountains
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Ngũ Hành Sơn
- `english_name`: Marble Mountains
- `place_kind`: landmark
- `source_notes`: City library; Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceMarbleMountains
- `legacy_summary`: Marble Mountains is a cluster of limestone and marble hills south of Da Nang, with caves, pagodas, stone steps, viewpoints, and nearby stone-carving shops. It is a place to climb into, not just photograph from outside.
- `legacy_context`: Marble Mountains works because the visit has layers: stairs, caves, shrines, lookout points, and the stone-carving area around the base.
- `legacy_sections_compact`: Why go: Marble Mountains is worth knowing because it is a cluster of limestone and marble hills where the visit moves through stairs, caves, pagodas, viewpoints, and stone-carving streets. | What you'll get: At Marble Mountains, expect shaded stone steps, cave chambers, incense, pagoda gates, and views back toward Da Nang's beach side once you climb high enough. | Say it locally: Say Ngũ Hành Sơn for Marble Mountains. The name refers to the mountain cluster, so it covers caves, temples, viewpoints, and the stone shops below. | Worth it if: Worth it if you want a Da Nang stop that is active but not a long day trip: climb, step into caves, pause at pagodas, and still stay close to the coast. | Before you go: Before you go, think of Marble Mountains as a compact climb with several possible stops. Shoes, stairs, caves, and shade matter more than a single photo angle.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-mi-quang
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Mì Quảng ở Đà Nẵng
- `english_name`: Mi Quang
- `place_kind`: dish
- `source_notes`: Vietnam Tourism/Da Nang food sources; local source.
- `target_hero_image`: HeroCityDanangPlaceMiQuang
- `legacy_summary`: Mi Quang is worth trying in Da Nang because it gives the trip a flavor to imagine before arrival. Expect bowl of mì Quảng with turmeric noodles, herbs, peanuts, and rice cracker, overhead natural light.
- `legacy_context`: For Mi Quang, Da Nang's food story comes through texture, small meal rituals, flavor, and herbs, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Mi Quang is worth trying because it turns Da Nang into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with sauce, steam, texture, and small meal rituals, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Mi Quang, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: bowl of mì Quảng with turmeric noodles, herbs, peanuts, and rice cracker, overhead natural light, with flavor, herbs, sauce, and steam, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Mì Quảng ở Đà Nẵng for Mi Quang. The local name is easier to remember once it sits beside small meal rituals, flavor, herbs, and sauce, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if you want a food memory rather than only a label: steam, texture, small meal rituals, and flavor, alongside Da Nang's seafood-and-mountain day. | Before you go: Mi Quang works best when the name is tied to the reason for going, not memorized as an abstract label. Picture bowl of mì Quảng with turmeric noodles, herbs, peanuts, and rice cracker, overhead natural light with steam, texture, small meal rituals, and flavor, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-mi-quang-1a
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Mì Quảng 1A
- `english_name`: Mi Quang 1A
- `place_kind`: restaurant
- `source_notes`: Local food source.
- `target_hero_image`: HeroCityDanangPlaceMiQuang1a
- `legacy_summary`: Mi Quang 1A is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect small noodle shop table with turmeric noodles and herbs.
- `legacy_context`: For Mi Quang 1A, Da Nang's restaurant story comes through evening meal energy, tables, house dishes, and menu details, alongside Han River light.
- `legacy_sections_compact`: Why go: Mi Quang 1A is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with evening meal energy, tables, house dishes, and menu details, alongside Han River light. | What you'll get: At Mi Quang 1A, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: small noodle shop table with turmeric noodles and herbs, with house dishes, menu details, staff rhythm, and drinks, alongside Han River light. | Say it locally: Say Mì Quảng 1A for Mi Quang 1A. The local name is easier to remember once it sits beside tables, house dishes, menu details, and staff rhythm, alongside Han River light. | Worth it if: Worth it if the meal itself should be one of the day's memories: drinks, evening meal energy, tables, and house dishes, alongside Han River light. | Before you go: Mi Quang 1A works best when the name is tied to the reason for going, not memorized as an abstract label. Picture small noodle shop table with turmeric noodles and herbs with drinks, evening meal energy, tables, and house dishes, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-museum
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bảo tàng Đà Nẵng
- `english_name`: Da Nang Museum
- `place_kind`: museum
- `source_notes`: Da Nang Fantasticity; local map.
- `target_hero_image`: HeroCityDanangPlaceMuseum
- `legacy_summary`: Da Nang Museum is the new city-first culture stop on Bạch Đằng, useful when Đà Nẵng has only meant beaches, bridges, seafood, and river lights so far.
- `legacy_context`: The museum works as a current-venue stop with entrance, hours, ticket price, and special exhibits checked before sending anyone there.
- `legacy_sections_compact`: Start With The City, Not The Beach: Da Nang Museum is the right culture stop if the city has only been beaches, bridges, and seafood in your head. The building makes Đà Nẵng itself the subject. | Old City Hall, New Displays: The renovated Bạch Đằng setting matters. Expect modern exhibit rooms rather than a dusty municipal collection, with city history and regional culture in the foreground. | Useful Phrases:  | Pick One Floor Theme First: Choose city history, wartime context, or regional culture before reading every display. A focused route keeps the museum from becoming an indoor checklist. | New Enough To Verify: Confirm entrance, hours, ticket price, and special exhibits before going. The riverfront location makes a Hàn River walk easy afterward.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-museum-branch-2
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bảo tàng Đà Nẵng - Cơ sở 2
- `english_name`: Da Nang Museum Branch 2
- `place_kind`: museum
- `source_notes`: Da Nang Fantasticity; branch-name source.
- `target_hero_image`: HeroCityDanangPlaceMuseumBranch2
- `legacy_summary`: Da Nang Museum Branch 2 is worth a stop if you want Da Nang to feel more layered than the streets outside. Expect museum courtyard with sculpture garden mood, clear daytime light.
- `legacy_context`: For Da Nang Museum Branch 2, Da Nang's cultural stop story comes through memory, local history, display cases, and gallery rooms, alongside bridge-and-beach Da Nang.
- `legacy_sections_compact`: Why go: Da Nang Museum Branch 2 is worth a stop when you want more than scenery: rooms, objects, art, and memory inside the city's story, with memory, local history, display cases, and gallery rooms, alongside bridge-and-beach Da Nang. | What you'll get: At Da Nang Museum Branch 2, you get rooms, objects, art, and memory inside the city's story: museum courtyard with sculpture garden mood, clear daytime light, with display cases, gallery rooms, artifacts, and quiet light, alongside bridge-and-beach Da Nang. | Say it locally: Say Bảo tàng Đà Nẵng - Cơ sở 2 for Da Nang Museum Branch 2. The local name is easier to remember once it sits beside gallery rooms, artifacts, quiet light, and memory, alongside bridge-and-beach Da Nang. | Worth it if: Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: local history, display cases, gallery rooms, and artifacts, alongside bridge-and-beach Da Nang. | Before you go: Da Nang Museum Branch 2 works best when the name is tied to the reason for going, not memorized as an abstract label. Picture museum courtyard with sculpture garden mood, clear daytime light with gallery rooms, artifacts, quiet light, and memory, alongside bridge-and-beach Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

