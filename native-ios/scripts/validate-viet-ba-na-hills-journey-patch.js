#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");

const sqlitePageID = "viet-phrase-city-danang-place-ba-na-hills";
const authoredResourcePageID = "viet-family-city-danang-place-ba-na-hills";
const phraseID = "city-danang-place-ba-na-hills";
const heroImageName = "HeroCityDanangPlaceBaNaHills";

const appDetailPath = path.join(repoRoot, "content-draft", "viet", "city-library", "app-detail-v2-2", "danang.json");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const assetDir = path.join(nativeRoot, "Resources", "Assets.xcassets", `${heroImageName}.imageset`);

const expectedSectionOrder = [
  "at-glance",
  "quick-say",
  "place-brief",
  "use-it-with",
  "when-to-use",
  "getting-there",
  "tickets",
  "cable-car",
  "photos",
  "getting-back",
  "good-to-know",
  "food-cash",
];

const expectedSourceHeadings = [
  "Early, With Weather Checked",
  "Cable Car Arrival",
  "Bridge Before Wandering",
  "Give It Room",
];

const expectedBodies = new Map([
  [
    "at-glance",
    "A mountain theme park above Da Nang: cable cars, cooler air, the Golden Bridge, gardens, replica streets, crowds, and weather risk.",
  ],
  [
    "place-brief",
    "Morning is the least painful crowd strategy. Fog or rain can turn the famous view into an expensive cloud walk, so the forecast matters before the ride west.",
  ],
  [
    "use-it-with",
    "The climb turns city heat into a mountain day: forest below, mist on the glass, cooler air at the upper level. Clear sky makes the scale feel cinematic.",
  ],
  [
    "when-to-use",
    "If the Golden Bridge is the main reason, do it first. After that, decide how much of the wider park the group actually wants.",
  ],
  [
    "good-to-know",
    "Travel time, tickets, cable cars, walking, and crowd flow all take space. A lighter city day leaves room for the mountain weather and the long ride back.",
  ],
]);

const expectedRows = new Map([
  ["quick-say", ["sight-1", "sight-3", "sight-4"]],
  ["getting-there", ["taxi-1", "repair-5", "transport-stop-here-clearer", "ves-is-this-address-correct"]],
  ["tickets", ["v500-time-date-book-two-tickets-please", "v500-time-date-book-one-ticket-please", "v500-sigh-acti-where-can-i-buy-tickets"]],
  ["cable-car", ["ves-where-cable-car"]],
  ["photos", ["ves-take-photo-for-me"]],
  ["getting-back", ["ves-call-taxi-for-me"]],
  ["food-cash", ["store-1", "airport-4"]],
]);

