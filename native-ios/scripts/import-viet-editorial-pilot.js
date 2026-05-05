#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const pilotRoot = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-canonical-pages",
  "chatgpt-pilot-2026-05-03"
);
const defaultPatchPath = path.join(pilotRoot, "SpeakLocal_Vietnam_Editorial_Pilot_Patch_v1.json");
const defaultApprovalPath = path.join(pilotRoot, "approved-imports-TASK-VIET-EDITORIAL-PILOT-IMPORT-001.json");
const defaultReadyApprovalPath = path.join(pilotRoot, "approved-imports-TASK-VIET-EDITORIAL-READY-IMPORT-001.json");
const readinessPath = path.join(
  repoRoot,
  "content-draft",
  "viet",
  "editorial-model-support",
  "TASK-VIET-EDITORIAL-MODEL-SUPPORT-001",
  "audit",
  "deferred-readiness.json"
);
const authoredResourcePath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const audioManifestPath = path.join(nativeRoot, "Resources", "viet-audio-manifest.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const sourceRoots = [
  path.join(repoRoot, "content-draft", "viet", "canonical-pages", "tier-one"),
  path.join(repoRoot, "content-draft", "viet", "canonical-pages", "catalog-promoted"),
];

function parseArgs(argv) {
  const options = {
    mode: "dry-run",
    patchPath: defaultPatchPath,
    approvalPath: defaultApprovalPath,
  };
  for (let index = 2; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--apply") {
      options.mode = "apply";
    } else if (arg === "--dry-run" || arg === "--check") {
      options.mode = "dry-run";
    } else if (arg === "--ready-batch") {
      options.approvalPath = defaultReadyApprovalPath;
    } else if (arg === "--patch") {
      options.patchPath = path.resolve(argv[++index]);
    } else if (arg === "--approval") {
      options.approvalPath = path.resolve(argv[++index]);
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
    .toLowerCase()
    .replace(/đ/g, "d")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 64);
}

function generatedAudioKey(prefix, text) {
  const hash = crypto.createHash("sha1").update(String(text ?? "").normalize("NFC")).digest("hex").slice(0, 10);
  return `${prefix}-${slug(text)}-${hash}`;
}

function authoredPhraseAudioKey(text, preferredKey, audioByText) {
  const exact = audioByText.byExactText.get(audioTextKey(text)) ?? audioByText.byNormalizedText.get(normalize(text));
  return preferredKey || exact || generatedAudioKey("audio-authored", text);
}

function authoredBreakdownAudioKey(text, audioByText) {
  return audioByText.byExactText.get(audioTextKey(text)) ?? audioByText.byNormalizedText.get(normalize(text)) ?? null;
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
  return files;
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
  if (!fs.existsSync(audioManifestPath)) return new Map();
  const manifest = readJSON(audioManifestPath);
  const byExactText = new Map();
  const byNormalizedText = new Map();
  for (const [key, value] of Object.entries(manifest)) {
    const exact = audioTextKey(value?.text);
    if (exact && !byExactText.has(exact)) {
      byExactText.set(exact, key);
    }
    const normalized = normalize(value?.text);
    if (normalized && !byNormalizedText.has(normalized)) {
      byNormalizedText.set(normalized, key);
    }
  }
  return { byExactText, byNormalizedText };
}

function parsePipeRows(value) {
  return String(value ?? "")
    .split("|")
    .map((item) => item.trim())
    .filter(Boolean);
}

function parseSectionCopy(value) {
  const sections = [];
  for (const part of String(value ?? "").split(" ⏎ --- ⏎ ")) {
    const separator = part.indexOf(" | ");
    if (separator === -1) continue;
    const id = part.slice(0, separator).trim();
    const body = part.slice(separator + 3).trim();
    if (id && body) sections.push({ id, body });
  }
  return sections;
}

function parseBreakdownLabels(value, phraseID) {
  return parsePipeRows(value).map((row, index) => {
    const separator = row.indexOf(" -> ");
    if (separator === -1) {
      throw new Error(`${phraseID} has malformed breakdown label: ${row}`);
    }
    return {
      id: `${phraseID}-editorial-${index + 1}`,
      vietnamese: row.slice(0, separator).trim(),
      english: row.slice(separator + 4).trim(),
    };
  });
}

