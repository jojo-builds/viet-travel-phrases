# SpeakLocal v2.2 BATCH_015 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_015` in the final handoff block. Put `SpeakLocal v2.2 BATCH_015 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-cham-museum
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bảo tàng Điêu khắc Chăm
- `english_name`: Museum of Cham Sculpture
- `place_kind`: museum
- `source_notes`: City library; Da Nang Fantasticity; museum source.
- `target_hero_image`: HeroCityDanangPlaceChamMuseum
- `legacy_summary`: The Museum of Cham Sculpture is the calm downtown Đà Nẵng culture stop where Mỹ Sơn, Trà Kiệu, and Đồng Dương galleries help the city feel older than bridges and beaches.
- `legacy_context`: The museum works when the visit has a small looking plan: three galleries first, repeated forms next, and labels after the eye has adjusted.
- `legacy_sections_compact`: Pick Three First Rooms: Start with the Mỹ Sơn, Trà Kiệu, and Đồng Dương galleries instead of trying to read every label. The museum gives Đà Nẵng historical depth fast. | Quiet Stone, Warm Light: The rooms hold sandstone gods, dancers, altars, and temple fragments from Champa sites across central Vietnam. Daylight makes the sculpture feel calmer than an artifact list. | Useful Phrases:  | Look For Repeated Forms: Find national treasures if they are marked, then notice what repeats: dancers, deities, animals, altars, and carved movement. Pattern teaches faster than label-reading. | A Culture Stop Downtown: The museum sits close to the Hàn River and Dragon Bridge. It works as the slower counterweight to Đà Nẵng’s waterfront speed.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-che-xoa-xoa-hat-luu
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chè xoa xoa hạt lựu ở Đà Nẵng
- `english_name`: Da Nang sweet soup
- `place_kind`: dessert
- `source_notes`: Da Nang local food sources; local naming source.
- `target_hero_image`: HeroCityDanangPlaceCheXoaXoaHatLuu
- `legacy_summary`: Da Nang sweet soup is worth trying in Da Nang for sweetness, texture, color, and a small break between bigger plans. Expect colorful Vietnamese dessert glass with jelly, coconut, and crushed ice, market.
- `legacy_context`: For Da Nang sweet soup, Da Nang's sweet story comes through coconut milk, jelly, shaved ice, and fruit, alongside Han River light.
- `legacy_sections_compact`: Why go: Da Nang sweet soup is worth trying for the sweet side of Da Nang: the sweet side of the city through cups, ice, fruit, jelly, coconut milk, and evening snack counters, with fruit, color, evening snack counters, and dessert cups, alongside Han River light. | What you'll get: At Da Nang sweet soup, you get the sweet side of the city through cups, ice, fruit, jelly, coconut milk, and evening snack counters: colorful Vietnamese dessert glass with jelly, coconut, and crushed ice, market, with fruit, color, evening snack counters, and dessert cups, alongside Han River light. | Say it locally: Say Chè xoa xoa hạt lựu ở Đà Nẵng for Da Nang sweet soup. The local name is easier to remember once it sits beside jelly, shaved ice, fruit, and color, alongside Han River light. | Worth it if: Worth it if you want the sweet, textural side of the city: color, evening snack counters, dessert cups, and coconut milk, alongside Han River light. | Before you go: Da Nang sweet soup works best when the name is tied to the reason for going, not memorized as an abstract label. Picture colorful Vietnamese dessert glass with jelly, coconut, and crushed ice, market with dessert cups, coconut milk, jelly, and shaved ice, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-co-chu-nho
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cô Chủ Nhỏ
- `english_name`: Co Chu Nho
- `place_kind`: restaurant
- `source_notes`: MICHELIN article/search source; venue source.
- `target_hero_image`: HeroCityDanangPlaceCoChuNho
- `legacy_summary`: Co Chu Nho is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect casual Vietnamese eatery table with duck or noodle dishes.
- `legacy_context`: For Co Chu Nho, Da Nang's restaurant story comes through tables, house dishes, menu details, and staff rhythm, alongside Han River light.
- `legacy_sections_compact`: Why go: Co Chu Nho is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with tables, house dishes, menu details, and staff rhythm, alongside Han River light. | What you'll get: At Co Chu Nho, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: casual Vietnamese eatery table with duck or noodle dishes, with menu details, staff rhythm, drinks, and evening meal energy, alongside Han River light. | Say it locally: Say Cô Chủ Nhỏ for Co Chu Nho. The local name is easier to remember once it sits beside evening meal energy, tables, house dishes, and menu details, alongside Han River light. | Worth it if: Worth it if the meal itself should be one of the day's memories: staff rhythm, drinks, evening meal energy, and tables, alongside Han River light. | Before you go: Co Chu Nho works best when the name is tied to the reason for going, not memorized as an abstract label. Picture casual Vietnamese eatery table with duck or noodle dishes with staff rhythm, drinks, evening meal energy, and tables, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-con-market
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chợ Cồn
- `english_name`: Con Market
- `place_kind`: market
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceConMarket
- `legacy_summary`: Cồn Market is the food-first Đà Nẵng market: rougher than Hàn, stronger for local snacks, and better when you want stools, steam, small portions, and cash-ready browsing.
- `legacy_context`: Cồn Market should be treated as a snack market before a souvenir stop, especially when the goal is Đà Nẵng food rhythm rather than easy central orientation.
- `legacy_sections_compact`: The Food-First Market: Cồn Market is the better choice when eating matters more than souvenir shopping. Compared with Hàn, it feels rougher around the edges and more snack-focused. | Aisles, Stools, Steam: Inside, sweet stalls and hot-food counters sit close together. Outside, carts and plastic stools make the market quicker, louder, and more local-feeling. | Useful Phrases:  | Afternoon For Snacks: Morning gives fresh-market texture, but afternoon is a strong snack window. The stop is still worth it when you want Đà Nẵng food rhythm in a working market. | Different Job Than Hàn: Hàn is easier for central bearings and gifts. Cồn is better when you want small dishes, cash, stool seating, and a less polished food crawl.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-cong-caphe-bach-dang
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cộng Cà Phê Bạch Đằng
- `english_name`: Cong Caphe Bach Dang
- `place_kind`: cafe
- `source_notes`: Venue and local map sources.
- `target_hero_image`: HeroCityDanangPlaceCongCapheBachDang
- `legacy_summary`: Cong Caphe Bach Dang is worth saving for Da Nang's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect green-toned Vietnamese cafe balcony near river, street-side details.
- `legacy_context`: For Cong Caphe Bach Dang, Da Nang's cafe story comes through soft pauses, cafe views, coffee counters, and iced glasses, alongside coastal Da Nang.
- `legacy_sections_compact`: Why go: Cong Caphe Bach Dang is worth saving when you want Da Nang's cafe culture, not just caffeine: street stools, design details, soft pauses, and cafe views, alongside coastal Da Nang. | What you'll get: At Cong Caphe Bach Dang, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: green-toned Vietnamese cafe balcony near river, street-side details, with street stools, design details, soft pauses, and cafe views, alongside coastal Da Nang. | Say it locally: Say Cộng Cà Phê Bạch Đằng for Cong Caphe Bach Dang. The local name is easier to remember once it sits beside iced glasses, street stools, design details, and soft pauses, alongside coastal Da Nang. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: cafe views, coffee counters, iced glasses, and street stools, alongside coastal Da Nang. | Before you go: Cong Caphe Bach Dang works best when the name is tied to the reason for going, not memorized as an abstract label. Picture green-toned Vietnamese cafe balcony near river, street-side details with cafe views, coffee counters, iced glasses, and street stools, alongside coastal Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

