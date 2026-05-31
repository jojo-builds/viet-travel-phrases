#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const defaultSourceDir = path.join(repoRoot, "content-draft", "viet", "city-library", "app-detail-v2-2");
const cityIDs = ["danang", "hanoi", "hcmc", "hoian", "hue"];

const recognitionPattern = /\b(?:MICHELIN|Michelin|Bib Gourmand|Green Star|One MICHELIN Star|MICHELIN Star|Selected)\b/;
const sourcePattern = /\b(?:Official MICHELIN|official MICHELIN|MICHELIN venue|MICHELIN Vietnam 2025|MICHELIN Guide support|2025 MICHELIN|MICHELIN Selected|Bib Gourmand|Green Star|One MICHELIN Star|MICHELIN Star)\b/i;
const explicitNoClaimPattern = /\b(?:No MICHELIN claim is used|outside the current MICHELIN Vietnam city coverage)\b/i;

function parseArgs(argv) {
  const args = {
    sourceDir: defaultSourceDir,
    reportOnly: false,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--source-dir") {
      const value = argv[index + 1];
      if (!value) throw new Error("--source-dir requires a path");
      args.sourceDir = path.resolve(value);
      index += 1;
    } else if (arg === "--report-only") {
      args.reportOnly = true;
    } else if (arg === "--help" || arg === "-h") {
      args.help = true;
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }

  return args;
}

function usage() {
  return [
    "Usage: node native-ios/scripts/audit-viet-city-michelin-coverage.js [--report-only] [--source-dir <dir>]",
    "",
    `Default source: ${path.relative(repoRoot, defaultSourceDir)}`,
    "Fails when a source-backed MICHELIN restaurant lacks visible recognition or an unsupported restaurant makes its own visible MICHELIN claim.",
  ].join("\n");
}

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function loadEntries(sourceDir) {
  const entries = [];
  for (const cityID of cityIDs) {
    const filePath = path.join(sourceDir, `${cityID}.json`);
    const city = readJSON(filePath);
    for (const entry of city.entries ?? []) {
      entries.push(entry);
    }
  }
  return entries;
}

function noteText(entry) {
  return [
    ...(entry.qa?.notes ?? []),
    entry.score?.reason,
    ...(entry.sourceNotes ?? []),
  ].filter(Boolean).join("\n");
}

function isSourceSupported(entry) {
  const notes = noteText(entry);
  return sourcePattern.test(notes) && !explicitNoClaimPattern.test(notes);
}

function ownVisibleText(entry) {
  return [
    entry.travelerMoment,
    entry.storySpine,
    entry.intro?.heading,
    entry.intro?.body,
    ...(entry.sections ?? []).flatMap((section) => [section.heading, section.body]),
  ].filter(Boolean).join("\n");
}

function relatedRecognitionCandidates(entry) {
  return [
    ...(entry.mentionedHereCandidates ?? []),
    ...(entry.relatedPlaceCandidates ?? []),
  ].filter((candidate) => {
    const text = [candidate.label, candidate.displaySubtitle].filter(Boolean).join("\n");
    return candidate.status === "render" && recognitionPattern.test(text);
  });
}

function compactEntry(entry) {
  return {
    city: entry.city,
    pageID: entry.pageID,
    displayName: entry.displayName,
    englishName: entry.englishName,
  };
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log(usage());
    return;
  }

  const entries = loadEntries(args.sourceDir);
  const byCatalogId = new Map(entries.map((entry) => [entry.id, entry]));
  const restaurants = entries.filter((entry) => entry.category === "Restaurant");
  const sourceSupported = restaurants.filter(isSourceSupported);
  const missingOwnRecognition = sourceSupported
    .filter((entry) => !recognitionPattern.test(ownVisibleText(entry)))
    .map(compactEntry);

  const unsupportedOwnRecognition = restaurants
    .filter((entry) => !isSourceSupported(entry) && recognitionPattern.test(ownVisibleText(entry)))
    .map(compactEntry);

  const relatedRecognitionProblems = [];
  let relatedRecognitionCount = 0;
  for (const entry of restaurants) {
    for (const candidate of relatedRecognitionCandidates(entry)) {
      relatedRecognitionCount += 1;
      const target = byCatalogId.get(candidate.catalogId);
      if (!target || !isSourceSupported(target)) {
        relatedRecognitionProblems.push({
          sourcePageID: entry.pageID,
          sourceDisplayName: entry.displayName,
          candidateCatalogId: candidate.catalogId,
          candidateLabel: candidate.label,
          candidateDisplaySubtitle: candidate.displaySubtitle,
          problem: target ? "target is not MICHELIN-source-supported" : "target missing",
        });
      }
    }
  }

  const report = {
    source: path.relative(repoRoot, args.sourceDir),
    restaurants: restaurants.length,
    sourceSupportedRestaurants: sourceSupported.length,
    sourceSupportedRestaurantIDs: sourceSupported.map((entry) => entry.pageID).sort(),
    relatedRecognitionCandidates: relatedRecognitionCount,
    missingOwnRecognition,
    unsupportedOwnRecognition,
    relatedRecognitionProblems,
    pass: missingOwnRecognition.length === 0 &&
      unsupportedOwnRecognition.length === 0 &&
      relatedRecognitionProblems.length === 0,
  };

  console.log(JSON.stringify(report, null, 2));
  if (!args.reportOnly && !report.pass) {
    process.exitCode = 1;
  }
}

if (require.main === module) {
  try {
    main();
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}
