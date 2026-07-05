SpeakLocal v2.2 BATCH_022 - Da Nang - 2026-05-26

Source basis read: exact BATCH_022 prompt and rows, v2.2 project instructions, v2.2 source bundle/current standard, and Copy Ledger/Catalog rows for the five Da Nang entries.    

## 1. Ngũ Hành Sơn / Marble Mountains — Da Nang — landmark

### Reader View

**The Climb Is The Point**

Marble Mountains is close enough to feel like a city stop, but it asks for stairs, cave air, incense, and pauses at pagoda gates. Come ready to move through it, not just stand below for the name.

### Useful phrase cards

* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?

### Sections

**Stairs Before Viewpoints**

The first stretch tells you what kind of visit this is. Stone steps, shaded rock, and temple corners slow the pace before the higher views back toward the beach side of Đà Nẵng.

**Caves Change The Mood**

Inside the chambers, the air drops and shrine light does more than any single photo. Move quietly, give people room, and let your eyes adjust before reaching for the camera.

**Stone Shops At The Base**

The streets below have stone-carving shops and traffic around the entrance area. Browse only if you have attention left; the climb itself is already enough for one compact stop.

### Implementation notes

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-marble-mountains`
* `displayName: Ngũ Hành Sơn`
* `englishName: Marble Mountains`
* `city: Đà Nẵng`
* `category: Landmark`
* `pronunciation: ngoo hanh son`
* `target_hero_image: HeroCityDanangPlaceMarbleMountains`

**Closest canonical anchor:** Dragon Bridge / Cầu Rồng, with Ba Na Hills as secondary expectation-setting support.
**Anchor behavior copied:** Turn a known attraction into the real traveler decision: where to put your body and attention.
**How this page differs:** Marble Mountains is not a single viewing position; it is a compact climb through stairs, caves, pagodas, and base streets.
**Owned traveler moment:** Arriving at the base, choosing to climb in rather than photograph from outside.

**Phrase/audio status**

* `vi: Lối vào ở đâu?` · `en: Where is the entrance?` · `intent: ask_entrance` · `phraseId: v500-sigh-acti-where-is-the-entrance` · `audioId: v500-sigh-acti-where-is-the-entrance` · `status: mapped`
* `vi: Vé bao nhiêu?` · `en: How much is the ticket?` · `intent: ask_ticket_price` · `phraseId: sight-1` · `audioId: sight-1` · `status: mapped`
* `vi: Tôi chụp hình ở đây được không?` · `en: Can I take photos here?` · `intent: ask_photo_permission` · `phraseId: sight-3` · `audioId: sight-3` · `status: mapped`
* Place-name pronunciation support: `city-danang-place-marble-mountains` · `audioId: audio-authored-ngu-hanh-son-7cd09d8626` · ready audio · render as name/pronunciation support, not as a phrase card.

**Mentioned Here candidates**

* **Đà Nẵng** — `type: city` · `catalogId: existing_or_null` · `status: check_catalog`

  * `displaySubtitle: The city base for this compact climb.`
  * `reason: Named naturally in the viewpoint section.`
* **Marble Mountain cave walk** — `type: experience` · `catalogId: danang-marble-mountain-cave-walk` · `status: render`

  * `displaySubtitle: Cave-and-shrine layer inside the mountain visit.`
  * `reason: The copy makes caves a central part of the traveler action.`

**Related place candidates**

* **Ngu Hanh Son District** — `relationship: nearby_area_context` · `catalogId: danang-ngu-hanh-son-district` · `status: check_catalog`

  * `displaySubtitle: Neighborhood context around the mountain cluster.`
  * `reason: Related by location, but not necessary unless route planning needs district context.`
* **My Khe Beach** — `relationship: view_context` · `catalogId: danang-my-khe-beach` · `status: do_not_render`

  * `displaySubtitle: Beach-side context visible from higher points.`
  * `reason: Beach side is mentioned as orientation, not a strong route/comparison link.`

**Verification flags**

* `type: light` · `reason: Ticketing, entrance flow, cave access, and photo expectations can change.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio reusable phrases but still need final native QA in batch review.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm exact render targets for Đà Nẵng city and Marble Mountain cave walk.` · `blocking: false`

**Source notes**

* Based on batch row legacy summary and catalog row: limestone/marble hills south of Da Nang, caves, pagodas, stone steps, viewpoints, and nearby stone-carving shops.
* Source labels: City library; Vietnam Tourism Da Nang.
* No visible claims about hours, ticket amount, closures, or route rules.

**Score**
28/30 — Strong traveler moment and concrete detail. Capped for light access/ticket/photo verification and unrun render/screenshot review.

**QA notes**

* Replaceability test: pass. Stairs, cave air, pagoda gates, stone shops, and beach-side view keep it place-specific.
* Phrase card test: pass. 3 ready-audio reusable traveler-action phrases; no place-name phrase card.
* Mentioned Here test: pass. Natural cave/Da Nang references evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex validation.

---

## 2. Mì Quảng ở Đà Nẵng / Mi Quang — Da Nang — dish

### Reader View

**Look For The Shallow Bowl**

Mì Quảng in Đà Nẵng is not a soupy noodle bowl. It usually lands wide and shallow: turmeric-colored noodles, a little rich broth, herbs, peanuts, and a rice cracker that makes the first bite more about texture than steam.

### Useful phrase cards

* **“Cho tôi một phần.”** — One portion, please.
* **“Ít cay thôi.”** — Less spicy, please.
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?

### Sections

**Choose The Protein First**

Menus often split the bowl by chicken, shrimp-and-pork, or a house mix. Pick that before worrying about the extras; the noodles, herbs, peanuts, and cracker are the shape that makes it mì Quảng.

**Break The Cracker Late**

The rice cracker is not garnish to ignore. Break it once the bowl is in front of you, then pull herbs through the sauce so the crunch does not disappear too early.

**A Local Meal That Stays Light**

A good bowl sits between beach-day ease and central-Vietnam depth: dry enough to stay light, saucy enough to remember. It is a smart first local meal when a full seafood spread feels too big.

### Implementation notes

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-mi-quang`
* `displayName: Mì Quảng ở Đà Nẵng`
* `englishName: Mi Quang`
* `city: Đà Nẵng`
* `category: Dish`
* `pronunciation: mee gwahng`
* `target_hero_image: HeroCityDanangPlaceMiQuang`

