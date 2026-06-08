#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const sourceRoot = path.join(repoRoot, "content-draft/viet/city-library/app-detail-v2-2");
const outputPath = path.join(
  repoRoot,
  "docs/content-audits/viet-city-listing-what-why-audit-2026-06-02.json"
);

const cities = ["danang", "hanoi", "hcmc", "hoian", "hue"];
const categoryTerms = {
  Restaurant: ["restaurant", "meal", "breakfast", "dinner", "lunch", "table", "kitchen", "grill", "seafood", "noodle", "bowl", "cafe", "coffee", "bar", "dessert", "bakery", "food", "shop", "specialist", "rice rolls", "phở", "pho"],
  Cafe: ["cafe", "coffee", "drink", "espresso", "tea", "roastery", "specialty-coffee", "restaurant table", "seated meal"],
  Market: ["market", "mall", "department store", "shopping", "storefronts", "stalls", "vendors", "goods", "aisles", "souvenir", "produce", "boutique", "tailor", "textile", "fabric"],
  Street: ["street", "walk", "shopfront", "sidewalk", "traffic", "corner", "block"],
  Neighborhood: ["district", "neighborhood", "quarter", "area", "streets", "city", "base", "ward", "old town", "ancient town", "old core", "riverside", "trading street", "heritage area"],
  Landmark: ["landmark", "temple", "pagoda", "museum", "palace", "bridge", "gate", "tower", "house", "citadel", "theatre", "church", "cathedral", "cathedral square", "apartment", "wharf", "tomb", "mausoleum", "square", "esplanade", "sanctuary", "skyline", "bronze urns", "dynastic urns"],
  Attraction: ["show", "theatre", "park", "ride", "viewpoint", "bridge", "performance", "amusement", "tour", "cable-car", "route", "walk", "drive", "loop", "deck", "skydeck", "rooftop", "class", "workshop", "music", "circus", "gallery", "skyline", "tunnel site", "street-food", "food lanes", "half-day"],
  Dish: ["dish", "plate", "bowl", "dumpling", "sandwich", "soup", "noodle", "rice", "pancake", "dessert", "sweet", "cake", "roll"],
  Dessert: ["dessert", "sweet", "ice cream", "jelly", "chè", "cake", "coconut"],
  Museum: ["museum", "gallery", "galleries", "art center", "collection", "exhibit", "display", "culture stop", "photo-room", "photo museum", "art space", "memory space"],
  Beach: ["beach", "sand", "shore", "water", "sea", "coast"],
  Village: ["village", "craft", "workshop", "old town", "trading street"],
  Nature: ["lake", "beach", "river", "mountain", "garden", "park", "island", "water", "view", "shade", "retreat", "outdoor edge", "mangrove", "mangrove forest", "forest"],
  Arrival: ["airport", "arrival", "terminal", "pickup", "immigration", "baggage", "border"],
  Station: ["station", "bus", "train", "platform", "terminal", "transport handoff"],
  Park: ["park", "garden", "green space", "lake", "shade", "walk"],
  Port: ["port", "wharf", "pier", "ferry", "boat", "riverfront"],
  Drink: ["drink", "coffee", "beer", "tea", "bar", "cafe"],
  River: ["river", "water", "boat", "wharf", "riverfront", "bridge"],
  Transport: ["airport", "station", "terminal", "bus", "taxi", "ride", "pickup"],
  Hotel: ["hotel", "stay", "lobby", "room"],
};

const identityTerms = new Set(
  Object.values(categoryTerms)
    .flat()
    .concat([
      "chinatown",
      "teppanyaki",
      "hibachi",
      "amusement",
      "water puppet",
      "walking route",
      "night market",
      "old house",
      "garden house",
      "food hall",
      "craft village",
      "boutique",
      "mall",
      "department store",
      "ward",
      "trading street",
      "beer street",
      "nightlife street",
      "sandwich",
      "bánh mì",
      "bánh xèo",
      "bún chả",
      "phở",
      "dumpling",
      "tapioca",
      "plate",
      "rice sheets",
      "rice rolls",
      "royal tomb",
      "tomb complex",
      "bronze urns",
      "dynastic urns",
      "square",
      "wharf",
      "apartment block",
      "art center",
      "court music",
      "coffee stop",
      "specialty-coffee",
      "cable-car",
      "table ritual",
      "transport handoff",
      "bus station",
      "village",
      "spa",
      "gallery",
      "workshop",
      "duck specialist",
      "mì quảng",
      "mỳ quảng",
      "chicken pho",
      "fabric market",
      "shopping mall",
      "observation deck",
      "photo museum",
      "wildlife drive",
      "bike loop",
      "assembly hall",
      "tailor atelier",
      "mausoleum",
      "esplanade",
      "sanctuary",
      "circus",
      "cathedral square",
      "street-food walk",
      "street-food evening",
      "wartime tunnel site",
      "mangrove forest",
      "ancient town",
      "landmark walk",
      "skyline tower",
      "rooftop",
    ])
);

