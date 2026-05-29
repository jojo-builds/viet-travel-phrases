#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const defaultSourceDir = path.join(repoRoot, "content-draft", "viet", "city-library", "app-detail-v2-2");
const cityIDs = ["danang", "hanoi", "hcmc", "hoian", "hue"];

const crutchTerms = [
  { key: "quiet", pattern: /\bquiet(?:er|ly)?\b/gi, maxEntries: 45 },
  { key: "shape", pattern: /\bshape[sd]?\b/gi, maxEntries: 40 },
  { key: "read", pattern: /\bread(?:s|ing)?\b/gi, maxEntries: 45 },
  { key: "frame", pattern: /\bframe[sd]?\b/gi, maxEntries: 32 },
  { key: "pause", pattern: /\bpause[sd]?\b/gi, maxEntries: 28 },
  { key: "belongs", pattern: /\bbelong(?:s|ed|ing)?\b/gi, maxEntries: 30 },
  { key: "stop", pattern: /\bstops?\b/gi, maxEntries: 220 },
  { key: "first", pattern: /\bfirst\b/gi, maxEntries: 175 },
  { key: "enough", pattern: /\benough\b/gi, maxEntries: 90 },
  { key: "fit/fits", pattern: /\bfit(?:s|ting)?\b/gi, maxEntries: 85 },
  { key: "feel/feels/feeling", pattern: /\bfeel(?:s|ing)?\b/gi, maxEntries: 170 },
  { key: "better", pattern: /\bbetter\b/gi, maxEntries: 65 },
  { key: "another", pattern: /\banother\b/gi, maxEntries: 75 },
  { key: "wider", pattern: /\bwider\b/gi, maxEntries: 20 },
  { key: "layer", pattern: /\blayer(?:s|ed|ing)?\b/gi, maxEntries: 0 },
  { key: "anchor", pattern: /\banchor(?:s|ed|ing)?\b/gi, maxEntries: 0 },
];

