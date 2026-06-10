const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

function walkJsonFiles(dir) {
  const files = [];
  for (const name of fs.readdirSync(dir)) {
    const abs = path.join(dir, name);
    const stat = fs.statSync(abs);
    if (stat.isDirectory()) files.push(...walkJsonFiles(abs));
    else if (name.endsWith(".json")) files.push(abs);
  }
  return files;
}

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function countSectionItems(page, key) {
  return (page.sections || []).reduce((total, section) => total + ((section[key] || []).length), 0);
}

function sectionCardTargets(section) {
  return (section.phrases || []).map((card) => card.detailPageID || card.id);
}

function allCardTargets(page) {
  return (page.sections || []).flatMap(sectionCardTargets);
}

function targetsForSection(page, sectionID) {
  const section = (page.sections || []).find((item) => item.id === sectionID);
  return section ? sectionCardTargets(section) : [];
}

function withFullBreakdown(page, tokens) {
  const next = tokens.map((token) => ({ ...token }));
  const finalToken = next[next.length - 1];
  if (finalToken?.vietnamese !== page.title || finalToken?.english !== page.englishTitle) {
    next.push({
      id: "full",
      vietnamese: page.title,
      english: page.englishTitle,
      audioKey: page.audioKey ?? null
    });
  }
  return next;
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
  const authoredResourcePath = path.join(repoRoot, "native-ios/Resources/viet-authored-listing-pages.json");
  if (fs.existsSync(authoredResourcePath)) {
    const resource = JSON.parse(fs.readFileSync(authoredResourcePath, "utf8"));
    const pages = Array.isArray(resource) ? resource : resource.pages;
    for (const page of pages || []) {
      if (page.id && !byID.has(page.id)) byID.set(page.id, page);
    }
  }
  return byID;
}

let audioManifest;

function normalizeAudioText(value) {
  return String(value || "")
    .normalize("NFC")
    .trim()
    .replace(/\s+/g, " ")
    .toLowerCase();
}

function audioTextMatches(audioKey, vietnamese) {
  if (!audioKey) return false;
  if (!audioManifest) {
    const manifestPath = path.join(repoRoot, "native-ios/Resources/viet-audio-manifest.json");
    audioManifest = fs.existsSync(manifestPath)
      ? JSON.parse(fs.readFileSync(manifestPath, "utf8"))
      : {};
  }
  return normalizeAudioText(audioManifest[audioKey]?.text) === normalizeAudioText(vietnamese);
}

function phraseCardFor(page) {
  return {
    id: page.phraseID,
    vietnamese: page.title,
    english: page.englishTitle,
    pronunciation: page.pronunciation,
    symbolName: audioTextMatches(page.audioKey, page.title) ? "speaker.wave.2.fill" : "text.bubble.fill",
    tintName: page.tintName || "teal",
    detailPageID: page.id,
    audioKey: page.audioKey ?? null
  };
}

