#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const resourcePath = path.join(repoRoot, "native-ios/Resources/viet-authored-listing-pages.json");
const sourceRoots = [
  "content-draft/viet/canonical-pages/tier-one",
  "content-draft/viet/canonical-pages/catalog-promoted",
  "content-draft/viet/editorial-model-support",
  "content-draft/viet/city-library/app-detail-v2-2",
];
const outputDir = path.join(repoRoot, "docs/content-audits/phrase-copy-production-gate-2026-06-08");

const formulaPatterns = [
  { code: "bare_summary", weight: 5, field: "summary", re: /^.{1,42}$/ },
  { code: "clear_first_sentence", weight: 4, re: /\b(clear|short) first sentence\b/i },
  { code: "first_phrase_leads", weight: 5, re: /\bfirst phrase leads to another request\b/i },
  { code: "fits_next_step", weight: 5, re: /\bfits the next step\b/i },
  { code: "answer_changes_need", weight: 4, re: /\bif the answer changes what you need\b/i },
  { code: "ready_next_turn", weight: 4, re: /\bready for the next turn\b/i },
  { code: "carry_next_detail", weight: 4, re: /\bcan carry the next detail\b/i },
  { code: "details_spread", weight: 4, re: /\bbefore details spread out\b/i },
  { code: "supporting_detail", weight: 3, re: /\bsupporting detail\b/i },
  { code: "next_detail_generic", weight: 3, re: /\bnext detail\b/i },
  { code: "another_request", weight: 3, re: /\banother request\b/i },
  { code: "lead_with_question", weight: 3, re: /\blead with the question\b/i },
  { code: "let_question_land", weight: 3, re: /\blet the question land first\b/i },
  { code: "main_request_yes_no", weight: 3, re: /\bmain request first; .*turns it into a yes\/no question\b/i },
  { code: "use_it_when", weight: 2, re: /\buse it when\b/i },
  { code: "say_this_when", weight: 2, re: /\bsay this when\b/i },
  { code: "belongs_when_detail", weight: 3, re: /\bit belongs .*\bwhen\b.*\bdetail\b/i },
  { code: "template_traveler_named", weight: 2, re: /\bfor travelers\b/i },
  { code: "generic_visible_detail", weight: 2, re: /\bvisible detail\b/i },
];

const bannedPremiumPatterns = [
  { code: "this_page_helps", weight: 12, re: /\bthis page helps\b/i },
  { code: "internal_role", weight: 12, re: /\b(content role|source rationale|relationship rows|route phrase|where-question)\b/i },
  { code: "travel_cliche", weight: 8, re: /\b(perfect for|must-visit|hidden gem|vibrant|bustling|curated|nestled)\b/i },
  { code: "source_scaffold", weight: 10, re: /\b(atomic|this row|move here|these cards stay|keep these close|next exchange close|reply points toward|likely follow-up|after the first answer)\b/i },
];

function main() {
  const pages = JSON.parse(fs.readFileSync(resourcePath, "utf8")).pages ?? [];
  const sourceByPageID = buildSourceIndex();
  const bodyFrequency = countRepeatedBodies(pages);
  const rows = pages.map((page) => scorePage(page, sourceByPageID, bodyFrequency));
  rows.sort((a, b) => b.score - a.score || a.pageID.localeCompare(b.pageID));

  fs.mkdirSync(outputDir, { recursive: true });
  writeJson(path.join(outputDir, "premium-copy-audit.json"), {
    generatedAt: new Date().toISOString(),
    pageCount: pages.length,
    counts: summarize(rows),
    topRows: rows.slice(0, 200),
  });
  writeCsv(path.join(outputDir, "premium-copy-audit.csv"), rows);
  writeMarkdown(path.join(outputDir, "premium-copy-audit.md"), rows);

  const summary = summarize(rows);
  console.log(JSON.stringify({
    pageCount: pages.length,
    counts: summary,
    top10: rows.slice(0, 10).map((row) => ({
      pageID: row.pageID,
      title: row.title,
      englishTitle: row.englishTitle,
      tierRole: row.tierRole,
      score: row.score,
      severity: row.severity,
      issueCodes: row.issues.map((issue) => issue.code).slice(0, 8),
    })),
  }, null, 2));
}

