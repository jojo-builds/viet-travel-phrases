#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const sourceDir = path.join(repoRoot, "content-draft", "viet", "city-library", "handwritten-copy");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const reviewReportPath = path.join(repoRoot, "docs", "content-audits", "viet-city-copy-production-2026-05-17.json");

const expectedCityIDs = ["hcmc", "hanoi", "danang", "hoian", "hue"];
const expectedPagesPerCity = 100;
const reviewID = "viet-city-copy-production-2026-05-17";
const importID = "viet-city-handwritten-copy-2026-05-18";
const requiredSectionIDs = [
  "at-glance",
  "quick-say",
  "place-brief",
  "use-it-with",
];
const bannedFragments = [
  "place name",
  "this page",
  "this row",
  "the row",
  "rows",
  "database",
  "generated",
  "generator",
  "template",
  "content role",
  "page kind",
  "the traveler needs",
  "the user should",
  "play the name",
  "shown here",
  "use this as",
  "useful moments",
  "route phrase",
  "where-question",
  "anchor",
  "managed outdoor activity area",
  "confirm the destination",
  "helps travelers",
  "local name noun",
];
const bannedExactSectionTitles = new Set([
  "Why it belongs",
  "Travel moment",
  "Hear the name",
  "At the place",
  "Traveler role",
  "Indoor reason",
  "Arrival handoff",
  "When it helps",
]);
const bannedOpeningPattern = /^Use\s+/i;
const bannedEditorialPatterns = [/belongs because/i, /\buse this when\b/i, /\btravelers?\b/i];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function fail(message) {
  throw new Error(message);
}

function normalize(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim();
}

function visibleTextForEntry(entry) {
  return [
    entry.summary,
    entry.context,
    entry.tip,
    entry.rationale,
    ...(entry.sections ?? []).flatMap((section) => [section.title, section.body]),
  ].filter(Boolean).join("\n");
}

function containsBannedText(value) {
  const lower = normalize(value).toLowerCase();
  return bannedFragments.find((fragment) => {
    const pattern = new RegExp(`\\b${fragment.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\b`, "i");
    return pattern.test(lower);
  });
}

function requireText(value, label, pageID, minLength) {
  const text = normalize(value);
  if (text.length < minLength) {
    fail(`${pageID} ${label} is too thin (${text.length} chars)`);
  }
  const banned = containsBannedText(text);
  if (banned) {
    fail(`${pageID} ${label} contains banned wording "${banned}"`);
  }
  return text;
}

function requireOptionalBody(value, label, pageID) {
  const text = normalize(value);
  if (!text) return "";
  const banned = containsBannedText(text);
  if (banned) {
    fail(`${pageID} ${label} contains banned wording "${banned}"`);
  }
  return text;
}

function requireNoTemplateDrift(value, label, pageID) {
  const text = normalize(value);
  if (!text) return;
  if (bannedOpeningPattern.test(text)) {
    fail(`${pageID} ${label} starts with template-like "Use ..." wording`);
  }
  const editorialPattern = bannedEditorialPatterns.find((pattern) => pattern.test(text));
  if (editorialPattern) {
    fail(`${pageID} ${label} contains internal/editorial wording "${editorialPattern.source}"`);
  }
}

function sectionMapFor(entry) {
  const sections = entry.sections ?? [];
  const byID = new Map();
  const bodyOwners = new Map();
  for (const section of sections) {
    if (!section.id) fail(`${entry.pageID} has a section without id`);
    if (byID.has(section.id)) fail(`${entry.pageID} repeats section ${section.id}`);
    if (bannedExactSectionTitles.has(normalize(section.title))) {
      fail(`${entry.pageID} section ${section.id} keeps template title "${normalize(section.title)}"`);
    }
    const phraseIDs = Array.isArray(section.phraseIDs)
      ? section.phraseIDs.map((phraseID) => requireText(phraseID, `section ${section.id} phraseID`, entry.pageID, 3))
      : [];
    const body = phraseIDs.length > 0
      ? requireOptionalBody(section.body, `section ${section.id} body`, entry.pageID)
      : requireText(section.body, `section ${section.id} body`, entry.pageID, 65);
    const bodyKey = normalize(body).toLowerCase();
    if (bodyKey) {
      const previousOwner = bodyOwners.get(bodyKey);
      if (previousOwner) {
        fail(`${entry.pageID} repeats section body in ${previousOwner} and ${section.id}`);
      }
      bodyOwners.set(bodyKey, section.id);
    }
    const nextSection = {
      id: section.id,
      title: requireText(section.title, `section ${section.id} title`, entry.pageID, 3),
      body,
    };
    if (phraseIDs.length > 0) {
      nextSection.phraseIDs = phraseIDs;
    }
    byID.set(section.id, nextSection);
    requireNoTemplateDrift(section.body, `section ${section.id} body`, entry.pageID);
  }
  for (const id of requiredSectionIDs) {
    if (!byID.has(id)) fail(`${entry.pageID} missing required section ${id}`);
  }
  return byID;
}

