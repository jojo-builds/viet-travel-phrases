#!/usr/bin/env node

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const familyRoot = path.resolve(root, "..");
const catalogPath = path.join(root, "Resources", "viet-phrase-catalog.json");
const audioManifestPath = path.join(root, "Resources", "viet-audio-manifest.json");
const outputPath = path.join(root, "Resources", "viet-authored-listing-pages.json");
const auditPath = path.join(root, "Resources", "viet-authored-audio-audit.json");
const sourceRoot = path.join(familyRoot, "content-draft", "viet", "listing-pages");

const catalog = JSON.parse(fs.readFileSync(catalogPath, "utf8"));
const audioManifest = JSON.parse(fs.readFileSync(audioManifestPath, "utf8"));

const phraseByID = new Map(catalog.phrases.map((phrase) => [phrase.id, phrase]));
const scenarioByID = new Map(catalog.scenarios.map((scenario) => [scenario.id, scenario]));
const familiesByScenarioID = new Map();

for (const family of catalog.families) {
  if (!familiesByScenarioID.has(family.scenarioID)) {
    familiesByScenarioID.set(family.scenarioID, []);
  }
  familiesByScenarioID.get(family.scenarioID).push(family);
}

const designedFamilyPageIDs = {
  "polite-hello": "viet-polite-hello",
  "polite-thank-you": "viet-thank-you",
  "polite-excuse-me": "viet-excuse-sorry",
  "v500-poli-basi-excuse-me": "viet-excuse-sorry",
  "polite-goodbye": "viet-goodbye",
  "social-how-are-you": "viet-how-are-you",
};

const manuallyAuthoredPageIDs = new Set([
  "viet-family-repair-meaning",
]);

const rootPageID = "viet-polite-hello";

const pageCategoryOverrides = {
  "viet-thank-you": ["gratitude"],
  "viet-excuse-sorry": ["repair"],
  "viet-goodbye": ["goodbyes"],
  "viet-how-are-you": ["small-talk", "greetings"],
};

function categoryIDsForPage(pageID, family) {
  return pageCategoryOverrides[pageID] ?? [family.scenarioID];
}

const phraseOverrides = {
  "v500-sigh-acti-i-have-a-tour-booking": {
    targetText: "Tôi có đặt tour",
    pronunciation: "toy koh dat tour",
    context: "Use this at a tour desk, meeting point, or attraction entrance when you need staff to match you to an existing tour booking.",
  },
  "v500-phon-inte-powe-where-can-i-get-a-local-sim-card": {
    targetText: "Tôi có thể mua SIM ở đâu?",
    pronunciation: "toy koh theh moo-ah sim uh dow",
    context: "Use this when you need to buy a SIM card or find the right counter for mobile data.",
  },
  "food-not-spicy-clearer": {
    targetText: "Ít cay thôi",
    englishText: "Less spicy, please",
    pronunciation: "eet kai thoy",
    context: "Use this when fully not spicy is unrealistic but you still need the dish milder.",
  },
  "v500-shop-can-you-lower-the-price": {
    targetText: "Giảm giá chút được không?",
    pronunciation: "zam zah choot dook khong",
    context: "Use this in markets or flexible-price shops when you want to ask for a small discount without sounding too formal.",
  },
  "v500-heal-phar-i-feel-dizzy": {
    targetText: "Tôi cảm thấy chóng mặt",
    pronunciation: "toy gahm thay chong mat",
    context: "Use this when dizziness is the symptom you need a pharmacist, clinic, or helper to understand quickly.",
  },
};

for (const [phraseID, override] of Object.entries(phraseOverrides)) {
  const phrase = phraseByID.get(phraseID);
  if (phrase) {
    phraseByID.set(phraseID, { ...phrase, ...override });
  }
}

