#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const databasePath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet.sqlite");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const reportPath = path.join(nativeRoot, "Resources", "LanguagePacks", "viet", "speaklocal-viet-report.json");
const outputRoot = path.join(repoRoot, "docs", "content-audits", "viet-canonical-content-audit-001");
const taskID = "TASK-VIET-CANONICAL-CONTENT-AUDIT-001";
const baNaJourneyPageID = "viet-phrase-city-danang-place-ba-na-hills";

const requiredSectionKeys = new Set([
  "at-glance",
  "breakdown",
  "when-to-use",
  "good-to-know",
]);

const learnerFacingBannedPatterns = [
  { id: "watch_out", pattern: /Watch out/i, severity: "must_fix" },
  { id: "repair_phrase", pattern: /repair phrase/i, severity: "must_fix" },
  { id: "understanding_repair", pattern: /Understanding Repair/i, severity: "must_fix" },
  { id: "different_ways", pattern: /\bDifferent ways\b/i, severity: "must_fix" },
  { id: "question_marker", pattern: /question marker/i, severity: "must_fix" },
  { id: "baseline_label", pattern: /\bbaseline\b/i, severity: "must_fix" },
  { id: "support_label", pattern: /\bsupport\b/i, severity: "must_fix" },
  { id: "thin_label", pattern: /\bthin\b/i, severity: "must_fix" },
  { id: "fallback_label", pattern: /\bfallback\b/i, severity: "must_fix" },
  { id: "filler_label", pattern: /\bfiller\b/i, severity: "must_fix" },
];

const patternHeavyCopy = [
  { id: "answers_traveler_question", pattern: /answers the traveler question/i },
  { id: "short_practice_phrase", pattern: /short practice phrase/i },
  { id: "keeps_sentence_direct", pattern: /keeps the sentence direct/i },
  { id: "clear_action_generic", pattern: /clear action/i },
  { id: "main_thing_understood", pattern: /main thing you need understood/i },
  { id: "built_for_quick_recognition", pattern: /built for quick recognition/i },
  { id: "beyond_one_memorized_line", pattern: /beyond one memorized line/i },
  { id: "stay_same_travel_lane", pattern: /Stay in the same travel lane/i },
  { id: "generic_context_object", pattern: /phone, ticket, item, or destination/i },
  { id: "small_task_generic", pattern: /small task/i },
  { id: "helps_you_handle", pattern: /helps you handle/i },
  { id: "keep_phrase_tied", pattern: /keep the phrase tied to/i },
  { id: "show_thing_connected", pattern: /show the thing connected to/i },
  { id: "show_generic_need", pattern: /Show the document, symptom, location, or item connected to the need/i },
  { id: "generic_connected_need", pattern: /document, symptom, location, or item connected to the need/i },
  { id: "generic_doc_symptom_place_item", pattern: /putting the exact document, symptom, place, or item into the first sentence/i },
  { id: "generic_proof_photo_map", pattern: /Keep the related proof, photo, room number, receipt, or map location visible/i },
  { id: "generic_document_handoff", pattern: /request for the document, a staff handoff, or a clear next action/i },
  { id: "generic_document_problem_place", pattern: /specific document, problem, or place/i },
  { id: "generic_most_useful_proof", pattern: /most useful proof, photo, room number, receipt, or map location/i },
  { id: "generic_see_detail_handoff", pattern: /request to see the detail, a staff handoff, or a clear next step/i },
  { id: "generic_not_working", pattern: /naming what is not working/i },
  { id: "generic_replacement_room_visit", pattern: /replacement offer, a room visit/i },
  { id: "generic_screen_room_broken_part", pattern: /Show the screen, room item, or broken part/i },
  { id: "you_may_hear_you_ask", pattern: /You may hear You ask/i },
  { id: "item_in_your_hand", pattern: /item in your hand/i },
  { id: "listener_catch_point", pattern: /listener to catch the point quickly/i },
  { id: "long_explanation", pattern: /rather than a long explanation/i },
  { id: "show_next_step", pattern: /let the other person show the next step/i },
  { id: "simple_anchor", pattern: /simple anchor/i },
  { id: "concrete_item_problem", pattern: /concrete item or problem/i },
  { id: "document_photo_problem", pattern: /document, photo, room number, receipt, or screen connected/i },
  { id: "request_see_item_desk", pattern: /request to see the item, a direction to another desk/i },
  { id: "short_practical_clue", pattern: /as a short practical clue/i },
  { id: "generic_booking_ticket_room_time", pattern: /booking, ticket, room number, or time on your phone/i },
  { id: "generic_place_object_screen", pattern: /place, object, or screen that gives the phrase context/i },
  { id: "generic_item_menu_photo", pattern: /item, menu line, or photo so the person can connect/i },
  { id: "practice_practical_thing", pattern: /practical thing you need someone to understand first/i },
  { id: "practice_practical_need_first", pattern: /names the practical need first/i },
  { id: "practice_long_explanation", pattern: /without turning it into a long explanation/i },
  { id: "practice_anchor_word", pattern: /anchor word/i },
  { id: "listener_catch_help", pattern: /what you need the listener to catch/i },
  { id: "works_because_it", pattern: /works because it/i },
];