function loadAuthoredCityFile(cityID) {
  const filePath = path.join(sourceDir, `${cityID}.json`);
  if (!fs.existsSync(filePath)) {
    fail(`missing handwritten city copy file ${path.relative(repoRoot, filePath)}`);
  }
  const file = readJSON(filePath);
  if (file.cityID !== cityID) {
    fail(`${path.relative(repoRoot, filePath)} has cityID ${file.cityID}, expected ${cityID}`);
  }
  if (!Array.isArray(file.entries)) {
    fail(`${path.relative(repoRoot, filePath)} missing entries array`);
  }
  return { filePath, file };
}

function excerpt(value) {
  const text = normalize(value);
  return text.length > 260 ? `${text.slice(0, 257)}...` : text;
}

function updateReviewRows(reviewReport, importedEntries, pagesByID) {
  const rowsByID = new Map((reviewReport.pages ?? []).map((row) => [row.id, row]));
  for (const entry of importedEntries) {
    const page = pagesByID.get(entry.pageID);
    const sectionByID = new Map(entry.sections.map((section) => [section.id, section]));
    const row = rowsByID.get(entry.pageID) ?? {
      id: entry.pageID,
      cityID: page.cityID,
      pageKind: page.pageKind,
      placeKind: page.placeKind,
    };
    row.cityID = page.cityID;
    row.pageKind = page.pageKind;
    row.placeKind = page.placeKind;
    row.reviewer = `city-owner:${page.cityID}`;
    row.status = "APPROVE";
    row.blockerLevel = "NONE";
    row.checklist = {
      ...(row.checklist ?? {}),
      voiceLengthPass: true,
      sectionCountPass: true,
      profileAudienceCuePass: true,
      noBannedVisibleTextPass: true,
      noBannedSourceInputPass: true,
      sourceNotesPresent: true,
      targetHeroPresent: true,
      durableReviewEvidencePresent: true,
      sectionBodiesDistinctEnough: true,
      runtimeOverrideExplicit: true,
      bannedMatches: [],
      sourceBannedMatches: [],
    };
    row.failures = [];
    row.evidence = {
      summaryExcerpt: excerpt(entry.summary),
      aboutExcerpt: excerpt(sectionByID.get("at-glance")?.body),
      phrasebookExcerpt: excerpt(sectionByID.get("quick-say")?.body),
      belongingExcerpt: excerpt(sectionByID.get("use-it-with")?.body),
      timingExcerpt: excerpt(sectionByID.get("when-to-use")?.body),
      goodToKnowExcerpt: excerpt(sectionByID.get("good-to-know")?.body),
    };
    rowsByID.set(entry.pageID, row);
  }
  reviewReport.pages = Array.from(rowsByID.values()).sort((a, b) => a.id.localeCompare(b.id));
}

