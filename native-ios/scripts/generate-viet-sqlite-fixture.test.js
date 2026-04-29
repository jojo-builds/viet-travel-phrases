#!/usr/bin/env node

const assert = require("assert");
const crypto = require("crypto");
const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");
const test = require("node:test");

const root = path.resolve(__dirname, "..");
const generatorPath = path.join(__dirname, "generate-viet-sqlite-fixture.js");
const validatorPath = path.join(__dirname, "validate-viet-sqlite-fixture.js");
const schemaPath = path.join(__dirname, "sqlite", "001_initial.sql");
const databasePath = path.join(root, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const reportPath = path.join(root, "Resources", "LanguagePacks", "viet", "speaklocal-viet-report.json");

function run(command, args, options = {}) {
  const result = spawnSync(command, args, {
    cwd: path.resolve(root, ".."),
    encoding: "utf8",
    ...options,
  });
  assert.strictEqual(
    result.status,
    0,
    `${command} ${args.join(" ")} failed\nSTDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}`
  );
  return result.stdout.trim();
}

function sha256(filePath) {
  return crypto.createHash("sha256").update(fs.readFileSync(filePath)).digest("hex");
}

function sqliteValue(sql) {
  return run("sqlite3", [databasePath, sql]);
}

test("generates deterministic Viet SQLite fixture with required counts and integrity", () => {
  run(process.execPath, [generatorPath]);
  assert.ok(fs.existsSync(schemaPath), "initial SQLite schema migration should exist");
  assert.ok(fs.existsSync(databasePath), "SQLite fixture should be generated");
  assert.ok(fs.existsSync(reportPath), "validation report should be generated");

  const firstDatabaseHash = sha256(databasePath);
  const firstReportHash = sha256(reportPath);
  run(process.execPath, [generatorPath]);

  assert.strictEqual(sha256(databasePath), firstDatabaseHash, "database bytes should be repeatable");
  assert.strictEqual(sha256(reportPath), firstReportHash, "report bytes should be repeatable");
  assert.strictEqual(sqliteValue("PRAGMA integrity_check;"), "ok");

  const counts = JSON.parse(sqliteValue(`SELECT json_object(
    'scenarios', (SELECT count(*) FROM scenario),
    'clusters', (SELECT count(*) FROM phrase_cluster),
    'phrases', (SELECT count(*) FROM phrase),
    'pages', (SELECT count(*) FROM phrase_page),
    'canonicalPhrases', (SELECT count(DISTINCT canonical_phrase_id) FROM phrase),
    'phrasesResolvedToPages', (
      SELECT count(*)
      FROM phrase p
      JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
    ),
    'aliases', (SELECT count(*) FROM page_alias),
    'sections', (SELECT count(*) FROM page_section),
    'breakdownSections', (SELECT count(*) FROM page_section WHERE section_key = 'breakdown'),
    'sectionItems', (SELECT count(*) FROM page_section_item),
    'searchDocuments', (SELECT count(*) FROM search_document),
    'relations', (SELECT count(*) FROM phrase_relation),
    'audioAssets', (SELECT count(*) FROM audio_asset),
    'audioUsages', (SELECT count(*) FROM audio_usage),
    'missingAudioAuditRows', (SELECT count(*) FROM missing_audio_audit)
  );`));

  assert.deepStrictEqual(
    {
      scenarios: counts.scenarios,
      clusters: counts.clusters,
      phrases: counts.phrases,
      pages: counts.pages,
      canonicalPhrases: counts.canonicalPhrases,
      phrasesResolvedToPages: counts.phrasesResolvedToPages,
    },
    {
      scenarios: 18,
      clusters: 900,
      phrases: 919,
      pages: 911,
      canonicalPhrases: 911,
      phrasesResolvedToPages: 919,
    }
  );
  assert.ok(counts.aliases >= 163, "authored pages should be represented by canonical aliases");
  assert.ok(counts.sections >= 6000, "authored and baseline page sections should be preserved");
  assert.strictEqual(counts.breakdownSections, 911, "every canonical page should have a breakdown section");
  assert.ok(counts.sectionItems >= 10000, "authored, baseline, phrase, and breakdown items should be preserved");
  assert.strictEqual(counts.searchDocuments, 919, "every source phrase row should produce a search document");
  assert.ok(counts.relations > 0, "page graph relation edges should be generated");
  assert.ok(counts.audioAssets > 0, "audio manifest rows should be represented");
  assert.ok(counts.audioUsages > 0, "audio usages should be represented");
  assert.strictEqual(counts.missingAudioAuditRows, 0, "current renderable rows should resolve audio");

  const duplicateCanonicalPages = sqliteValue(`
    SELECT count(*)
    FROM (
      SELECT p.normalized_target_text
      FROM phrase_page pp
      JOIN phrase p ON p.id = pp.phrase_id
      GROUP BY p.normalized_target_text
      HAVING count(*) > 1
    );
  `);
  assert.strictEqual(duplicateCanonicalPages, "0", "exact normalized Vietnamese text should not create duplicate canonical pages");

  const sectionlessPages = sqliteValue(`
    SELECT count(*)
    FROM phrase_page pp
    WHERE NOT EXISTS (
      SELECT 1 FROM page_section ps WHERE ps.page_id = pp.id
    );
  `);
  assert.strictEqual(sectionlessPages, "0", "every canonical phrase page should have renderable sections");

  assert.strictEqual(
    sqliteValue("SELECT canonical_page_id FROM page_alias WHERE alias_id = 'viet-polite-hello';"),
    "viet-phrase-polite-1",
    "legacy hello page should alias to canonical SQLite page"
  );
  assert.strictEqual(
    sqliteValue("SELECT summary FROM phrase_page WHERE id = 'viet-phrase-polite-1';"),
    "Hello (universal greeting)",
    "SQLite hello page should carry flagship summary"
  );

  const brokenRelations = sqliteValue(`
    SELECT count(*)
    FROM phrase_relation r
    WHERE r.source_kind != 'phrase_page'
       OR r.target_kind != 'phrase_page'
       OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.source_id)
       OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.target_id);
  `);
  assert.strictEqual(brokenRelations, "0", "phrase graph relation edges should resolve to canonical pages");

  const unresolvedSearchTargets = sqliteValue(`
    SELECT count(*)
    FROM search_document sd
    WHERE sd.target_kind = 'phrase_page'
      AND NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = sd.target_id);
  `);
  assert.strictEqual(unresolvedSearchTargets, "0", "search documents should resolve to canonical pages");

  const audioMismatches = sqliteValue(`
    SELECT count(*)
    FROM audio_usage au
    JOIN audio_asset aa ON aa.id = au.audio_asset_id
    WHERE au.normalized_expected_text != aa.normalized_spoken_text;
  `);
  assert.strictEqual(audioMismatches, "0", "visible audio usages should match normalized manifest text");

  const report = JSON.parse(fs.readFileSync(reportPath, "utf8"));
  assert.deepStrictEqual(report.countParity, {
    scenarios: { expected: 18, actual: 18, ok: true },
    clusters: { expected: 900, actual: 900, ok: true },
    phrases: { expected: 919, actual: 919, ok: true },
    canonicalPhrasePages: { expected: 911, actual: 911, ok: true },
    authoredPagesOrAliases: { expected: 164, actual: 164, ok: true },
  });
  assert.deepStrictEqual(report.canonicalIdentity.unresolvedDuplicateNormalizedTargetTextGroups, []);
  assert.strictEqual(report.canonicalIdentity.canonicalPageCount, 911);
  assert.strictEqual(report.canonicalIdentity.phrasesResolvedToCanonicalPages, 919);
  assert.strictEqual(report.validation.brokenRelationCount, 0);
  assert.strictEqual(report.validation.searchDocumentsWithMissingPageTargets, 0);
  assert.strictEqual(report.validation.sectionlessCanonicalPageCount, 0);
  run(process.execPath, [validatorPath]);
  assert.deepStrictEqual(report.bundlePackaging, {
    xcodeProjectPath: "native-ios/project.yml",
    resourcePath: "native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite",
    isIncludedInXcodeResources: true,
    status: "bundle-ready",
    requiredNextStep: "",
  });
});
