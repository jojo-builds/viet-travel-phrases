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
  /key word/i,
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

function sqliteList(sql) {
  const value = sqliteValue(sql);
  return value ? value.split("|") : [];
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

  assertEqual(
    sqliteValue("SELECT canonical_page_id FROM page_alias WHERE alias_id = 'viet-polite-hello';"),
    "viet-phrase-polite-1",
    "legacy Xin chào page alias"
  );
  assertEqual(
    sqliteValue("SELECT canonical_page_id FROM page_alias WHERE alias_id = 'viet-family-polite-hello';"),
    "viet-phrase-polite-1",
    "family Xin chào page alias"
  );
  assertEqual(
    sqliteValue("SELECT summary FROM phrase_page WHERE id = 'viet-phrase-polite-1';"),
    "Hello (universal greeting)",
    "Xin chào flagship summary"
  );
  assertEqual(
    sqliteList(`
      SELECT group_concat(section_key, '|')
      FROM (
        SELECT section_key
        FROM page_section
        WHERE page_id = 'viet-phrase-polite-1'
        ORDER BY sort_order
      );
    `).join("|"),
    [
      "at-glance",
      "quick-say",
      "breakdown",
      "situational-greetings",
      "local-greetings",
      "common-follow-ups",
      "cultural-note",
      "explore-next",
    ].join("|"),
    "Xin chào flagship section order"
  );

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_page pp
    WHERE NOT EXISTS (
      SELECT 1
      FROM page_section ps
      WHERE ps.page_id = pp.id
        AND ps.section_key = 'breakdown'
    );
  `), "canonical pages without breakdown section");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section ps
    WHERE ps.section_key = 'breakdown'
      AND NOT EXISTS (
        SELECT 1
        FROM page_section_item psi
        WHERE psi.section_id = ps.id
          AND psi.item_kind = 'breakdown_token'
      );
  `), "empty breakdown sections");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM (
      SELECT pp.id, pp.title, count(bt.id) AS token_count
      FROM phrase_page pp
      JOIN phrase p ON p.id = pp.phrase_id
      JOIN page_section ps ON ps.page_id = pp.id AND ps.section_key = 'breakdown'
      JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'breakdown_token'
      JOIN breakdown_token bt ON bt.id = psi.target_id
      GROUP BY pp.id, pp.title
      HAVING pp.title LIKE '% %'
         AND token_count = 1
    );
  `), "multiword pages with only one breakdown token");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section ps
    JOIN phrase_page pp ON pp.id = ps.page_id
    JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'breakdown_token'
    JOIN breakdown_token bt ON bt.id = psi.target_id
    WHERE ps.section_key = 'breakdown'
      AND psi.sort_order < (
        SELECT max(psi2.sort_order)
        FROM page_section_item psi2
        WHERE psi2.section_id = ps.id
          AND psi2.item_kind = 'breakdown_token'
      )
      AND bt.token_text = pp.title;
  `), "non-final breakdown tokens duplicating the full phrase");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section ps
    JOIN phrase_page pp ON pp.id = ps.page_id
    JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'breakdown_token'
    JOIN breakdown_token bt ON bt.id = psi.target_id
    WHERE ps.section_key = 'breakdown'
      AND psi.sort_order = (
        SELECT max(psi2.sort_order)
        FROM page_section_item psi2
        WHERE psi2.section_id = ps.id
          AND psi2.item_kind = 'breakdown_token'
      )
      AND bt.token_text != pp.title;
  `), "breakdowns whose final token is not the full phrase");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM breakdown_token
    WHERE lower(english_gloss) IN ('key word', 'phrase ending', 'word', 'action', 'place / service', 'question marker')
       OR lower(english_gloss) LIKE '%question marker%';
  `), "internal breakdown labels");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section ps
    JOIN phrase_page pp ON pp.id = ps.page_id
    JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'breakdown_token'
    JOIN breakdown_token bt ON bt.id = psi.target_id
    WHERE ps.section_key = 'breakdown'
      AND psi.sort_order < (
        SELECT max(psi2.sort_order)
        FROM page_section_item psi2
        WHERE psi2.section_id = ps.id
          AND psi2.item_kind = 'breakdown_token'
      )
      AND lower(bt.english_gloss) = lower(pp.english_title);
  `), "non-final breakdown glosses that repeat the whole English title");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_relation r
    WHERE r.source_kind != 'phrase_page'
       OR r.target_kind != 'phrase_page'
       OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.source_id)
       OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.target_id);
  `), "broken phrase-page relation edges");

  assertEqual(sqliteValue(`
    SELECT count(*)
    FROM sqlite_master
    WHERE type = 'index'
      AND name = 'idx_phrase_relation_source';
  `), "1", "relation source lookup index");

  const relationLookupPlan = sqliteValue(`
    EXPLAIN QUERY PLAN
    SELECT r.id
    FROM phrase_relation r
    JOIN phrase_page pp ON pp.id = r.target_id
    WHERE r.source_kind = 'phrase_page'
      AND r.target_kind = 'phrase_page'
      AND r.source_id = 'viet-phrase-polite-1'
    ORDER BY r.sort_order, r.relation_type, pp.title
    LIMIT 8;
  `);
  if (!relationLookupPlan.includes("idx_phrase_relation_source")) {
    throw new Error(`Relation lookup does not use idx_phrase_relation_source:\n${relationLookupPlan}`);
  }

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
  assertEqual(report.validation.badBreakdownGlossCount, 0, "report bad breakdown gloss count");
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
