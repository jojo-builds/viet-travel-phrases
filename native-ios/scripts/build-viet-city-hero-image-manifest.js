#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const outputPath = process.argv[2]
  ? path.resolve(process.argv[2])
  : path.join(repoRoot, "docs", "editorial-exports", "viet-image-assets", "city-hero-production-505", "manifest.json");

const hubRows = [
  {
    id: "hub-hanoi",
    kind: "cityHub",
    cityID: "hanoi",
    pageID: "browse-city-hanoi",
    title: "Hanoi / Hà Nội",
    profile: "cityHub",
    targetHeroImageName: "HeroCityHanoi",
    imagePromptNote: "Old Quarter lanes, Hoan Kiem lake mood, northern city texture, no readable signs.",
  },
  {
    id: "hub-hcmc",
    kind: "cityHub",
    cityID: "hcmc",
    pageID: "browse-city-hcmc",
    title: "Ho Chi Minh City / Thành phố Hồ Chí Minh",
    profile: "cityHub",
    targetHeroImageName: "HeroCityHcmc",
    imagePromptNote: "Saigon street energy, central market or skyline cue, tropical evening light, no logos.",
  },
  {
    id: "hub-danang",
    kind: "cityHub",
    cityID: "danang",
    pageID: "browse-city-danang",
    title: "Da Nang / Đà Nẵng",
    profile: "cityHub",
    targetHeroImageName: "HeroCityDanang",
    imagePromptNote: "Dragon Bridge or Han River cue, beach-city openness, clean realistic travel masthead.",
  },
  {
    id: "hub-hoian",
    kind: "cityHub",
    cityID: "hoian",
    pageID: "browse-city-hoian",
    title: "Hoi An / Hội An",
    profile: "cityHub",
    targetHeroImageName: "HeroCityHoian",
    imagePromptNote: "Lantern streets, old town walls, river warmth, realistic not postcard-like.",
  },
  {
    id: "hub-hue",
    kind: "cityHub",
    cityID: "hue",
    pageID: "browse-city-hue",
    title: "Hue / Huế",
    profile: "cityHub",
    targetHeroImageName: "HeroCityHue",
    imagePromptNote: "Imperial gate, Perfume River, garden-house calm, respectful historic mood.",
  },
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function profileFor(page) {
  const placeKind = String(page.placeKind ?? "").toLowerCase();
  const pageKind = String(page.pageKind ?? page.kind ?? "").toLowerCase();
  if (placeKind === "airport" || placeKind === "station" || placeKind === "port" || placeKind === "pier") return "airportStation";
  if (placeKind === "street" || placeKind === "neighborhood") return "street";
  if (placeKind === "market") return "market";
  if (placeKind === "cafe" || pageKind === "restaurant" || placeKind === "restaurant") return "restaurantCafe";
  if (pageKind === "dish" || placeKind === "dish" || page.contentRole === "dish") return "dish";
  if (placeKind === "beach" || placeKind === "nature" || placeKind === "river" || placeKind === "park") return "beachNature";
  if (placeKind === "museum") return "museumCulture";
  if (placeKind === "experience" || placeKind === "attraction" || placeKind === "village") return "experience";
  return "landmark";
}

function promptFor(row) {
  const profileLine = {
    cityHub: "a city hub masthead with one strong local cue",
    landmark: "a recognizable landmark/place hero",
    street: "a street or neighborhood context with realistic pickup/navigation cues",
    market: "a market scene with goods, aisles, cash-and-price atmosphere",
    restaurantCafe: "a restaurant, cafe, dish table, or entrance mood without copied signage",
    dish: "an appetizing Vietnamese dish/drink close-up with realistic texture",
    airportStation: "an arrival or transfer scene with curb, terminal, station, or luggage cues",
    beachNature: "a beach, river, park, or nature scene with realistic weather and depth",
    museumCulture: "a cultural or museum scene with respectful lighting and no copied exhibit text",
    experience: "an experience or day-trip scene with the main activity/place cue visible",
  }[row.profile] ?? "a realistic travel hero";

  return [
    "Use case: photorealistic-natural",
    "Asset type: native iOS tall city hero image",
    `Primary request: Create ${profileLine} for SpeakLocal Vietnam.`,
    `Page: ${row.title}`,
    `City: ${row.cityID}`,
    `Specific subject guidance: ${row.imagePromptNote}`,
    "Composition: vertical masthead source, key subject centered in the upper third and center 70% width, with enough soft background for an iOS title fade.",
    "Style: realistic travel/editorial photo, natural light, app-owned, premium but not glossy stock-photo artificial.",
    "Constraints: no readable text, no fake signs, no logos, no watermarks, no people as the main subject, no wrong-city cues, no generic Ha Long Bay imagery unless the page is actually Ha Long Bay.",
  ].join("\n");
}

function main() {
  const library = readJSON(cityLibraryPath);
  const placeRows = (library.pages ?? [])
    .filter((page) => page.kind === "place" && page.status === "approved")
    .map((page) => ({
      id: page.id,
      kind: "cityPlace",
      cityID: page.cityID,
      pageID: `viet-family-${page.id}`,
      sourcePageID: page.id,
      title: `${page.targetText ?? ""} / ${page.englishText ?? ""}`.trim(),
      profile: profileFor(page),
      currentHeroImageName: page.heroImageName ?? "",
      targetHeroImageName: page.productionIntake?.targetHeroImageName ?? page.editorialImport?.targetHeroImageName ?? "",
      imagePromptNote: page.productionIntake?.imagePromptNote ?? page.editorialImport?.imagePromptNote ?? "",
    }));

  const rows = [...hubRows, ...placeRows].map((row, index) => ({
    ...row,
    queueIndex: index + 1,
    status: "needs_generation",
    sourceImagePath: "",
    approvedImagePath: "",
    rejectReason: "",
    reviewerNotes: "",
    prompt: promptFor(row),
  }));

  ensureDir(path.dirname(outputPath));
  fs.writeFileSync(outputPath, `${JSON.stringify({
    generatedAt: new Date().toISOString(),
    totalRows: rows.length,
    expectedRows: 505,
    targetDimensions: "853 x 1844",
    reviewGate: {
      requiredReviewAgents: 2,
      doneDefinition: "All 505 images are realistic, accurate to the page/city, unique where required, imported into the app, wired through runtime resources and SQLite, strict validators pass, and the app is running on the simulator for testing.",
    },
    rows,
  }, null, 2)}\n`, "utf8");
  console.log(`Wrote ${rows.length} city hero image rows to ${path.relative(repoRoot, outputPath)}`);
  if (rows.length !== 505) {
    process.exitCode = 1;
    console.error(`ERROR: expected 505 rows, got ${rows.length}`);
  }
}

main();
