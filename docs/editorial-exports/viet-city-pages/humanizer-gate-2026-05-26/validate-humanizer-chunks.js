#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..", "..", "..");
const gateRoot = __dirname;
const chunksDir = path.join(gateRoot, "chunks");
const sourceDir = path.join(
  repoRoot,
  "content-draft",
  "viet",
  "city-library",
  "handwritten-copy",
);

const ranges = [
  { cityID: "danang", label: "001-025", start: 0, end: 25, file: "danang_001_025_humanized.json" },
  { cityID: "danang", label: "026-050", start: 25, end: 50, file: "danang_026_050_humanized.json" },
  { cityID: "danang", label: "051-075", start: 50, end: 75, file: "danang_051_075_humanized.json" },
  { cityID: "danang", label: "076-100", start: 75, end: 100, file: "danang_076_100_humanized.json" },
  { cityID: "hanoi", label: "001-025", start: 0, end: 25, file: "hanoi_001_025_humanized.json" },
  { cityID: "hanoi", label: "026-050", start: 25, end: 50, file: "hanoi_026_050_humanized.json" },
  { cityID: "hanoi", label: "051-075", start: 50, end: 75, file: "hanoi_051_075_humanized.json" },
  { cityID: "hanoi", label: "076-100", start: 75, end: 100, file: "hanoi_076_100_humanized.json" },
];

const requiredSectionIDs = ["at-glance", "quick-say", "place-brief", "use-it-with", "good-to-know"];
const bannedFragments = [
  "useful because",
  "traveler",
  "travelers",
  "helps travelers",
  "helps",
  "helps ",
  "anchor",
  "place name",
  "works best",
  "best for",
  "best as",
  "best when",
  "best treated",
  "best approached",
  "reads best",
  "content role",
  "map pin",
  "destination reference line",
  "use this as",
  "this entry",
  "this page",
  "this listing",
  "the useful moment",
  "useful moment",
  "the page",
  "the entry",
  " entry",
  "entry ",
  "entry should",
  "entry stays",
  "entry avoids",
  "dish entry",
  "food entry",
  "beach entry",
  "craft-village entry",
  "lake entry",
  "route entry",
  "restaurant entry",
  "street-orientation entry",
  "neighborhood-orientation entry",
  "the tone should",
  "should feel",
  "the focus is",
  "is framed",
  "low-claim",
  "avoids",
  "promises",
  "promise about",
  "without promising",
  "unstable show claims",
  "facility claims",
  "detailed facility claims",
  "exhibit claims",
  "access claims",
  "review language",
  "fear language",
  "inventory",
  "city library",
  "condition-aware",
  "entry point",
  "visible copy",
  "database",
  "schema",
  "render",
  "check_catalog",
  "not_run",
  "ready_for",
  "production-ready",
  "freshness-gated",
  "freshness gated",
  "freshness check",
  "freshness",
  "fresh review",
  "live checks",
  "current venue check",
  "current venue",
  "current details",
  "venue check",
  "before import",
  "before publishing",
  "before publication",
  "needs review",
  "need review",
  "needs checking",
  "need checking",
  "current review",
  "same-week",
  "late check",
  "until checked",
  "unstable claim",
  "current claim",
  "claims",
  "current menu",
  "current stalls",
  "current businesses",
  "current prestige",
  "overclaim",
  "thin-source",
  "offline copy",
  "source weakness",
  "source evidence is thin",
  "evidence is thinner",
  "copy should",
  "copy stays",
  "keep visible copy",
  "stay hidden until",
  "perfect for",
  "hidden gem",
  "must-visit",
  "bustling",
  "vibrant",
  "nestled",
  "curated",
];

const weakHeadingStarts = /^(Use|Keep|Choose|Ask|Confirm|Leave|Start|Let|Avoid)\b/i;
const weakSentenceStarts = /(^|[.!?]\s+)Use\s+/;

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim();
}