const familyCopyOverrides = {
  "repair-write-down": {
    summary: "Written text often rescues numbers, names, room numbers, and addresses faster than more speech.",
    atGlance: "Written text often rescues numbers, names, room numbers, and addresses faster than more speech. Use this when you need the other person to give you something you can read, save, or show again.",
    standard: "Viết xuống giúp tôi is the safest default for asking someone to write it down. It keeps the request polite and specific without needing to explain what you missed.",
    when: "Use it for hotel addresses, pickup points, prices, room numbers, names, or any detail you need to keep after the conversation ends.",
    watch: "Do not make it sound like a demand. A calm tone keeps the request cooperative, especially if the person already repeated themselves once.",
    tip: "Hand over your phone with a blank note open if paper is not nearby. The phrase plus the blank screen usually makes the request obvious.",
  },
  "v500-sigh-acti-i-have-a-tour-booking": {
    summary: "Use this when staff need to find an existing tour reservation, not sell you a new ticket.",
    atGlance: "Use this at a tour desk, pier, hotel lobby, or attraction entrance when you already booked and need staff to find your reservation. Show the booking name, QR code, or confirmation screen while you say it.",
    standard: "Tôi có đặt tour is the compact version to learn first. Tour is widely understood in travel settings, and đặt keeps the meaning on a booking or reservation rather than a casual plan.",
    when: "Use it before a tour starts, when checking in with a guide, or when a desk asks whether you already booked. Follow with the booking name if they look uncertain.",
    watch: "Do not rely on the phrase alone if the place is busy. Show the voucher or booking code so staff can match the right tour.",
    tip: "If staff answer with a time or meeting point, ask them to point to it on the voucher or map.",
  },
  "v500-phon-inte-powe-where-can-i-get-a-local-sim-card": {
    summary: "Ask this when you need to find a counter or shop that sells SIM cards for mobile data.",
    atGlance: "Use this when you land, lose data, or need a local mobile plan. In real travel speech, asking where to buy a SIM is clearer than a literal 'local SIM card' sentence.",
    standard: "Tôi có thể mua SIM ở đâu? is polite and easy to understand. You can also shorten it to Mua SIM ở đâu? when pointing at a phone kiosk.",
    when: "Use it at airports, convenience stores, phone shops, hotel desks, or tourist counters when you need mobile data before moving on.",
    watch: "Ask to see the data amount and expiration date before paying. A SIM plan can sound clear in speech but still be different on the printed package.",
    tip: "Show your phone and say SIM. Staff usually understand the goal quickly once they see the screen or SIM tray.",
  },
  "v500-shop-can-you-lower-the-price": {
    summary: "Use this when bargaining is normal and you want to ask for a small discount.",
    atGlance: "Use this in markets or flexible-price shops, not at fixed-price counters. Giảm giá chút được không? asks for a small discount without using the peer-like bạn.",
    standard: "Giảm giá chút được không? is the cleaner discount question here. It keeps the ask light and lets the seller say yes, no, or counteroffer.",
    when: "Use it after you know the price and still want to buy if the seller can lower it a little.",
    watch: "Keep your tone friendly. In Vietnam, bargaining can be playful in markets but awkward in fixed-price stores.",
    tip: "Point to the item, smile, and pause. The pause gives the seller room to answer without pressure.",
  },
  "money-lower-price": {
    summary: "Use this short market phrase only where bargaining is normal.",
    atGlance: "Bớt chút được không? is the compact local-feeling way to ask for a little lower price. It is useful in markets, informal stalls, or flexible-price moments.",
    standard: "Bớt chút được không? literally asks whether they can reduce it a little. It is shorter and more natural than a full textbook sentence.",
    when: "Use it after hearing the price, while still holding or pointing at the item.",
    watch: "Do not use it in places with fixed prices, posted menus, or official counters. There it can feel misplaced.",
    tip: "If the answer is a number, ask them to type it on a calculator so you do not mishear the final price.",
  },
  "v500-heal-phar-i-feel-dizzy": {
    summary: "Use this when dizziness is the symptom you need help for.",
    atGlance: "Use this at a pharmacy, clinic, hotel desk, or with a guide when you feel light-headed or dizzy. Keep it direct so the other person knows this is a health issue, not small talk.",
    standard: "Tôi cảm thấy chóng mặt is the safer complete sentence. It says 'I feel dizzy' clearly and gives the helper a symptom they can act on.",
    when: "Use it before asking for medicine, a place to sit, a clinic, or help contacting someone.",
    watch: "If dizziness is severe, repeated, or paired with chest pain, fainting, or trouble breathing, move to an emergency phrase instead of trying to soften it.",
    tip: "Point to yourself, sit if you need to, and show any medicine or condition note you carry.",
  },
  "social-how-are-you": {
    summary: "Use this after a greeting with someone close enough for light conversation.",
    atGlance: "Bạn khỏe không? is friendly, but it is not the only way to check in. With older people or service staff, Vietnamese often sounds warmer when you swap bạn for anh, chị, cô, chú, ông, or bà.",
    standard: "Bạn khỏe không? works best with peers, friends, classmates, or someone whose age relationship feels close to yours.",
    when: "Use it after Xin chào or Chào bạn, not as the very first sentence to a stranger in a rushed service moment.",
    watch: "With an older man or woman, Anh khỏe không? or Chị khỏe không? can sound more natural than generic bạn.",
    tip: "If you are unsure, keep it simple and friendly. A smile and the right relationship word often matter more than a perfect sentence.",
  },
  "v500-airp-bord-arri-here-is-my-visa": {
    summary: "Use this when immigration, airline, or visa staff need to see your visa document.",
    atGlance: "Use this when you are handing over a printed visa, e-visa, phone screenshot, or document folder. It tells staff exactly what the document is and that it belongs to you.",
    standard: "Đây là thị thực của tôi is clear and formal enough for document checks. It works best while the visa is already visible in your hand or on your phone.",
    when: "Use it at immigration, airline check-in, visa-on-arrival counters, or any desk where staff ask for visa proof.",
    watch: "If the visa is on your phone, make sure the screen is bright and unlocked before you start. Staff may need the passport and visa together.",
    tip: "Keep the passport open nearby. The fastest handoff is usually passport plus visa, not a long explanation.",
  },
};

function familyOverride(family) {
  return familyCopyOverrides[family.id] ?? {};
}

