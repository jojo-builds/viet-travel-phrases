#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const reportPath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet-report.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const phraseSourcePath = path.join(repoRoot, "content-draft", "viet", "phrase-source.csv");
const relationSamplePath = path.join(repoRoot, "content-draft", "viet", "relation-sample-v1.json");
const websitePreviewPath = path.join(repoRoot, "content-draft", "viet", "website-preview.json");
const expoVietPackPath = path.join(repoRoot, "app", "family", "packs", "viet.generated.ts");
const expoVietPresentationPath = path.join(repoRoot, "app", "family", "presentation", "viet.ts");
const expoVietPremiumPath = path.join(repoRoot, "app", "family", "presentation", "vietPremium.ts");
const listingPagesRoot = path.join(repoRoot, "content-draft", "viet", "listing-pages");
const sitePreviewDataRoot = path.join(repoRoot, "site", "data", "phrase-previews");
const sitePublicPreviewDataRoot = path.join(repoRoot, "site", "public", "data", "phrase-previews");
const siteRoot = path.join(repoRoot, "site");

const bannedPatterns = [
  /Watch out/i,
  /repair phrase/i,
  /Understanding Repair/i,
  /question marker/i,
  /warning-callout/i,
  /watch-out/i,
];

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

function sqliteValue(sql) {
  return run("sqlite3", [databasePath, sql]);
}

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function relative(filePath) {
  return path.relative(repoRoot, filePath).replaceAll(path.sep, "/");
}

function walkJSONFiles(dir) {
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...walkJSONFiles(fullPath));
    } else if (entry.isFile() && entry.name.endsWith(".json")) {
      files.push(fullPath);
    }
  }
  return files;
}

function walkFiles(dir, predicate) {
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...walkFiles(fullPath, predicate));
    } else if (entry.isFile() && predicate(fullPath)) {
      files.push(fullPath);
    }
  }
  return files;
}

function scanBannedFiles(files) {
  const matches = [];
  for (const filePath of files) {
    const text = fs.readFileSync(filePath, "utf8");
    for (const pattern of bannedPatterns) {
      if (pattern.test(text)) {
        matches.push({ path: relative(filePath), pattern: String(pattern) });
      }
    }
  }
  return matches;
}

function assertEqual(actual, expected, message) {
  if (actual !== expected) {
    throw new Error(`${message}: expected ${expected}, got ${actual}`);
  }
}

function assertZero(actual, message) {
  assertEqual(Number(actual), 0, message);
}

function main() {
  if (!fs.existsSync(databasePath)) {
    throw new Error(`Missing SQLite fixture: ${relative(databasePath)}`);
  }
  if (!fs.existsSync(reportPath)) {
    throw new Error(`Missing SQLite report: ${relative(reportPath)}`);
  }

  const report = readJSON(reportPath);
  const counts = JSON.parse(sqliteValue(`SELECT json_object(
    'scenarios', (SELECT count(*) FROM scenario),
    'clusters', (SELECT count(*) FROM phrase_cluster),
    'sourcePhrases', (SELECT count(*) FROM phrase),
    'canonicalPages', (SELECT count(*) FROM phrase_page),
    'resolvedPhrases', (
      SELECT count(*)
      FROM phrase p
      JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
    ),
    'searchDocuments', (SELECT count(*) FROM search_document),
    'relations', (SELECT count(*) FROM phrase_relation),
    'missingAudioAuditRows', (SELECT count(*) FROM missing_audio_audit)
  );`));

  assertEqual(sqliteValue("PRAGMA integrity_check;"), "ok", "SQLite integrity check");
  assertEqual(sqliteValue("PRAGMA foreign_key_check;"), "", "SQLite foreign key check");
  assertEqual(counts.scenarios, 18, "scenario count");
  assertEqual(counts.clusters, 900, "cluster count");
  assertEqual(counts.sourcePhrases, 919, "source phrase row count");
  assertEqual(counts.canonicalPages, 911, "canonical phrase-page count");
  assertEqual(counts.resolvedPhrases, 919, "phrases resolving to canonical pages");
  assertEqual(counts.searchDocuments, 919, "search document count");
  assertZero(counts.missingAudioAuditRows, "missing audio audit rows");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM (
      SELECT p.normalized_target_text
      FROM phrase_page pp
      JOIN phrase p ON p.id = pp.phrase_id
      GROUP BY p.normalized_target_text
      HAVING count(*) > 1
    );
  `), "duplicate canonical phrase-page groups");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_page pp
    WHERE NOT EXISTS (SELECT 1 FROM page_section ps WHERE ps.page_id = pp.id);
  `), "sectionless canonical phrase pages");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_relation r
    WHERE r.source_kind != 'phrase_page'
       OR r.target_kind != 'phrase_page'
       OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.source_id)
       OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.target_id);
  `), "broken phrase-page relation edges");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM search_document sd
    WHERE sd.target_kind = 'phrase_page'
      AND NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = sd.target_id);
  `), "search documents with missing page targets");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM audio_usage au
    JOIN audio_asset aa ON aa.id = au.audio_asset_id
    WHERE au.normalized_expected_text != aa.normalized_spoken_text;
  `), "audio usage text mismatches");

  const bannedScanFiles = [
    catalogPath,
    authoredPagesPath,
    phraseSourcePath,
    relationSamplePath,
    websitePreviewPath,
    expoVietPackPath,
    expoVietPresentationPath,
    expoVietPremiumPath,
    ...walkJSONFiles(listingPagesRoot),
    ...walkJSONFiles(sitePreviewDataRoot),
    ...walkJSONFiles(sitePublicPreviewDataRoot),
    ...walkFiles(siteRoot, (filePath) => filePath.endsWith(".html")),
  ];
  const bannedFileMatches = scanBannedFiles(bannedScanFiles);
  if (bannedFileMatches.length > 0) {
    throw new Error(`Banned user-facing wording found:\n${JSON.stringify(bannedFileMatches, null, 2)}`);
  }

  assertEqual(report.countParity.phrases.actual, 919, "report phrase count");
  assertEqual(report.countParity.canonicalPhrasePages.actual, 911, "report canonical page count");
  assertEqual(report.canonicalIdentity.phrasesResolvedToCanonicalPages, 919, "report resolved phrase count");
  assertEqual(report.canonicalIdentity.unresolvedDuplicateNormalizedTargetTextGroups.length, 0, "unresolved duplicate phrase groups");
  assertEqual(report.validation.duplicateCanonicalPageGroupCount, 0, "report duplicate page groups");
  assertEqual(report.validation.sectionlessCanonicalPageCount, 0, "report sectionless pages");
  assertEqual(report.validation.brokenRelationCount, 0, "report broken relation count");
  assertEqual(report.validation.searchDocumentsWithMissingPageTargets, 0, "report search target count");
  assertEqual(report.validation.audioUsageMismatchCount, 0, "report audio mismatch count");
  assertEqual(report.validation.bannedUserFacingMatchCount, 0, "report banned wording count");

  console.log(JSON.stringify({
    ok: true,
    counts,
    duplicateNormalizedTargetTextGroupsResolved: report.canonicalIdentity.duplicateNormalizedTargetTextGroupCount,
    bannedFileMatches: 0,
    relationCount: counts.relations,
  }, null, 2));
}

main();
