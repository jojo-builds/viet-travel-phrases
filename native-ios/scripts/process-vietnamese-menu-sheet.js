#!/usr/bin/env node

const { execFileSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const batchID = process.argv[2];
const generatedImagePath = process.argv[3];

if (!batchID || !generatedImagePath) {
  console.error("Usage: process-vietnamese-menu-sheet.js <menu-sheet-XXX> <generated-image-path>");
  process.exit(2);
}

const batchesPath = path.join(repoRoot, "native-ios", "artifacts", "vietnamese-menu", "menu-image-batches.json");
const batchPayload = JSON.parse(fs.readFileSync(batchesPath, "utf8"));
const batch = batchPayload.batches.find((candidate) => candidate.id === batchID);

if (!batch) {
  console.error(`Unknown batch ${batchID}`);
  process.exit(1);
}

const sourcePath = path.join(repoRoot, batch.sourcePath);
fs.mkdirSync(path.dirname(sourcePath), { recursive: true });
fs.copyFileSync(generatedImagePath, sourcePath);

execFileSync(
  path.join(repoRoot, "native-ios", "scripts", "crop-vietnamese-menu-contact-sheet.swift"),
  [
    "--sheet",
    sourcePath,
    "--items",
    batch.itemIDs.join(","),
    "--columns",
    String(batch.columns),
    "--rows",
    String(batch.rows),
    "--asset-root",
    path.join(repoRoot, "native-ios", "Resources", "Assets.xcassets"),
    "--target-size",
    "720",
    "--inset",
    batch.columns === 3 ? "8" : "5",
  ],
  { stdio: "inherit" }
);

console.log(`Processed ${batchID} from ${generatedImagePath}`);
