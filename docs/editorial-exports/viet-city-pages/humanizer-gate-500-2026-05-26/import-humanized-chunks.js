#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const repoRoot = path.resolve(__dirname, "..", "..", "..", "..");
const gateRoot = __dirname;
const chunksDir = path.join(gateRoot, "chunks");
const reportsDir = path.join(gateRoot, "reports");
const finalReviewPath = path.join(reportsDir, "humanizer_gate_500_final_review_2026-05-26.md");
const independentReviewPath = path.join(reportsDir, "independent_integrity_review_2026-05-26.md");
const sourceDir = path.join(
  repoRoot,
  "content-draft",
  "viet",
  "city-library",
  "handwritten-copy",
);

const cities = ["danang", "hanoi", "hcmc", "hoian", "hue"];
const ranges = ["001_025", "026_050", "051_075", "076_100"].map((fileRange, index) => {
  const starts = [0, 25, 50, 75];
  const ends = [25, 50, 75, 100];
  const labels = ["001-025", "026-050", "051-075", "076-100"];
  return { fileRange, label: labels[index], start: starts[index], end: ends[index] };
});

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

const validation = spawnSync(process.execPath, [path.join(gateRoot, "validate-humanizer-chunks.js"), "--strict"], {
  cwd: repoRoot,
  stdio: "inherit",
});
if (validation.status !== 0) {
  throw new Error("Humanizer chunks must pass strict validation before import.");
}

for (const reviewPath of [finalReviewPath, independentReviewPath]) {
  if (!fs.existsSync(reviewPath)) {
    throw new Error(`Missing required review receipt before import: ${reviewPath}`);
  }
  const text = fs.readFileSync(reviewPath, "utf8");
  if (!/^Status:\s+PASS\b/m.test(text)) {
    throw new Error(`Required review receipt is not PASS: ${reviewPath}`);
  }
}

const imported = [];
for (const cityID of cities) {
  const sourcePath = path.join(sourceDir, `${cityID}.json`);
  const file = readJSON(sourcePath);
  const nextEntries = file.entries.slice();

  for (const range of ranges) {
    const chunkPath = path.join(chunksDir, `${cityID}_${range.fileRange}_humanized.json`);
    if (!fs.existsSync(chunkPath)) throw new Error(`Missing chunk ${chunkPath}`);
    const chunk = readJSON(chunkPath);
    if (chunk.cityID !== cityID || chunk.range !== range.label) {
      throw new Error(`${path.basename(chunkPath)} has wrong cityID/range`);
    }
    if (!Array.isArray(chunk.entries) || chunk.entries.length !== range.end - range.start) {
      throw new Error(`${path.basename(chunkPath)} has wrong entry count`);
    }

    for (let i = 0; i < chunk.entries.length; i += 1) {
      const absoluteIndex = range.start + i;
      const expectedPageID = file.entries[absoluteIndex].pageID;
      const entry = chunk.entries[i];
      if (entry.pageID !== expectedPageID) {
        throw new Error(`${path.basename(chunkPath)} entry ${i} pageID mismatch: expected ${expectedPageID}, got ${entry.pageID}`);
      }
      nextEntries[absoluteIndex] = entry;
      imported.push(entry.pageID);
    }
  }

  file.entries = nextEntries;
  file.authoringStandard = "speaklocal-city-library-humanized-v2.2-500-2026-05-26";
  writeJSON(sourcePath, file);
}

const receiptPath = path.join(reportsDir, "humanizer_import_receipt.json");
writeJSON(receiptPath, {
  importedAt: new Date().toISOString(),
  importedCount: imported.length,
  sourceFiles: cities.map((cityID) => path.relative(repoRoot, path.join(sourceDir, `${cityID}.json`))),
  pageIDs: imported,
});

console.log(`Imported ${imported.length} humanized entries.`);
console.log(receiptPath);