function parseVisiblePhraseRows(value) {
  return parsePipeRows(value).map((row) => {
    const slotSeparator = row.indexOf(": ");
    const meaningSeparator = row.indexOf(" -> ");
    if (slotSeparator === -1 || meaningSeparator === -1 || meaningSeparator < slotSeparator) {
      throw new Error(`Malformed visible phrase row: ${row}`);
    }
    return {
      slot: row.slice(0, slotSeparator).trim(),
      vietnamese: row.slice(slotSeparator + 2, meaningSeparator).trim(),
      english: row.slice(meaningSeparator + 4).trim(),
    };
  });
}

function titleForSectionID(sectionID) {
  const explicit = {
    "at-glance": "At a glance",
    "quick-say": "Quick say",
    "breakdown": "Break it down",
    "place-brief": "What it is",
    "before-you-go": "Before you go",
    "inside-the-place": "Inside the place",
    "how-to-order": "How to order",
    "ingredients-diet": "Ingredients and diet",
    "journey-flow": "Journey flow",
    "key-phrases": "Key phrases",
    "use-it-with": "Use it with",
    "show-driver": "Show the driver",
    "confirm": "Confirm",
    "drop-off": "Drop off",
    "wrong-place": "Wrong place",
    "pickup": "Pickup",
    "what-happens-next": "What happens next",
    "recovery": "Recovery",
    "relationship-words": "Relationship words",
    "relationship-swaps": "Relationship swaps",
    "when-to-use": "When to use it",
    "good-to-know": "Good to know",
    "explore-next": "Explore next",
  };
  return explicit[sectionID] ?? sectionID
    .split("-")
    .map((part) => part ? `${part[0].toUpperCase()}${part.slice(1)}` : part)
    .join(" ");
}

const sectionSlotAliases = {
  "quick-say": ["quick-say", "ticket", "route", "street-only"],
  "inside-the-place": ["inside-the-place", "leaving", "pay"],
  "before-you-go": ["before-you-go", "leaving"],
  "how-to-order": ["quick-say", "spice"],
  "ingredients-diet": ["ingredients", "spice"],
  "key-phrases": ["ticket", "cable-car", "photo", "return", "entrance", "driver", "specific-stop", "wait", "return-time"],
  "use-it-with": ["route", "specific-stop", "wait", "return-time", "drop-off", "where", "photo"],
  "show-driver": ["taxi", "street-only"],
  "confirm": ["confirm"],
  "drop-off": ["drop-off"],
  "wrong-place": ["wrong-place"],
  "pickup": ["pickup"],
  "recovery": ["follow-up", "repair", "show", "driver"],
  "relationship-words": ["simple"],
  "relationship-swaps": ["follow-up"],
};

function phraseIDsForSection(sectionID, visibleRows) {
  const aliases = sectionSlotAliases[sectionID] ?? [sectionID];
  const rows = visibleRows.filter((row) => aliases.includes(row.slot));
  if (sectionID === "quick-say" && rows.length === 0 && visibleRows.length > 0) {
    return [visibleRows[0].phraseID];
  }
  return rows.map((row) => row.phraseID);
}

function buildCatalogIndex(authoredResource) {
  const catalog = readJSON(catalogPath);
  const phraseByID = new Map((catalog.phrases ?? []).map((phrase) => [phrase.id, phrase]));
  const familyByID = new Map((catalog.families ?? []).map((family) => [family.id, family]));
  const pageIDByPhraseID = new Map((authoredResource.pages ?? []).map((page) => [page.phraseID, page.id]));
  const phrasesByNormalizedVietnamese = new Map();
  for (const phrase of catalog.phrases ?? []) {
    const key = normalize(phrase.targetText);
    if (!key) continue;
    if (!phrasesByNormalizedVietnamese.has(key)) phrasesByNormalizedVietnamese.set(key, []);
    phrasesByNormalizedVietnamese.get(key).push(phrase);
  }
  return { phraseByID, familyByID, pageIDByPhraseID, phrasesByNormalizedVietnamese };
}

function resolvePhraseIDForVisibleRow(row, catalogIndex) {
  if (row.phraseID) return row.phraseID;
  const matches = catalogIndex.phrasesByNormalizedVietnamese.get(normalize(row.vietnamese)) ?? [];
  if (matches.length !== 1) {
    throw new Error(`Visible row ${row.vietnamese} resolves to ${matches.length} canonical phrases`);
  }
  return matches[0].id;
}

