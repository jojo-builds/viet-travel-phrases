#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const taskID = "TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001";
const priorTaskID = "TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001";
const phraseID = "city-danang-place-dragon-bridge";
const sourcePageID = "city-danang-place-dragon-bridge";
const currentAuthoredPageID = "viet-family-city-danang-place-dragon-bridge";
const incomingRoot = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-canonical-pages",
  "dragon-bridge-ux-copy-override-v2",
  "incoming-chatgpt",
  "completed-patch-files"
);
const importRoot = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-canonical-pages",
  "dragon-bridge-ux-copy-override-v2",
  "copy-import"
);
const defaultApprovalPath = path.join(importRoot, "approval-overlay.json");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const authoredResourcePath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");

const expectedSectionOrder = [
  "at-glance",
  "quick-say",
  "getting-there",
  "at-the-bridge",
  "pickup-nearby",
  "breakdown",
  "good-to-know",
  "explore-next",
];
const suppressedSections = ["place-brief", "use-it-with", "when-to-use"];
const nameMeaningBreakdownTokens = [
  {
    id: "city-danang-place-dragon-bridge-copy-import-1",
    vietnamese: "Cầu",
    english: "bridge",
  },
  {
    id: "city-danang-place-dragon-bridge-copy-import-2",
    vietnamese: "Rồng",
    english: "dragon",
  },
  {
    id: "city-danang-place-dragon-bridge-copy-import-3",
    vietnamese: "Cầu Rồng",
    english: "Dragon Bridge",
  },
];

function parseArgs(argv) {
  const options = {
    mode: "dry-run",
    approvalPath: defaultApprovalPath,
    outputPath: null,
  };
  for (let index = 2; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--apply") {
      options.mode = "apply";
    } else if (arg === "--dry-run" || arg === "--check") {
      options.mode = "dry-run";
    } else if (arg === "--approval") {
      options.approvalPath = path.resolve(argv[++index]);
    } else if (arg === "--output") {
      options.outputPath = path.resolve(argv[++index]);
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }
  return options;
}

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function relative(filePath) {
  return path.relative(repoRoot, filePath);
}

function parsePatchValue(row) {
  if (!String(row.proposed_value ?? "").trim()) return {};
  try {
    return JSON.parse(row.proposed_value);
  } catch (error) {
    throw new Error(`${row.patch_id} has invalid proposed_value JSON: ${error.message}`);
  }
}

function loadPatchFile(name) {
  const filePath = path.join(incomingRoot, `${name}.json`);
  if (!fs.existsSync(filePath)) {
    throw new Error(`Missing incoming Dragon Bridge patch file: ${relative(filePath)}`);
  }
  const rows = readJSON(filePath);
  if (!Array.isArray(rows)) {
    throw new Error(`${relative(filePath)} must be a JSON array`);
  }
  for (const row of rows) {
    if (row.review_status !== "REVIEW_ONLY" || row.import_approval !== "REVIEW_ONLY") {
      throw new Error(`${row.patch_id} raw incoming row must remain REVIEW_ONLY`);
    }
  }
  return rows;
}

function loadPatchSet() {
  return {
    page_patch: loadPatchFile("page_patch"),
    section_patch: loadPatchFile("section_patch"),
    phrase_row_patch: loadPatchFile("phrase_row_patch"),
    renderer_directives_patch: loadPatchFile("renderer_directives_patch"),
    validator_rules_patch: loadPatchFile("validator_rules_patch"),
  };
}

function groupByPhraseID(rows) {
  const grouped = new Map();
  for (const row of rows) {
    if (!grouped.has(row.phrase_id)) grouped.set(row.phrase_id, []);
    grouped.get(row.phrase_id).push(row);
  }
  return grouped;
}

function readCatalogIndex() {
  const catalog = readJSON(catalogPath);
  const authored = readJSON(authoredResourcePath);
  return {
    phraseByID: new Map((catalog.phrases ?? []).map((phrase) => [phrase.id, phrase])),
    familyByID: new Map((catalog.families ?? []).map((family) => [family.id, family])),
    pageIDByPhraseID: new Map((authored.pages ?? []).map((page) => [page.phraseID, page.id])),
  };
}

function isLegacyCityPageID(proposedPageID, id) {
  return proposedPageID === `viet-phrase-${id}` || proposedPageID === `viet-family-${id}`;
}

function canonicalDetailPageIDForPhrase(targetPhraseID, currentPhraseID, catalogIndex) {
  if (targetPhraseID === currentPhraseID) return null;
  const authoredPageID = catalogIndex.pageIDByPhraseID.get(targetPhraseID);
  if (authoredPageID) return authoredPageID;
  const phrase = catalogIndex.phraseByID.get(targetPhraseID);
  const family = phrase ? catalogIndex.familyByID.get(phrase.familyID) : null;
  return family?.pageID ?? null;
}