const weakBreakdownPatterns = [
  { id: "trailing_detail", pattern: /\bdetail$/i },
  { id: "starts_phrase", pattern: /^starts?\s+(?:the\s+)?phrase\b/i },
  { id: "finishes_phrase", pattern: /^finishes?\b/i },
  { id: "sets_up_phrase", pattern: /^sets up\b/i },
  { id: "part_of_reply", pattern: /^part of\b/i },
  { id: "proper_name", pattern: /^proper name\b/i },
  { id: "place_name", pattern: /^place name$/i },
  { id: "name_starter", pattern: /^name starter$/i },
  { id: "street_name", pattern: /^street name$/i },
  { id: "market_name", pattern: /^market name$/i },
  { id: "driver_word", pattern: /^driver word$/i },
  { id: "phrase_piece", pattern: /^phrase piece$/i },
  { id: "names_generic", pattern: /^names\b/i },
  { id: "key_word", pattern: /^key word$/i },
  { id: "phrase_ending", pattern: /^phrase ending$/i },
  { id: "generic_word", pattern: /^word$/i },
  { id: "generic_action", pattern: /^action$/i },
  { id: "question_ending", pattern: /^question ending$/i },
  { id: "place_service", pattern: /^place \/ service$/i },
  { id: "main_phrase_piece", pattern: /^main phrase piece$/i },
  { id: "extra_detail", pattern: /^extra detail$/i },
  { id: "main_place_or_thing", pattern: /^the main place or thing$/i },
  { id: "specific_detail", pattern: /^specific detail$/i },
  { id: "name_or_place_detail", pattern: /^name or place detail$/i },
  { id: "first_name_part", pattern: /^first name part$/i },
  { id: "second_name_part", pattern: /^second name part$/i },
  { id: "middle_name_part", pattern: /^middle name part$/i },
  { id: "final_name_part", pattern: /^final name part$/i },
  { id: "soft_reassurance", pattern: /^soft reassurance$/i },
  { id: "context_word", pattern: /^context word$/i },
  { id: "meaning_to_keep", pattern: /^meaning to keep$/i },
  { id: "meaningful_phrase_part", pattern: /^meaningful phrase part$/i },
  { id: "full_phrase_visible_label", pattern: /^full phrase$/i },
  { id: "phrase_meaning_fallback", pattern: /^phrase meaning$/i },
];

const protectedBreakdownContextRules = [
  {
    token: "cô",
    expected: "aunt-age woman / respectful female address",
    forbidden: [/have\s*\/\s*yes/i],
  },
  {
    token: "chưa",
    expected: "not yet",
    forbidden: [/pagoda/i],
  },
  {
    token: "vệ",
    expected: "hygiene as part of giấy vệ sinh; prefer the full chunk giấy vệ sinh",
    forbidden: [/ticket/i],
  },
  {
    token: "giấy vệ sinh",
    expected: "toilet paper",
    forbidden: [/ticket/i, /document/i],
  },
];

