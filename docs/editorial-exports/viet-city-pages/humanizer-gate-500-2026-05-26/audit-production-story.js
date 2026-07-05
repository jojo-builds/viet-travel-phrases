#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

if (!process.argv.includes("--legacy-humanizer")) {
  console.log([
    "LEGACY_REVOKED_NOT_CURRENT_GATE",
    "The 2026-05-26 humanizer story audit is historical only.",
    "Use the first-class v2.2 source, voice audit, rendered screenshots, and four final gates for current city/place approval.",
    "Pass --legacy-humanizer only to inspect the revoked historical run.",
  ].join("\n"));
  process.exit(0);
}

const repoRoot = path.resolve(__dirname, "..", "..", "..", "..");
const sourceDir = path.join(repoRoot, "content-draft", "viet", "city-library", "handwritten-copy");
const outputDir = path.join(__dirname, "reports");
const cities = ["danang", "hanoi", "hcmc", "hoian", "hue"];

const storySignals = [
  "ancient", "apartment", "assembly", "basket", "beach", "bridge", "broth", "cafe", "café",
  "cathedral", "ceremony", "cham", "champa", "citadel", "civic", "coffee", "colonial",
  "commuter", "community", "coast", "coastal", "counter", "courtyard", "craft", "district",
  "dynasty", "everyday", "family", "ferry", "fish sauce", "fishing", "food memory",
  "french", "garden", "gate", "geography", "hands", "heritage", "historic", "history",
  "imperial", "island", "lantern", "market", "meal pattern", "merchant", "monk", "morning",
  "mountain", "neighborhood", "noodle", "old road", "pagoda", "palace", "river", "ritual",
  "roll-and-dip", "royal", "seafood", "scarcity-era", "shrine", "sidewalk", "snack",
  "station", "street", "table ritual", "tailor", "temple", "textile", "tomb", "traditional stage",
  "vietnamese stage form", "trading port", "train", "village", "war memory", "wartime", "workshop",
];

const citySignals = {
  danang: ["han river", "bạch đằng", "bach dang", "my khe", "son tra", "marble", "hai van", "ba na", "nam o", "resort-city", "central vietnam", "central coast", "nuoc mam", "nước mắm", "beach", "bridge", "seafood"],
  hanoi: ["old quarter", "hoan kiem", "west lake", "ba dinh", "french quarter", "red river", "long bien", "northern vietnam", "low stools", "contemporary hanoi", "hanoi dining", "literature", "author", "hải phòng", "hai phong", "home-cooking", "vegetarian", "sticky rice", "lake", "pho", "bun cha", "chả cá", "bia hơi", "train street"],
  hcmc: ["saigon", "district 1", "nguyen hue", "dong khoi", "ben thanh", "thao dien", "tan son nhat", "broken rice", "cơm tấm", "fresh spring rolls", "contemporary dinner", "apartment", "colonial", "market", "river"],
  hoian: ["ancient town", "lantern", "hoai river", "thu bon", "central-coast", "central coast", "rice paper", "rice-field", "water-coconut", "custom-clothing", "tailor", "assembly hall", "trading port", "basket boat", "cam nam", "an bang"],
  hue: ["imperial", "royal", "perfume river", "citadel", "tomb", "garden house", "pagoda", "court", "tam giang", "banana leaf", "small-plate", "steamed-snack", "tea-table", "crisp yellow pancake", "central hue", "bun bo", "palace"],
};

const genericOnlySignals = [
  "easy stop",
  "quick stop",
  "short stop",
  "change of pace",
  "reset",
  "pause",
  "break",
  "simple",
  "good for",
  "worth",
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim();
}

function lower(value) {
  return normalize(value).toLowerCase();
}

function visibleText(entry) {
  return [
    entry.summary,
    entry.context,
    entry.tip,
    entry.rationale,
    ...(entry.sections ?? []).flatMap((section) => [section.title, section.body]),
  ].filter(Boolean).join(" ");
}

function hasAny(text, signals) {
  return signals.some((signal) => text.includes(signal));
}

function storySignalsFor(cityID, text) {
  const hits = new Set();
  for (const signal of storySignals) {
    if (text.includes(signal)) hits.add(signal);
  }
  for (const signal of citySignals[cityID] ?? []) {
    if (text.includes(signal)) hits.add(signal);
  }
  return [...hits].sort();
}

function main() {
  fs.mkdirSync(outputDir, { recursive: true });
  const issues = [];
  let entryCount = 0;

  for (const cityID of cities) {
    const data = readJSON(path.join(sourceDir, `${cityID}.json`));
    for (const entry of data.entries ?? []) {
      entryCount += 1;
      const text = lower(visibleText(entry));
      const hits = storySignalsFor(cityID, text);
      const genericHits = genericOnlySignals.filter((signal) => text.includes(signal));
      if (hits.length < 2) {
        issues.push({
          cityID,
          pageID: entry.pageID,
          severity: "review",
          message: `thin story signal (${hits.length} hit${hits.length === 1 ? "" : "s"}: ${hits.join(", ") || "none"})`,
        });
      } else if (genericHits.length >= 4 && hits.length < 2) {
        issues.push({
          cityID,
          pageID: entry.pageID,
          severity: "review",
          message: `story may be buried under generic utility words (${genericHits.join(", ")})`,
        });
      }
    }
  }

  const byCity = {};
  for (const issue of issues) byCity[issue.cityID] = (byCity[issue.cityID] ?? 0) + 1;
  const report = { generatedAt: new Date().toISOString(), entryCount, reviewCount: issues.length, byCity, issues };
  fs.writeFileSync(path.join(outputDir, "production_story_audit.json"), `${JSON.stringify(report, null, 2)}\n`);

  console.log(`Production story audit: entries=${entryCount} review=${issues.length}`);
  console.log(JSON.stringify(byCity));
  for (const issue of issues.slice(0, 80)) {
    console.log(`REVIEW ${issue.pageID}: ${issue.message}`);
  }
}

main();
