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

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

const byCity = new Map();
for (const range of ranges) {
  const chunkPath = path.join(chunksDir, range.file);
  if (!fs.existsSync(chunkPath)) {
    throw new Error(`Missing chunk ${chunkPath}`);
  }
  const chunk = readJSON(chunkPath);
  if (chunk.cityID !== range.cityID || chunk.range !== range.label) {
    throw new Error(`${range.file} has wrong cityID/range`);
  }
  if (!byCity.has(range.cityID)) byCity.set(range.cityID, []);
  byCity.get(range.cityID).push({ ...range, chunk });
}

const imported = [];
for (const [cityID, cityRanges] of byCity.entries()) {
  const sourcePath = path.join(sourceDir, `${cityID}.json`);
  const file = readJSON(sourcePath);
  const nextEntries = file.entries.slice();

  for (const range of cityRanges) {
    for (let i = 0; i < range.chunk.entries.length; i += 1) {
      const absoluteIndex = range.start + i;
      const expectedPageID = file.entries[absoluteIndex].pageID;
      const entry = range.chunk.entries[i];
      if (entry.pageID !== expectedPageID) {
        throw new Error(`${range.file} entry ${i} pageID mismatch: expected ${expectedPageID}, got ${entry.pageID}`);
      }
      nextEntries[absoluteIndex] = entry;
      imported.push(entry.pageID);
    }
  }

  file.entries = nextEntries;
  file.authoringStandard = "speaklocal-city-library-humanized-v2.2-2026-05-26";
  writeJSON(sourcePath, file);
}

const receiptPath = path.join(gateRoot, "reports", "humanizer_import_receipt.json");
writeJSON(receiptPath, {
  importedAt: new Date().toISOString(),
  importedCount: imported.length,
  sourceFiles: [...byCity.keys()].map((cityID) => path.relative(repoRoot, path.join(sourceDir, `${cityID}.json`))),
  pageIDs: imported,
});

console.log(`Imported ${imported.length} humanized entries.`);
console.log(receiptPath);
