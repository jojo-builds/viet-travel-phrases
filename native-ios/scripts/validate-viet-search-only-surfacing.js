#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const auditPath = path.join(repoRoot, "docs", "task-results", "listing-backdrop-audit-2026-05-29", "listing-backdrop-audit.json");
const placementPath = path.join(repoRoot, "content-draft", "viet", "search-only-surfacing-v1.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const swiftPath = path.join(nativeRoot, "App", "Models", "VietSearchOnlyPhraseSurfacing.swift");

function readJSON(filePath) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`Missing required file: ${path.relative(repoRoot, filePath)}`);
  }
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function run(command, args, options = {}) {
  const result = spawnSync(command, args, {
    cwd: repoRoot,
    encoding: "utf8",
    ...options,
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

function main() {
  const audit = readJSON(auditPath);
  const placement = readJSON(placementPath);
  const catalog = readJSON(catalogPath);

  const keepRows = (audit.searchAuditRows ?? [])
    .filter((row) => row.searchAuditDecisionID === "keep-search-only");
  const expectedPageIDs = sorted(new Set(keepRows.map((row) => row.canonicalPageID)));
  const expectedPhraseIDs = new Map(keepRows.map((row) => [row.canonicalPageID, row.runtimePhraseID]));
  const expectedEnglish = new Map(keepRows.map((row) => [row.canonicalPageID, row.englishTitle]));
  const placementRows = placement.placements ?? [];
  const placementPageIDs = sorted(new Set(placementRows.map((row) => row.canonicalPageID)));

  assert(expectedPageIDs.length === 315, `expected the audit to expose 315 keep-search-only rows, found ${expectedPageIDs.length}`);
  assert(placement.version === 1, "search-only surfacing placement version must be 1");
  assert(placementRows.length === 315, `expected 315 placement rows, found ${placementRows.length}`);
  assert(
    JSON.stringify(placementPageIDs) === JSON.stringify(expectedPageIDs),
    "placement rows must exactly match the audit keep-search-only canonicalPageID set"
  );

  const catalogPhraseIDs = new Set(catalog.phrases.map((phrase) => phrase.id));
  const subcategories = new Map((placement.browseSubcategories ?? []).map((subcategory) => [subcategory.id, subcategory]));
  assert(subcategories.size > 0, "placement must define browse subcategories");

  for (const row of placementRows) {
    assert(row.phraseID === expectedPhraseIDs.get(row.canonicalPageID), `${row.canonicalPageID} must use the audit runtimePhraseID`);
    assert(catalogPhraseIDs.has(row.phraseID), `${row.canonicalPageID} phraseID ${row.phraseID} is missing from the phrase catalog`);
    assert(row.englishTitle === expectedEnglish.get(row.canonicalPageID), `${row.canonicalPageID} englishTitle drifted from the audit`);
    assert(row.clusterID, `${row.canonicalPageID} is missing clusterID`);
    assert(row.browsePlacement?.subcategoryID, `${row.canonicalPageID} is missing a browse placement`);
    assert(subcategories.has(row.browsePlacement.subcategoryID), `${row.canonicalPageID} references missing browse subcategory ${row.browsePlacement.subcategoryID}`);
    assert(Array.isArray(row.supportPlacements) && row.supportPlacements.length > 0, `${row.canonicalPageID} needs at least one supporting phrase placement`);
  }

  assert(fs.existsSync(swiftPath), "generated Swift surfacing file is missing");
  const swift = fs.readFileSync(swiftPath, "utf8");
  const missingSwiftPageIDs = placementRows
    .filter((row) => row.browsePlacement)
    .map((row) => row.canonicalPageID)
    .filter((pageID) => !swift.includes(`"${pageID}"`));
  assert(missingSwiftPageIDs.length === 0, `generated Swift surfacing file is missing page IDs: ${missingSwiftPageIDs.slice(0, 12).join(", ")}`);

  assert(fs.existsSync(databasePath), "generated Viet SQLite fixture is missing");
  const pageIDSQL = expectedPageIDs.map(sqlValue).join(", ");
  const sqliteTargets = sqliteJSON(`
    SELECT pp.id
    FROM phrase_page pp
    WHERE pp.id IN (${pageIDSQL})
    ORDER BY pp.id;
  `).map((row) => row.id);
  assert(
    JSON.stringify(sqliteTargets) === JSON.stringify(expectedPageIDs),
    "SQLite phrase_page rows must contain every surfaced keep-search-only canonical page"
  );

  const relationRows = sqliteJSON(`
    SELECT source_id, target_id
    FROM phrase_relation
    WHERE source_path = 'content-draft/viet/search-only-surfacing-v1.json'
    ORDER BY source_id, target_id;
  `);
  const relationKeys = new Set(relationRows.map((row) => `${row.source_id}\u0000${row.target_id}`));

  const sectionItemRows = sqliteJSON(`
    SELECT ps.page_id AS source_id, pp.id AS target_id
    FROM page_section ps
    JOIN page_section_item psi ON psi.section_id = ps.id
    JOIN phrase p ON p.id = psi.target_id
    JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
    WHERE ps.source_path = 'content-draft/viet/search-only-surfacing-v1.json'
    ORDER BY ps.page_id, pp.id;
  `);
  const sectionItemKeys = new Set(sectionItemRows.map((row) => `${row.source_id}\u0000${row.target_id}`));

  const missingRelationKeys = [];
  const missingSectionItemKeys = [];
  for (const row of placementRows) {
    for (const support of row.supportPlacements) {
      const key = `${support.sourcePageID}\u0000${row.canonicalPageID}`;
      if (!relationKeys.has(key)) missingRelationKeys.push(key);
      if (!sectionItemKeys.has(key)) missingSectionItemKeys.push(key);
    }
  }
  assert(missingRelationKeys.length === 0, `SQLite phrase_relation is missing support links: ${missingRelationKeys.slice(0, 12).join(", ")}`);
  assert(missingSectionItemKeys.length === 0, `SQLite page sections are missing support rows: ${missingSectionItemKeys.slice(0, 12).join(", ")}`);

  console.log(JSON.stringify({
    ok: true,
    keepSearchOnlyRows: expectedPageIDs.length,
    browseSubcategories: subcategories.size,
    generatedRelations: relationRows.length,
    generatedSectionItems: sectionItemRows.length,
  }, null, 2));
}

main();
