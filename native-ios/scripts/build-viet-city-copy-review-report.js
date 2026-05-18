#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const sourcePath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const outputPath = path.join(repoRoot, "docs", "content-audits", "viet-city-copy-production-2026-05-17.json");

const reviewID = "viet-city-copy-production-2026-05-17";
const expectedCities = ["hcmc", "hanoi", "danang", "hoian", "hue"];
const bannedFragments = [
  "Vietnamese name shown here",
  "English meaning to keep in mind",
  "play it aloud",
  "play the name",
  "from the app",
  "shown here",
  "content role",
  "the row",
  "this row",
  "generator",
  "template",
  "database",
  "exact venue",
  "full name is what helps",
  "driver, ticket desk, server",
  "Keep the Use it",
  "Keep the next words ordinary",
  "phrasebook value comes from small choices",
  "payment and ride-back phrases matter",
  "Then ask for one portion, what is inside, sauce, spice, sweetness, or ice",
  "Start with [dish], then ask for one portion, what is inside",
  "before asking what is inside or how it is served",
  "that first ingredient question protects the flavor",
  "keep the table, menu, recommendation, ingredient check, drink choice, bill, and pickup point",
  "For transit stops, the practical question is where to stand next",
  "allergy risk usually live",
  "tickets, entrance, bathrooms, photos, or the return ride",
];
const formulaicPatterns = [
  /use the vietnamese name when/i,
  /use [^,.]+ when the destination is/i,
  /think in sequence:\s*arrival/i,
  /do the real work/i,
  /becomes legible/i,
  /this is a more deliberate/i,
  /\. keep\b/,
  /start with [^,.]+, then ask for one portion, what is inside/i,
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFC")
    .replace(/\s+/g, " ")
    .trim();
}

function normalizedLower(value) {
  return normalize(value).toLowerCase();
}

function profileFor(page) {
  const placeKind = normalizedLower(page.placeKind);
  const pageKind = normalizedLower(page.pageKind || page.kind);
  if (placeKind === "street" || placeKind === "neighborhood") return "street-neighborhood";
  if (["airport", "station", "port", "pier"].includes(placeKind)) return "transit";
  if (placeKind === "market" || page.subcategoryID === "shopping-markets") return "market";
  if (placeKind === "cafe") return "cafe";
  if (pageKind === "restaurant" || placeKind === "restaurant") return "restaurant";
  if (["dish", "drink", "dessert"].includes(pageKind) || ["dish", "drink", "dessert", "local dish", "food spot"].includes(placeKind)) return "dish";
  if (["experience", "attraction", "village", "river", "beach", "nature", "park", "landmark", "museum"].includes(placeKind)) return "place-experience";
  return "place";
}

function pageText(page) {
  const editorial = page.editorialImport ?? {};
  return [
    editorial.summary,
    ...(editorial.sections ?? []).flatMap((section) => [section.title, section.body]),
  ].filter(Boolean).join("\n");
}

function sectionBody(page, id) {
  return normalize((page.editorialImport?.sections ?? []).find((section) => section.id === id)?.body);
}

function excerpt(value, maxLength = 220) {
  const text = normalize(value);
  if (text.length <= maxLength) return text;
  return `${text.slice(0, maxLength).replace(/\s+\S*$/, "")}...`;
}

function visibleBannedMatches(text) {
  const matches = [];
  const lower = normalizedLower(text);
  for (const fragment of bannedFragments) {
    if (lower.includes(fragment.toLowerCase())) {
      matches.push(fragment);
    }
  }
  for (const pattern of formulaicPatterns) {
    if (pattern.test(text)) {
      matches.push(String(pattern));
    }
  }
  return matches;
}

function profileAudienceCuePass(page, text) {
  const lower = normalizedLower(text);
  const patternsByProfile = {
    "street-neighborhood": [/street/, /shopfront/, /crossing/, /map pin/, /neighborhood/, /hotel edge/, /lane/],
    transit: [/arrival/, /platform/, /route board/, /luggage/, /station door/, /city light/, /sign/, /boat/, /river/, /boarding/, /water/, /pier/],
    market: [/stall/, /snack/, /gift/, /color/, /bargain/, /market/, /browsing/, /shop/, /storefront/, /food counter/, /cool air/, /fabric/, /fitting/, /measuring tape/, /custom-made/, /handmade/, /workshop/, /tool/, /material/],
    cafe: [/coffee/, /ice/, /sweet/, /street stool/, /counter/, /pause/, /espresso/, /cafe/],
    restaurant: [/table/, /menu/, /drink/, /house dish/, /staff/, /meal/, /dining/],
    dish: [/menu/, /texture/, /herb/, /sauce/, /spic/, /sweet/, /ice/, /topping/, /coconut/, /flavor/, /dish/, /beer/, /glass/, /stool/, /snack/, /evening street/],
    "place-experience": [/view/, /entry detail/, /photo/, /local pride/, /stage/, /light/, /water/, /gate/, /courtyard/, /temple/, /visit/, /route/, /dish/, /spice/, /shared plate/, /local appetite/, /food/, /craft/, /hands/, /material/, /skill/, /museum/, /art/, /history/, /objects?/, /artifacts?/],
    place: [/photo/, /market/, /map/, /city/, /street/, /view/, /water/, /food/, /culture/],
  };
  return (patternsByProfile[profileFor(page)] ?? patternsByProfile.place).some((pattern) => pattern.test(lower));
}

