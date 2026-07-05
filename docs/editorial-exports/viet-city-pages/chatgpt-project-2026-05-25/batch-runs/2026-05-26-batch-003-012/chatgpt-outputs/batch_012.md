SpeakLocal v2.2 BATCH_012 - Hue B - 2026-05-26

Source read: the uploaded Batch 012 prompt, project instructions, source bundle, local Copy Ledger/Catalogs workbook, Phrase Picker Ready Audio, Native Phrase Catalog, City Places Catalog, and Menu Catalog. The batch prompt supplies the exact five rows and handoff block, and the project/source docs require v2.2 app-detail drafts with phrase cards, Mentioned Here mapping, verification flags, scores, and no production-ready claim.   

## 1. Bánh lọc Bà Vân / Ba Van Banh Loc — Hue — Restaurant

### Reader View

**Let The Dumplings Set The Pace**

Bánh lọc Bà Vân is a small Hue dumpling stop, the kind of place where banana-leaf parcels and a simple counter make the meal feel tied to the city rather than wedged between sights.

**Phrase cards**

* **“Cho tôi một phần”** — One portion, please.
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?
* **“Tính tiền giúp tôi”** — Please let me pay.

**Start Small At The Counter**

Order one portion first. The pleasure is in the chew, the shrimp, the leaf-wrapped heat, and the dipping sauce; too much too early turns a small Hue stop into a table project.

**Ask Before Shrimp Matters**

Bánh lọc usually means seafood is part of the story. If shrimp, pork, or fish sauce matters for you, ask before the plate arrives instead of trying to solve it after the first bite.

**Still Worth A Short Detour**

The rhythm is simple: unwrap, dip, pause, repeat. It is still worth the stop when you want a Hue food memory that does not need a long dinner.

### Implementation notes

**Content contract fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-ba-van-banh-loc`
* `displayName: Bánh lọc Bà Vân`
* `englishName: Ba Van Banh Loc`
* `city: Hue`
* `category: Restaurant`
* `pronunciation: bahn lawk bah vahn`
* `targetHeroImage: HeroCityHuePlaceBaVanBanhLoc`

**Closest canonical anchor:** Bà Lễ Well / Bale Well
**Anchor behavior copied:** Turn a small restaurant interaction into ordering confidence before the food arrives.
**How this page differs:** This is not a roll-it-yourself set meal; it is a focused Hue dumpling counter with banana-leaf parcels.
**Owned traveler moment:** Standing at the counter, choosing a first portion, then sitting down with sauce and leaf-wrapped dumplings.

**Useful phrase cards / audio status**

* **“Cho tôi một phần”** — One portion, please.
  `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?
  `intent: ask_shrimp` · `phraseId: v500-food-drin-does-this-contain-shrimp` · `audioId: v500-food-drin-does-this-contain-shrimp` · `status: mapped`
* **“Tính tiền giúp tôi”** — Please let me pay.
  `intent: ask_to_pay` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

**Mentioned Here candidates**

* **Bánh bột lọc** — `type: food` · `catalogId: food-banh-bot-loc` · `status: render`
  `sourceText: banana-leaf parcels / bánh lọc dumpling context`
  `displaySubtitle: Clear tapioca dumplings with shrimp, pork, and dipping sauce.`
  `reason: Menu Catalog has reviewed item food-banh-bot-loc; copy naturally frames the stop around Hue leaf-wrapped dumplings.`

**Related place candidates**

* **Banh bot loc** — `relationship: dish_context` · `catalogId: hue-banh-bot-loc` · `status: render`
  `displaySubtitle: The Hue dumpling to recognize before ordering.`
  `reason: City Places Catalog has a matching Hue dish page; useful context for this restaurant without forcing a route.`

**Verification flags**

* `type: light`
  `reason: Current hours, menu availability, and exact counter/service pattern can change.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Pronunciation and phrase fit still need native review before import.`
  `blocking: false`