function phraseOptionFromCatalog(phraseID, currentPhraseID, catalogIndex, audioByText) {
  const phrase = catalogIndex.phraseByID.get(phraseID);
  if (!phrase) {
    throw new Error(`Missing catalog phrase ${phraseID}`);
  }
  const family = catalogIndex.familyByID.get(phrase.familyID);
  const detailPageID = phrase.id === currentPhraseID
    ? null
    : (catalogIndex.pageIDByPhraseID.get(phrase.id) ?? family?.pageID ?? null);
  const audioKey = authoredPhraseAudioKey(phrase.targetText, phrase.audioKey, audioByText);
  return {
    id: phrase.id,
    vietnamese: phrase.targetText,
    english: phrase.englishText,
    pronunciation: phrase.pronunciation,
    symbolName: "text.bubble.fill",
    tintName: phrase.cityID ? "teal" : "blue",
    detailPageID,
    audioKey,
  };
}

function sourceBreakdownTokens(tokens, page, oldBreakdown, audioByText) {
  return tokens.map((token) => tokenWithAudio(token, page, oldBreakdown, audioByText));
}

function buildEditorialSections(patch, approval, catalogIndex, audioByText) {
  const sectionBodies = new Map(parseSectionCopy(patch.proposed_section_copy).map((section) => [section.id, section.body]));
  for (const [id, body] of Object.entries(approval.sectionBodyOverrides ?? {})) {
    sectionBodies.set(id, body);
  }

  const breakdownTokens = approval.breakdownTokens ?? parseBreakdownLabels(patch.proposed_breakdown_labels, patch.phrase_id);
  const visibleRows = approval.visibleRows ?? parseVisiblePhraseRows(patch.proposed_visible_phrase_rows);
  const resolvedVisibleRows = visibleRows.map((row) => ({
    ...row,
    phraseID: resolvePhraseIDForVisibleRow(row, catalogIndex),
  }));

  const sections = [];
  const assignedPhraseIDs = new Set();
  for (const [id, body] of sectionBodies.entries()) {
    const section = {
      id,
      title: titleForSectionID(id),
      body,
    };
    if (id === "breakdown") {
      section.breakdownTokens = breakdownTokens;
    }
    let phraseIDs = phraseIDsForSection(id, resolvedVisibleRows);
    if (id === "explore-next") {
      phraseIDs = resolvedVisibleRows
        .map((row) => row.phraseID)
        .filter((phraseID) => !assignedPhraseIDs.has(phraseID));
    }
    if (phraseIDs.length > 0) {
      section.phraseIDs = Array.from(new Set(phraseIDs));
      if (id !== "explore-next") {
        for (const phraseID of section.phraseIDs) assignedPhraseIDs.add(phraseID);
      }
    }
    sections.push(section);
  }

  return {
    sections,
    breakdownTokens,
    visibleRows: resolvedVisibleRows,
  };
}

function validateEditorialSectionPhraseIDs(approval, catalogIndex) {
  for (const section of approval.editorialSections ?? []) {
    for (const phraseID of section.phraseIDs ?? []) {
      if (!catalogIndex.phraseByID.has(phraseID)) {
        throw new Error(`${approval.patch_id} section ${section.id} references missing phrase ${phraseID}`);
      }
    }
  }
  for (const row of approval.visibleRows ?? []) {
    if (!row.phraseID) continue;
    if (!catalogIndex.phraseByID.has(row.phraseID)) {
      throw new Error(`${approval.patch_id} visible row ${row.vietnamese} references missing phrase ${row.phraseID}`);
    }
  }
}

function tokenWithAudio(token, page, oldBreakdown, audioByText) {
  const existing = oldBreakdown.find((item) => normalize(item.vietnamese) === normalize(token.vietnamese));
  const exactAudioKey = audioByText.byExactText.get(audioTextKey(token.vietnamese))
    ?? audioByText.byNormalizedText.get(normalize(token.vietnamese));
  const audioKey = token.audioKey ?? exactAudioKey ?? existing?.audioKey ?? (
    normalize(token.vietnamese) === normalize(page.title) ? page.audioKey : null
  );
  const next = {
    id: token.id,
    vietnamese: token.vietnamese,
    english: token.english,
  };
  if (audioKey) next.audioKey = audioKey;
  return next;
}

