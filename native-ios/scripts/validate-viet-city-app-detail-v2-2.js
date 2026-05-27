#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const defaultSourceDir = path.join(
  repoRoot,
  "content-draft",
  "viet",
  "city-library",
  "app-detail-v2-2",
);

const expectedContract = "speaklocal.place.app-detail.v2.2";
const voiceGateStatus = "needs_voice_gate";
const finalPassStatus = "FINAL_PASS";
const bannedVisibleCopyPhrases = [
  "useful because",
  "destination reference line",
  "works as",
  "it fits",
  "the street fits",
  "fits when",
  "stable role",
  "content role",
  "map pin",
  "this page helps",
  "schema checklist",
  "validator receipt",
  "runtime projection",
  "anchor",
];
const legacySectionIDs = new Set([
  "at-glance",
  "quick-say",
  "place-brief",
  "use-it-with",
  "when-to-use",
  "good-to-know",
  "breakdown",
  "explore-next",
  "standard-way",
  "traveler-insight",
  "local-tip",
]);
const currentSourceSectionIDPattern = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;

function parseArgs(argv) {
  const options = {
    sourceDir: defaultSourceDir,
    strictProduction: false,
    maxErrors: 100,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--strict-production") {
      options.strictProduction = true;
    } else if (arg === "--source-dir") {
      const value = argv[index + 1];
      if (!value) {
        throw new Error("--source-dir requires a path");
      }
      options.sourceDir = path.resolve(value);
      index += 1;
    } else if (arg === "--max-errors") {
      const value = Number(argv[index + 1]);
      if (!Number.isInteger(value) || value < 0) {
        throw new Error("--max-errors requires a non-negative integer");
      }
      options.maxErrors = value;
      index += 1;
    } else if (arg === "--help" || arg === "-h") {
      options.help = true;
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }

  return options;
}

function usage() {
  return [
    "Usage: node native-ios/scripts/validate-viet-city-app-detail-v2-2.js [--strict-production] [--source-dir <dir>]",
    "",
    `Default source: ${path.relative(repoRoot, defaultSourceDir)}`,
    "--strict-production fails unless every entry status is FINAL_PASS.",
    "--max-errors <n> limits printed errors; use 0 for all errors.",
  ].join("\n");
}

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function findJSONFiles(dir) {
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const entryPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...findJSONFiles(entryPath));
    } else if (entry.isFile() && entry.name.endsWith(".json") && !entry.name.startsWith("_")) {
      files.push(entryPath);
    }
  }
  return files.sort();
}

function entriesFromJSON(value) {
  if (Array.isArray(value)) return value;
  if (Array.isArray(value.entries)) return value.entries;
  if (Array.isArray(value.pages)) return value.pages;
  if (Array.isArray(value.appDetails)) return value.appDetails;
  return [value];
}

function loadEntries(sourceDir) {
  if (!fs.existsSync(sourceDir)) {
    return {
      entries: [],
      errors: [`source directory not found: ${path.relative(repoRoot, sourceDir)}`],
    };
  }

  const filePaths = findJSONFiles(sourceDir);
  if (filePaths.length === 0) {
    return {
      entries: [],
      errors: [`no JSON source files found in ${path.relative(repoRoot, sourceDir)}`],
    };
  }

  const entries = [];
  const errors = [];

  for (const filePath of filePaths) {
    try {
      for (const entry of entriesFromJSON(readJSON(filePath))) {
        entries.push({
          entry,
          filePath,
        });
      }
    } catch (error) {
      errors.push(`${path.relative(repoRoot, filePath)}: invalid JSON: ${error.message}`);
    }
  }

  return { entries, errors };
}

function loadOptionalIndex(sourceDir) {
  const indexPath = path.join(sourceDir, "_index.json");
  if (!fs.existsSync(indexPath)) return null;

  try {
    return {
      index: readJSON(indexPath),
      indexPath,
    };
  } catch (error) {
    return {
      index: null,
      indexPath,
      error: `${path.relative(repoRoot, indexPath)}: invalid JSON: ${error.message}`,
    };
  }
}

function isNonEmptyString(value) {
  return typeof value === "string" && value.trim().length > 0;
}