function uniqueLongSectionBodies(page) {
  const bodies = (page.editorialImport?.sections ?? [])
    .map((section) => normalizedLower(section.body))
    .filter((body) => body.length >= 60);
  return new Set(bodies).size;
}

function pageChecklist(page) {
  const text = pageText(page);
  const sections = page.editorialImport?.sections ?? [];
  const bannedMatches = visibleBannedMatches(text);
  const sourceText = [page.context, page.tip, page.rationale].filter(Boolean).join("\n");
  const sourceBannedMatches = visibleBannedMatches(sourceText);
  const runtimeOverride = page.editorialImport?.runtimeOverride;
  return {
    voiceLengthPass: text.length >= 480,
    sectionCountPass: sections.length >= 4,
    profileAudienceCuePass: profileAudienceCuePass(page, text),
    noBannedVisibleTextPass: bannedMatches.length === 0,
    noBannedSourceInputPass: sourceBannedMatches.length === 0,
    sourceNotesPresent: Boolean(page.editorialImport?.sourceNotes || page.sourceIDs?.length),
    targetHeroPresent: Boolean(page.editorialImport?.targetHeroImageName),
    durableReviewEvidencePresent: page.editorialImport?.reviewEvidence?.reviewID === reviewID,
    sectionBodiesDistinctEnough: uniqueLongSectionBodies(page) >= Math.min(4, sections.length),
    runtimeOverrideExplicit: page.id === "city-danang-place-ba-na-hills"
      ? runtimeOverride?.kind === "ba-na-hills-journey" && (runtimeOverride.expectedSectionIDs ?? []).length >= 8
      : true,
    bannedMatches,
    sourceBannedMatches,
  };
}

function pageEvidence(page) {
  return {
    summaryExcerpt: excerpt(page.editorialImport?.summary),
    aboutExcerpt: excerpt(sectionBody(page, "at-glance")),
    phrasebookExcerpt: excerpt(sectionBody(page, "quick-say")),
    belongingExcerpt: excerpt(sectionBody(page, "use-it-with") || sectionBody(page, "table-menu") || sectionBody(page, "how-to-order")),
    timingExcerpt: excerpt(sectionBody(page, "when-to-use") || sectionBody(page, "before-you-go")),
    goodToKnowExcerpt: excerpt(sectionBody(page, "good-to-know")),
  };
}

function statusForChecklist(checklist) {
  const booleans = Object.entries(checklist)
    .filter(([, value]) => typeof value === "boolean");
  return booleans.every(([, value]) => value) ? "APPROVE" : "FIX_NOW";
}

function checklistFailures(checklist) {
  return Object.entries(checklist)
    .filter(([, value]) => value === false)
    .map(([key]) => key);
}

function main() {
  const source = readJSON(sourcePath);
  const pages = (source.pages ?? [])
    .filter((page) => page.kind !== "phrase" && page.status === "approved")
    .sort((a, b) => `${a.cityID}:${a.id}`.localeCompare(`${b.cityID}:${b.id}`));

  const reportPages = pages.map((page) => {
    const checklist = pageChecklist(page);
    const status = statusForChecklist(checklist);
    return {
      id: page.id,
      cityID: page.cityID,
      pageKind: page.pageKind,
      placeKind: page.placeKind,
      profile: profileFor(page),
      reviewer: `city-owner:${page.cityID}`,
      status,
      blockerLevel: status === "APPROVE" ? "NONE" : "SAFE_FIX_NOW",
      checklist,
      failures: checklistFailures(checklist),
      evidence: pageEvidence(page),
    };
  });

  const byCity = Object.fromEntries(expectedCities.map((cityID) => [
    cityID,
    {
      pages: reportPages.filter((page) => page.cityID === cityID).length,
      approved: reportPages.filter((page) => page.cityID === cityID && page.status === "APPROVE").length,
      fixNow: reportPages.filter((page) => page.cityID === cityID && page.status === "FIX_NOW").length,
    },
  ]));

  const report = {
    reviewID,
    generatedAt: new Date().toISOString(),
    scope: "500 city noun/place pages plus 5 city hubs",
    source: path.relative(repoRoot, sourcePath),
    evidenceMode: "Every row stores current copy excerpts and computed pass/fail checks; native validation must also prove source/runtime parity before the report is accepted.",
    editorialStandard: [
      "Lead with the place, food, culture, or travel moment.",
      "Make the place, food, culture, or travel moment vivid before the trip.",
      "Keep noun-first Browse behavior and page-type-specific sensory or cultural cues.",
      "Avoid volatile claims about hours, rankings, prices, schedules, or access rules.",
    ],
    summary: {
      totalPages: reportPages.length,
      approved: reportPages.filter((page) => page.status === "APPROVE").length,
      fixNow: reportPages.filter((page) => page.status === "FIX_NOW").length,
      hardBlock: 0,
      followUp: 0,
      acceptedTemporaryRisk: 0,
      byCity,
    },
    pages: reportPages,
  };

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, `${JSON.stringify(report, null, 2)}\n`);
  console.log(`Wrote ${path.relative(process.cwd(), outputPath)}`);
}

main();
