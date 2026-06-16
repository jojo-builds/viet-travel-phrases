#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);
const renderedPagesPath = path.join(repoRoot, "native-ios/Resources/viet-authored-listing-pages.json");

const repairs = [
  {
    pageID: "viet-phrase-v500-food-drin-i-am-allergic-to-fish-sauce",
    phraseID: "v500-food-drin-i-am-allergic-to-fish-sauce",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-i-am-allergic-to-fish-sauce.json",
    sectionID: "explore-next",
    body: "No-meat, shellfish, general-allergy, and peanut-repair pages cover the next allergy check.",
    value: "aligns source allergy follow-up cards with the richer rendered allergy-repair card set"
  },
  {
    pageID: "viet-phrase-food-16",
    phraseID: "food-16",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-16.json",
    sectionID: "explore-next",
    body: "Chili, napkin, half-portion, two-of-these, and one-more pages help after the right dish is back in front of you.",
    value: "aligns source wrong-order follow-up cards with the richer rendered restaurant-correction card set"
  },
  {
    pageID: "viet-phrase-v500-food-drin-this-tastes-spoiled",
    phraseID: "v500-food-drin-this-tastes-spoiled",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-this-tastes-spoiled.json",
    sectionID: "explore-next",
    body: "Undercooked, cold, something-in-my-food, and change-this pages cover the replacement or correction path.",
    value: "removes a source-only wrong-order card that the native renderer already omits while preserving the rendered correction card"
  }
];

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function cardKey(card) {
  return card.detailPageID || card.id;
}

function countSectionItems(page, key) {
  return (page.sections || []).reduce((total, section) => total + ((section[key] || []).length), 0);
}

function appendLedger(rows) {
  const existing = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const existingKeys = new Set(existing.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}:${row.sectionID}`];
    } catch {
      return [];
    }
  }));
  const freshRows = rows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}:${row.sectionID}`));
  if (freshRows.length) {
    fs.appendFileSync(ledgerPath, `${freshRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }
  return freshRows.length;
}

function main() {
  const renderedPages = JSON.parse(fs.readFileSync(renderedPagesPath, "utf8")).pages;
  const ledgerRows = [];

  for (const repair of repairs) {
    const renderedPage = renderedPages.find((page) => page.id === repair.pageID);
    if (!renderedPage) throw new Error(`Rendered page not found: ${repair.pageID}`);
    const renderedSection = (renderedPage.sections || []).find((section) => section.id === repair.sectionID);
    if (!renderedSection) throw new Error(`Rendered section not found: ${repair.pageID} ${repair.sectionID}`);

    const sourcePage = readJson(repair.source);
    const sourceSection = (sourcePage.sections || []).find((section) => section.id === repair.sectionID);
    if (!sourceSection) throw new Error(`Source section not found: ${repair.pageID} ${repair.sectionID}`);

    const beforeCards = (sourceSection.phrases || []).map(cardKey);
    const beforeBody = sourceSection.body;
    const renderedCards = (renderedSection.phrases || []).map((card) => ({ ...card }));

    sourceSection.body = repair.body;
    sourceSection.phrases = renderedCards;
    writeJson(repair.source, sourcePage);

    ledgerRows.push({
      batch: 30,
      tierRole: sourcePage.tierRole,
      sectionID: `card-parity:${repair.sectionID}`,
      sectionTitle: "Source/render card parity",
      pageID: sourcePage.id,
      phraseID: sourcePage.phraseID,
      sourcePath: repair.source,
      before: {
        body: beforeBody,
        cardTargets: beforeCards
      },
      after: {
        body: sourceSection.body,
        cardTargets: sourceSection.phrases.map(cardKey)
      },
      preservedRenderedPhraseCards: countSectionItems(renderedPage, "phrases"),
      preservedSourcePhraseCards: countSectionItems(sourcePage, "phrases"),
      concreteTravelerValueImproved: repair.value,
      reason: "premium_audit_batch_30_card_parity"
    });
  }

  const ledgerRowsAdded = appendLedger(ledgerRows);
  console.log(JSON.stringify({
    batch: 30,
    repairedCardParityPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.pageID),
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
