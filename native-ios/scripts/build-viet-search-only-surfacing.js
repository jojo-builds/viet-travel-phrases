#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const auditPath = path.join(repoRoot, "docs", "task-results", "listing-backdrop-audit-2026-05-29", "listing-backdrop-audit.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const outputPath = path.join(repoRoot, "content-draft", "viet", "search-only-surfacing-v1.json");
const swiftOutputPath = path.join(nativeRoot, "App", "Models", "VietSearchOnlyPhraseSurfacing.swift");

const sourcePath = "content-draft/viet/search-only-surfacing-v1.json";

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value ?? "")
    .toLowerCase()
    .replace(/[’]/g, "'")
    .replace(/\s+/g, " ")
    .trim();
}

function swiftString(value) {
  return `"${String(value ?? "").replace(/\\/g, "\\\\").replace(/"/g, "\\\"")}"`;
}

function sortRows(rows) {
  return [...rows].sort((a, b) => {
    const aKey = [
      a.browsePlacement.collectionID,
      a.browsePlacement.subcategoryID,
      String(a.browsePlacement.sortOrder).padStart(4, "0"),
      a.englishTitle,
    ].join("\u0000");
    const bKey = [
      b.browsePlacement.collectionID,
      b.browsePlacement.subcategoryID,
      String(b.browsePlacement.sortOrder).padStart(4, "0"),
      b.englishTitle,
    ].join("\u0000");
    return aKey.localeCompare(bKey);
  });
}

