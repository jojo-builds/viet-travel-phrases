#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const packetRoot = path.join(repoRoot, "docs", "editorial-exports", "viet-canonical-pages", "chatgpt-batch-001");
const manifestPath = path.join(packetRoot, "manifest.json");
const schemaPath = path.join(packetRoot, "schema-version.json");
const sheetReadbackPath = path.join(packetRoot, "sheet-readback.json");
const taskID = "TASK-VIET-CHATGPT-EDITORIAL-BATCH-001";
const schemaVersion = "speaklocal.viet.chatgpt-editorial-batch.v1";

const requiredHardPhraseIDs = new Set([
  "city-hanoi-place-bun-cha-huong-lien",
  "city-hanoi-place-pho-bat-dan",
  "city-hoian-place-cao-lau-city",
  "city-hue-place-bun-bo-city",
  "city-danang-place-ba-na-hills",
  "city-danang-place-dragon-bridge",
  "city-danang-place-marble-mountains",
  "city-danang-place-son-tra",
  "city-danang-place-bach-dang-street",
  "city-danang-place-nguyen-van-linh-street",
  "city-danang-place-vo-nguyen-giap-street",
  "city-danang-go-ba-na-hills",
  "city-danang-where-ba-na-hills",
  "city-danang-ticket-marble-mountains",
  "city-danang-go-dragon-bridge",
  "city-danang-near-nguyen-van-linh-street",
  "acknowledge-da-chao-anh",
]);

const requiredFiles = [
  "README.md",
  "CHATGPT_PROMPT.md",
  "IMPORT_README.md",
  "manifest.json",
  "schema-version.json",
  "pages.csv",
  "pages.json",
  "sections.csv",
  "sections.json",
  "phrase_rows.csv",
  "phrase_rows.json",
  "breakdowns.csv",
  "breakdowns.json",
  "relationships.csv",
  "relationships.json",
  "renderer_directives.csv",
  "renderer_directives.json",
  "asset_directives.csv",
  "asset_directives.json",
  "validator_rules.csv",
  "validator_rules.json",
  "review_notes.csv",
  "review_notes.json",
  "schema_version.csv",
  "schema_version.json",
  "page_patch.csv",
  "page_patch.json",
  "section_patch.csv",
  "section_patch.json",
  "phrase_row_patch.csv",
  "phrase_row_patch.json",
  "breakdown_patch.csv",
  "breakdown_patch.json",
  "relationship_reorder_patch.csv",
  "relationship_reorder_patch.json",
  "renderer_directives_patch.csv",
  "renderer_directives_patch.json",
  "asset_directives_patch.csv",
  "asset_directives_patch.json",
  "validator_rules_patch.csv",
  "validator_rules_patch.json",
  "questions_for_jojo.csv",
  "questions_for_jojo.json",
  "sheet-tabs-manifest.json",
  "sheet-readback.json",
];

