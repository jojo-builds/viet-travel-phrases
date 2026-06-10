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
    id: "viet-phrase-v900-time-date-book-can-i-get-a-ticket-refund",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-can-i-get-a-ticket-refund.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-can-i-get-a-ticket-refund.json",
    summary: "For asking about a refund before a ticket, tour, or timed booking becomes final.",
    bodies: {
      "at-glance": "Ask at the counter, tour desk, or chat thread while the ticket or booking screen is still visible.",
      "quick-say": "Show the ticket first. The reply may depend on the date, cancellation rule, payment method, or whether the ticket was used.",
      breakdown: "Tôi có thể asks can I; được hoàn tiền vé means get the ticket money refunded; không makes it a yes/no question.",
      "when-to-use": "Ticket desks, tour offices, ferry counters, museums, and attraction chats are the natural places to ask.",
      "good-to-know": "Refund rules can be strict. Keep the receipt, booking code, and original payment card close.",
      "explore-next": "Booking, opening-time, move-it-later, boarding-time, and wait-time cards cover nearby schedule decisions.",
      "natural-variants": "What-time, today, and tomorrow-morning cards help if the refund question turns into rescheduling."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "được hoàn tiền vé", english: "get a ticket refund", keepTogetherReason: "ticket-refund phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a title-only refund page into a concrete ticket-counter question without removing booking cards"
  },
  {
    id: "viet-phrase-v900-time-date-book-can-you-send-a-confirmation-message",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-can-you-send-a-confirmation-message.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-can-you-send-a-confirmation-message.json",
    summary: "For getting written confirmation before you leave a booking desk or chat.",
    bodies: {
      "at-glance": "Ask before walking away. Keep the phone number, email address, booking code, or chat window visible.",
      "quick-say": "Point to the correct contact line while you ask. A message matters most when pickup time or address is easy to forget.",
      breakdown: "Bạn có thể asks can you; gửi tin nhắn means send a message; xác nhận means confirmation; không makes it a yes/no question.",
      "when-to-use": "Use this after bookings, reservations, pickups, ticket changes, and any plan that needs a written trail.",
      "good-to-know": "Check the contact detail before they send it. A wrong digit makes the confirmation useless.",
      "explore-next": "Booking, opening-time, move-it-later, boarding-time, and wait-time cards cover the next schedule question.",
      "natural-variants": "What-time, today, and tomorrow-morning cards help if the confirmation leads to a timing check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "gửi tin nhắn", english: "send a message", keepTogetherReason: "send-message phrase" },
      { id: "chunk-3", vietnamese: "xác nhận", english: "confirmation", keepTogetherReason: "confirmation noun" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "replaces generic booking scaffolding with a clear written-confirmation use case"
  },
  {
    id: "viet-phrase-bath-6",
    source: "content-draft/viet/canonical-pages/catalog-promoted/bathroom-personal-needs/bath-6.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/bathroom-personal-needs/bathroom-shower.json",
    summary: "For checking whether a shower is available at a stop, hotel, gym, beach, or station.",
    bodies: {
      "at-glance": "Ask near the desk or attendant before paying, changing clothes, or walking into a private area.",
      "quick-say": "Point to the sign, towel, locker area, or restroom direction. The answer may be yes, fee, staff-only, or elsewhere.",
      breakdown: "Ở đây means here; có chỗ tắm asks whether there is a place to shower; không makes it a yes/no question.",
      "when-to-use": "Stations, hostels, beaches, gyms, spas, and some cafes are the places where shower access may be unclear.",
      "good-to-know": "If the answer is yes, ask about towels, payment, and where to leave your things before you step away.",
      "explore-next": "Soap, hand-washing, water, toilet, and shampoo cards cover nearby personal-needs questions.",
      "natural-variants": "Bathroom, toilet-paper, and bathroom-use cards help if you only need the restroom."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Ở đây", english: "here", keepTogetherReason: "place reference" },
      { id: "chunk-2", vietnamese: "có chỗ tắm", english: "has a place to shower", keepTogetherReason: "shower-place phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the shower page specific to access, payment, and location instead of generic bathroom scaffolding"
  },
  {
    id: "viet-phrase-emergency-6",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/emergency-6.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/emergency-stolen-bag.json",
    summary: "For telling staff, police, or a nearby helper that your bag was taken.",
    bodies: {
      "at-glance": "Keep it direct. Show the bag photo, receipt, hotel tag, ride screen, or last known place if you have it.",
      "quick-say": "Say the problem first, then stop. Let the other person ask where, when, or what the bag looked like.",
      breakdown: "Túi của tôi means my bag; bị lấy mất means was taken or stolen.",
      "when-to-use": "Use this with hotel staff, station staff, police, venue security, or a driver who can help trace the stop.",
      "good-to-know": "Short facts help: color, size, where it was, and the last time you saw it.",
      "explore-next": "Unsafe, emergency, help, hospital, and embassy cards cover the next safety handoff.",
      "natural-variants": "Police, ambulance, and passport-loss cards cover more serious escalation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Túi của tôi", english: "my bag", keepTogetherReason: "owned-item phrase" },
      { id: "chunk-2", vietnamese: "bị lấy mất", english: "was taken / stolen", keepTogetherReason: "stolen-bag phrase" }
    ],
    value: "keeps the emergency card set while replacing reusable problem-report prose with stolen-bag guidance"
  },
  {
    id: "viet-phrase-emergency-premium-phone-stolen",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/emergency-premium-phone-stolen.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/emergency-phone-stolen.json",
    summary: "For saying your phone was stolen and moving quickly toward help or a report.",
    bodies: {
      "at-glance": "Use a borrowed phone, hotel desk, police desk, or staff counter. Show any device details you still have.",
      "quick-say": "Say the line once, then add where it happened, the phone model, and whether tracking is still available.",
      breakdown: "Điện thoại của tôi means my phone; đã bị đánh cắp means was stolen.",
      "when-to-use": "This belongs with police, hotel staff, venue security, or someone helping you call your carrier or bank.",
      "good-to-know": "If the phone had payment apps or cards, ask for help contacting the bank after the report starts.",
      "explore-next": "Unsafe, emergency, help, hospital, and stolen-bag cards cover nearby safety steps.",
      "natural-variants": "Police, ambulance, and passport-loss cards cover more serious escalation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Điện thoại của tôi", english: "my phone", keepTogetherReason: "owned-phone phrase" },
      { id: "chunk-2", vietnamese: "đã bị đánh cắp.", english: "was stolen.", keepTogetherReason: "stolen phrase" }
    ],
    value: "fixes misleading stolen-phone breakdown glosses and makes the page about reporting and account safety"
  },
  {
    id: "viet-phrase-v500-emer-safe-i-lost-my-credit-card",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v500-emer-safe-i-lost-my-credit-card.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v500-emer-safe-i-lost-my-credit-card.json",
    summary: "For explaining that a credit card is missing before asking for help canceling it.",
    bodies: {
      "at-glance": "Tell hotel staff, bank staff, or a helper the problem before showing account details or the bank app.",
      "quick-say": "Keep the wallet, card photo, bank screen, or passport ready. Do not hand over private numbers unless needed.",
      breakdown: "Tôi bị mất means I lost; thẻ tín dụng means credit card.",
      "when-to-use": "Hotel desks, bank branches, bank phone calls, and police reports are the places this sentence helps.",
      "good-to-know": "The phrase names the lost card. The next step is usually canceling the card or checking recent charges.",
      "explore-next": "Unsafe, emergency, help, hospital, and stolen-bag cards cover urgent next steps nearby.",
      "natural-variants": "Police, ambulance, and passport-loss cards cover more serious escalation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị mất", english: "I lost", keepTogetherReason: "lost-item phrase" },
      { id: "chunk-2", vietnamese: "thẻ tín dụng", english: "credit card", keepTogetherReason: "credit-card phrase" }
    ],
    value: "changes a generic emergency template into a concrete lost-card cancellation moment"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-my-card-was-declined",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-my-card-was-declined.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-my-card-was-declined.json",
    summary: "For explaining a declined card at a counter before trying cash or another payment.",
    bodies: {
      "at-glance": "Use it at checkout while the terminal, bill, or receipt is visible. Keep the tone neutral.",
      "quick-say": "Say the sentence, then show another card, cash, or the app screen if you want to try again.",
      breakdown: "Thẻ của tôi means my card; đã bị từ chối means was declined.",
      "when-to-use": "Restaurants, shops, ticket counters, hotels, and clinics are the places where a payment backup may be needed.",
      "good-to-know": "A declined card is not always a refusal by the shop. It may be bank security, network trouble, or card type.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover nearby payment decisions.",
      "natural-variants": "How-much and per-kilo cards help if the payment issue starts with a price check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Thẻ của tôi", english: "my card", keepTogetherReason: "owned-card phrase" },
      { id: "chunk-2", vietnamese: "đã bị từ chối", english: "was declined", keepTogetherReason: "declined-card phrase" }
    ],
    value: "replaces generic problem-report copy with a calm payment-recovery scenario"
  },
  {
    id: "viet-phrase-v500-phon-inte-powe-can-i-borrow-a-charger",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-i-borrow-a-charger.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-i-borrow-a-charger.json",
    summary: "For asking to borrow a charger at a cafe, hotel desk, shop, or waiting area.",
    bodies: {
      "at-glance": "Ask before your phone dies completely. Hold up the phone or cable so the connector type is obvious.",
      "quick-say": "Show the charging port if needed. Staff may offer a charger, a wall outlet, or a place to leave the phone.",
      breakdown: "Tôi có thể asks can I; mượn means borrow; bộ sạc means charger; được không asks if it is possible.",
      "when-to-use": "Cafes, hotels, airport desks, bus offices, and phone shops are the natural places to ask.",
      "good-to-know": "Keep the phone in sight if you leave it charging. A battery pack may be easier than borrowing a wall charger.",
      "explore-next": "Dead-battery, charger, charge-here, data-top-up, and eSIM cards cover nearby phone problems.",
      "natural-variants": "Wi-Fi password and SIM-card cards help if the charger request turns into a phone-service stop."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "mượn", english: "borrow", keepTogetherReason: "borrow verb" },
      { id: "chunk-3", vietnamese: "bộ sạc", english: "charger", keepTogetherReason: "charger noun" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the charger page about a real dying-phone interaction while preserving phone-service cards"
  },
  {
    id: "viet-phrase-v500-soci-smal-talk-can-we-go-somewhere-cooler",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-can-we-go-somewhere-cooler.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-can-we-go-somewhere-cooler.json",
    summary: "For suggesting a cooler place without making the heat feel like a complaint.",
    bodies: {
      "at-glance": "Use it with friends, a guide, a host, or staff when shade, air conditioning, or a fan would help.",
      "quick-say": "Keep the delivery light. Gesture toward shade, the doorway, or a cooler room if the group is already moving.",
      breakdown: "Chúng ta có thể asks can we; đi đâu đó means go somewhere; mát mẻ hơn means cooler; được không asks if possible.",
      "when-to-use": "Hot afternoons, outdoor tables, walking tours, and crowded rooms are common moments for this phrase.",
      "good-to-know": "Vietnam heat can be intense. A gentle suggestion lands better than saying the place is too hot.",
      "explore-next": "Like-Vietnam, food-good, weather-hot, how-are-you, and stay-length cards keep the small talk friendly.",
      "natural-variants": "From-the-United-States, from-England, and first-time cards cover nearby social openers."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chúng ta có thể", english: "can we", keepTogetherReason: "can-we phrase" },
      { id: "chunk-2", vietnamese: "đi đâu đó", english: "go somewhere", keepTogetherReason: "go-somewhere phrase" },
      { id: "chunk-3", vietnamese: "mát mẻ hơn", english: "cooler", keepTogetherReason: "cooler-place phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns an overheated small-talk page into a tactful shade/AC suggestion"
  },
  {
    id: "viet-phrase-v900-food-drin-i-have-been-waiting-a-long-time",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-i-have-been-waiting-a-long-time.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-i-have-been-waiting-a-long-time.json",
    summary: "For telling restaurant staff you have been waiting a long time for food or a table.",
    bodies: {
      "at-glance": "Use it after a real wait, not as the first thing you say. Keep the order, table, or receipt visible.",
      "quick-say": "Say it calmly and point to the order or table. The next answer may be an apology, a check, or a new wait time.",
      breakdown: "Tôi đã means I have; chờ đợi means waited; rất lâu rồi means for a very long time already.",
      "when-to-use": "Busy restaurants, cafes, host stands, and takeout counters are the places where this phrase fits.",
      "good-to-know": "A calm tone protects the interaction. If needed, follow with the dish name or order number.",
      "explore-next": "Clean-table, counter-order, recommendation, all-done, and pay-now cards cover nearby restaurant flow.",
      "natural-variants": "Table-for-one, table-for-four, wait-for-table, inside-seat, and outside-seat cards cover seating."
    },
    sectionPhrases: {
      "explore-next": [
        { id: "v900-food-drin-can-you-clean-this-table", vietnamese: "Bạn có thể lau cái bàn này được không?", english: "Can you clean this table?", pronunciation: "Ban co the lau cai ban nay duoc khong", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-can-you-clean-this-table", audioKey: "v900-food-drin-can-you-clean-this-table" },
        { id: "v900-food-drin-do-we-order-here-or-at-the-counter", vietnamese: "Chúng ta đặt hàng ở đây hay tại quầy?", english: "Do we order here or at the counter?", pronunciation: "Chung ta dat hang o day hay tai quay", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-do-we-order-here-or-at-the-counter", audioKey: "v900-food-drin-do-we-order-here-or-at-the-counter" },
        { id: "v900-food-drin-what-do-you-recommend", vietnamese: "Bạn đề xuất món gì?", english: "What do you recommend?", pronunciation: "Ban de xuat mon gi", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-what-do-you-recommend", audioKey: "v900-food-drin-what-do-you-recommend" },
        { id: "v900-food-drin-thats-all-thank-you", vietnamese: "Vậy thôi, cảm ơn", english: "That's all, thank you.", pronunciation: "Vay thoi cam on", symbolName: "text.bubble.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-thats-all-thank-you", audioKey: "audio-authored-vay-thoi-cam-on-efab00a56b" },
        { id: "coffee-7", vietnamese: "Tính tiền giúp tôi", english: "Please let me pay", pronunciation: "ting tyen zoop toy", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-family-food-pay-now", audioKey: "coffee-7" }
      ]
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đã", english: "I have", keepTogetherReason: "completed-action opener" },
      { id: "chunk-2", vietnamese: "chờ đợi", english: "waited", keepTogetherReason: "waiting verb" },
      { id: "chunk-3", vietnamese: "rất lâu rồi", english: "for a very long time already", keepTogetherReason: "long-wait phrase" }
    ],
    value: "replaces generic restaurant-card scaffolding with a tactful long-wait escalation"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-need-rehydration-salts",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-rehydration-salts.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-need-rehydration-salts.json",
    summary: "For asking a pharmacy for rehydration salts after heat, stomach trouble, or dehydration.",
    bodies: {
      "at-glance": "Ask at the pharmacy counter and show any symptom note, medicine photo, or translation screen.",
      "quick-say": "Keep the request simple. Staff may point to packets, ask about symptoms, or suggest a clinic if it sounds serious.",
      breakdown: "Tôi cần means I need; muối bù nước means rehydration salts.",
      "when-to-use": "Pharmacies, clinics, hotel desks, and tour stops are the places where dehydration help comes up.",
      "good-to-know": "Ask how to mix and drink it. Packet instructions can be fast, tiny, or only partly familiar.",
      "explore-next": "Headache, stomach pain, motion-sickness medicine, allergy, and diarrhea cards cover nearby health needs.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy cards help if symptoms need professional attention."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "need phrase" },
      { id: "chunk-2", vietnamese: "muối bù nước", english: "rehydration salts", keepTogetherReason: "rehydration-salts phrase" }
    ],
    value: "turns a title-only pharmacy page into a practical dehydration-counter request"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-i-leave-my-bags-until-check-in",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-leave-my-bags-until-check-in.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-leave-my-bags-until-check-in.json",
    summary: "For asking the front desk to hold your bags before the room is ready.",
    bodies: {
      "at-glance": "Ask before dragging luggage around the lobby. Keep the booking name and check-in time ready.",
      "quick-say": "Point to the bags while you ask. Staff may offer a luggage room, tag, pickup time, or different counter.",
      breakdown: "Tôi có thể asks can I; để lại hành lý means leave luggage; cho đến khi nhận phòng means until check-in; không makes it a yes/no question.",
      "when-to-use": "Hotel desks, guesthouse counters, hostels, and apartment check-in offices are the natural places to ask.",
      "good-to-know": "Ask whether the bags need a tag and when the desk closes, especially before a long walk or tour.",
      "explore-next": "Checkout-time, quiet-room, checkout, hot-room, and air-conditioner cards cover nearby front-desk needs.",
      "natural-variants": "Reservation, check-in, and polite check-in cards help if the desk needs to find the stay first."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "để lại hành lý của mình", english: "leave my luggage", keepTogetherReason: "leave-luggage phrase" },
      { id: "chunk-3", vietnamese: "cho đến khi nhận phòng", english: "until check-in", keepTogetherReason: "until-check-in phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a generic front-desk page into a luggage-hold before check-in interaction"
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
    if (repair.sectionPhrases?.[section.id]) {
      next.phrases = repair.sectionPhrases[section.id];
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

  for (const repair of repairs) {
    const { page, before } = updateSource(repair);
    updateAudit(repair, page);
    repairsByPhraseID.set(page.phraseID, repair);
    ledgerRows.push({
      batch: 26,
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
      reason: "premium_audit_batch_26"
    });
    if (repair.sectionPhrases) {
      ledgerRows.push({
        batch: 26,
        tierRole: page.tierRole,
        sectionID: "explore-next",
        sectionTitle: "Explore next",
        pageID: page.id,
        phraseID: page.phraseID,
        sourcePath: repair.source,
        before: {
          phraseCards: countSectionItems(before, "phrases"),
          issue: "source explore-next card list did not match the richer rendered restaurant-flow proof"
        },
        after: {
          phraseCards: countSectionItems(page, "phrases"),
          repair: "aligned first-class source to the five rendered restaurant-flow cards without thinning the rendered page"
        },
        preservedPhraseCards: countSectionItems(page, "phrases"),
        preservedBreakdownRows: countSectionItems(page, "breakdown"),
        concreteTravelerValueImproved: "makes source and rendered proof agree on the richer restaurant follow-up set for the long-wait page",
        reason: "premium_audit_batch_26_card_parity"
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
    batch: 26,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