* `type: audio_qa`
  `reason: Visible phrase cards use ready reusable audio; place-name phrase city-hue-place-ba-van-banh-loc is planned/no audio and should hide until audio.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Confirm whether restaurant-to-dish related card should use menu item food-banh-bot-loc, place page hue-banh-bot-loc, or both.`
  `blocking: false`

**Source notes**

* Batch row source notes: Hue tourism portal restaurants.
* Ledger legacy summary supplies the concrete scene: small Hue dumpling shop counter, banana-leaf parcels, clear shopfront.
* Menu Catalog has reviewed `food-banh-bot-loc`; no separate reviewed menu item found for “Bánh lọc Bà Vân.”
* Native Phrase Catalog has the place-name phrase as planned with no audio key; do not render it as a phrase card yet.

**Score**

27/30 — Strong focused restaurant draft; capped for thin venue-specific evidence, current-hours/menu freshness, native phrase QA, and catalog mapping decisions.

**QA notes**

* Replaceability test: pass. The counter, leaf parcels, shrimp, and Hue dumpling rhythm keep it specific.
* Phrase card test: pass. Three reusable ready-audio phrases; no one-off venue phrase rendered.
* Mentioned Here test: pass with catalog QA needed.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 2. Bánh bèo ở Huế / Banh beo — Hue — Dish

### Reader View

**Let The Tray Slow You Down**

Bánh bèo is a Hue dish built for small bites: little steamed rice cakes in saucers, shrimp topping, scallion oil, and sauce added by the spoon. It feels modest until the tray lands and the rhythm takes over.

**Phrase cards**

* **“Cho tôi một phần”** — One portion, please.
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?
* **“Cái này có nước mắm không?”** — Does this contain fish sauce?

**A Dish Of Small Decisions**

Do not rush the first saucer. Spoon a little sauce, taste once, then adjust. The texture is soft and light, so the topping and sauce carry more weight than the size suggests.

**Shrimp Is Usually Part Of It**

The classic topping leans on shrimp. If you avoid seafood, ask before ordering; removing the topping may not be as simple as scraping something off later.

**A Good First Hue Snack**

Bánh bèo works well when you want Hue’s food to feel precise rather than heavy. It is still worth trying because the whole dish is a lesson in restraint: one saucer, one spoon, one clean bite at a time.

### Implementation notes

**Content contract fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-banh-beo`
* `displayName: Bánh bèo ở Huế`
* `englishName: Banh beo`
* `city: Hue`
* `category: Dish`
* `pronunciation: bahn beh-oh`
* `targetHeroImage: HeroCityHuePlaceBanhBeo`

**Closest canonical anchor:** Chợ Cồn food-first pattern, with White Rose as dish-focus support.
**Anchor behavior copied:** Start with the food object, give the first eating move, and keep allergy/sauce questions practical.
**How this page differs:** It is a dish page, not a market or restaurant; the owned action is tasting a tray of small saucers.
**Owned traveler moment:** Sitting down to a tray of saucers and deciding how much sauce to spoon onto the first one.

**Useful phrase cards / audio status**

* **“Cho tôi một phần”** — One portion, please.
  `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?
  `intent: ask_shrimp` · `phraseId: v500-food-drin-does-this-contain-shrimp` · `audioId: v500-food-drin-does-this-contain-shrimp` · `status: mapped`
* **“Cái này có nước mắm không?”** — Does this contain fish sauce?
  `intent: ask_fish_sauce` · `phraseId: v900-food-drin-does-this-contain-fish-sauce` · `audioId: v900-food-drin-does-this-contain-fish-sauce` · `status: mapped`

**Mentioned Here candidates**

* **Bánh bèo** — `type: food` · `catalogId: food-banh-beo` · `status: render`
  `sourceText: little steamed rice cakes in saucers, shrimp topping, scallion oil`
  `displaySubtitle: Small steamed rice cakes with shrimp topping and sauce.`
  `reason: Menu Catalog has reviewed item food-banh-beo; copy naturally describes the dish itself.`

