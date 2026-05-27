#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..", "..", "..");
const sourceDir = path.join(repoRoot, "content-draft", "viet", "city-library", "handwritten-copy");
const chunksDir = path.join(__dirname, "chunks");
const cities = ["danang", "hanoi", "hcmc", "hoian", "hue"];
const ranges = [
  { label: "001_025", start: 0, end: 25 },
  { label: "026_050", start: 25, end: 50 },
  { label: "051_075", start: 50, end: 75 },
  { label: "076_100", start: 75, end: 100 },
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function main() {
  let count = 0;
  for (const cityID of cities) {
    const source = readJSON(path.join(sourceDir, `${cityID}.json`));
    const entries = source.entries ?? [];
    if (entries.length !== 100) {
      throw new Error(`${cityID} expected 100 entries, found ${entries.length}`);
    }
    for (const range of ranges) {
      const filePath = path.join(chunksDir, `${cityID}_${range.label}_humanized.json`);
      const existing = readJSON(filePath);
      const next = {
        ...existing,
        cityID,
        range: range.label.replace("_", "-"),
        entries: entries.slice(range.start, range.end),
      };
      fs.writeFileSync(filePath, `${JSON.stringify(next, null, 2)}\n`);
      count += next.entries.length;
    }
  }
  console.log(`Synced ${count} handwritten entries into humanizer chunks.`);
}

main();
