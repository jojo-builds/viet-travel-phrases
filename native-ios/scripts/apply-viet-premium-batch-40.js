#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v900-dire-navi-which-entrance-should-i-use",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-which-entrance-should-i-use.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-which-entrance-should-i-use.json",
    summary: "For choosing the correct entrance before a station, attraction, hotel, or pickup point splits into several doors.",
    bodies: {
      "at-glance": "Ask while the sign, door, gate number, or map location is still in front of you.",
      "quick-say": "Show the entrance you mean, then ask the question. A point, head shake, or short correction is enough before you move.",
      breakdown: "Tôi nên means I should; sử dụng lối vào nào asks which entrance to use.",
      "when-to-use": "Good at stations, malls, museums, hotels, parking areas, and attractions with several entry points.",
      "good-to-know": "If staff answer with a floor, gate, or street name, ask them to point before you walk away.",
      "explore-next": "Left, right, straight, pickup-point, and understand-now phrases cover the next route move.",
      "natural-variants": "If the answer becomes a longer route, ask how to get there, whether it is nearby, or how long the walk takes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi nên", english: "I should", keepTogetherReason: "I-should phrase" },
      { id: "chunk-2", vietnamese: "sử dụng", english: "use", keepTogetherReason: "use verb" },
      { id: "chunk-3", vietnamese: "lối vào nào?", english: "which entrance?", keepTogetherReason: "which-entrance phrase" }
    ],
    value: "turns a title-repeat entrance page into a concrete multi-door navigation check"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-need-pain-medicine",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-pain-medicine.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-pain-medicine.json",
    summary: "For asking a pharmacy or clinic counter for basic pain medicine without starting a long symptom story.",
    bodies: {
      "at-glance": "Say the need first, then point to the sore place, note, or translated symptom if staff ask.",
      "quick-say": "Keep the line short. The headache, stomach pain, allergy, or current medicine can come after staff understand the request.",
      breakdown: "Tôi cần means I need; thuốc giảm đau means pain medicine.",
      "when-to-use": "Good at pharmacies, hotel desks, clinics, and travel counters when you need a simple over-the-counter option.",
      "good-to-know": "Mention allergies, pregnancy, blood pressure, or other medicine before accepting a pill packet.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea cards cover the symptom follow-up.",
      "natural-variants": "Doctor and pharmacy-location cards help if the counter cannot handle the request."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "thuốc giảm đau", english: "pain medicine", keepTogetherReason: "pain-medicine phrase" }
    ],
    value: "turns a bare medicine title into a pharmacy-counter request with safety context"
  },
  {
    id: "viet-phrase-v900-heal-phar-when-should-i-seek-emergency-help",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-when-should-i-seek-emergency-help.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-when-should-i-seek-emergency-help.json",
    summary: "For asking when symptoms are serious enough to go to emergency care instead of waiting.",
    bodies: {
      "at-glance": "The symptom or medicine is already visible. Ask while the pharmacist, clinic staffer, hotel desk, or helper is focused on that detail.",
      "quick-say": "Show the symptom note, medicine packet, or affected area first. Then ask when emergency help becomes the right next step.",
      breakdown: "Khi nào asks when; tôi nên asks should I; sự giúp đỡ khẩn cấp means emergency help.",
      "when-to-use": "Good when pain, fever, breathing, allergic reaction, injury, or food poisoning feels beyond a simple pharmacy answer.",
      "good-to-know": "If the answer sounds urgent, switch to ambulance, hospital, or doctor phrases instead of asking more detail.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea cards cover symptom details if the situation stays non-urgent.",
      "natural-variants": "Doctor and pharmacy-location cards cover the safer handoff if staff say you need in-person care."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Khi nào", english: "when", keepTogetherReason: "when question word" },
      { id: "chunk-2", vietnamese: "tôi nên", english: "should I", keepTogetherReason: "should-I phrase" },
      { id: "chunk-3", vietnamese: "tìm kiếm", english: "seek / look for", keepTogetherReason: "seek phrase" },
      { id: "chunk-4", vietnamese: "sự giúp đỡ khẩn cấp?", english: "emergency help?", keepTogetherReason: "emergency-help phrase" }
    ],
    value: "replaces a wrong ticket/date scaffold with a real health-escalation question"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-where-can-i-buy-sunscreen",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-buy-sunscreen.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-buy-sunscreen.json",
    summary: "For finding sunscreen at a pharmacy, mini-mart, hotel desk, beach shop, or tour stop.",
    bodies: {
      "at-glance": "Ask before you start hunting through shelves. The answer is usually a shelf, shop name, or nearby street.",
      "quick-say": "Say the question and show a sunscreen photo if the word does not land. Staff can point you to the shelf or a nearby store.",
      breakdown: "Tôi có thể mua asks where can I buy; kem chống nắng means sunscreen; ở đâu asks where.",
      "when-to-use": "Good before beach days, motorbike rides, outdoor tours, market walks, and long sunny transfers.",
      "good-to-know": "If they point to whitening lotion or after-sun gel, show the SPF number you need.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and printing cards cover the nearby counter path.",
      "natural-variants": "Water, bag, and tissues cards cover the same quick errand stop."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể mua", english: "where can I buy", keepTogetherReason: "can-I-buy question frame" },
      { id: "chunk-2", vietnamese: "kem chống nắng", english: "sunscreen", keepTogetherReason: "sunscreen phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where ending" }
    ],
    value: "turns a generic service locator into a specific sunscreen errand page"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-please-do-not-tap-again",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-please-do-not-tap-again.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-please-do-not-tap-again.json",
    summary: "For stopping a second keypad, card-reader, or phone-screen tap before a payment goes through twice.",
    bodies: {
      "at-glance": "Someone is reaching for the screen again, and the payment moment needs to pause.",
      "quick-say": "Keep your card, phone, receipt, or terminal screen visible. Point to the pending payment before repeating the sentence.",
      breakdown: "Làm ơn means please; đừng means do not; gõ nữa means tap or type again.",
      "when-to-use": "Good at card readers, QR payments, ATMs, ticket counters, and small shops when one more tap could create confusion.",
      "good-to-know": "After the pause, show the receipt, app status, or bank notification before deciding whether to try again.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover ordinary price follow-ups.",
      "natural-variants": "How-much and per-kilo cards help when the issue is price clarity rather than a payment tap."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Làm ơn", english: "please", keepTogetherReason: "fixed polite phrase" },
      { id: "chunk-2", vietnamese: "đừng", english: "do not", keepTogetherReason: "negative command" },
      { id: "chunk-3", vietnamese: "gõ nữa", english: "tap / type again", keepTogetherReason: "do-not-tap-again phrase" }
    ],
    value: "turns a vague money page into a duplicate-payment pause"
  },
  {
    id: "viet-phrase-v900-sigh-acti-is-this-area-safe-at-night",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-this-area-safe-at-night.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-this-area-safe-at-night.json",
    summary: "For checking nighttime safety before walking, waiting, or choosing a route after dark.",
    bodies: {
      "at-glance": "Ask before leaving a lit lobby, cafe, station, restaurant, or ride pickup.",
      "quick-say": "Show the map area or street name while you ask. A short yes, no, or safer-route suggestion is the useful answer.",
      breakdown: "Khu vực này means this area; an toàn means safe; vào ban đêm means at night.",
      "when-to-use": "Good before walking back, waiting outside, crossing a quiet street, or deciding whether to call a ride.",
      "good-to-know": "If the answer is uncertain, ask for a safer route, pickup point, or nearby landmark instead of pushing ahead.",
      "explore-next": "Closing-time, meeting-point, advance-booking, tour-booking, and entrance cards cover the attraction side of the decision.",
      "natural-variants": "Ticket, start-point, and photo-permission cards cover safer daytime attraction questions."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Khu vực này", english: "this area", keepTogetherReason: "this-area phrase" },
      { id: "chunk-2", vietnamese: "có an toàn", english: "is safe", keepTogetherReason: "safe yes-no phrase" },
      { id: "chunk-3", vietnamese: "vào ban đêm", english: "at night", keepTogetherReason: "at-night phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a generic yes/no attraction page into a nighttime safety check and fixes bad at-night chunks"
  },
  {
    id: "viet-phrase-v900-sigh-acti-is-this-the-right-entrance",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-this-the-right-entrance.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-this-the-right-entrance.json",
    summary: "For confirming the entrance you are standing at before tickets, security, or a tour meeting point.",
    bodies: {
      "at-glance": "Ask while the doorway, sign, ticket line, or map location is visible.",
      "quick-say": "Point to the entrance and ask once. If staff point somewhere else, switch to directions instead of repeating.",
      breakdown: "Đây có phải là asks is this; lối vào bên phải means the right-side entrance; không? makes it a yes/no question.",
      "when-to-use": "Good at museums, temples, parks, theaters, tour offices, ferry piers, and sites with separate gates.",
      "good-to-know": "If your ticket has a gate number or time slot, show it before walking to the next entrance.",
      "explore-next": "Closing-time, meeting-point, advance-booking, tour-booking, and entrance cards cover the next attraction step.",
      "natural-variants": "Ticket, start-point, and photo-permission cards cover the broader sightseeing exchange."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải là", english: "is this", keepTogetherReason: "is-this question frame" },
      { id: "chunk-2", vietnamese: "lối vào bên phải", english: "right-side entrance", keepTogetherReason: "right-side entrance phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a title-repeat entrance page into a ticket/gate check and clarifies right-side wording"
  },
  {
    id: "viet-phrase-v500-prob-help-can-you-call-security",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-can-you-call-security.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-can-you-call-security.json",
    summary: "For asking a desk, guard, shop, hotel, or station staffer to call security calmly and directly.",
    bodies: {
      "at-glance": "You need another person brought in, not a long explanation from you.",
      "quick-say": "Say the line once and keep the person, bag, room, receipt, or location visible if it helps staff understand.",
      breakdown: "Bạn có thể asks can you; gọi bảo vệ means call security; được không asks is that possible.",
      "when-to-use": "Good at hotels, malls, stations, bars, shops, and venues when staff need to involve security.",
      "good-to-know": "Stay near a staffed counter or visible place while the request is being handled.",
      "explore-next": "Need-help, call-hotel, manager, double-charge, and report cards cover the practical help path.",
      "natural-variants": "If the situation is less urgent, ask for help finding your way or recovering something left behind."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you question frame" },
      { id: "chunk-2", vietnamese: "gọi bảo vệ", english: "call security", keepTogetherReason: "call-security phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite possibility ending" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-problems-1",
        "viet-phrase-problems-4"
      ]
    },
    cardParityLedger: {
      "natural-variants": "aligns source to the rendered lower-pressure help cards; the source-only need-help card was already omitted by the app"
    },
    value: "turns a bare security question into a calm staffed-counter safety request"
  },
  {
    id: "viet-phrase-v500-prob-help-please-write-down-your-name",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-please-write-down-your-name.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-please-write-down-your-name.json",
    summary: "For asking someone to write their name clearly when a report, receipt, handoff, or follow-up depends on it.",
    bodies: {
      "at-glance": "Ask before leaving the counter if you may need to identify who helped you later.",
      "quick-say": "Offer your phone, paper, receipt, or form while you ask. The name matters more than a spoken repeat.",
      breakdown: "Hãy viết means please write; tên của bạn means your name.",
      "when-to-use": "Good for hotel desks, police or security reports, delivery handoffs, repair counters, clinics, and ticket offices.",
      "good-to-know": "Ask for the name before the moment ends; it is harder to recover after you leave.",
      "explore-next": "Need-help, call-hotel, manager, double-charge, and report cards cover the follow-up path after a name is recorded.",
      "natural-variants": "Lost-way and left-behind-item phrases cover nearby help situations."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy viết", english: "please write", keepTogetherReason: "please-write phrase" },
      { id: "chunk-2", vietnamese: "tên của bạn", english: "your name", keepTogetherReason: "your-name phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-problems-1",
        "viet-phrase-problems-4"
      ]
    },
    cardParityLedger: {
      "natural-variants": "aligns source to the rendered lost/left-behind help cards; the source-only need-help card was already omitted by the app"
    },
    value: "turns a generic write-name page into a report/handoff record request"
  },
  {
    id: "viet-phrase-v500-tran-please-call-the-driver",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-call-the-driver.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-please-call-the-driver.json",
    summary: "For asking hotel, station, restaurant, or pickup staff to call the driver when the ride is hard to find.",
    bodies: {
      "at-glance": "Keep the ride screen, phone number, plate number, or pickup address open.",
      "quick-say": "Say the line and show the driver detail. Staff may only need to tap the number or confirm the plate.",
      breakdown: "Vui lòng means please; gọi tài xế means call the driver.",
      "when-to-use": "Good at ride-app pickups, hotel lobbies, bus counters, restaurants, and places where the driver is circling nearby.",
      "good-to-know": "If the driver answers, point to the pickup spot or address before the call ends.",
      "explore-next": "Stop-here, route, air-conditioning, waiting, and cash cards cover the ride after contact is made.",
      "natural-variants": "Take-me-here, District 1, and stop-here cards cover spoken backups if the call does not solve it."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "fixed polite phrase" },
      { id: "chunk-2", vietnamese: "gọi tài xế", english: "call the driver", keepTogetherReason: "call-driver phrase" }
    ],
    value: "turns a generic taxi helper page into a concrete ride-screen handoff"
  },
  {
    id: "viet-phrase-v500-unde-repa-is-that-good-or-bad",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-is-that-good-or-bad.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-is-that-good-or-bad.json",
    summary: "For checking whether the answer you just received is good news, bad news, or a warning.",
    bodies: {
      "at-glance": "Use it after someone explains a delay, price, route, repair, test result, or problem and you cannot read the tone.",
      "quick-say": "Point to the message, receipt, map, or item while you ask. Let the other person answer with a gesture or simpler word.",
      breakdown: "Điều đó means that thing; tốt hay xấu asks good or bad.",
      "when-to-use": "Good when the words were understandable but the meaning was not clear enough to decide what to do next.",
      "good-to-know": "If the answer still feels vague, ask them to write, show, or point to the next step.",
      "explore-next": "If the answer still feels unclear, ask them to repeat it, write it, explain it, point to the right one, or show you.",
      "natural-variants": "I-don't-understand and slower-speech cards cover the moment before you can judge the answer."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Điều đó", english: "that thing / that", keepTogetherReason: "that-thing phrase" },
      { id: "chunk-2", vietnamese: "tốt hay xấu?", english: "good or bad?", keepTogetherReason: "good-or-bad phrase" }
    ],
    value: "turns a generic repair page into a tone/meaning check after an unclear answer"
  },
  {
    id: "viet-phrase-v500-unde-repa-is-that-the-final-total",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-is-that-the-final-total.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-is-that-the-final-total.json",
    summary: "For checking the final payable amount before handing over cash, tapping a card, or accepting a receipt.",
    bodies: {
      "at-glance": "Ask while the calculator, bill, QR amount, receipt, or terminal screen is still visible.",
      "quick-say": "Point to the number and ask once. Wait for the final amount before paying or agreeing to another tap.",
      breakdown: "Đó có phải là asks is that; tổng số cuối cùng means the final total.",
      "when-to-use": "Good at restaurants, markets, taxis, ticket counters, hotels, and clinics when extra fees may have been added.",
      "good-to-know": "If the number changes, ask them to write it or show the receipt before paying.",
      "explore-next": "If the number is still unclear, ask them to repeat it, write it, explain it, point to the right one, or show you.",
      "natural-variants": "I-don't-understand and slower-speech cards help when the price explanation is still too fast."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đó có phải là", english: "is that", keepTogetherReason: "is-that question frame" },
      { id: "chunk-2", vietnamese: "tổng số cuối cùng?", english: "the final total?", keepTogetherReason: "final-total phrase" }
    ],
    value: "turns a generic repair page into a concrete final-payment check and fixes final-total chunks"
  }
];

const result = applyRepairs(40, repairs);
console.log(JSON.stringify(result, null, 2));
