#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v900-mone-numb-pric-i-gave-you-the-wrong-bill",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-i-gave-you-the-wrong-bill.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-i-gave-you-the-wrong-bill.json",
    summary: "For correcting a bill, receipt, or payment slip you handed over by mistake.",
    bodies: {
      "at-glance": "Use it when the wrong paper, receipt, room bill, or payment slip is already in someone's hand.",
      "quick-say": "Show the correct bill or receipt right after the phrase so the fix is obvious.",
      breakdown: "Tôi đưa nhầm means I gave by mistake; hóa đơn cho bạn means the bill to you.",
      "when-to-use": "Good at hotel desks, shops, ticket counters, clinics, and restaurants before the mistake becomes a longer dispute.",
      "good-to-know": "Keep both bills visible if you can. Pointing is faster than explaining every line item.",
      "explore-next": "Receipt, cancel the payment, refund, and write the price phrases cover the next repair step.",
      "natural-variants": "Use this is not my receipt, wrong amount, or charged twice phrases when the mistake came from their side."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đưa nhầm", english: "I gave by mistake", keepTogetherReason: "wrong-item handoff phrase" },
      { id: "chunk-2", vietnamese: "hóa đơn cho bạn", english: "the bill to you", keepTogetherReason: "bill handoff phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-mone-numb-pric-this-receipt-is-not-mine",
        "viet-phrase-v900-mone-numb-pric-i-was-charged-the-wrong-amount",
        "viet-phrase-help-4"
      ],
      "explore-next": [
        "viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt",
        "viet-phrase-v900-mone-numb-pric-please-cancel-that-card-payment",
        "viet-phrase-v900-mone-numb-pric-can-you-process-a-refund",
        "viet-phrase-v900-mone-numb-pric-can-you-refund-the-difference",
        "viet-phrase-v500-unde-repa-can-you-write-the-price"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces generic price cards with bill/receipt mistake cards while preserving three visible nearby cards",
      "explore-next": "replaces bargaining cards with receipt, payment cancellation, refund, and written-price repair cards while preserving five visible cards"
    },
    value: "turns a title-repeat money page into a concrete bill-correction handoff"
  },
  {
    id: "viet-phrase-v900-prob-help-can-you-help-me-contact-my-airline",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v900-prob-help-can-you-help-me-contact-my-airline.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v900-prob-help-can-you-help-me-contact-my-airline.json",
    summary: "For asking a desk, hotel, or helpful local to help reach your airline.",
    bodies: {
      "at-glance": "Use it when a flight, bag, check-in, cancellation, or connection problem needs the airline, not just local staff.",
      "quick-say": "Show the booking, flight number, boarding pass, or airline app before adding the story.",
      breakdown: "Bạn có thể means can you; giúp tôi liên hệ means help me contact; hãng hàng không của tôi means my airline.",
      "when-to-use": "Good at airport information desks, hotel reception, tour counters, and help desks with a phone nearby.",
      "good-to-know": "Lead with the airline name and flight number. That helps the helper skip straight to the right contact path.",
      "explore-next": "Lost luggage, baggage tag, driver, information desk, and departure hall phrases cover common airport follow-ups.",
      "natural-variants": "Contact the driver, contact the hotel, and emergency contact phrases cover nearby help calls."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "giúp tôi liên hệ", english: "help me contact", keepTogetherReason: "help-contact phrase" },
      { id: "chunk-3", vietnamese: "với hãng hàng không của tôi", english: "my airline", keepTogetherReason: "airline-contact phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-prob-help-can-you-contact-the-driver",
        "viet-phrase-v500-prob-help-can-you-help-me-contact-my-hotel",
        "viet-phrase-v500-prob-help-can-you-call-my-emergency-contact"
      ],
      "explore-next": [
        "viet-phrase-v500-airp-bord-arri-i-need-to-report-lost-luggage",
        "viet-phrase-v500-airp-bord-arri-this-is-my-baggage-tag",
        "viet-phrase-v500-airp-bord-arri-my-driver-canceled",
        "viet-phrase-v900-airp-bord-arri-where-is-the-information-desk",
        "viet-phrase-v900-airp-bord-arri-where-is-the-departure-hall"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces generic lost/help cards with contact-call variants while preserving three visible cards",
      "explore-next": "replaces generic problem cards with airline-adjacent airport recovery cards while preserving five visible cards"
    },
    value: "turns a generic help page into a specific airline-contact recovery moment"
  },
  {
    id: "viet-phrase-v900-tran-is-that-the-total-price",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-is-that-the-total-price.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-is-that-the-total-price.json",
    summary: "For confirming the full fare before you pay or agree to a ride.",
    bodies: {
      "at-glance": "Ask when tolls, luggage, waiting time, airport fees, or app prices might be separate.",
      "quick-say": "Point to the fare screen, calculator, or written number so the answer is about the total.",
      breakdown: "Đó có phải là asks is that; tổng giá means total price; không? makes it yes/no.",
      "when-to-use": "Good before cash changes hands, before a taxi starts moving, or when a driver names several small charges.",
      "good-to-know": "If the answer is not a clear yes, ask them to write the total before paying.",
      "explore-next": "Write the price, total amount, toll, receipt, and final price phrases cover the next money check.",
      "natural-variants": "Altogether, tax included, and service charge phrases help when the total is still unclear."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đó có phải là", english: "is that", keepTogetherReason: "is-that question frame" },
      { id: "chunk-2", vietnamese: "tổng giá", english: "the total price", keepTogetherReason: "total-price phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-price-8",
        "viet-phrase-v500-mone-numb-pric-is-tax-included",
        "viet-phrase-v900-mone-numb-pric-is-the-service-charge-included"
      ],
      "explore-next": [
        "viet-phrase-v500-unde-repa-can-you-write-the-price",
        "viet-phrase-v900-hote-acco-is-this-the-total-amount",
        "viet-phrase-v900-tran-does-that-include-tolls",
        "viet-phrase-v900-tran-please-give-me-a-receipt",
        "viet-family-money-final-price"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces route-direction cards with total-price clarification cards while preserving three visible cards",
      "explore-next": "replaces taxi-control cards with total, toll, receipt, and written-price follow-ups while preserving five visible cards"
    },
    value: "makes the transport page about total-fare confirmation instead of route commands"
  },
  {
    id: "viet-phrase-directions-9",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/directions-9.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/directions-which-exit.json",
    summary: "For choosing the right exit at a station, mall, market, airport, or attraction.",
    bodies: {
      "at-glance": "Ask when several exits or corridors look similar and you need one clear direction.",
      "quick-say": "Point to the sign, map, ticket, or phone route so the answer can be a gesture.",
      breakdown: "Lối ra means exit; nào? asks which one.",
      "when-to-use": "Good at stations, malls, markets, airports, parking areas, museums, and apartment lobbies.",
      "good-to-know": "People may answer with a number, color, floor, or finger point. Repeat the landmark if you are unsure.",
      "explore-next": "Turn left, turn right, straight ahead, understood, and pickup point phrases cover the next direction step.",
      "natural-variants": "How to get there, near here, and walking time phrases help if the exit answer becomes a route."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Lối ra", english: "exit", keepTogetherReason: "exit noun" },
      { id: "chunk-2", vietnamese: "nào?", english: "which one?", keepTogetherReason: "which-question ending" }
    ],
    value: "turns a generic directions page into a station or building exit decision"
  },
  {
    id: "viet-phrase-help-4",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/help-4.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/help-charged-twice.json",
    summary: "For telling a desk, shop, hotel, or app counter that you were charged twice.",
    bodies: {
      "at-glance": "Use it with the receipt, bank alert, app screen, or room bill visible.",
      "quick-say": "Say the phrase once, then show the two charges before explaining anything else.",
      breakdown: "Tôi bị means I was; tính tiền means charged; hai lần means twice.",
      "when-to-use": "Good at hotel reception, restaurants, ticket counters, ride desks, shops, and service counters.",
      "good-to-know": "Two visible charges make this much easier to solve. Keep the dates, amounts, and card screen ready.",
      "explore-next": "Receipt, refund, cancel the card payment, manager, and report phrases cover the next recovery step.",
      "natural-variants": "Wrong amount, this is not my receipt, and wrong bill phrases help with nearby payment mistakes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I was", keepTogetherReason: "passive problem frame" },
      { id: "chunk-2", vietnamese: "tính tiền", english: "charged", keepTogetherReason: "charge verb" },
      { id: "chunk-3", vietnamese: "hai lần", english: "twice", keepTogetherReason: "twice phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-mone-numb-pric-i-was-charged-the-wrong-amount",
        "viet-phrase-v900-mone-numb-pric-this-receipt-is-not-mine",
        "viet-phrase-v900-mone-numb-pric-i-gave-you-the-wrong-bill"
      ],
      "explore-next": [
        "viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt",
        "viet-phrase-v900-mone-numb-pric-can-you-process-a-refund",
        "viet-phrase-v900-mone-numb-pric-please-cancel-that-card-payment",
        "viet-phrase-help-3",
        "viet-phrase-help-5"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces generic lost/help cards with nearby payment-mistake cards while preserving three visible cards",
      "explore-next": "replaces broad help cards with receipt, refund, card-payment cancellation, manager, and report follow-ups while preserving five visible cards"
    },
    value: "turns a generic help page into a concrete double-charge recovery step"
  },
  {
    id: "viet-phrase-v500-airp-bord-arri-my-driver-canceled",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-my-driver-canceled.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-my-driver-canceled.json",
    summary: "For explaining that your airport pickup or ride-booking driver canceled.",
    bodies: {
      "at-glance": "Use it when you are stuck at arrivals, a lobby, or a pickup point and need a new transport plan.",
      "quick-say": "Show the canceled ride screen first. The screenshot explains the timing better than a long story.",
      breakdown: "Tài xế của tôi means my driver; đã hủy means canceled.",
      "when-to-use": "Good at airport pickup points, hotel desks, taxi counters, tour desks, and ride-hailing help spots.",
      "good-to-know": "If someone can help, the next useful detail is usually pickup point, destination, or whether to book another ride.",
      "explore-next": "Call the driver, Grab pickup, hotel destination, information desk, and phone charging phrases cover the next move.",
      "natural-variants": "Taxi counter, contact the driver, and Grab booking phrases help you rebuild the ride."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tài xế của tôi", english: "my driver", keepTogetherReason: "my-driver phrase" },
      { id: "chunk-2", vietnamese: "đã hủy", english: "canceled", keepTogetherReason: "canceled phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-airp-bord-arri-where-is-the-taxi-counter",
        "viet-phrase-v500-prob-help-can-you-contact-the-driver",
        "viet-phrase-v900-phon-inte-powe-can-you-help-me-book-a-grab"
      ],
      "explore-next": [
        "viet-phrase-v900-airp-bord-arri-please-call-this-driver-for-me",
        "viet-phrase-v900-airp-bord-arri-where-is-the-grab-pickup-point",
        "viet-phrase-v500-airp-bord-arri-please-take-me-to-the-hotel-listed-on-this-booki",
        "viet-phrase-v900-airp-bord-arri-where-is-the-information-desk",
        "viet-phrase-v900-airp-bord-arri-where-can-i-charge-my-phone"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces immigration/SIM cards with taxi-counter and ride-recovery cards while preserving three visible cards",
      "explore-next": "retargets airport follow-ups toward driver contact, Grab pickup, hotel destination, help desk, and phone charging while preserving five visible cards"
    },
    value: "turns an arrival page into a specific canceled-driver recovery moment"
  },
  {
    id: "viet-phrase-v500-airp-bord-arri-this-is-my-baggage-tag",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-this-is-my-baggage-tag.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-this-is-my-baggage-tag.json",
    summary: "For showing the baggage tag when staff are tracing, claiming, or reporting a bag.",
    bodies: {
      "at-glance": "Use it at a baggage desk before describing the bag, flight, or delivery address.",
      "quick-say": "Hold out the tag or photo while you say it so staff can read the number.",
      breakdown: "Đây là means this is; thẻ hành lý means baggage tag; của tôi means mine.",
      "when-to-use": "Good at baggage claim, airline counters, transfer desks, lost-luggage offices, and airport information desks.",
      "good-to-know": "The tag number matters more than a long description at first. Keep your passport or boarding pass nearby too.",
      "explore-next": "Pickup, driver meetup, bag did not arrive, domestic terminal, and visa phrases cover common arrivals follow-ups.",
      "natural-variants": "Immigration, baggage claim, and SIM card phrases help if you are still moving through arrivals."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây là", english: "this is", keepTogetherReason: "this-is phrase" },
      { id: "chunk-2", vietnamese: "thẻ hành lý", english: "baggage tag", keepTogetherReason: "baggage-tag noun" },
      { id: "chunk-3", vietnamese: "của tôi", english: "mine", keepTogetherReason: "mine phrase" }
    ],
    value: "turns a document page into a clear baggage-desk proof handoff"
  },
  {
    id: "viet-phrase-v500-prob-help-i-lost-my-room-key",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-i-lost-my-room-key.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-i-lost-my-room-key.json",
    summary: "For telling hotel staff you lost the room key or key card.",
    bodies: {
      "at-glance": "Use it at reception before giving your room number, passport name, or booking screen.",
      "quick-say": "Say it calmly, then show your room number or booking so staff can verify you.",
      breakdown: "Tôi bị mất means I lost; chìa khóa phòng means room key.",
      "when-to-use": "Good at hotel desks, homestays, apartments, guesthouses, and security counters.",
      "good-to-know": "Staff may ask for ID or charge a replacement fee. Keep the room number private until you are at the desk.",
      "explore-next": "Call the hotel, ask for the manager, make a report, charged twice, and translate for me phrases cover recovery follow-ups.",
      "natural-variants": "The key card and left something behind phrases cover nearby hotel desk problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị mất", english: "I lost", keepTogetherReason: "lost-item phrase" },
      { id: "chunk-2", vietnamese: "chìa khóa phòng", english: "room key", keepTogetherReason: "room-key noun" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-hotel-8",
        "viet-phrase-problems-4"
      ]
    },
    cardParityLedger: {
      "natural-variants": "matches the two rendered hotel recovery cards and removes one source-only helper-family card the app already omitted"
    },
    value: "turns a generic problem page into a hotel-front-desk lost-key page"
  },
  {
    id: "viet-phrase-v500-unde-repa-let-me-show-you-instead",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-let-me-show-you-instead.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-let-me-show-you-instead.json",
    summary: "For switching from explaining out loud to showing the screen, map, item, or note.",
    bodies: {
      "at-glance": "Use it when speech is stuck and the phone, photo, address, or object will be clearer.",
      "quick-say": "Say it, then immediately show the thing. Do not add a long English explanation first.",
      breakdown: "Thay vào đó means instead; hãy để tôi means let me; chỉ cho bạn means show you.",
      "when-to-use": "Good at counters, taxis, shops, hotels, pharmacies, and any moment where pointing beats explaining.",
      "good-to-know": "This keeps the exchange friendly because you are changing method, not correcting the person.",
      "explore-next": "Repeat, write it down, meaning, which one, and show me phrases cover nearby repair moves.",
      "natural-variants": "I do not understand and please speak more slowly phrases help when showing is not enough."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Thay vào đó", english: "instead", keepTogetherReason: "instead phrase" },
      { id: "chunk-2", vietnamese: "hãy để tôi", english: "let me", keepTogetherReason: "let-me phrase" },
      { id: "chunk-3", vietnamese: "chỉ cho bạn", english: "show you", keepTogetherReason: "show-you phrase" }
    ],
    value: "turns a repair phrase into a practical phone/map/showing move"
  },
  {
    id: "viet-phrase-v500-unde-repa-please-show-me-where-to-tap",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-please-show-me-where-to-tap.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-please-show-me-where-to-tap.json",
    summary: "For asking someone to point out the right button on a phone, kiosk, or payment screen.",
    bodies: {
      "at-glance": "Use it when an app, ATM, QR screen, ticket machine, or card reader is asking for the next tap.",
      "quick-say": "Hold the screen where they can see it and let them point instead of taking the phone.",
      breakdown: "Vui lòng chỉ cho tôi means please show me; nơi để nhấn means where to tap.",
      "when-to-use": "Good at payment terminals, ticket kiosks, SIM counters, hotel desks, ATMs, and delivery apps.",
      "good-to-know": "If money is involved, keep the phone in your hand and ask them to point. That protects the screen and the payment.",
      "explore-next": "Repeat, write it down, meaning, which one, and show me phrases cover nearby repair moves.",
      "natural-variants": "Do not tap again, point to it, and write the price phrases help when the screen is part of a payment or form."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng chỉ cho tôi", english: "please show me", keepTogetherReason: "please-show-me phrase" },
      { id: "chunk-2", vietnamese: "nơi để nhấn", english: "where to tap", keepTogetherReason: "where-to-tap phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-mone-numb-pric-please-do-not-tap-again",
        "viet-phrase-v500-unde-repa-please-point-to-it",
        "viet-phrase-v500-unde-repa-can-you-write-the-price"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces slower-speech cards with screen/payment repair cards while preserving three visible cards"
    },
    value: "turns a generic repair page into a concrete phone or payment-screen safety move"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-please-call-this-driver-for-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-please-call-this-driver-for-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-please-call-this-driver-for-me.json",
    summary: "For asking someone to call the driver shown on your booking or pickup screen.",
    bodies: {
      "at-glance": "Use it when the driver is hard to find, messages are not working, or the pickup point is confusing.",
      "quick-say": "Show the phone number or booking screen first so the helper knows exactly who to call.",
      breakdown: "Hãy gọi means please call; tài xế này means this driver; cho tôi means for me.",
      "when-to-use": "Good at airport pickup points, hotel desks, tour counters, security desks, and ride-hailing help spots.",
      "good-to-know": "Keep the phone unlocked and the number visible. If the driver cancels, switch to the driver canceled phrase.",
      "explore-next": "Pickup area, driver meetup, missing bag, domestic terminal, and visa phrases cover arrival follow-ups.",
      "natural-variants": "Driver canceled, contact the driver, and Grab pickup phrases help if the call becomes a ride problem."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy gọi", english: "please call", keepTogetherReason: "please-call phrase" },
      { id: "chunk-2", vietnamese: "tài xế này", english: "this driver", keepTogetherReason: "this-driver phrase" },
      { id: "chunk-3", vietnamese: "cho tôi", english: "for me", keepTogetherReason: "for-me phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-airp-bord-arri-my-driver-canceled",
        "viet-phrase-v500-prob-help-can-you-contact-the-driver",
        "viet-phrase-v900-airp-bord-arri-where-is-the-grab-pickup-point"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces immigration/SIM cards with driver-specific follow-ups while preserving three visible cards"
    },
    value: "turns a generic airport page into a specific driver-call handoff"
  },
  {
    id: "viet-phrase-v900-food-drin-do-we-order-here-or-at-the-counter",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-do-we-order-here-or-at-the-counter.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-do-we-order-here-or-at-the-counter.json",
    summary: "For figuring out whether to order at the table, counter, stall, or cashier first.",
    bodies: {
      "at-glance": "Ask before sitting down or waiting in the wrong place at a busy cafe, stall, or casual restaurant.",
      "quick-say": "Point between the table and counter if the place has no clear queue.",
      breakdown: "Chúng ta means we; đặt hàng means order; ở đây means here; hay tại quầy? means or at the counter?",
      "when-to-use": "Good at cafes, food courts, bakeries, stalls, casual restaurants, and hotel breakfast counters.",
      "good-to-know": "The answer may be a point, a number card, or a gesture toward the cashier. Watch where locals go next.",
      "explore-next": "Chili sauce, napkins, half portions, two of these, and one more phrases cover the next order step.",
      "natural-variants": "Utensil, rice, soup, sauce, lime, chili, napkin, and half portion phrases help once ordering begins."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chúng ta", english: "we", keepTogetherReason: "we pronoun" },
      { id: "chunk-2", vietnamese: "đặt hàng", english: "order", keepTogetherReason: "order verb phrase" },
      { id: "chunk-3", vietnamese: "ở đây", english: "here", keepTogetherReason: "here phrase" },
      { id: "chunk-4", vietnamese: "hay tại quầy?", english: "or at the counter?", keepTogetherReason: "counter-choice ending" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-food-drin-can-i-have-chili-sauce",
        "viet-phrase-v900-food-drin-can-i-have-napkins",
        "viet-phrase-v900-food-drin-can-i-order-half-a-portion",
        "viet-phrase-v900-food-drin-two-of-these-please",
        "viet-phrase-v900-food-drin-one-more-please"
      ]
    },
    cardParityLedger: {
      "explore-next": "matches the generator-rendered order follow-up cards instead of forcing a separate seating-flow set"
    },
    value: "turns a thin food page into a real counter-versus-table ordering decision"
  }
];

console.log(JSON.stringify(applyRepairs(35, repairs), null, 2));