const patchFiles = [
  "page_patch",
  "section_patch",
  "phrase_row_patch",
  "breakdown_patch",
  "relationship_reorder_patch",
  "renderer_directives_patch",
  "asset_directives_patch",
  "validator_rules_patch",
  "questions_for_jojo",
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function run(command, args) {
  const result = spawnSync(command, args, {
    cwd: repoRoot,
    encoding: "utf8",
    maxBuffer: 64 * 1024 * 1024,
  });
  if (result.status !== 0) {
    throw new Error(`${command} ${args.join(" ")} failed\nSTDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}`);
  }
  return result.stdout.trim();
}

function csvLineCount(filePath) {
  const text = fs.readFileSync(filePath, "utf8");
  return text.trimEnd().split("\n").length;
}

function csvHeader(filePath) {
  const firstLine = fs.readFileSync(filePath, "utf8").split("\n")[0] ?? "";
  return firstLine
    .split(",")
    .map((cell) => cell.replace(/^"|"$/g, "").replace(/""/g, "\""));
}

function assertPatchRows(rows, fileName, requiredPatchColumns) {
  assert(rows.length > 0, `${fileName}.json must have at least one row`);
  const columns = new Set(Object.keys(rows[0]));
  for (const column of requiredPatchColumns) {
    assert(columns.has(column), `${fileName}.json missing required patch column ${column}`);
  }
  for (const row of rows) {
    assert(row.review_status === "REVIEW_ONLY", `${fileName} ${row.patch_id} review_status must default to REVIEW_ONLY`);
    assert(row.import_approval === "REVIEW_ONLY", `${fileName} ${row.patch_id} import_approval must default to REVIEW_ONLY`);
    assert(row.import_approval !== "APPROVED_FOR_IMPORT", `${fileName} ${row.patch_id} must not be importable in this task`);
  }
}

function validateForbiddenDiffs() {
  const diff = run("git", ["diff", "--name-only"]);
  const names = diff.split(/\n+/).filter(Boolean);
  const forbiddenPrefixes = [
    "native-ios/App/",
    "native-ios/Resources/Audio/",
    "native-ios/Resources/viet-phrase-catalog.json",
    "native-ios/Resources/viet-authored-listing-pages.json",
    "native-ios/Resources/viet-audio-manifest.json",
    "native-ios/Resources/LanguagePacks/",
    "native-ios/project.yml",
    "native-ios/SpeakLocalNative.xcodeproj/",
  ];
  const forbidden = names.filter((name) => forbiddenPrefixes.some((prefix) => name.startsWith(prefix)));
  assert(forbidden.length === 0, `Forbidden paths changed:\n${forbidden.join("\n")}`);
}

function validateSheetReadback(manifest) {
  assert(fs.existsSync(sheetReadbackPath), "sheet-readback.json is required after Google Sheet tabs are created");
  const readback = readJSON(sheetReadbackPath);
  assert(readback.taskID === taskID, "sheet readback taskID mismatch");
  assert(readback.spreadsheetID === manifest.spreadsheet.id, "sheet readback spreadsheet ID mismatch");
  const tabs = new Map((readback.tabs ?? []).map((tab) => [tab.tab_name, tab]));
  for (const tabName of manifest.sheetTabs) {
    assert(tabs.has(tabName), `sheet readback missing ${tabName}`);
    const tab = tabs.get(tabName);
    assert(tab.status === "verified", `${tabName} was not verified`);
    assert(tab.expected_row_count === tab.actual_row_count, `${tabName} row count mismatch: expected ${tab.expected_row_count}, got ${tab.actual_row_count}`);
    assert(tab.expected_column_count === tab.actual_column_count, `${tabName} column count mismatch: expected ${tab.expected_column_count}, got ${tab.actual_column_count}`);
  }
}

function main() {
  assert(fs.existsSync(packetRoot), `Missing packet folder ${packetRoot}`);
  for (const file of requiredFiles) {
    assert(fs.existsSync(path.join(packetRoot, file)), `Missing required packet file ${file}`);
  }

  const manifest = readJSON(manifestPath);
  const schema = readJSON(schemaPath);
  assert(manifest.taskID === taskID, "manifest taskID mismatch");
  assert(schema.taskID === taskID, "schema taskID mismatch");
  assert(manifest.schemaVersion === schemaVersion, "manifest schemaVersion mismatch");
  assert(schema.schemaVersion === schemaVersion, "schema schemaVersion mismatch");
  assert(manifest.selectedPageCount === 25, `expected 25 selected pages, found ${manifest.selectedPageCount}`);
  assert(schema.selectedPageTarget === 25, "schema selectedPageTarget must be 25");

  const pageRows = readJSON(path.join(packetRoot, "pages.json"));
  const phraseIDs = new Set(pageRows.map((row) => row.phrase_id));
  for (const phraseID of requiredHardPhraseIDs) {
    assert(phraseIDs.has(phraseID), `required hard phrase missing from batch: ${phraseID}`);
  }
  const baNa = pageRows.find((row) => row.phrase_id === "city-danang-place-ba-na-hills");
  assert(baNa, "Bà Nà Hills reference page missing");
  assert(baNa.batch_role === "reference_completed", "Bà Nà Hills must be marked reference_completed");
  assert(String(baNa.ba_na_reference_summary ?? "").includes("Bà Nà v2 reference"), "Bà Nà reference summary missing");

  for (const [name, expected] of Object.entries(manifest.rowCounts)) {
    if (name === "schema_version") continue;
    const jsonPath = path.join(packetRoot, `${name}.json`);
    const csvPath = path.join(packetRoot, `${name}.csv`);
    if (!fs.existsSync(jsonPath)) continue;
    const rows = readJSON(jsonPath);
    assert(rows.length === expected, `${name}.json row count mismatch`);
    assert(csvLineCount(csvPath) === expected + 1, `${name}.csv line count mismatch`);
    assert(csvHeader(csvPath).length === Object.keys(rows[0] ?? {}).length, `${name}.csv header count mismatch`);
  }

  assert(readJSON(path.join(packetRoot, "sections.json")).length >= pageRows.length * 5, "selected pages do not export enough current sections");
  assert(readJSON(path.join(packetRoot, "phrase_rows.json")).length > 0, "phrase rows snapshot is empty");
  assert(readJSON(path.join(packetRoot, "breakdowns.json")).length > 0, "breakdowns snapshot is empty");
  assert(readJSON(path.join(packetRoot, "relationships.json")).length > 0, "relationships snapshot is empty");

  for (const patchFile of patchFiles) {
    assertPatchRows(readJSON(path.join(packetRoot, `${patchFile}.json`)), patchFile, schema.requiredPatchColumns);
  }

  const allPatchRows = patchFiles.flatMap((patchFile) => readJSON(path.join(packetRoot, `${patchFile}.json`)));
  assert(!allPatchRows.some((row) => row.import_approval === "APPROVED_FOR_IMPORT"), "packet contains importable patch rows before Jojo approval");
  assert(manifest.sheetTabs.every((tabName) => tabName.startsWith("batch_001_")), "all sheet tabs must be batch_001-prefixed");

  validateSheetReadback(manifest);
  validateForbiddenDiffs();

  console.log(`ChatGPT editorial batch validator OK: ${manifest.selectedPageCount} pages, ${manifest.sheetTabs.length} sheet tabs verified`);
}

main();
