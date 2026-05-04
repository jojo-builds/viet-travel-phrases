#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const canonicalAuditPath = path.join(repoRoot, "docs", "content-audits", "viet-canonical-content-audit-001", "per-page-audit.jsonl");
const pilotPatchPath = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-canonical-pages",
  "chatgpt-pilot-2026-05-03",
  "SpeakLocal_Vietnam_Editorial_Pilot_Patch_v1.json"
);
const baNaPatchPath = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-canonical-pages",
  "ba-na-hills-journey-v2",
  "SpeakLocal_Ba_Na_Hills_Journey_Patch_v2.json"
);
const outputRoot = path.join(repoRoot, "docs", "editorial-exports", "viet-canonical-pages", "chatgpt-batch-001");
const manifestPath = path.join(outputRoot, "manifest.json");
const schemaManifestPath = path.join(outputRoot, "schema-version.json");
const taskID = "TASK-VIET-CHATGPT-EDITORIAL-BATCH-001";
const batchID = "chatgpt-batch-001";
const schemaVersion = "speaklocal.viet.chatgpt-editorial-batch.v1";
const checkOnly = process.argv.includes("--check");

const spreadsheet = {
  id: "1mxsk9O6kuUhekBWhaNlbKH_n4innteBXtYZ4qmu1SOU",
  title: "SpeakLocal Viet Canonical Pages Editorial Export 2026-05-03 v2",
  url: "https://docs.google.com/spreadsheets/d/1mxsk9O6kuUhekBWhaNlbKH_n4innteBXtYZ4qmu1SOU/edit",
};

const selectedPhraseSpecs = [
  {
    phraseID: "city-hanoi-place-bun-cha-huong-lien",
    pilotPatchID: "EP-001",
    group: "restaurant",
    role: "active_review",
    reason: "Prior hard restaurant page; needs live-interaction model for ordering, drinks, payment, and ride-back support.",
  },
  {
    phraseID: "city-hanoi-place-pho-bat-dan",
    pilotPatchID: "EP-002",
    group: "restaurant",
    role: "active_review",
    reason: "Prior hard restaurant page; needs durable, source-aware traveler tasks without review-style claims.",
  },
  {
    phraseID: "city-hoian-place-cao-lau-city",
    pilotPatchID: "EP-003",
    group: "dish_identity",
    role: "active_review",
    reason: "Remaining unresolved Cao lầu identity page; needs Jojo decision before any canonical title/content import.",
  },
  {
    phraseID: "city-hue-place-bun-bo-city",
    pilotPatchID: "EP-004",
    group: "dish",
    role: "active_review",
    reason: "Prior hard dish page; needs order, spice, ingredient, and diet teaching shape.",
  },
  {
    phraseID: "city-danang-place-ba-na-hills",
    pilotPatchID: "EP-005",
    group: "journey_place",
    role: "reference_completed",
    reason: "Completed Bà Nà Hills journey patch; include as the model example, not as an active re-import target.",
  },
  {
    phraseID: "city-danang-place-dragon-bridge",
    pilotPatchID: "EP-006",
    group: "place_navigation",
    role: "active_review",
    reason: "Prior hard landmark page; needs place navigation and photo/pickup recovery shape.",
  },
  {
    phraseID: "city-danang-place-marble-mountains",
    pilotPatchID: "EP-007",
    group: "place_journey",
    role: "active_review",
    reason: "Prior hard attraction page; needs stable facts and ticket/entrance journey support.",
  },
  {
    phraseID: "city-danang-place-son-tra",
    pilotPatchID: "EP-008",
    group: "place_navigation",
    role: "active_review",
    reason: "Prior hard area page; needs route-area model and exact-stop support.",
  },
  {
    phraseID: "city-danang-place-bach-dang-street",
    pilotPatchID: "EP-009",
    group: "street_pronouncer",
    role: "active_review",
    reason: "Prior hard street page; needs street-name pronouncer and driver-facing linked rows.",
  },
  {
    phraseID: "city-danang-place-nguyen-van-linh-street",
    pilotPatchID: "EP-010",
    group: "street_pronouncer",
    role: "active_review",
    reason: "Prior hard street page; needs confirm-location/drop-off/wrong-place support.",
  },
  {
    phraseID: "city-danang-place-vo-nguyen-giap-street",
    pilotPatchID: "EP-011",
    group: "street_pronouncer",
    role: "active_review",
    reason: "Prior hard beach-side street page; needs driver pickup/drop-off teaching shape.",
  },
  {
    phraseID: "city-danang-go-ba-na-hills",
    pilotPatchID: "EP-012",
    group: "route_ticket",
    role: "active_review",
    reason: "Prior hard route phrase; needs title-preserving support instead of full-sentence canonical rewrite.",
  },
  {
    phraseID: "city-danang-where-ba-na-hills",
    pilotPatchID: "EP-013",
    group: "place_navigation",
    role: "active_review",
    reason: "Prior hard place question; needs journey recovery links while preserving canonical title.",
  },
  {
    phraseID: "city-danang-ticket-marble-mountains",
    pilotPatchID: "EP-014",
    group: "route_ticket",
    role: "active_review",
    reason: "Prior hard ticket phrase; needs title-preserving ticket-counter article support.",
  },
  {
    phraseID: "city-danang-go-dragon-bridge",
    pilotPatchID: "EP-015",
    group: "route_ticket",
    role: "active_review",
    reason: "Prior hard route phrase; needs route support while keeping clipped canonical title.",
  },
  {
    phraseID: "city-danang-near-nguyen-van-linh-street",
    pilotPatchID: "EP-016",
    group: "street_driver",
    role: "active_review",
    reason: "Prior hard street question; needs street pronouncer plus near-here driver flow.",
  },
  {
    phraseID: "acknowledge-da-chao-anh",
    pilotPatchID: "EP-020",
    group: "relationship_politeness",
    role: "active_review",
    reason: "Prior deferred politeness/tone cleanup path for relationship greetings.",
  },
  {
    phraseID: "v500-airp-bord-arri-where-is-the-taxi-counter",
    pilotPatchID: "",
    group: "airport_taxi",
    role: "active_review",
    reason: "High-value first-arrival page; taxi-counter copy often needs better beginner journey structure.",
  },
  {
    phraseID: "v900-airp-bord-arri-can-you-help-me-track-my-bag",
    pilotPatchID: "",
    group: "airport_baggage",
    role: "active_review",
    reason: "High-stress airport problem page; likely needs clear, natural support flow and native-language scrutiny.",
  },
  {
    phraseID: "hotel-9",
    pilotPatchID: "",
    group: "hotel_taxi",
    role: "active_review",
    reason: "Hotel desk taxi page; practical first-day traveler workflow with audio/link expectations.",
  },
  {
    phraseID: "v900-hote-acco-can-you-arrange-a-taxi-for-me",
    pilotPatchID: "",
    group: "hotel_taxi",
    role: "active_review",
    reason: "Longer hotel taxi variant; useful contrast with the shorter beginner version.",
  },
  {
    phraseID: "food-peanut-allergy",
    pilotPatchID: "",
    group: "food_allergy",
    role: "active_review",
    reason: "Food-allergy page; needs concise safety-forward copy without fear framing.",
  },
  {
    phraseID: "v500-food-drin-i-am-allergic-to-shellfish",
    pilotPatchID: "",
    group: "food_allergy",
    role: "active_review",
    reason: "Common seafood allergy phrase; needs ingredient/diet linked-row support.",
  },
  {
    phraseID: "emergency-hospital",
    pilotPatchID: "",
    group: "emergency_help",
    role: "active_review",
    reason: "Emergency hospital navigation; high traveler value and sensitive wording.",
  },
  {
    phraseID: "emergency-3",
    pilotPatchID: "",
    group: "emergency_passport",
    role: "active_review",
    reason: "Lost-passport page; important traveler flow with likely follow-up/support phrases.",
  },
];