const scenarioGuidance = {
  "polite-basics": {
    moment: "small service and first-contact moments",
    why: "Polite Vietnamese often works by softening the start or end of an interaction before the main request.",
    tip: "A small smile and a calm pace matter. These short phrases are often enough to make a service moment feel warmer.",
    watch: "Do not overthink the grammar in quick service moments. Clear, polite, and short is better than a long sentence said nervously.",
  },
  "understanding-repair": {
    moment: "moments when Vietnamese stops making sense",
    why: "These phrases keep the interaction cooperative when repeating the same words is not helping.",
    tip: "If speaking does not work, move quickly to writing, pointing, or showing the exact word on your phone.",
    watch: "Keep your tone curious. A sharp tone can make a clarification question sound like a challenge.",
  },
  transport: {
    moment: "rides, routes, pickup points, and stops",
    why: "Transport phrases work best when the driver can connect your words to a map, address, or landmark.",
    tip: "Show the location on your phone while you say the phrase. The visual context reduces mistakes.",
    watch: "Say the key place first, then confirm. Long explanations in a moving car are easy to misunderstand.",
  },
  "hotel-accommodation": {
    moment: "front desk, room, check-in, and hotel-service moments",
    why: "Hotel staff usually need one concrete detail: your booking, room number, time, or the item you need.",
    tip: "Pair the phrase with a booking screen, key card, room number, or photo of the problem.",
    watch: "Stay calm and specific. A direct phrase plus the room number is usually more effective than extra explanation.",
  },
  "food-drink": {
    moment: "ordering, adjusting dishes, and checking ingredients",
    why: "Vietnamese food interactions move fast, so pointing and short phrases protect the order.",
    tip: "Point to the dish or ingredient while speaking. It helps when tone marks or dish names are hard to pronounce.",
    watch: "For allergies and dietary limits, use the clearest version and confirm visually if possible.",
  },
  "money-numbers-prices": {
    moment: "prices, quantities, payment, and ATM moments",
    why: "Money phrases prevent small misunderstandings from becoming awkward after the transaction starts.",
    tip: "If the answer is a number, ask them to type it or show it on a calculator.",
    watch: "Confirm the final price before handing over cash or card, especially in markets and taxi moments.",
  },
  "directions-navigation": {
    moment: "finding places, turns, distance, and walking directions",
    why: "Direction phrases turn a vague travel problem into a specific next step.",
    tip: "Show the map or address first, then ask the phrase. The answer is easier to understand when both of you see the same place.",
    watch: "If the answer is long, ask them to point or type it. Street directions can be hard to catch by ear.",
  },
  "airport-border-arrival": {
    moment: "arrival, immigration, baggage, SIM cards, pickup, and airport services",
    why: "Airport phrases help staff route you to the next counter or service without a long explanation.",
    tip: "Keep your passport, baggage tag, or booking screen visible while you ask.",
    watch: "Airport staff may answer by pointing. Follow the gesture first, then ask again if the next step is still unclear.",
  },
  "health-pharmacy": {
    moment: "doctors, pharmacies, symptoms, and medication",
    why: "Health phrases need to be simple because the other person may need to act quickly or ask a follow-up.",
    tip: "Show the symptom, medication, or affected area when possible. It gives the helper something concrete.",
    watch: "Do not soften urgent medical needs too much. Clear and direct is safer.",
  },
  "problems-help": {
    moment: "lost items, help, managers, and recovery moments",
    why: "Help phrases work when they name the problem and the next person or action you need.",
    tip: "Start with the simplest phrase, then show the item, place, receipt, or photo connected to the problem.",
    watch: "If you feel unsafe or stuck, move to a stronger help phrase instead of trying to sound perfectly polite.",
  },
  "time-dates-booking": {
    moment: "times, dates, tickets, waits, and bookings",
    why: "Time phrases prevent missed pickups, bookings, and closing times.",
    tip: "Confirm the answer visually on a phone, ticket, or calendar when the exact time matters.",
    watch: "Morning, afternoon, and tomorrow can be easy to mix up. Repeat the date or show it if the booking matters.",
  },
  shopping: {
    moment: "sizes, colors, trying things on, and payment",
    why: "Shopping phrases keep the exchange short while still giving the seller enough detail to help.",
    tip: "Hold or point to the item as you speak. The phrase lands faster when the object is obvious.",
    watch: "In markets, price talk can feel playful. Keep your tone light when asking for a lower price.",
  },
  "phone-internet-power": {
    moment: "Wi-Fi, SIM, battery, charging, maps, and phone setup",
    why: "Phone phrases work best when the other person can see the exact screen or error.",
    tip: "Show the phone screen while you speak. A visible error message often explains the problem faster than more words.",
    watch: "Do not hand over your unlocked phone unless you trust the situation. Show the screen first.",
  },
  "bathroom-personal-needs": {
    moment: "bathrooms, soap, paper, water, and basic personal needs",
    why: "These phrases are practical and often need a quick answer, not a long conversation.",
    tip: "Ask directly and follow gestures. People may simply point you toward the right place.",
    watch: "Some places may not have paper or soap available. Asking early avoids an awkward surprise.",
  },
  "emergency-safety": {
    moment: "police, ambulance, hospitals, passports, and immediate safety",
    why: "Emergency phrases put the urgent need first so help can move faster.",
    tip: "Use the phrase clearly, then show your location, passport copy, injury, or emergency contact.",
    watch: "In safety moments, clarity matters more than sounding polished. Repeat the phrase if needed.",
  },
  "social-small-talk": {
    moment: "friendly introductions and light local conversation",
    why: "Small talk in Vietnamese often becomes warmer when it connects to place, food, or shared experience.",
    tip: "Keep it light. A friendly question after the phrase often feels more natural than a long introduction.",
    watch: "Some social phrases are best after a greeting, not as the very first thing you say to a stranger.",
  },
  "sightseeing-activities": {
    moment: "tickets, tours, photos, closing times, and meeting points",
    why: "Sightseeing phrases help staff answer with a point, ticket, time, or location.",
    tip: "Show the tour booking, ticket, or map while you ask.",
    watch: "Meeting points and start times are worth confirming twice, especially on busy tours.",
  },
  "local-services-everyday-tasks": {
    moment: "buying small items, receipts, bags, and everyday errands",
    why: "Everyday service phrases keep small tasks smooth without needing a full conversation.",
    tip: "Point to the item or show a photo when you can. It avoids guessing from pronunciation alone.",
    watch: "If the item is not available, ask for a nearby alternative instead of repeating the same phrase.",
  },
};

const glossary = new Map(Object.entries({
  "xin": "polite marker",
  "chào": "hello / greet",
  "cảm": "feel / thanks",
  "ơn": "gratitude",
  "nhiều": "much / many",
  "dạ": "polite yes",
  "không": "no / not / question",
  "cho": "give / let",
  "tôi": "I / me",
  "mình": "I / me",
  "anh": "older man",
  "chị": "older woman",
  "em": "younger person",
  "bạn": "you / friend",
  "giúp": "help",
  "với": "please / with",
  "làm": "do / make",
  "ơn": "favor / thanks",
  "ở": "at / in",
  "đâu": "where",
  "gần": "near",
  "nhất": "most",
  "bao": "how much",
  "nhiêu": "many / much",
  "mấy": "what / which",
  "giờ": "time / hour",
  "ngày": "day",
  "hôm": "day",
  "nay": "today / this",
  "mai": "tomorrow",
  "đi": "go",
  "đến": "to / arrive",
  "đây": "here / this",
  "đó": "that",
  "này": "this",
  "là": "is / means",
  "gì": "what",
  "nghĩa": "meaning",
  "nói": "speak / say",
  "chậm": "slow",
  "lại": "again",
  "viết": "write",
  "ra": "out",
  "số": "number",
  "tiền": "money / price",
  "phòng": "room",
  "khách": "guest",
  "sạn": "hotel",
  "nhận": "receive / check in",
  "trả": "return / check out",
  "hành": "luggage",
  "lý": "baggage",
  "visa": "visa",
  "hộ": "passport",
  "chiếu": "passport",
  "nhà": "place / house",
  "vệ": "clean / sanitary",
  "sinh": "hygiene",
  "bệnh": "illness",
  "viện": "institute / hospital",
  "thuốc": "medicine",
  "bác": "doctor",
  "sĩ": "doctor",
  "đau": "pain",
  "đầu": "head",
  "bụng": "stomach",
  "cứu": "rescue / help",
  "cấp": "urgent",
  "cảnh": "police",
  "sát": "police",
  "nguy": "danger",
  "hiểm": "danger",
  "vé": "ticket",
  "mở": "open",
  "đóng": "close",
  "cửa": "door / counter",
  "sim": "SIM card",
  "wifi": "Wi-Fi",
  "sạc": "charge",
  "pin": "battery",
  "bản": "map",
  "đồ": "map / thing",
  "nước": "water",
  "cà": "coffee",
  "phê": "coffee",
  "sữa": "milk",
  "đá": "ice",
  "đường": "sugar / street",
  "cay": "spicy",
  "ít": "less / little",
  "món": "dish",
  "ăn": "eat",
  "chay": "vegetarian",
  "đậu": "bean / peanut",
  "phộng": "peanut",
  "trứng": "egg",
  "bàn": "table",
  "menu": "menu",
  "thực": "food / item",
  "đơn": "menu / bill",
  "hóa": "invoice",
  "biên": "receipt",
  "lai": "receipt",
  "túi": "bag",
  "màu": "color",
  "size": "size",
  "cỡ": "size",
  "thử": "try on",
  "xem": "look / see",
  "mua": "buy",
  "bán": "sell",
  "rẻ": "cheap",
  "hơn": "more / than",
  "được": "can / okay",
}));

function normalizeAudioText(value) {
  return value.normalize("NFC").replace(/\s+/g, " ").trim().toLowerCase();
}

