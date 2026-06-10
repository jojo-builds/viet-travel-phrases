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
    id: "viet-phrase-v900-airp-bord-arri-do-i-need-to-fill-out-this-form",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-do-i-need-to-fill-out-this-form.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-do-i-need-to-fill-out-this-form.json",
    beforeSummary: "Do I need to fill out this form?",
    summary: "For checking whether an arrival, customs, baggage, hotel, or transport form actually needs to be filled before you move on.",
    bodies: {
      "at-glance": "Hold up the paper or phone form first. The answer should tell you fill it, skip it, or go to the right counter.",
      "quick-say": "Show the form and keep your passport, boarding pass, or booking nearby if staff need to compare details.",
      breakdown: "Tôi có cần means do I need; điền vào means fill in; mẫu đơn này means this form; không makes it a yes/no question.",
      "natural-variants": "Passport, visa, baggage tag, mistake, and signature cards cover the document questions around the form.",
      "when-to-use": "Airport desks, immigration counters, baggage offices, hotels, and transport counters are the moments where this question saves time.",
      "good-to-know": "If staff point to one box, fill only that part before asking again. Some forms are only for certain passports, bags, or bookings.",
      "explore-next": "Move to passport, visa, wrong-form, signature, written-report, or pickup cards if the form leads to another document step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có cần", english: "do I need", keepTogetherReason: "need-question phrase" },
      { id: "chunk-2", vietnamese: "điền vào", english: "fill in", keepTogetherReason: "fill-in verb" },
      { id: "chunk-3", vietnamese: "mẫu đơn này", english: "this form", keepTogetherReason: "this-form phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a bare airport form question into a concrete counter-and-document moment"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-where-is-the-smoking-area",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-smoking-area.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-smoking-area.json",
    beforeSummary: "Where is the smoking area?",
    summary: "For finding the designated smoking area in an airport, station, mall, hotel, or attraction without guessing near the doors.",
    bodies: {
      "at-glance": "Ask staff before stepping outside or following a crowd. The answer is usually a gate, floor, balcony, or marked corner.",
      "quick-say": "Point toward the terminal, lobby, or concourse if there are several exits. Wait for a gesture before walking.",
      breakdown: "Khu vực hút thuốc means smoking area; ở đâu asks where.",
      "natural-variants": "Information-desk, departure-hall, arrival-hall, and phone-charge cards cover nearby terminal navigation.",
      "when-to-use": "Good in airports, train stations, malls, hotels, large restaurants, and attractions where smoking is restricted to marked areas.",
      "good-to-know": "Do not assume an outdoor doorway is allowed. In Vietnam, staff may point to a specific corner even when the space looks open.",
      "explore-next": "Move to information-desk, departure-hall, arrivals, shuttle, or pickup-point cards if you still need orientation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Khu vực hút thuốc", english: "smoking area", keepTogetherReason: "smoking-area phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "grounds the smoking-area page in restricted terminal and venue navigation"
  },
  {
    id: "viet-phrase-v900-dire-navi-can-you-call-this-place-and-ask-for-directions",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-can-you-call-this-place-and-ask-for-directions.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-can-you-call-this-place-and-ask-for-directions.json",
    beforeSummary: "Can you call this place and ask for directions?",
    summary: "For asking a hotel desk, driver, shop counter, or helper to call the destination when the map location is not enough.",
    bodies: {
      "at-glance": "Show the map location and phone number first. The helper needs the destination, not a long story.",
      "quick-say": "Show the map location, address, station name, or sign first, ask once, and leave room for the answer.",
      breakdown: "Bạn có thể asks can you; gọi đến nơi này means call this place; và hỏi đường means and ask for directions; được không softens the request.",
      "natural-variants": "Address, pickup-point, map, and write-it-down cards cover the directions you may need after the call.",
      "when-to-use": "Good when a homestay, clinic, restaurant, shop, tour desk, or pickup point is hard to find from the map alone.",
      "good-to-know": "If the helper gets directions by phone, ask them to point on the map or write the key landmark before you leave.",
      "explore-next": "Move to map, correct pickup point, address, right direction, or write-address cards once the call gives a route."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "gọi đến nơi này", english: "call this place", keepTogetherReason: "call-this-place phrase" },
      { id: "chunk-3", vietnamese: "và hỏi đường", english: "and ask for directions", keepTogetherReason: "ask-directions phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the directions-call page a concrete map-location recovery moment"
  },
  {
    id: "viet-phrase-v900-food-drin-can-we-sit-inside",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-we-sit-inside.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-we-sit-inside.json",
    beforeSummary: "Can we sit inside?",
    title: "Chúng ta có thể ngồi bên trong được không?",
    pronunciation: "Chung ta co the ngoi ben trong duoc khong",
    audioKey: "v900-food-drin-can-we-sit-inside",
    summary: "For asking cafe or restaurant staff whether your group can take an indoor table instead of sitting outside.",
    bodies: {
      "at-glance": "Ask while pointing toward the indoor tables or doorway. The answer may depend on space, air conditioning, or reservations.",
      "quick-say": "Keep the group visible and wait for a table, a no, or a point toward another seating area.",
      breakdown: "Chúng ta có thể means can we; ngồi bên trong means sit inside; được không softens the question.",
      "natural-variants": "Fan, table, menu, wait-time, and bill cards cover the seating and restaurant flow around this request.",
      "when-to-use": "Cafes, noodle shops, restaurants, hotel breakfast rooms, and food courts are the natural moments for this question.",
      "good-to-know": "Indoor seats may be full or reserved. If staff point outside, ask about the fan or another table instead of repeating the same line.",
      "explore-next": "Move to table-for-two, wait-for-table, sit-by-fan, menu, or pay-the-bill cards if the seating exchange continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chúng ta có thể", english: "can we", keepTogetherReason: "can-we phrase" },
      { id: "chunk-2", vietnamese: "ngồi bên trong", english: "sit inside", keepTogetherReason: "sit-inside phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "keeps bundled audio intact while grounding the page in indoor restaurant seating"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-i-have-a-hair-dryer",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-have-a-hair-dryer.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-have-a-hair-dryer.json",
    beforeSummary: "Can I have a hair dryer?",
    title: "Tôi có thể mượn máy sấy tóc được không?",
    pronunciation: "Toi co the muon may say toc duoc khong",
    audioPlanned: true,
    summary: "For asking the hotel or homestay front desk to lend you a hair dryer for the room.",
    bodies: {
      "at-glance": "Ask with your room number or key card ready. Staff may send one up or hand it over at the desk.",
      "quick-say": "Name the item, then show the room number if they need it. Keep the request small and practical.",
      breakdown: "Tôi có thể mượn means can I borrow; máy sấy tóc means hair dryer; được không softens the request.",
      "natural-variants": "Water, towel, air-conditioning, room-fix, and checkout cards cover the hotel requests that often sit nearby.",
      "when-to-use": "Hotels, guesthouses, serviced apartments, homestays, and hostels are the right places to ask for this item.",
      "good-to-know": "Some rooms keep dryers at reception. If staff ask for a deposit or room number, keep the key card visible.",
      "explore-next": "Move to drinking water, towel, air-conditioner, room repair, or late-checkout cards if the desk exchange continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể mượn", english: "can I borrow", keepTogetherReason: "borrow request" },
      { id: "chunk-2", vietnamese: "máy sấy tóc", english: "hair dryer", keepTogetherReason: "hair-dryer phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "replaces literal can-have wording with a natural hotel borrowing request"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-can-you-print-the-receipt",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-can-you-print-the-receipt.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-can-you-print-the-receipt.json",
    beforeSummary: "Can you print the receipt?",
    summary: "For asking a cashier, hotel desk, clinic, pharmacy, or ticket counter to print a receipt before you leave.",
    bodies: {
      "at-glance": "Ask while the payment screen, bill, or purchase is still visible. It is easier before the next customer starts.",
      "quick-say": "Keep the card, cash, room number, or booking nearby in case staff need to find the transaction.",
      breakdown: "Bạn có thể asks can you; in biên lai means print the receipt; được không softens the request.",
      "natural-variants": "Card payment, refund, insurance receipt, and smaller-bills cards cover the paperwork around payment.",
      "when-to-use": "Shops, pharmacies, clinics, hotels, transport counters, and ticket desks are the places where a printed receipt may matter later.",
      "good-to-know": "Ask before walking away. Once the counter resets, staff may need the exact time, amount, or card slip to find it.",
      "explore-next": "Move to card payment, insurance receipt, refund, smaller bills, or write-down cards if the payment record needs more detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "in biên lai", english: "print the receipt", keepTogetherReason: "print-receipt phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns the receipt page into a concrete counter paperwork moment"
  },
  {
    id: "viet-phrase-v900-poli-basi-can-i-come-in",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/v900-poli-basi-can-i-come-in.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/polite-basics/v900-poli-basi-can-i-come-in.json",
    beforeSummary: "Can I come in?",
    summary: "For asking permission before entering a room, office, clinic space, staff area, home, temple room, or small shop interior.",
    bodies: {
      "at-glance": "Pause at the doorway and ask before stepping in. A nod, hand wave, or shoe-removal gesture may be the answer.",
      "quick-say": "Keep your body outside the threshold until they answer. The phrase works best with a small pause.",
      breakdown: "Tôi có thể means can I; vào means come in or enter; được không softens the question.",
      "natural-variants": "May-I, excuse-me, thank-you, and wait-here cards cover the polite doorway flow around this question.",
      "when-to-use": "Good at homestays, clinics, salons, small offices, temples, staff rooms, and shops where the entrance is not clearly public.",
      "good-to-know": "Doorway etiquette is often visual. Watch for shoes, a curtain, a raised hand, or a point to another entrance.",
      "explore-next": "Move to excuse-me, may-I, wait-here, where-is-the-entrance, or thank-you cards once permission is clear."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "vào", english: "come in / enter", keepTogetherReason: "enter verb" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the permission page a doorway etiquette moment instead of a generic yes-no page"
  },
  {
    id: "viet-phrase-v900-shop-can-i-see-that-one",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-can-i-see-that-one.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-can-i-see-that-one.json",
    beforeSummary: "Can I see that one?",
    summary: "For asking shop staff to show the item behind the counter, high on a shelf, inside a case, or across the stall.",
    bodies: {
      "at-glance": "Point to the exact item first. The phrase is clearer when staff can see which color, size, or display piece you mean.",
      "quick-say": "Keep pointing until they reach for the right one. If there are several similar items, add a color or size card next.",
      breakdown: "Tôi có thể means can I; xem cái đó means see that one; được không softens the question.",
      "natural-variants": "Color, size, inside, price, and cheaper-option cards cover the shopping questions that usually follow.",
      "when-to-use": "Markets, souvenir stalls, jewelry cases, clothing shops, and electronics counters are the natural places for this request.",
      "good-to-know": "If the item is fragile or behind glass, let staff handle it first. Ask to touch it only after they show it.",
      "explore-next": "Move to color, size, inside, price, touch-it, or cheaper-one cards if you keep comparing."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "xem cái đó", english: "see that one", keepTogetherReason: "see-that-one phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "grounds the see-that-one page in a pointing-and-display shopping moment"
  },
  {
    id: "viet-phrase-v900-shop-can-you-give-me-a-discount",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-can-you-give-me-a-discount.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-can-you-give-me-a-discount.json",
    beforeSummary: "Can you give me a discount?",
    summary: "For asking a market seller or flexible-price shop for a lower price after you already know the amount.",
    bodies: {
      "at-glance": "Ask while holding or pointing at one item. A smile and a pause keep the price talk light.",
      "quick-say": "Let the seller answer with a new number, a calculator, or a firm no. Do not add a long explanation.",
      breakdown: "Bạn có thể asks can you; giảm giá cho tôi means give me a discount; được không softens the request.",
      "natural-variants": "Best-price, cheaper-one, lower-price, final-price, and how-much cards cover the bargaining flow around this ask.",
      "when-to-use": "Markets, souvenir stalls, informal clothing shops, and flexible-price counters are the right places. Fixed-price stores are not.",
      "good-to-know": "Ask after the first price, not before. If they type a number, repeat it back or show it on the calculator.",
      "explore-next": "Move to best-price, cheaper-one, how-much, final-price, or too-expensive cards if the bargaining continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "giảm giá cho tôi", english: "give me a discount", keepTogetherReason: "discount phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns the discount page into a market-price moment with clear bargaining boundaries"
  },
  {
    id: "viet-phrase-v900-sigh-acti-is-photography-allowed",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-photography-allowed.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-photography-allowed.json",
    beforeSummary: "Is photography allowed?",
    summary: "For checking photo rules before taking pictures in a museum, temple, exhibit, performance space, market stall, or tour site.",
    bodies: {
      "at-glance": "Ask before raising the camera or phone. Staff may point to a sign, a no-flash rule, or a restricted room.",
      "quick-say": "Show the phone or camera if needed, then wait for yes, no, or a gesture toward the allowed area.",
      breakdown: "Có được phép means is it allowed; chụp ảnh means take photos; không makes it a yes/no question.",
      "natural-variants": "Ticket, guide, entrance, meeting-point, and closing-time cards cover the attraction questions around photo rules.",
      "when-to-use": "Museums, temples, galleries, shows, markets, workshops, and tours are the moments where photo rules can change by room.",
      "good-to-know": "Flash can be a separate rule. If staff say yes, still watch for signs around altars, exhibits, or performers.",
      "explore-next": "Move to English guide, entrance, ticket, closing time, or meeting point cards if the visit needs another rule check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có được phép", english: "is it allowed", keepTogetherReason: "allowed question" },
      { id: "chunk-2", vietnamese: "chụp ảnh", english: "take photos", keepTogetherReason: "photography phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the photography page into a concrete photo-rule check at attractions"
  },
  {
    id: "viet-phrase-v900-tran-the-car-number-is-different",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-the-car-number-is-different.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-the-car-number-is-different.json",
    beforeSummary: "The car number is different",
    title: "Biển số xe không giống",
    englishTitle: "The license plate is different",
    pronunciation: "Bien so xe khong giong",
    audioPlanned: true,
    summary: "For telling a driver, guard, or ride-hailing helper that the license plate does not match the car on your app.",
    bodies: {
      "at-glance": "Keep the ride screen open and compare the plate before getting in. This is a safety check, not a small wording detail.",
      "quick-say": "Point to the app plate and then the vehicle plate. Wait for an explanation before opening the door.",
      breakdown: "Biển số xe means license plate; không giống means does not match.",
      "natural-variants": "Driver, pickup point, correct car, address, and cancel-ride cards cover the ride-hailing checks around this line.",
      "when-to-use": "Ride-hailing pickups, hotel driveways, airport pickup zones, and station curbs are the moments where plate mismatch matters.",
      "good-to-know": "If the plate, driver photo, or car color is wrong, do not get in until the app or staff confirms it.",
      "explore-next": "Move to driver, correct car, pickup point, cancel ride, or contact-driver cards if the pickup still feels uncertain."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Biển số xe", english: "license plate", keepTogetherReason: "license-plate phrase" },
      { id: "chunk-2", vietnamese: "không giống", english: "does not match / is different", keepTogetherReason: "not-matching phrase" }
    ],
    value: "fixes car-number wording to a ride-hailing license-plate safety check"
  },
  {
    id: "viet-phrase-v900-tran-which-bus-goes-to-the-city-center",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-which-bus-goes-to-the-city-center.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-which-bus-goes-to-the-city-center.json",
    beforeSummary: "Which bus goes to the city center?",
    summary: "For asking station staff, airport staff, a kiosk, or another passenger which bus goes toward the city center before you board.",
    bodies: {
      "at-glance": "Ask before stepping onto the bus. Keep the destination or map visible so the answer can point to a route number or bay.",
      "quick-say": "Point toward the buses or route board, then wait for a number, platform, or direction.",
      breakdown: "Xe buýt nào means which bus; đi vào means goes into; trung tâm thành phố means the city center.",
      "natural-variants": "Ticket, platform, shuttle, pickup-point, and fare cards cover the transport choices around this question.",
      "when-to-use": "Airport bus stops, stations, local terminals, hotel desks, and street-side bus bays are the moments where route numbers matter.",
      "good-to-know": "The answer may be a route number instead of a sentence. Ask them to point if the board is crowded.",
      "explore-next": "Move to ticket, platform, fare, shuttle, or where-to-buy-ticket cards once you know the route."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xe buýt nào", english: "which bus", keepTogetherReason: "which-bus phrase" },
      { id: "chunk-2", vietnamese: "đi vào", english: "goes into", keepTogetherReason: "goes-into phrase" },
      { id: "chunk-3", vietnamese: "trung tâm thành phố?", english: "the city center?", keepTogetherReason: "city-center phrase" }
    ],
    value: "turns the bus page into a specific route-number and boarding decision moment"
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

function alignSelfPhraseCards(page, repair) {
  if (!repair.audioPlanned && !repair.title && !repair.englishTitle && !repair.pronunciation) return;

  const alignPhrase = (phrase) => {
    if (!phrase || phrase.detailPageID !== null || phrase.id !== page.phraseID) return phrase;
    return {
      ...phrase,
      vietnamese: page.title,
      english: page.englishTitle,
      pronunciation: page.pronunciation,
      symbolName: repair.audioPlanned ? "text.bubble.fill" : page.audioKey ? "speaker.wave.2.fill" : phrase.symbolName,
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
  if (repair.audioKey !== undefined) page.audioKey = repair.audioKey;
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
    if (repair.title && index.target_text !== undefined) row[index.target_text] = repair.title;
    if (repair.title && index.canonical_target_text !== undefined) row[index.canonical_target_text] = repair.title;
    if (repair.englishTitle && index.english_text !== undefined) row[index.english_text] = repair.englishTitle;
    if (repair.pronunciation && index.pronunciation !== undefined) row[index.pronunciation] = repair.pronunciation;
    if (repair.summary && index.family_summary !== undefined) row[index.family_summary] = repair.summary;
    if (repair.audioKey !== undefined) {
      if (index.audio_key !== undefined) row[index.audio_key] = repair.audioKey;
      if (index.audio_status !== undefined) row[index.audio_status] = "ready";
      if (index.notes !== undefined) {
        row[index.notes] = String(row[index.notes] || "")
          .replace(/; Batch 21 semantic repair moved audio to planned/g, "")
          .replace(/Batch 21 semantic repair moved audio to planned; /g, "")
          .replace(/Batch 21 semantic repair moved audio to planned/g, "");
        if (!row[index.notes].includes("Batch 21 retained bundled audio after city useful-phrase gate")) {
          row[index.notes] = `${row[index.notes]}; Batch 21 retained bundled audio after city useful-phrase gate`;
        }
      }
    }
    if (repair.audioPlanned) {
      if (index.audio_key !== undefined) row[index.audio_key] = "";
      if (index.audio_status !== undefined) row[index.audio_status] = "planned";
      if (index.notes !== undefined) {
        const note = row[index.notes] || "";
        if (!note.includes("Batch 21 semantic repair moved audio to planned")) {
          row[index.notes] = `${note}; Batch 21 semantic repair moved audio to planned`;
        }
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
      batch: 21,
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
          repair.audioPlanned ? "semantic audio replacement" : "source breakdown gloss repair"
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
      reason: "premium_audit_batch_21"
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
    batch: 21,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: newLedgerRows.length,
    updatedLedgerRows,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
