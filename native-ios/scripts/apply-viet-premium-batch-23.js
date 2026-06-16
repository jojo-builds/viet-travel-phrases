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
    id: "viet-phrase-v900-tran-please-avoid-the-highway",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-please-avoid-the-highway.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-please-avoid-the-highway.json",
    summary: "For asking a driver to avoid the highway when you want city streets, fewer tolls, or a slower local route.",
    bodies: {
      "at-glance": "Ask before the route is locked in. Show the map if you mean one specific highway or toll road.",
      "quick-say": "Say it early and point to the route. If the driver gives a reason, confirm whether the issue is tolls, traffic, or time.",
      breakdown: "Xin hãy tránh means please avoid; đường cao tốc means highway or expressway.",
      "natural-variants": "Destination, District 1, and stop-here cards keep the ride anchored after you change the route.",
      "when-to-use": "Good in taxis, ride-hailing cars, private transfers, and airport rides before the driver commits to a highway.",
      "good-to-know": "A highway may be faster but cost more or feel less direct. Ask before the car is already on the ramp.",
      "explore-next": "Move to stop-here, go-this-way, air-conditioning, wait-five-minutes, or cash cards if the ride needs another adjustment."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy tránh", english: "please avoid", keepTogetherReason: "avoid request" },
      { id: "chunk-2", vietnamese: "đường cao tốc", english: "highway / expressway", keepTogetherReason: "highway phrase" }
    ],
    value: "turns a bare route command into a clear driver-routing decision without deleting ride-control cards"
  },
  {
    id: "viet-phrase-v900-tran-please-turn-left-at-the-next-street",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-please-turn-left-at-the-next-street.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-please-turn-left-at-the-next-street.json",
    summary: "For guiding a driver to turn left at the next street when your map or landmark is clear.",
    bodies: {
      "at-glance": "Say it before the turn arrives. A map point or small hand gesture can help if traffic is loud.",
      "quick-say": "Keep the instruction short and early. Do not wait until the car is already at the intersection.",
      breakdown: "Vui lòng means please; rẽ trái means turn left; ở đường tiếp theo means at the next street.",
      "natural-variants": "Destination, District 1, and stop-here cards cover the route-control moments around this turn.",
      "when-to-use": "Good in taxis, ride-hailing cars, motorbike taxis, and private cars when you are helping guide the route.",
      "good-to-know": "The driver may choose the nearest legal or safer left turn. Watch the road and let them adjust if needed.",
      "explore-next": "Move to stop-here, go-this-way, air-conditioning, wait-five-minutes, or cash cards if the ride continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite marker" },
      { id: "chunk-2", vietnamese: "rẽ trái", english: "turn left", keepTogetherReason: "turn-left phrase" },
      { id: "chunk-3", vietnamese: "ở đường tiếp theo", english: "at the next street", keepTogetherReason: "next-street phrase" }
    ],
    value: "turns a bare driver command into a timed route instruction while preserving all ride cards"
  },
  {
    id: "viet-phrase-food-17",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-17.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/food-split-bill.json",
    summary: "For asking a cafe or restaurant to split the bill before cards or cash come out.",
    bodies: {
      "at-glance": "Ask when the bill arrives or before paying at the counter. Point to each person or receipt if needed.",
      "quick-say": "Say it before anyone pays. If they cannot split it, ask for one receipt and settle with your group.",
      breakdown: "Trả riêng means pay separately; được không asks if it is possible.",
      "when-to-use": "Good at cafes, restaurants, food courts, cashier stands, and group meals where each person wants a separate charge.",
      "good-to-know": "Some places cannot split a bill after it is printed or after the card terminal is ready. Ask early.",
      "explore-next": "Move to pay-now, card-payment, receipt, remove-from-bill, or bill-mistake cards if payment gets more specific.",
      "natural-variants": "Receipt, bill-by-card, remove-item, bill-mistake, and thank-you cards cover the rest of the payment flow."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Trả riêng", english: "pay separately", keepTogetherReason: "separate-payment phrase" },
      { id: "chunk-2", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "possibility question" }
    ],
    value: "replaces visible process language with a concrete group-payment moment and preserves bill/payment cards"
  },
  {
    id: "viet-phrase-money-premium-service-included",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/money-premium-service-included.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/money-service-included.json",
    summary: "For checking whether a service charge is already in the bill before you tip, pay, or question the total.",
    bodies: {
      "at-glance": "Use it with a bill, menu, hotel invoice, tour quote, or receipt in view.",
      "quick-say": "Point to the line item and ask once. The answer may be included, not included, tax, or service charge.",
      breakdown: "Dịch vụ means service; đã được bao gồm means already included; chưa asks whether it has been included yet.",
      "natural-variants": "How-much, per-kilo, and price cards keep the amount visible if the total still needs checking.",
      "when-to-use": "Good in restaurants, hotels, spas, tours, ticket counters, and shops when a total includes unclear fees.",
      "good-to-know": "Service charge and tax can be separate lines. Show the exact number instead of asking about the whole bill.",
      "explore-next": "Move to too-expensive, lower-price, final-price, show-another, or take-this cards if the conversation shifts back to price."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Dịch vụ", english: "service", keepTogetherReason: "service noun" },
      { id: "chunk-2", vietnamese: "đã được bao gồm", english: "already included", keepTogetherReason: "included phrase" },
      { id: "chunk-3", vietnamese: "chưa?", english: "yet?", keepTogetherReason: "yet question" }
    ],
    value: "turns a bare bill question into a service-charge decision while keeping price cards intact"
  },
  {
    id: "viet-phrase-v500-airp-bord-arri-i-am-here-for-tourism",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-i-am-here-for-tourism.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-i-am-here-for-tourism.json",
    summary: "For answering an arrival or immigration question about the purpose of your visit.",
    bodies: {
      "at-glance": "Keep your passport, visa, arrival form, or hotel address visible. This is a short purpose-of-visit answer.",
      "quick-say": "Say it plainly. If they ask next, show your hotel, return flight, or number of days.",
      breakdown: "Tôi đến đây means I came here; để du lịch means for tourism.",
      "natural-variants": "Immigration, baggage, and SIM-card cards cover the first airport questions after purpose of visit.",
      "when-to-use": "Good at immigration, airline desks, arrival counters, form checks, and any airport desk asking why you are in Vietnam.",
      "good-to-know": "This is an answer, not a travel story. Keep documents ready and add details only if asked.",
      "explore-next": "Move to pickup-area, meet-driver, missing-bag, domestic-terminal, or visa cards if the arrival flow continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đến đây", english: "I came here", keepTogetherReason: "arrival phrase" },
      { id: "chunk-2", vietnamese: "để du lịch", english: "for tourism", keepTogetherReason: "purpose phrase" }
    ],
    value: "turns the tourism answer into a real immigration/arrival handoff without removing airport follow-up cards"
  },
  {
    id: "viet-phrase-v500-airp-bord-arri-where-is-gate-10",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-where-is-gate-10.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-where-is-gate-10.json",
    summary: "For finding a specific airport gate when the signs, screen, or boarding pass are not enough.",
    bodies: {
      "at-glance": "Show your boarding pass or flight screen. Gate numbers can change, so let staff check the latest screen.",
      "quick-say": "Ask once, then follow the pointing toward the floor, terminal, security lane, or gate corridor.",
      breakdown: "Cổng 10 means gate 10; ở đâu asks where.",
      "natural-variants": "Immigration, baggage, and SIM-card cards cover nearby airport wayfinding if you are still arriving.",
      "when-to-use": "Good in departure halls, transfer corridors, information desks, security areas, and airport shops.",
      "good-to-know": "Gate changes happen. After getting directions, check the airport screen again before walking too far.",
      "explore-next": "Move to pickup-area, meet-driver, missing-bag, domestic-terminal, or visa cards if the airport task changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cổng 10", english: "gate 10", keepTogetherReason: "gate number" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "turns a bare gate question into a live airport wayfinding moment while preserving airport cards"
  },
  {
    id: "viet-phrase-v500-bath-pers-need-where-can-i-buy-shampoo",
    source: "content-draft/viet/canonical-pages/catalog-promoted/bathroom-personal-needs/v500-bath-pers-need-where-can-i-buy-shampoo.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/bathroom-personal-needs/v500-bath-pers-need-where-can-i-buy-shampoo.json",
    summary: "For finding shampoo at a pharmacy, convenience store, hotel shop, market, or guesthouse desk.",
    bodies: {
      "at-glance": "Show a photo or gesture hair-washing if needed. The answer may be an aisle, a nearby shop, or a small sachet.",
      "quick-say": "Ask the question, then let them point. If size matters, show a small-bottle gesture after the first answer.",
      breakdown: "Tôi có thể asks can I; mua means buy; dầu gội means shampoo; ở đâu asks where.",
      "natural-variants": "Bathroom, toilet paper, and bathroom-use cards cover the basic-needs questions around this one.",
      "when-to-use": "Good at hotels, pharmacies, convenience stores, markets, homestays, and roadside shops when travel supplies run out.",
      "good-to-know": "Small sachets and travel bottles are common. If brand does not matter, a photo is enough.",
      "explore-next": "Move to soap, wash-hands, water, shower, or toilet cards if the basic-needs stop continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "mua", english: "buy", keepTogetherReason: "buy verb" },
      { id: "chunk-3", vietnamese: "dầu gội", english: "shampoo", keepTogetherReason: "shampoo phrase" },
      { id: "chunk-4", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "turns a title-only supply question into concrete pharmacy/shop wayfinding with all basic-needs cards kept"
  },
  {
    id: "viet-phrase-v500-dire-navi-is-it-near-the-market",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-is-it-near-the-market.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-is-it-near-the-market.json",
    summary: "For confirming a place is near the market before you walk, cross, or accept directions.",
    bodies: {
      "at-glance": "Use the market as the landmark. Show the map so the other person can confirm the exact market.",
      "quick-say": "Ask while pointing to the map, street, or sign. Listen for yes, no, another market, or a different side of the road.",
      breakdown: "Có asks whether it is; gần chợ means near the market; không makes it a yes/no question.",
      "natural-variants": "How-to-get-there, near-here, and walking-time cards cover the next directions check.",
      "when-to-use": "Good at street corners, taxi dropoffs, hotel desks, market streets, and alleys where landmarks beat house numbers.",
      "good-to-know": "There may be more than one market nearby. Show the market name, photo, or map pin if you have it.",
      "explore-next": "Move to turn-left, turn-right, go-straight, understand-now, or pickup-point cards if the route continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "is it / is there", keepTogetherReason: "yes-no lead" },
      { id: "chunk-2", vietnamese: "gần chợ", english: "near the market", keepTogetherReason: "market landmark phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a market landmark question into a concrete map-and-street confirmation while keeping direction cards"
  },
  {
    id: "viet-phrase-v500-food-drin-i-ordered-this-without-peanuts",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-i-ordered-this-without-peanuts.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v500-food-drin-i-ordered-this-without-peanuts.json",
    summary: "For correcting a dish when peanuts appear after you ordered it without peanuts.",
    bodies: {
      "at-glance": "Point to the dish and the menu or order note. If this is an allergy, show the allergy card too.",
      "quick-say": "Say it before eating more. Keep your tone calm, but make the peanut issue clear.",
      breakdown: "Tôi đã gọi means I ordered; món này means this dish; mà không có means without; đậu phộng means peanuts.",
      "when-to-use": "Good at restaurants, cafes, food courts, and stalls when peanuts show up in a garnish, sauce, topping, or side dish.",
      "good-to-know": "Peanuts can appear as a topping or in a sauce. If allergy risk is serious, ask for a new dish, not only removal.",
      "explore-next": "Move to fish-sauce, no-meat, shellfish-allergy, or safer-dish cards if the ingredient check continues.",
      "natural-variants": "No-meat, without-this-ingredient, safest-dish, pork-beef-chicken, and shrimp cards cover nearby ingredient checks."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đã gọi", english: "I ordered", keepTogetherReason: "ordered phrase" },
      { id: "chunk-2", vietnamese: "món này", english: "this dish", keepTogetherReason: "this-dish phrase" },
      { id: "chunk-3", vietnamese: "mà không có", english: "without", keepTogetherReason: "without phrase" },
      { id: "chunk-4", vietnamese: "đậu phộng", english: "peanuts", keepTogetherReason: "peanut phrase" }
    ],
    value: "turns the peanut correction into a serious dish-safety handoff without removing allergy/ingredient cards"
  },
  {
    id: "viet-phrase-v500-heal-phar-i-have-food-poisoning",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-food-poisoning.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-food-poisoning.json",
    summary: "For telling a pharmacy, clinic, hotel desk, or helper that you suspect food poisoning.",
    bodies: {
      "at-glance": "Name the problem first. Add vomiting, diarrhea, fever, dehydration, or timing only if they ask.",
      "quick-say": "Keep it direct and show a translated note, medicine package, or hotel card if talking is hard.",
      breakdown: "Tôi bị means I have; ngộ độc thực phẩm means food poisoning.",
      "natural-variants": "Doctor and pharmacy cards cover the next help step after naming the problem.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, tour desks, and travel-insurance calls when stomach symptoms feel serious.",
      "good-to-know": "If symptoms are severe, ask for a doctor or clinic instead of only asking for medicine.",
      "explore-next": "Move to headache, stomach-hurts, motion-sickness, allergy, or diarrhea cards if the health details continue."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I have / I am suffering from", keepTogetherReason: "symptom phrase" },
      { id: "chunk-2", vietnamese: "ngộ độc thực phẩm", english: "food poisoning", keepTogetherReason: "food-poisoning phrase" }
    ],
    value: "turns a bare health phrase into a clear clinic/pharmacy symptom handoff while keeping health cards"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-can-i-have-a-receipt.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-can-i-have-a-receipt.json",
    summary: "For asking for a receipt after buying tickets, medicine, food, transport, or a service.",
    bodies: {
      "at-glance": "Ask before leaving the counter. Show the payment screen, card, cash, or item if staff need to match the sale.",
      "quick-say": "Say it once and wait. If they ask paper or digital, show your phone or email address.",
      breakdown: "Tôi có thể asks can I; có biên nhận means have a receipt; được không asks if it is possible.",
      "natural-variants": "How-much and per-kilo cards help if the receipt request turns into checking the amount.",
      "when-to-use": "Good at markets, ticket counters, pharmacies, cafes, hotel desks, transport desks, and repair shops.",
      "good-to-know": "Some small vendors cannot print a formal receipt. A written total, stamped slip, or photo may be the practical backup.",
      "explore-next": "Move to too-expensive, lower-price, final-price, show-another, or take-this cards if the amount is still being settled."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "có biên nhận", english: "have a receipt", keepTogetherReason: "receipt phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "possibility question" }
    ],
    value: "turns a receipt title into a practical counter/payment request while preserving price follow-up cards"
  },
  {
    id: "viet-phrase-v500-phon-inte-powe-can-i-use-the-wi-fi",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-i-use-the-wi-fi.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-i-use-the-wi-fi.json",
    summary: "For asking permission to use Wi-Fi at a cafe, hotel, shop, station, or waiting area.",
    bodies: {
      "at-glance": "Ask before requesting the password. Keep your phone open if a QR code, login screen, or pop-up matters.",
      "quick-say": "Show the phone and pause. Staff may point to a password sign, QR code, or network name.",
      breakdown: "Tôi có thể asks can I; sử dụng means use; Wi-Fi is Wi-Fi; không makes it a yes/no question.",
      "natural-variants": "Password and SIM-card cards cover the connection questions that usually come next.",
      "when-to-use": "Good at cafes, hotels, homestays, SIM shops, airports, stations, and counters where you need a quick connection.",
      "good-to-know": "Many places post a password or QR code near the counter. If connection fails, ask about the password or data instead.",
      "explore-next": "Move to battery, charger, charge-here, data-top-up, or eSIM cards if the phone problem is bigger than Wi-Fi."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "sử dụng", english: "use", keepTogetherReason: "use verb" },
      { id: "chunk-3", vietnamese: "Wi-Fi", english: "Wi-Fi", keepTogetherReason: "wifi noun" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the Wi-Fi page into a real counter/login-screen request while keeping phone support cards"
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
  return [
    ...tokens.map((token) => ({ ...token })),
    {
      id: "full",
      vietnamese: page.title,
      english: page.englishTitle,
      audioKey: page.audioKey ?? null
    }
  ];
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
    if (section.id === "breakdown") {
      next.breakdown = withFullBreakdown(page, repair.breakdown);
    }
    return next;
  });
  writeJson(repair.source, page);
  return {
    page,
    before,
    after: {
      title: page.title,
      englishTitle: page.englishTitle,
      summary: page.summary,
      sections: Object.fromEntries((page.sections || []).map((section) => [section.id, section.body || ""])),
      phraseCards: countSectionItems(page, "phrases"),
      breakdownRows: countSectionItems(page, "breakdown")
    }
  };
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
  if (field.length || row.length) row.push(field), rows.push(row);
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
  fs.writeFileSync(absPath, formatCSV(rows, bomMode));
  return changed;
}

function main() {
  const repairsByPhraseID = new Map();
  const ledgerRows = [];
  for (const repair of repairs) {
    const { page, before, after } = updateSource(repair);
    updateAudit(repair, page);
    repairsByPhraseID.set(page.phraseID, repair);
    ledgerRows.push({
      batch: 23,
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
          "source breakdown gloss repair"
        ]
      },
      after: {
        title: after.title,
        englishTitle: after.englishTitle,
        summary: after.summary,
        sections: {
          atGlance: after.sections["at-glance"],
          quickSay: after.sections["quick-say"],
          breakdown: after.sections.breakdown
        }
      },
      preservedPhraseCards: after.phraseCards,
      preservedBreakdownRows: after.breakdownRows,
      concreteTravelerValueImproved: repair.value,
      reason: "premium_audit_batch_23"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const ledgerRowsByKey = new Map(
    ledgerRows.map((row) => [`${row.reason}:${row.pageID}`, row])
  );
  let updatedLedgerRows = 0;
  const rewrittenLedgerRows = existingLedgerRows.map((line) => {
    try {
      const row = JSON.parse(line);
      const key = `${row.reason}:${row.pageID}`;
      if (ledgerRowsByKey.has(key)) {
        updatedLedgerRows += 1;
        return JSON.stringify(ledgerRowsByKey.get(key));
      }
    } catch {
      return line;
    }
    return line;
  });
  const existingKeys = new Set(existingLedgerRows.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}`];
    } catch {
      return [];
    }
  }));
  const newLedgerRows = ledgerRows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}`));
  const finalLedgerRows = [
    ...rewrittenLedgerRows,
    ...newLedgerRows.map((row) => JSON.stringify(row))
  ];
  if (updatedLedgerRows || newLedgerRows.length) {
    fs.writeFileSync(ledgerPath, `${finalLedgerRows.join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 23,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: newLedgerRows.length,
    updatedLedgerRows,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