const audioKeyByText = new Map();
for (const [key, entry] of Object.entries(audioManifest)) {
  const normalized = normalizeAudioText(entry.text);
  if (!audioKeyByText.has(normalized)) {
    audioKeyByText.set(normalized, key);
  }
}

function exactAudioKey(text, preferredKey) {
  const normalized = normalizeAudioText(text);
  if (preferredKey && audioManifest[preferredKey] && normalizeAudioText(audioManifest[preferredKey].text) === normalized) {
    return preferredKey;
  }
  return audioKeyByText.get(normalized) ?? null;
}

function authoredAudioKey(prefix, text, preferredKey = null) {
  const exactKey = exactAudioKey(text, preferredKey);
  if (exactKey) {
    return exactKey;
  }

  const hash = crypto.createHash("sha1").update(text.normalize("NFC")).digest("hex").slice(0, 10);
  return `${prefix}-${slug(text)}-${hash}`;
}

function authoredPhraseAudioKey(text, preferredKey) {
  return authoredAudioKey("audio-authored", text, preferredKey);
}

function authoredBreakdownAudioKey(text) {
  return authoredAudioKey("breakdown-authored", text);
}

function slug(value) {
  return value
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/đ/g, "d")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 64);
}

function tintForScenario(scenarioID) {
  return scenarioByID.get(scenarioID)?.tintName ?? "gray";
}

function symbolForScenario(scenarioID) {
  return scenarioByID.get(scenarioID)?.symbolName ?? "text.bubble.fill";
}

function canonicalPageID(family) {
  return designedFamilyPageIDs[family.id] ?? family.pageID;
}

function phraseOption(phrase, detailPageID = null, tintName = null) {
  return {
    id: phrase.id,
    vietnamese: phrase.targetText,
    english: phrase.englishText,
    pronunciation: phrase.pronunciation,
    symbolName: "speaker.wave.2.fill",
    tintName: tintName ?? tintForScenario(phrase.scenarioID),
    detailPageID,
    audioKey: authoredPhraseAudioKey(phrase.targetText, phrase.audioKey),
  };
}

function manualPhraseOption(id, vietnamese, english, pronunciation, tintName, detailPageID = null) {
  return {
    id,
    vietnamese,
    english,
    pronunciation,
    symbolName: "speaker.wave.2.fill",
    tintName,
    detailPageID,
    audioKey: authoredPhraseAudioKey(vietnamese, null),
  };
}

function scenarioCopy(scenarioID) {
  return scenarioGuidance[scenarioID] ?? {
    moment: "the travel moment in front of you",
    why: "The phrase says the practical need plainly before the conversation gets complicated.",
    tip: "Say the phrase first, then point, show, or gesture to the detail that matters.",
    watch: "Keep the sentence short and clear. More words are not always more helpful.",
  };
}

function phraseDepth(family, primaryPhrase) {
  const deepScenarios = new Set([
    "understanding-repair",
    "transport",
    "directions-navigation",
    "money-numbers-prices",
    "health-pharmacy",
    "emergency-safety",
    "hotel-accommodation",
    "food-drink",
    "airport-border-arrival",
    "problems-help",
  ]);

  if (deepScenarios.has(family.scenarioID)) {
    return "deep";
  }

  if ((family.phraseIDs ?? []).length > 1 || primaryPhrase.warningNoteType) {
    return "support";
  }

  return "baseline";
}

function sentence(text) {
  if (!text) return "";
  return /[.!?]$/.test(text.trim()) ? text.trim() : `${text.trim()}.`;
}

function weakSummary(summary) {
  return /when you need|need to explain that|use this when you need/i.test(summary ?? "");
}

function atGlanceText(family, primaryPhrase) {
  const copy = scenarioCopy(family.scenarioID);
  const override = familyOverride(family);
  if (override.atGlance) return override.atGlance;

  const lead = primaryPhrase.context
    ? sentence(primaryPhrase.context)
    : `${primaryPhrase.targetText} gives you a compact way to say "${primaryPhrase.englishText}" in ${copy.moment}.`;
  const usefulSummary = override.summary ?? (weakSummary(family.summary) ? "" : sentence(family.summary));
  const nextStep = (family.phraseIDs ?? []).length > 1
    ? "Use the nearby forms below when tone, setting, or politeness changes."
    : "Start with the full phrase, then use the nearby rows when the conversation needs one more step.";

  return [
    lead,
    usefulSummary,
    nextStep,
  ].filter(Boolean).join(" ");
}

function standardText(family, primaryPhrase) {
  const override = familyOverride(family);
  if (override.standard) return override.standard;

  return [
    `${primaryPhrase.targetText} is the safest default for "${primaryPhrase.englishText}".`,
    primaryPhrase.context ? sentence(primaryPhrase.context) : "It is short enough to say in a real travel moment.",
    "Say it slowly, then point, show your phone, or hold up the item if the other person needs more context.",
  ].join(" ");
}

function usageText(family, primaryPhrase) {
  const copy = scenarioCopy(family.scenarioID);
  const override = familyOverride(family);
  if (override.when) return override.when;

  const momentSentence = copy.moment.startsWith("moments when")
    ? `It helps in ${copy.moment}, especially when one clear sentence will work better than a long explanation.`
    : `Use it in ${copy.moment} when one clear sentence will work better than a long explanation.`;

  return [
    primaryPhrase.context ? sentence(primaryPhrase.context) : sentence(family.summary),
    momentSentence,
  ].join(" ");
}

function watchOutText(family, primaryPhrase) {
  const override = familyOverride(family);
  if (override.watch) return override.watch;

  if (primaryPhrase.warningNoteType === "medical") {
    return "Use this as the first sentence, then show symptoms, medication, or the affected area. In a health moment, clear details matter more than perfect grammar.";
  }

  if (primaryPhrase.warningNoteType === "safety") {
    return "Keep the phrase direct and repeat it if needed. In a safety moment, clarity matters more than sounding polished.";
  }

  return scenarioCopy(family.scenarioID).watch;
}

function localTipText(family, primaryPhrase) {
  return familyOverride(family).tip ?? scenarioCopy(family.scenarioID).tip;
}

function whyItMattersText(family) {
  return familyOverride(family).why ?? scenarioCopy(family.scenarioID).why;
}

function normalizedVietnameseKey(value) {
  return value
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9/]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

