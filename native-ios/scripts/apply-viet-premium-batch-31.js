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
    id: "viet-phrase-v500-poli-basi-okay",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/v500-poli-basi-okay.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/polite-basics/v500-poli-basi-okay.json",
    summary: "For agreeing clearly when someone confirms a price, time, route, or simple plan.",
    bodies: {
      "at-glance": "A short yes works best when the choice is already clear.",
      "quick-say": "Say it once, then nod or point to the item, screen, or direction being confirmed.",
      breakdown: "Đồng ý means agree or okay.",
      "natural-variants": "Hello, thanks, and a warmer thank-you keep the polite exchange open.",
      "when-to-use": "Good when a driver, seller, receptionist, or server checks that you agree.",
      "good-to-know": "Short agreement can sound warm in Vietnamese when your tone is relaxed and your face says yes too.",
      "explore-next": "Yes, no thanks, excuse me, it's okay, and goodbye phrases cover the nearby polite turns."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đồng ý", english: "agree / okay", keepTogetherReason: "fixed agreement phrase" }
    ],
    value: "turns a title-only okay page into a concrete agreement moment"
  },
  {
    id: "viet-phrase-v500-sigh-acti-can-i-have-a-map",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v500-sigh-acti-can-i-have-a-map.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v500-sigh-acti-can-i-have-a-map.json",
    summary: "For asking a desk, counter, or guide for a map before you start moving.",
    bodies: {
      "at-glance": "Ask before leaving the ticket desk, hotel counter, or tour stop, especially if signal or battery may be shaky.",
      "quick-say": "Point to the brochure rack, route board, or attraction name so the request lands on the right place.",
      breakdown: "Tôi means I; có thể means can; có bản đồ means have a map; được không? asks if it is possible.",
      "natural-variants": "Ticket price, start point, and photo phrases help when the map question turns into a quick orientation check.",
      "when-to-use": "Good at hotel desks, ticket counters, museums, tour kiosks, and station information windows.",
      "good-to-know": "A physical map can still help in Vietnam when the phone screen is hard to read outside or data is weak.",
      "explore-next": "Closing time, meeting-point, advance-booking, tour-booking, and entrance phrases cover what usually comes after the map."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi", english: "I / me" },
      { id: "chunk-2", vietnamese: "có thể", english: "can", keepTogetherReason: "fixed modal phrase" },
      { id: "chunk-3", vietnamese: "có bản đồ", english: "have a map", keepTogetherReason: "have-map phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is it possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the map page about a real counter or tour orientation moment"
  },
  {
    id: "viet-phrase-v500-unde-repa-can-you-write-the-address",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-can-you-write-the-address.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-can-you-write-the-address.json",
    summary: "For asking someone to write the address so you can show it to a driver, desk, or friend.",
    bodies: {
      "at-glance": "Written addresses keep tone marks, street numbers, and ward names from getting lost in speech.",
      "quick-say": "Show your phone, paper, or booking screen and leave space for the address.",
      breakdown: "Bạn có thể means can you; viết means write; địa chỉ means address; được không? asks if possible.",
      "natural-variants": "Repeat, slower, and simpler-speech phrases help if the conversation still feels too fast.",
      "when-to-use": "Good at hotel desks, cafes, shops, station counters, and anywhere a driver needs the exact address.",
      "good-to-know": "Street names in Vietnam can sound similar. A written line is often better than another spoken attempt.",
      "explore-next": "Repeat, write it down, meaning, which one, and show me phrases cover nearby clarification."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "viết", english: "write" },
      { id: "chunk-3", vietnamese: "địa chỉ", english: "address", keepTogetherReason: "address noun" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "anchors the address page in the driver or desk handoff it actually solves"
  },
  {
    id: "viet-phrase-v500-unde-repa-is-this-translation-correct",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-is-this-translation-correct.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-is-this-translation-correct.json",
    summary: "For checking whether a translated sentence says what you mean before you show it.",
    bodies: {
      "at-glance": "Best for one line at a time, not a whole conversation.",
      "quick-say": "Hold up the translated sentence and pause while the other person reads it.",
      breakdown: "Bản dịch này means this translation; có đúng không? asks is it correct.",
      "natural-variants": "Understanding and slower-speech phrases help if the correction comes back quickly.",
      "when-to-use": "Good before showing a message, confirming a price, checking a medicine note, or sending a booking reply.",
      "good-to-know": "If they correct it, save the wording or ask them to write it down.",
      "explore-next": "Repeat, write it down, meaning, which one, and show me phrases cover nearby repair moves."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bản dịch này", english: "this translation", keepTogetherReason: "this-translation phrase" },
      { id: "chunk-2", vietnamese: "có đúng không?", english: "is it correct?", keepTogetherReason: "correct yes-no question" }
    ],
    value: "makes the translation-check page practical instead of a generic repair prompt"
  },
  {
    id: "viet-phrase-v900-food-drin-i-think-there-is-a-mistake-on-the-bill",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-i-think-there-is-a-mistake-on-the-bill.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-i-think-there-is-a-mistake-on-the-bill.json",
    summary: "For calmly pointing out that the bill may be wrong.",
    bodies: {
      "at-glance": "Keep the receipt, menu price, or order screen visible so the check stays factual.",
      "quick-say": "Point to the line item first, then say the phrase.",
      breakdown: "Tôi nghĩ means I think; có sai sót means there is a mistake; trên hóa đơn means on the bill.",
      "when-to-use": "Good at cafe counters, restaurant tables, hotel desks, and cashier stands when the total or item looks off.",
      "good-to-know": "A quiet tone and a visible receipt make the correction feel like a check, not an accusation.",
      "explore-next": "Smaller-bills, exact-change, break-this-bill, pay-now, and card-payment phrases cover the payment turn after the bill is corrected.",
      "natural-variants": "Receipt, separate-payment, and card-payment phrases stay close for the rest of checkout."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi nghĩ", english: "I think", keepTogetherReason: "I-think phrase" },
      { id: "chunk-2", vietnamese: "có sai sót", english: "there is a mistake", keepTogetherReason: "mistake phrase" },
      { id: "chunk-3", vietnamese: "trên hóa đơn", english: "on the bill", keepTogetherReason: "on-the-bill phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v500-mone-numb-pric-i-need-smaller-bills",
        "viet-phrase-v500-mone-numb-pric-do-i-need-exact-change",
        "viet-phrase-v900-tran-can-you-break-this-bill",
        "viet-family-food-pay-now",
        "viet-family-service-card"
      ]
    },
    value: "turns the bill page into a calm receipt-check flow and restores the richer payment follow-ups"
  },
  {
    id: "viet-phrase-v900-food-drin-ill-have-what-they-are-having",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-ill-have-what-they-are-having.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-ill-have-what-they-are-having.json",
    summary: "For ordering the same dish you can see at another table or counter.",
    bodies: {
      "at-glance": "Point to the dish politely, not the person, so staff know what you mean.",
      "quick-say": "Show the dish with an open hand or menu photo, then keep the request short.",
      breakdown: "Tôi sẽ means I will; có means have; những gì họ đang có means what they are having.",
      "when-to-use": "Good at busy stalls, cafes, food courts, and restaurants when the menu name is unclear but the dish is visible.",
      "good-to-know": "Point at the dish or a photo instead of staring at the table. The gesture carries the detail.",
      "explore-next": "Peanut allergy, recommendation, not too spicy, less spicy, and too spicy phrases cover quick checks after the order.",
      "natural-variants": "This bowl, not spicy, utensils, takeaway, and pay now phrases cover the nearby ordering path."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi sẽ", english: "I will", keepTogetherReason: "I-will phrase" },
      { id: "chunk-2", vietnamese: "có", english: "have" },
      { id: "chunk-3", vietnamese: "những gì họ đang có", english: "what they are having", keepTogetherReason: "what-they-have phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-family-food-peanut-allergy",
        "viet-phrase-v900-food-drin-what-do-you-recommend",
        "viet-phrase-v900-food-drin-what-is-not-too-spicy",
        "viet-phrase-v900-food-drin-please-make-it-less-spicy",
        "viet-phrase-food-premium-too-spicy-now"
      ]
    },
    value: "makes the same-dish order concrete and preserves the richer food follow-ups without changing the audio-backed phrase"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-can-we-sit-somewhere-quieter",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-we-sit-somewhere-quieter.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-we-sit-somewhere-quieter.json",
    summary: "For asking staff to move to a quieter table or waiting spot.",
    bodies: {
      "at-glance": "Ask while pointing gently toward another table, corner, or area away from music or street noise.",
      "quick-say": "Keep your tone calm; the request is about hearing each other, not complaining.",
      breakdown: "Chúng ta có thể asks can we; ngồi means sit; chỗ nào yên tĩnh hơn means somewhere quieter; được không? asks if possible.",
      "natural-variants": "Inside, outside, and fan-seat phrases cover nearby seating choices.",
      "when-to-use": "Good at cafes, restaurants, lounges, waiting rooms, and hotel breakfast areas.",
      "good-to-know": "If staff cannot move you, they may point to a waiting area or quieter time.",
      "explore-next": "Table request, wait time, fan seat, cooler seat, and clean table phrases cover the seating conversation around it."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chúng ta có thể", english: "can we", keepTogetherReason: "can-we phrase" },
      { id: "chunk-2", vietnamese: "ngồi", english: "sit" },
      { id: "chunk-3", vietnamese: "chỗ nào yên tĩnh hơn", english: "somewhere quieter", keepTogetherReason: "quieter-place phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is it possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-food-drin-can-we-sit-inside",
        "viet-phrase-v900-food-drin-can-we-sit-outside",
        "viet-phrase-v900-food-drin-can-we-sit-by-the-fan"
      ],
      "explore-next": [
        "viet-phrase-v900-food-drin-a-table-for-one-please",
        "viet-phrase-v900-food-drin-a-table-for-four-please",
        "viet-phrase-v900-food-drin-is-there-a-wait-for-a-table",
        "viet-phrase-v900-loca-serv-ever-task-can-we-sit-somewhere-cooler",
        "viet-phrase-v900-food-drin-can-you-clean-this-table"
      ]
    },
    value: "replaces unrelated shop-errand cards with seating phrases while preserving the card count"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-please-print-it-in-black-and-white",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-please-print-it-in-black-and-white.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-please-print-it-in-black-and-white.json",
    summary: "For asking a copy shop, hotel desk, or service counter to print without color.",
    bodies: {
      "at-glance": "Say it before the file is printed, especially if price or official paperwork matters.",
      "quick-say": "Show the file, page, or sample and point to black-and-white if there is a display.",
      breakdown: "Vui lòng means please; in means print; bằng màu đen và trắng means in black and white.",
      "natural-variants": "Print this, copy this, and email it phrases cover the usual copy-shop choices.",
      "when-to-use": "Good at copy shops, hotel desks, reception counters, visa offices, and travel-agency desks.",
      "good-to-know": "Ask before they press print; color pages may cost more or be wrong for forms.",
      "explore-next": "Ready time, print location, scan this, receipt, and card payment phrases cover nearby counter details."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite please opener" },
      { id: "chunk-2", vietnamese: "in", english: "print" },
      { id: "chunk-3", vietnamese: "nó", english: "it" },
      { id: "chunk-4", vietnamese: "bằng màu đen và trắng", english: "in black and white", keepTogetherReason: "black-and-white print setting" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-loca-serv-ever-task-can-you-print-this-for-me",
        "viet-phrase-v900-loca-serv-ever-task-can-you-copy-this-document",
        "viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me"
      ],
      "explore-next": [
        "viet-phrase-v900-loca-serv-ever-task-when-will-it-be-ready",
        "viet-phrase-v900-loca-serv-ever-task-where-can-i-print-this",
        "viet-phrase-v900-loca-serv-ever-task-can-you-scan-this-document",
        "viet-family-service-receipt",
        "viet-family-service-card"
      ]
    },
    value: "replaces unrelated shop cards with print/copy counter follow-ups and fixes incorrect breakdown glosses"
  },
  {
    id: "viet-phrase-v900-shop-do-you-have-this-in-black",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-do-you-have-this-in-black.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-do-you-have-this-in-black.json",
    summary: "For asking whether the same item comes in black.",
    bodies: {
      "at-glance": "Hold up the item or photo so the color is the only thing changing.",
      "quick-say": "Point to the item first, then to a black sample, tag, or swatch.",
      breakdown: "Bạn có asks do you have; cái này means this item; màu đen means black; không? makes it yes/no.",
      "natural-variants": "Size, color, and try-on phrases keep the shop conversation clear.",
      "when-to-use": "Good at clothing stalls, shoe shops, souvenir counters, and small boutiques.",
      "good-to-know": "If the color is close but not right, point to a sample or photo instead of explaining shades.",
      "explore-next": "Looking, where-to-pay, exchange, price, and bargaining phrases cover nearby shop turns."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "do you have", keepTogetherReason: "do-you-have phrase" },
      { id: "chunk-2", vietnamese: "cái này", english: "this item", keepTogetherReason: "this-item phrase" },
      { id: "chunk-3", vietnamese: "màu đen", english: "black", keepTogetherReason: "black color phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "removes generic shop scaffolding and makes the color request visible and specific"
  },
  {
    id: "viet-phrase-v900-time-date-book-id-like-to-book-for-tomorrow",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-id-like-to-book-for-tomorrow.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-id-like-to-book-for-tomorrow.json",
    summary: "For making a booking for tomorrow at a desk, counter, or message thread.",
    bodies: {
      "at-glance": "Say tomorrow early so the date is checked before time, name, or price.",
      "quick-say": "Show the calendar date if timing matters or tomorrow could be misunderstood.",
      breakdown: "Tôi muốn means I would like; đặt chỗ means book or reserve; cho ngày mai means for tomorrow.",
      "natural-variants": "What time, today, and tomorrow morning phrases help settle the date and time.",
      "when-to-use": "Good for tours, restaurants, clinics, salons, transport desks, and hotel activities.",
      "good-to-know": "If the booking is important, ask them to write or message the time back.",
      "explore-next": "Existing booking, opening time, move later, boarding time, and wait phrases cover common scheduling follow-ups."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi muốn", english: "I would like", keepTogetherReason: "I-would-like phrase" },
      { id: "chunk-2", vietnamese: "đặt chỗ", english: "book / reserve", keepTogetherReason: "booking verb" },
      { id: "chunk-3", vietnamese: "cho ngày mai", english: "for tomorrow", keepTogetherReason: "for-tomorrow phrase" }
    ],
    value: "turns the tomorrow-booking page into a concrete counter or message flow"
  },
  {
    id: "viet-phrase-v900-time-date-book-is-this-ticket-for-today",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-is-this-ticket-for-today.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-is-this-ticket-for-today.json",
    summary: "For checking whether the ticket you are holding is valid for today.",
    bodies: {
      "at-glance": "Ask before entering, boarding, scanning, or standing in the wrong line.",
      "quick-say": "Show the printed ticket, QR code, or booking screen and point to the date.",
      breakdown: "Đây có phải là asks is this; vé means ticket; cho ngày hôm nay means for today; không? makes it yes/no.",
      "natural-variants": "What time, today, and tomorrow morning phrases help if the date is right but timing is unclear.",
      "when-to-use": "Good at ticket gates, ferry piers, museums, tour desks, and station counters.",
      "good-to-know": "Dates can be printed in small text or local formats. A quick check prevents the wrong queue.",
      "explore-next": "Booking, opening-time, move-later, boarding-time, and wait phrases cover common ticket timing questions."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải là", english: "is this", keepTogetherReason: "is-this question frame" },
      { id: "chunk-2", vietnamese: "vé", english: "ticket" },
      { id: "chunk-3", vietnamese: "cho ngày hôm nay", english: "for today", keepTogetherReason: "for-today phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "fixes the ticket-date page and removes bad breakdown glosses from the rendered learning layer"
  },
  {
    id: "viet-phrase-emergency-7",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/emergency-7.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/emergency-embassy.json",
    summary: "For asking for embassy help when a passport, document, or safety issue cannot wait.",
    bodies: {
      "at-glance": "Lead with the embassy request, then show your passport copy, phone screen, or written note.",
      "quick-say": "Keep the sentence short and let the hotel desk, police counter, or helper ask for details.",
      breakdown: "Tôi cần means I need; đại sứ quán means embassy.",
      "natural-variants": "Lost passport, nearest embassy, and contact embassy phrases keep the request focused.",
      "when-to-use": "Good at hotel desks, police counters, airports, clinics, and any official-help moment.",
      "good-to-know": "If you know your country's embassy or consulate, show the name on your phone.",
      "explore-next": "Unsafe, emergency, temporary document, passport report, and police station phrases cover stronger safety needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "đại sứ quán", english: "embassy", keepTogetherReason: "embassy noun" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-family-emergency-passport",
        "viet-phrase-v500-prob-help-where-is-the-nearest-embassy",
        "viet-phrase-v500-prob-help-please-help-me-contact-my-embassy"
      ],
      "explore-next": [
        "viet-family-emergency-not-safe",
        "viet-family-emergency-emergency",
        "viet-phrase-v900-emer-safe-i-need-a-temporary-travel-document",
        "viet-phrase-emergency-premium-passport-report",
        "viet-phrase-emergency-premium-police-station"
      ]
    },
    value: "turns the embassy page into a focused document and safety help flow with relevant follow-ups"
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
      byID.set(page.id, page);
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
      next.phrases = targets.map((targetID) => {
        const targetPage = pageIndex.get(targetID);
        if (!targetPage) throw new Error(`Missing card target ${targetID} for ${repair.id}`);
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
      batch: 31,
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
      reason: "premium_audit_batch_31_polish"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-500/generated-rows.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];
  const ledgerRowsAdded = appendLedger(ledgerRows);

  console.log(JSON.stringify({
    batch: 31,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