**Closest canonical anchor:** Cà phê Giảng for food ritual, with Chợ Cồn for food-first texture cues.
**Anchor behavior copied:** Give the traveler one clear first order and one tactile way to understand the item.
**How this page differs:** This is a dish page, not a venue; the copy teaches recognition, ordering choice, and eating rhythm.
**Owned traveler moment:** The bowl arrives and the traveler has to understand the shallow sauce, herbs, peanuts, and cracker.

**Phrase/audio status**

* `vi: Cho tôi một phần.` · `en: One portion, please.` · `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* `vi: Ít cay thôi.` · `en: Less spicy, please.` · `intent: reduce_spice` · `phraseId: food-not-spicy-clearer` · `audioId: audio-authored-it-cay-thoi-05b8e258a2` · `status: mapped`
* `vi: Cái này có chứa tôm không?` · `en: Does this contain shrimp?` · `intent: ask_shrimp` · `phraseId: v500-food-drin-does-this-contain-shrimp` · `audioId: v500-food-drin-does-this-contain-shrimp` · `status: mapped`
* Place-name pronunciation support: `city-danang-place-mi-quang` · planned/no ready audio · `hide_until_audio` for name pronunciation if needed.

**Mentioned Here candidates**

* **Mì Quảng gà** — `type: food` · `catalogId: food-mi-quang-ga` · `status: render`

  * `displaySubtitle: Quảng-style turmeric noodles with chicken.`
  * `reason: Named naturally in the protein-choice section and present in Menu Catalog.`
* **Mì Quảng tôm thịt** — `type: food` · `catalogId: food-mi-quang-tom-thit` · `status: render`

  * `displaySubtitle: Quảng-style turmeric noodles with shrimp and pork.`
  * `reason: Named naturally in the protein-choice section and present in Menu Catalog.`
* **Đà Nẵng** — `type: city` · `catalogId: existing_or_null` · `status: check_catalog`

  * `displaySubtitle: Central Vietnam base for the dish page.`
  * `reason: Named in intro and dish identity line.`

**Related place candidates**

* **Mì Quảng 1A** — `relationship: place_to_try_dish` · `catalogId: danang-mi-quang-1a` · `status: render`

  * `displaySubtitle: A focused Da Nang noodle stop for this dish.`
  * `reason: Exact batch sibling and natural route from dish page to restaurant page.`
* **Mỳ Quảng Bà Mua** — `relationship: alternate_restaurant` · `catalogId: danang-my-quang-ba-mua` · `status: check_catalog`

  * `displaySubtitle: Another Da Nang mì Quảng restaurant to compare after catalog QA.`
  * `reason: Existing catalog neighbor, but not named in visible copy.`
* **Mỳ Quảng Dung** — `relationship: alternate_restaurant` · `catalogId: danang-my-quang-dung` · `status: check_catalog`

  * `displaySubtitle: Another Da Nang mì Quảng option to confirm before rendering.`
  * `reason: Existing catalog neighbor, but not named in visible copy.`

**Verification flags**

* `type: catalog_qa` · `reason: Confirm whether generic Mì Quảng page should render beside variant menu items or only variants should render.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio reusable phrases but still need final native QA in batch review.` · `blocking: false`
* `type: audio_qa` · `reason: Place-name phrase row is planned/no ready audio; hide name phrase until audio exists.` · `blocking: false`

**Source notes**

* Batch source notes: Vietnam Tourism/Da Nang food sources; local source.
* Menu Catalog confirms Mì Quảng gà and Mì Quảng tôm thịt with wide turmeric rice noodles, broth/sauce, peanuts, and rice cracker.
* No visible claims about a specific shop, current price, opening hours, or availability on a given day.

**Score**
28/30 — Strong food recognition and ordering copy with mapped reusable phrase cards. Capped for name-audio gap, catalog QA, and unrun render/screenshot review.

**QA notes**

* Replaceability test: pass. Shallow bowl, turmeric noodles, peanuts, rice cracker, and chicken/shrimp-pork split keep it specific.
* Phrase card test: pass. 3 ready-audio reusable traveler-action phrases; no one-off dish phrase.
* Mentioned Here test: pass. Natural menu/catalog items evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex validation.

---

## 3. Mì Quảng 1A / Mi Quang 1A — Da Nang — restaurant

### Reader View

**A Fast Table For A Focused Bowl**

Mì Quảng 1A keeps the meal narrow: sit down, choose the bowl style, fold in the herbs, and let the day keep moving. The room matters less than the noodle rhythm and the small decisions before the first bite.

### Useful phrase cards

* **“Cho tôi xem thực đơn được không?”** — Can I see the menu?
* **“Cho tôi một phần.”** — One portion, please.
* **“Tính tiền giúp tôi.”** — Please let me pay.

### Sections

**Know The Bowl Style**

This is not the moment for a broad Da Nang dinner. Keep the order around mì Quảng and decide chicken, shrimp-and-pork, or whatever house version the menu is actually serving that day.

**Herbs Do Some Work**

The greens, peanuts, sauce, and cracker are part of the balance. Taste once before adding more heat, then fold the herbs through instead of leaving them beside the bowl.

**Short Meal, Clear Memory**

This kind of noodle stop fits a day with river light, beach time, or a museum already on it. It gives the itinerary local flavor without turning lunch into a long sit.

### Implementation notes

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-mi-quang-1a`
* `displayName: Mì Quảng 1A`
* `englishName: Mi Quang 1A`
* `city: Đà Nẵng`
* `category: Restaurant`
* `pronunciation: mee gwahng mot ah`
* `target_hero_image: HeroCityDanangPlaceMiQuang1a`

