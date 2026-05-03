# SpeakLocal Viet Editorial Pilot Approval Review — 13 Ready Rows

This packet shows the deferred ChatGPT editorial rows that the model-support task marked ready to ask Jojo about next. The app has **not** imported this copy yet. Approving rows means a future Content task may import the proposed editorial copy through source files, regenerate resources, run validators, and commit.

## How To Approve

Reply to the orchestrator or Content lane with one of these shapes:

- `Approve all 13 ready rows: EP-001, EP-002, EP-004, EP-005, EP-006, EP-007, EP-008, EP-009, EP-010, EP-011, EP-013, EP-016, EP-020.`
- `Approve only restaurants and streets: EP-001, EP-002, EP-009, EP-010, EP-011, EP-016.`
- `Approve EP-___ with these wording changes: ...`
- `Do not approve yet. Revise these rows first: ...`

The title-preserving rows `EP-012`, `EP-014`, and `EP-015` are intentionally excluded from this packet. `EP-003` remains blocked until the Cao lầu identity decision is made.

## Quick Table

| Patch | Page | Model | Proposed Direction |
| --- | --- | --- | --- |
| EP-001 | Bún chả Hương Liên / Bun Cha Huong Lien | restaurant-live-interaction | A walk-in guide for Bún chả Hương Liên: say the place name, order bún chả, handle drinks, pay, and get a ride back without turning the page into a review. |
| EP-002 | Phở Bát Đàn / Pho Bat Dan | restaurant-live-interaction | A walk-in guide for Phở Bát Đàn: say the place name, order a bowl of phở, ask what to get, pay, and recover if the line or counter feels confusing. |
| EP-004 | Bún bò Huế / Bun bo Hue | dish-order-and-diet | A dish guide for bún bò Huế: hear the dish name, order a bowl, manage spice level, and ask ingredient or diet questions before eating. |
| EP-005 | Bà Nà Hills / Ba Na Hills | place-journey | A journey page for Bà Nà Hills: confirm the ride, handle tickets, find the cable car, ask for photos, buy food/drinks, and find the return pickup. |
| EP-006 | Cầu Rồng / Dragon Bridge | place-navigation-photo | A Da Nang landmark page for Cầu Rồng: say the bridge name, ask where it is, get dropped nearby, ask for a photo, and recover if the pickup point is confusing. |
| EP-007 | Ngũ Hành Sơn / Marble Mountains | place-journey | A practical attraction page for Ngũ Hành Sơn: say the Vietnamese name, buy a ticket, ask about the entrance, handle stairs/caves, and get back to the driver. |
| EP-008 | Bán đảo Sơn Trà / Son Tra Peninsula | place-area-route | A route-area page for Sơn Trà: say the peninsula name, clarify the exact stop, ask about Linh Ứng Pagoda, and arrange the return pickup. |
| EP-009 | Đường Bạch Đằng / Bach Dang Street | street-pronouncer | A Say This Street page for Đường Bạch Đằng: hear the street name, insert it into taxi phrases, confirm the address, and handle pickup/drop-off. |
| EP-010 | Đường Nguyễn Văn Linh / Nguyen Van Linh Street | street-pronouncer | A Say This Street page for Đường Nguyễn Văn Linh: hear the street name, use it with a driver, confirm you are on the right street, and fix a wrong drop-off. |
| EP-011 | Đường Võ Nguyên Giáp / Vo Nguyen Giap Street | street-pronouncer | A Say This Street page for Đường Võ Nguyên Giáp: pronounce the street, insert it into driver phrases, and confirm beach-side pickup/drop-off points. |
| EP-013 | Bà Nà Hills ở đâu? / Where is Ba Na Hills? | direction-question-with-recovery | A practical where-question for when the traveler needs a direction, counter, pickup point, or map confirmation for Bà Nà Hills. |
| EP-016 | Đường Nguyễn Văn Linh gần đây không? / Is Nguyen Van Linh Street near here? | street-question-with-recovery | A street-distance check for Nguyễn Văn Linh Street, designed to help the traveler decide whether to walk, ride, or show the address again. |
| EP-020 | Dạ, chào anh / Respectful hello to an older man | phrase-politeness | A respectful everyday greeting for a man who feels older than you, useful in cafés, taxis, shops, hotel desks, and help moments. |