function applyApprovalToPage(page, patch, approval, audioByText, catalogIndex = null) {
  const changes = [];
  const oldBreakdown = (page.sections ?? []).find((section) => section.id === "breakdown")?.breakdown ?? [];

  if (approval.summaryOverride && page.summary !== approval.summaryOverride) {
    page.summary = approval.summaryOverride;
    changes.push("summary");
  }

  const bodyOverrides = approval.sectionBodyOverrides ?? {};
  for (const section of page.sections ?? []) {
    const nextBody = bodyOverrides[section.id];
    if (nextBody && section.body !== nextBody) {
      section.body = nextBody;
      changes.push(`section:${section.id}`);
    }
  }

  if (Array.isArray(approval.editorialSections) && catalogIndex) {
    const nextSections = approval.editorialSections.map((sourceSection) => {
      const section = {
        id: sourceSection.id,
        title: sourceSection.title ?? titleForSectionID(sourceSection.id),
        body: sourceSection.body,
      };
      if (Array.isArray(sourceSection.phraseIDs) && sourceSection.phraseIDs.length > 0) {
        section.phrases = sourceSection.phraseIDs.map((phraseID) => phraseOptionFromCatalog(phraseID, page.phraseID, catalogIndex, audioByText));
      }
      if (sourceSection.id === "breakdown") {
        section.breakdown = sourceBreakdownTokens(sourceSection.breakdownTokens ?? approval.breakdownTokens ?? [], page, oldBreakdown, audioByText);
      }
      return section;
    });
    if (JSON.stringify(page.sections ?? []) !== JSON.stringify(nextSections)) {
      page.sections = nextSections;
      changes.push("sections");
    }
    return changes;
  }

  if (Array.isArray(approval.breakdownTokens) && approval.breakdownTokens.length > 0) {
    const breakdownSection = (page.sections ?? []).find((section) => section.id === "breakdown");
    if (!breakdownSection) {
      throw new Error(`${patch.patch_id} ${patch.page_id} has no breakdown section in source page ${page.id}`);
    }
    const nextBreakdown = approval.breakdownTokens.map((token) => tokenWithAudio(token, page, oldBreakdown, audioByText));
    if (JSON.stringify(breakdownSection.breakdown ?? []) !== JSON.stringify(nextBreakdown)) {
      breakdownSection.breakdown = nextBreakdown;
      changes.push("breakdown");
    }
  }

  return changes;
}

function validateApproval(patch, approval) {
  if (approval.import_approval !== "APPROVED_FOR_IMPORT") {
    throw new Error(`${approval.patch_id} approval must be APPROVED_FOR_IMPORT`);
  }
  if (!patch) {
    throw new Error(`${approval.patch_id} is approved but missing from the pilot patch file`);
  }
  if (patch.import_approval !== "REVIEW_ONLY") {
    throw new Error(`${patch.patch_id} expected source patch to remain REVIEW_ONLY, found ${patch.import_approval}`);
  }
  if (normalize(patch.proposed_vietnamese) !== normalize(patch.current_vietnamese)) {
    throw new Error(`${patch.patch_id} changes Vietnamese text; this P0 import does not allow canonical text changes`);
  }
}

function cityLibrarySource() {
  if (!fs.existsSync(cityLibraryPath)) return null;
  const library = readJSON(cityLibraryPath);
  const byPhraseID = new Map((library.pages ?? []).map((page) => [page.id, page]));
  return { filePath: cityLibraryPath, library, byPhraseID };
}

function applyApprovalToCityRecord(record, patch, approval) {
  const nextImport = {
    taskID: approval.taskID,
    patchID: patch.patch_id,
    approvedAt: approval.approvedAt,
    sourcePatch: approval.sourcePatch ?? "SpeakLocal_Vietnam_Editorial_Pilot_Patch_v1.json",
    summary: approval.summaryOverride,
    categoryIDs: approval.categoryIDs ?? [],
    visibleRows: approval.visibleRows ?? [],
    sections: approval.editorialSections ?? [],
    replaceGeneratedSections: approval.replaceGeneratedSections === true,
    heroImageName: approval.heroImageName ?? null,
  };
  if (JSON.stringify(record.editorialImport ?? null) === JSON.stringify(nextImport)) {
    return [];
  }
  record.editorialImport = nextImport;
  return ["editorialImport"];
}

