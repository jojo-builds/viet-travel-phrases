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
    id: "viet-phrase-repair-premium-spell-name",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/repair-premium-spell-name.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/repair-spell-name.json",
    beforeSummary: "Can you spell the name for me?",
    summary: "For getting a hotel, driver, ticket desk, or contact name letter by letter so you can copy it correctly.",
    bodies: {
      "at-glance": "Good when a name is spoken too quickly to type. Open the form, note, or booking screen first.",
      "quick-say": "Hold the phone or paper where they can see it. Let them spell, then repeat the letters or show what you typed.",
      breakdown: "Bạn có thể asks can you; đánh vần tên means spell the name; cho tôi được không makes it a polite request.",
      "natural-variants": "Slower, repeat, and write-down cards stay nearby for moments when a name, address, or number still is not landing.",
      "when-to-use": "Best at hotel desks, ticket counters, phone calls on speaker, ride pickup points, and forms where one wrong letter matters.",
      "good-to-know": "Vietnamese names may include tone marks. If exact spelling matters, ask them to type it or check your screen.",
      "explore-next": "Move to say-again, write-down, meaning, which-one, or show-me cards if the spelling turns into another clarification."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "đánh vần tên", english: "spell the name", keepTogetherReason: "spell-name phrase" },
      { id: "chunk-3", vietnamese: "cho tôi", english: "for me", keepTogetherReason: "for-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a title-only spelling page into a real form, pickup, and contact-name clarification moment without dropping repair cards"
  },
  {
    id: "viet-phrase-v500-prob-help-can-you-check-the-security-camera",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-can-you-check-the-security-camera.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-can-you-check-the-security-camera.json",
    beforeSummary: "Can you check the security camera?",
    summary: "For asking staff to review camera footage after a lost item, wrong bag, room issue, or pickup confusion.",
    bodies: {
      "at-glance": "Use this at a desk with the time, place, and item visible. The more exact the moment, the easier the ask.",
      "quick-say": "Show the receipt, room number, ride screen, or photo first. Then ask for the camera check in one calm sentence.",
      breakdown: "Bạn có thể asks can you; kiểm tra means check; camera an ninh means security camera; được không softens the request.",
      "natural-variants": "Lost, left-something, and help cards cover the story you may need before staff can look.",
      "when-to-use": "Good at hotels, shops, stations, cafes, apartment lobbies, and parking areas where a camera may cover the spot.",
      "good-to-know": "Staff may need a manager, time range, or location. Keep the detail short and avoid turning it into a long accusation.",
      "explore-next": "Move to need-help, call-hotel, manager, charged-twice, or file-report cards if the desk asks for the next step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "kiểm tra", english: "check", keepTogetherReason: "compound verb" },
      { id: "chunk-3", vietnamese: "camera an ninh", english: "security camera", keepTogetherReason: "security-camera phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "replaces generic help copy and bad source glosses with a specific lost-item/security-desk request"
  },
  {
    id: "viet-phrase-v500-shop-can-i-return-it",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v500-shop-can-i-return-it.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v500-shop-can-i-return-it.json",
    beforeSummary: "Can I return it?",
    summary: "For asking about a return while the item, receipt, size tag, or payment record is still easy to show.",
    bodies: {
      "at-glance": "Best before leaving the shop or as soon as you notice the problem. Keep the item visible.",
      "quick-say": "Show the item and receipt first. The question gives the seller a clear yes/no before you explain why.",
      breakdown: "Tôi có thể asks can I; trả lại means return or give back; nó means it; được không softens the question.",
      "natural-variants": "Size, color, and try-on cards stay nearby if the answer becomes an exchange instead of a refund.",
      "when-to-use": "Good in shops, market stalls, mall counters, and small boutiques where policies may be informal.",
      "good-to-know": "Returns can be harder in small shops. A calm question plus the receipt gives you the best chance of a clear answer.",
      "explore-next": "Move to just-looking, where-pay, exchange-this, item-price, or lower-price cards if the shop conversation continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "trả lại", english: "return / give back", keepTogetherReason: "return verb" },
      { id: "chunk-3", vietnamese: "nó", english: "it", keepTogetherReason: "object pronoun" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "grounds the return page in a receipt/item counter moment while preserving exchange and price follow-ups"
  },
  {
    id: "viet-phrase-v500-sigh-acti-where-is-the-exit",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v500-sigh-acti-where-is-the-exit.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v500-sigh-acti-where-is-the-exit.json",
    beforeSummary: "Where is the exit?",
    summary: "For finding the exit from a market, museum, station, temple, mall, or attraction when signs are not obvious.",
    bodies: {
      "at-glance": "Ask near a doorway, corridor, ticket area, or crowd flow. Watch for the first gesture after the answer.",
      "quick-say": "Keep it short and look where they point. If there are several exits, show the street, pickup point, or map next.",
      breakdown: "Lối ra means exit; ở đâu asks where.",
      "natural-variants": "Ticket, start-point, and photo-rule cards cover the attraction questions that often happen nearby.",
      "when-to-use": "Good in markets, museums, stations, pagodas, malls, event spaces, and tour stops with multiple doors.",
      "good-to-know": "The answer may be a point, floor, or turn rather than a full sentence. Follow the gesture first.",
      "explore-next": "Move to closing-time, meeting-point, book-in-advance, tour-booking, or entrance cards if you need the next logistics detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Lối ra", english: "the exit", keepTogetherReason: "exit phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "turns an exit title into a concrete multi-door attraction/station navigation page while keeping sightseeing cards"
  },
  {
    id: "viet-phrase-v500-unde-repa-can-you-write-the-time",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-can-you-write-the-time.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-can-you-write-the-time.json",
    beforeSummary: "Can you write the time?",
    summary: "For getting a pickup time, booking time, closing time, or appointment time written clearly.",
    bodies: {
      "at-glance": "When a spoken time is too fast, noisy, or easy to mishear, ask for it on paper or in your notes app.",
      "quick-say": "Show the booking, ticket, or notes app. Let them write the time before you ask about where to go.",
      breakdown: "Bạn có thể asks can you; viết thời gian means write the time; được không softens the request.",
      "natural-variants": "Slower, repeat, and write-down cards help when the time still comes back too quickly.",
      "when-to-use": "Good at ticket desks, hotels, clinics, tour counters, restaurants, stations, and pickup points.",
      "good-to-know": "Times can be misunderstood across accents and noise. A written time is safer than guessing from memory.",
      "explore-next": "Move to say-again, write-down, meaning, which-one, or show-me cards if another detail is unclear."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "viết thời gian", english: "write the time", keepTogetherReason: "write-time phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "fixes a bad price gloss and makes the page about exact written timing rather than generic misunderstanding"
  },
  {
    id: "viet-phrase-v500-unde-repa-is-this-the-right-number",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-is-this-the-right-number.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-is-this-the-right-number.json",
    beforeSummary: "Is this the right number?",
    summary: "For confirming a price, phone number, room number, platform, address number, or ticket number before acting.",
    bodies: {
      "at-glance": "Good when you already have a number on screen or paper and need a quick check.",
      "quick-say": "Point to the number you mean. Pause for yes, no, or a correction before paying, calling, boarding, or signing.",
      breakdown: "Đây có phải asks is this; là con số means the number; đúng không asks correct?",
      "natural-variants": "Slower and repeat cards help if the correction comes back too quickly.",
      "when-to-use": "Good before entering a code, paying an amount, calling a contact, choosing a platform, or checking a room number.",
      "good-to-know": "This page is about one number, not a whole explanation. Keep the number visible until it is confirmed.",
      "explore-next": "Move to say-again, write-down, meaning, which-one, or show-me cards if the correction needs another pass."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải", english: "is this", keepTogetherReason: "is-this question start" },
      { id: "chunk-2", vietnamese: "là con số", english: "the number", keepTogetherReason: "number noun phrase" },
      { id: "chunk-3", vietnamese: "đúng không?", english: "correct?", keepTogetherReason: "correctness question" }
    ],
    value: "makes number confirmation concrete across travel contexts and fixes the source breakdown start"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-have-chili-sauce",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-chili-sauce.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-chili-sauce.json",
    beforeSummary: "Can I have chili sauce?",
    summary: "For asking for chili sauce at a table, stall, or counter without turning it into a long condiment request.",
    bodies: {
      "at-glance": "Best when the food is already in front of you or the sauce tray is nearby.",
      "quick-say": "Point to the dish or sauce area first. The phrase can mean asking to use or get the chili sauce.",
      breakdown: "Tôi có thể asks can I; dùng tương ớt means use chili sauce; được không softens the request.",
      "when-to-use": "Good at noodle shops, street stalls, rice plates, barbecue spots, cafes, and casual restaurants.",
      "good-to-know": "Vietnamese chili condiments vary by place. Point if you want the bottle, packet, or table sauce.",
      "explore-next": "Move to napkins, half-portion, two-of-these, one-more, or one-portion cards as the meal continues.",
      "natural-variants": "Herbs, utensils, rice, soup-on-side, and sauce-on-side cards cover the small table requests nearby."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "dùng tương ớt", english: "use chili sauce", keepTogetherReason: "chili-sauce request" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "keeps the ready audio while clarifying the have/use nuance and making the table request specific"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-order-this-without-meat",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-order-this-without-meat.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-i-order-this-without-meat.json",
    beforeSummary: "Can I order this without meat?",
    summary: "For asking whether a dish can be made without meat before staff starts preparing it.",
    bodies: {
      "at-glance": "Use it while pointing at the menu item or dish photo. The request needs the exact dish in view.",
      "quick-say": "Ask before ordering, then wait for yes, no, or a suggested alternative. Do not bury the meat request inside extra details.",
      breakdown: "Tôi có thể asks can I; gọi món này means order this dish; không có thịt means without meat; được không softens the question.",
      "when-to-use": "Good at stalls, cafes, vegetarian-friendly counters, noodle shops, and restaurants where ingredients may be flexible.",
      "good-to-know": "Some broths, sauces, or toppings may still contain meat. If that matters, follow with the allergy or ingredient cards.",
      "explore-next": "Move to allergy and ingredient cards if the answer needs more precision than no meat.",
      "natural-variants": "No-meat, without-ingredient, allergy, meat-type, and shrimp cards cover the next food safety checks."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "gọi món này", english: "order this dish", keepTogetherReason: "order-this-dish phrase" },
      { id: "chunk-3", vietnamese: "mà không có thịt", english: "without meat", keepTogetherReason: "without-meat phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "preserves the rich food safety card set while making the page a clear before-ordering ingredient check"
  },
  {
    id: "viet-phrase-v900-food-drin-do-you-have-beer",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-do-you-have-beer.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-do-you-have-beer.json",
    beforeSummary: "Do you have beer?",
    summary: "For checking whether beer is available at a cafe, food stall, beach bar, or casual restaurant.",
    bodies: {
      "at-glance": "Best before you settle into ordering drinks. The answer may be a brand, bottle, can, draft, or simple no.",
      "quick-say": "Ask once, then point to the drink menu if there is one. Let the staff offer the closest option.",
      breakdown: "Bạn có asks do you have; bia means beer; không turns it into a yes/no question.",
      "when-to-use": "Good at casual restaurants, cafes, street stalls, beach places, and small shops with drink coolers.",
      "good-to-know": "Some cafes do not serve alcohol; some restaurants only have a few local beers. A simple yes/no keeps it easy.",
      "explore-next": "Move to to-go, pay, receipt, split-payment, or that's-all cards when the drink order turns into checkout.",
      "natural-variants": "Fresh coconut, sugarcane juice, no-straw, ice, and less-ice cards cover nearby drink choices."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "do you have", keepTogetherReason: "have question" },
      { id: "chunk-2", vietnamese: "bia", english: "beer", keepTogetherReason: "drink noun" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a bare drink title into a realistic local drink availability check while preserving drink and checkout cards"
  },
  {
    id: "viet-phrase-v900-heal-phar-please-check-for-drug-interactions",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-please-check-for-drug-interactions.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-please-check-for-drug-interactions.json",
    beforeSummary: "Please check for drug interactions",
    summary: "For asking a pharmacist or clinic staff to check whether a new medicine is safe with what you already take.",
    bodies: {
      "at-glance": "Show the medicine name, package, prescription, or translated note first. This is a safety check, not a casual symptom question.",
      "quick-say": "Keep every medicine visible on the counter. Let staff compare names and doses before you add more detail.",
      breakdown: "Vui lòng means please; kiểm tra means check; tương tác thuốc means drug interactions.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy cards help if the answer sends you to a clinic or different counter.",
      "when-to-use": "Good at pharmacies, clinics, hospital desks, and hotel desks helping you choose where to ask.",
      "good-to-know": "Medicine names matter. Show the package or a clear photo, and say less until staff knows what they are checking.",
      "explore-next": "Move to headache, stomach, motion-sickness, allergy, or diarrhea cards if the pharmacist asks about symptoms."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "kiểm tra", english: "check", keepTogetherReason: "check verb" },
      { id: "chunk-3", vietnamese: "tương tác thuốc", english: "drug interactions", keepTogetherReason: "medical noun phrase" }
    ],
    value: "raises a health page from generic symptom scaffolding to a medication-safety counter request with correct source glosses"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-where-can-i-print-this",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-print-this.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-print-this.json",
    beforeSummary: "Where can I print this?",
    summary: "For finding a place to print a document, ticket, visa copy, boarding pass, label, or form.",
    bodies: {
      "at-glance": "Show the file or screenshot before asking. The goal is directions to a printer, not a long explanation.",
      "quick-say": "Ask, then show whether the file is on your phone, email, USB drive, or paper.",
      breakdown: "Tôi có thể asks can I; in cái này means print this; ở đâu asks where.",
      "natural-variants": "Water, bag, and tissues cards stay nearby for ordinary counter errands, but this page is about printing.",
      "when-to-use": "Good at hotels, copy shops, stationery shops, campuses, travel offices, and local service counters.",
      "good-to-know": "Printing answers often come as a place plus one instruction. Keep the file open so the next helper can understand fast.",
      "explore-next": "Move to sunscreen, open-this, card-payment, receipt, or print-for-me cards if the errand shifts at the counter."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "in cái này", english: "print this", keepTogetherReason: "print-this phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "reframes printing around actual document/travel-paper logistics instead of generic shop-counter language"
  },
  {
    id: "viet-phrase-v900-shop-can-you-wrap-it-carefully",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-can-you-wrap-it-carefully.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-can-you-wrap-it-carefully.json",
    beforeSummary: "Can you wrap it carefully?",
    summary: "For asking a seller to wrap a fragile souvenir, gift, bottle, ceramic piece, or small purchase with care.",
    bodies: {
      "at-glance": "Best while the item is still on the counter and before it goes into the bag.",
      "quick-say": "Point to the item and gesture gently if needed. The phrase asks for careful wrapping, not a gift-wrap service.",
      breakdown: "Bạn có thể asks can you; gói nó means wrap it; cẩn thận means carefully; được không softens the request.",
      "natural-variants": "Size, color, and try-on cards remain nearby if the shop exchange turns into choosing another item.",
      "when-to-use": "Good at souvenir shops, market stalls, ceramic stores, boutiques, food-gift counters, and luggage-packing moments.",
      "good-to-know": "For fragile items, the gesture helps. Show the part you are worried about before they start wrapping.",
      "explore-next": "Move to just-looking, where-pay, exchange-this, item-price, or lower-price cards if the purchase continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "gói nó", english: "wrap it", keepTogetherReason: "wrap-it phrase" },
      { id: "chunk-3", vietnamese: "cẩn thận", english: "carefully", keepTogetherReason: "carefully phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns wrapping into a fragile-purchase counter moment and fixes bad wrap/carefully source glosses"
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
  next.push({
    id: "full",
    vietnamese: page.title,
    english: page.englishTitle,
    audioKey: page.audioKey ?? null
  });
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
      batch: 19,
      tierRole: page.tierRole,
      sectionID: "page-visible-copy",
      sectionTitle: "Page visible copy",
      pageID: page.id,
      phraseID: page.phraseID,
      sourcePath: repair.source,
      before: {
        title: before.title,
        englishTitle: before.englishTitle,
        summary: repair.beforeSummary ?? before.summary,
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
      reason: "premium_audit_batch_19"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const existingKeys = new Set(existingLedgerRows.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}`];
    } catch {
      return [];
    }
  }));
  const newLedgerRows = ledgerRows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}`));
  if (newLedgerRows.length) {
    fs.appendFileSync(ledgerPath, `${newLedgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 19,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: newLedgerRows.length,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
