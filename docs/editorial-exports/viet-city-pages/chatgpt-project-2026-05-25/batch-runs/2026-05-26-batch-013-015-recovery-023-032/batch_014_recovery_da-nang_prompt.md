# SpeakLocal v2.2 BATCH_014 RECOVERY - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_014_recovery` in the final handoff block. Put `SpeakLocal v2.2 BATCH_014 RECOVERY - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

This is a recovery session. The previous chat for this batch returned an unusable partial response. Produce the full batch or `BLOCKED_STUB`; do not send a partial answer.

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

### 1. city-danang-place-boulevard-gelato-coffee
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Boulevard Gelato & Coffee
- `english_name`: Boulevard Gelato & Coffee
- `place_kind`: cafe
- `source_notes`: Local cafe source.
- `target_hero_image`: HeroCityDanangPlaceBoulevardGelatoCoffee
- `legacy_summary`: Boulevard Gelato & Coffee is worth saving for Da Nang's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect gelato-and-coffee counter with pastel cups, bright daylight.
- `legacy_context`: For Boulevard Gelato & Coffee, Da Nang's cafe story comes through design details, soft pauses, cafe views, and coffee counters, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: Boulevard Gelato & Coffee is worth saving when you want Da Nang's cafe culture, not just caffeine: cafe views, coffee counters, iced glasses, and street stools, alongside central-Vietnam beach rhythm. | What you'll get: At Boulevard Gelato & Coffee, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: gelato-and-coffee counter with pastel cups, bright daylight, with design details, soft pauses, cafe views, and coffee counters, alongside central-Vietnam beach rhythm. | Say it locally: Boulevard Gelato & Coffee usually stays as the venue name. Say it slowly and connect it to the scene around it: soft pauses, cafe views, coffee counters, and iced glasses, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: street stools, design details, soft pauses, and cafe views, alongside central-Vietnam beach rhythm. | Before you go: Boulevard Gelato & Coffee works best when the name is tied to the reason for going, not memorized as an abstract label. Picture gelato-and-coffee counter with pastel cups, bright daylight with soft pauses, cafe views, coffee counters, and iced glasses, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-bun-cha-ca
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bún chả cá ở Đà Nẵng
- `english_name`: Fish-cake noodle soup
- `place_kind`: dish
- `source_notes`: Da Nang local food sources.
- `target_hero_image`: HeroCityDanangPlaceBunChaCa
- `legacy_summary`: Fish-cake noodle soup is worth trying in Da Nang because it gives the trip a flavor to imagine before arrival. Expect clear broth noodle bowl with fish cakes, dill, tomato, and herbs, simple metal table.
- `legacy_context`: For Fish-cake noodle soup, Da Nang's food story comes through sauce, steam, texture, and small meal rituals, alongside coastal Da Nang.
- `legacy_sections_compact`: Why go: Fish-cake noodle soup is worth trying because it turns Da Nang into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with flavor, herbs, sauce, and steam, alongside coastal Da Nang. | What you'll get: At Fish-cake noodle soup, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: clear broth noodle bowl with fish cakes, dill, tomato, and herbs, simple metal table, with texture, small meal rituals, flavor, and herbs, alongside coastal Da Nang. | Say it locally: Say Bún chả cá ở Đà Nẵng for Fish-cake noodle soup. The local name is easier to remember once it sits beside herbs, sauce, steam, and texture, alongside coastal Da Nang. | Worth it if: Worth it if you want a food memory rather than only a label: small meal rituals, flavor, herbs, and sauce, alongside coastal Da Nang. | Before you go: Fish-cake noodle soup works best when the name is tied to the reason for going, not memorized as an abstract label. Picture clear broth noodle bowl with fish cakes, dill, tomato, and herbs, simple metal table with herbs, sauce, steam, and texture, alongside coastal Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-bun-cha-ca-hon
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bún Chả Cá Hờn
- `english_name`: Bun Cha Ca Hon
- `place_kind`: restaurant
- `source_notes`: Local food source.
- `target_hero_image`: HeroCityDanangPlaceBunChaCaHon
- `legacy_summary`: Bun Cha Ca Hon is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect steaming fish-cake noodle bowl on metal table, neighborhood shop.
- `legacy_context`: For Bun Cha Ca Hon, Da Nang's restaurant story comes through tables, house dishes, menu details, and staff rhythm, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Bun Cha Ca Hon is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with drinks, evening meal energy, tables, and house dishes, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Bun Cha Ca Hon, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: steaming fish-cake noodle bowl on metal table, neighborhood shop, with menu details, staff rhythm, drinks, and evening meal energy, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Bún Chả Cá Hờn for Bun Cha Ca Hon. The local name is easier to remember once it sits beside evening meal energy, tables, house dishes, and menu details, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if the meal itself should be one of the day's memories: staff rhythm, drinks, evening meal energy, and tables, alongside Da Nang's seafood-and-mountain day. | Before you go: Bun Cha Ca Hon works best when the name is tied to the reason for going, not memorized as an abstract label. Picture steaming fish-cake noodle bowl on metal table, neighborhood shop with evening meal energy, tables, house dishes, and menu details, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-cathedral
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Nhà thờ Con Gà Đà Nẵng
- `english_name`: Da Nang Cathedral
- `place_kind`: landmark
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceCathedral
- `legacy_summary`: Da Nang Cathedral is worth approaching slowly because worship, architecture, incense, and local memory shape the visit. Expect pink cathedral facade from street level.
- `legacy_context`: For Da Nang Cathedral, Da Nang's sacred place story comes through quiet pews, stained-glass light, courtyard shade, and bells, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Da Nang Cathedral is worth approaching slowly because worship, architecture, incense, and local memory all shape the visit: quiet pews, stained-glass light, courtyard shade, and bells, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Da Nang Cathedral, you get worship, architecture, local memory, and the quieter rhythm of a spiritual stop: pink cathedral facade from street level, with Da Nang worship, cathedral facades, quiet pews, and stained-glass light, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Nhà thờ Con Gà Đà Nẵng for Da Nang Cathedral. The local name is easier to remember once it sits beside bells, Da Nang worship, cathedral facades, and quiet pews, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if temples, incense, worship, and quiet architecture help the place feel deeper: stained-glass light, courtyard shade, bells, and Da Nang worship, alongside Da Nang's seafood-and-mountain day. | Before you go: Da Nang Cathedral works best when the name is tied to the reason for going, not memorized as an abstract label. Picture pink cathedral facade from street level with bells, Da Nang worship, cathedral facades, and quiet pews, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-central-bus-station
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bến xe Trung tâm Đà Nẵng
- `english_name`: Da Nang Central Bus Station
- `place_kind`: station
- `source_notes`: Da Nang transport and local map sources.
- `target_hero_image`: HeroCityDanangPlaceCentralBusStation
- `legacy_summary`: Da Nang Central Bus Station is worth recognizing because travel days still carry the mood of Da Nang. Expect Da Nang station light, local signs, shaded benches, and onward streets.
- `legacy_context`: For Da Nang Central Bus Station, Da Nang's station story comes through local signs, onward roads, station doors, and route boards, alongside Han River light.
- `legacy_sections_compact`: Why go: Da Nang Central Bus Station is worth recognizing because travel days still carry the city's mood: station doors, route boards, waiting benches, and city light, alongside Han River light. | What you'll get: At Da Nang Central Bus Station, you get the handoff between travel days, city days, trains, buses, rides, and local names: Da Nang station light, local signs, shaded benches, and onward streets, with waiting benches, city light, local signs, and onward roads, alongside Han River light. | Say it locally: Say Bến xe Trung tâm Đà Nẵng for Da Nang Central Bus Station. The local name is easier to remember once it sits beside route boards, waiting benches, city light, and local signs, alongside Han River light. | Worth it if: Worth it if Da Nang Central Bus Station gives your itinerary a clearer image: onward roads, station doors, route boards, and waiting benches, alongside Han River light. | Before you go: Da Nang Central Bus Station works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Da Nang station light, local signs, shaded benches, and onward streets with onward roads, station doors, route boards, and waiting benches, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
