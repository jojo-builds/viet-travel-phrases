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
    id: "viet-phrase-v500-food-drin-does-this-contain-peanuts",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-does-this-contain-peanuts.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v500-food-drin-does-this-contain-peanuts.json",
    summary: "For checking peanuts before you eat, order, or accept a dish.",
    beforeSummary: "Does this contain peanuts?",
    bodies: {
      "at-glance": "Use it before a bite, not after the plate has already become a problem.",
      "quick-say": "Point to the dish, sauce, topping, or menu photo. Wait for a clear yes, no, or safer suggestion.",
      breakdown: "Cái này means this item; có chứa means contains; đậu phộng means peanuts; không makes it a yes/no question.",
      "natural-variants": "If the answer is not clear, move to allergy, no peanuts, vegetarian, or safer-dish follow-ups.",
      "when-to-use": "Good at stalls, cafes, restaurants, buffets, bakeries, and counters where toppings are not obvious.",
      "good-to-know": "For a serious allergy, show the allergy phrase too. This line checks ingredients; it is not the whole warning.",
      "explore-next": "Use peanut-allergy, no-peanuts, without-this-ingredient, fish-sauce, or safer-dish cards if the answer needs another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái này", english: "this item", keepTogetherReason: "this-item phrase" },
      { id: "chunk-2", vietnamese: "có chứa", english: "contains", keepTogetherReason: "contains phrase" },
      { id: "chunk-3", vietnamese: "đậu phộng", english: "peanuts", keepTogetherReason: "peanut ingredient phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the peanut page into a real ingredient-safety check instead of generic yes/no scaffolding"
  },
  {
    id: "viet-phrase-v500-heal-phar-i-have-a-fever",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-a-fever.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-a-fever.json",
    title: "Tôi bị sốt",
    pronunciation: "Toi bi sot",
    summary: "For telling a pharmacist, clinic, or hotel desk that you have a fever.",
    beforeSummary: "I have a fever",
    bodies: {
      "at-glance": "Say it early if you need medicine, clinic help, or advice about whether to rest or go in.",
      "quick-say": "Keep the sentence short. Show your temperature, medicine box, symptom note, or travel-insurance card if it helps.",
      breakdown: "Tôi bị means I have or I am affected by; sốt means fever.",
      "natural-variants": "If the fever comes with other symptoms, move to doctor, pharmacy, headache, stomach pain, or how-to-take-this follow-ups.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, tour counters, and with a guide helping translate a health problem.",
      "good-to-know": "A number helps. If you know your temperature, show it rather than trying to explain the whole illness.",
      "explore-next": "Use doctor, pharmacy, headache, stomach, diarrhea, or dosage cards if staff need the next detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I have / I am affected by", keepTogetherReason: "condition phrase" },
      { id: "chunk-2", vietnamese: "sốt", english: "fever", keepTogetherReason: "symptom word" }
    ],
    value: "makes the fever page a direct health disclosure with practical next proof"
  },
  {
    id: "viet-phrase-v500-heal-phar-i-have-asthma",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-asthma.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-asthma.json",
    summary: "For telling someone asthma matters before medicine, transport, or clinic advice.",
    beforeSummary: "I have asthma",
    bodies: {
      "at-glance": "Use it before staff recommend medicine, activity, smoke exposure, or a long wait.",
      "quick-say": "Show an inhaler, medicine photo, or translated note if you have one. Keep the phrase calm and direct.",
      breakdown: "Tôi bị means I have or I am affected by; hen suyễn means asthma.",
      "natural-variants": "If breathing is difficult now, move to trouble-breathing, doctor, emergency help, or medicine follow-ups.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, tour counters, and any moment where breathing risk changes the plan.",
      "good-to-know": "If symptoms are urgent, do not bury that detail. Ask for medical help right away.",
      "explore-next": "Use doctor, pharmacy, trouble-breathing, emergency help, or medicine cards if the situation needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I have / I am affected by", keepTogetherReason: "condition phrase" },
      { id: "chunk-2", vietnamese: "hen suyễn", english: "asthma", keepTogetherReason: "asthma phrase" }
    ],
    value: "makes the asthma page specific to health-risk context instead of generic pharmacy copy"
  },
  {
    id: "viet-phrase-v500-hote-acco-can-someone-come-fix-it",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-can-someone-come-fix-it.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v500-hote-acco-can-someone-come-fix-it.json",
    summary: "For asking the hotel or guesthouse to send someone to fix a room problem.",
    beforeSummary: "Can someone come fix it?",
    bodies: {
      "at-glance": "Use it when the room issue needs a person, not just an explanation at the desk.",
      "quick-say": "Say the request, then show the room number, photo, or broken item. Keep the problem visible if you can.",
      breakdown: "Ai đó means someone; có thể means can; đến sửa means come fix; được không softens the request.",
      "natural-variants": "If staff need detail, move to toilet, shower, air conditioner, door lock, or room-too-hot follow-ups.",
      "when-to-use": "Good for toilets, showers, locks, lights, air conditioning, safes, and room fixtures that need maintenance.",
      "good-to-know": "A photo helps if the desk is busy. It shows the problem before the explanation gets long.",
      "explore-next": "Use toilet, shower, aircon, door-lock, room-hot, or front-desk cards if the repair needs more detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Ai đó", english: "someone", keepTogetherReason: "someone phrase" },
      { id: "chunk-2", vietnamese: "có thể", english: "can", keepTogetherReason: "can phrase" },
      { id: "chunk-3", vietnamese: "đến sửa", english: "come fix", keepTogetherReason: "come-fix phrase" },
      { id: "chunk-4", vietnamese: "nó", english: "it", keepTogetherReason: "object pronoun" },
      { id: "chunk-5", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns the hotel repair page into a concrete room-maintenance request"
  },
  {
    id: "viet-phrase-v500-phon-inte-powe-can-you-install-it-for-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-you-install-it-for-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-you-install-it-for-me.json",
    summary: "For asking a shop, hotel desk, or helper to install an app, SIM, eSIM, or setting.",
    beforeSummary: "Can you install it for me?",
    bodies: {
      "at-glance": "Use it only when you are comfortable letting someone handle the phone or look at the screen.",
      "quick-say": "Open the app, SIM screen, or settings page first. Ask, then keep an eye on passwords and private messages.",
      breakdown: "Bạn có thể asks can you; cài đặt means install or set up; cho tôi means for me; được không softens the request.",
      "natural-variants": "If the setup fails, move to Wi-Fi, eSIM, map not working, local SIM, or can-you-type-it follow-ups.",
      "when-to-use": "Good at SIM shops, hotel desks, phone stores, cafes, and with someone helping you connect.",
      "good-to-know": "Do not hand over unlocked private screens unless you trust the setting. Stay close while they help.",
      "explore-next": "Use Wi-Fi, eSIM, local SIM, charger, map, or type-it cards if the phone setup needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you request frame" },
      { id: "chunk-2", vietnamese: "cài đặt", english: "install / set up", keepTogetherReason: "install phrase" },
      { id: "chunk-3", vietnamese: "nó", english: "it", keepTogetherReason: "object pronoun" },
      { id: "chunk-4", vietnamese: "cho tôi", english: "for me", keepTogetherReason: "for-me phrase" },
      { id: "chunk-5", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "adds privacy and phone-setup context while preserving the connection-help cards"
  },
  {
    id: "viet-phrase-v500-time-date-book-is-it-open-today",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v500-time-date-book-is-it-open-today.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v500-time-date-book-is-it-open-today.json",
    summary: "For checking today's opening before you make the trip.",
    beforeSummary: "Is it open today?",
    bodies: {
      "at-glance": "Ask before leaving the hotel, walking across town, or paying for a ride.",
      "quick-say": "Show the place, ticket, booking, or map listing. The answer may be yes, closed, later, or a different entrance.",
      breakdown: "Hôm nay means today; có mở cửa means is open; không makes it a yes/no question.",
      "natural-variants": "If the answer changes the plan, ask what time, tomorrow, Monday closing, or whether there is a wait.",
      "when-to-use": "Good for museums, restaurants, shops, clinics, ticket desks, attractions, and small counters.",
      "good-to-know": "Hours can shift around holidays, weather, and family-run shops. A quick check can save a wasted ride.",
      "explore-next": "Use what-time, tomorrow, change-time, closed-on-Monday, or wait follow-ups if the schedule needs another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hôm nay", english: "today", keepTogetherReason: "today phrase" },
      { id: "chunk-2", vietnamese: "có mở cửa", english: "is open", keepTogetherReason: "open-status phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the open-today page specific to avoiding wasted trips and shifted hours"
  },
  {
    id: "viet-phrase-v500-time-date-book-is-there-a-change-fee",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v500-time-date-book-is-there-a-change-fee.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v500-time-date-book-is-there-a-change-fee.json",
    summary: "For checking whether changing a ticket, tour, seat, or booking costs extra.",
    beforeSummary: "Is there a change fee?",
    bodies: {
      "at-glance": "Ask before agreeing to the new time, date, seat, or route.",
      "quick-say": "Show the ticket or booking. The answer may separate the fee from any fare difference.",
      breakdown: "Có phí means is there a fee; thay đổi means change; không makes it a yes/no question.",
      "natural-variants": "If the fee matters, move to refund, final price, receipt, change-time, or manager follow-ups.",
      "when-to-use": "Good at bus desks, train counters, tour offices, hotel desks, clinics, and message threads.",
      "good-to-know": "Ask before the staff reissues anything. Once a booking is changed, the fee may be harder to undo.",
      "explore-next": "Use refund, receipt, final-price, move-later, or change-time cards if the booking needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có phí", english: "is there a fee", keepTogetherReason: "fee question frame" },
      { id: "chunk-2", vietnamese: "thay đổi", english: "change", keepTogetherReason: "change phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "fixes a wrong breakdown gloss and makes the change-fee page useful before booking changes"
  },
  {
    id: "viet-phrase-v500-tran-please-go-straight",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-go-straight.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-please-go-straight.json",
    summary: "For giving a driver a simple straight-ahead route cue.",
    beforeSummary: "Please go straight",
    bodies: {
      "at-glance": "Use it while the car or bike is moving and the next instruction needs to be short.",
      "quick-say": "Say it before the turn decision arrives. Show the map if traffic or lanes make the route unclear.",
      breakdown: "Hãy is a soft prompt; đi thẳng means go straight.",
      "natural-variants": "If the route changes, move to turn-right, turn-left, stop-here, correct-address, or follow-the-map follow-ups.",
      "when-to-use": "Good in taxis, motorbike taxis, private cars, hotel-arranged rides, and station pickups.",
      "good-to-know": "Short route cues work better before the intersection. A late instruction can sound like a correction.",
      "explore-next": "Use stop-here, turn-right, turn-left, follow-map, aircon, or cash cards if the ride needs another phrase."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy", english: "please / go ahead", keepTogetherReason: "soft instruction opener" },
      { id: "chunk-2", vietnamese: "đi thẳng", english: "go straight", keepTogetherReason: "straight-ahead phrase" }
    ],
    value: "turns the go-straight page into a timed driver cue instead of generic transport filler"
  },
  {
    id: "viet-phrase-v900-emer-safe-can-you-help-me-cancel-my-card",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v900-emer-safe-can-you-help-me-cancel-my-card.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v900-emer-safe-can-you-help-me-cancel-my-card.json",
    summary: "For asking for help freezing or cancelling a bank card after loss, theft, or a bad charge.",
    beforeSummary: "Can you help me cancel my card?",
    bodies: {
      "at-glance": "Use it when the card problem needs action now, not a long story first.",
      "quick-say": "Show the banking app, card photo, receipt, or emergency number if it is safe to do so.",
      breakdown: "Bạn có thể asks can you; giúp tôi means help me; hủy thẻ means cancel the card; được không softens the request.",
      "natural-variants": "If the problem is theft, move to police, report, hotel call, charged twice, or emergency-contact follow-ups.",
      "when-to-use": "Good at hotel desks, bank counters, police desks, shops, or with someone helping you make a call.",
      "good-to-know": "Protect private numbers. Show only the screen or contact detail needed for the next action.",
      "explore-next": "Use police, report, charged-twice, hotel-call, emergency-contact, or contact-embassy cards if the card problem leads to another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you request frame" },
      { id: "chunk-2", vietnamese: "giúp tôi", english: "help me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-3", vietnamese: "hủy thẻ", english: "cancel the card", keepTogetherReason: "cancel-card phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the card-cancel page concrete and privacy-aware while preserving safety follow-ups"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-have-napkins",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-napkins.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-napkins.json",
    title: "Cho tôi xin khăn giấy được không?",
    pronunciation: "Cho toi xin khan giay duoc khong",
    audioPlanned: true,
    summary: "For asking for napkins or tissues at a table, stall, cafe, or counter.",
    beforeSummary: "Can I have napkins?",
    bodies: {
      "at-glance": "Use it when the food is already on the table and you need napkins without turning it into a bigger request.",
      "quick-say": "Point lightly to the table or your hands. Keep the request small and polite.",
      breakdown: "Cho tôi xin is a polite asking frame; khăn giấy means tissues or napkins; được không asks if it is possible.",
      "natural-variants": "If the table needs more, move to spoon and chopsticks, chili sauce, lime, rice, or more herbs follow-ups.",
      "when-to-use": "Good at street-food tables, cafes, casual restaurants, hotel breakfast, and takeaway counters.",
      "good-to-know": "Khăn giấy often covers the small paper napkins or tissues you are likely to need at a meal.",
      "explore-next": "Use utensils, herbs, lime, chili sauce, rice, or sauce-on-the-side cards if the table needs one more thing."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cho tôi xin", english: "may I have / please give me", keepTogetherReason: "polite request frame" },
      { id: "chunk-2", vietnamese: "khăn giấy", english: "napkins / tissues", keepTogetherReason: "napkin phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "replaces literal Can-I-have wording with a natural table request and moves stale audio to planned"
  },
  {
    id: "viet-phrase-v900-food-drin-is-there-a-wait-for-a-table",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-is-there-a-wait-for-a-table.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-is-there-a-wait-for-a-table.json",
    summary: "For checking whether you need to wait before getting a table.",
    beforeSummary: "Is there a wait for a table?",
    bodies: {
      "at-glance": "Ask before joining a loose crowd, waiting outside, or assuming a table is available.",
      "quick-say": "Point to your group or hold up fingers for the party size. Listen for a time, no table, or wait here.",
      breakdown: "Có phải asks is it the case; đợi bàn means wait for a table; không makes it a yes/no question.",
      "natural-variants": "If there is a wait, move to table for two, call my name, inside/outside, or come back later follow-ups.",
      "when-to-use": "Good at busy cafes, street-food places, restaurants, hotel breakfast rooms, and tour lunch stops.",
      "good-to-know": "Some places use a list, some use a loose line. A quick question helps you avoid standing in the wrong spot.",
      "explore-next": "Use table-for-two, call-my-name, wait-here, inside, outside, or order-counter cards if seating needs another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có phải", english: "is it the case", keepTogetherReason: "yes-no question frame" },
      { id: "chunk-2", vietnamese: "đợi bàn", english: "wait for a table", keepTogetherReason: "table-wait phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the table-wait page specific to seating, lines, and group size"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-have-high-blood-pressure",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-have-high-blood-pressure.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-have-high-blood-pressure.json",
    summary: "For telling a pharmacist or clinician that high blood pressure affects what is safe.",
    beforeSummary: "I have high blood pressure",
    bodies: {
      "at-glance": "Say it before medicine, decongestants, pain relief, or activity advice.",
      "quick-say": "Show the medicine, prescription, blood-pressure reading, or translated note if you have one.",
      breakdown: "Tôi bị means I have or I am affected by; cao huyết áp means high blood pressure.",
      "natural-variants": "If staff need detail, move to medicine, alcohol, sleepy, doctor, or medical-report follow-ups.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, and with a guide helping translate health details.",
      "good-to-know": "The exact medicine matters. Keep the box or prescription visible while they answer.",
      "explore-next": "Use doctor, pharmacy, medicine, sleepy, alcohol, or receipt-for-insurance cards if the advice needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I have / I am affected by", keepTogetherReason: "condition phrase" },
      { id: "chunk-2", vietnamese: "cao huyết áp", english: "high blood pressure", keepTogetherReason: "blood-pressure phrase" }
    ],
    value: "makes the blood-pressure page medically practical instead of generic symptom scaffolding"
  }
];

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function phraseCardCount(page) {
  return (page.sections ?? []).reduce((total, section) => total + (section.phrases ?? []).length, 0);
}

function breakdownCount(page) {
  return (page.sections ?? []).reduce((total, section) => total + (section.breakdown ?? []).length, 0);
}

function sectionBodies(page) {
  return Object.fromEntries((page.sections ?? []).map((section) => [section.id, section.body]));
}

function speakerSymbolName(page, repair) {
  if (repair.audioPlanned || page.audioKey === null) return "text.bubble.fill";
  return "speaker.wave.2.fill";
}

function updateSelfPhrase(section, page, repair) {
  for (const option of section.phrases ?? []) {
    if (option.detailPageID !== null && option.id !== page.phraseID) continue;
    option.vietnamese = page.title;
    option.english = page.englishTitle;
    option.pronunciation = page.pronunciation;
    option.audioKey = repair.audioPlanned ? null : page.audioKey;
    option.symbolName = speakerSymbolName(page, repair);
  }
}

function updateSource(repair) {
  const page = readJson(repair.source);
  const before = {
    title: page.title,
    englishTitle: page.englishTitle,
    pronunciation: page.pronunciation,
    summary: page.summary,
    sections: sectionBodies(page),
    phraseCards: phraseCardCount(page),
    breakdownRows: breakdownCount(page)
  };

  if (repair.title) page.title = repair.title;
  if (repair.englishTitle) page.englishTitle = repair.englishTitle;
  if (repair.pronunciation) page.pronunciation = repair.pronunciation;
  if (repair.audioPlanned) page.audioKey = null;
  page.summary = repair.summary;

  for (const section of page.sections ?? []) {
    if (repair.bodies[section.id]) section.body = repair.bodies[section.id];
    if (section.id === "quick-say" || section.id === "standard-way") updateSelfPhrase(section, page, repair);
    if (section.id === "breakdown") {
      section.breakdown = [
        ...repair.breakdown.map((entry) => ({ ...entry, audioKey: null })),
        {
          id: `chunk-${repair.breakdown.length + 1}`,
          vietnamese: page.title,
          english: page.englishTitle,
          audioKey: page.audioKey ?? null
        }
      ];
    }
  }

  writeJson(repair.source, page);
  return {
    page,
    before,
    after: {
      title: page.title,
      englishTitle: page.englishTitle,
      pronunciation: page.pronunciation,
      summary: page.summary,
      sections: sectionBodies(page),
      phraseCards: phraseCardCount(page),
      breakdownRows: breakdownCount(page)
    }
  };
}

function updateAudit(repair, page) {
  const audit = readJson(repair.audit);
  audit.phraseText = page.title;
  audit.englishTitle = page.englishTitle;
  audit.tokens = [
    ...repair.breakdown.map((entry) => ({ ...entry })),
    {
      id: "full",
      vietnamese: page.title,
      english: page.englishTitle,
      audioKey: page.audioKey ?? null
    }
  ];
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
    const phraseID = row[index.phrase_id];
    const repair = repairsByPhraseID.get(phraseID);
    if (!repair) continue;
    if (repair.title) {
      row[index.target_text] = repair.title;
      row[index.canonical_target_text] = repair.title;
    }
    if (repair.englishTitle) row[index.english_text] = repair.englishTitle;
    if (repair.pronunciation) row[index.pronunciation] = repair.pronunciation;
    if (repair.audioPlanned) {
      row[index.audio_key] = "";
      row[index.audio_status] = "planned";
      const note = row[index.notes] || "";
      if (!note.includes("Batch 15 semantic repair moved audio to planned")) {
        row[index.notes] = `${note}; Batch 15 semantic repair moved audio to planned`;
      }
    }
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
      batch: 15,
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
          "source/rendered breakdown mismatch risk"
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
      reason: "premium_audit_batch_15"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const hasBatch15Rows = existingLedgerRows.some((line) => {
    try {
      const row = JSON.parse(line);
      return row.batch === 15 || row.reason === "premium_audit_batch_15";
    } catch {
      return false;
    }
  });

  if (!hasBatch15Rows) {
    fs.appendFileSync(ledgerPath, `${ledgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 15,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: hasBatch15Rows ? 0 : ledgerRows.length,
    ledgerSkippedAlreadyPresent: hasBatch15Rows,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