function validateApprovalOverlay(approval, patchSet) {
  if (approval.taskID !== taskID) {
    throw new Error(`approval overlay taskID must be ${taskID}`);
  }
  if (approval.approvalMode !== "agent-gated") {
    throw new Error("approval overlay approvalMode must be agent-gated");
  }
  const approvedRows = (approval.approvedPages ?? []).filter((row) => row.import_status === "AGENT_APPROVED_FOR_IMPORT");
  if (approvedRows.length !== 1 || approvedRows[0].phrase_id !== phraseID) {
    throw new Error(`approval overlay must approve only ${phraseID}`);
  }
  const patchPhraseIDs = new Set(patchSet.page_patch.map((row) => row.phrase_id));
  if (!patchPhraseIDs.has(phraseID)) {
    throw new Error(`incoming page patch missing ${phraseID}`);
  }
  for (const row of patchSet.page_patch) {
    if (row.phrase_id !== phraseID) {
      throw new Error(`unexpected incoming page patch ${row.phrase_id}`);
    }
  }
}

function validatePageID(row, currentPageID, pageIDMismatches) {
  if (!row.page_id || row.page_id === currentPageID) return;
  if (!isLegacyCityPageID(row.page_id, row.phrase_id)) {
    throw new Error(`${row.patch_id} page_id ${row.page_id} does not match current ${currentPageID}`);
  }
  pageIDMismatches.push({
    patch_id: row.patch_id,
    phrase_id: row.phrase_id,
    proposed_page_id: row.page_id,
    current_page_id: currentPageID,
    classification: "ACCEPTED_TEMPORARY_RISK",
    note: "legacy exported page ID accepted; current canonical authored page ID preserved",
  });
}

function buildEditorialSections(patchSet, catalogIndex, pageIDMismatches) {
  const sectionRows = (groupByPhraseID(patchSet.section_patch).get(phraseID) ?? [])
    .filter((row) => !row.operation.startsWith("SUPPRESS_"))
    .map((row) => ({ row, proposed: parsePatchValue(row) }))
    .filter(({ proposed }) => proposed.section_key)
    .sort((a, b) => Number(a.proposed.sort_order ?? a.row.target_order ?? 999) - Number(b.proposed.sort_order ?? b.row.target_order ?? 999));

  const rowGroups = new Map();
  for (const row of groupByPhraseID(patchSet.phrase_row_patch).get(phraseID) ?? []) {
    const proposed = parsePatchValue(row);
    const targetPhraseID = proposed.target_phrase_id;
    const sectionID = proposed.section_key;
    if (!targetPhraseID || !sectionID) continue;
    if (!catalogIndex.phraseByID.has(targetPhraseID)) {
      throw new Error(`${row.patch_id} references missing catalog phrase ${targetPhraseID}`);
    }
    const currentTargetPageID = canonicalDetailPageIDForPhrase(targetPhraseID, phraseID, catalogIndex)
      ?? catalogIndex.pageIDByPhraseID.get(targetPhraseID)
      ?? null;
    if (proposed.target_page_id && currentTargetPageID && proposed.target_page_id !== currentTargetPageID) {
      if (!isLegacyCityPageID(proposed.target_page_id, targetPhraseID)) {
        throw new Error(`${row.patch_id} target_page_id ${proposed.target_page_id} does not match current ${currentTargetPageID}`);
      }
      pageIDMismatches.push({
        patch_id: row.patch_id,
        phrase_id: row.phrase_id,
        target_phrase_id: targetPhraseID,
        proposed_page_id: proposed.target_page_id,
        current_page_id: currentTargetPageID,
        classification: "ACCEPTED_TEMPORARY_RISK",
        note: "legacy exported target page ID accepted; current canonical authored page ID preserved",
      });
    }
    if (!rowGroups.has(sectionID)) rowGroups.set(sectionID, []);
    rowGroups.get(sectionID).push({ row, proposed });
  }
  for (const rows of rowGroups.values()) {
    rows.sort((a, b) => Number(a.proposed.display_order ?? a.row.target_order ?? 999) - Number(b.proposed.display_order ?? b.row.target_order ?? 999));
  }

  const sections = sectionRows.map(({ proposed }) => {
    const sectionID = proposed.section_key === "name-meaning" ? "breakdown" : proposed.section_key;
    const section = {
      id: sectionID,
      title: proposed.title,
      body: proposed.body,
    };
    const phraseIDs = (rowGroups.get(proposed.section_key) ?? [])
      .map(({ proposed: rowValue }) => rowValue.target_phrase_id);
    if (phraseIDs.length) section.phraseIDs = Array.from(new Set(phraseIDs));
    if (proposed.section_key === "name-meaning") {
      section.breakdownTokens = nameMeaningBreakdownTokens;
    }
    return section;
  });

  const actualOrder = sections.map((section) => section.id);
  if (JSON.stringify(actualOrder) !== JSON.stringify(expectedSectionOrder)) {
    throw new Error(`Dragon Bridge section order mismatch: ${JSON.stringify(actualOrder)}`);
  }
  return sections;
}

