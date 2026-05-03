#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const canonicalAuditJSONLPath = path.join(repoRoot, "docs", "content-audits", "viet-canonical-content-audit-001", "per-page-audit.jsonl");
const outputRoot = path.join(repoRoot, "docs", "editorial-exports", "viet-canonical-pages", "latest");
const manifestPath = path.join(outputRoot, "manifest.json");
const taskID = "TASK-VIET-EDITORIAL-EXPORT-001";
const checkOnly = process.argv.includes("--check");

const genericCopyPatterns = [
  ["generic_different_ways", /\bDifferent ways to say\b/i],
  ["generic_answers_traveler_question", /answers the traveler question/i],
  ["generic_short_practice_phrase", /short practice phrase/i],
  ["generic_main_thing_understood", /main thing you need understood/i],
  ["generic_built_for_quick_recognition", /built for quick recognition/i],
  ["generic_long_explanation", /rather than a long explanation/i],
  ["generic_small_task", /\bsmall task\b/i],
  ["generic_anchor_word", /\banchor word\b/i],
];

const placeholderPatterns = [
  ["placeholder_todo", /\bTODO\b|\bTBD\b|\bplaceholder\b/i],
  ["placeholder_depth_label", /\bbaseline\b|\bsupport\b|\bthin\b|\bfallback\b|\bfiller\b/i],
  ["placeholder_internal_warning", /Watch out|repair phrase|Understanding Repair|question marker/i],
];

const wrongTemplatePatterns = [
  ["wrong_template_landmark_quickly", /landmark quickly/i],
  ["wrong_template_city_visit_copy", /Use this page before you visit/i],
  ["wrong_template_repeated_place_brief", /(.+?) is a .*? in .+?\.\s+\1 is a .*? in/i],
];

const weakBreakdownLabels = new Set([
  "key word",
  "phrase ending",
  "word",
  "action",
  "place / service",
  "question marker",
  "main phrase piece",
  "extra detail",
  "the main place or thing",
  "specific detail",
  "name or place detail",
  "first name part",
  "second name part",
  "middle name part",
  "final name part",
  "driver word",
  "phrase piece",
  "full phrase",
  "phrase meaning",
  "proper name",
  "place name",
  "street name",
  "market name",
]);

function run(command, args) {
  const result = spawnSync(command, args, {
    cwd: repoRoot,
    encoding: "utf8",
    maxBuffer: 256 * 1024 * 1024,
  });
  if (result.status !== 0) {
    throw new Error(`${command} ${args.join(" ")} failed\nSTDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}`);
  }
  return result.stdout.trim();
}

function sqliteJSON(sql) {
  const output = run("sqlite3", ["-json", databasePath, sql]);
  return output ? JSON.parse(output) : [];
}

function sqliteValue(sql) {
  return run("sqlite3", [databasePath, sql]);
}

function readJSON(filePath, fallback = null) {
  if (!fs.existsSync(filePath)) return fallback;
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function csvCell(value) {
  if (value === null || value === undefined) return "\"\"";
  const text = typeof value === "string" ? value : JSON.stringify(value);
  return `"${text.replace(/"/g, "\"\"").replace(/\r\n/g, "\n").replace(/\r/g, "\n").replace(/\n+/g, " ⏎ ")}"`;
}

function writeCSV(fileName, header, rows, generated) {
  generated.set(path.join(outputRoot, fileName), [header, ...rows].map((row) => row.map(csvCell).join(",")).join("\n") + "\n");
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[đĐ]/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function slug(value) {
  return normalize(value).replace(/\s+/g, "-");
}

function pipe(values) {
  return [...new Set((values ?? []).map((value) => String(value ?? "").trim()).filter(Boolean))].join("|");
}

function compactJSON(value) {
  return JSON.stringify(value ?? []);
}

function walkFiles(dir, predicate) {
  if (!fs.existsSync(dir)) return [];
  const out = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      out.push(...walkFiles(fullPath, predicate));
    } else if (entry.isFile() && predicate(fullPath)) {
      out.push(fullPath);
    }
  }
  return out.sort((a, b) => a.localeCompare(b));
}

