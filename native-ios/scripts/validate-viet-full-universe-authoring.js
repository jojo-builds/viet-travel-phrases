#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const sourceCSVPath = path.join(repoRoot, "content-draft", "viet", "phrase-source.csv");
const fullUniverseRoot = path.join(repoRoot, "content-draft", "viet", "full-listing-pages");
const indexPath = path.join(fullUniverseRoot, "_full-universe-index.json");
const rationalePath = path.join(fullUniverseRoot, "_ai-authoring-rationale.jsonl");
const audioManifestPath = path.join(repoRoot, "native-ios", "Resources", "viet-audio-manifest.json");
const taskID = "TASK-VIET-2000-FULL-LISTING-PAGES-001";

const bannedPatterns = [
  /Watch out/i,
  /repair phrase/i,
  /Understanding Repair/i,
  /\bDifferent ways\b/i,
  /question marker/i,
  /\bbaseline\b/i,
  /\bsupport\b/i,
  /\bthin\b/i,
  /\bfallback\b/i,
  /\bfiller\b/i,
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

function readPhraseRows() {
  const rows = parseCSV(fs.readFileSync(sourceCSVPath, "utf8"));
  const headers = rows.shift().map((header, index) => index === 0 ? header.replace(/^\uFEFF/, "") : header);
  return rows
    .filter((row) => row.length > 1)
    .map((row) => Object.fromEntries(headers.map((header, index) => [header, row[index] ?? ""])))
    .filter((row) => row.status === "approved");
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

function normalize(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim().toLowerCase();
}

function relative(filePath) {
  return path.relative(repoRoot, filePath).replaceAll(path.sep, "/");
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function sectionIDs(page) {
  return new Set((page.sections ?? []).map((section) => section.id));
}

function pageText(page) {
  return JSON.stringify(page);
}

function hasPhraseTeachingSection(page) {
  return (page.sections ?? []).some((section) =>
    section.id !== "standard-way"
    && section.id !== "quick-say"
    && section.id !== "explore-next"
    && (section.phrases ?? []).length > 0
  );
}

function wordCount(value) {
  return String(value ?? "").trim().split(/\s+/).filter(Boolean).length;
}

function main() {
  assert(fs.existsSync(fullUniverseRoot), `Missing full-universe authoring root: ${relative(fullUniverseRoot)}`);
  assert(fs.existsSync(indexPath), `Missing full-universe index: ${relative(indexPath)}`);
  assert(fs.existsSync(rationalePath), `Missing AI authoring rationale ledger: ${relative(rationalePath)}`);

  const phraseRows = readPhraseRows();
  const phraseByID = new Map(phraseRows.map((row) => [row.phrase_id, row]));
  const taskPhraseRows = phraseRows.filter((row) => row.notes.includes(`task=${taskID}`));
  const audioManifest = JSON.parse(fs.readFileSync(audioManifestPath, "utf8"));
  const audioTextByKey = new Map(Object.entries(audioManifest).map(([key, entry]) => [key, normalize(entry.text)]));
  const pages = walkJSONFiles(fullUniverseRoot).map((filePath) => ({
    filePath,
    page: JSON.parse(fs.readFileSync(filePath, "utf8")),
  }));
  const rationaleRows = fs.readFileSync(rationalePath, "utf8")
    .split(/\n/)
    .filter(Boolean)
    .map((line, index) => {
      try {
        return JSON.parse(line);
      } catch (error) {
        throw new Error(`${relative(rationalePath)}:${index + 1} is not valid JSON: ${error.message}`);
      }
    });

  const pagesByPhraseID = new Map();
  for (const { filePath, page } of pages) {
    assert(page.depth === "deep", `${relative(filePath)} must use depth=deep`);
    assert(phraseByID.has(page.phraseID), `${relative(filePath)} phraseID ${page.phraseID} is not in phrase-source.csv`);
    assert(!pagesByPhraseID.has(page.phraseID), `Duplicate authored page for phraseID ${page.phraseID}`);
    pagesByPhraseID.set(page.phraseID, page);

    const ids = sectionIDs(page);
    assert(ids.has("at-glance"), `${relative(filePath)} missing At a glance`);
    assert(ids.has("breakdown"), `${relative(filePath)} missing Break it down`);
    assert(ids.has("when-to-use"), `${relative(filePath)} missing When to use it`);
    assert(ids.has("explore-next"), `${relative(filePath)} missing Explore next`);
    assert(ids.has("standard-way") || ids.has("quick-say"), `${relative(filePath)} missing standard/quick phrase section`);
    assert(ids.has("good-to-know") || ids.has("local-tip") || ids.has("travel-note") || ids.has("cultural-note"), `${relative(filePath)} missing positive local/travel note`);
    assert(hasPhraseTeachingSection(page), `${relative(filePath)} missing variants/replies/nearby phrase teaching section`);

    const breakdown = (page.sections ?? []).find((section) => section.id === "breakdown")?.breakdown ?? [];
    assert(breakdown.length >= (wordCount(page.title) === 1 ? 1 : 2), `${relative(filePath)} needs a meaningful breakdown`);
    assert(normalize(breakdown[breakdown.length - 1]?.vietnamese) === normalize(page.title), `${relative(filePath)} final breakdown card must be the full phrase`);

    for (const pattern of bannedPatterns) {
      assert(!pattern.test(pageText(page)), `${relative(filePath)} contains banned/internal wording: ${pattern}`);
    }

    if (page.audioKey && audioTextByKey.has(page.audioKey)) {
      assert(audioTextByKey.get(page.audioKey) === normalize(page.title), `${relative(filePath)} hero audio does not match title`);
    }

    for (const section of page.sections ?? []) {
      for (const phrase of section.phrases ?? []) {
        const hasExactAudio = phrase.audioKey && audioTextByKey.get(phrase.audioKey) === normalize(phrase.vietnamese);
        const expectedSymbol = hasExactAudio ? "speaker.wave.2.fill" : "speaker.slash.fill";
        assert(phrase.symbolName === expectedSymbol, `${relative(filePath)} ${section.id} phrase ${phrase.id} should use ${expectedSymbol}`);
      }
    }
  }

  const rationaleByPageID = new Map(rationaleRows.map((row) => [row.pageID, row]));
  for (const { filePath, page } of pages) {
    const rationale = rationaleByPageID.get(page.id);
    assert(rationale, `${relative(filePath)} missing rationale record`);
    assert(rationale.status === "ai_authored_read_designed_written", `${page.id} rationale has wrong status`);
    assert(rationale.pageThesis && rationale.breakdownDesignNotes, `${page.id} rationale missing thesis or breakdown notes`);
    assert((rationale.variantsRepliesNearby ?? []).length > 0, `${page.id} rationale needs variant/reply/nearby reasoning`);
  }

  for (const row of taskPhraseRows) {
    assert(pagesByPhraseID.has(row.phrase_id), `${row.phrase_id} is a task phrase without a full-universe authored page`);
  }

  const duplicateTargets = Array.from(
    phraseRows.reduce((map, row) => {
      const key = normalize(row.target_text);
      if (!map.has(key)) map.set(key, []);
      map.get(key).push(row);
      return map;
    }, new Map()).entries()
  ).filter(([, rows]) => rows.length > 1 && rows.some((row) => row.notes.includes(`task=${taskID}`)));

  assert(
    duplicateTargets.length === 0,
    `Task phrase rows duplicate existing Vietnamese phrases: ${JSON.stringify(duplicateTargets.slice(0, 20).map(([target, rows]) => [target, rows.map((row) => row.phrase_id)]))}`
  );

  const index = JSON.parse(fs.readFileSync(indexPath, "utf8"));
  assert(index.taskID === taskID, "Full-universe index taskID mismatch");
  assert(index.authoredPageCount === pages.length, "Full-universe index authoredPageCount mismatch");

  console.log(JSON.stringify({
    ok: true,
    taskPhraseRows: taskPhraseRows.length,
    authoredPages: pages.length,
    rationaleRecords: rationaleRows.length,
  }, null, 2));
}

main();
