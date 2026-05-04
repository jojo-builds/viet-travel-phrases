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
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const plannedMissingAudioQueuePath = path.join(repoRoot, "docs", "audio-queues", "viet-planned-missing-audio.csv");
const phraseSourcePath = path.join(repoRoot, "content-draft", "viet", "phrase-source.csv");
const relationSamplePath = path.join(repoRoot, "content-draft", "viet", "relation-sample-v1.json");
const websitePreviewPath = path.join(repoRoot, "content-draft", "viet", "website-preview.json");
const expoVietPackPath = path.join(repoRoot, "app", "family", "packs", "viet.generated.ts");
const expoVietPresentationPath = path.join(repoRoot, "app", "family", "presentation", "viet.ts");
const expoVietPremiumPath = path.join(repoRoot, "app", "family", "presentation", "vietPremium.ts");
const tierOnePagesRoot = path.join(repoRoot, "content-draft", "viet", "canonical-pages", "tier-one");
const catalogPromotedPagesRoot = path.join(repoRoot, "content-draft", "viet", "canonical-pages", "catalog-promoted");
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
const baNaJourneyPageID = "viet-phrase-city-danang-place-ba-na-hills";
const dragonBridgeLandmarkPageID = "viet-phrase-city-danang-place-dragon-bridge";

