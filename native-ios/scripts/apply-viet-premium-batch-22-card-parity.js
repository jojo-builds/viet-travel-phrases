#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const sourcePath =
  "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-order-half-a-portion.json";
const renderedPath = "native-ios/Resources/viet-authored-listing-pages.json";
const ledgerPath =
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl";

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

const page = readJson(sourcePath);
const rendered = readJson(renderedPath);
const renderedPage = rendered.pages.find((candidate) => candidate.id === page.id);
if (!renderedPage) {
  throw new Error(`Rendered page not found: ${page.id}`);
}

const beforeExplore = (page.sections || []).find((section) => section.id === "explore-next");
const beforeNatural = (page.sections || []).find((section) => section.id === "natural-variants");
const renderedExplore = (renderedPage.sections || []).find((section) => section.id === "explore-next");
if (!beforeExplore || !renderedExplore) {
  throw new Error(`Explore next section missing for ${page.id}`);
}

const afterExploreBody =
  "Move to chili sauce, napkins, one portion, two of these, or one more cards if the order changes.";
const afterNaturalBody =
  "Chili sauce, napkins, one-portion, two-of-these, and one-more cards cover the order-size choices around it.";

page.sections = (page.sections || []).map((section) => {
  if (section.id === "explore-next") {
    return {
      ...section,
      body: afterExploreBody,
      phrases: renderedExplore.phrases.map((phrase) => ({ ...phrase }))
    };
  }
  if (section.id === "natural-variants") {
    return {
      ...section,
      body: afterNaturalBody
    };
  }
  return section;
});

writeJson(sourcePath, page);

const afterExplore = page.sections.find((section) => section.id === "explore-next");
const afterNatural = page.sections.find((section) => section.id === "natural-variants");
const ledgerRow = {
  batch: 22,
  tierRole: page.tierRole,
  sectionID: "explore-next",
  sectionTitle: "Explore next",
  pageID: page.id,
  phraseID: page.phraseID,
  sourcePath,
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
  concreteTravelerValueImproved:
    "mirrors the richer rendered food-order card set in source, growing Explore next from 2 to 5 cards and replacing a non-rendered lime source-only mismatch",
  reason: "premium_audit_batch_22_card_parity"
};

const ledgerAbs = path.join(repoRoot, ledgerPath);
const existing = fs.existsSync(ledgerAbs)
  ? fs.readFileSync(ledgerAbs, "utf8").split(/\n/).filter(Boolean)
  : [];
const key = `${ledgerRow.reason}:${ledgerRow.pageID}:${ledgerRow.sectionID}`;
let updated = 0;
const rewritten = existing.map((line) => {
  try {
    const row = JSON.parse(line);
    const rowKey = `${row.reason}:${row.pageID}:${row.sectionID}`;
    if (rowKey === key) {
      updated += 1;
      return JSON.stringify(ledgerRow);
    }
  } catch {
    return line;
  }
  return line;
});
if (updated === 0) {
  rewritten.push(JSON.stringify(ledgerRow));
}
fs.writeFileSync(ledgerAbs, `${rewritten.join("\n")}\n`);

console.log(JSON.stringify({
  batch: 22,
  pageID: page.id,
  beforeExploreCards: (beforeExplore.phrases || []).length,
  afterExploreCards: afterExplore.phrases.length,
  ledgerRows: updated === 0 ? 1 : 0,
  updatedLedgerRows: updated,
  ledgerPath
}, null, 2));
