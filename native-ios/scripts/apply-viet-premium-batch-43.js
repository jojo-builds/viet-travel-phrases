#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-emergency-premium-tourist-police",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/emergency-premium-tourist-police.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/emergency-tourist-police.json",
    summary: "For asking for tourist-police help when a passport, scam, threat, or official report is involved.",
    bodies: {
      "at-glance": "Say it at a hotel desk, police counter, station, or staffed place where someone can help you reach the right office.",
      "quick-say": "Keep your passport copy, location, report, photo, receipt, or helper contact visible. The phrase is short so the evidence can carry the rest.",
      breakdown: "Tôi cần means I need; cảnh sát du lịch means the tourist police.",
      "when-to-use": "Good for lost documents, scams, harassment, theft reports, or situations where ordinary staff cannot solve the problem.",
      "good-to-know": "If there is immediate danger, use police, emergency, or help-now phrases first and move toward a public staffed area.",
      "explore-next": "Unsafe, emergency, help, hospital, and passport cards cover more urgent safety paths.",
      "natural-variants": "Police, ambulance, and passport cards help when the situation needs a different official response."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "cảnh sát du lịch.", english: "the tourist police.", keepTogetherReason: "tourist-police phrase" }
    ],
    value: "turns a bare tourist-police title into a calm official-help request"
  },
  {
    id: "viet-phrase-money-premium-what-fee",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/money-premium-what-fee.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/money-what-fee.json",
    summary: "For asking what an added fee covers before accepting a bill, ticket, ATM charge, or service price.",
    bodies: {
      "at-glance": "Point to the line item, receipt, screen, or calculator number before asking.",
      "quick-say": "Keep the bill visible. The useful answer is the reason for the fee, not a faster repeat of the total.",
      breakdown: "Khoản phí này means this fee; dùng để làm gì asks what it is for.",
      "when-to-use": "Good at hotels, ticket counters, tours, card readers, ATMs, shops, and service desks when an extra charge appears.",
      "good-to-know": "If the answer is still unclear, ask them to write the fee name or show the policy before you pay.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover the price conversation after the fee is explained.",
      "natural-variants": "How-much and per-kilo cards help when the problem is the base price rather than an added fee."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Khoản phí này", english: "this fee", keepTogetherReason: "this-fee phrase" },
      { id: "chunk-2", vietnamese: "dùng để làm gì?", english: "what is it for?", keepTogetherReason: "what-for phrase" }
    ],
    value: "turns a generic money page into an added-fee clarity page"
  },
  {
    id: "viet-phrase-v500-airp-bord-arri-my-bag-is-damaged",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-my-bag-is-damaged.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-my-bag-is-damaged.json",
    summary: "For reporting damaged luggage at baggage claim before leaving the arrivals area.",
    bodies: {
      "at-glance": "Say it while the bag, tag, flight number, and damage are still easy for staff to inspect.",
      "quick-say": "Show the tear, wheel, handle, lock, or photo first. Then ask where to make the report or take the next step.",
      breakdown: "Túi của tôi means my bag; bị hỏng means is damaged.",
      "when-to-use": "Good at baggage desks, airline counters, airport service rooms, and hotel desks if the damage appears after pickup.",
      "good-to-know": "Take a photo before leaving the airport. A report is easier to make while the bag tag and flight are still visible.",
      "explore-next": "Pickup-area, driver-meet, missing-bag, domestic-terminal, and visa cards cover nearby airport follow-ups.",
      "natural-variants": "Immigration, baggage-claim, and SIM-card cards help if you are still inside arrivals."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Túi của tôi", english: "my bag", keepTogetherReason: "my-bag phrase" },
      { id: "chunk-2", vietnamese: "bị hỏng", english: "is damaged", keepTogetherReason: "is-damaged phrase" }
    ],
    value: "turns a generic problem page into an airport baggage-damage report"
  },
  {
    id: "viet-phrase-v500-dire-navi-my-map-app-is-not-working",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-my-map-app-is-not-working.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-my-map-app-is-not-working.json",
    summary: "For asking for directions when your map app will not load, locate you, or route correctly.",
    bodies: {
      "at-glance": "Show the frozen map, address, hotel name, ride screen, or nearby landmark while you say it.",
      "quick-say": "Keep the phone open and let the other person point, type, or show a simpler route.",
      breakdown: "Ứng dụng bản đồ của tôi means my map app; không hoạt động means is not working.",
      "when-to-use": "Good when data drops, GPS is wrong, the route will not load, or the app sends you to the wrong side of a street.",
      "good-to-know": "Once they understand the app problem, switch to where, near-here, turn, or walking-time phrases.",
      "explore-next": "Turn-left, right, straight, nearby, and walking-time cards cover the route after the map fails.",
      "natural-variants": "Excuse-me, how-to-get-there, and near-here cards help when someone can guide you directly."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Ứng dụng bản đồ của tôi", english: "my map app", keepTogetherReason: "my-map-app phrase" },
      { id: "chunk-2", vietnamese: "không hoạt động", english: "is not working", keepTogetherReason: "not-working phrase" }
    ],
    value: "turns a generic problem statement into a practical directions-recovery page"
  },
  {
    id: "viet-phrase-v500-emer-safe-please-stay-near-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v500-emer-safe-please-stay-near-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v500-emer-safe-please-stay-near-me.json",
    summary: "For asking a trusted person, staffer, or helper to stay close while you feel unsafe or unwell.",
    bodies: {
      "at-glance": "Say it to someone already helping you, then move toward light, staff, a desk, or a public place.",
      "quick-say": "Keep it simple and direct. Point to where you want to stand or walk if the person does not understand.",
      breakdown: "Xin hãy means please; ở gần tôi means stay near me.",
      "when-to-use": "Good at hotels, stations, clinics, police desks, late-night pickups, or crowded moments where you do not want to be alone.",
      "good-to-know": "If the person near you is the problem, use stop-following, police, or help phrases instead.",
      "explore-next": "Unsafe, emergency, help, hospital, and passport cards cover more urgent safety paths.",
      "natural-variants": "Police, ambulance, and passport cards help if the situation needs outside help."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy", english: "please", keepTogetherReason: "polite request frame" },
      { id: "chunk-2", vietnamese: "ở gần tôi", english: "stay near me", keepTogetherReason: "stay-near-me phrase" }
    ],
    value: "turns a scaffolded safety page into a concrete stay-close request"
  },
  {
    id: "viet-phrase-v500-emer-safe-stop-following-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v500-emer-safe-stop-following-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v500-emer-safe-stop-following-me.json",
    summary: "For telling someone to stop following you while you move toward help or a public staffed place.",
    bodies: {
      "at-glance": "Say it clearly, create distance, and head toward staff, light, cameras, a desk, or other people.",
      "quick-say": "Do not explain first. Say the sentence, then show or point to the person if a guard, receptionist, or officer can help.",
      breakdown: "Đừng means do not; đi theo tôi nữa means follow me anymore.",
      "when-to-use": "Good when someone is physically trailing you and you need the behavior to stop right now.",
      "good-to-know": "If it continues, switch to police, help, unsafe, or emergency phrases and keep moving toward support.",
      "explore-next": "Unsafe, emergency, help, hospital, and passport cards cover the next safety step.",
      "natural-variants": "Police, ambulance, and passport cards help when the situation becomes official or urgent."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đừng", english: "do not", keepTogetherReason: "negative command" },
      { id: "chunk-2", vietnamese: "đi theo tôi nữa", english: "follow me anymore", keepTogetherReason: "stop-following phrase" }
    ],
    value: "turns a safety phrase into a direct boundary-setting page without extra drama"
  },
  {
    id: "viet-phrase-v500-heal-phar-how-do-i-take-this",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-how-do-i-take-this.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v500-heal-phar-how-do-i-take-this.json",
    summary: "For asking how to take medicine before leaving a pharmacy, clinic, or hotel desk.",
    bodies: {
      "at-glance": "Show the box, bottle, blister pack, prescription, or receipt while you ask.",
      "quick-say": "Ask for dose, timing, and food warnings before the package goes back in the bag.",
      breakdown: "Tôi uống means I take or drink; thuốc này means this medicine; như thế nào asks how.",
      "when-to-use": "Good when instructions are spoken too fast, printed in Vietnamese, or unclear after a pharmacy handoff.",
      "good-to-know": "Ask them to write the dose if the answer includes numbers, times, meals, or warnings.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea cards cover symptom context if they ask why you need it.",
      "natural-variants": "Doctor and pharmacy-location cards help if the medicine needs a different kind of care."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi uống", english: "I take / drink", keepTogetherReason: "take-medicine verb" },
      { id: "chunk-2", vietnamese: "thuốc này", english: "this medicine", keepTogetherReason: "this-medicine phrase" },
      { id: "chunk-3", vietnamese: "như thế nào?", english: "how?", keepTogetherReason: "how ending" }
    ],
    value: "turns a title-repeat medicine page into a dosage-instruction request"
  },
  {
    id: "viet-phrase-v500-hote-acco-the-room-is-too-noisy",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-the-room-is-too-noisy.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/hotel-too-noisy.json",
    summary: "For telling the front desk the noise is bad enough that you cannot sleep.",
    bodies: {
      "at-glance": "Say it with your room number, booking, and the noise source in mind: street, karaoke, hallway, construction, or neighbors.",
      "quick-say": "Keep the request calm. The useful follow-up is a quieter room, earplugs, a check by staff, or a clear time when noise stops.",
      breakdown: "Tôi không thể ngủ được means I cannot sleep; vì quá ồn ào means because it is too noisy.",
      "when-to-use": "Good at hotels, hostels, guesthouses, and homestays when the room noise is not just a small annoyance.",
      "good-to-know": "A short recording or exact time can help staff understand the problem without a long complaint.",
      "explore-next": "Check-in, checkout-time, quiet-room, checkout, and luggage cards cover the hotel follow-up path.",
      "natural-variants": "Reservation, check-in, and polite-check-in cards stay nearby if the room issue becomes a desk conversation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi không thể ngủ được", english: "I cannot sleep", keepTogetherReason: "cannot-sleep phrase" },
      { id: "chunk-2", vietnamese: "vì quá ồn ào", english: "because it is too noisy", keepTogetherReason: "too-noisy reason" }
    ],
    value: "turns a wordy hotel complaint page into a clear front-desk sleep problem"
  },
  {
    id: "viet-phrase-v500-hote-acco-the-safe-is-not-opening",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-the-safe-is-not-opening.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v500-hote-acco-the-safe-is-not-opening.json",
    summary: "For asking hotel staff to help with a room safe that will not open.",
    bodies: {
      "at-glance": "Say it with the room number, key card, and safe in mind; do not leave valuables unattended if the safe is stuck.",
      "quick-say": "Keep the room number visible and ask the front desk for help. Staff may need to send maintenance or reset the safe.",
      breakdown: "Két sắt means safe; không mở được means cannot be opened.",
      "when-to-use": "Good when the keypad fails, the code is forgotten, batteries die, or the door will not unlock.",
      "good-to-know": "If passports or cards are inside, say that before staff decide how urgent the help is.",
      "explore-next": "Checkout-time, quiet-room, checkout, room-key, and luggage cards cover nearby hotel desk needs.",
      "natural-variants": "Reservation, check-in, and polite-check-in cards help if this happens during arrival."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "két sắt", english: "safe", keepTogetherReason: "safe noun" },
      { id: "chunk-2", vietnamese: "không mở được", english: "cannot be opened", keepTogetherReason: "not-opening phrase" }
    ],
    value: "turns a scaffolded hotel page into a room-safe maintenance request"
  },
  {
    id: "viet-phrase-v500-loca-serv-ever-task-one-item-is-missing",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-one-item-is-missing.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-one-item-is-missing.json",
    summary: "For telling a shop, laundry, delivery, hotel, or counter that one item is missing.",
    bodies: {
      "at-glance": "Say it while the receipt, bag, order, laundry bundle, or delivery photo is still visible.",
      "quick-say": "Point to the list or empty spot first. Then let staff check the order, shelf, bag, or back room.",
      breakdown: "Một mặt hàng means one item; bị thiếu means is missing.",
      "when-to-use": "Good for shopping bags, laundry returns, delivery orders, hotel amenities, printed documents, and small counter services.",
      "good-to-know": "If you know which item is missing, show the photo or name before repeating the sentence.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and printing cards cover the errand-counter follow-up.",
      "natural-variants": "Water, bag, and tissues cards stay useful at the same small shop or hotel desk."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Một mặt hàng", english: "one item", keepTogetherReason: "one-item phrase" },
      { id: "chunk-2", vietnamese: "bị thiếu", english: "is missing", keepTogetherReason: "is-missing phrase" }
    ],
    value: "turns a generic missing-item statement into a counter-service recovery page"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-can-i-try-another-card",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-can-i-try-another-card.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-can-i-try-another-card.json",
    summary: "For asking to use a different card after one payment attempt fails or is declined.",
    bodies: {
      "at-glance": "Ask before the cashier cancels the transaction, retries the same card, or switches you to cash.",
      "quick-say": "Keep the terminal, failed receipt, and new card visible. A nod or reset may be all the cashier needs.",
      breakdown: "Tôi có thể thử asks can I try; thẻ khác means another card; được không asks is that possible.",
      "when-to-use": "Good at card readers, ticket counters, hotels, restaurants, ATMs, and shops when the first card does not work.",
      "good-to-know": "If the first card may have charged, check the terminal or app before tapping a second card.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover nearby payment and price follow-ups.",
      "natural-variants": "How-much and per-kilo cards help if the payment problem starts with price confusion."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể thử", english: "can I try", keepTogetherReason: "can-I-try phrase" },
      { id: "chunk-2", vietnamese: "thẻ khác", english: "another card", keepTogetherReason: "another-card phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite possibility ending" }
    ],
    value: "turns a yes/no payment page into a practical card-retry request"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-the-atm-did-not-give-me-cash",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-the-atm-did-not-give-me-cash.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-the-atm-did-not-give-me-cash.json",
    summary: "For reporting an ATM problem when the withdrawal completed but no cash came out.",
    bodies: {
      "at-glance": "Say it with the ATM screen, receipt, bank app, location, time, and card visible if possible.",
      "quick-say": "Do not walk away without a record. Ask nearby bank, shop, hotel, or security staff what to do next.",
      breakdown: "ATM refers to the cash machine; không đưa means did not give; tiền mặt means cash; cho tôi means to me.",
      "when-to-use": "Good when the ATM keeps the transaction, shows success, prints a receipt, or debits your account without dispensing cash.",
      "good-to-know": "Avoid trying multiple withdrawals until you know whether the first one charged. Photograph the machine location if safe.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover ordinary money follow-ups after the ATM issue is handled.",
      "natural-variants": "How-much and per-kilo cards help when the next problem is payment at a counter."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "ATM", english: "cash machine", keepTogetherReason: "ATM noun" },
      { id: "chunk-2", vietnamese: "không đưa", english: "did not give", keepTogetherReason: "did-not-give phrase" },
      { id: "chunk-3", vietnamese: "tiền mặt", english: "cash", keepTogetherReason: "cash phrase" },
      { id: "chunk-4", vietnamese: "cho tôi", english: "to me", keepTogetherReason: "to-me phrase" }
    ],
    value: "turns a generic ATM page into a cash-not-dispensed incident page"
  }
];

console.log(JSON.stringify(applyRepairs(43, repairs), null, 2));