function buildSourceIndex() {
  const index = new Map();
  const add = (key, filePath) => {
    if (key && filePath && !index.has(key)) index.set(key, path.relative(repoRoot, filePath));
  };

  for (const root of [
    path.join(repoRoot, "content-draft", "viet", "canonical-pages", "tier-one"),
    path.join(repoRoot, "content-draft", "viet", "canonical-pages", "catalog-promoted"),
  ]) {
    for (const filePath of walkFiles(root, (candidate) => candidate.endsWith(".json") && !path.basename(candidate).startsWith("_"))) {
      const page = readJSON(filePath);
      if (!page) continue;
      add(`resource-page:${page.id}`, filePath);
      add(`phrase:${page.phraseID}`, filePath);
      add(`family:${page.familyID}`, filePath);
    }
  }

  const cityPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
  const city = readJSON(cityPath);
  for (const page of city?.pages ?? []) {
    add(`phrase:${page.id}`, cityPath);
    add(`family:${page.id}`, cityPath);
  }

  const practiceRoot = path.join(repoRoot, "content-draft", "viet", "practice-expansion", "TASK-VIET-CONTENT-PRACTICE-EXPANSION-001");
  const practiceManifest = readJSON(path.join(practiceRoot, "manifest.json"));
  for (const shardPath of practiceManifest?.sourceShards ?? []) {
    const fullPath = path.join(practiceRoot, shardPath);
    const shard = readJSON(fullPath);
    for (const page of shard?.pages ?? []) {
      add(`phrase:${page.phraseID ?? page.id}`, fullPath);
      add(`family:${page.familyID ?? page.id}`, fullPath);
    }
  }

  return index;
}

function loadCanonicalAuditRows() {
  if (!fs.existsSync(canonicalAuditJSONLPath)) return new Map();
  const rows = fs.readFileSync(canonicalAuditJSONLPath, "utf8")
    .trim()
    .split(/\n+/)
    .filter(Boolean)
    .map((line) => JSON.parse(line));
  return new Map(rows.map((row) => [row.pageID, row]));
}

function pageKindFrom(page, categories) {
  return page.cityMetadata?.pageKind
    ?? categories.find((category) => category.startsWith("city-page-kind-"))?.replace("city-page-kind-", "")
    ?? "phrase";
}

function placeKindFrom(page, categories) {
  return page.cityMetadata?.placeKind
    ?? categories.find((category) => category.startsWith("place-kind-"))?.replace("place-kind-", "")
    ?? "";
}

function contentRoleFrom(page, categories) {
  return page.cityMetadata?.contentRole
    ?? categories.find((category) => category.startsWith("content-role-"))?.replace("content-role-", "")
    ?? "";
}

function sourceLaneFor(page, sourcePath) {
  if (page?.tierRole) return page.tierRole;
  if (sourcePath.includes("city-library")) return "city-v1";
  if (sourcePath.includes("practice-expansion")) return "practice-expansion";
  if (sourcePath.includes("catalog-promoted")) return "catalog-promoted";
  if (sourcePath.includes("tier-one")) return "tier1";
  return "unknown";
}

function sourcePathFor(page, phraseID, sqliteSourcePath, sourceIndex) {
  return sourceIndex.get(`phrase:${phraseID}`)
    ?? sourceIndex.get(`family:${page?.familyID}`)
    ?? sourceIndex.get(`resource-page:${page?.id}`)
    ?? sqliteSourcePath
    ?? "";
}

function sectionText(sections) {
  return sections.map((section) => {
    const title = section.title ? `${section.title}: ` : "";
    return `${section.section_key} | ${title}${section.body ?? ""}`.trim();
  }).join("\n---\n");
}

function breakdownText(tokens) {
  return tokens.map((token) => `${token.token_text} -> ${token.english_gloss}`).join(" | ");
}

function phraseRowsText(rows) {
  return rows.map((row) => `${row.section_key}: ${row.target_text ?? row.title_override} -> ${row.english_text ?? row.subtitle_override} (${row.target_page_id ?? row.detail_page_id ?? ""})`).join(" | ");
}

function relationshipText(rows) {
  return rows.map((row) => `${row.relation_type}:${row.target_id}${row.display_label ? `:${row.display_label}` : ""}`).join(" | ");
}

