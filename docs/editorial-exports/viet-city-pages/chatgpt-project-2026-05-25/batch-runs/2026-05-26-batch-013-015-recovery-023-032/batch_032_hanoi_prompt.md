# SpeakLocal v2.2 BATCH_032 - Hanoi - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_032` in the final handoff block. Put `SpeakLocal v2.2 BATCH_032 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hanoi-place-bun-cha-ta
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bún Chả Ta
- `english_name`: Bun Cha Ta
- `place_kind`: restaurant
- `source_notes`: MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlaceBunChaTa
- `legacy_summary`: Bun Cha Ta is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect casual Hanoi bún chả table with dipping bowl and fresh herbs.
- `legacy_context`: For Bun Cha Ta, Hanoi's restaurant story comes through evening meal energy, tables, house dishes, and menu details, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Bun Cha Ta is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Bun Cha Ta, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: casual Hanoi bún chả table with dipping bowl and fresh herbs, with house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's steam-and-herb food streets. | Say it locally: Say Bún Chả Ta for Bun Cha Ta. The local name is easier to remember once it sits beside menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if the meal itself should be one of the day's memories: tables, house dishes, menu details, and staff rhythm, alongside Hanoi's steam-and-herb food streets. | Before you go: Bun Cha Ta works best when the name is tied to the reason for going, not memorized as an abstract label. Picture casual Hanoi bún chả table with dipping bowl and fresh herbs with tables, house dishes, menu details, and staff rhythm, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-bun-thang
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bún thang ở Hà Nội
- `english_name`: Bun thang
- `place_kind`: dish
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceBunThang
- `legacy_summary`: Bun thang is worth trying in Hanoi because it gives the trip a flavor to imagine before arrival. Expect bowl of bún thang with shredded egg, chicken, herbs, Hanoi.
- `legacy_context`: For Bun thang, Hanoi's food story comes through herbs, sauce, steam, and texture, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Bun thang is worth trying because it turns Hanoi into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with steam, texture, small meal rituals, and flavor, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Bun thang, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: bowl of bún thang with shredded egg, chicken, herbs, Hanoi, with herbs, sauce, steam, and texture, alongside Hanoi's steam-and-herb food streets. | Say it locally: Say Bún thang ở Hà Nội for Bun thang. The local name is easier to remember once it sits beside flavor, herbs, sauce, and steam, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if you want a food memory rather than only a label: texture, small meal rituals, flavor, and herbs, alongside Hanoi's steam-and-herb food streets. | Before you go: Bun thang works best when the name is tied to the reason for going, not memorized as an abstract label. Picture bowl of bún thang with shredded egg, chicken, herbs, Hanoi with flavor, herbs, sauce, and steam, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-ca-phe-sua-da
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Cà phê sữa đá ở Hà Nội
- `english_name`: Iced milk coffee
- `place_kind`: drink
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceCaPheSuaDa
- `legacy_summary`: Iced milk coffee is worth knowing in Hanoi because drink culture is part pause, part local rhythm. Expect Vietnamese iced milk coffee glass with condensed milk swirl, cafe table.
- `legacy_context`: For Iced milk coffee, Hanoi's drink story comes through cafe counters, street stools, local refreshment, and sweetness, alongside Hanoi's tiny-table coffee scene.
- `legacy_sections_compact`: Why go: Iced milk coffee is worth knowing because Vietnam's drink culture often carries the pause between bigger plans: local refreshment, sweetness, city pauses, and iced glasses, alongside Hanoi's tiny-table coffee scene. | What you'll get: At Iced milk coffee, you get drink culture, street stools, cold glasses, local refreshment, and sidewalk pauses: Vietnamese iced milk coffee glass with condensed milk swirl, cafe table, with cafe counters, street stools, local refreshment, and sweetness, alongside Hanoi's tiny-table coffee scene. | Say it locally: Say Cà phê sữa đá ở Hà Nội for Iced milk coffee. The local name is easier to remember once it sits beside street stools, local refreshment, sweetness, and city pauses, alongside Hanoi's tiny-table coffee scene. | Worth it if: Worth it if a cold glass, coffee pause, or sidewalk drink would make the day feel more local: iced glasses, cafe counters, street stools, and local refreshment, alongside Hanoi's tiny-table coffee scene. | Before you go: Iced milk coffee works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Vietnamese iced milk coffee glass with condensed milk swirl, cafe table with iced glasses, cafe counters, street stools, and local refreshment, alongside Hanoi's tiny-table coffee scene.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-cha-ca
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chả cá ở Hà Nội
- `english_name`: Turmeric dill fish
- `place_kind`: dish
- `source_notes`: Vietnam Travel Hanoi; MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlaceChaCa
- `legacy_summary`: Turmeric dill fish is worth trying in Hanoi because it gives the trip a flavor to imagine before arrival. Expect sizzling chả cá with dill and turmeric fish, noodles and herbs.
- `legacy_context`: For Turmeric dill fish, Hanoi's food story comes through flavor, herbs, sauce, and steam, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: Turmeric dill fish is worth trying because it turns Hanoi into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with sauce, steam, texture, and small meal rituals, alongside old-lane Hanoi. | What you'll get: At Turmeric dill fish, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: sizzling chả cá with dill and turmeric fish, noodles and herbs, with texture, small meal rituals, flavor, and herbs, alongside old-lane Hanoi. | Say it locally: Say Chả cá ở Hà Nội for Turmeric dill fish. The local name is easier to remember once it sits beside small meal rituals, flavor, herbs, and sauce, alongside old-lane Hanoi. | Worth it if: Worth it if you want a food memory rather than only a label: steam, texture, small meal rituals, and flavor, alongside old-lane Hanoi. | Before you go: Turmeric dill fish works best when the name is tied to the reason for going, not memorized as an abstract label. Picture sizzling chả cá with dill and turmeric fish, noodles and herbs with herbs, sauce, steam, and texture, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-cha-ca-thang-long
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chả cá Thăng Long
- `english_name`: Cha Ca Thang Long
- `place_kind`: restaurant
- `source_notes`: MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlaceChaCaThangLong
- `legacy_summary`: Cha Ca Thang Long is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect sizzling cha ca pan with dill and noodles on Hanoi table.
- `legacy_context`: For Cha Ca Thang Long, Hanoi's restaurant story comes through drinks, evening meal energy, tables, and house dishes, alongside Hanoi grill smoke and broth counters.
- `legacy_sections_compact`: Why go: Cha Ca Thang Long is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with drinks, evening meal energy, tables, and house dishes, alongside Hanoi grill smoke and broth counters. | What you'll get: At Cha Ca Thang Long, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: sizzling cha ca pan with dill and noodles on Hanoi table, with menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi grill smoke and broth counters. | Say it locally: Say Chả cá Thăng Long for Cha Ca Thang Long. The local name is easier to remember once it sits beside staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi grill smoke and broth counters. | Worth it if: Worth it if the meal itself should be one of the day's memories: house dishes, menu details, staff rhythm, and drinks, alongside Hanoi grill smoke and broth counters. | Before you go: Cha Ca Thang Long works best when the name is tied to the reason for going, not memorized as an abstract label. Picture sizzling cha ca pan with dill and noodles on Hanoi table with house dishes, menu details, staff rhythm, and drinks, alongside Hanoi grill smoke and broth counters.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
