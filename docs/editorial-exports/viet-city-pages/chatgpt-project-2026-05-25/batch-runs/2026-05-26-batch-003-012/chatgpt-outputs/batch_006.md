SpeakLocal v2.2 BATCH_006 - Hanoi B - 2026-05-26

Sources read: the attached Batch 006 prompt with the five fixed rows and handoff requirements, the v2.2 Source Bundle, the Project Instructions, and the local Copy Ledger/Catalogs workbook tabs for ledger rows, ready-audio phrases, menu items, and place candidates.   

## 1. Bún chả Hương Liên / Bun Cha Huong Lien — Hanoi — Restaurant

### Reader View

**Start With The Bun Cha, Not The Name**

Hương Liên works best when the meal stays simple: grilled pork in warm dipping broth, cool noodles, herbs, and a table that moves faster than a long lunch. Sit down, order clearly, and let the bowl come together slowly.

### Useful phrase cards

* **“Bún chả Hương Liên”** — Bun Cha Huong Lien
* **“Cho tôi một phần”** — One portion, please.
* **“Cho thêm rau”** — More herbs, please.

### Sections

**Let The Bowl Organize The Table**

The pork, noodles, herbs, and dipping bowl arrive as parts, not a finished plate. Add noodles and greens in small turns so the broth stays warm and the herbs stay bright.

**Keep The Order Plain**

The name can make the stop feel heavier than it needs to be. A clear portion, a drink if you want one, and a little space on the table are enough.

**A Meal You Can Remember Later**

This is a practical Hanoi bún chả table: smoke, herbs, dipping broth, and the small work of building each bite. It is still worth it when the bowl, not the story around it, gets your attention.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-bun-cha-huong-lien`
* `place_catalog_id: hanoi-bun-cha-huong-lien`
* `displayName: Bún chả Hương Liên`
* `englishName: Bun Cha Huong Lien`
* `city: Hanoi`
* `category: Restaurant`
* `pronunciation: boon cha huong lien`
* `target_hero_image: HeroCityHanoiPlaceBunChaHuongLien`

**Closest canonical model:** Bà Lễ Well / Bale Well, with Hàn Market as the phrase-card shape reference.
**Canonical behavior copied:** Make the first table move clear before the traveler starts eating.
**How this page differs:** This is a named bún chả restaurant, not a roll-it-yourself set meal or a broad market.
**Owned traveler moment:** Sitting down to a bún chả table and assembling pork, noodles, herbs, and dipping broth without overcomplicating the meal.

**Phrase/audio status**

* **“Bún chả Hương Liên”** — `intent: place_name_recognition` · `phraseId: city-hanoi-place-bun-cha-huong-lien` · `audioId: audio-authored-bun-cha-huong-lien-7123b3d369` · `status: mapped`
* **“Cho tôi một phần”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cho thêm rau”** — `intent: ask_more_herbs` · `phraseId: food-4` · `audioId: food-4` · `status: mapped`

**Mentioned Here candidates**

* **Bún chả** — `type: food` · `catalogId: food-bun-cha` · `sourceText: “Hanoi bún chả table”` · `status: render`

  * `displaySubtitle: Grilled pork, noodles, herbs, and dipping broth.`
  * `reason: The visible copy names bún chả as the meal structure and table rhythm.`

**Related place candidates**

* **Bún Chả Ta** — `relationship: same_dish_restaurant_comparison` · `catalogId: hanoi-bun-cha-ta` · `status: render`

  * `displaySubtitle: Another Hanoi bún chả table to compare.`
  * `reason: Same dish family; useful sibling restaurant comparison within this batch.`
* **Bún chả ở Hà Nội** — `relationship: dish_context` · `catalogId: hanoi-bun-cha` · `status: render`

  * `displaySubtitle: The Hanoi dish behind the restaurant stop.`
  * `reason: The restaurant page naturally depends on the broader bún chả dish page.`

**Verification flags**

* `type: light` · `reason: Current hours, menu details, venue status, and MICHELIN listing status should be checked before import.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Recheck Vietnamese phrase naturalness in the final phrase set.` · `blocking: false`
* `type: audio_qa` · `reason: Place-name audio is ready in the catalog; verify final ID mapping during import.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm food and related-place catalog links open to the intended targets.` · `blocking: false`

**Source notes**

* Batch row source notes: MICHELIN Hanoi guide.
* Legacy row supports the table image: grilled pork, noodles, herbs, staff/table rhythm.
* Menu Catalog row `food-bun-cha` supports bún chả components: grilled pork, rice vermicelli, herbs, fish-sauce dipping broth, pickled vegetables.
* Native Phrase Catalog row for `city-hanoi-place-bun-cha-huong-lien` has ready audio; generic food phrase rows `food-1` and `food-4` have ready audio.
* No visible claims about address, hours, queue, price, Obama/Bourdain history, or current MICHELIN status.

**Score**

28/30 — Strong table moment and mapped phrases; capped for venue freshness checks and no rendered screenshot review.

**QA notes**

* Replaceability test: pass — the first screen depends on Hương Liên as a named bún chả table.
* Phrase card test: pass — all visible phrase cards map to ready audio.
* Mentioned Here test: pass — bún chả is evaluated as a natural food mention.
* Catalog mention scan: pass — natural food and sibling-place candidates listed.
* Duplicate body test: pass.
* Anti-cynicism test: pass — expectation-setting stays calm and still keeps the meal worth doing.
* Screenshot review status: `not_run`.
* Production review gate: `not_run`.

---

## 2. Bún Chả Ta / Bun Cha Ta — Hanoi — Restaurant

### Reader View

**Let The Bowl Teach The Rhythm**

Bún Chả Ta reads best as a casual Hanoi bún chả meal: dipping broth in front of you, herbs on the side, noodles waiting to be added by hand. Give the first few bites time before adding more.

### Useful phrase cards

* **“Cho tôi một phần”** — One portion, please.
* **“Cho thêm rau”** — More herbs, please.
* **“Tính tiền giúp tôi”** — Please let me pay.

### Sections

**Build The Bite Slowly**

Drop in a small bundle of noodles, add herbs, then pull pork from the warm broth. The meal is easier when you stop trying to make one perfect bite.

**Watch The Dipping Bowl**

Bún chả is not a dry noodle plate. The broth carries sweetness, fish sauce, garlic, pickle, pork smoke, and heat if chili is already in the bowl.

**Small Meal, Clear Memory**

Come for a focused table rather than a long restaurant arc. The charm is how quickly pork, noodles, herbs, and sauce start to feel like Hanoi lunch.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-bun-cha-ta`
* `place_catalog_id: hanoi-bun-cha-ta`
* `displayName: Bún Chả Ta`
* `englishName: Bun Cha Ta`
* `city: Hanoi`
* `category: Restaurant`
* `pronunciation: bun cha ta`
* `target_hero_image: HeroCityHanoiPlaceBunChaTa`