function buildSourceIndex() {
  const out = new Map();
  for (const root of sourceRoots) {
    const absRoot = path.join(repoRoot, root);
    for (const filePath of walkJsonFiles(absRoot)) {
      try {
        const json = JSON.parse(fs.readFileSync(filePath, "utf8"));
        if (json.id) out.set(json.id, path.relative(repoRoot, filePath));
        if (Array.isArray(json.entries)) {
          for (const entry of json.entries) {
            if (entry.id) out.set(`viet-family-${entry.id}`, path.relative(repoRoot, filePath));
          }
        }
      } catch {
        // Audit should keep going and report what it can.
      }
    }
  }
  return out;
}

function walkJsonFiles(dir, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const name of fs.readdirSync(dir)) {
    const filePath = path.join(dir, name);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) walkJsonFiles(filePath, out);
    else if (name.endsWith(".json")) out.push(filePath);
  }
  return out;
}

function countRepeatedBodies(pages) {
  const counts = new Map();
  for (const page of pages) {
    for (const section of page.sections ?? []) {
      const normalized = normalizeText(section.body);
      if (wordCount(normalized) < 7) continue;
      counts.set(normalized, (counts.get(normalized) ?? 0) + 1);
    }
  }
  return counts;
}

function scorePage(page, sourceByPageID, bodyFrequency) {
  const issues = [];
  const visibleText = collectVisibleText(page).join("\n");
  const sections = page.sections ?? [];
  const phraseCards = sections.reduce((total, section) => total + (section.phrases?.length ?? 0), 0);
  const breakdownCards = sections.reduce((total, section) => total + (section.breakdown?.length ?? 0), 0);

  if (["tier1", "child", "catalog-promoted", "editorial-model-support"].includes(page.tierRole)) {
    if (phraseCards === 0) addIssue(issues, "no_phrase_cards", 10, "No rendered phrase cards.");
    if (wordCount(visibleText) < 90) addIssue(issues, "thin_page", 5, "Rendered page has fewer than 90 visible words.");
  }

  if (page.tierRole === "catalog-promoted" && normalizeText(page.summary) === normalizeText(page.englishTitle)) {
    addIssue(issues, "summary_equals_title", 7, "Summary repeats the English title.");
  }

  for (const pattern of bannedPremiumPatterns) {
    if (pattern.re.test(visibleText)) addIssue(issues, pattern.code, pattern.weight, snippetFor(visibleText, pattern.re));
  }

  for (const section of sections) {
    const body = String(section.body ?? "");
    if (!body) continue;

    for (const pattern of formulaPatterns) {
      if (pattern.field === "summary") continue;
      if (pattern.re.test(body)) addIssue(issues, pattern.code, pattern.weight, `${section.id}: ${body}`);
    }

    const repeated = bodyFrequency.get(normalizeText(body)) ?? 0;
    if (repeated >= 20) {
      addIssue(issues, "body_repeated_20_plus", 7, `${section.id}: repeated ${repeated} times`);
    } else if (repeated >= 8) {
      addIssue(issues, "body_repeated_8_plus", 4, `${section.id}: repeated ${repeated} times`);
    }
  }

  for (const pattern of formulaPatterns.filter((pattern) => pattern.field === "summary")) {
    if (page.tierRole === "catalog-promoted" && pattern.re.test(String(page.summary ?? ""))) {
      addIssue(issues, pattern.code, pattern.weight, `summary: ${page.summary}`);
    }
  }

  const sourcePath = sourceByPageID.get(page.id) ?? "";
  const score = issues.reduce((total, issue) => total + issue.weight, 0);
  return {
    pageID: page.id,
    title: page.title ?? "",
    englishTitle: page.englishTitle ?? "",
    tierRole: page.tierRole ?? "",
    categoryIDs: (page.categoryIDs ?? []).join("|"),
    sourcePath,
    score,
    severity: severityFor(score),
    phraseCards,
    breakdownCards,
    visibleWords: wordCount(visibleText),
    issues,
    worstSnippet: issues[0]?.detail ?? "",
  };
}