function isPlainObject(value) {
  return Boolean(value) && typeof value === "object" && !Array.isArray(value);
}

function validateHeadingBody(value, fieldName, issues) {
  if (!isPlainObject(value)) {
    issues.push(`${fieldName} is required`);
    return;
  }
  if (!isNonEmptyString(value.heading)) {
    issues.push(`${fieldName}.heading is required`);
  }
  if (!isNonEmptyString(value.body)) {
    issues.push(`${fieldName}.body is required`);
  }
}

function validatePhraseCards(entry, issues) {
  if (!Array.isArray(entry.usefulPhraseCards) || entry.usefulPhraseCards.length < 2) {
    issues.push("usefulPhraseCards must contain at least 2 items");
    return;
  }
  if (entry.status === finalPassStatus && entry.usefulPhraseCards.length > 3) {
    issues.push("usefulPhraseCards must contain at most 3 items for FINAL_PASS entries");
  }

  entry.usefulPhraseCards.forEach((card, index) => {
    const prefix = `usefulPhraseCards[${index}]`;
    if (!isPlainObject(card)) {
      issues.push(`${prefix} must be an object`);
      return;
    }
    for (const field of ["vi", "en", "intent", "status"]) {
      if (!isNonEmptyString(card[field])) {
        issues.push(`${prefix}.${field} is required`);
      }
    }
    if (!Object.prototype.hasOwnProperty.call(card, "phraseId")) {
      issues.push(`${prefix}.phraseId is required`);
    }
    if (!Object.prototype.hasOwnProperty.call(card, "audioId")) {
      issues.push(`${prefix}.audioId is required`);
    }
    if (entry.status === finalPassStatus) {
      if (card.status !== "mapped") {
        issues.push(`${prefix}.status must be mapped for FINAL_PASS entries`);
      }
      if (!isNonEmptyString(card.phraseId)) {
        issues.push(`${prefix}.phraseId must be set for FINAL_PASS entries`);
      }
      if (!isNonEmptyString(card.audioId)) {
        issues.push(`${prefix}.audioId must be set for FINAL_PASS entries`);
      }
    }
  });
}

function validateSections(entry, issues) {
  if (!Array.isArray(entry.sections) || entry.sections.length < 2 || entry.sections.length > 4) {
    issues.push("sections must contain 2-4 items");
    return;
  }

  entry.sections.forEach((section, index) => {
    const prefix = `sections[${index}]`;
    if (!isPlainObject(section)) {
      issues.push(`${prefix} must be an object`);
      return;
    }
    for (const field of ["id", "heading", "body"]) {
      if (!isNonEmptyString(section[field])) {
        issues.push(`${prefix}.${field} is required`);
      }
    }
    if (entry.status === finalPassStatus) {
      if (legacySectionIDs.has(section.id)) {
        issues.push(`${prefix}.id uses legacy city-v1 section id "${section.id}"`);
      }
      if (isNonEmptyString(section.id) && !currentSourceSectionIDPattern.test(section.id)) {
        issues.push(`${prefix}.id must be lowercase ASCII slug`);
      }
    }
  });
}

function validateQA(entry, issues) {
  if (!isPlainObject(entry.qa)) {
    issues.push("qa is required");
    return;
  }

  for (const field of [
    "replaceabilityTest",
    "phraseCardTest",
    "mentionedHereTest",
    "catalogMentionScan",
    "duplicateBodyTest",
    "antiCynicismTest",
  ]) {
    if (!isNonEmptyString(entry.qa[field])) {
      issues.push(`qa.${field} is required`);
    }
  }
}

function validateScoreAndStatus(entry, issues) {
  if (!isPlainObject(entry.score)) {
    issues.push("score is required");
  } else {
    if (!Number.isInteger(entry.score.value) || entry.score.value < 0 || entry.score.value > 30) {
      issues.push("score.value must be an integer from 0-30");
    }
    if (entry.score.max !== 30) {
      issues.push("score.max must be 30");
    }
    if (!isNonEmptyString(entry.score.reason)) {
      issues.push("score.reason is required");
    }
  }

  if (!isNonEmptyString(entry.status)) {
    issues.push("status is required");
  }
}

