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
    id: "viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-email-it-to-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-email-it-to-me.json",
    summary: "For asking a hotel, shop, clinic, or service counter to send the document or receipt by email.",
    bodies: {
      "at-glance": "Ask while the document, receipt, QR code, booking, or repair note is still visible.",
      "quick-say": "Show the email address or let them copy it from your phone. Spell it only if they ask.",
      breakdown: "Bạn có thể asks can you; gửi email means send by email; cho tôi means to me or for me; được không? asks if it is possible.",
      "natural-variants": "Water, bag, and tissues cards cover simple counter requests before the exchange turns digital.",
      "when-to-use": "Hotels, clinics, print shops, repair counters, tour desks, and delivery desks are the natural places for it.",
      "good-to-know": "Confirm the address before you leave. One wrong letter can make the receipt, invoice, or confirmation disappear.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and ready-time cards cover nearby service-counter tasks."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "gửi email", english: "send by email", keepTogetherReason: "email-send phrase" },
      { id: "chunk-3", vietnamese: "cho tôi", english: "to me / for me", keepTogetherReason: "recipient phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a title-only email request into a receipt/document handoff with concrete counter behavior"
  },
  {
    id: "viet-phrase-v900-sigh-acti-is-lunch-included",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-lunch-included.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-lunch-included.json",
    summary: "For checking whether a tour, ticket, or activity already includes lunch.",
    bodies: {
      "at-glance": "Ask before buying snacks, adding a meal option, or leaving the meeting point.",
      "quick-say": "Show the booking or ticket and point to the full-day schedule if the plan runs through lunch.",
      breakdown: "Có bao gồm asks whether it is included; bữa trưa means lunch; không? makes it a yes/no question.",
      "natural-variants": "Ticket-price, start-point, and photo-permission cards cover the next attraction-desk questions.",
      "when-to-use": "Use it for boat trips, cooking classes, day tours, museum packages, and full-day activity bookings.",
      "good-to-know": "Included can still mean a set meal, voucher, or simple stop. Ask before assuming drinks or special diets are covered.",
      "explore-next": "Close-time, meeting-point, advance-booking, tour-booking, and entrance cards cover nearby activity planning."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có bao gồm", english: "is included", keepTogetherReason: "included phrase" },
      { id: "chunk-2", vietnamese: "bữa trưa", english: "lunch", keepTogetherReason: "meal noun" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the lunch-included page about real tour inclusions instead of generic attraction scaffolding"
  },
  {
    id: "viet-phrase-help-premium-call-this-number",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/help-premium-call-this-number.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/help-call-this-number.json",
    summary: "For asking a desk, shop, or nearby helper to call a specific number for you.",
    bodies: {
      "at-glance": "Best when the number is already visible on your phone, receipt, booking, or sign.",
      "quick-say": "Show the number first. Say who it belongs to if you know: hotel, driver, clinic, bank, or tour desk.",
      breakdown: "Bạn có thể asks can you; gọi số này means call this number; hộ tôi means for me; được không? asks if it is possible.",
      "natural-variants": "Lost and left-something-behind cards help when the call is part of a simple handoff.",
      "when-to-use": "Hotel desks, shop counters, police or tourist help desks, and transport counters are the right places to ask.",
      "good-to-know": "Keep the request narrow. Do not hand over private details unless the call actually needs them.",
      "explore-next": "Direct-help, call-hotel, manager, charged-twice, and report cards cover the next help-desk move."
    },
    filterSectionPhraseDetailPageIDs: {
      "natural-variants": ["viet-family-help-need-help"]
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "gọi số này", english: "call this number", keepTogetherReason: "call-this-number phrase" },
      { id: "chunk-3", vietnamese: "hộ tôi", english: "for me", keepTogetherReason: "helping-for-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "anchors the page in a phone-number handoff and removes only a duplicate, non-rendered help card from source"
  },
  {
    id: "viet-phrase-help-premium-come-with-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/help-premium-come-with-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/help-come-with-me.json",
    summary: "For asking someone to walk with you to a desk, entrance, room, or problem spot.",
    bodies: {
      "at-glance": "Reach for this when pointing is not enough and the person needs to see the place with you.",
      "quick-say": "Ask once, then gesture toward the door, counter, room, vehicle, or item. Keep the reason short.",
      breakdown: "Bạn có thể asks can you; đi cùng tôi means come or go with me; được không? asks if it is possible.",
      "natural-variants": "Lost and left-something-behind cards fit when the next step is showing the place.",
      "when-to-use": "Hotels, stations, clinics, venues, repair counters, and security desks are common places for this handoff.",
      "good-to-know": "This is a bigger ask than calling or pointing. It fits situations that truly need someone to come see the problem.",
      "explore-next": "Direct-help, call-hotel, manager, charged-twice, and report cards cover nearby escalation paths."
    },
    filterSectionPhraseDetailPageIDs: {
      "natural-variants": ["viet-family-help-need-help"]
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "đi cùng tôi", english: "come with me / go with me", keepTogetherReason: "come-with-me phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the page about a real physical handoff and removes only a duplicate, non-rendered help card from source"
  },
  {
    id: "viet-phrase-hotel-8",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/hotel-8.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/hotel-key-card.json",
    summary: "For telling the front desk your room key card is not opening the door.",
    bodies: {
      "at-glance": "Bring the key card and room number to the desk before explaining the whole problem.",
      "quick-say": "Show the card while you say the line. Staff may test, reset, or replace it.",
      breakdown: "Thẻ phòng means room key card; không mở được means does not open or does not work.",
      "natural-variants": "Reservation, check-in, and polite check-in cards help if the desk needs to find your stay.",
      "when-to-use": "Use it at a hotel, guesthouse, hostel, or apartment desk when the card will not open the room.",
      "good-to-know": "Keep the room number visible, but do not say it loudly in a crowded lobby if privacy matters.",
      "explore-next": "Checkout-time, quiet-room, checkout, hot-room, and air-conditioner cards cover nearby front-desk problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Thẻ phòng", english: "room key card", keepTogetherReason: "key-card phrase" },
      { id: "chunk-2", vietnamese: "không mở được", english: "does not open / does not work", keepTogetherReason: "not-opening phrase" }
    ],
    value: "replaces generic hotel prose with a precise key-card reset moment"
  },
  {
    id: "viet-phrase-time-6",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/time-6.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/time-move-later.json",
    summary: "For asking to push a booking, pickup, ticket time, or appointment later.",
    bodies: {
      "at-glance": "Ask while the current time is visible on the booking, ticket, calendar, or chat.",
      "quick-say": "Show the original time first. Then listen for the new slot, fee, or no-change answer.",
      breakdown: "Dời lại means move or reschedule; muộn hơn means later; được không? asks if it is possible.",
      "natural-variants": "What-time, today, and tomorrow-morning cards help if the answer becomes a new time choice.",
      "when-to-use": "Booking desks, tour counters, clinic appointments, pickup chats, and ticket windows are natural places for it.",
      "good-to-know": "A later time may cost more or depend on availability. Keep the booking code ready for the follow-up.",
      "explore-next": "Booking, opening-time, boarding-time, wait-time, and one-ticket cards cover nearby schedule decisions."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Dời lại", english: "move / reschedule", keepTogetherReason: "reschedule verb" },
      { id: "chunk-2", vietnamese: "muộn hơn", english: "later", keepTogetherReason: "later-time phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a generic timing page into a concrete reschedule request"
  },
  {
    id: "viet-phrase-v500-dire-navi-is-it-next-to-the-hotel",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-is-it-next-to-the-hotel.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-is-it-next-to-the-hotel.json",
    summary: "For confirming whether a shop, pickup point, entrance, or stop is next to the hotel.",
    bodies: {
      "at-glance": "Helpful when the map looks close but you want the hotel landmark confirmed.",
      "quick-say": "Show the hotel name or map pin, then pause for yes, no, or a correction.",
      breakdown: "Nó means it; có ở cạnh asks if it is next to; khách sạn means hotel; không? makes it yes/no.",
      "natural-variants": "How-to-get-there, nearby, and walking-time cards help when the answer turns into directions.",
      "when-to-use": "Ask before walking, boarding, or paying when a hotel is the clearest landmark.",
      "good-to-know": "Hotel names can repeat or sound similar. A map pin helps the listener confirm the right building.",
      "explore-next": "Left-turn, right-turn, straight-ahead, understand-now, and pickup-point cards cover the next route step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Nó", english: "it", keepTogetherReason: "subject pronoun" },
      { id: "chunk-2", vietnamese: "có ở cạnh", english: "is next to", keepTogetherReason: "next-to phrase" },
      { id: "chunk-3", vietnamese: "khách sạn", english: "hotel", keepTogetherReason: "hotel noun" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the page about landmark confirmation instead of a generic yes/no direction template"
  },
  {
    id: "viet-phrase-v500-heal-phar-i-have-chest-pain",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-chest-pain.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-chest-pain.json",
    summary: "For clearly saying chest pain at a clinic, pharmacy, hotel desk, or emergency desk.",
    bodies: {
      "at-glance": "Treat this as urgent. Say the symptom first, especially if pain is strong, sudden, or paired with breathing trouble.",
      "quick-say": "Point to your chest, show any medicine or allergy note, and let staff call medical help if needed.",
      breakdown: "Tôi bị means I have or I am affected by; đau ngực means chest pain.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy cards help when staff need to route you quickly.",
      "when-to-use": "Use it with clinic staff, pharmacy staff, hotel staff, emergency desks, or any helper calling medical help.",
      "good-to-know": "Chest pain should not be treated as a normal pharmacy errand if it is severe, sudden, or hard to breathe.",
      "explore-next": "Headache, stomach pain, motion-sickness medicine, allergy, and diarrhea cards cover less urgent nearby symptoms."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I have / I am affected by", keepTogetherReason: "symptom opener" },
      { id: "chunk-2", vietnamese: "đau ngực", english: "chest pain", keepTogetherReason: "symptom phrase" }
    ],
    value: "adds urgency and safe traveler guidance to a serious symptom page without weakening the phrase"
  },
  {
    id: "viet-phrase-v500-hote-acco-there-is-no-hot-water",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-there-is-no-hot-water.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/hotel-no-hot-water.json",
    summary: "For telling the front desk the shower only runs cold.",
    bodies: {
      "at-glance": "Say it before asking to change rooms or have maintenance come up.",
      "quick-say": "Give the room number and point to the bathroom if staff need to check.",
      breakdown: "Vòi sen means shower; chỉ có means only has; nước lạnh means cold water.",
      "natural-variants": "No-hot-water, reservation, and check-in cards help if the desk needs context before fixing it.",
      "when-to-use": "Use it at a hotel, guesthouse, hostel, or apartment desk when the shower has no hot water.",
      "good-to-know": "If the desk says wait, ask when to try again or whether another room is available.",
      "explore-next": "Polite check-in, checkout-time, quiet-room, checkout, and hot-room cards cover nearby stay issues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vòi sen", english: "shower", keepTogetherReason: "shower noun" },
      { id: "chunk-2", vietnamese: "chỉ có", english: "only has", keepTogetherReason: "only-has phrase" },
      { id: "chunk-3", vietnamese: "nước lạnh", english: "cold water", keepTogetherReason: "cold-water phrase" }
    ],
    value: "fixes the hotel page around a concrete shower problem and repairs the misleading breakdown gloss"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-can-you-give-me-change",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-can-you-give-me-change.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-can-you-give-me-change.json",
    summary: "For asking someone to break a bill into smaller cash.",
    bodies: {
      "at-glance": "Show the bill and the smaller amount you need before the exchange gets confusing.",
      "quick-say": "Ask before paying if the stall, taxi, or ticket counter may not have change.",
      breakdown: "Bạn có thể asks can you; cho tôi means give me; tiền lẻ means small bills or change; được không? asks if possible.",
      "natural-variants": "How-much and per-kilo cards help when the cash question starts with a price check.",
      "when-to-use": "Market stalls, taxis, small shops, ticket counters, cafes, and kiosks are the common places for it.",
      "good-to-know": "Small bills are useful in Vietnam. Keep the request visible so the other person knows what you want broken.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover nearby payment moments."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "cho tôi", english: "give me", keepTogetherReason: "give-me phrase" },
      { id: "chunk-3", vietnamese: "tiền lẻ", english: "small bills / change", keepTogetherReason: "change noun" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the cash page about breaking bills rather than a generic money request"
  },
  {
    id: "viet-phrase-v900-dire-navi-is-it-past-the-traffic-light",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-is-it-past-the-traffic-light.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-is-it-past-the-traffic-light.json",
    summary: "For confirming whether the place is beyond the traffic light.",
    bodies: {
      "at-glance": "Best for directions that depend on one clear street landmark.",
      "quick-say": "Point down the road or at the map. Listen for before, after, left, or right.",
      breakdown: "Có opens the yes/no check; vượt qua means go past; đèn giao thông means traffic light; không? asks yes/no.",
      "natural-variants": "How-to-get-there, nearby, and walking-time cards help when the answer becomes route detail.",
      "when-to-use": "Ask at corners, shopfronts, taxi doors, hotel desks, or security desks before you walk farther.",
      "good-to-know": "Traffic lights are easier anchors than street names when pronunciation or spelling is uncertain.",
      "explore-next": "Left-turn, right-turn, straight-ahead, understand-now, and pickup-point cards cover the next direction."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "does it", keepTogetherReason: "yes-no opener" },
      { id: "chunk-2", vietnamese: "vượt qua", english: "go past", keepTogetherReason: "go-past phrase" },
      { id: "chunk-3", vietnamese: "đèn giao thông", english: "traffic light", keepTogetherReason: "traffic-light phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a generic direction confirmation into a landmark-based walking check"
  },
  {
    id: "viet-phrase-v900-dire-navi-is-this-the-correct-street",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-is-this-the-correct-street.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-is-this-the-correct-street.json",
    summary: "For checking whether you are on the right street before walking farther.",
    bodies: {
      "at-glance": "Ask at the corner, taxi door, shopfront, or map stop before committing to the route.",
      "quick-say": "Show the street name or pin. A yes/no answer is enough before you keep moving.",
      breakdown: "Đây có phải là asks is this; đường phố chính xác means the correct street; không? makes it yes/no.",
      "natural-variants": "How-to-get-there, nearby, and walking-time cards help if the answer becomes a route correction.",
      "when-to-use": "Best when the street sign, map pin, entrance, or pickup note looks close but not certain.",
      "good-to-know": "Street names can be hard to hear at speed. Show the sign or map so the other person can confirm with a point or short answer.",
      "explore-next": "Left-turn, right-turn, straight-ahead, understand-now, and pickup-point cards cover the next route move."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải là", english: "is this", keepTogetherReason: "is-this phrase" },
      { id: "chunk-2", vietnamese: "đường phố chính xác", english: "the correct street", keepTogetherReason: "correct-street phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the page honest about route-check use while flagging phrase naturalness for later audio-aware review"
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
      batch: 27,
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
      reason: "premium_audit_batch_27"
    });
    if (repair.filterSectionPhraseDetailPageIDs) {
      ledgerRows.push({
        batch: 27,
        tierRole: page.tierRole,
        sectionID: "source-render-card-parity",
        sectionTitle: "Source/render card parity",
        pageID: page.id,
        phraseID: page.phraseID,
        sourcePath: repair.source,
        before: {
          phraseCards: countSectionItems(before, "phrases"),
          issue: "source natural-variants carried a duplicate help card already represented by the richer explore-next help target"
        },
        after: {
          phraseCards: countSectionItems(page, "phrases"),
          repair: "removed only the duplicate, non-rendered natural-variants target so source matches rendered proof"
        },
        preservedPhraseCards: countSectionItems(page, "phrases"),
        preservedBreakdownRows: countSectionItems(page, "breakdown"),
        concreteTravelerValueImproved: "keeps rendered traveler cards intact while removing source-only duplicate drift",
        reason: "premium_audit_batch_27_card_parity"
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
    batch: 27,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
