#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const repairSources = [
  "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-do-i-need-exact-change.json",
  "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/v500-poli-basi-sorry.json",
  "content-draft/viet/canonical-pages/catalog-promoted/bathroom-personal-needs/v900-bath-pers-need-is-there-a-fee-for-the-bathroom.json",
  "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-rice-with-this.json",
  "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-that-was-very-good.json",
  "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-is-this-safe-with-my-medicine.json",
  "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-please-write-the-instructions.json",
  "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/v900-poli-basi-im-in-a-hurry.json"
];

const cityAudioBackedSubstitutions = new Map([
  [
    "v900-food-drin-can-i-have-rice-with-this",
    {
      vi: "Cho tôi một phần",
      en: "One portion please",
      intent: "food-drink",
      phraseId: "food-1",
      audioId: "food-1",
      status: "mapped"
    }
  ],
  [
    "v900-food-drin-that-was-very-good",
    {
      vi: "Đồ ăn ngon quá",
      en: "The food is so good",
      intent: "food-drink",
      phraseId: "smalltalk-5",
      audioId: "smalltalk-5",
      status: "mapped"
    }
  ]
]);

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function isPlainObject(value) {
  return Boolean(value) && typeof value === "object" && !Array.isArray(value);
}

function findJsonFiles(dir) {
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const entryPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...findJsonFiles(entryPath));
    } else if (entry.isFile() && entry.name.endsWith(".json")) {
      files.push(entryPath);
    }
  }
  return files.sort();
}

function countPhraseCards(value) {
  let count = 0;
  function visit(node) {
    if (!node || typeof node !== "object") return;
    if (Array.isArray(node)) {
      node.forEach(visit);
      return;
    }
    if (
      Object.prototype.hasOwnProperty.call(node, "detailPageID")
      || Object.prototype.hasOwnProperty.call(node, "phraseId")
      || Object.prototype.hasOwnProperty.call(node, "phraseID")
    ) {
      count += 1;
    }
    Object.values(node).forEach(visit);
  }
  visit(value);
  return count;
}

function buildRepairMaps() {
  const byPhraseID = new Map();
  const byPageID = new Map();
  for (const relPath of repairSources) {
    const page = readJson(relPath);
    const repair = {
      pageID: page.id,
      phraseID: page.phraseID,
      sourcePath: relPath,
      vietnamese: page.title,
      english: page.englishTitle,
      pronunciation: page.pronunciation,
      audioKey: page.audioKey ?? null,
      symbolName: page.audioKey ? "speaker.wave.2.fill" : "text.bubble.fill"
    };
    byPhraseID.set(page.phraseID, repair);
    byPageID.set(page.id, repair);
  }
  return { byPhraseID, byPageID };
}

function syncCardObject(node, maps) {
  if (!isPlainObject(node)) return false;
  const repair = maps.byPhraseID.get(node.id)
    ?? maps.byPhraseID.get(node.phraseId)
    ?? maps.byPhraseID.get(node.phraseID)
    ?? maps.byPageID.get(node.detailPageID);
  if (!repair) return false;

  let changed = false;
  const assign = (key, value) => {
    if (Object.prototype.hasOwnProperty.call(node, key) && node[key] !== value) {
      node[key] = value;
      changed = true;
    }
  };

  assign("vietnamese", repair.vietnamese);
  assign("vi", repair.vietnamese);
  assign("english", repair.english);
  assign("en", repair.english);
  assign("pronunciation", repair.pronunciation);
  assign("symbolName", repair.symbolName);
  assign("audioKey", repair.audioKey);
  return changed;
}

function syncJsonTree(value, maps) {
  let changed = false;
  function visit(node) {
    if (!node || typeof node !== "object") return;
    if (Array.isArray(node)) {
      node.forEach(visit);
      return;
    }
    if (syncCardObject(node, maps)) changed = true;
    Object.values(node).forEach(visit);
  }
  visit(value);
  return changed;
}

function syncCanonicalReferences(maps, ledgerRows) {
  const root = path.join(repoRoot, "content-draft/viet/canonical-pages");
  const files = findJsonFiles(root);
  let changedFiles = 0;
  let changedPages = 0;

  for (const absPath of files) {
    const relPath = path.relative(repoRoot, absPath);
    const beforeText = fs.readFileSync(absPath, "utf8");
    const data = JSON.parse(beforeText);
    const beforeCards = countPhraseCards(data);
    if (!syncJsonTree(data, maps)) continue;
    const afterCards = countPhraseCards(data);
    writeJson(relPath, data);
    changedFiles += 1;
    changedPages += 1;
    ledgerRows.push({
      batch: 25,
      tierRole: "reference-sync",
      sectionID: "phrase-card-reference",
      sectionTitle: "Phrase card reference",
      pageID: data.id ?? data.pageID ?? relPath,
      phraseID: data.phraseID ?? null,
      sourcePath: relPath,
      before: {
        phraseCards: beforeCards,
        issue: "stale related-card text or audio state after Batch 25 semantic phrase repair"
      },
      after: {
        phraseCards: afterCards,
        repair: "synced referenced phrase card text/pronunciation/audio state to authored source"
      },
      preservedPhraseCards: afterCards,
      preservedBreakdownRows: 0,
      concreteTravelerValueImproved: "keeps related phrase cards consistent with the repaired phrase page without deleting cards",
      reason: "premium_audit_batch_25_reference_sync"
    });
  }

  return { changedFiles, changedPages };
}

