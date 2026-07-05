#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const sourceRoots = [
  "content-draft/viet/canonical-pages/tier-one",
  "content-draft/viet/canonical-pages/catalog-promoted",
  "content-draft/viet/editorial-model-support",
];
const renderedPath = path.join(repoRoot, "native-ios/Resources/viet-authored-listing-pages.json");
const outputDir = path.join(repoRoot, "docs/content-audits/phrase-copy-production-gate-2026-06-08");

function main() {
  const renderedPages = JSON.parse(fs.readFileSync(renderedPath, "utf8")).pages ?? [];
  const renderedByID = new Map(renderedPages.map((page) => [page.id, page]));
  const sourcePages = loadSourcePages();
  const rows = [];

  for (const source of sourcePages) {
    const rendered = renderedByID.get(source.id);
    if (!rendered) {
      rows.push({
        severity: "HARD_BLOCK",
        pageID: source.id,
        tierRole: source.tierRole ?? "",
        englishTitle: source.englishTitle ?? "",
        sourcePath: source.__sourcePath,
        sectionID: "",
        sourceCount: sourceCardCount(source),
        renderedCount: 0,
        sourceOnly: sourceCardCount(source),
        renderedOnly: 0,
        note: "Source page missing from rendered native resource.",
      });
      continue;
    }

    const sourcePageKeys = new Set((source.sections ?? []).flatMap((section) => cardKeys(section)));
    const renderedPageKeys = new Set((rendered.sections ?? []).flatMap((section) => cardKeys(section)));
    const missingUnique = [...sourcePageKeys].filter((key) => !renderedPageKeys.has(key));
    const extraUnique = [...renderedPageKeys].filter((key) => !sourcePageKeys.has(key));
    if (missingUnique.length > 0) {
      rows.push({
        severity: "UNIQUE_SOURCE_CARD_MISSING",
        pageID: source.id,
        tierRole: source.tierRole ?? "",
        englishTitle: source.englishTitle ?? "",
        sourcePath: source.__sourcePath,
        sectionID: "__page_unique__",
        sourceCount: sourcePageKeys.size,
        renderedCount: renderedPageKeys.size,
        sourceOnly: missingUnique.length,
        renderedOnly: extraUnique.length,
        note: [
          `missing unique source cards: ${missingUnique.slice(0, 8).join("; ")}`,
          extraUnique.length ? `extra rendered cards: ${extraUnique.slice(0, 8).join("; ")}` : "",
        ].filter(Boolean).join(" | "),
      });
    }

    const sourceSections = new Map((source.sections ?? []).map((section) => [section.id, section]));
    const renderedSections = new Map((rendered.sections ?? []).map((section) => [section.id, section]));
    const sectionIDs = new Set([...sourceSections.keys(), ...renderedSections.keys()]);

    for (const sectionID of sectionIDs) {
      const sourceSection = sourceSections.get(sectionID);
      const renderedSection = renderedSections.get(sectionID);
      const sourceCards = cardKeys(sourceSection);
      const renderedCards = cardKeys(renderedSection);
      if (sourceCards.length === 0 && renderedCards.length === 0) continue;

      const sourceCounts = multiset(sourceCards);
      const renderedCounts = multiset(renderedCards);
      const allKeys = new Set([...sourceCounts.keys(), ...renderedCounts.keys()]);
      let sourceOnly = 0;
      let renderedOnly = 0;
      for (const key of allKeys) {
        const delta = (sourceCounts.get(key) ?? 0) - (renderedCounts.get(key) ?? 0);
        if (delta > 0) sourceOnly += delta;
        if (delta < 0) renderedOnly += -delta;
      }

      if (sourceOnly === 0 && renderedOnly === 0) continue;
      rows.push({
        severity: "SECTION_LAYOUT_DIFF",
        pageID: source.id,
        tierRole: source.tierRole ?? "",
        englishTitle: source.englishTitle ?? "",
        sourcePath: source.__sourcePath,
        sectionID,
        sourceCount: sourceCards.length,
        renderedCount: renderedCards.length,
        sourceOnly,
        renderedOnly,
        note: sampleDiff(sourceCounts, renderedCounts),
      });
    }
  }

  rows.sort((a, b) => (
    severityRank(a.severity) - severityRank(b.severity)
    || (b.sourceOnly - b.renderedOnly) - (a.sourceOnly - a.renderedOnly)
    || a.pageID.localeCompare(b.pageID)
    || a.sectionID.localeCompare(b.sectionID)
  ));

  const summary = summarize(rows, sourcePages.length);
  fs.mkdirSync(outputDir, { recursive: true });
  writeJson(path.join(outputDir, "source-render-card-parity.json"), {
    generatedAt: new Date().toISOString(),
    summary,
    topRows: rows.slice(0, 250),
  });
  writeCsv(path.join(outputDir, "source-render-card-parity.csv"), rows);

  console.log(JSON.stringify(summary, null, 2));
}

