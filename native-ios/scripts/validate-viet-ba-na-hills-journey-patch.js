#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const pageID = "viet-phrase-city-danang-place-ba-na-hills";
const authoredResourcePageID = "viet-family-city-danang-place-ba-na-hills";
const phraseID = "city-danang-place-ba-na-hills";
const patchID = "BNH-001";
const heroImageName = "HeroBaNaHills";

const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const patchPath = path.join(repoRoot, "docs", "editorial-exports", "viet-canonical-pages", "ba-na-hills-journey-v2", "SpeakLocal_Ba_Na_Hills_Journey_Patch_v2.json");
const approvalPath = path.join(repoRoot, "docs", "editorial-exports", "viet-canonical-pages", "ba-na-hills-journey-v2", "approved-imports-TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001.json");
const assetDir = path.join(nativeRoot, "Resources", "Assets.xcassets", `${heroImageName}.imageset`);

const expectedSectionOrder = [
  "at-glance",
  "quick-say",
  "journey-flow",
  "key-phrases",
  "breakdown",
  "good-to-know",
  "explore-next",
];
const expectedBodies = new Map([
  [
    "at-glance",
    "Treat Bà Nà Hills as a day-trip flow, not just a place name. The useful moments are pickup, tickets, cable car, photos, food or drinks, and the return ride.",
  ],
  ["quick-say", "Use this at the ticket counter or when asking staff for help."],
  [
    "good-to-know",
    "Ticket rules, hours, and pickup details can change. Keep your ticket or booking screen visible, and confirm where your return ride will meet you.",
  ],
  [
    "explore-next",
    "Practice the next phrases for getting there, finding the cable car, asking for photos, buying food or drinks, and getting back.",
  ],
]);
const expectedJourneyPhraseIDs = [
  "city-danang-go-ba-na-hills",
  "ves-two-tickets-ba-na-hills",
  "ves-where-cable-car",
  "ves-take-photo-for-me",
  "store-1",
  "ves-call-taxi-for-me",
];
const expectedKeyPhraseIDs = [
  "city-danang-go-ba-na-hills",
  "ves-two-tickets-ba-na-hills",
  "ves-where-cable-car",
  "ves-take-photo-for-me",
  "ves-call-taxi-for-me",
];
const expectedBreakdownTokens = [
  ["Bà Nà", "name recognition"],
  ["Hills", "English word in the attraction name"],
  ["Bà Nà Hills", "Ba Na Hills"],
];
const bannedPatterns = [
  /This is not a single place-name card/i,
  /Keep the page focused/i,
  /Connect to:/i,
  /\bdatabase\b/i,
  /\bimport\b/i,
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
  const cityLibrary = readJSON(cityLibraryPath);
  const authoredResource = readJSON(authoredPagesPath);
  const catalog = readJSON(catalogPath);
  const patch = readJSON(patchPath);
  const approval = readJSON(approvalPath);

  assert(patch.patches?.length === 1, "patch file must contain exactly one patch");
  const patchRow = patch.patches[0];
  assert(patchRow.page_id === pageID, `patch page_id changed: ${patchRow.page_id}`);
  assert(patchRow.authored_resource_page_id === authoredResourcePageID, `patch authored_resource_page_id changed: ${patchRow.authored_resource_page_id}`);
  assert(patchRow.phrase_id === phraseID, `patch phrase_id changed: ${patchRow.phrase_id}`);
  assert(approval.approvals?.length === 1, "approval overlay must contain exactly one approval");
  assert(approval.approvals[0].patch_id === patchID, `approval patch_id changed: ${approval.approvals[0].patch_id}`);
  assert(approval.approvals[0].import_approval === "APPROVED_FOR_IMPORT", `approval import_approval changed: ${approval.approvals[0].import_approval}`);

  const cityPage = cityLibrary.pages.find((page) => page.id === phraseID);
  assert(cityPage, `city library page missing ${phraseID}`);
  assert(cityPage.targetText === "Bà Nà Hills", "city library Vietnamese title changed");
  assert(cityPage.englishText === "Ba Na Hills", "city library English title changed");
  assert(cityPage.editorialImport?.patchID === patchID, "city library editorial patch missing");
  assert(cityPage.editorialImport?.sourcePatch === "SpeakLocal_Ba_Na_Hills_Journey_Patch_v2.json", "source patch marker missing");
  assert(cityPage.editorialImport?.replaceGeneratedSections === true, "replaceGeneratedSections must be true");
  assert(cityPage.editorialImport?.heroImageName === heroImageName, "city source hero image missing");

  const authoredPage = authoredResource.pages.find((page) => page.phraseID === phraseID);
  assert(authoredPage, `authored listing resource missing ${phraseID}`);
  assert(authoredPage.id === authoredResourcePageID, `authored page id changed: ${authoredPage.id}`);
  assert(authoredPage.title === "Bà Nà Hills", "authored Vietnamese title changed");
  assert(authoredPage.englishTitle === "Ba Na Hills", "authored English title changed");
  assert(authoredPage.heroImageName === heroImageName, "authored hero image missing");
  assertArrayEqual(ids(authoredPage.sections ?? []), expectedSectionOrder, "authored section order");
  for (const [sectionID, expectedBody] of expectedBodies) {
    assert(authoredPage.sections.find((section) => section.id === sectionID)?.body === expectedBody, `${sectionID} copy changed`);
  }
  assertArrayEqual(phraseIDs(authoredPage.sections.find((section) => section.id === "journey-flow")), expectedJourneyPhraseIDs, "journey flow phrase IDs");
  assertArrayEqual(phraseIDs(authoredPage.sections.find((section) => section.id === "key-phrases")), expectedKeyPhraseIDs, "key phrase IDs");
  const breakdown = authoredPage.sections.find((section) => section.id === "breakdown");
  assert(breakdown?.title === "Name guide", "breakdown title must be Name guide");
  assertArrayEqual(
    (breakdown?.breakdown ?? []).map((token) => [token.vietnamese, token.english]),
    expectedBreakdownTokens,
    "Name guide breakdown tokens"
  );
  assert(!ids(authoredPage.sections ?? []).includes("relationship-words"), "Bà Nà page must not include relationship words");

  const keyPhraseBody = authoredPage.sections.find((section) => section.id === "key-phrases")?.body ?? "";
  assert(!keyPhraseBody.includes("/"), "Key phrase body must not contain slash-separated copy");
  const pageText = JSON.stringify(authoredPage);
  for (const pattern of bannedPatterns) {
    assert(!pattern.test(pageText), `Bà Nà page contains banned/meta wording: ${pattern}`);
  }

  const storePhrase = catalog.phrases.find((phrase) => phrase.id === "store-1");
  assert(storePhrase, "store-1 phrase missing from catalog");
  assert(storePhrase.targetText === "Cho tôi chai nước", `store-1 Vietnamese changed: ${storePhrase.targetText}`);
  assert(storePhrase.englishText === "A bottle of water please", `store-1 English changed: ${storePhrase.englishText}`);
  assert(storePhrase.audioKey === "store-1", `store-1 audio key changed: ${storePhrase.audioKey}`);

  const sqlitePages = sqliteJSON(`
    SELECT pp.id, pp.phrase_id, pp.title, pp.english_title, pp.hero_image_name
    FROM phrase_page pp
    WHERE pp.phrase_id = '${phraseID}';
  `);
  assert(sqlitePages.length === 1, `expected one SQLite phrase_page for ${phraseID}, found ${sqlitePages.length}`);
  assert(sqlitePages[0].id === pageID, `SQLite canonical page id changed: ${sqlitePages[0].id}`);
  assert(sqlitePages[0].title === "Bà Nà Hills", "SQLite Vietnamese title changed");
  assert(sqlitePages[0].english_title === "Ba Na Hills", "SQLite English title changed");
  assert(sqlitePages[0].hero_image_name === heroImageName, "SQLite hero_image_name missing");

  const duplicateTitleRows = sqliteJSON(`
    SELECT lower(trim(title)) AS title_key, count(*) AS page_count
    FROM phrase_page
    WHERE lower(trim(title)) = lower(trim('Bà Nà Hills'))
    GROUP BY lower(trim(title));
  `);
  assert(duplicateTitleRows.length === 1 && Number(duplicateTitleRows[0].page_count) === 1, "duplicate Bà Nà Hills canonical pages found");

  const sqliteSections = sqliteJSON(`
    SELECT section_key AS id
    FROM page_section
    WHERE page_id = '${pageID}'
    ORDER BY sort_order;
  `);
  assertArrayEqual(ids(sqliteSections), expectedSectionOrder, "SQLite section order");
  const sqliteJourneyRows = sqliteJSON(`
    SELECT psi.target_id AS id
    FROM page_section ps
    JOIN page_section_item psi ON psi.section_id = ps.id
    WHERE ps.page_id = '${pageID}'
      AND ps.section_key = 'journey-flow'
      AND psi.item_kind = 'phrase'
    ORDER BY psi.sort_order;
  `);
  assertArrayEqual(ids(sqliteJourneyRows), expectedJourneyPhraseIDs, "SQLite journey flow phrase IDs");
  const sqliteKeyRows = sqliteJSON(`
    SELECT psi.target_id AS id
    FROM page_section ps
    JOIN page_section_item psi ON psi.section_id = ps.id
    WHERE ps.page_id = '${pageID}'
      AND ps.section_key = 'key-phrases'
      AND psi.item_kind = 'phrase'
    ORDER BY psi.sort_order;
  `);
  assertArrayEqual(ids(sqliteKeyRows), expectedKeyPhraseIDs, "SQLite key phrase IDs");

  assert(fs.existsSync(path.join(assetDir, "Contents.json")), "HeroBaNaHills Contents.json missing");
  assert(fs.existsSync(path.join(assetDir, "hero-ba-na-hills.png")), "HeroBaNaHills PNG missing");
  const phraseListingView = fs.readFileSync(path.join(nativeRoot, "App", "Views", "PhraseListingView.swift"), "utf8");
  assert(
    phraseListingView.includes("HeroMastheadImage(imageName: page.heroImageName ?? PhrasePageStyle.heroImageName)"),
    "PhraseListingView is not using per-page hero image metadata"
  );

  console.log("Bà Nà Hills journey patch validation passed.");
}

main();
