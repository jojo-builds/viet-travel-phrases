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
    id: "viet-phrase-v500-bath-pers-need-do-you-have-hand-sanitizer",
    source: "content-draft/viet/canonical-pages/catalog-promoted/bathroom-personal-needs/v500-bath-pers-need-do-you-have-hand-sanitizer.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/bathroom-personal-needs/v500-bath-pers-need-do-you-have-hand-sanitizer.json",
    summary: "For asking a counter, cafe, or restroom attendant for hand sanitizer.",
    bodies: {
      "at-glance": "Ask when soap, a sink, or a sanitizer bottle is not visible.",
      "quick-say": "Hold up your hands or point to the counter. A small gesture keeps the ask quick.",
      breakdown: "Bạn có asks do you have; nước rửa tay khô means hand sanitizer; không? makes it yes/no.",
      "natural-variants": "Bathroom, toilet-paper, and restroom phrases cover the same personal-needs moment.",
      "when-to-use": "Good at cafes, stations, hotel desks, shops, and public bathrooms after a ride, meal, or market stop.",
      "good-to-know": "A counter may point to a pump instead of answering aloud. Watch for the gesture.",
      "explore-next": "Soap, hand-washing, water, shower, and toilet follow-ups cover nearby personal-care needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "do you have", keepTogetherReason: "do-you-have phrase" },
      { id: "chunk-2", vietnamese: "nước rửa tay khô", english: "hand sanitizer", keepTogetherReason: "hand-sanitizer noun" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a title-only sanitizer page into a concrete personal-care counter ask"
  },
  {
    id: "viet-phrase-v500-dire-navi-can-you-help-me-get-back-to-my-hotel",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-can-you-help-me-get-back-to-my-hotel.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-can-you-help-me-get-back-to-my-hotel.json",
    summary: "For asking someone to help you find your way back to your hotel.",
    bodies: {
      "at-glance": "The hotel name is clear; the route back is the part that needs help.",
      "quick-say": "Show the hotel name, address, or map location before you ask.",
      breakdown: "Bạn có thể asks can you; giúp tôi means help me; quay lại means return to; khách sạn means hotel; được không? asks if it is possible.",
      "natural-variants": "Route, nearby, and walking-time follow-ups help after someone points you in a direction.",
      "when-to-use": "Good at street corners, stations, shop counters, and hotel-adjacent neighborhoods when you need a clean reset.",
      "good-to-know": "A hotel card or booking screen is better than a long explanation. Let the other person point or type the route.",
      "explore-next": "Turn, straight-ahead, pickup-point, and thanks follow-ups cover the next direction step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "giúp tôi", english: "help me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-3", vietnamese: "quay lại", english: "return to", keepTogetherReason: "return phrase" },
      { id: "chunk-4", vietnamese: "khách sạn", english: "hotel", keepTogetherReason: "hotel noun" },
      { id: "chunk-5", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the directions page about a real lost-route hotel reset"
  },
  {
    id: "viet-phrase-v500-shop-can-you-put-it-in-a-bag",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v500-shop-can-you-put-it-in-a-bag.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v500-shop-can-you-put-it-in-a-bag.json",
    summary: "For asking a shop or market stall to put the item in a bag.",
    bodies: {
      "at-glance": "Use it after buying something small, wet, fragile, or awkward to carry.",
      "quick-say": "Point to the item and then to a bag if one is visible.",
      breakdown: "Bạn có thể asks can you; bỏ nó means put it; vào túi means into a bag; được không? asks if it is possible.",
      "natural-variants": "Size, color, and try-on follow-ups stay nearby if the purchase is not finished yet.",
      "when-to-use": "Good at markets, convenience stores, pharmacies, clothing shops, and souvenir counters.",
      "good-to-know": "Some shops charge for bags or use lightweight plastic. A gesture toward your backpack also works.",
      "explore-next": "Looking, payment, exchange, price, and bargaining follow-ups cover the rest of the shop counter."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "bỏ nó", english: "put it", keepTogetherReason: "put-it phrase" },
      { id: "chunk-3", vietnamese: "vào túi", english: "into a bag", keepTogetherReason: "into-a-bag phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "replaces generic shopping follow-up prose with a concrete bagging request"
  },
  {
    id: "viet-phrase-v500-shop-do-you-have-this",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v500-shop-do-you-have-this.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v500-shop-do-you-have-this.json",
    summary: "For asking a shop if they carry the item, size, color, or product you are showing.",
    bodies: {
      "at-glance": "Point to the item, shelf label, photo, or empty package before asking.",
      "quick-say": "Keep the object or phone screen visible so the answer can be yes, no, or a point to another shelf.",
      breakdown: "Bạn có asks do you have; cái này means this item; không? makes it yes/no.",
      "natural-variants": "Size, color, and try-on follow-ups help if the first answer is yes.",
      "when-to-use": "Good at markets, pharmacies, minimarts, clothing shops, electronics counters, and souvenir stalls.",
      "good-to-know": "If staff walk away after hearing it, they may be checking stock. Keep the sample or photo ready.",
      "explore-next": "Looking, payment, exchange, price, and bargaining follow-ups cover nearby shopping turns."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "do you have", keepTogetherReason: "do-you-have phrase" },
      { id: "chunk-2", vietnamese: "cái này", english: "this item", keepTogetherReason: "this-item phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the stock-check page specific to showing an item or photo"
  },
  {
    id: "viet-phrase-v500-time-date-book-i-booked-the-wrong-time",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v500-time-date-book-i-booked-the-wrong-time.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v500-time-date-book-i-booked-the-wrong-time.json",
    summary: "For telling a desk or booking contact that the reservation time is wrong.",
    bodies: {
      "at-glance": "Use it when the booking exists but the time on it is not the time you meant.",
      "quick-say": "Show the confirmation and point to the wrong time before asking what can be changed.",
      breakdown: "Tôi đã đặt means I booked; sai means wrong; thời gian means time.",
      "natural-variants": "Time, today, and tomorrow-morning follow-ups help when the desk asks what time you need.",
      "when-to-use": "Good at tour desks, ticket counters, clinics, restaurants, hotels, and message threads about a booking.",
      "good-to-know": "Keep the corrected time visible. Numbers are easier to fix when both people can point to the same screen.",
      "explore-next": "Booking, opening-time, move-later, boarding, and wait follow-ups cover nearby schedule problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đã đặt", english: "I booked", keepTogetherReason: "booking phrase" },
      { id: "chunk-2", vietnamese: "sai", english: "wrong", keepTogetherReason: "wrong adjective" },
      { id: "chunk-3", vietnamese: "thời gian", english: "time", keepTogetherReason: "time noun" }
    ],
    value: "turns a bare booking title into a specific wrong-time correction moment"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-need-fever-medicine",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-fever-medicine.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-fever-medicine.json",
    summary: "For asking a pharmacy for fever-reducing medicine.",
    bodies: {
      "at-glance": "At a pharmacy, fever is the symptom to name before the product discussion starts.",
      "quick-say": "Show any current medicine, allergies, or a translated note before staff choose a product.",
      breakdown: "Tôi cần means I need; thuốc hạ sốt means fever-reducing medicine.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy follow-ups help if staff send you somewhere else.",
      "when-to-use": "Good at pharmacies, clinic desks, and hotel desks when you need help finding the right counter or product.",
      "good-to-know": "Ask staff about dose and interactions. If symptoms feel severe, use a doctor or clinic phrase instead.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea follow-ups cover common pharmacy details."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "thuốc hạ sốt", english: "fever-reducing medicine", keepTogetherReason: "fever-medicine noun" }
    ],
    value: "makes the pharmacy page practical without giving medical advice"
  },
  {
    id: "viet-phrase-v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis.json",
    summary: "For asking a clinic, pharmacy, or hotel desk for someone who can discuss medicine in English.",
    bodies: {
      "at-glance": "Use it when dosage, symptoms, allergies, or paperwork need to be exact.",
      "quick-say": "Show the medicine, symptom note, or insurance form so staff know why English matters.",
      breakdown: "Có asks is there; bác sĩ hoặc dược sĩ means doctor or pharmacist; nói tiếng Anh means speaks English; không? makes it yes/no.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy follow-ups help if they point you to another counter.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, and hospital reception when the next answer needs detail.",
      "good-to-know": "If no one speaks English, a written note or translation screen can still keep the conversation steady.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea follow-ups cover common health details."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "is there", keepTogetherReason: "existence question opener" },
      { id: "chunk-2", vietnamese: "bác sĩ hoặc dược sĩ", english: "doctor or pharmacist", keepTogetherReason: "doctor-or-pharmacist phrase" },
      { id: "chunk-3", vietnamese: "nói tiếng Anh", english: "speaks English", keepTogetherReason: "English-speaking phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "anchors the English-speaking medical page in exact health conversations"
  },
  {
    id: "viet-phrase-v900-phon-inte-powe-how-many-gigabytes-are-included",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-how-many-gigabytes-are-included.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-how-many-gigabytes-are-included.json",
    summary: "For checking how much mobile data comes with a SIM or eSIM plan.",
    bodies: {
      "at-glance": "Ask before paying for a SIM, eSIM, top-up, or tourist data package.",
      "quick-say": "Point to the plan, price card, or phone screen while you ask.",
      breakdown: "Có bao nhiêu asks how many; gigabyte is the data amount; được bao gồm means are included.",
      "natural-variants": "Wi-Fi password and SIM-card follow-ups stay useful if the data plan is not enough.",
      "when-to-use": "Good at airport SIM counters, phone shops, minimarts, hotel desks, and mobile-service stalls.",
      "good-to-know": "Data amounts can sound like prices. Confirm the number on a screen before choosing the plan.",
      "explore-next": "Battery, charger, charging, data top-up, and eSIM follow-ups cover nearby phone problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có bao nhiêu", english: "how many", keepTogetherReason: "how-many phrase" },
      { id: "chunk-2", vietnamese: "gigabyte", english: "gigabytes", keepTogetherReason: "data unit" },
      { id: "chunk-3", vietnamese: "được bao gồm?", english: "are included", keepTogetherReason: "included phrase" }
    ],
    value: "turns a bare phone-plan question into a concrete SIM/eSIM buying check"
  },
  {
    id: "viet-phrase-v900-time-date-book-do-i-need-to-bring-my-passport",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-do-i-need-to-bring-my-passport.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-do-i-need-to-bring-my-passport.json",
    summary: "For checking whether a passport is required for a booking, ticket, rental, or tour.",
    bodies: {
      "at-glance": "Ask before leaving the hotel, especially when the counter may need the original document.",
      "quick-say": "Show the booking or passport photo and ask if the original passport is needed.",
      breakdown: "Tôi có cần asks do I need; mang theo means bring; hộ chiếu means passport; không? makes it yes/no.",
      "natural-variants": "Time, today, and tomorrow-morning follow-ups help if the answer depends on when you go.",
      "when-to-use": "Good for tours, rentals, train tickets, ferry tickets, clinics, and hotel or activity bookings.",
      "good-to-know": "Some counters accept a photo; others ask for the original passport. Confirm before you travel across town.",
      "explore-next": "Booking, opening-time, move-later, boarding, and wait follow-ups cover nearby schedule questions."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có cần", english: "do I need", keepTogetherReason: "do-I-need phrase" },
      { id: "chunk-2", vietnamese: "mang theo", english: "bring", keepTogetherReason: "bring-with phrase" },
      { id: "chunk-3", vietnamese: "hộ chiếu", english: "passport", keepTogetherReason: "passport noun" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the passport page about a real document requirement check"
  },
  {
    id: "viet-phrase-v900-unde-repa-can-you-read-this-translation",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v900-unde-repa-can-you-read-this-translation.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v900-unde-repa-can-you-read-this-translation.json",
    summary: "For asking someone to check a translated sentence before you show or send it.",
    bodies: {
      "at-glance": "Use it when the translation app might be close, but you need a human check.",
      "quick-say": "Show only the line you want checked, not the whole chat.",
      breakdown: "Bạn có asks can you; đọc được means can read; bản dịch này means this translation; không? makes it yes/no.",
      "natural-variants": "Slower, repeat, and I-do-not-understand follow-ups help if the answer starts a repair loop.",
      "when-to-use": "Good before sending a message, showing a request at a counter, or confirming that translated wording is safe.",
      "good-to-know": "This is about checking meaning, not asking for a full translation. Keep the screen simple.",
      "explore-next": "Repeat, write-it-down, meaning, which-one, and show-me follow-ups cover the next repair step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "đọc được", english: "can read", keepTogetherReason: "can-read phrase" },
      { id: "chunk-3", vietnamese: "bản dịch này", english: "this translation", keepTogetherReason: "this-translation noun" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the translation page about checking one line, not generic repair copy"
  },
  {
    id: "viet-phrase-service-9",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/service-9.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/service-refill.json",
    summary: "For asking a cafe, hotel, or counter to add water to your bottle.",
    bodies: {
      "at-glance": "Use it when a refill station, cooler, or water jug is nearby but not clearly self-serve.",
      "quick-say": "Hold the bottle where staff can see it and point to the water source if there is one.",
      breakdown: "Châm thêm means refill or add more; nước means water; vào chai này means into this bottle; được không? asks if it is possible.",
      "natural-variants": "Bottle-water, bag, and tissues follow-ups cover the same small-counter rhythm.",
      "when-to-use": "Good at cafes, hotel lobbies, hostels, tour desks, gyms, and small shops with a visible water cooler.",
      "good-to-know": "Some places sell bottled water instead of refilling. A point to the shelf or cooler is still a useful answer.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and print-this follow-ups cover nearby service-counter needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Châm thêm", english: "refill / add more", keepTogetherReason: "refill phrase" },
      { id: "chunk-2", vietnamese: "nước", english: "water", keepTogetherReason: "water noun" },
      { id: "chunk-3", vietnamese: "vào chai này", english: "into this bottle", keepTogetherReason: "into-this-bottle phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a bare refill title into a realistic water-bottle counter request"
  },
  {
    id: "viet-phrase-transport-premium-turn-around",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/transport-premium-turn-around.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/viet-phrase-transport-premium-turn-around.json",
    summary: "For asking a driver to turn back when the route has gone the wrong way.",
    bodies: {
      "at-glance": "Use it when the car or bike needs to go back, not just change lanes.",
      "quick-say": "Keep the map open and point behind you or to the route line.",
      breakdown: "Xin hãy means please; quay lại means turn back or go back.",
      "natural-variants": "Go-back, destination, and District 1 follow-ups help if the driver needs the corrected route.",
      "when-to-use": "Good in taxis, ride-hailing cars, motorbike pickups, or shuttle vans when the turn has already been missed.",
      "good-to-know": "Say it early and calmly. A map gesture often explains the problem faster than extra words.",
      "explore-next": "Stop-here, go-this-way, air-conditioning, and wait follow-ups cover nearby driver requests."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy", english: "please", keepTogetherReason: "polite request opener" },
      { id: "chunk-2", vietnamese: "quay lại.", english: "turn back / go back", keepTogetherReason: "turn-back phrase with punctuation" }
    ],
    value: "removes template copy and makes the transport page about a missed-turn driver moment"
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
      batch: 29,
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
          "visible prose and breakdown trust repair"
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
      reason: "premium_audit_batch_29"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-500/generated-rows.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];
  const ledgerRowsAdded = appendLedger(ledgerRows);

  console.log(JSON.stringify({
    batch: 29,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
