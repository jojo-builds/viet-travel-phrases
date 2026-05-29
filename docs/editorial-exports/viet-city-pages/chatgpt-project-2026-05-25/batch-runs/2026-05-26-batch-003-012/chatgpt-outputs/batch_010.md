SpeakLocal v2.2 BATCH_010 - Hoi An B - 2026-05-26

Source basis: exact Batch 010 rows and handoff requirements came from the attached batch prompt; v2.2 app-detail structure, phrase-card rules, and Mentioned Here rules came from the Source Bundle; ready-audio phrase IDs came from the Phrase Picker / Native Phrase Catalog; Hoi An place IDs and menu-item IDs came from the Copy Ledger and Catalogs workbook.      

---

## Giếng Bà Lễ / Bale Well — Hoi An — restaurant

### Reader View

**Settle The Set Before Your Hands Get Busy**

Bale Well is the Hội An meal where the table fills fast: pork skewers, bánh xèo, spring rolls, herbs, rice paper, and sauce. Ask what the set includes, then let someone show the first roll.

### Useful phrase cards

* **“Cái này bao nhiêu?”** — How much is this?
* **“Chỉ cho tôi được không?”** — Can you show me?
* **“Cho thêm rau.”** — More herbs, please.

### Sections

**The First Roll Is The Lesson**

The meal makes sense after one demo. Watch the rice paper, herbs, pancake, pork, and sauce order, then stop worrying about neat hands.

**Better Shared Than Sampled**

The spread is built for people reaching across the table. Solo travelers can still enjoy it, but should check portion size before food starts landing.

**Keep It Near The Old Streets**

Pair it with an Ancient Town walk when you want a noisy, filling food break instead of a long tasting dinner. The charm is the motion: staff, skewers, sauce, wrappers.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-hoian-place-bale-well`
* `displayName: Giếng Bà Lễ`
* `englishName: Bale Well`
* `city: Hoi An`
* `category: Restaurant`
* `target_hero_image: HeroCityHoianPlaceBaleWell`
* `pronunciation: zyeng bah leh`
* Closest canonical anchor: Bale Well — friction-to-confidence restaurant pattern.
* Anchor behavior copied: first action reduces awkwardness before a fast shared meal.
* How this page differs: this is the actual Bale Well row, rewritten from the legacy text into the v2.2 Reader View shape with only ready-audio reusable phrases.
* Owned traveler moment: sitting down as the shared set starts arriving before the traveler knows how to roll it.

### Phrase/audio status

* **“Cái này bao nhiêu?”** — `intent: ask_price` · `phraseId: price-1` · `audioId: price-1` · `status: mapped`
* **“Chỉ cho tôi được không?”** — `intent: ask_show_me` · `phraseId: repair-show-me` · `audioId: repair-show-me` · `status: mapped`
* **“Cho thêm rau.”** — `intent: ask_more_herbs` · `phraseId: food-4` · `audioId: food-4` · `status: mapped`
* Place-name phrase: `city-hoian-place-bale-well` · audio planned only · `hide_until_audio`

### Mentioned Here candidates

* **Bánh xèo** — `type: food` · `catalogId: hoian-banh-xeo` · `status: render`

  * `sourceText: bánh xèo`
  * `displaySubtitle: Crisp pancake folded into the shared spread.`
  * `reason: Named naturally in the intro as part of the Bale Well set.`
* **Hoi An Ancient Town** — `type: neighborhood` · `catalogId: hoian-ancient-town` · `status: render`

  * `sourceText: Ancient Town`
  * `displaySubtitle: Old-street walk pairing before or after the meal.`
  * `reason: Named naturally in route-pairing guidance.`

### Related place candidates

* **Bánh xèo Hội An** — `relationship: dish_context` · `catalogId: hoian-banh-xeo` · `status: render`

  * `displaySubtitle: Learn the pancake before it appears in the roll-it-yourself spread.`
  * `reason: Bale Well copy naturally includes bánh xèo as one part of the meal.`
* **Hoi An Ancient Town** — `relationship: route_pairing` · `catalogId: hoian-ancient-town` · `status: render`

  * `displaySubtitle: Easy nearby walk before or after a filling meal.`
  * `reason: Route pairing appears in visible copy.`

### Verification flags

* `type: light`

  * `reason: Current set price, portion format, and recent service/menu pattern should be checked before import.`
  * `blocking: false`
* `type: native_speaker_qa`

  * `reason: Pronunciation and phrase-card naturalness need native confirmation.`
  * `blocking: false`
* `type: catalog_qa`

  * `reason: Confirm whether food mentions should link to city place IDs, menu item IDs, or both.`
  * `blocking: false`

### Source/freshness notes

* Batch row source notes: local food and venue references; local-name spelling kept conservative.
* Legacy source describes a hands-on shared set with pork skewers, bánh xèo, spring rolls, herbs, rice paper, and sauce.
* Visible copy avoids current hours, price amount, address, and claims about present-day service consistency.

### Score

28/30 — Strong ordering-moment draft with ready-audio reusable phrases. Capped for current set-price/menu verification and native-speaker QA.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready audio.
* Mentioned Here test: pass; natural food and route mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Bánh đập hến xào ở Hội An / Cracked rice paper and clams — Hoi An — dish

### Reader View

**Crack, Scoop, Then Slow Down**

Bánh đập hến xào is a small Hội An food ritual: crisp rice paper cracked over a soft rice sheet, with warm stir-fried clams, herbs, and sauce. It is texture first, not a heavy meal.

### Useful phrase cards

* **“Cho tôi một phần.”** — One portion, please.
* **“Không cay nhé.”** — Not spicy, please.
* **“Tính tiền giúp tôi.”** — Please let me pay.

### Sections

**Cẩm Nam Gives It Context**

Think of this around the quieter river-side food map of Cẩm Nam. The dish feels less like a formal order and more like a snack with a setting.

**Listen For The Crack**

The fun is in the contrast: brittle cracker, chewy rice sheet, soft clams, herbs. Break small pieces and scoop instead of trying to make a tidy bite.

**Light, Local, Memorable**

Order it when you want one local texture before a river walk or another dish. It still earns space because the eating motion stays with you.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-hoian-place-banh-dap-hen-xao`
* `displayName: Bánh đập hến xào ở Hội An`
* `englishName: Cracked rice paper and clams`
* `city: Hoi An`
* `category: Dish`
* `target_hero_image: HeroCityHoianPlaceBanhDapHenXao`
* `pronunciation: bahn dap hen sow uh hoy an`
* Closest canonical anchor: White Rose Restaurant / dish-source pattern, with scarce-evidence restraint.
* Anchor behavior copied: make the eating motion and first order clearer than a broad food description.
* How this page differs: this is a dish page with no exact ready-audio place-name phrase and no exact menu-catalog item found, so the visible phrase cards stay reusable.
* Owned traveler moment: a traveler hearing and feeling the rice paper crack before the first bite.