const subcategoryDefinitions = [
  {
    id: "emergency.health-clinic",
    collectionID: "emergency",
    title: "Clinic & pharmacy",
    subtitle: "Doctor, dentist, hospital, clinic bills",
    symbolName: "cross.case.fill",
    imageName: "HeroCategoryEmergency",
    supportSourcePageIDs: ["viet-phrase-health-1", "viet-phrase-problems-6", "viet-phrase-emergency-hospital"],
    supportSectionID: "search-surfacing-health-clinic",
    supportTitle: "Clinic next steps",
    supportBody: "These cover the specific health questions that often come right after asking for a pharmacy, doctor, clinic, or hospital.",
  },
  {
    id: "emergency.health-symptoms",
    collectionID: "emergency",
    title: "Symptoms",
    subtitle: "Fever, nausea, stomach, dizziness",
    symbolName: "heart.text.square.fill",
    imageName: "HeroCategoryEmergency",
    supportSourcePageIDs: ["viet-phrase-health-2", "viet-phrase-health-3", "viet-phrase-health-5"],
    supportSectionID: "search-surfacing-health-symptoms",
    supportTitle: "Explain symptoms",
    supportBody: "Use these when the health conversation needs the specific symptom, condition, or allergy instead of a general request.",
  },
  {
    id: "emergency.health-conditions",
    collectionID: "emergency",
    title: "Conditions & allergies",
    subtitle: "Asthma, diabetes, pregnancy, allergies",
    symbolName: "heart.text.square.fill",
    imageName: "HeroCategoryEmergency",
    supportSourcePageIDs: ["viet-phrase-health-5", "viet-phrase-problems-6", "viet-phrase-health-1"],
    supportSectionID: "search-surfacing-health-conditions",
    supportTitle: "Conditions and allergies",
    supportBody: "Use these when a doctor, clinic, or pharmacy needs to know a condition, pregnancy, asthma, diabetes, or allergy.",
  },
  {
    id: "emergency.medicine",
    collectionID: "emergency",
    title: "Medicine questions",
    subtitle: "How to take it, pills, side effects",
    symbolName: "pills.fill",
    imageName: "HeroCategoryEmergency",
    supportSourcePageIDs: ["viet-phrase-health-1", "viet-phrase-health-4", "viet-phrase-health-6"],
    supportSectionID: "search-surfacing-medicine",
    supportTitle: "Medicine questions",
    supportBody: "Once medicine is on the counter, these phrases help ask dosage, timing, side effects, and receipts clearly.",
  },
  {
    id: "emergency.first-aid-supplies",
    collectionID: "emergency",
    title: "First aid supplies",
    subtitle: "Bandages, antiseptic, sunscreen, insect bites",
    symbolName: "cross.vial.fill",
    imageName: "HeroCategoryEmergency",
    supportSourcePageIDs: ["viet-phrase-health-1", "viet-phrase-health-6", "viet-phrase-health-5"],
    supportSectionID: "search-surfacing-first-aid-supplies",
    supportTitle: "First aid supplies",
    supportBody: "Use these at a pharmacy or clinic counter for bandages, antiseptic, rehydration salts, repellent, sunscreen, or insect bites.",
  },
  {
    id: "emergency.lost-report",
    collectionID: "emergency",
    title: "Lost items & reports",
    subtitle: "Passport, wallet, phone, embassy, report",
    symbolName: "doc.text.fill",
    imageName: "HeroCategoryEmergency",
    supportSourcePageIDs: ["viet-phrase-emergency-3", "viet-phrase-emergency-7", "viet-phrase-help-5"],
    supportSectionID: "search-surfacing-lost-report",
    supportTitle: "Reports and documents",
    supportBody: "These are the follow-up lines for lost items, embassy help, travel documents, and official reports.",
  },
  {
    id: "emergency.safety-now",
    collectionID: "emergency",
    title: "Safety right now",
    subtitle: "Accident, unsafe, scam, unwanted attention",
    symbolName: "shield.fill",
    imageName: "HeroCategoryEmergency",
    supportSourcePageIDs: ["viet-phrase-emergency-5", "viet-phrase-emergency-4", "viet-phrase-help-need-help-direct"],
    supportSectionID: "search-surfacing-safety-now",
    supportTitle: "If this gets urgent",
    supportBody: "Keep these close for uncomfortable, unsafe, or escalating moments where a clear short sentence matters.",
  },
  {
    id: "questions.booking-changes",
    collectionID: "questions",
    title: "Bookings & changes",
    subtitle: "Reservations, wrong date, deposits, changes",
    symbolName: "calendar.badge.clock",
    imageName: "HeroCategoryQuestions",
    supportSourcePageIDs: ["viet-phrase-time-4", "viet-phrase-time-5", "viet-phrase-sight-6"],
    supportSectionID: "search-surfacing-booking-changes",
    supportTitle: "Booking changes",
    supportBody: "Use these when a reservation, date, time, deposit, or online booking question gets more specific.",
  },
  {
    id: "questions.tickets-lines",
    collectionID: "questions",
    title: "Tickets, seats & lines",
    subtitle: "Boarding, seats, refunds, hours, waits",
    symbolName: "ticket.fill",
    imageName: "HeroCategoryQuestions",
    supportSourcePageIDs: ["viet-phrase-time-7", "viet-phrase-sight-1", "viet-phrase-time-5"],
    supportSectionID: "search-surfacing-tickets-lines",
    supportTitle: "Tickets and lines",
    supportBody: "Use these around ticket counters, boarding, seats, refunds, opening hours, and waiting lines.",
  },
  {
    id: "getting-around.walking-directions",
    collectionID: "getting-around",
    title: "Walking & distance",
    subtitle: "Walk there, distance, wrong way",
    symbolName: "figure.walk",
    imageName: "HeroCategoryGettingAround",
    supportSourcePageIDs: ["viet-phrase-directions-1", "viet-phrase-directions-3", "viet-phrase-directions-7"],
    supportSectionID: "search-surfacing-walking-directions",
    supportTitle: "Walking details",
    supportBody: "These phrases help when the answer is about walking, stairs, turns, distance, or whether you are close enough.",
  },
  {
    id: "getting-around.stairs-turns",
    collectionID: "getting-around",
    title: "Stairs, turns & landmarks",
    subtitle: "Upstairs, downstairs, bridge, corner",
    symbolName: "arrow.triangle.turn.up.right.diamond.fill",
    imageName: "HeroCategoryGettingAround",
    supportSourcePageIDs: ["viet-phrase-directions-1", "viet-phrase-directions-4", "viet-phrase-directions-5"],
    supportSectionID: "search-surfacing-stairs-turns",
    supportTitle: "Turns and landmarks",
    supportBody: "Use these when directions depend on stairs, bridges, corners, nearby landmarks, or a specific building.",
  },
  {
    id: "getting-around.pickup-maps",
    collectionID: "getting-around",
    title: "Maps & pickup points",
    subtitle: "Map app, address, pin, pickup point",
    symbolName: "map.fill",
    imageName: "HeroCategoryGettingAround",
    supportSourcePageIDs: ["viet-phrase-directions-8", "viet-phrase-directions-9", "viet-phrase-repair-5"],
    supportSectionID: "search-surfacing-pickup-maps",
    supportTitle: "Maps and pickup",
    supportBody: "Use these when the conversation moves from directions to maps, pins, streets, exits, or pickup points.",
  },
  {
    id: "polite-repair.clarify-specific",
    collectionID: "polite-repair",
    title: "Clarify specifics",
    subtitle: "Which one, slower, exact total, right number",
    symbolName: "questionmark.bubble.fill",
    imageName: "HeroCategoryPoliteRepair",
    supportSourcePageIDs: ["viet-phrase-problems-2", "viet-phrase-problems-3", "viet-phrase-repair-1"],
    supportSectionID: "search-surfacing-clarify-specific",
    supportTitle: "When you need one more detail",
    supportBody: "These phrases keep a confusing exchange calm when you need a number, word, total, or choice repeated.",
  },
  {
    id: "polite-repair.translate-show",
    collectionID: "polite-repair",
    title: "Show, translate, mark",
    subtitle: "Map, phone, app, translation help",
    symbolName: "rectangle.and.pencil.and.ellipsis",
    imageName: "HeroCategoryPoliteRepair",
    supportSourcePageIDs: ["viet-phrase-repair-2", "viet-phrase-repair-3", "viet-phrase-repair-5"],
    supportSectionID: "search-surfacing-translate-show",
    supportTitle: "Show it another way",
    supportBody: "Use these when pointing, writing, translating, or showing the phone is easier than adding more speech.",
  },
  {
    id: "numbers-money.prices-totals",
    collectionID: "numbers-money",
    title: "Prices & totals",
    subtitle: "Final price, total, per person, enough",
    symbolName: "tag.fill",
    imageName: "HeroCategoryNumbersMoney",
    supportSourcePageIDs: ["viet-phrase-price-1", "viet-phrase-price-5", "viet-phrase-price-8"],
    supportSectionID: "search-surfacing-prices-totals",
    supportTitle: "Price details",
    supportBody: "These phrases belong with money because they handle totals, per-person pricing, extra fees, and price changes.",
  },
  {
    id: "numbers-money.cash-receipts",
    collectionID: "numbers-money",
    title: "Cash, cards & receipts",
    subtitle: "Bills, change, exchange, receipts, card issues",
    symbolName: "creditcard.fill",
    imageName: "HeroCategoryNumbersMoney",
    supportSourcePageIDs: ["viet-phrase-store-6", "viet-phrase-store-7", "viet-phrase-airport-4"],
    supportSectionID: "search-surfacing-cash-receipts",
    supportTitle: "Payment follow-ups",
    supportBody: "Keep these near payment pages for cash, cards, receipts, exchange, and small billing problems.",
  },
  {
    id: "everyday-services.print-laundry",
    collectionID: "everyday-services",
    title: "Print, copy, laundry",
    subtitle: "Documents, repairs, laundry, timing",
    symbolName: "printer.fill",
    imageName: "HeroCategoryNumbersMoney",
    supportSourcePageIDs: ["viet-phrase-service-8", "viet-phrase-store-7", "viet-phrase-v500-loca-serv-ever-task-can-you-fix-this"],
    supportSectionID: "search-surfacing-print-laundry",
    supportTitle: "Service counter details",
    supportBody: "These are useful at copy shops, hotel desks, laundry counters, and small repair stops.",
  },
  {
    id: "everyday-services.water-rain-comfort",
    collectionID: "everyday-services",
    title: "Water, rain, comfort",
    subtitle: "Water, tissues, rain gear, cooler seats",
    symbolName: "drop.fill",
    imageName: "HeroCategoryEssentials",
    supportSourcePageIDs: ["viet-phrase-store-1", "viet-phrase-store-3", "viet-phrase-store-4"],
    supportSectionID: "search-surfacing-water-rain-comfort",
    supportTitle: "Small practical needs",
    supportBody: "These are the ordinary trip-savers: water, tissues, rain gear, a cooler seat, or a quick rest.",
  },
  {
    id: "everyday-services.bathroom-personal",
    collectionID: "everyday-services",
    title: "Bathroom & personal needs",
    subtitle: "Bathroom, shower, soap, sanitizer",
    symbolName: "figure.stand",
    imageName: "HeroCategoryEssentials",
    supportSourcePageIDs: ["viet-phrase-bath-1", "viet-phrase-bathroom-use", "viet-phrase-bath-4"],
    supportSectionID: "search-surfacing-bathroom-personal",
    supportTitle: "Bathroom follow-ups",
    supportBody: "Use these when the basic bathroom question turns into soap, sanitizer, shower, fee, or personal-care needs.",
  },
  {
    id: "everyday-services.phone-sim-wifi",
    collectionID: "everyday-services",
    title: "SIM, Wi-Fi, data",
    subtitle: "SIM cards, eSIM, passwords, signal",
    symbolName: "simcard.fill",
    imageName: "HeroCategoryAirport",
    supportSourcePageIDs: ["viet-phrase-phone-1", "viet-phrase-phone-2", "viet-phrase-phone-6"],
    supportSectionID: "search-surfacing-phone-sim-wifi",
    supportTitle: "Phone connection help",
    supportBody: "These are the next lines after asking for Wi-Fi, a SIM, an eSIM, or mobile data help.",
  },
  {
    id: "everyday-services.phone-repair-apps",
    collectionID: "everyday-services",
    title: "Phone repair & apps",
    subtitle: "Charger, screen, code, app, repair",
    symbolName: "iphone.gen3",
    imageName: "HeroCategoryAirport",
    supportSourcePageIDs: ["viet-phrase-phone-3", "viet-phrase-phone-4", "viet-phrase-phone-5"],
    supportSectionID: "search-surfacing-phone-repair-apps",
    supportTitle: "Phone fixes",
    supportBody: "Use these when the issue is a charger, screen, app, verification code, location pin, or repair shop.",
  },
  {
    id: "tours-sights.tickets-entry",
    collectionID: "tours-sights",
    title: "Tickets & entry",
    subtitle: "Entrance, exit, maps, tickets",
    symbolName: "ticket.fill",
    imageName: "HeroCategoryQuestions",
    supportSourcePageIDs: ["viet-phrase-sight-1", "viet-phrase-sight-2", "viet-phrase-sight-5"],
    supportSectionID: "search-surfacing-tickets-entry",
    supportTitle: "Tickets and entry",
    supportBody: "These belong at sights, museums, ticket booths, and tour desks when entry details are the next question.",
  },
  {
    id: "tours-sights.tours-guides",
    collectionID: "tours-sights",
    title: "Tours, guides, photos",
    subtitle: "Guide, meeting point, photos, what to bring",
    symbolName: "camera.fill",
    imageName: "HeroCategoryQuestions",
    supportSourcePageIDs: ["viet-phrase-sight-3", "viet-phrase-sight-5", "viet-phrase-sight-6"],
    supportSectionID: "search-surfacing-tours-guides",
    supportTitle: "Tour follow-ups",
    supportBody: "Use these when the plan involves a guide, meeting point, photos, safety, or what to bring.",
  },
  {
    id: "polite-repair.polite-basics-extra",
    collectionID: "polite-repair",
    title: "Polite basics",
    subtitle: "Yes, no, sorry, may I, sit here",
    symbolName: "hand.wave.fill",
    imageName: "HeroCategoryPoliteRepair",
    supportSourcePageIDs: ["viet-phrase-polite-2", "viet-phrase-polite-5", "viet-phrase-polite-6"],
    supportSectionID: "search-surfacing-polite-basics",
    supportTitle: "Small polite moves",
    supportBody: "These compact phrases help with yes, no, sorry, permission, hurry, and small social adjustments.",
  },
  {
    id: "local-greetings.small-talk-extra",
    collectionID: "local-greetings",
    title: "Small talk & boundaries",
    subtitle: "Recommendations, rain, rest, photos, alone time",
    symbolName: "bubble.left.and.bubble.right.fill",
    imageName: "HeroCategoryEssentials",
    supportSourcePageIDs: ["viet-phrase-smalltalk-4", "viet-phrase-smalltalk-5", "viet-phrase-polite-4"],
    supportSectionID: "search-surfacing-small-talk",
    supportTitle: "Small talk and boundaries",
    supportBody: "These are useful when casual conversation becomes practical, rainy, tiring, or too much.",
  },
  {
    id: "shopping.browse-buy",
    collectionID: "shopping",
    title: "Browse and buy",
    subtitle: "Touch it, see another, gift, too expensive",
    symbolName: "bag.fill",
    imageName: "HeroCategoryNumbersMoney",
    supportSourcePageIDs: ["viet-phrase-shop-4", "viet-phrase-shop-5", "viet-phrase-price-4"],
    supportSectionID: "search-surfacing-browse-buy",
    supportTitle: "While shopping",
    supportBody: "Use these when browsing turns into touching, comparing, gift shopping, buying, or politely walking away.",
  },
];