function loadSourcePages() {
  const pages = [];
  for (const root of sourceRoots) {
    const absRoot = path.join(repoRoot, root);
    for (const filePath of walkJsonFiles(absRoot)) {
      try {
        const page = JSON.parse(fs.readFileSync(filePath, "utf8"));
        if (!page.id || !Array.isArray(page.sections)) continue;
        pages.push({
          ...page,
          __sourcePath: path.relative(repoRoot, filePath),
        });
      } catch {
        // Keep the audit focused on readable JSON pages.
      }
    }
  }
  return pages.sort((a, b) => a.id.localeCompare(b.id));
}

function walkJsonFiles(dir, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const name of fs.readdirSync(dir)) {
    const filePath = path.join(dir, name);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) walkJsonFiles(filePath, out);
    else if (name.endsWith(".json") && !name.startsWith("_")) out.push(filePath);
  }
  return out;
}

function sourceCardCount(page) {
  return (page.sections ?? []).reduce((total, section) => total + cardKeys(section).length, 0);
}

function cardKeys(section) {
  return (section?.phrases ?? []).map((phrase) => (
    phrase.detailPageID
    || phrase.id
    || `${normalizeText(phrase.vietnamese)}|${normalizeText(phrase.english)}`
  )).filter(Boolean);
}

function multiset(values) {
  const out = new Map();
  for (const value of values) out.set(value, (out.get(value) ?? 0) + 1);
  return out;
}

function sampleDiff(sourceCounts, renderedCounts) {
  const sourceOnly = [];
  const renderedOnly = [];
  const keys = new Set([...sourceCounts.keys(), ...renderedCounts.keys()]);
  for (const key of keys) {
    const delta = (sourceCounts.get(key) ?? 0) - (renderedCounts.get(key) ?? 0);
    if (delta > 0) sourceOnly.push(`${key} x${delta}`);
    if (delta < 0) renderedOnly.push(`${key} x${-delta}`);
  }
  return [
    sourceOnly.length ? `source-only: ${sourceOnly.slice(0, 5).join("; ")}` : "",
    renderedOnly.length ? `rendered-only: ${renderedOnly.slice(0, 5).join("; ")}` : "",
  ].filter(Boolean).join(" | ");
}

function summarize(rows, sourcePageCount) {
  const out = {
    sourcePageCount,
    mismatchRows: rows.length,
    pageMismatchCount: new Set(rows.map((row) => row.pageID)).size,
    uniqueSourceCardMissingRows: rows.filter((row) => row.severity === "UNIQUE_SOURCE_CARD_MISSING").length,
    sectionLayoutDiffRows: rows.filter((row) => row.severity === "SECTION_LAYOUT_DIFF").length,
    hardBlockRows: rows.filter((row) => row.severity === "HARD_BLOCK").length,
    sourceOnlyCards: rows.reduce((total, row) => total + row.sourceOnly, 0),
    renderedOnlyCards: rows.reduce((total, row) => total + row.renderedOnly, 0),
  };
  out.recommendation = out.hardBlockRows > 0 || out.uniqueSourceCardMissingRows > 0
    ? "REVISE_BEFORE_PRODUCTION"
    : out.mismatchRows > 0 ? "PASS_WITH_RISKS" : "PASS";
  return out;
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

function severityRank(severity) {
  return {
    HARD_BLOCK: 0,
    UNIQUE_SOURCE_CARD_MISSING: 1,
    SECTION_LAYOUT_DIFF: 2,
  }[severity] ?? 3;
}

function writeJson(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function writeCsv(filePath, rows) {
  const header = [
    "severity",
    "pageID",
    "tierRole",
    "englishTitle",
    "sourcePath",
    "sectionID",
    "sourceCount",
    "renderedCount",
    "sourceOnly",
    "renderedOnly",
    "note",
  ];
  const lines = [header.join(",")];
  for (const row of rows) {
    lines.push(header.map((field) => csv(row[field])).join(","));
  }
  fs.writeFileSync(filePath, `${lines.join("\n")}\n`);
}

function csv(value) {
  const text = String(value ?? "");
  return /[",\n]/.test(text) ? `"${text.replace(/"/g, '""')}"` : text;
}

main();
