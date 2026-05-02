#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const repoRoot = path.resolve(__dirname, "..", "..");
const taskID = "TASK-VIET-CONTENT-PRACTICE-EXPANSION-001";
const sourceRoot = path.join(repoRoot, "content-draft", "viet", "practice-expansion", taskID);
const manifestPath = path.join(sourceRoot, "manifest.json");
const phraseSourcePath = path.join(repoRoot, "content-draft", "viet", "phrase-source.csv");
const authoredPagesPath = path.join(repoRoot, "native-ios", "Resources", "viet-authored-listing-pages.json");
const databasePath = path.join(repoRoot, "native-ios", "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const missingAudioQueuePath = path.join(repoRoot, "docs", "audio-queues", "viet-planned-missing-audio.csv");

const baselineCanonicalPages = 1688;
const minimumFinalCanonicalPages = 2938;
const minimumNetNewPages = 1250;
const minimumCandidatePages = 1350;

const bannedPatterns = [
  /Watch out/i,
  /repair phrase/i,
  /Understanding Repair/i,
  /Understanding repair/i,
  /\bDifferent ways\b/i,
  /question marker/i,
  /key word/i,
  /first name part/i,
  /second name part/i,
  /middle name part/i,
  /final name part/i,
  /\bbaseline\b/i,
  /\bsupport\b/i,
  /\bthin\b/i,
  /\bfallback\b/i,
  /\bfiller\b/i,
];

const sourceQualityPatterns = [
  /Anh\/chị/i,
  /\bOne\s+(a|an)\s+/i,
  /\bOne\s+(ice|tissues|toilet paper|bandages|Wi-Fi|small change)\b/i,
  /Can you help me (show me|take me|give me|send me|wait for me|take a photo for me)/i,
];

const requiredBuckets = [
  "english-to-vietnamese",
  "vietnamese-to-english",
  "missing-token",
  "city-destination",
  "pronoun-social",
  "polite-register",
  "likely-reply",
  "distractor",
];

function parseCSV(text) {
  const rows = [];
  let row = [];
  let field = "";
  let inQuotes = false;
  for (let index = 0; index < text.length; index += 1) {
    const character = text[index];
    const nextCharacter = text[index + 1];
    if (inQuotes) {
      if (character === "\"" && nextCharacter === "\"") {
        field += "\"";
        index += 1;
      } else if (character === "\"") {
        inQuotes = false;
      } else {
        field += character;
      }
      continue;
    }
    if (character === "\"") {
      inQuotes = true;
    } else if (character === ",") {
      row.push(field);
      field = "";
    } else if (character === "\n") {
      row.push(field);
      rows.push(row);
      row = [];
      field = "";
    } else if (character !== "\r") {
      field += character;
    }
  }
  if (field.length > 0 || row.length > 0) {
    row.push(field);
    rows.push(row);
  }
  return rows;
}

function readPhraseSourceRows() {
  const rows = parseCSV(fs.readFileSync(phraseSourcePath, "utf8"));
  const headers = rows.shift().map((header, index) => index === 0 ? header.replace(/^\uFEFF/, "") : header);
  return rows
    .filter((row) => row.length > 1)
    .map((row) => Object.fromEntries(headers.map((header, index) => [header, row[index] ?? ""])))
    .filter((row) => row.status === "approved");
}

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim().toLowerCase();
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function sqliteValue(sql) {
  const result = spawnSync("sqlite3", [databasePath, sql], { cwd: repoRoot, encoding: "utf8" });
  if (result.status !== 0) {
    throw new Error(`sqlite3 failed: ${result.stderr || result.stdout}`);
  }
  return result.stdout.trim();
}

function csvRowCount(filePath) {
  if (!fs.existsSync(filePath)) return 0;
  return fs.readFileSync(filePath, "utf8").split(/\r?\n/).filter(Boolean).slice(1).length;
}

function loadSourceRecords() {
  assert(fs.existsSync(manifestPath), `Missing practice expansion manifest: ${manifestPath}`);
  const manifest = readJSON(manifestPath);
  assert(manifest.taskID === taskID, "manifest taskID mismatch");
  return (manifest.sourceShards ?? []).flatMap((relativePath) => {
    const shard = readJSON(path.join(sourceRoot, relativePath));
    return (shard.pages ?? []).map((page) => ({ ...page, sourceShard: relativePath }));
  }).filter((page) => page.status === "approved");
}

function pageText(page) {
  return JSON.stringify(page);
}

function wordCount(value) {
  return String(value ?? "").trim().split(/\s+/).filter(Boolean).length;
}

function hasTextOnlyRun(page) {
  let run = 0;
  for (const section of page.sections ?? []) {
    const interactive = (section.phrases ?? []).length > 0 || (section.breakdown ?? []).length > 0;
    run = interactive ? 0 : run + 1;
    if (run >= 3) return true;
  }
  return false;
}

function main() {
  const records = loadSourceRecords();
  const phraseRows = readPhraseSourceRows();
  const phraseByID = new Map(phraseRows.map((row) => [row.phrase_id, row]));
  const authoredBundle = readJSON(authoredPagesPath);
  const authoredPages = (authoredBundle.pages ?? []).filter((page) => page.tierRole === "practice-expansion");
  const authoredPageByPhraseID = new Map(authoredPages.map((page) => [page.phraseID, page]));

  assert(records.length >= minimumCandidatePages, `expected at least ${minimumCandidatePages} approved practice-expansion source records, found ${records.length}`);
  assert(authoredPages.length === records.length, `expected ${records.length} generated practice-expansion pages, found ${authoredPages.length}`);

  const duplicateTargets = Array.from(records.reduce((map, record) => {
    const key = normalize(record.targetText);
    if (!map.has(key)) map.set(key, []);
    map.get(key).push(record.phraseID);
    return map;
  }, new Map()).entries()).filter(([, ids]) => ids.length > 1);
  assert(duplicateTargets.length === 0, `duplicate practice-expansion Vietnamese phrases: ${JSON.stringify(duplicateTargets.slice(0, 10))}`);

  const bucketCounts = new Map();
  const difficultyCounts = new Map();
  for (const record of records) {
    assert(phraseByID.has(record.phraseID), `${record.phraseID} missing from phrase-source.csv`);
    assert(record.rationale && record.rationale.length >= 30, `${record.phraseID} missing useful rationale`);
    assert((record.chunks ?? []).length >= (wordCount(record.targetText) === 1 ? 1 : 2), `${record.phraseID} needs a meaningful breakdown`);
    const learnerFacingSource = [
      record.targetText,
      record.englishText,
      record.canonicalTargetText,
      record.context,
      ...(record.searchAliases ?? []),
      ...(record.chunks ?? []).flatMap((chunk) => [chunk.vietnamese, chunk.english]),
      record.atGlance,
      record.quickSay,
      record.whenToUse,
      record.goodToKnow,
    ].join("\n");
    for (const pattern of sourceQualityPatterns) {
      assert(!pattern.test(learnerFacingSource), `${record.phraseID} contains unresolved source quality wording: ${pattern}`);
    }
    for (const bucket of record.practiceBuckets ?? []) {
      bucketCounts.set(bucket, (bucketCounts.get(bucket) ?? 0) + 1);
    }
    difficultyCounts.set(record.difficulty, (difficultyCounts.get(record.difficulty) ?? 0) + 1);
  }
  for (const bucket of requiredBuckets) {
    assert((bucketCounts.get(bucket) ?? 0) > 0, `missing practice bucket coverage: ${bucket}`);
  }
  assert((difficultyCounts.get("beginner") ?? 0) / records.length >= 0.65, "practice expansion should stay beginner-heavy");

  for (const page of authoredPages) {
    const sectionIDs = new Set((page.sections ?? []).map((section) => section.id));
    for (const id of ["at-glance", "quick-say", "breakdown", "practice-pairs", "when-to-use", "good-to-know", "explore-next"]) {
      assert(sectionIDs.has(id), `${page.id} missing ${id}`);
    }
    assert((page.sections.find((section) => section.id === "breakdown")?.breakdown ?? []).length >= (wordCount(page.title) === 1 ? 1 : 2), `${page.id} needs meaningful breakdown`);
    assert(!hasTextOnlyRun(page), `${page.id} has 3+ text-only sections in a row`);
    assert((page.sections.find((section) => section.id === "explore-next")?.phrases ?? []).length > 0, `${page.id} missing Explore next links`);
    for (const pattern of bannedPatterns) {
      assert(!pattern.test(pageText(page)), `${page.id} contains banned/internal wording: ${pattern}`);
    }
  }

  const finalCanonicalPages = Number(sqliteValue("SELECT count(*) FROM phrase_page;"));
  const netNewPages = finalCanonicalPages - baselineCanonicalPages;
  const duplicateCanonicalGroups = Number(sqliteValue(`
    SELECT count(*)
    FROM (
      SELECT p.normalized_target_text
      FROM phrase_page pp
      JOIN phrase p ON p.id = pp.phrase_id
      GROUP BY p.normalized_target_text
      HAVING count(*) > 1
    );
  `));
  assert(finalCanonicalPages >= minimumFinalCanonicalPages, `expected at least ${minimumFinalCanonicalPages} canonical pages, found ${finalCanonicalPages}`);
  assert(netNewPages >= minimumNetNewPages, `expected at least ${minimumNetNewPages} net-new pages, found ${netNewPages}`);
  assert(duplicateCanonicalGroups === 0, `duplicate canonical normalized groups: ${duplicateCanonicalGroups}`);
  assert(csvRowCount(missingAudioQueuePath) > 0, "planned missing-audio queue is missing or empty");

  console.log(JSON.stringify({
    ok: true,
    approvedSourceRecords: records.length,
    generatedPracticeExpansionPages: authoredPages.length,
    finalCanonicalPages,
    netNewPages,
    practiceBuckets: Object.fromEntries(bucketCounts),
    difficultyCounts: Object.fromEntries(difficultyCounts),
  }, null, 2));
}

main();