const subcategoryByID = new Map(subcategoryDefinitions.map((subcategory) => [subcategory.id, subcategory]));

function chooseHealth(english) {
  if (/\b(antiseptic|bandages|mosquito|repellent|sunscreen|rehydration|bitten by an insect)\b/.test(english)) {
    return "emergency.first-aid-supplies";
  }
  if (/\b(take|pill|pills|medicine|dose|days|times per day|alcohol|side effect|prescription|penicillin|allergy medicine|drug interaction|instructions|sleepy|safe with my medicine|emergency help)\b/.test(english)) {
    return "emergency.medicine";
  }
  if (/\b(clinic|dentist|doctor|hospital|medical report|receipt for insurance|clinic bill|clinic wait|come back)\b/.test(english)) {
    return "emergency.health-clinic";
  }
  if (/\b(pregnant|asthma|diabetes|allergic|allergy|penicillin|chest pain|trouble breathing)\b/.test(english)) {
    return "emergency.health-conditions";
  }
  return "emergency.health-symptoms";
}

function chooseEmergency(english) {
  if (/\b(passport|stolen|lost|report|wallet|credit card|embassy|tourist police|travel document|insurance)\b/.test(english)) {
    return "emergency.lost-report";
  }
  return "emergency.safety-now";
}

function chooseTime(english) {
  if (/\b(book|booking|reservation|change|wrong|deposit|move it|move this|online)\b/.test(english)) {
    return "questions.booking-changes";
  }
  return "questions.tickets-lines";
}