**Related place candidates**

* None.

**Verification flags**

* `type: light`
  `reason: Current restaurant availability, toppings, and sauce service vary by vendor.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Phrase card fit and pronunciation need native review before import.`
  `blocking: false`
* `type: audio_qa`
  `reason: Visible phrase cards use ready reusable audio; place-name phrase city-hue-place-banh-beo is planned/no audio and should hide until audio.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Confirm whether Menu Catalog item food-banh-beo should render as Mentioned Here on a dish page or stay internal as menu support.`
  `blocking: false`

**Source notes**

* Batch row source notes: Vietnam Tourism Hue food; Hue tourism portal cuisine materials.
* Legacy summary supplies tray of small ceramic saucers, shrimp topping, and scallion oil.
* Menu Catalog item `food-banh-beo` is handwritten-reviewed and notes shrimp topping, scallion oil, fried shallots, and fish-sauce dip.
* Native Phrase Catalog has place-name phrase planned with no audio key; do not render it as a phrase card yet.

**Score**

28/30 — Strong dish draft with clear first-bite behavior and ready-audio cards; capped for vendor variation, native QA, and catalog rendering choice.

**QA notes**

* Replaceability test: pass. The saucers, shrimp topping, scallion oil, and sauce rhythm distinguish it from other Hue snacks.
* Phrase card test: pass. Three reusable ready-audio phrases.
* Mentioned Here test: pass with catalog QA needed.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 3. Bánh bột lọc ở Huế / Banh bot loc — Hue — Dish

### Reader View

**Expect Chew Before Comfort**

Bánh bột lọc is not a soft dumpling in the usual sense. The tapioca wrapper is glossy and chewy, often folded around shrimp and pork, then served with a dipping sauce that makes the small bite feel sharper.

**Phrase cards**

* **“Cho tôi một phần”** — One portion, please.
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?
* **“Cái này có nước mắm không?”** — Does this contain fish sauce?

**Look For The Filling**

The wrapper can be almost translucent, so the filling is part of the appeal. Notice the shrimp before you dip; it tells you what kind of bite you are about to get.

**Leaf Or Plate, Same Idea**

Some versions arrive in banana leaf; others come already opened. Either way, the move is small and deliberate: unwrap if needed, dip lightly, then decide whether you want more sauce.

**Worth It For Texture**

This is the Hue snack to try when texture matters as much as flavor. It is still worth the order because the chew, shrimp, leaf, and sauce make one small dumpling feel very specific to the city.

### Implementation notes

**Content contract fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-banh-bot-loc`
* `displayName: Bánh bột lọc ở Huế`
* `englishName: Banh bot loc`
* `city: Hue`
* `category: Dish`
* `pronunciation: bahn boht lawk`
* `targetHeroImage: HeroCityHuePlaceBanhBotLoc`

**Closest canonical anchor:** White Rose Restaurant, with Bale Well as interaction support.
**Anchor behavior copied:** Make a focused dumpling recognizable before the traveler orders, and surface shrimp questions naturally.
**How this page differs:** This is not tied to one restaurant source; it is the Hue dish itself, with Bà Vân as a related eating context.
**Owned traveler moment:** Opening or spotting a glossy dumpling, seeing the shrimp inside, then dipping lightly.

**Useful phrase cards / audio status**

* **“Cho tôi một phần”** — One portion, please.
  `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?
  `intent: ask_shrimp` · `phraseId: v500-food-drin-does-this-contain-shrimp` · `audioId: v500-food-drin-does-this-contain-shrimp` · `status: mapped`
* **“Cái này có nước mắm không?”** — Does this contain fish sauce?
  `intent: ask_fish_sauce` · `phraseId: v900-food-drin-does-this-contain-fish-sauce` · `audioId: v900-food-drin-does-this-contain-fish-sauce` · `status: mapped`

**Mentioned Here candidates**

