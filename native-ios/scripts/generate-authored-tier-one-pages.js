#!/usr/bin/env node

const crypto = require("crypto");
const { execFileSync } = require("child_process");
const fs = require("fs");
const path = require("path");
const {
  applyReviewedBreakdownOverride,
  loadBreakdownAuditLedger,
  renderBreakdownAuditExport,
  validateBreakdownAuditCoverage,
} = require("./lib/viet-breakdown-audit");

const root = path.resolve(__dirname, "..");
const familyRoot = path.resolve(root, "..");
const catalogPath = path.join(root, "Resources", "viet-phrase-catalog.json");
const audioManifestPath = path.join(root, "Resources", "viet-audio-manifest.json");
const outputPath = path.join(root, "Resources", "viet-authored-listing-pages.json");
const auditPath = path.join(root, "Resources", "viet-authored-audio-audit.json");
const canonicalPagesRoot = path.join(familyRoot, "content-draft", "viet", "canonical-pages");
const sourceRoot = path.join(canonicalPagesRoot, "tier-one");
const catalogPromotedSourceRoot = path.join(canonicalPagesRoot, "catalog-promoted");
const cityLibraryPath = path.join(familyRoot, "content-draft", "viet", "city-library", "v1.json");
const editorialSupportRoot = path.join(familyRoot, "content-draft", "viet", "editorial-model-support", "TASK-VIET-EDITORIAL-MODEL-SUPPORT-001");
const editorialSupportManifestPath = path.join(editorialSupportRoot, "manifest.json");
const catalogPromotedTaskID = "TASK-VIET-2000-FULL-LISTING-PAGES-001";
const editorialPilotImportScriptPath = path.join(root, "scripts", "import-viet-editorial-pilot.js");
const breakdownAuditExportPath = path.join(familyRoot, "content-draft", "viet", "breakdown-audit", "audit", "rendered-breakdown-audit.json");

const catalog = JSON.parse(fs.readFileSync(catalogPath, "utf8"));
const audioManifest = JSON.parse(fs.readFileSync(audioManifestPath, "utf8"));
const breakdownAuditLedger = loadBreakdownAuditLedger({ repoRoot: familyRoot });

const phraseByID = new Map(catalog.phrases.map((phrase) => [phrase.id, phrase]));
const familyByID = new Map(catalog.families.map((family) => [family.id, family]));
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
  "v900-tran-where-can-i-buy-a-ticket": "viet-phrase-v500-sigh-acti-where-can-i-buy-tickets",
};

const manuallyAuthoredPageIDs = new Set();

const rootPageID = "viet-polite-hello";

const pageCategoryOverrides = {
  "viet-polite-hello": ["greetings", "polite-basics"],
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
  "repair-slower": {
    summary: "Ask someone to slow down without making the exchange feel tense.",
    atGlance: "Use Nói chậm chút được không? when Vietnamese is coming too quickly and repeating the same speed will not help. It keeps the exchange cooperative while asking for a slower second pass.",
    standard: "Say Nói chậm chút được không? once, then pause. Watch for a slower repeat, a gesture toward the object, or a move to writing on paper or a phone.",
    when: "Use this at counters, rides, hotel desks, markets, or anywhere the answer matters but the speed is too fast. Ask early, while the moment still feels friendly.",
    why: "A slower repeat is often more useful than another full-speed answer. This phrase gives the other person a clear repair path: slow down, point, write, or show the detail.",
    watch: "Tone matters here. Curious and calm sounds like a request; sharp or repeated too many times can sound like a challenge.",
    tip: "If the slower repeat still misses, point, write, or show the exact word. The goal is clarity, not winning the spoken exchange.",
    travelerInsight: "The reply may come as slower Vietnamese, one important word, a pointed explanation, or writing. If speech still does not land, move quickly to showing the word or number on your phone.",
    variation: "These versions change the pressure of the request. Pick the softer one for service counters and the shorter one when the person already understands what you need.",
    exploreNext: "Use these when slower speech is still not enough and you need writing, meaning, repetition, or English help.",
  },
  "money-how-much": {
    summary: "Use this at markets, seafood trays, taxis, and any cash moment where the price needs to be visible before you commit.",
    atGlance: "Cái này bao nhiêu? is the pointing phrase for one visible thing: a mango, shirt, coffee, seafood tray, menu photo, or ride add-on. The phrase is small, but it protects the moment before money gets awkward.",
    standard: "Point first, say Cái này bao nhiêu?, then wait for the number to be spoken, typed, or shown on a calculator. Keep the item visible until the price is clear.",
    when: "Markets, snack stalls, small shops, beach seafood, laundry counters, and informal rides are where this earns its place. For several items, move to a total-price phrase before paying.",
    why: "The useful part is timing. Ask before the bag is packed, the plate is weighed, or the ride has started, then repeat or show the number back so both sides see the same price.",
    watch: "Confirm the final price before handing over cash or card, especially when several items, bags, or add-ons are involved.",
    tip: "If the answer comes too fast, hand over your phone calculator or point to theirs. Numbers are easier to trust when both people can see them.",
    travelerInsight: "The answer may be spoken fast, typed into a phone, shown on a calculator, or answered with a gesture. If the number matters, ask them to type it.",
    variation: "Use these when the price question needs a softer tone, a total, or a clearer object. The pointing still does most of the work.",
    youMayHear: "A vendor may answer with a fast number, a typed amount, or a short cash-only note. Pause until the amount is visible before you pay.",
    exploreNext: "These are the next phrases when the price turns into a total, a bargain, a cash/card question, or a number you need repeated.",
  },
  "transport-cash": {
    summary: "Use this near the end of a ride when the amount is already clear and the driver needs to know you are paying in cash.",
    atGlance: "Say Tôi trả bằng tiền mặt when the ride is turning into a payment moment. It belongs with fare, meter, change, card, and receipt questions, after the route is settled.",
    standard: "Use Tôi trả bằng tiền mặt after the fare is visible or agreed. Say it once, keep the cash or ride screen visible, then wait for a nod, a number, or a payment instruction.",
    when: "Use it when the ride is ending, the fare is settled, or the driver asks how you are paying. If the price is not clear yet, ask the fare first.",
    why: "Cash can be the cleanest way to finish a ride, but only after the amount is understood. This line sets the payment method before money changes hands.",
    watch: "Do not lead with a large bill unless the amount is clear. Let the fare be visible first, then hand over cash.",
    tip: "If the reply is fast, point to the meter, app price, calculator, or bill. A visible number is easier than repeating the phrase louder.",
    travelerInsight: "The next exchange is usually about amount, meter, card, receipt, or change. Keep the payment question narrow so the driver does not think you are changing the route.",
    exploreNext: "Use these when the cash line turns into a fare, meter, card, receipt, or change question.",
    teachingPhraseFamilyIDs: ["transport-fare", "transport-meter", "service-card"],
    nearbyPhraseFamilyIDs: ["transport-fare", "transport-meter", "service-card", "service-receipt"],
    explorePhraseFamilyIDs: ["transport-fare", "transport-meter", "service-card", "service-receipt", "money-small-bills"],
  },
  "repair-write-down": {
    summary: "Written text often rescues numbers, names, room numbers, and addresses faster than more speech.",
    atGlance: "Written text often rescues numbers, names, room numbers, and addresses faster than more speech. Use this when you need the other person to give you something you can read, save, or show again.",
    standard: "Viết xuống giúp tôi is the clearest version to start with when you need someone to write it down. It keeps the request polite and specific without needing to explain what you missed.",
    when: "Use it for hotel addresses, pickup points, prices, room numbers, names, or any detail you need to keep after the conversation ends.",
    watch: "Frame it as a cooperative request. A calm tone keeps the other person with you, especially if they already repeated themselves once.",
    tip: "Hand over your phone with a blank note open if paper is not nearby. The phrase plus the blank screen usually makes the request obvious.",
  },
  "v500-sigh-acti-i-have-a-tour-booking": {
    summary: "Use this when staff need to find an existing tour reservation, not sell you a new ticket.",
    atGlance: "Use this at a tour desk, pier, hotel lobby, or attraction entrance when you already booked and need staff to find your reservation. Show the booking name, QR code, or confirmation screen while you say it.",
    standard: "Start with Tôi có đặt tour when staff need to find an existing reservation. Tour is widely understood in travel settings, and đặt keeps the meaning on a booking or reservation rather than a casual plan.",
    when: "Use it before a tour starts, when checking in with a guide, or when a desk asks whether you already booked. Follow with the booking name if they look uncertain.",
    why: "Tour check-ins move quickly because staff are usually matching names, times, and group lists. This phrase tells them you are already in the system, so the next useful answer is likely a meeting point, guide name, or confirmation request.",
    watch: "Pair the phrase with the voucher or booking code when the place is busy so staff can match the right tour quickly.",
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
    atGlance: "Use this in markets or flexible-price shops, not at fixed-price counters. Giảm giá chút được không? asks for a small discount without using the peer-like bạn, so it keeps the bargain about the price instead of the relationship.",
    standard: "Giảm giá chút được không? is the cleaner discount question here. It keeps the ask light, includes chút for 'a little,' and gives the seller room to say yes, no, or counteroffer without losing face.",
    when: "Use it after you know the price and still want to buy if the seller can lower it a little. It works best when you are holding or pointing at one item, not while asking about a whole shelf.",
    why: "Price talk is partly social in markets. A small, friendly ask sounds better than a hard demand because it lets the seller protect the mood while still changing the number.",
    watch: "Keep your tone friendly. In Vietnam, bargaining can be playful in markets but awkward in fixed-price stores.",
    tip: "Point to the item, smile, and pause. The pause gives the seller room to answer without pressure.",
  },
  "money-lower-price": {
    summary: "Use this short market phrase only where bargaining is normal.",
    atGlance: "Bớt chút được không? is the compact local-feeling way to ask for a little lower price. It is useful in markets, informal stalls, or flexible-price moments where the seller expects some back-and-forth.",
    standard: "Bớt chút được không? literally asks whether they can reduce it a little. It is shorter and more natural than a full textbook sentence, and chút keeps the request modest instead of confrontational.",
    when: "Use it after hearing the price, while still holding or pointing at the item. It is best for one specific item, one ride price, or one quoted number you want softened.",
    why: "The phrase asks for a small adjustment, not a fight over value. Sellers can answer with a smaller number, a smile, or a firm final price while the exchange stays friendly.",
    watch: "Use it where prices are flexible, such as markets or informal stalls. At fixed-price counters, confirm the posted price instead.",
    tip: "If the answer is a number, ask them to type it on a calculator so you do not mishear the final price.",
  },
  "v500-heal-phar-i-feel-dizzy": {
    summary: "Use this when dizziness is the symptom you need help for.",
    atGlance: "Use this at a pharmacy, clinic, hotel desk, or with a guide when you feel light-headed or dizzy. Keep it direct so the other person knows this is a health issue, not small talk.",
    standard: "Tôi cảm thấy chóng mặt is the safer complete sentence. It says 'I feel dizzy' clearly and gives the helper a symptom they can act on.",
    when: "Use it before asking for medicine, a place to sit, a clinic, or help contacting someone.",
    watch: "Keep severe dizziness direct, especially with chest pain, fainting, or trouble breathing. Move to an emergency phrase when the situation needs urgent help.",
    tip: "Point to yourself, sit if you need to, and show any medicine or condition note you carry.",
  },
  "social-how-are-you": {
    summary: "Use this after a greeting with someone close enough for light conversation.",
    atGlance: "Bạn khỏe không? is friendly, but it is not the only way to check in. With older people or service staff, Vietnamese often sounds warmer when you swap bạn for anh, chị, cô, chú, ông, or bà.",
    standard: "Bạn khỏe không? works best with peers, friends, classmates, or someone whose age relationship feels close to yours.",
    when: "Use it after Xin chào or Chào bạn, not as the very first sentence to a stranger in a rushed service moment.",
    watch: "With an older man or woman, Anh khỏe không? or Chị khỏe không? can sound more natural than the all-purpose bạn.",
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
    watch: "Keep quick service phrases clear, polite, and short. A calm short sentence usually works better than a long one said nervously.",
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
    watch: "Keep urgent medical needs clear and direct. A short sentence gives helpers something they can act on quickly.",
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
    watch: "Show the screen first and keep control of your phone unless the situation feels trustworthy.",
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
    why: "Everyday service phrases keep quick errands smooth without needing a full conversation.",
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
  "không": "no / not / asks yes or no",
  "cho": "give / let",
  "tôi": "I / me",
  "mình": "I / me",
  "anh": "older man",
  "chị": "older woman",
  "em": "younger person",
  "bạn": "you / friend",
  "giúp": "help",
  "với": "please / with",
  "hãy": "please / soft command",
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
  "hiểu": "understand",
  "cái": "item / classifier",
  "quận": "district",
  "năm": "five",
  "phút": "minutes",
  "bằng": "by / with",
  "bật": "turn on",
  "đồng": "dong / currency",
  "hồ": "meter / clock",
  "nghĩ": "think",
  "chúng": "we",
  "ta": "part of chúng ta",
  "bị": "got / passive marker",
  "nóng": "hot",
  "quá": "too / very",
  "chạy": "run / work",
  "thêm": "more / add",
  "khăn": "towel",
  "giữ": "keep / hold",
  "bạc": "sweet milk",
  "xỉu": "coffee style",
  "mang": "bring / carry",
  "tính": "calculate / bill",
  "người": "person",
  "phần": "portion",
  "tô": "bowl",
  "rau": "greens / herbs",
  "muỗng": "spoon",
  "đũa": "chopsticks",
  "gói": "wrap / pack",
  "ứng": "react / allergy",
  "ký": "kilo",
  "mắc": "expensive",
  "cuối": "final / last",
  "khác": "different / another",
  "atm": "ATM",
  "thế": "like that / way",
  "nào": "which / how",
  "mất": "lose / takes",
  "chưa": "not yet",
  "tiêu": "digest / diarrhea word",
  "chảy": "flow / diarrhea word",
  "quên": "forget",
  "gọi": "call",
  "quản": "manage",
  "sáng": "morning",
  "chỉ": "only / point",
  "giấy": "paper",
  "giấy vệ sinh": "toilet paper",
  "xà": "soap word",
  "rửa": "wash",
  "tay": "hand",
  "an": "public security word",
  "khẩn": "urgent",
  "từ": "from / word",
  "mỹ": "the United States",
  "lần": "time / occasion",
  "thích": "like",
  "nam": "Vietnam word / south",
  "hết": "out / finished",
  "ngon": "delicious",
  "thời": "time / weather word",
  "tiết": "weather word",
  "chụp": "take a photo",
  "hình": "photo",
  "gặp": "meet",
  "chai": "bottle",
  "quẹt": "swipe",
  "thẻ": "card",
  "khóa": "lock",
  "đã": "already / past marker",
  "đỡ": "help / ease",
  "bây": "now word",
  "đợi": "wait",
  "hàng": "item / goods",
  "esim": "eSIM",
  "thể": "can / able",
  "chạm": "touch",
  "vào": "into / touch target",
  "vừa": "just / recently",
  "tiếng": "language / sound",
  "ngay": "right away",
  "tài": "driver",
  "xế": "driver",
  "được": "can / okay",
}));

function normalizeAudioText(value) {
  return value.normalize("NFC").replace(/\s+/g, " ").trim().toLowerCase();
}

function accentlessWordTokens(value) {
  return Array.from(String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[đĐ]/g, "d")
    .toLowerCase()
    .matchAll(/[a-z0-9]+/g), (match) => match[0]);
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
  return exactAudioKey(text, null);
}

function hasExactAudio(text, audioKey) {
  if (!audioKey) return false;
  const entry = audioManifest[audioKey];
  return Boolean(entry && normalizeAudioText(entry.text) === normalizeAudioText(text));
}

