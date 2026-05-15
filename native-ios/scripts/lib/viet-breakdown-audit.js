const fs = require("fs");
const path = require("path");

const DEFAULT_AUDIT_RELATIVE_ROOT = path.join("content-draft", "viet", "breakdown-audit");
const DEFAULT_LEDGER_RELATIVE_ROOT = path.join(DEFAULT_AUDIT_RELATIVE_ROOT, "pages");

const PLACEHOLDER_GLOSSES = new Set([
  "action",
  "context word",
  "detail",
  "extra detail",
  "first name part",
  "key word",
  "main phrase piece",
  "meaning to keep",
  "meaningful phrase part",
  "name or place detail",
  "phrase ending",
  "phrase piece",
  "place / service",
  "place name",
  "question ending",
  "specific detail",
  "the action",
  "the main place or thing",
  "word",
  "attraction name",
  "english word in the attraction name",
]);

const MALFORMED_LEGACY_CHUNKS = new Set([
  "gui email cho = email",
  "gui email bao = email",
  "cao cho toi = for me / please",
]);

function normalizeDisplayText(text) {
  return String(text ?? "")
    .normalize("NFC")
    .trim()
    .replace(/\s+/g, " ");
}

function normalizeComparisonText(text) {
  return normalizeDisplayText(text).toLocaleLowerCase("vi");
}

function normalizeVietnameseKey(text) {
  return normalizeComparisonText(text)
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/[^\p{L}\p{N}/?]+/gu, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function wordCount(text) {
  return normalizeDisplayText(text).split(/\s+/).filter(Boolean).length;
}

function walkJSONFiles(dir) {
  if (!fs.existsSync(dir)) return [];
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...walkJSONFiles(fullPath));
    } else if (entry.isFile() && entry.name.endsWith(".json") && !entry.name.startsWith("_")) {
      files.push(fullPath);
    }
  }
  return files.sort((a, b) => a.localeCompare(b));
}

function loadBreakdownAuditLedger({ repoRoot, ledgerRoot } = {}) {
  if (!repoRoot && !ledgerRoot) {
    throw new Error("loadBreakdownAuditLedger requires repoRoot or ledgerRoot");
  }

  const resolvedLedgerRoot = ledgerRoot ?? path.join(repoRoot, DEFAULT_LEDGER_RELATIVE_ROOT);
  const entries = [];
  const entriesByPageID = new Map();
  const errors = [];

  for (const filePath of walkJSONFiles(resolvedLedgerRoot)) {
    let entry;
    try {
      entry = JSON.parse(fs.readFileSync(filePath, "utf8"));
    } catch (error) {
      errors.push(`${filePath}: invalid JSON: ${error.message}`);
      continue;
    }

    const pageID = normalizeDisplayText(entry.pageID);
    if (!pageID) {
      errors.push(`${filePath}: missing pageID`);
      continue;
    }
    if (entriesByPageID.has(pageID)) {
      errors.push(`${filePath}: duplicate pageID ${pageID}`);
      continue;
    }

    const normalizedEntry = {
      ...entry,
      pageID,
      __filePath: filePath,
    };
    entries.push(normalizedEntry);
    entriesByPageID.set(pageID, normalizedEntry);
  }

  return {
    ledgerRoot: resolvedLedgerRoot,
    entries,
    entriesByPageID,
    errors,
  };
}

function phraseTextForPage(page) {
  return normalizeDisplayText(page?.title ?? page?.phraseText ?? page?.vietnamese);
}

function breakdownSectionsForPage(page) {
  return (page.sections ?? []).filter((section) => (section.breakdown ?? []).length > 0 || section.id === "breakdown");
}

function appFacingTokenID(pageID, token, index, isFinal) {
  if (token.id) return normalizeDisplayText(token.id);
  return isFinal ? `${pageID}-breakdown-full` : `${pageID}-breakdown-piece-${index + 1}`;
}

