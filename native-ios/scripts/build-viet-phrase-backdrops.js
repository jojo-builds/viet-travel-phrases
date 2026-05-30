#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const auditPath = path.join(repoRoot, "docs", "task-results", "listing-backdrop-audit-2026-05-29", "listing-backdrop-audit.json");
const outputPath = path.join(repoRoot, "content-draft", "viet", "phrase-backdrops-v1.json");
const assetsRoot = path.join(nativeRoot, "Resources", "Assets.xcassets");

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function assetExists(assetName) {
  return fs.existsSync(path.join(assetsRoot, `${assetName}.imageset`, "Contents.json"));
}

function sortPlacements(rows) {
  return [...rows].sort((a, b) => {
    const aKey = [a.assetName, a.pageID].join("\u0000");
    const bKey = [b.assetName, b.pageID].join("\u0000");
    return aKey.localeCompare(bKey);
  });
}

function buildPlacements(audit) {
  const needsRows = (audit.listingRows ?? [])
    .filter((row) => row.auditStatus === "Needs Backdrop" || row.needsBackdropWork === "Yes");
  const seenPageIDs = new Set();
  const placements = [];

  for (const row of needsRows) {
    if (seenPageIDs.has(row.canonicalPageID)) {
      throw new Error(`Duplicate needs-backdrop page ID: ${row.canonicalPageID}`);
    }
    seenPageIDs.add(row.canonicalPageID);

    if (!row.recommendedAsset) {
      throw new Error(`Missing recommendedAsset for ${row.canonicalPageID}`);
    }
    if (!row.recommendedAsset.startsWith("HeroCategory")) {
      throw new Error(`Expected HeroCategory recommendedAsset for ${row.canonicalPageID}, found ${row.recommendedAsset}`);
    }
    if (!assetExists(row.recommendedAsset)) {
      throw new Error(`Missing asset catalog image for ${row.canonicalPageID}: ${row.recommendedAsset}`);
    }

    placements.push({
      pageID: row.canonicalPageID,
      phraseID: row.runtimePhraseID,
      englishTitle: row.englishTitle,
      assetName: row.recommendedAsset,
      source: "category-fallback",
      priority: row.priority,
      reachabilityStatus: row.reachabilityStatus,
      rolloutBucket: row.rolloutBucket,
      imageTheme: row.imageTheme,
    });
  }

  if (placements.length !== 952) {
    throw new Error(`Expected 952 needs-backdrop placements, found ${placements.length}`);
  }

  return sortPlacements(placements);
}

function main() {
  const audit = readJSON(auditPath);
  const placements = buildPlacements(audit);
  const counts = new Map();
  for (const placement of placements) {
    counts.set(placement.assetName, (counts.get(placement.assetName) ?? 0) + 1);
  }

  const payload = {
    version: 1,
    generatedAt: "source:listing-backdrop-audit-2026-05-29",
    sourceAudit: "docs/task-results/listing-backdrop-audit-2026-05-29/listing-backdrop-audit.json",
    intent: "Give all 952 human-reachable Viet phrase/listing pages a production category fallback image so direct, Search, Saved, Practice, and Browse entry use the shared photo-backdrop sheet interaction.",
    strategy: "Phase 1 uses existing HeroCategory assets only; semantic mini-pools can replace selected assetName values in a later version without changing runtime wiring.",
    placements,
  };

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, `${JSON.stringify(payload, null, 2)}\n`);

  console.log(JSON.stringify({
    ok: true,
    placements: placements.length,
    assets: Object.fromEntries([...counts.entries()].sort((a, b) => a[0].localeCompare(b[0]))),
  }, null, 2));
}

main();