### Phrase/audio status

* **“Cho tôi một phần.”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Không cay nhé.”** — `intent: request_not_spicy` · `phraseId: food-3` · `audioId: food-3` · `status: mapped`
* **“Tính tiền giúp tôi.”** — `intent: pay_now` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`
* Place-name phrase: `city-hoian-place-banh-dap-hen-xao` · audio planned only · `hide_until_audio`

### Mentioned Here candidates

* **Cẩm Nam** — `type: neighborhood` · `catalogId: hoian-cam-nam` · `status: render`

  * `sourceText: Cẩm Nam`
  * `displaySubtitle: Quieter river-side food context for this dish.`
  * `reason: Named naturally in the context section.`
* **Cracked rice paper and clams** — `type: food` · `catalogId: hoian-banh-dap-hen-xao` · `status: do_not_render`

  * `sourceText: Bánh đập hến xào`
  * `displaySubtitle: Current page; do not render as a self-link.`
  * `reason: Self-page mention only.`

### Related place candidates

* **Thu Bon River** — `relationship: light_route_pairing` · `catalogId: hoian-thu-bon-river` · `status: render`

  * `displaySubtitle: A slow walk pairing after a light Cẩm Nam snack.`
  * `reason: The visible copy frames this as a light dish before a river walk.`
* **Cẩm Nam** — `relationship: food_context_area` · `catalogId: hoian-cam-nam` · `status: render`

  * `displaySubtitle: Neighborhood context for simple clam-and-rice-paper meals.`
  * `reason: Named in visible copy as the clearest place context.`

### Verification flags

* `type: light`

  * `reason: Dish availability, exact local spelling variants, and Cam Nam venue specifics should be checked before import.`
  * `blocking: false`
* `type: native_speaker_qa`

  * `reason: Pronunciation and place-name wording need native confirmation.`
  * `blocking: false`
* `type: catalog_qa`

  * `reason: No exact Menu Catalog item found for bánh đập hến xào; confirm whether a new food item is needed.`
  * `blocking: false`

### Source/freshness notes

* Batch row source notes: Hoi An and Cam Nam food references.
* Legacy source describes rice crackers with stir-fried clams and herbs.
* Visible copy avoids naming a specific current vendor, price, hours, or exact serving size.

### Score

26/30 — Usable, restrained dish draft with clear eating behavior. Capped for sparse exact catalog support, missing ready place-name audio, and native/local food QA.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready audio.
* Mentioned Here test: pass; Cẩm Nam evaluated and self-link suppressed.
* Catalog mention scan: needs_review; no exact menu-catalog item found for the dish.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Bánh mì Hội An / Banh mi in Hoi An — Hoi An — dish

### Reader View

**Decide Before The Bread Opens**

Hoi An bánh mì is a fast counter decision wrapped in crisp bread: filling, chili, sauce, herbs, and whether it travels with you. The sandwich feels simple once those choices are clear.

### Useful phrase cards

* **“Cái này bao nhiêu?”** — How much is this?
* **“Không cay nhé.”** — Not spicy, please.
* **“Mang đi.”** — To go.

### Sections

**Start With A Clear Filling**

Pork gives the richer, pâté-friendly style. Chicken is gentler. Egg works when you want a smaller breakfast feel. Fillings vary by shop, so choose one first and let the counter move.

**Ask About Chili Early**

Chili and sauce go in before the first bite, not after. Say mild before the bread is built if you want the herbs, pickles, and pâté to stay in balance.

**Best While The Bread Is Still Crisp**

A paper wrapper and a street counter are part of the rhythm. This is a between-stops meal: sharp, warm, quick, and better before the steam softens the loaf.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-hoian-place-banh-mi`
* `displayName: Bánh mì Hội An`
* `englishName: Banh mi in Hoi An`
* `city: Hoi An`
* `category: Dish`
* `target_hero_image: HeroCityHoianPlaceBanhMi`
* `pronunciation: bahn mee hoy an`
* Closest canonical anchor: Bánh Mì Phượng, adapted from named counter to general dish.
* Anchor behavior copied: choose filling, chili, sauce, and takeaway before counter pressure.
* How this page differs: this page teaches the general Hội An bánh mì decision rather than one famous shop’s line rhythm.
* Owned traveler moment: reaching the counter and needing to choose filling/chili before the bread is assembled.

