#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const updates = [
  {
    id: "viet-phrase-v900-tran-this-is-the-wrong-address",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-this-is-the-wrong-address.json",
    summary: "For stopping an address mismatch before the ride continues in the wrong direction.",
    bodies: {
      "at-glance": "The address on the app, receipt, or message is wrong. Say this before the ride keeps moving.",
      "quick-say": "Put the correct address beside the wrong one on screen, then say the phrase and let the driver compare.",
      "good-to-know": "Do not argue from memory if the screen can show it. The fix is faster when both addresses are visible.",
      "explore-next": "If the address is wrong, the next move is usually stopping here, going this way, or showing the correct destination.",
      "natural-variants": "Use take-me-here, District 1, or stop-here cards only after the correct destination is clear.",
    },
    value: "makes address-mismatch recovery specific instead of generic transport scaffold",
  },
  {
    id: "viet-phrase-v500-tran-please-turn-around",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-turn-around.json",
    summary: "For asking the driver to turn back after a missed turn, wrong road, or route mistake.",
    bodies: {
      "at-glance": "The turn has already been missed, and going back matters more than continuing forward.",
      "quick-say": "Point to the map route or last turn after the phrase so the driver can see why you need to go back.",
      "good-to-know": "A turn-around request may need a safe place to loop. Give the driver room to choose the legal turn.",
      "explore-next": "After the turn-around request, stop-here, take-me-here, and go-this-way cards cover the next route correction.",
      "natural-variants": "Use the shorter turn-around card when the driver already understands the mistake.",
    },
    value: "makes turn-around copy route-specific instead of generic ride scaffold",
  },
  {
    id: "viet-phrase-food-premium-has-meat-in-it",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-premium-has-meat-in-it.json",
    summary: "For pointing out meat in a dish when a vegetarian, allergy, or dietary limit changes the order.",
    bodies: {
      "at-glance": "Use this after spotting meat in the dish, tray, sauce, or filling.",
      "quick-say": "Point to the exact piece or menu photo while you say it. The issue is the meat, not the whole meal.",
      "when-to-use": "Best before eating or paying, while staff can still explain, remake, or suggest another dish.",
      "good-to-know": "Meat can hide in broth, filling, or garnish. Ask again if the answer only covers the visible pieces.",
      "explore-next": "Move next to no-meat, without-this-ingredient, fish-sauce allergy, or shellfish allergy cards if safety matters.",
      "natural-variants": "No-meat and without-this-ingredient cards are stronger before ordering; this line is for what is already in front of you.",
    },
    value: "replaces point-to-item boilerplate with a specific meat-in-dish dietary moment",
  },
  {
    id: "viet-phrase-food-premium-which-dish-safe",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-premium-which-dish-safe.json",
    summary: "For asking staff to steer you toward the safest dish for a specific allergy or restriction.",
    bodies: {
      "at-glance": "Use this before ordering when the menu has several risky-looking choices and you need staff to narrow it down.",
      "quick-say": "Show the allergy note first, then ask for the safest dish. Wait for one clear recommendation.",
      "when-to-use": "Best at a restaurant counter or table before the kitchen starts cooking.",
      "good-to-know": "A safe dish needs a clear answer, not just a friendly nod. Ask again if the reply feels vague.",
      "explore-next": "Keep fish-sauce, shellfish, and cannot-eat-this cards nearby if the answer turns uncertain.",
      "natural-variants": "Use no-meat or without-this-ingredient cards when you already know which dish you want.",
    },
    value: "removes long-explanation formula from the allergy-safe dish page",
  },
];

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function countCards(page) {
  return (page.sections || []).reduce((total, section) => total + ((section.phrases || []).length), 0);
}

function applyUpdate(update) {
  const page = readJson(update.source);
  const before = JSON.parse(JSON.stringify(page));
  page.summary = update.summary;
  page.sections = (page.sections || []).map((section) => (
    Object.prototype.hasOwnProperty.call(update.bodies, section.id)
      ? { ...section, body: update.bodies[section.id] }
      : section
  ));
  writeJson(update.source, page);
  return {
    batch: "49",
    tierRole: page.tierRole,
    sectionID: "page-visible-copy",
    sectionTitle: "Reviewer-risk copy polish",
    pageID: page.id,
    phraseID: page.phraseID,
    sourcePath: update.source,
    before: {
      summary: before.summary,
      phraseCardCount: countCards(before),
      changedBodies: Object.fromEntries((before.sections || [])
        .filter((section) => Object.prototype.hasOwnProperty.call(update.bodies, section.id))
        .map((section) => [section.id, section.body])),
    },
    after: {
      summary: page.summary,
      phraseCardCount: countCards(page),
      changedBodies: Object.fromEntries((page.sections || [])
        .filter((section) => Object.prototype.hasOwnProperty.call(update.bodies, section.id))
        .map((section) => [section.id, section.body])),
    },
    preservedPhraseCards: countCards(page),
    concreteTravelerValueImproved: update.value,
    reason: "premium_audit_batch_49_reviewer_risk_polish",
  };
}

function appendLedger(rows) {
  const existing = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const keys = new Set(existing.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}:${row.sectionID}`];
    } catch {
      return [];
    }
  }));
  const fresh = rows.filter((row) => !keys.has(`${row.reason}:${row.pageID}:${row.sectionID}`));
  if (fresh.length) {
    fs.appendFileSync(ledgerPath, `${fresh.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }
  return fresh.length;
}

const rows = updates.map(applyUpdate);
console.log(JSON.stringify({
  batch: "49",
  repairedPages: rows.length,
  pageIDs: rows.map((row) => row.pageID),
  ledgerRowsAdded: appendLedger(rows),
}, null, 2));
