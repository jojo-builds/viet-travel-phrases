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
    id: "viet-phrase-v900-dire-navi-where-is-the-back-entrance",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-where-is-the-back-entrance.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-where-is-the-back-entrance.json",
    summary: "For finding a rear entrance, service door, or quieter way into a venue.",
    bodies: {
      "at-glance": "Ask before circling the block, entering the wrong door, or stepping into a staff-only area.",
      "quick-say": "Show the place name or map, then gesture toward the back side if you can.",
      breakdown: "Lối vào means entrance; phía sau means back or rear side; ở đâu? asks where it is.",
      "natural-variants": "These help when the answer turns into a route, distance, or walking-time question.",
      "when-to-use": "Good at restaurants, stations, small venues, parking areas, and side entrances where the front door is not the one you need.",
      "good-to-know": "Rear entrances can mean service doors or resident-only doors. Wait for a point or short confirmation before walking in.",
      "explore-next": "These direction cards cover the next turn after someone points you around the building."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Lối vào", english: "entrance", keepTogetherReason: "entrance noun" },
      { id: "chunk-2", vietnamese: "phía sau", english: "back / rear side", keepTogetherReason: "rear-side phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where-question ending" }
    ],
    value: "replaces title-only direction scaffolding with a real rear-entrance decision point"
  },
  {
    id: "viet-phrase-v900-food-drin-can-you-clean-this-table",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-you-clean-this-table.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-you-clean-this-table.json",
    summary: "For asking restaurant staff to wipe a table before you sit down.",
    bodies: {
      "at-glance": "Best when the table is sticky, wet, or still has crumbs from the last group.",
      "quick-say": "Point to the tabletop and step back so staff can wipe it without a long explanation.",
      breakdown: "Bạn có thể asks can you; lau means wipe or clean; cái bàn này means this table; được không? asks politely if it is possible.",
      "natural-variants": "If staff move you before cleaning, use the seating or wait-time follow-ups nearby.",
      "when-to-use": "Good at cafes, food courts, street-side tables, and busy restaurants before your group sits down.",
      "good-to-know": "A small gesture is enough here. Point, ask once, and give staff room to clean.",
      "explore-next": "Fan, table-size, wait, inside, and outside cards cover the seating questions that often come next."
    },
    replaceSectionPhrases: {
      "explore-next": [
        {
          id: "v900-food-drin-do-we-order-here-or-at-the-counter",
          vietnamese: "Chúng ta đặt hàng ở đây hay tại quầy?",
          english: "Do we order here or at the counter?",
          pronunciation: "Chung ta dat hang o day hay tai quay",
          symbolName: "speaker.wave.2.fill",
          tintName: "green",
          detailPageID: "viet-phrase-v900-food-drin-do-we-order-here-or-at-the-counter",
          audioKey: "v900-food-drin-do-we-order-here-or-at-the-counter"
        },
        {
          id: "v900-food-drin-i-have-been-waiting-a-long-time",
          vietnamese: "Tôi đã chờ đợi rất lâu rồi",
          english: "I have been waiting a long time",
          pronunciation: "Toi da cho doi rat lau roi",
          symbolName: "speaker.wave.2.fill",
          tintName: "green",
          detailPageID: "viet-phrase-v900-food-drin-i-have-been-waiting-a-long-time",
          audioKey: "v900-food-drin-i-have-been-waiting-a-long-time"
        },
        {
          id: "v900-food-drin-what-do-you-recommend",
          vietnamese: "Bạn đề xuất món gì?",
          english: "What do you recommend?",
          pronunciation: "Ban de xuat mon gi",
          symbolName: "speaker.wave.2.fill",
          tintName: "green",
          detailPageID: "viet-phrase-v900-food-drin-what-do-you-recommend",
          audioKey: "v900-food-drin-what-do-you-recommend"
        },
        {
          id: "v900-food-drin-thats-all-thank-you",
          vietnamese: "Vậy thôi, cảm ơn",
          english: "That's all, thank you.",
          pronunciation: "Vay thoi cam on",
          symbolName: "text.bubble.fill",
          tintName: "green",
          detailPageID: "viet-phrase-v900-food-drin-thats-all-thank-you",
          audioKey: "audio-authored-vay-thoi-cam-on-efab00a56b"
        },
        {
          id: "coffee-7",
          vietnamese: "Tính tiền giúp tôi",
          english: "Please let me pay",
          pronunciation: "ting tyen zoop toy",
          symbolName: "speaker.wave.2.fill",
          tintName: "green",
          detailPageID: "viet-family-food-pay-now",
          audioKey: "coffee-7"
        }
      ]
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "lau", english: "wipe / clean", keepTogetherReason: "cleaning verb" },
      { id: "chunk-3", vietnamese: "cái bàn này", english: "this table", keepTogetherReason: "this-table phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a bare restaurant request into a concrete table-cleaning moment while keeping the rich restaurant card set"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-i-have-a-room-away-from-the-street",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-have-a-room-away-from-the-street.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-have-a-room-away-from-the-street.json",
    summary: "For asking the front desk for a quieter room away from road noise.",
    bodies: {
      "at-glance": "Ask before accepting the key if road noise could make the night hard to sleep.",
      "quick-say": "Show the booking and mention sleep only if the desk asks why.",
      breakdown: "Tôi có thể asks can I; có một phòng means have a room; cách xa đường phố means away from the street; được không? asks if it is possible.",
      "natural-variants": "Reservation and check-in cards help the desk find your stay before changing the room.",
      "when-to-use": "Good at hotels, guesthouses, and homestays before you unpack or settle in.",
      "good-to-know": "Away from the street may mean a rear room, higher floor, or different side of the building.",
      "explore-next": "Checkout, quiet-room, and room-problem cards cover nearby front-desk requests."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "có một phòng", english: "have a room", keepTogetherReason: "room-request phrase" },
      { id: "chunk-3", vietnamese: "cách xa", english: "away from", keepTogetherReason: "away-from phrase" },
      { id: "chunk-4", vietnamese: "đường phố", english: "the street", keepTogetherReason: "street noun" },
      { id: "chunk-5", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the hotel page about noise and sleep instead of generic booking/key-card copy"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-you-help-me-with-my-bags",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-help-me-with-my-bags.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-help-me-with-my-bags.json",
    summary: "For asking hotel or transport staff to help carry your bags.",
    bodies: {
      "at-glance": "Best in a lobby, at stairs, by a taxi, or near a luggage room when the bags are awkward to carry.",
      "quick-say": "Point to the bags first, then the room, car, desk, or stairs.",
      breakdown: "Bạn có thể asks can you; giúp tôi means help me; mang túi xách means carry bags; được không? asks if it is possible.",
      "natural-variants": "Reservation and check-in cards help if the desk needs to match the bags to your room.",
      "when-to-use": "Good at hotels, apartments, hostels, station counters, ferry ramps, and taxi doors.",
      "good-to-know": "This is a physical ask. Keep the destination visible so staff know where the bags should go.",
      "explore-next": "Checkout, quiet-room, hot-room, and air-conditioner cards cover nearby hotel-desk issues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "giúp tôi", english: "help me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-3", vietnamese: "mang túi xách", english: "carry bags", keepTogetherReason: "carry-bags phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "anchors the page in a luggage-carrying handoff rather than generic hotel follow-up prose"
  },
  {
    id: "viet-phrase-v900-hote-acco-please-do-not-clean-the-room-today",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-please-do-not-clean-the-room-today.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-please-do-not-clean-the-room-today.json",
    summary: "For telling housekeeping or the front desk to skip room cleaning today.",
    bodies: {
      "at-glance": "Say it before leaving the room or when housekeeping knocks.",
      "quick-say": "Show the room number or door and keep the request polite.",
      breakdown: "Xin vui lòng means please; không dọn phòng means do not clean the room; ngày hôm nay means today.",
      "natural-variants": "Reservation and check-in cards help if the front desk needs to confirm the room.",
      "when-to-use": "Good at hotels, guesthouses, apartments, or homestays when you want privacy or restocking later.",
      "good-to-know": "If you still need towels or water, ask for those separately so staff do not assume you need nothing.",
      "explore-next": "Checkout-time, quiet-room, checkout, hot-room, and air-conditioner cards cover nearby stay requests."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "không dọn phòng", english: "do not clean the room", keepTogetherReason: "do-not-clean-room phrase" },
      { id: "chunk-3", vietnamese: "ngày hôm nay", english: "today", keepTogetherReason: "today phrase" }
    ],
    value: "fixes misleading breakdown glosses and makes the page about a real housekeeping boundary"
  },
  {
    id: "viet-phrase-v900-hote-acco-please-wake-me-up-at-six",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-please-wake-me-up-at-six.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-please-wake-me-up-at-six.json",
    summary: "For asking the hotel to arrange a six o'clock wake-up call.",
    bodies: {
      "at-glance": "Ask at the front desk the night before an early pickup, flight, train, or tour.",
      "quick-say": "Show the time on your phone and confirm morning if there is any doubt.",
      breakdown: "Hãy đánh thức means please wake; tôi means me; lúc sáu giờ means at six o'clock; nhé softens the request.",
      "natural-variants": "Reservation and check-in cards help if the desk needs to attach the wake-up call to your room.",
      "when-to-use": "Good for hotels and guesthouses before an early departure or tour pickup.",
      "good-to-know": "Six can be repeated back as a number. Listen for sáu giờ or point to 6:00.",
      "explore-next": "Checkout-time, quiet-room, checkout, hot-room, and air-conditioner cards cover nearby front-desk needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy đánh thức", english: "please wake", keepTogetherReason: "wake-up request" },
      { id: "chunk-2", vietnamese: "tôi", english: "me", keepTogetherReason: "object pronoun" },
      { id: "chunk-3", vietnamese: "lúc sáu giờ", english: "at six o'clock", keepTogetherReason: "time phrase" },
      { id: "chunk-4", vietnamese: "nhé", english: "softens the request", keepTogetherReason: "softening particle" }
    ],
    value: "turns generic hotel timing copy into a concrete wake-up-call request with safer time handling"
  },
  {
    id: "viet-phrase-v900-hote-acco-the-room-smells-like-smoke",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-the-room-smells-like-smoke.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-the-room-smells-like-smoke.json",
    summary: "For reporting smoke smell in a hotel room before unpacking.",
    bodies: {
      "at-glance": "Say it before unpacking so staff can check the room or move you.",
      "quick-say": "Give the room number, point toward the room, and keep bags packed if you need a change.",
      breakdown: "Căn phòng means the room; có mùi means has a smell; khói means smoke.",
      "natural-variants": "Reservation and check-in cards help if the desk needs to find your stay quickly.",
      "when-to-use": "Good at hotels, apartments, guesthouses, and homestays before you settle in.",
      "good-to-know": "Smoke smell can affect deposit or cleaning conversations. Report it early and calmly.",
      "explore-next": "Checkout-time, quiet-room, checkout, hot-room, and air-conditioner cards cover nearby room problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Căn phòng", english: "the room", keepTogetherReason: "room noun" },
      { id: "chunk-2", vietnamese: "có mùi", english: "has a smell", keepTogetherReason: "smell phrase" },
      { id: "chunk-3", vietnamese: "khói", english: "smoke", keepTogetherReason: "smoke noun" }
    ],
    value: "makes the room-smell page about reporting early instead of repeating generic room-number guidance"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-where-can-i-buy-mosquito-repellent",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-buy-mosquito-repellent.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-buy-mosquito-repellent.json",
    summary: "For asking where to buy mosquito repellent before an evening, beach, or rural stop.",
    bodies: {
      "at-glance": "Ask before sunset, after rain, or before a river, beach, garden, or countryside stop.",
      "quick-say": "Show a photo of spray or lotion if the word does not land.",
      breakdown: "Tôi có thể mua asks can I buy; thuốc chống muỗi means mosquito repellent; ở đâu? asks where.",
      "natural-variants": "Water, bag, and tissues cards cover the small-shop basics around this request.",
      "when-to-use": "Good at pharmacies, convenience stores, hotel desks, markets, and small neighborhood shops.",
      "good-to-know": "Vietnamese shops may point you to a pharmacy or a shelf instead of explaining the product.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and print-this cards cover nearby counter needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể mua", english: "can I buy", keepTogetherReason: "can-I-buy phrase" },
      { id: "chunk-2", vietnamese: "thuốc chống muỗi", english: "mosquito repellent", keepTogetherReason: "repellent noun" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where-question ending" }
    ],
    value: "replaces generic shop/direction prose with a practical mosquito-repellent purchase moment"
  },
  {
    id: "viet-phrase-v900-tran-does-the-rental-include-insurance",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-does-the-rental-include-insurance.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-does-the-rental-include-insurance.json",
    summary: "For checking whether a rental already includes insurance.",
    bodies: {
      "at-glance": "Ask before signing, paying, or riding away.",
      "quick-say": "Point to the rental price or contract and wait for what is covered.",
      breakdown: "Giá thuê means rental price; có bao gồm asks whether it includes; bảo hiểm means insurance; không? makes it yes/no.",
      "natural-variants": "Taxi and stop-here cards stay useful if the rental question turns into transport planning.",
      "when-to-use": "Good for motorbikes, cars, bicycles, boats, scooters, and gear rentals before money changes hands.",
      "good-to-know": "Insurance, deposit, and damage responsibility are separate details. Keep them clear before you leave.",
      "explore-next": "Stop, route, air-conditioning, wait, and cash cards cover nearby transport conversations."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Giá thuê", english: "rental price", keepTogetherReason: "rental-price noun" },
      { id: "chunk-2", vietnamese: "có bao gồm", english: "does it include", keepTogetherReason: "include phrase" },
      { id: "chunk-3", vietnamese: "bảo hiểm", english: "insurance", keepTogetherReason: "insurance noun" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "fixes misleading transport breakdowns and makes the page about rental coverage instead of taxi destination copy"
  },
  {
    id: "viet-phrase-v900-tran-please-show-me-how-to-start-it",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-please-show-me-how-to-start-it.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-please-show-me-how-to-start-it.json",
    summary: "For asking staff to demonstrate how to start a rental bike, scooter, appliance, or machine.",
    bodies: {
      "at-glance": "Ask before leaving the counter if the controls are unfamiliar.",
      "quick-say": "Hold the key, button, or handlebar area in view while they show you.",
      breakdown: "Hãy chỉ cho tôi means please show me; cách bắt đầu means how to start; nó means it.",
      "natural-variants": "Taxi and stop-here cards help if you decide not to ride or need another way to leave.",
      "when-to-use": "Good at motorbike rentals, scooter counters, ferry gear desks, hotel equipment desks, and activity rentals.",
      "good-to-know": "A demonstration is better than a long explanation here. Try it once while staff are still nearby.",
      "explore-next": "Stop-here, route, air-conditioning, wait, and cash cards cover nearby transport needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy chỉ cho tôi", english: "please show me", keepTogetherReason: "show-me request" },
      { id: "chunk-2", vietnamese: "cách bắt đầu", english: "how to start", keepTogetherReason: "how-to-start phrase" },
      { id: "chunk-3", vietnamese: "nó", english: "it", keepTogetherReason: "object pronoun" }
    ],
    value: "makes the page about a hands-on rental demonstration instead of generic transport follow-up copy"
  },
  {
    id: "viet-phrase-food-premium-too-spicy-now",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-premium-too-spicy-now.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/food-too-spicy-now.json",
    summary: "For telling restaurant staff the dish is too spicy for you after tasting it.",
    bodies: {
      "at-glance": "Say it calmly after one bite if you need rice, water, a milder replacement, or less chili.",
      "quick-say": "Point to the dish, then ask for less chili, more rice, or another option.",
      breakdown: "Món này means this dish; quá cay means too spicy; đối với tôi means for me.",
      "natural-variants": "For undercooked, cold, or spoiled dishes, use the nearby food-problem follow-ups without blaming the kitchen.",
      "when-to-use": "Good after tasting, before the dish is remade, or before another person adds more chili.",
      "good-to-know": "Spicy can be personal. The phrase says the dish is too spicy for you, not that the kitchen made a mistake.",
      "explore-next": "Change-this and related food-problem cards keep the request practical if staff offer a fix."
    },
    filterSectionPhraseDetailPageIDs: {
      "explore-next": ["viet-phrase-food-16"]
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Món này", english: "this dish", keepTogetherReason: "this-dish phrase" },
      { id: "chunk-2", vietnamese: "quá cay", english: "too spicy", keepTogetherReason: "too-spicy phrase" },
      { id: "chunk-3", vietnamese: "đối với tôi.", english: "for me", keepTogetherReason: "for-me phrase with punctuation" }
    ],
    value: "makes the spicy-food page calm and specific while leaving the rendered food-problem card set intact"
  },
  {
    id: "viet-phrase-v500-airp-bord-arri-i-dont-have-a-printed-copy",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-i-dont-have-a-printed-copy.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-i-dont-have-a-printed-copy.json",
    summary: "For explaining at a counter that you only have the document on your phone.",
    bodies: {
      "at-glance": "Good at check-in, ticket desks, immigration-style queues, tour counters, and pickup desks.",
      "quick-say": "Show the screen and ask if the digital copy is enough.",
      breakdown: "Tôi không means I do not; có means have; bản in means printed copy.",
      "natural-variants": "Immigration, baggage, and SIM cards cover the first airport questions around the same counter flow.",
      "when-to-use": "Good when the booking, visa, ticket, form, receipt, or confirmation exists digitally but not on paper.",
      "good-to-know": "A clear phone screen, booking code, or PDF can solve the problem faster than a long explanation.",
      "explore-next": "Pickup, driver, missing-bag, domestic-terminal, and visa cards cover nearby arrival-counter needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi không", english: "I do not", keepTogetherReason: "negative opener" },
      { id: "chunk-2", vietnamese: "có", english: "have", keepTogetherReason: "have verb" },
      { id: "chunk-3", vietnamese: "bản in", english: "printed copy", keepTogetherReason: "printed-copy noun" }
    ],
    value: "turns an airport title page into a concrete digital-document handoff"
  }
];

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function countSectionItems(page, key) {
  return (page.sections || []).reduce((total, section) => total + ((section[key] || []).length), 0);
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

function updateSource(repair) {
  const page = readJson(repair.source);
  const before = JSON.parse(JSON.stringify(page));
  page.summary = repair.summary;
  page.sections = (page.sections || []).map((section) => {
    const next = { ...section };
    if (Object.prototype.hasOwnProperty.call(repair.bodies, section.id)) {
      next.body = repair.bodies[section.id];
    }
    const phraseReplacement = repair.replaceSectionPhrases?.[section.id];
    if (phraseReplacement) {
      next.phrases = phraseReplacement.map((phrase) => ({ ...phrase }));
    }
    const filterOut = repair.filterSectionPhraseDetailPageIDs?.[section.id];
    if (filterOut) {
      const blocked = new Set(filterOut);
      next.phrases = (next.phrases || []).filter((phrase) => !blocked.has(phrase.detailPageID));
    }
    if (section.id === "breakdown") {
      next.breakdown = withFullBreakdown(page, repair.breakdown);
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
  const repairsByPhraseID = new Map();
  const ledgerRows = [];

  for (const repair of repairs) {
    const { page, before } = updateSource(repair);
    updateAudit(repair, page);
    repairsByPhraseID.set(page.phraseID, repair);
    ledgerRows.push({
      batch: 28,
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
        issues: [
          "title-as-summary",
          "formulaic projection prose",
          "breakdown or visible prose trust repair"
        ]
      },
      after: {
        title: page.title,
        englishTitle: page.englishTitle,
        summary: page.summary,
        sections: {
          atGlance: repair.bodies["at-glance"],
          quickSay: repair.bodies["quick-say"],
          breakdown: repair.bodies.breakdown
        }
      },
      preservedPhraseCards: countSectionItems(page, "phrases"),
      preservedBreakdownRows: countSectionItems(page, "breakdown"),
      concreteTravelerValueImproved: repair.value,
      reason: "premium_audit_batch_28"
    });
    if (repair.filterSectionPhraseDetailPageIDs || repair.replaceSectionPhrases) {
      ledgerRows.push({
        batch: 28,
        tierRole: page.tierRole,
        sectionID: "source-render-card-parity",
        sectionTitle: "Source/render card parity",
        pageID: page.id,
        phraseID: page.phraseID,
        sourcePath: repair.source,
        before: {
          phraseCards: countSectionItems(before, "phrases"),
          issue: repair.replaceSectionPhrases
            ? "source explore-next did not match the richer rendered restaurant-flow card set"
            : "source explore-next carried a card that the native renderer already omitted from this page"
        },
        after: {
          phraseCards: countSectionItems(page, "phrases"),
          repair: repair.replaceSectionPhrases
            ? "grew first-class source to match the rendered page card set"
            : "aligned first-class source to the rendered page without reducing visible rendered cards"
        },
        preservedPhraseCards: countSectionItems(page, "phrases"),
        preservedBreakdownRows: countSectionItems(page, "breakdown"),
        concreteTravelerValueImproved: repair.replaceSectionPhrases
          ? "keeps the richer rendered restaurant-flow cards and makes first-class source match them"
          : "keeps the rendered food-problem card set intact while removing source-only card drift",
        reason: "premium_audit_batch_28_card_parity"
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
    batch: 28,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
