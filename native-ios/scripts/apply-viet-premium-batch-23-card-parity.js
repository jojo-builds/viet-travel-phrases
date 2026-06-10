#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const renderedPath = "native-ios/Resources/viet-authored-listing-pages.json";
const ledgerPath =
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl";

const repairs = [
  {
    sourcePath: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-17.json",
    pageID: "viet-phrase-food-17",
    exploreBody:
      "Move to smaller bills, exact change, break-this-bill, pay-now, or card-payment cards if payment gets more specific.",
    naturalBody:
      "Receipt, bill-by-card, remove-item, bill-mistake, and thank-you cards cover the rest of the payment flow.",
    value:
      "mirrors the richer rendered split-payment card set in source, growing Explore next from 2 to 5 cards without removing payment support"
  },
  {
    sourcePath: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-i-ordered-this-without-peanuts.json",
    pageID: "viet-phrase-v500-food-drin-i-ordered-this-without-peanuts",
    exploreBody:
      "Move to no-meat, fish-sauce allergy, shellfish allergy, cannot-eat-allergy, or no-peanuts cards if the ingredient check continues.",
    naturalBody:
      "No-meat, without-this-ingredient, safest-dish, pork-beef-chicken, and shrimp cards cover nearby ingredient checks.",
    value:
      "mirrors the richer rendered allergy card set in source, growing Explore next from 2 to 5 cards without weakening the allergy path"
  }
];

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function phraseSummary(phrases) {
  return (phrases || []).map((phrase) => ({
    id: phrase.id,
    detailPageID: phrase.detailPageID,
    english: phrase.english
  }));
}

const rendered = readJson(renderedPath);
const ledgerRows = [];

for (const repair of repairs) {
  const page = readJson(repair.sourcePath);
  const renderedPage = rendered.pages.find((candidate) => candidate.id === repair.pageID);
  if (!renderedPage) {
    throw new Error(`Rendered page not found: ${repair.pageID}`);
  }
  const beforeExplore = (page.sections || []).find((section) => section.id === "explore-next");
  const beforeNatural = (page.sections || []).find((section) => section.id === "natural-variants");
  const renderedExplore = (renderedPage.sections || []).find((section) => section.id === "explore-next");
  if (!beforeExplore || !renderedExplore) {
    throw new Error(`Explore next section missing for ${repair.pageID}`);
  }

  page.sections = (page.sections || []).map((section) => {
    if (section.id === "explore-next") {
      return {
        ...section,
        body: repair.exploreBody,
        phrases: renderedExplore.phrases.map((phrase) => ({ ...phrase }))
      };
    }
    if (section.id === "natural-variants") {
      return {
        ...section,
        body: repair.naturalBody
      };
    }
    return section;
  });

  writeJson(repair.sourcePath, page);
  const afterExplore = page.sections.find((section) => section.id === "explore-next");
  const afterNatural = page.sections.find((section) => section.id === "natural-variants");

  ledgerRows.push({
    batch: 23,
    tierRole: page.tierRole,
    sectionID: "explore-next",
    sectionTitle: "Explore next",
    pageID: page.id,
    phraseID: page.phraseID,
    sourcePath: repair.sourcePath,
    before: {
      body: beforeExplore.body ?? "",
      phraseCards: phraseSummary(beforeExplore.phrases),
      nearbyBody: beforeNatural?.body ?? ""
    },
    after: {
      body: afterExplore.body ?? "",
      phraseCards: phraseSummary(afterExplore.phrases),
      nearbyBody: afterNatural?.body ?? ""
    },
    preservedPhraseCards: afterExplore.phrases.length,
    concreteTravelerValueImproved: repair.value,
    reason: "premium_audit_batch_23_card_parity"
  });
}

const ledgerAbs = path.join(repoRoot, ledgerPath);
const existing = fs.existsSync(ledgerAbs)
  ? fs.readFileSync(ledgerAbs, "utf8").split(/\n/).filter(Boolean)
  : [];
const ledgerRowsByKey = new Map(
  ledgerRows.map((row) => [`${row.reason}:${row.pageID}:${row.sectionID}`, row])
);
let updatedLedgerRows = 0;
const rewritten = existing.map((line) => {
  try {
    const row = JSON.parse(line);
    const key = `${row.reason}:${row.pageID}:${row.sectionID}`;
    if (ledgerRowsByKey.has(key)) {
      updatedLedgerRows += 1;
      return JSON.stringify(ledgerRowsByKey.get(key));
    }
  } catch {
    return line;
  }
  return line;
});
const existingKeys = new Set(existing.flatMap((line) => {
  try {
    const row = JSON.parse(line);
    return [`${row.reason}:${row.pageID}:${row.sectionID}`];
  } catch {
    return [];
  }
}));
const newLedgerRows = ledgerRows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}:${row.sectionID}`));
fs.writeFileSync(ledgerAbs, `${[...rewritten, ...newLedgerRows.map((row) => JSON.stringify(row))].join("\n")}\n`);

console.log(JSON.stringify({
  batch: 23,
  repairedPages: repairs.length,
  pageIDs: repairs.map((repair) => repair.pageID),
  beforeExploreCards: ledgerRows.map((row) => row.before.phraseCards.length),
  afterExploreCards: ledgerRows.map((row) => row.after.phraseCards.length),
  ledgerRows: newLedgerRows.length,
  updatedLedgerRows,
  ledgerPath
}, null, 2));
