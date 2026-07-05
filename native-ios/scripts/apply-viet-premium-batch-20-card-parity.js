#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const sourceRoot = path.join(repoRoot, "content-draft/viet/canonical-pages/catalog-promoted");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const repairs = [
  {
    phraseID: "food-premium-without-this-ingredient",
    oldVietnamese: "Bạn có thể làm nó mà không cần thành phần này?",
    newVietnamese: "Bạn có thể làm món này không có nguyên liệu này được không?",
    english: "Can you make it without this ingredient?",
    pronunciation: "Ban co the lam mon nay khong co nguyen lieu nay duoc khong",
    value: "keeps the related ingredient-removal card while aligning it to the repaired canonical phrase text"
  },
  {
    phraseID: "v900-tran-please-wait-while-i-get-in",
    oldVietnamese: "Vui lòng đợi trong khi tôi vào",
    newVietnamese: "Vui lòng đợi tôi lên xe",
    english: "Please wait while I get in",
    pronunciation: "Vui long doi toi len xe",
    value: "keeps the ride-boarding card while aligning it to the repaired vehicle phrase text"
  }
];

function walkJSONFiles(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const files = [];
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...walkJSONFiles(fullPath));
    } else if (entry.isFile() && entry.name.endsWith(".json")) {
      files.push(fullPath);
    }
  }
  return files;
}

function pageIDFromSource(sourcePath) {
  const page = JSON.parse(fs.readFileSync(sourcePath, "utf8"));
  return page.id ?? page.pageID ?? path.basename(sourcePath, ".json");
}

function updatePlannedAudioPhraseCards(value, fileRepairs, updates) {
  if (!value || typeof value !== "object") {
    return;
  }
  if (Array.isArray(value)) {
    for (const item of value) {
      updatePlannedAudioPhraseCards(item, fileRepairs, updates);
    }
    return;
  }

  const repair = repairs.find((candidate) => candidate.phraseID === value.id);
  if (repair) {
    const before = {
      vietnamese: value.vietnamese,
      pronunciation: value.pronunciation,
      symbolName: value.symbolName,
      audioKey: value.audioKey
    };
    let changed = false;
    if (value.vietnamese === repair.oldVietnamese) {
      value.vietnamese = repair.newVietnamese;
      changed = true;
    }
    if ("pronunciation" in value && value.pronunciation !== repair.pronunciation) {
      value.pronunciation = repair.pronunciation;
      changed = true;
    }
    if ("symbolName" in value && value.symbolName !== "text.bubble.fill") {
      value.symbolName = "text.bubble.fill";
      changed = true;
    }
    if ("audioKey" in value && value.audioKey !== null) {
      value.audioKey = null;
      changed = true;
    }
    if (changed) {
      fileRepairs.push({ ...repair, occurrences: 1 });
      updates.push({
        repair,
        before,
        after: {
          vietnamese: value.vietnamese,
          pronunciation: value.pronunciation,
          symbolName: value.symbolName,
          audioKey: value.audioKey
        }
      });
    }
  }

  for (const child of Object.values(value)) {
    updatePlannedAudioPhraseCards(child, fileRepairs, updates);
  }
}

const sourceFiles = walkJSONFiles(sourceRoot);
const ledgerRows = [];
const changed = [];

for (const sourcePath of sourceFiles) {
  let text = fs.readFileSync(sourcePath, "utf8");
  let next = text;
  const fileRepairs = [];
  for (const repair of repairs) {
    if (!next.includes(repair.oldVietnamese)) {
      continue;
    }
    const occurrences = next.split(repair.oldVietnamese).length - 1;
    next = next.split(repair.oldVietnamese).join(repair.newVietnamese);
    fileRepairs.push({ ...repair, occurrences });
  }
  if (next === text) {
    const page = JSON.parse(text);
    const styleRepairs = [];
    const updates = [];
    updatePlannedAudioPhraseCards(page, styleRepairs, updates);
    if (updates.length === 0) {
      continue;
    }
    next = `${JSON.stringify(page, null, 2)}\n`;
    fs.writeFileSync(sourcePath, next);
    const relativeSourcePath = path.relative(repoRoot, sourcePath);
    const pageID = page.id ?? page.pageID ?? path.basename(sourcePath, ".json");
    changed.push({ pageID, sourcePath: relativeSourcePath, repairs: styleRepairs });
    for (const update of updates) {
      ledgerRows.push({
        batch: 20,
        tierRole: "catalog-promoted",
        sectionID: "visible-card-planned-audio-state",
        sectionTitle: "Visible phrase card planned-audio state",
        pageID,
        phraseID: update.repair.phraseID,
        sourcePath: relativeSourcePath,
        before: update.before,
        after: update.after,
        preservedPhraseCards: "all",
        preservedBreakdownRows: "unchanged",
        concreteTravelerValueImproved: "keeps the card visible while preventing a stale speaker icon for repaired phrase text",
        reason: "premium_audit_batch_20_card_parity"
      });
    }
    continue;
  }

  const page = JSON.parse(next);
  const styleRepairs = [];
  const updates = [];
  updatePlannedAudioPhraseCards(page, styleRepairs, updates);
  next = `${JSON.stringify(page, null, 2)}\n`;
  fs.writeFileSync(sourcePath, next);
  const relativeSourcePath = path.relative(repoRoot, sourcePath);
  const pageID = page.id ?? page.pageID ?? pageIDFromSource(sourcePath);
  changed.push({ pageID, sourcePath: relativeSourcePath, repairs: [...fileRepairs, ...styleRepairs] });
  for (const repair of fileRepairs) {
    ledgerRows.push({
      batch: 20,
      tierRole: "catalog-promoted",
      sectionID: "visible-card-text-parity",
      sectionTitle: "Visible phrase card text parity",
      pageID,
      phraseID: repair.phraseID,
      sourcePath: relativeSourcePath,
      before: {
        cardVietnamese: repair.oldVietnamese,
        cardEnglish: repair.english
      },
      after: {
        cardVietnamese: repair.newVietnamese,
        cardEnglish: repair.english
      },
      preservedPhraseCards: "all",
      preservedBreakdownRows: "unchanged",
      concreteTravelerValueImproved: repair.value,
      reason: "premium_audit_batch_20_card_parity"
    });
  }
  for (const update of updates) {
    ledgerRows.push({
      batch: 20,
      tierRole: "catalog-promoted",
      sectionID: "visible-card-planned-audio-state",
      sectionTitle: "Visible phrase card planned-audio state",
      pageID,
      phraseID: update.repair.phraseID,
      sourcePath: relativeSourcePath,
      before: update.before,
      after: update.after,
      preservedPhraseCards: "all",
      preservedBreakdownRows: "unchanged",
      concreteTravelerValueImproved: "keeps the card visible while preventing a stale speaker icon for repaired phrase text",
      reason: "premium_audit_batch_20_card_parity"
    });
  }
}

if (ledgerRows.length > 0) {
  fs.appendFileSync(ledgerPath, `${ledgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
}

console.log(JSON.stringify({
  changedPages: changed.length,
  replacementRows: ledgerRows.length,
  changed
}, null, 2));
