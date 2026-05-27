# SpeakLocal Canonical 31 Example Set v2.2

Voice anchors plus selected app-detail models for the live app implementation.

Use with: `SpeakLocal_Editorial_Playbook_v2_2_Portable.md`.

## What v2.2 changes

The v2.1 examples successfully taught the SpeakLocal voice. The live app render surfaced the next layer: the examples also need to teach **how the app should display copy**.

New sessions should learn these extra rules from this file:

1. **Useful Phrases are playable cards, not prose.**  
   Each phrase should map to an existing phrase/audio item when possible.

2. **Mentioned Here is a catalog-link layer.**  
   If the copy naturally mentions foods, places, streets, neighborhoods, or experiences already in the app catalog, propose them as `mentionedHereCandidates`.

3. **Do not force mentions.**  
   The copy should still feel natural. Links should follow the copy, not the other way around.

4. **No duplicate bodies.**  
   Do not render the same paragraph twice. Do not render both a mobile body and an expanded section if they repeat the same sentence.

5. **The app uses an app-detail version.**  
   For major listings, the app may show an intro, phrase cards, two to four sections, Mentioned Here cards, and a comparison or related-place section. That is not too long if every section has a different job.

6. **The original “mobile-first entry” remains a compression reference.**  
   It is not the only thing the app should render. The app should render the `app-detail entry` when available.

Important: only examples with an explicit `App-detail entry` are full v2.2 output models. Entries labeled `Mobile-first entry` are voice references only. Convert them through `speaklocal.place.app-detail.v2.2.schema.json` and `V2_2_PRODUCTION_REVIEW_GATE.md` before using them for production.

## App-detail output model

For every new or revised listing, produce:

- `intro` — one traveler-use heading and one short body.
- `useful_phrase_cards` — 3–4 phrase cards, ideally with existing audio.
- `sections` — 2–4 distinct practical sections.
- `mentionedHereCandidates` — catalog items named naturally in the copy.
- `relatedPlaceCandidates` — only when comparison or navigation is useful.
- `verificationFlags` — internal only unless status-blocking.

## Canonical app-detail anchors added in v2.2

The Hàn Market and Ba Na Hills entries below are rewritten as app-detail examples because the live app revealed two important product lessons:

- Hàn Market needs phrase cards + Mentioned Here item cards.
- Ba Na Hills needs expectation-setting that stays honest without becoming too caution-heavy.

## Calibration Report

### 10 strongest canonical anchors

1. **Chợ Hàn (Hàn Market)** - teaches the **first-bearings market** pattern: define the market's job before listing inventory. It orients the traveler with one roof, one first lap, one food move, and one timing split between breakfast energy and gift shopping.
2. **The Note Coffee** - teaches the **touristy ritual without shame** pattern: admit the place is touristy, then give a simple sequence the traveler can enjoy anyway: order, climb, read, leave a note.
3. **Bà Lễ Well / Bale Well** - teaches the **friction-to-confidence** pattern: when pricing, service rhythm, or portion size can be unclear, turn the first action into a confidence cue before the traveler sits down.
4. **Cà phê Giảng** - teaches the **ritual plus origin story** pattern: give one first order, one arrival cue, and one softer alternative without turning the listing into a coffee-history essay.
5. **Dragon Bridge / Cầu Rồng** - teaches the **simple landmark with one real decision** pattern: close and wet versus farther and cleaner view. The object becomes usable because the traveler knows where to stand.
6. **Museum of Cham Sculpture** - teaches the **museum-fatigue prevention** pattern: give the traveler three anchors and repeated forms to look for instead of asking them to read every label.
7. **Perfume River / Sông Hương** - teaches the **scenery needs a route** pattern: a river cruise becomes useful only when tied to a destination, price, time, return, and safety questions.
8. **Bùi Viện Walking Street** - teaches the **nightlife safety without fear-mongering** pattern: look first, sit later, keep valuables close, check prices, and preserve curiosity.
9. **Ba Na Hills / Bà Nà Hills** - teaches the **expectation-setting without deflation** pattern: name the theme-park reality, then keep the still-worth-it sentence about cable car, mountain air, and weather.
10. **Japan Town Saigon** - teaches the **cluster-neighborhood entry** pattern: choose one alley or street, read the door before entering, and treat business type as part of traveler orientation.

### Useful secondary examples, not primary anchors yet

- **Làng hương Thủy Xuân** - strong craft-village copy, but it is a specialized one-off until more craft/workshop entries exist.
- **Đường Đồng Khởi** - useful street-spine model, but it needs more sibling street examples before becoming a primary street anchor.
- **White Rose Restaurant** - strong dish-source example, but Bale Well carries a more reusable restaurant-friction pattern.
- **Chợ Cồn** - strong food-first market, best used beside Hàn Market rather than alone because the reusable lesson is contrast.
- **Chợ Lớn** - useful broad-district anchor, but Japan Town is tighter for cluster behavior.
- **Lập An Lagoon** - useful condition-dependent lagoon entry, but Perfume River and Bạch Mã teach route and condition decisions more broadly.
- **Da Nang Museum** - useful new-venue pattern, but current entrance, hours, and exhibit state make it verification-heavy.
- **Da Nang Fine Arts Museum** - good museum variant, but still derivative of Cham Museum and Da Nang Museum.
- **Chợ đêm Sơn Trà** - useful riverfront-night-market add-on, but hours, stall mix, and Dragon Bridge pairing need same-week checks.
- **Phá Tam Giang** - strong lagoon route entry, but boat, dock, weather, and seafood details are too changeable for a primary anchor.
- **Vườn quốc gia Bạch Mã** - strong nature-day example, but it works best as a companion to Ba Na Hills and Lập An for condition-setting.

### Five weakest or least production-ready examples

These are not failures. They are the five examples most likely to drift generic, overlap another entry, or need a narrower production frame.

1. **Bánh Mì Phượng** - revised against **Bale Well** and **Cà phê Giảng**. The old version was useful but leaned too much on counter speed and status context; the revision makes the first move clearer and keeps the reopening/safety concern internal.
2. **Chợ Bắc Mỹ An** - revised against **Hàn Market / Cồn Market** and the scarce-evidence fallback. The old version was already narrow; the revision makes kem bơ the opening behavior and avoids inflating the market.
3. **Madam Khanh** - revised against **Bánh Mì Phượng** and **Bale Well**. The old version risked collapsing into the same famous-bánh-mì copy as Bánh Mì Phượng; the revision differentiates it through heat, sauce, and a calmer order.
4. **Morning Glory Original** - revised against **White Rose** and **Bale Well**. The old version was solid but too close to "polished first meal"; the revision teaches how to use a broad menu without overordering.
5. **Thảo Điền** - revised against **Japan Town Saigon** and **Chợ Lớn**. The old version was honest but broad; the revision pins the neighborhood to one street, one stop, and one return plan.

## Full 31-Entry Set

### 1. Chợ Hàn (Hàn Market) - Đà Nẵng - Market

**Calibration role:** Primary canonical anchor.

**Pattern taught:** First-bearings market + catalog-aware food mentions. Use a central market to orient the traveler before asking them to shop or eat.

**Closest anchor behavior:** Hàn Market teaches how a market page can combine practical copy, phrase cards, and `Mentioned Here` food cards without becoming a keyword list.

**App-detail entry**

**A Market For First Bearings**  
Hàn Market gives you a practical first read on central Đà Nẵng. Jars of mắm, dried squid, fabric stalls, rattan bags, and breakfast bowls make the city feel specific even if you buy nothing.

**Useful phrase cards**

- **"Cái này bao nhiêu?"** - How much is this?  
  `intent: ask_price` · `phraseId: existing_or_null` · `audioId: existing_or_null` · `status: mapped|close_match|new_phrase_needed|hide_until_audio`