* **Bánh bột lọc** — `type: food` · `catalogId: food-banh-bot-loc` · `status: render`
  `sourceText: glossy and chewy, often folded around shrimp and pork`
  `displaySubtitle: Clear tapioca dumplings with shrimp, pork, and dipping sauce.`
  `reason: Menu Catalog has reviewed item food-banh-bot-loc; copy naturally describes the dish itself.`

**Related place candidates**

* **Bánh lọc Bà Vân** — `relationship: restaurant_for_dish` · `catalogId: hue-ba-van-banh-loc` · `status: render`
  `displaySubtitle: A small Hue stop for leaf-wrapped dumplings.`
  `reason: City Places Catalog has a Bà Vân restaurant row, and the batch source notes connect Bà Vân with this dish context.`

**Verification flags**

* `type: light`
  `reason: Current vendor versions, filling mix, and banana-leaf service vary.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Phrase cards and pronunciation need native review before import.`
  `blocking: false`
* `type: audio_qa`
  `reason: Visible phrase cards use ready reusable audio; place-name phrase city-hue-place-banh-bot-loc is planned/no audio and should hide until audio.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Confirm related card behavior between menu item food-banh-bot-loc, dish page hue-banh-bot-loc, and restaurant page hue-ba-van-banh-loc.`
  `blocking: false`

**Source notes**

* Batch row source notes: Vietnam Tourism Hue food; Hue tourism portal restaurant listings for Bà Vân.
* Legacy summary supplies glossy dumplings in banana leaf, visible shrimp, and dipping sauce.
* Menu Catalog item `food-banh-bot-loc` is handwritten-reviewed and notes tapioca wrapper, shrimp, pork, optional banana leaf, and fish-sauce dip.
* Native Phrase Catalog has place-name phrase planned with no audio key; do not render it as a phrase card yet.

**Score**

28/30 — Strong dish-specific texture and ordering guidance; capped for vendor variation, native QA, and related-card mapping.

**QA notes**

* Replaceability test: pass. Glossy tapioca wrapper, visible shrimp, leaf/opened versions, and dipping behavior keep it specific.
* Phrase card test: pass. Three reusable ready-audio phrases.
* Mentioned Here test: pass with catalog QA needed.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 4. Bánh khoái ở Huế / Banh khoai — Hue — Dish

### Reader View

**Go For The Crackle And The Herbs**

Bánh khoái is Hue’s crisp yellow pancake: louder, richer, and more hands-on than the smaller steamed snacks. The first bite works best when you treat the herbs, fig, starfruit, and dipping sauce as part of the dish, not decoration.

**Phrase cards**

* **“Cho tôi một phần”** — One portion, please.
* **“Cho thêm rau”** — More herbs, please.
* **“Không cay nhé”** — Not spicy, please.

**Build The Bite**

Break off a crisp piece, add herbs and fruit, then dip. The pancake alone can feel heavy; the fresh pieces around it are what keep the bite bright.

**Check The Sauce Before Pouring**

The sauce is a main character here. Start with a small dip before adding more, especially if you are sensitive to spice or strong fish-sauce flavor.

**A Bigger Hue Snack**

Bánh khoái feels more like a small meal than a nibble. It is still worth ordering when you want something with crunch, heat, herbs, and a table rhythm instead of another soft dumpling.

### Implementation notes

**Content contract fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-banh-khoai`
* `displayName: Bánh khoái ở Huế`
* `englishName: Banh khoai`
* `city: Hue`
* `category: Dish`
* `pronunciation: bahn khw-eye`
* `targetHeroImage: HeroCityHuePlaceBanhKhoai`

**Closest canonical anchor:** Bà Lễ Well / Bale Well, with Chợ Cồn food-first support.
**Anchor behavior copied:** Explain the table move before the traveler starts eating: herbs, sauce, and first bite matter.
**How this page differs:** This is a single crisp Hue pancake rather than a rolling set or market snack crawl.
**Owned traveler moment:** Building the first bite with pancake, herbs, fruit, and sauce.

**Useful phrase cards / audio status**

* **“Cho tôi một phần”** — One portion, please.
  `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cho thêm rau”** — More herbs, please.
  `intent: ask_more_herbs` · `phraseId: food-4` · `audioId: food-4` · `status: mapped`
