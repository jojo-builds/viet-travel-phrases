#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const repairs = [
  {
    id: "viet-phrase-help-5",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/help-5.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/help-file-report.json",
    summary: "For asking a desk, police counter, hotel, or transport office to make an official report.",
    bodies: {
      "at-glance": "A written report gives you a record for a lost item, accident, charge problem, or insurance claim.",
      "quick-say": "Show the receipt, booking, photo, or last location first so the report starts with the right incident.",
      breakdown: "Tôi cần means I need; làm biên bản means make or file an official report.",
      "when-to-use": "Good at police stations, hotel desks, transport offices, clinics, and security counters.",
      "good-to-know": "A report usually needs one clear problem, your contact details, and any proof you have. Keep the story short.",
      "explore-next": "Use I need help, please call the hotel, I need the manager, charged-twice, or translation phrases when the report becomes a recovery step.",
      "natural-variants": "I'm lost and I left something behind help when the report starts with finding what went missing."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "làm biên bản", english: "file an official report", keepTogetherReason: "official-report phrase" }
    ],
    cardTargets: {
      "natural-variants": ["viet-phrase-problems-1", "viet-phrase-problems-4"]
    },
    cardParityLedger: {
      "natural-variants": "removes one source-only duplicate helper card that was not rendered while preserving the two visible lost-item recovery cards"
    },
    value: "turns a title-repeat help page into a concrete official-report handoff"
  },
  {
    id: "viet-phrase-sight-6",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/sight-6.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/sight-book-in-advance.json",
    summary: "For checking whether a tour, ticket, or attraction needs a reservation before you show up.",
    bodies: {
      "at-glance": "Ask before walking to the entrance or committing to a time slot.",
      "quick-say": "Point to the tour, ticket window, map location, or date so the answer is about this plan.",
      breakdown: "Tôi cần means do I need; đặt trước means book in advance; không? makes it yes/no.",
      "when-to-use": "Good at tour desks, museums, boats, cooking classes, buses, and popular attractions.",
      "good-to-know": "If the answer is yes, ask about time, price, or where to book before leaving the counter.",
      "explore-next": "Ask what time it closes, where the meeting point is, where the entrance is, or where to buy tickets next.",
      "natural-variants": "Ticket price, start time, and photo-permission phrases help if booking is not needed."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "do I need / I need", keepTogetherReason: "need-question frame" },
      { id: "chunk-2", vietnamese: "đặt trước", english: "book in advance", keepTogetherReason: "advance-booking phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a generic booking prompt into a specific counter and time-slot decision"
  },
  {
    id: "viet-phrase-v500-airp-bord-arri-i-need-to-report-lost-luggage",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-i-need-to-report-lost-luggage.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-i-need-to-report-lost-luggage.json",
    summary: "For starting a missing-bag report at an airport baggage desk.",
    bodies: {
      "at-glance": "Use it with your baggage tag, passport, flight number, or bag photo ready.",
      "quick-say": "Say the phrase once, then let the tag or photo carry the detail.",
      breakdown: "Tôi cần means I need; báo cáo means report; hành lý thất lạc means lost luggage.",
      "when-to-use": "Good at baggage-service counters, airline desks, airport information desks, and transfer desks.",
      "good-to-know": "Staff may ask for the tag number, bag description, delivery address, and local phone or email.",
      "explore-next": "Pickup area, driver meetup, missing bag, domestic terminal, and visa phrases cover arrival follow-ups.",
      "natural-variants": "Immigration, baggage-claim, and SIM-card phrases help if you are still finding your way through arrivals."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "báo cáo", english: "report", keepTogetherReason: "report verb" },
      { id: "chunk-3", vietnamese: "hành lý thất lạc", english: "lost luggage", keepTogetherReason: "lost-luggage phrase" }
    ],
    value: "turns a generic arrival page into a baggage-desk report moment"
  },
  {
    id: "viet-phrase-v500-bath-pers-need-where-can-i-buy-toothpaste",
    source: "content-draft/viet/canonical-pages/catalog-promoted/bathroom-personal-needs/v500-bath-pers-need-where-can-i-buy-toothpaste.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/bathroom-personal-needs/v500-bath-pers-need-where-can-i-buy-toothpaste.json",
    summary: "For finding toothpaste at a shop, hotel desk, pharmacy, or nearby counter.",
    bodies: {
      "at-glance": "Ask near a shelf, reception desk, pharmacy counter, or convenience store entrance.",
      "quick-say": "Point to your toothbrush, mouth, or a product shelf if the word does not land.",
      breakdown: "Tôi có thể means can I; mua means buy; kem đánh răng means toothpaste; ở đâu? asks where.",
      "when-to-use": "Good at hotels, convenience stores, pharmacies, stations, and late-night counters.",
      "good-to-know": "Small shops may point you to a shelf, a pharmacy, or the nearest convenience store. Watch the gesture.",
      "explore-next": "Soap, hand-washing, water, shower, and toilet cards cover nearby bathroom-supply needs.",
      "natural-variants": "Bathroom, toilet-paper, and use-bathroom phrases help if the errand is part of a bigger washroom stop."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "mua", english: "buy", keepTogetherReason: "buying verb" },
      { id: "chunk-3", vietnamese: "kem đánh răng", english: "toothpaste", keepTogetherReason: "toothpaste noun" },
      { id: "chunk-4", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where-question ending" }
    ],
    value: "turns a bathroom-supply page into a concrete shop or hotel-desk errand"
  },
  {
    id: "viet-phrase-v500-prob-help-can-you-help-me-look-for-it",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-can-you-help-me-look-for-it.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-can-you-help-me-look-for-it.json",
    summary: "For asking staff or a nearby helper to help search for something you lost there.",
    bodies: {
      "at-glance": "Use it while pointing to the last place, table, room, car, shelf, or photo.",
      "quick-say": "Keep the item description short, then show a picture, receipt, or last location.",
      breakdown: "Bạn có thể means can you; giúp tôi tìm nó means help me look for it; được không? softens the request.",
      "when-to-use": "Good at hotels, cafes, taxis, shops, stations, and security desks.",
      "good-to-know": "People can help faster if you name the item, last place, and time in one short sequence.",
      "explore-next": "Use I need help, please call the hotel, manager, charged-twice, and report phrases if the search becomes a recovery path.",
      "natural-variants": "I'm lost and I left something behind help if the search becomes a clearer report."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "giúp tôi tìm nó", english: "help me look for it", keepTogetherReason: "help-look-for-it phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    cardTargets: {
      "natural-variants": ["viet-phrase-problems-1", "viet-phrase-problems-4"]
    },
    cardParityLedger: {
      "natural-variants": "removes one source-only duplicate helper card that was not rendered while preserving the visible lost-item recovery cards"
    },
    value: "turns a generic help prompt into a practical lost-item search request"
  },
  {
    id: "viet-phrase-v500-unde-repa-can-you-write-the-price",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-can-you-write-the-price.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-can-you-write-the-price.json",
    summary: "For asking someone to write a price so you can check the number before paying.",
    bodies: {
      "at-glance": "Use it when a spoken price is too fast, too noisy, or has too many zeros.",
      "quick-say": "Hand over your phone, calculator, or paper and wait for the number.",
      breakdown: "Bạn có thể means can you; viết giá means write the price; được không? asks politely.",
      "when-to-use": "Good at markets, taxis, repair counters, pharmacies, ticket windows, and small shops.",
      "good-to-know": "Written prices help you check zeros, currency, and whether the amount is per person or total.",
      "explore-next": "Repeat, write-it-down, meaning, which-one, and show-me phrases cover the next clarification step.",
      "natural-variants": "Understand and slower-speech phrases help if the price turns into a longer explanation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "viết giá", english: "write the price", keepTogetherReason: "write-price phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a generic understanding page into a concrete price-clarification move"
  },
  {
    id: "viet-phrase-v500-unde-repa-i-understand-a-little",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-i-understand-a-little.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-i-understand-a-little.json",
    summary: "For letting someone know you followed part of the conversation but still need patience.",
    bodies: {
      "at-glance": "Say it when you caught the basic idea but missed the exact number, word, or next step.",
      "quick-say": "Follow it with a repeat, write-it-down, or point-to-it request if you need one more clue.",
      breakdown: "Tôi hiểu means I understand; một chút means a little.",
      "when-to-use": "Good in taxis, markets, hotels, pharmacies, ticket counters, and friendly small talk.",
      "good-to-know": "It keeps the tone warm without pretending you understood everything.",
      "explore-next": "Repeat, write-it-down, meaning, which-one, and show-me phrases keep the conversation moving.",
      "natural-variants": "I-don't-understand and slower-speech phrases help when you need the whole answer again."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi hiểu", english: "I understand", keepTogetherReason: "I-understand phrase" },
      { id: "chunk-2", vietnamese: "một chút", english: "a little", keepTogetherReason: "a-little phrase" }
    ],
    value: "turns a thin repair phrase into a polite partial-understanding signal"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-where-can-i-buy-a-bottle-of-water",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-can-i-buy-a-bottle-of-water.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-can-i-buy-a-bottle-of-water.json",
    summary: "For finding bottled water inside an airport, station, hotel lobby, or nearby shop.",
    bodies: {
      "at-glance": "Ask while pointing to a kiosk, cafe, vending area, or the bottle you want.",
      "quick-say": "Keep it simple; this is a small errand, not a baggage or immigration question.",
      breakdown: "Tôi có thể means can I; mua một chai nước means buy one bottle of water; ở đâu? asks where.",
      "when-to-use": "Good after a flight, before a taxi ride, beside a station counter, or near a hotel lobby.",
      "good-to-know": "People may answer by pointing to a kiosk or convenience shelf. Follow the gesture first.",
      "explore-next": "Ask if they have bottled water, ask for one bottle, ask where to buy water, say you need bottled water, or ask to refill a bottle.",
      "natural-variants": "Immigration, baggage-claim, and SIM-card phrases help once the airport errand turns back into arrivals."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "mua một chai nước", english: "buy one bottle of water", keepTogetherReason: "bottle-of-water request" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where-question ending" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-family-food-bottled-water",
        "viet-family-service-water",
        "viet-family-v500-loca-serv-ever-task-where-can-i-buy-water",
        "viet-phrase-v500-loca-serv-ever-task-i-need-bottled-water",
        "viet-phrase-service-9"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five rendered cards from unrelated baggage/visa follow-ups to water-specific requests while preserving the arrival-context natural cards"
    },
    value: "makes the page read like a real water errand instead of airport document boilerplate"
  },
  {
    id: "viet-phrase-v900-food-drin-does-this-contain-fish-sauce",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-does-this-contain-fish-sauce.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-does-this-contain-fish-sauce.json",
    summary: "For checking fish sauce in a dish, dipping sauce, dressing, or marinade before you eat.",
    bodies: {
      "at-glance": "Ask before ordering, dipping, or accepting a sauce if fish sauce is a dietary issue for you.",
      "quick-say": "Point to the dish, sauce cup, or menu photo. Pause for a yes or no before explaining allergies.",
      breakdown: "Cái này means this one; có nước mắm means has fish sauce; không? makes it yes/no.",
      "when-to-use": "Good with dipping sauces, soups, marinades, salads, and rice dishes where fish sauce may not be obvious.",
      "good-to-know": "Fish sauce is common in Vietnamese cooking, including dressings and dipping sauces. If it is an allergy, say the allergy phrase too.",
      "explore-next": "Peanut, egg, vegetarian, and allergy phrases help with nearby dietary checks.",
      "natural-variants": "No-meat, ingredient-removal, safest-dish, meat-identification, and shrimp checks cover the same menu decision from different angles."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái này", english: "this one", keepTogetherReason: "this-one phrase" },
      { id: "chunk-2", vietnamese: "có nước mắm", english: "has fish sauce", keepTogetherReason: "fish-sauce check" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    cardTargets: {
      "when-to-use": [],
      "natural-variants": [
        "viet-phrase-food-premium-no-meat",
        "viet-phrase-food-premium-without-this-ingredient",
        "viet-phrase-food-premium-which-dish-safe",
        "viet-phrase-v900-food-drin-is-this-pork-beef-or-chicken",
        "viet-phrase-v500-food-drin-does-this-contain-shrimp"
      ]
    },
    cardParityLedger: {
      "when-to-use": "moves five dietary variant cards out of the context section so the section stays prose-only",
      "natural-variants": "preserves all five dietary variant cards in the section that describes those variants"
    },
    value: "turns a generic yes/no food page into a Vietnam-specific sauce and allergy check"
  },
  {
    id: "viet-phrase-v900-heal-phar-how-many-pills-each-time",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-how-many-pills-each-time.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-how-many-pills-each-time.json",
    summary: "For checking the number of tablets or capsules to take at one dose.",
    bodies: {
      "at-glance": "Ask before you leave the pharmacy or clinic, while the medicine is still in hand.",
      "quick-say": "Show the box or blister pack and point to one dose, not the whole day.",
      breakdown: "Mỗi lần means each time; bao nhiêu viên asks how many pills or tablets.",
      "when-to-use": "Good when instructions are spoken quickly, handwritten, or split across several medicines.",
      "good-to-know": "Confirm pills per dose separately from times per day. Those are easy to mix up.",
      "explore-next": "Ask how to take it, how many times per day, with food, before bed, or ask them to write the instructions.",
      "natural-variants": "Medicine availability, interaction, and sleepiness checks help before you accept the medicine."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Mỗi lần", english: "each time", keepTogetherReason: "each-time phrase" },
      { id: "chunk-2", vietnamese: "bao nhiêu viên?", english: "how many pills?", keepTogetherReason: "pill-count question" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v500-heal-phar-how-do-i-take-this",
        "viet-phrase-v500-heal-phar-how-many-times-per-day",
        "viet-phrase-v900-heal-phar-should-i-take-it-with-food",
        "viet-phrase-v900-heal-phar-should-i-take-it-before-bed",
        "viet-phrase-v900-heal-phar-please-write-the-instructions"
      ],
      "natural-variants": [
        "viet-phrase-v900-heal-phar-do-you-have-this-medicine",
        "viet-phrase-v900-heal-phar-please-check-for-drug-interactions",
        "viet-phrase-v900-heal-phar-will-this-make-me-sleepy"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five rendered cards from generic symptoms to dosage/instruction follow-ups while preserving card count",
      "natural-variants": "retargets three rendered cards from location help to medicine-safety checks that fit the dose question"
    },
    value: "repairs a medication dosage page and removes misleading symptom-card drift"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-have-trouble-breathing",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-have-trouble-breathing.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-have-trouble-breathing.json",
    summary: "For telling someone a breathing problem is happening now.",
    bodies: {
      "at-glance": "Use this as an urgent health phrase. Say it before giving background details.",
      "quick-say": "Show the person, inhaler, medicine, or translated emergency note if speaking is hard.",
      breakdown: "Tôi means I; khó thở means hard to breathe or trouble breathing.",
      "when-to-use": "Good at clinics, pharmacies, hotels, restaurants, stations, and anywhere someone can call help.",
      "good-to-know": "Trouble breathing is not a routine pharmacy question. If it is severe, ask for an ambulance or doctor.",
      "explore-next": "Ambulance, doctor, asthma, chest pain, and English-speaking doctor phrases cover urgent next steps.",
      "natural-variants": "Pharmacy and allergy-medicine phrases help if the first person redirects you to a counter nearby."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi", english: "I", keepTogetherReason: "subject pronoun" },
      { id: "chunk-2", vietnamese: "khó thở", english: "have trouble breathing", keepTogetherReason: "breathing-trouble phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-heal-phar-can-you-call-an-ambulance",
        "viet-family-health-doctor",
        "viet-phrase-v500-heal-phar-i-have-asthma",
        "viet-phrase-v500-heal-phar-i-have-chest-pain",
        "viet-phrase-v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis"
      ],
      "natural-variants": [
        "viet-phrase-health-1",
        "viet-phrase-health-pharmacy-clearer",
        "viet-phrase-v900-heal-phar-i-need-allergy-medicine"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five rendered cards from routine symptoms to urgent breathing, doctor, and ambulance follow-ups",
      "natural-variants": "replaces one duplicate doctor card with an allergy-medicine follow-up so rendered card depth stays intact after the urgent doctor card moved into Explore next"
    },
    value: "reframes a high-stakes symptom as urgent and removes routine headache/stomach drift"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-need-allergy-medicine",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-allergy-medicine.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-allergy-medicine.json",
    summary: "For asking a pharmacy for allergy medicine rather than general symptom help.",
    bodies: {
      "at-glance": "Use it for allergy symptoms like sneezing, itching, or hives when you need pharmacy help.",
      "quick-say": "Point to the symptom or a medicine photo so staff know the kind of allergy help you mean.",
      breakdown: "Tôi cần means I need; thuốc dị ứng means allergy medicine.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, and counters that can point you to a pharmacy.",
      "good-to-know": "If breathing, swelling, or a serious drug allergy is involved, switch to a doctor or ambulance phrase.",
      "explore-next": "Allergy, penicillin allergy, medicine availability, interaction, and safe-with-my-medicine phrases cover safer choices.",
      "natural-variants": "Doctor and pharmacy phrases help if staff cannot choose medicine at that counter."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "thuốc dị ứng", english: "allergy medicine", keepTogetherReason: "allergy-medicine noun" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-family-health-allergy",
        "viet-phrase-v900-heal-phar-i-am-allergic-to-penicillin",
        "viet-phrase-v900-heal-phar-do-you-have-this-medicine",
        "viet-phrase-v900-heal-phar-please-check-for-drug-interactions",
        "viet-phrase-v900-heal-phar-is-this-safe-with-my-medicine"
      ],
      "natural-variants": [
        "viet-family-health-doctor",
        "viet-phrase-health-1",
        "viet-family-health-pharmacy"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five rendered cards from generic symptoms to allergy and medicine-safety follow-ups",
      "natural-variants": "retargets the doctor card to the canonical health-doctor page while preserving the three visible fallback cards"
    },
    value: "turns a generic pharmacy page into an allergy-specific medicine request with safety follow-ups"
  }
];

function walkJsonFiles(dir) {
  const files = [];
  for (const name of fs.readdirSync(dir)) {
    const abs = path.join(dir, name);
    const stat = fs.statSync(abs);
    if (stat.isDirectory()) files.push(...walkJsonFiles(abs));
    else if (name.endsWith(".json")) files.push(abs);
  }
  return files;
}

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function countSectionItems(page, key) {
  return (page.sections || []).reduce((total, section) => total + ((section[key] || []).length), 0);
}

function sectionCardTargets(section) {
  return (section.phrases || []).map((card) => card.detailPageID || card.id);
}

function allCardTargets(page) {
  return (page.sections || []).flatMap(sectionCardTargets);
}

function targetsForSection(page, sectionID) {
  const section = (page.sections || []).find((item) => item.id === sectionID);
  return section ? sectionCardTargets(section) : [];
}

function withFullBreakdown(page, tokens) {
  const next = tokens.map((token) => ({ ...token }));
  const finalToken = next[next.length - 1];
  if (finalToken?.vietnamese !== page.title || finalToken?.english !== page.englishTitle) {
    next.push({
      id: "full",
      vietnamese: page.title,
      english: page.englishTitle,
      audioKey: page.audioKey ?? null
    });
  }
  return next;
}

function indexPages() {
  const byID = new Map();
  const roots = [
    path.join(repoRoot, "content-draft/viet/canonical-pages/catalog-promoted"),
    path.join(repoRoot, "content-draft/viet/canonical-pages/tier-one")
  ];
  for (const root of roots) {
    for (const absPath of walkJsonFiles(root)) {
      const page = JSON.parse(fs.readFileSync(absPath, "utf8"));
      if (page.id) byID.set(page.id, page);
    }
  }
  return byID;
}

function phraseCardFor(page) {
  return {
    id: page.phraseID,
    vietnamese: page.title,
    english: page.englishTitle,
    pronunciation: page.pronunciation,
    symbolName: page.audioKey ? "speaker.wave.2.fill" : "text.bubble.fill",
    tintName: page.tintName || "teal",
    detailPageID: page.id,
    audioKey: page.audioKey ?? null
  };
}

function updateSource(repair, pageIndex) {
  const page = readJson(repair.source);
  const before = JSON.parse(JSON.stringify(page));
  page.summary = repair.summary;
  page.sections = (page.sections || []).map((section) => {
    const next = { ...section };
    if (Object.prototype.hasOwnProperty.call(repair.bodies, section.id)) {
      next.body = repair.bodies[section.id];
    }
    if (section.id === "breakdown") {
      next.breakdown = withFullBreakdown(page, repair.breakdown);
    }
    const targets = repair.cardTargets?.[section.id];
    if (targets) {
      const existingCardsByTarget = new Map(
        (section.phrases || []).map((card) => [card.detailPageID || card.id, card])
      );
      next.phrases = targets.map((targetID) => {
        const targetPage = pageIndex.get(targetID);
        if (!targetPage) {
          const existingCard = existingCardsByTarget.get(targetID);
          if (existingCard) return existingCard;
          throw new Error(`Missing card target ${targetID} for ${repair.id}`);
        }
        return phraseCardFor(targetPage);
      });
    }
    return next;
  });
  writeJson(repair.source, page);
  return { page, before };
}

function updateAudit(repair, page) {
  const audit = readJson(repair.audit);
  audit.pageID = page.id;
  audit.phraseText = page.title;
  audit.englishTitle = page.englishTitle;
  audit.reviewStatus = "reviewed";
  audit.tokens = withFullBreakdown(page, repair.breakdown);
  writeJson(repair.audit, audit);
}

function parseCSV(text) {
  const rows = [];
  let row = [];
  let field = "";
  let quoted = false;
  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];
    if (quoted) {
      if (char === "\"" && next === "\"") {
        field += "\"";
        i += 1;
      } else if (char === "\"") {
        quoted = false;
      } else {
        field += char;
      }
    } else if (char === "\"") {
      quoted = true;
    } else if (char === ",") {
      row.push(field);
      field = "";
    } else if (char === "\n") {
      row.push(field);
      rows.push(row);
      row = [];
      field = "";
    } else if (char !== "\r") {
      field += char;
    }
  }
  if (field.length || row.length) {
    row.push(field);
    rows.push(row);
  }
  return rows.filter((item) => item.length > 1 || item[0] !== "");
}

function formatCSV(rows, bomMode) {
  const body = rows.map((row, rowIndex) => row.map((field, fieldIndex) => {
    let value = String(field ?? "");
    if (rowIndex === 0 && fieldIndex === 0) {
      value = value.replace(/^[\ufeff]+/, "");
      if (bomMode === "first-header-cell") value = `\ufeff${value}`;
    }
    return `"${value.replace(/"/g, "\"\"")}"`;
  }).join(",")).join("\n");
  return `${bomMode === "file" ? "\ufeff" : ""}${body}\n`;
}

function updateCSV(relPath, repairsByPhraseID) {
  const absPath = path.join(repoRoot, relPath);
  if (!fs.existsSync(absPath)) return 0;
  const original = fs.readFileSync(absPath, "utf8");
  const rows = parseCSV(original);
  const hasHeaderCellBOM = /^[\ufeff]+/.test(String(rows[0]?.[0] ?? "")) || original.startsWith("\"\ufeff");
  const bomMode = hasHeaderCellBOM
    ? "first-header-cell"
    : original.charCodeAt(0) === 0xfeff
      ? "file"
      : "none";
  const header = rows[0];
  const index = Object.fromEntries(header.map((name, i) => [String(name).replace(/^[\ufeff]+/, ""), i]));
  let changed = 0;
  for (let i = 1; i < rows.length; i += 1) {
    const row = rows[i];
    const repair = repairsByPhraseID.get(row[index.phrase_id]);
    if (!repair) continue;
    if (repair.summary && index.family_summary !== undefined) row[index.family_summary] = repair.summary;
    changed += 1;
  }
  if (changed) fs.writeFileSync(absPath, formatCSV(rows, bomMode));
  return changed;
}

function appendLedger(rows) {
  const existing = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const existingKeys = new Set(existing.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}:${row.sectionID}`];
    } catch {
      return [];
    }
  }));
  const freshRows = rows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}:${row.sectionID}`));
  if (freshRows.length) {
    fs.appendFileSync(ledgerPath, `${freshRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }
  return freshRows.length;
}

function main() {
  const pageIndex = indexPages();
  const repairsByPhraseID = new Map();
  const ledgerRows = [];

  for (const repair of repairs) {
    const { page, before } = updateSource(repair, pageIndex);
    updateAudit(repair, page);
    repairsByPhraseID.set(page.phraseID, repair);
    ledgerRows.push({
      batch: 34,
      tierRole: page.tierRole,
      sectionID: "page-visible-copy",
      sectionTitle: "Page visible copy",
      pageID: page.id,
      phraseID: page.phraseID,
      sourcePath: repair.source,
      before: {
        title: before.title,
        englishTitle: before.englishTitle,
        summary: before.summary,
        cardTargets: allCardTargets(before),
        phraseCardCount: countSectionItems(before, "phrases"),
        breakdownRows: countSectionItems(before, "breakdown"),
        issues: [
          "title-as-summary",
          "formulaic projection prose",
          "visible prose and breakdown trust repair"
        ]
      },
      after: {
        title: page.title,
        englishTitle: page.englishTitle,
        summary: page.summary,
        cardTargets: allCardTargets(page),
        phraseCardCount: countSectionItems(page, "phrases"),
        breakdownRows: countSectionItems(page, "breakdown"),
        sections: {
          atGlance: repair.bodies["at-glance"],
          quickSay: repair.bodies["quick-say"],
          breakdown: repair.bodies.breakdown
        }
      },
      preservedPhraseCards: countSectionItems(page, "phrases"),
      preservedBreakdownRows: countSectionItems(page, "breakdown"),
      concreteTravelerValueImproved: repair.value,
      reason: "premium_audit_batch_34_polish"
    });
    for (const [sectionID, concreteTravelerValueImproved] of Object.entries(repair.cardParityLedger || {})) {
      ledgerRows.push({
        batch: 34,
        tierRole: page.tierRole,
        sectionID: `card-parity:${sectionID}`,
        sectionTitle: "Source/render card parity",
        pageID: page.id,
        phraseID: page.phraseID,
        sourcePath: repair.source,
        before: {
          cardTargets: targetsForSection(before, sectionID)
        },
        after: {
          cardTargets: targetsForSection(page, sectionID)
        },
        preservedRenderedPhraseCards: countSectionItems(page, "phrases"),
        preservedSourcePhraseCards: countSectionItems(page, "phrases"),
        concreteTravelerValueImproved,
        reason: "premium_audit_batch_34_card_parity"
      });
    }
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-500/generated-rows.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];
  const ledgerRowsAdded = appendLedger(ledgerRows);

  console.log(JSON.stringify({
    batch: 34,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRowsAdded
  }, null, 2));
}

main();