- **"Bớt chút được không?"** - Can you lower it a little?  
  `intent: bargain_lightly` · `phraseId: existing_or_null` · `audioId: existing_or_null` · `status: mapped|close_match|new_phrase_needed|hide_until_audio`
- **"Cho tôi một phần."** - One portion, please.  
  `intent: order_small_portion` · `phraseId: existing_or_null` · `audioId: existing_or_null` · `status: mapped|close_match|new_phrase_needed|hide_until_audio`
- **"Trả ở đâu?"** - Where do I pay?  
  `intent: pay_location` · `phraseId: existing_or_null` · `audioId: existing_or_null` · `status: mapped|close_match|new_phrase_needed|hide_until_audio`

**Sections**

**Walk Once Before Choosing**  
The food area is easier after one slow lap. Notice where people are eating, then choose mì Quảng, bánh bèo, nem lụi, or a small bánh xèo instead of ordering from the first call.

**Morning Food, Later Gifts**  
Food rhythm is strongest early, while fabric, dried food, and souvenir browsing can feel easier after the first rush. The stop is still worth it because it gives central Đà Nẵng a working-market texture.

**Different Job Than Cồn**  
Hàn is the easier central market for bearings and gifts. Cồn is the stronger food-first choice when snacks matter more than location or polished browsing.

**Mentioned Here candidates**

- **Mì Quảng** — `type: food` · naturally named in food-area guidance · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`
- **Bánh bèo** — `type: food` · naturally named in food-area guidance · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`
- **Nem lụi** — `type: food` · naturally named in food-area guidance · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`
- **Bánh xèo** — `type: food` · naturally named in food-area guidance · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`
- **Chợ Cồn** — `type: market` · direct comparison · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`
- **Đà Nẵng** — `type: city` · city context · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`

**Implementation notes**

- Do not render the “Walk Once Before Choosing” body twice.
- Do not render useful phrases as a prose paragraph.
- Render phrase cards only if mapped to existing audio or flagged for phrase creation.
- Render Mentioned Here cards only for catalog items that exist.
- If the app has specific catalog variants like **Mì Quảng gà** or **Mì Quảng tôm thịt**, those may render instead of generic **Mì Quảng**.

**Verification flags:** Recheck current hours before publication. Vietnamese phrase/audio QA still required.

**Score:** 29/30 as an app-detail anchor. Capped below 30 for current hours and phrase/catalog mapping.


### 2. Làng hương Thủy Xuân (Thủy Xuân Incense Village) - Huế - Craft Village

**Calibration role:** Useful secondary example.

**Pattern taught:** Craft before photo. A colorful place still needs a working-process cue.

**Mobile-first entry**

**Go For The Craft, Not Just The Color**  
The incense fans are the easy photo, but the better move is to watch one stick being made. Ask before taking close photos, notice the cinnamon or agarwood scent, and go in the morning if you want softer light and more active making before the tomb route gets hot.

**Useful phrases**

- **"Cho tôi thử làm một cây nhang được không?"** - Could I try making one incense stick?
- **"Có nhang trầm hương không?"** - Do you have agarwood incense?
- **"Cái này bao nhiêu tiền?"** - How much is this?
- **"Tôi có thể chụp ảnh không?"** - May I take a photo?

**Verification flags:** Recheck current workshop/demo availability and photo expectations. Vietnamese phrase QA still recommended.

### 3. Đường Đồng Khởi (Đồng Khởi Street) - Ho Chi Minh City - Historic Street

**Calibration role:** Useful secondary example.

**Pattern taught:** Historic street as mental map. Start, direction, landmark steps, and realistic traffic.

**Mobile-first entry**

**Walk The Spine Toward The River**  
Start near the Central Post Office, pass the Opera House, and keep moving toward the Saigon River. Đồng Khởi is not a quiet heritage lane; it is old facades, hotel doors, traffic, shops, and coffee stops in one compact District 1 walk. Morning makes it easier to read.

**Useful phrases**

- **"Đường Đồng Khởi ở đâu?"** - Where is Đồng Khởi Street?
- **"Đi bộ đến Nhà hát Thành phố được không?"** - Can I walk to the Opera House?
- **"Bưu điện Trung tâm đi hướng nào?"** - Which way is the Central Post Office?
- **"Cho tôi hỏi, sông Sài Gòn ở đâu?"** - Excuse me, where is the Saigon River?

**Verification flags:** Recheck venue-specific closures if paired with landmark cards. Vietnamese phrase QA still recommended.

### 4. The Note Coffee - Hà Nội - Café

**Calibration role:** Primary canonical anchor.

**Pattern taught:** Touristy ritual without shame. The copy gives permission to enjoy the sequence without pretending the place is quiet or undiscovered.

**Mobile-first entry**

**Order, Climb, Leave A Note**  
The Note Coffee is best as a short Hanoi ritual: order egg coffee or coconut latte, climb to a seat, read a few notes, and leave one of your own. It can be crowded, so go for the memory rather than a quiet coffee session near Hoàn Kiếm.

**Useful phrases**

- **"Cho tôi một cà phê trứng."** - One egg coffee, please.
- **"Cho tôi giấy ghi chú được không?"** - Could I have note paper?
- **"Tôi có thể ngồi tầng trên không?"** - Can I sit upstairs?
- **"Ít ngọt thôi."** - Less sweet, please.

**Verification flags:** Recheck current address, hours, and branch status. Vietnamese phrase QA still recommended.

### 5. White Rose Restaurant - Hội An - Restaurant / Dish

**Calibration role:** Useful secondary example.

**Pattern taught:** Dish-source restaurant. Teach the focused order and allergy question instead of praising the restaurant broadly.

**Mobile-first entry**

**Start With The Dumpling Source**  
White Rose Restaurant is the focused stop for Hội An's bánh bao bánh vạc. Order the dumplings first, add fried wonton only if you want crunch, and ask about shrimp if shellfish matters. Go earlier if seeing the making matters; otherwise keep it a short food detour from Ancient Town.

**Useful phrases**

- **"Cho tôi một đĩa bánh bao bánh vạc."** - One plate of white rose dumplings, please.
- **"Bánh này có tôm không?"** - Does this dumpling have shrimp?
- **"Cho thêm nước chấm được không?"** - Could I have more dipping sauce?
- **"Tôi có thể xem cách làm không?"** - Could I see how it is made?

**Verification flags:** Recheck current hours. Vietnamese phrase QA still recommended.

### 6. Bà Lễ Well / Bale Well - Hội An - Restaurant

**Calibration role:** Primary canonical anchor.

**Pattern taught:** Friction-to-confidence. Mixed reviews, set menus, and fast service become one first question.

**Mobile-first entry**

**Confirm The Set First**  
Bale Well is a roll-it-yourself meal built around pork skewers, bánh xèo, spring rolls, herbs, rice paper, and sauce. Ask the set price before the spread arrives, and check whether a smaller portion is possible if you are solo. Let the staff show you the first roll.

**Useful phrases**

- **"Một suất ăn bao nhiêu tiền?"** - How much is one set meal?
- **"Chỉ cho tôi cách cuốn được không?"** - Could you show me how to roll it?
- **"Cho thêm rau được không?"** - Could I have more herbs?
- **"Tính tiền giúp tôi."** - The bill, please.

**Verification flags:** Recheck current set price and recent review pattern. Vietnamese phrase QA still recommended.

### 7. Chợ Cồn - Đà Nẵng - Market

**Calibration role:** Useful secondary example.

**Pattern taught:** Same category, different job. This is the food-first contrast to Hàn Market's orientation role.

**Mobile-first entry**

**The Food-First Market**  
Choose Cồn Market when you want Đà Nẵng snacks more than souvenirs. Do one slow lap, then start small with bánh bèo, bánh bột lọc, bún mắm, or mì Quảng. Afternoon is a strong snack window; bring cash and follow the busier counters instead of the loudest call.

**Useful phrases**