### Phrase/audio status

* **“Cái này bao nhiêu?”** — `intent: ask_price` · `phraseId: price-1` · `audioId: price-1` · `status: mapped`
* **“Không cay nhé.”** — `intent: request_not_spicy` · `phraseId: food-3` · `audioId: food-3` · `status: mapped`
* **“Mang đi.”** — `intent: takeaway` · `phraseId: coffee-6` · `audioId: coffee-6` · `status: mapped`
* Place-name phrase: `city-hoian-place-banh-mi` · audio planned only · `hide_until_audio`

### Mentioned Here candidates

* **Bánh mì thịt** — `type: food` · `catalogId: food-banh-mi-thit` · `status: render`

  * `sourceText: Pork`
  * `displaySubtitle: Richer pork bánh mì with pickles, herbs, and chili optional.`
  * `reason: Pork filling is named naturally in the filling section.`
* **Bánh mì gà** — `type: food` · `catalogId: food-banh-mi-ga` · `status: render`

  * `sourceText: Chicken`
  * `displaySubtitle: Gentler chicken bánh mì option when available.`
  * `reason: Chicken filling is named naturally in the filling section.`
* **Bánh mì ốp la** — `type: food` · `catalogId: food-banh-mi-op-la` · `status: render`

  * `sourceText: Egg`
  * `displaySubtitle: Breakfast-style egg bánh mì when you want a smaller start.`
  * `reason: Egg is named naturally as a filling option.`
* **Banh mi in Hoi An** — `type: food` · `catalogId: hoian-banh-mi` · `status: do_not_render`

  * `sourceText: Hoi An bánh mì`
  * `displaySubtitle: Current page; do not render as a self-link.`
  * `reason: Self-page mention only.`

### Related place candidates

* **Banh Mi Phuong** — `relationship: named_counter_option` · `catalogId: hoian-banh-mi-phuong` · `status: render`

  * `displaySubtitle: Faster, famous counter version of the same ordering decision.`
  * `reason: Natural comparison for travelers who want a named bánh mì stop.`
* **Madam Khanh** — `relationship: named_counter_option` · `catalogId: hoian-madam-khanh` · `status: render`

  * `displaySubtitle: Another Hội An sandwich counter where filling and heat matter.`
  * `reason: Useful comparison for the general bánh mì page.`