const preferredBreakdownChunks = new Set([
  "anh/chi",
  "anh chi",
  "bac si",
  "bao lau",
  "bao nhieu",
  "buu dien",
  "ca phe",
  "ca phe den",
  "ca phe sua",
  "cam thay",
  "cam on",
  "cho hoi",
  "cho toi",
  "co ban",
  "co the",
  "cua toi",
  "dia chi",
  "dia phuong",
  "dia diem",
  "dia diem cu",
  "dia diem moi",
  "dat tour",
  "da xay ra",
  "di bo",
  "di thang",
  "dien thoai",
  "de nhan phong",
  "duoc khong",
  "gan nhat",
  "giup toi",
  "hanh ly",
  "ho chieu",
  "khach san",
  "khong duong",
  "khong sao",
  "khong sao dau",
  "it cay",
  "khu don",
  "lam on",
  "may lanh",
  "mat khau",
  "mua sim",
  "giam gia",
  "nha thuoc",
  "nha ve sinh",
  "nhan phong",
  "nhap canh",
  "noi lai",
  "nuoc suoi",
  "o dau",
  "re phai",
  "re trai",
  "say xe",
  "the hanh ly",
  "the sim",
  "thi thuc",
  "chong mat",
  "thuc don",
  "tien mat",
  "tieng anh",
  "thit bo",
  "thit ga",
  "thit lon",
  "toi bi",
  "toi can",
  "toi co",
  "toi co the",
  "toi khong",
  "toi muon",
  "toi tra",
  "tra phong",
  "truong hop",
  "viet xuong",
  "yen tinh",
  "xin chao",
  "xin loi",
  "xin vui long",
]);

const breakdownMeanings = new Map(Object.entries({
  "anh/chi": "you (polite)",
  "anh chi": "you (polite)",
  "lay": "claim / collect",
  "hanh ly": "baggage",
  "cong": "gate",
  "mua": "buy",
  "mua sim": "buy a SIM",
  "sim": "SIM card",
  "the sim": "SIM card",
  "dia phuong": "local",
  "day": "here / this",
  "la": "is",
  "thi thuc": "visa",
  "ho chieu": "passport",
  "the hanh ly": "baggage tag",
  "cua toi": "my / mine",
  "cua": "of",
  "toi": "I / me",
  "toi bi": "I have / got",
  "toi can": "I need",
  "toi co": "I have",
  "toi co the": "can I",
  "toi khong": "I do not",
  "toi muon": "I want",
  "toi tra": "I pay",
  "ban": "you",
  "co": "have / yes",
  "co the": "can",
  "co ban": "do you sell",
  "khong": "not / no",
  "khong duong": "no sugar",
  "khong sao": "it is okay",
  "khong sao dau": "it is okay",
  "phai": "right / must",
  "dung": "correct",
  "sai": "wrong",
  "o": "at / in",
  "o dau": "where?",
  "den": "to / arrive",
  "di": "go",
  "di bo": "walk",
  "di thang": "go straight",
  "de": "to / for",
  "de nhan phong": "for check-in",
  "ve": "ticket",
  "xe": "vehicle",
  "dia chi": "address",
  "dia diem": "location",
  "dia diem cu": "old location",
  "dia diem moi": "new location",
  "cu": "old",
  "moi": "new",
  "chinh xac": "correct / exact",
  "tien": "money",
  "tien mat": "cash",
  "gia": "price",
  "bao nhieu": "how much",
  "bao lau": "how long",
  "bot": "reduce / lower",
  "chut": "a little",
  "giup": "help",
  "giup toi": "help me",
  "nhung gi": "what",
  "da xay ra": "happened",
  "xay ra": "happen",
  "xin": "please",
  "xin chao": "hello",
  "xin loi": "excuse me / sorry",
  "xin vui long": "please",
  "cho": "for",
  "cho hoi": "excuse me / may I ask",
  "cho toi": "can I have",
  "mot": "one",
  "hai": "two",
  "hay": "or",
  "bac si": "doctor",
  "buu dien": "post office",
  "ca phe": "coffee",
  "ca phe den": "black coffee",
  "ca phe sua": "milk coffee",
  "cam on": "thank you",
  "cam thay": "feel",
  "chong mat": "dizzy",
  "cua hang": "shop",
  "dat": "book / reserve",
  "dat tour": "booked a tour",
  "dien thoai": "phone",
  "duoc khong": "is it possible?",
  "giam": "reduce",
  "giam gia": "lower the price",
  "gan nhat": "nearest",
  "khach san": "hotel",
  "it cay": "less spicy",
  "khoe": "healthy / well",
  "khu don": "pickup area",
  "lam on": "please",
  "may lanh": "air conditioning",
  "mat khau": "password",
  "nha thuoc": "pharmacy",
  "nha ve sinh": "bathroom",
  "nhan phong": "check in",
  "nhap canh": "immigration",
  "noi lai": "say again",
  "nuoc suoi": "bottled water",
  "phong": "room",
  "phong yen tinh": "quiet room",
  "re phai": "turn right",
  "re trai": "turn left",
  "say xe": "motion sickness",
  "thuc don": "menu",
  "thit bo": "beef",
  "thit ga": "chicken",
  "thit lon": "pork",
  "tieng anh": "English",
  "thoi": "only / just",
  "tra phong": "check out",
  "truong hop": "case / situation",
  "khan cap": "emergency",
  "viet": "write",
  "viet xuong": "write down",
  "xuong": "down",
  "yen tinh": "quiet",
}));

function englishFallbackChunk(englishText, index) {
  const words = englishText
    .replace(/[?!.,]+/g, "")
    .split(/\s+/)
    .filter(Boolean)
    .map((word) => word.toLowerCase());

  return words[index] ?? englishText.toLowerCase();
}

function breakdownMeaning(vietnamese, fallback) {
  const normalized = normalizedVietnameseKey(vietnamese);
  if (/^\d+$/.test(normalized)) return vietnamese;
  return breakdownMeanings.get(normalized) ?? glossary.get(vietnamese.toLowerCase()) ?? fallback;
}

function chunkVietnamesePhrase(phrase) {
  const words = phrase.split(/\s+/).filter(Boolean);
  const chunks = [];

  while (words.length > 0) {
    const maxCandidateLength = Math.min(3, words.length);
    let matchedChunk = null;

    for (let length = maxCandidateLength; length >= 2; length -= 1) {
      const candidate = words.slice(0, length).join(" ");
      if (preferredBreakdownChunks.has(normalizedVietnameseKey(candidate))) {
        matchedChunk = candidate;
        break;
      }
    }

    if (matchedChunk) {
      chunks.push(matchedChunk);
      words.splice(0, matchedChunk.split(/\s+/).length);
    } else {
      chunks.push(words.shift());
    }
  }

  return chunks;
}