function auditFlags({ page, pageKind, categories, sections, breakdowns, phraseRows, relationships, canonicalAudit }) {
  const combined = [
    page?.title,
    page?.englishTitle,
    page?.summary,
    ...sections.flatMap((section) => [section.title, section.body]),
    ...breakdowns.flatMap((token) => [token.token_text, token.english_gloss]),
    ...phraseRows.flatMap((row) => [row.title_override, row.subtitle_override, row.target_text, row.english_text]),
  ].join("\n");

  const flags = [];
  const evidence = [];
  for (const [code, pattern] of genericCopyPatterns) {
    if (pattern.test(combined)) {
      flags.push(code);
      evidence.push(code);
    }
  }
  for (const [code, pattern] of placeholderPatterns) {
    if (pattern.test(combined)) {
      flags.push(code);
      evidence.push(code);
    }
  }
  for (const [code, pattern] of wrongTemplatePatterns) {
    if (pattern.test(combined)) {
      flags.push(code);
      evidence.push(code);
    }
  }
  if ((pageKind === "restaurant" || pageKind === "dish") && categories.includes("actual-landmarks")) {
    flags.push("wrong_template_food_in_landmarks");
    evidence.push(`${pageKind} page has actual-landmarks category`);
  }

  const nonFinalBreakdowns = breakdowns.slice(0, -1);
  const seenGlosses = new Map();
  for (const token of nonFinalBreakdowns) {
    const gloss = normalize(token.english_gloss);
    if (!gloss) continue;
    if (weakBreakdownLabels.has(gloss)) {
      flags.push("weak_breakdown_label");
      evidence.push(`${token.token_text} -> ${token.english_gloss}`);
    }
    if (seenGlosses.has(gloss)) {
      flags.push("weak_duplicate_breakdown_label");
      evidence.push(`${seenGlosses.get(gloss)} + ${token.token_text} share ${token.english_gloss}`);
    }
    seenGlosses.set(gloss, token.token_text);
  }

  if (sections.length < 5) {
    flags.push("placeholder_like_low_section_count");
    evidence.push(`section_count=${sections.length}`);
  }
  if (!phraseRows.length && !breakdowns.length) {
    flags.push("placeholder_like_no_interactive_items");
    evidence.push("no phrase rows or breakdown rows");
  }
  for (const issueCode of canonicalAudit?.issueCodes ?? []) {
    flags.push(`canonical_audit_${issueCode}`);
  }
  for (const issue of canonicalAudit?.issues ?? []) {
    if (issue?.message) evidence.push(issue.message);
  }

  const uniqueFlags = [...new Set(flags)];
  return {
    flags: uniqueFlags,
    generic: uniqueFlags.some((flag) => flag.startsWith("generic_")),
    placeholderLike: uniqueFlags.some((flag) => flag.startsWith("placeholder")),
    wrongTemplate: uniqueFlags.some((flag) => flag.startsWith("wrong_template")),
    weakCopy: uniqueFlags.some((flag) => flag.startsWith("weak_") || flag.startsWith("canonical_audit_")),
    evidence: [...new Set(evidence)].join(" || "),
  };
}

function importContract(generatedAt) {
  return {
    schemaVersion: "speaklocal.viet.editorial-import-contract.v1",
    generatedAt,
    status: "design-only-not-imported",
    sourceOfTruth: "Repo source files remain canonical. Sheet rows are editorial staging only.",
    immutableKeys: [
      "page_id",
      "phrase_id",
      "source_lane",
      "source_path",
    ],
    approvalValue: "APPROVED_FOR_IMPORT",
    allowedReviewStatuses: [
      "not_started",
      "needs_review",
      "rewrite_proposed",
      "approved_for_import",
      "do_not_import",
      "needs_native_language_review",
    ],
    importableColumns: {
      pages: [
        "proposed_vietnamese",
        "proposed_english",
        "proposed_pronunciation",
        "proposed_summary",
        "proposed_category_tags",
      ],
      sections: [
        "proposed_section_title",
        "proposed_section_body",
        "proposed_presentation",
      ],
      breakdowns: [
        "proposed_token_text",
        "proposed_english_gloss",
      ],
      relationships: [
        "proposed_target_page_id",
        "proposed_relation_type",
        "proposed_display_label",
        "proposed_reason",
      ],
    },
    importRules: [
      "No row may import unless import_approval exactly equals APPROVED_FOR_IMPORT.",
      "Import must resolve page_id and phrase_id to current repo resources before writing.",
      "Import must write source-owned files only; generated JSON, SQLite, and practice outputs are rebuilt afterward.",
      "Canonical page IDs and phrase IDs are immutable.",
      "Vietnamese phrase text changes require duplicate-normalized-phrase validation before import.",
      "Audio is not generated by import. Changed text becomes planned missing audio unless exact normalized audio already exists.",
      "Rows marked needs_native_language_review or do_not_import are skipped.",
    ],
  };
}

