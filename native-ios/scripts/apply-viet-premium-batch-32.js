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
    id: "viet-phrase-social-9",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/social-9.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/social-small-talk/social-recommend.json",
    summary: "For asking a local, host, server, or shopkeeper what they would pick nearby.",
    bodies: {
      "at-glance": "A recommendation question works best when you are choosing between real options in front of you.",
      "quick-say": "Point to the menu, shelf, street, or counter area so the answer stays practical.",
      breakdown: "Bạn means you; gợi ý means suggest or recommend; gì ở đây? means what here?",
      "natural-variants": "Country and first-time phrases keep the chat warm if the answer turns into small talk.",
      "when-to-use": "Good at cafes, markets, homestays, hotel desks, food stalls, and small shops.",
      "good-to-know": "People may answer by pointing, naming one item, or asking what you like. Watch the gesture as much as the words.",
      "explore-next": "Vietnam, food, weather, how-are-you, and how-long-staying phrases cover the friendly turn after the recommendation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn", english: "you" },
      { id: "chunk-2", vietnamese: "gợi ý", english: "suggest / recommend", keepTogetherReason: "recommendation verb" },
      { id: "chunk-3", vietnamese: "gì ở đây?", english: "what here?", keepTogetherReason: "what-here phrase" }
    ],
    value: "turns a title-only small-talk page into a real recommendation moment"
  },
  {
    id: "viet-phrase-v500-dire-navi-where-is-the-bus-stop",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-where-is-the-bus-stop.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-where-is-the-bus-stop.json",
    summary: "For finding the right bus stop before you start walking the wrong way.",
    bodies: {
      "at-glance": "Ask while the street, route number, or map is still visible.",
      "quick-say": "Say the question, then let the pointing or street-name answer land before asking more.",
      breakdown: "Trạm xe buýt means bus stop; ở đâu? asks where.",
      "natural-variants": "Excuse me, how-to-get-there, nearby, and walking-time phrases help if they point you down the street.",
      "when-to-use": "Good at street corners, station exits, hotel desks, and ticket counters.",
      "good-to-know": "Bus stops may be signed, tucked into a curb lane, or described by a nearby building. A map screenshot helps.",
      "explore-next": "Left, right, straight, understand-now, and pickup-point phrases cover the next direction check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Trạm xe buýt", english: "bus stop", keepTogetherReason: "bus-stop noun" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "replaces generic direction prose and fixes the bad bus-stop breakdown gloss"
  },
  {
    id: "viet-phrase-v500-food-drin-please-make-it-without-peanuts",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-please-make-it-without-peanuts.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v500-food-drin-please-make-it-without-peanuts.json",
    summary: "For asking staff to leave peanuts out before the dish is cooked or assembled.",
    bodies: {
      "at-glance": "Say it before ordering, then point to the dish so staff know which item needs the change.",
      "quick-say": "Keep the wording short and serious; if it is an allergy, say the allergy phrase too.",
      breakdown: "Hãy làm món này means please make this dish; mà không cần đậu phộng means without peanuts.",
      "when-to-use": "Good at street stalls, casual restaurants, cafes, and counters where toppings or sauces are adjusted.",
      "good-to-know": "Peanuts can appear as garnish, sauce, or crunch. Pointing at the dish helps, but allergy wording matters if the risk is medical.",
      "explore-next": "Fish sauce, meat, ingredient, allergy, and shrimp checks keep the order precise if staff ask what to change.",
      "natural-variants": "No-meat, no-this-ingredient, safe-for-allergy, pork-beef-chicken, and shrimp phrases keep the food question specific."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy làm món này", english: "please make this dish", keepTogetherReason: "make-this-dish phrase" },
      { id: "chunk-2", vietnamese: "mà không cần", english: "without / not needing", keepTogetherReason: "without phrase" },
      { id: "chunk-3", vietnamese: "đậu phộng", english: "peanuts", keepTogetherReason: "peanut noun" }
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
      "explore-next": "aligns source to the richer rendered allergy follow-up set while preserving all 11 visible cards"
    },
    value: "makes the peanut request clear and keeps the allergy/ingredient follow-up path rich"
  },
  {
    id: "viet-phrase-v500-heal-phar-how-many-times-per-day",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-how-many-times-per-day.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v500-heal-phar-how-many-times-per-day.json",
    summary: "For checking medicine frequency before you leave the pharmacy or clinic.",
    bodies: {
      "at-glance": "Ask while the packet, bottle, or prescription is still on the counter.",
      "quick-say": "Point to the medicine and wait for the number; then ask them to write it if needed.",
      breakdown: "Bao nhiêu lần asks how many times; mỗi ngày? means each day?",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy phrases help if the dose question reveals you need more help.",
      "when-to-use": "Good when instructions are spoken quickly or the label is not clear enough to trust.",
      "good-to-know": "Numbers matter here. If you hear one, two, or three, confirm with fingers or ask for written instructions.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea phrases cover common pharmacy branches."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bao nhiêu lần", english: "how many times", keepTogetherReason: "frequency question" },
      { id: "chunk-2", vietnamese: "mỗi ngày?", english: "each day / per day?", keepTogetherReason: "per-day phrase" }
    ],
    value: "turns the dose question into a concrete pharmacy safety check"
  },
  {
    id: "viet-phrase-v500-loca-serv-ever-task-i-need-bottled-water",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-i-need-bottled-water.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-i-need-bottled-water.json",
    summary: "For asking for sealed drinking water at a shop, hotel desk, stall, or counter.",
    bodies: {
      "at-glance": "Use this when you need bottled water, not a glass or refill.",
      "quick-say": "Point to a bottle size, fridge, shelf, or room-service tray if there is more than one option.",
      breakdown: "Tôi cần means I need; nước đóng chai means bottled water.",
      "natural-variants": "Bottle-of-water, bag, and tissues phrases cover nearby counter requests.",
      "when-to-use": "Good at convenience stores, hotel desks, pharmacies, cafes, bus stops, and airport counters.",
      "good-to-know": "If the answer is a price or size, point to the bottle you want and keep the exchange simple.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and print-this phrases cover common small errand follow-ups."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "nước đóng chai", english: "bottled water", keepTogetherReason: "bottled-water noun" }
    ],
    value: "removes generic service-counter copy and makes the bottled-water ask specific"
  },
  {
    id: "viet-phrase-v500-loca-serv-ever-task-is-there-an-elevator",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-is-there-an-elevator.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-is-there-an-elevator.json",
    summary: "For checking lift access before carrying bags, entering a building, or choosing stairs.",
    bodies: {
      "at-glance": "Ask before committing to stairs, especially with luggage, heat, injury, or an upper-floor address.",
      "quick-say": "Point toward the lobby, stairwell, or floor number so the answer is about this building.",
      breakdown: "Có means there is or has; thang máy means elevator; không? makes it yes/no.",
      "natural-variants": "Elevator-location, ramp, and upstairs phrases cover nearby access questions.",
      "when-to-use": "Good at hotels, apartment lobbies, clinics, malls, stations, and small office buildings.",
      "good-to-know": "If there is no elevator, ask for the floor, a ramp, or help with bags before moving on.",
      "explore-next": "Downstairs, back-entrance, write-address, quieter-seat, and cooler-seat phrases cover practical reroutes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "is there / has" },
      { id: "chunk-2", vietnamese: "thang máy", english: "elevator", keepTogetherReason: "elevator noun" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-dire-navi-where-is-the-elevator",
        "viet-phrase-v500-loca-serv-ever-task-is-there-a-ramp",
        "viet-phrase-v500-dire-navi-do-i-go-upstairs"
      ],
      "explore-next": [
        "viet-phrase-v500-dire-navi-do-i-go-downstairs",
        "viet-phrase-v900-dire-navi-where-is-the-back-entrance",
        "viet-phrase-v500-unde-repa-can-you-write-the-address",
        "viet-phrase-v900-loca-serv-ever-task-can-we-sit-somewhere-quieter",
        "viet-phrase-v900-loca-serv-ever-task-can-we-sit-somewhere-cooler"
      ]
    },
    value: "replaces unrelated errand cards with access and building-navigation follow-ups"
  },
  {
    id: "viet-phrase-v500-prob-help-my-phone-is-missing",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-my-phone-is-missing.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-my-phone-is-missing.json",
    summary: "For telling staff or a helper that your phone is missing and you need help finding or reporting it.",
    bodies: {
      "at-glance": "Say the problem clearly, then show the last place, receipt, booking, or device photo if you have one.",
      "quick-say": "Keep the first sentence calm. The next step may be calling the phone, checking a counter, or filing a report.",
      breakdown: "Điện thoại means phone; của tôi means my; bị mất means is lost or missing.",
      "natural-variants": "Lost, left-something, and need-help phrases keep the first recovery step simple.",
      "when-to-use": "Good at hotel desks, cafes, taxis, shops, stations, and police or security counters.",
      "good-to-know": "A short phrase plus a map, photo, receipt, or ride screen usually works better than a long explanation.",
      "explore-next": "Need-help, call-hotel, manager, charged-twice, and file-report phrases cover the recovery path."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Điện thoại", english: "phone", keepTogetherReason: "phone noun" },
      { id: "chunk-2", vietnamese: "của tôi", english: "my / mine", keepTogetherReason: "my phrase" },
      { id: "chunk-3", vietnamese: "bị mất", english: "is lost / missing", keepTogetherReason: "lost/missing phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-problems-1",
        "viet-phrase-problems-4"
      ]
    },
    cardParityLedger: {
      "natural-variants": "removes a non-rendered duplicate helper-family card while keeping the rendered direct need-help recovery path"
    },
    value: "makes the missing-phone page a recovery handoff instead of generic help prose"
  },
  {
    id: "viet-phrase-v500-soci-smal-talk-where-can-i-buy-a-raincoat",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-where-can-i-buy-a-raincoat.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-where-can-i-buy-a-raincoat.json",
    summary: "For finding rain gear fast when the weather turns and you are still out walking.",
    bodies: {
      "at-glance": "Ask near a shop, hotel desk, market stall, cafe counter, or station exit when rain is starting.",
      "quick-say": "Point outside or show your wet bag so the request is about immediate rain gear.",
      breakdown: "Tôi có thể means can I; mua áo mưa means buy a raincoat; ở đâu? asks where.",
      "natural-variants": "Rain poncho, umbrella, and will-it-rain phrases cover the same weather moment.",
      "when-to-use": "Good before a walk, motorbike ride, market stop, or open-air transfer in sudden rain.",
      "good-to-know": "Small shops may offer ponchos, umbrellas, or lightweight raincoats. Point to the option you mean.",
      "explore-next": "Wait-out-rain, sunscreen, bottled-water, bag, and card-payment phrases cover nearby small errand turns."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "mua áo mưa", english: "buy a raincoat", keepTogetherReason: "buy-raincoat phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-loca-serv-ever-task-i-need-a-rain-poncho",
        "viet-phrase-v500-loca-serv-ever-task-i-need-an-umbrella",
        "viet-phrase-v500-soci-smal-talk-will-it-rain-today"
      ],
      "explore-next": [
        "viet-phrase-v500-soci-smal-talk-where-can-i-wait-out-the-rain",
        "viet-phrase-v900-loca-serv-ever-task-where-can-i-buy-sunscreen",
        "viet-family-service-water",
        "viet-family-service-bag",
        "viet-family-service-card"
      ]
    },
    value: "moves the raincoat page away from small-talk filler into real weather and shop follow-ups"
  },
  {
    id: "viet-phrase-v500-tran-please-open-the-trunk",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-open-the-trunk.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-please-open-the-trunk.json",
    summary: "For asking a taxi or ride driver to open the trunk for luggage.",
    bodies: {
      "at-glance": "Say it beside the car while gesturing to the bag, not from across the street.",
      "quick-say": "Keep the request short, then step back so the driver can open the trunk safely.",
      breakdown: "Vui lòng means please; mở means open; cốp xe means car trunk.",
      "natural-variants": "Take-me-here, District 1, and stop-here phrases cover the ride setup around the bag.",
      "when-to-use": "Good at hotel pickup, airport curb, station taxi stands, and ride-hailing meetups.",
      "good-to-know": "If the car is small or already full, the driver may point to the back seat or ask which bag.",
      "explore-next": "Stop-here, go-this-way, air-conditioning, wait-five-minutes, and cash phrases cover the ride after loading."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite please opener" },
      { id: "chunk-2", vietnamese: "mở", english: "open" },
      { id: "chunk-3", vietnamese: "cốp xe", english: "car trunk", keepTogetherReason: "trunk noun" }
    ],
    value: "turns the trunk request into a specific curbside luggage moment"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-is-this-the-correct-immigration-line",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-is-this-the-correct-immigration-line.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-is-this-the-correct-immigration-line.json",
    summary: "For confirming the immigration queue before you commit to a long airport line.",
    bodies: {
      "at-glance": "Ask before joining the queue, especially if there are separate lines for passports, e-gates, or visas.",
      "quick-say": "Point to the line or sign, then wait for a yes, no, or a hand gesture toward another queue.",
      breakdown: "Đây có phải là asks is this; đường nhập cư means immigration line here; chính xác không? asks correct?",
      "natural-variants": "Immigration, baggage claim, and SIM-card phrases cover the first airport decisions after arrival.",
      "when-to-use": "Good when signs are crowded, lines split, or staff are directing people quickly.",
      "good-to-know": "If they point somewhere else, move first and ask again near the new sign if you are still unsure.",
      "explore-next": "Pickup-area, driver-meetup, missing-bag, domestic-terminal, and visa phrases cover common arrival follow-ups."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải là", english: "is this", keepTogetherReason: "is-this question frame" },
      { id: "chunk-2", vietnamese: "đường nhập cư", english: "immigration line", keepTogetherReason: "audio-backed immigration-line wording" },
      { id: "chunk-3", vietnamese: "chính xác không?", english: "correct?", keepTogetherReason: "correct yes-no ending" }
    ],
    value: "removes generic yes-no copy and fixes misleading immigration-line breakdown chunks"
  },
  {
    id: "viet-phrase-v900-dire-navi-can-you-point-out-a-nearby-landmark",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-can-you-point-out-a-nearby-landmark.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-can-you-point-out-a-nearby-landmark.json",
    summary: "For asking someone to anchor directions to a visible building, cafe, sign, or corner.",
    bodies: {
      "at-glance": "Use it when street names are hard to catch and a landmark would make the route easier.",
      "quick-say": "Show the map or address, then ask for a landmark you can actually look for.",
      breakdown: "Bạn có thể means can you; chỉ ra means point out; một điểm mốc gần đó means a nearby landmark.",
      "natural-variants": "Excuse-me, near-here, and walking-time phrases help turn the landmark into a route.",
      "when-to-use": "Good at hotel desks, street corners, station exits, market lanes, and pickup points.",
      "good-to-know": "A cafe, bridge, gate, bank, or large sign may be more useful than another street name.",
      "explore-next": "Left, right, straight, understand-now, and pickup-point phrases cover the next navigation step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "chỉ ra", english: "point out", keepTogetherReason: "point-out verb" },
      { id: "chunk-3", vietnamese: "một điểm mốc gần đó", english: "a nearby landmark", keepTogetherReason: "nearby-landmark noun phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the landmark request into concrete route-finding guidance and repairs bad glosses"
  },
  {
    id: "viet-phrase-v900-food-drin-can-you-remove-this-from-the-bill",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-you-remove-this-from-the-bill.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-you-remove-this-from-the-bill.json",
    summary: "For asking staff to take one wrong or unwanted line item off the bill.",
    bodies: {
      "at-glance": "Keep the bill visible and point to the exact item, not the total.",
      "quick-say": "Ask calmly, then let the receipt or menu price carry the detail.",
      breakdown: "Bạn có thể means can you; loại bỏ điều này means remove this; khỏi hóa đơn? means from the bill?",
      "when-to-use": "Good when an item was added twice, a cancelled dish stayed on the receipt, or a charge does not belong.",
      "good-to-know": "Pointing to one line keeps the request factual and easier for staff to fix.",
      "explore-next": "Pay-now, card-payment, smaller-bills, exact-change, and break-this-bill phrases cover checkout after the correction.",
      "natural-variants": "Receipt, separate-payment, card-payment, bill-mistake, and that's-all phrases stay close for the payment turn."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "loại bỏ điều này", english: "remove this", keepTogetherReason: "remove-this phrase" },
      { id: "chunk-3", vietnamese: "khỏi hóa đơn?", english: "from the bill?", keepTogetherReason: "from-the-bill phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-family-food-pay-now",
        "viet-family-service-card",
        "viet-phrase-v500-mone-numb-pric-i-need-smaller-bills",
        "viet-phrase-v500-mone-numb-pric-do-i-need-exact-change",
        "viet-phrase-v900-tran-can-you-break-this-bill"
      ]
    },
    value: "makes the bill-removal page a precise receipt correction and expands payment follow-ups"
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
      batch: 32,
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
      reason: "premium_audit_batch_32_polish"
    });
    for (const [sectionID, concreteTravelerValueImproved] of Object.entries(repair.cardParityLedger || {})) {
      ledgerRows.push({
        batch: 32,
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
        reason: "premium_audit_batch_32_card_parity"
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
    batch: 32,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