* **“Không cay nhé”** — Not spicy, please.
  `intent: ask_not_spicy` · `phraseId: food-3` · `audioId: food-3` · `status: mapped`

**Mentioned Here candidates**

* **Bánh khoái** — `type: food` · `catalogId: hue-banh-khoai` · `status: check_catalog`
  `sourceText: Hue’s crisp yellow pancake`
  `displaySubtitle: Crisp Hue pancake served with herbs, fruit, and sauce.`
  `reason: City Places Catalog has hue-banh-khoai; Menu Catalog did not show a reviewed food-banh-khoai item during local lookup, so Codex should decide whether this self/dish mention renders or stays internal.`

**Related place candidates**

* None.

**Verification flags**

* `type: light`
  `reason: Current vendor versions, herb plate, fruit accompaniments, and sauce style vary.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Pronunciation and phrase fit need native review before import.`
  `blocking: false`
* `type: audio_qa`
  `reason: Visible phrase cards use ready reusable audio; place-name phrase city-hue-place-banh-khoai is planned/no audio and should hide until audio.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Menu Catalog lookup did not find a reviewed Bánh khoái item; check whether City Places Catalog self-link should not render.`
  `blocking: false`

**Source notes**

* Batch row source notes: Vietnam Tourism Hue food; Hue tourism portal cuisine materials.
* Legacy summary supplies crisp yellow Hue bánh khoái with herbs, fig, starfruit, and dipping sauce.
* Menu Catalog lookup did not find a reviewed Bánh khoái item; City Places Catalog has `hue-banh-khoai`.
* Native Phrase Catalog has place-name phrase planned with no audio key; do not render it as a phrase card yet.

**Score**

27/30 — Good concrete eating behavior and ready-audio cards; capped for missing reviewed Menu Catalog item, vendor variation, and native QA.

**QA notes**

* Replaceability test: pass. Crisp pancake, herbs, fig, starfruit, and sauce make it distinct from the dumpling pages.
* Phrase card test: pass. Three reusable ready-audio phrases.
* Mentioned Here test: needs_review because catalog target is not a reviewed menu item.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 5. Bánh nậm ở Huế / Banh nam — Hue — Dish

### Reader View

**Open The Leaf Before The Sauce**

Bánh nậm is quiet food: a flat steamed rice sheet opened from banana leaf, topped with shrimp, then eaten with fish sauce. Give the first piece a small dip before you decide how much sauce it needs.

**Phrase cards**

* **“Cho tôi một phần”** — One portion, please.
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?
* **“Cái này có nước mắm không?”** — Does this contain fish sauce?

**Soft Texture, Sharp Sauce**

The rice sheet is gentle; the topping and sauce do the louder work. That contrast is the point, so start slowly instead of flooding the leaf.

**Good Beside Other Small Plates**

Bánh nậm makes sense with other Hue snacks because it does not shout for attention. Order it when you want the leaf-wrapped side of the city’s food, not a heavy main dish.

**Still Worth The Quiet Bite**

It can look plain at first. The memory is in the opening: steam, leaf, shrimp, sauce, and a soft piece that disappears faster than you expect.

### Implementation notes

**Content contract fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-banh-nam`
* `displayName: Bánh nậm ở Huế`
* `englishName: Banh nam`
* `city: Hue`
* `category: Dish`
* `pronunciation: bahn nahm`
* `targetHeroImage: HeroCityHuePlaceBanhNam`

**Closest canonical anchor:** White Rose Restaurant, with Bánh bèo-style small-bite behavior.
**Anchor behavior copied:** Make the dish legible by showing the first eating move and the ingredient questions.
**How this page differs:** Bánh nậm is flatter and quieter than bột lọc; the action is opening the leaf and controlling sauce.
**Owned traveler moment:** Opening the banana leaf, taking a small first dip, and reading the shrimp topping.

**Useful phrase cards / audio status**

* **“Cho tôi một phần”** — One portion, please.
  `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?
  `intent: ask_shrimp` · `phraseId: v500-food-drin-does-this-contain-shrimp` · `audioId: v500-food-drin-does-this-contain-shrimp` · `status: mapped`