function pageFromResource(resource, phraseID) {
  return (resource.pages ?? []).find((page) => page.phraseID === phraseID) ?? null;
}

function main() {
  const options = parseArgs(process.argv);
  const patchFile = readJSON(options.patchPath);
  const approvalFile = readJSON(options.approvalPath);
  const patchByID = new Map((patchFile.patches ?? []).map((row) => [row.patch_id, row]));
  const approvedRows = (approvalFile.approvals ?? []).filter((row) => row.import_approval === "APPROVED_FOR_IMPORT");
  const sources = sourceIndex();
  const audioByText = audioKeyIndex();
  const authoredResource = fs.existsSync(authoredResourcePath) ? readJSON(authoredResourcePath) : { pages: [] };
  const catalogIndex = buildCatalogIndex(authoredResource);
  const citySource = cityLibrarySource();
  const sourceWrites = new Map();
  let cityLibraryChanged = false;
  const imported = [];
  const skipped = [];

  for (const approval of approvedRows) {
    const patch = patchByID.get(approval.patch_id);
    validateApproval(patch, approval);
    const enrichedApproval = {
      ...approval,
      taskID: approvalFile.taskID,
      approvedAt: approvalFile.approvedAt,
      sourcePatch: approvalFile.sourcePatch,
      summaryOverride: approval.summaryOverride ?? (approval.copySource === "pilot-proposed" ? patch.proposed_summary : undefined),
      categoryIDs: approval.categoryIDs ?? (approval.copySource === "pilot-proposed" ? parsePipeRows(patch.proposed_category_tags) : []),
    };

    if (approval.copySource === "pilot-proposed") {
      const editorial = buildEditorialSections(patch, enrichedApproval, catalogIndex, audioByText);
      enrichedApproval.editorialSections = editorial.sections;
      enrichedApproval.breakdownTokens = enrichedApproval.breakdownTokens ?? editorial.breakdownTokens;
      enrichedApproval.visibleRows = editorial.visibleRows;
    }
    validateEditorialSectionPhraseIDs(enrichedApproval, catalogIndex);

    const source = sources.byPhraseID.get(patch.phrase_id) ?? sources.byPageID.get(patch.page_id);
    const cityRecord = citySource?.byPhraseID.get(patch.phrase_id) ?? null;
    if (!source && !cityRecord) {
      throw new Error(`${patch.patch_id} could not resolve source page for phrase_id=${patch.phrase_id}`);
    }

    const sourceChanges = source
      ? applyApprovalToPage(source.page, patch, enrichedApproval, audioByText, catalogIndex)
      : applyApprovalToCityRecord(cityRecord, patch, enrichedApproval);
    const resourcePage = pageFromResource(authoredResource, patch.phrase_id);
    const resourceChanges = source && resourcePage
      ? applyApprovalToPage(resourcePage, patch, enrichedApproval, audioByText, catalogIndex)
      : [];
    if (source) {
      sourceWrites.set(source.filePath, source.page);
    } else {
      cityLibraryChanged = true;
    }

    imported.push({
      patch_id: patch.patch_id,
      page_id: patch.page_id,
      phrase_id: patch.phrase_id,
      source_path: source ? relative(source.filePath) : relative(cityLibraryPath),
      source_changes: sourceChanges,
      resource_changes: resourceChanges,
    });
  }

  for (const patch of patchFile.patches ?? []) {
    if (!approvedRows.some((row) => row.patch_id === patch.patch_id)) {
      skipped.push({
        patch_id: patch.patch_id,
        page_id: patch.page_id,
        import_approval: patch.import_approval,
      });
    }
  }

  const summary = {
    taskID: approvalFile.taskID,
    mode: options.mode,
    patchPath: relative(options.patchPath),
    approvalPath: relative(options.approvalPath),
    approvedCount: approvedRows.length,
    imported,
    skippedCount: skipped.length,
    skipped,
  };

  if (options.mode === "apply") {
    for (const [filePath, page] of sourceWrites.entries()) {
      writeJSON(filePath, page);
    }
    if (cityLibraryChanged && citySource) {
      writeJSON(citySource.filePath, citySource.library);
    }
    if (imported.some((row) => row.resource_changes.length > 0)) {
      writeJSON(authoredResourcePath, authoredResource);
    }
  }

  console.log(JSON.stringify(summary, null, 2));
}

main();
