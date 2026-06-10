#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);
const renderedPath = path.join(repoRoot, "native-ios/Resources/viet-authored-listing-pages.json");

const repairs = [
  {
    id: "viet-phrase-v900-shop-where-is-the-fitting-room",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-where-is-the-fitting-room.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-where-is-the-fitting-room.json",
    beforeSummary: "Where is the fitting room?",
    summary: "For finding the changing room in a clothing shop, market stall, boutique, or mall store before trying something on.",
    bodies: {
      "at-glance": "Ask while holding the item or size you want to try. The answer is usually a point, curtain, corner, or upstairs/downstairs.",
      "quick-say": "Keep the item visible. If there are separate rooms or a line, show the piece and wait for the direction.",
      breakdown: "Phòng thử đồ means fitting room; ở đâu asks where.",
      "natural-variants": "Size, color, and try-on cards cover the clothing questions that usually sit beside the fitting room.",
      "when-to-use": "Good in clothing shops, market stalls, boutiques, malls, tailor shops, and souvenir stores with apparel.",
      "good-to-know": "Some fitting rooms are simple curtained areas. Watch the gesture first, then ask again if the direction is unclear.",
      "explore-next": "Move to just-looking, where-pay, exchange-this, item-price, or lower-price cards if the shopping flow continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Phòng thử đồ", english: "fitting room", keepTogetherReason: "fitting-room phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "turns a bare fitting-room question into a clothing-shop moment while preserving shopping follow-up cards"
  },
  {
    id: "viet-phrase-v900-tran-please-wait-while-i-get-in",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-please-wait-while-i-get-in.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-please-wait-while-i-get-in.json",
    beforeSummary: "Please wait while I get in",
    title: "Vui lòng đợi tôi lên xe",
    englishTitle: "Please wait while I get in",
    pronunciation: "Vui long doi toi len xe",
    audioPlanned: true,
    summary: "For asking a driver to wait a moment while you get into the car or onto the motorbike.",
    bodies: {
      "at-glance": "Use it at the curb before the ride starts, especially with luggage, a child, or a slow step into traffic.",
      "quick-say": "Say it before moving toward the door or seat. Keep the ride screen or destination visible if the driver is checking.",
      breakdown: "Vui lòng means please; đợi tôi means wait for me; lên xe means get in or onto the vehicle.",
      "natural-variants": "Take-me-here, District 1, and stop-here cards cover the ride instructions around the pickup.",
      "when-to-use": "Good for taxis, rideshares, private cars, motorbike taxis, and station pickups when the driver is ready before you are seated.",
      "good-to-know": "A small hand gesture helps. The driver needs to know you are getting in, not changing the destination.",
      "explore-next": "Move to stop-here, go-this-way, air-conditioning, wait-five-minutes, or cash cards if the ride needs another instruction."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "đợi tôi", english: "wait for me", keepTogetherReason: "wait-for-me phrase" },
      { id: "chunk-3", vietnamese: "lên xe", english: "get in / onto the vehicle", keepTogetherReason: "vehicle-boarding phrase" }
    ],
    value: "fixes a too-literal vehicle phrase and moves the changed self phrase to planned audio instead of reusing stale audio"
  },
  {
    id: "viet-phrase-food-premium-has-peanuts",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-premium-has-peanuts.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/food-has-peanuts.json",
    beforeSummary: "Does this have peanuts?",
    summary: "For checking a dish, sauce, topping, or dessert for peanuts before you eat or order.",
    bodies: {
      "at-glance": "Point to the exact dish or sauce. This question needs the item in view.",
      "quick-say": "Ask before eating, then wait for a clear yes, no, or safer recommendation.",
      breakdown: "Cái này means this item; có asks has; đậu phộng means peanuts; không turns it into a yes/no question.",
      "when-to-use": "Good at stalls, restaurants, cafes, dessert counters, and markets when toppings or sauces are not obvious.",
      "good-to-know": "Peanuts can appear as garnish, sauce, or crushed topping. If peanuts are dangerous for you, follow with the allergy card.",
      "explore-next": "Move to fish-sauce, egg-or-peanuts, vegetarian, or peanut-allergy cards if the answer needs more safety detail.",
      "natural-variants": "No-meat, without-ingredient, allergy, meat-type, and shrimp cards cover nearby food-safety checks."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái này", english: "this item", keepTogetherReason: "this-item phrase" },
      { id: "chunk-2", vietnamese: "có", english: "has", keepTogetherReason: "has verb" },
      { id: "chunk-3", vietnamese: "đậu phộng", english: "peanuts", keepTogetherReason: "peanut noun" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the peanut page a concrete food-safety check while preserving allergy and ingredient cards"
  },
  {
    id: "viet-phrase-food-premium-without-this-ingredient",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-premium-without-this-ingredient.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/food-without-this-ingredient.json",
    beforeSummary: "Can you make it without this ingredient?",
    title: "Bạn có thể làm món này không có nguyên liệu này được không?",
    englishTitle: "Can you make it without this ingredient?",
    pronunciation: "Ban co the lam mon nay khong co nguyen lieu nay duoc khong",
    audioPlanned: true,
    summary: "For asking staff to leave out the specific ingredient you are pointing at before they make the dish.",
    bodies: {
      "at-glance": "Point to the ingredient, menu line, or photo first. The kitchen needs the exact thing to leave out.",
      "quick-say": "Ask before ordering and wait for yes, no, or a safer dish. Keep the request short.",
      breakdown: "Bạn có thể asks can you; làm món này means make this dish; không có nguyên liệu này means without this ingredient; được không softens the request.",
      "when-to-use": "Good at restaurants, noodle shops, cafes, vegetarian counters, and stalls where a dish can sometimes be adjusted.",
      "good-to-know": "If the ingredient is an allergy risk, use the allergy cards too. Removing one topping may not change broth, sauce, or oil.",
      "explore-next": "Move to allergy cards if the answer needs more precision than one ingredient.",
      "natural-variants": "No-meat, safest-dish, meat-type, shrimp, and fish-sauce cards cover nearby ingredient checks."
    },
    copyRenderedPhraseSections: ["explore-next"],
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "làm món này", english: "make this dish", keepTogetherReason: "make-this-dish phrase" },
      { id: "chunk-3", vietnamese: "không có nguyên liệu này", english: "without this ingredient", keepTogetherReason: "without-this-ingredient phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "fixes a literal ingredient phrase, moves stale audio to planned, and aligns source with rendered allergy follow-up cards"
  },
  {
    id: "viet-phrase-help-premium-contact-embassy",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/help-premium-contact-embassy.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/help-contact-embassy.json",
    beforeSummary: "Can you help me contact the embassy?",
    summary: "For asking a hotel desk, clinic, police counter, or trusted helper to help contact your embassy.",
    bodies: {
      "at-glance": "Use it when the next step needs an official contact, not just a local suggestion.",
      "quick-say": "Show your passport copy, embassy number, contact page, or message draft. Keep the request calm and direct.",
      breakdown: "Bạn có thể asks can you; giúp tôi means help me; liên hệ với đại sứ quán means contact the embassy; được không softens the request.",
      "natural-variants": "Lost and left-something cards cover the story that may explain why embassy help is needed.",
      "when-to-use": "Good at hotels, clinics, police counters, travel offices, and with a trusted local helper during a serious document or safety problem.",
      "good-to-know": "Embassy help usually needs exact identity and contact details. Keep your passport copy or phone screen ready.",
      "explore-next": "Move to need-help, call-hotel, manager, charged-twice, or file-report cards if the helper asks what happened next."
    },
    copyRenderedPhraseSections: ["natural-variants"],
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "giúp tôi", english: "help me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-3", vietnamese: "liên hệ với đại sứ quán", english: "contact the embassy", keepTogetherReason: "embassy-contact phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "removes generic help copy, keeps the embassy page serious, and resolves a duplicate source-only help card"
  },
  {
    id: "viet-phrase-hotel-premium-late-checkout",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/hotel-premium-late-checkout.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/hotel-late-checkout.json",
    beforeSummary: "Can I check out later?",
    summary: "For asking the front desk whether you can leave the room later than the normal checkout time.",
    bodies: {
      "at-glance": "Ask while the booking, room number, or key card is visible.",
      "quick-say": "Keep it short. The answer may depend on housekeeping, occupancy, or an extra fee.",
      breakdown: "Tôi có thể asks can I; trả phòng means check out; sau means later; được không softens the question.",
      "natural-variants": "Reservation and check-in cards cover the front-desk flow around this request.",
      "when-to-use": "Good at hotel desks, guesthouses, serviced apartments, homestays, and hostels before the normal checkout time.",
      "good-to-know": "Late checkout may be unavailable or paid. Confirm the new time before you leave the desk.",
      "explore-next": "Move to checkout-time, quiet-room, checkout, hot-room, or air-conditioner cards if the front desk exchange continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "trả phòng", english: "check out", keepTogetherReason: "checkout verb" },
      { id: "chunk-3", vietnamese: "sau", english: "later", keepTogetherReason: "later word" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "grounds late checkout in a front-desk timing request while preserving hotel follow-up cards"
  },
  {
    id: "viet-phrase-v500-dire-navi-do-i-go-downstairs",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-do-i-go-downstairs.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-do-i-go-downstairs.json",
    beforeSummary: "Do I go downstairs?",
    summary: "For checking whether the route, platform, counter, restroom, or exit is one level below you.",
    bodies: {
      "at-glance": "Ask while pointing at the stairs, escalator, sign, map, or floor number.",
      "quick-say": "Show the place you are trying to reach. The answer may be a point down, a floor number, or a quick no.",
      breakdown: "Tôi có asks do I; đi xuống means go down; tầng dưới means downstairs or lower floor; không makes it a question.",
      "natural-variants": "How-to-get-there, near-here, and walking-time cards cover the direction questions around it.",
      "when-to-use": "Good in stations, malls, museums, markets, hotels, clinics, and buildings where the right level is not obvious.",
      "good-to-know": "Downstairs may mean a lower floor, basement, platform, or underpass. Watch the gesture before moving.",
      "explore-next": "Move to left, right, straight, understand-now, or pickup-point cards if the route needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có", english: "do I", keepTogetherReason: "question frame" },
      { id: "chunk-2", vietnamese: "đi xuống", english: "go down", keepTogetherReason: "go-down verb" },
      { id: "chunk-3", vietnamese: "tầng dưới", english: "downstairs / lower floor", keepTogetherReason: "lower-floor phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "fixes misleading source glosses and makes the page a real floor-level navigation check"
  },
  {
    id: "viet-phrase-v500-emer-safe-please-call-the-police",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v500-emer-safe-please-call-the-police.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v500-emer-safe-please-call-the-police.json",
    beforeSummary: "Please call the police",
    summary: "For asking someone nearby to call the police in a real safety, theft, harassment, or threat situation.",
    bodies: {
      "at-glance": "Use it when the situation needs police help now. Keep the location or photo visible if you can.",
      "quick-say": "Say the line clearly, then show the location, stolen item, photo, passport copy, or person involved.",
      breakdown: "Hãy is a direct please-do opener; gọi means call; cảnh sát means police.",
      "natural-variants": "Police, ambulance, and passport cards cover the urgent help choices around this request.",
      "when-to-use": "Good at hotel desks, shops, stations, police counters, and street help moments when the problem is active or serious.",
      "good-to-know": "Keep the request short. If you are unsafe, move toward staff, a counter, or a public place while asking.",
      "explore-next": "Move to unsafe, emergency, help, hospital, or stolen-bag cards if the helper needs the situation named."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy", english: "please do", keepTogetherReason: "direct request opener" },
      { id: "chunk-2", vietnamese: "gọi", english: "call", keepTogetherReason: "call verb" },
      { id: "chunk-3", vietnamese: "cảnh sát", english: "police", keepTogetherReason: "police noun" }
    ],
    value: "keeps the police page urgent and concrete instead of generic health/help copy"
  },
  {
    id: "viet-phrase-v500-emer-safe-there-has-been-an-accident",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v500-emer-safe-there-has-been-an-accident.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v500-emer-safe-there-has-been-an-accident.json",
    beforeSummary: "There has been an accident",
    summary: "For telling someone there has been an accident and the situation needs help now.",
    bodies: {
      "at-glance": "Use it when you need attention fast before giving details.",
      "quick-say": "Say the line, then show the location, injury, vehicle, photo, or person who needs help.",
      breakdown: "Đã có means there has been; một tai nạn means an accident.",
      "natural-variants": "Police, ambulance, and passport cards cover the urgent help choices around this report.",
      "when-to-use": "Good with hotel staff, station staff, police counters, clinic desks, drivers, and bystanders when an accident has just happened.",
      "good-to-know": "After this line, the next useful detail is usually location, injury, or whether an ambulance is needed.",
      "explore-next": "Move to unsafe, emergency, help, hospital, or stolen-bag cards if the helper needs the situation named."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đã có", english: "there has been", keepTogetherReason: "there-has-been phrase" },
      { id: "chunk-2", vietnamese: "một tai nạn", english: "an accident", keepTogetherReason: "accident phrase" }
    ],
    value: "turns accident copy into an urgent report moment and removes misplaced symptom/medicine scaffolding"
  },
  {
    id: "viet-phrase-v500-prob-help-can-you-call-my-emergency-contact",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-can-you-call-my-emergency-contact.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-can-you-call-my-emergency-contact.json",
    beforeSummary: "Can you call my emergency contact?",
    summary: "For asking a hotel desk, clinic, police counter, or helper to call the emergency contact saved on your phone.",
    bodies: {
      "at-glance": "Use it when you need another person reached, not just local help at the counter.",
      "quick-say": "Open the contact first. Show the name and number so the helper does not have to search your phone.",
      breakdown: "Bạn có thể gọi cho asks can you call; người liên lạc khẩn cấp của tôi means my emergency contact; được không softens the request.",
      "natural-variants": "Lost and left-something cards cover the story that may explain why the contact is needed.",
      "when-to-use": "Good at hotels, clinics, police counters, stations, and with trusted staff when you cannot comfortably make the call yourself.",
      "good-to-know": "Keep the contact screen open and unlocked. If the call is urgent, show the number before explaining everything.",
      "explore-next": "Move to need-help, call-hotel, manager, charged-twice, or file-report cards if the helper asks what happened next."
    },
    copyRenderedPhraseSections: ["natural-variants"],
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể gọi cho", english: "can you call", keepTogetherReason: "can-you-call phrase" },
      { id: "chunk-2", vietnamese: "người liên lạc khẩn cấp của tôi", english: "my emergency contact", keepTogetherReason: "emergency-contact phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes emergency-contact help concrete and resolves a duplicate source-only need-help card"
  },
  {
    id: "viet-phrase-v500-shop-is-this-new",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v500-shop-is-this-new.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v500-shop-is-this-new.json",
    beforeSummary: "Is this new?",
    summary: "For checking whether a shop item is new, unused, or fresh stock before buying it.",
    bodies: {
      "at-glance": "Ask while pointing at the exact item, box, tag, or display piece.",
      "quick-say": "Hold up the item and wait for yes, no, or a replacement from the back.",
      breakdown: "Cái này means this item; có mới asks is it new; không makes it a yes/no question.",
      "natural-variants": "Size, color, and try-on cards cover the choice questions that often follow.",
      "when-to-use": "Good in markets, clothing shops, electronics counters, souvenir shops, and stalls where display pieces may be handled.",
      "good-to-know": "If condition matters, point to the packaging, seal, tag, or scratch you are asking about.",
      "explore-next": "Move to just-looking, where-pay, exchange-this, item-price, or lower-price cards if the shopping exchange continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái này", english: "this item", keepTogetherReason: "this-item phrase" },
      { id: "chunk-2", vietnamese: "có mới", english: "is new", keepTogetherReason: "is-new phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "grounds the new-item page in packaging/display-piece checks while preserving shopping follow-ups"
  },
  {
    id: "viet-phrase-v500-sigh-acti-where-is-the-entrance",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v500-sigh-acti-where-is-the-entrance.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v500-sigh-acti-where-is-the-entrance.json",
    beforeSummary: "Where is the entrance?",
    summary: "For finding the entrance to an attraction, museum, temple, station, market, or event space.",
    bodies: {
      "at-glance": "Ask near the ticket desk, gate, sidewalk, or crowd flow. The answer may be a point rather than a sentence.",
      "quick-say": "Show the ticket, booking, map, or attraction name only if the first answer is not enough.",
      breakdown: "Lối vào means entrance; ở đâu asks where.",
      "natural-variants": "Ticket, start-point, and photo-rule cards cover the attraction questions that often sit nearby.",
      "when-to-use": "Good at museums, temples, markets, stations, parks, event spaces, and tour stops with more than one gate.",
      "good-to-know": "Entrances can be around the side or through a parking area. Follow the gesture first, then ask again if needed.",
      "explore-next": "Move to closing-time, meeting-point, book-in-advance, tour-booking, or ticket-buying cards if you need the next logistics detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Lối vào", english: "the entrance", keepTogetherReason: "entrance phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "turns entrance copy into a concrete gate-finding moment while preserving sightseeing follow-up cards"
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

function renderedSectionsByPage() {
  const rendered = JSON.parse(fs.readFileSync(renderedPath, "utf8")).pages;
  const result = new Map();
  for (const page of rendered) {
    result.set(page.id, new Map((page.sections || []).map((section) => [section.id, section])));
  }
  return result;
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

function updateSource(repair, renderedByPage) {
  const page = readJson(repair.source);
  const before = JSON.parse(JSON.stringify(page));
  if (repair.title) page.title = repair.title;
  if (repair.englishTitle) page.englishTitle = repair.englishTitle;
  if (repair.pronunciation) page.pronunciation = repair.pronunciation;
  if (repair.audioPlanned) page.audioKey = null;
  page.summary = repair.summary;
  const renderedSections = renderedByPage.get(repair.id) || new Map();
  page.sections = (page.sections || []).map((section) => {
    const next = { ...section };
    if (Object.prototype.hasOwnProperty.call(repair.bodies, section.id)) {
      next.body = repair.bodies[section.id];
    }
    if ((repair.copyRenderedPhraseSections || []).includes(section.id)) {
      next.phrases = (renderedSections.get(section.id)?.phrases || []).map((phrase) => ({ ...phrase }));
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
        if (!note.includes("Batch 20 semantic repair moved audio to planned")) {
          row[index.notes] = `${note}; Batch 20 semantic repair moved audio to planned`;
        }
      }
    }
    changed += 1;
  }
  fs.writeFileSync(absPath, formatCSV(rows, bomMode));
  return changed;
}

function main() {
  const renderedByPage = renderedSectionsByPage();
  const repairsByPhraseID = new Map();
  const ledgerRows = [];
  for (const repair of repairs) {
    const { page, before, after } = updateSource(repair, renderedByPage);
    updateAudit(repair, page);
    repairsByPhraseID.set(page.phraseID, repair);
    ledgerRows.push({
      batch: 20,
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
      reason: "premium_audit_batch_20"
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
    batch: 20,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: newLedgerRows.length,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