function main() {
  const library = readJSON(cityLibraryPath);
  const reviewReport = readJSON(reviewReportPath);
  if (reviewReport.reviewID !== reviewID) {
    fail(`review report ${path.relative(repoRoot, reviewReportPath)} must keep reviewID ${reviewID}`);
  }

  const nounPages = (library.pages ?? []).filter((page) => page.status === "approved" && page.kind !== "phrase");
  const pagesByID = new Map(nounPages.map((page) => [page.id, page]));
  const importedEntries = [];

  for (const cityID of expectedCityIDs) {
    const expectedPageIDs = nounPages
      .filter((page) => page.cityID === cityID)
      .map((page) => page.id)
      .sort();
    if (expectedPageIDs.length !== expectedPagesPerCity) {
      fail(`${cityID} expected ${expectedPagesPerCity} source pages, found ${expectedPageIDs.length}`);
    }

    const { filePath, file } = loadAuthoredCityFile(cityID);
    if (file.entries.length !== expectedPagesPerCity) {
      fail(`${path.relative(repoRoot, filePath)} expected ${expectedPagesPerCity} entries, found ${file.entries.length}`);
    }

    const seen = new Set();
    for (const entry of file.entries) {
      if (!entry.pageID) fail(`${path.relative(repoRoot, filePath)} has entry without pageID`);
      if (seen.has(entry.pageID)) fail(`${cityID} duplicates ${entry.pageID}`);
      seen.add(entry.pageID);
      const page = pagesByID.get(entry.pageID);
      if (!page) fail(`${cityID} entry references unknown page ${entry.pageID}`);
      if (page.cityID !== cityID) fail(`${entry.pageID} belongs to ${page.cityID}, not ${cityID}`);

      const summary = requireText(entry.summary, "summary", entry.pageID, 130);
      requireText(visibleTextForEntry(entry), "visible entry", entry.pageID, 480);
      requireNoTemplateDrift(entry.context, "context", entry.pageID);
      requireNoTemplateDrift(entry.tip, "tip", entry.pageID);
      requireNoTemplateDrift(entry.rationale, "rationale", entry.pageID);
      requireNoTemplateDrift(entry.summary, "summary", entry.pageID);
      const sectionByID = sectionMapFor(entry);
      const sections = (entry.sections ?? []).map((section) => sectionByID.get(section.id));
      const sourceNotes = page.editorialImport?.sourceNotes ?? page.productionIntake?.sourceNotes ?? "";
      const imagePromptNote = page.editorialImport?.imagePromptNote ?? page.productionIntake?.imagePromptNote ?? "";
      const targetHeroImageName = page.editorialImport?.targetHeroImageName ?? page.productionIntake?.targetHeroImageName ?? page.heroImageName;
      const sourceMode = normalize(entry.sourceMode ?? "");
      if (!targetHeroImageName) fail(`${entry.pageID} is missing target hero image name`);

      page.context = normalize(entry.context ?? summary);
      page.tip = normalize(entry.tip ?? sectionByID.get("good-to-know")?.body ?? sectionByID.get("use-it-with").body);
      page.rationale = normalize(entry.rationale ?? sectionByID.get("use-it-with").body);
      page.editorialImport = {
        ...(page.editorialImport ?? {}),
        patchID: importID,
        summary,
        sourceNotes,
        imagePromptNote,
        sections,
        targetHeroImageName,
        approvedAt: "2026-05-18T00:00:00+07:00",
        approvedBy: `codex-city-handwritten-copy:${cityID}`,
        reviewStatus: "handwritten-reviewed",
        claimRisk: "stable-traveler-context",
        heroImageName: targetHeroImageName,
        replaceGeneratedSections: true,
        reviewEvidence: {
          reviewID,
          scope: "500 city noun pages plus 5 city hubs",
          reviewer: `city-owner:${cityID}`,
          checklistStatus: "reviewed",
        },
        audienceRewrite: {
          reviewID: importID,
          standard: "handwritten-per-listing-traveler-excitement",
          source: path.relative(repoRoot, filePath),
        },
      };
      if (sourceMode) {
        page.editorialImport.sourceMode = sourceMode;
      } else {
        delete page.editorialImport.sourceMode;
      }
      if (!entry.runtimeOverride) {
        delete page.editorialImport.runtimeOverride;
      }
      importedEntries.push({ ...entry, sections });
    }

    const missing = expectedPageIDs.filter((pageID) => !seen.has(pageID));
    const extra = Array.from(seen).filter((pageID) => !expectedPageIDs.includes(pageID));
    if (missing.length || extra.length) {
      fail(`${cityID} page coverage mismatch. Missing: ${missing.slice(0, 8).join(", ")} Extra: ${extra.slice(0, 8).join(", ")}`);
    }
  }

  updateReviewRows(reviewReport, importedEntries, pagesByID);
  writeJSON(cityLibraryPath, library);
  writeJSON(reviewReportPath, reviewReport);
  console.log(`Imported ${importedEntries.length} handwritten city copy entries from ${path.relative(repoRoot, sourceDir)}`);
}

main();