function chooseDirections(english) {
  if (/\b(map|pickup|street|address|pin|mall|corner|building|cafe|hotel|market|exit|place)\b/.test(english)) {
    return "getting-around.pickup-maps";
  }
  if (/\b(upstairs|downstairs|bridge|corner|inside|next to|across|behind|elevator|bus stop)\b/.test(english)) {
    return "getting-around.stairs-turns";
  }
  return "getting-around.walking-directions";
}

function chooseRepair(english) {
  if (/\b(translate|app|map|mark|point|show|phone|word|number|total|per person|right number|place on the map)\b/.test(english)) {
    return "polite-repair.translate-show";
  }
  return "polite-repair.clarify-specific";
}

function chooseMoney(english) {
  if (/\b(bill|cash|exchange|receipt|card|fee|tax|change|insurance|split|atm|smaller bills|large bills|wrong bill)\b/.test(english)) {
    return "numbers-money.cash-receipts";
  }
  return "numbers-money.prices-totals";
}

function chooseServices(english) {
  if (/\b(print|copy|scan|document|laundry|kilo|shrink|ready|fix|cost|how long|email)\b/.test(english)) {
    return "everyday-services.print-laundry";
  }
  return "everyday-services.water-rain-comfort";
}

function choosePhone(english) {
  if (/\b(sim|esim|data|wi-fi|wifi|internet|password|signal|gigabytes|valid|activate|phone call|outside the city)\b/.test(english)) {
    return "everyday-services.phone-sim-wifi";
  }
  return "everyday-services.phone-repair-apps";
}

