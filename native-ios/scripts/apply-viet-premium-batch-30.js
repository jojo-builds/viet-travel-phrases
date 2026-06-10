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
    id: "viet-phrase-v500-food-drin-i-am-allergic-to-fish-sauce",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-i-am-allergic-to-fish-sauce.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v500-food-drin-i-am-allergic-to-fish-sauce.json",
    summary: "For telling a restaurant or stall that fish sauce is an allergy issue before you order.",
    bodies: {
      "at-glance": "Say it before the dish is cooked, especially when a sauce, broth, or marinade is unclear.",
      "quick-say": "Show the menu line or allergy note while staff check whether fish sauce is in the dish.",
      breakdown: "Tôi bị means I am affected by; dị ứng với means allergic to; nước mắm means fish sauce.",
      "when-to-use": "Good at noodle shops, seafood stalls, dipping-sauce counters, and restaurants where sauces come separately.",
      "good-to-know": "Fish sauce can be in broths, marinades, and dipping bowls, even when the dish does not look fishy.",
      "explore-next": "No-meat, shellfish, general-allergy, and peanut-repair pages cover the next allergy check.",
      "natural-variants": "Nearby food-safety phrases help when staff needs a replacement order or a safer dish."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I am affected by", keepTogetherReason: "affected-by phrase" },
      { id: "chunk-2", vietnamese: "dị ứng với", english: "allergic to", keepTogetherReason: "allergy phrase" },
      { id: "chunk-3", vietnamese: "nước mắm", english: "fish sauce", keepTogetherReason: "fish-sauce noun" }
    ],
    value: "turns a title-only allergy page into a specific fish-sauce restaurant check"
  },
  {
    id: "viet-phrase-v500-loca-serv-ever-task-is-there-a-ramp",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-is-there-a-ramp.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-is-there-a-ramp.json",
    summary: "For asking whether there is a ramp before moving bags, a stroller, or a wheelchair.",
    bodies: {
      "at-glance": "Ask at the entrance before committing to stairs or a narrow doorway.",
      "quick-say": "Point to the steps, doorway, bag, stroller, or chair so the answer can be a direction.",
      breakdown: "Có asks is there; đoạn đường nối means ramp; không? makes it yes/no.",
      "natural-variants": "The extra cards cover small counter asks that often happen after the access question.",
      "when-to-use": "Good at stations, hotels, shops, clinics, malls, and service counters with steps at the entrance.",
      "good-to-know": "The answer may be a point to a side entrance, lift, or back door. Wait for the gesture before moving.",
      "explore-next": "Print, receipt, card-payment, open-this, and repair-bag pages cover nearby service-counter details."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "is there", keepTogetherReason: "existence question opener" },
      { id: "chunk-2", vietnamese: "đoạn đường nối", english: "ramp", keepTogetherReason: "ramp noun" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the ramp question about real entrance access instead of generic service-counter copy"
  },
  {
    id: "viet-phrase-v500-phon-inte-powe-can-you-activate-it-for-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-you-activate-it-for-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-you-activate-it-for-me.json",
    summary: "For asking a SIM, eSIM, app, or phone-shop clerk to activate the service for you.",
    bodies: {
      "at-glance": "The purchase is done; the phone still needs the counter to make it work.",
      "quick-say": "Keep the SIM, eSIM QR code, error screen, or setup page visible.",
      breakdown: "Bạn có thể asks can you; kích hoạt means activate; nó cho tôi means it for me; được không? asks if it is possible.",
      "natural-variants": "Wi-Fi password, SIM-card, and data-top-up pages help if activation turns into setup trouble.",
      "when-to-use": "Good at airport SIM counters, phone shops, hotel desks, and mobile-service kiosks.",
      "good-to-know": "Activation may need a passport, code, restart, or APN setting. Let staff point to the next screen.",
      "explore-next": "No-signal, OTP, eSIM, charging, and written-password pages cover problems that can show up after activation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "kích hoạt", english: "activate", keepTogetherReason: "activate verb" },
      { id: "chunk-3", vietnamese: "nó cho tôi", english: "it for me", keepTogetherReason: "it-for-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "anchors activation copy in a real SIM/eSIM setup moment"
  },
  {
    id: "viet-phrase-v500-shop-this-is-too-big",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v500-shop-this-is-too-big.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v500-shop-this-is-too-big.json",
    summary: "For telling a shop that the item or size is too big.",
    bodies: {
      "at-glance": "Point to the item on your body, bag, table, or receipt so the size problem is obvious.",
      "quick-say": "Hold the item while you say it, then show the smaller size, color, or exchange option you want.",
      breakdown: "Cái này means this one; quá means too; lớn means big.",
      "natural-variants": "Size, color, and try-on phrases keep the shop conversation moving.",
      "when-to-use": "Good at clothing stalls, shoe shops, souvenir counters, markets, and exchange desks.",
      "good-to-know": "If you need a smaller one, point to the size tag or hold two options side by side.",
      "explore-next": "Looking, payment, exchange, price, and bargaining pages cover nearby shop turns."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái này", english: "this one", keepTogetherReason: "this-one phrase" },
      { id: "chunk-2", vietnamese: "quá", english: "too", keepTogetherReason: "too adverb" },
      { id: "chunk-3", vietnamese: "lớn", english: "big", keepTogetherReason: "big adjective" }
    ],
    value: "turns the size page into a concrete shop exchange moment"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-can-you-copy-this-document",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-copy-this-document.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-copy-this-document.json",
    summary: "For asking a print shop, hotel desk, or service counter to copy a document.",
    bodies: {
      "at-glance": "Have the document ready and keep the page count visible if there is more than one sheet.",
      "quick-say": "Hand over or show the document first, then point to the page or side you need copied.",
      breakdown: "Bạn có thể asks can you; sao chép means copy; tài liệu này means this document.",
      "natural-variants": "The extra counter cards are useful if the copy errand turns into a longer wait.",
      "when-to-use": "Good at copy shops, hotel desks, reception counters, visa offices, and travel-agency desks.",
      "good-to-know": "If they ask about color or black-and-white, point to a sample or use the print follow-up next.",
      "explore-next": "Print-this, black-and-white, email-it, receipt, and ready-time pages cover the next copy-shop details."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "sao chép", english: "copy", keepTogetherReason: "copy verb" },
      { id: "chunk-3", vietnamese: "tài liệu này?", english: "this document?", keepTogetherReason: "this-document noun with question mark" }
    ],
    value: "makes the document-copy page specific to a real copy-shop counter"
  },
  {
    id: "viet-phrase-v900-phon-inte-powe-how-long-will-the-repair-take",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-how-long-will-the-repair-take.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-how-long-will-the-repair-take.json",
    summary: "For asking how long a phone or device repair will take.",
    bodies: {
      "at-glance": "Ask before leaving the device, paying a deposit, or agreeing to wait nearby.",
      "quick-say": "Show the phone, ticket, or repair note so staff can answer with a time.",
      breakdown: "Việc sửa chữa means the repair; sẽ mất means will take; bao lâu? asks how long.",
      "natural-variants": "Wi-Fi and SIM phrases help if the repair counter starts checking setup instead of hardware.",
      "when-to-use": "Good at phone shops, repair kiosks, hotel desks, and electronics counters.",
      "good-to-know": "Ask for the pickup time in writing if the answer is fast or the timing matters.",
      "explore-next": "Battery, charger, receipt, data, and written-password pages cover nearby repair-counter problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Việc sửa chữa", english: "the repair", keepTogetherReason: "repair noun phrase" },
      { id: "chunk-2", vietnamese: "sẽ mất", english: "will take", keepTogetherReason: "will-take phrase" },
      { id: "chunk-3", vietnamese: "bao lâu?", english: "how long?", keepTogetherReason: "how-long question" }
    ],
    value: "reframes the repair-duration page around a device counter decision"
  },
  {
    id: "viet-phrase-v900-time-date-book-please-send-the-refund-to-this-card",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-please-send-the-refund-to-this-card.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-please-send-the-refund-to-this-card.json",
    summary: "For asking a refund to go back to the card you are showing.",
    bodies: {
      "at-glance": "After a booking, ticket, or order is cancelled, the refund card becomes the important detail.",
      "quick-say": "Show the card, receipt, or payment screen so the refund destination is clear.",
      breakdown: "Vui lòng gửi means please send; tiền hoàn lại means refund; vào thẻ này means to this card.",
      "natural-variants": "Time and date phrases help if the refund depends on the original booking window.",
      "when-to-use": "Good at booking desks, ticket counters, hotel desks, tour offices, and message threads after a cancellation.",
      "good-to-know": "Refunds can take time. Ask for a receipt or written confirmation before leaving.",
      "explore-next": "Booking, opening-time, move-later, boarding, and wait pages cover nearby schedule questions."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng gửi", english: "please send", keepTogetherReason: "please-send phrase" },
      { id: "chunk-2", vietnamese: "tiền hoàn lại", english: "the refund", keepTogetherReason: "refund noun" },
      { id: "chunk-3", vietnamese: "vào thẻ này", english: "to this card", keepTogetherReason: "to-this-card phrase" }
    ],
    value: "turns the refund page into a specific payment-destination request"
  },
  {
    id: "viet-phrase-food-16",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-16.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/food-wrong-order.json",
    summary: "For telling a server or stall that the dish is not what you ordered.",
    bodies: {
      "at-glance": "Keep it calm and point to the dish or receipt before the table gets crowded.",
      "quick-say": "Show the menu line, ticket, or photo so staff can compare the order quickly.",
      breakdown: "Đây không phải means this is not; món tôi gọi means the dish I ordered.",
      "when-to-use": "Good at stalls, cafes, restaurants, delivery counters, and busy food courts when the wrong item arrives.",
      "good-to-know": "A photo or receipt keeps the correction factual and less awkward.",
      "explore-next": "Chili, napkin, half-portion, two-of-these, and one-more pages help after the right dish is back in front of you.",
      "natural-variants": "Herbs, utensils, rice, spice, and side-sauce pages cover small fixes when the dish is right but needs adjusting."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây không phải", english: "this is not", keepTogetherReason: "this-is-not phrase" },
      { id: "chunk-2", vietnamese: "món tôi gọi", english: "the dish I ordered", keepTogetherReason: "ordered-dish phrase" }
    ],
    value: "makes the wrong-order page about a calm restaurant correction"
  },
  {
    id: "viet-phrase-phone-premium-no-signal",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/phone-premium-no-signal.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/phone-no-signal.json",
    summary: "For telling a hotel desk, cafe, or phone shop that your phone has no signal here.",
    bodies: {
      "at-glance": "Show the signal bars or error screen before asking for help.",
      "quick-say": "Keep the phone unlocked so staff can see whether it is signal, SIM, or data.",
      breakdown: "Không có means there is no; tín hiệu means signal; ở đây means here.",
      "natural-variants": "Wi-Fi, SIM, and data phrases help when the fix is changing networks instead of moving locations.",
      "when-to-use": "Good at SIM counters, hotels, cafes, airports, and phone shops when service drops.",
      "good-to-know": "If the place has Wi-Fi, ask for the password while the mobile signal is down.",
      "explore-next": "Data top-up, eSIM, OTP, activation, and charging pages cover nearby phone-troubleshooting turns."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Không có", english: "there is no", keepTogetherReason: "there-is-no phrase" },
      { id: "chunk-2", vietnamese: "tín hiệu", english: "signal", keepTogetherReason: "signal noun" },
      { id: "chunk-3", vietnamese: "ở đây.", english: "here", keepTogetherReason: "here phrase with punctuation" }
    ],
    value: "removes translation fallback copy and makes the no-signal page actionable"
  },
  {
    id: "viet-phrase-phone-premium-otp-not-arriving",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/phone-premium-otp-not-arriving.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/phone-otp-not-arriving.json",
    summary: "For explaining that a verification code is not arriving on your phone.",
    bodies: {
      "at-glance": "Login, payment, SIM setup, or booking verification can get stuck on this code step.",
      "quick-say": "Show the waiting screen and phone number so staff can check the next step.",
      breakdown: "Mã xác minh means verification code; không đến means not arriving.",
      "natural-variants": "Wi-Fi, SIM, and data phrases help if the code problem is really a network problem.",
      "when-to-use": "Good at phone shops, hotel desks, bank counters, booking desks, and app help chats.",
      "good-to-know": "A retry may take a minute. Ask before sending the code again if staff are helping.",
      "explore-next": "No-signal, eSIM, activation, written-password, and data pages cover the nearby setup problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Mã xác minh", english: "verification code", keepTogetherReason: "verification-code noun" },
      { id: "chunk-2", vietnamese: "không đến.", english: "is not arriving", keepTogetherReason: "not-arriving phrase" }
    ],
    value: "turns a formula translation page into a real stuck-verification-code support moment"
  },
  {
    id: "viet-phrase-v500-food-drin-this-tastes-spoiled",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-this-tastes-spoiled.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v500-food-drin-this-tastes-spoiled.json",
    summary: "For telling staff that the food tastes spoiled or off.",
    bodies: {
      "at-glance": "Keep it calm when the taste seems wrong enough that you should stop eating.",
      "quick-say": "Point to the dish and keep the wording short; the goal is a safe replacement or check.",
      breakdown: "Cái này means this; có vị means tastes; hư hỏng means spoiled.",
      "when-to-use": "Good at restaurants, stalls, food courts, and delivery counters when freshness is the issue.",
      "good-to-know": "You do not need to argue. A short sentence and the dish in front of you are enough.",
      "explore-next": "Undercooked, cold, something-in-my-food, and change-this pages cover the replacement or correction path.",
      "natural-variants": "Food-safety follow-ups help when the problem is freshness, doneness, or something in the dish."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái này", english: "this", keepTogetherReason: "this phrase" },
      { id: "chunk-2", vietnamese: "có vị", english: "tastes", keepTogetherReason: "taste phrase" },
      { id: "chunk-3", vietnamese: "hư hỏng", english: "spoiled", keepTogetherReason: "spoiled adjective" }
    ],
    value: "makes the spoiled-food page calm, safety-aware, and specific"
  },
  {
    id: "viet-phrase-v500-phon-inte-powe-please-write-the-password",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-please-write-the-password.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-please-write-the-password.json",
    summary: "For asking someone to write down a Wi-Fi or account password.",
    bodies: {
      "at-glance": "Ask when hearing the password is not enough to type it correctly.",
      "quick-say": "Show the phone or login screen so they know which password you mean.",
      breakdown: "Vui lòng means please; viết means write; mật khẩu means password.",
      "natural-variants": "Wi-Fi, SIM, and activation phrases help if the password is part of a setup flow.",
      "when-to-use": "Good at hotel desks, cafes, SIM counters, coworking spaces, and shops with guest Wi-Fi.",
      "good-to-know": "Passwords are easier when written. Let staff type or write it if pronunciation is unclear.",
      "explore-next": "Activation, no-signal, OTP, data, and eSIM pages cover nearby phone-setup problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "please opener" },
      { id: "chunk-2", vietnamese: "viết", english: "write", keepTogetherReason: "write verb" },
      { id: "chunk-3", vietnamese: "mật khẩu", english: "password", keepTogetherReason: "password noun" }
    ],
    value: "turns a password page into a practical hotel/cafe setup request"
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
      batch: 30,
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
      reason: "premium_audit_batch_30"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-500/generated-rows.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];
  const ledgerRowsAdded = appendLedger(ledgerRows);

  console.log(JSON.stringify({
    batch: 30,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
