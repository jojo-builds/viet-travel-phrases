#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const taskID = "TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001";
const batchRoot = path.join(repoRoot, "docs", "editorial-exports", "viet-canonical-pages", "chatgpt-batch-001");
const incomingRoot = path.join(batchRoot, "incoming-chatgpt", "completed-patch-files");
const approvedRoot = path.join(batchRoot, "agent-approved-import");
const approvalPath = path.join(approvedRoot, "approval-overlay.json");
const importApplyPath = path.join(approvedRoot, "import-apply.json");
const resultPath = path.join(repoRoot, "docs", "task-results", `${taskID}.md`);
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredResourcePath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const sqliteReportPath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet-report.json");
const sourceRoots = [
  path.join(repoRoot, "content-draft", "viet", "canonical-pages", "tier-one"),
  path.join(repoRoot, "content-draft", "viet", "canonical-pages", "catalog-promoted"),
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function relative(filePath) {
  return path.relative(repoRoot, filePath);
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

function collectJSONFiles(dir) {
  if (!fs.existsSync(dir)) return [];
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...collectJSONFiles(fullPath));
    } else if (entry.isFile() && entry.name.endsWith(".json") && !entry.name.startsWith("_")) {
      files.push(fullPath);
    }
  }
  return files.sort((a, b) => a.localeCompare(b));
}

function loadPatchRows(name) {
  const filePath = path.join(incomingRoot, `${name}.json`);
  assert(fs.existsSync(filePath), `missing incoming patch file ${relative(filePath)}`);
  const rows = readJSON(filePath);
  assert(Array.isArray(rows), `${relative(filePath)} must be an array`);
  for (const row of rows) {
    assert(row.review_status === "REVIEW_ONLY", `${row.patch_id} raw review_status changed`);
    assert(row.import_approval === "REVIEW_ONLY", `${row.patch_id} raw import_approval changed`);
  }
  return rows;
}

function parsePatchValue(row) {
  try {
    return JSON.parse(row.proposed_value || "{}");
  } catch (error) {
    throw new Error(`${row.patch_id} proposed_value is invalid JSON`);
  }
}

function sourceIndex() {
  const byPhraseID = new Map();
  for (const root of sourceRoots) {
    for (const filePath of collectJSONFiles(root)) {
      const page = readJSON(filePath);
      if (page.phraseID) byPhraseID.set(page.phraseID, { filePath, page });
    }
  }
  return byPhraseID;
}

function approvedPhraseIDs(approval) {
  return new Set((approval.approvedPages ?? [])
    .filter((row) => row.import_status === "AGENT_APPROVED_FOR_IMPORT")
    .map((row) => row.phrase_id));
}

function questionPhraseIDs(questions) {
  return new Set(questions
    .filter((row) => row.operation === "QUESTION_ONLY" || String(row.jojo_question ?? "").trim())
    .map((row) => row.phrase_id));
}

function validateForbiddenDiffs() {
  const diff = run("git", ["diff", "--name-only"]);
  const names = diff.split(/\n+/).filter(Boolean);
  const forbiddenExact = new Set([
    "native-ios/project.yml",
    "native-ios/SpeakLocalNative.xcodeproj/project.pbxproj",
  ]);
  const forbiddenPrefixes = [
    "native-ios/Resources/Audio/",
  ];
  const forbidden = names.filter((name) =>
    forbiddenExact.has(name) || forbiddenPrefixes.some((prefix) => name.startsWith(prefix))
  );
  assert(forbidden.length === 0, `forbidden paths changed:\n${forbidden.join("\n")}`);
}

function validateImportedSource(importSummary, approval) {
  const approved = approvedPhraseIDs(approval);
  const cityLibrary = readJSON(cityLibraryPath);
  const cityByPhraseID = new Map((cityLibrary.pages ?? []).map((page) => [page.id, page]));
  const sourceByPhraseID = sourceIndex();

  assert(importSummary.importedPageCount === approved.size, "import summary count does not match approval count");
  for (const phraseID of approved) {
    const cityRecord = cityByPhraseID.get(phraseID);
    const source = sourceByPhraseID.get(phraseID);
    assert(cityRecord || source, `${phraseID} is approved but has no source record`);
    const importMeta = cityRecord?.editorialImport ?? source?.page?.editorialImport;
    assert(importMeta?.taskID === taskID, `${phraseID} missing task editorial import marker`);
    assert(importMeta?.sourcePatch === "chatgpt-batch-001/incoming-chatgpt/completed-patch-files", `${phraseID} source patch marker mismatch`);
    if (cityRecord) {
      assert(importMeta.replaceGeneratedSections === true, `${phraseID} city import must replace generated sections`);
      assert((importMeta.sections ?? []).length >= 5, `${phraseID} city import has too few sections`);
    } else {
      assert((source.page.sections ?? []).length >= 5, `${phraseID} source import has too few sections`);
    }
  }
}

