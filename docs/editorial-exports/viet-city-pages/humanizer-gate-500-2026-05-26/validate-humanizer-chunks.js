#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

if (!process.argv.includes("--legacy-humanizer")) {
  console.log([
    "LEGACY_REVOKED_NOT_CURRENT_GATE",
    "The 2026-05-26 humanizer chunk validator is historical only.",
    "Use native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production and native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js for current city/place v2.2 approval.",
    "Pass --legacy-humanizer only to inspect the revoked historical chunk run.",
  ].join("\n"));
  process.exit(0);
}

const repoRoot = path.resolve(__dirname, "..", "..", "..", "..");
const gateRoot = __dirname;
const chunksDir = path.join(gateRoot, "chunks");
const reportsDir = path.join(gateRoot, "reports");
const sourceDir = path.join(
  repoRoot,
  "content-draft",
  "viet",
  "city-library",
  "handwritten-copy",
);
const phraseCatalogPath = path.join(repoRoot, "native-ios", "Resources", "viet-phrase-catalog.json");
const audioManifestPath = path.join(repoRoot, "native-ios", "Resources", "viet-audio-manifest.json");

const cities = ["danang", "hanoi", "hcmc", "hoian", "hue"];
const labels = [
  { label: "001-025", start: 0, end: 25 },
  { label: "026-050", start: 25, end: 50 },
  { label: "051-075", start: 50, end: 75 },
  { label: "076-100", start: 75, end: 100 },
];
const ranges = cities.flatMap((cityID) =>
  labels.map((range) => ({
    cityID,
    ...range,
    file: `${cityID}_${range.label.replace("-", "_")}_humanized.json`,
  })),
);

const requiredSectionIDs = ["at-glance", "quick-say", "place-brief", "use-it-with", "good-to-know"];
const bannedFragments = [
  "useful because",
  "traveler",
  "travelers",
  "helps travelers",
  "anchor",
  "place name",
  "works best",
  "works because it",
  "best for",
  "best as",
  "best when",
  "best treated",
  "best approached",
  "reads best",
  "key word",
  "creamy top",
  "content role",
  "map pin",
  "destination reference line",
  "use this as",
  "this entry",
  "this row",
  "this page",
  "this listing",
  "the row",
  "rows",
  "the useful moment",
  "useful moment",
  "the page",
  "the entry",
  "entry should",
  "entry stays",
  "entry avoids",
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
  "review language",
  "inventory",
  "generated",
  "generator",
  "city library",
  "page kind",
  "the traveler needs",
  "the user should",
  "play the name",
  "shown here",
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
  "worth knowing",
  "worth saving",
  "worth considering",
  "matters when",
  "fits when",
  "works when",
  "belongs in the same image",
  "the point is the small reset",
  "safe frame",
  "stable role",
  "source detail",
  "source image",
  "source confirms",
  "verified",
  "city set",
  "restaurant set",
  "restaurant page",
  "theatre page",
  "loop page",
  "the stable reason",
  "stable reason",
  "stable draw",
  "stable role",
  "the durable reason",
  "durable reason",
  "durable idea",
  "durable part",
  "stable details",
  "in the source",
  "visible experience should",
  "safest claim",
  "keep the claim",
  "evidence is narrow",
  "thin evidence",
  "specific menus change",
  "menu details should",
  "not a menu claim",
  "not a claim",
  "visit logistics",
  "planning logistics",
  "saved value",
  "reference points",
  "useful moments",
  "route phrase",
  "where-question",
  "belongs because",
  "the stable thing",
  "local name noun",
  "current rules",
  "fresh source",
  "gives da nang a",
  "gives hanoi a",
  "gives hue a",
  "gives hoi an a",
  "gives hcmc a",
  "gives saigon a",
  "perfect for",
  "hidden gem",
  "must-visit",
  "bustling",
  "vibrant",
  "nestled",
  "curated",
];