const genericHeadings = /\b(easy|quiet|small|good|right|better|first|before|after|nearby|use|save|stop|pause|reset|timing|pace|room|view|choice|case|moment|route)\b/i;
const genericBodies = /\b(useful|easier|works?|fits?|makes sense|enough|start with|keep it|worth|belongs|good for|good when|when the plan|if the goal)\b/i;

const entries = cities.flatMap((city) => {
  const filePath = path.join(sourceRoot, `${city}.json`);
  return readEntries(filePath).map((entry) => ({ ...entry, filePath }));
});

const findings = entries.map(scoreEntry).filter((finding) => finding.flags.length > 0);
findings.sort((a, b) => b.score - a.score || a.pageID.localeCompare(b.pageID));

const report = {
  generatedAt: new Date().toISOString(),
  sourceRoot: path.relative(repoRoot, sourceRoot),
  totalEntries: entries.length,
  findingCount: findings.length,
  hardReviewCount: findings.filter((finding) => finding.score >= 6).length,
  findings,
};

fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, JSON.stringify(report, null, 2) + "\n");

console.log(`What/why audit wrote ${path.relative(repoRoot, outputPath)}`);
console.log(`Entries: ${report.totalEntries}`);
console.log(`Findings: ${report.findingCount}`);
console.log(`Hard review: ${report.hardReviewCount}`);
for (const finding of findings.slice(0, 25)) {
  console.log(`${finding.score} ${finding.pageID} :: ${finding.flags.join(", ")}`);
  console.log(`  ${finding.heading} — ${finding.body}`);
}

function scoreEntry(entry) {
  const heading = entry.intro?.heading || "";
  const body = entry.intro?.body || "";
  const visibleIntro = `${heading} ${body}`.toLowerCase();
  const travelerMoment = (entry.travelerMoment || "").toLowerCase();
  const storySpine = (entry.storySpine || "").toLowerCase();
  const category = entry.category || "";
  const expectedTerms = categoryTerms[category] || [];
  const flags = [];
  let score = 0;

  const visibleHasCategoryTerm = expectedTerms.some((term) => visibleIntro.includes(term));
  const visibleHasIdentityTerm = [...identityTerms].some((term) => visibleIntro.includes(term));
  const metadataHasCategoryTerm = expectedTerms.some((term) => travelerMoment.includes(term) || storySpine.includes(term));
  const titleOnlyIntro = startsWithNameOnly(entry, body);
  const headingIsGeneric = genericHeadings.test(heading) && !visibleHasCategoryTerm;
  const bodyIsGeneric = genericBodies.test(body) && !visibleHasIdentityTerm;

  if (!visibleHasCategoryTerm && metadataHasCategoryTerm) {
    flags.push("visible_intro_omits_metadata_identity");
    score += 4;
  }

  if (!visibleHasIdentityTerm) {
    flags.push("intro_lacks_clear_place_type");
    score += 3;
  }

  if (headingIsGeneric) {
    flags.push("generic_heading_before_identity");
    score += 2;
  }

  if (bodyIsGeneric) {
    flags.push("generic_body_without_identity");
    score += 2;
  }

  if (titleOnlyIntro) {
    flags.push("starts_with_name_but_not_definition");
    score += 2;
  }

  if (body.length > 220 && !body.includes(". ")) {
    flags.push("long_intro_without_mobile_break");
    score += 1;
  }

  return {
    pageID: entry.pageID,
    displayName: entry.displayName,
    englishName: entry.englishName,
    city: entry.city,
    category,
    score,
    flags,
    heading,
    body,
    travelerMoment: entry.travelerMoment,
    storySpine: entry.storySpine,
    sourceFile: path.relative(repoRoot, entry.filePath),
  };
}

function startsWithNameOnly(entry, body) {
  const lowerBody = body.toLowerCase();
  const names = [entry.displayName, entry.englishName].filter(Boolean).map((name) => name.toLowerCase());
  if (!names.some((name) => lowerBody.startsWith(name.toLowerCase()))) {
    return false;
  }

  const firstClause = lowerBody.split(/[.:;]/)[0];
  return ![...identityTerms].some((term) => firstClause.includes(term));
}

function readEntries(filePath) {
  const parsed = JSON.parse(fs.readFileSync(filePath, "utf8"));
  if (Array.isArray(parsed)) {
    return parsed;
  }

  for (const key of ["entries", "pages", "items"]) {
    if (Array.isArray(parsed[key])) {
      return parsed[key];
    }
  }

  const firstArray = Object.values(parsed).find(Array.isArray);
  if (firstArray) {
    return firstArray;
  }

  throw new Error(`Could not find entries array in ${filePath}`);
}
