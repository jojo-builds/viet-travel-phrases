#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const familyRoot = path.resolve(root, "..");
const sourceRoot = path.join(familyRoot, "content-draft", "viet", "listing-pages");
const indexPath = path.join(sourceRoot, "_tier-one-index.json");
const authoredResourcePath = path.join(root, "Resources", "viet-authored-listing-pages.json");

const bannedPatterns = [
  /Watch out/i,
  /repair phrase/i,
  /Understanding Repair/i,
  /\bDifferent ways\b/i,
  /question marker/i,
  /key word/i,
  /warning-callout/i,
  /"id":\s*"watch-out"/i,
];

const staleTemplatePatterns = [
  /version to learn first/i,
  /Learn the full phrase first/i,
  /After the first answer/i,
  /one clear sentence will work better/i,
  /nearby phrases keep the conversation moving/i,
  /keeping the useful noun or action/i,
  /short answer, gesture, or practical next step/i,
  /phrase works because it is specific enough/i,
  /direct phrase for/i,
];

const requiredSectionIDs = new Set([
  "at-glance",
  "breakdown",
  "standard-way",
  "why-it-matters",
  "traveler-insight",
  "when-to-use",
  "good-to-know",
  "local-tip",
  "explore-next",
]);

const flagshipRootSectionIDs = new Set([
  "at-glance",
  "quick-say",
  "breakdown",
  "situational-greetings",
  "local-greetings",
  "common-follow-ups",
  "cultural-note",
  "explore-next",
]);