**Closest canonical anchor:** Bà Lễ Well / Bale Well, with Cà phê Giảng as a food-ritual secondary anchor.
**Anchor behavior copied:** Reduce restaurant friction by giving the traveler a first ordering move and a rhythm for the table.
**How this page differs:** The friction is not a set menu or rolling technique; it is keeping a famous local dish stop narrow and readable.
**Owned traveler moment:** Sitting at a small noodle-shop table and choosing the bowl before the table fills with herbs, cracker, and sauce.

**Phrase/audio status**

* `vi: Cho tôi xem thực đơn được không?` · `en: Can I see the menu?` · `intent: ask_menu` · `phraseId: food-menu` · `audioId: food-menu` · `status: mapped`
* `vi: Cho tôi một phần.` · `en: One portion, please.` · `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* `vi: Tính tiền giúp tôi.` · `en: Please let me pay.` · `intent: ask_to_pay` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`
* Place-name pronunciation support: `city-danang-place-mi-quang-1a` · planned/no ready audio · `hide_until_audio` for name pronunciation if needed.

**Mentioned Here candidates**

* **Mì Quảng** — `type: food` · `catalogId: danang-mi-quang` · `status: render`

  * `displaySubtitle: The Da Nang dish behind the focused order.`
  * `reason: The restaurant copy centers on ordering mì Quảng.`