**Closest canonical model:** Bà Lễ Well / Bale Well.
**Canonical behavior copied:** Lower the awkwardness of a table meal by making the first eating move obvious.
**How this page differs:** This is a casual bún chả table, not a set-roll meal with price uncertainty.
**Owned traveler moment:** Building the first bún chả bite from dipping broth, pork, noodles, and herbs.

**Phrase/audio status**

* **“Cho tôi một phần”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cho thêm rau”** — `intent: ask_more_herbs` · `phraseId: food-4` · `audioId: food-4` · `status: mapped`
* **“Tính tiền giúp tôi”** — `intent: pay_now` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

**Mentioned Here candidates**

* **Bún chả** — `type: food` · `catalogId: food-bun-cha` · `sourceText: “casual Hanoi bún chả meal”` · `status: render`

  * `displaySubtitle: Grilled pork, noodles, herbs, and dipping broth.`
  * `reason: The visible copy names bún chả as the dish and table behavior.`

**Related place candidates**

* **Bún chả Hương Liên** — `relationship: same_dish_restaurant_comparison` · `catalogId: hanoi-bun-cha-huong-lien` · `status: render`

  * `displaySubtitle: A named bún chả stop with ready place-name audio.`
  * `reason: Same dish family; useful comparison with the other bún chả restaurant in this batch.`
* **Bún chả ở Hà Nội** — `relationship: dish_context` · `catalogId: hanoi-bun-cha` · `status: render`

  * `displaySubtitle: The Hanoi dish behind the restaurant table.`
  * `reason: The restaurant page naturally points back to the broader dish page.`

**Verification flags**