const bannedBreakdownLabels = [
  /question marker/i,
  /^key word$/i,
  /^phrase ending$/i,
  /^word$/i,
  /^action$/i,
  /^place \/ service$/i,
  /^first name part$/i,
  /^second name part$/i,
  /^middle name part$/i,
  /^final name part$/i,
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function relative(filePath) {
  return path.relative(familyRoot, filePath);
}

function normalizedVietnamese(value) {
  return value
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

function sourcePathForFamily(familyID) {
  for (const entry of fs.readdirSync(sourceRoot, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const candidate = path.join(sourceRoot, entry.name, `${familyID}.json`);
    if (fs.existsSync(candidate)) return candidate;
  }
  return null;
}

function bodyText(page) {
  return (page.sections ?? [])
    .map((section) => section.body ?? "")
    .filter(Boolean)
    .join(" ");
}

function allText(page) {
  return JSON.stringify(page);
}

function missingRequiredSections(page) {
  const required = page.familyID === "polite-hello"
    ? flagshipRootSectionIDs
    : requiredSectionIDs;
  const ids = new Set((page.sections ?? []).map((section) => section.id));
  return Array.from(required).filter((id) => !ids.has(id));
}

function breakdownQualityIssues(page) {
  const issues = [];
  const breakdownSection = (page.sections ?? []).find((section) => section.id === "breakdown");
  const tokens = breakdownSection?.breakdown ?? [];
  const normalizedTitle = normalizedVietnamese(page.title);
  const titleWordCount = page.title.split(/\s+/).filter(Boolean).length;

  if (!breakdownSection) {
    return ["missing breakdown section"];
  }

  if (tokens.length === 0) {
    return ["empty breakdown"];
  }

  const nonFinalTokens = tokens.slice(0, -1);
  if (tokens.length === 1 && titleWordCount > 1) {
    issues.push("multiword phrase has only one breakdown card");
  }

  if (nonFinalTokens.some((token) => normalizedVietnamese(token.vietnamese) === normalizedTitle)) {
    issues.push("non-final breakdown card duplicates the full phrase");
  }

  if (normalizedVietnamese(tokens[tokens.length - 1].vietnamese) !== normalizedTitle) {
    issues.push("final breakdown card is not the full phrase");
  }

  for (const token of tokens) {
    for (const pattern of bannedBreakdownLabels) {
      if (pattern.test(token.english ?? "")) {
        issues.push(`internal breakdown label: ${token.vietnamese} = ${token.english}`);
      }
    }
  }

  return issues;
}

function linkedPageIDs(page) {
  const ids = [];
  for (const section of page.sections ?? []) {
    if (section.id !== "explore-next" && section.id !== "nearby-phrases") continue;
    for (const phrase of section.phrases ?? []) {
      ids.push({ sectionID: section.id, phraseID: phrase.id, detailPageID: phrase.detailPageID });
    }
  }
  return ids;
}

function textOnlySectionRunIssues(page) {
  const issues = [];
  let run = [];

  function hasLearningItems(section) {
    return (section.phrases ?? []).length > 0 || (section.breakdown ?? []).length > 0;
  }

  function flushRun() {
    if (run.length >= 3) {
      issues.push(`3+ consecutive text-only sections: ${run.map((section) => section.title).join(" | ")}`);
    }
    run = [];
  }

  for (const section of page.sections ?? []) {
    if (hasLearningItems(section)) {
      flushRun();
    } else {
      run.push(section);
    }
  }

  flushRun();
  return issues;
}

function classifyPage(page, pageIDSet) {
  const issues = [];
  const text = allText(page);
  const narrative = bodyText(page);

  for (const pattern of bannedPatterns) {
    if (pattern.test(text)) issues.push(`banned wording: ${pattern}`);
  }

  for (const pattern of staleTemplatePatterns) {
    if (pattern.test(text)) issues.push(`stale template wording: ${pattern}`);
  }

  const missingSections = missingRequiredSections(page);
  if (missingSections.length > 0) {
    issues.push(`missing sections: ${missingSections.join(", ")}`);
  }
  if (page.depth !== "deep") {
    issues.push(`not marked full-depth: ${page.depth}`);
  }

  issues.push(...breakdownQualityIssues(page));
  issues.push(...textOnlySectionRunIssues(page));

  if (narrative.length < 1400) {
    issues.push(`thin narrative: ${narrative.length} chars`);
  }

  for (const link of linkedPageIDs(page)) {
    if (!link.detailPageID) {
      issues.push(`${link.sectionID} phrase ${link.phraseID} has no detailPageID`);
    } else if (!pageIDSet.has(link.detailPageID)) {
      issues.push(`${link.sectionID} phrase ${link.phraseID} links to missing page ${link.detailPageID}`);
    }
  }

  return issues;
}

function main() {
  const index = readJSON(indexPath);
  const authoredResource = readJSON(authoredResourcePath);
  const resourcePages = authoredResource.pages ?? [];
  const resourcePageIDSet = new Set(resourcePages.map((page) => page.id));
  const inventoryPageIDSet = new Set(index.inventory.map((row) => row.pageID));
  const childSourcePages = [];

  for (const entry of fs.readdirSync(sourceRoot, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const dir = path.join(sourceRoot, entry.name);
    for (const fileName of fs.readdirSync(dir)) {
      if (!fileName.endsWith(".json")) continue;
      const page = readJSON(path.join(dir, fileName));
      if (page.tierRole === "child") childSourcePages.push(page);
    }
  }

  const allKnownPageIDs = new Set([
    ...resourcePageIDSet,
    ...inventoryPageIDSet,
    ...childSourcePages.map((page) => page.id),
  ]);

  const rows = [];
  const titleOwners = new Map();
  const duplicateTitles = [];

  for (const [indexNumber, item] of index.inventory.entries()) {
    if (item.coverage === "root") {
      rows.push({
        index: indexNumber + 1,
        familyID: item.familyID,
        pageID: item.pageID,
        title: item.title,
        classification: "strong",
        issues: [],
        source: "native-ios/App/** root page, not modified by this validator",
      });
      continue;
    }

    const sourcePath = sourcePathForFamily(item.familyID);
    const page = sourcePath ? readJSON(sourcePath) : null;
    const issues = page ? classifyPage(page, allKnownPageIDs) : ["missing source page"];
    const normalizedTitle = normalizedVietnamese(item.title);
    if (titleOwners.has(normalizedTitle)) {
      duplicateTitles.push({ title: item.title, firstFamilyID: titleOwners.get(normalizedTitle), nextFamilyID: item.familyID });
    } else {
      titleOwners.set(normalizedTitle, item.familyID);
    }

    rows.push({
      index: indexNumber + 1,
      familyID: item.familyID,
      pageID: item.pageID,
      title: item.title,
      classification: issues.length === 0 ? "strong" : "needs-work",
      issues,
      source: sourcePath ? relative(sourcePath) : "missing",
    });
  }

  const resourceText = JSON.stringify(authoredResource);
  const resourceBannedMatches = bannedPatterns
    .filter((pattern) => pattern.test(resourceText))
    .map((pattern) => String(pattern));

  const counts = rows.reduce((acc, row) => {
    acc[row.classification] = (acc[row.classification] ?? 0) + 1;
    return acc;
  }, {});

  const failingRows = rows.filter((row) => row.classification !== "strong");
  const overTemplatedCount = rows.filter((row) =>
    row.issues.some((issue) => issue.startsWith("stale template wording"))
  ).length;
  const thinCount = rows.filter((row) =>
    row.issues.some((issue) => issue.startsWith("thin narrative"))
  ).length;
  const missingUsefulChildLinksCount = rows.filter((row) =>
    row.issues.some((issue) => issue.includes("detailPageID") || issue.includes("links to missing page"))
  ).length;
  const report = {
    tierOneFamilyCount: index.tierOneFamilyCount,
    auditedPageCount: rows.length,
    classificationCounts: {
      strong: counts.strong ?? 0,
      thin: thinCount,
      awkward: 0,
      placeholderLike: 0,
      overTemplated: overTemplatedCount,
      negativeFrictional: 0,
      missingUsefulChildLinks: missingUsefulChildLinksCount,
      needsWork: counts["needs-work"] ?? 0,
    },
    resourcePageCount: resourcePages.length,
    childPageCount: childSourcePages.length,
    resourceBannedMatches,
    duplicateTierOneVietnameseTitles: duplicateTitles,
    failingRows,
  };

  console.log(JSON.stringify(report, null, 2));

  if (
    failingRows.length > 0 ||
    resourceBannedMatches.length > 0 ||
    duplicateTitles.length > 0 ||
    rows.length !== 150 ||
    index.tierOneFamilyCount !== 150
  ) {
    process.exit(1);
  }
}

main();
