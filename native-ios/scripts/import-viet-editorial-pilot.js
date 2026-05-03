#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

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
const authoredResourcePath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const audioManifestPath = path.join(nativeRoot, "Resources", "viet-audio-manifest.json");
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

function applyApprovalToPage(page, patch, approval, audioByText) {
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
  const sourceWrites = new Map();
  const imported = [];
  const skipped = [];

  for (const approval of approvedRows) {
    const patch = patchByID.get(approval.patch_id);
    validateApproval(patch, approval);

    const source = sources.byPhraseID.get(patch.phrase_id) ?? sources.byPageID.get(patch.page_id);
    if (!source) {
      throw new Error(`${patch.patch_id} could not resolve source page for phrase_id=${patch.phrase_id}`);
    }

    const sourceChanges = applyApprovalToPage(source.page, patch, approval, audioByText);
    const resourcePage = pageFromResource(authoredResource, patch.phrase_id);
    const resourceChanges = resourcePage ? applyApprovalToPage(resourcePage, patch, approval, audioByText) : [];
    sourceWrites.set(source.filePath, source.page);

    imported.push({
      patch_id: patch.patch_id,
      page_id: patch.page_id,
      phrase_id: patch.phrase_id,
      source_path: relative(source.filePath),
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
    if (imported.some((row) => row.resource_changes.length > 0)) {
      writeJSON(authoredResourcePath, authoredResource);
    }
  }

  console.log(JSON.stringify(summary, null, 2));
}

main();