function validateCandidateArrays(entry, issues) {
  for (const field of ["mentionedHereCandidates", "relatedPlaceCandidates", "verificationFlags"]) {
    if (!Array.isArray(entry[field])) {
      issues.push(`${field} must be an array`);
    }
  }

  const renderableCandidateCount = [
    ...(entry.mentionedHereCandidates ?? []),
    ...(entry.relatedPlaceCandidates ?? []),
  ].filter((candidate) => candidate?.status === "render").length;
  if (entry.status === finalPassStatus && renderableCandidateCount < 1) {
    issues.push("FINAL_PASS entries need at least one renderable Mentioned Here or related-place candidate");
  }

  (entry.mentionedHereCandidates ?? []).forEach((candidate, index) => {
    const prefix = `mentionedHereCandidates[${index}]`;
    if (!isPlainObject(candidate)) {
      issues.push(`${prefix} must be an object`);
      return;
    }
    for (const field of ["label", "type", "sourceText", "displaySubtitle", "reason", "status"]) {
      if (!isNonEmptyString(candidate[field])) {
        issues.push(`${prefix}.${field} is required`);
      }
    }
    if (!["render", "check_catalog", "do_not_render"].includes(candidate.status)) {
      issues.push(`${prefix}.status is unsupported`);
    }
    if (!Object.prototype.hasOwnProperty.call(candidate, "catalogId")) {
      issues.push(`${prefix}.catalogId is required`);
    }
  });

  (entry.relatedPlaceCandidates ?? []).forEach((candidate, index) => {
    const prefix = `relatedPlaceCandidates[${index}]`;
    if (!isPlainObject(candidate)) {
      issues.push(`${prefix} must be an object`);
      return;
    }
    for (const field of ["catalogId", "label", "relationship", "displaySubtitle", "reason", "status"]) {
      if (!isNonEmptyString(candidate[field])) {
        issues.push(`${prefix}.${field} is required`);
      }
    }
    if (!["render", "check_catalog", "do_not_render"].includes(candidate.status)) {
      issues.push(`${prefix}.status is unsupported`);
    }
    if (candidate.catalogId === entry.id || candidate.catalogId === entry.pageID) {
      issues.push(`${prefix}.catalogId must not point to the same page`);
    }
  });
}

function statusKind(status) {
  const trimmed = String(status ?? "").trim();
  const upper = trimmed.toUpperCase();
  const lower = trimmed.toLowerCase();

  if (upper === finalPassStatus) return "pass";
  if (lower === voiceGateStatus) return "revise";
  if (upper.includes("REVISE") || upper.includes("REVISION") || upper.includes("NEEDS")) return "revise";
  if (upper.includes("FAIL") || upper.includes("BLOCK")) return "fail";
  return "unknown";
}

function normalizeVisibleText(value) {
  return String(value ?? "")
    .normalize("NFC")
    .replace(/\s+/g, " ")
    .trim()
    .toLowerCase();
}

function visibleCopyValues(entry) {
  const values = [
    entry.displayName,
    entry.englishName,
    entry.travelerMoment,
    entry.storySpine,
    entry.intro?.heading,
    entry.intro?.body,
  ];

  for (const card of entry.usefulPhraseCards ?? []) {
    values.push(card?.vi, card?.en, card?.intent);
  }

  for (const section of entry.sections ?? []) {
    values.push(section?.heading, section?.body);
  }

  for (const candidate of entry.mentionedHereCandidates ?? []) {
    values.push(candidate?.label, candidate?.displaySubtitle);
  }

  for (const candidate of entry.relatedPlaceCandidates ?? []) {
    values.push(candidate?.label, candidate?.displaySubtitle);
  }

  return values.filter((value) => value !== undefined && value !== null);
}

function validateBannedVisibleCopy(entry, issues) {
  for (const value of visibleCopyValues(entry)) {
    if (/^Use\s+/i.test(String(value).trim())) {
      issues.push('visible copy starts with template-like "Use ..." wording');
    }
  }

  const copy = normalizeVisibleText(visibleCopyValues(entry).join("\n"));
  for (const phrase of bannedVisibleCopyPhrases) {
    if (copy.includes(phrase)) {
      issues.push(`banned visible-copy phrase "${phrase}"`);
    }
  }
}