function chooseSightseeing(english) {
  if (/\b(ticket|entrance|exit|included|entry|map|right entrance|buy tickets)\b/.test(english)) {
    return "tours-sights.tickets-entry";
  }
  return "tours-sights.tours-guides";
}

function subcategoryIDFor(row, phrase) {
  const english = normalize(row.englishTitle);

  switch (phrase.scenarioID) {
  case "health-pharmacy":
    return chooseHealth(english);
  case "emergency-safety":
  case "problems-help":
    return chooseEmergency(english);
  case "time-dates-booking":
    return chooseTime(english);
  case "directions-navigation":
    return chooseDirections(english);
  case "understanding-repair":
    return chooseRepair(english);
  case "money-numbers-prices":
    return chooseMoney(english);
  case "local-services-everyday-tasks":
    return chooseServices(english);
  case "bathroom-personal-needs":
    return "everyday-services.bathroom-personal";
  case "phone-internet-power":
    return choosePhone(english);
  case "sightseeing-activities":
    return chooseSightseeing(english);
  case "polite-basics":
    return "polite-repair.polite-basics-extra";
  case "social-small-talk":
    return "local-greetings.small-talk-extra";
  case "shopping":
    return "shopping.browse-buy";
  default:
    throw new Error(`No search-only surfacing rule for scenario: ${phrase.scenarioID} (${row.canonicalPageID})`);
  }
}