* **Mì Quảng gà** — `type: food` · `catalogId: food-mi-quang-ga` · `status: render`

  * `displaySubtitle: Chicken version of Quảng-style turmeric noodles.`
  * `reason: Named naturally as a bowl-style option.`
* **Mì Quảng tôm thịt** — `type: food` · `catalogId: food-mi-quang-tom-thit` · `status: render`

  * `displaySubtitle: Shrimp-and-pork version of Quảng-style turmeric noodles.`
  * `reason: Named naturally as a bowl-style option.`
* **Đà Nẵng** — `type: city` · `catalogId: existing_or_null` · `status: check_catalog`

  * `displaySubtitle: City context for the restaurant stop.`
  * `reason: Named naturally in the restaurant positioning section.`

**Related place candidates**

* **Mì Quảng ở Đà Nẵng** — `relationship: dish_context` · `catalogId: danang-mi-quang` · `status: render`

  * `displaySubtitle: Learn the dish before choosing a bowl.`
  * `reason: Direct dish-page pairing for this restaurant.`
* **Mỳ Quảng Bà Mua** — `relationship: alternate_restaurant` · `catalogId: danang-my-quang-ba-mua` · `status: check_catalog`

  * `displaySubtitle: Another mì Quảng restaurant to compare after catalog QA.`
  * `reason: Existing catalog neighbor, not visible-copy supported yet.`
* **Mỳ Quảng Dung** — `relationship: alternate_restaurant` · `catalogId: danang-my-quang-dung` · `status: check_catalog`

  * `displaySubtitle: Another mì Quảng stop to confirm before rendering.`
  * `reason: Existing catalog neighbor, not visible-copy supported yet.`

**Verification flags**

* `type: light` · `reason: Current opening status, menu variants, address, and service rhythm should be checked before import.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio reusable phrases but still need final native QA in batch review.` · `blocking: false`
* `type: audio_qa` · `reason: Place-name phrase row is planned/no ready audio; hide name phrase until audio exists.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm restaurant and variant dish card targets before render.` · `blocking: false`

**Source notes**

* Batch source notes: local food source.
* Legacy context supports small noodle shop table with turmeric noodles and herbs.
* Menu Catalog supports the chicken and shrimp-pork mì Quảng variants; visible copy avoids claiming current menu availability beyond “whatever house version the menu is actually serving that day.”

**Score**
27/30 — Stronger than legacy and usable as draft, but capped for venue freshness, sparse current evidence, name-audio gap, and unrun render/screenshot review.

**QA notes**

* Replaceability test: pass. Small noodle-shop table, narrow order, herbs/cracker/sauce, and bowl-style choice differentiate it.
* Phrase card test: pass. 3 ready-audio reusable traveler-action phrases; no one-off venue phrase.
* Mentioned Here test: pass. Natural dish and variant mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex validation.

---

## 4. Bảo tàng Đà Nẵng / Da Nang Museum — Da Nang — museum

### Reader View

**The City Gets The First Word**

Da Nang Museum is the counterweight to a beach-and-bridge trip. Go in for the city itself: riverfront civic space, local history, regional culture, and enough indoor quiet to reset the day.

### Useful phrase cards

* **“Xin một vé.”** — One ticket, please.
* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Có hướng dẫn tiếng Anh không?”** — Is there an English guide?

### Sections

**Pick One Thread**

Choose city history, wartime context, or regional culture before reading every wall. A short museum visit feels better when you leave with one clear thread instead of ten half-read rooms.

**Bạch Đằng Changes The Exit**