- **"Món này là gì?"** - What is this dish?
- **"Cho tôi một phần nhỏ."** - Give me a small portion.
- **"Có cay không?"** - Is it spicy?
- **"Tôi ăn ở đây."** - I will eat here.

**Verification flags:** Recheck current hours and food-court changes. Vietnamese phrase QA still recommended.

### 8. Cà phê Giảng - Hà Nội - Café

**Calibration role:** Primary canonical anchor.

**Pattern taught:** Ritual plus origin story. One first order, one entrance cue, one softer alternative.

**Mobile-first entry**

**Start Hot And Classic At The Source**  
Find the original Nguyễn Hữu Huân shop through its narrow Old Quarter entrance and order hot cà phê trứng first. The cup is small, rich, and more dessert-like than a normal coffee. If coffee feels too bitter, egg cocoa gives you the same creamy top.

**Useful phrases**

- **"Cho tôi một cà phê trứng nóng."** - One hot egg coffee, please.
- **"Có ca cao trứng không?"** - Do you have egg cocoa?
- **"Ít ngọt được không?"** - Can it be less sweet?
- **"Quán ở trong ngõ phải không?"** - Is the café inside the alley?

**Verification flags:** Recheck current hours and branch/address details. Vietnamese phrase QA still recommended.

### 9. Dragon Bridge / Cầu Rồng - Đà Nẵng - Landmark

**Calibration role:** Primary canonical anchor.

**Pattern taught:** Simple landmark with one decision. Turn a famous object into a stand-close-or-stand-back choice.

**Mobile-first entry**

**Choose Dry Or Close**  
Stand near Dragon Bridge if you want to feel the spray; stay on the riverbank if you want the clean view. On show nights, arrive early enough to choose your side, then recheck the schedule that week. Pair it with the Hàn River walk or Sơn Trà Night Market.

**Useful phrases**

- **"Cầu Rồng ở đâu?"** - Where is Dragon Bridge?
- **"Mấy giờ phun lửa?"** - What time is the fire show?
- **"Tôi muốn đứng bên bờ sông."** - I want to stand by the riverbank.
- **"Chỗ này có bị ướt không?"** - Will this spot get wet?

**Verification flags:** Recheck the official show schedule the same week. Vietnamese phrase QA still recommended.

### 10. Bánh Mì Phượng - Hội An - Restaurant

**Calibration role:** Revised weakest / least production-ready example.

**Closest strong anchor:** Bale Well for pre-order confidence, plus Cà phê Giảng for first-order ritual.

**What changed:** The revision keeps the famous-counter reality but makes the first behavior clearer: choose filling, chili, and sauce before the counter. Safety/reopening context stays internal as a verification flag rather than taking over the traveler copy.

**Revised expanded version**

**Choose Before The Counter Moves**  
Bánh Mì Phượng works best when you decide before the line reaches the glass case: filling, chili, sauce, and whether you are eating now or taking it away. The counter can move quickly, and the sandwich is easier to enjoy when you are not making every choice under pressure.

**Fast Bread, Many Hands**  
Expect crisp rolls, pâté, herbs, pickles, meat or chicken, sauce, and heat built in layers. It is famous, but the useful part is still practical: a fast Hội An sandwich that teaches you how much flavor can fit into one roll.

**Start Classic, Control The Heat**  
If you want the house rhythm, start with pork and pâté. If heat worries you, ask for little chili before the sandwich is built; if you want the gentler move, chicken is easier to read.

**Earlier Keeps It Human**  
Go before peak queue time if you want the sandwich rather than the crowd to be the main event. The fame can make the stop feel bigger than it needs to be, but a well-built bánh mì is still worth the short detour.

**Keep It A Food Stop**  
Use Phan Châu Trinh as a quick break from Ancient Town, not the whole itinerary. Order, eat nearby, then move back into the streets.

**Mobile-first entry**

**Choose Before The Counter Moves**  
Bánh Mì Phượng moves fast, so choose your filling, chili, and sauce before the counter. Start classic with pork and pâté if you want the house rhythm; ask for little or no chili before the sandwich is built. The fame can make the stop feel bigger than it is, but a crisp, well-built bánh mì is still worth a short Hội An detour.

**Useful phrases**

- **"Một bánh mì thịt, ít ớt."** - One pork bánh mì, little chili.
- **"Không ớt được không?"** - Can I have no chili?
- **"Có bánh mì gà không?"** - Do you have chicken bánh mì?
- **"Mang đi."** - To go.

**Score:** 27/30. Strong traveler decision and sharper differentiation, capped for current hours, recent status context, and native-speaker phrase QA.

**Verification flags:** Light verification for opening status, hours, recent food-safety/local-news context, and menu options. Vietnamese phrase QA required.

### 11. Chợ Lớn - Ho Chi Minh City - Neighborhood

**Calibration role:** Useful secondary example.

**Pattern taught:** Broad district through anchors. A big neighborhood needs a first market, one temple, and one nearby street type.

**Mobile-first entry**

**Anchor The District First**  
Chợ Lớn is too large to treat as one casual street. Start at Binh Tay Market, add Thiên Hậu Temple, then choose one nearby medicine, lantern, or fabric street. Go in the morning for more active trade and cooler sidewalks; expect short rides rather than one perfect walking loop.

**Useful phrases**

- **"Chợ Bình Tây ở đâu?"** - Where is Binh Tay Market?
- **"Chùa Bà Thiên Hậu đi hướng nào?"** - Which way is Thiên Hậu Temple?
- **"Tôi chỉ xem thôi."** - I am just looking.
- **"Gọi xe về Quận 1 giúp tôi được không?"** - Could you help call a car back to District 1?

**Verification flags:** Recheck temple and market hours. Vietnamese phrase QA still recommended.

### 12. Lập An Lagoon / Đầm Lập An - Huế / Lăng Cô - Nature

**Calibration role:** Useful secondary example.

**Pattern taught:** Condition-dependent route stop. Tide makes the difference between roadside water and a meaningful lagoon pause.

**Mobile-first entry**

**Go When The Tide Helps**  
Lập An Lagoon works best when low tide reveals sandbars, oyster beds, and people working close to the water. Stop for oysters or another local seafood dish if you eat there, and treat it as a Huế-Lăng Cô-Hải Vân road-trip pause rather than a full standalone day.

**Useful phrases**

- **"Khi nào thủy triều xuống?"** - When is low tide?
- **"Hàu hôm nay có tươi không?"** - Are the oysters fresh today?
- **"Cho tôi một đĩa hàu nướng."** - One plate of grilled oysters, please.
- **"Chỗ nào chụp ảnh an toàn?"** - Where is it safe to take photos?

**Verification flags:** Recheck tide timing and route/weather issues. Vietnamese phrase QA still recommended.

### 13. Ba Na Hills / Bà Nà Hills - Đà Nẵng - Theme Park / Landmark

**Calibration role:** Primary canonical anchor.

**Pattern taught:** Expectation-setting without deflation. Name the theme-park reality, then keep the still-worth-it sentence.

**Closest anchor behavior:** Ba Na Hills teaches how to protect travelers from the wrong expectation while still letting the place feel exciting.

**App-detail entry**

**More Theme Park Than Viewpoint**  
Ba Na Hills is a mountain theme park, not just a quiet Golden Bridge stop. Expect cable cars, replica French streets, gardens, rides, crowds, and fast-changing weather.

**Useful phrase cards**

- **"Vé bao nhiêu?"** - How much is the ticket?  
  `intent: ask_ticket_price` · `phraseId: existing_or_null` · `audioId: existing_or_null` · `status: mapped|close_match|new_phrase_needed|hide_until_audio`
- **"Tôi chụp hình ở đây được không?"** - Can I take photos here?  
  `intent: ask_photo_permission` · `phraseId: existing_or_null` · `audioId: existing_or_null` · `status: mapped|close_match|new_phrase_needed|hide_until_audio`