const oldSectionTitles = new Set(["why go", "what you'll get", "say it locally", "worth it if", "before you go"]);
const weakHeadingStarts = /^(Use|Keep|Choose|Ask|Confirm|Leave|Start|Let|Check)\b/i;
const weakSentenceStarts = /(^|[.!?]\s+|\n)Use\s+/;
const entryWordPattern = /\bentry\b/i;
const lowercaseHeadingStart = /^[a-z]/;
const freshnessTitlePattern = /\b(fresh(?:ness| check| checks| look| details| review)|current(?: details| menu| stalls| businesses| claim| claims| review| venue| exhibits| displays| activity| program| street rhythm| look)?|details (?:need|needs|can)|can (?:change|shift|vary)|need(?:s)? (?:current )?checking|check (?:before|for current|again)|confirm\b.*\bseparately)\b/i;
const genericNameCardTitlePattern =
  /^(?:(?:Local|The|Short)\s+)?(?:Name|Venue|Street|Route|Dish|Cafe|Bridge|Beach|Market|Station|Theatre|Museum|Tomb|Neighborhood|Area|Shop|Restaurant|Bar|Temple|Pagoda|Gate|Airport|Park|House)(?:\s+(?:Name|To\s+(?:Recognize|Hear)|Cue|First|In\s+(?:Vietnamese|English)|At\s+The\s+Door|On\s+Signs))?$|^(?:Local\s+)?(?:Dish|Market|Station|Street|Venue|Shop|Restaurant|Temple|Tomb|Area|Walking\s+Street)\s+Name(?:\s+Cue)?$/i;
const qaBodyPattern = /\b(?:details?|menus?|prices?|hours|schedules?|access|rules?|availability|crowds?|stalls?|businesses|exhibits|displays|activity|programs?|routes?|street conditions|ticket details|venue details)\b.{0,70}\b(?:can|may|might|need|needs)\b.{0,40}\b(?:change|shift|vary|check|checking|checked|current|fresh|verifying|verification)\b/i;

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

const phraseCatalog = readJSON(phraseCatalogPath);
const phraseByID = new Map((phraseCatalog.phrases ?? []).map((phrase) => [phrase.id, phrase]));
const audioManifest = readJSON(audioManifestPath);

function normalize(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim();
}

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function hasBannedFragment(text, fragment) {
  return new RegExp(`\\b${escapeRegExp(fragment)}\\b`, "i").test(text);
}

function words(value) {
  const text = normalize(value);
  return text ? text.split(/\s+/).length : 0;
}

function sectionByID(entry) {
  return new Map((entry.sections ?? []).map((section) => [section.id, section]));
}

function phraseIDs(entry) {
  const quickSay = sectionByID(entry).get("quick-say");
  return Array.isArray(quickSay?.phraseIDs) ? quickSay.phraseIDs.map(String) : [];
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

function fail(errors, id, message) {
  errors.push({ id, message });
}

function warn(warnings, id, message) {
  warnings.push({ id, message });
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
    if (field === "summary" && text.length < 130) fail(errors, id, "summary is under importer minimum of 130 characters");
    if (words(text) > 45) fail(errors, id, `${field} is over 45 words`);
  }

  if (!Array.isArray(entry.sections)) {
    fail(errors, id, "sections is not an array");
    return;
  }

  const sections = sectionByID(entry);
  if (sections.size !== entry.sections.length) fail(errors, id, "duplicate section id detected");
  for (const sectionID of requiredSectionIDs) {
    if (!sections.has(sectionID)) fail(errors, id, `missing section ${sectionID}`);
  }
  for (const sourceSectionID of (source.sections ?? []).map((section) => section.id)) {
    if (!sections.has(sourceSectionID)) fail(errors, id, `dropped source section ${sourceSectionID}`);
  }

  for (const section of entry.sections) {
    const title = normalize(section.title);
    const body = normalize(section.body);
    if (!title) fail(errors, id, `section ${section.id} missing title`);
    if (lowercaseHeadingStart.test(title)) fail(errors, id, `heading starts lowercase: ${title}`);
    if (oldSectionTitles.has(title.toLowerCase())) fail(errors, id, `old section title remains: ${title}`);
    if (weakHeadingStarts.test(title)) fail(errors, id, `heading is command-like: ${title}`);
    if (freshnessTitlePattern.test(title)) warn(warnings, id, `freshness/process-like heading: ${title}`);
    if (section.id === "quick-say" && !phraseIDs(entry).length && genericNameCardTitlePattern.test(title)) {
      warn(warnings, id, `generic non-playable quick-say title: ${title}`);
    }
    if (section.id === "quick-say" && !phraseIDs(entry).length && body.length < 65) {
      fail(errors, id, "quick-say without phraseIDs needs a body of at least 65 characters");
    }
    if (section.id !== "quick-say" && body.length < 65) fail(errors, id, `section ${section.id} body too thin`);
    if (section.id !== "quick-say" && words(body) > 45) fail(errors, id, `section ${section.id} body over 45 words`);
  }

  const originalPhraseIDs = phraseIDs(source);
  const nextPhraseIDs = phraseIDs(entry);
  const quickSay = sections.get("quick-say");
  if (nextPhraseIDs.length > 0) {
    if (normalize(quickSay?.title) !== "Useful Phrases") fail(errors, id, "quick-say with phraseIDs must keep title Useful Phrases");
    if (normalize(quickSay?.body) !== "") fail(errors, id, "quick-say with phraseIDs must keep empty body");
  } else if (normalize(quickSay?.title) === "Useful Phrases") {
    fail(errors, id, "quick-say without phraseIDs must not use title Useful Phrases");
  }
	  if (originalPhraseIDs.join("|") !== nextPhraseIDs.join("|")) {
	    fail(errors, id, `quick-say phraseIDs changed from [${originalPhraseIDs.join("|")}] to [${nextPhraseIDs.join("|")}]`);
	  }
	  for (const phraseID of nextPhraseIDs) {
	    const phrase = phraseByID.get(phraseID);
	    if (!phrase) {
	      fail(errors, id, `quick-say phraseID not found in catalog: ${phraseID}`);
	      continue;
	    }
	    if (phrase.audioStatus !== "ready") fail(errors, id, `quick-say phraseID is not ready audio: ${phraseID}`);
	    if (!audioManifest[phraseID] && !audioManifest[phrase.audioKey]) fail(errors, id, `quick-say phraseID has no bundled audio manifest entry: ${phraseID}`);
	    if (phrase.placeID || phrase.placeName || phrase.cityLibraryKind || phrase.cityLibraryPageKind || phrase.contentRole) {
	      fail(errors, id, `quick-say phraseID appears place/entity-specific instead of reusable: ${phraseID}`);
	    }
	  }

  const text = visibleText(entry);
  for (const fragment of bannedFragments) {
    if (hasBannedFragment(text, fragment)) fail(errors, id, `banned visible fragment: ${fragment}`);
  }
  if (entryWordPattern.test(text)) fail(errors, id, "banned visible fragment: entry");
  if (weakSentenceStarts.test(text)) fail(errors, id, "visible sentence begins with Use");
  if (qaBodyPattern.test(text)) warn(warnings, id, "visible QA/freshness/process language in body copy");

  const bodies = (entry.sections ?? []).map((section) => normalize(section.body)).filter(Boolean);
  if (new Set(bodies).size !== bodies.length) fail(errors, id, "duplicate section body detected");
}