* `type: light` · `reason: Current hours, menu details, venue status, and MICHELIN listing status should be checked before import.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Recheck Vietnamese phrase naturalness and the capitalization of the place name.` · `blocking: false`
* `type: audio_qa` · `reason: Generic phrase cards are ready; place-name audio is not ready and should not render as a phrase card.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm sibling restaurant and dish cards open to the intended catalog targets.` · `blocking: false`

**Source notes**

* Batch row source notes: MICHELIN Hanoi guide.
* Legacy row supports casual bún chả table, dipping bowl, fresh herbs, table rhythm.
* Menu Catalog row `food-bun-cha` supports dish components and dipping-broth behavior.
* Native Phrase Catalog row for `city-hanoi-place-bun-cha-ta` is planned/no audio; no place-name phrase rendered.
* Generic ready-audio phrases selected from food rows `food-1`, `food-4`, and `coffee-7`.
* No visible claims about address, hours, queue, price, branch status, or current MICHELIN status.

**Score**

27/30 — Clear casual-table behavior and mapped reusable phrases; capped for thin venue-specific evidence and place-name audio not ready.

**QA notes**

* Replaceability test: pass — this page owns the casual bún chả assembly moment.
* Phrase card test: pass — visible phrase cards map to ready audio.
* Mentioned Here test: pass — bún chả is evaluated and linked.
* Catalog mention scan: pass — food and sibling restaurant candidates listed.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: `not_run`.
* Production review gate: `not_run`.

---

## 3. Bún thang ở Hà Nội / Bun thang — Hanoi — Dish

### Reader View

**A Quiet Bowl After Bigger Flavors**

Bún thang is a delicate Hanoi noodle soup: clear broth, rice vermicelli, shredded chicken, egg ribbons, pork sausage, and herbs. Choose it when you want detail instead of heat.

### Useful phrase cards

* **“Cho tôi tô này”** — I’ll take this bowl.
* **“Tôi không ăn thịt lợn”** — I do not eat pork.
* **“Tính tiền giúp tôi”** — Please let me pay.

### Sections

**Look For Layers, Not Fire**

The bowl is built from fine textures: pale noodles, chicken shreds, yellow egg, herbs, and clear broth. It should feel careful rather than loud.

**Ask Before You Assume It Is Chicken Soup**

Bún thang can include pork sausage and dried-shrimp flavor. If pork or seafood matters, ask before you commit to the bowl.

**Between Heavier Meals**