function run(command, args) {
  const result = spawnSync(command, args, {
    cwd: repoRoot,
    encoding: "utf8",
    maxBuffer: 128 * 1024 * 1024,
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

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
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

function csvCell(value) {
  return `"${String(value ?? "").replace(/"/g, "\"\"").replace(/\n+/g, " ").trim()}"`;
}

function markdownCell(value) {
  return String(value ?? "")
    .replace(/\|/g, "\\|")
    .replace(/\n+/g, " ")
    .trim();
}

function walkFiles(dir, predicate) {
  if (!fs.existsSync(dir)) return [];
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

function sourceIndex() {
  const index = new Map();
  const roots = [
    path.join(repoRoot, "content-draft", "viet", "canonical-pages", "tier-one"),
    path.join(repoRoot, "content-draft", "viet", "canonical-pages", "catalog-promoted"),
  ];
  for (const root of roots) {
    for (const filePath of walkFiles(root, (candidate) => candidate.endsWith(".json"))) {
      try {
        const json = readJSON(filePath);
        if (json.id) {
          index.set(json.id, path.relative(repoRoot, filePath));
        }
        if (json.phraseID && json.id) {
          index.set(`phrase:${json.phraseID}`, path.relative(repoRoot, filePath));
        }
      } catch {
        // Leave malformed/non-page JSON to the existing source validators.
      }
    }
  }
  const cityPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
  if (fs.existsSync(cityPath)) {
    const city = readJSON(cityPath);
    for (const page of city.pages ?? []) {
      index.set(`phrase:${page.id}`, path.relative(repoRoot, cityPath));
    }
  }
  const practiceRoot = path.join(repoRoot, "content-draft", "viet", "practice-expansion", "TASK-VIET-CONTENT-PRACTICE-EXPANSION-001");
  const manifestPath = path.join(practiceRoot, "manifest.json");
  if (fs.existsSync(manifestPath)) {
    const manifest = readJSON(manifestPath);
    for (const shardPath of manifest.sourceShards ?? []) {
      const fullPath = path.join(practiceRoot, shardPath);
      const shard = readJSON(fullPath);
      for (const page of shard.pages ?? []) {
        index.set(`phrase:${page.phraseID}`, path.relative(repoRoot, fullPath));
      }
    }
  }
  return index;
}

function authoredPageIndex() {
  const bundle = fs.existsSync(authoredPagesPath) ? readJSON(authoredPagesPath) : { pages: [] };
  const byPageID = new Map();
  const byPhraseID = new Map();
  for (const page of bundle.pages ?? []) {
    byPageID.set(page.id, page);
    byPhraseID.set(page.phraseID, page);
  }
  return { byPageID, byPhraseID };
}

function issue(code, severity, message) {
  return { code, severity, message };
}

function sourceLane(page, authored, sourcePath) {
  const tierRole = authored?.tierRole;
  if (tierRole) return tierRole;
  if (sourcePath.includes("city-library")) return "city-library";
  if (sourcePath.includes("practice-expansion")) return "practice-expansion";
  if (sourcePath.includes("canonical-pages/catalog-promoted")) return "catalog-promoted";
  if (sourcePath.includes("canonical-pages/tier-one")) return "tier1";
  if (Number(page.is_authored) === 0) return "catalog-built";
  return "authored-unknown";
}

function hasInteractiveContent(section) {
  return Number(section.phrase_item_count) > 0 || Number(section.breakdown_item_count) > 0;
}

function duplicateNonFinalBreakdownLabels(breakdownRows) {
  if (breakdownRows.length < 3) return [];
  const maxOrder = Math.max(...breakdownRows.map((row) => Number(row.sort_order)));
  const labelRows = new Map();
  for (const row of breakdownRows) {
    if (Number(row.sort_order) >= maxOrder) continue;
    const label = normalize(row.english_gloss);
    if (!label) continue;
    if (!labelRows.has(label)) labelRows.set(label, []);
    labelRows.get(label).push(row);
  }
  return [...labelRows.values()].filter((rows) => rows.length > 1);
}

function wrongBreakdownContextIssues(page, breakdownRows) {
  const issues = [];
  for (const row of breakdownRows) {
    const token = String(row.token_text ?? "").trim().toLowerCase();
    const gloss = String(row.english_gloss ?? "");
    for (const rule of protectedBreakdownContextRules) {
      if (token !== rule.token) continue;
      if (rule.forbidden.some((pattern) => pattern.test(gloss))) {
        issues.push(`${row.token_text} -> ${row.english_gloss}; expected ${rule.expected}`);
      }
    }
  }

  if (
    String(page.title ?? "").trim().toLowerCase() === "có giấy vệ sinh không?"
    && !breakdownRows.some((row) => String(row.token_text ?? "").trim().toLowerCase() === "giấy vệ sinh")
  ) {
    issues.push("Có giấy vệ sinh không? must teach giấy vệ sinh as one toilet-paper chunk");
  }

  return issues;
}

function pageIssues(page, sections, breakdownRows, phraseRows, authored, sourcePath) {
  const issues = [];
  const fullText = [
    page.title,
    page.english_title,
    page.summary,
    ...sections.flatMap((section) => [section.title, section.body]),
    ...phraseRows.flatMap((row) => [row.title_override, row.subtitle_override]),
    ...breakdownRows.flatMap((row) => [row.token_text, row.english_gloss]),
  ].filter(Boolean).join("\n");

  if (Number(page.section_count) === 0) {
    issues.push(issue("missing_sections", "blocker", "Canonical page has no article sections."));
  }

  const sectionKeys = new Set(sections.map((section) => section.section_key));
  for (const key of requiredSectionKeys) {
    if (key === "when-to-use" && page.id === baNaJourneyPageID && sectionKeys.has("journey-flow")) {
      continue;
    }
    if (!sectionKeys.has(key)) {
      issues.push(issue(`missing_${key}`, "must_fix", `Missing required ${key} section.`));
    }
  }
  if (!sectionKeys.has("quick-say") && !sectionKeys.has("standard-way")) {
    issues.push(issue("missing_quick_or_standard", "must_fix", "Missing Quick say or standard-way teaching section."));
  }
  if (!sectionKeys.has("explore-next")) {
    issues.push(issue("missing_explore_next", "needs_authored_review", "Missing Explore next section."));
  }

  if (normalize(page.english_title) !== normalize(page.phrase_english_text)) {
    issues.push(issue("hero_translation_mismatch", "blocker", "Hero English title does not match canonical phrase English text."));
  }

  if (breakdownRows.length === 0) {
    issues.push(issue("missing_breakdown_tokens", "must_fix", "Breakdown section has no reusable token rows."));
  } else {
    const weakTokens = breakdownRows
      .filter((row) => weakBreakdownPatterns.some((pattern) => pattern.pattern.test(String(row.english_gloss ?? ""))))
      .map((row) => `${row.token_text}: ${row.english_gloss}`);
    if (weakTokens.length > 0) {
      issues.push(issue("weak_breakdown_label", "needs_authored_review", `Weak or internal breakdown labels: ${weakTokens.slice(0, 4).join("; ")}`));
    }
    const duplicateLabels = duplicateNonFinalBreakdownLabels(breakdownRows);
    if (duplicateLabels.length > 0) {
      issues.push(issue(
        "duplicate_breakdown_label",
        "needs_authored_review",
        `Repeated non-final breakdown labels: ${duplicateLabels.slice(0, 3).map((rows) => `${rows[0].english_gloss} (${rows.map((row) => row.token_text).join(" + ")})`).join("; ")}`
      ));
    }
    if (breakdownRows.length === 1 && String(page.title).split(/\s+/).filter(Boolean).length > 1) {
      issues.push(issue("single_card_multiword_breakdown", "needs_authored_review", "Multiword phrase has only one breakdown card."));
    }
    const wrongBreakdownIssues = wrongBreakdownContextIssues(page, breakdownRows);
    if (wrongBreakdownIssues.length > 0) {
      issues.push(issue("wrong_breakdown_dictionary_context", "blocker", wrongBreakdownIssues.join("; ")));
    }
  }

  let textOnlyRun = [];
  for (const section of sections) {
    if (hasInteractiveContent(section)) {
      textOnlyRun = [];
    } else {
      textOnlyRun.push(section);
      if (textOnlyRun.length >= 3) {
        issues.push(issue("three_text_only_sections", "must_fix", `Three consecutive text-only sections: ${textOnlyRun.map((item) => item.title).join(" | ")}`));
        break;
      }
    }
  }

  for (const banned of learnerFacingBannedPatterns) {
    if (banned.pattern.test(fullText)) {
      issues.push(issue(`banned_${banned.id}`, banned.severity, `Learner-facing text matches ${banned.pattern}.`));
    }
  }

  const copyPatterns = patternHeavyCopy
    .filter((pattern) => pattern.pattern.test(fullText))
    .map((pattern) => pattern.id);
  if (copyPatterns.length > 0) {
    issues.push(issue("pattern_heavy_copy", "needs_authored_repair", `Pattern-heavy copy markers: ${copyPatterns.join(", ")}.`));
  }

  if (Number(page.article_phrase_row_count) === 0) {
    issues.push(issue("no_article_phrase_rows", "must_fix", "No phrase-row learning opportunities outside relationship words."));
  }

  if (Number(page.broken_relation_count) > 0) {
    issues.push(issue("broken_relation", "blocker", "Page has relation rows whose target page is missing."));
  }

  if (sourceLane(page, authored, sourcePath) === "catalog-built") {
    issues.push(issue("catalog_built_no_authored_source", "needs_authored_review", "Page is built from catalog defaults and needs durable authored source to meet the human-quality standard."));
  }

  return issues;
}

function verdictFromIssues(issues) {
  if (issues.some((item) => item.severity === "blocker")) return "BLOCKER";
  if (issues.some((item) => item.severity === "must_fix")) return "FAIL";
  if (issues.some((item) => item.severity === "needs_authored_repair")) return "NEEDS_AUTHORED_REPAIR";
  if (issues.some((item) => item.severity === "needs_authored_review")) return "NEEDS_REVIEW";
  return "PASS";
}

function main() {
  if (!fs.existsSync(databasePath)) {
    throw new Error(`Missing SQLite database: ${path.relative(repoRoot, databasePath)}`);
  }

  fs.mkdirSync(outputRoot, { recursive: true });

  const sourceByID = sourceIndex();
  const authoredIndex = authoredPageIndex();
  const sqliteReport = fs.existsSync(reportPath) ? readJSON(reportPath) : null;

  const pages = sqliteJSON(`
    SELECT
      pp.id,
      pp.title,
      pp.english_title,
      pp.summary,
      pp.completeness_status,
      pp.is_authored,
      p.id AS phrase_id,
      p.english_text AS phrase_english_text,
      p.audio_status,
      p.source_path AS phrase_source_path,
      (
        SELECT count(*)
        FROM page_section ps
        WHERE ps.page_id = pp.id
      ) AS section_count,
      (
        SELECT count(*)
        FROM page_section ps
        JOIN page_section_item psi ON psi.section_id = ps.id
        WHERE ps.page_id = pp.id
          AND psi.item_kind = 'phrase'
          AND ps.section_key != 'relationship-words'
      ) AS article_phrase_row_count,
      (
        SELECT count(*)
        FROM page_alias pa
        WHERE pa.canonical_page_id = pp.id
      ) AS alias_count,
      (
        SELECT count(*)
        FROM phrase_relation pr
        WHERE pr.source_kind = 'page'
          AND pr.source_id = pp.id
          AND pr.target_kind = 'page'
          AND NOT EXISTS (SELECT 1 FROM phrase_page target WHERE target.id = pr.target_id)
      ) AS broken_relation_count
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    ORDER BY pp.id;
  `);

  const sectionRows = sqliteJSON(`
    SELECT
      ps.id,
      ps.page_id,
      ps.section_key,
      ps.title,
      ps.body,
      ps.presentation,
      ps.sort_order,
      (
        SELECT count(*)
        FROM page_section_item psi
        WHERE psi.section_id = ps.id
          AND psi.item_kind = 'phrase'
      ) AS phrase_item_count,
      (
        SELECT count(*)
        FROM page_section_item psi
        WHERE psi.section_id = ps.id
          AND psi.item_kind = 'breakdown_token'
      ) AS breakdown_item_count
    FROM page_section ps
    ORDER BY ps.page_id, ps.sort_order;
  `);
  const sectionsByPage = new Map();
  for (const row of sectionRows) {
    if (!sectionsByPage.has(row.page_id)) sectionsByPage.set(row.page_id, []);
    sectionsByPage.get(row.page_id).push(row);
  }

  const breakdownRows = sqliteJSON(`
    SELECT
      pp.id AS page_id,
      bt.token_text,
      bt.english_gloss,
      psi.sort_order
    FROM phrase_page pp
    JOIN page_section ps ON ps.page_id = pp.id AND ps.section_key = 'breakdown'
    JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'breakdown_token'
    JOIN breakdown_token bt ON bt.id = psi.target_id
    ORDER BY pp.id, psi.sort_order;
  `);
  const breakdownByPage = new Map();
  for (const row of breakdownRows) {
    if (!breakdownByPage.has(row.page_id)) breakdownByPage.set(row.page_id, []);
    breakdownByPage.get(row.page_id).push(row);
  }

  const phraseRows = sqliteJSON(`
    SELECT
      ps.page_id,
      ps.section_key,
      p.id AS phrase_id,
      p.target_text,
      p.english_text,
      pp.id AS target_page_id,
      psi.title_override,
      psi.subtitle_override,
      psi.sort_order
    FROM page_section ps
    JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'phrase'
    JOIN phrase p ON p.id = psi.target_id
    LEFT JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
    ORDER BY ps.page_id, ps.sort_order, psi.sort_order;
  `);
  const phraseRowsByPage = new Map();
  for (const row of phraseRows) {
    if (!phraseRowsByPage.has(row.page_id)) phraseRowsByPage.set(row.page_id, []);
    phraseRowsByPage.get(row.page_id).push(row);
  }

  const duplicateCanonicalGroups = Number(sqliteValue(`
    SELECT count(*)
    FROM (
      SELECT p.normalized_target_text
      FROM phrase_page pp
      JOIN phrase p ON p.id = pp.phrase_id
      GROUP BY p.normalized_target_text
      HAVING count(*) > 1
    );
  `));

  const auditRows = pages.map((page, index) => {
    const authored = authoredIndex.byPageID.get(page.id) ?? authoredIndex.byPhraseID.get(page.phrase_id);
    const sourcePath = sourceByID.get(page.id)
      ?? sourceByID.get(`phrase:${page.phrase_id}`)
      ?? page.phrase_source_path
      ?? "";
    const sections = sectionsByPage.get(page.id) ?? [];
    const breakdown = breakdownByPage.get(page.id) ?? [];
    const pagePhraseRows = phraseRowsByPage.get(page.id) ?? [];
    const issues = pageIssues(page, sections, breakdown, pagePhraseRows, authored, sourcePath);
    const verdict = verdictFromIssues(issues);
    return {
      row: index + 1,
      pageID: page.id,
      phraseID: page.phrase_id,
      vietnamese: page.title,
      english: page.english_title,
      sourceLane: sourceLane(page, authored, sourcePath),
      sourcePath,
      sectionCount: Number(page.section_count),
      phraseRowCount: Number(page.article_phrase_row_count),
      breakdownTokenCount: breakdown.length,
      audioStatus: page.audio_status,
      aliasCount: Number(page.alias_count),
      verdict,
      issueCodes: issues.map((item) => item.code),
      issues,
    };
  });

  const issueCounts = new Map();
  const severityCounts = new Map();
  const laneCounts = new Map();
  const verdictCounts = new Map();
  for (const row of auditRows) {
    laneCounts.set(row.sourceLane, (laneCounts.get(row.sourceLane) ?? 0) + 1);
    verdictCounts.set(row.verdict, (verdictCounts.get(row.verdict) ?? 0) + 1);
    for (const item of row.issues) {
      issueCounts.set(item.code, (issueCounts.get(item.code) ?? 0) + 1);
      severityCounts.set(item.severity, (severityCounts.get(item.severity) ?? 0) + 1);
    }
  }

  const summary = {
    taskID,
    generatedAt: new Date().toISOString(),
    databasePath: path.relative(repoRoot, databasePath),
    canonicalPageCount: auditRows.length,
    sourcePhraseCount: Number(sqliteValue("SELECT count(*) FROM phrase;")),
    duplicateCanonicalGroups,
    missingAudioRows: Number(sqliteValue("SELECT count(*) FROM missing_audio_audit;")),
    releaseBlockingMissingAudioRows: Number(sqliteValue("SELECT count(*) FROM missing_audio_audit WHERE release_blocking = 1;")),
    missingAudioRowsWithExactReusableAssets: Number(sqliteValue(`
      SELECT count(*)
      FROM missing_audio_audit ma
      JOIN audio_asset aa
        ON aa.language_pack_id = ma.language_pack_id
       AND aa.normalized_spoken_text = ma.normalized_expected_text;
    `)),
    missingAudioRowsWithExactTargetUsages: Number(sqliteValue(`
      SELECT count(*)
      FROM missing_audio_audit ma
      JOIN audio_usage au
        ON au.target_kind = ma.target_kind
       AND au.target_id = ma.target_id
       AND au.normalized_expected_text = ma.normalized_expected_text;
    `)),
    sqliteReportGeneratedCounts: sqliteReport?.generatedCounts ?? null,
    verdictCounts: Object.fromEntries([...verdictCounts.entries()].sort()),
    sourceLaneCounts: Object.fromEntries([...laneCounts.entries()].sort()),
    issueCounts: Object.fromEntries([...issueCounts.entries()].sort()),
    severityCounts: Object.fromEntries([...severityCounts.entries()].sort()),
  };

  fs.writeFileSync(
    path.join(outputRoot, "per-page-audit.jsonl"),
    auditRows.map((row) => JSON.stringify(row)).join("\n") + "\n"
  );

  const csvHeader = [
    "row",
    "page_id",
    "phrase_id",
    "vietnamese",
    "english",
    "source_lane",
    "source_path",
    "section_count",
    "phrase_row_count",
    "breakdown_token_count",
    "audio_status",
    "alias_count",
    "verdict",
    "issue_codes",
    "issue_messages",
  ];
  const csvRows = auditRows.map((row) => [
    row.row,
    row.pageID,
    row.phraseID,
    row.vietnamese,
    row.english,
    row.sourceLane,
    row.sourcePath,
    row.sectionCount,
    row.phraseRowCount,
    row.breakdownTokenCount,
    row.audioStatus,
    row.aliasCount,
    row.verdict,
    row.issueCodes.join("|"),
    row.issues.map((item) => `${item.severity}:${item.message}`).join(" || "),
  ]);
  fs.writeFileSync(
    path.join(outputRoot, "per-page-audit.csv"),
    [csvHeader, ...csvRows].map((row) => row.map(csvCell).join(",")).join("\n") + "\n"
  );
  fs.writeFileSync(path.join(outputRoot, "issue-summary.json"), `${JSON.stringify(summary, null, 2)}\n`);

  const jojoReviewRows = auditRows
    .filter((row) => row.issues.some((item) => item.severity === "needs_authored_review" || item.severity === "needs_authored_repair"))
    .map((row) => [
      row.pageID,
      row.phraseID,
      row.vietnamese,
      row.english,
      row.sourceLane,
      row.sourcePath,
      row.verdict,
      row.issues
        .filter((item) => item.severity === "needs_authored_review" || item.severity === "needs_authored_repair")
        .map((item) => item.code)
        .join("|"),
      row.issues
        .filter((item) => item.severity === "needs_authored_review" || item.severity === "needs_authored_repair")
        .map((item) => item.message)
        .join(" || "),
    ]);
  fs.writeFileSync(
    path.join(outputRoot, "jojo-review-queue.csv"),
    [
      ["page_id", "phrase_id", "vietnamese", "english", "source_lane", "source_path", "verdict", "review_codes", "evidence"],
      ...jojoReviewRows,
    ].map((row) => row.map(csvCell).join(",")).join("\n") + "\n"
  );

  const topIssues = [...issueCounts.entries()].sort((a, b) => b[1] - a[1]).slice(0, 20);
  const markdown = [
    "# Viet Canonical Content Audit 001",
    "",
    `Task: \`${taskID}\``,
    `Generated: ${summary.generatedAt}`,
    "",
    "## Summary",
    "",
    `- Canonical pages audited: ${summary.canonicalPageCount}`,
    `- Source phrase rows: ${summary.sourcePhraseCount}`,
    `- Duplicate normalized canonical Vietnamese groups: ${summary.duplicateCanonicalGroups}`,
    `- Missing audio queue rows: ${summary.missingAudioRows}`,
    `- Release-blocking missing audio rows: ${summary.releaseBlockingMissingAudioRows}`,
    `- Missing audio rows with exact reusable assets: ${summary.missingAudioRowsWithExactReusableAssets}`,
    `- Missing audio rows with exact target usages: ${summary.missingAudioRowsWithExactTargetUsages}`,
    "",
    "## Verdict Counts",
    "",
    "| Verdict | Pages |",
    "| --- | ---: |",
    ...Object.entries(summary.verdictCounts).map(([key, value]) => `| ${markdownCell(key)} | ${value} |`),
    "",
    "## Source Lane Counts",
    "",
    "| Source lane | Pages |",
    "| --- | ---: |",
    ...Object.entries(summary.sourceLaneCounts).map(([key, value]) => `| ${markdownCell(key)} | ${value} |`),
    "",
    "## Top Issue Counts",
    "",
    "| Issue | Pages |",
    "| --- | ---: |",
    ...topIssues.map(([key, value]) => `| ${markdownCell(key)} | ${value} |`),
    "",
    "## Artifacts",
    "",
    "- `per-page-audit.jsonl`: full page-level reasoning record.",
    "- `per-page-audit.csv`: spreadsheet-friendly page audit.",
    "- `issue-summary.json`: machine-readable rollup.",
    "- `jojo-review-queue.csv`: pages needing Jojo/native/content judgment.",
    "- `repair-ledger.md`: safe repairs made during this task.",
    "",
    "## First 50 Non-Pass Pages",
    "",
    "| # | Page ID | Vietnamese | English | Source | Verdict | Issues |",
    "| ---: | --- | --- | --- | --- | --- | --- |",
    ...auditRows
      .filter((row) => row.verdict !== "PASS")
      .slice(0, 50)
      .map((row) => `| ${row.row} | \`${markdownCell(row.pageID)}\` | ${markdownCell(row.vietnamese)} | ${markdownCell(row.english)} | ${markdownCell(row.sourceLane)} | ${markdownCell(row.verdict)} | ${markdownCell(row.issueCodes.join(", "))} |`),
    "",
  ];
  fs.writeFileSync(path.join(outputRoot, "README.md"), markdown.join("\n"));

  console.log(JSON.stringify(summary, null, 2));

  if (process.argv.includes("--check")) {
    const nonPassRows = auditRows.filter((row) => row.verdict !== "PASS");
    const releaseBlockingAudio = summary.releaseBlockingMissingAudioRows;
    const reusableAudioQueued = summary.missingAudioRowsWithExactReusableAssets + summary.missingAudioRowsWithExactTargetUsages;
    if (duplicateCanonicalGroups > 0 || releaseBlockingAudio > 0 || reusableAudioQueued > 0 || nonPassRows.length > 0) {
      process.exitCode = 1;
    }
  }
}

main();
