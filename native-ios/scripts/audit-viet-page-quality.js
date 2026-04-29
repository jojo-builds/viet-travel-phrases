#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const reportPath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet-report.json");
const auditPath = path.join(repoRoot, "docs", "content-audits", "viet-page-quality-recovery-001.md");

function run(command, args) {
  const result = spawnSync(command, args, { cwd: repoRoot, encoding: "utf8", maxBuffer: 32 * 1024 * 1024 });
  if (result.status !== 0) {
    throw new Error(`${command} ${args.join(" ")} failed\nSTDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}`);
  }
  return result.stdout.trim();
}

function sqliteJSON(sql) {
  const output = run("sqlite3", ["-json", databasePath, sql]);
  return output ? JSON.parse(output) : [];
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function markdownCell(value) {
  return String(value ?? "")
    .replace(/\|/g, "\\|")
    .replace(/\n+/g, " ")
    .trim();
}

function breakdownIssues(page, tokens) {
  const issues = [];
  const titleKey = normalize(page.title);
  const englishTitleKey = String(page.english_title ?? "").trim().toLowerCase();
  const titleWordCount = String(page.title).split(/\s+/).filter(Boolean).length;
  const labels = tokens.map((token) => String(token.english_gloss ?? "").toLowerCase());

  if (tokens.length === 0) {
    issues.push("missing breakdown");
  }
  if (tokens.length === 1 && titleWordCount > 1) {
    issues.push("multiword phrase has one card");
  }
  if (tokens.slice(0, -1).some((token) => normalize(token.token_text) === titleKey)) {
    issues.push("non-final card duplicates full phrase");
  }
  if (tokens.length > 0 && normalize(tokens[tokens.length - 1].token_text) !== titleKey) {
    issues.push("final card is not full phrase");
  }
  if (labels.some((label) => [
    "key word",
    "phrase ending",
    "word",
    "action",
    "place / service",
    "question marker",
  ].includes(label) || label.includes("question marker"))) {
    issues.push("internal breakdown label");
  }
  if (tokens.slice(0, -1).some((token) => String(token.english_gloss ?? "").trim().toLowerCase() === englishTitleKey)) {
    issues.push("non-final gloss repeats whole English title");
  }

  return issues;
}

const overTemplatePatterns = [
  /keeping the useful noun or action/i,
  /short answer, gesture, or practical next step/i,
  /direct phrase for/i,
  /nearby phrases are likely to sit near this moment/i,
  /phrase works because it is specific enough/i,
  /Use this when one key word/i,
  /\bDifferent ways\b/i,
  /question marker/i,
];

function articleIssues(page) {
  const issues = [];
  const text = `${page.summary ?? ""} ${page.section_text ?? ""}`;

  if (Number(page.section_count) === 0) {
    issues.push("missing article sections");
  }
  if (Number(page.section_count) < 5 && page.id !== "viet-phrase-polite-1") {
    issues.push("too few article sections");
  }
  for (const pattern of overTemplatePatterns) {
    if (pattern.test(text)) {
      issues.push(`over-templated/internal wording: ${pattern}`);
    }
  }

  return issues;
}

function main() {
  const report = JSON.parse(fs.readFileSync(reportPath, "utf8"));
  const pages = sqliteJSON(`
    SELECT
      pp.id,
      pp.title,
      pp.english_title,
      pp.summary,
      pp.completeness_status,
      pp.is_authored,
      p.id AS phrase_id,
      p.audio_status,
      (
        SELECT group_concat(section_key, ' / ')
        FROM (
          SELECT ps.section_key
          FROM page_section ps
          WHERE ps.page_id = pp.id
          ORDER BY ps.sort_order
        )
      ) AS section_keys,
      (SELECT count(*) FROM page_section ps WHERE ps.page_id = pp.id) AS section_count,
      (
        SELECT group_concat(ps.title || ' ' || ps.body, ' ')
        FROM page_section ps
        WHERE ps.page_id = pp.id
      ) AS section_text,
      (SELECT count(*) FROM page_alias pa WHERE pa.canonical_page_id = pp.id) AS alias_count,
      (SELECT count(*) FROM audio_usage au WHERE au.target_kind = 'phrase' AND au.target_id = p.id) AS phrase_audio_usage_count
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    ORDER BY pp.id;
  `);

  const breakdownRows = sqliteJSON(`
    SELECT
      pp.id AS page_id,
      psi.sort_order,
      bt.token_text,
      bt.english_gloss
    FROM phrase_page pp
    JOIN page_section ps ON ps.page_id = pp.id AND ps.section_key = 'breakdown'
    JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'breakdown_token'
    JOIN breakdown_token bt ON bt.id = psi.target_id
    ORDER BY pp.id, psi.sort_order;
  `);

  const breakdownByPageID = new Map();
  for (const row of breakdownRows) {
    const rows = breakdownByPageID.get(row.page_id) ?? [];
    rows.push(row);
    breakdownByPageID.set(row.page_id, rows);
  }

  function articleStatusLabel(page, hasArticleSections) {
    if (!hasArticleSections) return "missing article";
    if (page.completeness_status === "deep") return "deep article";
    return "complete article";
  }

  const auditedRows = pages.map((page) => {
    const tokens = breakdownByPageID.get(page.id) ?? [];
    const issues = [...articleIssues(page), ...breakdownIssues(page, tokens)];
    const hasArticleSections = Number(page.section_count) > 0;
    const hasBreakdown = tokens.length > 0;
    const passed = hasArticleSections && hasBreakdown && issues.length === 0;

    return {
      ...page,
      token_count: tokens.length,
      breakdown_status: issues.length === 0 ? "pass" : issues.join("; "),
      article_status: articleStatusLabel(page, hasArticleSections),
      canonical_status: `canonical; ${page.alias_count} alias(es)`,
      audio_status: report.audio.missingAudioAuditRows === 0
        ? `${page.audio_status}; visible audio audit clean`
        : `${page.audio_status}; missing-audio rows present`,
      source_type: page.is_authored ? "authored article" : "catalog-built article",
      pass_fail: passed ? "PASS" : "FAIL",
    };
  });

  const passCount = auditedRows.filter((row) => row.pass_fail === "PASS").length;
  const authoredCount = auditedRows.filter((row) => row.is_authored).length;
  const catalogBuiltCount = auditedRows.length - authoredCount;

  const lines = [
    "# Viet Page Quality Recovery Audit 001",
    "",
    "Date: 2026-04-29",
    "",
    "## Summary",
    "",
    `- Current canonical phrase-page universe: ${auditedRows.length}.`,
    `- Source phrase rows: ${report.generatedCounts.phrases}.`,
    `- Audit-pass pages: ${passCount}.`,
    `- Authored article pages: ${authoredCount}.`,
    `- Catalog-built article pages: ${catalogBuiltCount}.`,
    `- Duplicate canonical Vietnamese page groups: ${report.validation.duplicateCanonicalPageGroupCount}.`,
    `- Broken relations/search targets: ${report.validation.brokenRelationCount} broken relation edges, ${report.validation.searchDocumentsWithMissingPageTargets} missing search targets.`,
    `- Missing visible audio audit rows: ${report.audio.missingAudioAuditRows}.`,
    "",
    "## Recovery Notes",
    "",
    "- `viet-polite-hello` and `viet-family-polite-hello` now alias to canonical `viet-phrase-polite-1`.",
    "- `viet-phrase-polite-1` now carries the flagship Xin chào article rhythm in the generated SQLite page sections.",
    "- Catalog-built canonical pages now receive `At a glance`, `Quick say`, `Break it down`, `When to use it`, `Good to know`, and nearby phrase sections.",
    "- The bad `Không sao đâu` breakdown now teaches `Không sao` plus softening `đâu` before the full phrase.",
    "",
    "## One-By-One Canonical Page Audit",
    "",
    "| # | Page ID | Vietnamese title | English title | Source type | Article completeness | Breakdown quality | Canonical status | Visible audio status | Result / notes |",
    "| ---: | --- | --- | --- | --- | --- | --- | --- | --- | --- |",
  ];

  auditedRows.forEach((row, index) => {
    lines.push([
      index + 1,
      `\`${markdownCell(row.id)}\``,
      markdownCell(row.title),
      markdownCell(row.english_title),
      markdownCell(row.source_type),
      markdownCell(row.article_status),
      markdownCell(`${row.breakdown_status} (${row.token_count} cards)`),
      markdownCell(row.canonical_status),
      markdownCell(row.audio_status),
      markdownCell(row.pass_fail),
    ].join(" | ").replace(/^/, "| ").replace(/$/, " |"));
  });

  fs.mkdirSync(path.dirname(auditPath), { recursive: true });
  fs.writeFileSync(auditPath, `${lines.join("\n")}\n`);

  console.log(JSON.stringify({
    auditPath: path.relative(repoRoot, auditPath),
    canonicalPages: auditedRows.length,
    passCount,
    authoredCount,
    catalogBuiltCount,
  }, null, 2));

  if (passCount !== auditedRows.length) {
    process.exit(1);
  }
}

main();