The riverfront location makes the after-museum move easy: step back into daylight, walk the Hàn River side, and let bridges and traffic make more sense with some city context behind them.

**Quiet Beats Completion**

This is an indoor pause, not a test. Stop at a few objects, skip the rest, and leave while the city still feels sharper.

### Implementation notes

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-museum`
* `displayName: Bảo tàng Đà Nẵng`
* `englishName: Da Nang Museum`
* `city: Đà Nẵng`
* `category: Museum`
* `pronunciation: bao tang da nang`
* `target_hero_image: HeroCityDanangPlaceMuseum`

**Closest canonical anchor:** Da Nang Museum canonical secondary example, with Museum of Cham Sculpture for museum-fatigue prevention.
**Anchor behavior copied:** Make the museum visit manageable by choosing one thread rather than reading everything.
**How this page differs:** This is a city-first museum and current-venue stop, not an art/form-based museum like Cham Sculpture.
**Owned traveler moment:** A traveler steps indoors after beach/bridge impressions and chooses one museum thread before the visit becomes a checklist.

**Phrase/audio status**

* `vi: Xin một vé.` · `en: One ticket, please.` · `intent: request_one_ticket` · `phraseId: v500-time-date-book-one-ticket-please` · `audioId: v500-time-date-book-one-ticket-please` · `status: mapped`
* `vi: Lối vào ở đâu?` · `en: Where is the entrance?` · `intent: ask_entrance` · `phraseId: v500-sigh-acti-where-is-the-entrance` · `audioId: v500-sigh-acti-where-is-the-entrance` · `status: mapped`
* `vi: Có hướng dẫn tiếng Anh không?` · `en: Is there an English guide?` · `intent: ask_english_guide` · `phraseId: v900-sigh-acti-is-there-an-english-guide` · `audioId: v900-sigh-acti-is-there-an-english-guide` · `status: mapped`
* Place-name pronunciation support: `city-danang-place-museum` · planned/no ready audio · `hide_until_audio` for name pronunciation if needed.

**Mentioned Here candidates**

* **Đà Nẵng** — `type: city` · `catalogId: existing_or_null` · `status: check_catalog`

  * `displaySubtitle: The city behind the museum visit.`
  * `reason: Named in the museum title and city-first intro.`
* **Đường Bạch Đằng** — `type: street` · `catalogId: danang-bach-dang-street` · `status: render`

  * `displaySubtitle: Riverfront street for the post-museum walk.`
  * `reason: Named naturally in the exit-route section.`
* **Sông Hàn** — `type: river` · `catalogId: danang-han-river` · `status: render`

  * `displaySubtitle: Riverfront context after the museum.`
  * `reason: Named naturally as the after-museum walk.`
* **Dragon Bridge** — `type: landmark` · `catalogId: danang-dragon-bridge` · `status: check_catalog`

  * `displaySubtitle: Nearby bridge context after a city-history stop.`
  * `reason: Bridges are referenced generally; render only if catalog QA wants a more specific related card.`

**Related place candidates**

* **Da Nang Museum Branch 2** — `relationship: museum_pairing` · `catalogId: danang-museum-branch-2` · `status: render`

  * `displaySubtitle: A quieter branch-style museum stop to compare with the main city museum.`
  * `reason: Exact batch sibling and useful comparison/route candidate.`
* **Museum of Cham Sculpture** — `relationship: museum_contrast` · `catalogId: danang-cham-museum` · `status: render`

  * `displaySubtitle: A more focused art-and-heritage museum near the central river area.`
  * `reason: Canonical museum-fatigue comparator and existing catalog item.`
* **Da Nang Fine Arts Museum** — `relationship: museum_contrast` · `catalogId: danang-fine-arts-museum` · `status: render`

  * `displaySubtitle: A compact art-focused museum alternative downtown.`
  * `reason: Useful museum comparison for travelers choosing one indoor culture stop.`

**Verification flags**

* `type: same_week` · `reason: Entrance flow, hours, ticket price, exhibitions, and English-guide/interpretation availability should be checked close to publication.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio reusable phrases but still need final native QA in batch review.` · `blocking: false`
* `type: audio_qa` · `reason: Place-name phrase row is planned/no ready audio; hide name phrase until audio exists.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm render targets for Bạch Đằng, Sông Hàn, Branch 2, Cham Museum, and Fine Arts Museum.` · `blocking: false`

**Source notes**

* Batch source notes: Da Nang Fantasticity; local map.
* Legacy copy supports Bạch Đằng, city-first culture role, renovated setting, and need to verify current entrance/hours/ticket/special exhibits.
* Visible copy avoids current hours, ticket amount, exact entrance address, and current exhibition claims.

**Score**
27/30 — Clearer voice and useful museum route, but capped for same-week venue verification, name-audio gap, and unrun render/screenshot review.

**QA notes**

* Replaceability test: pass. Bạch Đằng, Hàn River, beach/bridge contrast, and city-first museum role keep it specific.
* Phrase card test: pass. 3 ready-audio reusable traveler-action phrases; no place-name phrase card.
* Mentioned Here test: pass. Natural street/river/city/museum mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex validation.

---

## 5. Bảo tàng Đà Nẵng - Cơ sở 2 / Da Nang Museum Branch 2 — Da Nang — museum

### Reader View

**A Quieter Way Into The City**

Da Nang Museum Branch 2 is better treated as a small culture pause than another box to tick. Courtyard light, gallery rooms, display cases, and a few well-chosen objects can make the city feel less flat after beaches, bridges, and seafood plans.

### Useful phrase cards

* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Có hướng dẫn tiếng Anh không?”** — Is there an English guide?

### Sections

**Courtyard First, Rooms After**

If the visit begins outside, give that light a minute before the display cases. Smaller museum stops are easier when you slow down before trying to read everything.

**Pick Objects, Not A Timeline**

Choose a few objects, artworks, or room details and follow them. Branch museums can lose shape if you force every label into one story.

**Bridge-And-Beach Da Nang Gets Quieter**

The contrast matters: after traffic, river views, and outdoor plans, quiet rooms let the city gather a little depth. Keep the visit short enough that the objects stay clear.

### Implementation notes

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-museum-branch-2`
* `displayName: Bảo tàng Đà Nẵng - Cơ sở 2`
* `englishName: Da Nang Museum Branch 2`
* `city: Đà Nẵng`
* `category: Museum`
* `pronunciation: bao tang da nang, kuh suh hai`
* `target_hero_image: HeroCityDanangPlaceMuseumBranch2`