function appFacingBreakdownTokens(entry, audioKeyForToken) {
  const tokens = Array.isArray(entry.tokens) ? entry.tokens : [];
  return tokens.map((token, index) => {
    const isFinal = index === tokens.length - 1;
    const vietnamese = normalizeDisplayText(token.vietnamese);
    const english = normalizeDisplayText(token.english);
    const audioKey = Object.prototype.hasOwnProperty.call(token, "audioKey")
      ? token.audioKey
      : (audioKeyForToken ? audioKeyForToken(vietnamese, { isFinal, token, index }) : null);

    return {
      id: appFacingTokenID(entry.pageID, token, index, isFinal),
      vietnamese,
      english,
      audioKey,
    };
  });
}

function reviewFacingBreakdownTokens(entry) {
  const tokens = Array.isArray(entry.tokens) ? entry.tokens : [];
  return tokens.map((token, index) => {
    const isFinal = index === tokens.length - 1;
    const keepTogetherReason = normalizeDisplayText(token.keepTogetherReason);
    const exportedToken = {
      id: appFacingTokenID(entry.pageID, token, index, isFinal),
      vietnamese: normalizeDisplayText(token.vietnamese),
      english: normalizeDisplayText(token.english),
      audioKey: Object.prototype.hasOwnProperty.call(token, "audioKey") ? token.audioKey : null,
    };

    if (keepTogetherReason) {
      exportedToken.keepTogetherReason = keepTogetherReason;
    }

    return exportedToken;
  });
}

function applyReviewedBreakdownOverride({ page, existingBreakdown, ledger, audioKeyForToken }) {
  const entry = ledger?.entriesByPageID?.get(page.id);
  if (!entry || entry.reviewStatus !== "reviewed") {
    return existingBreakdown ?? [];
  }

  return appFacingBreakdownTokens(entry, audioKeyForToken);
}

function validateEntryAgainstPage(entry, page, { requireReviewed }) {
  const errors = [];
  const pageLabel = entry.pageID || "(missing pageID)";
  const phraseText = page ? phraseTextForPage(page) : normalizeDisplayText(entry.phraseText);

  if (requireReviewed && entry.reviewStatus !== "reviewed") {
    errors.push(`${pageLabel}: reviewStatus must be reviewed`);
  }
  if (requireReviewed && entry.visualReview?.status !== "reviewed") {
    errors.push(`${pageLabel}: visualReview.status must be reviewed`);
  }
  if (!Array.isArray(entry.tokens) || entry.tokens.length === 0) {
    errors.push(`${pageLabel}: tokens must be a non-empty array`);
    return errors;
  }

  const entryPhraseText = normalizeDisplayText(entry.phraseText);
  if (page && entryPhraseText && normalizeComparisonText(entryPhraseText) !== normalizeComparisonText(phraseText)) {
    errors.push(`${pageLabel}: phraseText does not match page title`);
  }

  const tokens = entry.tokens.map((token) => ({
    vietnamese: normalizeDisplayText(token.vietnamese),
    english: normalizeDisplayText(token.english),
    keepTogetherReason: normalizeDisplayText(token.keepTogetherReason),
  }));

  for (const [index, token] of tokens.entries()) {
    const tokenLabel = `${pageLabel}: token ${index + 1}`;
    if (!token.vietnamese) errors.push(`${tokenLabel} missing vietnamese`);
    if (!token.english) errors.push(`${tokenLabel} missing english`);

    const lowerGloss = token.english.toLocaleLowerCase("vi");
    if (PLACEHOLDER_GLOSSES.has(lowerGloss)) {
      errors.push(`${tokenLabel} uses placeholder gloss "${token.english}"`);
    }

    const malformedKey = `${normalizeVietnameseKey(token.vietnamese)} = ${lowerGloss}`;
    if (MALFORMED_LEGACY_CHUNKS.has(malformedKey)) {
      errors.push(`${tokenLabel} keeps malformed legacy chunk ${token.vietnamese} = ${token.english}`);
    }

    const isFinal = index === tokens.length - 1;
    if (!isFinal && wordCount(token.vietnamese) > 1 && !token.keepTogetherReason) {
      errors.push(`${tokenLabel} is multi-word and needs keepTogetherReason`);
    }
  }

  const finalToken = tokens[tokens.length - 1];
  if (phraseText && normalizeComparisonText(finalToken.vietnamese) !== normalizeComparisonText(phraseText)) {
    errors.push(`${pageLabel}: final token must be the complete phrase`);
  }

  const reconstructed = tokens.slice(0, -1).map((token) => token.vietnamese).join(" ");
  if (phraseText && normalizeComparisonText(reconstructed) !== normalizeComparisonText(phraseText)) {
    errors.push(`${pageLabel}: non-final tokens do not reconstruct phrase`);
  }

  return errors;
}