## Full Proposed Rows

### EP-001 — Bún chả Hương Liên / Bun Cha Huong Lien

- **Group**: Restaurants
- **pageKind**: restaurant
- **placeKind**: restaurant
- **content model**: restaurant-live-interaction
- **page ID**: `viet-phrase-city-hanoi-place-bun-cha-huong-lien`
- **phrase ID**: `city-hanoi-place-bun-cha-huong-lien`

**Why this row exists**

Current copy is serviceable but still reads like a generic named-place template. It says the name helps staff/drivers, but does not create the live restaurant interaction.

**Proposed direction**

A walk-in guide for Bún chả Hương Liên: say the place name, order bún chả, handle drinks, pay, and get a ride back without turning the page into a review.

**Proposed breakdown labels**

Bún chả -> dish name | Hương Liên -> restaurant name | Bún chả Hương Liên -> Bun Cha Huong Lien

**Proposed visible phrase rows**

quick-say: Dạ, cho tôi một phần bún chả. -> One portion of bun cha, please | inside-the-place: Cho tôi trà đá. -> Iced tea, please | inside-the-place: Tính tiền giúp tôi. -> Bill, please | leaving: Gọi giúp tôi taxi được không? -> Can you call me a taxi?

**Proposed section copy**

- **at-glance**: You are probably using this page in one of two moments: showing the restaurant name to a driver or walking in and ordering. Keep the name visible, then move quickly into table, menu, drink, bill, or ride-back phrases.
- **quick-say**: Start with the useful sentence, not the trivia: Dạ, cho tôi một phần bún chả. — One portion of bun cha, please.
- **breakdown**: Bún chả is the dish name. Hương Liên is the restaurant name. Treat the full name as one map/address phrase, not a sentence to translate word by word.
- **place-brief**: Restaurant page: this should feel like “I walked into this place — what do I say?” The page should help with ordering, confirming a table, asking for a recommendation, paying, and leaving.
- **before-you-go**: For a driver or hotel desk, show the map pin first. Say Bún chả Hương Liên once, then point to the address if pronunciation gets shaky.
- **inside-the-place**: Useful next phrases: Dạ, cho tôi một phần bún chả. / Cho tôi trà đá. / Tính tiền giúp tôi. / Tôi trả bằng tiền mặt.
- **good-to-know**: Avoid volatile facts like hours, prices, awards, or wait times unless they are verified. Keep the page durable and action-based.
- **explore-next**: Connect to: ordering bún chả, iced tea, bill please, allergy, cash/card, and taxi return.

---

### EP-002 — Phở Bát Đàn / Pho Bat Dan

- **Group**: Restaurants
- **pageKind**: restaurant
- **placeKind**: restaurant
- **content model**: restaurant-live-interaction
- **page ID**: `viet-phrase-city-hanoi-place-pho-bat-dan`
- **phrase ID**: `city-hanoi-place-pho-bat-dan`

**Why this row exists**

Current restaurant page is durable but not situational enough; it should coach the user through the place experience.

**Proposed direction**

A walk-in guide for Phở Bát Đàn: say the place name, order a bowl of phở, ask what to get, pay, and recover if the line or counter feels confusing.

**Proposed breakdown labels**

Phở -> pho / noodle soup | Bát Đàn -> restaurant name | Phở Bát Đàn -> Pho Bat Dan

**Proposed visible phrase rows**

quick-say: Dạ, cho tôi một tô phở. -> One bowl of pho, please | inside-the-place: Có món nào nổi tiếng không? -> What is popular here? | inside-the-place: Tính tiền giúp tôi. -> Bill, please | leaving: Cho tôi xuống ở đây được không? -> Can you drop me off here?

**Proposed section copy**

