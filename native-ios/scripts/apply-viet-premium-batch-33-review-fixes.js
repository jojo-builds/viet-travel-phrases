#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const penicillinPath = "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-am-allergic-to-penicillin.json";
const simPath = "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-the-sim-card-is-not-working.json";

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function walkJsonFiles(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const abs = path.join(dir, name);
    const stat = fs.statSync(abs);
    if (stat.isDirectory()) walkJsonFiles(abs, out);
    else if (name.endsWith(".json")) out.push(abs);
  }
  return out;
}

function indexPages() {
  const byID = new Map();
  const roots = [
    path.join(repoRoot, "content-draft/viet/canonical-pages/catalog-promoted"),
    path.join(repoRoot, "content-draft/viet/canonical-pages/tier-one")
  ];
  for (const root of roots) {
    for (const absPath of walkJsonFiles(root)) {
      const page = JSON.parse(fs.readFileSync(absPath, "utf8"));
      if (page.id) byID.set(page.id, page);
    }
  }
  return byID;
}

function phraseCardFor(page) {
  return {
    id: page.phraseID,
    vietnamese: page.title,
    english: page.englishTitle,
    pronunciation: page.pronunciation,
    symbolName: page.audioKey ? "speaker.wave.2.fill" : "text.bubble.fill",
    tintName: page.tintName || "teal",
    detailPageID: page.id,
    audioKey: page.audioKey ?? null
  };
}

function sectionCardTargets(section) {
  return (section?.phrases || []).map((card) => card.detailPageID || card.id);
}

function countSectionItems(page, key) {
  return (page.sections || []).reduce((total, section) => total + ((section[key] || []).length), 0);
}

function replaceSectionCards(page, sectionID, targetIDs, pageIndex) {
  const section = (page.sections || []).find((item) => item.id === sectionID);
  if (!section) throw new Error(`Missing section ${sectionID} on ${page.id}`);
  section.phrases = targetIDs.map((targetID) => {
    const target = pageIndex.get(targetID);
    if (!target) throw new Error(`Missing card target ${targetID} for ${page.id}`);
    return phraseCardFor(target);
  });
}

function setSectionBody(page, sectionID, body) {
  const section = (page.sections || []).find((item) => item.id === sectionID);
  if (!section) throw new Error(`Missing section ${sectionID} on ${page.id}`);
  section.body = body;
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
  const pageIndex = indexPages();
  const ledgerRows = [];

  const penicillin = readJson(penicillinPath);
  const penicillinBefore = JSON.parse(JSON.stringify(penicillin));
  setSectionBody(
    penicillin,
    "explore-next",
    "If staff need to check the medicine, ask about availability, interactions, alcohol, sleepiness, or whether it is safe with your regular medicine."
  );
  replaceSectionCards(penicillin, "explore-next", [
    "viet-phrase-v900-heal-phar-do-you-have-this-medicine",
    "viet-phrase-v900-heal-phar-please-check-for-drug-interactions",
    "viet-phrase-v900-heal-phar-can-i-drink-alcohol-with-this",
    "viet-phrase-v900-heal-phar-will-this-make-me-sleepy",
    "viet-phrase-v900-heal-phar-is-this-safe-with-my-medicine"
  ], pageIndex);
  writeJson(penicillinPath, penicillin);
  ledgerRows.push({
    batch: 33,
    tierRole: penicillin.tierRole,
    sectionID: "review-gate:penicillin-explore-next",
    sectionTitle: "Review-gate explore-next copy/card alignment",
    pageID: penicillin.id,
    phraseID: penicillin.phraseID,
    sourcePath: penicillinPath,
    before: {
      body: (penicillinBefore.sections || []).find((item) => item.id === "explore-next")?.body,
      cardTargets: sectionCardTargets((penicillinBefore.sections || []).find((item) => item.id === "explore-next"))
    },
    after: {
      body: (penicillin.sections || []).find((item) => item.id === "explore-next")?.body,
      cardTargets: sectionCardTargets((penicillin.sections || []).find((item) => item.id === "explore-next"))
    },
    preservedPhraseCards: countSectionItems(penicillin, "phrases"),
    concreteTravelerValueImproved: "matches the medication-allergy follow-up prose to rendered medicine, interaction, alcohol, sleepiness, and safety cards instead of generic symptom cards",
    reason: "premium_audit_batch_33_review_gate_fix"
  });

  const sim = readJson(simPath);
  const simBefore = JSON.parse(JSON.stringify(sim));
  setSectionBody(
    sim,
    "explore-next",
    "Battery, charger, charging, data top-up, and eSIM cards cover nearby phone problems."
  );
  writeJson(simPath, sim);
  ledgerRows.push({
    batch: 33,
    tierRole: sim.tierRole,
    sectionID: "review-gate:sim-explore-next",
    sectionTitle: "Review-gate explore-next copy/card alignment",
    pageID: sim.id,
    phraseID: sim.phraseID,
    sourcePath: simPath,
    before: {
      body: (simBefore.sections || []).find((item) => item.id === "explore-next")?.body,
      cardTargets: sectionCardTargets((simBefore.sections || []).find((item) => item.id === "explore-next"))
    },
    after: {
      body: (sim.sections || []).find((item) => item.id === "explore-next")?.body,
      cardTargets: sectionCardTargets((sim.sections || []).find((item) => item.id === "explore-next"))
    },
    preservedPhraseCards: countSectionItems(sim, "phrases"),
    concreteTravelerValueImproved: "matches the SIM troubleshooting body to the actual rendered data-top-up card without changing card depth",
    reason: "premium_audit_batch_33_review_gate_fix"
  });

  const ledgerRowsAdded = appendLedger(ledgerRows);
  console.log(JSON.stringify({
    batch: 33,
    reviewFixes: 2,
    pageIDs: [penicillin.id, sim.id],
    ledgerRowsAdded
  }, null, 2));
}

main();