function formulaHeadingPattern(title) {
  const text = normalize(title).toLowerCase();
  if (!text) return "";
  if (/^(good|better) (for|when|as)\b/.test(text)) return "good-for/as/when heading";
  if (/^(name|local name|venue name|street name|dish name|route name|cafe name|brand name|place name)\b/.test(text)) {
    return "generic name-card heading";
  }
  if (freshnessTitlePattern.test(text)) return "freshness/checking heading";
  if (/^(a|an|the)?\s*(clean|cool|quiet|short|small|easy|simple|practical)\s+(pause|reset|break|stop)\b/.test(text)) {
    return "generic pause/reset heading";
  }
  if (/\b(route marker|reference point|name to hear|name to recognize)\b/.test(text)) return "map/name utility heading";
  return "";
}

function validateCorpusTaste({ chunks, warnings }) {
  const titleCounts = new Map();
  for (const chunk of chunks) {
    for (const entry of chunk.entries ?? []) {
      for (const section of entry.sections ?? []) {
        const title = normalize(section.title);
        if (!title || title === "Useful Phrases") continue;
        titleCounts.set(title.toLowerCase(), (titleCounts.get(title.toLowerCase()) ?? 0) + 1);
      }
    }
  }
  for (const [title, count] of titleCounts.entries()) {
    if (count > 12) warn(warnings, "corpus", `corpus repeated heading ${count}x: ${title}`);
  }
}