function updateSource(repair, pageIndex) {
  const page = readJson(repair.source);
  const before = JSON.parse(JSON.stringify(page));
  if (Object.prototype.hasOwnProperty.call(repair, "title")) page.title = repair.title;
  if (Object.prototype.hasOwnProperty.call(repair, "englishTitle")) page.englishTitle = repair.englishTitle;
  if (Object.prototype.hasOwnProperty.call(repair, "pronunciation")) page.pronunciation = repair.pronunciation;
  if (Object.prototype.hasOwnProperty.call(repair, "audioKey")) page.audioKey = repair.audioKey;
  page.summary = repair.summary;
  page.sections = (page.sections || []).map((section) => {
    const next = { ...section };
    if (Object.prototype.hasOwnProperty.call(repair.bodies, section.id)) {
      next.body = repair.bodies[section.id];
    }
    if (section.id === "breakdown") {
      next.breakdown = withFullBreakdown(page, repair.breakdown);
    }
    const targets = repair.cardTargets?.[section.id];
    if (targets) {
      const existingCardsByTarget = new Map(
        (section.phrases || []).map((card) => [card.detailPageID || card.id, card])
      );
      next.phrases = targets.map((targetID) => {
        const targetPage = pageIndex.get(targetID);
        if (!targetPage) {
          const existingCard = existingCardsByTarget.get(targetID);
          if (existingCard) return existingCard;
          throw new Error(`Missing card target ${targetID} for ${repair.id}`);
        }
        return phraseCardFor(targetPage);
      });
    }
    next.phrases = (next.phrases || []).map((card) => {
      if (card.id !== page.phraseID) return card;
      const audioKey = Object.prototype.hasOwnProperty.call(repair, "audioKey") ? repair.audioKey : card.audioKey;
      return {
        ...card,
        vietnamese: page.title,
        english: page.englishTitle,
        pronunciation: page.pronunciation,
        audioKey,
        symbolName: audioTextMatches(audioKey, page.title) ? "speaker.wave.2.fill" : "text.bubble.fill"
      };
    });
    return next;
  });
  page.examples = (page.examples || []).map((card) => {
    if (card.id !== page.phraseID) return card;
    const audioKey = Object.prototype.hasOwnProperty.call(repair, "audioKey") ? repair.audioKey : card.audioKey;
    return {
      ...card,
      vietnamese: page.title,
      english: page.englishTitle,
      pronunciation: page.pronunciation,
      audioKey,
      symbolName: audioTextMatches(audioKey, page.title) ? "speaker.wave.2.fill" : "text.bubble.fill"
    };
  });
  writeJson(repair.source, page);
  return { page, before };
}

function updateAudit(repair, page) {
  const audit = readJson(repair.audit);
  audit.pageID = page.id;
  audit.phraseText = page.title;
  audit.englishTitle = page.englishTitle;
  audit.reviewStatus = "reviewed";
  audit.tokens = withFullBreakdown(page, repair.breakdown);
  writeJson(repair.audit, audit);
}

function parseCSV(text) {
  const rows = [];
  let row = [];
  let field = "";
  let quoted = false;
  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];
    if (quoted) {
      if (char === "\"" && next === "\"") {
        field += "\"";
        i += 1;
      } else if (char === "\"") {
        quoted = false;
      } else {
        field += char;
      }
    } else if (char === "\"") {
      quoted = true;
    } else if (char === ",") {
      row.push(field);
      field = "";
    } else if (char === "\n") {
      row.push(field);
      rows.push(row);
      row = [];
      field = "";
    } else if (char !== "\r") {
      field += char;
    }
  }
  if (field.length || row.length) {
    row.push(field);
    rows.push(row);
  }
  return rows.filter((item) => item.length > 1 || item[0] !== "");
}

function formatCSV(rows, bomMode) {
  const body = rows.map((row, rowIndex) => row.map((field, fieldIndex) => {
    let value = String(field ?? "");
    if (rowIndex === 0 && fieldIndex === 0) {
      value = value.replace(/^[\ufeff]+/, "");
      if (bomMode === "first-header-cell") value = `\ufeff${value}`;
    }
    return `"${value.replace(/"/g, "\"\"")}"`;
  }).join(",")).join("\n");
  return `${bomMode === "file" ? "\ufeff" : ""}${body}\n`;
}

