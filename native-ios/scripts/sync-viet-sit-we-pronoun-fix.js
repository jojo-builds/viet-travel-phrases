#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const fixes = [
  {
    phraseID: "v900-food-drin-can-we-sit-by-the-fan",
    pageID: "viet-phrase-v900-food-drin-can-we-sit-by-the-fan",
    oldVietnamese: "Chúng ta có thể ngồi cạnh quạt được không?",
    newVietnamese: "Chúng tôi có thể ngồi cạnh quạt được không?",
    oldPronunciation: "Chung ta co the ngoi canh quat duoc khong",
    newPronunciation: "Chung toi co the ngoi canh quat duoc khong",
    value: "changes restaurant seating request from inclusive we to traveler-party we"
  },
  {
    phraseID: "v900-food-drin-can-we-sit-inside",
    pageID: "viet-phrase-v900-food-drin-can-we-sit-inside",
    oldVietnamese: "Chúng ta có thể ngồi bên trong được không?",
    newVietnamese: "Chúng tôi có thể ngồi bên trong được không?",
    oldPronunciation: "Chung ta co the ngoi ben trong duoc khong",
    newPronunciation: "Chung toi co the ngoi ben trong duoc khong",
    value: "changes indoor-table request from inclusive we to traveler-party we"
  },
  {
    phraseID: "v900-food-drin-can-we-sit-outside",
    pageID: "viet-phrase-v900-food-drin-can-we-sit-outside",
    oldVietnamese: "Chúng ta có thể ngồi bên ngoài được không?",
    newVietnamese: "Chúng tôi có thể ngồi bên ngoài được không?",
    oldPronunciation: "Chung ta co the ngoi ben ngoai duoc khong",
    newPronunciation: "Chung toi co the ngoi ben ngoai duoc khong",
    value: "changes outdoor-table request from inclusive we to traveler-party we"
  },
  {
    phraseID: "v900-loca-serv-ever-task-can-we-sit-somewhere-cooler",
    pageID: "viet-phrase-v900-loca-serv-ever-task-can-we-sit-somewhere-cooler",
    oldVietnamese: "Chúng ta có thể ngồi chỗ nào mát hơn được không?",
    newVietnamese: "Chúng tôi có thể ngồi chỗ nào mát hơn được không?",
    oldPronunciation: "Chung ta co the ngoi cho nao mat hon duoc khong",
    newPronunciation: "Chung toi co the ngoi cho nao mat hon duoc khong",
    value: "syncs corrected cooler-seat phrase into inbound related cards"
  },
  {
    phraseID: "v900-loca-serv-ever-task-can-we-sit-somewhere-quieter",
    pageID: "viet-phrase-v900-loca-serv-ever-task-can-we-sit-somewhere-quieter",
    oldVietnamese: "Chúng ta có thể ngồi chỗ nào yên tĩnh hơn được không?",
    newVietnamese: "Chúng tôi có thể ngồi chỗ nào yên tĩnh hơn được không?",
    oldPronunciation: "Chung ta co the ngoi cho nao yen tinh hon duoc khong",
    newPronunciation: "Chung toi co the ngoi cho nao yen tinh hon duoc khong",
    value: "changes quieter-seat request from inclusive we to traveler-party we"
  }
];

const fixByPhraseID = new Map(fixes.map((fix) => [fix.phraseID, fix]));
const fixByPageID = new Map(fixes.map((fix) => [fix.pageID, fix]));
const fixByOldVietnamese = new Map(fixes.map((fix) => [fix.oldVietnamese, fix]));
const fixByOldPronunciation = new Map(fixes.map((fix) => [fix.oldPronunciation, fix]));
const touchedPages = [];
let activeFileFixes = [];

function walkFiles(dir, predicate, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const name of fs.readdirSync(dir)) {
    const abs = path.join(dir, name);
    const stat = fs.statSync(abs);
    if (stat.isDirectory()) walkFiles(abs, predicate, out);
    else if (predicate(abs)) out.push(abs);
  }
  return out;
}

function updateString(value) {
  let next = value;
  for (const fix of fixes) {
    next = next.split(fix.oldVietnamese).join(fix.newVietnamese);
    next = next.split(fix.oldPronunciation).join(fix.newPronunciation);
  }
  next = next.split("Chúng ta có thể asks can we").join("Chúng tôi có thể asks can we");
  next = next.split("Chúng ta có thể +").join("Chúng tôi có thể +");
  if (next === "Chúng ta có thể" && activeFileFixes.length > 0) return "Chúng tôi có thể";
  return next;
}