**Closest canonical anchor:** Da Nang Museum canonical secondary example, with Museum of Cham Sculpture for museum-fatigue prevention.
**Anchor behavior copied:** Give the traveler a small indoor culture strategy: choose a few objects and avoid trying to complete every display.
**How this page differs:** Branch 2 has thinner public evidence and should stay restrained; the copy leans on quiet, courtyard/gallery mood rather than detailed exhibit claims.
**Owned traveler moment:** Entering a quieter branch-style museum stop and choosing a few objects instead of forcing the whole story.

**Phrase/audio status**

* `vi: Lối vào ở đâu?` · `en: Where is the entrance?` · `intent: ask_entrance` · `phraseId: v500-sigh-acti-where-is-the-entrance` · `audioId: v500-sigh-acti-where-is-the-entrance` · `status: mapped`
* `vi: Tôi chụp hình ở đây được không?` · `en: Can I take photos here?` · `intent: ask_photo_permission` · `phraseId: sight-3` · `audioId: sight-3` · `status: mapped`
* `vi: Có hướng dẫn tiếng Anh không?` · `en: Is there an English guide?` · `intent: ask_english_guide` · `phraseId: v900-sigh-acti-is-there-an-english-guide` · `audioId: v900-sigh-acti-is-there-an-english-guide` · `status: mapped`
* Place-name pronunciation support: `city-danang-place-museum-branch-2` · planned/no ready audio · `hide_until_audio` for name pronunciation if needed.

**Mentioned Here candidates**

* **Đà Nẵng** — `type: city` · `catalogId: existing_or_null` · `status: check_catalog`

  * `displaySubtitle: City context for the branch museum stop.`
  * `reason: Named in title and final section.`
* **Da Nang Museum** — `type: museum` · `catalogId: danang-museum` · `status: render`

  * `displaySubtitle: Main city museum context for this branch listing.`
  * `reason: The branch name naturally points back to the main museum page.`

