#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v900-food-drin-i-asked-for-this-not-spicy",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-i-asked-for-this-not-spicy.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-i-asked-for-this-not-spicy.json",
    summary: "For correcting a dish that arrived spicy after you asked for it mild.",
    bodies: {
      "at-glance": "The dish is already on the table, and the chili level is the problem.",
      "quick-say": "Point to the dish, then say the phrase. Keep the menu or original request visible if you have it.",
      breakdown: "Tôi yêu cầu means I asked for; món này means this dish; không cay means not spicy.",
      "when-to-use": "Good at street stalls, casual restaurants, food courts, and delivery counters when the order needs a calm correction.",
      "good-to-know": "Keep the tone calm and direct. The goal is a fix, not a complaint about the kitchen.",
      "explore-next": "Peanut allergy, recommendations, mild choices, less spicy request, and too spicy now phrases cover the next food move.",
      "natural-variants": "This bowl, not spicy, utensils, takeaway, and pay-now phrases help if the order needs a full reset."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi yêu cầu", english: "I asked for", keepTogetherReason: "asked-for phrase" },
      { id: "chunk-2", vietnamese: "món này", english: "this dish", keepTogetherReason: "this-dish phrase" },
      { id: "chunk-3", vietnamese: "không cay.", english: "not spicy.", keepTogetherReason: "not-spicy phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-family-food-peanut-allergy",
        "viet-phrase-v900-food-drin-what-do-you-recommend",
        "viet-phrase-v900-food-drin-what-is-not-too-spicy",
        "viet-phrase-v900-food-drin-please-make-it-less-spicy",
        "viet-phrase-food-premium-too-spicy-now"
      ]
    },
    cardParityLedger: {
      "explore-next": "mirrors the richer rendered spice/allergy follow-up set instead of keeping a two-card source stub"
    },
    value: "turns a title-repeat food page into a specific spice-level correction"
  },
  {
    id: "viet-phrase-v900-food-drin-please-make-it-without-meat",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-please-make-it-without-meat.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-please-make-it-without-meat.json",
    summary: "For asking a cook, stall, or server to leave meat out of a dish before it is made.",
    bodies: {
      "at-glance": "This belongs before the order is cooked, especially when the menu photo looks flexible.",
      "quick-say": "Point to the dish and say the phrase before paying or sitting down.",
      breakdown: "Hãy làm means please make; món này means this dish; không có thịt means without meat.",
      "when-to-use": "Good at vegetarian-friendly counters, noodle shops, rice stalls, cafes, and hotel breakfast stations.",
      "good-to-know": "Meat stock, fish sauce, and shrimp paste can still be in a dish. Ask the allergy or fish-sauce follow-up if that matters.",
      "explore-next": "Without meat, fish sauce allergy, shellfish allergy, cannot eat this, and peanut order correction phrases cover common food restrictions.",
      "natural-variants": "No meat, without this ingredient, safest dish, meat type, and shrimp-check phrases help clarify what can stay in the order."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy làm", english: "please make", keepTogetherReason: "please-make phrase" },
      { id: "chunk-2", vietnamese: "món này", english: "this dish", keepTogetherReason: "this-dish phrase" },
      { id: "chunk-3", vietnamese: "không có thịt", english: "without meat", keepTogetherReason: "without-meat phrase" }
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
      "explore-next": "mirrors the rendered allergy/restriction follow-up set instead of keeping a two-card source stub"
    },
    value: "makes the no-meat page a real pre-order food restriction moment"
  },
  {
    id: "viet-phrase-v900-hote-acco-is-this-the-total-amount",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-is-this-the-total-amount.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-is-this-the-total-amount.json",
    summary: "For confirming the full hotel charge before you pay, sign, or leave the desk.",
    bodies: {
      "at-glance": "Taxes, deposits, minibar charges, late checkout, or service fees may still be separate.",
      "quick-say": "Point to the printed bill, booking screen, or card terminal so the answer is about the exact total.",
      breakdown: "Đây có phải là asks is this; tổng số tiền means the total amount.",
      "when-to-use": "Good at checkout, after a room change, before a card payment, or when a deposit line looks unclear.",
      "good-to-know": "If the answer is not a clear yes, ask them to write the total before you tap or sign.",
      "explore-next": "Write total, receipt, service charge, extra fee, and refund phrases cover the next money check.",
      "natural-variants": "Deposit refund, unused charge, and emailed invoice phrases help when the hotel bill needs a closer look."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải là", english: "is this", keepTogetherReason: "is-this question frame" },
      { id: "chunk-2", vietnamese: "tổng số tiền?", english: "the total amount?", keepTogetherReason: "total-amount phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-hote-acco-was-the-deposit-refunded",
        "viet-phrase-v900-hote-acco-i-was-charged-for-something-i-did-not-use",
        "viet-phrase-v900-hote-acco-can-you-email-me-the-invoice"
      ],
      "explore-next": [
        "viet-phrase-money-premium-write-total",
        "viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt",
        "viet-phrase-v900-mone-numb-pric-is-the-service-charge-included",
        "viet-phrase-v500-mone-numb-pric-is-there-an-extra-fee",
        "viet-phrase-v900-mone-numb-pric-can-you-process-a-refund"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces check-in basics with hotel bill and invoice follow-ups while preserving three visible cards",
      "explore-next": "replaces checkout basics with total, receipt, fee, and refund follow-ups while preserving five visible cards"
    },
    value: "turns a generic hotel page into a concrete checkout total check"
  },
  {
    id: "viet-phrase-v900-phon-inte-powe-the-app-will-not-accept-my-card",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-the-app-will-not-accept-my-card.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-the-app-will-not-accept-my-card.json",
    summary: "For showing a payment screen when an app refuses your card.",
    bodies: {
      "at-glance": "Use it with a ride, delivery, ticket, hotel, or SIM app when the error is visible on your phone.",
      "quick-say": "Show the error screen first. Then ask for help switching payment, trying another card, or paying another way.",
      breakdown: "Ứng dụng means the app; sẽ không chấp nhận means will not accept; thẻ của tôi means my card.",
      "when-to-use": "Good at hotel desks, SIM shops, ride pickup points, ticket counters, and cafes when staff can see the failed payment.",
      "good-to-know": "Keep the phone in your hand if money is involved. Let them point, read, or type only what you allow.",
      "explore-next": "QR payment, payment went through, book a Grab, type the address, and Wi-Fi phrases cover common app-payment follow-ups.",
      "natural-variants": "Declined card, try another card, and card machine not working phrases help when the problem moves from app to payment."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Ứng dụng", english: "the app", keepTogetherReason: "app noun" },
      { id: "chunk-2", vietnamese: "sẽ không chấp nhận", english: "will not accept", keepTogetherReason: "will-not-accept phrase" },
      { id: "chunk-3", vietnamese: "thẻ của tôi", english: "my card", keepTogetherReason: "my-card phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-mone-numb-pric-my-card-was-declined",
        "viet-phrase-v500-mone-numb-pric-can-i-try-another-card",
        "viet-phrase-v900-mone-numb-pric-the-card-machine-is-not-working"
      ],
      "explore-next": [
        "viet-phrase-v900-mone-numb-pric-can-i-pay-by-qr-code",
        "viet-phrase-v900-mone-numb-pric-the-payment-went-through",
        "viet-phrase-v900-phon-inte-powe-can-you-help-me-book-a-grab",
        "viet-phrase-v900-phon-inte-powe-can-you-type-the-address-for-me",
        "viet-phrase-v500-phon-inte-powe-can-i-use-the-wi-fi"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces generic phone cards with card-failure follow-ups while preserving three visible cards",
      "explore-next": "replaces battery/charger cards with app payment, ride app, address, and Wi-Fi follow-ups while preserving five visible cards"
    },
    value: "turns a phone category page into a practical failed app-payment recovery"
  },
  {
    id: "viet-phrase-v900-sigh-acti-can-i-take-a-photo-here",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-can-i-take-a-photo-here.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-can-i-take-a-photo-here.json",
    summary: "For checking photo rules before raising your camera at a temple, museum, shop, or viewpoint.",
    bodies: {
      "at-glance": "Ask before taking the shot when signs are unclear or staff are nearby.",
      "quick-say": "Gesture lightly toward your phone or camera, say the phrase, then wait for yes, no, or a pointed boundary.",
      breakdown: "Tôi có thể asks can I; chụp ảnh means take a photo; ở đây được không asks if it is allowed here.",
      "when-to-use": "Good at temples, museums, ticketed attractions, workshops, markets, and places where people may not want photos.",
      "good-to-know": "A small nod or crossed-arm gesture may be the answer. Respect that first before asking for detail.",
      "explore-next": "Entrance, exit, less crowded, safe at night, and written name phrases help when the visit continues.",
      "natural-variants": "Photography allowed, what to avoid, and included in ticket phrases cover nearby permission checks."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I question frame" },
      { id: "chunk-2", vietnamese: "chụp ảnh", english: "take a photo", keepTogetherReason: "take-photo phrase" },
      { id: "chunk-3", vietnamese: "ở đây được không?", english: "is it allowed here?", keepTogetherReason: "allowed-here question" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-sigh-acti-is-photography-allowed",
        "viet-phrase-v500-sigh-acti-what-should-i-avoid",
        "viet-phrase-v900-sigh-acti-is-this-included-in-the-ticket"
      ],
      "explore-next": [
        "viet-phrase-v500-sigh-acti-where-is-the-entrance",
        "viet-phrase-v500-sigh-acti-where-is-the-exit",
        "viet-phrase-v900-sigh-acti-where-is-less-crowded",
        "viet-phrase-v900-sigh-acti-is-this-area-safe-at-night",
        "viet-phrase-v900-sigh-acti-can-you-write-the-name-for-me"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces generic sight cards with permission and ticket-boundary cards while preserving three visible cards",
      "explore-next": "replaces timing cards with entrance, exit, crowd, safety, and written-name follow-ups while preserving five visible cards"
    },
    value: "makes the photo page about consent and site rules instead of a bare yes/no question"
  },
  {
    id: "viet-phrase-v900-sigh-acti-i-cannot-find-the-tour-guide",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-i-cannot-find-the-tour-guide.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-i-cannot-find-the-tour-guide.json",
    summary: "For telling staff you are at the meeting area but cannot find the guide.",
    bodies: {
      "at-glance": "Use it with a tour booking, ticket, chat thread, or meeting-point sign in view.",
      "quick-say": "Show the booking or meeting point after the phrase so staff can match the time, company, or guide name.",
      breakdown: "Tôi không thể tìm thấy means I cannot find; hướng dẫn viên du lịch means the tour guide.",
      "when-to-use": "Good at hotel lobbies, ticket desks, attraction entrances, bus pickup points, and tour counters.",
      "good-to-know": "The next useful detail is usually the tour company, guide name, start time, or meeting point.",
      "explore-next": "Tour booking, entrance, English guide, tour meeting place, and book a tour phrases cover the next sightseeing handoff.",
      "natural-variants": "Tour meeting place, start time, and send meeting point phrases help when the guide is not visible yet."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi không thể tìm thấy", english: "I cannot find", keepTogetherReason: "cannot-find phrase" },
      { id: "chunk-2", vietnamese: "hướng dẫn viên du lịch", english: "the tour guide", keepTogetherReason: "tour-guide phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-sigh-acti-where-does-the-tour-meet",
        "viet-phrase-v900-sigh-acti-what-time-does-the-tour-start",
        "viet-phrase-v900-sigh-acti-please-send-me-the-meeting-point"
      ],
      "explore-next": [
        "viet-phrase-v500-sigh-acti-i-have-a-tour-booking",
        "viet-phrase-v500-sigh-acti-where-is-the-entrance",
        "viet-phrase-v900-sigh-acti-is-there-an-english-guide",
        "viet-phrase-v900-dire-navi-where-do-i-meet-the-tour-group",
        "viet-phrase-v900-sigh-acti-id-like-to-book-a-tour"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces generic attraction cards with tour meeting and timing follow-ups while preserving three visible cards",
      "explore-next": "retargets the five-card set toward booking, entrance, guide language, meeting point, and tour booking"
    },
    value: "turns the guide page into a concrete meeting-point recovery moment"
  },
  {
    id: "viet-phrase-v900-unde-repa-is-there-someone-who-speaks-english",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v900-unde-repa-is-there-someone-who-speaks-english.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v900-unde-repa-is-there-someone-who-speaks-english.json",
    summary: "For politely asking for an English speaking handoff when the exchange is stuck.",
    bodies: {
      "at-glance": "Repeating, pointing, or translation has not solved the conversation.",
      "quick-say": "Ask calmly at the counter or desk. The answer may be a staff handoff, a phone call, or a polite no.",
      breakdown: "Có ai asks is there anyone; nói được tiếng Anh means who can speak English; không makes it a yes/no question.",
      "when-to-use": "Good at hotels, clinics, transport counters, police desks, pharmacies, and service counters.",
      "good-to-know": "If no one speaks English, switch to writing, pointing, or a translation app instead of repeating louder.",
      "explore-next": "Explain in English, translation app, type into my phone, write the address, and translate-this phrases cover the next repair path.",
      "natural-variants": "I do not understand, slower speech, and polite slower speech phrases help before asking for a full handoff."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có ai", english: "is there anyone", keepTogetherReason: "is-there-anyone phrase" },
      { id: "chunk-2", vietnamese: "nói được tiếng Anh", english: "who can speak English", keepTogetherReason: "speaks-English phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-unde-repa-can-you-explain-it-in-english",
        "viet-phrase-v500-unde-repa-can-i-use-a-translation-app",
        "viet-phrase-v500-unde-repa-please-type-it-into-my-phone",
        "viet-phrase-v500-unde-repa-can-you-write-the-address",
        "viet-phrase-repair-translate-this"
      ]
    },
    cardParityLedger: {
      "explore-next": "replaces generic repeat/write cards with English, translation-app, typing, address, and translate-this follow-ups"
    },
    value: "turns an English-help page into a polite handoff and next-step repair strategy"
  },
  {
    id: "viet-phrase-directions-8",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/directions-8.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/directions-pickup-point.json",
    summary: "For finding the exact pickup point before a driver, tour, shuttle, or Grab arrives.",
    bodies: {
      "at-glance": "The map says you are nearby, but the curb, gate, or entrance is still unclear.",
      "quick-say": "Show the booking or map pin and ask the question. A point or short direction may be enough.",
      breakdown: "Điểm đón means pickup point; ở đâu asks where.",
      "when-to-use": "Good at airports, hotel lobbies, malls, stations, tour pickup areas, and busy streets with several entrances.",
      "good-to-know": "Pickup answers often come as a gesture toward a door, lane, or sign. Watch the finger before asking again.",
      "explore-next": "Call taxi, take me to this address, correct pickup point, drop me off, call driver, and book Grab phrases cover the ride handoff.",
      "natural-variants": "Excuse me, how to get there, near here, and walking-time phrases help if the pickup point becomes a route."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Điểm đón", english: "pickup point", keepTogetherReason: "pickup-point phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where-question phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-family-ves-call-taxi-for-me",
        "viet-phrase-v900-tran-please-take-me-to-this-address",
        "viet-phrase-v900-dire-navi-is-this-the-correct-pickup-point",
        "viet-family-ves-drop-me-off-here",
        "viet-phrase-v500-tran-please-call-the-driver",
        "viet-phrase-v900-phon-inte-powe-can-you-help-me-book-a-grab"
      ]
    },
    cardParityLedger: {
      "explore-next": "mirrors the richer rendered six-card pickup/ride handoff instead of keeping direction-only source cards"
    },
    value: "turns a generic where question into a pickup-point and ride handoff page"
  },
  {
    id: "viet-phrase-emergency-premium-wallet-stolen",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/emergency-premium-wallet-stolen.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/emergency-wallet-stolen.json",
    summary: "For telling staff or police that your wallet was stolen and you need help taking the next step.",
    bodies: {
      "at-glance": "You are safe enough to name the theft clearly and ask for help.",
      "quick-say": "Say the phrase, then show a bag, card alert, ID photo, police desk, or hotel contact if it helps.",
      breakdown: "Ví của tôi means my wallet; đã bị đánh cắp means was stolen.",
      "when-to-use": "Good at hotel desks, police stations, transport counters, shops, and any safe staffed place after the theft.",
      "good-to-know": "Start with safety, then cards, ID, and reports. Do not turn the first sentence into the whole story.",
      "explore-next": "Police station, passport report, write what happened, send my location, and temporary travel document phrases cover the recovery path.",
      "natural-variants": "Call police, lost credit card, and cancel my card phrases cover the urgent financial steps."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Ví của tôi", english: "my wallet", keepTogetherReason: "my-wallet phrase" },
      { id: "chunk-2", vietnamese: "đã bị đánh cắp.", english: "was stolen.", keepTogetherReason: "was-stolen phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-emer-safe-please-call-the-police",
        "viet-phrase-v500-emer-safe-i-lost-my-credit-card",
        "viet-phrase-v900-emer-safe-can-you-help-me-cancel-my-card"
      ],
      "explore-next": [
        "viet-phrase-emergency-premium-police-station",
        "viet-phrase-emergency-premium-passport-report",
        "viet-phrase-v900-emer-safe-please-write-down-what-happened",
        "viet-phrase-v900-emer-safe-please-send-my-location-to-this-person",
        "viet-phrase-v900-emer-safe-i-need-a-temporary-travel-document"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces generic emergency cards with police, lost-card, and card-cancel follow-ups while preserving three visible cards",
      "explore-next": "replaces broad safety cards with police-station, report, location, and travel-document recovery cards"
    },
    value: "turns a theft page into a calm wallet recovery sequence"
  },
  {
    id: "viet-phrase-hotel-premium-different-room",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/hotel-premium-different-room.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/hotel-different-room.json",
    summary: "For telling the front desk the room assigned does not match the room you booked.",
    bodies: {
      "at-glance": "The booking screen, room type, bed setup, or confirmation email is the proof.",
      "quick-say": "Say the phrase before unpacking. Then show the booking so the desk can compare the room type.",
      breakdown: "Tôi đã đặt means I booked; một phòng khác means a different room.",
      "when-to-use": "Good at hotel desks, guesthouses, homestays, and serviced apartments when the assigned room feels wrong.",
      "good-to-know": "Stay specific: room type, bed count, window, floor, or booking photo. That is easier to fix than a long complaint.",
      "explore-next": "Change rooms, see the room first, nearby rooms, two beds, and room refund phrases cover the next front-desk move.",
      "natural-variants": "Not the room I booked, booking wrong, and booked online phrases help prove the mismatch."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đã đặt", english: "I booked", keepTogetherReason: "I-booked phrase" },
      { id: "chunk-2", vietnamese: "một phòng khác.", english: "a different room.", keepTogetherReason: "different-room phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-hote-acco-this-is-not-the-room-i-booked",
        "viet-phrase-hotel-premium-booking-wrong",
        "viet-phrase-v500-hote-acco-i-booked-online"
      ],
      "explore-next": [
        "viet-phrase-v500-hote-acco-can-i-change-rooms",
        "viet-phrase-v900-hote-acco-can-i-see-the-room-first",
        "viet-phrase-v900-hote-acco-can-you-put-us-in-nearby-rooms",
        "viet-phrase-v900-hote-acco-can-i-have-a-room-with-two-beds",
        "viet-phrase-v900-hote-acco-can-i-get-a-refund-for-the-room"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces check-in basics with room-mismatch proof cards while preserving three visible cards",
      "explore-next": "replaces checkout basics with room-change, preview, nearby-room, bed, and refund follow-ups"
    },
    value: "turns a generic hotel line into a specific room-mismatch front-desk page"
  },
  {
    id: "viet-phrase-repair-premium-which-exit",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/repair-premium-which-exit.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/repair-which-exit.json",
    summary: "For checking which exit someone means when directions are happening too fast.",
    bodies: {
      "at-glance": "Stations, malls, markets, museums, parking areas, and airports can have several exits.",
      "quick-say": "Point to the map, sign, or hallway before asking. A number, color, or finger point may be the whole answer.",
      breakdown: "Đó là means that is; lối ra nào asks which exit.",
      "when-to-use": "Good when a person says go out there but the building has more than one way out.",
      "good-to-know": "Repeat the exit number, floor, or landmark back if you are not sure.",
      "explore-next": "Downstairs, upstairs, correct street, main entrance, and back entrance phrases help after the exit is chosen.",
      "natural-variants": "Which exit, exit to the street, and which entrance phrases cover nearby building-navigation questions."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đó là", english: "that is", keepTogetherReason: "that-is phrase" },
      { id: "chunk-2", vietnamese: "lối ra nào?", english: "which exit?", keepTogetherReason: "which-exit phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-directions-9",
        "viet-phrase-v900-dire-navi-where-is-the-exit-to-the-street",
        "viet-phrase-v900-dire-navi-which-entrance-should-i-use"
      ],
      "explore-next": [
        "viet-phrase-v500-dire-navi-do-i-go-downstairs",
        "viet-phrase-v500-dire-navi-do-i-go-upstairs",
        "viet-phrase-v900-dire-navi-is-this-the-correct-street",
        "viet-phrase-v900-dire-navi-where-is-the-main-entrance",
        "viet-phrase-v900-dire-navi-where-is-the-back-entrance"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces general repair cards with exit and entrance navigation cards while preserving three visible cards",
      "explore-next": "replaces generic repeat/write cards with stairs, street, and entrance follow-ups while preserving five visible cards"
    },
    value: "turns the repair page into a specific building-exit clarification"
  },
  {
    id: "viet-phrase-transport-premium-luggage-trunk",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/transport-premium-luggage-trunk.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/transport-luggage-trunk.json",
    summary: "For telling a driver or staff member that your luggage is still in the trunk.",
    bodies: {
      "at-glance": "The car has not left yet, or the driver is about to move on.",
      "quick-say": "Point to the vehicle or trunk while you say it. Keep the ride screen visible if you need the driver identified.",
      breakdown: "Hành lý của tôi means my luggage; ở trong cốp xe means is in the trunk.",
      "when-to-use": "Good after taxis, Grab rides, hotel transfers, buses, airport pickups, and any ride where bags were loaded for you.",
      "good-to-know": "Act quickly but calmly. The car, plate, driver, or company is the detail that helps most.",
      "explore-next": "Call the driver, contact the company, driver left, different car number, and stop near the entrance phrases cover recovery.",
      "natural-variants": "Open the trunk, put my bag here, and left something in the car phrases cover nearby luggage moments."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hành lý của tôi", english: "my luggage", keepTogetherReason: "my-luggage phrase" },
      { id: "chunk-2", vietnamese: "ở trong cốp xe.", english: "is in the trunk.", keepTogetherReason: "in-the-trunk phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-tran-please-open-the-trunk",
        "viet-phrase-v500-tran-can-i-put-my-bag-here",
        "viet-phrase-v500-tran-i-left-something-in-the-car"
      ],
      "explore-next": [
        "viet-phrase-v500-tran-please-call-the-driver",
        "viet-phrase-v900-tran-can-you-help-me-contact-the-company",
        "viet-phrase-v900-tran-the-driver-left-without-me",
        "viet-phrase-v900-tran-the-car-number-is-different",
        "viet-phrase-v900-tran-please-stop-near-the-entrance"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces destination basics with trunk, bag, and left-item cards while preserving three visible cards",
      "explore-next": "replaces generic taxi controls with driver/company and recovery cards while preserving five visible cards"
    },
    value: "turns a generic transport page into a clear lost-luggage-in-car recovery moment"
  }
];

console.log(JSON.stringify(applyRepairs(36, repairs), null, 2));