function validateChunkTaste({ chunk, warnings }) {
  const exactTitleCounts = new Map();
  const formulaCounts = new Map();
  let genericNameCards = 0;
  let freshnessTitles = 0;

  for (const entry of chunk.entries ?? []) {
    for (const section of entry.sections ?? []) {
      const title = normalize(section.title);
      if (!title || title === "Useful Phrases") continue;

      const exactKey = title.toLowerCase();
      exactTitleCounts.set(exactKey, (exactTitleCounts.get(exactKey) ?? 0) + 1);
      const formulaKey = formulaHeadingPattern(title);
      if (formulaKey) formulaCounts.set(formulaKey, (formulaCounts.get(formulaKey) ?? 0) + 1);
      if (section.id === "quick-say" && !phraseIDs(entry).length && genericNameCardTitlePattern.test(title)) {
        genericNameCards += 1;
      }
      if (freshnessTitlePattern.test(title)) freshnessTitles += 1;
    }
  }

  for (const [title, count] of exactTitleCounts.entries()) {
    if (count > 2) warn(warnings, chunk.range ?? chunk.cityID, `repeated exact heading ${count}x: ${title}`);
  }
  for (const [pattern, count] of formulaCounts.entries()) {
    if (count > 3) warn(warnings, chunk.range ?? chunk.cityID, `repeated formula heading ${count}x: ${pattern}`);
  }
  if (genericNameCards > 3) warn(warnings, chunk.range ?? chunk.cityID, `non-playable quick-say name-card pattern appears ${genericNameCards}x`);
  if (freshnessTitles > 0) warn(warnings, chunk.range ?? chunk.cityID, `freshness/process headings appear ${freshnessTitles}x`);
}

const report = {
  gate: "humanizer-gate-500-2026-05-26",
  generatedAt: new Date().toISOString(),
  entries: 0,
  errorCount: 0,
  warningCount: 0,
  chunks: [],
};

let totalEntries = 0;
const loadedChunks = [];
for (const range of ranges) {
  const sourcePath = path.join(sourceDir, `${range.cityID}.json`);
  const sourceFile = readJSON(sourcePath);
  const chunkPath = path.join(chunksDir, range.file);
  const chunkReport = { file: range.file, cityID: range.cityID, range: range.label, status: "pass", errors: [], warnings: [] };

  if (!fs.existsSync(chunkPath)) {
    chunkReport.status = "fail";
    fail(chunkReport.errors, `${range.cityID}-${range.label}`, `missing chunk ${range.file}`);
    report.chunks.push(chunkReport);
    continue;
  }

  const chunk = readJSON(chunkPath);
  loadedChunks.push(chunk);
  if (chunk.cityID !== range.cityID) fail(chunkReport.errors, range.file, `wrong cityID ${chunk.cityID}`);
  if (chunk.range !== range.label) fail(chunkReport.errors, range.file, `wrong range ${chunk.range}`);
  if (!Array.isArray(chunk.entries)) {
    fail(chunkReport.errors, range.file, "entries is not an array");
  } else if (chunk.entries.length !== range.end - range.start) {
    fail(chunkReport.errors, range.file, `expected ${range.end - range.start} entries, got ${chunk.entries.length}`);
  } else {
    for (let i = 0; i < chunk.entries.length; i += 1) {
      const source = sourceFile.entries[range.start + i];
      validateEntry({ source, entry: chunk.entries[i], expectedID: source.pageID, errors: chunkReport.errors, warnings: chunkReport.warnings });
    }
    validateChunkTaste({ chunk, warnings: chunkReport.warnings });
    totalEntries += chunk.entries.length;
  }

  if (chunkReport.errors.length) chunkReport.status = "fail";
  report.chunks.push(chunkReport);
}

const corpusWarnings = [];
validateCorpusTaste({ chunks: loadedChunks, warnings: corpusWarnings });
if (corpusWarnings.length) {
  report.chunks.push({ file: "__corpus__", cityID: "all", range: "all", status: "warn", errors: [], warnings: corpusWarnings });
}

fs.mkdirSync(reportsDir, { recursive: true });
const reportPath = path.join(reportsDir, "humanizer_chunk_validation.json");

const errors = report.chunks.reduce((sum, chunk) => sum + chunk.errors.length, 0);
const warnings = report.chunks.reduce((sum, chunk) => sum + chunk.warnings.length, 0);
const missingChunks = report.chunks.filter((chunk) => chunk.errors.some((error) => error.message.startsWith("missing chunk"))).length;
report.entries = totalEntries;
report.errorCount = errors;
report.warningCount = warnings;
fs.writeFileSync(reportPath, `${JSON.stringify(report, null, 2)}\n`);

if (errors) {
  console.error(`Humanizer chunk validation failed. entries=${totalEntries} errors=${errors} warnings=${warnings} missingChunks=${missingChunks}`);
  console.error(reportPath);
  process.exit(1);
}

if (process.argv.includes("--strict") && warnings) {
  console.error(`Humanizer strict validation failed. entries=${totalEntries} errors=0 warnings=${warnings} missingChunks=${missingChunks}`);
  console.error(reportPath);
  process.exit(1);
}

console.log(`Humanizer chunk validation passed. entries=${totalEntries} warnings=${warnings}`);
console.log(reportPath);