After smoky pork, fried snacks, or a long coffee run, bún thang gives Hanoi a quieter register. It is still worth seeking out because the restraint is the flavor.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-bun-thang`
* `place_catalog_id: hanoi-bun-thang`
* `displayName: Bún thang ở Hà Nội`
* `englishName: Bun thang`
* `city: Hanoi`
* `category: Dish`
* `pronunciation: boon tang`
* `target_hero_image: HeroCityHanoiPlaceBunThang`

**Closest canonical model:** White Rose Restaurant, with dish-source behavior adapted to a citywide dish.
**Canonical behavior copied:** Focus the dish around what to order, what to notice, and what ingredient question can prevent a bad mismatch.
**How this page differs:** This is not one restaurant; it is a Hanoi bowl with delicate composition and shop-by-shop variation.
**Owned traveler moment:** Choosing a quieter noodle bowl and checking pork/seafood concerns before eating.

**Phrase/audio status**

* **“Cho tôi tô này”** — `intent: order_this_bowl` · `phraseId: food-2` · `audioId: food-2` · `status: mapped`
* **“Tôi không ăn thịt lợn”** — `intent: avoid_pork` · `phraseId: v900-food-drin-i-do-not-eat-pork` · `audioId: v900-food-drin-i-do-not-eat-pork` · `status: mapped`
* **“Tính tiền giúp tôi”** — `intent: pay_now` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

**Mentioned Here candidates**

* **Bún thang** — `type: food` · `catalogId: food-bun-thang` · `sourceText: “Bún thang is a delicate Hanoi noodle soup”` · `status: render`

  * `displaySubtitle: Clear broth with chicken, egg ribbons, pork sausage, herbs, and rice noodles.`
  * `reason: The visible copy names the dish and explains its bowl structure.`

**Related place candidates**

* None proposed.

  * `reason: This dish page is focused around one bowl; no route or comparison card is needed unless Codex wants a noodle-soup comparison module later.`

**Verification flags**

* `type: light` · `reason: Bowl components and garnishes vary by shop; keep ingredient checks internal and verify before import if a venue is named later.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Recheck phrase-card Vietnamese and pronunciation before import.` · `blocking: false`
* `type: audio_qa` · `reason: Generic phrase cards are ready; place-name pronunciation row is planned/no audio and should not render as a phrase card.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm `food-bun-thang` maps to the intended menu item/card.` · `blocking: false`

**Source notes**

* Batch row source notes: Hanoi tourism portal.
* Legacy row supports shredded egg, chicken, herbs, steam/texture framing.
* Menu Catalog row `food-bun-thang` supports clear broth, rice vermicelli, shredded chicken, egg ribbons, pork sausage, and herb details.
* Native Phrase Catalog place row for bún thang is planned/no audio; no place-name phrase rendered.
* Generic ready-audio phrases selected from rows `food-2`, `v900-food-drin-i-do-not-eat-pork`, and `coffee-7`.

**Score**

28/30 — Strong dish-specific behavior and useful ingredient caution; capped for shop variation, no place-name audio, and no rendered screenshot review.

**QA notes**

* Replaceability test: pass — the copy depends on bún thang’s clear broth and layered ingredients.
* Phrase card test: pass — visible cards map to ready audio.
* Mentioned Here test: pass — bún thang evaluated as a menu/catalog item.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: `not_run`.
* Production review gate: `not_run`.

---

## 4. Cà phê sữa đá ở Hà Nội / Iced milk coffee — Hanoi — Drink

### Reader View

**A Cold Pause Between Old Streets**

Cà phê sữa đá is the glass for a Hanoi pause: dark coffee, condensed milk, ice, and enough sweetness to slow the next walk down. Drink it at a small table, not as a rushed caffeine errand.

### Useful phrase cards

* **“Cho tôi một cà phê sữa đá”** — One iced milk coffee, please.
* **“Ít đá thôi”** — Just a little ice.
* **“Làm ơn bớt đường đi”** — Less sugar, please.

### Sections

**Stir Before Judging**

Condensed milk settles low; coffee bite sits above it. Stir once, taste, then decide whether the sweetness is the point or too much for you.

**Choose A Short Sit**

This drink works best as a small reset between walks, markets, and meals. A plastic stool or narrow cafe table is enough; the point is the pause, not a long session.

**Different Mood Than Egg Coffee**

Egg coffee asks for a warm, dessert-like stop. Iced milk coffee is lighter and more sidewalk-friendly, a cold glass you can fold between walks.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-ca-phe-sua-da`
* `place_catalog_id: hanoi-ca-phe-sua-da`
* `displayName: Cà phê sữa đá ở Hà Nội`
* `englishName: Iced milk coffee`
* `city: Hanoi`
* `category: Drink`
* `pronunciation: kah fay soo-uh dah`
* `target_hero_image: HeroCityHanoiPlaceCaPheSuaDa`

**Closest canonical model:** Cà phê Giảng, with The Note Coffee as a compact café-ritual reference.
**Canonical behavior copied:** Give one first order, one physical pause, and one comparison that helps the traveler choose the right coffee mood.
**How this page differs:** This is a citywide drink, not a single upstairs café or origin-story stop.
**Owned traveler moment:** Sitting briefly with a cold coffee glass and adjusting sweetness/ice before the next walk.

**Phrase/audio status**

* **“Cho tôi một cà phê sữa đá”** — `intent: order_iced_milk_coffee` · `phraseId: coffee-1` · `audioId: coffee-1` · `status: mapped`
* **“Ít đá thôi”** — `intent: ask_less_ice` · `phraseId: coffee-4` · `audioId: coffee-4` · `status: mapped`
* **“Làm ơn bớt đường đi”** — `intent: ask_less_sugar` · `phraseId: v900-food-drin-less-sugar-please` · `audioId: v900-food-drin-less-sugar-please` · `status: mapped`

**Mentioned Here candidates**

* **Cà phê sữa đá** — `type: drink` · `catalogId: drink-ca-phe-sua-da` · `sourceText: “Cà phê sữa đá is the glass for a Hanoi pause”` · `status: render`

  * `displaySubtitle: Vietnamese iced milk coffee with condensed milk and ice.`
  * `reason: The visible copy names the drink and explains the drinking moment.`