- **at-glance**: Use this when Phở Bát Đàn is the exact food stop, not just a search result. The useful moment is usually: show the place name, order a bowl, ask what is available, pay, or get back to your ride.
- **quick-say**: Dạ, cho tôi một tô phở. — One bowl of pho, please.
- **breakdown**: Phở is the dish. Bát Đàn is the restaurant/place name. Do not over-literalize the name; the user needs pronunciation and a useful next sentence.
- **place-brief**: Restaurant page: turn the page into a small interaction flow. First: say/show the name. Next: order. Then: handle drink, bill, cash/card, or ride-back.
- **inside-the-place**: Useful next phrases: Dạ, cho tôi một tô phở. / Có món nào nổi tiếng không? / Tính tiền giúp tôi. / Tôi trả bằng tiền mặt.
- **good-to-know**: If the place is busy, the user needs short phrases more than explanations. Keep sentences short enough to play as audio.
- **explore-next**: Connect to: one bowl of pho, what do you recommend, bill please, cash/card, no beef/no pork dietary pages.

---

### EP-004 — Bún bò Huế / Bun bo Hue

- **Group**: Dish
- **pageKind**: dish
- **placeKind**: dish
- **content model**: dish-order-and-diet
- **page ID**: `viet-phrase-city-hue-place-bun-bo-city`
- **phrase ID**: `city-hue-place-bun-bo-city`

**Why this row exists**

Current copy is better than many rows but still includes place-route language and not enough ordering flow.

**Proposed direction**

A dish guide for bún bò Huế: hear the dish name, order a bowl, manage spice level, and ask ingredient or diet questions before eating.

**Proposed breakdown labels**

Bún bò Huế -> dish name | Bún bò Huế -> Bun bo Hue

**Proposed visible phrase rows**

quick-say: Dạ, cho tôi một tô bún bò Huế. -> One bowl of bun bo Hue, please | spice: Không cay quá nhé. -> Not too spicy, please | ingredients: Món này có gì? -> What is in this dish? | pay: Tính tiền giúp tôi. -> Bill, please

**Proposed section copy**

- **at-glance**: Use this when the user wants the dish, not just a nearby restaurant. The page should move from pronunciation into ordering and spice/ingredient safety.
- **quick-say**: Dạ, cho tôi một tô bún bò Huế. — One bowl of bun bo Hue, please.
- **breakdown**: Bún bò Huế is the dish name. Keep it together in audio; do not break it into misleading literal pieces.
- **how-to-order**: Best first sentence: Dạ, cho tôi một tô bún bò Huế. Add Không cay quá nhé if the user is worried about heat.
- **ingredients-diet**: Surface quick safety phrases: Món này có cay không? / Tôi không ăn thịt bò. / Tôi không ăn thịt lợn. / Tôi bị dị ứng đậu phộng.
- **when-to-use**: Use this at a restaurant, market stall, or when asking a hotel/café where to find the dish.
- **good-to-know**: Keep this practical. The user wants confidence ordering, not a food encyclopedia.
- **explore-next**: Connect to: one bowl please, not too spicy, what is inside, no beef, no pork, bill please.

---

### EP-005 — Bà Nà Hills / Ba Na Hills

- **Group**: Attraction / Place Journey
- **pageKind**: place
- **placeKind**: landmark
- **content model**: place-journey
- **page ID**: `viet-phrase-city-danang-place-ba-na-hills`
- **phrase ID**: `city-danang-place-ba-na-hills`

**Why this row exists**

Current place-name page treats Bà Nà Hills as a static map anchor. User feedback says attractions need multi-stage journey pages.

**Proposed direction**

A journey page for Bà Nà Hills: confirm the ride, handle tickets, find the cable car, ask for photos, buy food/drinks, and find the return pickup.

**Proposed breakdown labels**

Bà Nà Hills -> place name | Bà Nà Hills -> Ba Na Hills

**Proposed visible phrase rows**

ticket: Dạ, cho tôi hai vé lên Bà Nà Hills. -> Two tickets to Ba Na Hills, please | cable-car: Cáp treo ở đâu? -> Where is the cable car? | photo: Bạn chụp giúp tôi được không? -> Can you take a photo for me? | return: Gọi giúp tôi taxi được không? -> Can you call me a taxi?