**Related place candidates**

* **Da Nang Museum** — `relationship: main_branch_pairing` · `catalogId: danang-museum` · `status: render`

  * `displaySubtitle: The main city museum to compare before choosing a museum stop.`
  * `reason: Direct branch relationship and exact batch sibling.`
* **Da Nang Fine Arts Museum** — `relationship: museum_contrast` · `catalogId: danang-fine-arts-museum` · `status: render`

  * `displaySubtitle: A compact art-focused museum alternative downtown.`
  * `reason: Useful comparison for travelers choosing a quieter culture stop.`
* **Museum of Cham Sculpture** — `relationship: museum_contrast` · `catalogId: danang-cham-museum` · `status: render`

  * `displaySubtitle: A more focused heritage museum with a stronger object route.`
  * `reason: Useful comparison for museum-fatigue planning.`
* **Sông Hàn** — `relationship: nearby_context` · `catalogId: danang-han-river` · `status: check_catalog`

  * `displaySubtitle: Riverfront context if the branch visit is paired with a central walk.`
  * `reason: River views are mentioned generally; render only if route context is confirmed by catalog QA.`

**Verification flags**

* `type: same_week` · `reason: Branch public access, entrance, hours, ticketing, exhibit state, and English-guide/interpretation availability need current confirmation.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio reusable phrases but still need final native QA in batch review.` · `blocking: false`
* `type: audio_qa` · `reason: Place-name phrase row is planned/no ready audio; hide name phrase until audio exists.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm exact Branch 2, main museum, Fine Arts Museum, Cham Museum, and Sông Hàn render targets.` · `blocking: false`

**Source notes**

* Batch source notes: Da Nang Fantasticity; branch-name source.
* Legacy copy supports courtyard/sculpture-garden mood, gallery rooms, display cases, artifacts, quiet light, and bridge-and-beach contrast.
* Evidence is thinner than for the main museum; visible copy intentionally avoids exact exhibit, hours, price, entrance, and access claims.

**Score**
27/30 — Restrained, specific enough for a draft, and less database-like after revision. Capped for sparse evidence, same-week venue verification, name-audio gap, and unrun render/screenshot review.

**QA notes**

* Replaceability test: pass. Branch name, courtyard light, gallery rooms, display cases, bridge-and-beach contrast keep it specific enough without overclaiming.
* Phrase card test: pass. 3 ready-audio reusable traveler-action phrases; no place-name phrase card.
* Mentioned Here test: pass. Natural main museum/city references evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex validation.

---

## Batch QA summary

* Reader View appears first for each listing and contains only app-visible copy.
* Phrase cards kept to 2–3 per listing.
* All visible phrase cards use ready-audio reusable traveler-action phrases.
* Place-name phrase/audio rows are treated as pronunciation/name support only; planned/no-audio name rows are hidden until audio.
* No visible copy uses `useful because`, `reference line`, `destination`, `anchor`, `content role`, `this page helps`, or `the job is`.
* Headings varied across the batch; no repeated scaffold from `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`.
* No public URLs included.
* No current hours, prices, closures, payment rules, ticket rules, or live exhibit claims included in visible copy.
* All pages remain draft/review material, not production-ready.

## Codex handoff block

* `batch_id: batch_022`
* `page_ids: city-danang-place-marble-mountains, city-danang-place-mi-quang, city-danang-place-mi-quang-1a, city-danang-place-museum, city-danang-place-museum-branch-2`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none for visible cards; all visible cards use ready-audio reusable traveler-action phrases, but native_speaker_qa remains required`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio; Ngũ Hành Sơn ready as pronunciation/name support; Mi Quang, Mi Quang 1A, Da Nang Museum, and Da Nang Museum Branch 2 are planned/no ready audio and should hide_until_audio`
* `visible_copy_risks: Mi Quang 1A and Museum Branch 2 have thinner current venue evidence; copy is intentionally restrained and avoids volatile facts`
* `source_freshness_risks: Marble Mountains entrance/tickets/photo/cave access; Mi Quang 1A opening/menu/address/service rhythm; Da Nang Museum and Branch 2 entrance/hours/ticketing/exhibits/English interpretation; Branch 2 public access and exhibit state`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