function speakerSymbolName(text, audioKey) {
  return hasExactAudio(text, audioKey) ? "speaker.wave.2.fill" : "text.bubble.fill";
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

function canonicalDetailPageID(pageID) {
  return pageID ?? null;
}

function phraseOption(phrase, detailPageID = null, tintName = null) {
  const audioKey = authoredPhraseAudioKey(phrase.targetText, phrase.audioKey);
  return {
    id: phrase.id,
    vietnamese: phrase.targetText,
    english: phrase.englishText,
    pronunciation: phrase.pronunciation,
    symbolName: speakerSymbolName(phrase.targetText, audioKey),
    tintName: tintName ?? tintForScenario(phrase.scenarioID),
    detailPageID: canonicalDetailPageID(detailPageID),
    audioKey,
  };
}

function manualPhraseOption(id, vietnamese, english, pronunciation, tintName, detailPageID = null) {
  const audioKey = authoredPhraseAudioKey(vietnamese, null);
  return {
    id,
    vietnamese,
    english,
    pronunciation,
    symbolName: speakerSymbolName(vietnamese, audioKey),
    tintName,
    detailPageID: canonicalDetailPageID(detailPageID),
    audioKey,
  };
}

function catalogPhraseOption(phraseID, detailPageID = null, tintName = null) {
  const phrase = phraseByID.get(phraseID);
  if (!phrase) {
    throw new Error(`Missing catalog phrase ${phraseID}`);
  }

  return phraseOption(phrase, detailPageID, tintName ?? tintForScenario(phrase.scenarioID));
}

function scenarioCopy(scenarioID) {
  return scenarioGuidance[scenarioID] ?? {
    moment: "the travel moment in front of you",
    why: "The phrase says the practical need plainly before the conversation gets complicated.",
    tip: "Say the phrase first, then point, show, or gesture to the detail that matters.",
    watch: "Keep the sentence short and clear. The right pointed detail usually helps more than extra words.",
  };
}

function phraseDepth(family, primaryPhrase) {
  return "deep";
}

function sentence(text) {
  if (!text) return "";
  return /[.!?][)"”']*$/.test(text.trim()) ? text.trim() : `${text.trim()}.`;
}

function cleanFinalPunctuation(text) {
  return String(text ?? "")
    .replace(/\?\./g, "?")
    .replace(/!\./g, "!")
    .replace(/\.\./g, ".")
    .replace(/\?([)”"])\./g, "?$1")
    .replace(/!([)”"])\./g, "!$1")
    .replace(/\s+/g, " ")
    .trim();
}

function weakSummary(summary) {
  return /when you need|need to explain that|use this when you need/i.test(summary ?? "");
}

function travelerFacingSummary(phrase) {
  const english = String(phrase.englishText ?? "").trim();
  const target = String(phrase.targetText ?? "").trim();
  if (/^(hello|hi|goodbye|thank|thanks|sorry|excuse me|yes|no|okay|it.?s okay)\b/i.test(english)) {
    return cleanFinalPunctuation(`${target} is a common way to say “${english}” in Vietnamese.`);
  }
  return cleanFinalPunctuation(`${target} means “${english}”.`);
}

function instructionLikeSentence(text) {
  return /^(use|ask|say|add|show|point|keep)\b/i.test((text ?? "").trim());
}

function cleanEnglishIntent(englishText) {
  return englishText
    .replace(/[’‘]/g, "'")
    .replace(/[?!]+$/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

function contextAsSituation(text, fallback) {
  const source = (text || fallback || "").trim();
  if (!source) return "";

  return sentence(source
    .replace(/^Use this when\s+/i, "Reach for it when ")
    .replace(/^Use this at\s+/i, "This is for ")
    .replace(/^Use this in\s+/i, "This is for ")
    .replace(/^Use this before\s+/i, "This comes before ")
    .replace(/^Use this if\s+/i, "This helps if ")
    .replace(/^Use this to\s+/i, "This helps you ")
    .replace(/^Ask this when\s+/i, "Ask when "));
}

function intentTeaching(primaryPhrase) {
  const english = cleanEnglishIntent(primaryPhrase.englishText).toLowerCase();

  if (/^(where|where can|where do|where is|where are)\b/.test(english) || /\bnearest\b/.test(english)) {
    return {
      moment: "finding a place, counter, pickup point, or service without explaining the whole situation",
      strategy: "turning the problem into something the other person can point to, type, or mark on a map",
      response: "a point, short direction, nearby option, or counter name",
      followUp: "If the answer is longer than a point or nearby stop, ask them to show it on your phone.",
    };
  }

  if (/^(how much|what.*price|.*fare|.*cost|.*ticket.*price|.*bao nhiêu)/.test(english) || /\bprice\b|\bfare\b|\batm\b/.test(english)) {
    return {
      moment: "getting a number clear before money, tickets, rides, or quantities become awkward",
      strategy: "making the price or amount the center of the exchange",
      response: "a number, typed amount, calculator screen, or direct yes/no about payment",
      followUp: "Repeat or show the number before paying if the amount matters.",
    };
  }

  if (/^(can i|could i|may i|do you have|do you sell|is there|are there)\b/.test(english)) {
    return {
      moment: "asking for permission or availability while keeping the interaction soft",
      strategy: "letting the other person answer yes, no, or point you to the right option",
      response: "a yes/no answer, a gesture toward the item, or a short alternative",
      followUp: "If they point somewhere else, follow the gesture first and ask again only if the next step is unclear.",
    };
  }

  if (/^(i need|i want|i'd like|i would like|please|a table|one |more )\b/.test(english)) {
    return {
      moment: "making a request where the other person can help right away",
      strategy: "putting the need first and leaving room for the helper to confirm the detail",
      response: "a confirmation, a handoff, a price, or a follow-up question",
      followUp: "Pause after the phrase so the person can confirm before you add more words.",
    };
  }

  if (/^(today|tomorrow|morning|what time|goodbye|yes|thank you|it'?s okay|how are you|i like|i'm from|i am from|this is my first|the food|the weather)\b/.test(english)) {
    return {
      moment: "keeping a short social or scheduling exchange warm and easy to answer",
      strategy: "using a short friendly phrase that invites a clear reply",
      response: "a short reply, a smile, a time, or a light follow-up question",
      followUp: "Pause naturally after the phrase; these exchanges work best when the reply has room to arrive.",
    };
  }

  if (/^i have\b.*\b(booking|reservation|tour)\b/.test(english)) {
    return {
      moment: "helping staff find a booking, ticket, room, or tour record quickly",
      strategy: "putting the booking first so staff can look it up before you explain more",
      response: "a name check, booking-code request, counter direction, or short wait",
      followUp: "Keep the booking name, code, room number, or ticket visible until staff find the record.",
    };
  }

  if (/^i have\b.*\b(headache|stomach|stomachache|diarrhea|allergy|pain|injury)\b/.test(english) || /^i am injured\b/.test(english)) {
    return {
      moment: "explaining a symptom clearly enough for pharmacy, clinic, or hotel staff to help",
      strategy: "naming the symptom first before you add timing or background",
      response: "a question about symptoms, medicine, a doctor, or where the pain is",
      followUp: "Point to the affected area or show the medicine name if that makes the need clearer.",
    };
  }

  if (/^(here is|this is my)\b.*\b(passport|visa|baggage tag)\b/.test(english)) {
    return {
      moment: "showing the document staff need at the next checkpoint",
      strategy: "pairing the document with a short phrase so staff know what you are handing over",
      response: "a quick check, a stamp, a counter direction, or a request for one more document",
      followUp: "Keep the document open to the photo page or relevant line while staff check it.",
    };
  }

  if (/^this is an emergency\b/.test(english)) {
    return {
      moment: "making urgency clear before the details get complicated",
      strategy: "naming the emergency first so helpers switch into action mode",
      response: "a question about what happened, a call for help, or an instruction to wait nearby",
      followUp: "After they understand it is urgent, add the location, person, or injury detail they ask for.",
    };
  }

  if (/^(i lost|i left)\b/.test(english) || /\bmissing\b|\bbehind\b|\bkept my card\b/.test(english)) {
    return {
      moment: "recovering a lost item, card, document, or bag before the trail goes cold",
      strategy: "saying what went missing before you add where or when it happened",
      response: "a question about the last place, a room or ride check, or a staff handoff",
      followUp: "Have the receipt, room number, ride detail, or last location ready if they ask.",
    };
  }

  if (/\b(bag did not arrive|baggage did not arrive|bag is missing|baggage is missing)\b/.test(english)) {
    return {
      moment: "getting airport staff to start a baggage check instead of sending you onward",
      strategy: "saying the bag problem first so staff know to check the carousel or baggage desk",
      response: "a baggage-tag request, counter direction, form, or update on where to wait",
      followUp: "Keep the baggage tag, flight number, and pickup carousel in view while staff check.",
    };
  }

  if (/\b(map|phone|sim|wi-?fi|wifi|battery|app|screen)\b.*\b(not working|broken)\b/.test(english) || /\bnot working\b.*\b(map|phone|sim|wi-?fi|wifi|battery|app|screen)\b/.test(english)) {
    return {
      moment: "getting help with a phone, map, signal, battery, or app problem",
      strategy: "showing the screen issue before adding a long explanation",
      response: "a look at the screen, a reset suggestion, or directions to a SIM or Wi-Fi help spot",
      followUp: "Keep the phone open to the error, map, or settings page while you ask.",
    };
  }

  if (/\b(air conditioner|door|lock|room)\b.*\b(not working|does not|isn't|broken|hot)\b/.test(english) || /\b(the room is hot|the door does not lock)\b/.test(english)) {
    return {
      moment: "getting hotel staff to understand the room issue quickly",
      strategy: "naming the room problem first so staff can send help or offer a fix",
      response: "a room-number check, maintenance visit, new key, or room-change option",
      followUp: "Have the room number ready and show the item if staff need to inspect it.",
    };
  }

  if (/\bnot working\b|\bbroken\b/.test(english) || /^(my .*not|my .*is not|the .*does not|the .*isn't)\b/.test(english)) {
    return {
      moment: "showing a broken room item, phone issue, card problem, or app problem clearly",
      strategy: "naming what is not working before you explain more",
      response: "a check, a replacement offer, a room visit, or a request to show the issue",
      followUp: "Show the screen, room item, or broken part if seeing it will save time.",
    };
  }

  if (/^(i cannot|i can't)\b/.test(english)) {
    return {
      moment: "telling someone your body or movement limit before they ask you to continue",
      strategy: "stating the limit first so helpers do not move too fast",
      response: "a safety check, a question about pain, or help moving you to a safer spot",
      followUp: "Point to what hurts or where you need to stay still if words are not enough.",
    };
  }

  if (/^(i have|here is|this is|i left|i lost|my .*not|my .*is not|the .*does not|the .*isn't|i cannot|i can't)\b/.test(english) || /\bmissing\b|\bnot working\b|\bbroken\b|\bkept my card\b|\bbehind\b/.test(english)) {
    return {
      moment: "showing a document, reporting a problem, or explaining what went wrong",
      strategy: "starting with the main problem before adding background",
      response: "a quick check, a staff handoff, or a next instruction",
      followUp: "Show the relevant screen, paper, room number, or location only if it helps them act.",
    };
  }

  if (/^(no|not|i am vegetarian|i'm vegetarian|i am allergic|i'm allergic|do not)\b/.test(english) || /\ballergic\b|\bvegetarian\b|\bnot spicy\b|\bno sugar\b/.test(english)) {
    return {
      moment: "setting a food, safety, comfort, or personal boundary clearly",
      strategy: "stating the limit before the order or interaction moves too far",
      response: "a confirmation, a substitute, or a question about what is allowed",
      followUp: "Confirm visually when the detail affects safety, health, or the final order.",
    };
  }

  if (/^(excuse me|sorry|can you speak|do you speak|i don't understand|i do not understand|what does that mean)\b/.test(english)) {
    return {
      moment: "keeping a confusing exchange cooperative and easy to repair",
      strategy: "asking for one clear help action before adding more words",
      response: "a slower repeat, a pointed explanation, or a switch to writing",
      followUp: "If the first reply is still unclear, move to showing, writing, or pointing.",
    };
  }

  return {
    moment: "turning the travel need into one clear sentence",
    strategy: "making the next practical step easy for the other person to choose",
    response: "a clear reply, a pointed detail, or a simple follow-up",
    followUp: "Use the related phrases below if the exchange moves one step further.",
  };
}

function intentFragmentForCue(intent) {
  return String(intent ?? "")
    .replace(/^["“]|["”]$/g, "")
    .replace(/[.?!]+$/g, "")
    .trim()
    .toLowerCase();
}

function phraseMomentLead(vietnamese, intent) {
  const title = cleanFinalPunctuation(vietnamese || "");
  const fragment = intentFragmentForCue(intent);
  if (!title) return "";

  if (/^(where|which)\b/.test(fragment)) {
    return `${title} keeps the direction question short.`;
  }
  if (/^(how much|what price|what time|when)\b/.test(fragment)) {
    return `${title} puts the practical detail first.`;
  }
  if (/^(can|could|do|does|is|are|may|should)\b/.test(fragment)) {
    return `${title} keeps the question easy to answer.`;
  }
  if (/^(please|help|call|write|show|take|bring|give|open|stop|wait|turn)\b/.test(fragment)) {
    return `${title} makes the request direct without adding extra explanation.`;
  }
  if (/^(i need|i have|i am|i'm|my|this|here is|there is|i lost|i left|i cannot|i can't)\b/.test(fragment)) {
    return `${title} names the need before the details start piling up.`;
  }
  if (/^(thank|sorry|excuse|hello|goodbye|yes|no)\b/.test(fragment)) {
    return `${title} keeps the social move simple and polite.`;
  }
  return `${title} keeps the travel moment short and clear.`;
}

function fullPhraseCue(vietnamese, fallbackCue) {
  const title = cleanFinalPunctuation(vietnamese || "");
  if (!title) return fallbackCue;
  if (/[?!]$/.test(title)) return "Use the full phrase before adding details.";
  return `Keep ${title} together as one sentence before adding details.`;
}

function responseSentence(response) {
  let clean = String(response ?? "").trim();
  if (!clean) return "";
  clean = clean.replace(/^a short reply,\s*/i, "");
  if (/confirmation, a handoff, a price, or follow-up question/i.test(clean)) return "";
  if (/confirmation, a handoff, a price, or a follow-up question/i.test(clean)) return "";
  if (/clear reply, a pointed detail, or a simple follow-up/i.test(clean)) return "";
  if (/^a short reply$/i.test(clean)) return "";
  return `The reply may be ${clean}.`;
}

function withoutDuplicateParts(parts) {
  const seen = new Set();
  return parts.filter((part) => {
    const text = String(part ?? "").trim();
    if (!text) return false;
    const key = text.toLowerCase();
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}

function atGlanceText(family, primaryPhrase) {
  const copy = scenarioCopy(family.scenarioID);
  const override = familyOverride(family);
  if (override.atGlance) return override.atGlance;

  const intent = cleanEnglishIntent(primaryPhrase.englishText);
  const situation = contextAsSituation(primaryPhrase.context, family.summary);
  const summaryCandidate = override.summary ?? (weakSummary(family.summary) ? "" : sentence(family.summary));
  const usefulSummary = primaryPhrase.context && instructionLikeSentence(summaryCandidate) ? "" : summaryCandidate;

  return [
    phraseMomentLead(primaryPhrase.targetText, intent),
    situation,
    usefulSummary,
  ].filter(Boolean).join(" ");
}

function contextCueText(family) {
  switch (family.scenarioID) {
    case "transport":
    case "directions-navigation":
      return "Keep the map, address, or destination visible while you speak so the reply points to the same place.";
    case "hotel-accommodation":
    case "time-dates-booking":
    case "sightseeing-activities":
      return "Keep the booking, ticket, room number, or time visible when the exact detail matters.";
    case "food-drink":
    case "shopping":
    case "local-services-everyday-tasks":
      return "Point to the actual item, menu line, size, or photo while you say it.";
    case "phone-internet-power":
      return "Show the phone screen or error message first so the problem is visible before you add more words.";
    case "airport-border-arrival":
      return "Keep your passport, visa, baggage tag, pickup message, or SIM details visible when staff need to match the phrase to a real item.";
    case "emergency-safety":
    case "health-pharmacy":
      return "Keep the affected area, passport copy, location, or helper contact visible if it helps the other person act.";
    case "problems-help":
      return "Keep a receipt, room number, ride detail, or last location visible when it helps staff trace the problem.";
    case "bathroom-personal-needs":
      return "Ask directly, then follow pointing or gestures; these moments usually need a quick practical answer.";
    case "polite-basics":
      return "Keep your voice calm and let the short phrase do the politeness work before you add another request.";
    case "social-small-talk":
      return "Use it after a greeting or shared moment, then leave space for a short friendly reply.";
    case "understanding-repair":
      return "If it is still unclear, show, write, or point to the exact word.";
    default:
      return "Keep the relevant place, object, or screen visible while you speak.";
  }
}

function standardText(family, primaryPhrase) {
  const override = familyOverride(family);
  if (override.standard) return override.standard;

  return [
    fullPhraseCue(primaryPhrase.targetText, contextCueText(family)),
    contextCueText(family),
  ].filter(Boolean).join(" ");
}

function usageText(family, primaryPhrase) {
  const copy = scenarioCopy(family.scenarioID);
  const override = familyOverride(family);
  if (override.when) return override.when;

  const teaching = intentTeaching(primaryPhrase);
  const situation = contextAsSituation(primaryPhrase.context, family.summary);
  const momentSentence = copy.moment.startsWith("moments when")
    ? `It fits ${copy.moment}, especially when the next step is ${teaching.response}.`
    : `It fits ${copy.moment}, especially when the next step is ${teaching.response}.`;

  return [
    situation,
    momentSentence,
    teaching.followUp.replace(/^Pause after the phrase so\b/i, "Pause so"),
  ].filter(Boolean).join(" ");
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

function whyItMattersText(family, primaryPhrase) {
  const override = familyOverride(family);
  if (override.why) return override.why;

  const teaching = intentTeaching(primaryPhrase);
  return [
    scenarioCopy(family.scenarioID).why,
    `For "${cleanEnglishIntent(primaryPhrase.englishText)}", ${primaryPhrase.targetText} makes the next step easier to answer.`,
    teaching.followUp.replace(/^Pause after the phrase so\b/i, "Pause so"),
  ].join(" ");
}

function travelerInsightText(family, primaryPhrase) {
  const override = familyOverride(family);
  if (override.travelerInsight) return override.travelerInsight;

  const teaching = intentTeaching(primaryPhrase);
  const scenario = scenarioByID.get(family.scenarioID);
  const categoryName = scenario?.title ?? "this situation";
  return [
    `Expect ${teaching.response} in ${categoryName}.`,
    `Say ${primaryPhrase.targetText} once, then watch for the reply.`,
    contextCueText(family),
  ].join(" ");
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
  "bac xiu",
  "bao lau",
  "bao nhieu",
  "bat dau",
  "bien nhan bao hiem",
  "bao cao y te",
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
  "con trong",
  "cua toi",
  "dia chi",
  "dia phuong",
  "dia diem",
  "dia diem cu",
  "dia diem moi",
  "dat tour",
  "da xay ra",
  "diem gap",
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
  "khan cap",
  "khong duong",
  "khong sao",
  "it cay",
  "khu don",
  "lam on",
  "lac duong",
  "may lanh",
  "mat khau",
  "mat hang",
  "mua sim",
  "giam gia",
  "giay ve sinh",
  "nha thuoc",
  "nha ve sinh",
  "nhan phong",
  "nhap canh",
  "noi lai",
  "nuoc suoi",
  "o dau",
  "di chuyen",
  "dung o day",
  "hoat dong",
  "kem chong nang",
  "khan giay",
  "khong an toan",
  "re phai",
  "re trai",
  "say xe",
  "the hanh ly",
  "tai xe",
  "the sim",
  "thi thuc",
  "chong mat",
  "cho mot qua",
  "thuc don",
  "dua tuoi",
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
  "truoc khi di ngu",
  "truong hop",
  "ung dung dich thuat",
  "viet xuong",
  "yen tinh",
  "tu tu",
  "xe cuu thuong",
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
  "con trong": "still available / open",
  "co": "have / yes",
  "co the": "can",
  "co ban": "do you sell",
  "khong": "not / no",
  "khong duong": "no sugar",
  "khong sao": "it is okay",
  "dau": "where / reassurance particle",
  "phai": "right / must",
  "dung": "correct",
  "sai": "wrong",
  "o": "at / in",
  "o dau": "where?",
  "den": "to / arrive",
  "di": "go",
  "di bo": "walk",
  "di chuyen": "move",
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
  "giay ve sinh": "toilet paper",
  "bao nhieu": "how much",
  "bao lau": "how long",
  "bac xiu": "sweet milk coffee",
  "bao cao y te": "medical report",
  "bat": "start",
  "bat dau": "begin / start",
  "bien nhan bao hiem": "receipt for insurance",
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
  "cho mot qua": "give me one",
  "cho toi": "can I have",
  "dua tuoi": "fresh coconut",
  "mot": "one",
  "hai": "two",
  "hãy": "please / soft command",
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
  "diem": "point",
  "diem gap": "meeting point",
  "duoc khong": "is it possible?",
  "giam": "reduce",
  "giam gia": "lower the price",
  "gan nhat": "nearest",
  "khach san": "hotel",
  "it cay": "less spicy",
  "khoe": "healthy / well",
  "khu don": "pickup area",
  "lac": "lost",
  "lac duong": "lost on the route",
  "lam on": "please",
  "may lanh": "air conditioning",
  "mat khau": "password",
  "mat hang": "item",
  "nha thuoc": "pharmacy",
  "nha ve sinh": "bathroom",
  "nhan phong": "check in",
  "nhap canh": "immigration",
  "noi lai": "say again",
  "nuoc suoi": "bottled water",
  "phong": "room",
  "phong yen tinh": "quiet room",
  "pass": "password",
  "re phai": "turn right",
  "re trai": "turn left",
  "an toan": "safe",
  "cuu thuong": "ambulance",
  "dung o day": "stop here",
  "hoat dong": "working",
  "kem chong nang": "sunscreen",
  "khan giay": "tissues",
  "khong an toan": "unsafe",
  "nhe": "soft polite ending",
  "nhé": "soft polite ending",
  "noi": "say / speak",
  "roi": "already / enough",
  "rồi": "already / enough",
  "say xe": "motion sickness",
  "thuc don": "menu",
  "thit bo": "beef",
  "thit ga": "chicken",
  "thit lon": "pork",
  "tieng anh": "English",
  "thoi": "only / just",
  "tai xe": "driver",
  "tra phong": "check out",
  "truoc khi di ngu": "before bed",
  "truong hop": "case / situation",
  "khan cap": "urgent / emergency",
  "thuong": "injury / medical help",
  "ung dung dich thuat": "translation app",
  "tu tu": "slowly",
  "wi fi": "Wi-Fi",
  "xe cuu thuong": "ambulance",
  "viet": "write",
  "viet xuong": "write down",
  "xuong": "down",
  "yen tinh": "quiet",
}));

const exactBreakdownPieces = new Map(Object.entries({
  "ban nay con trong": [
    { vietnamese: "Bàn", english: "table" },
    { vietnamese: "này", english: "this" },
    { vietnamese: "còn trống", english: "still available / open" },
  ],
  "co giay ve sinh khong": [
    { vietnamese: "Có ... không?", english: "do you have / is there?" },
    { vietnamese: "giấy vệ sinh", english: "toilet paper" },
  ],
  "cam on": [
    { vietnamese: "Cảm", english: "feel / receive" },
    { vietnamese: "ơn", english: "kindness / favor" },
  ],
  "xin loi": [
    { vietnamese: "Xin", english: "please / ask" },
    { vietnamese: "lỗi", english: "mistake / fault" },
  ],
  "tam biet": [
    { vietnamese: "Tạm", english: "for now" },
    { vietnamese: "biệt", english: "separate / goodbye" },
  ],
  "khong sao": [
    { vietnamese: "Không", english: "no / not" },
    { vietnamese: "sao", english: "problem / why" },
  ],
  "khong sao dau": [
    { vietnamese: "Không sao", english: "it is okay" },
    { vietnamese: "đâu", english: "adds reassurance" },
  ],
}));

const exactRawBreakdownMeanings = new Map(Object.entries({
  "bàn": "table",
  "bạn": "you",
  "chỉ": "only",
  "chị": "older woman / respectful female address",
  "nhận": "accept / receive",
  "mặt": "cash (in tiền mặt)",
  "cổng": "gate",
  "đổi": "change",
  "đợi": "wait",
  "còn trống": "still available / open",
  "này": "this",
  "có": "have / yes",
  "cô": "aunt-age woman / respectful female address",
  "tôi": "I / me",
  "tỏi": "garlic",
  "bơ": "butter",
  "bỏ": "leave out / remove",
  "không?": "not? / yes-no ending",
  "chưa": "not yet",
  "chùa": "pagoda",
  "vé": "ticket",
  "vệ": "hygiene",
  "giấy vệ sinh": "toilet paper",
}));

function fallbackBreakdownMeaning(vietnamese) {
  if (/^\d+$/.test(normalizedVietnameseKey(vietnamese))) return vietnamese;
  if (/^[A-ZĐ][\p{L}\p{M}'-]+(?:\s+[A-ZĐ][\p{L}\p{M}'-]+)*$/u.test(vietnamese)) {
    return "local name";
  }
  return "meaning to keep";
}

function breakdownMeaning(vietnamese) {
  const exact = vietnamese.normalize("NFC").trim().toLowerCase();
  const normalized = normalizedVietnameseKey(vietnamese);
  if (/^\d+$/.test(normalized)) return vietnamese;
  return exactRawBreakdownMeanings.get(exact) ?? glossary.get(exact) ?? breakdownMeanings.get(normalized) ?? fallbackBreakdownMeaning(vietnamese);
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
    ["không", "asks yes or no"],
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
    .map((chunk) => ({
      vietnamese: chunk,
      english: breakdownMeaning(chunk),
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
  const exactPieces = exactBreakdownPieces.get(normalizedVietnameseKey(normalizedTargetText));
  if (exactPieces) {
    return exactPieces;
  }

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
  if (phrase.targetText.split(/\s+/).filter(Boolean).length === 1) {
    return [{
      id: `${phrase.id}-full`,
      vietnamese: phrase.targetText,
      english: phrase.englishText,
      audioKey: authoredPhraseAudioKey(phrase.targetText, phrase.audioKey),
    }];
  }

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
    return "This pattern asks for a yes-or-no answer. Keep the main need together so the question feels natural.";
  }

  if (phrase.targetText.startsWith("Đây là")) {
    return "This pattern points to something first, then names it. It is useful when a document, item, or screen is already visible.";
  }

  return "Listen to each piece, then the whole phrase, so the rhythm feels connected instead of memorized word by word.";
}

function variantBody(variants) {
  return variants.length === 1
    ? "This form changes the tone or setting. Use it when the note under the phrase matches the moment."
    : "Each form changes the tone, setting, or next action. Choose the one that matches the person in front of you.";
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
    body: "These are the next phrases a traveler is likely to need when this moment keeps moving.",
    phrases: relatedOptions,
  };
}

function teachingPhraseOptions(family, sections, currentPageID, primaryPhrase, limit = 3) {
  const exclusions = linkedPageIDs(sections);
  if (currentPageID) {
    exclusions.add(currentPageID);
  }

  const overrideOptions = overrideFamilyOptions(family, "teachingPhraseFamilyIDs", limit, exclusions);
  if (overrideOptions.length > 0) {
    return overrideOptions;
  }

  const relatedOptions = exploreOptions(family, limit, exclusions);
  if (relatedOptions.length > 0) {
    return relatedOptions;
  }

  return [phraseOption(primaryPhrase, null, tintForScenario(family.scenarioID))];
}

function exploreNextPhraseOptions(family, sections, currentPageID, primaryPhrase, limit = 8) {
  const exclusions = linkedPageIDs(sections);
  if (currentPageID) {
    exclusions.add(currentPageID);
  }

  const overrideOptions = overrideFamilyOptions(family, "explorePhraseFamilyIDs", limit, exclusions);
  if (overrideOptions.length > 0) {
    return overrideOptions;
  }

  const excludedOptions = exploreOptions(family, limit, exclusions);
  if (excludedOptions.length > 0) {
    return excludedOptions;
  }

  const relaxedExclusions = new Set();
  if (currentPageID) {
    relaxedExclusions.add(currentPageID);
  }
  const relaxedOptions = exploreOptions(family, limit, relaxedExclusions);
  if (relaxedOptions.length > 0) {
    return relaxedOptions;
  }

  return [phraseOption(primaryPhrase, null, tintForScenario(family.scenarioID))];
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

function explicitFamilyOptions(familyIDs, limit = 8, excludingPageIDs = new Set()) {
  if (!Array.isArray(familyIDs) || familyIDs.length === 0) return [];

  const options = [];
  for (const familyID of familyIDs) {
    const candidate = familyByID.get(familyID);
    if (!candidate) {
      throw new Error(`Missing explicit family option ${familyID}`);
    }
    const pageID = canonicalPageID(candidate);
    if (excludingPageIDs.has(pageID)) continue;
    const phrase = phraseByID.get(candidate.primaryPhraseID);
    if (!phrase) {
      throw new Error(`Missing primary phrase ${candidate.primaryPhraseID} for explicit family option ${familyID}`);
    }
    options.push(phraseOption(phrase, pageID, tintForScenario(candidate.scenarioID)));
    if (options.length >= limit) break;
  }
  return options;
}

function overrideFamilyOptions(family, key, limit = 8, excludingPageIDs = new Set()) {
  const override = familyOverride(family);
  const currentPageID = canonicalPageID(family);
  // Family overrides are handwritten card choices. Preserve repeated cards across
  // sections when the page deliberately carries the same follow-up through a flow.
  void excludingPageIDs;
  return explicitFamilyOptions(override[key], limit, new Set([currentPageID]));
}

function xinChaoFlagshipPage(family, primaryPhrase) {
  const pageID = canonicalPageID(family);

  return {
    id: pageID,
    familyID: family.id,
    phraseID: primaryPhrase.id,
    tierRole: "tier1",
    depth: "deep",
    title: "Xin chào",
    englishTitle: "Hello",
    pronunciation: "sin chow",
    summary: "A safe first hello for shops, hotels, tours, and any moment where the relationship word is not obvious yet.",
    iconName: "star.fill",
    tintName: "red",
    categoryIDs: categoryIDsForPage(pageID, family),
    audioKey: authoredPhraseAudioKey(primaryPhrase.targetText, primaryPhrase.audioKey),
    sections: withSectionPresentations([
      {
        id: "at-glance",
        title: "Start Safe, Then Warm Up",
        body: "Xin chào is the clean first hello when you walk into a shop, hotel, tour desk, or small request. It buys you a polite opening before you decide whether anh, chị, cô, chú, or a simpler chào fits better.",
      },
      {
        id: "quick-say",
        title: "The First Hello",
        body: "Start with Xin chào when the relationship is unclear. Drop to Chào when the moment is relaxed, or add the right relationship word when the person in front of you is obvious.",
        phrases: [
          phraseOption(primaryPhrase, null, "red"),
          manualPhraseOption("xin-chao-casual-chao", "Chào", "Hi / hello (casual)", "chow", "orange"),
        ],
      },
      {
        id: "breakdown",
        title: "Break it down",
        body: "Xin gives the greeting its polite shape. Chào carries the hello. Together they keep the opening respectful without forcing you to guess age, role, or closeness too early.",
        breakdown: [
          { id: "xin", vietnamese: "Xin", english: "polite opening", audioKey: authoredBreakdownAudioKey("Xin") },
          { id: "chao", vietnamese: "chào", english: "greet / hello", audioKey: authoredBreakdownAudioKey("chào") },
          { id: "full", vietnamese: "Xin chào", english: "polite hello", audioKey: authoredPhraseAudioKey(primaryPhrase.targetText, primaryPhrase.audioKey) },
        ],
      },
      {
        id: "when-to-use",
        title: "Where It Helps",
        body: "Use it at first contact: front desk, shop counter, guide pickup, cafe order, or polite question. If the exchange becomes warmer, the next phrase can carry the relationship word.",
        presentation: "plain-text",
      },
      {
        id: "situational-greetings",
        title: "When The Room Gives You More",
        body: "These greetings fit once the setting is clearer: a familiar person, a respectful older adult, a phone call, or a time-of-day exchange.",
        presentation: "horizontal-phrase-cards",
        phrases: [
          manualPhraseOption("xin-chao-friend", "Chào bạn", "Hi, friend", "chow ban", "orange"),
          manualPhraseOption("xin-chao-formal", "Dạ, chào anh/chị", "Hello, formal and respectful", "yah chow anh chee", "red"),
          manualPhraseOption("xin-chao-phone", "Alô", "Hello on the phone", "ah-lo", "green"),
          manualPhraseOption("xin-chao-morning", "Chào buổi sáng", "Good morning", "chow boo-ee sahng", "blue"),
          manualPhraseOption("xin-chao-afternoon", "Chào buổi chiều", "Good afternoon", "chow boo-ee chee-ew", "purple"),
        ],
      },
      {
        id: "local-greetings",
        title: "Relationship Words Matter",
        body: "Vietnamese greetings often show age, respect, and social distance. Stay with Xin chào when unsure; choose anh, chị, em, cô, chú, ông, or bà only when the role feels clear enough.",
        phrases: [
          manualPhraseOption("xin-chao-anh", "Chào anh", "Hello, older brother / slightly older man", "chow anh", "blue"),
          manualPhraseOption("xin-chao-chi", "Chào chị", "Hello, older sister / slightly older woman", "chow chee", "red"),
          manualPhraseOption("xin-chao-em", "Chào em", "Hello, younger sibling / someone younger", "chow em", "green"),
          manualPhraseOption("xin-chao-ong", "Chào ông", "Hello, grandfather / elderly man", "chow ohm", "purple"),
          manualPhraseOption("xin-chao-ba", "Chào bà", "Hello, grandmother / elderly woman", "chow bah", "red"),
          manualPhraseOption("xin-chao-chu", "Chào chú", "Hello, uncle / older man", "chow choo", "teal"),
          manualPhraseOption("xin-chao-co", "Chào cô", "Hello, aunt / older woman", "chow koh", "red"),
        ],
      },
      {
        id: "common-follow-ups",
        title: "If The Hello Continues",
        body: "After hello, the next beat is usually practical or social: checking in, asking where to go, or moving into the actual request.",
        phrases: [
          catalogPhraseOption("smalltalk-7", "viet-how-are-you", "red"),
          manualPhraseOption("xin-chao-where-going", "Đi đâu đấy?", "Where are you going?", "dee dow day", "red"),
          manualPhraseOption("xin-chao-nice-meet", "Rất vui được gặp bạn", "Nice to meet you", "zuht voo-ee duhk gap ban", "red"),
        ],
      },
      {
        id: "cultural-note",
        title: "You Do Not Need The Perfect Word",
        body: "A calm Xin chào is better than freezing while you calculate the perfect relationship term. Smile, keep the greeting simple, then let the next phrase do the work.",
        presentation: "tip-callout",
      },
      {
        id: "good-to-know",
        title: "Good To Know",
        body: "If someone answers with a warmer chào plus a relationship word, you can mirror the energy without copying every word exactly.",
        presentation: "tip-callout",
      },
      {
        id: "explore-next",
        title: "Keep The Exchange Moving",
        body: "Use these when the hello has opened the door and you need the next small move.",
        phrases: [
          catalogPhraseOption("polite-2", "viet-thank-you", "green"),
          catalogPhraseOption("polite-5", "viet-excuse-sorry", "blue"),
          catalogPhraseOption("polite-7", "viet-goodbye", "purple"),
        ],
      },
    ]),
    examples: [phraseOption(primaryPhrase, null, "red")],
  };
}

function childPageForVariant(family, variantPhrase, primaryPhrase) {
  const pageID = `viet-phrase-${variantPhrase.id}`;
  const scenario = scenarioByID.get(family.scenarioID);
  const primaryPageID = canonicalPageID(family);
  const travelerInsightPhrases = [
    phraseOption(primaryPhrase, primaryPageID, tintForScenario(family.scenarioID)),
    ...exploreOptions(family, 2, new Set([pageID, primaryPageID])),
  ];

  return {
    id: pageID,
    familyID: family.id,
    phraseID: variantPhrase.id,
    tierRole: "child",
    depth: "deep",
    title: variantPhrase.targetText,
    englishTitle: variantPhrase.englishText,
    pronunciation: variantPhrase.pronunciation,
    summary: `A focused guide to when ${variantPhrase.targetText} sounds more natural than ${primaryPhrase.targetText}.`,
    iconName: scenario?.symbolName ?? "text.bubble.fill",
    tintName: tintForScenario(family.scenarioID),
    categoryIDs: categoryIDsForPage(pageID, family),
    audioKey: authoredPhraseAudioKey(variantPhrase.targetText, variantPhrase.audioKey),
    sections: withSectionPresentations([
      {
        id: "at-glance",
        title: "At a glance",
        body: `${variantPhrase.targetText} is useful when "${variantPhrase.englishText}" needs a slightly different tone or setting. ${sentence(variantPhrase.context || family.summary)}`
      },
      {
        id: "breakdown",
        title: "Break it down",
        body: breakdownLeadIn(variantPhrase),
        breakdown: breakdownTokens(variantPhrase),
      },
      {
        id: "standard-way",
        title: "The standard way",
        body: `Use ${variantPhrase.targetText} when "${variantPhrase.englishText}" is the exact tone or situation you want.`,
        phrases: [phraseOption(variantPhrase, null, tintForScenario(family.scenarioID))],
      },
      {
        id: "when-to-use",
        title: "When to use it",
        body: `${contextAsSituation(variantPhrase.context, family.summary)} Use ${primaryPhrase.targetText} when you want the shorter default, and choose this form when the note under the phrase matches the person or setting.`,
      },
      {
        id: "traveler-insight",
        title: "Traveler insight",
        body: travelerInsightText(family, variantPhrase),
        phrases: travelerInsightPhrases,
      },
      {
        id: "good-to-know",
        title: "Good to know",
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
    case "good-to-know":
    case "watch-out":
      return "tip-callout";
    case "local-tip":
    case "traveler-tip":
      return (section.phrases ?? []).length > 0 ? "phrase-list" : "tip-callout";
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
  if (family.id === "polite-hello") {
    return xinChaoFlagshipPage(family, primaryPhrase);
  }

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
    const override = familyOverride(family);
    if (override.variation) {
      variationsSection.body = override.variation;
    }
    sections.push(variationsSection);
  }

  sections.push({
    id: "why-it-matters",
    title: "Why it matters",
    body: whyItMattersText(family, primaryPhrase),
  });

  sections.push({
    id: "traveler-insight",
    title: "Traveler insight",
    body: travelerInsightText(family, primaryPhrase),
    phrases: teachingPhraseOptions(family, sections, pageID, primaryPhrase, 3),
  });

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

  sections.push({
    id: "when-to-use",
    title: "When to use it",
    body: usageText(family, primaryPhrase),
    phrases: teachingPhraseOptions(family, sections, pageID, primaryPhrase, 3),
  });

  sections.push({
    id: "good-to-know",
    title: "Good to know",
    body: watchOutText(family, primaryPhrase),
  });

  sections.push({
    id: "local-tip",
    title: "Local tip",
    body: localTipText(family, primaryPhrase),
    phrases: teachingPhraseOptions(family, sections, pageID, primaryPhrase, 3),
  });

  if (depth === "deep" && variantOptions.length === 0) {
    const overrideNearbyOptions = overrideFamilyOptions(family, "nearbyPhraseFamilyIDs", 4, linkedPageIDs(sections));
    const nearbySection = overrideNearbyOptions.length > 0
      ? {
          id: "nearby-phrases",
          title: "Useful nearby phrases",
          body: familyOverride(family).exploreNext ?? "These are the next phrases a traveler is likely to need when this moment keeps moving.",
          phrases: overrideNearbyOptions,
        }
      : nearbyPhraseSection(family, linkedPageIDs(sections));
    if (nearbySection) {
      sections.push(nearbySection);
    }
  }

  if (primaryPhrase.youMayHear) {
    const override = familyOverride(family);
    sections.push({
      id: "you-may-hear",
      title: "You May Hear",
      body: override.youMayHear ?? `A local may answer with: ${primaryPhrase.youMayHear}`,
    });
  }

  const override = familyOverride(family);
  sections.push({
    id: "explore-next",
    title: override.exploreNextTitle ?? "Explore next",
    body: override.exploreNext ?? "Use these next when the conversation moves one step forward.",
    phrases: exploreNextPhraseOptions(family, sections, pageID, primaryPhrase, 8),
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
    summary: familyOverride(family).summary ?? sentence(family.summary) ?? travelerFacingSummary(primaryPhrase),
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

function walkJSONFiles(dir) {
  if (!fs.existsSync(dir)) return [];
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...walkJSONFiles(fullPath));
    } else if (entry.isFile() && entry.name.endsWith(".json") && !entry.name.startsWith("_")) {
      files.push(fullPath);
    }
  }
  return files.sort((a, b) => a.localeCompare(b));
}

function loadCatalogPromotedPages() {
  return walkJSONFiles(catalogPromotedSourceRoot).map((filePath) => {
    const page = JSON.parse(fs.readFileSync(filePath, "utf8"));
    return {
      ...page,
      sections: withSectionPresentations((page.sections ?? []).map((section) => ({
        ...section,
        phrases: (section.phrases ?? []).map((phrase) => ({
          ...phrase,
          symbolName: speakerSymbolName(phrase.vietnamese, phrase.audioKey),
          detailPageID: canonicalDetailPageID(phrase.detailPageID),
        })),
      }))),
      examples: (page.examples ?? []).map((phrase) => ({
        ...phrase,
        symbolName: speakerSymbolName(phrase.vietnamese, phrase.audioKey),
        detailPageID: canonicalDetailPageID(phrase.detailPageID),
      })),
    };
  });
}

function loadCatalogPromotedPhraseIDs() {
  return new Set(walkJSONFiles(catalogPromotedSourceRoot).map((filePath) => {
    const page = JSON.parse(fs.readFileSync(filePath, "utf8"));
    return page.phraseID;
  }).filter(Boolean));
}

function normalizeAuthoredPhrasePage(page) {
  return {
    ...page,
    sections: withSectionPresentations((page.sections ?? []).map((section) => ({
      ...section,
      phrases: (section.phrases ?? []).map((phrase) => ({
        ...phrase,
        symbolName: speakerSymbolName(phrase.vietnamese, phrase.audioKey),
        detailPageID: canonicalDetailPageID(phrase.detailPageID),
      })),
    }))),
    examples: (page.examples ?? []).map((phrase) => ({
      ...phrase,
      symbolName: speakerSymbolName(phrase.vietnamese, phrase.audioKey),
      detailPageID: canonicalDetailPageID(phrase.detailPageID),
    })),
  };
}

function loadExistingChildPagesByPhraseID() {
  return new Map(walkJSONFiles(sourceRoot)
    .map((filePath) => normalizeAuthoredPhrasePage(JSON.parse(fs.readFileSync(filePath, "utf8"))))
    .filter((page) => page.tierRole === "child" && page.phraseID)
    .map((page) => [page.phraseID, page]));
}

function loadCityLibrary() {
  if (!fs.existsSync(cityLibraryPath)) {
    return null;
  }
  return JSON.parse(fs.readFileSync(cityLibraryPath, "utf8"));
}

function canonicalCityDetailPageID(phraseID) {
  return cityPageID(phraseID);
}

function cityPageID(phraseID) {
  return `viet-family-${phraseID}`;
}

function cityLibraryPhraseOption(pageRecord, detailPageID = null) {
  const phrase = phraseByID.get(pageRecord.id);
  if (!phrase) {
    throw new Error(`Missing city library phrase in catalog: ${pageRecord.id}`);
  }
  return phraseOption(phrase, detailPageID, "teal");
}

const cityRestaurantPlaceKinds = new Set(["restaurant", "cafe"]);
const cityDishPlaceKinds = new Set(["local dish", "food spot", "dish", "drink", "dessert"]);
const cityAttractionPlaceKinds = new Set([
  "attraction",
  "beach",
  "landmark",
  "museum",
  "nature",
  "park",
  "river",
  "village",
  "experience",
]);

function cityPlaceKind(place) {
  const explicitKind = String(place.placeKind ?? "").trim();
  if (explicitKind) return explicitKind;
  const legacyKind = String(place.kind ?? "").trim().toLowerCase();
  if (cityDishPlaceKinds.has(legacyKind)) return "dish";
  return legacyKind;
}

function cityPageKind(pageRecord, place) {
  if (pageRecord.pageKind) return pageRecord.pageKind;
  if (pageRecord.kind !== "place") return pageRecord.kind;
  const placeKind = String(place.kind ?? "").trim().toLowerCase();
  if (cityRestaurantPlaceKinds.has(placeKind)) return "restaurant";
  if (placeKind === "drink" || placeKind === "dessert") return placeKind;
  if (cityDishPlaceKinds.has(placeKind)) return "dish";
  return "place";
}

function isDerivedCityPlacePhrase(pageRecord, pageKind) {
  return pageKind === "phrase" && pageRecord.kind === "phrase" && Boolean(pageRecord.placeID);
}

function isCityAttractionPlaceKind(placeKind) {
  return cityAttractionPlaceKinds.has(String(placeKind ?? "").trim().toLowerCase());
}

function cityContentRole(pageRecord, place) {
  if (pageRecord.contentRole) return cleanCityContentRole(pageRecord.contentRole);
  if (place.contentRole) return cleanCityContentRole(place.contentRole);
  const placeKind = cityPlaceKind(place);
  if (placeKind === "drink" || placeKind === "dessert") return placeKind;
  if (placeKind === "dish") return "dish";
  if (placeKind === "cafe") return "cafe";
  if (placeKind === "restaurant") {
    const sourceIDs = new Set([...(place.sourceIDs ?? []), ...(pageRecord.sourceIDs ?? [])]);
    return sourceIDs.has("michelin-vietnam") ? "fine-dining" : "everyday";
  }
  return "";
}

function cleanCityContentRole(role) {
  return role === "dish-anchor" ? "dish" : role;
}

function cleanCityCategoryID(categoryID) {
  return categoryID === "content-role-dish-anchor" ? "content-role-dish" : categoryID;
}

function isCityDishLikePageKind(pageKind) {
  return ["dish", "drink", "dessert"].includes(String(pageKind ?? "").trim().toLowerCase());
}

function phraseOptionByID(phraseID, tintName = "teal") {
  const phrase = phraseByID.get(phraseID);
  if (!phrase) return null;
  const family = familyByID.get(phrase.familyID);
  return phraseOption(phrase, family ? canonicalPageID(family) : null, tintName);
}

function compactPhraseOptions(options, limit) {
  const seen = new Set();
  const unique = [];
  for (const option of options.filter(Boolean)) {
    const key = normalizeAudioText(option.vietnamese);
    if (!key || seen.has(key)) continue;
    seen.add(key);
    unique.push(option);
    if (unique.length >= limit) break;
  }
  return unique;
}

function cityChunk(vietnamese, english, id = null) {
  return { id, vietnamese, english };
}

function isCompactCityChunk(vietnamese) {
  return vietnamese.split(/\s+/).filter(Boolean).length <= 3 && vietnamese.length <= 24;
}

function splitProperNameChunk(vietnamese, english) {
  return [cityChunk(vietnamese, english || "local place")];
}

function cityGeneratedLabel(label, english) {
  if (!label) return cleanLabelForCityChunk(english);
  if (/^(street|place|market|lake|beach|airport) name$/i.test(label)) {
    return cleanLabelForCityChunk(english);
  }
  return label;
}

function cleanLabelForCityChunk(english) {
  const text = String(english ?? "").trim();
  if (!text || /^(proper name|place name|street name|market name|name starter|phrase piece)$/i.test(text)) {
    return "local name";
  }
  return text;
}

function splitLongCityChunk(chunk) {
  const vietnamese = Array.isArray(chunk) ? chunk[0] : chunk.vietnamese;
  const english = Array.isArray(chunk) ? chunk[1] : chunk.english;
  if (isCompactCityChunk(vietnamese)) {
    return [cityChunk(vietnamese, english, Array.isArray(chunk) ? null : chunk.id)];
  }

  const matchers = [
    [/^(gần)\s+(.+)$/iu, [["$1", "near"], ["$2", english]]],
    [/^(ở)\s+(.+)$/iu, [["$1", "at"], ["$2", english]]],
    [/^(phố đi bộ)\s+(.+)$/iu, [["$1", "walking street"], ["$2", "street name"]]],
    [/^(đường)\s+(.+)$/iu, [["$1", "street"], ["$2", "street name"]]],
    [/^(phố cổ)\s+(.+)$/iu, [["$1", "old town / old quarter"], ["$2", "local name"]]],
    [/^(chợ đêm)\s+(.+)$/iu, [["$1", "night market"], ["$2", "local name"]]],
    [/^(chợ)\s+(.+)$/iu, [["$1", "market"], ["$2", "market name"]]],
    [/^(hồ)\s+(.+)$/iu, [["$1", "lake"], ["$2", "lake name"]]],
    [/^(biển)\s+(.+)$/iu, [["$1", "beach"], ["$2", "beach name"]]],
    [/^(sân bay)\s+(.+)$/iu, [["$1", "airport"], ["$2", "airport name"]]],
    [/^(bán đảo)\s+(.+)$/iu, [["$1", "peninsula"], ["$2", "local name"]]],
  ];

  for (const [pattern, pieces] of matchers) {
    const match = vietnamese.match(pattern);
    if (!match) continue;
    return pieces.flatMap(([template, label]) => {
      const value = template.replace(/\$(\d+)/g, (_, index) => match[Number(index)] ?? "").trim();
      return splitLongCityChunk(cityChunk(value, cityGeneratedLabel(label, english)));
    });
  }

  const exactSplits = {
    "Bưu điện Thành phố": [
      ["Bưu điện", "post office"],
      ["Thành phố", "city"],
    ],
    "Nhà thờ Đức Bà Sài Gòn": [
      ["Nhà thờ", "cathedral / church"],
      ["Đức Bà", "Notre-Dame"],
      ["Sài Gòn", "Saigon"],
    ],
    "Nén Đà Nẵng": [
      ["Nén", "restaurant name"],
      ["Đà Nẵng", "Da Nang"],
    ],
    "Múa rối Thăng Long": [
      ["Múa rối", "water puppets"],
      ["Thăng Long", "Thang Long"],
    ],
    "Tôi có đặt bàn": [
      ["Tôi có", "I have"],
      ["đặt bàn", "a reservation"],
    ],
    "Cao lầu ở": [
      ["Cao lầu", "dish name"],
      ["ở", "in / at"],
    ],
    "Bún bò ở": [
      ["Bún bò", "Hue noodle dish"],
      ["ở", "in / at"],
    ],
  };

  if (exactSplits[vietnamese]) {
    return exactSplits[vietnamese].map(([target, meaning]) => cityChunk(target, meaning));
  }

  return splitProperNameChunk(vietnamese, english);
}

function cityRecognitionGloss(pageKind, placeKind) {
  if (pageKind === "restaurant") return "restaurant name";
  if (pageKind === "drink") return "drink name";
  if (pageKind === "dessert") return "dessert name";
  if (pageKind === "dish") return "dish name";
  if (placeKind === "street") return "street name";
  return "local name";
}

function isUsefulCityPlaceWord(vietnamese, english) {
  const text = normalizeAudioText(vietnamese);
  const gloss = normalizeAudioText(english);
  return [
    "airport",
    "street",
    "market",
    "park",
    "museum",
    "bridge",
    "lake",
    "beach",
    "river",
    "cathedral",
    "church",
    "pagoda",
    "restaurant",
    "cafe",
    "old town",
    "old quarter",
    "walking street",
    "peninsula",
    "imperial city",
    "tomb",
    "station",
    "port",
    "atm",
    "da nang",
    "hanoi",
    "hoi an",
    "hue",
    "saigon",
    "ho chi minh",
  ].some((word) => text.includes(word) || gloss.includes(word));
}

function looksLikeNameChunk(vietnamese, english) {
  const normalizedVietnamese = normalizeAudioText(vietnamese);
  const normalizedEnglish = normalizeAudioText(english);
  const accentlessVietnamese = slug(vietnamese).replace(/-/g, " ");
  const accentlessEnglish = slug(english).replace(/-/g, " ");
  return normalizedVietnamese === normalizedEnglish
    || accentlessVietnamese === accentlessEnglish
    || /^[A-Z0-9][A-Za-z0-9 '&.-]*$/.test(String(vietnamese ?? "").trim());
}

function shouldUseCityRecognitionGloss(vietnamese, english) {
  const gloss = normalizeAudioText(english);
  const normalizedVietnamese = normalizeAudioText(vietnamese);
  const accentlessVietnamese = slug(vietnamese).replace(/-/g, " ");
  const accentlessEnglish = slug(english).replace(/-/g, " ");
  return !gloss
    || gloss === normalizedVietnamese
    || accentlessEnglish === accentlessVietnamese
    || [
      "local place",
      "proper name",
      "place name",
      "local name",
      "street name",
      "market name",
      "lake name",
      "beach name",
      "airport name",
      "restaurant name",
      "dish name",
      "name recognition",
      "restaurant name recognition",
      "dish name recognition",
      "name ending",
      "restaurant name ending",
      "dish name ending",
    ].includes(gloss);
}

function cityBreakdownTokens(pageRecord, pageKind = null, placeKind = null, options = {}) {
  if (isCityDishLikePageKind(pageKind) && normalizeAudioText(pageRecord.targetText) === normalizeAudioText("Cao lầu ở Hội An")) {
    return [
      { id: `${pageRecord.id}-chunk-1`, vietnamese: "Cao lầu", english: "dish name", audioKey: null },
      { id: `${pageRecord.id}-chunk-2`, vietnamese: "ở Hội An", english: "in Hội An", audioKey: authoredBreakdownAudioKey("ở Hội An") },
      { id: `${pageRecord.id}-full`, vietnamese: pageRecord.targetText, english: pageRecord.englishText, audioKey: authoredBreakdownAudioKey(pageRecord.targetText) },
    ];
  }

  const chunks = [...(pageRecord.chunks ?? [])];
  const lastChunk = chunks[chunks.length - 1];
  const lastVietnamese = Array.isArray(lastChunk) ? lastChunk?.[0] : lastChunk?.vietnamese;
  const hasFinalChunk = normalizeAudioText(lastVietnamese ?? "") === normalizeAudioText(pageRecord.targetText);
  const finalChunk = hasFinalChunk
    ? chunks[chunks.length - 1]
    : { id: `${pageRecord.id}-full`, vietnamese: pageRecord.targetText, english: pageRecord.englishText };
  const teachingChunks = hasFinalChunk ? chunks.slice(0, -1) : chunks;
  const compactChunks = teachingChunks.flatMap(splitLongCityChunk);
  compactChunks.push(finalChunk);

  return compactChunks.map((chunk, index) => {
    const vietnamese = Array.isArray(chunk) ? chunk[0] : chunk.vietnamese;
    let english = Array.isArray(chunk) ? chunk[1] : chunk.english;
    const isFinalToken = index === compactChunks.length - 1;
    if (
      !options.preserveNameGloss
      &&
      !isFinalToken
      && pageKind
      && looksLikeNameChunk(vietnamese, english)
      && !isUsefulCityPlaceWord(vietnamese, english)
      && shouldUseCityRecognitionGloss(vietnamese, english)
    ) {
      english = cityRecognitionGloss(pageKind, placeKind);
    }
    return {
      id: Array.isArray(chunk) ? `${pageRecord.id}-chunk-${index + 1}` : (chunk.id ?? `${pageRecord.id}-chunk-${index + 1}`),
      vietnamese,
      english,
      audioKey: /\b(?:local name|restaurant name|dish name|street name|market name|beach name|airport name|name recognition|name ending)\b/i.test(english) ? null : authoredBreakdownAudioKey(vietnamese),
    };
  });
}

function derivedPlacePhraseTip(placeKind) {
  if (placeKind === "restaurant" || placeKind === "cafe") {
    return "If the name is hard to say, show the map pin and play the full sentence.";
  }
  if (placeKind === "street") {
    return "If pronunciation is hard, show the address and play the full sentence.";
  }
  if (["airport", "station", "port"].includes(placeKind)) {
    return "Keep the ticket, booking, or pickup screen visible if staff ask a follow-up.";
  }
  return "Keep the map pin, ticket, or meeting point visible if the answer comes fast.";
}

function derivedPlacePhraseRecordScore(record, pageRecord, placeKind) {
  const text = cityRecordSearchText(record);
  let score = 0;
  if (record.kind === "place") score += 1000;
  if (record.id === pageRecord.id) score -= 10000;
  if (placeKind === "restaurant" || placeKind === "cafe") {
    if (/go|đến|đi /.test(text)) score += 500;
    if (/reservation|đặt bàn/.test(text)) score += 450;
    if (/stop|dừng|drop|xuống/.test(text)) score += 350;
    if (/where|ở đâu/.test(text)) score += 260;
    if (/\batm\b|ăn gần|eat near/.test(text)) score -= 250;
  } else if (placeKind === "street") {
    if (/đến đường|driver|taxi|đi đường/.test(text)) score += 500;
    if (/phải đường|gần đây|near here/.test(text)) score += 450;
    if (/stop|dừng|drop|xuống/.test(text)) score += 400;
    if (/wrong|sai chỗ|không đúng/.test(text)) score += 350;
  } else {
    if (/where|ở đâu|\bgo\b|đi |stop|dừng|drop|xuống|ticket|vé|photo|chụp|taxi|call|gọi|pickup|đón/.test(text)) score += 450;
    if (/\batm\b|ăn gần|eat near/.test(text)) score -= 150;
  }
  return score;
}

function derivedPlacePhraseOptions(pageRecord, relatedRecords, placePage, placeKind) {
  const samePlaceRecords = [
    placePage,
    ...relatedRecords.filter((record) => record.placeID === pageRecord.placeID),
  ]
    .filter(Boolean)
    .filter((record) => record.id !== pageRecord.id)
    .filter((record) => {
      if (placeKind !== "restaurant" && placeKind !== "cafe") return true;
      return !/stop|dừng|drop|xuống/.test(cityRecordSearchText(record));
    })
    .map((record, index) => ({
      record,
      index,
      score: derivedPlacePhraseRecordScore(record, pageRecord, placeKind),
    }))
    .sort((left, right) => (right.score - left.score) || (left.index - right.index) || left.record.id.localeCompare(right.record.id))
    .map((entry) => cityLibraryPhraseOption(entry.record, canonicalCityDetailPageID(entry.record.id)));

  const samePlaceOptions = compactPhraseOptions(samePlaceRecords, 5);
  const supplemental = [];
  if (placeKind === "restaurant" || placeKind === "cafe") {
    supplemental.push(
      phraseOptionByID("food-menu", "green"),
      phraseOptionByID("food-need-table", "green"),
      phraseOptionByID("coffee-7", "green")
    );
  } else if (samePlaceOptions.length < 2) {
    supplemental.push(
      phraseOptionByID("repair-show-me", "teal"),
      phraseOptionByID("ves-not-right-place", "orange"),
      phraseOptionByID("ves-call-taxi-for-me", "orange")
    );
  }

  return compactPhraseOptions([...samePlaceOptions, ...supplemental], 5);
}

function linkedCityPhraseOptions(records, count = 4) {
  return records
    .slice(0, count)
    .map((record) => cityLibraryPhraseOption(record, canonicalCityDetailPageID(record.id)));
}

function cityRecordSearchText(record) {
  return [
    record.id,
    record.targetText,
    record.englishText,
    record.subcategoryID,
  ].filter(Boolean).join(" ").toLowerCase();
}

function isATMOrGenericNearbyRecord(record) {
  const text = cityRecordSearchText(record);
  return /\batm\b|có atm|eat near|ăn gần|nearby/i.test(text);
}

function scoreCityRecordForIntent(record, intent) {
  const text = cityRecordSearchText(record);
  let score = 0;

  if (isATMOrGenericNearbyRecord(record)) score -= 80;
  if (/where|ở đâu|\bgo\b|đi |stop|dừng|drop|xuống|taxi|pickup|đón|call|gọi/i.test(text)) score += 20;

  switch (intent) {
    case "restaurant-walk-in":
      if (/where|ở đâu|\bgo\b|đi |stop|dừng|drop|xuống|taxi|call|gọi/i.test(text)) score += 70;
      break;
    case "restaurant-order":
      if (/portion|phần|bowl|tô|order|menu|thực đơn|recommend|đề xuất|table|bàn|bún chả|phở/i.test(text)) score += 110;
      break;
    case "restaurant-pay":
      if (/bill|pay|cash|card|receipt|tính tiền|tiền mặt|thẻ|hóa đơn|taxi|call|gọi/i.test(text)) score += 110;
      break;
    case "dish-order":
      if (/portion|phần|bowl|tô|want to eat|muốn ăn|order|bún bò|cao lầu|bún chả|phở/i.test(text)) score += 110;
      break;
    case "dish-ingredients":
      if (/inside|ingredient|có gì|spicy|cay|allerg|dị ứng|pork|beef|seafood|vegetarian|thịt|hải sản|ăn chay/i.test(text)) score += 110;
      break;
    case "find-nearby":
      if (/where|ở đâu|eat near|ăn gần|\bgo\b|đi |stop|dừng/i.test(text)) score += 80;
      if (/\batm\b|có atm/i.test(text)) score -= 70;
      break;
    case "place-action":
      if (/where|ở đâu|\bgo\b|đi |stop|dừng|ticket|vé|photo|chụp|taxi|call|gọi|cable|cáp treo|pickup|đón/i.test(text)) score += 100;
      if (/\batm\b|có atm|eat near|ăn gần/i.test(text)) score -= 50;
      break;
    default:
      break;
  }

  return score;
}

function rankedCityPhraseRows(records, intent, limit = 4) {
  return records
    .filter((record) => record.kind === "phrase")
    .map((record, index) => ({ record, index, score: scoreCityRecordForIntent(record, intent) }))
    .sort((a, b) => (b.score - a.score) || (a.index - b.index) || a.record.id.localeCompare(b.record.id))
    .slice(0, limit)
    .map((entry) => entry.record);
}

function linkedCityPhraseOptionsByIntent(records, intent, count = 4) {
  return linkedCityPhraseOptions(rankedCityPhraseRows(records, intent, count), count);
}

function genericAttractionGettingThereOptions() {
  return compactPhraseOptions([
    phraseOptionByID("taxi-1", "orange"),
    phraseOptionByID("repair-5", "teal"),
    phraseOptionByID("transport-stop-here-clearer", "orange"),
    phraseOptionByID("ves-is-this-address-correct", "teal"),
  ], 4);
}

function genericAttractionVisitOptions() {
  return compactPhraseOptions([
    phraseOptionByID("repair-5", "teal"),
    phraseOptionByID("ves-is-this-address-correct", "teal"),
    phraseOptionByID("ves-take-photo-for-me", "teal"),
    phraseOptionByID("transport-stop-here-clearer", "orange"),
  ], 4);
}

function genericAttractionPickupOptions() {
  return compactPhraseOptions([
    phraseOptionByID("repair-5", "teal"),
    phraseOptionByID("ves-is-this-address-correct", "teal"),
    phraseOptionByID("transport-stop-here-clearer", "orange"),
    phraseOptionByID("ves-call-taxi-for-me", "orange"),
  ], 4);
}

function genericAttractionExploreOptions() {
  return compactPhraseOptions([
    phraseOptionByID("sight-1", "purple"),
    phraseOptionByID("v500-time-date-book-one-ticket-please", "purple"),
    phraseOptionByID("v500-sigh-acti-where-can-i-buy-tickets", "purple"),
    phraseOptionByID("v500-sigh-acti-where-is-the-exit", "teal"),
    phraseOptionByID("airport-4", "teal"),
  ], 5);
}

function specificFoodOrderOptionForText(value) {
  const text = String(value ?? "").toLowerCase();
  if (/bún chả|bun cha/i.test(text)) return phraseOptionByID("ves-order-bun-cha-portion", "green");
  if (/phở|pho/i.test(text)) return phraseOptionByID("ves-order-pho-bowl", "green");
  if (/bún bò|bun bo/i.test(text)) return phraseOptionByID("ves-order-bun-bo-hue-bowl", "green");
  if (/cao lầu|cao lau/i.test(text)) return phraseOptionByID("ves-order-cao-lau-portion", "green");
  return null;
}

function citySpecificFoodOrderOption(pageRecord) {
  return specificFoodOrderOptionForText(`${pageRecord.targetText ?? ""} ${pageRecord.englishText ?? ""}`);
}

function editorialCityPhraseOption(phraseID, currentPhraseID, tintName = "teal") {
  const phrase = phraseByID.get(phraseID);
  if (!phrase) {
    throw new Error(`Missing editorial city phrase option ${phraseID}`);
  }
  const family = familyByID.get(phrase.familyID);
  const detailPageID = phraseID === currentPhraseID ? null : (family ? canonicalPageID(family) : null);
  return phraseOption(phrase, detailPageID, tintName);
}

function editorialCityBreakdownTokens(tokens) {
  return (tokens ?? []).map((token, index) => ({
    id: token.id ?? `editorial-chunk-${index + 1}`,
    vietnamese: token.vietnamese,
    english: token.english,
    audioKey: authoredBreakdownAudioKey(token.vietnamese),
  }));
}

function applyCityEditorialImport(sections, pageRecord) {
  const editorialImport = pageRecord.editorialImport;
  if (!editorialImport?.sections?.length) {
    return sections;
  }

  const usesSourceMode = ["expanded-detail", "mobile-first"].includes(editorialImport.sourceMode);
  const nextSections = editorialImport.replaceGeneratedSections === true
    ? []
    : sections.map((section) => ({ ...section }));
  const generatedSectionByID = new Map(sections.map((section) => [section.id, section]));
  const shouldReplaceGeneratedSections = editorialImport.replaceGeneratedSections === true;
  const shouldUseEditorialOnlySections = shouldReplaceGeneratedSections && usesSourceMode;
  const insertBeforeIndex = () => {
    const goodToKnowIndex = nextSections.findIndex((section) => section.id === "good-to-know");
    return goodToKnowIndex === -1 ? nextSections.length : goodToKnowIndex;
  };

  for (const editorialSection of editorialImport.sections) {
    const generatedSection = generatedSectionByID.get(editorialSection.id);
    const hasPhraseIDs = Array.isArray(editorialSection.phraseIDs);
    const next = shouldUseEditorialOnlySections
      ? {
        id: editorialSection.id,
        title: editorialSection.title,
        body: editorialSection.body,
        phrases: [],
        breakdown: [],
        presentation: editorialSection.presentation ?? (hasPhraseIDs ? "phrase-list" : "plain-text"),
      }
      : {
        ...(generatedSection ? { ...generatedSection } : {}),
        id: editorialSection.id,
        title: editorialSection.title,
        body: editorialSection.body,
      };
    if (Array.isArray(editorialSection.phraseIDs)) {
      next.phrases = editorialSection.phraseIDs.map((phraseID) => editorialCityPhraseOption(phraseID, pageRecord.id));
      next.presentation = editorialSection.presentation ?? "phrase-list";
    }
    if (editorialSection.id === "breakdown") {
      next.breakdown = editorialCityBreakdownTokens(editorialSection.breakdownTokens);
    }

    const existingIndex = nextSections.findIndex((section) => section.id === editorialSection.id);
    if (existingIndex >= 0) {
      nextSections[existingIndex] = {
        ...nextSections[existingIndex],
        ...next,
      };
    } else if (shouldReplaceGeneratedSections) {
      nextSections.push(next);
    } else {
      nextSections.splice(insertBeforeIndex(), 0, next);
    }
  }

  return nextSections;
}

function compactDerivedPlacePhraseSections(authoredSections, generatedSections) {
  const generatedRelated = generatedSections.find((section) => section.id === "related-phrases");
  const authoredRelated = authoredSections.find((section) => (
    section.id === "related-phrases"
    && Array.isArray(section.phrases)
    && section.phrases.length > 0
  ));

  const breakdown = generatedSections.find((section) => section.id === "breakdown")
    ?? authoredSections.find((section) => section.id === "breakdown");
  const related = authoredRelated ?? generatedRelated;
  const tip = generatedSections.find((section) => section.id === "good-to-know")
    ?? authoredSections.find((section) => section.id === "good-to-know");

  return [breakdown, related, tip].filter(Boolean);
}

function findRelatedCityRecords(pageRecord, pageRecords, placePageByPlaceID) {
  const samePlace = pageRecords
    .filter((candidate) => candidate.id !== pageRecord.id && candidate.placeID === pageRecord.placeID)
    .sort((a, b) => {
      const placeFirst = a.kind === "place" ? -1 : b.kind === "place" ? 1 : 0;
      return placeFirst || a.id.localeCompare(b.id);
    });
  const sameSubcategory = pageRecords
    .filter((candidate) => (
      candidate.id !== pageRecord.id
      && candidate.cityID === pageRecord.cityID
      && candidate.subcategoryID === pageRecord.subcategoryID
      && candidate.placeID !== pageRecord.placeID
    ))
    .sort((a, b) => a.id.localeCompare(b.id));
  const sameCityBeginner = pageRecords
    .filter((candidate) => (
      candidate.id !== pageRecord.id
      && candidate.cityID === pageRecord.cityID
      && candidate.difficulty === "beginner"
      && candidate.subcategoryID !== pageRecord.subcategoryID
    ))
    .sort((a, b) => a.id.localeCompare(b.id));
  const related = [...samePlace, ...sameSubcategory, ...sameCityBeginner];
  const seen = new Set();
  const unique = [];
  for (const candidate of related) {
    if (seen.has(candidate.id)) continue;
    seen.add(candidate.id);
    unique.push(candidate);
  }

  if (pageRecord.kind !== "place") {
    const placePage = placePageByPlaceID.get(pageRecord.placeID);
    if (placePage && placePage.id !== pageRecord.id && !seen.has(placePage.id)) {
      unique.unshift(placePage);
    }
  }

  return unique;
}

function cityPlaceTypeLabel(placeKind) {
  const labels = {
    airport: "airport",
    park: "park",
    landmark: "landmark",
    street: "street",
    museum: "museum",
    market: "market",
    beach: "beach",
    nature: "nature stop",
    restaurant: "restaurant",
    cafe: "cafe",
    neighborhood: "neighborhood",
    attraction: "attraction",
    river: "riverfront area",
    station: "station",
    port: "port",
    village: "village",
    dish: "local dish",
    experience: "experience",
  };
  return labels[placeKind] ?? "place";
}

function cityPlaceBrief(city, place, pageRecord, pageKind, placeKind, contentRole) {
  if (pageKind === "restaurant") {
    return `${place.vietnameseName} is a restaurant in ${city.shortTitle}.`;
  }

  if (isCityDishLikePageKind(pageKind)) {
    if (contentRole === "drink") {
      return `${place.vietnameseName} is a local drink in ${city.shortTitle}.`;
    }
    if (contentRole === "dessert") {
      return `${place.vietnameseName} is a local dessert in ${city.shortTitle}.`;
    }
    return `${place.vietnameseName} is a local dish in ${city.shortTitle}.`;
  }

  const typeLabel = cityPlaceTypeLabel(placeKind);
  if (placeKind === "neighborhood") {
    return `${place.vietnameseName} is useful on maps, hotel notes, and walking directions in ${city.shortTitle}. Pair it with a nearby street, market, lake, or pickup point.`;
  }
  if (placeKind === "street") {
    return `${place.vietnameseName} means ${place.englishName}.`;
  }
  if (["airport", "station", "port"].includes(placeKind)) {
    return `${place.vietnameseName} is ${place.englishName} in ${city.shortTitle}.`;
  }
  if (["market"].includes(placeKind)) {
    return `${place.vietnameseName} is a market in ${city.shortTitle}.`;
  }
  return `${place.vietnameseName} is ${place.englishName} in ${city.shortTitle}.`;
}

function cityPlaceWhatItIsBody(city, place, pageRecord, pageKind, placeKind, contentRole) {
  const authoredContext = String(pageRecord.context ?? "").trim();
  return authoredContext || cityPlaceBrief(city, place, pageRecord, pageKind, placeKind, contentRole);
}

function normalizedCityAnchorNames(city) {
  return [city.vietnameseName, city.shortTitle, city.title]
    .map((value) => normalizeAudioText(value ?? ""))
    .filter(Boolean);
}

function cityPhraseContainsPlace(pageRecord, place) {
  const target = normalizeAudioText(pageRecord.targetText);
  const english = normalizeAudioText(pageRecord.englishText);
  return [place.vietnameseName, place.englishName]
    .map((value) => normalizeAudioText(value ?? ""))
    .filter((value) => value.length >= 3)
    .some((value) => target.includes(value) || english.includes(value));
}

function cityPhraseAnchorName(pageRecord, city, place) {
  if (cityPhraseContainsPlace(pageRecord, place)) {
    return place.vietnameseName;
  }
  const target = normalizeAudioText(pageRecord.targetText);
  const english = normalizeAudioText(pageRecord.englishText);
  const containsCity = normalizedCityAnchorNames(city).some((value) => target.includes(value) || english.includes(value));
  return containsCity ? city.shortTitle : place.vietnameseName;
}

function cityWhenToUseBody(pageRecord, city, place, pageKind, placeKind) {
  if (pageKind === "restaurant") {
    return "Payment, receipt, cash/card, and ride-back sentences.";
  }

  if (isCityDishLikePageKind(pageKind)) {
    return "Nearby, ordering, and dish-finding sentences.";
  }

  if (pageRecord.kind === "place") {
    return "Meeting, pickup, drop-off, and nearby-help sentences.";
  }

  const visiblePlace = cityPhraseAnchorName(pageRecord, city, place);

  switch (pageRecord.subcategoryID) {
    case "arrivals-routes":
      return `Use it for a ride, walk, or drop-off near ${visiblePlace}. Show the pin, say the phrase, then listen for the stop or time.`;
    case "landmarks-attractions":
      return `Use it at a hotel desk, ticket counter, ride pickup, or street corner when ${visiblePlace} is the place you are trying to reach or recognize.`;
    case "neighborhoods-streets":
      return `Use it when an address, meetup point, or walking route mentions ${visiblePlace}. Keep the map or message open.`;
    case "food-coffee":
      return `Use it when the food stop, cafe, dish, or reservation is the real goal. Keep ${visiblePlace} visible so staff can point you to the right counter, table, or street.`;
    case "shopping-markets":
      return `Use it when shopping plans, market entrances, or souvenir errands revolve around ${visiblePlace}. The phrase should lead to a point, price area, entrance, or quick direction.`;
    case "practical-help-near-places":
      return `Use it when you need practical help near ${visiblePlace}, not a citywide search. The place narrows the answer to something you can walk to or show on the map.`;
    default:
      return `Use it when ${visiblePlace} is part of the next step in ${city.shortTitle}.`;
  }
}

function cityPhraseAtGlanceBody(pageRecord, city, place) {
  const visiblePlace = cityPhraseAnchorName(pageRecord, city, place);
  switch (pageRecord.subcategoryID) {
    case "arrivals-routes":
      return `Use this when getting to, leaving, or confirming a stop near ${visiblePlace}. Keep the map visible for directions or times.`;
    case "landmarks-attractions":
      return `Use this when ${visiblePlace} is part of the attraction, ticket, photo, pickup, or walking moment. Say the short phrase, then show the map or ticket screen if the place is busy.`;
    case "neighborhoods-streets":
      return `Use this when an address, pickup note, or walking route mentions ${visiblePlace}. Keep the map or message open.`;
    case "food-coffee":
      return `Use this when the meal, drink, cafe, or food stop is near ${visiblePlace}. Point to the map, menu, or dish so the answer stays practical.`;
    case "shopping-markets":
      return `Use this when a market, shop, entrance, price area, or souvenir errand is near ${visiblePlace}. A visible map pin or item keeps the exchange short.`;
    case "practical-help-near-places":
      return `Use this when you need cash, a bathroom, help, or another practical stop near ${visiblePlace}.`;
    default:
      return normalizeText(pageRecord.context).replace(/\broute phrase\b/gi, "travel phrase").replace(/\bwhere-question\b/gi, "question");
  }
}

function cityPageForRecord(pageRecord, context) {
  const { cityByID, placeByID, pageRecords, placePageByPlaceID } = context;
  const city = cityByID.get(pageRecord.cityID);
  const place = placeByID.get(pageRecord.placeID);
  const phrase = phraseByID.get(pageRecord.id);
  if (!city || !place || !phrase) {
    throw new Error(`Cannot build city page ${pageRecord.id}; missing city/place/catalog phrase`);
  }

  const pageKind = cityPageKind(pageRecord, place);
  const placeKind = cityPlaceKind(place);
  const contentRole = cityContentRole(pageRecord, place);
  const derivedPlacePhrase = isDerivedCityPlacePhrase(pageRecord, pageKind);
  const relatedRecords = findRelatedCityRecords(pageRecord, pageRecords, placePageByPlaceID);
  const placePage = placePageByPlaceID.get(pageRecord.placeID);
  const samePlacePhraseRows = relatedRecords.filter((record) => record.kind === "phrase");
  const placePhraseRows = pageRecord.kind === "place"
    ? relatedRecords.filter((record) => record.kind === "phrase")
    : (placePage ? [placePage] : []);
  const selfOption = cityLibraryPhraseOption(pageRecord, null);
  const quickBodyByKind = {
    phrase: `Start with ${pageRecord.targetText} when "${pageRecord.englishText}" is the immediate thing you need to say in ${city.shortTitle}.`,
    place: "Say it slowly, then show the map, ticket, address, or pickup note if needed.",
    restaurant: "Show the restaurant on your map first; then order, ask about the menu, pay, or get a ride back.",
    dish: "Start with the dish name, then use the ordering and ingredient phrases when you need to ask where to get it or what is inside.",
    drink: "Start with the drink name, then use the ordering, ice, sweetness, and ingredient phrases when needed.",
    dessert: "Start with the dessert name, then use the ordering, toppings, ice, sweetness, and ingredient phrases when needed.",
  };
  const samePlaceOptions = linkedCityPhraseOptions(samePlacePhraseRows, 8);
  const attractionPlaceKind = isCityAttractionPlaceKind(placeKind);
  const placeActionOptions = attractionPlaceKind
    ? genericAttractionGettingThereOptions()
    : linkedCityPhraseOptionsByIntent(placePhraseRows, "place-action", 4);
  const placeVisitOptions = attractionPlaceKind
    ? genericAttractionVisitOptions()
    : placeActionOptions;
  const placePickupOptions = attractionPlaceKind
    ? genericAttractionPickupOptions()
    : linkedCityPhraseOptionsByIntent(relatedRecords.filter((record) => record.kind === "phrase"), "place-action", 3);
  const placeExploreOptions = attractionPlaceKind
    ? genericAttractionExploreOptions()
    : linkedCityPhraseOptions(relatedRecords, 5);
  const restaurantWalkInOptions = linkedCityPhraseOptionsByIntent(placePhraseRows, "restaurant-walk-in", 4);
  const restaurantTableMenuOptions = compactPhraseOptions([
    phraseOptionByID("food-need-table", "green"),
    phraseOptionByID("food-menu", "green"),
  ], 4);
  const restaurantOrderOptions = compactPhraseOptions([
    citySpecificFoodOrderOption(pageRecord),
    phraseOptionByID("v900-food-drin-what-do-you-recommend", "green"),
  ], 4);
  const restaurantDrinkOptions = compactPhraseOptions([
    phraseOptionByID("store-1", "green"),
    phraseOptionByID("coffee-2", "green"),
    phraseOptionByID("coffee-1", "green"),
  ], 3);
  const restaurantPayOptions = compactPhraseOptions([
    phraseOptionByID("coffee-7", "green"),
    phraseOptionByID("store-6", "green"),
    phraseOptionByID("taxi-7", "green"),
    phraseOptionByID("store-7", "green"),
  ], 4);
  const restaurantGettingBackOptions = compactPhraseOptions([
    phraseOptionByID("ves-call-taxi-for-me", "orange"),
  ], 3);
  const dishOrderOptions = compactPhraseOptions([
    citySpecificFoodOrderOption(pageRecord),
    phraseOptionByID("food-1", "green"),
    phraseOptionByID("food-3", "green"),
    phraseOptionByID("ves-not-too-spicy", "green"),
  ], 4);
  const dishFindOptions = linkedCityPhraseOptionsByIntent(relatedRecords.filter((record) => record.kind === "phrase"), "find-nearby", 4);
  const genericRestaurantOptions = compactPhraseOptions([
    phraseOptionByID("food-need-table", "green"),
    phraseOptionByID("food-menu", "green"),
    phraseOptionByID("v900-food-drin-what-do-you-recommend", "green"),
    phraseOptionByID("food-peanut-allergy", "red"),
    phraseOptionByID("food-vegetarian", "green"),
    phraseOptionByID("store-6", "green"),
    phraseOptionByID("taxi-7", "orange"),
    phraseOptionByID("store-7", "green"),
  ], 8);
  const genericDishOptions = compactPhraseOptions([
    phraseOptionByID("ves-whats-in-this-dish", "green"),
    phraseOptionByID("food-vegetarian", "green"),
    phraseOptionByID("food-peanut-allergy", "red"),
    phraseOptionByID("food-3", "green"),
    phraseOptionByID("v900-food-drin-i-do-not-eat-beef", "green"),
    phraseOptionByID("v900-food-drin-i-do-not-eat-pork", "green"),
    phraseOptionByID("v900-food-drin-i-do-not-eat-seafood", "green"),
  ], 5);

  const sections = derivedPlacePhrase
    ? [
      {
        id: "breakdown",
        title: "Break it down",
        body: "",
        breakdown: cityBreakdownTokens(pageRecord, pageKind, placeKind, { preserveNameGloss: true }),
      },
      {
        id: "related-phrases",
        title: "Related phrases",
        body: "",
        phrases: derivedPlacePhraseOptions(pageRecord, relatedRecords, placePage, placeKind),
      },
      {
        id: "good-to-know",
        title: "Tip",
        body: derivedPlacePhraseTip(placeKind),
      },
    ]
    : [
      {
        id: "at-glance",
        title: pageKind === "phrase" ? "Say this" : "Start here",
        body: pageKind === "phrase" ? cityPhraseAtGlanceBody(pageRecord, city, place) : cityPlaceBrief(city, place, pageRecord, pageKind, placeKind, contentRole),
      },
      {
        id: "quick-say",
        title: pageKind === "phrase" ? "Quick say" : (isCityDishLikePageKind(pageKind) ? "Order it" : "Say it"),
        body: quickBodyByKind[pageKind] ?? quickBodyByKind.phrase,
        phrases: [selfOption],
      },
      {
        id: "breakdown",
        title: pageKind === "phrase" ? "Break it down" : "What the name means",
        body: pageKind === "phrase"
          ? "Listen for these pieces, then play the whole sentence."
          : "Keep proper names together; use literal pieces only when they help.",
        breakdown: cityBreakdownTokens(pageRecord, pageKind, placeKind),
      },
    ];

  if (!derivedPlacePhrase && pageKind === "restaurant") {
    sections.push(
      {
        id: "place-brief",
        title: "Getting there",
        body: "Map, arrival, and drop-off sentences for getting to the restaurant.",
        phrases: restaurantWalkInOptions,
      },
      {
        id: "table-menu",
        title: "Table & menu",
        body: "",
        phrases: restaurantTableMenuOptions,
      },
      {
        id: "before-you-go",
        title: "Order",
        body: "",
        phrases: restaurantOrderOptions,
      },
      {
        id: "menu-dietary",
        title: "Drinks",
        body: "",
        phrases: restaurantDrinkOptions,
      },
      {
        id: "when-to-use",
        title: "Pay",
        presentation: "plain-text",
        body: "",
        phrases: restaurantPayOptions,
      },
      {
        id: "inside-the-place",
        title: "Getting back",
        body: "",
        phrases: restaurantGettingBackOptions,
      }
    );
  } else if (!derivedPlacePhrase && isCityDishLikePageKind(pageKind)) {
    sections.push(
      {
        id: "place-brief",
        title: "Order it",
        body: "First-ordering sentences for the dish.",
        phrases: dishOrderOptions,
      },
      {
        id: "how-to-order",
        title: "Adjust it",
        body: "Short spice and portion sentences.",
        phrases: compactPhraseOptions([
          ...dishOrderOptions,
          ...samePlaceOptions.filter((option) => !/\batm\b|eat near|ăn gần/i.test(`${option.english} ${option.vietnamese}`)),
        ], 4),
      },
      {
        id: "ingredients-diet",
        title: "Ingredients and diet",
        body: "Ingredient, allergy, and diet sentences before ordering.",
        phrases: genericDishOptions,
      },
      {
        id: "when-to-use",
        title: "Find it nearby",
        presentation: "plain-text",
        body: cityWhenToUseBody(pageRecord, city, place, pageKind, placeKind),
        phrases: dishFindOptions,
      }
    );
  } else if (!derivedPlacePhrase && pageKind === "place") {
    sections.push(
      {
        id: "place-brief",
        title: "Getting there",
        body: attractionPlaceKind
          ? "Use the place name with your map or ticket screen, then use a reusable ride phrase."
          : cityPlaceWhatItIsBody(city, place, pageRecord, pageKind, placeKind, contentRole),
        phrases: placeActionOptions,
      },
      {
        id: "use-it-with",
        title: "At the place",
        body: attractionPlaceKind
          ? "Ticket, entrance, photo, and return-ride phrases that work at many attractions."
          : "Direction, ticket, photo, and pickup sentences.",
        phrases: placeVisitOptions,
      },
      {
        id: "when-to-use",
        title: "Meeting or pickup",
        presentation: "plain-text",
        body: cityWhenToUseBody(pageRecord, city, place, pageKind, placeKind),
        phrases: placePickupOptions,
      }
    );
  } else if (!derivedPlacePhrase) {
    sections.push(
      {
        id: "place-anchor",
        title: "Show with it",
        body: `Keep ${cityPhraseAnchorName(pageRecord, city, place)} visible on your map, ticket, address, or message.`,
        phrases: linkedCityPhraseOptions(placePhraseRows, 1),
      },
      {
        id: "when-to-use",
        title: "When it helps",
        body: cityWhenToUseBody(pageRecord, city, place, pageKind, placeKind),
        phrases: linkedCityPhraseOptions(relatedRecords.filter((record) => record.kind === "phrase"), 3),
      }
    );
  }

  if (!derivedPlacePhrase) {
    sections.push(
      {
        id: "good-to-know",
        title: "Good to know",
        body: pageRecord.tip,
      },
      {
        id: "explore-next",
        title: "Explore next",
        body: `Next helpful phrases around ${city.shortTitle}.`,
        phrases: placeExploreOptions,
      }
    );
  }

  let authoredSections = applyCityEditorialImport(sections, pageRecord);
  if (derivedPlacePhrase) {
    authoredSections = compactDerivedPlacePhraseSections(authoredSections, sections);
  }
  const editorialCategoryIDs = (pageRecord.editorialImport?.categoryIDs ?? []).map(cleanCityCategoryID);

  return {
    id: cityPageID(pageRecord.id),
    familyID: pageRecord.id,
    phraseID: pageRecord.id,
    tierRole: "city-v1",
    depth: "deep",
    title: pageRecord.targetText,
    englishTitle: pageRecord.englishText,
    pronunciation: pageRecord.pronunciation,
    summary: pageRecord.editorialImport?.summary ?? pageRecord.englishText,
    heroImageName: pageRecord.editorialImport?.heroImageName ?? pageRecord.heroImageName ?? (derivedPlacePhrase ? "HeroCompactPhraseMasthead" : cityFallbackHeroImageName(pageKind)),
    iconName: pageKind === "restaurant" ? "fork.knife"
      : pageKind === "drink" ? "cup.and.saucer.fill"
      : pageKind === "dessert" ? "birthday.cake.fill"
      : pageKind === "dish" ? "takeoutbag.and.cup.and.straw.fill"
        : pageRecord.kind === "place" ? "mappin.and.ellipse" : "map.fill",
    tintName: pageKind === "restaurant" ? "green" : pageKind === "drink" ? "blue" : pageKind === "dessert" ? "pink" : pageKind === "dish" ? "orange" : "teal",
    categoryIDs: Array.from(new Set([
      "city-guides",
      pageRecord.cityID,
      pageRecord.subcategoryID,
      pageRecord.difficulty,
      `city-page-kind-${pageKind}`,
      placeKind ? `place-kind-${placeKind}` : null,
      contentRole ? `content-role-${contentRole}` : null,
      pageKind === "place" ? "actual-landmarks" : null,
      pageKind === "phrase" ? "city-phrases" : null,
      derivedPlacePhrase ? "derived-place-phrases" : null,
      pageKind === "restaurant" ? "restaurants" : null,
      pageKind === "dish" ? "local-dishes" : null,
      pageKind === "drink" ? "local-drinks" : null,
      pageKind === "dessert" ? "local-desserts" : null,
      ...editorialCategoryIDs,
    ].filter(Boolean))),
    audioKey: authoredPhraseAudioKey(pageRecord.targetText, phrase.audioKey),
    cityMetadata: {
      cityID: pageRecord.cityID,
      cityName: city.title,
      subcategoryID: pageRecord.subcategoryID,
      difficulty: pageRecord.difficulty,
      kind: pageRecord.kind,
      pageKind,
      placeKind,
      contentRole,
      derivedPlacePhrase,
      placeID: pageRecord.placeID,
      placeName: place.englishName,
      sourceIDs: pageRecord.sourceIDs ?? [],
      rationale: cleanTravelerBody(pageRecord.rationale),
      editorialImportPatchID: pageRecord.editorialImport?.patchID ?? null,
      editorialReviewStatus: pageRecord.editorialImport?.reviewStatus ?? null,
      editorialSourceMode: pageRecord.editorialImport?.sourceMode ?? null,
      editorialRuntimeOverrideKind: pageRecord.editorialImport?.runtimeOverride?.kind ?? null,
      targetHeroImageName: pageRecord.editorialImport?.targetHeroImageName ?? pageRecord.productionIntake?.targetHeroImageName ?? null,
    },
    sections: withSectionPresentations(authoredSections),
    examples: [selfOption],
  };
}

function cityFallbackHeroImageName(pageKind) {
  if (pageKind === "place" || pageKind === "restaurant" || isCityDishLikePageKind(pageKind)) {
    return "HeroNeutralMasthead";
  }
  return null;
}

function loadCityLibraryPages() {
  const library = loadCityLibrary();
  if (!library) {
    return [];
  }
  const cityByID = new Map((library.cities ?? []).map((city) => [city.id, city]));
  const placeByID = new Map((library.places ?? []).map((place) => [place.id, place]));
  const pageRecords = (library.pages ?? [])
    .filter((page) => page.status === "approved")
    .sort((a, b) => a.id.localeCompare(b.id));
  const placePageByPlaceID = new Map(
    pageRecords
      .filter((page) => page.kind === "place")
      .map((page) => [page.placeID, page])
  );
  return pageRecords.map((pageRecord) => cityPageForRecord(pageRecord, {
    cityByID,
    placeByID,
    pageRecords,
    placePageByPlaceID,
  }));
}

function loadEditorialSupportManifest() {
  if (!fs.existsSync(editorialSupportManifestPath)) {
    return null;
  }
  return JSON.parse(fs.readFileSync(editorialSupportManifestPath, "utf8"));
}

function loadEditorialSupportRecords() {
  const manifest = loadEditorialSupportManifest();
  if (!manifest) {
    return [];
  }

  return (manifest.sourceShards ?? []).flatMap((relativePath) => {
    const shardPath = path.join(editorialSupportRoot, relativePath);
    const shard = JSON.parse(fs.readFileSync(shardPath, "utf8"));
    return (shard.pages ?? []).map((record) => ({
      ...record,
      sourceShard: relativePath,
    }));
  })
    .filter((record) => record.status === "approved")
    .sort((a, b) => a.phraseID.localeCompare(b.phraseID));
}

function editorialSupportPageID(record) {
  return `viet-family-${record.phraseID}`;
}

function editorialSupportPhraseOption(phraseID, detailPageID = null, tintName = null) {
  const phrase = phraseByID.get(phraseID);
  if (!phrase) {
    throw new Error(`Missing editorial support phrase in catalog: ${phraseID}`);
  }
  return phraseOption(phrase, detailPageID, tintName ?? tintForScenario(phrase.scenarioID));
}

function editorialSupportBreakdownTokens(record) {
  const chunks = [...(record.chunks ?? [])];
  const finalMatches = chunks.length > 0
    && normalizeAudioText(chunks[chunks.length - 1].vietnamese) === normalizeAudioText(record.targetText);
  if (!finalMatches) {
    chunks.push({
      id: `${record.phraseID}-full`,
      vietnamese: record.targetText,
      english: record.englishText,
    });
  }

  return chunks.map((chunk, index) => ({
    id: chunk.id ?? `${record.phraseID}-chunk-${index + 1}`,
    vietnamese: chunk.vietnamese,
    english: chunk.english,
    audioKey: authoredBreakdownAudioKey(chunk.vietnamese),
  }));
}

function editorialSupportOptions(phraseIDs, count = 4, excludingPageIDs = new Set()) {
  const options = [];
  for (const phraseID of phraseIDs ?? []) {
    const option = editorialSupportPhraseOption(phraseID, `viet-family-${phraseID}`);
    if (option.detailPageID && excludingPageIDs.has(option.detailPageID)) continue;
    options.push(option);
    if (options.length >= count) break;
  }
  return options;
}

function editorialSupportPageForRecord(record) {
  const phrase = phraseByID.get(record.phraseID);
  if (!phrase) {
    throw new Error(`Cannot build editorial support page ${record.phraseID}; missing catalog phrase`);
  }

  const pageID = editorialSupportPageID(record);
  const supportFamily = familyByID.get(record.familyID);
  const selfOption = editorialSupportPhraseOption(record.phraseID, null, record.tintName);
  const pageExclusions = new Set([pageID]);
  const relatedOptions = editorialSupportOptions(record.relatedPhraseIDs, 4, pageExclusions);
  const contrastOptions = editorialSupportOptions(record.contrastPhraseIDs ?? record.relatedPhraseIDs, 3, pageExclusions);
  const sections = [
    {
      id: "at-glance",
      title: "At a glance",
      body: record.atGlance,
    },
    {
      id: "quick-say",
      title: "Quick say",
      body: record.quickSay,
      phrases: [selfOption],
    },
    {
      id: "breakdown",
      title: "Break it down",
      body: record.breakdownBody,
      breakdown: editorialSupportBreakdownTokens(record),
    },
    {
      id: "use-it-with",
      title: record.useItWithTitle ?? "Use it with",
      body: record.useItWith,
      phrases: contrastOptions.length ? contrastOptions : relatedOptions,
    },
  ];

  const whenExclusions = linkedPageIDs(sections);
  whenExclusions.add(pageID);
  const whenOptions = editorialSupportOptions(record.relatedPhraseIDs, 4, whenExclusions);

  sections.push(
    {
      id: "when-to-use",
      title: "When to use it",
      body: record.whenToUse,
      phrases: whenOptions.length ? whenOptions : relatedOptions,
    },
    {
      id: "good-to-know",
      title: "Good to know",
      body: record.goodToKnow,
    }
  );

  const exploreExclusions = linkedPageIDs(sections);
  exploreExclusions.add(pageID);
  let exploreSupportOptions = editorialSupportOptions(record.explorePhraseIDs ?? record.relatedPhraseIDs, 6, exploreExclusions);
  if (exploreSupportOptions.length === 0 && supportFamily) {
    exploreSupportOptions = exploreOptions(supportFamily, 6, exploreExclusions);
  }

  sections.push(
    {
      id: "explore-next",
      title: "Explore next",
      body: record.exploreNextBody,
      phrases: exploreSupportOptions.length ? exploreSupportOptions : relatedOptions,
    }
  );

  return {
    id: pageID,
    familyID: record.familyID,
    phraseID: record.phraseID,
    tierRole: "editorial-model-support",
    depth: "deep",
    title: record.targetText,
    englishTitle: record.englishText,
    pronunciation: record.pronunciation,
    summary: record.englishText,
    iconName: record.iconName ?? symbolForScenario(record.scenarioID),
    tintName: record.tintName ?? tintForScenario(record.scenarioID),
    categoryIDs: Array.from(new Set([
      record.scenarioID,
      "editorial-model-support",
      record.supportModel ? `support-model-${record.supportModel}` : null,
      record.supportFamily ? `support-family-${record.supportFamily}` : null,
      `difficulty-${record.difficulty ?? "beginner"}`,
      ...(record.categoryIDs ?? []),
    ].filter(Boolean))),
    audioKey: authoredPhraseAudioKey(record.targetText, phrase.audioKey),
    editorialSupportMetadata: {
      taskID: record.taskID,
      supportModel: record.supportModel,
      supportFamily: record.supportFamily,
      requiredForPatchIDs: record.requiredForPatchIDs ?? [],
      sourceShard: record.sourceShard,
      rationale: record.rationale,
      stableFactSourceIDs: record.stableFactSourceIDs ?? [],
    },
    sections: withSectionPresentations(sections),
    examples: [selfOption],
  };
}

function loadEditorialSupportPages() {
  return loadEditorialSupportRecords().map(editorialSupportPageForRecord);
}

function collectAudioAudit(pages) {
  const required = [];
  const missing = [];
  const seen = new Set();

  function addAudio(ref) {
    if (!ref.audioKey) {
      if (ref.kind === "breakdown") {
        return;
      }

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

function cleanTravelerBody(body) {
  let text = String(body ?? "");
  const exactBodies = new Map([
    [
      "Read the cards left to right: first catch the request shape, then the place, item, action, or time detail, and finally the complete phrase.",
      "Play each piece, then the full phrase.",
    ],
    [
      "Go next to phrases that help you ask the price, check availability, or ask where to pay.",
      "Try these next when price, availability, or payment comes up.",
    ],
    [
      "Go next to phrases that help you ask about another nearby place, confirm the route, or move to a ride/drop-off phrase.",
      "Try these next when you need a nearby place, route, or ride.",
    ],
    [
      "Go next to phrases that help you learn the next phrase that keeps the same exchange moving.",
      "Try these next if the exchange moves one step further.",
    ],
    [
      "Go next to phrases that help you confirm the ingredient, adjust the order, or ask for a safer option.",
      "Try these next for ingredients, adjustments, or safer food choices.",
    ],
    [
      "Go next to phrases that help you practice the question that likely produced this reply.",
      "Try these next to practice the question behind this reply.",
    ],
    [
      "Learn the reusable place or food words, and keep proper names together when there is no simple reliable literal meaning.",
      "Keep proper names together; use literal pieces only when they help.",
    ],
  ]);
  if (exactBodies.has(text.trim())) return exactBodies.get(text.trim());

  text = text
    .replace(/\bPoint to the menu item, ingredient, or dish while you say it so staff can connect the words to the order\. Pause for the answer\./g, "Point to the dish or menu item, then pause.")
    .replace(/\bIf the answer is a number, ask them to type it or show it on a calculator before you pay\. Pause for the answer\./g, "Ask them to type or show the number before you pay.")
    .replace(/\bHold or point to the exact item while you say the phrase so the answer stays about one thing\. Pause for the answer\./g, "Point to the exact item, then pause.")
    .replace(/\bShow the destination before you speak; drivers and staff can then confirm, point, or correct the route\. Pause for the answer\./g, "Show the destination, then listen for the route or stop.")
    .replace(/\bShow the medicine, symptom note, or body area if you can; this keeps the exchange practical and safer\. Pause for the answer\./g, "Show the medicine, symptom note, or body area if you can.")
    .replace(/\bHave your phone screen open when you ask; it often explains the problem faster than extra words\. Pause for the answer\./g, "Keep your phone screen open.")
    .replace(/\bAdd your room number, key card, or booking screen after the phrase if staff need to act on it\. Pause for the answer\./g, "Keep the room number, key card, or booking visible.")
    .replace(/\bShow the object, address, or screen connected to the errand so the other person knows what to solve\. Pause for the answer\./g, "Show the object, address, or screen connected to the errand.")
    .replace(/\bUse the attraction name, ticket, or meeting-point screen as the starting point for the conversation\. Pause for the answer\./g, "Keep the attraction, ticket, or meeting-point screen visible.")
    .replace(/\bPair the phrase with a map pin or address so the answer can be a gesture, street name, or short route cue\. Pause for the answer\./g, "Keep the map pin or address visible.")
    .replace(/\bAirport staff often answer by pointing or naming a counter, so keep your passport, baggage tag, or pickup screen visible\. Pause for the answer\./g, "Keep your passport, baggage tag, or pickup screen visible.")
    .replace(/\bA calm tone matters as much as the words\. Short polite phrases keep the exchange warm without forcing a long conversation\./g, "A calm tone keeps short polite phrases warm.")
    .replace(/\bNumbers are easier to confirm visually\. Hold up the item or calculator and let the other person show the price\./g, "Let the price appear on a calculator, phone, or receipt.")
    .replace(/\bShort, concrete wording is helpful here because the answer is usually a point, a doorway, or a simple yes\/no\. Point clearly, then leave room for a short answer\./g, "Ask briefly, then watch for a point, doorway, or yes/no answer.")
    .replace(/\bFor directions, give the listener one clear reference point\. A map or address lets them point instead of explaining everything in fast Vietnamese\./g, "Keep one map point or address visible.")
    .replace(/\bThese phrases keep the exchange friendly when Vietnamese moves too fast\. Ask for one specific next step: repeat, write, show, or point\./g, "Ask for one next step: repeat, write, show, or point.")
    .replace(/\bPoint clearly, then leave room for a short answer\./g, "Pause for the answer.")
    .replace(/\bThis page focuses on durable language: ticket, entrance, caves or stairs, driver wait, and return ride\./g, "The durable phrases here cover tickets, entrances, caves or stairs, driver wait, and return ride.")
    .replace(/\bThis page avoids prices and current ticket rules\./g, "Prices and ticket rules can change.")
    .replace(/\bThis page only teaches the durable ticket request\./g, "This is the durable ticket request.")
    .replace(/\bPlace name plus ở đâu\b/g, "The name plus ở đâu")
    .replace(/\bname recognition for the attraction\b/g, "attraction name")
    .replace(/\bDừng ở keeps the request polite and clear\. Show the pin if the place has more than one entrance or side street\./g, "Show the pin if the place has more than one entrance or side street.")
    .replace(/\bTransport phrases work best with a visible destination\. Let the driver or staff point, confirm, or type a number\./g, "Keep the destination visible so the driver can confirm it.")
    .replace(/\bTreat the full name as one travel phrase\. If pronunciation feels hard, say it once and point to the map pin right away\./g, "Hear the full name, then keep the map pin visible.")
    .replace(/\bAdd your room number, key card, or booking screen after the phrase if staff need to act on it\. Point clearly, then leave room for a short answer\./g, "Keep the room number, key card, or booking screen visible.")
    .replace(/\bDirections in Vietnam are often answered with pointing plus a few words\. That is useful: watch the gesture first, then ask a follow-up if you need the street, floor, or entrance repeated\./g, "Watch the gesture first; ask again if you need the street, floor, or entrance repeated.")
    .replace(/\bShow the object, address, or screen connected to the errand so the other person knows what to solve\. Point clearly, then leave room for a short answer\./g, "Show the object, address, or screen connected to the errand.")
    .replace(/\bUse this before you move, pay, enter, board, sign, or choose\. It lets the other person confirm or correct the exact option you are showing\./g, "Ask before you move, pay, enter, board, sign, or choose.")
    .replace(/\bUse the attraction name, ticket, or meeting-point screen as the starting point for the conversation\. Point clearly, then leave room for a short answer\./g, "Keep the attraction, ticket, or meeting-point screen visible.")
    .replace(/\bPractice nearby phrases for nearby pages that change part of the reply or the next step while keeping the travel moment familiar\. This keeps practice tied to the real moment\./g, "Try nearby replies that move the exchange one step forward.")
    .replace(/\bPractice nearby phrases for nearby pages that change [^.]+ or the next step while keeping the travel moment familiar\. This keeps practice tied to the real moment\./g, "Try nearby phrases that move the exchange one step forward.")
    .replace(/\bPair the phrase with a map pin or address so the answer can be a gesture, street name, or short route cue\. Point clearly, then leave room for a short answer\./g, "Keep the map pin or address visible for a gesture or route cue.")
    .replace(/\bFor health and pharmacy phrases, short wording plus a visible note is kinder to both sides\. Let the staff ask one follow-up at a time\./g, "Keep symptoms short and let staff ask one follow-up at a time.")
    .replace(/\bAirport staff often answer by pointing or naming a counter, so keep your passport, baggage tag, or pickup screen visible\. Point clearly, then leave room for a short answer\./g, "Keep your passport, baggage tag, or pickup screen visible.")
    .replace(/\bNumbers are easier to trust when they are visible\. Ask the short phrase first, then invite a typed number, calculator screen, ticket, or written time if the answer comes too fast\./g, "Ask once, then let the number appear on a phone, calculator, ticket, or note.")
    .replace(/\bIt is short, so pair it with a map gesture or a food app screen\. The listener can point you toward nearby options\./g, "Pair it with a map gesture or food app screen.")
    .replace(/\bKeep the explanation simple and show the evidence if you can\. A short phrase plus a photo, receipt, or booking usually works better than adding more English\./g, "Keep the explanation short and show the photo, receipt, or booking.")
    .replace(/\bHotel staff can usually help faster when they can see the booking or room number\. Keep that visible after you say the phrase\./g, "Keep the booking or room number visible.")
    .replace(/\bKeep the confirmation, ticket, or date visible so the answer can be checked against it\. Point clearly, then leave room for a short answer\./g, "Keep the confirmation, ticket, or date visible.")
    .replace(/\bKeep this page durable and action-based\. Use the name, order, bill, and ride-back phrases; check current restaurant details separately if needed\./g, "Details can change. Keep the map or booking open, then rely on ordering, bill, and ride-back phrases.")
    .replace(/\bPoint to the menu item, ingredient, or dish while you say it so staff can connect the words to the order\. Point clearly, then leave room for a short answer\./g, "Point to the dish or menu item, then pause for the answer.")
    .replace(/\bIf the answer is a number, ask them to type it or show it on a calculator before you pay\. Point clearly, then leave room for a short answer\./g, "Ask them to type or show the number before you pay.")
    .replace(/\bHold or point to the exact item while you say the phrase so the answer stays about one thing\. Point clearly, then leave room for a short answer\./g, "Point to the exact item, then pause for the answer.")
    .replace(/\bShow the destination before you speak; drivers and staff can then confirm, point, or correct the route\. Point clearly, then leave room for a short answer\./g, "Show the destination, then listen for the route, stop, or correction.")
    .replace(/\bShow the medicine, symptom note, or body area if you can; this keeps the exchange practical and safer\. Point clearly, then leave room for a short answer\./g, "Show the medicine, symptom note, or body area if you can.")
    .replace(/\bHave your phone screen open when you ask; it often explains the problem faster than extra words\. Point clearly, then leave room for a short answer\./g, "Keep your phone screen open; it often explains the problem faster than extra words.")
    .replace(/\bThis phrase can sound warm when the request is small and your tone is calm\. A visible phone screen, receipt, or booking helps the other person answer without a long explanation\./g, "Keep the phone, receipt, or booking visible so the answer stays short.")
    .replace(/\bPractice nearby phrases for price questions for nearby things, so you can hear the item name and the number separately\. This keeps practice tied to the real moment\./g, "Try nearby price phrases so the item name and number stay separate.")
    .replace(/\bPractice nearby phrases for availability questions, so you can tell yes\/no answers from price or direction answers\. This keeps practice tied to the real moment\./g, "Try nearby availability phrases so yes/no answers are easier to hear.")
    .replace(/\bPractice nearby phrases for relationship-word swaps, which make the same request warmer or more respectful\. This keeps practice tied to the real moment\./g, "Try nearby relationship-word swaps when the request needs a warmer tone.")
    .replace(/\bPractice nearby phrases for nearby-place questions, so you can swap the destination without rebuilding the sentence\. This keeps practice tied to the real moment\./g, "Try nearby-place phrases when the destination changes.")
    .replace(/\bPractice nearby phrases for nearby pages that change stop or the next step while keeping the travel moment familiar\. This keeps practice tied to the real moment\./g, "Try nearby stop phrases when the next place changes.")
    .replace(/\bPractice nearby phrases for ride destinations, so the driver hears the destination as the important part\. This keeps practice tied to the real moment\./g, "Try nearby ride phrases when the destination changes.")
    .replace(/\bListen to each piece, then the whole phrase, so the rhythm feels connected instead of memorized word by word\./g, "Play each piece, then the full phrase.")
    .replace(/\bThis phrase is direct in a helpful way; warmth comes from your tone, pointing clearly, and giving the other person room to answer\./g, "Point clearly, then leave room for a short answer.")
    .replace(/\bThis keeps the lesson practical for [^.]+\./g, "This keeps practice tied to the real moment.")
    .replace(/\bFor travelers,\s*/g, "")
    .replace(/\bwhen the traveler needs\b/gi, "when you need")
    .replace(/\bwhen a traveler needs\b/gi, "when you need")
    .replace(/\bthe traveler needs\b/gi, "you need")
    .replace(/\bthe user needs\b/gi, "you need")
    .replace(/\bThis is the traveler version of\b/gi, "This is the travel version of")
    .replace(/\btraveler version of\b/gi, "travel version of")
    .replace(/\bis the phrase to keep ready for\b/g, "helps with")
    .replace(/\bIt works best when you focus on [^.]+\./g, "")
    .replace(/\bthe next detail you need resolved\b/g, "the next thing you need")
    .replace(/\bUse this page before you visit\b/g, "Use this before you visit")
    .replace(/\bUse this page\b/g, "Use this")
    .replace(/\bwhere-question\b/g, "question")
    .replace(/\bWhere-questions\b/g, "Questions")
    .replace(/\bwhere-questions\b/g, "questions")
    .replace(/\bQuestions should include likely replies and recovery phrases, not just the sentence\./g, "Keep nearby direction and recovery phrases close.")
    .replace(/\broute phrase\b/g, "travel phrase")
    .replace(/\buseful moments\b/g, "helpful steps")
    .replace(/\bdurable next steps\b/g, "next steps")
    .replace(/\bcontent role\b/g, "travel use")
    .replace(/\bpage kind\b/g, "page type")
    .replace(/\brelationship rows\b/g, "related phrases")
    .replace(/\bconnect to\b/g, "match to")
    .replace(/\bconnect it to\b/g, "match it to")
    .replace(/\bcity place anchor keeps the answer local\b/g, "nearby stop keeps the answer local")
    .replace(/\bcity anchor\b/g, "nearby stop")
    .replace(/\broute anchor\b/g, "route reference")
    .replace(/\bdestination anchor\b/g, "destination")
    .replace(/\bconversation anchor\b/g, "starting point")
    .replace(/\banchor for the conversation\b/g, "starting point for the conversation")
    .replace(/\banchors the dish to\b/g, "keeps the dish tied to")
    .replace(/\banchor rows\b/g, "main rows")
    .replace(/\banchor word\b/g, "main word")
    .replace(/\banchoring\b/g, "tying")
    .replace(/\banchors\b/g, "reference points")
    .replace(/\banchor\b/g, "reference point")
    .replace(/\bthe place name\b/g, "the map pin")
    .replace(/\bplace name\b/g, "name")
    .replace(/\bGo next to phrases that help you\b/g, "Try these next to")
    .replace(/\bPractice it beside these related pages to hear\b/g, "Practice nearby phrases for")
    .replace(/\bTreat the rest as name recognition\b/g, "Keep the proper name together")
    .replace(/\bLearn the reusable place or food words\b/g, "Learn the useful words")
    .replace(/\s{2,}/g, " ")
    .trim();

  return text;
}

function authoredPageProfile(page) {
  const meta = page.cityMetadata || {};
  const pageKind = meta.pageKind || "";
  const placeKind = meta.placeKind || "";
  if (pageKind === "phrase" && meta.derivedPlacePhrase) return "derived-place-phrase";
  if (pageKind === "restaurant") return "restaurant";
  if (isCityDishLikePageKind(pageKind)) return "dish";
  if (pageKind === "place" && placeKind === "street") return "street";
  if (pageKind === "place") return "place";
  if (!pageKind && /\bđường\b/i.test(page.title || "")) return "street";
  return "phrase";
}

function phraseRoleForPage(page, profile) {
  if (profile === "derived-place-phrase") return "derived_place_question";
  if (isNameBasedProfile(profile)) return "name_only";

  const summary = String(page.summary || "");
  if (/something you may hear back/i.test(summary)) {
    return "traveler_may_hear";
  }

  return "traveler_says";
}

function isNameBasedProfile(profile) {
  return ["place", "restaurant", "dish", "street"].includes(profile);
}

function preservesHandwrittenCityEditorial(page) {
  return page.tierRole === "city-v1"
    && page.cityMetadata?.editorialReviewStatus === "handwritten-reviewed";
}

function preservesHandwrittenPhraseEditorial(page) {
  return [
    "tier1",
    "child",
    "catalog-promoted",
    "editorial-model-support",
  ].includes(page.tierRole);
}

const xinChaoFlagshipRuntimeSectionIDs = new Set([
  "at-glance",
  "breakdown",
  "good-to-know",
  "explore-next",
]);

function usesXinChaoFlagshipRuntimeContract(page) {
  return page?.familyID === "polite-hello" || page?.id === "viet-polite-hello";
}

function authoredCitySectionBody(page, sectionID) {
  const body = cleanTravelerBody((page.sections || []).find((section) => section.id === sectionID)?.body || "");
  if (!body) return "";
  if (/^(say it slowly|show the restaurant|start with the dish name|map, arrival|first-ordering sentences|short spice|ingredient, allergy)/i.test(body)) return "";
  if (/^(direction, ticket|use the place name with|ticket, entrance|pickup areas can be split)/i.test(body)) return "";
  return body;
}

function isGenericNameAboutBody(body, page, profile) {
  const text = normalizeAudioText(body || "");
  const title = normalizeAudioText(page.title || "");
  const english = normalizeAudioText(page.englishTitle || page.summary || "");
  const city = normalizeAudioText(page.cityMetadata?.cityShortTitle || page.cityMetadata?.cityName || "");
  if (!text || !title) return true;
  if (profile === "restaurant" && text === normalizeAudioText(`${page.title || ""} is a restaurant${city ? ` in ${page.cityMetadata?.cityShortTitle || page.cityMetadata?.cityName}` : ""}.`)) return true;
  if (profile === "dish" && text === normalizeAudioText(`${page.title || ""} is a local dish${city ? ` in ${page.cityMetadata?.cityShortTitle || page.cityMetadata?.cityName}` : ""}.`)) return true;
  if (text === normalizeAudioText(`${page.title || ""} is ${page.englishTitle || page.summary || ""}${city ? ` in ${page.cityMetadata?.cityShortTitle || page.cityMetadata?.cityName}` : ""}.`)) return true;
  if (text === normalizeAudioText(`${page.title || ""} means ${page.englishTitle || page.summary || ""}.`)) return true;
  return Boolean(english && text === english);
}

function authoredCityAboutBody(page, profile) {
  const atGlance = authoredCitySectionBody(page, "at-glance");
  if (atGlance && !isGenericNameAboutBody(atGlance, page, profile)) return atGlance;

  const summary = cleanTravelerBody(page.summary || "");
  if (summary && !isGenericNameAboutBody(summary, page, profile)) return summary;
  return "";
}

function adultNameAboutBody(page, profile) {
  const meta = page.cityMetadata || {};
  const city = meta.cityShortTitle || meta.cityName || "";
  const where = city ? ` in ${city}` : "";
  const title = page.title || page.vietnamese || "";
  const english = page.englishTitle || page.summary || "";
  const authoredBody = authoredCityAboutBody(page, profile);
  if (authoredBody) return authoredBody;

  if (/bà nà hills/i.test(title)) {
    return "Bà Nà Hills is a mountain resort and day-trip attraction outside Da Nang, known for the cable car and Golden Bridge.";
  }
  if (/cầu rồng/i.test(title)) {
    return "Cầu Rồng is Dragon Bridge in Vietnamese, literally “dragon bridge.” It is one of Da Nang’s main river landmarks.";
  }
  if (/ngũ hành sơn/i.test(title)) {
    return "Ngũ Hành Sơn is Marble Mountains in Vietnamese, a landmark area of limestone hills, caves, and pagodas near Da Nang.";
  }
  if (/sơn trà|bán đảo sơn trà/i.test(title)) {
    return "Bán đảo Sơn Trà is Son Tra Peninsula in Vietnamese, a coastal nature area north of Da Nang.";
  }
  if (profile === "street") {
    return `${title} means ${english}.`;
  }
  if (profile === "restaurant") {
    if (/bún chả hương liên/i.test(title)) {
      return "Bún chả Hương Liên is a Hanoi restaurant known for bún chả: grilled pork, noodles, herbs, and dipping sauce.";
    }
    if (/phở bát đàn/i.test(title)) {
      return "Phở Bát Đàn is a Hanoi pho restaurant.";
    }
    return `${title} is a restaurant${where}.`;
  }
  if (profile === "dish") {
    if (/bún bò huế/i.test(title)) {
      return "Bún bò Huế is a spicy beef noodle soup from Huế.";
    }
    if (/cao lầu/i.test(title)) {
      return "Cao lầu is a Hội An noodle dish with pork, herbs, broth, and chewy noodles.";
    }
    return `${title} is a local dish${where}.`;
  }
  const placeKind = meta.placeKind || "";
  if (["airport", "station", "port"].includes(placeKind)) {
    return `${title} is ${english}.`;
  }
  return `${title} is ${english}${where}.`;
}

function adultNameGoodToKnow(page, profile) {
  const title = `${page.title || ""} ${page.englishTitle || ""}`;
  const placeKind = page.cityMetadata?.placeKind || "";
  if (/bà nà hills/i.test(title)) {
    return "Ticket rules, hours, and pickup details can change. Keep your ticket or booking screen visible, and confirm the return pickup point.";
  }
  if (/cầu rồng/i.test(title)) {
    return "For pickup, confirm which side of the bridge or nearby landmark is easiest to meet at.";
  }
  if (profile === "street") {
    return "Full sentences are usually easier for drivers than spelling the street name.";
  }
  if (profile === "restaurant") {
    return "Details can change. Keep the map pin or booking screen handy.";
  }
  if (profile === "dish") {
    return "Ask about ingredients before ordering if you avoid pork, beef, seafood, peanuts, or spice.";
  }
  if (["airport", "station", "port"].includes(placeKind)) {
    return "Pickup areas can be split by terminal or lane. Keep your flight or booking screen visible.";
  }
  return cleanTravelerBody(page.sections?.find((section) => section.id === "good-to-know")?.body || "");
}

function adultNameSectionBody(page, section, profile) {
  const sectionBodyByID = {
    "journey-flow": "Pickup → Tickets → Cable car → Photos → Food/drinks → Return ride",
    "key-phrases": "",
    "getting-there": "",
    "at-the-bridge": "",
    "pickup-nearby": "",
    "show-driver": "",
    confirm: "",
    "drop-off": "",
    "wrong-place": "",
    "before-you-go": "",
    "menu-dietary": "",
    "inside-the-place": "",
    "how-to-order": "",
    "ingredients-diet": "",
  };
  if (Object.prototype.hasOwnProperty.call(sectionBodyByID, section.id)) return sectionBodyByID[section.id];

  switch (section.id) {
    case "at-glance":
      return adultNameAboutBody(page, profile);
    case "quick-say":
      return "";
    case "breakdown":
      return "";
    case "place-brief":
    case "use-it-with":
    case "when-to-use":
      return "";
    case "good-to-know":
      return adultNameGoodToKnow(page, profile);
    case "explore-next":
      return "";
    default:
      return cleanTravelerBody(section.body);
  }
}

function cleanTravelerBreakdownGloss(gloss, page, vietnamese = "") {
  const exactVietnamese = String(vietnamese ?? "").normalize("NFC").trim().toLowerCase();
  if (exactRawBreakdownMeanings.has(exactVietnamese)) {
    return exactRawBreakdownMeanings.get(exactVietnamese);
  }

  const text = String(gloss ?? "").trim();
  if (page.cityMetadata?.derivedPlacePhrase && /^(local name|place name|proper name|name recognition)$/i.test(text)) return "name";
  if (/^full phrase$/i.test(text)) return page.englishTitle || page.summary || "whole phrase";
  if (/^key word$/i.test(text)) return "key word to hear";
  if (/^first name part$/i.test(text) || /^second name part$/i.test(text)) return "local name";
  if (/^street name to keep together$/i.test(text)) return "name to keep together";
  if (/^question ending$/i.test(text)) return "asks yes or no";
  if (/^restaurant name recognition$/i.test(text) || /^restaurant name ending$/i.test(text)) return "restaurant name";
  if (/^dish name recognition$/i.test(text) || /^dish name ending$/i.test(text)) return "dish name";
  if (/^name recognition for the attraction$/i.test(text)) return "attraction name";
  if (/^name recognition$/i.test(text) || /^name ending$/i.test(text) || /^local place$/i.test(text)) return "local name";
  return cleanTravelerBody(text);
}

function cleanTravelerSectionTitle(title, page) {
  const profile = authoredPageProfile(page);
  if (profile === "derived-place-phrase") {
    const byID = {
      breakdown: "Break it down",
      "related-phrases": "Related phrases",
      "good-to-know": "Tip",
    };
    const sectionIDTitle = byID[page.__currentSectionID];
    if (sectionIDTitle) return sectionIDTitle;
  }
  if (isNameBasedProfile(profile)) {
    const contentRole = page.cityMetadata?.contentRole || "";
    const hearTitle = profile === "street"
      ? "Hear the street"
      : profile === "dish" && contentRole === "drink" ? "Hear the drink"
      : profile === "dish" && contentRole === "dessert" ? "Hear the dessert"
      : profile === "dish" ? "Hear the dish"
      : "Hear the name";
    const byID = {
      "at-glance": "About",
      "quick-say": hearTitle,
      "breakdown": profile === "restaurant" ? "Name guide" : "What the name means",
      "journey-flow": "Visit flow",
      "key-phrases": "Common phrases",
      "show-driver": profile === "street" ? "Tell the driver" : "Show driver",
      "place-brief": "What to picture",
      "table-menu": "Table & menu",
      "before-you-go": profile === "restaurant" ? "Order" : "Before you go",
      "menu-dietary": profile === "restaurant" ? "Drinks" : "Ingredients and diet",
      "inside-the-place": profile === "restaurant" ? "Getting back" : "At the place",
      "how-to-order": profile === "dish" ? "Adjust it" : "How to order",
      "ingredients-diet": "Diet / allergy",
      "use-it-with": "Why it belongs",
      "when-to-use": "Trip cues",
      "explore-next": `More ${page.title || "place"} phrases`,
    };
    const sectionIDTitle = byID[page.__currentSectionID];
    if (sectionIDTitle) return sectionIDTitle;
  }
  const sectionID = page.__currentSectionID;
  if (page.__phraseRole === "traveler_may_hear") {
    const mayHearTitles = {
      "at-glance": "You may hear",
      "practice-pairs": isTableAvailabilityReplyPage(page) ? "Say next" : "Related replies",
      "nearby-phrases": "Related phrases",
      "explore-next": "Related phrases",
      "good-to-know": "Good to know",
    };
    if (mayHearTitles[sectionID]) return mayHearTitles[sectionID];
  }
  const genericByID = {
    "at-glance": "Meaning",
    "quick-say": "Say this",
    "standard-way": "Say this",
    "natural-variations": "Other ways",
    "traveler-insight": "Common follow-ups",
    "what-happens-next": "Common follow-ups",
    "you-may-hear": "Common follow-ups",
    "practice-pairs": phrasePracticePairsTitle(page),
    "nearby-phrases": phraseNearbyTitle(page),
    "explore-next": phraseNearbyTitle(page),
    "when-to-use": "Good to know",
  };
  if (genericByID[sectionID]) return genericByID[sectionID];
  const legacyProfile = page.cityMetadata?.pageKind || page.cityMetadata?.placeKind || "";
  if (/^Use it with$/i.test(title)) return "Show with it";
  if (/^When to use it$/i.test(title) && /place|restaurant|dish|landmark|street|airport|station|port|market|beach/i.test(legacyProfile)) {
    return "When it helps";
  }
  if (/^Place anchor$/i.test(title)) return "Show with it";
  if (/^Place brief$/i.test(title)) return "Start here";
  return title;
}

function optionMatchesPageName(option, page) {
  const text = normalizeAudioText(`${option?.vietnamese ?? ""} ${option?.english ?? ""}`);
  const title = normalizeAudioText(page.title ?? "");
  const english = normalizeAudioText(page.englishTitle ?? "");
  return (title && text.includes(title)) || (english && text.includes(english));
}

function withoutGenericNearbyOptions(options) {
  return (options || []).filter((option) => !/\batm\b|có atm|eat near|ăn gần/i.test(`${option.english ?? ""} ${option.vietnamese ?? ""}`));
}

function curatedNameSectionPhrases(page, section, profile) {
  const existing = section.phrases || [];
  if (section.id === "quick-say") {
    if (normalizeAudioText(section.title || "") === "useful phrases" && existing.length > 0) {
      return compactPhraseOptions(existing, 6);
    }
    const self = selfPhraseOptionForPage(page);
    return self ? [self] : existing.slice(0, 1);
  }
  if (profile === "restaurant" && preservesHandwrittenCityEditorial(page)) {
    return compactPhraseOptions(existing, 6);
  }
  if (/bà nà hills/i.test(`${page.title || ""} ${page.englishTitle || ""}`) && section.id === "journey-flow") {
    return [];
  }
  if (profile === "restaurant") {
    if (section.id === "place-brief") {
      const placeRows = withoutGenericNearbyOptions(existing).filter((option) => optionMatchesPageName(option, page));
      return compactPhraseOptions(placeRows, 4);
    }
    if (section.id === "before-you-go") {
      return compactPhraseOptions([
        specificFoodOrderOptionForText(`${page.title ?? ""} ${page.englishTitle ?? ""}`),
        phraseOptionByID("v900-food-drin-what-do-you-recommend", "green"),
      ], 4);
    }
    if (section.id === "table-menu") {
      return compactPhraseOptions([
        phraseOptionByID("food-need-table", "green"),
        phraseOptionByID("food-menu", "green"),
      ], 4);
    }
    if (section.id === "menu-dietary") {
      return compactPhraseOptions([
        phraseOptionByID("store-1", "green"),
        phraseOptionByID("coffee-2", "green"),
        phraseOptionByID("coffee-5", "green"),
      ], 3);
    }
    if (section.id === "when-to-use") {
      return compactPhraseOptions([
        phraseOptionByID("coffee-7", "green"),
        phraseOptionByID("store-6", "green"),
        phraseOptionByID("taxi-7", "green"),
        phraseOptionByID("store-7", "green"),
      ], 4);
    }
    if (section.id === "inside-the-place") {
      return compactPhraseOptions([
        phraseOptionByID("ves-call-taxi-for-me", "orange"),
      ], 3);
    }
  }

  if (profile === "dish") {
    if (section.id === "place-brief" || section.id === "how-to-order") {
      const base = section.id === "place-brief" ? [
        specificFoodOrderOptionForText(`${page.title ?? ""} ${page.englishTitle ?? ""}`),
        phraseOptionByID("food-1", "green"),
      ] : [
        phraseOptionByID("food-3", "green"),
        phraseOptionByID("ves-not-too-spicy", "green"),
      ];
      return compactPhraseOptions(base, 4);
    }
    if (section.id === "ingredients-diet") {
      return compactPhraseOptions([
        phraseOptionByID("ves-whats-in-this-dish", "green"),
        phraseOptionByID("food-peanut-allergy", "red"),
        phraseOptionByID("food-vegetarian", "green"),
        phraseOptionByID("v900-food-drin-i-do-not-eat-beef", "green"),
        phraseOptionByID("v900-food-drin-i-do-not-eat-pork", "green"),
        phraseOptionByID("v900-food-drin-i-do-not-eat-seafood", "green"),
      ], 6);
    }
    if (section.id === "when-to-use") {
      return [];
    }
  }

  return existing;
}

function curatedSectionPhrases(page, section, profile, phraseRole = "traveler_says") {
  if (phraseRole === "traveler_may_hear") {
    if (isDoctorComingPage(page)) {
      if (section.id === "practice-pairs") {
        return doctorComingSupportOptions(3);
      }
      if (section.id === "nearby-phrases" || section.id === "explore-next") {
        return doctorComingSupportOptions(5);
      }
    }
    if (isTableAvailabilityReplyPage(page)) {
      if (section.id === "practice-pairs" || section.id === "nearby-phrases") {
        return tableAvailabilityNextPhrases();
      }
      if (section.id === "explore-next") {
        return [];
      }
    }
    const laneOptions = mayHearLaneSupportOptions(page, section.id);
    if (laneOptions) {
      return laneOptions;
    }
    return withoutUnrelatedMayHearOptions(section.phrases || []);
  }
  if (profile === "phrase" && isIngredientQuestionPage(page)) {
    if (section.id === "practice-pairs" || section.id === "nearby-phrases" || section.id === "explore-next") {
      const options = ingredientQuestionOptions(section.id === "practice-pairs" ? 4 : 8)
        .filter((option) => normalizeAudioText(option.vietnamese) !== normalizeAudioText(page.title || ""));
      return compactPhraseOptions(options, section.id === "practice-pairs" ? 3 : 6);
    }
  }
  if (profile === "phrase" && isTaxiRideHelpPage(page)) {
    if (section.id === "practice-pairs" || section.id === "nearby-phrases" || section.id === "explore-next") {
      const options = taxiRideHelpOptions(section.id === "practice-pairs" ? 4 : 8)
        .filter((option) => normalizeAudioText(option.vietnamese) !== normalizeAudioText(page.title || ""));
      return compactPhraseOptions(options, section.id === "practice-pairs" ? 3 : 6);
    }
  }
  return curatedNameSectionPhrases(page, section, profile);
}

function curatedSectionBreakdown(page, section) {
  if (section.id === "breakdown" && isTableAvailabilityReplyPage(page)) {
    return [
      { id: "ban-nay-con-trong-table", vietnamese: "Bàn", english: "table", audioKey: authoredBreakdownAudioKey("Bàn") },
      { id: "ban-nay-con-trong-this", vietnamese: "này", english: "this", audioKey: authoredBreakdownAudioKey("này") },
      { id: "ban-nay-con-trong-available", vietnamese: "còn trống", english: "still available / open", audioKey: authoredBreakdownAudioKey("còn trống") },
      { id: "ban-nay-con-trong-full", vietnamese: "Bàn này còn trống", english: "This table is available", audioKey: authoredPhraseAudioKey("Bàn này còn trống", null) },
    ];
  }
  return section.breakdown || [];
}

function withoutUnrelatedMayHearOptions(options) {
  return (options || []).filter((option) => {
    const text = normalizeAudioText(`${option.vietnamese ?? ""} ${option.english ?? ""}`);
    return !/(doctor|bac si|room|phong|pork|thit heo|peanuts|dau phong|spicy|cay|cash only|chi nhan tien mat)/i.test(text);
  });
}

function mayHearLaneSupportOptions(page, sectionID) {
  const titleKey = normalizedVietnameseKey(page.title || "");
  const categoryIDs = new Set(page.categoryIDs || []);
  const limit = sectionID === "practice-pairs" ? 3 : 6;
  const optionIDs = (() => {
    if (titleKey === "chi nhan tien mat") {
      return [
        "taxi-7",
        "store-6",
        "store-7",
        "airport-4",
        "v500-mone-numb-pric-where-can-i-exchange-money",
      ];
    }
    if (titleKey === "cong doi roi") {
      return [
        "v500-airp-bord-arri-where-is-gate-10",
        "v900-airp-bord-arri-where-is-the-departure-hall",
        "v900-airp-bord-arri-i-think-i-went-to-the-wrong-terminal",
      ];
    }
    if (titleKey === "co phong khac") {
      return [
        "hotel-quiet-room",
        "hotel-1",
        "hotel-8",
        "hotel-9",
      ];
    }
    if (titleKey === "dua ho chieu ra") {
      return [
        "v500-airp-bord-arri-here-is-my-passport",
        "v500-airp-bord-arri-here-is-my-visa",
        "v500-airp-bord-arri-where-do-i-sign",
        "airport-pickup-clearer",
      ];
    }
    if (titleKey === "cho mot chut" || titleKey === "doi o day") {
      return [
        "polite-6",
        "taxi-6",
        "directions-8",
        "v500-tran-please-wait-here",
      ];
    }
    if (categoryIDs.has("food-drink")) {
      return [
        "ves-whats-in-this-dish",
        "v900-food-drin-does-this-contain-fish-sauce",
        "v500-food-drin-does-this-contain-shrimp",
        "food-premium-has-peanuts",
        "food-vegetarian",
      ];
    }
    if (categoryIDs.has("hotel-accommodation")) {
      return [
        "hotel-1",
        "hotel-quiet-room",
        "hotel-8",
        "hotel-9",
      ];
    }
    if (categoryIDs.has("airport-border-arrival")) {
      return [
        "airport-2",
        "airport-5",
        "v500-airp-bord-arri-here-is-my-passport",
        "airport-pickup-clearer",
      ];
    }
    return null;
  })();

  if (!optionIDs) return null;
  if (!["practice-pairs", "nearby-phrases", "explore-next"].includes(sectionID)) return null;
  return compactPhraseOptions(optionIDs.map((phraseID) => phraseOptionByID(phraseID, "teal")), limit);
}

function selfPhraseOptionForPage(page) {
  if (page?.phraseID && phraseByID.has(page.phraseID)) {
    return catalogPhraseOption(page.phraseID, null, page.cityMetadata?.placeKind === "street" ? "blue" : null);
  }
  const title = normalizeAudioText(page?.title || "");
  const english = normalizeAudioText(page?.englishTitle || page?.summary || "");
  for (const section of page?.sections || []) {
    for (const option of section.phrases || []) {
      if (optionMatchesPageName(option, page) || normalizeAudioText(option.vietnamese) === title || normalizeAudioText(option.english) === english) {
        return { ...option, detailPageID: null };
      }
    }
  }
  return null;
}

function phraseContextSentence(page) {
  const title = page.title || "";
  const english = page.englishTitle || page.summary || "";
  if (normalizedVietnameseKey(title) === "toi khong hieu") {
    return "A simple recovery phrase for when Vietnamese is too fast or unclear.";
  }
  const summary = cleanTravelerBody(page.summary || "");
  if (
    summary
    && summary !== english
    && summary.length <= 130
    && !/notes below|likely replies|next steps|the user|without turning/i.test(summary)
    && !/^(yes|no|thank you|hello|goodbye)$/i.test(summary)
  ) {
    return summary;
  }
  if (title && english) return cleanFinalPunctuation(`${title} means “${english}”.`);
  return summary || english || "";
}

function isTableAvailabilityReplyPage(page) {
  return normalizedVietnameseKey(page.title || "") === "ban nay con trong";
}

function isIngredientQuestionPage(page) {
  const id = String(page.phraseID || page.familyID || page.id || "");
  const english = String(page.englishTitle || page.summary || "");
  return /does (this|it) (have|contain)\b/i.test(english) || id.includes("food-has");
}

function isTaxiRideHelpPage(page) {
  const text = normalizeAudioText([
    page.phraseID,
    page.familyID,
    page.id,
    page.title,
    page.englishTitle,
  ].filter(Boolean).join(" "));
  return /(goi taxi|call a taxi|goi xe cong nghe|ride share|pickup point|diem don|drop me off)/i.test(text);
}

function isDoctorComingPage(page) {
  return normalizedVietnameseKey(page.title || "") === "bac si dang den";
}

function isCashOnlyPage(page) {
  return normalizedVietnameseKey(page.title || "") === "chi nhan tien mat";
}

function isGateChangedPage(page) {
  return normalizedVietnameseKey(page.title || "") === "cong doi roi";
}

function mayHearContextSentence(page) {
  if (isTableAvailabilityReplyPage(page)) {
    return "Staff may use this when a table is open.";
  }
  return "Listen for this as a short answer.";
}

function tableAvailabilityNextPhrases() {
  return compactPhraseOptions([
    phraseOptionByID("food-need-table", "green"),
    phraseOptionByID("v900-food-drin-is-there-a-wait-for-a-table", "green"),
    phraseOptionByID("food-menu", "green"),
    phraseOptionByID("coffee-7", "green"),
  ], 4);
}

function ingredientQuestionOptions(limit = 8) {
  return compactPhraseOptions([
    phraseOptionByID("food-premium-has-peanuts", "green"),
    phraseOptionByID("v500-food-drin-does-this-contain-shrimp", "green"),
    phraseOptionByID("v900-food-drin-does-this-contain-fish-sauce", "green"),
    phraseOptionByID("food-15", "green"),
    phraseOptionByID("food-vegetarian", "green"),
    phraseOptionByID("food-peanut-allergy", "red"),
  ], limit);
}

function taxiRideHelpOptions(limit = 7) {
  return compactPhraseOptions([
    phraseOptionByID("ves-call-taxi-for-me", "orange"),
    phraseOptionByID("v900-tran-please-take-me-to-this-address", "green"),
    phraseOptionByID("directions-8", "green"),
    phraseOptionByID("v900-dire-navi-is-this-the-correct-pickup-point", "green"),
    phraseOptionByID("ves-drop-me-off-here", "green"),
    phraseOptionByID("v500-tran-please-call-the-driver", "green"),
    phraseOptionByID("v900-phon-inte-powe-can-you-help-me-book-a-grab", "orange"),
    phraseOptionByID("v500-unde-repa-can-you-write-the-address", "teal"),
  ], limit);
}

function doctorComingSupportOptions(limit = 6) {
  return compactPhraseOptions([
    phraseOptionByID("problems-6", "red"),
    phraseOptionByID("health-2", "red"),
    phraseOptionByID("health-3", "red"),
    phraseOptionByID("v900-emer-safe-please-call-emergency-services", "red"),
    phraseOptionByID("help-need-help-direct", "red"),
    phraseOptionByID("polite-2", "green"),
  ], limit);
}

function phrasePracticePairsTitle(page) {
  if (isIngredientQuestionPage(page)) return "Other ingredients";
  if (isTaxiRideHelpPage(page)) return "Getting a ride";
  return "Common follow-ups";
}

function phraseNearbyTitle(page) {
  if (isIngredientQuestionPage(page)) return "More ingredient questions";
  if (isTaxiRideHelpPage(page)) return "More ride phrases";
  return "Next phrases";
}

function isSelfOnlyHeroRepeatSection(section, page) {
  if (!["quick-say", "standard-way"].includes(section.id)) return false;
  const phrases = section.phrases || [];
  if (phrases.length !== 1) return false;
  const phrase = phrases[0];
  return normalizeAudioText(phrase.vietnamese) === normalizeAudioText(page.title)
    && normalizeAudioText(phrase.english) === normalizeAudioText(page.englishTitle);
}

function isHeroMeaningRepeatSection(section, page) {
  if (section.id !== "at-glance") return false;
  if ((section.phrases || []).length > 0 || (section.breakdown || []).length > 0) return false;

  const body = normalizeAudioText(section.body || "");
  const title = normalizeAudioText(page.title || "");
  const english = normalizeAudioText(page.englishTitle || page.summary || "");
  if (!body || !english) return false;
  if (body === english) return true;
  return title && body.startsWith(`${title} means `) && body.includes(english);
}

function isHeroRepeatSectionForGeneratedPage(section, page) {
  return isSelfOnlyHeroRepeatSection(section, page) || isHeroMeaningRepeatSection(section, page);
}

function phraseSectionBody(page, section, phraseRole = "traveler_says") {
  const title = page.title || "";
  const english = page.englishTitle || page.summary || "";
  if (phraseRole === "traveler_may_hear") {
    switch (section.id) {
      case "at-glance":
        return mayHearContextSentence(page);
      case "good-to-know":
        if (isCashOnlyPage(page)) {
          return "If cards are not accepted, ask for the nearest ATM or pay in cash.";
        }
        if (isGateChangedPage(page)) {
          return "Check the screen again and ask staff to confirm the new gate.";
        }
        if (isTableAvailabilityReplyPage(page)) {
          return "To ask first, use the question form: “Bàn này còn trống không?”";
        }
        if (isDoctorComingPage(page)) {
          return "Stay nearby and keep your phone visible. They may ask where you are or what happened.";
        }
        return cleanTravelerBody(section.body);
      case "breakdown":
      case "practice-pairs":
      case "nearby-phrases":
      case "explore-next":
        return "";
      default:
        return cleanTravelerBody(section.body);
    }
  }
  switch (section.id) {
    case "at-glance":
      return phraseContextSentence(page);
    case "quick-say":
    case "standard-way":
      return title && english ? sentence(`${title} — ${english}`) : "";
    case "breakdown":
      return "";
    case "natural-variations":
      return "";
    case "traveler-insight":
    case "what-happens-next":
    case "you-may-hear":
      return "";
    case "practice-pairs":
      return "";
    case "nearby-phrases":
    case "explore-next":
      return "";
    case "good-to-know":
    case "local-tip":
      return cleanTravelerBody(section.body);
    default:
      return cleanTravelerBody(section.body);
  }
}

function shouldKeepSectionForProfile(section, profile, page = null, phraseRole = "traveler_says") {
  const hasRows = (section.phrases || []).length > 0;
  const hasBreakdown = (section.breakdown || []).length > 0;
  if (profile === "derived-place-phrase") {
    if (section.id === "breakdown") return hasBreakdown;
    if (section.id === "related-phrases") return hasRows;
    if (section.id === "good-to-know") return String(section.body ?? "").trim().length > 0;
    return false;
  }
  if (isNameBasedProfile(profile)) {
    const keepByProfile = {
      place: new Set(["at-glance", "quick-say", "journey-flow", "key-phrases", "getting-there", "tickets", "cable-car", "photos", "getting-back", "food-cash", "at-the-bridge", "pickup-nearby", "place-brief", "use-it-with", "when-to-use", "breakdown", "good-to-know", "explore-next"]),
      street: new Set(["at-glance", "quick-say", "show-driver", "place-brief", "confirm", "use-it-with", "wrong-place", "when-to-use", "breakdown", "good-to-know", "explore-next"]),
      restaurant: new Set(["at-glance", "quick-say", "place-brief", "use-it-with", "table-menu", "before-you-go", "menu-dietary", "when-to-use", "inside-the-place", "pay-and-leave", "breakdown", "good-to-know"]),
      dish: new Set(["at-glance", "quick-say", "place-brief", "use-it-with", "when-to-use", "how-to-order", "ingredients-diet", "breakdown", "good-to-know"]),
    };
    return (keepByProfile[profile] || keepByProfile.place).has(section.id);
  }

  if (profile === "phrase" && phraseRole === "traveler_says" && preservesHandwrittenPhraseEditorial(page)) {
    if (usesXinChaoFlagshipRuntimeContract(page) && !xinChaoFlagshipRuntimeSectionIDs.has(section.id)) {
      return false;
    }
    if (section.id === "breakdown") return hasBreakdown;
    return sectionHasTravelerContent(section);
  }

  if (profile === "phrase" && phraseRole === "traveler_says" && isHeroRepeatSectionForGeneratedPage(section, page)) {
    return false;
  }

  if (phraseRole === "traveler_may_hear") {
    const keepIDs = new Set([
      "at-glance",
      "breakdown",
      "practice-pairs",
      "nearby-phrases",
      "explore-next",
      "good-to-know",
    ]);
    if (!keepIDs.has(section.id)) return false;
    if (section.id === "breakdown") return hasBreakdown;
    if (["practice-pairs", "nearby-phrases", "explore-next"].includes(section.id)) {
      if (page && isTableAvailabilityReplyPage(page) && section.id === "explore-next") return false;
      return hasRows || (page && isTableAvailabilityReplyPage(page) && section.id === "practice-pairs");
    }
    return true;
  }

  const keepIDs = new Set([
    "at-glance",
    "quick-say",
    "standard-way",
    "breakdown",
    "natural-variations",
    "traveler-insight",
    "what-happens-next",
    "you-may-hear",
    "practice-pairs",
    "nearby-phrases",
    "good-to-know",
    "explore-next",
  ]);
  if (!keepIDs.has(section.id)) return false;
  if (["natural-variations", "traveler-insight", "practice-pairs", "nearby-phrases", "explore-next"].includes(section.id)) {
    return hasRows;
  }
  if (section.id === "breakdown") return hasBreakdown;
  return true;
}

const sectionOrderByProfile = {
  place: ["at-glance", "quick-say", "journey-flow", "key-phrases", "place-brief", "use-it-with", "when-to-use", "getting-there", "tickets", "cable-car", "photos", "getting-back", "food-cash", "at-the-bridge", "pickup-nearby", "breakdown", "good-to-know", "explore-next"],
  street: ["at-glance", "quick-say", "show-driver", "place-brief", "confirm", "use-it-with", "wrong-place", "when-to-use", "breakdown", "good-to-know", "explore-next"],
  restaurant: ["at-glance", "quick-say", "place-brief", "use-it-with", "when-to-use", "inside-the-place", "good-to-know", "table-menu", "before-you-go", "menu-dietary", "breakdown"],
  dish: ["at-glance", "quick-say", "place-brief", "how-to-order", "ingredients-diet", "breakdown", "good-to-know"],
  "derived-place-phrase": ["breakdown", "related-phrases", "good-to-know"],
  phrase: ["at-glance", "quick-say", "standard-way", "breakdown", "natural-variations", "why-it-matters", "traveler-insight", "when-to-use", "local-tip", "what-happens-next", "you-may-hear", "practice-pairs", "good-to-know", "nearby-phrases", "explore-next"],
};

function phraseDedupKey(option) {
  return phraseIDFromPracticeOption(option)
    || option?.id
    || `${normalizeAudioText(option?.vietnamese || "")}|${normalizeAudioText(option?.english || "")}`;
}

function sectionHasTravelerContent(section) {
  return Boolean(
    String(section.body || "").trim()
    || (section.phrases || []).length
    || (section.breakdown || []).length
  );
}

function mergeDuplicateVisibleSections(sections) {
  const merged = [];
  const titleIndexes = new Map();

  for (const section of sections) {
    const titleKey = normalizeAudioText(section.title || section.id || "");
    if (!titleKey || !titleIndexes.has(titleKey)) {
      titleIndexes.set(titleKey, merged.length);
      merged.push(section);
      continue;
    }

    const existingIndex = titleIndexes.get(titleKey);
    const existing = merged[existingIndex];
    merged[existingIndex] = {
      ...existing,
      body: [existing.body, section.body].filter(Boolean).find((body) => String(body).trim()) || "",
      phrases: compactPhraseOptions([...(existing.phrases || []), ...(section.phrases || [])], 12),
      breakdown: compactBreakdownRows([...(existing.breakdown || []), ...(section.breakdown || [])]),
    };
  }

  return merged;
}

function compactBreakdownRows(rows) {
  const seen = new Set();
  const compacted = [];

  for (const row of rows || []) {
    const key = `${normalizeAudioText(row?.vietnamese || "")}|${normalizeAudioText(row?.english || "")}`;
    if (!key || seen.has(key)) continue;
    seen.add(key);
    compacted.push(row);
  }

  return compacted;
}

function isBaNaHillsPage(page) {
  return normalizedVietnameseKey(page.title || "") === "ba na hills";
}

function phraseSection(id, title, phraseIDs, tintName = "teal") {
  return {
    id,
    title,
    body: "",
    phrases: compactPhraseOptions(phraseIDs.map((phraseID) => phraseOptionByID(phraseID, tintName)), 6),
    breakdown: [],
    presentation: "phrase-list",
  };
}

function baNaJourneySection(existingByID, id, title, phraseIDs, tintName = "teal") {
  const fallback = phraseSection(id, title, phraseIDs, tintName);
  const existing = existingByID.get(id);
  if (!existing) return fallback;
  return {
    ...fallback,
    ...existing,
    id,
    title: existing.title || title,
    phrases: Array.isArray(existing.phrases) ? existing.phrases : fallback.phrases,
    presentation: existing.presentation || fallback.presentation,
  };
}

function rewriteBaNaHillsJourneySections(page, sections) {
  if (!isBaNaHillsPage(page)) return sections;
  if (page.cityMetadata?.editorialRuntimeOverrideKind !== "ba-na-hills-journey") return sections;

  const existingByID = new Map(sections.map((section) => [section.id, section]));
  const about = existingByID.get("at-glance");
  const hearName = existingByID.get("quick-say");
  const placeBrief = existingByID.get("place-brief");
  const useItWith = existingByID.get("use-it-with");
  const whenToUse = existingByID.get("when-to-use");
  const visitFlow = existingByID.get("journey-flow");
  const nameGuide = existingByID.get("breakdown");
  const goodToKnow = existingByID.get("good-to-know");

  return [
    about ? { ...about, id: "at-glance", title: about.title || "About" } : null,
    hearName ? baNaJourneySection(existingByID, "quick-say", "Useful Phrases", [
      "sight-1",
      "sight-3",
      "sight-4",
      "sight-5",
    ], "teal") : null,
    placeBrief ?? null,
    useItWith ?? null,
    whenToUse ?? null,
    visitFlow ? { ...visitFlow, id: "journey-flow", title: "Visit flow", presentation: "plain-text" } : null,
    baNaJourneySection(existingByID, "getting-there", "Getting there", [
      "taxi-1",
      "repair-5",
      "transport-stop-here-clearer",
      "ves-is-this-address-correct",
    ], "teal"),
    baNaJourneySection(existingByID, "tickets", "Tickets", [
      "v500-time-date-book-two-tickets-please",
      "v500-time-date-book-one-ticket-please",
      "v500-sigh-acti-where-can-i-buy-tickets",
    ], "orange"),
    baNaJourneySection(existingByID, "cable-car", "Cable car", [
      "ves-where-cable-car",
    ], "teal"),
    baNaJourneySection(existingByID, "photos", "Photos", [
      "ves-take-photo-for-me",
    ], "purple"),
    baNaJourneySection(existingByID, "getting-back", "Getting back", [
      "repair-5",
      "ves-is-this-address-correct",
      "ves-call-taxi-for-me",
    ], "orange"),
    goodToKnow ? { ...goodToKnow, id: "good-to-know", title: goodToKnow.title || "Good to know" } : null,
    baNaJourneySection(existingByID, "food-cash", "Food & cash", [
      "store-1",
      "airport-4",
    ], "green"),
    nameGuide ? { ...nameGuide, id: "breakdown", title: "Name guide" } : null,
  ].filter(Boolean).filter(sectionHasTravelerContent);
}

function sectionPhraseFilter(page, section, profile, phrase) {
  if (!isNameBasedProfile(profile)) return true;
  const attractionPlace = profile === "place" && isCityAttractionPlaceKind(page.cityMetadata?.placeKind);
  if (attractionPlace && ["use-it-with", "when-to-use", "explore-next"].includes(section.id)) return true;
  if (section.id === "explore-next") return optionMatchesPageName(phrase, page);
  if (profile === "street" && ["place-brief", "use-it-with", "when-to-use"].includes(section.id)) {
    return optionMatchesPageName(phrase, page);
  }
  if (profile === "place" && ["place-brief", "use-it-with", "when-to-use"].includes(section.id)) {
    return optionMatchesPageName(phrase, page);
  }
  return true;
}

function normalizeTravelerSections(page, sections, profile) {
  const seenPhraseKeys = new Set();
  const preserveRepeatedPhraseCards = profile === "phrase" && preservesHandwrittenPhraseEditorial(page);
  const deduped = sections.map((section) => {
    const phrases = [];
    const sectionSeenPhraseKeys = new Set();
    for (const phrase of (section.phrases || []).filter((item) => sectionPhraseFilter(page, section, profile, item))) {
      const key = phraseDedupKey(phrase);
      if (!key || sectionSeenPhraseKeys.has(key)) continue;
      sectionSeenPhraseKeys.add(key);
      if (!preserveRepeatedPhraseCards) {
        if (seenPhraseKeys.has(key)) continue;
        seenPhraseKeys.add(key);
      }
      phrases.push(phrase);
    }
    const presentation = section.presentation === "phrase-list" && phrases.length === 0 && String(section.body || "").trim()
      ? "plain-text"
      : section.presentation;
    return {
      ...section,
      body: cleanFinalPunctuation(section.body || ""),
      phrases,
      presentation,
    };
  }).filter((section) => {
    if (!sectionHasTravelerContent(section)) return false;
    if (section.id === "explore-next" && (section.phrases || []).length === 0) return false;
    if (section.id === "journey-flow" && !String(section.body || "").trim() && (section.phrases || []).length === 0) return false;
    return true;
  });

  const order = sectionOrderByProfile[profile] || sectionOrderByProfile.phrase;
  const sorted = deduped.sort((left, right) => {
    const leftIndex = order.includes(left.id) ? order.indexOf(left.id) : order.length;
    const rightIndex = order.includes(right.id) ? order.indexOf(right.id) : order.length;
    if (leftIndex !== rightIndex) return leftIndex - rightIndex;
    return 0;
  });
  return mergeDuplicateVisibleSections(sorted);
}

function shortenBodyForMobile(body) {
  const text = cleanTravelerBody(body);
  const words = text.split(/\s+/).filter(Boolean);
  if (words.length <= 28) return text;
  const sentence = text.match(/^[^.!?]+[.!?]/)?.[0]?.trim();
  if (sentence && sentence.split(/\s+/).filter(Boolean).length <= 28) return sentence;
  return `${words.slice(0, 26).join(" ")}.`;
}

function bodyWordCount(body) {
  return String(body ?? "").split(/\s+/).filter(Boolean).length;
}

function splitSentences(body) {
  const text = cleanFinalPunctuation(body);
  if (!text) return [];
  return text.match(/[^.!?]+[.!?]+(?:["”])?/g)?.map((sentenceText) => cleanFinalPunctuation(sentenceText)) ?? [text];
}

function pageCopyCue(page) {
  const categoryIDs = new Set(page.categoryIDs || []);
  if (categoryIDs.has("transport") || categoryIDs.has("directions-navigation")) {
    return "Keep the map, address, or destination visible.";
  }
  if (categoryIDs.has("hotel-accommodation") || categoryIDs.has("time-dates-booking")) {
    return "Keep the booking, room number, date, or address visible.";
  }
  if (categoryIDs.has("airport-border-arrival")) {
    return "Keep the passport, baggage tag, pickup screen, or flight detail visible.";
  }
  if (categoryIDs.has("food-drink") || categoryIDs.has("shopping") || categoryIDs.has("local-services-everyday-tasks")) {
    return "Point to the item, menu line, receipt, size, or photo.";
  }
  if (categoryIDs.has("health-pharmacy") || categoryIDs.has("emergency-safety")) {
    return "Show the symptom, medicine, location, or helper contact if you can.";
  }
  if (categoryIDs.has("phone-internet-power")) {
    return "Keep the phone screen or error message visible.";
  }
  if (categoryIDs.has("polite-basics") || categoryIDs.has("social-small-talk")) {
    return "Keep the tone warm and leave room for a short reply.";
  }
  if (categoryIDs.has("understanding-repair")) {
    return "If it is still unclear, show, write, or point to the exact word.";
  }
  return "Keep the relevant place, item, or screen visible.";
}

function phraseFormulaResidue(body) {
  return /(as your first sentence|Pause after the phrase|Pause naturally after the phrase|If speech still does not land|reply often comes as|^Expect .+ in [^.]+\. Say .+ once|Listen for |Keep your voice calm and let the short phrase|visible while you speak so|visible when the exact detail matters|Use the rows below|use the next rows if|keeping one travel detail clear|move the exchange forward|real [a-z -]+ exchange|detail you need resolved|likely reply is|Use the complete line|Go next to phrases|makes the next step easier to answer|It fits .*especially when the next step is|The phrase is doing one job|make the task visible with|is useful when the map, sign, or building layout|is for asking permission before you act|confirmation phrase for moments when you want to avoid guessing|friendly way to ask for help with|helps you decide whether the next move is worth the time|It names .+ in a compact way|\bUse the full phrase before adding details\.\s+Use the full phrase before adding details\b|\bKeep\s+[^.]+?\s+together as one sentence before adding details\.\s+Keep\b|\bis the line for\b|\bStart with\s+[^.]+,\s+then pause\b|\bThis is for when\b|\bThe reply may be a short reply\b|\bSay\s+[^.]+?\s+once, then watch for the reply\b|\bSay it once, then watch for the reply before adding more words\b|\bExpect a confirmation, a handoff, a price, or follow-up question\b|\bSay\s+[^.]+?\s+when you need\s+["“][^"”]+["”]|\bSay\s+[^.]+?\s+for\s+["“][^"”]+["”]\.\s+Say\b|\bSay\s+[^.]+?\s+for\s+["“][^"”]+["”]|\bUse\s+[^.]+?\s+for\s+["“][^"”]+["”]\.\s+(Say|Keep|Point|$)|\bUse\s+[^.]+?\s+for\s+["“][^"”]+["”]|Use it when\s+["“][^"”]+["”]\s+is the next thing you need to say|Try these next to confirm, answer, or continue after|quick money check|keeps the exchange focused|answer can be a number|pilot row|canonical title)/i.test(body);
}

function formulaSentenceResidue(sentenceText) {
  return /(as your first sentence|Pause after the phrase|Pause naturally after the phrase|If speech still does not land|reply often comes as|^Expect .+ in [^.]+|Listen for |Keep your voice calm and let the short phrase|visible while you speak so|visible when the exact detail matters|Use the rows below|use the next rows if|keeping one travel detail clear|move the exchange forward|real [a-z -]+ exchange|detail you need resolved|likely reply is|Use the complete line|Go next to phrases|makes the next step easier to answer|It fits .*especially when the next step is|The phrase is doing one job|make the task visible with|is useful when the map, sign, or building layout|is for asking permission before you act|confirmation phrase for moments when you want to avoid guessing|friendly way to ask for help with|helps you decide whether the next move is worth the time|It names .+ in a compact way|\bUse the full phrase before adding details\b|\bKeep\s+[^.]+?\s+together as one sentence before adding details\b|\bis the line for\b|\bStart with\s+[^.]+,\s+then pause\b|\bThis is for when\b|\bThe reply may be a short reply\b|\bSay\s+[^.]+?\s+once, then watch for the reply\b|\bSay it once, then watch for the reply before adding more words\b|\bExpect a confirmation, a handoff, a price, or follow-up question\b|\bSay\s+[^.]+?\s+when you need\s+["“][^"”]+["”]|\bSay\s+[^.]+?\s+for\s+["“][^"”]+["”]\.\s+Say\b|\bSay\s+[^.]+?\s+for\s+["“][^"”]+["”]|\bUse\s+[^.]+?\s+for\s+["“][^"”]+["”]\.\s+(Say|Keep|Point|$)|\bUse\s+[^.]+?\s+for\s+["“][^"”]+["”]|Use it when\s+["“][^"”]+["”]\s+is the next thing you need to say|Try these next to confirm, answer, or continue after|quick money check|keeps the exchange focused|answer can be a number|pilot row|canonical title)/i.test(sentenceText);
}

function phraseIntentFragment(intent) {
  return String(intent ?? "")
    .replace(/^["“]|["”]$/g, "")
    .replace(/[.?!]+$/g, "")
    .trim();
}

function lowerFirstWord(text) {
  const value = phraseIntentFragment(text);
  if (!value) return "";
  if (/^[A-Z]{2,}\b/.test(value)) return value;
  return value.charAt(0).toLowerCase() + value.slice(1);
}

function usefulSituationSentence(body) {
  for (const sentenceText of splitSentences(body)) {
    if (!sentenceText) continue;
    if (formulaSentenceResidue(sentenceText)) continue;
    if (/^Expect\b/i.test(sentenceText)) continue;
    if (bodyWordCount(sentenceText) > 22) continue;
    return sentenceText;
  }
  return "";
}

function responseCueFromFormula(body) {
  const text = String(body ?? "");
  const patterns = [
    /^Expect (.+?)(?: in [^.]+)?\./i,
    /listen for ([^.]+)\./i,
    /reply often comes as ([^.]+)\./i,
    /likely reply is ([^.]+?)(?:, so|\.)/i,
    /next step is ([^.]+)\./i,
  ];
  for (const pattern of patterns) {
    const match = text.match(pattern);
    if (!match?.[1]) continue;
    const response = match[1]
      .replace(/\bor a\b/g, "or")
      .replace(/\s+/g, " ")
      .trim();
    if (response) return response;
  }
  return "";
}

function compactPhraseReplacement(page, section, body) {
  const title = cleanFinalPunctuation(page.title || "");
  const intent = cleanEnglishIntent(page.englishTitle || page.summary || "");
  const intentFragment = lowerFirstWord(intent);
  const cue = pageCopyCue(page);
  const situation = usefulSituationSentence(body);
  const response = responseCueFromFormula(body);
  const atGlanceLine = title
    ? phraseMomentLead(title, intentFragment)
    : "";
  const sayLine = title
    ? fullPhraseCue(title, cue)
    : "";
  const responseLine = responseSentence(response);

  switch (section.id) {
    case "at-glance":
      return [atGlanceLine, situation && !/^Use\b/i.test(situation) ? situation : cue].filter(Boolean).join(" ");
    case "quick-say":
    case "standard-way":
      return withoutDuplicateParts([sayLine, situation || cue]).join(" ");
    case "why-it-matters":
      return [
        situation || "The phrase keeps the request clear before extra details get in the way.",
        responseLine || cue,
      ].filter(Boolean).join(" ");
    case "traveler-insight":
    case "what-happens-next":
    case "you-may-hear":
      return [
        responseLine,
        situation || cue,
      ].filter(Boolean).join(" ");
    case "when-to-use":
      return [
        situation || (intentFragment ? `Reach for it when the next move is ${intentFragment}.` : ""),
        responseLine || cue,
      ].filter(Boolean).join(" ");
    case "nearby-phrases":
    case "practice-pairs":
    case "explore-next":
      return "Use these if the answer changes the next step.";
    default:
      return [situation, cue].filter(Boolean).join(" ") || body;
  }
}

function cleanPreservedPhraseSectionBody(page, section, profile, phraseRole) {
  const body = cleanFinalPunctuation(cleanTravelerBody(section.body || ""));
  if (!body) return "";
  if (profile !== "phrase" || phraseRole !== "traveler_says") return body;
  if (!phraseFormulaResidue(body)) return body;

  const replacement = cleanFinalPunctuation(compactPhraseReplacement(page, section, body));
  if (!replacement) return body;
  if (!phraseFormulaResidue(replacement) && bodyWordCount(replacement) <= 40) return replacement;
  return shortenBodyForMobile(replacement);
}

function practicePageType(page, profile) {
  const meta = page.cityMetadata || {};
  const categoryIDs = new Set(page.categoryIDs || []);
  const title = `${page.title || ""} ${page.englishTitle || ""}`.toLowerCase();
  const vietnameseTitleTokens = new Set(accentlessWordTokens(page.title || ""));
  const englishTitle = String(page.englishTitle || "").toLowerCase();

  if (meta.pageKind === "city") return "city";
  if (profile === "street") return "street";
  if (profile === "restaurant") return "restaurant";
  if (profile === "dish") return "dish";
  if (profile === "derived-place-phrase") return "phrase";
  if (profile === "place") {
    if (
      /bà nà hills|ba na hills|ngũ hành sơn|marble mountains|airport|sân bay/i.test(title)
      || ["airport", "theme-park", "resort"].includes(meta.placeKind)
    ) {
      return "macroAttraction";
    }
    return "landmark";
  }
  if (categoryIDs.has("emergency-safety")) return "emergency";
  if (
    categoryIDs.has("hotel-accommodation")
    || categoryIDs.has("airport-border-arrival")
    || categoryIDs.has("transport")
    || categoryIDs.has("health-pharmacy")
    || categoryIDs.has("bathroom-personal-needs")
    || categoryIDs.has("shopping")
  ) {
    return "practicalFlow";
  }
  if (
    categoryIDs.has("polite-basics")
    && (
      vietnameseTitleTokens.has("chao")
      || englishTitle.includes("hello")
      || ["anh", "chi", "em", "co", "chu", "ong", "ba"].some((token) => vietnameseTitleTokens.has(token))
    )
  ) {
    return "greeting";
  }
  return "phrase";
}

function practiceKindForType(type) {
  return {
    phrase: "phrase_audio_review",
    greeting: "greeting_choice_mini_flow",
    street: "street_driver_mini_scenario",
    landmark: "place_visit_mini_scenario",
    macroAttraction: "trip_journey_scenario",
    restaurant: "restaurant_ordering_scenario",
    dish: "dish_ordering_scenario",
    city: "city_scenario_hub",
    practicalFlow: "practical_flow_scenario",
    emergency: "urgent_help_scenario",
  }[type] || "phrase_audio_review";
}

function practiceCTALabelForType(type) {
  return {
    phrase: "Practice this phrase",
    greeting: "Practice this greeting",
    street: "Practice this street",
    landmark: "Practice this place",
    macroAttraction: "Practice this trip",
    restaurant: "Practice ordering here",
    dish: "Practice ordering this",
    city: "Practice this city",
    practicalFlow: "Practice this situation",
    emergency: "Practice urgent help",
  }[type] || "Practice this phrase";
}

function phraseIDFromPracticeOption(option) {
  if (option?.id && phraseByID.has(option.id)) return option.id;
  const detailPageID = option?.detailPageID || "";
  if (detailPageID.startsWith("viet-phrase-")) {
    const inferred = detailPageID.slice("viet-phrase-".length);
    if (phraseByID.has(inferred)) return inferred;
  }
  return null;
}

function uniqueStrings(values) {
  const seen = new Set();
  return values.filter((value) => {
    if (!value || seen.has(value)) return false;
    seen.add(value);
    return true;
  });
}

function practiceStepGroupsForPage(page, sections, type) {
  const groups = [];
  for (const section of sections) {
    const phraseIDs = uniqueStrings((section.phrases || []).map(phraseIDFromPracticeOption).filter(Boolean));
    if (phraseIDs.length === 0) continue;
    const sectionSlug = slug(section.id || section.title || `step-${groups.length + 1}`) || `step-${groups.length + 1}`;
    groups.push({
      stepID: sectionSlug,
      title: section.title || "Practice",
      sourceSectionID: section.id,
      primaryPhraseIDs: phraseIDs.slice(0, 1),
      supportPhraseIDs: phraseIDs.slice(1, 5),
    });
    if (groups.length >= (type === "phrase" || type === "greeting" ? 3 : 6)) break;
  }

  if (groups.length === 0 && page.phraseID && phraseByID.has(page.phraseID)) {
    groups.push({
      stepID: "main-phrase",
      title: "Say this",
      sourceSectionID: "self",
      primaryPhraseIDs: [page.phraseID],
      supportPhraseIDs: [],
    });
  }

  return groups;
}

function practiceIntegrationMetadata(page, sections, profile) {
  const type = practicePageType(page, profile);
  const groups = practiceStepGroupsForPage(page, sections, type);
  const primaryPracticePhraseIDs = uniqueStrings([
    page.phraseID && phraseByID.has(page.phraseID) ? page.phraseID : null,
    ...groups.flatMap((group) => group.primaryPhraseIDs),
  ]);
  const secondaryPracticePhraseIDs = uniqueStrings(groups.flatMap((group) => group.supportPhraseIDs))
    .filter((phraseID) => !primaryPracticePhraseIDs.includes(phraseID));

  return {
    ...(page.practiceMetadata || {}),
    integrationVersion: "listing-scenario-seed-v1",
    scenarioEligible: type !== "phrase" && primaryPracticePhraseIDs.length > 0,
    practiceKind: practiceKindForType(type),
    practiceCTALabel: practiceCTALabelForType(type),
    practiceSurfacePolicy: type === "phrase" ? "saved_or_recent_only" : "recommended_when_relevant",
    scenarioSeedID: `scenario-seed-${slug(page.phraseID || page.id)}`,
    scenarioStepGroups: groups,
    primaryPracticePhraseIDs,
    secondaryPracticePhraseIDs,
    practiceSourcePageID: page.id,
  };
}

function sanitizeAuthoredPage(page) {
  const profile = authoredPageProfile(page);
  const phraseRole = phraseRoleForPage(page, profile);
  const sections = (page.sections || []).filter((section) => shouldKeepSectionForProfile(section, profile, page, phraseRole));
  const preserveCityEditorial = preservesHandwrittenCityEditorial(page);
  const preservePhraseEditorial = preservesHandwrittenPhraseEditorial(page);
  const sanitizedSections = rewriteBaNaHillsJourneySections(page, normalizeTravelerSections(page, sections.map((section) => ({
    ...section,
    title: preserveCityEditorial || preservePhraseEditorial
      ? cleanFinalPunctuation(section.title || "")
      : cleanTravelerSectionTitle(section.title, { ...page, __currentSectionID: section.id, __phraseRole: phraseRole }),
    body: preserveCityEditorial
      ? cleanFinalPunctuation(section.body || "")
      : preservePhraseEditorial
      ? cleanPreservedPhraseSectionBody(page, section, profile, phraseRole)
      : isNameBasedProfile(profile) ? shortenBodyForMobile(adultNameSectionBody(page, section, profile)) : shortenBodyForMobile(phraseSectionBody(page, section, phraseRole)),
    phrases: curatedSectionPhrases(page, section, profile, phraseRole).map((phrase) => ({
      ...phrase,
      english: cleanTravelerBody(phrase.english),
    })),
    breakdown: section.id === "breakdown"
      ? applyReviewedBreakdownOverride({
        page,
        existingBreakdown: curatedSectionBreakdown(page, section).map((token) => ({
          ...token,
          english: cleanTravelerBreakdownGloss(token.english, page, token.vietnamese),
        })),
        ledger: breakdownAuditLedger,
        audioKeyForToken: (text, { isFinal } = {}) => (
          isFinal
            ? authoredPhraseAudioKey(text, page.audioKey)
            : authoredBreakdownAudioKey(text)
        ),
      })
      : curatedSectionBreakdown(page, section).map((token) => ({
        ...token,
        english: cleanTravelerBreakdownGloss(token.english, page, token.vietnamese),
      })),
  })), profile));

  return {
    ...page,
    summary: preserveCityEditorial || preservePhraseEditorial
      ? cleanFinalPunctuation(page.summary || "")
      : profile === "derived-place-phrase"
      ? cleanFinalPunctuation(page.englishTitle || page.summary || "")
      : isNameBasedProfile(profile)
      ? cleanFinalPunctuation(adultNameAboutBody(page, profile))
      : phraseRole === "traveler_may_hear"
      ? cleanFinalPunctuation(page.englishTitle || page.summary || "")
      : cleanFinalPunctuation(phraseContextSentence(page)),
    practiceMetadata: practiceIntegrationMetadata(page, sanitizedSections, profile),
    sections: sanitizedSections,
  };
}

function sanitizeAuthoredPages(pages) {
  return pages.map(sanitizeAuthoredPage);
}

function canonicalSourcePageForWrite(page) {
  const profile = authoredPageProfile(page);
  const phraseRole = phraseRoleForPage(page, profile);
  return {
    ...page,
    summary: cleanFinalPunctuation(page.summary || ""),
    sections: (page.sections || []).map((section) => ({
      ...section,
      title: cleanFinalPunctuation(section.title || ""),
      body: cleanPreservedPhraseSectionBody(page, section, profile, phraseRole),
      phrases: (section.phrases || []).map((phrase) => ({
        ...phrase,
        english: cleanTravelerBody(phrase.english),
      })),
      breakdown: (section.breakdown || []).map((token) => ({
        ...token,
        english: cleanTravelerBreakdownGloss(token.english, page, token.vietnamese),
      })),
    })),
  };
}

function sourceReasonToGoCityPagesByRuntimeID() {
  const library = loadCityLibrary();
  if (!library) return new Map();
  const entries = (library.pages ?? [])
    .filter((page) => page.status === "approved")
    .filter((page) => page.kind !== "phrase")
    .filter((page) => page.editorialImport?.audienceRewrite?.standard === "reason-to-go-factual-hook-before-local-name")
    .filter((page) => page.editorialImport?.runtimeOverride?.kind !== "ba-na-hills-journey")
    .map((page) => [cityPageID(page.id), page]);
  return new Map(entries);
}

function applySourceReasonToGoCityEditorial(pages) {
  const sourceByRuntimeID = sourceReasonToGoCityPagesByRuntimeID();
  if (sourceByRuntimeID.size === 0) return pages;

  return pages.map((page) => {
    const sourcePage = sourceByRuntimeID.get(page.id);
    const sourceSections = sourcePage?.editorialImport?.sections ?? [];
    if (!sourcePage || sourceSections.length === 0) return page;

    const existingSectionsByID = new Map((page.sections ?? []).map((section) => [section.id, section]));
    const sections = sourceSections.map((section) => ({
      ...(existingSectionsByID.get(section.id) ?? {}),
      id: section.id,
      title: section.title,
      body: section.body,
    }));

    return {
      ...page,
      summary: cleanFinalPunctuation(sourcePage.editorialImport.summary || page.summary || ""),
      sections: withSectionPresentations(sections),
      cityMetadata: {
        ...(page.cityMetadata ?? {}),
        rationale: cleanTravelerBody(sourcePage.rationale),
        editorialAudienceRewriteReviewID: sourcePage.editorialImport.audienceRewrite.reviewID,
        editorialAudienceRewriteStandard: sourcePage.editorialImport.audienceRewrite.standard,
      },
    };
  });
}

function runEditorialPilotImport() {
  if (!fs.existsSync(editorialPilotImportScriptPath)) {
    return false;
  }
  execFileSync(process.execPath, [editorialPilotImportScriptPath, "--apply"], {
    cwd: familyRoot,
    stdio: "inherit",
  });
  return true;
}

function writeBreakdownAuditExport(pages) {
  fs.mkdirSync(path.dirname(breakdownAuditExportPath), { recursive: true });
  fs.writeFileSync(breakdownAuditExportPath, `${JSON.stringify(
    renderBreakdownAuditExport({ pages, ledger: breakdownAuditLedger }),
    null,
    2
  )}\n`);
}

function validateBreakdownAuditForGeneration(pages) {
  const report = validateBreakdownAuditCoverage({
    pages,
    ledger: breakdownAuditLedger,
    requireAllReviewed: process.argv.includes("--require-breakdown-audit-complete"),
  });
  if (!report.ok) {
    throw new Error(`Breakdown audit validation failed:\n${report.errors.slice(0, 40).join("\n")}`);
  }
  return report;
}

function main() {
  const existingChildPagesByPhraseID = loadExistingChildPagesByPhraseID();
  removeGeneratedSources();

  const catalogPromotedPages = loadCatalogPromotedPages();
  const catalogPromotedPhraseIDs = loadCatalogPromotedPhraseIDs();
  const cityLibraryPages = loadCityLibraryPages();
  const editorialSupportPages = loadEditorialSupportPages();
  const catalogPromotedPageIDByPhraseID = new Map(catalogPromotedPages.map((page) => [page.phraseID, page.id]));
  const taskCatalogPromotedPhraseIDs = new Set([...catalogPromotedPhraseIDs]
    .filter((phraseID) => phraseByID.get(phraseID)?.notes?.includes(`task=${catalogPromotedTaskID}`)));
  for (const page of catalogPromotedPages) {
    const family = familyByID.get(page.familyID);
    if (family?.primaryPhraseID === page.phraseID) {
      designedFamilyPageIDs[page.familyID] = page.id;
    }
  }
  const starterFamilies = catalog.families.filter((family) => {
    const primaryPhrase = phraseByID.get(family.primaryPhraseID);
    return family.accessTier === "starter"
      && primaryPhrase?.variantRole === "say-first"
      && !taskCatalogPromotedPhraseIDs.has(family.primaryPhraseID);
  });

  const childPageIDsByPhraseID = new Map();
  for (const family of starterFamilies) {
    for (const phraseID of family.phraseIDs ?? []) {
      const phrase = phraseByID.get(phraseID);
      if (phrase && phrase.variantRole !== "say-first") {
        childPageIDsByPhraseID.set(
          phrase.id,
          catalogPromotedPageIDByPhraseID.get(phrase.id) ?? `viet-phrase-${phrase.id}`
        );
      }
    }
  }

  const pages = [];
  const childPages = [];
  const inventory = [];

  for (const family of starterFamilies) {
    const primaryPhrase = phraseByID.get(family.primaryPhraseID);
    const pageID = canonicalPageID(family);

    const page = pageForFamily(family, childPageIDsByPhraseID);
    const coverage = manuallyAuthoredPageIDs.has(page.id) ? "manual-swift" : "authored-resource";
    inventory.push({ familyID: family.id, pageID: page.id, coverage, title: page.title });

    const scenarioDir = path.join(sourceRoot, family.scenarioID);
    fs.mkdirSync(scenarioDir, { recursive: true });
    fs.writeFileSync(path.join(scenarioDir, `${family.id}.json`), `${JSON.stringify(canonicalSourcePageForWrite(page), null, 2)}\n`);

    if (!manuallyAuthoredPageIDs.has(page.id) && !catalogPromotedPhraseIDs.has(family.primaryPhraseID)) {
      pages.push(page);
    }

    for (const phraseID of family.phraseIDs ?? []) {
      const phrase = phraseByID.get(phraseID);
      if (!phrase || phrase.variantRole === "say-first") continue;
      if (catalogPromotedPhraseIDs.has(phrase.id)) continue;
      const childPage = existingChildPagesByPhraseID.get(phrase.id) ?? childPageForVariant(family, phrase, primaryPhrase);
      childPages.push(childPage);
      fs.writeFileSync(path.join(scenarioDir, `${family.id}--${phrase.id}.json`), `${JSON.stringify(canonicalSourcePageForWrite(childPage), null, 2)}\n`);
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

  const allPages = applySourceReasonToGoCityEditorial(
    sanitizeAuthoredPages([...pages, ...childPages, ...catalogPromotedPages, ...cityLibraryPages, ...editorialSupportPages])
  );
  validateBreakdownAuditForGeneration(allPages);
  const audioAudit = collectAudioAudit(allPages);
  const bundle = {
    metadata: {
      source: path.relative(root, sourceRoot),
      catalogPromotedSource: path.relative(root, catalogPromotedSourceRoot),
      cityLibrarySource: fs.existsSync(cityLibraryPath) ? path.relative(root, cityLibraryPath) : null,
      editorialSupportSource: fs.existsSync(editorialSupportManifestPath) ? path.relative(root, editorialSupportRoot) : null,
      tierOneFamilyCount: starterFamilies.length,
      resourceMainPageCount: pages.length,
      childPageCount: childPages.length,
      catalogPromotedPageCount: catalogPromotedPages.length,
      cityLibraryPageCount: cityLibraryPages.length,
      editorialSupportPageCount: editorialSupportPages.length,
      generatedAt: new Date().toISOString(),
    },
    pages: allPages,
  };

  fs.writeFileSync(outputPath, `${JSON.stringify(bundle, null, 2)}\n`);
  fs.writeFileSync(auditPath, `${JSON.stringify({
    metadata: {
      generatedAt: bundle.metadata.generatedAt,
      tierOneFamilyCount: starterFamilies.length,
      cityLibraryPageCount: cityLibraryPages.length,
      requiredAudioCount: audioAudit.required.length,
      missingAudioCount: audioAudit.missing.length,
    },
    required: audioAudit.required,
    missing: audioAudit.missing,
  }, null, 2)}\n`);

  const importedEditorialPilot = runEditorialPilotImport();
  const finalBundle = JSON.parse(fs.readFileSync(outputPath, "utf8"));
  finalBundle.pages = applySourceReasonToGoCityEditorial(sanitizeAuthoredPages(finalBundle.pages ?? []));
  validateBreakdownAuditForGeneration(finalBundle.pages ?? []);
  fs.writeFileSync(outputPath, `${JSON.stringify(finalBundle, null, 2)}\n`);
  writeBreakdownAuditExport(finalBundle.pages ?? []);
  const finalAudioAudit = collectAudioAudit(finalBundle.pages ?? []);
  fs.writeFileSync(auditPath, `${JSON.stringify({
    metadata: {
      generatedAt: finalBundle.metadata?.generatedAt ?? bundle.metadata.generatedAt,
      tierOneFamilyCount: starterFamilies.length,
      cityLibraryPageCount: cityLibraryPages.length,
      editorialSupportPageCount: editorialSupportPages.length,
      requiredAudioCount: finalAudioAudit.required.length,
      missingAudioCount: finalAudioAudit.missing.length,
    },
    required: finalAudioAudit.required,
    missing: finalAudioAudit.missing,
  }, null, 2)}\n`);

  console.log(`Tier 1 families: ${starterFamilies.length}`);
  console.log(`Authored resource main pages: ${pages.length}`);
  console.log(`Child pages: ${childPages.length}`);
  console.log(`Catalog-promoted authored pages: ${catalogPromotedPages.length}`);
  console.log(`City library pages: ${cityLibraryPages.length}`);
  console.log(`Editorial model support pages: ${editorialSupportPages.length}`);
  console.log(`Missing assigned audio: ${finalAudioAudit.missing.length}`);
  if (importedEditorialPilot) {
    console.log("Applied approved editorial pilot imports");
  }
  console.log(`Wrote ${path.relative(process.cwd(), outputPath)}`);
}

main();