**Proposed section copy**

- **at-glance**: This is not a single place-name card. Treat Bà Nà Hills as a day-trip flow: ride/drop-off, ticket, cable car, photos, food/drinks, and return pickup.
- **quick-say**: Dạ, cho tôi hai vé lên Bà Nà Hills. — Two tickets to Ba Na Hills, please.
- **breakdown**: Bà Nà Hills is a place name. Learn it as one audio unit, then use it inside ticket, driver, and direction phrases.
- **journey-flow**: 1. Confirm pickup/drop-off. 2. Buy or scan tickets. 3. Find the cable car. 4. Ask for a photo. 5. Buy food/drinks. 6. Find the return ride.
- **key-phrases**: Cáp treo ở đâu? / Bạn chụp giúp tôi được không? / Đi xuống ở đâu? / Gọi giúp tôi taxi được không?
- **when-to-use**: Use this before or during the trip, especially when the user needs the next step rather than a description of the attraction.
- **good-to-know**: Do not add hours, prices, or ticket-policy claims without research. The durable value is the sequence of things the traveler has to say.
- **explore-next**: Connect to: Go to Bà Nà Hills, where is cable car, one/two tickets, take photo, food/drink, return taxi.

---

### EP-006 — Cầu Rồng / Dragon Bridge

- **Group**: Attraction / Navigation + Photo
- **pageKind**: place
- **placeKind**: landmark
- **content model**: place-navigation-photo
- **page ID**: `viet-phrase-city-danang-place-dragon-bridge`
- **phrase ID**: `city-danang-place-dragon-bridge`

**Why this row exists**

Current row is stronger than many, but still should shift toward photo/navigation/pickup scenario.

**Proposed direction**

A Da Nang landmark page for Cầu Rồng: say the bridge name, ask where it is, get dropped nearby, ask for a photo, and recover if the pickup point is confusing.

**Proposed breakdown labels**

Cầu -> bridge | Rồng -> dragon | Cầu Rồng -> Dragon Bridge

**Proposed visible phrase rows**

quick-say: Cầu Rồng -> Dragon Bridge | drop-off: Cho tôi xuống gần Cầu Rồng. -> Let me off near Dragon Bridge | where: Cầu Rồng ở đâu? -> Where is Dragon Bridge? | photo: Bạn chụp giúp tôi được không? -> Can you take a photo for me?

**Proposed section copy**

- **at-glance**: Use this around the river, in a Grab/taxi, or when asking a local to point you toward the bridge. The page should be about navigation, photos, and pickup points.
- **quick-say**: Cầu Rồng — Dragon Bridge. Practice the name, then use it in a full sentence: Cho tôi xuống gần Cầu Rồng.
- **breakdown**: Cầu means bridge. Rồng means dragon. Together: Cầu Rồng, the place name.
- **place-brief**: Landmark page: this should be a small navigation/photo flow, not a generic place description.
- **use-it-with**: Cho tôi xuống gần Cầu Rồng. / Cầu Rồng ở đâu? / Bạn chụp giúp tôi được không? / Tôi đang ở gần Cầu Rồng.
- **when-to-use**: Use it when the bridge is the meetup point, photo stop, walking direction, or pickup/drop-off landmark.
- **good-to-know**: Because the name is short, the full-sentence audio matters: street noise can make single-word place names hard to catch.
- **explore-next**: Connect to: go to Dragon Bridge, stop at Dragon Bridge, photo help, where is pickup area, taxi return.

---

### EP-007 — Ngũ Hành Sơn / Marble Mountains

- **Group**: Attraction / Place Journey
- **pageKind**: place
- **placeKind**: landmark
- **content model**: place-journey
- **page ID**: `viet-phrase-city-danang-place-marble-mountains`
- **phrase ID**: `city-danang-place-marble-mountains`

**Why this row exists**

Current page is a generic place anchor; the app needs a ticket/entrance/return flow.

**Proposed direction**

