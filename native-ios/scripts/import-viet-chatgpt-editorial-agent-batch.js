#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const taskID = "TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001";
const batchRoot = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-canonical-pages",
  "chatgpt-batch-001"
);
const incomingRoot = path.join(batchRoot, "incoming-chatgpt", "completed-patch-files");
const approvedRoot = path.join(batchRoot, "agent-approved-import");
const defaultApprovalPath = path.join(approvedRoot, "approval-overlay.json");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const authoredResourcePath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const audioManifestPath = path.join(nativeRoot, "Resources", "viet-audio-manifest.json");
const sourceRoots = [
  path.join(repoRoot, "content-draft", "viet", "canonical-pages", "tier-one"),
  path.join(repoRoot, "content-draft", "viet", "canonical-pages", "catalog-promoted"),
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

function audioTextKey(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim().toLowerCase();
}

function slug(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 64);
}

function generatedAudioKey(prefix, text) {
  const hash = crypto.createHash("sha1").update(String(text ?? "").normalize("NFC")).digest("hex").slice(0, 10);
  return `${prefix}-${slug(text)}-${hash}`;
}

function parsePatchValue(row) {
  if (!String(row.proposed_value ?? "").trim()) return {};
  try {
    return JSON.parse(row.proposed_value);
  } catch (error) {
    throw new Error(`${row.patch_id} has invalid proposed_value JSON: ${error.message}`);
  }
}

