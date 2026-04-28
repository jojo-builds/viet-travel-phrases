#!/usr/bin/env node

const assert = require("assert");
const crypto = require("crypto");
const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");
const test = require("node:test");

const root = path.resolve(__dirname, "..");
const generatorPath = path.join(__dirname, "generate-viet-sqlite-fixture.js");
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
    'aliases', (SELECT count(*) FROM page_alias),
    'sections', (SELECT count(*) FROM page_section),
    'sectionItems', (SELECT count(*) FROM page_section_item),
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
    },
    {
      scenarios: 18,
      clusters: 900,
      phrases: 919,
      pages: 919,
    }
  );
  assert.ok(counts.aliases >= 163, "authored pages should be represented by canonical aliases");
  assert.ok(counts.sections >= 1304, "authored page sections should be preserved");
  assert.ok(counts.sectionItems >= 2083, "authored phrase and breakdown items should be preserved");
  assert.ok(counts.audioAssets > 0, "audio manifest rows should be represented");
  assert.ok(counts.audioUsages > 0, "audio usages should be represented");
  assert.strictEqual(counts.missingAudioAuditRows, 0, "current renderable rows should resolve audio");

  const report = JSON.parse(fs.readFileSync(reportPath, "utf8"));
  assert.deepStrictEqual(report.countParity, {
    scenarios: { expected: 18, actual: 18, ok: true },
    clusters: { expected: 900, actual: 900, ok: true },
    phrases: { expected: 919, actual: 919, ok: true },
    authoredPagesOrAliases: { expected: 163, actual: 163, ok: true },
  });
  assert.deepStrictEqual(report.bundlePackaging, {
    xcodeProjectPath: "native-ios/project.yml",
    resourcePath: "native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite",
    isIncludedInXcodeResources: false,
    status: "generated-not-bundled",
    requiredNextStep: "Update native-ios/project.yml resource rules before opening this fixture with Bundle.main.",
  });
});