* **“Cái này có nước mắm không?”** — Does this contain fish sauce?
  `intent: ask_fish_sauce` · `phraseId: v900-food-drin-does-this-contain-fish-sauce` · `audioId: v900-food-drin-does-this-contain-fish-sauce` · `status: mapped`

**Mentioned Here candidates**

* **Bánh nậm** — `type: food` · `catalogId: food-banh-nam` · `status: render`
  `sourceText: flat steamed rice sheet opened from banana leaf, topped with shrimp`
  `displaySubtitle: Flat steamed rice dumpling in banana leaf with shrimp topping.`
  `reason: Menu Catalog has reviewed item food-banh-nam; copy naturally describes the dish itself.`

**Related place candidates**

* None.

**Verification flags**

* `type: light`
  `reason: Current vendor versions, topping mix, and sauce service vary.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Phrase cards and pronunciation need native review before import.`
  `blocking: false`
* `type: audio_qa`
  `reason: Visible phrase cards use ready reusable audio; place-name phrase city-hue-place-banh-nam is planned/no audio and should hide until audio.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Confirm whether Menu Catalog item food-banh-nam should render as Mentioned Here on a dish page or stay internal as menu support.`
  `blocking: false`

**Source notes**

* Batch row source notes: Vietnam Tourism Hue food; Hue tourism portal cuisine materials.
* Legacy summary supplies opened banana-leaf bánh nậm, shrimp topping, fish sauce bowl, and Hue table.
* Menu Catalog item `food-banh-nam` is handwritten-reviewed and notes rice flour sheet, banana leaf, shrimp/pork topping, scallion oil, and fish-sauce dip.
* Native Phrase Catalog has place-name phrase planned with no audio key; do not render it as a phrase card yet.

**Score**

28/30 — Strong quiet-dish differentiation and ready-audio cards; capped for vendor variation, native QA, and catalog rendering choice.

**QA notes**

* Replaceability test: pass. Banana leaf opening, flat rice sheet, shrimp topping, and controlled sauce separate it from bánh bèo and bánh bột lọc.
* Phrase card test: pass. Three reusable ready-audio phrases.
* Mentioned Here test: pass with catalog QA needed.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Batch QA summary

* Reader View visible copy avoids the prohibited visible phrases from the Batch 012 prompt.
* Phrase cards are 2–3 per listing and use reusable ready-audio phrases only.
* No one-off place-name phrases render; all five place-name phrase rows are planned/no audio.
* Food/dish mentions were scanned against Menu Catalog and City Places Catalog.
* No page is marked ready for import or production-ready.
* Freshness risks are kept in internal notes and verification flags, not visible copy.

## Codex handoff block

* `batch_id: batch_012`
* `page_ids: city-hue-place-ba-van-banh-loc, city-hue-place-banh-beo, city-hue-place-banh-bot-loc, city-hue-place-banh-khoai, city-hue-place-banh-nam`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none for visible phrase cards; all visible cards use ready reusable audio from Native Phrase Catalog / Phrase Picker rows`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio; all five current place-name phrase rows are planned/no audio and should not render as phrase cards`
* `visible_copy_risks: Bánh khoái Mentioned Here target needs catalog decision because no reviewed Menu Catalog item was found locally; otherwise visible copy is draft-ready for Jojo voice review but not approved_for_import`
* `source_freshness_risks: restaurant hours, current menu/topping variations, sauce service, shrimp/pork/fish-sauce handling, and vendor availability should be checked before import/publication`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