function parseBreakdownValue(value, patchID) {
  const separator = String(value ?? "").indexOf(" -> ");
  if (separator === -1) {
    throw new Error(`${patchID} has malformed breakdown value: ${value}`);
  }
  return {
    vietnamese: String(value).slice(0, separator).trim(),
    english: String(value).slice(separator + 4).trim(),
  };
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

function sourceIndex() {
  const byPhraseID = new Map();
  const byPageID = new Map();
  for (const root of sourceRoots) {
    for (const filePath of collectJSONFiles(root)) {
      const page = readJSON(filePath);
      if (page.phraseID) byPhraseID.set(page.phraseID, { filePath, page });
      if (page.id) byPageID.set(page.id, { filePath, page });
    }
  }
  return { byPhraseID, byPageID };
}

function audioKeyIndex() {
  const manifest = fs.existsSync(audioManifestPath) ? readJSON(audioManifestPath) : {};
  const byExactText = new Map();
  const byNormalizedText = new Map();
  for (const [key, value] of Object.entries(manifest)) {
    const exact = audioTextKey(value?.text);
    if (exact && !byExactText.has(exact)) byExactText.set(exact, key);
    const normalized = normalize(value?.text);
    if (normalized && !byNormalizedText.has(normalized)) byNormalizedText.set(normalized, key);
  }
  return { byExactText, byNormalizedText };
}

function authoredPhraseAudioKey(text, preferredKey, audioByText) {
  const exact = audioByText.byExactText.get(audioTextKey(text)) ?? audioByText.byNormalizedText.get(normalize(text));
  return preferredKey || exact || generatedAudioKey("audio-authored", text);
}

function authoredBreakdownAudioKey(text, audioByText) {
  return audioByText.byExactText.get(audioTextKey(text)) ?? null;
}

function loadPatchFile(name) {
  const filePath = path.join(incomingRoot, `${name}.json`);
  if (!fs.existsSync(filePath)) {
    throw new Error(`Missing incoming ChatGPT patch file: ${relative(filePath)}`);
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
  const names = [
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
  const patchSet = {};
  for (const name of names) patchSet[name] = loadPatchFile(name);
  return patchSet;
}

function groupByPhraseID(rows) {
  const grouped = new Map();
  for (const row of rows) {
    if (!grouped.has(row.phrase_id)) grouped.set(row.phrase_id, []);
    grouped.get(row.phrase_id).push(row);
  }
  return grouped;
}

function buildCatalogIndex() {
  const catalog = readJSON(catalogPath);
  const authored = fs.existsSync(authoredResourcePath) ? readJSON(authoredResourcePath) : { pages: [] };
  const phraseByID = new Map((catalog.phrases ?? []).map((phrase) => [phrase.id, phrase]));
  const familyByID = new Map((catalog.families ?? []).map((family) => [family.id, family]));
  const pageIDByPhraseID = new Map((authored.pages ?? []).map((page) => [page.phraseID, page.id]));
  return { catalog, authored, phraseByID, familyByID, pageIDByPhraseID };
}

function isLegacyCityPageID(proposedPageID, phraseID) {
  return proposedPageID === `viet-phrase-${phraseID}` || proposedPageID === `viet-family-${phraseID}`;
}

function canonicalDetailPageIDForPhrase(phraseID, currentPhraseID, catalogIndex) {
  if (phraseID === currentPhraseID) return null;
  const pageID = catalogIndex.pageIDByPhraseID.get(phraseID);
  if (pageID) return pageID;
  const family = catalogIndex.familyByID.get(catalogIndex.phraseByID.get(phraseID)?.familyID);
  return family?.pageID ?? null;
}

function phraseOptionFromCatalog(phraseID, currentPhraseID, catalogIndex, audioByText) {
  const phrase = catalogIndex.phraseByID.get(phraseID);
  if (!phrase) {
    throw new Error(`Missing catalog phrase ${phraseID}`);
  }
  return {
    id: phrase.id,
    vietnamese: phrase.targetText,
    english: phrase.englishText,
    pronunciation: phrase.pronunciation,
    detailPageID: canonicalDetailPageIDForPhrase(phraseID, currentPhraseID, catalogIndex),
    audioKey: authoredPhraseAudioKey(phrase.targetText, phrase.audioKey, audioByText),
    tintName: phrase.cityID ? "teal" : undefined,
  };
}

function targetPhraseIDFromRow(row) {
  const proposed = parsePatchValue(row);
  return proposed.target_phrase_id ?? "";
}

function validateRowTarget(row, currentPhraseID, catalogIndex, mismatches) {
  const proposed = parsePatchValue(row);
  const phraseID = proposed.target_phrase_id;
  if (!phraseID) {
    throw new Error(`${row.patch_id} missing proposed target_phrase_id`);
  }
  if (!catalogIndex.phraseByID.has(phraseID)) {
    throw new Error(`${row.patch_id} references missing catalog phrase ${phraseID}`);
  }
  const expectedPageID = canonicalDetailPageIDForPhrase(phraseID, currentPhraseID, catalogIndex)
    ?? catalogIndex.pageIDByPhraseID.get(phraseID)
    ?? null;
  const proposedPageID = proposed.target_page_id;
  if (proposedPageID && expectedPageID && proposedPageID !== expectedPageID) {
    if (!isLegacyCityPageID(proposedPageID, phraseID)) {
      throw new Error(`${row.patch_id} target_page_id ${proposedPageID} does not match current ${expectedPageID}`);
    }
    mismatches.push({
      patch_id: row.patch_id,
      phrase_id: row.phrase_id,
      target_phrase_id: phraseID,
      proposed_page_id: proposedPageID,
      current_page_id: expectedPageID,
      note: "legacy exported page ID accepted; current canonical ID preserved",
    });
  }
  return phraseID;
}

function sectionTitleForID(sectionID) {
  const explicit = {
    "at-glance": "At a glance",
    "quick-say": "Quick say",
    breakdown: "Break it down",
    "standard-way": "The standard way",
    "natural-variations": "Natural variations",
    "why-it-matters": "Why it matters",
    "traveler-insight": "Traveler insight",
    "when-to-use": "When to use it",
    "good-to-know": "Good to know",
    "local-tip": "Local tip",
    "explore-next": "Explore next",
    "inside-the-place": "Inside the place",
    "before-you-go": "Before you go",
    "menu-dietary": "Menu and dietary help",
    "place-brief": "What it is",
    "how-to-order": "How to order",
    "ingredients-diet": "Ingredients and diet",
    "use-it-with": "Use it with",
    "show-driver": "Show the driver",
    confirm: "Confirm",
    "drop-off": "Drop off",
    "wrong-place": "Wrong place",
    pickup: "Pickup",
    "what-happens-next": "What happens next",
    recovery: "Recovery",
  };
  return explicit[sectionID] ?? sectionID.split("-").map((part) => part ? `${part[0].toUpperCase()}${part.slice(1)}` : part).join(" ");
}

function buildEditorialSections(phraseID, approval, patchSet, catalogIndex, audioByText, mismatches) {
  const sectionRows = (groupByPhraseID(patchSet.section_patch).get(phraseID) ?? [])
    .filter((row) => !row.operation.startsWith("REFERENCE_"))
    .filter((row) => !row.operation.startsWith("SUPPRESS_"))
    .map((row) => ({ row, proposed: parsePatchValue(row) }))
    .filter(({ proposed }) => proposed.section_key)
    .sort((a, b) => Number(a.proposed.sort_order ?? a.row.target_order ?? 999) - Number(b.proposed.sort_order ?? b.row.target_order ?? 999));

  const rowGroups = new Map();
  for (const row of groupByPhraseID(patchSet.phrase_row_patch).get(phraseID) ?? []) {
    if (row.operation.startsWith("REFERENCE_")) continue;
    const proposed = parsePatchValue(row);
    if (proposed.suppress === true || row.operation.startsWith("SUPPRESS_")) continue;
    const sectionID = proposed.section_key;
    if (!sectionID) continue;
    validateRowTarget(row, phraseID, catalogIndex, mismatches);
    if (!rowGroups.has(sectionID)) rowGroups.set(sectionID, []);
    rowGroups.get(sectionID).push({ row, proposed });
  }
  for (const rows of rowGroups.values()) {
    rows.sort((a, b) => Number(a.proposed.display_order ?? a.row.target_order ?? 999) - Number(b.proposed.display_order ?? b.row.target_order ?? 999));
  }

  const breakdownTokens = (groupByPhraseID(patchSet.breakdown_patch).get(phraseID) ?? [])
    .filter((row) => !row.operation.startsWith("REFERENCE_"))
    .map((row, index) => {
      const parsed = parseBreakdownValue(row.proposed_value, row.patch_id);
      return {
        id: `${phraseID}-batch001-${index + 1}`,
        vietnamese: parsed.vietnamese,
        english: parsed.english,
      };
    });

  const sections = sectionRows.map(({ proposed }) => {
    const sectionID = proposed.section_key;
    const section = {
      id: sectionID,
      title: proposed.title ?? sectionTitleForID(sectionID),
      body: proposed.body ?? "",
    };
    const phraseIDs = (rowGroups.get(sectionID) ?? []).map(({ proposed: rowValue }) => rowValue.target_phrase_id);
    if (phraseIDs.length > 0) {
      section.phraseIDs = Array.from(new Set(phraseIDs));
    }
    if (sectionID === "breakdown" && breakdownTokens.length > 0) {
      section.breakdownTokens = breakdownTokens;
    }
    return section;
  });

  const sectionOverrides = approval.agent_repair_overrides?.sections ?? [];
  for (const override of sectionOverrides) {
    const section = sections.find((candidate) => candidate.id === override.id);
    if (!section) {
      throw new Error(`${phraseID} repair override references missing section ${override.id}`);
    }
    if (Object.prototype.hasOwnProperty.call(override, "title")) {
      section.title = override.title;
    }
    if (Object.prototype.hasOwnProperty.call(override, "body")) {
      section.body = override.body;
    }
  }

  for (const section of sections) {
    if (section.id === "breakdown" && !section.breakdownTokens?.length && breakdownTokens.length > 0) {
      section.breakdownTokens = breakdownTokens;
    }
  }

  const fullSourceSections = sections.map((section) => {
    const full = {
      id: section.id,
      title: section.title,
      body: section.body,
    };
    if (section.phraseIDs?.length) {
      full.phrases = section.phraseIDs.map((targetPhraseID) =>
        phraseOptionFromCatalog(targetPhraseID, phraseID, catalogIndex, audioByText)
      );
    }
    if (section.id === "breakdown" && section.breakdownTokens?.length) {
      full.breakdown = section.breakdownTokens.map((token) => {
        const next = { ...token };
        const audioKey = authoredBreakdownAudioKey(token.vietnamese, audioByText);
        if (audioKey) next.audioKey = audioKey;
        return next;
      });
    }
    return full;
  });

  return { editorialSections: sections, fullSourceSections, breakdownTokens };
}

function approvalIndex(approvalFile) {
  const approved = new Map();
  for (const row of approvalFile.approvedPages ?? []) {
    if (row.import_status !== "AGENT_APPROVED_FOR_IMPORT") continue;
    approved.set(row.phrase_id, row);
  }
  return approved;
}

function openQuestionsByPhraseID(patchSet) {
  const questions = new Map();
  for (const row of patchSet.questions_for_jojo) {
    if (row.operation === "QUESTION_ONLY" || String(row.jojo_question ?? "").trim()) {
      questions.set(row.phrase_id, row);
    }
  }
  return questions;
}

function validateApprovalOverlay(approvalFile, patchSet) {
  if (approvalFile.taskID !== taskID) {
    throw new Error(`approval overlay taskID must be ${taskID}`);
  }
  if (approvalFile.approvalMode !== "agent-gated") {
    throw new Error("approval overlay approvalMode must be agent-gated");
  }
  const pageRows = new Set(patchSet.page_patch.map((row) => row.phrase_id));
  const questions = openQuestionsByPhraseID(patchSet);
  for (const row of approvalFile.approvedPages ?? []) {
    if (!pageRows.has(row.phrase_id)) {
      throw new Error(`approval references unknown phrase_id ${row.phrase_id}`);
    }
    if (row.import_status !== "AGENT_APPROVED_FOR_IMPORT") {
      throw new Error(`${row.phrase_id} approvedPages row must be AGENT_APPROVED_FOR_IMPORT`);
    }
    if (questions.has(row.phrase_id)) {
      throw new Error(`${row.phrase_id} has an open Jojo/product question and cannot be approved`);
    }
  }
}

function applyToCityRecord(record, pagePatch, approval, builtSections) {
  const metadata = parsePatchValue(pagePatch);
  const next = {
    taskID,
    patchID: pagePatch.patch_id,
    approvedAt: approval.approved_at,
    approvedBy: approval.approved_by ?? "codex-agent-review",
    sourcePatch: "chatgpt-batch-001/incoming-chatgpt/completed-patch-files",
    summary: metadata.summary ?? record.summary ?? record.context,
    categoryIDs: approval.categoryIDs ?? [],
    sections: builtSections.editorialSections,
    replaceGeneratedSections: true,
    heroImageName: null,
    templateProfile: metadata.template_profile ?? "",
    agentApprovalID: approval.approval_id ?? null,
  };
  if (JSON.stringify(record.editorialImport ?? null) === JSON.stringify(next)) return [];
  record.editorialImport = next;
  return ["editorialImport"];
}

function applyToSourcePage(page, pagePatch, approval, builtSections) {
  const metadata = parsePatchValue(pagePatch);
  const changes = [];
  if (metadata.summary && page.summary !== metadata.summary) {
    page.summary = metadata.summary;
    changes.push("summary");
  }
  if (JSON.stringify(page.sections ?? []) !== JSON.stringify(builtSections.fullSourceSections)) {
    page.sections = builtSections.fullSourceSections;
    changes.push("sections");
  }
  const nextImport = {
    taskID,
    patchID: pagePatch.patch_id,
    approvedAt: approval.approved_at,
    approvedBy: approval.approved_by ?? "codex-agent-review",
    sourcePatch: "chatgpt-batch-001/incoming-chatgpt/completed-patch-files",
    templateProfile: metadata.template_profile ?? "",
    agentApprovalID: approval.approval_id ?? null,
  };
  if (JSON.stringify(page.editorialImport ?? null) !== JSON.stringify(nextImport)) {
    page.editorialImport = nextImport;
    changes.push("editorialImport");
  }
  return changes;
}

function main() {
  const options = parseArgs(process.argv);
  const patchSet = loadPatchSet();
  const approvalFile = readJSON(options.approvalPath);
  validateApprovalOverlay(approvalFile, patchSet);

  const approved = approvalIndex(approvalFile);
  const pageRowsByPhraseID = new Map(patchSet.page_patch.map((row) => [row.phrase_id, row]));
  const sources = sourceIndex();
  const cityLibrary = readJSON(cityLibraryPath);
  const cityByPhraseID = new Map((cityLibrary.pages ?? []).map((page) => [page.id, page]));
  const catalogIndex = buildCatalogIndex();
  const audioByText = audioKeyIndex();
  const sourceWrites = new Map();
  const imported = [];
  const skipped = [];
  const pageIDMismatches = [];
  let cityLibraryChanged = false;

  for (const pagePatch of patchSet.page_patch) {
    const approval = approved.get(pagePatch.phrase_id);
    if (!approval) {
      skipped.push({
        phrase_id: pagePatch.phrase_id,
        page_id: pagePatch.page_id,
        patch_id: pagePatch.patch_id,
        reason: "not agent-approved",
      });
      continue;
    }
    const source = sources.byPhraseID.get(pagePatch.phrase_id) ?? sources.byPageID.get(pagePatch.page_id);
    const cityRecord = cityByPhraseID.get(pagePatch.phrase_id) ?? null;
    if (!source && !cityRecord) {
      throw new Error(`${pagePatch.patch_id} could not resolve source for ${pagePatch.phrase_id}`);
    }
    const currentPageID = catalogIndex.pageIDByPhraseID.get(pagePatch.phrase_id) ?? source?.page?.id ?? null;
    if (pagePatch.page_id && currentPageID && pagePatch.page_id !== currentPageID) {
      if (!isLegacyCityPageID(pagePatch.page_id, pagePatch.phrase_id)) {
        throw new Error(`${pagePatch.patch_id} page_id ${pagePatch.page_id} does not match current ${currentPageID}`);
      }
      pageIDMismatches.push({
        patch_id: pagePatch.patch_id,
        phrase_id: pagePatch.phrase_id,
        proposed_page_id: pagePatch.page_id,
        current_page_id: currentPageID,
        note: "legacy exported page ID accepted; current canonical ID preserved",
      });
    }

    const builtSections = buildEditorialSections(pagePatch.phrase_id, approval, patchSet, catalogIndex, audioByText, pageIDMismatches);
    if (builtSections.editorialSections.length === 0) {
      throw new Error(`${pagePatch.patch_id} has no importable sections`);
    }

    const changes = cityRecord
      ? applyToCityRecord(cityRecord, pagePatch, approval, builtSections)
      : applyToSourcePage(source.page, pagePatch, approval, builtSections);
    if (cityRecord) {
      cityLibraryChanged = true;
    } else {
      sourceWrites.set(source.filePath, source.page);
    }
    imported.push({
      phrase_id: pagePatch.phrase_id,
      page_id: currentPageID,
      patch_id: pagePatch.patch_id,
      source_path: cityRecord ? relative(cityLibraryPath) : relative(source.filePath),
      source_lane: cityRecord ? "city-library" : "canonical-pages",
      changes,
      section_count: builtSections.editorialSections.length,
      phrase_row_count: builtSections.editorialSections.reduce((sum, section) => sum + (section.phraseIDs?.length ?? 0), 0),
      breakdown_count: builtSections.breakdownTokens.length,
    });
  }

  const summary = {
    taskID,
    mode: options.mode,
    incomingRoot: relative(incomingRoot),
    approvalPath: relative(options.approvalPath),
    rawRowCounts: Object.fromEntries(Object.entries(patchSet).map(([name, rows]) => [name, rows.length])),
    approvedPageCount: approved.size,
    importedPageCount: imported.length,
    skippedPageCount: skipped.length,
    imported,
    skipped,
    pageIDMismatches,
  };

  if (options.mode === "apply") {
    for (const [filePath, page] of sourceWrites.entries()) {
      writeJSON(filePath, page);
    }
    if (cityLibraryChanged) {
      writeJSON(cityLibraryPath, cityLibrary);
    }
  }

  if (options.outputPath) {
    writeJSON(options.outputPath, summary);
  }
  console.log(JSON.stringify(summary, null, 2));
}

main();