function semanticBreakdownPieces(targetText, englishText) {
  const terminal = targetText.match(/[?!.,]+$/)?.[0] ?? "";
  let workingTarget = targetText.replace(/[?!.,]+$/g, "").trim();
  const suffixPieces = [];
  const suffixes = [
    ["được không", "is it possible?"],
    ["đúng không", "right?"],
    ["phải không", "is that right?"],
    ["không", "yes/no question"],
  ];

  for (const [vietnamese, english] of suffixes) {
    const normalizedTarget = normalizedVietnameseKey(workingTarget);
    const normalizedSuffix = normalizedVietnameseKey(vietnamese);
    if (!normalizedTarget.endsWith(normalizedSuffix)) continue;

    const suffixWithSpace = ` ${vietnamese}`;
    const lowerTarget = workingTarget.toLowerCase();
    const index = lowerTarget.lastIndexOf(suffixWithSpace);
    if (index >= 0) {
      workingTarget = workingTarget.slice(0, index).trim();
      suffixPieces.push({
        vietnamese: vietnamese + (terminal === "?" ? "?" : ""),
        english,
      });
      break;
    }
  }

  const corePieces = chunkVietnamesePhrase(workingTarget)
    .filter(Boolean)
    .map((chunk, index) => ({
      vietnamese: chunk,
      english: breakdownMeaning(chunk, englishFallbackChunk(englishText, index)),
    }));

  return [...corePieces, ...suffixPieces];
}

function showingItemLabel(englishText, ownsItem) {
  const prefixes = ownsItem
    ? ["Here is my", "This is my", "Here is the", "This is the", "Here is", "This is"]
    : ["Here is", "This is", "It is"];

  for (const prefix of prefixes) {
    if (englishText.toLowerCase().startsWith(prefix.toLowerCase())) {
      return englishText.slice(prefix.length).replace(/[ .?!]+$/g, "").trim().toLowerCase();
    }
  }

  return englishText.toLowerCase();
}

function showingPhraseBreakdownPieces(targetText, englishText) {
  if (targetText.startsWith("Đây là ") && targetText.endsWith(" của tôi")) {
    const itemText = targetText
      .slice("Đây là ".length, targetText.length - " của tôi".length)
      .trim();
    return [
      { vietnamese: "Đây", english: "here / this" },
      { vietnamese: "là", english: "is" },
      ...semanticBreakdownPieces(itemText, showingItemLabel(englishText, true)),
      { vietnamese: "của tôi", english: "my / mine" },
    ];
  }

  if (targetText.startsWith("Đây là ")) {
    const itemText = targetText.slice("Đây là ".length).trim();
    return [
      { vietnamese: "Đây", english: "here / this" },
      { vietnamese: "là", english: "is" },
      ...semanticBreakdownPieces(itemText, showingItemLabel(englishText, false)),
    ];
  }

  return null;
}

function placeNameFromWhereQuestion(englishText) {
  const match = englishText.match(/^where\s+(?:is|are)\s+(.+?)\??$/i);
  return match ? match[1].trim().toLowerCase() : "place";
}

function splitVietnamesePieces(targetText, englishText) {
  const normalizedTargetText = targetText.normalize("NFC");
  const normalizedEnglishText = englishText.normalize("NFC");

  if (normalizedTargetText.endsWith(" ở đâu?")) {
    const subject = normalizedTargetText.slice(0, -" ở đâu?".length).trim();
    return [
      ...semanticBreakdownPieces(subject, placeNameFromWhereQuestion(normalizedEnglishText)),
      { vietnamese: "ở đâu?", english: "where?" },
    ];
  }

  return showingPhraseBreakdownPieces(normalizedTargetText, normalizedEnglishText)
    ?? semanticBreakdownPieces(normalizedTargetText, normalizedEnglishText);
}

function breakdownTokens(phrase) {
  const pieces = splitVietnamesePieces(phrase.targetText, phrase.englishText)
    .map((piece, index) => ({
      id: `${phrase.id}-piece-${index + 1}`,
      vietnamese: piece.vietnamese,
      english: piece.english,
      audioKey: authoredBreakdownAudioKey(piece.vietnamese),
    }));

  pieces.push({
    id: `${phrase.id}-full`,
    vietnamese: phrase.targetText,
    english: phrase.englishText,
    audioKey: authoredPhraseAudioKey(phrase.targetText, phrase.audioKey),
  });

  return pieces;
}

function breakdownLeadIn(phrase) {
  const targetText = phrase.targetText.normalize("NFC");
  const englishText = phrase.englishText.normalize("NFC");

  if (targetText.endsWith(" ở đâu?")) {
    return "This pattern asks where a place or service is. Swap the first part to ask about another nearby stop.";
  }

  if (targetText.startsWith("Đây là ") && targetText.endsWith(" của tôi")) {
    return "Use this when you are showing a document or item. The phrase points to it, names it, then marks it as yours.";
  }

  if (showingPhraseBreakdownPieces(targetText, englishText)) {
    return "Use this when you need to identify what something is. The phrase points to the item first, then names it clearly.";
  }

  if (targetText.includes("không")) {
    return "This pattern turns the phrase into a yes-or-no question. Keep the main need together so the question stays natural.";
  }

  if (phrase.targetText.startsWith("Đây là")) {
    return "This pattern points to something first, then names it. It is useful when a document, item, or screen is already visible.";
  }

  return "Use the cards to hear the phrase in pieces, then listen to the full version so the rhythm stays connected.";
}

function variantBody(variants) {
  return variants.length === 1
    ? "This nearby form changes the tone or setting. Use it when the note under the row matches the moment."
    : "These nearby forms are not decoration. Each one changes the tone, setting, or next action, so choose the row that matches the person in front of you.";
}

function naturalVariationSection(family, variantOptions) {
  if (variantOptions.length > 0) {
    return {
      id: "natural-variations",
      title: "Natural variations",
      body: variantBody(variantOptions),
      phrases: variantOptions,
    };
  }

  return null;
}

function nearbyPhraseSection(family, excludingPageIDs) {
  const relatedOptions = exploreOptions(family, 4, excludingPageIDs);
  if (relatedOptions.length === 0) {
    return null;
  }

  return {
    id: "nearby-phrases",
    title: "Useful nearby phrases",
    body: "These are not the same sentence, but they are the next phrases a traveler is likely to need as this moment keeps moving.",
    phrases: relatedOptions,
  };
}

function linkedPageIDs(sections) {
  const ids = new Set();
  for (const section of sections) {
    for (const phrase of section.phrases ?? []) {
      if (phrase.detailPageID) {
        ids.add(phrase.detailPageID);
      }
    }
  }
  return ids;
}

