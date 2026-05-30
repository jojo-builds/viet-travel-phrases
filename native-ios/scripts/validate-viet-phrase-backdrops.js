#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const auditPath = path.join(repoRoot, "docs", "task-results", "listing-backdrop-audit-2026-05-29", "listing-backdrop-audit.json");
const backdropPath = path.join(repoRoot, "content-draft", "viet", "phrase-backdrops-v1.json");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const assetsRoot = path.join(nativeRoot, "Resources", "Assets.xcassets");

function readJSON(filePath) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`Missing required file: ${path.relative(repoRoot, filePath)}`);
  }
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function run(command, args) {
  const result = spawnSync(command, args, {
    cwd: repoRoot,
    encoding: "utf8",
  });

  if (result.status !== 0) {
    throw new Error(`${command} ${args.join(" ")} failed\nSTDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}`);
  }

  return result.stdout.trim();
}

function sqliteJSON(sql) {
  return JSON.parse(run("sqlite3", ["-json", databasePath, sql]) || "[]");
}

function sqlValue(value) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function sorted(values) {
  return [...values].sort((a, b) => String(a).localeCompare(String(b)));
}

function assetExists(assetName) {
  return fs.existsSync(path.join(assetsRoot, `${assetName}.imageset`, "Contents.json"));
}

function main() {
  const audit = readJSON(auditPath);
  const backdrops = readJSON(backdropPath);
  const needsRows = (audit.listingRows ?? [])
    .filter((row) => row.auditStatus === "Needs Backdrop" || row.needsBackdropWork === "Yes");
  const expectedPageIDs = sorted(new Set(needsRows.map((row) => row.canonicalPageID)));
  const expectedAssets = new Map(needsRows.map((row) => [row.canonicalPageID, row.recommendedAsset]));
  const placementRows = backdrops.placements ?? [];
  const placementPageIDs = sorted(new Set(placementRows.map((row) => row.pageID)));

  assert(expectedPageIDs.length === 952, `expected 952 needs-backdrop rows, found ${expectedPageIDs.length}`);
  assert(backdrops.version === 1, "phrase backdrop catalog version must be 1");
  assert(placementRows.length === 952, `expected 952 backdrop placements, found ${placementRows.length}`);
  assert(
    JSON.stringify(placementPageIDs) === JSON.stringify(expectedPageIDs),
    "backdrop placements must exactly match the audit needs-backdrop canonicalPageID set"
  );

  const missingAssets = [];
  for (const row of placementRows) {
    assert(row.pageID, "backdrop placement is missing pageID");
    assert(row.assetName === expectedAssets.get(row.pageID), `${row.pageID} asset must match audit recommendedAsset`);
    assert(row.source === "category-fallback", `${row.pageID} should use category-fallback in v1`);
    assert(row.assetName?.startsWith("HeroCategory"), `${row.pageID} must use a HeroCategory asset`);
    if (!assetExists(row.assetName)) {
      missingAssets.push(`${row.pageID}:${row.assetName}`);
    }
  }
  assert(missingAssets.length === 0, `missing backdrop assets: ${missingAssets.slice(0, 12).join(", ")}`);

  assert(fs.existsSync(databasePath), "generated Viet SQLite fixture is missing");
  const sqliteRows = sqliteJSON(`
    SELECT id, hero_image_name
    FROM phrase_page
    WHERE id IN (${expectedPageIDs.map(sqlValue).join(", ")})
    ORDER BY id;
  `);
  assert(sqliteRows.length === expectedPageIDs.length, `SQLite contains ${sqliteRows.length} of ${expectedPageIDs.length} expected pages`);

  const sqliteByID = new Map(sqliteRows.map((row) => [row.id, row.hero_image_name]));
  const mismatchedSQLite = [];
  for (const pageID of expectedPageIDs) {
    const expectedAsset = expectedAssets.get(pageID);
    if (sqliteByID.get(pageID) !== expectedAsset) {
      mismatchedSQLite.push(`${pageID}:${sqliteByID.get(pageID) ?? "NULL"}!=${expectedAsset}`);
    }
  }
  assert(mismatchedSQLite.length === 0, `SQLite hero_image_name mismatches: ${mismatchedSQLite.slice(0, 12).join(", ")}`);

  const counts = {};
  for (const row of placementRows) {
    counts[row.assetName] = (counts[row.assetName] ?? 0) + 1;
  }

  console.log(JSON.stringify({
    ok: true,
    needsBackdropRows: expectedPageIDs.length,
    placements: placementRows.length,
    assets: Object.fromEntries(Object.entries(counts).sort((a, b) => a[0].localeCompare(b[0]))),
  }, null, 2));
}

main();