function syncSearchOnlyPlacements(maps) {
  const relPath = "content-draft/viet/search-only-surfacing-v1.json";
  const data = readJson(relPath);
  let changed = 0;
  for (const entry of data.placements ?? data.entries ?? []) {
    const repair = maps.byPhraseID.get(entry.phraseID)
      ?? maps.byPageID.get(entry.canonicalPageID)
      ?? maps.byPageID.get(entry.originalPageID);
    if (!repair) continue;
    if (entry.vietnameseTitle !== repair.vietnamese) {
      entry.vietnameseTitle = repair.vietnamese;
      changed += 1;
    }
  }
  if (changed) writeJson(relPath, data);
  return changed;
}

function syncCityUsefulPhraseCards(ledgerRows) {
  const relPath = "content-draft/viet/city-library/app-detail-v2-2/hcmc.json";
  const data = readJson(relPath);
  let changed = 0;
  for (const entry of data.entries ?? []) {
    let touched = false;
    const beforeCards = Array.isArray(entry.usefulPhraseCards)
      ? entry.usefulPhraseCards.map((card) => ({ ...card }))
      : [];
    entry.usefulPhraseCards = (entry.usefulPhraseCards ?? []).map((card) => {
      const replacement = cityAudioBackedSubstitutions.get(card.phraseId);
      if (!replacement) return card;
      touched = true;
      changed += 1;
      return { ...replacement };
    });
    if (touched) {
      ledgerRows.push({
        batch: 25,
        tierRole: "city-useful-phrase-card",
        sectionID: "usefulPhraseCards",
        sectionTitle: "Useful phrase cards",
        pageID: entry.pageID ?? entry.id,
        phraseID: null,
        sourcePath: relPath,
        before: {
          cards: beforeCards
        },
        after: {
          cards: entry.usefulPhraseCards
        },
        preservedPhraseCards: entry.usefulPhraseCards.length,
        preservedBreakdownRows: 0,
        concreteTravelerValueImproved: "keeps FINAL_PASS city cards audio-backed after Batch 25 semantic phrase repairs",
        reason: "premium_audit_batch_25_city_audio_backed_substitution"
      });
    }
  }
  if (changed) writeJson(relPath, data);
  return changed;
}

function syncLegacyCityRuntimeProjection(ledgerRows) {
  const relPath = "content-draft/viet/city-library/v1.json";
  const data = readJson(relPath);
  const replacementsByPageID = new Map([
    ["city-hcmc-place-bep-me-in", new Map([["v900-food-drin-can-i-have-rice-with-this", "food-1"]])],
    ["city-hcmc-place-cuc-gach-quan", new Map([["v900-food-drin-can-i-have-rice-with-this", "food-1"]])],
    ["city-hcmc-place-man-moi", new Map([["v900-food-drin-that-was-very-good", "smalltalk-5"]])]
  ]);
  let changed = 0;

  for (const page of data.pages ?? []) {
    const replacements = replacementsByPageID.get(page.id);
    if (!replacements) continue;
    for (const section of page.editorialImport?.sections ?? []) {
      if (!Array.isArray(section.phraseIDs)) continue;
      const before = [...section.phraseIDs];
      section.phraseIDs = section.phraseIDs.map((phraseID) => replacements.get(phraseID) ?? phraseID);
      if (JSON.stringify(before) !== JSON.stringify(section.phraseIDs)) {
        changed += 1;
        ledgerRows.push({
          batch: 25,
          tierRole: "city-v1-runtime-projection",
          sectionID: section.id,
          sectionTitle: section.title,
          pageID: page.id,
          phraseID: null,
          sourcePath: relPath,
          before: {
            phraseIDs: before
          },
          after: {
            phraseIDs: section.phraseIDs
          },
          preservedPhraseCards: section.phraseIDs.length,
          preservedBreakdownRows: 0,
          concreteTravelerValueImproved: "keeps the current native city runtime projection audio-backed after Batch 25 semantic phrase repairs",
          reason: "premium_audit_batch_25_city_v1_projection_sync"
        });
      }
    }
  }

  if (changed) writeJson(relPath, data);
  return changed;
}

function appendLedger(rows) {
  const existing = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const existingKeys = new Set(existing.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}`];
    } catch {
      return [];
    }
  }));
  const freshRows = rows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}`));
  if (freshRows.length) {
    fs.appendFileSync(ledgerPath, `${freshRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }
  return freshRows.length;
}

function main() {
  const maps = buildRepairMaps();
  const ledgerRows = [];
  const canonical = syncCanonicalReferences(maps, ledgerRows);
  const searchOnlyPlacements = syncSearchOnlyPlacements(maps);
  const cityUsefulPhraseCards = syncCityUsefulPhraseCards(ledgerRows);
  const cityV1RuntimeProjection = syncLegacyCityRuntimeProjection(ledgerRows);
  const ledgerRowsAdded = appendLedger(ledgerRows);

  console.log(JSON.stringify({
    batch: 25,
    canonical,
    searchOnlyPlacements,
    cityUsefulPhraseCards,
    cityV1RuntimeProjection,
    ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