function nearbyFamilies(family, limit = 8, excludingPageIDs = new Set()) {
  const families = familiesByScenarioID.get(family.scenarioID) ?? [];
  const sameScenario = families.filter((candidate) => candidate.id !== family.id);
  const starters = sameScenario.filter((candidate) => candidate.accessTier === "starter");
  return starters
    .filter((candidate) => !excludingPageIDs.has(canonicalPageID(candidate)))
    .filter((candidate, index, all) => all.findIndex((other) => other.id === candidate.id) === index)
    .slice(0, limit);
}

function exploreOptions(family, limit = 8, excludingPageIDs = new Set()) {
  return nearbyFamilies(family, limit, excludingPageIDs).map((candidate) => {
    const phrase = phraseByID.get(candidate.primaryPhraseID);
    return phraseOption(phrase, canonicalPageID(candidate), tintForScenario(candidate.scenarioID));
  });
}

function childPageForVariant(family, variantPhrase, primaryPhrase) {
  const pageID = `viet-phrase-${variantPhrase.id}`;
  const scenario = scenarioByID.get(family.scenarioID);
  return {
    id: pageID,
    familyID: family.id,
    phraseID: variantPhrase.id,
    tierRole: "child",
    depth: "baseline",
    title: variantPhrase.targetText,
    englishTitle: variantPhrase.englishText,
    pronunciation: variantPhrase.pronunciation,
    summary: `A focused guide to using ${variantPhrase.targetText} as a nearby form of ${primaryPhrase.targetText}.`,
    iconName: scenario?.symbolName ?? "text.bubble.fill",
    tintName: tintForScenario(family.scenarioID),
    categoryIDs: categoryIDsForPage(pageID, family),
    audioKey: authoredPhraseAudioKey(variantPhrase.targetText, variantPhrase.audioKey),
    sections: withSectionPresentations([
      {
        id: "at-glance",
        title: "At a glance",
        body: `${variantPhrase.targetText} is useful when "${variantPhrase.englishText}" fits better than the parent phrase. ${sentence(variantPhrase.context || family.summary)}`
      },
      {
        id: "breakdown",
        title: "Break it down",
        body: breakdownLeadIn(variantPhrase),
        breakdown: breakdownTokens(variantPhrase),
      },
      {
        id: "when-to-use",
        title: "When to use it",
        body: `${sentence(variantPhrase.context || family.summary)} Return to ${primaryPhrase.targetText} when you need the simpler default version.`,
      },
      {
        id: "watch-out",
        title: "Watch out",
        body: watchOutText(family, variantPhrase),
      },
      {
        id: "explore-next",
        title: "Explore next",
        body: "Nearby phrases keep the conversation moving after this one.",
        phrases: [
          phraseOption(primaryPhrase, canonicalPageID(family), tintForScenario(family.scenarioID)),
          ...exploreOptions(family).slice(0, 5),
        ],
      },
    ]),
    examples: [phraseOption(variantPhrase, null, tintForScenario(family.scenarioID))],
  };
}

function sectionPresentation(section) {
  if (section.presentation) {
    return section.presentation;
  }

  if ((section.breakdown ?? []).length > 0 || section.id === "breakdown") {
    return "breakdown-strip";
  }

  switch (section.id) {
    case "standard-way":
    case "ways-to-say":
    case "relationship-forms":
    case "pronoun-swap":
    case "explore-next":
      return (section.phrases ?? []).length > 0 ? "phrase-list" : "plain-text";
    case "natural-variations":
    case "nearby-phrases":
      return (section.phrases ?? []).length > 0 ? "horizontal-phrase-cards" : "plain-text";
    case "watch-out":
      return "warning-callout";
    case "local-tip":
    case "traveler-tip":
      return "tip-callout";
    default:
      return (section.phrases ?? []).length > 0 ? "phrase-list" : "plain-text";
  }
}

function withSectionPresentations(sections) {
  return sections.map((section) => ({
    ...section,
    presentation: sectionPresentation(section),
  }));
}

function pageForFamily(family, childPageIDsByPhraseID) {
  const primaryPhrase = phraseByID.get(family.primaryPhraseID);
  const scenario = scenarioByID.get(family.scenarioID);
  const phrases = (family.phraseIDs ?? []).map((id) => phraseByID.get(id)).filter(Boolean);
  const variants = phrases.filter((phrase) => phrase.id !== primaryPhrase.id);
  const depth = phraseDepth(family, primaryPhrase);
  const pageID = canonicalPageID(family);
  const variantOptions = variants.map((phrase) => phraseOption(
    phrase,
    childPageIDsByPhraseID.get(phrase.id) ?? null,
    tintForScenario(family.scenarioID)
  ));

  const sections = [
    {
      id: "at-glance",
      title: "At a glance",
      body: atGlanceText(family, primaryPhrase),
    },
    {
      id: "breakdown",
      title: "Break it down",
      body: breakdownLeadIn(primaryPhrase),
      breakdown: breakdownTokens(primaryPhrase),
    },
    {
      id: "standard-way",
      title: "The standard way",
      body: standardText(family, primaryPhrase),
      phrases: [phraseOption(primaryPhrase, null, tintForScenario(family.scenarioID))],
    },
  ];

  const variationsSection = naturalVariationSection(family, variantOptions);
  if (variationsSection) {
    sections.push(variationsSection);
  }

  if (depth === "deep") {
    sections.push({
      id: "why-it-matters",
      title: "Why it matters",
      body: whyItMattersText(family),
    });
  }

  if (family.id === "social-how-are-you") {
    sections.push({
      id: "relationship-forms",
      title: "Relationship forms",
      body: "Swap bạn when the relationship is clear. These versions sound warmer with older or younger people because Vietnamese treats the relationship word as part of the sentence.",
      phrases: [
        manualPhraseOption("how-are-you-anh", "Anh khỏe không?", "How are you, older man?", "anh khweh khom", "blue"),
        manualPhraseOption("how-are-you-chi", "Chị khỏe không?", "How are you, older woman?", "chee khweh khom", "red"),
        manualPhraseOption("how-are-you-em", "Em khỏe không?", "How are you, younger person?", "em khweh khom", "green"),
      ],
    });
  }

  sections.push(
    {
      id: "when-to-use",
      title: "When to use it",
      body: usageText(family, primaryPhrase),
    },
    {
      id: "watch-out",
      title: "Watch out",
      body: watchOutText(family, primaryPhrase),
    },
    {
      id: "local-tip",
      title: "Local tip",
      body: localTipText(family, primaryPhrase),
    }
  );

  if (depth === "deep" && variantOptions.length === 0) {
    const nearbySection = nearbyPhraseSection(family, linkedPageIDs(sections));
    if (nearbySection) {
      sections.push(nearbySection);
    }
  }

  if (primaryPhrase.youMayHear) {
    sections.push({
      id: "you-may-hear",
      title: "You may hear",
      body: `A local may answer with: ${primaryPhrase.youMayHear}`,
    });
  }

  sections.push({
    id: "explore-next",
    title: "Explore next",
    body: "Use these next when the conversation moves one step forward.",
    phrases: exploreOptions(family, 8, linkedPageIDs(sections)),
  });

  return {
    id: pageID,
    familyID: family.id,
    phraseID: primaryPhrase.id,
    tierRole: "tier1",
    depth,
    title: primaryPhrase.targetText,
    englishTitle: primaryPhrase.englishText,
    pronunciation: primaryPhrase.pronunciation,
    summary: variantOptions.length > 0
      ? `Different ways to say "${primaryPhrase.englishText}" in Vietnam, with the safe phrase, useful variants, and nearby next steps.`
      : `Different ways to say "${primaryPhrase.englishText}" in Vietnam, with the safe phrase, reusable pieces, and nearby next steps.`,
    iconName: scenario?.symbolName ?? "text.bubble.fill",
    tintName: tintForScenario(family.scenarioID),
    categoryIDs: categoryIDsForPage(pageID, family),
    audioKey: authoredPhraseAudioKey(primaryPhrase.targetText, primaryPhrase.audioKey),
    sections: withSectionPresentations(sections),
    examples: [phraseOption(primaryPhrase, null, tintForScenario(family.scenarioID))],
  };
}

