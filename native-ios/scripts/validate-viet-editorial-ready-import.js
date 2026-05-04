#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const pilotRoot = path.join(repoRoot, "docs", "editorial-exports", "viet-canonical-pages", "chatgpt-pilot-2026-05-03");
const patchPath = path.join(pilotRoot, "SpeakLocal_Vietnam_Editorial_Pilot_Patch_v1.json");
const approvalPath = path.join(pilotRoot, "approved-imports-TASK-VIET-EDITORIAL-READY-IMPORT-001.json");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");

const approvedPatchIDs = new Set([
  "EP-001",
  "EP-002",
  "EP-004",
  "EP-005",
  "EP-006",
  "EP-007",
  "EP-008",
  "EP-009",
  "EP-010",
  "EP-011",
  "EP-013",
  "EP-016",
  "EP-020",
]);

const excludedPatchIDs = new Set(["EP-003", "EP-012", "EP-014", "EP-015"]);
const supersededPatchIDs = new Map([
  ["EP-005", "BNH-001"],
]);
const internalTravelerFacingPattern = /\b(NEEDS_RESEARCH|volatile|Do not add|Best first sentence|not the trivia|placeholder|fallback|Watch out|repair phrase|Understanding Repair|question marker)\b/i;

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
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

function parseVisiblePhraseRows(value) {
  return String(value ?? "")
    .split("|")
    .map((row) => row.trim())
    .filter(Boolean)
    .map((row) => {
      const slotSeparator = row.indexOf(": ");
      const meaningSeparator = row.indexOf(" -> ");
      assert(slotSeparator !== -1 && meaningSeparator !== -1, `Malformed visible row: ${row}`);
      return {
        slot: row.slice(0, slotSeparator).trim(),
        vietnamese: row.slice(slotSeparator + 2, meaningSeparator).trim(),
        english: row.slice(meaningSeparator + 4).trim(),
      };
    });
}

function pageText(page) {
  return [
    page.summary,
    ...(page.sections ?? []).flatMap((section) => [
      section.title,
      section.body,
      ...(section.breakdown ?? []).flatMap((token) => [token.vietnamese, token.english]),
      ...(section.phrases ?? []).flatMap((phrase) => [phrase.vietnamese, phrase.english]),
    ]),
  ].filter(Boolean).join("\n");
}

function main() {
  const patch = readJSON(patchPath);
  const approval = readJSON(approvalPath);
  const cityLibrary = readJSON(cityLibraryPath);
  const authoredPages = readJSON(authoredPagesPath);
  const catalog = readJSON(catalogPath);

  assert(approval.taskID === "TASK-VIET-EDITORIAL-READY-IMPORT-001", "approval taskID mismatch");
  const approved = (approval.approvals ?? []).filter((row) => row.import_approval === "APPROVED_FOR_IMPORT");
  const approvedIDs = new Set(approved.map((row) => row.patch_id));
  assert(approved.length === approvedPatchIDs.size, `expected ${approvedPatchIDs.size} approved imports, got ${approved.length}`);
  for (const patchID of approvedPatchIDs) {
    assert(approvedIDs.has(patchID), `${patchID} missing from ready approval overlay`);
  }
  for (const patchID of excludedPatchIDs) {
    assert(!approvedIDs.has(patchID), `${patchID} must remain excluded`);
  }

  const patchByID = new Map((patch.patches ?? []).map((row) => [row.patch_id, row]));
  const cityPageByID = new Map((cityLibrary.pages ?? []).map((page) => [page.id, page]));
  const authoredPageByPhraseID = new Map((authoredPages.pages ?? []).map((page) => [page.phraseID, page]));
  const catalogByNormalizedText = new Map();
  for (const phrase of catalog.phrases ?? []) {
    const key = normalize(phrase.targetText);
    if (!catalogByNormalizedText.has(key)) catalogByNormalizedText.set(key, []);
    catalogByNormalizedText.get(key).push(phrase);
  }

  const checkedRows = [];
  for (const patchID of approvedPatchIDs) {
    const patchRow = patchByID.get(patchID);
    assert(patchRow, `${patchID} missing from patch file`);
    assert(patchRow.import_approval === "REVIEW_ONLY", `${patchID} source patch should remain REVIEW_ONLY`);
    assert(normalize(patchRow.current_vietnamese) === normalize(patchRow.proposed_vietnamese), `${patchID} changes canonical Vietnamese`);

    const authoredPage = authoredPageByPhraseID.get(patchRow.phrase_id);
    assert(authoredPage, `${patchID} generated page missing for ${patchRow.phrase_id}`);
    assert(normalize(authoredPage.title) === normalize(patchRow.current_vietnamese), `${patchID} generated title changed`);
    if (!supersededPatchIDs.has(patchID)) {
      assert(authoredPage.summary === patchRow.proposed_summary, `${patchID} generated summary did not import proposed summary`);
    }

    if (patchRow.phrase_id.startsWith("city-")) {
      const cityRecord = cityPageByID.get(patchRow.phrase_id);
      const expectedPatchID = supersededPatchIDs.get(patchID) ?? patchID;
      assert(cityRecord?.editorialImport?.patchID === expectedPatchID, `${patchID} missing city-library editorialImport`);
      assert(normalize(cityRecord.targetText) === normalize(patchRow.current_vietnamese), `${patchID} city source title changed`);
    }

    const text = pageText(authoredPage);
    assert(!internalTravelerFacingPattern.test(text), `${patchID} has internal/staging traveler-facing text`);

    for (const visibleRow of parseVisiblePhraseRows(patchRow.proposed_visible_phrase_rows)) {
      const matches = catalogByNormalizedText.get(normalize(visibleRow.vietnamese)) ?? [];
      assert(matches.length === 1, `${patchID} visible row ${visibleRow.vietnamese} resolves to ${matches.length} catalog phrases`);
      const visibleInPage = (authoredPage.sections ?? []).some((section) => (
        (section.phrases ?? []).some((phrase) => normalize(phrase.vietnamese) === normalize(visibleRow.vietnamese))
      ));
      assert(visibleInPage, `${patchID} visible row ${visibleRow.vietnamese} is not present on the generated page`);
    }

    checkedRows.push({
      patchID,
      phraseID: patchRow.phrase_id,
      pageID: authoredPage.id,
      visibleRows: parseVisiblePhraseRows(patchRow.proposed_visible_phrase_rows).length,
    });
  }

  for (const patchID of excludedPatchIDs) {
    const patchRow = patchByID.get(patchID);
    if (!patchRow?.phrase_id?.startsWith("city-")) continue;
    const cityRecord = cityPageByID.get(patchRow.phrase_id);
    assert(cityRecord?.editorialImport?.patchID !== patchID, `${patchID} was imported but should be excluded`);
  }

  console.log(JSON.stringify({
    status: "pass",
    taskID: approval.taskID,
    importedCount: checkedRows.length,
    excludedPatchIDs: [...excludedPatchIDs],
    checkedRows,
  }, null, 2));
}

main();
