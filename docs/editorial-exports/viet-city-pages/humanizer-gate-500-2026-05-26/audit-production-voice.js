#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

if (!process.argv.includes("--legacy-humanizer")) {
  console.log([
    "LEGACY_REVOKED_NOT_CURRENT_GATE",
    "The 2026-05-26 humanizer voice audit is historical only.",
    "Use native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js plus the Editorial Voice Gate for current city/place v2.2 approval.",
    "Pass --legacy-humanizer only to inspect the revoked historical run.",
  ].join("\n"));
  process.exit(0);
}

const repoRoot = path.resolve(__dirname, "..", "..", "..", "..");
const sourceDir = path.join(repoRoot, "content-draft", "viet", "city-library", "handwritten-copy");
const outputDir = path.join(__dirname, "reports");
const cities = ["danang", "hanoi", "hcmc", "hoian", "hue"];

const allowedUsefulPhrasesTitle = "Useful Phrases";
const commandHeading = /^(Use|Keep|Choose|Ask|Confirm|Check|Start|Let|Leave|Make|Take|Save|Treat|Think|Pair|Go|Stop)\b/i;
const weirdVisibleFragments = [
  "counterweight",
  "first word",
  "pick one thread",
  "one clear thread",
  "half-read",
  "beats completion",
  "destination reference line",
  "reference line",
  "useful because",
  "useful before",
  "useful after",
  "it is useful",
  "this is useful",
  "the useful",
  "stable role",
  "stable reason",
  "durable reason",
  "safe frame",
  "as a frame",
  "framed as",
  "reads as",
  "reads best",
  "works as",
  "works when",
  "works best",
  "works because",
  "makes sense with",
  "makes more sense",
  "the move is",
  "the job is",
  "the page",
  "this page",
  "this listing",
  "this entry",
  "the entry",
  "the row",
  "schema",
  "database",
  "render",
  "check_catalog",
  "do_not_render",
  "not_run",
  "production-ready",
  "source copy",
  "visible copy",
  "freshness",
  "same-week",
  "current details",
  "needs checking",
  "thin-source",
  "ai",
  "slop",
  "helps travelers",
  "the traveler",
  "travelers",
  "map pin",
  "content role",
  "place name noun",
  "local name noun",
  "play the name",
  "hear the name",
  "shown here",
  "name to keep",
  "keep the name",
];

const softCliches = [
  "change of pace",
  "box to tick",
  "low-pressure",
  "grounded",
  "reset",
  "pause",
  "breathe",
  "slows down",
  "softens",
  "lands",
  "rhythm",
  "ordinary",
  "layered",
  "texture",
  "context",
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFC")
    .replace(/\s+/g, " ")
    .trim();
}

function lower(value) {
  return normalize(value).toLowerCase();
}

function words(value) {
  const text = normalize(value);
  return text ? text.split(/\s+/).length : 0;
}

function fieldValues(entry) {
  const values = [
    ["summary", entry.summary],
    ["context", entry.context],
    ["tip", entry.tip],
    ["rationale", entry.rationale],
  ];
  for (const section of entry.sections ?? []) {
    values.push([`${section.id}.title`, section.title]);
    values.push([`${section.id}.body`, section.body]);
  }
  return values;
}

function visibleFields(entry) {
  return fieldValues(entry).filter(([, value]) => normalize(value));
}

function containsFragment(text, fragment) {
  const escaped = fragment.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  return new RegExp(`\\b${escaped}\\b`, "i").test(text);
}