### Verification flags

* `type: light`

  * `reason: Current shop fillings, chili/sauce patterns, and menu variants vary by vendor.`
  * `blocking: false`
* `type: native_speaker_qa`

  * `reason: Pronunciation and phrase-card glosses need native confirmation.`
  * `blocking: false`
* `type: catalog_qa`

  * `reason: Confirm whether Mentioned Here should prefer menu item IDs or city dish IDs.`
  * `blocking: false`

### Source/freshness notes

* Batch row source notes: Vietnam food and Hoi An local references.
* Menu Catalog includes bánh mì đặc biệt, bánh mì thịt, bánh mì gà, bánh mì ốp la, and other bánh mì variants.
* Visible copy avoids naming exact current shops, rankings, prices, or hours.

### Score

27/30 — Clear general dish page with strong counter behavior and mapped phrases. Capped for vendor variation, planned place-name audio, and native/catalog QA.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready audio.
* Mentioned Here test: pass; food variants evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Bánh mì Phượng / Banh Mi Phuong — Hoi An — restaurant

### Reader View

**Choose Before The Counter Moves**

Bánh Mì Phượng works best when filling, chili, sauce, and takeaway are decided before you reach the glass case. The line can make the sandwich feel bigger than it is; the better version is still a quick, confident Hội An food stop.

### Useful phrase cards

* **“Ít cay thôi.”** — Less spicy, please.
* **“Mang đi.”** — To go.
* **“Tính tiền giúp tôi.”** — Please let me pay.

### Sections

**Fast Bread, Many Hands**

Expect crisp rolls, pâté, herbs, pickles, meat or chicken, sauce, and heat layered fast. Give the counter one clear order instead of negotiating every bite at the glass.

**Classic Means Richer**

Pork and pâté carry the heavier house rhythm. Chicken is easier if you want a cleaner read, and little chili keeps the first sandwich from becoming only heat.

**A Short Old Town Break**

Keep the stop small: order, eat nearby, then go back into the streets. It still makes sense when you want the famous counter without letting the fame take over the meal.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-hoian-place-banh-mi-phuong`
* `displayName: Bánh mì Phượng`
* `englishName: Banh Mi Phuong`
* `city: Hoi An`
* `category: Restaurant`
* `target_hero_image: HeroCityHoianPlaceBanhMiPhuong`
* `pronunciation: bahn mee fwuhng`
* Closest canonical anchor: Bánh Mì Phượng revised canonical example, with Bale Well for pre-order confidence.
* Anchor behavior copied: make the first move a choice sequence before counter pressure.
* How this page differs: this draft limits visible copy to durable ordering behavior and keeps current status/reopening/food-safety context internal.
* Owned traveler moment: the line reaching the glass case before the traveler has chosen filling, chili, sauce, and takeaway.

### Phrase/audio status

* **“Ít cay thôi.”** — `intent: request_less_spicy` · `phraseId: food-not-spicy-clearer` · `audioId: audio-authored-it-cay-thoi-05b8e258a2` · `status: mapped`
* **“Mang đi.”** — `intent: takeaway` · `phraseId: coffee-6` · `audioId: coffee-6` · `status: mapped`
* **“Tính tiền giúp tôi.”** — `intent: pay_now` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`
* Place-name phrase: `city-hoian-place-banh-mi-phuong` · `audioId: audio-authored-banh-mi-phuong-db1ed9143b` · `status: mapped` for pronunciation/name audio only, not needed as a utility phrase card.

### Mentioned Here candidates

* **Bánh mì thịt** — `type: food` · `catalogId: food-banh-mi-thit` · `status: render`

  * `sourceText: Pork`
  * `displaySubtitle: Richer pork bánh mì direction for a classic order.`
  * `reason: Pork is named naturally in the classic-order section.`
* **Bánh mì gà** — `type: food` · `catalogId: food-banh-mi-ga` · `status: render`

  * `sourceText: Chicken`
  * `displaySubtitle: Gentler chicken bánh mì option when available.`
  * `reason: Chicken is named naturally as the calmer filling option.`
* **Hoi An Ancient Town** — `type: neighborhood` · `catalogId: hoian-ancient-town` · `status: render`

  * `sourceText: Old Town`
  * `displaySubtitle: Nearby old-street context for a short food break.`
  * `reason: Old Town route behavior appears naturally in visible copy.`
