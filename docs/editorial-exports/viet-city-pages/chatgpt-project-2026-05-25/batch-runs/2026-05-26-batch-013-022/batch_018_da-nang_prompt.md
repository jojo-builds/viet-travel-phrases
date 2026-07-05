# SpeakLocal v2.2 BATCH_018 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_018` in the final handoff block. Put `SpeakLocal v2.2 BATCH_018 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-hai-van-pass
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Đèo Hải Vân
- `english_name`: Hai Van Pass
- `place_kind`: landmark
- `source_notes`: Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceHaiVanPass
- `legacy_summary`: Hai Van Pass is the mountain road between Da Nang and Hue, famous for ocean bends, low clouds, and views down toward Lang Co and the coast. Save it when the ride itself is part of the plan.
- `legacy_context`: Hai Van Pass is less about one building and more about a coastal mountain crossing: curves, viewpoints, mist, and the feeling of leaving Da Nang by the scenic route.
- `legacy_sections_compact`: Why go: Hai Van Pass is worth knowing because it is the coastal mountain road that makes the Da Nang-Hue route feel like part of the trip, with sea views, curves, clouds, and viewpoint stops. | What you'll get: At Hai Van Pass, expect a winding climb, ocean below, green slopes, old lookout points, and the sense that central Vietnam is changing from city and beach into mountains and lagoon. | Say it locally: Say Đèo Hải Vân for Hai Van Pass. Đèo means pass, so the phrase clarifies whether the route goes over the mountain road rather than through the tunnel. | Worth it if: Worth it if the transfer day can become scenic: a motorbike ride, private car stop, or slow route with photos instead of only getting from one city to another. | Before you go: Before you go, decide whether the pass is the route or the destination. If the ride is the point, the pass name matters more than a generic transfer phrase.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-hai-van-pass-ride
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chuyến đi đèo Hải Vân
- `english_name`: Hai Van Pass ride
- `place_kind`: experience
- `source_notes`: Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceHaiVanPassRide
- `legacy_summary`: Hai Van Pass ride is worth knowing in Da Nang because it brings movement across the city as part of the discovery into the trip. Expect open scenic pass road with guardrail and coastline, morning clouds.
- `legacy_context`: For Hai Van Pass ride, Da Nang's route story comes through cafe pauses, local movement, the route between named places, and street corners, alongside Han River light.
- `legacy_sections_compact`: Why go: Hai Van Pass ride is worth knowing because it gives Da Nang a specific route scene: cafe pauses, local movement, the route between named places, and street corners, alongside Han River light. | What you'll get: At Hai Van Pass ride, you get movement across the city as part of the discovery: open scenic pass road with guardrail and coastline, morning clouds, with the route between named places, street corners, food stops, and cafe pauses, alongside Han River light. | Say it locally: Say Chuyến đi đèo Hải Vân for Hai Van Pass ride. The local name is easier to remember once it sits beside local movement, the route between named places, street corners, and food stops, alongside Han River light. | Worth it if: Worth it if Hai Van Pass ride gives your itinerary a clearer image: street corners, food stops, cafe pauses, and local movement, alongside Han River light. | Before you go: Hai Van Pass ride works best when the name is tied to the reason for going, not memorized as an abstract label. Picture open scenic pass road with guardrail and coastline, morning clouds with local movement, the route between named places, street corners, and food stops, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-han-market
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chợ Hàn
- `english_name`: Han Market
- `place_kind`: market
- `source_notes`: City library; Vietnam Tourism/Da Nang sources.
- `target_hero_image`: HeroCityDanangPlaceHanMarket
- `legacy_summary`: Hàn Market gives a quick first read on central Đà Nẵng: mắm, dried seafood, fabric, rattan bags, and breakfast bowls under one roof, close enough to pair with the river or Dragon Bridge.
- `legacy_context`: Hàn Market sits in central Đà Nẵng as an easy first-bearings market: useful for a food lap, a gift errand, or a quick city-center orientation stop.
- `legacy_sections_compact`: A Market For First Bearings: Hàn Market gives you a practical first read on central Đà Nẵng. Jars of mắm, dried squid, fabric stalls, rattan bags, and breakfast bowls make the city feel specific even if you buy nothing. | Walk Once Before Choosing: The food area is easier after one slow lap. Notice where people are eating, then choose mì Quảng, bánh bèo, nem lụi, or a small bánh xèo instead of ordering from the first call. | Useful Phrases:  | Morning Food, Later Gifts: Food rhythm is strongest early, while fabric, dried food, and souvenir browsing can feel easier after the first rush. The stop is still worth it because it gives central Đà Nẵng a working-market texture. | Different Job Than Cồn: Hàn is the easier central market for bearings and gifts. Cồn is the stronger food-first choice when snacks matter more than location or polished browsing.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-han-river
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Sông Hàn
- `english_name`: Han River
- `place_kind`: river
- `source_notes`: City library; Vietnam Tourism/Da Nang sources.
- `target_hero_image`: HeroCityDanangPlaceHanRiver
- `legacy_summary`: Han River is worth knowing because water helps organize Da Nang: bridges, reflections, banks, boats, and evening light. Expect calm Han River with bridge silhouettes and promenade, evening river light.
- `legacy_context`: For Han River, Da Nang's river story comes through bridges, reflections, river walks, and waterline views, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Han River is worth knowing because the water helps organize the city: evening light, boats, bridges, and reflections, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Han River, you get geography, history, and everyday movement meeting: calm Han River with bridge silhouettes and promenade, evening river light, with river walks, waterline views, evening light, and boats, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Sông Hàn for Han River. The local name is easier to remember once it sits beside boats, bridges, reflections, and river walks, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if Han River gives your itinerary a clearer image: waterline views, evening light, boats, and bridges, alongside Da Nang's seafood-and-mountain day. | Before you go: Han River works best when the name is tied to the reason for going, not memorized as an abstract label. Picture calm Han River with bridge silhouettes and promenade, evening river light with reflections, river walks, waterline views, and evening light, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-han-river-cruise
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Du thuyền sông Hàn
- `english_name`: Han River cruise
- `place_kind`: experience
- `source_notes`: Da Nang tourism sources; operator-neutral source.
- `target_hero_image`: HeroCityDanangPlaceHanRiverCruise
- `legacy_summary`: Han River cruise is worth knowing in Da Nang because it brings water travel as part of the place rather than only transport into the trip. Expect small cruise boat on Han River at night with bridge lights.
- `legacy_context`: For Han River cruise, Da Nang's boat experience story comes through water light, riverbanks, bridges, and boarding points, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Han River cruise is worth knowing because it gives Da Nang a specific boat experience scene: water light, riverbanks, bridges, and boarding points, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Han River cruise, you get water travel as part of the place rather than only transport: small cruise boat on Han River at night with bridge lights, with bridges, boarding points, a slower path across the day, and boats, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Du thuyền sông Hàn for Han River cruise. The local name is easier to remember once it sits beside boats, water light, riverbanks, and bridges, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if Han River cruise gives your itinerary a clearer image: boarding points, a slower path across the day, boats, and water light, alongside Da Nang's seafood-and-mountain day. | Before you go: Han River cruise works best when the name is tied to the reason for going, not memorized as an abstract label. Picture small cruise boat on Han River at night with bridge lights with riverbanks, bridges, boarding points, and a slower path across the day, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