function entryLabel(entry, filePath) {
  return entry.id || entry.displayName || path.relative(repoRoot, filePath);
}

function validateEntry(entry, filePath, options) {
  const issues = [];

  if (!isPlainObject(entry)) {
    return {
      id: path.relative(repoRoot, filePath),
      city: "unknown",
      status: "UNKNOWN",
      kind: "unknown",
      issues: ["entry must be an object"],
    };
  }

  if (entry.contentContract !== expectedContract) {
    issues.push(`contentContract must be ${expectedContract}`);
  }
  for (const field of ["travelerMoment", "storySpine"]) {
    if (!isNonEmptyString(entry[field])) {
      issues.push(`${field} is required`);
    }
  }

  validateHeadingBody(entry.intro, "intro", issues);
  validatePhraseCards(entry, issues);
  validateSections(entry, issues);
  validateCandidateArrays(entry, issues);
  validateQA(entry, issues);
  validateScoreAndStatus(entry, issues);
  validateBannedVisibleCopy(entry, issues);

  const status = String(entry.status ?? "UNKNOWN").trim() || "UNKNOWN";
  const kind = statusKind(status);
  if (kind === "unknown") {
    issues.push(`unsupported status ${status}`);
  } else if (options.strictProduction && status.toUpperCase() !== finalPassStatus) {
    issues.push(`strict production requires every entry to be FINAL_PASS; ${status} found`);
  }

  return {
    id: entryLabel(entry, filePath),
    city: isNonEmptyString(entry.city) ? entry.city.trim() : "unknown",
    status,
    kind,
    issues,
  };
}

function increment(map, key, amount = 1) {
  map.set(key, (map.get(key) ?? 0) + amount);
}

function buildInventory(results) {
  const byCity = new Map();
  const byKind = new Map([
    ["pass", 0],
    ["revise", 0],
    ["fail", 0],
    ["unknown", 0],
  ]);

  for (const result of results) {
    if (!byCity.has(result.city)) {
      byCity.set(result.city, {
        total: 0,
        statuses: new Map(),
        kinds: new Map([
          ["pass", 0],
          ["revise", 0],
          ["fail", 0],
          ["unknown", 0],
        ]),
      });
    }

    const city = byCity.get(result.city);
    city.total += 1;
    increment(city.statuses, result.status);
    increment(city.kinds, result.kind);
    increment(byKind, result.kind);
  }

  return { byCity, byKind };
}

function cityIDFromFile(filePath) {
  const basename = path.basename(filePath, ".json");
  return basename.startsWith("_") ? "unknown" : basename;
}

function sourceIndexRowKey(row) {
  return `${row.file}:${row.pageID || row.id}`;
}

function validateIndex(sourceDir, loadedEntries, errors) {
  const loadedIndex = loadOptionalIndex(sourceDir);
  if (!loadedIndex) return;
  if (loadedIndex.error) {
    errors.push(loadedIndex.error);
    return;
  }

  const { index, indexPath } = loadedIndex;
  const indexLabel = path.relative(repoRoot, indexPath);
  if (!isPlainObject(index)) {
    errors.push(`${indexLabel}: index must be an object`);
    return;
  }

  const sourceRows = loadedEntries.map(({ entry, filePath }) => ({
    id: entry?.id,
    pageID: entry?.pageID,
    cityID: cityIDFromFile(filePath),
    file: path.basename(filePath),
    status: String(entry?.status ?? "UNKNOWN").trim() || "UNKNOWN",
  }));
  const sourceByKey = new Map(sourceRows.map((row) => [sourceIndexRowKey(row), row]));

  if (isPlainObject(index.counts)) {
    if (index.counts.entries !== undefined && index.counts.entries !== sourceRows.length) {
      errors.push(`${indexLabel}: counts.entries is ${index.counts.entries}, expected ${sourceRows.length}`);
    }

    const finalPassCount = sourceRows.filter((row) => row.status === finalPassStatus).length;
    if (index.counts.finalPass !== undefined && index.counts.finalPass !== finalPassCount) {
      errors.push(`${indexLabel}: counts.finalPass is ${index.counts.finalPass}, expected ${finalPassCount}`);
    }

    const needsVoiceGateCount = sourceRows.filter((row) => row.status === voiceGateStatus).length;
    if (index.counts.needsVoiceGate !== undefined && index.counts.needsVoiceGate !== needsVoiceGateCount) {
      errors.push(`${indexLabel}: counts.needsVoiceGate is ${index.counts.needsVoiceGate}, expected ${needsVoiceGateCount}`);
    }
  }

  if (Array.isArray(index.entries)) {
    if (index.entries.length !== sourceRows.length) {
      errors.push(`${indexLabel}: entries length is ${index.entries.length}, expected ${sourceRows.length}`);
    }

    for (const indexRow of index.entries) {
      const key = sourceIndexRowKey(indexRow);
      const sourceRow = sourceByKey.get(key);
      if (!sourceRow) {
        errors.push(`${indexLabel}: stale index row ${key}`);
        continue;
      }
      if (indexRow.status !== sourceRow.status) {
        errors.push(`${indexLabel}: ${key} status is ${indexRow.status}, expected ${sourceRow.status}`);
      }
      if (indexRow.cityID !== undefined && indexRow.cityID !== sourceRow.cityID) {
        errors.push(`${indexLabel}: ${key} cityID is ${indexRow.cityID}, expected ${sourceRow.cityID}`);
      }
    }
  }
}