function supportSourcePageID(subcategory, targetPageID, index) {
  const candidates = subcategory.supportSourcePageIDs.filter((pageID) => pageID !== targetPageID);
  if (candidates.length === 0) {
    throw new Error(`No non-self support source available for ${targetPageID} in ${subcategory.id}`);
  }
  return candidates[index % candidates.length];
}

function makePlacementRows(audit, catalog) {
  const phraseByPageID = new Map(catalog.phrases.map((phrase) => [`viet-phrase-${phrase.id}`, phrase]));
  const keepRows = (audit.searchAuditRows ?? [])
    .filter((row) => row.searchAuditDecisionID === "keep-search-only")
    .sort((a, b) => String(a.canonicalPageID).localeCompare(String(b.canonicalPageID)));
  const subcategoryCounts = new Map();

  return keepRows.map((row) => {
    const phrase = phraseByPageID.get(row.canonicalPageID);
    if (!phrase) {
      throw new Error(`Missing phrase catalog row for ${row.canonicalPageID}`);
    }
    const subcategoryID = subcategoryIDFor(row, phrase);
    const subcategory = subcategoryByID.get(subcategoryID);
    if (!subcategory) {
      throw new Error(`Missing subcategory definition ${subcategoryID}`);
    }
    const sortOrder = subcategoryCounts.get(subcategoryID) ?? 0;
    subcategoryCounts.set(subcategoryID, sortOrder + 1);
    const sourcePageID = supportSourcePageID(subcategory, row.canonicalPageID, sortOrder);

    return {
      canonicalPageID: row.canonicalPageID,
      originalPageID: row.pageID,
      phraseID: row.runtimePhraseID,
      englishTitle: row.englishTitle,
      vietnameseTitle: row.title,
      sourceScenarioID: phrase.scenarioID,
      accessTier: row.runtimeAccessTier,
      clusterID: subcategoryID,
      browsePlacement: {
        collectionID: subcategory.collectionID,
        subcategoryID,
        sortOrder,
      },
      supportPlacements: [
        {
          sourcePageID,
          sectionID: subcategory.supportSectionID,
          sectionTitle: subcategory.supportTitle,
          sectionBody: subcategory.supportBody,
          displayLabel: subcategory.title,
          sortOrder,
        },
      ],
    };
  });
}

