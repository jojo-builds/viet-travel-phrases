# SpeakLocal v2.2 BATCH_020 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_020` in the final handoff block. Put `SpeakLocal v2.2 BATCH_020 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-la-maison-1888
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: La Maison 1888
- `english_name`: La Maison 1888
- `place_kind`: restaurant
- `source_notes`: Da Nang Fantasticity MICHELIN article; MICHELIN or venue source.
- `target_hero_image`: HeroCityDanangPlaceLaMaison1888
- `legacy_summary`: La Maison 1888 is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect elegant colonial-style dining room mood with white tablecloths.
- `legacy_context`: For La Maison 1888, Da Nang's restaurant story comes through menu details, staff rhythm, drinks, and evening meal energy, alongside Han River light.
- `legacy_sections_compact`: Why go: La Maison 1888 is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with drinks, evening meal energy, tables, and house dishes, alongside Han River light. | What you'll get: At La Maison 1888, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: elegant colonial-style dining room mood with white tablecloths, with tables, house dishes, menu details, and staff rhythm, alongside Han River light. | Say it locally: La Maison 1888 usually stays as the venue name. Say it slowly and connect it to the scene around it: house dishes, menu details, staff rhythm, and drinks, alongside Han River light. | Worth it if: Worth it if the meal itself should be one of the day's memories: house dishes, menu details, staff rhythm, and drinks, alongside Han River light. | Before you go: La Maison 1888 works best when the name is tied to the reason for going, not memorized as an abstract label. Picture elegant colonial-style dining room mood with white tablecloths with evening meal energy, tables, house dishes, and menu details, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-lady-buddha
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Tượng Phật Bà
- `english_name`: Lady Buddha
- `place_kind`: landmark
- `source_notes`: Vietnam Tourism Da Nang; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceLadyBuddha
- `legacy_summary`: Lady Buddha is the towering white statue at Linh Ung Pagoda on Son Tra Peninsula, looking back over Da Nang Bay. Save it for the statue, the pagoda visit, and the view over the coast.
- `legacy_context`: Lady Buddha is shorthand for the statue area at Linh Ung Pagoda, not a separate neighborhood. The hook is the huge white figure above the sea-facing city.
- `legacy_sections_compact`: Why go: Lady Buddha is worth knowing because the tall white statue at Linh Ung Pagoda is one of Da Nang's most visible coastal landmarks, looking over the city from Son Tra Peninsula. | What you'll get: At Lady Buddha, expect a respectful pagoda setting, sea air, broad views of Da Nang Bay, and the statue rising above trees and temple courtyards. | Say it locally: Say Tượng Phật Bà for Lady Buddha. If the place needs more context, add Sơn Trà or Linh Ứng so the statue connects to the peninsula and pagoda. | Worth it if: Worth it if you want a calm stop with views, temple courtyards, and a clearer sense of how Da Nang sits between mountain, peninsula, and sea. | Before you go: Before you go, remember that Lady Buddha usually means the statue area at Linh Ung Pagoda. The name is useful, but the pagoda and Son Tra setting give it meaning.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-le-duan-night-market
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chợ đêm Lê Duẩn
- `english_name`: Le Duan Night Market
- `place_kind`: market
- `source_notes`: Da Nang local tourism source; local map.
- `target_hero_image`: HeroCityDanangPlaceLeDuanNightMarket
- `legacy_summary`: Le Duan Night Market is worth knowing in Da Nang because it brings the city shifting from daytime movement into food, lights, and browsing into the trip. Expect compact night shopping lane with clothes racks and warm bulbs.
- `legacy_context`: For Le Duan Night Market, Da Nang's night market story comes through evening crowds, lanterns, food smoke, and small gifts, alongside bridge-and-beach Da Nang.
- `legacy_sections_compact`: Why go: Le Duan Night Market is worth knowing because it gives Da Nang a specific night market scene: warm lights, river edges, evening crowds, and lanterns, alongside bridge-and-beach Da Nang. | What you'll get: At Le Duan Night Market, you get the city shifting from daytime movement into food, lights, and browsing: compact night shopping lane with clothes racks and warm bulbs, with food smoke, small gifts, warm lights, and river edges, alongside bridge-and-beach Da Nang. | Say it locally: Say Chợ đêm Lê Duẩn for Le Duan Night Market. The local name is easier to remember once it sits beside lanterns, food smoke, small gifts, and warm lights, alongside bridge-and-beach Da Nang. | Worth it if: Worth it if Le Duan Night Market gives your itinerary a clearer image: river edges, evening crowds, lanterns, and food smoke, alongside bridge-and-beach Da Nang. | Before you go: Le Duan Night Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture compact night shopping lane with clothes racks and warm bulbs with river edges, evening crowds, lanterns, and food smoke, alongside bridge-and-beach Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-linh-ung-pagoda
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chùa Linh Ứng
- `english_name`: Linh Ung Pagoda
- `place_kind`: landmark
- `source_notes`: City library; Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceLinhUngPagoda
- `legacy_summary`: Linh Ung Pagoda is the Son Tra stop where Da Nang's coast, temple grounds, and the tall white Lady Buddha come together above the sea.
- `legacy_context`: Linh Ung Pagoda matters because the setting is part of the visit: courtyards, incense, sea wind, city views, and the Lady Buddha watching over the peninsula.
- `legacy_sections_compact`: Why go: Linh Ung Pagoda is worth visiting because the temple setting opens onto the sea. The white Lady Buddha, courtyards, incense, and Son Tra views make it one of Da Nang's clearest spiritual landmarks. | What you'll get: Expect a large pagoda complex, temple gates, incense, monkeys nearby on some days, and the tall Lady Buddha facing the water. The view back toward Da Nang is part of the payoff. | Say it locally: Say Chùa Linh Ứng for Linh Ung Pagoda. Chùa means pagoda or temple, and Linh Ứng identifies this Son Tra complex. | Worth it if: Worth it if you want a stop that mixes temple quiet with big coastal views. It pairs naturally with a Son Tra drive or Lady Buddha visit. | Before you go: Before you go, dress and move like you are entering an active religious place, even if the view and statue are what first drew you there.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-long-coffee
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cà phê Long
- `english_name`: Long Coffee
- `place_kind`: cafe
- `source_notes`: Local cafe source.
- `target_hero_image`: HeroCityDanangPlaceLongCoffee
- `legacy_summary`: Long Coffee is worth saving for Da Nang's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect old-school Vietnamese coffee table with metal phin and low stools.
- `legacy_context`: For Long Coffee, Da Nang's cafe story comes through street stools, design details, soft pauses, and cafe views, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Long Coffee is worth saving when you want Da Nang's cafe culture, not just caffeine: street stools, design details, soft pauses, and cafe views, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Long Coffee, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: old-school Vietnamese coffee table with metal phin and low stools, with coffee counters, iced glasses, street stools, and design details, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Cà phê Long for Long Coffee. The local name is easier to remember once it sits beside iced glasses, street stools, design details, and soft pauses, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: cafe views, coffee counters, iced glasses, and street stools, alongside Da Nang's seafood-and-mountain day. | Before you go: Long Coffee works best when the name is tied to the reason for going, not memorized as an abstract label. Picture old-school Vietnamese coffee table with metal phin and low stools with cafe views, coffee counters, iced glasses, and street stools, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