* **Cà phê trứng** — `type: drink` · `catalogId: drink-ca-phe-trung` · `sourceText: “Egg coffee asks for a warm, dessert-like stop.”` · `status: render`

  * `displaySubtitle: Hanoi egg coffee, richer and warmer than a cold milk coffee.`
  * `reason: The visible copy uses egg coffee as a natural comparison, not as a keyword list.`

**Related place candidates**

* **Hanoi coffee hop** — `relationship: coffee_route` · `catalogId: hanoi-coffee-hop` · `status: render`

  * `displaySubtitle: A simple way to connect Hanoi coffee stops.`
  * `reason: The iced milk coffee page naturally supports a short coffee route or comparison set.`

**Verification flags**

* `type: light` · `reason: Drink style, sweetness, condensed milk amount, and glass size vary by café.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Recheck the “less sugar” phrase for natural fit with condensed-milk coffee before final import.` · `blocking: false`
* `type: audio_qa` · `reason: Generic coffee phrase cards are ready; place-name pronunciation row is planned/no audio and should not render as a phrase card.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm drink-card links for cà phê sữa đá and cà phê trứng, plus the Hanoi coffee-hop related card.` · `blocking: false`

**Source notes**

* Batch row source notes: Vietnam Travel Hanoi.
* Legacy row supports iced milk coffee glass, condensed milk swirl, cafe table, street stools, and sidewalk pause.
* Menu Catalog row `drink-ca-phe-sua-da` supports robusta coffee, condensed milk, ice, and strong/sweet framing.
* Menu Catalog row `drink-ca-phe-trung` supports the comparison to egg coffee.
* Ready-audio phrase rows: `coffee-1`, `coffee-4`, and `v900-food-drin-less-sugar-please`.
* No visible claims about specific café hours, current menus, pricing, or café rankings.

**Score**

28/30 — Strong drink ritual and mapped phrases; capped for café-by-café variation and native phrase fit around sweetness.

**QA notes**

* Replaceability test: pass — the copy depends on iced milk coffee’s condensed milk, ice, and short-pause behavior.
* Phrase card test: pass — all visible cards map to ready audio.
* Mentioned Here test: pass — cà phê sữa đá and egg coffee evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: `not_run`.
* Production review gate: `not_run`.

---

## 5. Chả cá ở Hà Nội / Turmeric dill fish — Hanoi — Dish

### Reader View

**Let The Pan Be Dinner**

Chả cá turns Hanoi fish into a table ritual: turmeric fish, dill, scallions, noodles, herbs, peanuts, and a sauce choice with real bite. Order it when you want the meal to happen at the table.

### Useful phrase cards

* **“Cho tôi một phần”** — One portion, please.
* **“Cái này có đậu phộng không?”** — Does this have peanuts?
* **“Cái này có nước mắm không?”** — Does this contain fish sauce?

### Sections

**Expect Dill, Heat, And Assembly**

The pan gives you fish and dill first, then the noodles and herbs make it a full meal. Add in small rounds so the fish stays hot and the greens stay sharp.

**Decide On The Sauce**

Mắm tôm can be strong; a milder fish-sauce dip is easier for some first-timers. Ask before pouring if the bowl smells sharper than expected.

**A Slower Hanoi Meal**