A practical attraction page for Ngũ Hành Sơn: say the Vietnamese name, buy a ticket, ask about the entrance, handle stairs/caves, and get back to the driver.

**Proposed breakdown labels**

Ngũ Hành Sơn -> Vietnamese place name | Ngũ Hành Sơn -> Marble Mountains

**Proposed visible phrase rows**

ticket: Một vé vào Ngũ Hành Sơn. -> One ticket to Marble Mountains | entrance: Lối vào ở đâu? -> Where is the entrance? | driver: Tài xế chờ ở đâu? -> Where does the driver wait? | return: Gọi giúp tôi taxi được không? -> Can you call me a taxi?

**Proposed section copy**

- **at-glance**: Use this when the user is visiting Marble Mountains and needs the Vietnamese name to work at a ticket counter, with a driver, or while asking for the entrance.
- **quick-say**: Một vé vào Ngũ Hành Sơn. — One ticket to Marble Mountains.
- **breakdown**: Ngũ Hành Sơn is the Vietnamese place name. Do not rely on the English translation with drivers; practice the local name and show the map pin.
- **journey-flow**: 1. Confirm the driver/drop-off. 2. Buy ticket. 3. Ask for entrance or stairs/elevator if needed. 4. Ask where to meet again. 5. Return ride.
- **key-phrases**: Một vé vào Ngũ Hành Sơn. / Lối vào ở đâu? / Tài xế chờ ở đâu? / Gọi giúp tôi taxi được không?
- **when-to-use**: Use this at the ticket counter, hotel desk, taxi/Grab handoff, or when trying to return to the pickup point.
- **good-to-know**: Keep factual details like ticket rules, caves, elevators, and hours behind NEEDS_RESEARCH unless verified.
- **explore-next**: Connect to: one ticket, entrance, how long from here, stop at Marble Mountains, taxi return.

---

### EP-008 — Bán đảo Sơn Trà / Son Tra Peninsula

- **Group**: Area / Route
- **pageKind**: place
- **placeKind**: nature
- **content model**: place-area-route
- **page ID**: `viet-phrase-city-danang-place-son-tra`
- **phrase ID**: `city-danang-place-son-tra`

**Why this row exists**

Current page has a simple place name model; this is an area that needs exact-stop/pickup handling.

**Proposed direction**

A route-area page for Sơn Trà: say the peninsula name, clarify the exact stop, ask about Linh Ứng Pagoda, and arrange the return pickup.

**Proposed breakdown labels**

Bán đảo -> peninsula | Sơn Trà -> local place name | Bán đảo Sơn Trà -> Son Tra Peninsula

**Proposed visible phrase rows**

route: Đi bán đảo Sơn Trà. -> Go to Son Tra Peninsula | specific-stop: Chùa Linh Ứng ở đâu? -> Where is Linh Ung Pagoda? | wait: Anh chờ tôi ở đây được không? -> Can you wait for me here? | return-time: Mấy giờ quay lại? -> What time do we come back?

**Proposed section copy**

- **at-glance**: Sơn Trà is an area, not just one door. The page should help the user clarify which stop they mean and keep the driver/pickup context visible.
- **quick-say**: Đi bán đảo Sơn Trà. — Go to Son Tra Peninsula.
- **breakdown**: Bán đảo means peninsula. Sơn Trà is the local name. Treat the full phrase as a route-area name.
- **place-brief**: Use this for a driver, hotel desk, or tour desk when the user is trying to reach the area or a stop inside it.
- **use-it-with**: Đi bán đảo Sơn Trà. / Chùa Linh Ứng ở đâu? / Anh chờ tôi ở đây được không? / Mấy giờ quay lại?
- **when-to-use**: Use it when the destination is the broader area, then narrow to the exact stop with a map pin.
- **good-to-know**: Because this is an area, the map pin matters. The phrase alone may not identify the exact stop.
- **explore-next**: Connect to: Linh Ứng Pagoda, Dragon Bridge, My Khe Beach, return pickup, wait here.

---

### EP-009 — Đường Bạch Đằng / Bach Dang Street