function formatInventory(results) {
  const inventory = buildInventory(results);
  const lines = ["Inventory by city:"];

  for (const [city, counts] of [...inventory.byCity.entries()].sort(([a], [b]) => a.localeCompare(b))) {
    const statusCounts = [...counts.statuses.entries()]
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([status, count]) => `${status}=${count}`)
      .join(" ");
    lines.push(
      `${city} ${counts.total} ${statusCounts} pass=${counts.kinds.get("pass")} revise=${counts.kinds.get("revise")} fail=${counts.kinds.get("fail")}`,
    );
  }

  lines.push(
    `Status totals: pass=${inventory.byKind.get("pass")} revise=${inventory.byKind.get("revise")} fail=${inventory.byKind.get("fail")} unknown=${inventory.byKind.get("unknown")}`,
  );

  return lines.join("\n");
}

function validateSource(options) {
  const loaded = loadEntries(options.sourceDir);
  const results = loaded.entries.map(({ entry, filePath }) => validateEntry(entry, filePath, options));
  const errors = [...loaded.errors];

  if (loaded.entries.length === 0 && loaded.errors.length === 0) {
    errors.push("no v2.2 entries found");
  }

  for (const result of results) {
    for (const issue of result.issues) {
      errors.push(`${result.id}: ${issue}`);
    }
  }

  validateIndex(options.sourceDir, loaded.entries, errors);

  const productionBlockedCount = results.filter((result) => result.status.toUpperCase() !== finalPassStatus).length;

  return {
    ok: errors.length === 0,
    errors,
    results,
    productionBlockedCount,
  };
}

function main() {
  let options;
  try {
    options = parseArgs(process.argv.slice(2));
  } catch (error) {
    console.error(error.message);
    console.error(usage());
    process.exit(2);
  }

  if (options.help) {
    console.log(usage());
    return;
  }

  const report = validateSource(options);
  console.log(`Viet city app-detail v2.2 validation: ${report.ok ? "PASS" : "FAIL"}`);
  console.log(`source: ${path.relative(repoRoot, options.sourceDir)}`);
  console.log(`total entries: ${report.results.length}`);
  if (report.results.length > 0) {
    console.log(formatInventory(report.results));
  }
  if (report.productionBlockedCount > 0) {
    const noun = report.productionBlockedCount === 1 ? "entry" : "entries";
    console.log(`production blocked: ${report.productionBlockedCount} ${noun} are not FINAL_PASS`);
  }

  if (report.errors.length > 0) {
    console.error("Errors:");
    const printedErrors = options.maxErrors === 0 ? report.errors : report.errors.slice(0, options.maxErrors);
    for (const error of printedErrors) {
      console.error(`- ${error}`);
    }
    if (printedErrors.length < report.errors.length) {
      console.error(`- ... ${report.errors.length - printedErrors.length} more errors (rerun with --max-errors 0 for full output)`);
    }
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = {
  validateSource,
};
