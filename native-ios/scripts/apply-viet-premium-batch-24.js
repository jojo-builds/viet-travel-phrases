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
    id: "viet-phrase-v900-dire-navi-should-i-cross-the-street",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-should-i-cross-the-street.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-should-i-cross-the-street.json",
    summary: "For asking whether a crossing is safe before stepping into busy traffic.",
    bodies: {
      "at-glance": "Useful at market streets, station roads, and intersections where signals or crossings are unclear.",
      "quick-say": "Point to the crossing and wait before moving. If they wave you back, stay put.",
      breakdown: "Tôi có nên asks should I; băng qua đường means cross the street; không makes it a yes/no question.",
      "natural-variants": "How-to-get-there, near-here, and walking-time cards help if the crossing is part of a larger route.",
      "good-to-know": "Traffic can flow around pedestrians, but that does not make every crossing sensible. A guard, vendor, or hotel staffer may know the safer side.",
      "explore-next": "Turn-left, turn-right, go-straight, understand-now, and pickup-point cards cover the next route decision."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có nên", english: "should I", keepTogetherReason: "should-I question" },
      { id: "chunk-2", vietnamese: "băng qua đường", english: "cross the street", keepTogetherReason: "cross-street phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a bare crossing question into a real traffic-safety check without removing route cards"
  },
  {
    id: "viet-phrase-v900-food-drin-can-we-sit-outside",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-we-sit-outside.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-we-sit-outside.json",
    summary: "For asking for an outdoor table before staff seat you inside.",
    bodies: {
      "at-glance": "Useful at cafes, beer places, and restaurants where outside seats fill first or close in rain.",
      "quick-say": "Point toward the outdoor tables while you ask. Staff can answer with a table, wait time, or weather warning.",
      breakdown: "Chúng ta có thể asks can we; ngồi bên ngoài means sit outside; được không asks if it is possible.",
      "good-to-know": "Outdoor seating can depend on weather, smoke, fans, or how busy the sidewalk is. If staff hesitate, ask for any table instead.",
      "explore-next": "Clean-table and table-for-two cards cover the next seating moment.",
      "natural-variants": "Table-for-one, table-for-four, and wait-for-table cards cover nearby seating requests."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chúng ta có thể", english: "can we", keepTogetherReason: "can-we phrase" },
      { id: "chunk-2", vietnamese: "ngồi bên ngoài", english: "sit outside", keepTogetherReason: "sit-outside phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the outdoor-seat page feel like a cafe/restaurant seating request while preserving eleven food cards"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-have-a-sore-throat",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-have-a-sore-throat.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-have-a-sore-throat.json",
    summary: "For telling a pharmacy, clinic, hotel desk, or helper that your throat hurts.",
    bodies: {
      "at-glance": "Name the symptom first. Add fever, cough, medicine allergies, or timing only if they ask.",
      "quick-say": "Show a translated note or point to your throat. Pharmacy staff may offer lozenges, spray, or ask about fever.",
      breakdown: "Tôi bị means I have; đau họng means a sore throat.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy cards help if you need a place rather than a symptom line.",
      "good-to-know": "Short symptom phrases are easier at a counter. Keep any medicine package or allergy note visible.",
      "explore-next": "Headache, stomach pain, motion-sickness medicine, allergy, and diarrhea cards cover nearby health needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I have", keepTogetherReason: "symptom opener" },
      { id: "chunk-2", vietnamese: "đau họng", english: "a sore throat", keepTogetherReason: "sore-throat phrase" }
    ],
    value: "turns a title-only symptom page into a practical pharmacy/clinic handoff"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-hurt-my-arm",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-hurt-my-arm.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-hurt-my-arm.json",
    title: "Tôi bị thương ở tay",
    pronunciation: "Toi bi thuong o tay",
    summary: "For explaining an arm injury at a clinic, pharmacy, hotel desk, or to someone helping you.",
    bodies: {
      "at-glance": "Show the arm first and keep the sentence short. Add fall, swelling, cut, or pain level after they understand.",
      "quick-say": "Point to the exact spot while you say it. A photo, bandage, or translated note can carry the extra detail.",
      breakdown: "Tôi bị thương means I am injured; ở tay means in the arm or hand area.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy cards help if you need medical direction after naming the injury.",
      "good-to-know": "Vietnamese may use tay for arm or hand depending on context. Pointing removes the ambiguity.",
      "explore-next": "Headache, stomach pain, motion-sickness medicine, allergy, and diarrhea cards cover other health handoffs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị thương", english: "I am injured", keepTogetherReason: "injury phrase" },
      { id: "chunk-2", vietnamese: "ở tay", english: "in the arm or hand area", keepTogetherReason: "body-area phrase" }
    ],
    value: "makes the arm-injury page clear and corrects visible casing while keeping health support cards"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-i-stay-one-more-night",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-stay-one-more-night.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-stay-one-more-night.json",
    summary: "For asking the front desk if you can extend your room by one night.",
    bodies: {
      "at-glance": "Ask before checkout pressure starts. Have your room number, booking name, and payment method ready.",
      "quick-say": "Say it at the desk, then show the booking or room key. The answer may depend on availability or a new rate.",
      breakdown: "Tôi có thể asks can I; ở lại means stay; thêm một đêm nữa means one more night; được không asks if possible.",
      "natural-variants": "Reservation, check-in, and polite check-in cards help if the desk needs to look up your stay.",
      "good-to-know": "Availability can change fast in small hotels. If the same room is full, staff may offer another room.",
      "explore-next": "Checkout-time, quiet-room, checkout, hot-room, and air-conditioner cards cover the rest of the hotel desk flow."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "ở lại", english: "stay", keepTogetherReason: "stay verb" },
      { id: "chunk-3", vietnamese: "thêm một đêm nữa", english: "one more night", keepTogetherReason: "one-more-night phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns the extra-night page into a concrete front-desk extension request"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-you-email-me-the-invoice",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-email-me-the-invoice.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-email-me-the-invoice.json",
    summary: "For asking a hotel, tour desk, clinic, or service counter to send the invoice by email.",
    bodies: {
      "at-glance": "Show the email address before staff start spelling it back. A booking name or receipt number helps them find the charge.",
      "quick-say": "Point to the email on your phone while you ask. Leave the screen open until they copy it.",
      breakdown: "Bạn có thể asks can you; gửi email cho tôi means send email to me; hóa đơn means invoice; được không asks if possible.",
      "natural-variants": "Reservation, check-in, and polite check-in cards cover the desk details that may come before the invoice.",
      "good-to-know": "Invoice and receipt requests often need the booking name. Keep the payment screen or room number nearby.",
      "explore-next": "Checkout-time, quiet-room, checkout, hot-room, and air-conditioner cards cover related front-desk needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "gửi email cho tôi", english: "send email to me", keepTogetherReason: "email-to-me phrase" },
      { id: "chunk-3", vietnamese: "hóa đơn", english: "invoice", keepTogetherReason: "invoice noun" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "replaces title-as-summary hotel invoice copy with a practical email/booking-name handoff"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-do-you-accept-us-dollars",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-do-you-accept-us-dollars.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-do-you-accept-us-dollars.json",
    summary: "For checking whether a shop, hotel, or tour counter will take US dollars before you hand over cash.",
    bodies: {
      "at-glance": "Ask before counting bills. The answer may be no, a dong-only price, or a rate they write on a calculator.",
      "quick-say": "Show the dollar bill and wait for the answer. If they quote a rate, confirm the dong total before paying.",
      breakdown: "Bạn có chấp nhận asks do you accept; đô la Mỹ means US dollars; không makes it a yes/no question.",
      "natural-variants": "How-much and per-kilo cards cover price checks if the answer turns into a dong amount.",
      "good-to-know": "Many places prefer Vietnamese dong even when they understand dollars. A calculator total prevents a rate misunderstanding.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover the next money step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có chấp nhận", english: "do you accept", keepTogetherReason: "accept question" },
      { id: "chunk-2", vietnamese: "đô la Mỹ", english: "US dollars", keepTogetherReason: "US-dollar phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the US-dollar page a real cash/rate check instead of generic price scaffolding"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-is-there-an-atm-nearby",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-is-there-an-atm-nearby.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-is-there-an-atm-nearby.json",
    summary: "For asking where to find a nearby ATM when you need cash.",
    bodies: {
      "at-glance": "Useful at markets, pharmacies, cafes, hotels, or stations when card payment is not enough.",
      "quick-say": "Show your wallet or map while you ask. The answer may be a bank name, mall floor, or short street direction.",
      breakdown: "Có means is there; máy ATM means ATM; nào gần đây means any nearby; không makes it a yes/no question.",
      "natural-variants": "How-much and per-kilo cards cover price checks if the ATM question starts from a purchase.",
      "good-to-know": "Ask which bank or landmark if the first answer is vague. ATMs are often inside malls, convenience stores, or bank lobbies.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover the cash and purchase flow."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có máy ATM nào", english: "is there any ATM", keepTogetherReason: "ATM question" },
      { id: "chunk-2", vietnamese: "gần đây", english: "nearby", keepTogetherReason: "nearby phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the ATM page into a cash-finding errand with concrete location clues"
  },
  {
    id: "viet-phrase-v900-time-date-book-is-this-the-right-line",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-is-this-the-right-line.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-is-this-the-right-line.json",
    title: "Đây có phải là hàng đúng không?",
    pronunciation: "Day co phai la hang dung khong",
    audioPlanned: true,
    summary: "For checking whether you are in the right queue before waiting, boarding, entering, or buying a ticket.",
    bodies: {
      "at-glance": "Ask before committing to the line. Show the ticket, counter sign, booking, or entrance you mean.",
      "quick-say": "Point to the queue while you ask. The answer may be yes, a different line, or a counter number.",
      breakdown: "Đây có phải asks is this; hàng đúng means the right line or queue; không makes it a yes/no question.",
      "natural-variants": "What-time, today, and tomorrow-morning cards help if the line question turns into a schedule check.",
      "when-to-use": "Good at ticket counters, boarding gates, attractions, clinics, food stalls, and any place with several queues.",
      "good-to-know": "Line labels can change by ticket type, booking, or time slot. A photo of the sign helps staff correct you quickly.",
      "explore-next": "Booking, opening-time, move-it-later, boarding-time, and wait-time cards cover the next queue detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải", english: "is this", keepTogetherReason: "is-this question" },
      { id: "chunk-2", vietnamese: "là hàng đúng", english: "the right line / queue", keepTogetherReason: "right-queue phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "repairs a queue/line semantic risk by replacing dòng with hàng and moving stale audio to planned"
  },
  {
    id: "viet-phrase-repair-show-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/repair-show-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/repair-show-me.json",
    summary: "For asking someone to point, demonstrate, or show the option when words are not enough.",
    bodies: {
      "at-glance": "Good when the map, menu, machine, ticket, form, or product choice is easier to show than explain.",
      "quick-say": "Hold the screen, note, or object near the person and wait. A gesture may solve the exchange faster than more words.",
      breakdown: "Chỉ cho tôi means show me; được không softens the request.",
      "natural-variants": "Show-on-map, don't-understand, and slower cards help when the explanation still is not clear.",
      "good-to-know": "This is a repair phrase, not a demand. A calm tone and visible context make it easier to answer.",
      "explore-next": "Slower, repeat, write-it-down, meaning, and which-one cards cover the next misunderstanding."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chỉ cho tôi", english: "show me", keepTogetherReason: "show-me request" },
      { id: "chunk-2", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns the repair page into a concrete show/point/demonstrate moment while keeping repair cards"
  },
  {
    id: "viet-phrase-v500-emer-safe-please-call-an-ambulance",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v500-emer-safe-please-call-an-ambulance.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v500-emer-safe-please-call-an-ambulance.json",
    summary: "For asking someone nearby to call an ambulance during a medical emergency.",
    bodies: {
      "at-glance": "Say the request first, then show the injured person, location, hotel card, or translated emergency note.",
      "quick-say": "Point to the person who needs help and keep the sentence short. The goal is action, not a full explanation.",
      breakdown: "Hãy gọi means please call; xe cấp cứu means ambulance.",
      "natural-variants": "Police, ambulance, and lost-passport cards cover the urgent help options nearby.",
      "good-to-know": "In an emergency, the clearest phrase is the best phrase. Let the other person ask follow-up questions after they understand.",
      "explore-next": "Unsafe, emergency, help, hospital, and stolen-bag cards cover the next safety handoff."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy gọi", english: "please call", keepTogetherReason: "call request" },
      { id: "chunk-2", vietnamese: "xe cấp cứu", english: "ambulance", keepTogetherReason: "ambulance phrase" }
    ],
    value: "removes generic health scaffolding and makes the ambulance page a clear emergency action"
  },
  {
    id: "viet-phrase-v500-emer-safe-please-leave-me-alone",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v500-emer-safe-please-leave-me-alone.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v500-emer-safe-please-leave-me-alone.json",
    summary: "For telling someone firmly to leave you alone when a situation feels uncomfortable or unsafe.",
    bodies: {
      "at-glance": "Use it with a clear voice and move toward staff, a counter, hotel security, or a public place if needed.",
      "quick-say": "Say it once, then create space. If the person keeps following you, move to help or police language.",
      breakdown: "Xin hãy means please; để tôi yên means leave me alone.",
      "natural-variants": "Police, ambulance, and lost-passport cards sit nearby because safety situations can change fast.",
      "good-to-know": "This phrase is intentionally direct. You do not need to soften it if someone is bothering you.",
      "explore-next": "Unsafe, emergency, help, hospital, and stolen-bag cards cover the next safety handoff."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "để tôi yên", english: "leave me alone", keepTogetherReason: "leave-me-alone phrase" }
    ],
    value: "makes the leave-me-alone page direct and safety-aware without deleting emergency support cards"
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

function alignSelfPhraseCards(page, repair) {
  const changedSelf = repair.audioPlanned || repair.title || repair.englishTitle || repair.pronunciation;
  if (!changedSelf) return;

  const alignPhrase = (phrase) => {
    if (!phrase || phrase.detailPageID !== null || phrase.id !== page.phraseID) return phrase;
    return {
      ...phrase,
      vietnamese: page.title,
      english: page.englishTitle,
      pronunciation: page.pronunciation,
      symbolName: repair.audioPlanned ? "text.bubble.fill" : phrase.symbolName,
      audioKey: repair.audioPlanned ? null : page.audioKey
    };
  };

  page.sections = (page.sections || []).map((section) => ({
    ...section,
    phrases: (section.phrases || []).map(alignPhrase)
  }));
  page.examples = (page.examples || []).map(alignPhrase);
}

function updateSource(repair) {
  const page = readJson(repair.source);
  const before = JSON.parse(JSON.stringify(page));
  if (repair.title) page.title = repair.title;
  if (repair.englishTitle) page.englishTitle = repair.englishTitle;
  if (repair.pronunciation) page.pronunciation = repair.pronunciation;
  if (repair.audioPlanned) page.audioKey = null;
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
  alignSelfPhraseCards(page, repair);
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
    if (repair.title && index.target_text !== undefined) row[index.target_text] = repair.title;
    if (repair.title && index.canonical_target_text !== undefined) row[index.canonical_target_text] = repair.title;
    if (repair.englishTitle && index.english_text !== undefined) row[index.english_text] = repair.englishTitle;
    if (repair.pronunciation && index.pronunciation !== undefined) row[index.pronunciation] = repair.pronunciation;
    if (repair.summary && index.family_summary !== undefined) row[index.family_summary] = repair.summary;
    if (repair.audioPlanned) {
      if (index.audio_key !== undefined) row[index.audio_key] = "";
      if (index.audio_status !== undefined) row[index.audio_status] = "planned";
      if (index.notes !== undefined) {
        const note = row[index.notes] || "";
        if (!note.includes("Batch 24 semantic repair moved audio to planned")) {
          row[index.notes] = `${note}; Batch 24 semantic repair moved audio to planned`;
        }
      }
    }
    changed += 1;
  }
  fs.writeFileSync(absPath, formatCSV(rows, bomMode));
  return changed;
}

function updateSearchOnlySurfacing(repair) {
  if (!repair.title) return 0;
  const relPath = "content-draft/viet/search-only-surfacing-v1.json";
  const data = readJson(relPath);
  let changed = 0;
  for (const entry of data.entries || []) {
    if (entry.canonicalPageID !== repair.id && entry.originalPageID !== repair.id) continue;
    entry.vietnameseTitle = repair.title;
    changed += 1;
  }
  if (changed) writeJson(relPath, data);
  return changed;
}

function appendLedger(rows) {
  const existing = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const existingKeys = new Set(existing.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}`];
    } catch {
      return [];
    }
  }));
  const freshRows = rows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}`));
  if (freshRows.length) {
    fs.appendFileSync(ledgerPath, `${freshRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }
  return freshRows.length;
}

function main() {
  const repairsByPhraseID = new Map();
  const ledgerRows = [];
  let searchOnlyChanges = 0;

  for (const repair of repairs) {
    const { page, before } = updateSource(repair);
    updateAudit(repair, page);
    searchOnlyChanges += updateSearchOnlySurfacing(repair);
    repairsByPhraseID.set(page.phraseID, repair);
    const phraseCards = countSectionItems(page, "phrases");
    const breakdownRows = countSectionItems(page, "breakdown");
    ledgerRows.push({
      batch: 24,
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
          repair.audioPlanned ? "semantic audio replacement" : "visible prose/breakdown repair"
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
      preservedPhraseCards: phraseCards,
      preservedBreakdownRows: breakdownRows,
      concreteTravelerValueImproved: repair.value,
      reason: "premium_audit_batch_24"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];
  const ledgerRowsAdded = appendLedger(ledgerRows);

  console.log(JSON.stringify({
    batch: 24,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    searchOnlyChanges,
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
