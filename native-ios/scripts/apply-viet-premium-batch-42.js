#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v900-airp-bord-arri-can-you-help-me-track-my-bag",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-can-you-help-me-track-my-bag.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-can-you-help-me-track-my-bag.json",
    summary: "For asking an airline or baggage-desk staffer to check where your delayed bag is now.",
    bodies: {
      "at-glance": "Ask with the baggage tag, flight number, passport, and any missing-bag report visible.",
      "quick-say": "Show the tag first, then ask the sentence. Staff may need the barcode or report number more than a long story.",
      breakdown: "Bạn có thể asks can you; giúp tôi means help me; theo dõi means track; túi của tôi means my bag.",
      "when-to-use": "Good after the belt stops, after filing a report, or when the app says the bag is still in transit.",
      "good-to-know": "If they give a status, ask where and when to check again before leaving the baggage area.",
      "explore-next": "Pickup-area, driver-meet, missing-bag, domestic-terminal, and visa cards cover the next airport move.",
      "natural-variants": "Immigration, baggage-claim, and SIM-card cards help if you are still navigating the arrival hall."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you question frame" },
      { id: "chunk-2", vietnamese: "giúp tôi", english: "help me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-3", vietnamese: "theo dõi", english: "track", keepTogetherReason: "track verb" },
      { id: "chunk-4", vietnamese: "túi của tôi?", english: "my bag?", keepTogetherReason: "my-bag phrase" }
    ],
    value: "turns a bare baggage title into a bag-tracking counter request with document context"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-is-this-the-official-taxi-line",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-is-this-the-official-taxi-line.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-is-this-the-official-taxi-line.json",
    summary: "For checking whether the taxi queue in front of you is the real airport or station line.",
    bodies: {
      "at-glance": "Ask before joining a line, following a driver, loading bags, or agreeing to a fare.",
      "quick-say": "Point at the queue or sign while you ask. A short yes, no, or gesture toward another lane is the useful answer.",
      breakdown: "Đây có phải là asks is this; tuyến taxi chính thức means the official taxi line.",
      "when-to-use": "Good outside airports, train stations, ferry piers, bus terminals, and big attractions where informal drivers approach.",
      "good-to-know": "If the answer is no, ask for the pickup area or an official counter instead of negotiating on the curb.",
      "explore-next": "Pickup-area, driver-meet, missing-bag, domestic-terminal, and visa cards cover the next arrival decision.",
      "natural-variants": "Immigration, baggage-claim, and SIM-card cards stay nearby if you need to step back inside."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải là", english: "is this", keepTogetherReason: "is-this question frame" },
      { id: "chunk-2", vietnamese: "tuyến taxi chính thức?", english: "the official taxi line?", keepTogetherReason: "official-taxi-line phrase" }
    ],
    value: "turns a title-repeat taxi page into a safer official-queue check"
  },
  {
    id: "viet-phrase-v900-dire-navi-how-long-does-it-take-by-motorbike",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-how-long-does-it-take-by-motorbike.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-how-long-does-it-take-by-motorbike.json",
    summary: "For estimating a motorbike ride before choosing between walking, taxi, bus, or waiting.",
    bodies: {
      "at-glance": "Ask with the destination on your map so the answer can be a real time, not a vague guess.",
      "quick-say": "Show the pin, then ask. If the number sounds fast, confirm whether that includes traffic or only the ride itself.",
      breakdown: "Đi xe máy means by motorbike; mất bao lâu asks how long it takes.",
      "when-to-use": "Good before booking a ride, accepting a hotel suggestion, leaving a cafe, or deciding whether a place is close enough.",
      "good-to-know": "Vietnam traffic can change quickly. A typed number or hand signal is easier to trust than a fast spoken estimate.",
      "explore-next": "Turn-left, right, straight, nearby, and walking-time cards cover the route once you choose how to go.",
      "natural-variants": "Excuse-me, how-to-get-there, and near-here cards help when you still need the path, not just the time."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đi xe máy", english: "by motorbike", keepTogetherReason: "motorbike-travel phrase" },
      { id: "chunk-2", vietnamese: "mất bao lâu?", english: "takes how long?", keepTogetherReason: "how-long ending" }
    ],
    value: "turns a generic directions page into a real ride-time decision"
  },
  {
    id: "viet-phrase-v900-emer-safe-i-think-this-is-a-scam",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v900-emer-safe-i-think-this-is-a-scam.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v900-emer-safe-i-think-this-is-a-scam.json",
    summary: "For naming a suspicious charge, ride, offer, or request when you need staff or police help.",
    bodies: {
      "at-glance": "Say it calmly with the receipt, chat, price, driver screen, or photo visible.",
      "quick-say": "Keep the claim short. The evidence on your phone or paper should do most of the explaining.",
      breakdown: "Tôi nghĩ means I think; đây là means this is; một trò lừa đảo means a scam.",
      "when-to-use": "Good at hotel desks, shops, stations, police counters, or ride pickup points when something feels dishonest or unsafe.",
      "good-to-know": "If you feel physically unsafe, move to a staffed place and use emergency, police, or help-now phrases instead.",
      "explore-next": "Unsafe, emergency, help, hospital, and passport cards cover more urgent safety paths.",
      "natural-variants": "Police, ambulance, and passport cards help when the issue needs an official report or immediate support."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi nghĩ", english: "I think", keepTogetherReason: "I-think phrase" },
      { id: "chunk-2", vietnamese: "đây là", english: "this is", keepTogetherReason: "this-is phrase" },
      { id: "chunk-3", vietnamese: "một trò lừa đảo", english: "a scam", keepTogetherReason: "scam phrase" }
    ],
    value: "turns a scaffolded emergency page into a calm scam-reporting phrase"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-hurt-my-foot",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-hurt-my-foot.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-hurt-my-foot.json",
    summary: "For explaining a foot or lower-leg injury at a pharmacy, clinic, hotel desk, or tour stop.",
    bodies: {
      "at-glance": "Point to the injured foot, shoe, swelling, scrape, or walking problem while you say it.",
      "quick-say": "Keep the line simple. If staff ask, show where it hurts, when it happened, and whether you can walk.",
      breakdown: "Tôi bị thương means I am injured; ở chân points to the foot or leg area.",
      "when-to-use": "Good after a fall, motorbike scrape, long walk, beach cut, blister, or twisted ankle.",
      "good-to-know": "If you cannot put weight on it, switch to doctor, hospital, or transport help instead of treating it like a small pharmacy errand.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea cards cover other symptom conversations.",
      "natural-variants": "Doctor and pharmacy-location cards help if the person sends you somewhere else for care."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị thương", english: "I am injured", keepTogetherReason: "injury phrase" },
      { id: "chunk-2", vietnamese: "ở chân", english: "in the foot or leg", keepTogetherReason: "foot-leg area phrase" }
    ],
    value: "turns a bare health title into a useful injury explanation with escalation context"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-need-antiseptic",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-antiseptic.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-antiseptic.json",
    summary: "For asking a pharmacy or clinic counter for antiseptic to clean a small cut, scrape, or bite.",
    bodies: {
      "at-glance": "Say the need, then show the wound or point to the kind of cleaning liquid, spray, or wipe you mean.",
      "quick-say": "Ask before accepting a random ointment. If you need bandages too, point to the cut after the first request lands.",
      breakdown: "Tôi cần means I need; thuốc sát trùng means antiseptic.",
      "when-to-use": "Good after a small fall, street scrape, insect bite, beach cut, or blister that needs cleaning.",
      "good-to-know": "Mention allergies or sensitive skin if you know them. If the wound is deep or infected, ask for a doctor.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea cards cover other pharmacy needs.",
      "natural-variants": "Doctor and pharmacy-location cards help when the counter cannot supply the right item."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "thuốc sát trùng", english: "antiseptic", keepTogetherReason: "antiseptic phrase" }
    ],
    value: "turns a generic medicine page into a wound-care pharmacy request"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-was-bitten-by-an-insect",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-was-bitten-by-an-insect.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-was-bitten-by-an-insect.json",
    summary: "For explaining an insect bite when you need cream, advice, or help judging whether it is serious.",
    bodies: {
      "at-glance": "Show the bite if appropriate, or point to the affected area and say when it happened.",
      "quick-say": "Keep the sentence short. If there is swelling, fever, dizziness, or breathing trouble, move to urgent help.",
      breakdown: "Tôi bị means I was or got; côn trùng cắn means bitten by an insect.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, and tour counters after mosquito, ant, bee, or unknown insect bites.",
      "good-to-know": "A normal itch and a spreading reaction are different problems. Show the change if the bite is getting worse.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea cards cover other symptom details.",
      "natural-variants": "Doctor and pharmacy-location cards help if staff suggest in-person care."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I was / got", keepTogetherReason: "I-was phrase" },
      { id: "chunk-2", vietnamese: "côn trùng cắn", english: "bitten by an insect", keepTogetherReason: "insect-bite phrase" }
    ],
    value: "turns a title repeat into a bite-care page with symptom escalation"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-how-much-per-kilo-for-laundry",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-how-much-per-kilo-for-laundry.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-how-much-per-kilo-for-laundry.json",
    summary: "For checking the laundry price before handing over a bag of clothes.",
    bodies: {
      "at-glance": "Ask while the bag is still with you, before the shop weighs it, writes the ticket, or separates express service.",
      "quick-say": "Point to the laundry bag and the scale if there is one. Ask for the price by kilo before agreeing to wash, dry, or iron.",
      breakdown: "Giặt đồ means laundry or washing clothes; bao nhiêu asks how much; một kg means per kilo.",
      "when-to-use": "Good at laundry shops, homestays, hotel desks, and travel counters that charge by weight.",
      "good-to-know": "Express service, ironing, or delicate items can change the price. Ask for the total and pickup time together.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and printing cards cover the errand-counter path.",
      "natural-variants": "Water, bag, and tissues cards stay useful at the same small shop or hotel desk."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Giặt đồ", english: "laundry / washing clothes", keepTogetherReason: "laundry phrase" },
      { id: "chunk-2", vietnamese: "bao nhiêu", english: "how much", keepTogetherReason: "how-much phrase" },
      { id: "chunk-3", vietnamese: "một kg?", english: "per kilo?", keepTogetherReason: "per-kilo phrase" }
    ],
    value: "turns a repeated service page into a concrete laundry price check"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-can-you-give-me-a-better-price",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-can-you-give-me-a-better-price.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-can-you-give-me-a-better-price.json",
    summary: "For making a polite bargain when the price feels flexible but you still want the exchange to stay friendly.",
    bodies: {
      "at-glance": "Ask once with the item in view, then wait for a number, head shake, or counteroffer.",
      "quick-say": "Keep your tone light. This works at markets and small shops, not at fixed-price counters with printed signs.",
      breakdown: "Bạn có thể asks can you; cho tôi means give me; một mức giá tốt hơn means a better price.",
      "when-to-use": "Good for souvenirs, clothing, small services, and market items where bargaining is normal.",
      "good-to-know": "If they say no, smile and decide whether to accept, walk away, or ask for a smaller item.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover the bargaining follow-up.",
      "natural-variants": "How-much and per-kilo cards help when you still need the base price first."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you question frame" },
      { id: "chunk-2", vietnamese: "cho tôi", english: "give me", keepTogetherReason: "give-me phrase" },
      { id: "chunk-3", vietnamese: "một mức giá tốt hơn?", english: "a better price?", keepTogetherReason: "better-price phrase" }
    ],
    value: "turns a generic bargain line into a culturally softer price-negotiation page"
  },
  {
    id: "viet-phrase-v900-phon-inte-powe-where-can-i-buy-a-power-bank",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-where-can-i-buy-a-power-bank.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-where-can-i-buy-a-power-bank.json",
    summary: "For finding a portable battery before your phone dies during a ride, tour, or long walk.",
    bodies: {
      "at-glance": "Ask with your low-battery screen visible. Staff may point to a phone shop, mini-mart, mall floor, or charger shelf.",
      "quick-say": "Show a photo of a power bank if the word does not land. The answer is usually a nearby shop or shelf, not a long explanation.",
      breakdown: "Tôi có thể mua asks where can I buy; sạc dự phòng means power bank; ở đâu asks where.",
      "when-to-use": "Good at cafes, hotels, SIM shops, malls, airports, convenience stores, and tour stops when battery matters.",
      "good-to-know": "Check cable type and charging speed before paying; the cheapest battery may not help your phone in time.",
      "explore-next": "Dead-battery, charger, charge-here, Wi-Fi, and SIM cards cover the rest of the phone-and-power problem.",
      "natural-variants": "Wi-Fi-password and SIM-card cards help if the same shop can solve more than battery."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể mua", english: "where can I buy", keepTogetherReason: "can-I-buy question frame" },
      { id: "chunk-2", vietnamese: "sạc dự phòng", english: "power bank", keepTogetherReason: "power-bank phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where ending" }
    ],
    value: "turns a formulaic phone page into a low-battery errand page and fixes wrong chunk meanings"
  },
  {
    id: "viet-phrase-v900-time-date-book-how-many-people-are-ahead-of-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-how-many-people-are-ahead-of-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-how-many-people-are-ahead-of-me.json",
    summary: "For checking your place in a queue before deciding whether to wait, leave, or come back.",
    bodies: {
      "at-glance": "Ask while you still have the ticket number, queue screen, line, or waiting area in view.",
      "quick-say": "Point to yourself and the line if needed. The useful answer is a number or a rough wait time.",
      breakdown: "Có bao nhiêu asks how many; người means people; đang ở phía trước tôi means are ahead of me.",
      "when-to-use": "Good at clinics, restaurants, ticket counters, salons, ferries, and tour desks where the line is unclear.",
      "good-to-know": "If the number is high, ask about the wait time before losing your place or leaving the area.",
      "explore-next": "Booking, opening-time, move-it-later, boarding-time, and wait-list cards cover scheduling after the queue answer.",
      "natural-variants": "What-time, today, and tomorrow-morning cards help if waiting today is not worth it."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có bao nhiêu", english: "how many", keepTogetherReason: "how-many phrase" },
      { id: "chunk-2", vietnamese: "người", english: "people", keepTogetherReason: "people noun" },
      { id: "chunk-3", vietnamese: "đang ở phía trước tôi?", english: "are ahead of me?", keepTogetherReason: "ahead-of-me phrase" }
    ],
    value: "turns a repeated booking page into a queue-position decision"
  },
  {
    id: "viet-phrase-airport-7",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/airport-7.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/airport-domestic-terminal.json",
    summary: "For finding the domestic terminal before a transfer, pickup, ticket change, or wrong-building mistake.",
    bodies: {
      "at-glance": "Ask with the flight number, airline, ticket, or pickup screen visible so staff can point to the correct building.",
      "quick-say": "Show the domestic flight detail first. The answer may be a shuttle, walkway, floor, or separate terminal entrance.",
      breakdown: "Nhà ga nội địa means domestic terminal; ở đâu asks where.",
      "when-to-use": "Good after an international arrival, before a domestic connection, or when a driver drops you at the wrong airport door.",
      "good-to-know": "Some airports separate domestic and international areas by shuttle or a long walk. Confirm before dragging luggage across the terminal.",
      "explore-next": "Pickup-area, driver-meet, missing-bag, visa, and ATM cards cover common airport follow-ups.",
      "natural-variants": "Immigration, baggage-claim, and SIM-card cards help if you still need arrival-hall basics."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Nhà ga nội địa", english: "domestic terminal", keepTogetherReason: "domestic-terminal phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where ending" }
    ],
    value: "turns a bare airport title into a transfer-specific domestic-terminal page"
  }
];

console.log(JSON.stringify(applyRepairs(42, repairs), null, 2));