function writePlacementJSON(placements) {
  const payload = {
    version: 1,
    generatedAt: "source:listing-backdrop-audit-2026-05-29",
    sourceAudit: "docs/task-results/listing-backdrop-audit-2026-05-29/listing-backdrop-audit.json",
    intent: "Move all 315 keep-search-only rows into intentional Browse shelves and supporting detail-page phrase modules without deleting search access.",
    browseSubcategories: subcategoryDefinitions.map((subcategory) => ({
      id: subcategory.id,
      collectionID: subcategory.collectionID,
      title: subcategory.title,
      subtitle: subcategory.subtitle,
      symbolName: subcategory.symbolName,
      imageName: subcategory.imageName,
      supportSourcePageIDs: subcategory.supportSourcePageIDs,
      supportSectionID: subcategory.supportSectionID,
      supportTitle: subcategory.supportTitle,
      supportBody: subcategory.supportBody,
    })),
    placements: sortRows(placements),
  };

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, `${JSON.stringify(payload, null, 2)}\n`);
  return payload;
}

function writeSwift(payload) {
  const subcategories = payload.browseSubcategories.map((subcategory) => {
    const pageIDs = payload.placements
      .filter((row) => row.browsePlacement.subcategoryID === subcategory.id)
      .sort((a, b) => a.browsePlacement.sortOrder - b.browsePlacement.sortOrder)
      .map((row) => row.canonicalPageID);
    return { ...subcategory, pageIDs };
  });

  const blocks = subcategories.map((subcategory) => {
    const pageIDs = subcategory.pageIDs.map((pageID) => `                ${swiftString(pageID)},`).join("\n");
    return `        SearchOnlySubcategorySpec(
            id: ${swiftString(subcategory.id)},
            collectionID: ${swiftString(subcategory.collectionID)},
            title: ${swiftString(subcategory.title)},
            subtitle: ${swiftString(subcategory.subtitle)},
            symbolName: ${swiftString(subcategory.symbolName)},
            imageName: ${swiftString(subcategory.imageName)},
            pageIDs: [
${pageIDs}
            ]
        )`;
  }).join(",\n");

  const swift = `// Generated by native-ios/scripts/build-viet-search-only-surfacing.js.
// Source: ${sourcePath}

import Foundation

enum VietSearchOnlyPhraseSurfacing {
    private struct SearchOnlySubcategorySpec {
        let id: String
        let collectionID: String
        let title: String
        let subtitle: String
        let symbolName: String
        let imageName: String
        let pageIDs: [String]
    }

    static func subcategories(for collectionID: String, tintName: AccentTint) -> [BrowseCollectionSubcategory] {
        specs
            .filter { $0.collectionID == collectionID }
            .compactMap { spec in
                let items = uniquePhraseItems(spec.pageIDs.compactMap(BrowseSearchPhraseItem.resolve))
                guard !items.isEmpty else {
                    return nil
                }

                return BrowseCollectionSubcategory(
                    id: "\\(collectionID).search-only.\\(spec.id)",
                    title: spec.title,
                    subtitle: spec.subtitle,
                    symbolName: spec.symbolName,
                    tintName: tintName,
                    phraseCount: items.count,
                    imageName: spec.imageName,
                    items: items
                )
            }
    }

    private static func uniquePhraseItems(_ items: [BrowseSearchPhraseItem]) -> [BrowseSearchPhraseItem] {
        var seen = Set<String>()
        return items.filter { item in
            seen.insert(item.pageID).inserted
        }
    }

    private static let specs: [SearchOnlySubcategorySpec] = [
${blocks}
    ]
}
`;

  fs.writeFileSync(swiftOutputPath, swift);
}

function main() {
  const audit = readJSON(auditPath);
  const catalog = readJSON(catalogPath);
  const placements = makePlacementRows(audit, catalog);
  const payload = writePlacementJSON(placements);
  writeSwift(payload);

  const counts = new Map();
  for (const row of payload.placements) {
    const key = row.browsePlacement.subcategoryID;
    counts.set(key, (counts.get(key) ?? 0) + 1);
  }

  console.log(JSON.stringify({
    ok: true,
    placements: payload.placements.length,
    browseSubcategories: payload.browseSubcategories.length,
    counts: Object.fromEntries([...counts.entries()].sort((a, b) => a[0].localeCompare(b[0]))),
  }, null, 2));
}

main();