function words(value) {
  const text = normalize(value);
  return text ? text.split(/\s+/).length : 0;
}

function visibleText(entry) {
  return [
    entry.summary,
    entry.context,
    entry.tip,
    entry.rationale,
    ...(entry.sections ?? []).flatMap((section) => [section.title, section.body]),
  ].filter(Boolean).join("\n");
}

function sectionByID(entry) {
  return new Map((entry.sections ?? []).map((section) => [section.id, section]));
}

function phraseIDs(entry) {
  const quickSay = sectionByID(entry).get("quick-say");
  return Array.isArray(quickSay?.phraseIDs) ? quickSay.phraseIDs.map(String) : [];
}

function fail(errors, id, message) {
  errors.push({ id, message });
}

function validateEntry({ source, entry, expectedID, errors, warnings }) {
  const id = entry?.pageID ?? expectedID;
  if (!entry || typeof entry !== "object") {
    fail(errors, expectedID, "missing entry object");
    return;
  }
  if (entry.pageID !== expectedID) {
    fail(errors, expectedID, `pageID mismatch: got ${entry.pageID}`);
  }

  for (const field of ["summary", "context", "tip", "rationale"]) {
    const text = normalize(entry[field]);
    if (text.length < 35) fail(errors, id, `${field} is too thin`);
    if (field === "summary" && text.length < 130) {
      fail(errors, id, "summary is under importer minimum of 130 characters");
    }
    if (words(text) > 45) fail(errors, id, `${field} is over 45 words`);
  }

  if (!Array.isArray(entry.sections)) {
    fail(errors, id, "sections is not an array");
    return;
  }
  const sections = sectionByID(entry);
  if (sections.size !== (entry.sections ?? []).length) {
    fail(errors, id, "duplicate section id detected");
  }
  for (const sectionID of requiredSectionIDs) {
    if (!sections.has(sectionID)) {
      fail(errors, id, `missing section ${sectionID}`);
    }
  }
  const sourceSectionIDs = (source.sections ?? []).map((section) => section.id);
  for (const sourceSectionID of sourceSectionIDs) {
    if (!sections.has(sourceSectionID)) {
      fail(errors, id, `dropped source section ${sourceSectionID}`);
    }
  }

  for (const section of entry.sections) {
    const title = normalize(section.title);
    const body = normalize(section.body);
    if (!title) fail(errors, id, `section ${section.id} missing title`);
    const sectionPhraseIDs = Array.isArray(section.phraseIDs) ? section.phraseIDs : [];
    if (section.id === "quick-say" && sectionPhraseIDs.length === 0 && body.length < 65) {
      fail(errors, id, "quick-say without phraseIDs needs a body of at least 65 characters");
    }
    if (section.id !== "quick-say" && body.length < 65) {
      fail(errors, id, `section ${section.id} body too thin`);
    }
    if (section.id !== "quick-say" && words(body) > 45) {
      fail(errors, id, `section ${section.id} body over 45 words`);
    }
    if (weakHeadingStarts.test(title)) {
      fail(errors, id, `heading is command-like: ${title}`);
    }
  }

  const originalPhraseIDs = phraseIDs(source);
  const nextPhraseIDs = phraseIDs(entry);
  const quickSay = sections.get("quick-say");
  if (nextPhraseIDs.length > 0) {
    if (normalize(quickSay?.title) !== "Useful Phrases") {
      fail(errors, id, "quick-say with phraseIDs must keep title Useful Phrases");
    }
    if (normalize(quickSay?.body) !== "") {
      fail(errors, id, "quick-say with phraseIDs must keep empty body");
    }
  } else if (normalize(quickSay?.title) === "Useful Phrases") {
    fail(errors, id, "quick-say without phraseIDs must not use title Useful Phrases");
  }
  if (originalPhraseIDs.length > 0) {
    const before = originalPhraseIDs.join("|");
    const after = nextPhraseIDs.join("|");
    if (before !== after) {
      fail(errors, id, `quick-say phraseIDs changed from [${before}] to [${after}]`);
    }
  } else if (nextPhraseIDs.length > 0) {
    fail(errors, id, `quick-say added phraseIDs [${nextPhraseIDs.join("|")}] where source had none`);
  }

  const lowerVisible = visibleText(entry).toLowerCase();
  if (weakSentenceStarts.test(visibleText(entry))) {
    fail(errors, id, "visible copy has a sentence starting with Use");
  }
  for (const fragment of bannedFragments) {
    if (lowerVisible.includes(fragment)) {
      fail(errors, id, `visible copy contains banned fragment "${fragment}"`);
    }
  }

  const uniqueBodies = new Set(
    entry.sections
      .filter((section) => section.id !== "quick-say")
      .map((section) => normalize(section.body).toLowerCase())
      .filter(Boolean),
  );
  const nonQuickBodies = entry.sections.filter((section) => section.id !== "quick-say").length;
  if (uniqueBodies.size !== nonQuickBodies) {
    fail(errors, id, "duplicate section body detected");
  }
}