function inspectEntry(cityID, entry) {
  const issues = [];
  const sections = entry.sections ?? [];
  const sectionIDs = new Set(sections.map((section) => section.id));
  for (const required of ["at-glance", "quick-say", "place-brief", "use-it-with", "good-to-know"]) {
    if (!sectionIDs.has(required)) issues.push({ severity: "hard", field: "sections", message: `missing section ${required}` });
  }

  const seenBodies = new Map();
  for (const [field, raw] of visibleFields(entry)) {
    const value = normalize(raw);
    const valueLower = lower(value);

    if (field.endsWith(".title")) {
      const isUsefulPhrases = value === allowedUsefulPhrasesTitle;
      if (!isUsefulPhrases && commandHeading.test(value)) {
        issues.push({ severity: "hard", field, message: `command-like heading: ${value}` });
      }
      if (words(value) > 7) {
        issues.push({ severity: "soft", field, message: `long heading (${words(value)} words): ${value}` });
      }
    }

    if (field.endsWith(".body") || ["summary", "context", "tip", "rationale"].includes(field)) {
      if (words(value) > 45) {
        issues.push({ severity: "hard", field, message: `over 45 words (${words(value)})` });
      }
      const key = valueLower.replace(/[^a-z0-9]+/g, " ").trim();
      if (key) {
        const previous = seenBodies.get(key);
        if (previous) {
          issues.push({ severity: "hard", field, message: `duplicates ${previous}` });
        } else {
          seenBodies.set(key, field);
        }
      }
    }

    for (const fragment of weirdVisibleFragments) {
      if (containsFragment(valueLower, fragment)) {
        if (value === allowedUsefulPhrasesTitle && fragment === "useful") continue;
        issues.push({ severity: "hard", field, message: `visible process/AI fragment: "${fragment}"` });
      }
    }
  }

  const quickSay = sections.find((section) => section.id === "quick-say");
  if (quickSay?.title === allowedUsefulPhrasesTitle) {
    const phraseIDs = Array.isArray(quickSay.phraseIDs) ? quickSay.phraseIDs : [];
    if (phraseIDs.length < 2) {
      issues.push({ severity: "hard", field: "quick-say.phraseIDs", message: "Useful Phrases needs at least two phrase IDs" });
    }
    if (normalize(quickSay.body)) {
      issues.push({ severity: "hard", field: "quick-say.body", message: "Useful Phrases must not render prose body" });
    }
  }

  const clicheHits = new Map();
  for (const [, value] of visibleFields(entry)) {
    const valueLower = lower(value);
    for (const fragment of softCliches) {
      if (containsFragment(valueLower, fragment)) {
        clicheHits.set(fragment, (clicheHits.get(fragment) ?? 0) + 1);
      }
    }
  }
  const repeatedSoft = [...clicheHits.entries()].filter(([, count]) => count >= 3);
  for (const [fragment, count] of repeatedSoft) {
    issues.push({ severity: "soft", field: "entry", message: `repeated soft word "${fragment}" appears ${count} times` });
  }

  return issues.map((issue) => ({ cityID, pageID: entry.pageID, ...issue }));
}

function main() {
  fs.mkdirSync(outputDir, { recursive: true });
  const issues = [];
  const titleCounts = new Map();
  let entryCount = 0;

  for (const cityID of cities) {
    const filePath = path.join(sourceDir, `${cityID}.json`);
    const data = readJSON(filePath);
    for (const entry of data.entries ?? []) {
      entryCount += 1;
      issues.push(...inspectEntry(cityID, entry));
      for (const section of entry.sections ?? []) {
        if (section.title && section.title !== allowedUsefulPhrasesTitle) {
          const key = lower(section.title);
          const item = titleCounts.get(key) ?? { title: section.title, pages: [] };
          item.pages.push(entry.pageID);
          titleCounts.set(key, item);
        }
      }
    }
  }

  for (const item of titleCounts.values()) {
    if (item.pages.length >= 4) {
      issues.push({
        cityID: "all",
        pageID: item.pages.slice(0, 8).join(", "),
        severity: "soft",
        field: "section.title",
        message: `repeated heading "${item.title}" appears ${item.pages.length} times`,
      });
    }
  }

  const hard = issues.filter((issue) => issue.severity === "hard");
  const soft = issues.filter((issue) => issue.severity === "soft");
  const report = { generatedAt: new Date().toISOString(), entryCount, hardCount: hard.length, softCount: soft.length, issues };
  fs.writeFileSync(path.join(outputDir, "production_voice_audit.json"), `${JSON.stringify(report, null, 2)}\n`);

  console.log(`Production voice audit: entries=${entryCount} hard=${hard.length} soft=${soft.length}`);
  for (const issue of issues.slice(0, 80)) {
    console.log(`${issue.severity.toUpperCase()} ${issue.pageID} ${issue.field}: ${issue.message}`);
  }
  if (hard.length > 0) process.exitCode = 1;
}

main();