function updateNode(node) {
  if (typeof node === "string") return updateString(node);
  if (Array.isArray(node)) return node.map(updateNode);
  if (!node || typeof node !== "object") return node;

  const next = {};
  for (const [key, value] of Object.entries(node)) {
    next[key] = updateNode(value);
  }

  const phraseFix = fixByPhraseID.get(next.phraseID);
  if (phraseFix) {
    next.title = phraseFix.newVietnamese;
    next.pronunciation = phraseFix.newPronunciation;
    next.audioKey = null;
  }

  const cardFix = fixByPhraseID.get(next.id) || fixByPageID.get(next.detailPageID);
  if (cardFix && Object.prototype.hasOwnProperty.call(next, "vietnamese")) {
    next.vietnamese = cardFix.newVietnamese;
    next.pronunciation = cardFix.newPronunciation;
    next.audioKey = null;
    next.symbolName = "text.bubble.fill";
  }

  if (fixByOldVietnamese.has(next.vietnamese)) {
    const fix = fixByOldVietnamese.get(next.vietnamese);
    next.vietnamese = fix.newVietnamese;
    next.pronunciation = fix.newPronunciation;
    next.audioKey = null;
    next.symbolName = "text.bubble.fill";
  }
  if (fixByOldPronunciation.has(next.pronunciation)) {
    next.pronunciation = fixByOldPronunciation.get(next.pronunciation).newPronunciation;
  }

  return next;
}

function countSectionItems(page, key) {
  return (page.sections || []).reduce((total, section) => total + ((section[key] || []).length), 0);
}

function changedPhraseIDs(beforeText, afterText) {
  return fixes
    .filter((fix) => beforeText.includes(fix.oldVietnamese) || afterText.includes(fix.newVietnamese))
    .map((fix) => fix.phraseID);
}

function updateJsonFile(absPath) {
  const beforeText = fs.readFileSync(absPath, "utf8");
  activeFileFixes = fixes.filter((fix) => (
    beforeText.includes(fix.phraseID)
    || beforeText.includes(fix.pageID)
    || beforeText.includes(fix.oldVietnamese)
    || beforeText.includes(fix.newVietnamese)
  ));
  let before;
  try {
    before = JSON.parse(beforeText);
  } catch {
    return false;
  }
  const after = updateNode(before);
  const afterText = `${JSON.stringify(after, null, 2)}\n`;
  if (afterText === beforeText) return false;
  fs.writeFileSync(absPath, afterText);

  if (absPath.includes("/content-draft/viet/canonical-pages/")) {
    const page = after;
    if (page.id) {
      touchedPages.push({
        pageID: page.id,
        phraseID: page.phraseID ?? null,
        sourcePath: path.relative(repoRoot, absPath),
        changedPhraseIDs: changedPhraseIDs(beforeText, afterText),
        preservedPhraseCards: countSectionItems(page, "phrases"),
        preservedBreakdownRows: countSectionItems(page, "breakdown")
      });
    }
  }
  return true;
}

function parseCSV(text) {
  const rows = [];
  let row = [];
  let field = "";
  let quoted = false;
  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];
    if (quoted) {
      if (char === "\"" && next === "\"") {
        field += "\"";
        i += 1;
      } else if (char === "\"") quoted = false;
      else field += char;
    } else if (char === "\"") quoted = true;
    else if (char === ",") {
      row.push(field);
      field = "";
    } else if (char === "\n") {
      row.push(field);
      rows.push(row);
      row = [];
      field = "";
    } else if (char !== "\r") field += char;
  }
  if (field.length || row.length) {
    row.push(field);
    rows.push(row);
  }
  return rows.filter((item) => item.length > 1 || item[0] !== "");
}

function formatCSV(rows, bomMode) {
  const body = rows.map((row, rowIndex) => row.map((field, fieldIndex) => {
    let value = String(field ?? "");
    if (rowIndex === 0 && fieldIndex === 0) {
      value = value.replace(/^[\ufeff]+/, "");
      if (bomMode === "first-header-cell") value = `\ufeff${value}`;
    }
    return `"${value.replace(/"/g, "\"\"")}"`;
  }).join(",")).join("\n");
  return `${bomMode === "file" ? "\ufeff" : ""}${body}\n`;
}

