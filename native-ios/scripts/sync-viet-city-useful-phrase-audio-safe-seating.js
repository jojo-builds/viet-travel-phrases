#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const sourceDir = path.join(repoRoot, "content-draft/viet/city-library/app-detail-v2-2");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const riskySeatingPhraseIDs = new Set([
  "v900-food-drin-can-we-sit-inside",
  "v900-food-drin-can-we-sit-outside"
]);

const replacementCard = {
  vi: "Cho tôi bàn cho hai người nhé",
  en: "A table for two, please",
  intent: "food-drink",
  phraseId: "food-need-table",
  audioId: "food-need-table",
  status: "mapped"
};

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJson(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function countPhraseCards(entry) {
  return Array.isArray(entry.usefulPhraseCards) ? entry.usefulPhraseCards.length : 0;
}

function cardLabel(card) {
  return `${card.en ?? ""} => ${card.vi ?? ""}`;
}

function syncFile(filePath) {
  const beforeText = fs.readFileSync(filePath, "utf8");
  const data = JSON.parse(beforeText);
  const ledgerRows = [];
  let replacements = 0;

  for (const entry of data.entries ?? []) {
    if (!Array.isArray(entry.usefulPhraseCards)) continue;
    const beforeCards = entry.usefulPhraseCards.map((card) => ({ ...card }));
    let touched = false;
    entry.usefulPhraseCards = entry.usefulPhraseCards.map((card) => {
      if (!riskySeatingPhraseIDs.has(card.phraseId)) return card;
      touched = true;
      replacements += 1;
      return { ...replacementCard };
    });

    if (!touched) continue;
    const afterCards = entry.usefulPhraseCards.map((card) => ({ ...card }));
    ledgerRows.push({
      pageID: entry.pageID ?? entry.id,
      sourcePath: path.relative(repoRoot, filePath),
      sectionID: "usefulPhraseCards",
      sectionTitle: "Useful Phrase cards",
      before: beforeCards.map(cardLabel),
      after: afterCards.map(cardLabel),
      preservedPhraseCards: countPhraseCards(entry),
      preservedRelatedCards: (entry.relatedPlaceCandidates ?? []).length,
      preservedMentionedCards: (entry.mentionedHereCandidates ?? []).length,
      concreteTravelerValueImproved: "kept a restaurant seating phrase on the city page while using a bundled-audio card instead of a planned-audio seating request",
      reason: "city_useful_phrase_audio_safe_seating_no_thinning"
    });
  }

  const afterText = `${JSON.stringify(data, null, 2)}\n`;
  if (afterText !== beforeText) writeJson(filePath, data);
  return { replacements, ledgerRows };
}

function appendLedger(rows) {
  if (rows.length === 0) return;
  const previous = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter((line) => {
      if (!line.trim()) return false;
      try {
        return JSON.parse(line).reason !== "city_useful_phrase_audio_safe_seating_no_thinning";
      } catch {
        return true;
      }
    })
    : [];
  const next = previous.concat(rows.map((row) => JSON.stringify(row)));
  fs.writeFileSync(ledgerPath, `${next.join("\n")}\n`);
}

function main() {
  const allRows = [];
  let totalReplacements = 0;
  for (const name of fs.readdirSync(sourceDir).sort()) {
    if (!name.endsWith(".json") || name.startsWith("_")) continue;
    const result = syncFile(path.join(sourceDir, name));
    totalReplacements += result.replacements;
    allRows.push(...result.ledgerRows);
  }
  appendLedger(allRows);
  console.log(JSON.stringify({
    totalReplacements,
    ledgerRows: allRows.length,
    replacementPhraseID: replacementCard.phraseId
  }, null, 2));
}

main();
