#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const renderedPath = path.join(repoRoot, "native-ios/Resources/viet-authored-listing-pages.json");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const repairs = [
  {
    id: "viet-phrase-v500-prob-help-can-you-check-the-security-camera",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-can-you-check-the-security-camera.json",
    sections: ["natural-variants"],
    value: "removed one duplicate source-only need-help card from natural variants because the same need-help action already renders once in Explore Next",
    parityType: "duplicate-source-card-demotion"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-have-chili-sauce",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-chili-sauce.json",
    sections: ["explore-next"],
    value: "aligned source to the richer rendered table-request card set: napkins, half portion, two of these, one more, and one portion",
    parityType: "source-card-enrichment"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-order-this-without-meat",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-order-this-without-meat.json",
    sections: ["explore-next"],
    value: "aligned source to the rendered allergy follow-up set so the no-meat page keeps the stricter food-safety cards",
    parityType: "source-card-enrichment"
  },
  {
    id: "viet-phrase-v900-food-drin-do-you-have-beer",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-do-you-have-beer.json",
    sections: ["when-to-use", "explore-next"],
    value: "aligned source to rendered drink and checkout follow-ups, including the current cup-of-ice wording and checkout cards",
    parityType: "source-card-enrichment"
  }
];

function readJson(absOrRelPath) {
  const absPath = path.isAbsolute(absOrRelPath) ? absOrRelPath : path.join(repoRoot, absOrRelPath);
  return JSON.parse(fs.readFileSync(absPath, "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function cardTarget(card) {
  return card.detailPageID || card.id;
}

function sectionCards(page, sectionID) {
  return (page.sections || []).find((section) => section.id === sectionID)?.phrases || [];
}

function main() {
  const renderedPages = readJson(renderedPath).pages;
  const renderedByID = new Map(renderedPages.map((page) => [page.id, page]));
  const ledgerRows = [];

  for (const repair of repairs) {
    const source = readJson(repair.source);
    const rendered = renderedByID.get(repair.id);
    if (!rendered) {
      throw new Error(`Missing rendered page ${repair.id}`);
    }

    const before = {};
    const after = {};
    source.sections = (source.sections || []).map((section) => {
      if (!repair.sections.includes(section.id)) return section;
      const renderedCards = sectionCards(rendered, section.id).map((card) => ({ ...card }));
      before[section.id] = (section.phrases || []).map(cardTarget);
      after[section.id] = renderedCards.map(cardTarget);
      return {
        ...section,
        phrases: renderedCards
      };
    });

    writeJson(repair.source, source);
    ledgerRows.push({
      batch: 19,
      tierRole: source.tierRole,
      sectionID: repair.sections.join(","),
      sectionTitle: "Source/render card parity addendum",
      pageID: source.id,
      phraseID: source.phraseID,
      sourcePath: repair.source,
      before: {
        cardTargetsBySection: before,
        issues: ["source-render card parity drift", repair.parityType]
      },
      after: {
        cardTargetsBySection: after
      },
      preservedPhraseCards: (source.sections || []).reduce((total, section) => total + ((section.phrases || []).length), 0),
      preservedBreakdownRows: (source.sections || []).reduce((total, section) => total + ((section.breakdown || []).length), 0),
      concreteTravelerValueImproved: repair.value,
      reason: "premium_audit_batch_19_card_parity"
    });
  }

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const existingKeys = new Set(existingLedgerRows.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}`];
    } catch {
      return [];
    }
  }));
  const newLedgerRows = ledgerRows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}`));
  if (newLedgerRows.length) {
    fs.appendFileSync(ledgerPath, `${newLedgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 19,
    parityAddenda: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    ledgerRows: newLedgerRows.length,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