- **Group**: Street Pronouncer
- **pageKind**: place
- **placeKind**: street
- **content model**: street-pronouncer
- **page ID**: `viet-phrase-city-danang-place-bach-dang-street`
- **phrase ID**: `city-danang-place-bach-dang-street`

**Why this row exists**

Current page already mentions street name, but should be explicitly redesigned as Say This Street / Tell the Driver.

**Proposed direction**

A Say This Street page for Đường Bạch Đằng: hear the street name, insert it into taxi phrases, confirm the address, and handle pickup/drop-off.

**Proposed breakdown labels**

Đường -> street | Bạch Đằng -> street name | Đường Bạch Đằng -> Bach Dang Street

**Proposed visible phrase rows**

street-only: Đường Bạch Đằng -> Bach Dang Street | taxi: Cho tôi đến đường Bạch Đằng. -> Please take me to Bach Dang Street | confirm: Đây có phải đường Bạch Đằng không? -> Is this Bach Dang Street? | drop-off: Cho tôi xuống ở đây được không? -> Can you drop me off here?

**Proposed section copy**

- **at-glance**: This is a street-audio page. The user likely needs to say the street to a driver, hotel desk, or local while showing an address.
- **quick-say**: Đường Bạch Đằng. Play the street name by itself, then play the full taxi sentence.
- **breakdown**: Đường means street. Bạch Đằng is the street name. Keep Bạch Đằng together in audio.
- **show-driver**: Cho tôi đến đường Bạch Đằng. — Please take me to Bach Dang Street.
- **confirm**: Đây có phải đường Bạch Đằng không? — Is this Bach Dang Street?
- **drop-off**: Cho tôi xuống ở đây được không? — Can you drop me off here?
- **good-to-know**: Street names should always have two audio versions: street-only and full sentence.
- **explore-next**: Connect to: go by Bach Dang Street, stop at Bach Dang Street, near here, wrong place, show address.

---

### EP-010 — Đường Nguyễn Văn Linh / Nguyen Van Linh Street

- **Group**: Street Pronouncer
- **pageKind**: place
- **placeKind**: street
- **content model**: street-pronouncer
- **page ID**: `viet-phrase-city-danang-place-nguyen-van-linh-street`
- **phrase ID**: `city-danang-place-nguyen-van-linh-street`

**Why this row exists**

Current row has a normal place template; street names deserve their own audio-first feature.

**Proposed direction**

A Say This Street page for Đường Nguyễn Văn Linh: hear the street name, use it with a driver, confirm you are on the right street, and fix a wrong drop-off.

**Proposed breakdown labels**

Đường -> street | Nguyễn Văn Linh -> street name | Đường Nguyễn Văn Linh -> Nguyen Van Linh Street

**Proposed visible phrase rows**

street-only: Đường Nguyễn Văn Linh -> Nguyen Van Linh Street | taxi: Cho tôi đến đường Nguyễn Văn Linh. -> Please take me to Nguyen Van Linh Street | confirm: Đây có phải đường Nguyễn Văn Linh không? -> Is this Nguyen Van Linh Street? | wrong-place: Hình như không đúng chỗ. -> I think this is not the right place

**Proposed section copy**

- **at-glance**: This page solves a real traveler problem: the street name is hard to pronounce from spelling. Make the audio the main value.
- **quick-say**: Đường Nguyễn Văn Linh. Practice street-only audio first, then the taxi sentence.
- **breakdown**: Đường means street. Nguyễn Văn Linh is the street name. Do not split the personal name into fake meanings for travelers.
- **show-driver**: Cho tôi đến đường Nguyễn Văn Linh. — Please take me to Nguyen Van Linh Street.
- **confirm**: Đây có phải đường Nguyễn Văn Linh không? — Is this Nguyen Van Linh Street?
- **wrong-place**: Hình như không đúng chỗ. — I think this is not the right place.
- **good-to-know**: For long Vietnamese street names, full-sentence audio is more useful than dictionary-style spelling.
- **explore-next**: Connect to: go to Nguyen Van Linh Street, stop here, near here, wrong place, show address.

---

