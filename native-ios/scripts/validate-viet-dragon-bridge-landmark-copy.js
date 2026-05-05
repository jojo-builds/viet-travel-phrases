#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const taskID = "TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001";
const phraseID = "city-danang-place-dragon-bridge";
const sourcePageID = "city-danang-place-dragon-bridge";
const authoredPageID = "viet-family-city-danang-place-dragon-bridge";
const sqlitePageID = "viet-phrase-city-danang-place-dragon-bridge";
const importRoot = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-canonical-pages",
  "dragon-bridge-ux-copy-override-v2",
  "copy-import"
);
const incomingRoot = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-canonical-pages",
  "dragon-bridge-ux-copy-override-v2",
  "incoming-chatgpt",
  "completed-patch-files"
);
const approvalPath = path.join(importRoot, "approval-overlay.json");
const importApplyPath = path.join(importRoot, "import-apply.json");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredResourcePath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const sqlitePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const heroImageName = "HeroDragonBridge";
const assetDir = path.join(nativeRoot, "Resources", "Assets.xcassets", `${heroImageName}.imageset`);

const expectedSectionOrder = [
  "at-glance",
  "quick-say",
  "getting-there",
  "at-the-bridge",
  "pickup-nearby",
  "breakdown",
  "good-to-know",
  "explore-next",
];
const expectedRows = new Map([
  ["quick-say", ["city-danang-place-dragon-bridge"]],
  ["getting-there", ["city-danang-go-dragon-bridge", "city-danang-where-dragon-bridge"]],
  ["at-the-bridge", ["ves-take-photo-for-me"]],
  ["pickup-nearby", ["ves-drop-near-dragon-bridge", "city-danang-stop-dragon-bridge"]],
  ["explore-next", ["city-danang-atm-dragon-bridge", "city-danang-eat-near-dragon-bridge"]],
]);
const bannedUserFacingTerms = [
  "anchor",
  "place name",
  "useful moments",
  "where-question",
  "route phrase",
  "connect to",
  "this page",
  "relationship rows",
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function relative(filePath) {
  return path.relative(repoRoot, filePath);
}

function sqliteJSON(sql) {
  const result = spawnSync("sqlite3", ["-json", sqlitePath, sql], {
    cwd: repoRoot,
    encoding: "utf8",
    maxBuffer: 64 * 1024 * 1024,
  });
  if (result.status !== 0) {
    throw new Error(`sqlite3 failed\nSQL:\n${sql}\nSTDERR:\n${result.stderr}`);
  }
  const output = result.stdout.trim();
  return output ? JSON.parse(output) : [];
}

function loadPatchRows(name) {
  const filePath = path.join(incomingRoot, `${name}.json`);
  assert(fs.existsSync(filePath), `missing incoming patch file ${relative(filePath)}`);
  const rows = readJSON(filePath);
  assert(Array.isArray(rows), `${relative(filePath)} must be a JSON array`);
  for (const row of rows) {
    assert(row.review_status === "REVIEW_ONLY", `${row.patch_id} raw review_status changed`);
    assert(row.import_approval === "REVIEW_ONLY", `${row.patch_id} raw import_approval changed`);
  }
  return rows;
}

function pageText(page) {
  return [
    page.title,
    page.englishTitle,
    page.summary,
    ...(page.sections ?? []).flatMap((section) => [
      section.title,
      section.body,
      ...(section.phrases ?? []).flatMap((phrase) => [phrase.vietnamese, phrase.english, phrase.note]),
      ...(section.breakdown ?? []).flatMap((token) => [token.vietnamese, token.english]),
    ]),
  ].filter(Boolean).join("\n");
}

function sectionIDs(page) {
  return (page.sections ?? []).map((section) => section.id);
}

function phraseIDs(section) {
  return (section?.phrases ?? []).map((phrase) => phrase.id);
}

function assertArrayEqual(actual, expected, label) {
  assert(JSON.stringify(actual) === JSON.stringify(expected), `${label} mismatch\nexpected ${JSON.stringify(expected)}\nactual   ${JSON.stringify(actual)}`);
}

function main() {
  loadPatchRows("page_patch");
  loadPatchRows("section_patch");
  loadPatchRows("phrase_row_patch");
  loadPatchRows("renderer_directives_patch");
  loadPatchRows("validator_rules_patch");

  assert(fs.existsSync(approvalPath), `missing approval overlay ${relative(approvalPath)}`);
  assert(fs.existsSync(importApplyPath), `missing import apply summary ${relative(importApplyPath)}`);
  const approval = readJSON(approvalPath);
  const importSummary = readJSON(importApplyPath);
  assert(approval.taskID === taskID, "approval overlay taskID mismatch");
  assert(approval.approvalMode === "agent-gated", "approval overlay must be agent-gated");
  assert((approval.approvedPages ?? []).length === 1, "approval overlay must approve exactly one page");
  assert(approval.approvedPages[0].phrase_id === phraseID, "approval must target Dragon Bridge");
  assert(approval.approvedPages[0].import_status === "AGENT_APPROVED_FOR_IMPORT", "Dragon Bridge approval must be import-ready");
  assert(importSummary.taskID === taskID, "import summary taskID mismatch");
  assert(importSummary.mode === "apply", "import summary must be an apply run");
  assert(importSummary.importedPageCount === 1, "exactly one page should be imported");
  assert(importSummary.skippedPageCount === 0, "Dragon copy import should not skip rows");

  const cityLibrary = readJSON(cityLibraryPath);
  const cityRecord = (cityLibrary.pages ?? []).find((page) => page.id === sourcePageID);
  assert(cityRecord, `missing city source ${sourcePageID}`);
  assert(cityRecord.targetText === "Cầu Rồng", "Vietnamese canonical title changed");
  assert(cityRecord.englishText === "Dragon Bridge", "English canonical title changed");
  assert(cityRecord.editorialImport?.taskID === taskID, "city source missing task marker");
  assert(cityRecord.editorialImport?.sourcePatch === "dragon-bridge-ux-copy-override-v2/incoming-chatgpt/completed-patch-files", "source patch marker mismatch");
  assert(cityRecord.editorialImport?.templateProfile === "landmark-action-page", "template profile mismatch");
  assert(cityRecord.editorialImport?.heroImageName === heroImageName, "Dragon hero image metadata missing");
  assertArrayEqual((cityRecord.editorialImport.sections ?? []).map((section) => section.id), expectedSectionOrder, "source section order");

  const authored = readJSON(authoredResourcePath);
  const page = (authored.pages ?? []).find((candidate) => candidate.phraseID === phraseID);
  assert(page, `missing authored Dragon Bridge page ${phraseID}`);
  assert(page.id === authoredPageID, `authored page ID changed: ${page.id}`);
  assert(page.title === "Cầu Rồng", "authored Vietnamese title changed");
  assert(page.englishTitle === "Dragon Bridge", "authored English title changed");
  assert(page.heroImageName === heroImageName, "authored Dragon hero image missing");
  assertArrayEqual(sectionIDs(page), expectedSectionOrder, "authored section order");
  assert(!sectionIDs(page).includes("place-brief"), "place-brief must be suppressed");
  assert(!sectionIDs(page).includes("use-it-with"), "use-it-with must be suppressed");
  assert(!sectionIDs(page).includes("when-to-use"), "when-to-use must be suppressed");
  for (const [sectionID, expectedPhraseIDs] of expectedRows) {
    const section = page.sections.find((candidate) => candidate.id === sectionID);
    assertArrayEqual(phraseIDs(section), expectedPhraseIDs, `${sectionID} phrase rows`);
  }
  const selfRow = page.sections.find((section) => section.id === "quick-say")?.phrases?.[0];
  assert(selfRow?.id === phraseID, "quick-say self row missing");
  assert(!selfRow.detailPageID, "quick-say self row must not link to the current page");
  const breakdown = page.sections.find((section) => section.id === "breakdown")?.breakdown ?? [];
  assertArrayEqual(
    breakdown.map((token) => [token.vietnamese, token.english]),
    [
      ["Cầu", "bridge"],
      ["Rồng", "dragon"],
      ["Cầu Rồng", "Dragon Bridge"],
    ],
    "name meaning breakdown"
  );

  const renderedText = pageText(page).toLowerCase();
  const bannedHits = bannedUserFacingTerms.filter((term) => renderedText.includes(term.toLowerCase()));
  assert(bannedHits.length === 0, `Dragon Bridge rendered copy includes banned internal terms: ${bannedHits.join(", ")}`);

  const catalog = readJSON(catalogPath);
  const phraseIDsInCatalog = new Set((catalog.phrases ?? []).map((phrase) => phrase.id));
  for (const ids of expectedRows.values()) {
    for (const id of ids) {
      assert(phraseIDsInCatalog.has(id), `missing linked catalog phrase ${id}`);
    }
  }

  const sqlitePages = sqliteJSON(`
    SELECT id, phrase_id, title, english_title, hero_image_name
    FROM phrase_page
    WHERE phrase_id = '${phraseID}';
  `);
  assert(sqlitePages.length === 1, `expected one SQLite Dragon Bridge page, found ${sqlitePages.length}`);
  assert(sqlitePages[0].id === sqlitePageID, `SQLite canonical page ID changed: ${sqlitePages[0].id}`);
  assert(sqlitePages[0].title === "Cầu Rồng", "SQLite Vietnamese title changed");
  assert(sqlitePages[0].english_title === "Dragon Bridge", "SQLite English title changed");
  assert(sqlitePages[0].hero_image_name === heroImageName, "SQLite Dragon hero image missing");
  assert(fs.existsSync(path.join(assetDir, "Contents.json")), "HeroDragonBridge Contents.json missing");
  assert(fs.existsSync(path.join(assetDir, "hero-dragon-bridge.png")), "HeroDragonBridge PNG missing");
  const sqliteSections = sqliteJSON(`
    SELECT section_key AS id
    FROM page_section
    WHERE page_id = '${sqlitePageID}'
    ORDER BY sort_order;
  `);
  assertArrayEqual(sqliteSections.map((row) => row.id), expectedSectionOrder, "SQLite section order");
  const linkedRows = sqliteJSON(`
    SELECT ps.section_key, psi.target_id
    FROM page_section ps
    JOIN page_section_item psi ON psi.section_id = ps.id
    WHERE ps.page_id = '${sqlitePageID}' AND psi.item_kind IN ('phrase', 'authored_phrase')
    ORDER BY ps.sort_order, psi.sort_order;
  `);
  for (const row of linkedRows) {
    const count = sqliteJSON(`SELECT count(*) AS count FROM phrase_page WHERE phrase_id = '${row.target_id}';`);
    assert(Number(count[0].count) === 1, `${row.section_key} row ${row.target_id} does not resolve to exactly one canonical page`);
  }

  console.log("Dragon Bridge landmark copy import validator OK");
}

main();