* **Banh Mi Phuong** — `type: place` · `catalogId: hoian-banh-mi-phuong` · `status: do_not_render`

  * `sourceText: Bánh Mì Phượng`
  * `displaySubtitle: Current page; do not render as a self-link.`
  * `reason: Self-page mention only.`

### Related place candidates

* **Banh mi in Hoi An** — `relationship: dish_context` · `catalogId: hoian-banh-mi` · `status: render`

  * `displaySubtitle: Learn the general sandwich choices before a named counter stop.`
  * `reason: Direct dish context for the restaurant page.`
* **Madam Khanh** — `relationship: comparable_banh_mi_counter` · `catalogId: hoian-madam-khanh` · `status: render`

  * `displaySubtitle: Another Hội An sandwich counter where filling and heat matter.`
  * `reason: Useful comparison for travelers choosing between famous bánh mì counters.`
* **Hoi An Ancient Town** — `relationship: route_pairing` · `catalogId: hoian-ancient-town` · `status: render`

  * `displaySubtitle: Keep the stop small before returning to the old streets.`
  * `reason: Visible copy frames the restaurant as a short Old Town break.`

### Verification flags

* `type: light`

  * `reason: Opening status, hours, current menu options, queue pattern, and recent food-safety/local-news context should be checked before import.`
  * `blocking: false`
* `type: native_speaker_qa`

  * `reason: Phrase-card naturalness, pronunciation, and place-name audio should be checked by a native speaker.`
  * `blocking: false`
* `type: audio_qa`

  * `reason: Visible phrase cards are mapped to ready audio; confirm app wiring for the ready place-name audio.`
  * `blocking: false`
* `type: catalog_qa`

  * `reason: Confirm food/menu item cards and related restaurant cards link to the intended app targets.`
  * `blocking: false`

### Source/freshness notes

* Batch row source notes: existing city-library; Vietnam Tourism and local food references.
* Source Bundle canonical revision keeps reopening/safety concern internal and focuses visible copy on choosing filling, chili, sauce, and takeaway.
* Visible copy avoids current hours, address, reopening claims, safety claims, exact menu list, and price.

### Score

27/30 — Strong traveler decision and strong canonical fit. Capped for current venue/status/menu verification and native/audio QA.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready audio.
* Mentioned Here test: pass; menu items and route pairing evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Bánh xèo Hội An / Hoi An banh xeo — Hoi An — dish

### Reader View

**Tear It Small Before You Dip**

Hội An bánh xèo is a crisp pancake you eat with your hands: tear a small piece, fold it into rice paper or lettuce with herbs, then dip lightly. The first bite should crunch before the sauce takes over.

### Useful phrase cards

* **“Cho tôi một phần.”** — One portion, please.
* **“Cho thêm rau.”** — More herbs, please.
* **“Ít cay thôi.”** — Less spicy, please.

### Sections

**Small Pancake, Big Setup**

The plate can look simple until the herbs, wrappers, and dipping sauce arrive. Give yourself a minute before eating; the wrapping is half the point.

**Shrimp, Pork, Or Chay Need A Check**

Classic versions often include pork and shrimp; vegetarian versions may still need a dip question. Ask before ordering if meat, shellfish, or fish sauce matters.

**Better Hot Than Perfect**

