#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const supportPagesPath = path.join(
  repoRoot,
  "content-draft",
  "viet",
  "editorial-model-support",
  "TASK-VIET-EDITORIAL-MODEL-SUPPORT-001",
  "source",
  "support-pages.json"
);
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const sqlitePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");

const attractionPlaceKinds = new Set([
  "attraction",
  "beach",
  "landmark",
  "museum",
  "nature",
  "park",
  "river",
  "village",
]);

const retiredPhraseIDs = new Set([
  "ves-two-tickets-ba-na-hills",
  "ves-drop-near-dragon-bridge",
  "ves-take-me-to-ba-na-hills",
  "ves-one-ticket-marble-mountains-polite",
  "ves-two-tickets-marble-mountains",
  "ves-take-me-to-dragon-bridge",
]);

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function sqliteJSON(sql) {
  const result = spawnSync("sqlite3", ["-json", sqlitePath, sql], {
    cwd: repoRoot,
    encoding: "utf8",
    maxBuffer: 64 * 1024 * 1024,
  });
  if (result.status !== 0) {
    throw new Error(`sqlite3 failed\nSQL:\n${sql}\nSTDERR:\n${result.stderr}`);
  }
  return result.stdout.trim() ? JSON.parse(result.stdout) : [];
}

function addFailure(failures, label, detail) {
  failures.push(`${label}: ${detail}`);
}

function isAttractionPlaceKind(kind) {
  return attractionPlaceKinds.has(String(kind ?? ""));
}

function pagePhraseRows(page) {
  return (page.sections ?? []).flatMap((section) =>
    (section.phrases ?? []).map((phrase) => ({
      sectionID: section.id,
      ...phrase,
    }))
  );
}

function rowMentionsPlace(row, page) {
  const placeNames = [
    page.cityMetadata?.placeName,
    page.title,
    page.englishTitle,
  ].map(normalize).filter(Boolean);
  const visibleText = normalize([row.vietnamese, row.english].filter(Boolean).join(" "));
  return placeNames.some((name) => name && visibleText.includes(name));
}

function main() {
  const failures = [];
  const cityLibrary = readJSON(cityLibraryPath);
  const supportPages = readJSON(supportPagesPath);
  const catalog = readJSON(catalogPath);
  const authored = readJSON(authoredPagesPath);

  const retiredIDFragments = Array.from(retiredPhraseIDs);

  for (const page of cityLibrary.pages ?? []) {
    if (page.kind === "phrase" && isAttractionPlaceKind(page.placeKind)) {
      addFailure(failures, "city source attraction phrase", page.id);
    }
  }

  for (const page of supportPages.pages ?? []) {
    if (retiredPhraseIDs.has(page.phraseID)) {
      addFailure(failures, "support source retired phrase", page.phraseID);
    }
    const serialized = JSON.stringify(page);
    for (const phraseID of retiredIDFragments) {
      if (serialized.includes(phraseID)) {
        addFailure(failures, "support source retired phrase reference", `${page.phraseID} -> ${phraseID}`);
      }
    }
  }

  for (const phrase of catalog.phrases ?? []) {
    if (retiredPhraseIDs.has(phrase.id)) {
      addFailure(failures, "catalog retired phrase", phrase.id);
    }
    if (phrase.cityLibraryKind === "phrase" && isAttractionPlaceKind(phrase.placeKind)) {
      addFailure(failures, "catalog attraction phrase", phrase.id);
    }
  }

  for (const page of authored.pages ?? []) {
    const pageKind = page.cityMetadata?.pageKind;
    const placeKind = page.cityMetadata?.placeKind;
    if (page.cityMetadata?.derivedPlacePhrase && isAttractionPlaceKind(placeKind)) {
      addFailure(failures, "authored attraction derived page", page.phraseID);
    }
    if (retiredPhraseIDs.has(page.phraseID)) {
      addFailure(failures, "authored retired phrase page", page.phraseID);
    }
    const serialized = JSON.stringify(page);
    for (const phraseID of retiredIDFragments) {
      if (serialized.includes(phraseID)) {
        addFailure(failures, "authored retired phrase reference", `${page.phraseID} -> ${phraseID}`);
      }
    }
    if (pageKind === "place" && isAttractionPlaceKind(placeKind)) {
      for (const row of pagePhraseRows(page)) {
        if (row.id === page.phraseID) continue;
        if (retiredPhraseIDs.has(row.id)) {
          addFailure(failures, "attraction page retired row", `${page.phraseID}/${row.sectionID} -> ${row.id}`);
        }
        if (row.detailPageID && retiredIDFragments.some((phraseID) => row.detailPageID.includes(phraseID))) {
          addFailure(failures, "attraction page retired detail", `${page.phraseID}/${row.sectionID} -> ${row.detailPageID}`);
        }
        if (rowMentionsPlace(row, page)) {
          addFailure(failures, "attraction page non-self row mentions place", `${page.phraseID}/${row.sectionID} -> ${row.id}`);
        }
      }
    }
  }

  if (fs.existsSync(sqlitePath)) {
    const sqliteRows = sqliteJSON(`
      SELECT p.id
      FROM phrase p
      JOIN phrase_city_tag pct ON pct.phrase_id = p.id
      WHERE pct.page_kind = 'phrase'
        AND pct.place_kind IN ('${Array.from(attractionPlaceKinds).join("','")}')
      ORDER BY p.id;
    `);
    for (const row of sqliteRows) {
      addFailure(failures, "SQLite attraction phrase", row.id);
    }
    const retiredSQL = Array.from(retiredPhraseIDs).map((id) => `'${id.replace(/'/g, "''")}'`).join(",");
    const retiredRows = sqliteJSON(`
      SELECT id
      FROM phrase
      WHERE id IN (${retiredSQL})
      ORDER BY id;
    `);
    for (const row of retiredRows) {
      addFailure(failures, "SQLite retired phrase", row.id);
    }
  }

  if (failures.length > 0) {
    console.error(`Attraction phrase scope audit failed with ${failures.length} issue(s):`);
    for (const failure of failures.slice(0, 80)) {
      console.error(`- ${failure}`);
    }
    if (failures.length > 80) {
      console.error(`- ... ${failures.length - 80} more`);
    }
    process.exit(1);
  }

  console.log(JSON.stringify({
    status: "pass",
    cityPagesChecked: (cityLibrary.pages ?? []).length,
    supportPagesChecked: (supportPages.pages ?? []).length,
    catalogPhrasesChecked: (catalog.phrases ?? []).length,
    authoredPagesChecked: (authored.pages ?? []).length,
  }, null, 2));
}

main();