function validateRenderedResources(importSummary) {
  const authored = readJSON(authoredResourcePath);
  const pagesByPhraseID = new Map((authored.pages ?? []).map((page) => [page.phraseID, page]));
  for (const imported of importSummary.imported ?? []) {
    const page = pagesByPhraseID.get(imported.phrase_id);
    assert(page, `${imported.phrase_id} missing from authored resource`);
    assert(page.summary && !/^Different ways to say/i.test(page.summary), `${imported.phrase_id} hero summary is meta copy`);
    assert((page.sections ?? []).length >= 5, `${imported.phrase_id} rendered page has too few sections`);
    assert(page.sections.some((section) => section.id === "breakdown" && (section.breakdown ?? []).length > 0), `${imported.phrase_id} missing rendered breakdown`);
    assert(page.sections.some((section) => (section.phrases ?? []).length > 0), `${imported.phrase_id} has no rendered phrase rows`);
    for (const section of page.sections ?? []) {
      for (const phrase of section.phrases ?? []) {
        if (phrase.detailPageID) {
          assert([...pagesByPhraseID.values()].some((candidate) => candidate.id === phrase.detailPageID), `${imported.phrase_id} row ${phrase.id} broken detailPageID ${phrase.detailPageID}`);
        }
      }
    }
  }

  assert(fs.existsSync(catalogPath), "catalog resource missing");
  assert(fs.existsSync(sqliteReportPath), "SQLite report missing");
}

function main() {
  const pageRows = loadPatchRows("page_patch");
  const questions = loadPatchRows("questions_for_jojo");
  loadPatchRows("section_patch");
  loadPatchRows("phrase_row_patch");
  loadPatchRows("breakdown_patch");
  loadPatchRows("relationship_reorder_patch");
  loadPatchRows("renderer_directives_patch");
  loadPatchRows("asset_directives_patch");
  loadPatchRows("validator_rules_patch");

  assert(fs.existsSync(approvalPath), `missing approval overlay ${relative(approvalPath)}`);
  assert(fs.existsSync(importApplyPath), `missing import apply summary ${relative(importApplyPath)}`);
  const approval = readJSON(approvalPath);
  const importSummary = readJSON(importApplyPath);
  assert(approval.taskID === taskID, "approval taskID mismatch");
  assert(approval.approvalMode === "agent-gated", "approvalMode must be agent-gated");
  assert(importSummary.taskID === taskID, "import summary taskID mismatch");
  assert(importSummary.mode === "apply", "import summary must be from apply mode");

  const approved = approvedPhraseIDs(approval);
  const questionIDs = questionPhraseIDs(questions);
  for (const phraseID of approved) {
    assert(!questionIDs.has(phraseID), `${phraseID} has open Jojo question but was approved`);
  }
  for (const row of approval.skippedPages ?? []) {
    if (row.skip_category === "next_question") {
      assert(row.exact_decision_needed, `${row.phrase_id} next-question skip needs exact_decision_needed`);
    }
  }
  for (const row of approval.approvedPages ?? []) {
    const pagePatch = pageRows.find((candidate) => candidate.phrase_id === row.phrase_id);
    assert(pagePatch, `${row.phrase_id} approved but missing page patch`);
    const proposed = parsePatchValue(pagePatch);
    assert(proposed.summary, `${row.phrase_id} approved page missing summary proposal`);
  }

  validateImportedSource(importSummary, approval);
  validateRenderedResources(importSummary);
  validateForbiddenDiffs();

  if (fs.existsSync(resultPath)) {
    const result = fs.readFileSync(resultPath, "utf8");
    assert(result.includes("Jojo phone test terms"), "result missing phone test terms section");
    assert(result.includes("Next questions"), "result missing next questions section");
  }

  console.log(`ChatGPT editorial agent import validator OK: ${approved.size} approved pages, ${importSummary.importedPageCount} imported`);
}

main();