const bannedPatterns = [
  /Watch out/i,
  /repair phrase/i,
  /Understanding Repair/i,
  /\bDifferent ways\b/i,
  /answers the traveler question/i,
  /helps you handle/i,
  /keep the phrase tied to/i,
  /show the thing connected to/i,
  /Show the document, symptom, location, or item connected to the need/i,
  /document, symptom, location, or item connected to the need/i,
  /putting the exact document, symptom, place, or item into the first sentence/i,
  /Keep the related proof, photo, room number, receipt, or map location visible/i,
  /request for the document, a staff handoff, or a clear next action/i,
  /specific document, problem, or place/i,
  /most useful proof, photo, room number, receipt, or map location/i,
  /request to see the detail, a staff handoff, or a clear next step/i,
  /naming what is not working/i,
  /replacement offer, a room visit/i,
  /Show the screen, room item, or broken part/i,
  /You may hear You ask/i,
  /item in your hand/i,
  /listener to catch the point quickly/i,
  /rather than a long explanation/i,
  /let the other person show the next step/i,
  /simple anchor/i,
  /concrete item or problem/i,
  /document, photo, room number, receipt, or screen connected/i,
  /request to see the item, a direction to another desk/i,
  /as a short practical clue/i,
  /booking, ticket, room number, or time on your phone/i,
  /place, object, or screen that gives the phrase context/i,
  /item, menu line, or photo so the person can connect/i,
  /practical thing you need someone to understand first/i,
  /names the practical need first/i,
  /without turning it into a long explanation/i,
  /anchor word/i,
  /what you need the listener to catch/i,
  /works because it/i,
  /specific detail/i,
  /name or place detail/i,
  /soft reassurance/i,
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

const reviewedCompoundPhrasePageIDs = [
  "viet-phrase-acknowledge-co",
  "viet-phrase-acknowledge-duoc",
  "viet-phrase-hello-chao",
  "viet-phrase-hello-chao-ban",
  "viet-phrase-hello-da-chao-anh-chi",
  "viet-phrase-help-1",
  "viet-phrase-polite-3",
  "viet-phrase-polite-5",
  "viet-phrase-repair-4",
  "viet-phrase-repair-english-help",
  "viet-phrase-repair-number-amount",
  "viet-phrase-ves-can-you-show-me-politeness",
  "viet-phrase-v900-dire-navi-can-you-call-this-place-and-ask-for-directions",
  "viet-phrase-v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis",
  "viet-phrase-v900-loca-serv-ever-task-please-print-it-in-black-and-white",
];

const approvedQuickSayShortcutPairs = [
  ["viet-phrase-city-danang-place-ba-na-hills", "viet-phrase-ves-two-tickets-ba-na-hills"],
  ["viet-phrase-city-danang-place-marble-mountains", "viet-phrase-city-danang-ticket-marble-mountains"],
  ["viet-phrase-city-danang-place-son-tra", "viet-phrase-city-danang-go-son-tra"],
  ["viet-phrase-city-hanoi-place-bun-cha-huong-lien", "viet-phrase-ves-order-bun-cha-portion"],
  ["viet-phrase-city-hanoi-place-pho-bat-dan", "viet-phrase-ves-order-pho-bowl"],
  ["viet-phrase-city-hue-place-bun-bo-city", "viet-phrase-ves-order-bun-bo-hue-bowl"],
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

function assertTrue(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function sqlQuote(value) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

function sqliteList(sql) {
  const value = sqliteValue(sql);
  return value ? value.split("|") : [];
}

function csvRowCount(filePath) {
  if (!fs.existsSync(filePath)) return 0;
  return fs.readFileSync(filePath, "utf8")
    .split(/\r?\n/)
    .filter(Boolean)
    .slice(1)
    .length;
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
    'missingAudioAuditRows', (SELECT count(*) FROM missing_audio_audit),
    'releaseBlockingMissingAudioAuditRows', (SELECT count(*) FROM missing_audio_audit WHERE release_blocking = 1),
    'plannedMissingAudioAuditRows', (SELECT count(*) FROM missing_audio_audit WHERE severity = 'planned' AND release_blocking = 0),
    'cities', (SELECT count(*) FROM city),
    'cityPlaces', (SELECT count(*) FROM city_place),
    'cityPhraseTags', (SELECT count(*) FROM phrase_city_tag)
  );`));
  const cityLibrary = fs.existsSync(cityLibraryPath) ? readJSON(cityLibraryPath) : { cities: [], places: [], pages: [] };
  const cityLibraryPages = (cityLibrary.pages ?? []).filter((page) => page.status === "approved");

  assertEqual(sqliteValue("PRAGMA integrity_check;"), "ok", "SQLite integrity check");
  assertEqual(sqliteValue("PRAGMA foreign_key_check;"), "", "SQLite foreign key check");
  assertEqual(counts.scenarios, report.countParity.scenarios.expected, "scenario count");
  assertEqual(counts.clusters, report.countParity.clusters.expected, "cluster count");
  assertEqual(counts.sourcePhrases, report.countParity.phrases.expected, "source phrase row count");
  assertEqual(counts.canonicalPages, report.countParity.canonicalPhrasePages.expected, "canonical phrase-page count");
  assertEqual(counts.resolvedPhrases, report.countParity.phrases.expected, "phrases resolving to canonical pages");
  assertEqual(counts.searchDocuments, report.countParity.phrases.expected, "search document count");
  assertZero(counts.releaseBlockingMissingAudioAuditRows, "release-blocking missing audio audit rows");
  const plannedAudioSourcePhraseCount = Number(sqliteValue("SELECT count(*) FROM phrase WHERE audio_status = 'planned';"));
  const plannedAudioQueueRows = csvRowCount(plannedMissingAudioQueuePath);
  assertTrue(plannedAudioQueueRows > 0, `planned missing-audio queue is empty or missing: ${relative(plannedMissingAudioQueuePath)}`);
  assertEqual(counts.plannedMissingAudioAuditRows, counts.missingAudioAuditRows, "missing audio audit rows should all be planned");
  assertEqual(counts.releaseBlockingMissingAudioAuditRows, 0, "release-blocking missing audio audit rows");
  assertEqual(counts.plannedMissingAudioAuditRows, plannedAudioQueueRows, "planned missing audio queue rows");
  assertTrue(counts.plannedMissingAudioAuditRows <= plannedAudioSourcePhraseCount, "planned missing audio rows must be deduped by normalized expected text");
  assertTrue(plannedAudioSourcePhraseCount >= cityLibraryPages.length, "planned source phrases should include at least the city-library pages");
  assertEqual(counts.cities, (cityLibrary.cities ?? []).length, "city table count");
  assertEqual(counts.cityPlaces, (cityLibrary.places ?? []).length, "city place table count");
  assertEqual(counts.cityPhraseTags, cityLibraryPages.length, "city phrase tag count");
  assertZero(sqliteValue(`
    SELECT count(*)
    FROM city_place
    WHERE COALESCE(place_kind, '') = '';
  `), "city places missing place_kind");
  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_city_tag
    WHERE COALESCE(page_kind, '') = ''
       OR COALESCE(place_kind, '') = '';
  `), "city phrase tags missing page_kind/place_kind");
  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_city_tag
    WHERE page_kind IN ('restaurant', 'dish')
      AND COALESCE(content_role, '') = '';
  `), "restaurant/dish city pages missing content_role");

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
    FROM phrase_page
    WHERE lower(english_title) LIKE '%different ways%'
       OR lower(english_title) LIKE '%with the phrase%'
       OR lower(english_title) LIKE '%notes below%'
       OR lower(english_title) LIKE '%can follow a greeting%'
       OR lower(english_title) LIKE '%movement check%'
       OR lower(english_title) LIKE '%main thing you need%'
       OR lower(english_title) LIKE '%main idea you need%';
  `), "hero English subtitles with internal or explanatory wording");

  const relationshipWordsEligiblePageIDs = report.validation.relationshipWordsEligiblePageIDs ?? [];
  const relationshipWordsEligiblePageIDSQL = relationshipWordsEligiblePageIDs.length > 0
    ? relationshipWordsEligiblePageIDs.map(sqlQuote).join(",")
    : "'__none__'";
  assertTrue(
    relationshipWordsEligiblePageIDs.includes("viet-phrase-polite-1")
      && relationshipWordsEligiblePageIDs.includes("viet-phrase-hello-chao")
      && relationshipWordsEligiblePageIDs.includes("viet-phrase-hello-chao-anh"),
    "relationship-word eligibility missing expected greeting pages"
  );
  assertTrue(
    !relationshipWordsEligiblePageIDs.includes("viet-phrase-smalltalk-1"),
    "relationship-word eligibility should not include Tôi đến từ Mỹ"
  );
  assertTrue(
    !relationshipWordsEligiblePageIDs.includes("viet-family-city-danang-place-ba-na-hills"),
    "relationship-word eligibility should not include Bà Nà Hills place page"
  );

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_page pp
    WHERE pp.id IN (${relationshipWordsEligiblePageIDSQL})
      AND NOT EXISTS (
      SELECT 1
      FROM page_section ps
      WHERE ps.page_id = pp.id
        AND ps.section_key = 'relationship-words'
    );
  `), "eligible canonical pages without relationship-word shelf");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section ps
    WHERE ps.section_key = 'relationship-words'
      AND ps.page_id NOT IN (${relationshipWordsEligiblePageIDSQL});
  `), "ineligible canonical pages with relationship-word shelf");
  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section ps
    JOIN phrase_page pp ON pp.id = ps.page_id
    JOIN phrase_city_tag pct ON pct.phrase_id = pp.phrase_id
    WHERE ps.section_key = 'relationship-words'
      AND pct.page_kind IN ('place', 'restaurant', 'dish', 'city', 'category');
  `), "city/place/restaurant/dish/category pages with relationship-word shelf");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section ps
    WHERE ps.section_key = 'relationship-words'
      AND (
        (SELECT count(*) FROM page_section_item psi WHERE psi.section_id = ps.id AND psi.item_kind = 'phrase') = 0
        OR EXISTS (
          SELECT 1
          FROM page_section_item psi
          WHERE psi.section_id = ps.id
            AND psi.item_kind = 'phrase'
            AND COALESCE(psi.title_override, '') NOT IN (${relationshipWordVietnamese.map(sqlQuote).join(",")})
        )
      );
  `), "relationship-word shelves with non-canonical or empty greeting rows");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_page pp
    JOIN page_section ps ON ps.page_id = pp.id
    JOIN page_section_item psi ON psi.section_id = ps.id
    WHERE ps.section_key IN ('quick-say', 'standard-way')
      AND psi.item_kind = 'phrase'
      AND NOT (
        (psi.note = pp.id AND psi.title_override = pp.title)
        OR (
          pp.id = 'viet-phrase-polite-1'
          AND psi.note = 'viet-phrase-hello-chao'
          AND psi.title_override = 'Chào'
        )
        OR (
          pp.id || '>' || psi.note IN (${approvedQuickSayShortcutPairs.map(([sourceID, targetID]) => sqlQuote(`${sourceID}>${targetID}`)).join(",")})
        )
      );
  `), "Quick Say/Standard Way rows that are neither canonical self rows nor approved beginner shortcuts");

  assertEqual(Number(sqliteValue(`
    SELECT count(*)
    FROM phrase_page pp
    JOIN page_section ps ON ps.page_id = pp.id
    JOIN page_section_item psi ON psi.section_id = ps.id
    WHERE pp.id = 'viet-phrase-polite-1'
      AND ps.section_key = 'quick-say'
      AND psi.item_kind = 'phrase'
      AND psi.note = 'viet-phrase-hello-chao'
      AND psi.title_override = 'Chào';
  `)), 1, "approved Xin chào beginner shortcut row");

  const reviewedCompoundPhrasePageIDSQL = reviewedCompoundPhrasePageIDs.map(sqlQuote).join(",");
  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_page pp
    WHERE (
        pp.title LIKE '%/%'
        OR pp.english_title LIKE '%/%'
        OR lower(pp.english_title) LIKE '% and/or %'
        OR pp.title LIKE '% và %'
        OR pp.title LIKE '% hoặc %'
        OR pp.title LIKE '%anh/chị%'
      )
      AND pp.id NOT IN (${reviewedCompoundPhrasePageIDSQL});
  `), "unreviewed suspicious compound/two-phrase canonical rows");

  const textOnlySectionRunCount = Number(sqliteValue(`
    WITH section_flags AS (
      SELECT
        pp.id AS page_id,
        ps.id AS section_id,
        ps.sort_order,
        CASE WHEN EXISTS (
          SELECT 1
          FROM page_section_item psi
          WHERE psi.section_id = ps.id
            AND psi.item_kind IN ('phrase', 'authored_phrase', 'breakdown_token')
        ) THEN 0 ELSE 1 END AS text_only
      FROM phrase_page pp
      JOIN page_section ps ON ps.page_id = pp.id
    ),
    runs AS (
      SELECT
        section_flags.*,
        SUM(CASE WHEN text_only = 0 THEN 1 ELSE 0 END) OVER (
          PARTITION BY page_id
          ORDER BY sort_order
          ROWS UNBOUNDED PRECEDING
        ) AS run_group
      FROM section_flags
    )
    SELECT count(*)
    FROM (
      SELECT page_id, run_group
      FROM runs
      WHERE text_only = 1
      GROUP BY page_id, run_group
      HAVING count(*) >= 3
    );
  `));
  if (textOnlySectionRunCount !== 0) {
    const sample = sqliteValue(`
      WITH section_flags AS (
        SELECT
          pp.id AS page_id,
          pp.title AS page_title,
          ps.title AS section_title,
          ps.sort_order,
          CASE WHEN EXISTS (
            SELECT 1
            FROM page_section_item psi
            WHERE psi.section_id = ps.id
              AND psi.item_kind IN ('phrase', 'authored_phrase', 'breakdown_token')
          ) THEN 0 ELSE 1 END AS text_only
        FROM phrase_page pp
        JOIN page_section ps ON ps.page_id = pp.id
      ),
      runs AS (
        SELECT
          section_flags.*,
          SUM(CASE WHEN text_only = 0 THEN 1 ELSE 0 END) OVER (
            PARTITION BY page_id
            ORDER BY sort_order
            ROWS UNBOUNDED PRECEDING
          ) AS run_group
        FROM section_flags
      )
      SELECT page_id || ': ' || group_concat(section_title, ' | ')
      FROM runs
      WHERE text_only = 1
      GROUP BY page_id, run_group
      HAVING count(*) >= 3
      ORDER BY page_id
      LIMIT 20;
    `);
    throw new Error(`canonical pages with 3+ consecutive text-only sections: ${textOnlySectionRunCount}\n${sample}`);
  }

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM phrase_page
    WHERE completeness_status != 'deep';
  `), "canonical pages not marked as full-depth article pages");

  const incompleteArticleContractCount = Number(sqliteValue(`
    WITH page_contract AS (
      SELECT
        pp.id AS page_id,
        MAX(CASE WHEN ps.section_key = 'at-glance' THEN 1 ELSE 0 END) AS has_at_glance,
        MAX(CASE WHEN ps.section_key IN ('quick-say', 'standard-way') THEN 1 ELSE 0 END) AS has_quick_or_standard,
        MAX(CASE WHEN ps.section_key = 'breakdown' THEN 1 ELSE 0 END) AS has_breakdown,
        MAX(CASE
          WHEN ps.section_key = 'when-to-use' THEN 1
          WHEN pp.id = '${baNaJourneyPageID}' AND ps.section_key = 'journey-flow' THEN 1
          WHEN pp.id = '${dragonBridgeLandmarkPageID}' AND ps.section_key = 'getting-there' THEN 1
          ELSE 0
        END) AS has_when_to_use,
        MAX(CASE WHEN ps.section_key = 'good-to-know' THEN 1 ELSE 0 END) AS has_good_to_know,
        SUM(CASE WHEN psi.item_kind = 'phrase' AND ps.section_key != 'relationship-words' THEN 1 ELSE 0 END) AS article_phrase_rows,
        SUM(CASE WHEN psi.item_kind = 'breakdown_token' THEN 1 ELSE 0 END) AS breakdown_rows
      FROM phrase_page pp
      JOIN page_section ps ON ps.page_id = pp.id
      LEFT JOIN page_section_item psi ON psi.section_id = ps.id
      GROUP BY pp.id
    )
    SELECT count(*)
    FROM page_contract
    WHERE page_id != 'viet-phrase-polite-1'
      AND (
        has_at_glance = 0
        OR has_quick_or_standard = 0
        OR has_breakdown = 0
        OR has_when_to_use = 0
        OR has_good_to_know = 0
        OR article_phrase_rows = 0
        OR breakdown_rows = 0
      );
  `));
  if (incompleteArticleContractCount !== 0) {
    const sample = sqliteValue(`
      WITH page_contract AS (
        SELECT
          pp.id AS page_id,
          pp.title AS page_title,
          MAX(CASE WHEN ps.section_key = 'at-glance' THEN 1 ELSE 0 END) AS has_at_glance,
          MAX(CASE WHEN ps.section_key IN ('quick-say', 'standard-way') THEN 1 ELSE 0 END) AS has_quick_or_standard,
          MAX(CASE WHEN ps.section_key = 'breakdown' THEN 1 ELSE 0 END) AS has_breakdown,
          MAX(CASE
            WHEN ps.section_key = 'when-to-use' THEN 1
            WHEN pp.id = '${baNaJourneyPageID}' AND ps.section_key = 'journey-flow' THEN 1
            WHEN pp.id = '${dragonBridgeLandmarkPageID}' AND ps.section_key = 'getting-there' THEN 1
            ELSE 0
          END) AS has_when_to_use,
          MAX(CASE WHEN ps.section_key = 'good-to-know' THEN 1 ELSE 0 END) AS has_good_to_know,
          SUM(CASE WHEN psi.item_kind = 'phrase' AND ps.section_key != 'relationship-words' THEN 1 ELSE 0 END) AS article_phrase_rows,
          SUM(CASE WHEN psi.item_kind = 'breakdown_token' THEN 1 ELSE 0 END) AS breakdown_rows
        FROM phrase_page pp
        JOIN page_section ps ON ps.page_id = pp.id
        LEFT JOIN page_section_item psi ON psi.section_id = ps.id
        GROUP BY pp.id
      )
      SELECT page_id || ': ' || page_title
      FROM page_contract
      WHERE page_id != 'viet-phrase-polite-1'
        AND (
          has_at_glance = 0
          OR has_quick_or_standard = 0
          OR has_breakdown = 0
          OR has_when_to_use = 0
          OR has_good_to_know = 0
          OR article_phrase_rows = 0
          OR breakdown_rows = 0
        )
      ORDER BY page_id
      LIMIT 20;
    `);
    throw new Error(`canonical pages missing the full phrase-page contract: ${incompleteArticleContractCount}\n${sample}`);
  }

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
      "when-to-use",
      "situational-greetings",
      "common-follow-ups",
      "cultural-note",
      "good-to-know",
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
    WHERE lower(english_gloss) IN ('key word', 'phrase ending', 'word', 'action', 'place / service', 'question marker', 'main phrase piece', 'extra detail', 'the main place or thing', 'first name part', 'second name part', 'middle name part', 'final name part', 'driver word', 'phrase piece', 'full phrase', 'phrase meaning')
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

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM page_section_item psi
    JOIN phrase p ON p.id = psi.target_id
    JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
    WHERE psi.item_kind = 'phrase'
      AND COALESCE(psi.note, '') != pp.id;
  `), "phrase rows without exact canonical destination notes");

  assertZero(sqliteValue(`
    WITH visible_phrase_rows AS (
      SELECT
        ps.page_id,
        COALESCE(psi.note, pp.id, psi.target_id) AS canonical_target
      FROM page_section ps
      JOIN page_section_item psi ON psi.section_id = ps.id
      LEFT JOIN phrase p ON p.id = psi.target_id
      LEFT JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
      WHERE psi.item_kind IN ('phrase', 'authored_phrase')
    )
    SELECT count(*)
    FROM (
      SELECT page_id, canonical_target
      FROM visible_phrase_rows
      WHERE page_id != '${baNaJourneyPageID}'
      GROUP BY page_id, canonical_target
      HAVING count(*) > 1
    );
  `), "visible phrase rows repeated on the same canonical page");

  assertZero(sqliteValue(`
    WITH visible_phrase_rows AS (
      SELECT
        ps.page_id,
        lower(trim(COALESCE(psi.title_override, p.target_text, psi.target_id))) AS visible_text
      FROM page_section ps
      JOIN page_section_item psi ON psi.section_id = ps.id
      LEFT JOIN phrase p ON p.id = psi.target_id
      WHERE psi.item_kind IN ('phrase', 'authored_phrase')
    )
    SELECT count(*)
    FROM (
      SELECT page_id, visible_text
      FROM visible_phrase_rows
      WHERE page_id != '${baNaJourneyPageID}'
      GROUP BY page_id, visible_text
      HAVING count(*) > 1
    );
  `), "visible phrase text repeated on the same canonical page");

  assertZero(sqliteValue(`
    WITH taught_rows AS (
      SELECT ps.page_id, psi.target_id
      FROM page_section ps
      JOIN page_section_item psi ON psi.section_id = ps.id
      WHERE psi.item_kind = 'phrase'
        AND ps.section_key NOT IN ('relationship-words', 'explore-next')
    ),
    explore_rows AS (
      SELECT ps.page_id, psi.target_id
      FROM page_section ps
      JOIN page_section_item psi ON psi.section_id = ps.id
      WHERE psi.item_kind = 'phrase'
        AND ps.section_key = 'explore-next'
    )
    SELECT count(*)
    FROM explore_rows er
    JOIN taught_rows tr
      ON tr.page_id = er.page_id
     AND tr.target_id = er.target_id;
  `), "Explore next rows that repeat phrases already taught on the page");

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

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM missing_audio_audit ma
    JOIN audio_asset aa
      ON aa.language_pack_id = ma.language_pack_id
     AND aa.normalized_spoken_text = ma.normalized_expected_text;
  `), "missing audio rows with exact reusable audio assets");

  assertZero(sqliteValue(`
    SELECT count(*)
    FROM missing_audio_audit ma
    JOIN audio_usage au
      ON au.target_kind = ma.target_kind
     AND au.target_id = ma.target_id
     AND au.normalized_expected_text = ma.normalized_expected_text;
  `), "missing audio rows with exact target audio usages");

  const bannedScanFiles = [
    catalogPath,
    authoredPagesPath,
    phraseSourcePath,
    relationSamplePath,
    websitePreviewPath,
    expoVietPackPath,
    expoVietPresentationPath,
    expoVietPremiumPath,
    ...walkJSONFiles(tierOnePagesRoot),
    ...walkJSONFiles(catalogPromotedPagesRoot),
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
  assertEqual(report.validation.unexpectedRelationshipWordsSectionCount, 0, "report unexpected relationship-word shelf count");
  assertEqual(report.validation.badRelationshipWordsSectionCount, 0, "report incomplete relationship-word shelf count");
  assertEqual(report.validation.badQuickSayTeachingRowCount, 0, "report bad Quick Say teaching row count");
  assertEqual(report.validation.textOnlySectionRunCount, 0, "report text-only section run count");
  assertEqual(report.validation.nonDeepCompletenessStatusCount, 0, "report non-full-depth page status count");
  assertEqual(report.validation.incompleteArticleContractCount, 0, "report incomplete article contract count");
  assertEqual(report.validation.brokenRelationCount, 0, "report broken relation count");
  assertEqual(report.validation.searchDocumentsWithMissingPageTargets, 0, "report search target count");
  assertEqual(report.validation.pageEnglishTitlePhraseTextMismatchCount, 0, "report page English title mismatch count");
  assertEqual(report.validation.audioUsageMismatchCount, 0, "report audio mismatch count");
  assertEqual(report.validation.badBreakdownGlossCount, 0, "report bad breakdown gloss count");
  assertEqual(report.validation.duplicateBreakdownGlossCount, 0, "report duplicate breakdown gloss count");
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
