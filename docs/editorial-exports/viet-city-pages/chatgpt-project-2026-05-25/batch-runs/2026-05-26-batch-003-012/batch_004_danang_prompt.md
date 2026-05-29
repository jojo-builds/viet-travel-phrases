# SpeakLocal v2.2 BATCH_004 - Da Nang B - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_004` in the final handoff block. Put `SpeakLocal v2.2 BATCH_004 - Da Nang B - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Extra anti-drift constraints for this 50-listing test:
- Keep phrase cards to 2-3, and only use ready-audio reusable phrases unless a place-name phrase already has ready audio.
- Do not create one-off phrases for a single attraction, restaurant, or object. Mark them as hidden/planned instead.
- Visible copy must not say `useful because`, `reference line`, `destination`, `anchor`, `content role`, `this page helps`, or `the job is`.
- Write travel copy, not a database note. Short, observed, specific, calm.
- If current venue facts might be stale, keep that risk in internal source/freshness notes instead of visible copy.

# New Chat Prompt for This Project

Use the five city listings in the `Exact batch rows` section below. They have already been claimed for this batch; do not select different rows from the ledger.

Before writing, read:
- the v2.2 Source Bundle,
- the Copy Ledger and Catalogs spreadsheet,
- the Canonical 31 examples inside the source bundle,
- the Phrase Picker Ready Audio tab,
- the Menu Catalog tab if any listing is food, drink, cafe, restaurant, dessert, market, or shop related.

For each listing, write one v2.2 app-detail draft. Use existing ready-audio phrase IDs when possible. Use existing menu/catalog items when natural. Do not invent facts. Do not write like a QA form.

Output in a readable review format first, not JSON. Start with a clean reader view that contains only app-visible copy. Put schema fields, self-score, QA, source notes, freshness notes, phrase/audio status, and Mentioned Here mapping after the reader view.

Self-score each draft against v2.2 voice and revise the weakest visible lines before final output. The score is an internal drafting aid only; the output remains draft/review material for later Jojo/Codex approval, import, and production validation.

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