function importContractMarkdown(contract) {
  return [
    "# Viet Editorial Import Contract",
    "",
    "Status: design only. No import is implemented or run by this task.",
    "",
    "The repo remains the source of truth. Google Sheets and CSVs are review surfaces for Jojo, ChatGPT, and reviewers.",
    "",
    "## Immutable Keys",
    "",
    ...contract.immutableKeys.map((key) => `- \`${key}\``),
    "",
    "## Approval Gate",
    "",
    `A row may be imported only when \`import_approval\` exactly equals \`${contract.approvalValue}\`.`,
    "",
    "Allowed review statuses:",
    "",
    ...contract.allowedReviewStatuses.map((status) => `- \`${status}\``),
    "",
    "## Importable Columns",
    "",
    ...Object.entries(contract.importableColumns).flatMap(([sheet, columns]) => [
      `### ${sheet}`,
      "",
      ...columns.map((column) => `- \`${column}\``),
      "",
    ]),
    "## Rules",
    "",
    ...contract.importRules.map((rule) => `- ${rule}`),
    "",
  ].join("\n");
}

function buildExport() {
  const existingManifest = readJSON(manifestPath);
  const generatedAt = process.env.SPEAKLOCAL_EXPORT_GENERATED_AT || existingManifest?.generatedAt || new Date().toISOString();
  const authoredBundle = readJSON(authoredPagesPath, { pages: [] });
  const authoredByPageID = new Map((authoredBundle.pages ?? []).map((page) => [page.id, page]));
  const authoredByPhraseID = new Map((authoredBundle.pages ?? []).map((page) => [page.phraseID, page]));
  const sourceIndex = buildSourceIndex();
  const canonicalAuditByPageID = loadCanonicalAuditRows();

  const pages = sqliteJSON(`
    SELECT
      pp.id AS page_id,
      pp.phrase_id,
      pp.title,
      pp.english_title,
      pp.summary,
      pp.icon_name,
      pp.tint_name,
      pp.page_renderer,
      pp.completeness_status AS page_completeness_status,
      pp.is_authored,
      p.target_text,
      p.english_text,
      p.pronunciation,
      p.access_tier,
      p.completeness_status AS phrase_completeness_status,
      p.audio_status,
      p.source_path AS phrase_source_path,
      p.source_row_id,
      p.sense_key,
      pct.city_id,
      pct.subcategory_id,
      pct.place_id,
      pct.difficulty,
      pct.page_kind AS city_page_kind,
      pct.place_kind AS city_place_kind,
      pct.content_role AS city_content_role,
      pct.spoken_chunks,
      pct.source_ids AS city_source_ids,
      pct.rationale AS city_rationale,
      cp.vietnamese_name AS city_place_vietnamese,
      cp.english_name AS city_place_english,
      (
        SELECT aa.source_manifest_key
        FROM audio_usage au
        JOIN audio_asset aa ON aa.id = au.audio_asset_id
        WHERE au.target_kind = 'phrase'
          AND au.target_id = p.id
          AND au.is_primary = 1
        LIMIT 1
      ) AS primary_audio_key,
      (
        SELECT ma.id
        FROM missing_audio_audit ma
        WHERE ma.target_kind = 'phrase'
          AND ma.target_id = p.id
        LIMIT 1
      ) AS missing_audio_id
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    LEFT JOIN phrase_city_tag pct ON pct.phrase_id = p.id
    LEFT JOIN city_place cp ON cp.id = pct.place_id
    ORDER BY pp.id;
  `);

  const categories = sqliteJSON(`
    SELECT page_id, category_id, sort_order, source_path
    FROM page_category
    ORDER BY page_id, sort_order, category_id;
  `);
  const categoriesByPage = new Map();
  for (const row of categories) {
    if (!categoriesByPage.has(row.page_id)) categoriesByPage.set(row.page_id, []);
    categoriesByPage.get(row.page_id).push(row);
  }

  const sections = sqliteJSON(`
    SELECT id, page_id, section_key, title, body, presentation, sort_order, source_path
    FROM page_section
    ORDER BY page_id, sort_order, section_key;
  `);
  const sectionsByPage = new Map();
  for (const row of sections) {
    if (!sectionsByPage.has(row.page_id)) sectionsByPage.set(row.page_id, []);
    sectionsByPage.get(row.page_id).push(row);
  }

  const phraseRows = sqliteJSON(`
    SELECT
      ps.page_id,
      ps.id AS section_id,
      ps.section_key,
      ps.title AS section_title,
      psi.id AS item_id,
      psi.sort_order,
      psi.target_id AS target_phrase_id,
      psi.title_override,
      psi.subtitle_override,
      psi.note AS detail_page_id,
      p.target_text,
      p.english_text,
      p.pronunciation,
      p.audio_status,
      pp.id AS target_page_id
    FROM page_section_item psi
    JOIN page_section ps ON ps.id = psi.section_id
    LEFT JOIN phrase p ON p.id = psi.target_id
    LEFT JOIN phrase_page pp ON pp.phrase_id = p.id
    WHERE psi.item_kind = 'phrase'
    ORDER BY ps.page_id, ps.sort_order, psi.sort_order, psi.id;
  `);
  const phraseRowsByPage = new Map();
  for (const row of phraseRows) {
    if (!phraseRowsByPage.has(row.page_id)) phraseRowsByPage.set(row.page_id, []);
    phraseRowsByPage.get(row.page_id).push(row);
  }

  const breakdowns = sqliteJSON(`
    SELECT
      ps.page_id,
      ps.id AS section_id,
      ps.section_key,
      ps.title AS section_title,
      psi.id AS item_id,
      psi.sort_order AS item_sort_order,
      bt.id AS breakdown_token_id,
      bt.token_text,
      bt.english_gloss,
      bt.sort_order AS token_sort_order
    FROM page_section_item psi
    JOIN page_section ps ON ps.id = psi.section_id
    JOIN breakdown_token bt ON bt.id = psi.target_id
    WHERE psi.item_kind = 'breakdown_token'
    ORDER BY ps.page_id, ps.sort_order, bt.sort_order, bt.id;
  `);
  const breakdownsByPage = new Map();
  for (const row of breakdowns) {
    if (!breakdownsByPage.has(row.page_id)) breakdownsByPage.set(row.page_id, []);
    breakdownsByPage.get(row.page_id).push(row);
  }

  const relationships = sqliteJSON(`
    SELECT id, source_kind, source_id, target_kind, target_id, relation_type, reason, display_label, sort_order, source_path
    FROM phrase_relation
    ORDER BY source_id, sort_order, id;
  `);
  const relationshipsByPage = new Map();
  for (const row of relationships) {
    if (!relationshipsByPage.has(row.source_id)) relationshipsByPage.set(row.source_id, []);
    relationshipsByPage.get(row.source_id).push(row);
  }

  const pageRows = [];
  const sectionRows = [];
  const breakdownRows = [];
  const phraseRowRows = [];
  const relationshipRows = [];
  let flaggedPageCount = 0;

  for (const row of pages) {
    const authored = authoredByPageID.get(row.page_id) ?? authoredByPhraseID.get(row.phrase_id);
    const pageSections = sectionsByPage.get(row.page_id) ?? [];
    const pageBreakdowns = breakdownsByPage.get(row.page_id) ?? [];
    const pagePhraseRows = phraseRowsByPage.get(row.page_id) ?? [];
    const pageRelationships = relationshipsByPage.get(row.page_id) ?? [];
    const pageCategoryRows = categoriesByPage.get(row.page_id) ?? [];
    const categoryIDs = pageCategoryRows.map((category) => category.category_id);
    const sourcePath = sourcePathFor(authored, row.phrase_id, row.phrase_source_path, sourceIndex);
    const sourceLane = sourceLaneFor(authored, sourcePath);
    const pageKind = row.city_page_kind || pageKindFrom(authored ?? {}, categoryIDs);
    const placeKind = row.city_place_kind || placeKindFrom(authored ?? {}, categoryIDs);
    const contentRole = row.city_content_role || contentRoleFrom(authored ?? {}, categoryIDs);
    const canonicalAudit = canonicalAuditByPageID.get(row.page_id);
    const flags = auditFlags({
      page: authored ?? { title: row.title, englishTitle: row.english_title, summary: row.summary },
      pageKind,
      categories: categoryIDs,
      sections: pageSections,
      breakdowns: pageBreakdowns,
      phraseRows: pagePhraseRows,
      relationships: pageRelationships,
      canonicalAudit,
    });
    if (flags.flags.length) flaggedPageCount += 1;

    const audioStatus = row.primary_audio_key
      ? "ready"
      : row.missing_audio_id
        ? "planned_missing_audio"
        : row.audio_status;

    pageRows.push([
      row.page_id,
      row.phrase_id,
      sourceLane,
      pageKind,
      placeKind,
      contentRole,
      row.title,
      row.english_title,
      row.target_text,
      row.english_text,
      row.pronunciation,
      row.summary,
      row.access_tier,
      row.page_completeness_status,
      row.phrase_completeness_status,
      audioStatus,
      row.primary_audio_key,
      row.missing_audio_id,
      row.city_id,
      row.subcategory_id,
      row.place_id,
      row.difficulty,
      row.spoken_chunks,
      row.city_source_ids,
      row.city_rationale,
      pipe(categoryIDs),
      sourcePath,
      row.phrase_source_path,
      pipe(pageSections.map((section) => section.source_path)),
      pageSections.length,
      pagePhraseRows.length,
      pageBreakdowns.length,
      pageRelationships.length,
      pageSections.map((section) => section.section_key).join("|"),
      sectionText(pageSections),
      breakdownText(pageBreakdowns),
      phraseRowsText(pagePhraseRows),
      relationshipText(pageRelationships),
      canonicalAudit?.verdict ?? "",
      flags.generic ? "TRUE" : "FALSE",
      flags.placeholderLike ? "TRUE" : "FALSE",
      flags.wrongTemplate ? "TRUE" : "FALSE",
      flags.weakCopy ? "TRUE" : "FALSE",
      flags.flags.join("|"),
      flags.evidence,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "not_started",
      "",
      "",
      "",
    ]);

    for (const section of pageSections) {
      sectionRows.push([
        row.page_id,
        row.phrase_id,
        sourceLane,
        pageKind,
        section.id,
        section.section_key,
        section.sort_order,
        section.title,
        section.body,
        section.presentation,
        section.source_path,
        sourcePath,
        "",
        "",
        "",
        "",
        "not_started",
        "",
        "",
        "",
      ]);
    }

    for (const token of pageBreakdowns) {
      breakdownRows.push([
        row.page_id,
        row.phrase_id,
        sourceLane,
        pageKind,
        token.section_id,
        token.section_key,
        token.breakdown_token_id,
        token.token_sort_order,
        token.token_text,
        token.english_gloss,
        sourcePath,
        "",
        "",
        "",
        "not_started",
        "",
        "",
        "",
      ]);
    }

    for (const phraseRow of pagePhraseRows) {
      phraseRowRows.push([
        row.page_id,
        row.phrase_id,
        sourceLane,
        pageKind,
        phraseRow.section_id,
        phraseRow.section_key,
        phraseRow.item_id,
        phraseRow.sort_order,
        phraseRow.target_phrase_id,
        phraseRow.target_page_id,
        phraseRow.detail_page_id,
        phraseRow.title_override || phraseRow.target_text,
        phraseRow.subtitle_override || phraseRow.english_text,
        phraseRow.pronunciation,
        phraseRow.audio_status,
        sourcePath,
        "",
        "",
        "",
        "",
        "not_started",
        "",
        "",
        "",
      ]);
    }

    for (const relationship of pageRelationships) {
      relationshipRows.push([
        row.page_id,
        row.phrase_id,
        sourceLane,
        pageKind,
        relationship.id,
        relationship.source_kind,
        relationship.source_id,
        relationship.target_kind,
        relationship.target_id,
        relationship.relation_type,
        relationship.display_label,
        relationship.reason,
        relationship.sort_order,
        relationship.source_path,
        sourcePath,
        "",
        "",
        "",
        "",
        "not_started",
        "",
        "",
        "",
      ]);
    }
  }

  const generated = new Map();

  writeCSV("pages.csv", [
    "page_id",
    "phrase_id",
    "source_lane",
    "pageKind",
    "placeKind",
    "contentRole",
    "vietnamese",
    "english",
    "phrase_vietnamese",
    "phrase_english",
    "pronunciation",
    "summary",
    "access_tier",
    "page_completeness_status",
    "phrase_completeness_status",
    "audio_status",
    "audio_key",
    "missing_audio_id",
    "city_id",
    "subcategory_id",
    "place_id",
    "difficulty",
    "spoken_chunks",
    "city_source_ids",
    "source_rationale",
    "category_tags",
    "source_path",
    "generated_phrase_source_path",
    "generated_section_source_paths",
    "section_count",
    "phrase_row_count",
    "breakdown_token_count",
    "relationship_count",
    "section_ids",
    "current_section_copy",
    "breakdown_labels",
    "visible_phrase_rows",
    "related_pages_relationships",
    "canonical_audit_verdict",
    "audit_generic_flag",
    "audit_placeholder_like_flag",
    "audit_wrong_template_flag",
    "audit_weak_copy_flag",
    "audit_flags",
    "audit_evidence",
    "proposed_vietnamese",
    "proposed_english",
    "proposed_pronunciation",
    "proposed_summary",
    "proposed_category_tags",
    "proposed_page_notes",
    "reviewer_notes",
    "review_status",
    "import_approval",
    "approved_by",
    "approved_at",
  ], pageRows, generated);

  writeCSV("sections.csv", [
    "page_id",
    "phrase_id",
    "source_lane",
    "pageKind",
    "section_id",
    "section_key",
    "sort_order",
    "current_section_title",
    "current_section_body",
    "current_presentation",
    "generated_section_source_path",
    "source_path",
    "proposed_section_title",
    "proposed_section_body",
    "proposed_presentation",
    "reviewer_notes",
    "review_status",
    "import_approval",
    "approved_by",
    "approved_at",
  ], sectionRows, generated);

  writeCSV("breakdowns.csv", [
    "page_id",
    "phrase_id",
    "source_lane",
    "pageKind",
    "section_id",
    "section_key",
    "breakdown_token_id",
    "sort_order",
    "current_token_text",
    "current_english_gloss",
    "source_path",
    "proposed_token_text",
    "proposed_english_gloss",
    "reviewer_notes",
    "review_status",
    "import_approval",
    "approved_by",
    "approved_at",
  ], breakdownRows, generated);

  writeCSV("phrase-rows.csv", [
    "page_id",
    "phrase_id",
    "source_lane",
    "pageKind",
    "section_id",
    "section_key",
    "item_id",
    "sort_order",
    "target_phrase_id",
    "target_page_id",
    "detail_page_id",
    "current_row_vietnamese",
    "current_row_english",
    "current_pronunciation",
    "target_audio_status",
    "source_path",
    "proposed_target_phrase_id",
    "proposed_target_page_id",
    "proposed_row_vietnamese",
    "proposed_row_english",
    "review_status",
    "import_approval",
    "approved_by",
    "approved_at",
  ], phraseRowRows, generated);

  writeCSV("relationships.csv", [
    "page_id",
    "phrase_id",
    "source_lane",
    "pageKind",
    "relationship_id",
    "source_kind",
    "source_id",
    "target_kind",
    "target_id",
    "relation_type",
    "display_label",
    "reason",
    "sort_order",
    "generated_relation_source_path",
    "source_path",
    "proposed_target_page_id",
    "proposed_relation_type",
    "proposed_display_label",
    "proposed_reason",
    "review_status",
    "import_approval",
    "approved_by",
    "approved_at",
  ], relationshipRows, generated);

  const contract = importContract(generatedAt);
  generated.set(path.join(outputRoot, "import-contract.json"), `${JSON.stringify(contract, null, 2)}\n`);
  generated.set(path.join(outputRoot, "import-contract.md"), importContractMarkdown(contract));

  const manifest = {
    schemaVersion: "speaklocal.viet.editorial-export.v1",
    taskID,
    generatedAt,
    databasePath: path.relative(repoRoot, databasePath),
    authoredPagesPath: path.relative(repoRoot, authoredPagesPath),
    outputRoot: path.relative(repoRoot, outputRoot),
    rowCounts: {
      pages: pageRows.length,
      sections: sectionRows.length,
      breakdowns: breakdownRows.length,
      phraseRows: phraseRowRows.length,
      relationships: relationshipRows.length,
      flaggedPages: flaggedPageCount,
    },
    pageKindCounts: pageRows.reduce((acc, row) => {
      acc[row[3]] = (acc[row[3]] ?? 0) + 1;
      return acc;
    }, {}),
    sourceLaneCounts: pageRows.reduce((acc, row) => {
      acc[row[2]] = (acc[row[2]] ?? 0) + 1;
      return acc;
    }, {}),
    files: [
      "pages.csv",
      "sections.csv",
      "breakdowns.csv",
      "phrase-rows.csv",
      "relationships.csv",
      "import-contract.md",
      "import-contract.json",
      "manifest.json",
      "README.md",
    ],
    reviewerColumns: [
      "proposed_*",
      "reviewer_notes",
      "review_status",
      "import_approval",
      "approved_by",
      "approved_at",
    ],
  };
  generated.set(path.join(outputRoot, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
  generated.set(path.join(outputRoot, "README.md"), [
    "# Viet Canonical Pages Editorial Export",
    "",
    "This folder is a Google-Sheet-ready editorial staging export for the current Viet canonical page universe.",
    "",
    "The repo remains the source of truth. Do not hand-edit generated runtime resources from Sheet feedback; approved rows should be imported back into source-owned files, then generators should rebuild JSON, SQLite, and practice artifacts.",
    "",
    "## Files",
    "",
    "- `pages.csv`: one row per canonical page, with page/phrase IDs, page kind metadata, current copy, tags, source location, audio state, audit flags, and blank review/import columns.",
    "- `sections.csv`: one row per page section for section-level rewrite review.",
    "- `breakdowns.csv`: one row per breakdown token/label.",
    "- `phrase-rows.csv`: one row per visible phrase row inside sections.",
    "- `relationships.csv`: one row per canonical relation edge.",
    "- `import-contract.md` and `import-contract.json`: design-only import contract for a future approved-row importer.",
    "- `manifest.json`: row counts and export metadata.",
    "",
    "## Current Counts",
    "",
    `- Pages: ${manifest.rowCounts.pages}`,
    `- Sections: ${manifest.rowCounts.sections}`,
    `- Breakdown rows: ${manifest.rowCounts.breakdowns}`,
    `- Visible phrase rows: ${manifest.rowCounts.phraseRows}`,
    `- Relationship rows: ${manifest.rowCounts.relationships}`,
    `- Flagged pages: ${manifest.rowCounts.flaggedPages}`,
    "",
    "## Regenerate",
    "",
    "```bash",
    "node native-ios/scripts/export-viet-editorial-review.js",
    "node native-ios/scripts/export-viet-editorial-review.js --check",
    "```",
    "",
  ].join("\n"));

  return { generated, manifest };
}

function assertMatchesDisk(generated) {
  const mismatches = [];
  for (const [filePath, content] of generated.entries()) {
    const existing = fs.existsSync(filePath) ? fs.readFileSync(filePath, "utf8") : null;
    if (existing !== content) {
      mismatches.push(path.relative(repoRoot, filePath));
    }
  }
  if (mismatches.length) {
    throw new Error(`Editorial export is stale. Regenerate with node native-ios/scripts/export-viet-editorial-review.js\n${mismatches.join("\n")}`);
  }
}

function writeGenerated(generated) {
  fs.mkdirSync(outputRoot, { recursive: true });
  for (const [filePath, content] of generated.entries()) {
    fs.writeFileSync(filePath, content);
  }
}

function main() {
  const { generated, manifest } = buildExport();
  if (checkOnly) {
    assertMatchesDisk(generated);
    console.log(`Editorial export check OK: ${manifest.rowCounts.pages} pages, ${manifest.rowCounts.sections} sections, ${manifest.rowCounts.relationships} relationships`);
    return;
  }
  writeGenerated(generated);
  console.log(`Wrote Viet editorial export: ${manifest.rowCounts.pages} pages, ${manifest.rowCounts.sections} sections, ${manifest.rowCounts.relationships} relationships`);
}

main();
