#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const sourcePath =
  "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-we-sit-inside.json";
const ledgerPath =
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl";

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function phraseCard({
  id,
  vietnamese,
  english,
  pronunciation,
  detailPageID,
  audioKey,
  symbolName = "speaker.wave.2.fill"
}) {
  return {
    id,
    vietnamese,
    english,
    pronunciation,
    symbolName,
    tintName: "green",
    detailPageID,
    audioKey
  };
}

const page = readJson(sourcePath);
const beforeExplore = (page.sections || []).find((section) => section.id === "explore-next");
const beforeNatural = (page.sections || []).find((section) => section.id === "natural-variants");
const afterCards = [
  phraseCard({
    id: "v900-food-drin-do-we-order-here-or-at-the-counter",
    vietnamese: "Chúng ta đặt hàng ở đây hay tại quầy?",
    english: "Do we order here or at the counter?",
    pronunciation: "Chung ta dat hang o day hay tai quay",
    detailPageID: "viet-phrase-v900-food-drin-do-we-order-here-or-at-the-counter",
    audioKey: "v900-food-drin-do-we-order-here-or-at-the-counter"
  }),
  phraseCard({
    id: "v900-food-drin-i-have-been-waiting-a-long-time",
    vietnamese: "Tôi đã chờ đợi rất lâu rồi",
    english: "I have been waiting a long time",
    pronunciation: "Toi da cho doi rat lau roi",
    detailPageID: "viet-phrase-v900-food-drin-i-have-been-waiting-a-long-time",
    audioKey: "v900-food-drin-i-have-been-waiting-a-long-time"
  }),
  phraseCard({
    id: "v900-food-drin-what-do-you-recommend",
    vietnamese: "Bạn đề xuất món gì?",
    english: "What do you recommend?",
    pronunciation: "Ban de xuat mon gi",
    detailPageID: "viet-phrase-v900-food-drin-what-do-you-recommend",
    audioKey: "v900-food-drin-what-do-you-recommend"
  }),
  phraseCard({
    id: "v900-food-drin-thats-all-thank-you",
    vietnamese: "Vậy thôi, cảm ơn",
    english: "That's all, thank you.",
    pronunciation: "Vay thoi cam on",
    symbolName: "text.bubble.fill",
    detailPageID: "viet-phrase-v900-food-drin-thats-all-thank-you",
    audioKey: "audio-authored-vay-thoi-cam-on-efab00a56b"
  }),
  phraseCard({
    id: "coffee-7",
    vietnamese: "Tính tiền giúp tôi",
    english: "Please let me pay",
    pronunciation: "ting tyen zoop toy",
    detailPageID: "viet-family-food-pay-now",
    audioKey: "coffee-7"
  })
];

page.sections = (page.sections || []).map((section) => {
  if (section.id === "explore-next") {
    return {
      ...section,
      body: "After you get seated, move to ordering at the counter, waiting a long time, asking what they recommend, saying that's all, or paying.",
      phrases: afterCards
    };
  }
  if (section.id === "natural-variants") {
    return {
      ...section,
      body: "Ordering, wait-time, recommendations, closing the order, and payment cards cover the restaurant flow after seating."
    };
  }
  return section;
});

writeJson(sourcePath, page);

const ledgerAbs = path.join(repoRoot, ledgerPath);
const ledgerRow = {
  batch: 21,
  tierRole: page.tierRole,
  sectionID: "explore-next",
  sectionTitle: "Explore next",
  pageID: page.id,
  phraseID: page.phraseID,
  sourcePath,
  before: {
    body: beforeExplore?.body ?? "",
    phraseCards: (beforeExplore?.phrases || []).map((phrase) => ({
      id: phrase.id,
      detailPageID: phrase.detailPageID,
      english: phrase.english
    })),
    nearbyBody: beforeNatural?.body ?? ""
  },
  after: {
    body: page.sections.find((section) => section.id === "explore-next")?.body ?? "",
    phraseCards: afterCards.map((phrase) => ({
      id: phrase.id,
      detailPageID: phrase.detailPageID,
      english: phrase.english
    })),
    nearbyBody: page.sections.find((section) => section.id === "natural-variants")?.body ?? ""
  },
  preservedPhraseCards: afterCards.length,
  concreteTravelerValueImproved:
    "mirrors the richer rendered restaurant-flow card set in source and aligns visible body copy with the actual cards",
  reason: "premium_audit_batch_21_card_parity"
};

const existing = fs.existsSync(ledgerAbs) ? fs.readFileSync(ledgerAbs, "utf8") : "";
const key = `${ledgerRow.reason}:${ledgerRow.pageID}:${ledgerRow.sectionID}`;
const hasKey = existing
  .split(/\n/)
  .filter(Boolean)
  .some((line) => {
    try {
      const row = JSON.parse(line);
      return `${row.reason}:${row.pageID}:${row.sectionID}` === key;
    } catch {
      return false;
    }
  });

if (!hasKey) {
  fs.appendFileSync(ledgerAbs, `${JSON.stringify(ledgerRow)}\n`);
}

console.log(JSON.stringify({
  batch: 21,
  pageID: page.id,
  beforeExploreCards: (beforeExplore?.phrases || []).length,
  afterExploreCards: afterCards.length,
  ledgerRows: hasKey ? 0 : 1,
  ledgerPath
}, null, 2));