const bannedPatterns = [
  /\bRelated because\b/i,
  /\bMentioned here because\b/i,
  /\bdo_not_render\b/i,
  /\bdatabase\b/i,
  /\bschema\b/i,
  /\bvalidator\b/i,
  /\bFINAL_PASS\b/i,
  /This is not a single place-name card/i,
  /Keep the page focused/i,
  /Connect to:/i,
  /REVIEW_ONLY/i,
  /Watch out/i,
  /repair phrase/i,
  /Understanding Repair/i,
  /question marker/i,
  /literal meaning/i,
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function sqliteJSON(sql) {
  const result = spawnSync("sqlite3", ["-json", databasePath, sql], {
    cwd: repoRoot,
    encoding: "utf8",
    maxBuffer: 32 * 1024 * 1024,
  });
  if (result.status !== 0) {
    throw new Error(`sqlite3 failed\nSQL:\n${sql}\nSTDERR:\n${result.stderr}`);
  }
  const output = result.stdout.trim();
  return output ? JSON.parse(output) : [];
}

function ids(rows) {
  return rows.map((row) => row.id);
}

function phraseIDs(section) {
  return (section?.phrases ?? []).map((phrase) => phrase.id);
}

function assertArrayEqual(actual, expected, label) {
  assert(
    JSON.stringify(actual) === JSON.stringify(expected),
    `${label} mismatch\nexpected: ${JSON.stringify(expected)}\nactual: ${JSON.stringify(actual)}`
  );
}

function main() {
  const appDetail = readJSON(appDetailPath);
  const cityLibrary = readJSON(cityLibraryPath);
  const authoredResource = readJSON(authoredPagesPath);

  const sourcePage = appDetail.entries.find((page) => page.id === authoredResourcePageID);
  assert(sourcePage, `V2.2 source page missing ${authoredResourcePageID}`);
  assert(sourcePage.displayName === "Bà Nà Hills", "V2.2 Vietnamese title changed");
  assert(sourcePage.englishName === "Ba Na Hills", "V2.2 English title changed");
  assert(sourcePage.intro?.heading === "More Park Than Viewpoint", "V2.2 intro heading changed");
  assertArrayEqual((sourcePage.sections ?? []).map((section) => section.heading), expectedSourceHeadings, "V2.2 source headings");
  assertArrayEqual((sourcePage.usefulPhraseCards ?? []).map((card) => card.phraseId), ["sight-1", "sight-3", "sight-4"], "V2.2 useful phrase cards");

  const cityPage = cityLibrary.pages.find((page) => page.id === phraseID);
  assert(cityPage, `city library page missing ${phraseID}`);
  assert(cityPage.targetText === "Bà Nà Hills", "city library Vietnamese title changed");
  assert(cityPage.englishText === "Ba Na Hills", "city library English title changed");
  assert(cityPage.editorialImport?.runtimeOverride?.kind === "ba-na-hills-journey", "runtime override kind missing");
  assert(cityPage.editorialImport?.heroImageName === heroImageName, "city source hero image missing");
  assertArrayEqual(cityPage.editorialImport?.runtimeOverride?.expectedSectionIDs ?? [], expectedSectionOrder, "runtime override expected sections");

  const authoredPage = authoredResource.pages.find((page) => page.id === authoredResourcePageID);
  assert(authoredPage, `authored listing resource missing ${authoredResourcePageID}`);
  assert(authoredPage.phraseID === phraseID, `authored phrase id changed: ${authoredPage.phraseID}`);
  assert(authoredPage.title === "Bà Nà Hills", "authored Vietnamese title changed");
  assert(authoredPage.englishTitle === "Ba Na Hills", "authored English title changed");
  assert(authoredPage.heroImageName === heroImageName, "authored hero image missing");
  assertArrayEqual(ids(authoredPage.sections ?? []), expectedSectionOrder, "authored section order");

  const authoredTitles = new Map((authoredPage.sections ?? []).map((section) => [section.id, section.title]));
  assert(authoredTitles.get("at-glance") === "More Park Than Viewpoint", "Bà Nà rendered intro title regressed to a generic label");
  assert(authoredTitles.get("good-to-know") === "Give It Room", "Bà Nà rendered final prose title regressed to a generic label");
  assert(!["About", "Good to know"].includes(authoredTitles.get("at-glance")), "generic About label rendered");
  assert(!["About", "Good to know"].includes(authoredTitles.get("good-to-know")), "generic Good to know label rendered");

  for (const [sectionID, expectedBody] of expectedBodies) {
    assert(authoredPage.sections.find((section) => section.id === sectionID)?.body === expectedBody, `${sectionID} copy changed`);
  }
  for (const [sectionID, expectedPhraseIDs] of expectedRows) {
    assertArrayEqual(phraseIDs(authoredPage.sections.find((section) => section.id === sectionID)), expectedPhraseIDs, `${sectionID} phrase IDs`);
  }
  assert(!ids(authoredPage.sections ?? []).includes("relationship-words"), "Bà Nà page must not include relationship words");

  const pageText = JSON.stringify(authoredPage);
  for (const pattern of bannedPatterns) {
    assert(!pattern.test(pageText), `Bà Nà page contains banned/meta wording: ${pattern}`);
  }

  const sqlitePages = sqliteJSON(`
    SELECT pp.id, pp.phrase_id, pp.title, pp.english_title, pp.hero_image_name
    FROM phrase_page pp
    WHERE pp.phrase_id = '${phraseID}';
  `);
  assert(sqlitePages.length === 1, `expected one SQLite phrase_page for ${phraseID}, found ${sqlitePages.length}`);
  assert(sqlitePages[0].id === sqlitePageID, `SQLite canonical page id changed: ${sqlitePages[0].id}`);
  assert(sqlitePages[0].title === "Bà Nà Hills", "SQLite Vietnamese title changed");
  assert(sqlitePages[0].english_title === "Ba Na Hills", "SQLite English title changed");
  assert(sqlitePages[0].hero_image_name === heroImageName, "SQLite hero_image_name missing");

  const sqliteSections = sqliteJSON(`
    SELECT section_key AS id
    FROM page_section
    WHERE page_id = '${sqlitePageID}'
    ORDER BY sort_order;
  `);
  assertArrayEqual(ids(sqliteSections), expectedSectionOrder, "SQLite section order");
  for (const [sectionID, expectedPhraseIDs] of expectedRows) {
    const sqliteRows = sqliteJSON(`
      SELECT psi.target_id AS id
      FROM page_section ps
      JOIN page_section_item psi ON psi.section_id = ps.id
      WHERE ps.page_id = '${sqlitePageID}'
        AND ps.section_key = '${sectionID}'
        AND psi.item_kind = 'phrase'
      ORDER BY psi.sort_order;
    `);
    assertArrayEqual(ids(sqliteRows), expectedPhraseIDs, `SQLite ${sectionID} phrase IDs`);
  }

  assert(fs.existsSync(path.join(assetDir, "Contents.json")), "HeroCityDanangPlaceBaNaHills Contents.json missing");
  assert(fs.existsSync(path.join(assetDir, "hero-city-danang-place-ba-na-hills-720q80.jpg")), "HeroCityDanangPlaceBaNaHills image missing");

  console.log("Bà Nà Hills V2.2 journey validation passed.");
}

main();
