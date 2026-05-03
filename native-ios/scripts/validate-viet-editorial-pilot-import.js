#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const pilotRoot = path.join(repoRoot, "docs", "editorial-exports", "viet-canonical-pages", "chatgpt-pilot-2026-05-03");
const patchPath = path.join(pilotRoot, "SpeakLocal_Vietnam_Editorial_Pilot_Patch_v1.json");
const approvalPath = path.join(pilotRoot, "approved-imports-TASK-VIET-EDITORIAL-PILOT-IMPORT-001.json");

const expectedImports = new Map([
  ["EP-017", {
    phraseID: "acknowledge-da-chao-co",
    requiredBreakdowns: [
      ["cô", "aunt-age woman / respectful female address"],
      ["Dạ, chào cô", "Respectful hello to an aunt-age woman"],
    ],
    forbiddenBreakdowns: [
      ["cô", /have\s*\/\s*yes/i],
    ],
  }],
  ["EP-018", {
    phraseID: "airport-6",
    requiredBreakdowns: [
      ["chưa", "not yet"],
      ["tới", "arrived / reached"],
    ],
    forbiddenBreakdowns: [
      ["chưa", /pagoda/i],
    ],
  }],
  ["EP-019", {
    phraseID: "bath-2",
    requiredBreakdowns: [
      ["Có ... không?", "do you have / is there?"],
      ["giấy vệ sinh", "toilet paper"],
    ],
    forbiddenBreakdowns: [
      ["vệ", /ticket/i],
    ],
  }],
]);

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function runSQLite(sql) {
  const result = spawnSync("sqlite3", ["-json", databasePath, sql], {
    cwd: repoRoot,
    encoding: "utf8",
    maxBuffer: 16 * 1024 * 1024,
  });
  if (result.status !== 0) {
    throw new Error(`sqlite3 failed\nSTDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}`);
  }
  return result.stdout.trim() ? JSON.parse(result.stdout) : [];
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function main() {
  assert(fs.existsSync(databasePath), `Missing SQLite database: ${path.relative(repoRoot, databasePath)}`);
  const patch = readJSON(patchPath);
  const approval = readJSON(approvalPath);
  const patchIDs = new Set((patch.patches ?? []).map((row) => row.patch_id));
  const approved = (approval.approvals ?? []).filter((row) => row.import_approval === "APPROVED_FOR_IMPORT");
  const approvedIDs = new Set(approved.map((row) => row.patch_id));

  assert(approved.length === expectedImports.size, `Expected ${expectedImports.size} approved P0 imports, found ${approved.length}`);
  for (const id of expectedImports.keys()) {
    assert(patchIDs.has(id), `${id} missing from pilot patch`);
    assert(approvedIDs.has(id), `${id} missing from approval overlay`);
  }

  for (const row of patch.patches ?? []) {
    if (!expectedImports.has(row.patch_id)) {
      assert(!approvedIDs.has(row.patch_id), `${row.patch_id} is unexpectedly approved`);
    }
  }

  const breakdownRows = runSQLite(`
    SELECT
      p.id AS phrase_id,
      bt.token_text,
      bt.english_gloss
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    JOIN page_section ps ON ps.page_id = pp.id AND ps.section_key = 'breakdown'
    JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'breakdown_token'
    JOIN breakdown_token bt ON bt.id = psi.target_id
    WHERE p.id IN (${[...expectedImports.values()].map((item) => `'${item.phraseID}'`).join(", ")})
    ORDER BY p.id, psi.sort_order;
  `);

  for (const [patchID, expectation] of expectedImports.entries()) {
    const rows = breakdownRows.filter((row) => row.phrase_id === expectation.phraseID);
    assert(rows.length > 0, `${patchID} has no generated breakdown rows`);

    for (const [token, expectedGloss] of expectation.requiredBreakdowns) {
      assert(
        rows.some((row) => row.token_text === token && row.english_gloss === expectedGloss),
        `${patchID} missing breakdown ${token} -> ${expectedGloss}`
      );
    }

    for (const [token, forbiddenPattern] of expectation.forbiddenBreakdowns) {
      assert(
        !rows.some((row) => row.token_text === token && forbiddenPattern.test(row.english_gloss ?? "")),
        `${patchID} still has forbidden breakdown for ${token}`
      );
    }
  }

  console.log(JSON.stringify({
    status: "pass",
    approvedImports: [...approvedIDs],
    checkedPhraseIDs: [...expectedImports.values()].map((item) => item.phraseID),
  }, null, 2));
}

main();