- **"Mấy giờ đóng cửa?"** - What time does it close?  
  `intent: ask_closing_time` · `phraseId: existing_or_null` · `audioId: existing_or_null` · `status: mapped|close_match|new_phrase_needed|hide_until_audio`
- **"Điểm gặp ở đâu?"** - Where is the meeting point?  
  `intent: ask_meeting_point` · `phraseId: existing_or_null` · `audioId: existing_or_null` · `status: mapped|close_match|new_phrase_needed|hide_until_audio`

**Sections**

**Cooler Air, Bigger Production**  
The cable car gives the real arrival: forest below, cooler air above, and a full resort complex instead of a quiet lookout. When the sky opens, the scale can feel genuinely cinematic.

**Bridge Before The Crowd**  
If the Golden Bridge matters, go early and do it before the rest of the park. After that, decide how much French Village, gardens, rides, or food you actually want.

**Early, With Weather Checked**  
Morning is the easiest crowd strategy. Fog or rain can hide the famous view, so the forecast matters before the ride west.

**A Half-Day Minimum**  
Ba Na Hills sits far enough from central Đà Nẵng to need a real outing. Pairing it with too many city stops makes the day feel rushed.

**Mentioned Here candidates**

- **Golden Bridge / Cầu Vàng** — `type: landmark` · central priority in copy · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`
- **French Village** — `type: experience/place` · named as park area · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`
- **Đà Nẵng** — `type: city` · origin context · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`
- **Ba Na Hills cable car** — `type: experience` · major experience cue · `catalogId: existing_or_null` · `status: render|check_catalog|do_not_render`

**Implementation notes**

- Avoid scolding language like “Know You Are Choosing…” when the softer heading above works.
- Avoid overly negative phrases such as “least painful crowd strategy.” Use “easiest crowd strategy.”
- Keep the still-worth-it sentence: clear weather and the cable-car scale can feel cinematic.
- Phrase cards should use existing audio if available; do not invent longer ticket phrases unless audio exists.

**Verification flags:** Same-week check for ticket price, cable-car status, park hours, weather, crowd conditions, and Golden Bridge access.

**Score:** 29/30 as an app-detail expectation-setting anchor. Capped below 30 for same-week weather/operations checks and phrase/catalog mapping.


### 14. Museum of Cham Sculpture - Đà Nẵng - Museum

**Calibration role:** Primary canonical anchor.

**Pattern taught:** Museum-fatigue prevention. Give the traveler a route and repeated forms before details.

**Mobile-first entry**

**Pick Three Anchors**  
Do not try to read every label first. Start with the Mỹ Sơn, Trà Kiệu, and Đồng Dương galleries, then look for repeated dancers, deities, animals, and altars. Go near opening so the museum stays calm, then pair it with the Hàn River or Dragon Bridge.

**Useful phrases**

- **"Cho tôi hai vé vào bảo tàng."** - Two museum tickets, please.
- **"Phòng Mỹ Sơn ở đâu?"** - Where is the Mỹ Sơn gallery?
- **"Có thuyết minh tiếng Anh không?"** - Is there English interpretation?
- **"Tôi có thể chụp ảnh không?"** - May I take photos?

**Verification flags:** Recheck hours, ticket price, and gallery access. Vietnamese phrase QA still recommended.

### 15. Perfume River / Sông Hương - Huế - River / Cultural Route

**Calibration role:** Primary canonical anchor.

**Pattern taught:** Vague scenery needs a destination. A boat ride becomes usable when anchored to Thiên Mụ, return, timing, and price.

**Mobile-first entry**

**Choose A Destination, Not A Cruise**  
For a first Perfume River ride, ask for Thiên Mụ Pagoda instead of a vague cruise. It gives the boat trip a clear point and helps Huế make sense: citadel, bridges, pagodas, tomb routes, and hotels arranged around the water. Confirm price, time, and return before boarding.

**Useful phrases**

- **"Đi thuyền đến chùa Thiên Mụ bao nhiêu tiền?"** - How much is a boat to Thiên Mụ Pagoda?
- **"Đi một chiều hay khứ hồi?"** - One way or round trip?
- **"Chuyến này mất bao lâu?"** - How long does this trip take?
- **"Có áo phao không?"** - Are there life jackets?

**Verification flags:** Recheck boat prices, current routes, and evening performance schedules. Vietnamese phrase QA still recommended.

### 16. Bùi Viện Walking Street - Ho Chi Minh City - Nightlife Street

**Calibration role:** Primary canonical anchor.

**Pattern taught:** Nightlife safety without fear-mongering. Look first, sit later, and make safety concrete.

**Mobile-first entry**

**Walk Once Before Sitting**  
Bùi Viện is Saigon's concentrated backpacker-nightlife strip. Do one pass before choosing a bar or food stall, keep your phone and bag close, and check prices before ordering. Early evening is kinder for a first look; later gets louder and more chaotic.

**Useful phrases**

- **"Cho tôi xem menu."** - Please show me the menu.
- **"Giá này cho một chai hay một xô?"** - Is this price for one bottle or one bucket?
- **"Không, cảm ơn."** - No, thank you.
- **"Gọi taxi giúp tôi được không?"** - Could you call me a taxi?

**Verification flags:** Recheck current pedestrianization nights and any local safety advisories. Vietnamese phrase QA still recommended.

### 17. Da Nang Museum / Bảo tàng Đà Nẵng - Đà Nẵng - Museum

**Calibration role:** Useful secondary example.

**Pattern taught:** New or recently renovated venue. Give the venue a trip role, then flag entrance and current-state checks.

**Mobile-first entry**

**Start With The City, Not The Beach**  
Use Da Nang Museum when you want the city behind the bridges and beaches. Start with one floor theme - city history, wartime context, or regional culture - instead of reading every display. Confirm the entrance, hours, and ticket price before going, then pair it with a Hàn River walk.

**Useful phrases**

- **"Cho tôi một vé vào bảo tàng."** - One museum ticket, please.
- **"Lối vào ở số 31 Trần Phú phải không?"** - Is the entrance at 31 Trần Phú?
- **"Khu lịch sử Đà Nẵng ở tầng nào?"** - Which floor is the Đà Nẵng history section?
- **"Hôm nay có phim 3D không?"** - Is there a 3D film today?

**Verification flags:** Same-week check for entrance flow, hours, ticket price, and special exhibits. Vietnamese phrase QA still recommended.

### 18. Chợ Bắc Mỹ An (Bắc Mỹ An Market) - Đà Nẵng - Market

**Calibration role:** Revised weakest / least production-ready example.

**Closest strong anchor:** Hàn Market and Cồn Market for market-job definition, plus the scarce-evidence fallback pattern.

**What changed:** The revision narrows the entry around kem bơ and small snack decisions. It avoids pretending the market has the evidence depth of Hàn or Cồn.

**Revised expanded version**

**Start With Kem Bơ, Then Decide**  
Bắc Mỹ An Market works best as a small snack stop near the Mỹ An side of Đà Nẵng. Start with kem bơ, then decide whether you want one hot snack or whether that is enough.

**Small Market, Small Orders**  
This is not the place to prove you can decode every stall. The useful move is to point politely, ask what something is, check spice, and keep the first order small.

**Do Not Turn It Into Hàn Or Cồn**  
Hàn is better for central bearings and gifts; Cồn is stronger for a fuller food-market crawl. Bắc Mỹ An is still worth it when you want a lower-pressure bite close to the beach side of the city.

**Use It When Nearby**  
Go if you are already around Mỹ An, Mỹ Khê, or a beach-side stay. It does not need to become a cross-city mission unless kem bơ is the point.

**Cash And Pointing Help**  
Bring small bills, expect simple seating, and avoid fixed claims about vendor hours or exact dishes until checked.

**Mobile-first entry**

**Start With Kem Bơ, Then Decide**  
Bắc Mỹ An Market is best as a small snack stop near the Mỹ An side of Đà Nẵng. Start with kem bơ, then add one hot snack only if you are still hungry. It is not Hàn or Cồn, and that is fine: the value is a lower-pressure bite near the beach side of the city.

**Useful phrases**

- **"Cho tôi một ly kem bơ."** - One avocado ice cream, please.
- **"Món này là gì?"** - What is this dish?
- **"Cho tôi một phần nhỏ."** - Give me a small portion.
- **"Có cay không?"** - Is it spicy?

**Score:** 27/30. Stronger and narrower; capped for sparse evidence, changing stall availability, and native-speaker phrase QA.

**Verification flags:** Light verification for stall hours, exact snack availability, and current prices. Vietnamese phrase QA required.

### 19. Madam Khanh - The Banh Mi Queen - Hội An - Restaurant

**Calibration role:** Revised weakest / least production-ready example.

**Closest strong anchor:** Bánh Mì Phượng for differentiating similar food counters, plus Bale Well for pre-order confidence.

**What changed:** The revision makes Madam Khanh less interchangeable with Bánh Mì Phượng by focusing on a calmer heat-and-sauce decision rather than fame.

**Revised expanded version**

**Name The Filling And Heat**  
Madam Khanh is easiest when you order like you already know the move: filling first, then chili level. The shop is known to travelers, but the actual task is simple counter confidence.

**A Famous Stop That Can Stay Small**  
The sandwich has the familiar Hội An shape: crisp roll, warm filling, herbs, pickles, sauce, and heat. It can still be worth it because the order is quick, the flavor is clear, and you do not need to make lunch into a project.

**Mixed If You Want The House Move**  
Ask for a mixed bánh mì if you want the fuller version. If spice or pork worries you, say that before the roll is built; vegetarian or chicken options need current menu confirmation.

**Earlier Than Peak Hunger**  
Go before the line turns the counter into pressure. The goal is a confident order, not proving you found the most famous sandwich in town.

**A Quick Ancient Town Anchor**  
Use it before a tailor appointment, lantern-street walk, or coffee stop. It is a good small meal, not the whole evening.

**Mobile-first entry**

**Name The Filling And Heat**  
At Madam Khanh, decide your filling and chili level before ordering. Ask for a mixed bánh mì if you want the fuller house-style move; say little or no chili before the roll is built. The stop is famous, but it can still work best as a small, quick Hội An meal before you move back into Ancient Town.

**Useful phrases**

- **"Một bánh mì thập cẩm, ít ớt."** - One mixed bánh mì, little chili.
- **"Không ớt được không?"** - Can I have no chili?
- **"Có bánh mì chay không?"** - Do you have vegetarian bánh mì?
- **"Mang đi."** - To go.

**Score:** 27/30. Better differentiation from Bánh Mì Phượng; capped for current menu, hours, address, and phrase QA.

**Verification flags:** Light verification for current hours, exact menu options, and address. Vietnamese phrase QA required.

### 20. Japan Town Saigon - Ho Chi Minh City - Neighborhood

**Calibration role:** Primary canonical anchor.

**Pattern taught:** Cluster-neighborhood entry. Choose one alley, read the door, and understand day/night shift.

**Mobile-first entry**

**Choose An Alley Before Dinner**  
Start around Lê Thánh Tôn and Thái Văn Lung, choose one alley, then decide: ramen, izakaya food, a quiet drink, or just a look. Read the door before entering because restaurants, bars, and adult-oriented businesses sit close together. Early dinner is easier than late-night wandering.

**Useful phrases**

- **"Đường Thái Văn Lung ở đâu?"** - Where is Thái Văn Lung Street?
- **"Cho tôi xem menu trước."** - Please show me the menu first.
- **"Tôi chỉ đi dạo thôi."** - I am just walking.
- **"Gọi xe về khách sạn giúp tôi được không?"** - Could you call a car back to my hotel?

**Verification flags:** Light verification for individual business status, pricing, and nighttime character. Vietnamese phrase QA still recommended.

### 21. Vườn quốc gia Bạch Mã (Bạch Mã National Park) - Huế / Đà Nẵng Region - Nature

**Calibration role:** Useful secondary example.

**Pattern taught:** Real nature-day condition setting. Pick one route, check weather, plan shoes and transport.

**Mobile-first entry**

**Check Weather Before Committing**  
Bạch Mã is a real nature day, not a quick viewpoint. Choose one main goal - Hải Vọng Đài, Five Lakes, or Đỗ Quyên Waterfall - then check weather, trail conditions, transport, and return timing before you go. Wear shoes with grip and expect wet steps or fog if the mountain turns.

**Useful phrases**

- **"Hôm nay trên núi có mưa không?"** - Is it raining on the mountain today?
- **"Đường lên Hải Vọng Đài ở đâu?"** - Where is the way to Hải Vọng Đài?
- **"Đường đi Ngũ Hồ có trơn không?"** - Is the way to Five Lakes slippery?
- **"Tôi cần hướng dẫn viên không?"** - Do I need a guide?

**Verification flags:** Same-week check for weather, trail conditions, road access, fees, and transport timing. Vietnamese phrase QA still recommended.

### 22. Morning Glory Original - Hội An - Restaurant

**Calibration role:** Revised weakest / least production-ready example.

**Closest strong anchor:** White Rose for Hội An food context, plus Bale Well for ordering confidence.

**What changed:** The revision makes the broad menu usable by teaching one anchor dish, one shared vegetable or side, and one ingredient question instead of framing the restaurant as a general first meal.

**Revised source notes**

- Taste Vietnam's Morning Glory page says the restaurant opened in 2006, was created by Ms Vy, and focuses on Vietnamese daily food, street food, snacks, home food, family recipes, and local Hội An specialties: [Taste Vietnam](https://tastevietnam.maisonvy.com/morning-glory-restaurant-hoi-an).
- The same official page lists Morning Glory Original at 106 Nguyễn Thái Học Street and ties it to an open-kitchen/cooking-school history.
- Current hours, booking/queue pattern, and exact menu availability should be checked before app publication.

**Revised expanded version**

**Pick One Hội An Dish First**  
Morning Glory is useful when you want a controlled first meal near the old streets, but the menu can get wide quickly. Choose one Hội An or central-coast anchor before adding anything else.

**Street Food In A Restaurant Frame**  
The room is organized, but the idea is still daily Vietnamese food: market snacks, home dishes, street-food logic, and family recipes brought into one place. That makes it easier than a food crawl, but not a reason to overorder.

**Ask About Pork, Shellfish, And Heat**  
Start with one local dish and one vegetable or shared plate only after you understand portion size. If pork, shellfish, or chili matters, ask before the table fills.

**Good When You Need Calm**  
This is still worth it when Ancient Town feels busy and you want your first Hội An dinner to be readable. Go before peak dinner pressure if you want the meal to feel calm rather than famous.

**Use It As A Launchpad**  
After one controlled meal, smaller counters and specialty stops become easier to understand. Do not ask Morning Glory to be the whole Hội An food story.

**Mobile-first entry**

**Pick One Hội An Dish First**  
Morning Glory is a controlled first meal near the old streets, but the menu can get wide fast. Choose one Hội An or central-coast anchor before adding a shared plate. Ask about pork, shellfish, and chili before the table fills. It is still worth it when Ancient Town feels busy and you want dinner to be readable.

**Useful phrases**

- **"Món nào là món đặc trưng của Hội An?"** - Which dish is a Hội An specialty?
- **"Món này có tôm hoặc thịt heo không?"** - Does this dish have shrimp or pork?
- **"Món này có cay không?"** - Is this dish spicy?
- **"Cho tôi một phần để chia."** - One portion to share, please.

**Score:** 28/30. Stronger ordering behavior and place specificity; capped for current menu/hours verification and native-speaker phrase QA.

**Verification flags:** Light verification for current hours, holiday hours, menu availability, booking/queue pattern, and phrase QA.

### 23. Da Nang Fine Arts Museum / Bảo tàng Mỹ thuật Đà Nẵng - Đà Nẵng - Museum

**Calibration role:** Useful secondary example.

**Pattern taught:** Museum variant by floor choice. Pick modern or folk first, then choose three works.

**Mobile-first entry**

**Pick Modern Or Folk First**  
Da Nang Fine Arts Museum works best when you choose one floor theme before reading every label. Start with modern works on the second floor or folk craft and regional objects on the third, then pick three pieces to actually notice. It is a compact downtown culture stop, useful before Hàn Market, the riverfront, or a rain break.

**Useful phrases**

- **"Cho tôi một vé vào bảo tàng."** - One museum ticket, please.
- **"Tầng mỹ thuật hiện đại ở đâu?"** - Where is the modern art floor?
- **"Có thuyết minh tiếng Anh không?"** - Is there English interpretation?
- **"Tôi có thể chụp ảnh không?"** - May I take photos?

**Verification flags:** Light verification for ticket notice, photo policy, temporary exhibitions, and English interpretation. Vietnamese phrase QA still recommended.

### 24. Chợ đêm Sơn Trà (Sơn Trà Night Market) - Đà Nẵng - Night Market

**Calibration role:** Useful secondary example.

**Pattern taught:** Night market as add-on, not mission. Pair it with nearby evening landmark behavior.

**Mobile-first entry**

**Snack Before The Bridge Show**  
Use Sơn Trà Night Market as an easy snack-and-walk near Dragon Bridge, not a serious food mission. Do one lap before buying, check seafood prices before agreeing, and start smaller if the grills feel too much. Pair it with Love Bridge, the river walk, or the Dragon Bridge show after rechecking the schedule that week.

**Useful phrases**

- **"Chợ đêm Sơn Trà ở đâu?"** - Where is Sơn Trà Night Market?
- **"Món này bao nhiêu tiền?"** - How much is this dish?
- **"Tính theo ký hay theo phần?"** - Is it priced by weight or by portion?
- **"Cầu Rồng đi hướng nào?"** - Which way is Dragon Bridge?

**Verification flags:** Same-week check for market hours, stall layout, seafood pricing pattern, and Dragon Bridge show schedule. Vietnamese phrase QA still recommended.

### 25. Thảo Điền - Ho Chi Minh City - Neighborhood

**Calibration role:** Revised weakest / least production-ready example.

**Closest strong anchor:** Japan Town Saigon for cluster behavior, plus Chợ Lớn for broad-area anchoring.

**What changed:** The revision narrows the neighborhood to one street and one first stop, then makes the return ride part of the decision.

**Revised source notes**

- VietnamOnline describes Thảo Điền as a relaxed neighborhood with restaurants, cafés, supermarkets, entertainment spots, and creative spaces such as The Factory Contemporary Arts Centre: [VietnamOnline](https://www.vietnamonline.com/destination/ho-chi-minh-city/districts/thao-dien.html).
- VnExpress, citing Time Out, describes Thảo Điền as walkable and tree-lined, with restaurants, spas, boutiques, Bakes, Tre Dining, Hue Cafe Roastery, Xuân Thủy Street, and Maison Marou: [VnExpress International](https://e.vnexpress.net/news/travel/places/hcmc-s-largest-expat-hub-thao-dien-named-among-world-s-coolest-neighborhoods-4799347.html).
- Business turnover and administrative naming should be checked before naming specific venues in app copy.

**Revised expanded version**

**Start On Xuân Thủy**  
Thảo Điền is easier if you choose one first street. Start on Xuân Thủy for cafés, boutiques, bakeries, and restaurants, then decide whether to add a gallery, dinner, or just a slower walk.

**A Softer East-Side Pocket**  
The area feels greener, lower, and more international than the District 1 hotel core. That is the use and the limit: it is good for decompression, not for pretending you have seen every side of Saigon.

**Pick One Stop Before Wandering**  
Choose coffee, a bakery, a booked meal, or a gallery first. Without an anchor, the neighborhood can feel like scattered villas and side streets.

**Still Worth The Ride When You Need Air**  
Thảo Điền is still worth it after a dense central day because it gives you space to eat, browse, and reset. Go on purpose, then call a car back rather than assuming the area will become a walking loop home.

**Verify Named Venues Late**  
Specific cafés, shops, and galleries can change quickly. The durable traveler move is street first, stop second, return plan third.

**Mobile-first entry**

**Start On Xuân Thủy**  
Use Thảo Điền as a slower east-side pocket, not a whole-city substitute. Start on Xuân Thủy for cafés, boutiques, bakeries, or dinner, then choose one stop before wandering. It is still worth the ride when District 1 feels too dense; just plan the car back instead of treating it like a walking loop.

**Useful phrases**

- **"Đường Xuân Thủy ở đâu?"** - Where is Xuân Thủy Street?
- **"Cho tôi xem menu trước."** - Please show me the menu first.
- **"Tôi chỉ xem thôi."** - I am just looking.
- **"Gọi xe về Quận 1 giúp tôi được không?"** - Could you help call a car back to District 1?

**Score:** 27/30. Clearer anchor street and return plan; capped for broad neighborhood evidence, business turnover, administrative naming, and phrase QA.

**Verification flags:** Light verification for current administrative naming, gallery/restaurant status, named-business availability, and native-speaker phrase QA.

### 26. Phá Tam Giang (Tam Giang Lagoon) - Huế - Lagoon / Experience

**Calibration role:** Useful secondary example.

**Pattern taught:** Lagoon route by boat plan. Timing, dock, return, and weather matter more than scenery claims.

**Mobile-first entry**

**Go For Sunset With A Boat Plan**  
Tam Giang Lagoon is better with timing than with a vague "go see water" plan. Choose sunrise or sunset, confirm the dock, boat length, return, and life jackets, then ask what seafood is fresh that day. Weather matters here; rain or wind can turn a beautiful working lagoon into a flat ride.

**Useful phrases**

- **"Đi thuyền lúc hoàng hôn bao nhiêu tiền?"** - How much is a sunset boat ride?
- **"Đi khứ hồi không?"** - Is it round trip?
- **"Có áo phao không?"** - Are there life jackets?
- **"Hải sản hôm nay có gì?"** - What seafood do you have today?

**Verification flags:** Same-week check for weather, dock/boat availability, route length, life jackets, seafood availability, and transport timing. Vietnamese phrase QA still recommended.

### 27. Cầu Tình Yêu (Love Lock Bridge) - Đà Nẵng - Landmark

**Calibration role:** New entry from listing pool.

**Source notes**

- Visit Da Nang places Love Lock Bridge on Trần Hưng Đạo Street by the Hàn River, opposite Dragon Bridge, and says it opened in 2015 with heart-shaped lanterns and lock-covered railings: [Visit Da Nang](https://visitdanang.travel/en/love-lock-bridge-da-nang-sweet-testament-to-promises-6921).
- The same source frames the best use as strolling, photos, and pairing the bridge with Dragon Bridge, the Carp-Dragon statue, APEC Park, and Sơn Trà Night Market.
- Current lock rules, nearby parking, lighting time, and Dragon Bridge show pairing should be checked same week.

**Closest canonical anchor**

- **Dragon Bridge / Cầu Rồng** because Love Bridge is a simple riverfront landmark that needs one use decision: lock/photo pause versus passing viewpoint. It also inherits Dragon Bridge's schedule-pairing risk.

**Expanded version**

**Use It As A Short River Pause**  
Cầu Tình Yêu is not a major stop by itself. Use it as a short Hàn River pause: heart lanterns, love locks, the Carp-Dragon statue nearby, and Dragon Bridge in the same riverfront frame.

**Sentimental, But Simple**  
The bridge is openly romantic and photo-oriented. That can feel a little staged, but it is still worth it when the lights are on and you want an easy evening pause without committing to a full night market or cruise.

**Lock Or Just Look**  
If you want to attach a lock, ask where to buy one and whether there are any current rules. If you do not, walk the railing, take the Dragon Bridge angle, and keep moving.

**Go Around Blue Hour**  
Late afternoon into early evening is the useful window: river light first, heart lanterns after. Weekends can get busy when people are also positioning for Dragon Bridge.

**Pair It, Do Not Center It**  
Pair Love Bridge with Dragon Bridge, Sơn Trà Night Market, APEC Park, or a Hàn River walk. It works best as one small link in an evening route.

**Mobile version**

**Use It As A Short River Pause**  
Cầu Tình Yêu is best as a quick Hàn River stop, not a main event. Walk the lock-covered railing, take the Dragon Bridge angle, and decide whether you actually want to buy a lock. It is sentimental and photo-oriented, but still worth it when the heart lanterns are lit and the riverfront evening already has you nearby.

**Useful phrases**

- **"Cầu Tình Yêu ở đâu?"** - Where is Love Bridge?
- **"Tôi có thể mua ổ khóa ở đâu?"** - Where can I buy a lock?
- **"Cầu Rồng đi hướng nào?"** - Which way is Dragon Bridge?
- **"Mấy giờ đèn bật?"** - What time do the lights turn on?

**Score:** 28/30. Strong landmark decision and nearby-route value; capped for lighting, lock-rule, and show-schedule verification plus native-speaker phrase QA.

**Verification flags:** Same-week verification for lighting, lock rules, parking, nearby access, and Dragon Bridge show schedule. Vietnamese phrase QA required.

### 28. Chợ đêm Helio (Helio Night Market) - Đà Nẵng - Night Market

**Calibration role:** New entry from listing pool.

**Source notes**

- Helio's own site places the night market on 2/9 Street in Hòa Cường Bắc, Hải Châu District, lists daily operating hours, free entry, food, shopping, and music activity: [Helio](https://helio.vn/vi/news/helio-night-market-da-nang-a-super-hot-shopping-and-dining-paradise-at-night.html).
- Local Vietnam describes Helio as more like a relaxed food festival than a traditional market, with rows of food stalls, outdoor seating, live music, and weekend energy: [Local Vietnam](https://localvietnam.com/da-nang/helio-night-market/).
- Hours, stall count, music/event schedule, and food prices should be checked close to publication.

**Closest canonical anchor**

- **Hàn Market / Chợ Cồn** for defining a market's job, with **Sơn Trà Night Market** as a secondary contrast. Helio's job is curated food-court night, not riverfront add-on or working daytime market.

**Expanded version**

**Treat It Like A Food Court Night**  
Helio is easier if you stop expecting a working market. Use it like an organized outdoor food court: pick a few small dishes, find seating, and let the music decide whether you stay.

**Clean, Curated, Less Chaotic**  
The layout is part of the value. Compared with tighter markets, Helio gives you more space, clearer zones, and less pressure from vendors. It may feel less local, but that lower friction can be exactly what a tired traveler needs.

**Order In Rounds**  
Start with one local dish or snack, then add a skewer, drink, or dessert only after you see portion size. If seafood pricing is unclear, ask before agreeing.

**Weekend For Energy, Weekday For Ease**  
Weekends are better for music and crowd energy; weekdays are easier if you want to hear yourself think. Recheck hours and event schedule because the venue is built around current programming.

**Different Job Than Sơn Trà**  
Sơn Trà is the Dragon Bridge add-on. Helio is the more controlled food-and-seating night when you want options without turning dinner into a negotiation.

**Mobile version**

**Treat It Like A Food Court Night**  
Helio works best when you use it as an organized outdoor food court, not a traditional market. Pick one local snack first, find a seat, then add a skewer, drink, or dessert if you are still hungry. It may feel curated, but that can still be worth it when you want food, music, and less stall pressure.

**Useful phrases**

- **"Chợ đêm Helio ở đâu?"** - Where is Helio Night Market?
- **"Món này bao nhiêu tiền?"** - How much is this dish?
- **"Cho tôi một phần nhỏ."** - Give me a small portion.
- **"Có chỗ ngồi không?"** - Is there seating?

**Score:** 28/30. Clear market job and traveler decision; capped for venue programming, current hours, prices, and Vietnamese phrase QA.

**Verification flags:** Same-week verification for operating hours, event/music schedule, stall mix, food prices, and payment norms. Vietnamese phrase QA required.

### 29. Quận 3 (District 3) - Ho Chi Minh City - Neighborhood

**Calibration role:** New entry from listing pool.

**Source notes**

- VietnamOnline places District 3 just west of District 1 and describes it as greener and more tree-lined, with historic colonial buildings and pagodas: [VietnamOnline](https://www.vietnamonline.com/maps/ho-chi-minh-city/district/district-3.html).
- A Ho Chi Minh City district overview lists District 3 anchors such as War Remnants Museum, Turtle Lake, Bàn Cờ Market, Nguyễn Thiện Thuật apartment complex, Vĩnh Nghiêm Pagoda, and Tân Định Church: [Equatorial HCMC district guide PDF](https://hochiminhcity.equatorial.com/wp-content/uploads/sites/69/2025/03/2025-02-25-EHCMC-Press-Release-Explore-The-Vibrancy-Of-HCMC-Districts.pdf).
- Administrative naming and individual venue hours should be checked before publication; traveler-facing "Quận 3" remains the useful search label in the supplied listing pool.

**Closest canonical anchor**

- **Chợ Lớn** because District 3 is a broad area that needs anchors, not wandering. **Japan Town Saigon** also informs the street-first behavior, but District 3 is less of a tight cluster.

**Expanded version**

**Choose One Anchor, Then Walk Nearby**  
Quận 3 is useful when you do not treat it as one attraction. Start with one anchor - War Remnants Museum, Turtle Lake, Tân Định Church, or Bàn Cờ Market - then walk the nearby streets instead of trying to "do District 3."

**Saigon With A Lower Volume**  
The district sits close to District 1 but often feels greener and more lived-in: tree-lined streets, cafés, older buildings, schools, markets, temples, and apartment blocks. It is still busy Saigon, just less hotel-core polished.

**Match The Anchor To Your Mood**  
War Remnants Museum is serious and emotional. Turtle Lake is more of an evening snack-and-sit spot. Bàn Cờ Market is for a local food/market look. Tân Định Church is a quick visual stop if the church is open.

**Still Worth It For A Breathing Route**  
Quận 3 will not hand you one headline moment, but it can still be worth it because it shows central Saigon between landmarks. Use it when District 1 feels too compressed.

**Plan The Return**  
Walk in small sections and call a car when you are done. Do not assume every anchor connects as one smooth route in heat or traffic.

**Mobile version**

**Choose One Anchor, Then Walk Nearby**  
Use Quận 3 by choosing one anchor first: War Remnants Museum, Turtle Lake, Tân Định Church, or Bàn Cờ Market. Then walk the nearby streets instead of trying to "do District 3." It is still busy Saigon, but the greener streets and everyday cafés can give you a useful breathing route beside District 1.

**Useful phrases**

- **"Hồ Con Rùa ở đâu?"** - Where is Turtle Lake?
- **"Chợ Bàn Cờ đi hướng nào?"** - Which way is Bàn Cờ Market?
- **"Tôi chỉ đi dạo thôi."** - I am just walking.
- **"Gọi xe về Quận 1 giúp tôi được không?"** - Could you help call a car back to District 1?

**Score:** 27/30. Strong anchor logic for a broad area; capped for administrative naming, venue hours, and phrase QA.

**Verification flags:** Light verification for current administrative naming, venue hours, church access, market hours, and native-speaker phrase QA.

### 30. Đồi Vọng Cảnh (Vọng Cảnh Hill) - Huế - Viewpoint / Nature

**Calibration role:** New entry from listing pool.

**Source notes**

- Khám phá Huế describes Vọng Cảnh Hill as a 43-meter hill southwest of Huế beside the Perfume River, near Nguyễn Dynasty tombs and Hòn Chén Temple: [Khám phá Huế](https://khamphahue.com.vn/en-us/Discover-Hue/Detail/tid/Vong-Canh-Hill.html/pid/17680/cid/464).
- Local Vietnam describes it as a pine-covered viewpoint about 7 km south/southwest of Huế, best used with nearby tombs, sunset, and a short walk rather than as a major standalone attraction: [Local Vietnam](https://localvietnam.com/hue/vong-canh-hill/).
- Access conditions, weather, and any current site changes should be checked before publication.

**Closest canonical anchor**

- **Lập An Lagoon** for route-stop framing and **Bạch Mã National Park** for condition awareness. Vọng Cảnh is much lighter than Bạch Mã, but timing and pairing still carry the entry.

**Expanded version**

**Use It After A Tomb Stop**  
Vọng Cảnh Hill works best as a short viewpoint after Tự Đức, Đồng Khánh, or another southwest Huế stop. Do not cross town only for a hill unless sunset is the point.

**Pines, River, Low Effort**  
The hill is not high or dramatic. The reward is the quiet mix of pine shade, Perfume River bends, countryside, and the tomb landscape nearby.

**Arrive Before Sunset**  
Give yourself enough light to walk up, find the view, and leave without rushing. If the weather is flat or rainy, the stop becomes a simple breather rather than a photo payoff.

**Still Worth It When The Light Helps**  
At soft light, the small scale becomes the charm: a brief pause over Huế's river-and-tomb landscape instead of another structured monument visit.

**Plan Your Ride Back**  
Have a car, scooter, or ride-hailing plan. The hill is easygoing, but it is not the place to be improvising transport after dark.

**Mobile version**

**Use It After A Tomb Stop**  
Vọng Cảnh Hill is best as a short viewpoint after Tự Đức, Đồng Khánh, or another southwest Huế stop. Go before sunset, check weather, and plan the ride back before it gets dark. The hill is small, but soft light over the Perfume River and tomb landscape can still make it worth the pause.

**Useful phrases**

- **"Đồi Vọng Cảnh ở đâu?"** - Where is Vọng Cảnh Hill?
- **"Đi lên đồi có khó không?"** - Is going up the hill difficult?
- **"Chỗ nào ngắm hoàng hôn đẹp?"** - Where is a good place to watch sunset?
- **"Gọi xe về trung tâm Huế giúp tôi được không?"** - Could you help call a car back to central Huế?

**Score:** 28/30. Clear route-stop use and expectation-setting; capped for weather/access verification and Vietnamese phrase QA.

**Verification flags:** Light verification for current access, weather, path condition, safety after dark, and native-speaker phrase QA.

### 31. Cà phê Đinh (Đinh Café) - Hà Nội - Café

**Calibration role:** New entry from listing pool.

**Source notes**

- Gurutto Vietnam lists Đinh Café at 2F - 13 Đinh Tiên Hoàng, Hoàn Kiếm, describes the second-floor Old Quarter room, Hoàn Kiếm Lake view, simple menu, and owner connection to Giảng's egg-coffee family: [Gurutto Vietnam](https://en.gurutto-vietnam.com/detail/5085/index.html).
- VinWonders lists Dinh Coffee at 13 Đinh Tiên Hoàng and frames it as an egg-coffee stop connected to the daughter of Nguyễn Văn Giảng, with opening hours that should be rechecked: [VinWonders](https://uat2.vinwonders.com/en/wonderpedia/news/egg-coffee-in-hanoi/).
- Current hours, entrance path, seating, and menu should be verified before publication.

**Closest canonical anchor**

- **Cà phê Giảng** because this is another egg-coffee ritual tied to the Giảng family story. **The Note Coffee** also helps because the visit has a physical sequence: find entrance, climb, order, sit.

**Expanded version**

**Find The Upstairs Room First**  
Cà phê Đinh is about the approach as much as the drink. Look for the 13 Đinh Tiên Hoàng entrance, go upstairs, then settle into the small room before ordering.

**Old Quarter, Lake Edge**  
The space is tight, older, and close to Hoàn Kiếm Lake. It is not polished, and that is part of the point: a compact Hanoi coffee room where the city feels close through the balcony and stairs.

**Order Egg Coffee Hot**  
Start with hot cà phê trứng if this is your comparison stop after Giảng. If you want less intensity, ask for less sweet or choose cocoa only if the current menu confirms it.

**Still Worth The Climb**  
It is known to travelers now, but the climb into a small second-floor room over Đinh Tiên Hoàng can still make the cup feel like part of old Hanoi rather than just another egg-coffee checklist.

**Keep It Short Near Hoàn Kiếm**  
Use it before or after a lake walk. If the room is full, do not force a long wait; there are enough nearby coffee stops to keep the day moving.

**Mobile version**

**Find The Upstairs Room First**  
Cà phê Đinh is a small upstairs egg-coffee stop near Hoàn Kiếm Lake. Find the 13 Đinh Tiên Hoàng entrance, climb up, then order hot cà phê trứng before comparing it with Giảng. It is tight and traveler-known, but the second-floor room and lake-edge pause can still make the cup feel like old Hanoi.

**Useful phrases**

- **"Cho tôi một cà phê trứng nóng."** - One hot egg coffee, please.
- **"Lối lên quán ở đâu?"** - Where is the way up to the café?
- **"Tôi có thể ngồi ban công không?"** - Can I sit on the balcony?
- **"Ít ngọt thôi."** - Less sweet, please.

**Score:** 28/30. Strong café ritual and physical arrival cue; capped for current entrance/hours/menu verification and native-speaker phrase QA.

**Verification flags:** Light verification for current hours, entrance path, seating/balcony availability, menu items, and Vietnamese phrase QA.


## V2.2 app implementation guidance for all 31 examples

When a section says **Mobile-first entry**, treat it as the compression source, not the whole UI. For the live app, convert it into the app-detail contract:

1. Intro heading/body.
2. Useful phrase cards.
3. Two to four distinct practical sections.
4. Mentioned Here candidates when the copy naturally names catalog items.
5. Related place candidates only when comparison or route planning is useful.
6. Verification flags kept internal.

Do not copy source notes into the app. Do not render duplicate bodies. Do not render unsupported Vietnamese phrase prose.

If a listing mentions catalog items like **mì Quảng**, **bánh xèo**, **Dragon Bridge**, **Chợ Cồn**, **Đà Nẵng**, **Golden Bridge**, or **Hoàn Kiếm Lake**, propose them as candidates and let catalog QA decide whether to render the cards.

## Batch Pattern Notes

- **Best new headings:** **Use It As A Short River Pause**, **Treat It Like A Food Court Night**, **Choose One Anchor, Then Walk Nearby**, **Use It After A Tomb Stop**, and **Find The Upstairs Room First**.
- **Best revised headings:** **Choose Before The Counter Moves**, **Start With Kem Bơ, Then Decide**, **Name The Filling And Heat**, **Pick One Hội An Dish First**, and **Start On Xuân Thủy**.
- **Hardest categories:** Broad neighborhoods and similar food counters. They require sharper entry behavior than descriptive copy.
- **Sparse evidence:** Chợ Bắc Mỹ An, Thảo Điền, Quận 3, and Vọng Cảnh Hill need restrained claims.
- **Same-week verification:** Dragon Bridge, Da Nang Museum, Sơn Trà Night Market, Tam Giang Lagoon, Love Bridge, and Helio Night Market.
- **Status-blocking uncertainty:** None identified in this batch, assuming pre-publication checks confirm current hours/access.
- **Vietnamese phrase QA:** All revised and new entries need native-speaker QA before publication. Phrases are task-tied and diacritic-checked, but not final native proof.