function updateCSV(relPath) {
  const absPath = path.join(repoRoot, relPath);
  if (!fs.existsSync(absPath)) return 0;
  const original = fs.readFileSync(absPath, "utf8");
  const rows = parseCSV(original);
  const hasHeaderCellBOM = /^[\ufeff]+/.test(String(rows[0]?.[0] ?? "")) || original.startsWith("\"\ufeff");
  const bomMode = hasHeaderCellBOM
    ? "first-header-cell"
    : original.charCodeAt(0) === 0xfeff
      ? "file"
      : "none";
  const header = rows[0].map((name) => String(name).replace(/^[\ufeff]+/, ""));
  const index = Object.fromEntries(header.map((name, i) => [name, i]));
  let changed = 0;
  for (let i = 1; i < rows.length; i += 1) {
    const row = rows[i];
    const fix = fixByPhraseID.get(row[index.phrase_id]);
    if (!fix) continue;
    row[index.target_text] = fix.newVietnamese;
    row[index.canonical_target_text] = fix.newVietnamese;
    row[index.pronunciation] = fix.newPronunciation;
    row[index.audio_key] = "";
    row[index.audio_status] = "planned";
    changed += 1;
  }
  if (changed) fs.writeFileSync(absPath, formatCSV(rows, bomMode));
  return changed;
}

function updateRationaleJsonl() {
  const relPath = "content-draft/viet/canonical-pages/catalog-promoted/_ai-authoring-rationale.jsonl";
  const absPath = path.join(repoRoot, relPath);
  if (!fs.existsSync(absPath)) return 0;
  const lines = fs.readFileSync(absPath, "utf8").split(/\n/);
  let changed = 0;
  const out = lines.map((line) => {
    if (!line.trim()) return line;
    try {
      const row = JSON.parse(line);
      const fix = fixByPhraseID.get(row.phraseID);
      if (!fix) return line;
      row.vietnamese = fix.newVietnamese;
      row.pageThesis = updateString(row.pageThesis || "");
      row.audioDecision = "Exact audio now planned after traveler-party pronoun correction.";
      changed += 1;
      return JSON.stringify(row);
    } catch {
      return updateString(line);
    }
  });
  if (changed) fs.writeFileSync(absPath, out.join("\n"));
  return changed;
}

function appendLedger() {
  const existing = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean).map((line) => JSON.parse(line))
    : [];
  const kept = existing.filter((row) => row.reason !== "premium_audit_batch_45_sit_pronoun_sync");
  const pageRows = touchedPages
    .filter((page, index, pages) => pages.findIndex((item) => item.pageID === page.pageID) === index)
    .map((page) => ({
      batch: 45,
      tierRole: "mixed",
      sectionID: "sit-pronoun-sync",
      sectionTitle: "Traveler-party we pronoun sync",
      pageID: page.pageID,
      phraseID: page.phraseID,
      sourcePath: page.sourcePath,
      changedPhraseIDs: page.changedPhraseIDs,
      before: {
        issue: "related or primary seating phrase used inclusive chúng ta for a customer/group request"
      },
      after: {
        repair: "uses chúng tôi and planned audio where exact bundled audio no longer matches"
      },
      preservedPhraseCards: page.preservedPhraseCards,
      preservedBreakdownRows: page.preservedBreakdownRows,
      concreteTravelerValueImproved: "keeps seating requests aimed at staff from implying the staff member is part of the traveler group",
      reason: "premium_audit_batch_45_sit_pronoun_sync"
    }));
  fs.writeFileSync(ledgerPath, `${kept.concat(pageRows).map((row) => JSON.stringify(row)).join("\n")}\n`);
  return pageRows.length;
}

const jsonRoots = [
  path.join(repoRoot, "content-draft/viet/canonical-pages"),
  path.join(repoRoot, "content-draft/viet/breakdown-audit/pages"),
];

let jsonChanges = 0;
for (const root of jsonRoots) {
  for (const file of walkFiles(root, (abs) => abs.endsWith(".json"))) {
    if (updateJsonFile(file)) jsonChanges += 1;
  }
}
jsonChanges += updateJsonFile(path.join(repoRoot, "content-draft/viet/search-only-surfacing-v1.json")) ? 1 : 0;

const csvChanges = [
  updateCSV("content-draft/viet/phrase-source.csv"),
  updateCSV("content-draft/viet/autonomous-500/generated-rows.csv"),
  updateCSV("content-draft/viet/autonomous-900/generated-rows.csv")
];
const rationaleRows = updateRationaleJsonl();
const ledgerRowsAdded = appendLedger();

console.log(JSON.stringify({
  batch: 45,
  jsonChanges,
  csvChanges,
  rationaleRows,
  ledgerRowsAdded,
  touchedPages: touchedPages.map((page) => page.pageID)
}, null, 2));