### EP-011 — Đường Võ Nguyên Giáp / Vo Nguyen Giap Street

- **Group**: Street Pronouncer
- **pageKind**: place
- **placeKind**: street
- **content model**: street-pronouncer
- **page ID**: `viet-phrase-city-danang-place-vo-nguyen-giap-street`
- **phrase ID**: `city-danang-place-vo-nguyen-giap-street`

**Why this row exists**

Current page has street language, but the UX should explicitly become street pronouncer + driver sentence.

**Proposed direction**

A Say This Street page for Đường Võ Nguyên Giáp: pronounce the street, insert it into driver phrases, and confirm beach-side pickup/drop-off points.

**Proposed breakdown labels**

Đường -> street | Võ Nguyên Giáp -> street name | Đường Võ Nguyên Giáp -> Vo Nguyen Giap Street

**Proposed visible phrase rows**

street-only: Đường Võ Nguyên Giáp -> Vo Nguyen Giap Street | taxi: Cho tôi đến đường Võ Nguyên Giáp. -> Please take me to Vo Nguyen Giap Street | confirm: Đây có phải đường Võ Nguyên Giáp không? -> Is this Vo Nguyen Giap Street? | pickup: Tôi đang ở đường Võ Nguyên Giáp. -> I’m on Vo Nguyen Giap Street

**Proposed section copy**

- **at-glance**: Use this when an address, hotel, beach stop, or Grab pickup mentions Đường Võ Nguyên Giáp and the traveler needs to say it out loud.
- **quick-say**: Đường Võ Nguyên Giáp. Play street-only audio, then the full sentence.
- **breakdown**: Đường means street. Võ Nguyên Giáp is the street name. Keep the name as a single audio unit.
- **show-driver**: Cho tôi đến đường Võ Nguyên Giáp. — Please take me to Vo Nguyen Giap Street.
- **confirm**: Đây có phải đường Võ Nguyên Giáp không? — Is this Vo Nguyen Giap Street?
- **pickup**: Tôi đang ở đường Võ Nguyên Giáp. — I’m on Vo Nguyen Giap Street.
- **good-to-know**: Street pages should support Show Driver mode: large Vietnamese text, English below, big play button.
- **explore-next**: Connect to: My Khe Beach, stop here, wrong location, show address, taxi return.

---

### EP-013 — Bà Nà Hills ở đâu? / Where is Ba Na Hills?

- **Group**: Direction Question + Recovery
- **pageKind**: phrase
- **placeKind**: landmark
- **content model**: direction-question-with-recovery
- **page ID**: `viet-phrase-city-danang-where-ba-na-hills`
- **phrase ID**: `city-danang-where-ba-na-hills`

**Why this row exists**

Current where-question page is okay, but should include 'what they might say back' and recovery.

**Proposed direction**

A practical where-question for when the traveler needs a direction, counter, pickup point, or map confirmation for Bà Nà Hills.

**Proposed breakdown labels**

Bà Nà Hills -> place name | ở đâu? -> where? | Bà Nà Hills ở đâu? -> Where is Ba Na Hills?

**Proposed visible phrase rows**

quick-say: Bà Nà Hills ở đâu? -> Where is Ba Na Hills? | follow-up: Cáp treo ở đâu? -> Where is the cable car? | repair: Làm ơn nói lại. -> Please say that again

**Proposed section copy**

- **at-glance**: Use this when you need someone to point you toward the ticket area, pickup point, or next step connected to Bà Nà Hills.
- **quick-say**: Bà Nà Hills ở đâu? — Where is Ba Na Hills?
- **breakdown**: Bà Nà Hills -> place name | ở đâu? -> where?
- **what-happens-next**: The answer may be a point, a counter name, a direction, or a gesture. Follow the gesture first, then ask again if needed.
- **recovery**: If the answer is too fast, use: Làm ơn nói lại. — Please say that again.
- **when-to-use**: Use at the hotel desk, ticket area, station, or pickup zone when the exact next step is unclear.
- **good-to-know**: Where-questions should include likely replies and recovery phrases, not just the sentence.
- **explore-next**: Connect to: cable car, two tickets, return taxi, please say that again.