function main() {
  const options = parseArgs(process.argv);
  const patchSet = loadPatchSet();
  const approval = readJSON(options.approvalPath);
  validateApprovalOverlay(approval, patchSet);

  const cityLibrary = readJSON(cityLibraryPath);
  const pageRecord = (cityLibrary.pages ?? []).find((page) => page.id === sourcePageID);
  if (!pageRecord) throw new Error(`Missing city source record ${sourcePageID}`);
  if (pageRecord.targetText !== "Cầu Rồng" || pageRecord.englishText !== "Dragon Bridge") {
    throw new Error("Dragon Bridge canonical title changed unexpectedly");
  }

  const pageIDMismatches = [];
  const catalogIndex = readCatalogIndex();
  for (const row of patchSet.page_patch) {
    validatePageID(row, currentAuthoredPageID, pageIDMismatches);
  }
  const sections = buildEditorialSections(patchSet, catalogIndex, pageIDMismatches);
  const pagePatch = patchSet.page_patch.find((row) => row.phrase_id === phraseID);
  const pageMetadata = parsePatchValue(pagePatch);
  const approvalRow = approval.approvedPages.find((row) => row.phrase_id === phraseID);
  const nextImport = {
    taskID,
    patchID: pagePatch.patch_id,
    approvedAt: approvalRow.approved_at,
    approvedBy: approvalRow.approved_by ?? "codex-agent-review",
    sourcePatch: "dragon-bridge-ux-copy-override-v2/incoming-chatgpt/completed-patch-files",
    priorTaskID,
    priorApprovalArtifacts: [
      "agent-approved-import/traveler-editorial-review.md",
      "agent-approved-import/canonical-import-safety-review.md",
    ],
    summary: pageMetadata.summary ?? pageRecord.englishText,
    categoryIDs: [],
    sections,
    replaceGeneratedSections: true,
    heroImageName: null,
    templateProfile: pageMetadata.template_profile ?? "landmark-action-page",
    suppressedSections,
    agentApprovalID: approvalRow.approval_id ?? null,
    issueClassifications: {
      missingDragonBridgeHero: "FOLLOW_UP",
      legacyExportedPageID: "ACCEPTED_TEMPORARY_RISK",
    },
  };
  const changed = JSON.stringify(pageRecord.editorialImport ?? null) !== JSON.stringify(nextImport);
  if (options.mode === "apply" && changed) {
    pageRecord.editorialImport = nextImport;
    writeJSON(cityLibraryPath, cityLibrary);
  }

  const summary = {
    taskID,
    mode: options.mode,
    incomingRoot: relative(incomingRoot),
    approvalPath: relative(options.approvalPath),
    sourcePath: relative(cityLibraryPath),
    rawRowCounts: Object.fromEntries(Object.entries(patchSet).map(([name, rows]) => [name, rows.length])),
    approvedPageCount: 1,
    importedPageCount: 1,
    skippedPageCount: 0,
    imported: [
      {
        phrase_id: phraseID,
        page_id: currentAuthoredPageID,
        patch_id: pagePatch.patch_id,
        source_path: relative(cityLibraryPath),
        source_lane: "city-library",
        changed,
        section_order: sections.map((section) => section.id),
        phrase_row_groups: Object.fromEntries(sections.map((section) => [section.id, section.phraseIDs ?? []])),
        breakdown_section: "breakdown",
      },
    ],
    skipped: [],
    pageIDMismatches,
    issueClassifications: [
      {
        issue: "Generic Vietnam masthead remains on Dragon Bridge",
        classification: "FOLLOW_UP",
        action: "Track as TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001; not a copy-import blocker.",
      },
      {
        issue: "Incoming patch uses stale viet-phrase page IDs for city pages",
        classification: "ACCEPTED_TEMPORARY_RISK",
        action: "Resolve by phrase_id/current authored page mapping and preserve canonical source record.",
      },
    ],
  };
  if (options.outputPath) writeJSON(options.outputPath, summary);
  console.log(JSON.stringify(summary, null, 2));
}

main();