function validateBreakdownAuditCoverage({ pages, ledger, requireAllReviewed = false } = {}) {
  const errors = [...(ledger?.errors ?? [])];
  const warnings = [];
  const pagesWithBreakdown = (pages ?? []).filter((page) => breakdownSectionsForPage(page).length > 0);
  const pagesByID = new Map((pages ?? []).map((page) => [page.id, page]));
  const reviewedPageIDs = [];

  for (const entry of ledger?.entries ?? []) {
    const page = pagesByID.get(entry.pageID);
    if (!page) {
      errors.push(`${entry.pageID}: ledger entry has no matching runtime page`);
      continue;
    }
    errors.push(...validateEntryAgainstPage(entry, page, { requireReviewed: requireAllReviewed }));
    if (entry.reviewStatus === "reviewed") {
      reviewedPageIDs.push(entry.pageID);
    }
  }

  if (requireAllReviewed) {
    for (const page of pagesWithBreakdown) {
      const entry = ledger?.entriesByPageID?.get(page.id);
      if (!entry) {
        errors.push(`${page.id} missing reviewed ledger entry`);
      } else if (entry.reviewStatus !== "reviewed") {
        errors.push(`${page.id}: ledger entry is not reviewed`);
      }
    }
  }

  return {
    ok: errors.length === 0,
    errors,
    warnings,
    counts: {
      runtimePages: pages?.length ?? 0,
      pagesWithBreakdown: pagesWithBreakdown.length,
      ledgerEntries: ledger?.entries?.length ?? 0,
      reviewedEntries: reviewedPageIDs.length,
      missingReviewedEntries: requireAllReviewed
        ? Math.max(0, pagesWithBreakdown.length - reviewedPageIDs.length)
        : null,
    },
  };
}

function renderBreakdownAuditExport({ pages, ledger }) {
  const generatedAt = new Date().toISOString();
  const renderedPages = (pages ?? []).map((page) => {
    const entry = ledger?.entriesByPageID?.get(page.id);
    const sections = breakdownSectionsForPage(page);
    const runtimeBreakdown = sections.flatMap((section) => section.breakdown ?? []);
    const reviewedBreakdown = entry?.reviewStatus === "reviewed"
      ? reviewFacingBreakdownTokens(entry)
      : null;

    return {
      pageID: page.id,
      phraseText: phraseTextForPage(page),
      englishTitle: page.englishTitle ?? "",
      reviewStatus: entry?.reviewStatus ?? "missing",
      visualReview: entry?.visualReview ?? { status: "missing" },
      notes: entry?.notes ?? entry?.reviewNotes ?? [],
      runtimeBreakdown,
      reviewedBreakdown,
    };
  });

  return {
    generatedAt,
    ledgerRoot: ledger?.ledgerRoot ?? null,
    summary: {
      pages: renderedPages.length,
      reviewed: renderedPages.filter((page) => page.reviewStatus === "reviewed").length,
      visualReviewed: renderedPages.filter((page) => page.visualReview?.status === "reviewed").length,
      missing: renderedPages.filter((page) => page.reviewStatus === "missing").length,
      generatedAt,
    },
    pages: renderedPages,
  };
}

module.exports = {
  DEFAULT_AUDIT_RELATIVE_ROOT,
  DEFAULT_LEDGER_RELATIVE_ROOT,
  applyReviewedBreakdownOverride,
  loadBreakdownAuditLedger,
  normalizeDisplayText,
  normalizeVietnameseKey,
  renderBreakdownAuditExport,
  validateBreakdownAuditCoverage,
};