function updateCSV(relPath, repairsByPhraseID) {
  const absPath = path.join(repoRoot, relPath);
  if (!fs.existsSync(absPath)) return 0;
  const original = fs.readFileSync(absPath, "utf8");
  const rows = parseCSV(original);
  const hasHeaderCellBOM = /^[\ufeff]+/.test(String(rows[0]?.[0] ?? "")) || original.startsWith("\"\ufeff");
  const bomMode = hasHeaderCellBOM
    ? "first-header-cell"
    : original.charCodeAt(0) === 0xfeff
      ? "file"
      : "none";
  const header = rows[0];
  const index = Object.fromEntries(header.map((name, i) => [String(name).replace(/^[\ufeff]+/, ""), i]));
  let changed = 0;
  for (let i = 1; i < rows.length; i += 1) {
    const row = rows[i];
    const repair = repairsByPhraseID.get(row[index.phrase_id]);
    if (!repair) continue;
    if (repair.summary && index.family_summary !== undefined) row[index.family_summary] = repair.summary;
    if (Object.prototype.hasOwnProperty.call(repair, "title")) {
      if (index.target_text !== undefined) row[index.target_text] = repair.title;
      if (index.canonical_target_text !== undefined) row[index.canonical_target_text] = repair.title;
    }
    if (Object.prototype.hasOwnProperty.call(repair, "pronunciation") && index.pronunciation !== undefined) {
      row[index.pronunciation] = repair.pronunciation;
    }
    if (Object.prototype.hasOwnProperty.call(repair, "audioKey") && index.audio_key !== undefined) {
      row[index.audio_key] = repair.audioKey || "";
    }
    if (Object.prototype.hasOwnProperty.call(repair, "audioStatus") && index.audio_status !== undefined) {
      row[index.audio_status] = repair.audioStatus;
    }
    changed += 1;
  }
  if (changed) fs.writeFileSync(absPath, formatCSV(rows, bomMode));
  return changed;
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

function applyRepairs(batch, repairs) {
  const pageIndex = indexPages();
  const repairsByPhraseID = new Map();
  const ledgerRows = [];

  for (const repair of repairs) {
    const { page, before } = updateSource(repair, pageIndex);
    updateAudit(repair, page);
    repairsByPhraseID.set(page.phraseID, repair);
    ledgerRows.push({
      batch,
      tierRole: page.tierRole,
      sectionID: "page-visible-copy",
      sectionTitle: "Page visible copy",
      pageID: page.id,
      phraseID: page.phraseID,
      sourcePath: repair.source,
      before: {
        title: before.title,
        englishTitle: before.englishTitle,
        summary: before.summary,
        cardTargets: allCardTargets(before),
        phraseCardCount: countSectionItems(before, "phrases"),
        breakdownRows: countSectionItems(before, "breakdown"),
        issues: [
          "title-as-summary",
          "formulaic projection prose",
          "visible prose and breakdown trust repair"
        ]
      },
      after: {
        title: page.title,
        englishTitle: page.englishTitle,
        summary: page.summary,
        cardTargets: allCardTargets(page),
        phraseCardCount: countSectionItems(page, "phrases"),
        breakdownRows: countSectionItems(page, "breakdown"),
        sections: {
          atGlance: repair.bodies["at-glance"],
          quickSay: repair.bodies["quick-say"],
          breakdown: repair.bodies.breakdown
        }
      },
      preservedPhraseCards: countSectionItems(page, "phrases"),
      preservedBreakdownRows: countSectionItems(page, "breakdown"),
      concreteTravelerValueImproved: repair.value,
      reason: `premium_audit_batch_${batch}_polish`
    });
    for (const [sectionID, concreteTravelerValueImproved] of Object.entries(repair.cardParityLedger || {})) {
      ledgerRows.push({
        batch,
        tierRole: page.tierRole,
        sectionID: `card-parity:${sectionID}`,
        sectionTitle: "Source/render card parity",
        pageID: page.id,
        phraseID: page.phraseID,
        sourcePath: repair.source,
        before: {
          cardTargets: targetsForSection(before, sectionID)
        },
        after: {
          cardTargets: targetsForSection(page, sectionID)
        },
        preservedRenderedPhraseCards: countSectionItems(page, "phrases"),
        preservedSourcePhraseCards: countSectionItems(page, "phrases"),
        concreteTravelerValueImproved,
        reason: `premium_audit_batch_${batch}_card_parity`
      });
    }
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-500/generated-rows.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];
  const ledgerRowsAdded = appendLedger(ledgerRows);

  return {
    batch,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRowsAdded
  };
}

module.exports = {
  applyRepairs
};
