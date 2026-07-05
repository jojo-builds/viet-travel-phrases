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
    id: "viet-phrase-v500-phon-inte-powe-how-many-days-is-it-valid",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-how-many-days-is-it-valid.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-how-many-days-is-it-valid.json",
    beforeSummary: "How many days is it valid?",
    summary: "For checking the exact validity period before you buy a SIM, pass, ticket, or day-use service.",
    bodies: {
      "at-glance": "Ask before paying or leaving the counter, while the plan, receipt, or phone screen is still easy to check.",
      "quick-say": "Show the plan or receipt first. Let the answer be a number of days, an expiry date, or a quick correction.",
      breakdown: "Có hiệu lực means valid or effective; trong bao nhiêu ngày asks for how many days.",
      "natural-variants": "Wi-Fi, SIM, charger, and data-top-up cards cover the phone errands that usually follow.",
      "when-to-use": "Good at SIM shops, ticket counters, rental desks, hotel desks, and service counters before you walk away.",
      "good-to-know": "Validity periods can be spoken fast. A written date or marked receipt is easier to trust later.",
      "explore-next": "Move to battery, charger, charge-here, data-top-up, or eSIM cards if the timing question turns into phone setup."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có hiệu lực", english: "is valid / effective", keepTogetherReason: "validity phrase" },
      { id: "chunk-2", vietnamese: "trong bao nhiêu ngày?", english: "for how many days?", keepTogetherReason: "duration question" }
    ],
    value: "turns a title-only validity page into a purchase/check-before-leaving moment"
  },
  {
    id: "viet-phrase-v500-phon-inte-powe-where-can-i-fix-my-phone",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-where-can-i-fix-my-phone.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-where-can-i-fix-my-phone.json",
    beforeSummary: "Where can I fix my phone?",
    summary: "For finding a repair counter when a cracked screen, dead port, or broken SIM setup is slowing the day down.",
    bodies: {
      "at-glance": "Ask with the phone visible so the answer can be a shop name, floor, street, or quick point down the block.",
      "quick-say": "Show the damage or error screen. A gesture toward the phone makes the request clear without a long story.",
      breakdown: "Tôi có thể asks can I; sửa điện thoại means fix a phone; ở đâu asks where.",
      "natural-variants": "Wi-Fi, SIM, charger, and map cards help when the problem is setup instead of repair.",
      "when-to-use": "Good at hotel desks, SIM shops, malls, electronics stalls, and cafes where someone may know the nearest repair spot.",
      "good-to-know": "Phone repair directions often come as a landmark or floor number. Repeat the place name if the route sounds fast.",
      "explore-next": "Move to battery, charger, charge-here, data-top-up, or eSIM cards if the fix is really a power or connection issue."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "sửa điện thoại", english: "fix my phone", keepTogetherReason: "phone-fix phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "makes the phone-repair page specific to a broken-device errand instead of generic direction scaffolding"
  },
  {
    id: "viet-phrase-v500-prob-help-can-you-contact-the-driver",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-can-you-contact-the-driver.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-can-you-contact-the-driver.json",
    beforeSummary: "Can you contact the driver?",
    summary: "For asking a desk, guard, or helper to call or message the driver when the pickup is not working.",
    bodies: {
      "at-glance": "Best when the ride screen, plate number, hotel name, or phone number is already open.",
      "quick-say": "Show the ride detail while you ask. It turns the problem into one clear call or message.",
      breakdown: "Bạn có thể asks can you; liên hệ với means contact; tài xế means driver; được không softens the ask.",
      "natural-variants": "Lost, left-something, and need-help cards cover the problem if the ride has already gone wrong.",
      "when-to-use": "Good at hotel lobbies, airport pickup areas, tour desks, apartment gates, and shop counters near a meeting point.",
      "good-to-know": "A visible plate number or driver name saves time. Let the helper copy from the screen instead of spelling it aloud.",
      "explore-next": "Move to help-now, call-hotel, manager, charged-twice, or report cards if the driver issue becomes a larger problem."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "liên hệ với", english: "contact", keepTogetherReason: "contact phrase" },
      { id: "chunk-3", vietnamese: "tài xế", english: "the driver", keepTogetherReason: "driver noun" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "grounds the driver-contact page in pickup trouble with preserved help cards"
  },
  {
    id: "viet-phrase-v500-time-date-book-do-i-need-a-deposit",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v500-time-date-book-do-i-need-a-deposit.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v500-time-date-book-do-i-need-a-deposit.json",
    beforeSummary: "Do I need a deposit?",
    summary: "For checking whether money is due upfront before a tour, room, rental, appointment, or reservation is held.",
    bodies: {
      "at-glance": "Ask before confirming the booking, especially when the price, refund rule, or pickup time is still being discussed.",
      "quick-say": "Keep the booking screen or price visible. The answer may be a number, a percentage, or a simple no.",
      breakdown: "Tôi có cần asks do I need; đặt cọc means a deposit; không makes it a yes/no question.",
      "natural-variants": "Time, today, and tomorrow cards help when the deposit question turns into scheduling.",
      "when-to-use": "Good at tour desks, guesthouses, rental counters, clinics, classes, and message threads about reservations.",
      "good-to-know": "If a deposit is required, ask for the amount or receipt before paying. That keeps the later pickup or check-in simpler.",
      "explore-next": "Move to booking, opening-time, move-later, boarding-time, or wait cards if the answer becomes a schedule detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có cần", english: "do I need", keepTogetherReason: "need question" },
      { id: "chunk-2", vietnamese: "đặt cọc", english: "a deposit", keepTogetherReason: "deposit noun" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the deposit page into a booking-money check instead of generic yes/no scaffolding"
  },
  {
    id: "viet-phrase-v900-emer-safe-this-person-is-bothering-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v900-emer-safe-this-person-is-bothering-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v900-emer-safe-this-person-is-bothering-me.json",
    beforeSummary: "This person is bothering me",
    summary: "For telling staff, security, or police that one specific person is creating a problem right now.",
    bodies: {
      "at-glance": "Say it when pointing, stepping closer to staff, or showing a location makes the situation clear.",
      "quick-say": "Keep the sentence direct. Point to the person or move beside staff instead of adding a long explanation.",
      breakdown: "Người này means this person; đang marks what is happening now; làm phiền tôi means bothering me.",
      "natural-variants": "Police, ambulance, passport, and unsafe cards are nearby if the situation needs a stronger next step.",
      "when-to-use": "Good at hotels, bars, stations, markets, rides, event entrances, and police counters when you need another person to intervene.",
      "good-to-know": "A calm, short line helps staff act. If you feel unsafe, move to the unsafe or emergency card immediately.",
      "explore-next": "Move to unsafe, emergency, help, hospital, or stolen-bag cards if the problem escalates or needs official help."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Người này", english: "this person", keepTogetherReason: "person phrase" },
      { id: "chunk-2", vietnamese: "đang", english: "is / currently", keepTogetherReason: "current-action marker" },
      { id: "chunk-3", vietnamese: "làm phiền tôi", english: "bothering me", keepTogetherReason: "bothering-me phrase" }
    ],
    value: "makes the safety page direct and actionable without generic health/help wording"
  },
  {
    id: "viet-phrase-v900-phon-inte-powe-can-you-type-the-address-for-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-can-you-type-the-address-for-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-can-you-type-the-address-for-me.json",
    beforeSummary: "Can you type the address for me?",
    summary: "For handing over your phone so a hotel, shop, or driver can enter the address without spelling mistakes.",
    bodies: {
      "at-glance": "Best when the address is long, tonal marks matter, or the map app needs the exact Vietnamese name.",
      "quick-say": "Open the map, note, or message field first. Hold the phone so the other person can type instead of dictate.",
      breakdown: "Bạn có thể asks can you; gõ địa chỉ means type the address; cho tôi means for me; được không softens it.",
      "natural-variants": "Wi-Fi, SIM, and charger cards stay nearby if the phone problem changes from typing to setup.",
      "when-to-use": "Good at hotel desks, taxi stands, tour counters, shops, clinics, and anywhere an exact address matters.",
      "good-to-know": "Typed addresses reduce wrong pins. Check the result before you leave the counter or start walking.",
      "explore-next": "Move to battery, charger, charge-here, data-top-up, or eSIM cards if the phone itself becomes the obstacle."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "gõ địa chỉ", english: "type the address", keepTogetherReason: "type-address phrase" },
      { id: "chunk-3", vietnamese: "cho tôi", english: "for me", keepTogetherReason: "for-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the address-typing page about exact map input instead of generic phone-help copy"
  },
  {
    id: "viet-phrase-repair-5",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/repair-5.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/viet-phrase-repair-5.json",
    beforeSummary: "Can you show me on the map?",
    summary: "For turning fast directions into a visible map point when spoken instructions are not enough.",
    bodies: {
      "at-glance": "Open the map before asking so the answer can become a pin, street, entrance, or route line.",
      "quick-say": "Hand the phone over or point to the map. Let the person tap, trace, or point instead of explaining again.",
      breakdown: "Chỉ means point or show; trên bản đồ means on the map; giúp tôi means help me; được không softens the request.",
      "natural-variants": "Show-me, don't-understand, and slower cards help when the first answer is still too fast.",
      "when-to-use": "Good with directions, pickup points, hotel names, market stalls, bus stops, and any place that is easier to point to than describe.",
      "good-to-know": "A map point can solve what repeated speech cannot. Confirm the pin before walking away.",
      "explore-next": "Move to slower, repeat, write-down, meaning, or which-one cards if the map still leaves a question."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chỉ", english: "point / show", keepTogetherReason: "show verb" },
      { id: "chunk-2", vietnamese: "trên bản đồ", english: "on the map", keepTogetherReason: "map phrase" },
      { id: "chunk-3", vietnamese: "giúp tôi", english: "help me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the map-repair page concrete and visual while keeping all repair follow-up cards"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-where-is-the-information-desk",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-information-desk.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-information-desk.json",
    beforeSummary: "Where is the information desk?",
    summary: "For finding the airport help counter before baggage, pickup, SIM, or terminal questions start piling up.",
    bodies: {
      "at-glance": "Ask as soon as signs stop helping. Staff can usually answer with a direction, floor, or counter name.",
      "quick-say": "Keep your bag, passport, or flight detail close. The desk may be the fastest path to the next answer.",
      breakdown: "Bàn thông tin means information desk; ở đâu asks where.",
      "natural-variants": "Immigration, baggage claim, and SIM cards cover the airport questions that often come next.",
      "when-to-use": "Good in arrivals halls, departure halls, baggage areas, transfer corridors, and pickup zones when you need a human desk.",
      "good-to-know": "Airport answers often come with a point and a landmark. Watch the gesture before asking again.",
      "explore-next": "Move to pickup area, meet-driver, missing-bag, domestic-terminal, or visa cards if the desk points you onward."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bàn thông tin", english: "the information desk", keepTogetherReason: "desk phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "turns a bare airport where-question into a useful orientation page"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-pay-the-bill-by-card",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-pay-the-bill-by-card.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-i-pay-the-bill-by-card.json",
    beforeSummary: "Can I pay the bill by card?",
    summary: "For checking card payment before the server brings the terminal, receipt, or cash-change conversation.",
    bodies: {
      "at-glance": "Ask when the bill is visible and you want to know whether card is acceptable before reaching for cash.",
      "quick-say": "Point to the bill or card. A short question is enough at the table or cashier stand.",
      breakdown: "Tôi có thể asks can I; thanh toán hóa đơn means pay the bill; bằng thẻ means by card; không makes it a question.",
      "natural-variants": "Receipt, split-payment, remove-item, bill-mistake, and that's-all cards cover the payment details around it.",
      "when-to-use": "Good at cafes, restaurants, hotel counters, bars, and cashier stands where card rules may vary.",
      "good-to-know": "If card is not available, move to cash or smaller-bills before the bill exchange gets awkward.",
      "explore-next": "Move to receipt, pay-separately, remove-from-bill, bill-mistake, or pay-now cards if the bill needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "thanh toán hóa đơn", english: "pay the bill", keepTogetherReason: "pay-bill phrase" },
      { id: "chunk-3", vietnamese: "bằng thẻ", english: "by card", keepTogetherReason: "card-payment phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the card-payment page specific to the bill moment while preserving payment follow-ups"
  },
  {
    id: "viet-phrase-v900-food-drin-can-we-sit-by-the-fan",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-we-sit-by-the-fan.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-we-sit-by-the-fan.json",
    beforeSummary: "Can we sit by the fan?",
    summary: "For asking for a cooler table in a hot cafe, food hall, or open-front restaurant.",
    bodies: {
      "at-glance": "Ask before sitting down, while the fan, doorway, or open table is easy to point at.",
      "quick-say": "Point to the fan or table. Keep the request light so it sounds like comfort, not a complaint.",
      breakdown: "Chúng ta có thể asks can we; ngồi cạnh quạt means sit by the fan; được không softens the request.",
      "natural-variants": "Table-for-one, table-for-four, wait, inside, and outside cards cover nearby seating questions.",
      "when-to-use": "Good at busy lunch counters, cafes, casual restaurants, night-market tables, and open-air rooms on hot days.",
      "good-to-know": "A gesture helps. Fan seating may mean one table over, closer to the doorway, or away from the cooking heat.",
      "explore-next": "Move to clean-table, table-for-two, order-counter, long-wait, or recommendation cards if seating turns into service."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chúng ta có thể", english: "can we", keepTogetherReason: "can-we phrase" },
      { id: "chunk-2", vietnamese: "ngồi cạnh quạt", english: "sit by the fan", keepTogetherReason: "fan-seat phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the fan-seat page vivid and situational without removing table cards"
  },
  {
    id: "viet-phrase-v900-heal-phar-do-you-have-this-medicine",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-do-you-have-this-medicine.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-do-you-have-this-medicine.json",
    beforeSummary: "Do you have this medicine?",
    summary: "For showing a box, photo, prescription, or translated name and asking if the pharmacy has the same medicine.",
    bodies: {
      "at-glance": "Keep the package, photo, or note visible so staff can compare the name instead of guessing from memory.",
      "quick-say": "Show the medicine first. Let the answer be yes, no, a substitute, or a question about dosage.",
      breakdown: "Bạn có asks do you have; thuốc này means this medicine; không makes it a yes/no question.",
      "natural-variants": "Doctor, pharmacy, and symptom cards help if the medicine is unavailable or the staff needs more context.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, and counters where someone is helping you match a medicine name.",
      "good-to-know": "Medicine names and doses matter. If the answer is a substitute, compare the box or label before buying.",
      "explore-next": "Move to headache, stomach, motion-sickness, allergy, or diarrhea cards if the exchange shifts to symptoms."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "do you have", keepTogetherReason: "have question" },
      { id: "chunk-2", vietnamese: "thuốc này", english: "this medicine", keepTogetherReason: "medicine phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the medicine page into a package/photo matching moment with clearer pharmacy guidance"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-i-get-a-refund-for-the-room",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-get-a-refund-for-the-room.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-get-a-refund-for-the-room.json",
    beforeSummary: "Can I get a refund for the room?",
    summary: "For asking the front desk about a room refund when the stay, booking, or room problem needs resolving.",
    bodies: {
      "at-glance": "Ask with the booking, receipt, room number, or app screen visible so the desk can check the exact stay.",
      "quick-say": "Keep the tone calm and the proof ready. The first answer may be a policy, manager check, or partial refund.",
      breakdown: "Tôi có thể asks can I; được hoàn lại means get refunded; tiền phòng means room money; không makes it a question.",
      "natural-variants": "Reservation, check-in, and room cards help if the refund question turns into a booking discussion.",
      "when-to-use": "Good at hotels, guesthouses, serviced apartments, booking counters, and message threads after a room issue.",
      "good-to-know": "Refund conversations move better with dates and proof. Keep the problem simple before adding extra details.",
      "explore-next": "Move to checkout-time, quiet-room, checkout, room-hot, or air-conditioner cards if the desk offers a room fix instead."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "được hoàn lại", english: "get refunded", keepTogetherReason: "refund phrase" },
      { id: "chunk-3", vietnamese: "tiền phòng", english: "room payment", keepTogetherReason: "room-money phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the refund page about a specific front-desk resolution moment"
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
  return {
    page,
    before,
    after: {
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
    if (repair.summary && index.family_summary !== undefined) {
      row[index.family_summary] = repair.summary;
      changed += 1;
    }
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
      batch: 17,
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
          "breakdown gloss cleanup"
        ]
      },
      after: {
        title: page.title,
        englishTitle: page.englishTitle,
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
      reason: "premium_audit_batch_17"
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
    batch: 17,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: newLedgerRows.length,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