function addIssue(issues, code, weight, detail) {
  issues.push({ code, weight, detail: String(detail).replace(/\s+/g, " ").slice(0, 260) });
}

function collectVisibleText(page) {
  const text = [page.title, page.englishTitle, page.summary];
  for (const section of page.sections ?? []) {
    text.push(section.title, section.body);
    for (const phrase of section.phrases ?? []) text.push(phrase.vietnamese, phrase.english);
    for (const row of section.breakdown ?? []) text.push(row.vietnamese, row.english);
  }
  return text.filter(Boolean).map(String);
}

function normalizeText(value) {
  return String(value ?? "")
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[đĐ]/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function wordCount(value) {
  const normalized = normalizeText(value);
  return normalized ? normalized.split(" ").length : 0;
}

function snippetFor(text, re) {
  const match = String(text).match(re);
  if (!match) return "";
  const start = Math.max(0, match.index - 80);
  return String(text).slice(start, start + 240).replace(/\s+/g, " ");
}

function severityFor(score) {
  if (score >= 18) return "HARD_REVIEW";
  if (score >= 10) return "WEAK_REVIEW";
  if (score >= 5) return "WATCH";
  return "PASS";
}

function summarize(rows) {
  return rows.reduce((acc, row) => {
    acc[row.severity] = (acc[row.severity] ?? 0) + 1;
    return acc;
  }, { HARD_REVIEW: 0, WEAK_REVIEW: 0, WATCH: 0, PASS: 0 });
}

function writeJson(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function writeCsv(filePath, rows) {
  const header = [
    "severity",
    "score",
    "pageID",
    "tierRole",
    "title",
    "englishTitle",
    "phraseCards",
    "breakdownCards",
    "visibleWords",
    "issueCodes",
    "sourcePath",
    "worstSnippet",
  ];
  const lines = [header.join(",")];
  for (const row of rows) {
    lines.push([
      row.severity,
      row.score,
      row.pageID,
      row.tierRole,
      row.title,
      row.englishTitle,
      row.phraseCards,
      row.breakdownCards,
      row.visibleWords,
      row.issues.map((issue) => issue.code).join("|"),
      row.sourcePath,
      row.worstSnippet,
    ].map(csvCell).join(","));
  }
  fs.writeFileSync(filePath, `${lines.join("\n")}\n`);
}

function csvCell(value) {
  const text = String(value ?? "");
  if (!/[",\n]/.test(text)) return text;
  return `"${text.replace(/"/g, '""')}"`;
}

function writeMarkdown(filePath, rows) {
  const summary = summarize(rows);
  const lines = [
    "# Premium Listing Copy Audit",
    "",
    "This audit is intentionally stricter than production QA. It flags copy that passes validators but may still feel templated, generic, or not fully authored.",
    "",
    "## Counts",
    "",
    `- HARD_REVIEW: ${summary.HARD_REVIEW}`,
    `- WEAK_REVIEW: ${summary.WEAK_REVIEW}`,
    `- WATCH: ${summary.WATCH}`,
    `- PASS: ${summary.PASS}`,
    "",
    "## Top Review Queue",
    "",
  ];

  for (const row of rows.slice(0, 40)) {
    lines.push(`### ${row.severity} ${row.score} - ${row.englishTitle || row.title}`);
    lines.push("");
    lines.push(`- pageID: \`${row.pageID}\``);
    lines.push(`- tierRole: \`${row.tierRole}\``);
    lines.push(`- source: \`${row.sourcePath || "unknown"}\``);
    lines.push(`- cards: ${row.phraseCards} phrase, ${row.breakdownCards} breakdown`);
    lines.push(`- issues: ${row.issues.map((issue) => `\`${issue.code}\``).join(", ")}`);
    lines.push(`- sample: ${row.worstSnippet || "n/a"}`);
    lines.push("");
  }

  fs.writeFileSync(filePath, `${lines.join("\n")}\n`);
}

main();