function removeGeneratedSources() {
  fs.rmSync(sourceRoot, { recursive: true, force: true });
  fs.mkdirSync(sourceRoot, { recursive: true });
}

function collectAudioAudit(pages) {
  const required = [];
  const missing = [];
  const seen = new Set();

  function addAudio(ref) {
    if (!ref.audioKey) {
      const record = { ...ref, resolved: false };
      required.push(record);
      missing.push(record);
      return;
    }

    const key = `${ref.audioKey}\u0000${ref.text}`;
    if (seen.has(key)) return;
    seen.add(key);
    const entry = audioManifest[ref.audioKey];
    const resolved = Boolean(entry && normalizeAudioText(entry.text) === normalizeAudioText(ref.text));
    const record = { ...ref, resolved };
    required.push(record);
    if (!resolved) missing.push(record);
  }

  for (const page of pages) {
    addAudio({ pageID: page.id, sectionID: "hero", kind: "hero", audioKey: page.audioKey, text: page.title });
    for (const section of page.sections ?? []) {
      for (const phrase of section.phrases ?? []) {
        addAudio({ pageID: page.id, sectionID: section.id, kind: "phrase", audioKey: phrase.audioKey, text: phrase.vietnamese });
      }
      for (const token of section.breakdown ?? []) {
        addAudio({ pageID: page.id, sectionID: section.id, kind: "breakdown", audioKey: token.audioKey, text: token.vietnamese });
      }
    }
  }

  return { required, missing };
}

function main() {
  removeGeneratedSources();

  const starterFamilies = catalog.families.filter((family) => {
    const primaryPhrase = phraseByID.get(family.primaryPhraseID);
    return family.accessTier === "starter" && primaryPhrase?.variantRole === "say-first";
  });

  const childPageIDsByPhraseID = new Map();
  for (const family of starterFamilies) {
    for (const phraseID of family.phraseIDs ?? []) {
      const phrase = phraseByID.get(phraseID);
      if (phrase && phrase.variantRole !== "say-first") {
        childPageIDsByPhraseID.set(phrase.id, `viet-phrase-${phrase.id}`);
      }
    }
  }

  const pages = [];
  const childPages = [];
  const inventory = [];

  for (const family of starterFamilies) {
    const primaryPhrase = phraseByID.get(family.primaryPhraseID);
    const pageID = canonicalPageID(family);

    if (pageID === rootPageID) {
      inventory.push({ familyID: family.id, pageID, coverage: "root", title: primaryPhrase.targetText });
      continue;
    }

    const page = pageForFamily(family, childPageIDsByPhraseID);
    const coverage = manuallyAuthoredPageIDs.has(page.id) ? "manual-swift" : "authored-resource";
    inventory.push({ familyID: family.id, pageID: page.id, coverage, title: page.title });

    const scenarioDir = path.join(sourceRoot, family.scenarioID);
    fs.mkdirSync(scenarioDir, { recursive: true });
    fs.writeFileSync(path.join(scenarioDir, `${family.id}.json`), `${JSON.stringify(page, null, 2)}\n`);

    if (!manuallyAuthoredPageIDs.has(page.id)) {
      pages.push(page);
    }

    for (const phraseID of family.phraseIDs ?? []) {
      const phrase = phraseByID.get(phraseID);
      if (!phrase || phrase.variantRole === "say-first") continue;
      const childPage = childPageForVariant(family, phrase, primaryPhrase);
      childPages.push(childPage);
      fs.writeFileSync(path.join(scenarioDir, `${family.id}--${phrase.id}.json`), `${JSON.stringify(childPage, null, 2)}\n`);
    }
  }

  fs.writeFileSync(path.join(sourceRoot, "_tier-one-index.json"), `${JSON.stringify({
    generatedAt: new Date().toISOString(),
    source: path.relative(sourceRoot, catalogPath),
    tierOneFamilyCount: starterFamilies.length,
    resourceMainPageCount: pages.length,
    childPageCount: childPages.length,
    inventory,
  }, null, 2)}\n`);

  const allPages = [...pages, ...childPages];
  const audioAudit = collectAudioAudit(allPages);
  const bundle = {
    metadata: {
      source: path.relative(root, sourceRoot),
      tierOneFamilyCount: starterFamilies.length,
      resourceMainPageCount: pages.length,
      childPageCount: childPages.length,
      generatedAt: new Date().toISOString(),
    },
    pages: allPages,
  };

  fs.writeFileSync(outputPath, `${JSON.stringify(bundle, null, 2)}\n`);
  fs.writeFileSync(auditPath, `${JSON.stringify({
    metadata: {
      generatedAt: bundle.metadata.generatedAt,
      tierOneFamilyCount: starterFamilies.length,
      requiredAudioCount: audioAudit.required.length,
      missingAudioCount: audioAudit.missing.length,
    },
    required: audioAudit.required,
    missing: audioAudit.missing,
  }, null, 2)}\n`);

  console.log(`Tier 1 families: ${starterFamilies.length}`);
  console.log(`Authored resource main pages: ${pages.length}`);
  console.log(`Child pages: ${childPages.length}`);
  console.log(`Missing assigned audio: ${audioAudit.missing.length}`);
  console.log(`Wrote ${path.relative(process.cwd(), outputPath)}`);
}

main();
