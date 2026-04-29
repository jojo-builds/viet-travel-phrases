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
const fullListingPagesRoot = path.join(repoRoot, "content-draft", "viet", "full-listing-pages");
const sitePreviewDataRoot = path.join(repoRoot, "site", "data", "phrase-previews");
const sitePublicPreviewDataRoot = path.join(repoRoot, "site", "public", "data", "phrase-previews");
const siteRoot = path.join(repoRoot, "site");
const appUserFacingSourcePaths = [
  path.join(nativeRoot, "App", "Models", "AuthoredVietListingPages.swift"),
  path.join(nativeRoot, "App", "Models", "PhrasePage.swift"),
  path.join(nativeRoot, "App", "Views", "AppShellView.swift"),
  path.join(nativeRoot, "App", "Views", "PhraseDetailView.swift"),
  path.join(nativeRoot, "App", "Views", "PhraseListingView.swift"),
  path.join(nativeRoot, "App", "Views", "SearchPageView.swift"),
];

const bannedPatterns = [
  /Watch out/i,
  /repair phrase/i,
  /Understanding Repair/i,
  /\bDifferent ways\b/i,
  /question marker/i,
  /key word/i,
  /warning-callout/i,
  /watch-out/i,
];

const relationshipWordVietnamese = [
  "Chào anh",
  "Chào chị",
  "Chào em",
  "Chào ông",
  "Chào bà",
  "Chào chú",
  "Chào cô",
];
const relationshipWordListSQL = relationshipWordVietnamese.join("|").replace(/'/g, "''");

const requiredLegacyNativePageAliases = [
  ["viet-polite-hello", "viet-phrase-polite-1"],
  ["viet-family-polite-hello", "viet-phrase-polite-1"],
  ["viet-hello-anh", "viet-phrase-hello-chao-anh"],
  ["viet-hello-chi", "viet-phrase-hello-chao-chi"],
  ["viet-hello-em", "viet-phrase-hello-chao-em"],
  ["viet-hello-ong", "viet-phrase-hello-chao-ong"],
  ["viet-hello-ba", "viet-phrase-hello-chao-ba"],
  ["viet-hello-chu", "viet-phrase-hello-chao-chu"],
  ["viet-hello-co", "viet-phrase-hello-chao-co"],
  ["viet-respectful-hello", "viet-phrase-hello-da-chao-anh-chi"],
  ["viet-phone-hello", "viet-phrase-hello-alo"],
  ["viet-where-going", "viet-phrase-smalltalk-di-dau-day"],
  ["viet-nice-to-meet-you", "viet-phrase-smalltalk-nice-to-meet-you"],
  ["viet-hello-anh-way-respectful", "viet-phrase-acknowledge-da-chao-anh"],
  ["viet-hello-chi-way-respectful", "viet-phrase-acknowledge-da-chao-chi"],
  ["viet-hello-ong-way-respectful", "viet-phrase-acknowledge-da-chao-ong"],
  ["viet-hello-ba-way-respectful", "viet-phrase-acknowledge-da-chao-ba"],
  ["viet-hello-chu-way-respectful", "viet-phrase-acknowledge-da-chao-chu"],
  ["viet-hello-co-way-respectful", "viet-phrase-acknowledge-da-chao-co"],
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

function scanBannedFiles(files, patterns = bannedPatterns) {
  const matches = [];
  for (const filePath of files) {
    const text = fs.readFileSync(filePath, "utf8");
    for (const pattern of patterns) {
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
  assertEqual(counts.clusters, report.countParity.clusters.expected, "cluster count");
  assertEqual(counts.sourcePhrases, report.countParity.phrases.expected, "source phrase row count");
  assertEqual(counts.canonicalPages, report.countParity.canonicalPhrasePages.expected, "canonical phrase-page count");
  assertEqual(counts.resolvedPhrases, report.countParity.phrases.expected, "phrases resolving to canonical pages");
  assertEqual(counts.searchDocuments, report.countParity.phrases.expected, "search document count");
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
    FROM phrase_page pp
    WHERE NOT EXISTS (
      SELECT 1
      FROM page_section ps
      WHERE ps.page_id = pp.id
        AND ps.section_key = 'relationship-words'
    );
  `), "canonical pages without relationship-word shelf");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section ps
    WHERE ps.section_key = 'relationship-words'
      AND (
        (SELECT count(*) FROM page_section_item psi WHERE psi.section_id = ps.id AND psi.item_kind = 'phrase') != ${relationshipWordVietnamese.length}
        OR (
          SELECT group_concat(title_override, '|')
          FROM (
            SELECT psi.title_override
            FROM page_section_item psi
            WHERE psi.section_id = ps.id
              AND psi.item_kind = 'phrase'
            ORDER BY psi.sort_order
          )
        ) != '${relationshipWordListSQL}'
      );
  `), "relationship-word shelves without the full canonical greeting set");

  assertZero(
    sqliteValue("SELECT count(*) FROM page_section_item WHERE item_kind = 'authored_phrase';"),
    "visible authored phrase rows without canonical phrase pages"
  );

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section_item psi
    JOIN page_section ps ON ps.id = psi.section_id
    JOIN phrase p ON p.id = psi.target_id
    LEFT JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
    WHERE psi.item_kind = 'phrase'
      AND psi.note IS NOT NULL
      AND psi.note != ''
      AND psi.note != pp.id;
  `), "phrase section rows whose stored note route is not the target canonical page");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section_item psi
    JOIN phrase p ON p.id = psi.target_id
    WHERE psi.item_kind = 'phrase'
      AND psi.title_override IS NOT NULL
      AND lower(trim(psi.title_override)) != lower(trim(p.target_text));
  `), "visible phrase rows whose text differs from the linked canonical phrase");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    WHERE lower(trim(pp.title)) != lower(trim(p.target_text));
  `), "canonical phrase pages whose title differs from their canonical phrase text");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    WHERE lower(trim(pp.english_title)) != lower(trim(p.english_text));
  `), "canonical phrase pages whose English title differs from their canonical English phrase");

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
  for (const [aliasID, canonicalPageID] of requiredLegacyNativePageAliases) {
    const sqlAliasID = `'${aliasID.replace(/'/g, "''")}'`;
    assertEqual(
      sqliteValue(`SELECT canonical_page_id FROM page_alias WHERE alias_id = ${sqlAliasID};`),
      canonicalPageID,
      `legacy native page alias ${aliasID}`
    );
  }
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
      "relationship-words",
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
    ...walkJSONFiles(fullListingPagesRoot),
    ...walkJSONFiles(sitePreviewDataRoot),
    ...walkJSONFiles(sitePublicPreviewDataRoot),
    ...walkFiles(siteRoot, (filePath) => filePath.endsWith(".html")),
  ];
  const bannedFileMatches = [
    ...scanBannedFiles(bannedScanFiles),
    ...scanBannedFiles(appUserFacingSourcePaths, [/\bDifferent ways\b/i]),
  ];
  if (bannedFileMatches.length > 0) {
    throw new Error(`Banned user-facing wording found:\n${JSON.stringify(bannedFileMatches, null, 2)}`);
  }

  assertEqual(report.countParity.phrases.actual, report.countParity.phrases.expected, "report phrase count");
  assertEqual(report.countParity.canonicalPhrasePages.actual, report.countParity.canonicalPhrasePages.expected, "report canonical page count");
  assertEqual(report.canonicalIdentity.phrasesResolvedToCanonicalPages, report.countParity.phrases.expected, "report resolved phrase count");
  assertEqual(report.canonicalIdentity.unresolvedDuplicateNormalizedTargetTextGroups.length, 0, "unresolved duplicate phrase groups");
  assertEqual(report.validation.duplicateCanonicalPageGroupCount, 0, "report duplicate page groups");
  assertEqual(report.validation.sectionlessCanonicalPageCount, 0, "report sectionless pages");
  assertEqual(report.validation.missingRelationshipWordsSectionCount, 0, "report missing relationship-word shelf count");
  assertEqual(report.validation.badRelationshipWordsSectionCount, 0, "report incomplete relationship-word shelf count");
  assertEqual(report.validation.brokenRelationCount, 0, "report broken relation count");
  assertEqual(report.validation.searchDocumentsWithMissingPageTargets, 0, "report search target count");
  assertEqual(report.validation.pageEnglishTitlePhraseTextMismatchCount, 0, "report page English title mismatch count");
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