const formulaPatterns = [
  { key: "good as", pattern: /\bgood as\b/gi, maxEntries: 0 },
  { key: "top/best claim", pattern: /\b(?:top|best|#1|number one|must-visit|must visit)\b/gi, maxEntries: 0 },
  { key: "surface", pattern: /\bsurface\b/gi, maxEntries: 0 },
  { key: "fits naturally", pattern: /\bfits naturally\b/gi, maxEntries: 0 },
  { key: "fits a day", pattern: /\bfits (?:a|the) day\b/gi, maxEntries: 0 },
  { key: "it fits", pattern: /\bit fits\b/gi, maxEntries: 0 },
  { key: "street fits", pattern: /\bstreet fits\b/gi, maxEntries: 0 },
  { key: "works as", pattern: /\bworks as\b/gi, maxEntries: 0 },
  { key: "works well", pattern: /\bworks well\b/gi, maxEntries: 0 },
  { key: "works better", pattern: /\bworks better\b/gi, maxEntries: 0 },
  { key: "lands better", pattern: /\blands better\b/gi, maxEntries: 0 },
  { key: "better when", pattern: /\bbetter when\b/gi, maxEntries: 0 },
  { key: "good when", pattern: /\bgood when\b/gi, maxEntries: 0 },
  { key: "belongs when", pattern: /\bbelongs when\b/gi, maxEntries: 0 },
  { key: "the strongest", pattern: /\bthe strongest\b/gi, maxEntries: 0 },
  { key: "strongest", pattern: /\bstrongest\b/gi, maxEntries: 0 },
  { key: "stronger", pattern: /\bstronger\b/gi, maxEntries: 0 },
  { key: "stillness", pattern: /\bstillness\b/gi, maxEntries: 0 },
  { key: "the durable", pattern: /\bthe durable\b/gi, maxEntries: 0 },
  { key: "not a", pattern: /\bnot a\s/gi, maxEntries: 0 },
  { key: "this is not", pattern: /\bthis is not\b/gi, maxEntries: 0 },
  { key: "it is not", pattern: /\bit is not\b/gi, maxEntries: 0 },
  { key: "not the whole", pattern: /\bnot the whole\b/gi, maxEntries: 0 },
  { key: "not the only", pattern: /\bnot the only\b/gi, maxEntries: 0 },
  { key: "not only", pattern: /\bnot only\b/gi, maxEntries: 0 },
  { key: "not the reason", pattern: /\bnot the reason\b/gi, maxEntries: 0 },
  { key: "not the point", pattern: /\bnot the point\b/gi, maxEntries: 0 },
  { key: "not the moment", pattern: /\bnot the moment\b/gi, maxEntries: 0 },
  { key: "stable memory", pattern: /\bstable memory\b/gi, maxEntries: 0 },
  { key: "durable draw", pattern: /\bdurable draw\b/gi, maxEntries: 0 },
  { key: "durable handoff", pattern: /\bdurable handoff\b/gi, maxEntries: 0 },
  { key: "good when the point", pattern: /\bgood when the point\b/gi, maxEntries: 0 },
  { key: "more than another", pattern: /\bmore than another\b/gi, maxEntries: 0 },
  { key: "a wider stop", pattern: /\ba wider\b[\s\S]{0,40}\bstop\b/gi, maxEntries: 0 },
  { key: "are enough", pattern: /\bare enough\b/gi, maxEntries: 0 },
  { key: "better beside", pattern: /\bbetter beside\b/gi, maxEntries: 0 },
  { key: "works for", pattern: /\bworks for\b/gi, maxEntries: 0 },
  { key: "template use opening", pattern: /^use\s+/gim, maxEntries: 0 },
  { key: "duplicate heading word", pattern: /\b([A-Za-zÀ-ỹ]+),\s+\1\b/gi, maxEntries: 0 },
];

function parseArgs(argv) {
  const args = {
    sourceDir: defaultSourceDir,
    failOnThresholds: true,
  };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--source-dir") {
      const value = argv[index + 1];
      if (!value) throw new Error("--source-dir requires a path");
      args.sourceDir = path.resolve(value);
      index += 1;
    } else if (arg === "--report-only") {
      args.failOnThresholds = false;
    } else if (arg === "--help" || arg === "-h") {
      args.help = true;
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }
  return args;
}

function visibleText(entry) {
  return [
    entry.intro?.heading,
    entry.intro?.body,
    ...(entry.sections ?? []).flatMap((section) => [section.heading, section.body]),
  ].filter(Boolean).join("\n");
}

function visibleFields(entry) {
  return [
    ["intro.heading", entry.intro?.heading],
    ["intro.body", entry.intro?.body],
    ...(entry.sections ?? []).flatMap((section, index) => [
      [`sections.${index}.heading`, section.heading],
      [`sections.${index}.body`, section.body],
    ]),
  ].filter(([, value]) => typeof value === "string" && value.length > 0);
}

function countPattern(pattern, text) {
  return (text.match(pattern) ?? []).length;
}

function countMetric(entries, metric) {
  let entryCount = 0;
  let useCount = 0;
  const examples = [];
  for (const entry of entries) {
    const text = visibleText(entry);
    const count = countPattern(metric.pattern, text);
    if (count > 0) {
      entryCount += 1;
      useCount += count;
      if (examples.length < 8) {
        examples.push(entry.pageID);
      }
    }
  }
  return {
    key: metric.key,
    entryCount,
    useCount,
    maxEntries: metric.maxEntries,
    examples,
    pass: entryCount <= metric.maxEntries,
  };
}

function collectCasingFailures(entries) {
  const failures = [];
  for (const entry of entries) {
    for (const [field, value] of visibleFields(entry)) {
      if (/^[a-z]/.test(value) || /\. [a-z]/.test(value)) {
        failures.push({
          pageID: entry.pageID,
          field,
          value,
        });
        if (failures.length >= 20) {
          return failures;
        }
      }
    }
  }
  return failures;
}

function loadEntries(sourceDir) {
  const entries = [];
  for (const cityID of cityIDs) {
    const filePath = path.join(sourceDir, `${cityID}.json`);
    const city = JSON.parse(fs.readFileSync(filePath, "utf8"));
    entries.push(...(city.entries ?? []));
  }
  return entries;
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log("Usage: node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js [--report-only] [--source-dir <dir>]");
    return;
  }

  const entries = loadEntries(args.sourceDir);
  const crutches = crutchTerms.map((metric) => countMetric(entries, metric));
  const formulas = formulaPatterns.map((metric) => countMetric(entries, metric));
  const casingFailures = collectCasingFailures(entries);
  const failures = [...crutches, ...formulas].filter((metric) => !metric.pass);

  const report = {
    source: path.relative(repoRoot, args.sourceDir),
    entries: entries.length,
    crutches,
    formulas,
    casingFailures,
    failures,
  };

  console.log(JSON.stringify(report, null, 2));
  if (args.failOnThresholds && (failures.length > 0 || casingFailures.length > 0)) {
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