Chả cá is not a grab-and-go bowl. It is still worth the extra attention when you want smoke, dill, turmeric, and noodles to carry the evening.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-cha-ca`
* `place_catalog_id: hanoi-cha-ca`
* `displayName: Chả cá ở Hà Nội`
* `englishName: Turmeric dill fish`
* `city: Hanoi`
* `category: Dish`
* `pronunciation: chah kah`
* `target_hero_image: HeroCityHanoiPlaceChaCa`

**Closest canonical model:** White Rose Restaurant, with Bale Well’s table-confidence pattern.
**Canonical behavior copied:** Teach the focused dish order, the ingredient risk, and the first table move.
**How this page differs:** Chả cá is a hot-pan assembly meal, not a single finished plate or a dumpling source restaurant.
**Owned traveler moment:** Choosing chả cá for a slower dinner and deciding how to handle herbs, peanuts, and sauce at the table.

**Phrase/audio status**

* **“Cho tôi một phần”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cái này có đậu phộng không?”** — `intent: check_peanuts` · `phraseId: food-premium-has-peanuts` · `audioId: food-premium-has-peanuts` · `status: mapped`
* **“Cái này có nước mắm không?”** — `intent: check_fish_sauce` · `phraseId: v900-food-drin-does-this-contain-fish-sauce` · `audioId: v900-food-drin-does-this-contain-fish-sauce` · `status: mapped`

**Mentioned Here candidates**

* **Chả cá Lã Vọng** — `type: food` · `catalogId: food-cha-ca-la-vong` · `sourceText: “Chả cá turns Hanoi fish into a table ritual”` · `status: render`

  * `displaySubtitle: Hanoi-style turmeric fish with dill, noodles, herbs, and sauce.`
  * `reason: Menu Catalog uses `food-cha-ca-la-vong` as the existing catalog item for this dish family.`
* **Mắm tôm** — `type: food` · `catalogId: null` · `sourceText: “Mắm tôm can be strong”` · `status: check_catalog`

  * `displaySubtitle: Fermented shrimp-paste sauce, often strong on a first bite.`
  * `reason: Named naturally in the sauce section, but no standalone sauce catalog item was confirmed in the checked rows.`

**Related place candidates**

* **Chả cá Thăng Long** — `relationship: dish_to_restaurant` · `catalogId: hanoi-cha-ca-thang-long` · `status: render`

  * `displaySubtitle: A Hanoi restaurant page for the same hot-pan fish style.`
  * `reason: Useful next card for travelers who want a named chả cá restaurant after reading the dish page.`

**Verification flags**

* `type: light` · `reason: Sauce options, peanuts, herbs, and table setup can vary by shop; current restaurant examples should be checked before import if named in rendered modules.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Recheck ingredient phrases and pronunciation before import.` · `blocking: false`
* `type: audio_qa` · `reason: Visible phrase cards are ready; place-name pronunciation row is planned/no audio and should not render as a phrase card.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm `food-cha-ca-la-vong`, `hanoi-cha-ca-thang-long`, and possible mắm tôm handling.` · `blocking: false`

**Source notes**

* Batch row source notes: Vietnam Travel Hanoi; MICHELIN Hanoi guide.
* Legacy row supports sizzling chả cá with dill, turmeric fish, noodles, herbs, steam, and old-lane Hanoi framing.
* Menu Catalog row `food-cha-ca-la-vong` supports turmeric fish, dill, scallions, rice vermicelli, peanuts, herbs, mắm tôm, and a milder fish-sauce dip.
* Ready-audio phrase rows: `food-1`, `food-premium-has-peanuts`, and `v900-food-drin-does-this-contain-fish-sauce`.
* No visible claims about specific restaurant hours, current menus, prices, table fees, or current MICHELIN status.

**Score**

28/30 — Strong table ritual and ingredient-aware phrase set; capped for sauce/shop variation, mắm tôm catalog check, and no rendered screenshot review.

**QA notes**

* Replaceability test: pass — the copy depends on turmeric fish, dill, noodles, sauce, and hot-pan assembly.
* Phrase card test: pass — all visible cards map to ready audio.
* Mentioned Here test: pass with one `check_catalog` sauce candidate.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: `not_run`.
* Production review gate: `not_run`.

---

## Codex handoff block

* `batch_id: batch_006`
* `page_ids: city-hanoi-place-bun-cha-huong-lien, city-hanoi-place-bun-cha-ta, city-hanoi-place-bun-thang, city-hanoi-place-ca-phe-sua-da, city-hanoi-place-cha-ca`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none; all visible phrase cards are mapped to ready-audio IDs inspected in the local catalog; text-only menu order lines were not rendered as phrase cards`
* `place_name_phrases: Bún chả Hương Liên rendered because ready audio exists; Bún Chả Ta, Bún thang, Cà phê sữa đá, and Chả cá place-name rows are planned/no-audio and should hide_until_audio`
* `visible_copy_risks: two bún chả restaurant pages are close siblings, so Jojo should compare them side by side for voice separation; visible copy avoids current hours, prices, queues, addresses, ranking language, and unstable venue claims`
* `source_freshness_risks: current restaurant status, MICHELIN listing status, menu details, sauce availability, ingredient variation, and café-by-café drink customization should be checked before Codex import or rendering`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