const snapshotFiles = [
  "pages",
  "sections",
  "phrase_rows",
  "breakdowns",
  "relationships",
  "renderer_directives",
  "asset_directives",
  "validator_rules",
  "review_notes",
  "schema_version",
];

const patchFiles = [
  "page_patch",
  "section_patch",
  "phrase_row_patch",
  "breakdown_patch",
  "relationship_reorder_patch",
  "renderer_directives_patch",
  "asset_directives_patch",
  "validator_rules_patch",
  "questions_for_jojo",
];

const requiredPatchColumns = [
  "patch_id",
  "page_id",
  "phrase_id",
  "review_status",
  "import_approval",
  "operation",
  "target_id",
  "target_order",
  "current_value",
  "proposed_value",
  "reason_for_change",
  "new_linked_phrase_required",
  "canonical_target_id",
  "audio_policy",
  "asset_policy",
  "validator_rule",
  "jojo_question",
];

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

function readJSON(filePath, fallback = null) {
  if (!fs.existsSync(filePath)) return fallback;
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function readJSONLByPageID(filePath) {
  if (!fs.existsSync(filePath)) return new Map();
  const rows = fs.readFileSync(filePath, "utf8")
    .trim()
    .split(/\n+/)
    .filter(Boolean)
    .map((line) => JSON.parse(line));
  return new Map(rows.map((row) => [row.pageID, row]));
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

function csvCell(value) {
  if (value === null || value === undefined) return "\"\"";
  const text = typeof value === "string" ? value : JSON.stringify(value);
  return `"${text.replace(/"/g, "\"\"").replace(/\r\n/g, "\n").replace(/\r/g, "\n").replace(/\n+/g, " ⏎ ")}"`;
}

function writeCSV(generated, fileName, rows) {
  if (!rows.length) {
    throw new Error(`Cannot write empty CSV ${fileName}`);
  }
  const header = Object.keys(rows[0]);
  const lines = [
    header.map(csvCell).join(","),
    ...rows.map((row) => header.map((column) => csvCell(row[column])).join(",")),
  ];
  generated.set(path.join(outputRoot, `${fileName}.csv`), `${lines.join("\n")}\n`);
}

function writeJSON(generated, fileName, value) {
  generated.set(path.join(outputRoot, `${fileName}.json`), `${JSON.stringify(value, null, 2)}\n`);
}

function toKeyValueRows(value, prefix = "") {
  return Object.entries(value).map(([key, item]) => ({
    key: prefix ? `${prefix}.${key}` : key,
    value: typeof item === "string" ? item : JSON.stringify(item),
  }));
}

function parsePipe(value) {
  return String(value ?? "")
    .split("|")
    .map((item) => item.trim())
    .filter(Boolean);
}

function compactList(values) {
  return [...new Set((values ?? []).map((value) => String(value ?? "").trim()).filter(Boolean))].join("|");
}

function authoredSourceIndex() {
  const authored = readJSON(authoredPagesPath, { pages: [] });
  const byPhraseID = new Map();
  const byPageID = new Map();
  for (const page of authored.pages ?? []) {
    if (page.phraseID) byPhraseID.set(page.phraseID, page);
    if (page.id) byPageID.set(page.id, page);
  }
  return { authored, byPhraseID, byPageID };
}

function pilotPatchIndex() {
  const patch = readJSON(pilotPatchPath, { patches: [] });
  return new Map((patch.patches ?? []).map((row) => [row.patch_id, row]));
}

function baNaReferenceSummary() {
  const patch = readJSON(baNaPatchPath, null);
  if (!patch) return "";
  const sectionOrder = (patch.sections ?? []).map((section) => section.id ?? section.section_id).filter(Boolean).join("|");
  return `Bà Nà v2 reference: page=${patch.page_id ?? patch.pageID ?? ""}; sections=${sectionOrder}`;
}

function buildLookupData() {
  const pages = sqliteJSON(`
    SELECT
      pp.id AS page_id,
      pp.phrase_id,
      pp.title,
      pp.english_title,
      pp.summary,
      pp.icon_name,
      pp.tint_name,
      pp.hero_image_name,
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
      pct.page_kind,
      pct.place_kind,
      pct.content_role,
      pct.spoken_chunks,
      pct.source_ids,
      pct.rationale,
      cp.vietnamese_name AS city_place_vietnamese,
      cp.english_name AS city_place_english,
      cp.place_kind AS city_place_kind,
      cp.content_role AS city_place_content_role,
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
  const sections = sqliteJSON(`
    SELECT id, page_id, section_key, title, body, presentation, sort_order, source_path
    FROM page_section
    ORDER BY page_id, sort_order, section_key;
  `);
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
      pp.id AS target_page_id,
      pp.title AS target_page_title
    FROM page_section_item psi
    JOIN page_section ps ON ps.id = psi.section_id
    LEFT JOIN phrase p ON p.id = psi.target_id
    LEFT JOIN phrase_page pp ON pp.phrase_id = p.id
    WHERE psi.item_kind = 'phrase'
    ORDER BY ps.page_id, ps.sort_order, psi.sort_order, psi.id;
  `);
  const breakdowns = sqliteJSON(`
    SELECT
      ps.page_id,
      ps.id AS section_id,
      ps.section_key,
      ps.title AS section_title,
      psi.id AS item_id,
      psi.sort_order AS item_sort_order,
      bt.id AS breakdown_token_id,
      bt.phrase_id AS breakdown_phrase_id,
      bt.token_text,
      bt.english_gloss,
      bt.sort_order AS token_sort_order
    FROM page_section_item psi
    JOIN page_section ps ON ps.id = psi.section_id
    JOIN breakdown_token bt ON bt.id = psi.target_id
    WHERE psi.item_kind = 'breakdown_token'
    ORDER BY ps.page_id, ps.sort_order, bt.sort_order, bt.id;
  `);
  const relationships = sqliteJSON(`
    SELECT
      pr.id AS relationship_id,
      pr.source_kind,
      pr.source_id,
      pr.target_kind,
      pr.target_id,
      pr.relation_type,
      pr.reason,
      pr.display_label,
      pr.sort_order,
      pr.source_path,
      tp.target_text AS target_phrase_vietnamese,
      tp.english_text AS target_phrase_english,
      tpp.id AS target_page_id
    FROM phrase_relation pr
    LEFT JOIN phrase tp ON tp.id = pr.target_id
    LEFT JOIN phrase_page tpp ON tpp.phrase_id = tp.id OR tpp.id = pr.target_id
    ORDER BY pr.source_id, pr.sort_order, pr.id;
  `);

  const groupBy = (rows, key) => {
    const out = new Map();
    for (const row of rows) {
      if (!out.has(row[key])) out.set(row[key], []);
      out.get(row[key]).push(row);
    }
    return out;
  };

  return {
    pages,
    byPhraseID: new Map(pages.map((row) => [row.phrase_id, row])),
    byPageID: new Map(pages.map((row) => [row.page_id, row])),
    categoriesByPage: groupBy(categories, "page_id"),
    sectionsByPage: groupBy(sections, "page_id"),
    phraseRowsByPage: groupBy(phraseRows, "page_id"),
    breakdownsByPage: groupBy(breakdowns, "page_id"),
    relationshipsByPage: groupBy(relationships, "source_id"),
  };
}

function sourceLaneFor(page, sourcePath) {
  if (page?.tierRole) return page.tierRole;
  if (sourcePath.includes("city-library")) return "city-v1";
  if (sourcePath.includes("practice-expansion")) return "practice-expansion";
  if (sourcePath.includes("catalog-promoted")) return "catalog-promoted";
  if (sourcePath.includes("tier-one")) return "tier1";
  return "unknown";
}

function audioStatusFor(row) {
  if (row.primary_audio_key) return "ready";
  if (row.missing_audio_id) return "planned_missing_audio";
  return row.audio_status ?? "";
}

function auditFlagsFor({ page, sections, phraseRows, breakdowns, audit }) {
  const combined = [
    page.title,
    page.english_title,
    page.summary,
    ...sections.flatMap((section) => [section.title, section.body]),
    ...phraseRows.flatMap((row) => [row.title_override, row.subtitle_override, row.target_text, row.english_text]),
    ...breakdowns.flatMap((row) => [row.token_text, row.english_gloss]),
  ].join("\n");
  const flags = [];
  const checks = [
    ["generic_different_ways", /\bDifferent ways to say\b/i],
    ["generic_answers_traveler_question", /answers the traveler question/i],
    ["generic_short_practice_phrase", /short practice phrase/i],
    ["wrong_template_landmark_quickly", /landmark quickly/i],
    ["wrong_template_city_visit_copy", /Use this page before you visit/i],
    ["internal_watch_out", /Watch out|repair phrase|Understanding Repair|question marker/i],
    ["placeholder_depth_label", /\bbaseline\b|\bsupport\b|\bthin\b|\bfallback\b|\bfiller\b/i],
  ];
  for (const [code, pattern] of checks) {
    if (pattern.test(combined)) flags.push(code);
  }
  for (const issueCode of audit?.issueCodes ?? []) {
    flags.push(`canonical_audit_${issueCode}`);
  }
  return [...new Set(flags)];
}

function selectedPages(lookups, source, auditByPageID, pilotByID) {
  return selectedPhraseSpecs.map((spec, index) => {
    const page = lookups.byPhraseID.get(spec.phraseID);
    if (!page) {
      throw new Error(`Selected phrase ${spec.phraseID} was not found in the current SQLite canonical universe`);
    }
    const sections = lookups.sectionsByPage.get(page.page_id) ?? [];
    const phraseRows = lookups.phraseRowsByPage.get(page.page_id) ?? [];
    const breakdowns = lookups.breakdownsByPage.get(page.page_id) ?? [];
    const relationships = lookups.relationshipsByPage.get(page.page_id) ?? [];
    const categories = lookups.categoriesByPage.get(page.page_id) ?? [];
    const categoryIDs = categories.map((category) => category.category_id);
    const authoredPage = source.byPhraseID.get(page.phrase_id) ?? source.byPageID.get(page.page_id);
    const audit = auditByPageID.get(page.page_id);
    const sourcePath = audit?.sourcePath ?? page.phrase_source_path ?? "";
    const pilot = spec.pilotPatchID ? pilotByID.get(spec.pilotPatchID) : null;
    const flags = auditFlagsFor({ page, sections, phraseRows, breakdowns, audit });
    return {
      ...page,
      selected_order: index + 1,
      batch_id: batchID,
      batch_role: spec.role,
      selection_group: spec.group,
      selection_reason: spec.reason,
      pilot_patch_id: spec.pilotPatchID,
      pilot_page_id: pilot?.page_id ?? "",
      current_page_id_mismatch_from_pilot: pilot?.page_id && pilot.page_id !== page.page_id ? "TRUE" : "FALSE",
      source_lane: sourceLaneFor(authoredPage ?? {}, sourcePath),
      source_path: sourcePath,
      category_tags: compactList(categoryIDs),
      section_count: sections.length,
      phrase_row_count: phraseRows.length,
      breakdown_count: breakdowns.length,
      relationship_count: relationships.length,
      section_ids: compactList(sections.map((section) => section.section_key)),
      audit_verdict: audit?.verdict ?? "",
      audit_flags: compactList(flags),
      audit_issue_codes: compactList(audit?.issueCodes ?? []),
      audio_status_resolved: audioStatusFor(page),
      authored_page_id: authoredPage?.id ?? "",
      authored_tier_role: authoredPage?.tierRole ?? "",
      ba_na_reference_summary: spec.phraseID === "city-danang-place-ba-na-hills" ? baNaReferenceSummary() : "",
    };
  });
}

function buildPageRows(pages) {
  return pages.map((page) => ({
    selected_order: page.selected_order,
    batch_id: page.batch_id,
    batch_role: page.batch_role,
    selection_group: page.selection_group,
    selection_reason: page.selection_reason,
    pilot_patch_id: page.pilot_patch_id,
    pilot_page_id: page.pilot_page_id,
    current_page_id_mismatch_from_pilot: page.current_page_id_mismatch_from_pilot,
    page_id: page.page_id,
    phrase_id: page.phrase_id,
    vietnamese_title: page.title,
    english_title: page.english_title,
    phrase_vietnamese: page.target_text,
    phrase_english: page.english_text,
    pronunciation: page.pronunciation,
    summary: page.summary,
    pageKind: page.page_kind || "",
    placeKind: page.place_kind || page.city_place_kind || "",
    contentRole: page.content_role || page.city_place_content_role || "",
    city_id: page.city_id || "",
    subcategory_id: page.subcategory_id || "",
    place_id: page.place_id || "",
    city_place_vietnamese: page.city_place_vietnamese || "",
    city_place_english: page.city_place_english || "",
    difficulty: page.difficulty || "",
    spoken_chunks: page.spoken_chunks || "",
    source_ids: page.source_ids || "",
    rationale: page.rationale || "",
    category_tags: page.category_tags,
    page_renderer: page.page_renderer,
    hero_image_name: page.hero_image_name || "",
    icon_name: page.icon_name,
    tint_name: page.tint_name,
    access_tier: page.access_tier,
    page_completeness_status: page.page_completeness_status,
    phrase_completeness_status: page.phrase_completeness_status,
    audio_status: page.audio_status_resolved,
    audio_key: page.primary_audio_key || "",
    missing_audio_id: page.missing_audio_id || "",
    source_lane: page.source_lane,
    source_path: page.source_path,
    generated_phrase_source_path: page.phrase_source_path || "",
    source_row_id: page.source_row_id || "",
    sense_key: page.sense_key || "",
    section_count: page.section_count,
    phrase_row_count: page.phrase_row_count,
    breakdown_count: page.breakdown_count,
    relationship_count: page.relationship_count,
    section_ids: page.section_ids,
    audit_verdict: page.audit_verdict,
    audit_flags: page.audit_flags,
    audit_issue_codes: page.audit_issue_codes,
    ba_na_reference_summary: page.ba_na_reference_summary,
    reviewer_notes: "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
  }));
}

function buildSectionRows(pages, lookups) {
  return pages.flatMap((page) => (lookups.sectionsByPage.get(page.page_id) ?? []).map((section) => ({
    selected_order: page.selected_order,
    batch_role: page.batch_role,
    selection_group: page.selection_group,
    page_id: page.page_id,
    phrase_id: page.phrase_id,
    section_id: section.id,
    section_key: section.section_key,
    sort_order: section.sort_order,
    current_section_title: section.title,
    current_section_body: section.body,
    current_presentation: section.presentation,
    generated_section_source_path: section.source_path,
    source_path: page.source_path,
    linked_phrase_row_count: (lookups.phraseRowsByPage.get(page.page_id) ?? []).filter((row) => row.section_id === section.id).length,
    breakdown_row_count: (lookups.breakdownsByPage.get(page.page_id) ?? []).filter((row) => row.section_id === section.id).length,
    reviewer_notes: "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
  })));
}

function buildPhraseRows(pages, lookups) {
  return pages.flatMap((page) => (lookups.phraseRowsByPage.get(page.page_id) ?? []).map((row) => ({
    selected_order: page.selected_order,
    batch_role: page.batch_role,
    selection_group: page.selection_group,
    page_id: page.page_id,
    phrase_id: page.phrase_id,
    section_id: row.section_id,
    section_key: row.section_key,
    item_id: row.item_id,
    sort_order: row.sort_order,
    target_phrase_id: row.target_phrase_id || "",
    target_page_id: row.target_page_id || "",
    target_resolution_status: row.target_page_id ? "resolved_one_canonical_page" : "unresolved_target",
    detail_page_id: row.detail_page_id || "",
    current_row_vietnamese: row.title_override || row.target_text || "",
    current_row_english: row.subtitle_override || row.english_text || "",
    target_phrase_vietnamese: row.target_text || "",
    target_phrase_english: row.english_text || "",
    pronunciation: row.pronunciation || "",
    target_audio_status: row.audio_status || "",
    source_path: page.source_path,
    reviewer_notes: "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
  })));
}

function buildBreakdownRows(pages, lookups) {
  return pages.flatMap((page) => (lookups.breakdownsByPage.get(page.page_id) ?? []).map((row) => ({
    selected_order: page.selected_order,
    batch_role: page.batch_role,
    selection_group: page.selection_group,
    page_id: page.page_id,
    phrase_id: page.phrase_id,
    section_id: row.section_id,
    section_key: row.section_key,
    item_id: row.item_id,
    breakdown_token_id: row.breakdown_token_id,
    sort_order: row.token_sort_order,
    current_token_text: row.token_text,
    current_english_gloss: row.english_gloss,
    source_path: page.source_path,
    reviewer_notes: "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
  })));
}

function buildRelationshipRows(pages, lookups) {
  return pages.flatMap((page) => (lookups.relationshipsByPage.get(page.page_id) ?? []).map((row) => ({
    selected_order: page.selected_order,
    batch_role: page.batch_role,
    selection_group: page.selection_group,
    page_id: page.page_id,
    phrase_id: page.phrase_id,
    relationship_id: row.relationship_id,
    source_kind: row.source_kind,
    source_id: row.source_id,
    target_kind: row.target_kind,
    target_id: row.target_id,
    target_page_id: row.target_page_id || "",
    target_resolution_status: row.target_page_id ? "resolved_one_canonical_page" : "unresolved_or_non_phrase_target",
    target_vietnamese: row.target_phrase_vietnamese || "",
    target_english: row.target_phrase_english || "",
    relation_type: row.relation_type,
    display_label: row.display_label || "",
    reason: row.reason,
    sort_order: row.sort_order,
    generated_relation_source_path: row.source_path,
    source_path: page.source_path,
    reviewer_notes: "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
  })));
}

function buildRendererDirectiveRows(pages, lookups) {
  return pages.map((page) => {
    const sections = lookups.sectionsByPage.get(page.page_id) ?? [];
    const presentations = compactList(sections.map((section) => `${section.section_key}:${section.presentation}`));
    return {
      selected_order: page.selected_order,
      batch_role: page.batch_role,
      selection_group: page.selection_group,
      page_id: page.page_id,
      phrase_id: page.phrase_id,
      pageKind: page.page_kind || "",
      placeKind: page.place_kind || "",
      contentRole: page.content_role || "",
      current_page_renderer: page.page_renderer,
      current_hero_image_name: page.hero_image_name || "",
      current_hero_behavior: page.hero_image_name ? "page_specific_hero_image" : "default_language_masthead",
      current_section_presentations: presentations,
      current_missing_audio_policy: "ready audio uses speaker.wave.2.fill; planned/missing audio uses disabled speaker.slash.fill with Audio not available yet",
      current_self_row_policy: "self rows should not show a chevron; linked rows resolve to exactly one canonical page",
      proposed_renderer_directive: "",
      proposed_section_order: "",
      proposed_suppressed_sections: "",
      reviewer_notes: "",
      review_status: "REVIEW_ONLY",
      import_approval: "REVIEW_ONLY",
    };
  });
}

function buildAssetDirectiveRows(pages) {
  return pages.map((page) => ({
    selected_order: page.selected_order,
    batch_role: page.batch_role,
    selection_group: page.selection_group,
    page_id: page.page_id,
    phrase_id: page.phrase_id,
    current_hero_image_name: page.hero_image_name || "",
    current_asset_status: page.hero_image_name ? "asset_metadata_present" : "default_app_hero",
    current_license_status: page.hero_image_name === "HeroBaNaHills"
      ? "documented in ba-na-hills-journey-v2/hero-image-attribution.md"
      : "",
    desired_asset_type: page.page_kind === "restaurant"
      ? "durable place/restaurant visual or default if unsourced"
      : page.page_kind === "dish"
        ? "dish visual only if production-quality and source-safe"
        : page.place_kind
          ? "place-specific visual only if production-quality and source-safe"
          : "",
    proposed_asset_policy: "",
    proposed_hero_image_name: "",
    proposed_license_or_source_note: "",
    reviewer_notes: "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
  }));
}

function buildValidatorRuleRows() {
  const rows = [
    ["batch_contract", "Patch files must preserve required columns and default to REVIEW_ONLY until Jojo approval."],
    ["canonical_identity", "Patch rows may not change page_id or phrase_id unless a separate explicit source-owned canonical-row proposal exists."],
    ["no_import_this_task", "This batch may not contain APPROVED_FOR_IMPORT values at creation time."],
    ["linked_rows", "Every visible linked row proposed later must resolve to exactly one canonical page or ask Jojo a question."],
    ["page_kind_fit", "Place, restaurant, dish, street, route, and relationship/person pages need page-kind-aware copy and section shape."],
    ["proper_names", "Proper names must not get fake literal breakdowns; use name recognition when no reliable simple translation exists."],
    ["volatile_facts", "No hours, prices, schedules, awards, best claims, or current policy claims without durable source evidence."],
    ["audio_policy", "No audio generation; exact audio reuse first, otherwise planned missing audio with disabled speaker state."],
    ["anti_internal_copy", "No user-facing AI/editorial/generator/validator/internal terminology."],
    ["anti_dense_text", "Avoid long runs of text-only sections; phrase rows/breakdowns should create learning interaction."],
  ];
  return rows.map(([ruleID, currentRule], index) => ({
    rule_id: ruleID,
    sort_order: index + 1,
    scope: "chatgpt_batch_001_and_future_import",
    current_rule: currentRule,
    proposed_validator_rule: "",
    proposed_failure_message: "",
    reviewer_notes: "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
  }));
}

function buildReviewNoteRows(pages) {
  return pages.map((page) => ({
    selected_order: page.selected_order,
    batch_role: page.batch_role,
    selection_group: page.selection_group,
    page_id: page.page_id,
    phrase_id: page.phrase_id,
    vietnamese_title: page.title,
    english_title: page.english_title,
    selection_reason: page.selection_reason,
    known_context: page.ba_na_reference_summary || (page.pilot_patch_id ? `Prior pilot hard row ${page.pilot_patch_id}` : "Selected as high-value first-time traveler page."),
    audit_flags: page.audit_flags,
    current_page_id_mismatch_from_pilot: page.current_page_id_mismatch_from_pilot,
    suggested_chatgpt_focus: page.batch_role === "reference_completed"
      ? "Read as a model for journey-page structure; do not propose re-import unless Jojo explicitly asks."
      : "Fill exact patch rows or ask Jojo a precise question; do not write vague notes.",
    screenshot_or_artifact_pointer: page.phrase_id === "city-danang-place-ba-na-hills"
      ? "docs/task-results/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001.md"
      : "",
    reviewer_notes: "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
  }));
}

function patchSkeleton(idPrefix, rows, mapper) {
  return rows.map((row, index) => ({
    patch_id: `B001-${idPrefix}-${String(index + 1).padStart(3, "0")}`,
    page_id: row.page_id ?? "",
    phrase_id: row.phrase_id ?? "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
    operation: row.batch_role === "reference_completed" ? "REFERENCE_ONLY" : "NO_OP_REVIEW_ONLY",
    target_id: mapper.targetID(row),
    target_order: mapper.targetOrder(row),
    current_value: mapper.currentValue(row),
    proposed_value: "",
    reason_for_change: "",
    new_linked_phrase_required: "",
    canonical_target_id: mapper.canonicalTargetID ? mapper.canonicalTargetID(row) : "",
    audio_policy: "NO_AUDIO_GENERATION_REUSE_OR_QUEUE",
    asset_policy: "",
    validator_rule: "",
    jojo_question: "",
  }));
}

function buildPatchRows({ pages, sections, phraseRows, breakdowns, relationships, rendererDirectives, assetDirectives, validatorRules }) {
  const pagePatch = patchSkeleton("PAGE", pages, {
    targetID: (row) => row.page_id,
    targetOrder: (row) => row.selected_order,
    currentValue: (row) => JSON.stringify({
      vietnamese_title: row.vietnamese_title,
      english_title: row.english_title,
      summary: row.summary,
      pageKind: row.pageKind,
      hero_image_name: row.hero_image_name,
    }),
  });
  const sectionPatch = patchSkeleton("SEC", sections, {
    targetID: (row) => row.section_id,
    targetOrder: (row) => row.sort_order,
    currentValue: (row) => JSON.stringify({
      section_key: row.section_key,
      title: row.current_section_title,
      body: row.current_section_body,
      presentation: row.current_presentation,
    }),
  });
  const phraseRowPatch = patchSkeleton("ROW", phraseRows, {
    targetID: (row) => row.item_id,
    targetOrder: (row) => row.sort_order,
    currentValue: (row) => JSON.stringify({
      section_key: row.section_key,
      target_phrase_id: row.target_phrase_id,
      target_page_id: row.target_page_id,
      vietnamese: row.current_row_vietnamese,
      english: row.current_row_english,
    }),
    canonicalTargetID: (row) => row.target_page_id,
  });
  const breakdownPatch = patchSkeleton("BRK", breakdowns, {
    targetID: (row) => row.breakdown_token_id,
    targetOrder: (row) => row.sort_order,
    currentValue: (row) => `${row.current_token_text} -> ${row.current_english_gloss}`,
  });
  const relationshipPatch = patchSkeleton("REL", relationships, {
    targetID: (row) => row.relationship_id,
    targetOrder: (row) => row.sort_order,
    currentValue: (row) => JSON.stringify({
      target_id: row.target_id,
      target_page_id: row.target_page_id,
      relation_type: row.relation_type,
      display_label: row.display_label,
      reason: row.reason,
    }),
    canonicalTargetID: (row) => row.target_page_id,
  });
  const rendererPatch = patchSkeleton("REN", rendererDirectives, {
    targetID: (row) => row.page_id,
    targetOrder: (row) => row.selected_order,
    currentValue: (row) => JSON.stringify({
      renderer: row.current_page_renderer,
      hero: row.current_hero_behavior,
      presentations: row.current_section_presentations,
    }),
  });
  const assetPatch = patchSkeleton("AST", assetDirectives, {
    targetID: (row) => row.page_id,
    targetOrder: (row) => row.selected_order,
    currentValue: (row) => JSON.stringify({
      current_hero_image_name: row.current_hero_image_name,
      current_asset_status: row.current_asset_status,
      current_license_status: row.current_license_status,
    }),
  }).map((row) => ({ ...row, asset_policy: "NO_IMAGE_GENERATION_IN_BATCH_001" }));
  const validatorPatch = validatorRules.map((row, index) => ({
    patch_id: `B001-VAL-${String(index + 1).padStart(3, "0")}`,
    page_id: "",
    phrase_id: "",
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
    operation: "NO_OP_REVIEW_ONLY",
    target_id: row.rule_id,
    target_order: row.sort_order,
    current_value: row.current_rule,
    proposed_value: "",
    reason_for_change: "",
    new_linked_phrase_required: "",
    canonical_target_id: "",
    audio_policy: "",
    asset_policy: "",
    validator_rule: row.rule_id,
    jojo_question: "",
  }));
  const questions = pages.map((row, index) => ({
    patch_id: `B001-Q-${String(index + 1).padStart(3, "0")}`,
    page_id: row.page_id,
    phrase_id: row.phrase_id,
    review_status: "REVIEW_ONLY",
    import_approval: "REVIEW_ONLY",
    operation: "QUESTION_ONLY",
    target_id: row.page_id,
    target_order: row.selected_order,
    current_value: row.selection_reason,
    proposed_value: "",
    reason_for_change: "",
    new_linked_phrase_required: "",
    canonical_target_id: "",
    audio_policy: "",
    asset_policy: "",
    validator_rule: "",
    jojo_question: "",
  }));
  return {
    page_patch: pagePatch,
    section_patch: sectionPatch,
    phrase_row_patch: phraseRowPatch,
    breakdown_patch: breakdownPatch,
    relationship_reorder_patch: relationshipPatch,
    renderer_directives_patch: rendererPatch,
    asset_directives_patch: assetPatch,
    validator_rules_patch: validatorPatch,
    questions_for_jojo: questions,
  };
}

function buildSchemaManifest(rowCounts, generatedAt, backingSpreadsheet) {
  return {
    schemaVersion,
    taskID,
    batchID,
    generatedAt,
    status: "editorial_packet_only_no_import",
    spreadsheet,
    backingSpreadsheet,
    acceptedSteers: [
      "Use batch_001_* tabs in the existing Google Sheet and do not overwrite old snapshot tabs.",
      "Mirror the Sheet-ready packet back to repo CSV/JSON.",
      "Default all patch rows to REVIEW_ONLY.",
      "Include known hard pages from the prior editorial pilot.",
      "Mark Bà Nà Hills as the completed model example/reference.",
      "Add a schema/version manifest for future batches.",
    ],
    selectedPageTarget: 25,
    requiredHardPhraseIDs: selectedPhraseSpecs.slice(0, 17).map((row) => row.phraseID),
    referencePhraseIDs: ["city-danang-place-ba-na-hills"],
    reviewStatusDefault: "REVIEW_ONLY",
    importApprovalDefault: "REVIEW_ONLY",
    importApprovalValueForFutureTasks: "APPROVED_FOR_IMPORT",
    requiredPatchColumns,
    snapshotFiles,
    patchFiles,
    sheetTabs: [...snapshotFiles, ...patchFiles].map((name) => `batch_001_${name}`),
    rowCounts,
    boundaries: [
      "Do not author/import final listing copy in this task.",
      "Do not create new canonical pages.",
      "Do not generate or add audio/images.",
      "Do not touch native-ios/App/**.",
      "Do not touch native-ios/Resources/Audio/**.",
      "Do not modify generated Viet runtime resources.",
    ],
  };
}

function buildPromptMarkdown(schema) {
  return [
    "# SpeakLocal Viet ChatGPT Editorial Batch 001 Prompt",
    "",
    "You are filling an editorial patch packet for SpeakLocal Vietnam canonical listing pages.",
    "",
    "## Job",
    "",
    "- Read the `batch_001_*` snapshot tabs and fill exact patch rows only.",
    "- Do not rewrite outside the patch templates.",
    "- Do not use vague notes where a structured patch row is possible.",
    "- Do not write `consider`, `maybe`, or `could` in patch rows. Propose exact content or ask Jojo a direct question.",
    "- Keep every user-facing line for first-time travelers, beginners, offline use, and real travel confidence.",
    "- Keep the phrase/action as the hero, not blog copy, review copy, or Yelp-style venue prose.",
    "",
    "## Content Rules",
    "",
    "- Do not mention AI, ChatGPT, editorial process, validators, generators, source lanes, page models, or internal terminology in user-facing copy.",
    "- Do not invent volatile facts: prices, hours, schedules, wait times, current awards, current policies, rankings, or `best` claims.",
    "- Use stable facts only when the source packet gives enough confidence. Otherwise write a row in `questions_for_jojo`.",
    "- Preserve canonical `page_id` and `phrase_id` unless proposing an explicit new source-owned canonical row in the appropriate patch sheet.",
    "- Proper names should not receive fake literal breakdowns. Use `name recognition` or a precise sourced meaning.",
    "- No new audio is generated. Use `audio_policy` to mark exact reuse or planned missing audio.",
    "- Default all proposed rows to `REVIEW_ONLY` until Jojo approves them.",
    "",
    "## What To Fill",
    "",
    "- Use `page_patch` for page-level metadata or hero/summary proposals.",
    "- Use `section_patch` for section title/body/presentation proposals.",
    "- Use `phrase_row_patch` for visible row additions, removals, replacements, promotion, or demotion.",
    "- Use `breakdown_patch` for token/gloss replacement.",
    "- Use `relationship_reorder_patch` for Explore next and graph-order changes.",
    "- Use `renderer_directives_patch`, `asset_directives_patch`, and `validator_rules_patch` only when the page needs behavior, asset, or validation instructions.",
    "- Use `questions_for_jojo` for product, factual, canonical-title, or native-language uncertainty.",
    "",
    "## Reference Model",
    "",
    "Bà Nà Hills is included as a completed journey-page reference. Read it as a model for page depth and section flow; do not re-import it unless Jojo explicitly asks.",
    "",
    "## Import Contract",
    "",
    `Future Codex import may import only rows where \`import_approval\` exactly equals \`${schema.importApprovalValueForFutureTasks}\`.`,
    "All other rows must remain staging-only.",
    "",
  ].join("\n");
}

function buildImportReadme(schema) {
  return [
    "# ChatGPT Batch 001 Import README",
    "",
    "This folder is an editorial staging packet. It is not a source import and it does not change app content by itself.",
    "",
    "## Later Import Flow",
    "",
    "1. Jojo sends the packet or Google Sheet tabs to ChatGPT 5.5 Pro.",
    "2. ChatGPT fills exact patch rows and keeps unresolved questions in `questions_for_jojo`.",
    "3. If ChatGPT edits the Google Sheet, Codex exports the versioned `batch_001_*` tabs back into this repo packet.",
    "4. Jojo approves a subset by setting `import_approval` to `APPROVED_FOR_IMPORT` in a future task.",
    "5. Codex runs a dry-run import against only explicit approvals.",
    "6. Codex validates no unresolved targets, no duplicate canonical pages, no internal/meta copy, no wrong-template leakage, and no unapproved import rows.",
    "7. Codex writes source-owned files only, then regenerates and validates generated JSON, SQLite, and practice resources.",
    "",
    "## Non-Import Defaults",
    "",
    "- `review_status` defaults to `REVIEW_ONLY`.",
    "- `import_approval` defaults to `REVIEW_ONLY`.",
    "- Bà Nà Hills is a completed reference page for this batch.",
    "- Audio/image generation is outside this batch.",
    "",
    "## Google Sheet",
    "",
    `- Spreadsheet: ${schema.spreadsheet.url}`,
    schema.backingSpreadsheet?.url ? `- Batch backing spreadsheet: ${schema.backingSpreadsheet.url}` : "",
    "- Old snapshot tabs must remain untouched.",
    "- Batch tabs use the `batch_001_*` prefix.",
    "",
  ].join("\n");
}

function buildReadme(schema, pages) {
  return [
    "# Viet ChatGPT Editorial Batch 001",
    "",
    "This packet gives ChatGPT 5.5 Pro enough current page context to fill deterministic editorial patch rows later.",
    "",
    "The repo remains the source of truth. This batch does not import content, create pages, generate audio/images, or touch native UI.",
    "",
    "## Selected Pages",
    "",
    ...pages.map((page) => `- ${page.selected_order}. \`${page.page_id}\` / \`${page.phrase_id}\` - ${page.title} (${page.selection_group}, ${page.batch_role})`),
    "",
    "## Files",
    "",
    ...schema.snapshotFiles.map((file) => `- \`${file}.csv\` and \`${file}.json\``),
    ...schema.patchFiles.map((file) => `- \`${file}.csv\` and \`${file}.json\``),
    "- `CHATGPT_PROMPT.md`",
    "- `IMPORT_README.md`",
    "- `manifest.json`",
    "- `schema-version.json`",
    "",
    "## Regenerate",
    "",
    "```bash",
    "node native-ios/scripts/export-viet-chatgpt-editorial-batch.js",
    "node native-ios/scripts/validate-viet-chatgpt-editorial-batch.js",
    "```",
    "",
  ].join("\n");
}

function sheetCSVPayloadRows(files) {
  return Object.entries(files).map(([name, rows]) => ({
    tab_name: `batch_001_${name}`,
    source_csv: `${name}.csv`,
    row_count: rows.length,
    column_count: rows.length ? Object.keys(rows[0]).length : 0,
    purpose: patchFiles.includes(name) ? "patch_template" : "source_snapshot",
  }));
}

function buildExport() {
  const existingManifest = readJSON(manifestPath, null);
  const existingSchema = readJSON(schemaManifestPath, null);
  const generatedAt = process.env.SPEAKLOCAL_BATCH_001_GENERATED_AT
    || existingManifest?.generatedAt
    || existingSchema?.generatedAt
    || new Date().toISOString();
  const backingSpreadsheet = {
    id: process.env.SPEAKLOCAL_BATCH_001_BACKING_SPREADSHEET_ID
      || existingManifest?.googleSheetBackingSpreadsheet?.id
      || existingSchema?.backingSpreadsheet?.id
      || "",
    url: process.env.SPEAKLOCAL_BATCH_001_BACKING_SPREADSHEET_URL
      || existingManifest?.googleSheetBackingSpreadsheet?.url
      || existingSchema?.backingSpreadsheet?.url
      || "",
    title: process.env.SPEAKLOCAL_BATCH_001_BACKING_SPREADSHEET_TITLE
      || existingManifest?.googleSheetBackingSpreadsheet?.title
      || existingSchema?.backingSpreadsheet?.title
      || "",
  };
  const lookups = buildLookupData();
  const source = authoredSourceIndex();
  const auditByPageID = readJSONLByPageID(canonicalAuditPath);
  const pilotByID = pilotPatchIndex();
  const selected = selectedPages(lookups, source, auditByPageID, pilotByID);

  const pages = buildPageRows(selected);
  const sections = buildSectionRows(selected, lookups);
  const phraseRows = buildPhraseRows(selected, lookups);
  const breakdowns = buildBreakdownRows(selected, lookups);
  const relationships = buildRelationshipRows(selected, lookups);
  const rendererDirectives = buildRendererDirectiveRows(selected, lookups);
  const assetDirectives = buildAssetDirectiveRows(selected);
  const validatorRules = buildValidatorRuleRows();
  const reviewNotes = buildReviewNoteRows(selected);

  const files = {
    pages,
    sections,
    phrase_rows: phraseRows,
    breakdowns,
    relationships,
    renderer_directives: rendererDirectives,
    asset_directives: assetDirectives,
    validator_rules: validatorRules,
    review_notes: reviewNotes,
  };

  const patchRows = buildPatchRows({
    pages,
    sections,
    phraseRows,
    breakdowns,
    relationships,
    rendererDirectives,
    assetDirectives,
    validatorRules,
  });
  Object.assign(files, patchRows);

  const rowCounts = Object.fromEntries(Object.entries(files).map(([name, rows]) => [name, rows.length]));
  const schema = buildSchemaManifest(rowCounts, generatedAt, backingSpreadsheet);
  const schemaRows = toKeyValueRows(schema);
  files.schema_version = schemaRows;

  const generated = new Map();
  for (const [name, rows] of Object.entries(files)) {
    writeCSV(generated, name, rows);
    writeJSON(generated, name, rows);
  }
  writeJSON(generated, "schema-version", schema);

  const manifest = {
    schemaVersion,
    taskID,
    batchID,
    generatedAt: schema.generatedAt,
    outputRoot: path.relative(repoRoot, outputRoot),
    spreadsheet,
    googleSheetBackingSpreadsheet: backingSpreadsheet,
    selectedPageCount: pages.length,
    selectedPages: pages.map((page) => ({
      selected_order: page.selected_order,
      page_id: page.page_id,
      phrase_id: page.phrase_id,
      title: page.vietnamese_title,
      english: page.english_title,
      batch_role: page.batch_role,
      selection_group: page.selection_group,
      pilot_patch_id: page.pilot_patch_id,
      reason: page.selection_reason,
    })),
    rowCounts: {
      ...rowCounts,
      schema_version: schemaRows.length,
    },
    files: [
      ...Object.keys(files).flatMap((name) => [`${name}.csv`, `${name}.json`]),
      "schema-version.json",
      "README.md",
      "CHATGPT_PROMPT.md",
      "IMPORT_README.md",
      "manifest.json",
      "sheet-tabs-manifest.json",
    ],
    requiredPatchColumns,
    sheetTabs: schema.sheetTabs,
    boundaries: schema.boundaries,
  };
  writeJSON(generated, "manifest", manifest);
  writeJSON(generated, "sheet-tabs-manifest", {
    schemaVersion,
    taskID,
    batchID,
    spreadsheet,
    tabs: sheetCSVPayloadRows(files),
  });
  generated.set(path.join(outputRoot, "README.md"), buildReadme(schema, pages));
  generated.set(path.join(outputRoot, "CHATGPT_PROMPT.md"), buildPromptMarkdown(schema));
  generated.set(path.join(outputRoot, "IMPORT_README.md"), buildImportReadme(schema));

  return { generated, manifest };
}

function writeGenerated(generated) {
  fs.mkdirSync(outputRoot, { recursive: true });
  for (const [filePath, content] of generated.entries()) {
    fs.writeFileSync(filePath, content);
  }
}

function assertMatchesDisk(generated) {
  const stale = [];
  for (const [filePath, content] of generated.entries()) {
    const current = fs.existsSync(filePath) ? fs.readFileSync(filePath, "utf8") : null;
    if (current !== content) stale.push(path.relative(repoRoot, filePath));
  }
  if (stale.length) {
    throw new Error(`ChatGPT editorial batch packet is stale. Regenerate with node native-ios/scripts/export-viet-chatgpt-editorial-batch.js\n${stale.join("\n")}`);
  }
}

function main() {
  const { generated, manifest } = buildExport();
  if (checkOnly) {
    assertMatchesDisk(generated);
    console.log(`ChatGPT editorial batch check OK: ${manifest.selectedPageCount} pages, ${manifest.rowCounts.sections} sections, ${manifest.rowCounts.phrase_rows} phrase rows`);
    return;
  }
  writeGenerated(generated);
  console.log(`Wrote ${batchID}: ${manifest.selectedPageCount} pages, ${manifest.rowCounts.sections} sections, ${manifest.rowCounts.phrase_rows} phrase rows`);
}

main();
