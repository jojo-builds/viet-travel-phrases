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
    id: "viet-phrase-v900-food-drin-this-is-undercooked",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-this-is-undercooked.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-this-is-undercooked.json",
    summary: "For sending back food that looks or feels not cooked through.",
    bodies: {
      "at-glance": "Point to the bite, bowl, or plate while the food is still in front of you.",
      "quick-say": "Say it calmly before eating more; if needed, ask them to change it or cook it longer.",
      breakdown: "Món này means this dish; chưa được nấu chín kỹ means not cooked thoroughly yet.",
      "when-to-use": "Good at restaurants, cafes, hotel breakfasts, and stalls where staff can still fix the dish.",
      "good-to-know": "Keep the plate visible and avoid a long explanation. A clear point is usually enough.",
      "explore-next": "Change-this, cold-food, spoiled-food, something-in-food, and too-spicy pages cover nearby food problems.",
      "natural-variants": "Cold, spoiled, and something-in-food phrases help if the issue is safety or quality, not doneness."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Món này", english: "this dish", keepTogetherReason: "this-dish phrase" },
      { id: "chunk-2", vietnamese: "chưa được nấu chín kỹ", english: "not cooked thoroughly yet", keepTogetherReason: "undercooked phrase" }
    ],
    cardTargets: {
      "explore-next": ["viet-phrase-v900-food-drin-can-you-change-this"]
    },
    cardParityLedger: {
      "explore-next": "removes one non-rendered source-only food-card target while preserving the rendered correction card and five visible food-problem cards"
    },
    value: "turns a generic food-complaint page into a concrete plate-still-present repair moment"
  },
  {
    id: "viet-phrase-v900-heal-phar-can-you-call-an-ambulance",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-can-you-call-an-ambulance.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-can-you-call-an-ambulance.json",
    summary: "For asking someone nearby to call an ambulance in a serious medical emergency.",
    bodies: {
      "at-glance": "Say this first if someone is badly hurt, cannot breathe, has chest pain, or needs urgent help.",
      "quick-say": "Keep the request direct, then show the person, location, or translated emergency note.",
      breakdown: "Bạn có thể means can you; gọi xe cứu thương means call an ambulance; được không? asks if they can do it.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy cards are for less urgent medical help.",
      "when-to-use": "Good at hotels, clinics, pharmacies, restaurants, stations, and security desks.",
      "good-to-know": "If they hesitate, point to the injured person or phone screen and repeat the ambulance word.",
      "explore-next": "Headache, stomach, motion-sickness, medicine, and allergy pages are nearby, but emergency symptoms come first."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "gọi xe cứu thương", english: "call an ambulance", keepTogetherReason: "ambulance request" },
      { id: "chunk-3", vietnamese: "được không?", english: "can you / is it possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "repairs an emergency page that previously read like a routine pharmacy prompt"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-am-allergic-to-penicillin",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-am-allergic-to-penicillin.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-am-allergic-to-penicillin.json",
    summary: "For warning a pharmacist or clinician before they choose medicine for you.",
    bodies: {
      "at-glance": "Say it before accepting pills, injections, or antibiotic advice.",
      "quick-say": "Show the medicine name or allergy note if you have it, then let staff check alternatives.",
      breakdown: "Tôi bị dị ứng với means I am allergic to; penicillin is the medicine name.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy pages help if the allergy changes where you need to go.",
      "when-to-use": "Good at pharmacies, clinics, hospitals, hotel desks, and travel insurance calls.",
      "good-to-know": "For drug allergies, short and serious is better than a long story. Point to the written name if possible.",
      "explore-next": "If staff need to check the medicine, ask about availability, interactions, alcohol, sleepiness, or whether it is safe with your regular medicine."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I am / I have", keepTogetherReason: "I-have condition frame" },
      { id: "chunk-2", vietnamese: "dị ứng với penicillin", english: "allergic to penicillin", keepTogetherReason: "drug-allergy phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-heal-phar-do-you-have-this-medicine",
        "viet-phrase-v900-heal-phar-please-check-for-drug-interactions",
        "viet-phrase-v900-heal-phar-can-i-drink-alcohol-with-this",
        "viet-phrase-v900-heal-phar-will-this-make-me-sleepy",
        "viet-phrase-v900-heal-phar-is-this-safe-with-my-medicine"
      ]
    },
    value: "reframes a bad generic health page as a high-stakes medication warning"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-need-mosquito-repellent",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-mosquito-repellent.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-mosquito-repellent.json",
    summary: "For asking a pharmacy, shop, or hotel desk for mosquito repellent.",
    bodies: {
      "at-glance": "Ask before evenings outside, river walks, garden seating, or countryside transfers.",
      "quick-say": "Point to your skin, bite marks, or a shelf of sprays so they know you mean repellent.",
      breakdown: "Tôi cần means I need; thuốc chống muỗi means mosquito repellent.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy pages stay nearby if bites become a medical issue.",
      "when-to-use": "Good at pharmacies, convenience stores, hotel desks, homestays, and outdoor-tour counters.",
      "good-to-know": "Vietnam shops may offer sprays, creams, coils, or plug-ins. Point to skin-safe repellent if that matters.",
      "explore-next": "Headache, stomach, motion-sickness, medicine, and allergy pages cover common pharmacy follow-ups."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "thuốc chống muỗi", english: "mosquito repellent", keepTogetherReason: "mosquito-repellent noun" }
    ],
    value: "makes the page about the real shop/pharmacy moment instead of generic medical wording"
  },
  {
    id: "viet-phrase-v900-heal-phar-please-write-the-address-of-the-clinic",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-please-write-the-address-of-the-clinic.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-please-write-the-address-of-the-clinic.json",
    summary: "For getting a clinic address written clearly before you leave.",
    bodies: {
      "at-glance": "Ask while the clinic name, referral, or map is still open.",
      "quick-say": "Hand over your phone, paper, or receipt so they can write the address instead of spelling it aloud.",
      breakdown: "Hãy ghi means please write; địa chỉ phòng khám means the clinic address.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy pages help if you still need to choose where to go.",
      "when-to-use": "Good at pharmacies, hotel desks, clinics, insurance calls, and front desks.",
      "good-to-know": "A written address is easier for taxis, maps, and insurance notes than a fast spoken direction.",
      "explore-next": "Headache, stomach, motion-sickness, medicine, and allergy pages cover the reason for the clinic visit."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy ghi", english: "please write", keepTogetherReason: "please-write phrase" },
      { id: "chunk-2", vietnamese: "địa chỉ phòng khám", english: "the clinic address", keepTogetherReason: "clinic-address noun phrase" }
    ],
    value: "turns a title-repeat page into a practical written-address handoff"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-can-you-dry-these-clothes",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-dry-these-clothes.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-dry-these-clothes.json",
    summary: "For asking laundry staff to dry clothes, not just wash them.",
    bodies: {
      "at-glance": "Ask before handing over the bag if you need clothes back dry the same day.",
      "quick-say": "Point to the clothes and confirm the pickup time before leaving.",
      breakdown: "Bạn có thể means can you; làm khô means dry; những bộ quần áo này means these clothes.",
      "natural-variants": "Water, bag, and tissues cards are nearby counter requests, but laundry timing matters here.",
      "when-to-use": "Good at laundries, hotel desks, homestays, and small service counters.",
      "good-to-know": "Rainy weather can change drying time. Ask when it will be ready if you need them for travel.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and print-this cards cover nearby service-counter turns."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "làm khô", english: "dry", keepTogetherReason: "drying verb" },
      { id: "chunk-3", vietnamese: "những bộ quần áo này", english: "these clothes", keepTogetherReason: "these-clothes noun phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a generic errand page into a real laundry timing page"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-can-you-wash-these-clothes",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-wash-these-clothes.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-wash-these-clothes.json",
    summary: "For asking a laundry or hotel desk to wash a specific bag of clothes.",
    bodies: {
      "at-glance": "Point to the clothes, then ask about pickup time before you leave them.",
      "quick-say": "Keep detergent, drying, and timing questions separate so the first answer stays clear.",
      breakdown: "Bạn có thể means can you; giặt means wash; những bộ quần áo này means these clothes.",
      "natural-variants": "Water, bag, and tissues cards are nearby counter requests, but laundry timing matters here.",
      "when-to-use": "Good at laundries, hotel desks, homestays, and small service counters.",
      "good-to-know": "If you need them tonight, ask the ready-time phrase right after this one.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and print-this cards cover nearby service-counter turns."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "giặt", english: "wash", keepTogetherReason: "wash verb" },
      { id: "chunk-3", vietnamese: "những bộ quần áo này", english: "these clothes", keepTogetherReason: "these-clothes noun phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "repairs laundry copy and fixes a misleading breakdown that called clothing a price"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-can-i-pay-by-qr-code",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-can-i-pay-by-qr-code.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-can-i-pay-by-qr-code.json",
    summary: "For asking whether a shop or counter accepts QR payment.",
    bodies: {
      "at-glance": "Show the payment screen or point to the QR stand before cash comes out.",
      "quick-say": "Ask before they total the bill if you need to use an app instead of cash.",
      breakdown: "Tôi có thể means can I; thanh toán means pay; bằng mã QR means by QR code.",
      "natural-variants": "How-much and per-kilo cards help if the price is not clear yet.",
      "when-to-use": "Good at cafes, shops, ticket counters, market stalls, and service desks that display QR signs.",
      "good-to-know": "Some QR payments need a local bank app. Keep cash or card nearby if they say no.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover the price turn."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "thanh toán", english: "pay", keepTogetherReason: "payment verb" },
      { id: "chunk-3", vietnamese: "bằng mã QR", english: "by QR code", keepTogetherReason: "QR-code payment phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes QR payment feel like a real counter decision instead of a generic price page"
  },
  {
    id: "viet-phrase-v900-phon-inte-powe-the-sim-card-is-not-working",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-the-sim-card-is-not-working.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-the-sim-card-is-not-working.json",
    summary: "For showing a shop or hotel desk that your SIM has stopped working.",
    bodies: {
      "at-glance": "Keep the phone open to the error, signal bars, or mobile-data screen.",
      "quick-say": "Say the phrase, then let them look at the screen before adding more detail.",
      breakdown: "Thẻ SIM means SIM card; không hoạt động means is not working.",
      "natural-variants": "Wi-Fi password and SIM-card pages help if you need another connection path.",
      "when-to-use": "Good at SIM shops, airport counters, hotel desks, cafes, and phone-repair stalls.",
      "good-to-know": "A staff member may check data settings, registration, balance, or the physical card. Keep the phone unlocked.",
      "explore-next": "Battery, charger, charging, data top-up, and eSIM cards cover nearby phone problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Thẻ SIM", english: "SIM card", keepTogetherReason: "SIM-card noun" },
      { id: "chunk-2", vietnamese: "không hoạt động", english: "is not working", keepTogetherReason: "not-working phrase" }
    ],
    value: "moves the SIM-card page from generic phone copy to a concrete screen-showing support moment"
  },
  {
    id: "viet-phrase-v900-shop-can-you-make-it-a-round-number",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-can-you-make-it-a-round-number.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-can-you-make-it-a-round-number.json",
    summary: "For gently asking a seller to round the price to an easier number.",
    bodies: {
      "at-glance": "Ask after the price is clear, not before you know the total.",
      "quick-say": "Point to the calculator or cash amount so the rounded number is obvious.",
      breakdown: "Bạn có thể means can you; biến nó thành means make it into; một số tròn means a round number.",
      "natural-variants": "Size, color, and try-on cards stay nearby if the negotiation shifts back to the item.",
      "when-to-use": "Good at markets, small shops, and souvenir counters when bargaining stays friendly.",
      "good-to-know": "Smile and be ready for no. If they agree, confirm the final number before paying.",
      "explore-next": "Just-looking, pay-where, exchange-this, how-much, and lower-price pages cover the shopping turn."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "biến nó thành", english: "make it into", keepTogetherReason: "make-it-into phrase" },
      { id: "chunk-3", vietnamese: "một số tròn", english: "a round number", keepTogetherReason: "round-number phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is it possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a thin shopping line into a polite price-negotiation moment"
  },
  {
    id: "viet-phrase-v900-shop-im-looking-for-a-gift",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-im-looking-for-a-gift.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-im-looking-for-a-gift.json",
    summary: "For telling shop staff you want a gift, not something for yourself.",
    bodies: {
      "at-glance": "Say it before asking for suggestions, wrapping, size, or price.",
      "quick-say": "Point to the kind of item you are considering so suggestions stay practical.",
      breakdown: "Tôi đang tìm means I am looking for; một món quà means a gift.",
      "natural-variants": "Size, color, and try-on cards help if the gift becomes a specific item.",
      "when-to-use": "Good at markets, souvenir shops, clothing stalls, bookstores, and hotel gift counters.",
      "good-to-know": "Mentioning a gift can make staff show safer, easier-to-pack options.",
      "explore-next": "Just-looking, pay-where, exchange-this, how-much, and lower-price pages cover the shopping turn."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đang tìm", english: "I am looking for", keepTogetherReason: "looking-for phrase" },
      { id: "chunk-2", vietnamese: "một món quà", english: "a gift", keepTogetherReason: "gift noun phrase" }
    ],
    value: "repairs the gift page and fixes a wrong breakdown gloss that implied past tense"
  },
  {
    id: "viet-phrase-v900-sigh-acti-can-you-write-the-name-for-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-can-you-write-the-name-for-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-can-you-write-the-name-for-me.json",
    summary: "For asking staff to write an attraction, guide, hotel, or meeting-point name clearly.",
    bodies: {
      "at-glance": "Ask when a name is hard to hear, spell, or search on the map.",
      "quick-say": "Hand over your phone or paper so they can write it once instead of repeating it.",
      breakdown: "Bạn có thể means can you; viết tên means write the name; cho tôi means for me.",
      "natural-variants": "Ticket, start-time, and photo cards help around the same tour or attraction counter.",
      "when-to-use": "Good at tour desks, ticket counters, hotel lobbies, entrances, and meeting points.",
      "good-to-know": "A written name is easier for maps, drivers, and search than a fast spoken Vietnamese name.",
      "explore-next": "Closing time, meeting point, advance booking, tour booking, and entrance cards cover the next planning step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "viết tên", english: "write the name", keepTogetherReason: "write-name phrase" },
      { id: "chunk-3", vietnamese: "cho tôi", english: "for me", keepTogetherReason: "for-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is it possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a generic sightseeing helper into a map/search handoff"
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
      batch: 33,
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
      reason: "premium_audit_batch_33_polish"
    });
    for (const [sectionID, concreteTravelerValueImproved] of Object.entries(repair.cardParityLedger || {})) {
      ledgerRows.push({
        batch: 33,
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
        reason: "premium_audit_batch_33_card_parity"
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
    batch: 33,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRowsAdded
  }, null, 2));
}

main();