const result = {
  generatedAt: new Date().toISOString(),
  chunks: [],
  totals: { entries: 0, errors: 0, warnings: 0, missingChunks: 0 },
  errors: [],
  warnings: [],
};

for (const range of ranges) {
  const sourcePath = path.join(sourceDir, `${range.cityID}.json`);
  const chunkPath = path.join(chunksDir, range.file);
  const sourceFile = readJSON(sourcePath);
  const expected = sourceFile.entries.slice(range.start, range.end);

  if (!fs.existsSync(chunkPath)) {
    result.totals.missingChunks += 1;
    result.chunks.push({ ...range, status: "missing" });
    result.errors.push({ id: `${range.cityID}-${range.label}`, message: `missing chunk ${chunkPath}` });
    continue;
  }

  const chunk = readJSON(chunkPath);
  const errors = [];
  const warnings = [];
  if (chunk.cityID !== range.cityID) fail(errors, `${range.cityID}-${range.label}`, "cityID mismatch");
  if (chunk.range !== range.label) fail(errors, `${range.cityID}-${range.label}`, "range mismatch");
  if (!Array.isArray(chunk.entries)) fail(errors, `${range.cityID}-${range.label}`, "entries is not an array");
  if ((chunk.entries ?? []).length !== expected.length) {
    fail(errors, `${range.cityID}-${range.label}`, `expected ${expected.length} entries, got ${(chunk.entries ?? []).length}`);
  }

  for (let i = 0; i < expected.length; i += 1) {
    validateEntry({
      source: expected[i],
      entry: chunk.entries?.[i],
      expectedID: expected[i].pageID,
      errors,
      warnings,
    });
  }

  result.totals.entries += chunk.entries?.length ?? 0;
  result.totals.errors += errors.length;
  result.totals.warnings += warnings.length;
  result.errors.push(...errors);
  result.warnings.push(...warnings);
  result.chunks.push({
    cityID: range.cityID,
    range: range.label,
    file: range.file,
    status: errors.length ? "fail" : "pass",
    entries: chunk.entries?.length ?? 0,
    errors: errors.length,
    warnings: warnings.length,
  });
}

const reportPath = path.join(gateRoot, "reports", "humanizer_chunk_validation.json");
fs.writeFileSync(reportPath, `${JSON.stringify(result, null, 2)}\n`);

if (result.totals.errors > 0 || result.totals.missingChunks > 0) {
  console.error(`Humanizer chunk validation failed. Report: ${reportPath}`);
  console.error(`errors=${result.totals.errors} missingChunks=${result.totals.missingChunks}`);
  process.exit(1);
}

console.log(`Humanizer chunk validation passed. entries=${result.totals.entries} warnings=${result.totals.warnings}`);
console.log(reportPath);