Wait too long and the crisp edge softens. Eat while it is warm, with enough herbs to cool the oil and enough sauce to season without drowning the pancake.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-hoian-place-banh-xeo`
* `displayName: Bánh xèo Hội An`
* `englishName: Hoi An banh xeo`
* `city: Hoi An`
* `category: Dish`
* `target_hero_image: HeroCityHoianPlaceBanhXeo`
* `pronunciation: bahn say-oh hoy an`
* Closest canonical anchor: White Rose Restaurant for dish-source focus, plus Hàn Market for food-card awareness.
* Anchor behavior copied: teach the first eating move rather than over-describing the dish.
* How this page differs: this is a general dish page, so it avoids venue claims and focuses on wrapping, dipping, and ingredient checks.
* Owned traveler moment: the pancake, herbs, wrappers, and sauce arriving at the table before the traveler knows how to assemble the first bite.

### Phrase/audio status

* **“Cho tôi một phần.”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cho thêm rau.”** — `intent: ask_more_herbs` · `phraseId: food-4` · `audioId: food-4` · `status: mapped`
* **“Ít cay thôi.”** — `intent: request_less_spicy` · `phraseId: food-not-spicy-clearer` · `audioId: audio-authored-it-cay-thoi-05b8e258a2` · `status: mapped`
* Place-name phrase: `city-hoian-place-banh-xeo` · audio planned only · `hide_until_audio`

### Mentioned Here candidates

* **Bánh xèo** — `type: food` · `catalogId: food-banh-xeo` · `status: render`

  * `sourceText: bánh xèo`
  * `displaySubtitle: Crisp turmeric-rice pancake eaten with herbs and dip.`
  * `reason: The dish is named naturally throughout; menu item can support food-card rendering.`
* **Bánh xèo chay** — `type: food` · `catalogId: food-banh-xeo-chay` · `status: render`

  * `sourceText: Chay`
  * `displaySubtitle: Vegetarian pancake option; dip still needs a check.`
  * `reason: Vegetarian version is named naturally in ingredient-check guidance.`
* **Hoi An banh xeo** — `type: food` · `catalogId: hoian-banh-xeo` · `status: do_not_render`

  * `sourceText: Hội An bánh xèo`
  * `displaySubtitle: Current page; do not render as a self-link.`
  * `reason: Self-page mention only.`

### Related place candidates

* **Bale Well** — `relationship: roll_it_yourself_context` · `catalogId: hoian-bale-well` · `status: render`

  * `displaySubtitle: Shared set meal where bánh xèo appears inside the rolling ritual.`
  * `reason: Bánh xèo is part of the Bale Well meal context and helps route food learning.`
* **Hoi An Ancient Town** — `relationship: general_food_route` · `catalogId: hoian-ancient-town` · `status: check_catalog`

  * `displaySubtitle: Easy old-street area to pair with a quick pancake stop.`
  * `reason: Useful route pairing, though not named directly in visible copy.`

### Verification flags

* `type: light`

  * `reason: Current local serving style, ingredient defaults, vegetarian dip handling, and vendor availability vary by shop.`
  * `blocking: false`
* `type: native_speaker_qa`

  * `reason: Pronunciation, chay wording, and phrase-card naturalness need native confirmation.`
  * `blocking: false`
* `type: catalog_qa`

  * `reason: Confirm whether Mentioned Here should render Menu Catalog `food-banh-xeo`or city dish`hoian-banh-xeo` for non-self contexts.`
  * `blocking: false`

### Source/freshness notes

* Batch row source notes: Central Vietnam food references.
* Menu Catalog supports bánh xèo as a crisp turmeric-rice pancake eaten with herbs, rice paper or lettuce, and fish-sauce dip; vegetarian bánh xèo also exists as a catalog item.
* Visible copy avoids naming a specific vendor, price, hours, and exact current filling list beyond common ingredient checks.

### Score

28/30 — Strong dish behavior, clear phrase fit, and useful ingredient checks. Capped for local serving variation, planned place-name audio, and native/catalog QA.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready audio.
* Mentioned Here test: pass; menu variants evaluated and self-link suppressed.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Batch-level QA summary

* All five requested page IDs from Batch 010 are included.
* Reader View appears before implementation notes for each listing.
* Visible phrase cards are limited to 2–3 per listing.
* Visible phrase cards use ready-audio reusable phrases only.
* One place-name phrase has ready audio: `city-hoian-place-banh-mi-phuong`; it is marked for pronunciation/name audio only, not forced into the utility phrase-card set.
* Place-name phrases without ready audio are marked `hide_until_audio`.
* No visible copy uses the banned app-internal phrases from the batch prompt.
* No page is marked production-ready.
* Screenshot review and production review gate remain `not_run`.

```markdown
## Codex handoff block

- `batch_id: batch_010`
- `page_ids: city-hoian-place-bale-well, city-hoian-place-banh-dap-hen-xao, city-hoian-place-banh-mi, city-hoian-place-banh-mi-phuong, city-hoian-place-banh-xeo`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: none for visible phrase cards; all visible cards are mapped to ready-audio reusable phrase IDs`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio; city-hoian-place-banh-mi-phuong has ready name audio, while city-hoian-place-bale-well, city-hoian-place-banh-dap-hen-xao, city-hoian-place-banh-mi, and city-hoian-place-banh-xeo are hide_until_audio`
- `visible_copy_risks: no hours, prices, rankings, current reopening claims, or exact address claims are visible; Banh Mi Phuong fame/counter-speed language should get Jojo voice review for balance`
- `source_freshness_risks: Bale Well set price/portion/service rhythm; Banh Mi Phuong opening status, hours, menu options, queue pattern, and recent food-safety/local-news context; dish serving styles, ingredient defaults, vegetarian dip handling, vendor availability, and local spelling/pronunciation`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```