---

### EP-016 — Đường Nguyễn Văn Linh gần đây không? / Is Nguyen Van Linh Street near here?

- **Group**: Street Question + Recovery
- **pageKind**: phrase
- **placeKind**: street
- **content model**: street-question-with-recovery
- **page ID**: `viet-phrase-city-danang-near-nguyen-van-linh-street`
- **phrase ID**: `city-danang-near-nguyen-van-linh-street`

**Why this row exists**

Current copy has a decent distance-check note, but should be tied to Street Pronouncer and likely replies.

**Proposed direction**

A street-distance check for Nguyễn Văn Linh Street, designed to help the traveler decide whether to walk, ride, or show the address again.

**Proposed breakdown labels**

Đường Nguyễn Văn Linh -> Nguyen Van Linh Street | gần đây không? -> near here?

**Proposed visible phrase rows**

quick-say: Đường Nguyễn Văn Linh gần đây không? -> Is Nguyen Van Linh Street near here? | show: Anh/chị chỉ giúp tôi được không? -> Can you show me? | driver: Cho tôi đến đường Nguyễn Văn Linh. -> Please take me to Nguyen Van Linh Street

**Proposed section copy**

- **at-glance**: Use this when the traveler sees the street name on a map or address and wants a quick local read: is it nearby or not?
- **quick-say**: Đường Nguyễn Văn Linh gần đây không? — Is Nguyen Van Linh Street near here?
- **breakdown**: Đường Nguyễn Văn Linh -> Nguyen Van Linh Street | gần đây không? -> near here?
- **what-happens-next**: Likely replies are a point, yes/no, a number of minutes, or a gesture. The user should show the map while asking.
- **recovery**: If the answer is unclear, use: Anh/chị chỉ giúp tôi được không? — Can you show me?
- **when-to-use**: Use before committing to a walk, ride, or detour.
- **good-to-know**: Street-name pages should include likely nonverbal replies because locals may answer by pointing.
- **explore-next**: Connect to: street pronouncer, show driver, stop here, wrong place.

---

### EP-020 — Dạ, chào anh / Respectful hello to an older man

- **Group**: Politeness / Greeting
- **pageKind**: phrase
- **placeKind**: 
- **content model**: phrase-politeness
- **page ID**: `viet-phrase-acknowledge-da-chao-anh`
- **phrase ID**: `acknowledge-da-chao-anh`

**Why this row exists**

Current page is okay but has boilerplate at-glance and when-to-use. Rewrite with concrete traveler contexts.

**Proposed direction**

A respectful everyday greeting for a man who feels older than you, useful in cafés, taxis, shops, hotel desks, and help moments.

**Proposed breakdown labels**

Dạ -> polite opener | chào -> hello / greet | anh -> older brother / older man address | Dạ, chào anh -> Respectful hello to an older man

**Proposed visible phrase rows**

quick-say: Dạ, chào anh -> Respectful hello to an older man | simple: Chào anh -> Hello to an older man | follow-up: Anh nói tiếng Anh không? -> Do you speak English?

**Proposed section copy**

- **at-glance**: Use Dạ, chào anh when greeting a man who seems older than you but not elderly. This is often more natural than a generic Xin chào.
- **quick-say**: Dạ, chào anh. — Respectful hello to an older man.
- **breakdown**: Dạ -> polite opener | chào -> hello/greet | anh -> older brother / older man address
- **relationship-words**: Vietnamese greetings often choose a relationship word. Anh is a safe everyday choice for a slightly older man.
- **relationship-swaps**: Dạ, chào chị for an older woman. Dạ, chào chú for an uncle-age man. Dạ, chào ông for an elderly man.
- **when-to-use**: Use at the start of a taxi, shop, café, hotel, or help interaction when you want to be warm and respectful.
- **good-to-know**: If age is unclear, keep your tone warm and use Dạ. The app should not punish uncertainty here.
- **explore-next**: Connect to: Chào anh, Dạ, chào chị, Cảm ơn, Do you speak English?

---