### 1. city-danang-place-ba-na-hills
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bà Nà Hills
- `english_name`: Ba Na Hills
- `place_kind`: landmark
- `source_notes`: City library; Vietnam Tourism Da Nang; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceBaNaHills
- `legacy_summary`: Ba Na Hills is a mountain theme park, not just the Golden Bridge: cable cars, cooler air, replica French streets, gardens, indoor rides, crowds, and weather risk above Đà Nẵng.
- `legacy_context`: Ba Na Hills works when the day is planned as a full mountain outing, with weather, tickets, cable-car timing, and crowd expectations handled before leaving the city.
- `legacy_sections_compact`: Know You Are Choosing A Theme Park: Ba Na Hills is a mountain theme park, not just a quiet Golden Bridge viewpoint. Expect cable cars, replica French streets, gardens, rides, crowds, and weather risk. | Useful Phrases:  | Cooler Air, Bigger Production: The cable car gives the real arrival: forest below, cooler air above, and a full resort complex instead of a quiet lookout. Clear weather can make the scale feel cinematic. | Bridge Before The Crowd: If the Golden Bridge matters, go early and do it before the rest of the park. After that, decide how much French Village, gardens, rides, or food you actually want. | Early, With Weather Checked: Morning is the least painful crowd strategy. Fog or rain can turn the famous view into an expensive cloud walk, so the forecast matters before the ride west.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-bac-my-an-market
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chợ Bắc Mỹ An
- `english_name`: Bac My An Market
- `place_kind`: market
- `source_notes`: Local map.
- `target_hero_image`: HeroCityDanangPlaceBacMyAnMarket
- `legacy_summary`: Bắc Mỹ An Market is a smaller beach-side Đà Nẵng snack stop where kem bơ, small portions, cash, pointing, and spice questions matter more than souvenir browsing.
- `legacy_context`: Bắc Mỹ An makes sense near Mỹ An or Mỹ Khê, when a lower-pressure bite makes more sense than a full cross-city market mission.
- `legacy_sections_compact`: Start With Kem Bơ, Then Decide: Bắc Mỹ An Market is a small snack stop near the Mỹ An side of Đà Nẵng. Start with kem bơ, then decide whether one hot snack is enough. | Small Market, Small Orders: This is not the place to decode every stall. Point politely, ask what something is, check spice, and keep the first order small. | Useful Phrases:  | Beach-Side Snack Stop: The market is still worth it when you are already near Mỹ An, Mỹ Khê, or the beach side of the city. It does not need to become a cross-city mission. | Not Hàn Or Cồn: Hàn is better for central bearings and gifts; Cồn is stronger for a food crawl. Bắc Mỹ An is narrower, and that is the point.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-bach-dang-street
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Đường Bạch Đằng
- `english_name`: Bach Dang Street
- `place_kind`: street
- `source_notes`: City library; Vietnam Tourism/Da Nang sources.
- `target_hero_image`: HeroCityDanangPlaceBachDangStreet
- `legacy_summary`: Bach Dang Street is Da Nang's riverfront spine: bridges, promenade walks, cafes, hotels, and Han River lights all make more sense from this edge of the city.
- `legacy_context`: For Bach Dang Street, Da Nang's street story comes through street signs, shopfronts, scooters, and crossings, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: Bach Dang Street is worth recognizing because streets shape how Da Nang feels on the ground: street signs, shopfronts, scooters, and crossings, alongside central-Vietnam beach rhythm. | What you'll get: At Bach Dang Street, you get a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement: riverside promenade with street trees and city buildings, late afternoon, with cafe edges, neighborhood movement, street signs, and shopfronts, alongside central-Vietnam beach rhythm. | Say it locally: Say Đường Bạch Đằng for Bach Dang Street. The local name is easier to remember once it sits beside shopfronts, scooters, crossings, and cafe edges, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if the street helps you understand the neighborhood before you are there: neighborhood movement, street signs, shopfronts, and scooters, alongside central-Vietnam beach rhythm. | Before you go: Bach Dang Street works best when the name is tied to the reason for going, not memorized as an abstract label. Picture riverside promenade with street trees and city buildings, late afternoon with crossings, cafe edges, neighborhood movement, and street signs, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-ban-co-peak
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Đỉnh Bàn Cờ
- `english_name`: Ban Co Peak
- `place_kind`: landmark
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceBanCoPeak
- `legacy_summary`: Ban Co Peak is worth knowing in Da Nang because it brings architecture, views, local pride, and history in visual form into the trip. Expect mountain viewpoint road with Da Nang coastline below, soft haze.
- `legacy_context`: For Ban Co Peak, Da Nang's landmark story comes through views, local pride, history, and city light, alongside bridge-and-beach Da Nang.
- `legacy_sections_compact`: Why go: Ban Co Peak is worth knowing because it gives Da Nang a specific landmark scene: views, local pride, history, and city light, alongside bridge-and-beach Da Nang. | What you'll get: At Ban Co Peak, you get architecture, views, local pride, and history in visual form: mountain viewpoint road with Da Nang coastline below, soft haze, with landmark memory, architecture, views, and local pride, alongside bridge-and-beach Da Nang. | Say it locally: Say Đỉnh Bàn Cờ for Ban Co Peak. The local name is easier to remember once it sits beside local pride, history, city light, and landmark memory, alongside bridge-and-beach Da Nang. | Worth it if: Worth it if Ban Co Peak gives your itinerary a clearer image: architecture, views, local pride, and history, alongside bridge-and-beach Da Nang. | Before you go: Ban Co Peak works best when the name is tied to the reason for going, not memorized as an abstract label. Picture mountain viewpoint road with Da Nang coastline below, soft haze with architecture, views, local pride, and history, alongside bridge-and-beach Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-banh-mi
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Bánh mì ở Đà Nẵng
- `english_name`: Banh mi
- `place_kind`: dish
- `source_notes`: Vietnam food sources.
- `target_hero_image`: HeroCityDanangPlaceBanhMi
- `legacy_summary`: Banh mi is worth trying in Da Nang because it gives the trip a flavor to imagine before arrival. Expect crisp Vietnamese baguette sandwich with herbs on paper, street counter.
- `legacy_context`: For Banh mi, Da Nang's food story comes through herbs, sauce, steam, and texture, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Banh mi is worth trying because it turns Da Nang into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with herbs, sauce, steam, and texture, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Banh mi, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: crisp Vietnamese baguette sandwich with herbs on paper, street counter, with small meal rituals, flavor, herbs, and sauce, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Bánh mì ở Đà Nẵng for Banh mi. The local name is easier to remember once it sits beside texture, small meal rituals, flavor, and herbs, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if you want a food memory rather than only a label: sauce, steam, texture, and small meal rituals, alongside Da Nang's seafood-and-mountain day. | Before you go: Banh mi works best when the name is tied to the reason for going, not memorized as an abstract label. Picture crisp Vietnamese baguette sandwich with herbs on paper, street counter with texture, small meal rituals, flavor, and herbs, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
