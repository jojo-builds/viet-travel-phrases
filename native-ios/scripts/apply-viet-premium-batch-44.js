#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v500-prob-help-i-need-to-speak-with-the-manager",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-i-need-to-speak-with-the-manager.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-i-need-to-speak-with-the-manager.json",
    summary: "For asking for the manager when a counter, hotel, ride, shop, or service problem needs escalation.",
    bodies: {
      "at-glance": "Use it after the first staffer cannot resolve the problem, not as the first move for every small issue.",
      "quick-say": "Say the line once, then show the receipt, room number, ride detail, photo, or message that explains why.",
      breakdown: "Tôi cần means I need; nói chuyện với means speak with; người quản lý means the manager.",
      "when-to-use": "Good for double charges, broken room issues, missing items, service disputes, or safety concerns that need someone with authority.",
      "good-to-know": "Keep the tone calm. The phrase asks for the right person, not a fight.",
      "explore-next": "Need-help, call-hotel, manager, double-charge, and report cards cover the practical help path.",
      "natural-variants": "Lost and left-something-behind cards cover lower-pressure help before escalation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "nói chuyện với", english: "speak with", keepTogetherReason: "speak-with phrase" },
      { id: "chunk-3", vietnamese: "người quản lý", english: "the manager", keepTogetherReason: "manager phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-problems-1",
        "viet-phrase-problems-4"
      ]
    },
    cardParityLedger: {
      "natural-variants": "aligns source to the rendered lower-pressure lost/left-behind cards; manager escalation remains covered in Explore Next"
    },
    value: "turns a manager title into a calm escalation page with card parity"
  },
  {
    id: "viet-phrase-v500-prob-help-please-stay-with-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-please-stay-with-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-please-stay-with-me.json",
    summary: "For asking a trusted person or staffer not to leave while you sort out a problem.",
    bodies: {
      "at-glance": "This is for a moment when steady help beside you matters more than a phone call or quick direction.",
      "quick-say": "Say it to someone already helping you, then show the receipt, address, room number, ride screen, or person involved.",
      breakdown: "Xin hãy means please; ở lại với tôi means stay with me.",
      "when-to-use": "Good at hotels, clinics, stations, shops, and street help moments when you need another person to stay present.",
      "good-to-know": "If the situation is unsafe, move toward staff, light, or a public desk while asking them to stay.",
      "explore-next": "Need-help, call-hotel, manager, double-charge, and report cards cover the practical help path.",
      "natural-variants": "Lost and left-something-behind cards cover nearby help situations."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy", english: "please", keepTogetherReason: "polite request frame" },
      { id: "chunk-2", vietnamese: "ở lại với tôi", english: "stay with me", keepTogetherReason: "stay-with-me phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-problems-1",
        "viet-phrase-problems-4"
      ]
    },
    cardParityLedger: {
      "natural-variants": "aligns source to the rendered lower-pressure lost/left-behind cards; urgent help remains covered in Explore Next"
    },
    value: "turns a generic help page into a clear stay-present request with card parity"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-i-made-a-mistake-on-the-form",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-i-made-a-mistake-on-the-form.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-i-made-a-mistake-on-the-form.json",
    summary: "For telling airport, immigration, airline, or hotel staff that a form needs correction.",
    bodies: {
      "at-glance": "Say it before handing the form over for final processing, especially if the passport or booking detail is wrong.",
      "quick-say": "Point to the exact field. Staff need to know the mistake, not hear a long apology.",
      breakdown: "Tôi đã mắc lỗi means I made a mistake; trong biểu mẫu means on the form.",
      "when-to-use": "Good at immigration, airline desks, baggage reports, hotel check-in, visa forms, and tour paperwork.",
      "good-to-know": "Ask before crossing out or rewriting a form; some counters need a clean copy.",
      "explore-next": "Pickup-area, driver-meet, missing-bag, domestic-terminal, and visa cards cover nearby airport follow-ups.",
      "natural-variants": "Immigration, baggage-claim, and SIM-card cards help if the form issue sends you back into arrivals."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đã mắc lỗi", english: "I made a mistake", keepTogetherReason: "made-a-mistake phrase" },
      { id: "chunk-2", vietnamese: "trong biểu mẫu", english: "on the form", keepTogetherReason: "on-the-form phrase" }
    ],
    value: "turns a title-repeat form page into a field-correction request"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-i-think-i-went-to-the-wrong-terminal",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-i-think-i-went-to-the-wrong-terminal.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-i-think-i-went-to-the-wrong-terminal.json",
    summary: "For checking a terminal mistake before you lose time walking, queueing, or dragging luggage farther.",
    bodies: {
      "at-glance": "Ask with the flight number, airline, ticket, or pickup screen visible.",
      "quick-say": "Show the flight detail first. Staff can point you to a shuttle, walkway, counter, or correct terminal.",
      breakdown: "Tôi nghĩ means I think; tôi đã đến nhầm means I went to the wrong place; nhà ga means terminal.",
      "when-to-use": "Good after a driver drop-off, domestic/international transfer, wrong entrance, or confusing airport sign.",
      "good-to-know": "Confirm before security or check-in. Turning around later can cost much more time.",
      "explore-next": "Pickup-area, driver-meet, missing-bag, domestic-terminal, and visa cards cover nearby airport moves.",
      "natural-variants": "Immigration, baggage-claim, and SIM-card cards stay useful if you need to reorient inside the terminal."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi nghĩ", english: "I think", keepTogetherReason: "I-think phrase" },
      { id: "chunk-2", vietnamese: "tôi đã đến nhầm", english: "I went to the wrong place", keepTogetherReason: "went-to-wrong-place phrase" },
      { id: "chunk-3", vietnamese: "nhà ga", english: "terminal", keepTogetherReason: "terminal phrase" }
    ],
    value: "turns a generic terminal page into a time-sensitive airport correction"
  },
  {
    id: "viet-phrase-v900-emer-safe-please-help-me-get-out-of-here",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v900-emer-safe-please-help-me-get-out-of-here.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v900-emer-safe-please-help-me-get-out-of-here.json",
    summary: "For asking someone to help you leave an unsafe, confusing, or overwhelming place immediately.",
    bodies: {
      "at-glance": "Say it to staff, a driver, a guard, hotel help, or another trusted person while moving toward a safer exit.",
      "quick-say": "Do not explain everything first. Name the need, point toward the door, street, desk, or safer area, and move.",
      breakdown: "Xin hãy giúp means please help; tôi ra khỏi đây means me get out of here.",
      "when-to-use": "Good when a bar, room, vehicle, crowd, alley, or building no longer feels safe or manageable.",
      "good-to-know": "If someone is blocking you or following you, switch to police, help, or emergency phrases as soon as you can.",
      "explore-next": "Unsafe, emergency, help, hospital, and passport cards cover the next safety step.",
      "natural-variants": "Police, ambulance, and passport cards help when the situation needs official support."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy giúp", english: "please help", keepTogetherReason: "please-help phrase" },
      { id: "chunk-2", vietnamese: "tôi ra khỏi đây", english: "me get out of here", keepTogetherReason: "get-out-of-here phrase" }
    ],
    value: "turns a scaffolded emergency page into a direct exit-help request"
  },
  {
    id: "viet-phrase-v900-emer-safe-please-send-my-location-to-this-person",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v900-emer-safe-please-send-my-location-to-this-person.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v900-emer-safe-please-send-my-location-to-this-person.json",
    summary: "For asking someone to send your location to a trusted contact when you need help being found.",
    bodies: {
      "at-glance": "Show the contact, chat, map, or phone screen so the helper knows exactly who should receive it.",
      "quick-say": "Keep your phone unlocked only if it feels safe. Point to the contact instead of handing over more than needed.",
      breakdown: "Vui lòng gửi means please send; vị trí của tôi means my location; cho người này means to this person.",
      "when-to-use": "Good at hotels, police desks, clinics, ride pickups, stations, or late-night help moments when someone needs your location.",
      "good-to-know": "If you cannot share your phone, ask them to write the address or send the location from their own device.",
      "explore-next": "Unsafe, emergency, help, hospital, and passport cards cover more urgent safety paths.",
      "natural-variants": "Police, ambulance, and passport cards help when location sharing is part of a larger emergency."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng gửi", english: "please send", keepTogetherReason: "please-send phrase" },
      { id: "chunk-2", vietnamese: "vị trí của tôi", english: "my location", keepTogetherReason: "my-location phrase" },
      { id: "chunk-3", vietnamese: "cho người này", english: "to this person", keepTogetherReason: "to-this-person phrase" }
    ],
    value: "turns a generic safety page into a location-sharing help request"
  },
  {
    id: "viet-phrase-v900-food-drin-i-do-not-eat-beef",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-i-do-not-eat-beef.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-i-do-not-eat-beef.json",
    summary: "For telling a server or cook you do not eat beef before they recommend, modify, or confirm a dish.",
    bodies: {
      "at-glance": "Say it before ordering, then point to the menu line, broth, topping, or dish photo you are unsure about.",
      "quick-say": "Keep the request calm and specific. If this is an allergy or religious rule, add that detail next.",
      breakdown: "Tôi không means I do not; ăn means eat; thịt bò means beef.",
      "when-to-use": "Good at pho shops, grills, rice counters, banh mi stands, hotel breakfasts, and mixed-menu restaurants.",
      "good-to-know": "Broth, sauces, and toppings can still contain beef. Ask what meat is in the dish if you are unsure.",
      "explore-next": "Without-meat and allergy cards cover the safer follow-up when beef is only one part of the issue.",
      "natural-variants": "No-meat, without-this-ingredient, safest-dish, meat-type, and shrimp cards cover nearby food checks."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi không", english: "I do not", keepTogetherReason: "I-do-not phrase" },
      { id: "chunk-2", vietnamese: "ăn", english: "eat", keepTogetherReason: "eat verb" },
      { id: "chunk-3", vietnamese: "thịt bò", english: "beef", keepTogetherReason: "beef phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-food-drin-can-i-order-this-without-meat",
        "viet-phrase-v500-food-drin-i-am-allergic-to-fish-sauce",
        "viet-phrase-v500-food-drin-i-am-allergic-to-shellfish",
        "viet-phrase-v500-food-drin-i-cannot-eat-this-because-of-an-allergy",
        "viet-phrase-v500-food-drin-i-ordered-this-without-peanuts"
      ]
    },
    cardParityLedger: {
      "explore-next": "aligns source to the richer rendered allergy and no-meat follow-up set instead of a source-only fish-sauce check"
    },
    value: "turns a repeated dietary page into a concrete beef-avoidance and allergy-adjacent page"
  },
  {
    id: "viet-phrase-v900-hote-acco-i-was-charged-for-something-i-did-not-use",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-i-was-charged-for-something-i-did-not-use.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-i-was-charged-for-something-i-did-not-use.json",
    summary: "For questioning a hotel or service charge for something you did not use.",
    bodies: {
      "at-glance": "Point to the bill line, room number, booking, minibar item, laundry slip, or service charge before explaining.",
      "quick-say": "Keep the receipt visible. Ask for the line to be checked before arguing about the full bill.",
      breakdown: "Tôi đã bị tính phí means I was charged; cho thứ mà tôi không sử dụng means for something I did not use.",
      "when-to-use": "Good at hotel checkout, guesthouse desks, tour counters, laundry pickups, and service bills with an extra item.",
      "good-to-know": "If they remove the charge, ask for the new total or updated receipt before paying.",
      "explore-next": "Checkout-time, quiet-room, checkout, room-key, and luggage cards cover nearby hotel desk needs.",
      "natural-variants": "Reservation, check-in, and polite-check-in cards help if the bill issue is tied to your booking."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đã bị tính phí", english: "I was charged", keepTogetherReason: "was-charged phrase" },
      { id: "chunk-2", vietnamese: "cho thứ mà tôi không sử dụng", english: "for something I did not use", keepTogetherReason: "unused-item phrase" }
    ],
    value: "turns a scaffolded hotel bill page into a charge-dispute page"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-how-much-will-it-cost",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-how-much-will-it-cost.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-how-much-will-it-cost.json",
    summary: "For getting a clear quote before a repair, errand, print job, delivery, or small service starts.",
    bodies: {
      "at-glance": "Ask while the item, photo, document, bag, address, or task is visible.",
      "quick-say": "Tie the question to one job. If they add a step, ask again before the work continues.",
      breakdown: "Nó sẽ có giá means it will cost; bao nhiêu asks how much.",
      "when-to-use": "Good at repair counters, print shops, laundry desks, delivery help, hotel errands, and small local services.",
      "good-to-know": "A written quote, calculator number, or receipt is safer than a fast spoken estimate.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and printing cards cover the errand-counter path.",
      "natural-variants": "Water, bag, and tissues cards stay useful at the same small shop or counter."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Nó sẽ có giá", english: "it will cost", keepTogetherReason: "it-will-cost phrase" },
      { id: "chunk-2", vietnamese: "bao nhiêu?", english: "how much?", keepTogetherReason: "how-much ending" }
    ],
    value: "turns a repeated service price page into a quote-before-work page"
  },
  {
    id: "viet-phrase-v900-phon-inte-powe-can-you-send-me-your-location",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-can-you-send-me-your-location.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-can-you-send-me-your-location.json",
    summary: "For asking a driver, host, shop, friend, or helper to send their exact location to your phone.",
    bodies: {
      "at-glance": "Ask while the chat, map, pickup, or address problem is still open on your screen.",
      "quick-say": "Show the messaging app or map. The answer may be a pin, address, nearby landmark, or shared location.",
      breakdown: "Bạn có thể asks can you; gửi cho tôi means send me; vị trí của bạn means your location.",
      "when-to-use": "Good for ride pickups, hotel meetups, shops, tours, deliveries, and friends when the written address is not enough.",
      "good-to-know": "If sharing a live location feels too much, ask for a nearby landmark or typed address instead.",
      "explore-next": "Dead-battery, charger, charge-here, Wi-Fi, and SIM cards cover nearby phone problems.",
      "natural-variants": "Wi-Fi-password and SIM-card cards help if the location issue is really a connectivity issue."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you question frame" },
      { id: "chunk-2", vietnamese: "gửi cho tôi", english: "send me", keepTogetherReason: "send-me phrase" },
      { id: "chunk-3", vietnamese: "vị trí của bạn?", english: "your location?", keepTogetherReason: "your-location phrase" }
    ],
    value: "turns a generic phone page into a shared-location request"
  },
  {
    id: "viet-phrase-v900-sigh-acti-what-time-does-the-tour-start",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-what-time-does-the-tour-start.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-what-time-does-the-tour-start.json",
    summary: "For confirming a tour start time before waiting in the wrong place or missing the group.",
    bodies: {
      "at-glance": "Ask with the booking, ticket, tour name, meeting point, or guide message visible.",
      "quick-say": "Let the time answer land, then confirm the meeting place if there is any doubt.",
      breakdown: "Chuyến tham quan means the tour; bắt đầu means starts; lúc mấy giờ asks what time.",
      "when-to-use": "Good at tour desks, hotel lobbies, piers, museum entrances, bus pickups, and attraction counters.",
      "good-to-know": "Start time and meeting time may be different. Ask where to meet if the answer sounds like departure time.",
      "explore-next": "Closing-time, meeting-point, advance-booking, tour-booking, and entrance cards cover the next attraction step.",
      "natural-variants": "Ticket, start-point, and photo-permission cards cover the broader sightseeing exchange."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chuyến tham quan", english: "the tour", keepTogetherReason: "tour phrase" },
      { id: "chunk-2", vietnamese: "bắt đầu", english: "starts", keepTogetherReason: "starts verb" },
      { id: "chunk-3", vietnamese: "lúc mấy giờ?", english: "at what time?", keepTogetherReason: "what-time ending" }
    ],
    value: "turns a repeated sightseeing page into a tour-start confirmation"
  },
  {
    id: "viet-phrase-v900-time-date-book-what-time-does-it-start",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-what-time-does-it-start.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-what-time-does-it-start.json",
    summary: "For confirming the start time of a booking, class, tour, appointment, show, or pickup.",
    bodies: {
      "at-glance": "Ask while the ticket, booking, calendar, message thread, or address is visible.",
      "quick-say": "Get the time first, then confirm the place if the event has multiple entrances or meeting points.",
      breakdown: "Nó bắt đầu means it starts; lúc mấy giờ asks at what time.",
      "when-to-use": "Good for tours, buses, ferries, appointments, classes, events, rentals, and timed entries.",
      "good-to-know": "If the answer includes a range, ask whether that is arrival time, start time, or pickup time.",
      "explore-next": "Booking, opening-time, move-it-later, boarding-time, and wait-list cards cover the scheduling follow-up.",
      "natural-variants": "What-time, today, and tomorrow-morning cards help when the start time changes the plan."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Nó bắt đầu", english: "it starts", keepTogetherReason: "it-starts phrase" },
      { id: "chunk-2", vietnamese: "lúc mấy giờ?", english: "at what time?", keepTogetherReason: "what-time ending" }
    ],
    value: "turns a repeated time page into a general start-time confirmation"
  }
];

console.log(JSON.stringify(applyRepairs(44, repairs), null, 2));
