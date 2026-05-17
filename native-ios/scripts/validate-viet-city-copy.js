#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const sourcePath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredPagesPath = path.join(repoRoot, "native-ios", "Resources", "viet-authored-listing-pages.json");
const reviewReportPath = path.join(repoRoot, "docs", "content-audits", "viet-city-copy-production-2026-05-17.json");

const expectedCityIDs = ["hcmc", "hanoi", "danang", "hoian", "hue"];
const expectedPagesPerCity = 100;
const expectedNounPageCount = expectedCityIDs.length * expectedPagesPerCity;
const reviewStatus = "handwritten-reviewed";
const reviewID = "viet-city-copy-production-2026-05-17";
const bannedVisibleFragments = [
  "noun",
  "anchor",
  "route phrase",
  "where-question",
  "place name",
  "content role",
  "page kind",
  "the traveler needs",
  "this page",
  "use this as",
  "database",
  "generator",
  "template",
  "content role",
  "city tile",
  "city food guide",
  "the row",
  "this row",
  "row",
  "rows",
  "surface",
  "page can stay",
  "local sources",
  "shop-name",
  "specific dish row",
  "generic drink row",
  "generic museum row",
  "named tailor rows",
  "shown here",
  "play it aloud",
  "play the name",
  "from the app",
  "pronunciation gets noisy",
  "think in sequence",
  "becomes legible",
  "do the real work",
  "exact venue",
];

const formulaicVisiblePatterns = [
  /\bvietnamese name shown here\b/i,
  /\benglish meaning to keep in mind\b/i,
  /\bplay (?:the name|it) (?:first|once|before)\b/i,
  /\bfull name is what helps\b/i,
  /\bdriver, ticket desk, server\b/i,
  /\bkeep the next words ordinary\b/i,
  /\bphrasebook value comes from small choices\b/i,
  /\bpayment and ride-back phrases matter\b/i,
  /\bthen ask for one portion, what is inside, sauce, spice, sweetness, or ice\b/i,
  /\bstart with [^,.]+, then ask for one portion, what is inside\b/i,
  /\bbefore asking what is inside or how it is served\b/i,
  /\bthat first ingredient question protects the flavor\b/i,
  /\bkeep the table, menu, recommendation, ingredient check, drink choice, bill, and pickup point\b/i,
  /\bfor transit stops, the practical question is where to stand next\b/i,
  /\ballergy risk usually live\b/i,
  /\btickets, entrance, bathrooms, photos, or the return ride\b/i,
  /\bshow (?:the )?(?:map|saved map result|ticket|booking screen)\b/i,
  /\buse the vietnamese name when\b/i,
  /\buse [^,.]+ when the destination is\b/i,
  /\bpart of how .* becomes legible\b/i,
  /\bthis is a more deliberate restaurant plan\b/i,
  /\bcheck .* ingredients first if you avoid\b/i,
  /\bthink in sequence:\s*arrival\b/i,
  /\btable, menu, order, drink, bill, and pickup phrases do the real work\b/i,
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function fail(message) {
  console.error(`ERROR: ${message}`);
  process.exitCode = 1;
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFC")
    .replace(/\s+/g, " ")
    .trim();
}

function normalizedLower(value) {
  return normalize(value).toLowerCase();
}

function visibleHubText(city) {
  const hub = city.hubEditorial ?? {};
  return [
    hub.subtitle,
    hub.intro,
    hub.practicePrompt,
    ...(hub.signatureMoments ?? []),
    ...(hub.browseGroups ?? []),
  ].filter(Boolean).join("\n");
}

function visibleEditorialText(page) {
  const editorial = page.editorialImport ?? {};
  return [
    editorial.summary,
    ...(editorial.sections ?? []).flatMap((section) => [section.title, section.body]),
  ].filter(Boolean).join("\n");
}

function sourceEditorialInputText(page) {
  return [
    page.context,
    page.tip,
    page.rationale,
  ].filter(Boolean).join("\n");
}

function authoredRuntimeText(page) {
  return [
    page.title,
    page.englishTitle,
    page.summary,
    ...(page.sections ?? []).flatMap((section) => [section.title, section.body]),
  ].filter(Boolean).join("\n");
}

function sourcePageIDForRuntimePage(runtimePage) {
  if (runtimePage.familyID) return runtimePage.familyID;
  return String(runtimePage.id ?? "").replace(/^viet-family-/, "");
}

function requireTextIncludes(page, text, patterns, label) {
  if (!patterns.some((pattern) => pattern.test(text))) {
    fail(`${page.id} missing ${label} utility in authored copy`);
  }
}

function profileFor(page) {
  const pageKind = normalizedLower(page.pageKind || page.kind);
  const placeKind = normalizedLower(page.placeKind);
  if (placeKind === "street" || placeKind === "neighborhood") return "street";
  if (["airport", "station", "port", "pier"].includes(placeKind)) return "transit";
  if (placeKind === "market" || page.subcategoryID === "shopping-markets") return "market";
  if (pageKind === "restaurant" || placeKind === "restaurant" || placeKind === "cafe") return "restaurant";
  if (pageKind === "dish" || placeKind === "dish" || placeKind === "local dish" || placeKind === "food spot") return "dish";
  if (["landmark", "museum", "attraction", "experience", "beach", "nature", "park", "river", "village"].includes(placeKind)) return "attraction";
  return "place";
}

function validateProfileUtility(page) {
  const text = normalizedLower(visibleEditorialText(page));
  switch (profileFor(page)) {
  case "street":
    requireTextIncludes(page, text, [/driver/, /pickup/, /map pin/, /street/], "driver or pickup");
    break;
  case "transit":
    requireTextIncludes(page, text, [/pickup/, /drop-off/, /arrival/, /transfer/, /luggage/, /ticket/], "arrival or transfer");
    break;
  case "market":
    requireTextIncludes(page, text, [/cash/, /price/, /bargain/, /market/, /meeting point/, /pickup/], "cash or price");
    break;
  case "restaurant":
    requireTextIncludes(page, text, [/table/, /menu/, /order/, /drink/, /bill/, /pay/, /payment/, /cash/, /card/], "table menu pay");
    break;
  case "dish":
    requireTextIncludes(page, text, [/order/, /inside/, /ingredient/, /sauce/, /spic/, /allergy/, /diet/, /sweet/, /ice/], "order ingredients adjustment");
    break;
  case "attraction":
    requireTextIncludes(page, text, [/ticket/, /entrance/, /photo/, /pickup/, /driver/, /return/, /visit/], "ticket entrance or pickup");
    break;
  default:
    requireTextIncludes(page, text, [/driver/, /pickup/, /ticket/, /entrance/, /photo/, /market/, /order/, /pay/, /map/], "traveler utility");
    break;
  }
}

function validateNoBannedVisibleText(context, text) {
  const lower = normalizedLower(text);
  for (const fragment of bannedVisibleFragments) {
    const pattern = new RegExp(`\\b${fragment.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\b`, "i");
    if (pattern.test(lower)) {
      fail(`${context} contains banned visible wording: "${fragment}"`);
    }
  }
  for (const pattern of formulaicVisiblePatterns) {
    if (pattern.test(text)) {
      fail(`${context} contains formulaic visible wording: ${pattern}`);
    }
  }
}

function reviewRowsByPageID(reviewReport) {
  return new Map((reviewReport.pages ?? []).map((page) => [page.id, page]));
}

function normalizedTemplateKey(page, text) {
  let key = normalizedLower(text);
  const removals = [
    page.id,
    page.cityID,
    page.targetText,
    page.englishText,
    page.placeID,
    page.productionIntake?.intakeVietnameseName,
    page.productionIntake?.targetHeroImageName,
  ].filter(Boolean);
  for (const value of removals) {
    const fragment = String(value).toLowerCase().replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    key = key.replace(new RegExp(fragment, "gi"), "{name}");
  }
  return key
    .replace(/\b(da nang|đà nẵng|hanoi|hà nội|saigon|sài gòn|ho chi minh city|ho chi minh|hcmc|hoi an|hội an|hue|huế)\b/gi, "{city}")
    .replace(/\b[a-z0-9]+(?:-[a-z0-9]+){2,}\b/gi, "{id}")
    .replace(/[0-9]+/g, "{n}")
    .replace(/\s+/g, " ")
    .trim();
}

function validateRuntimeSectionParity(sourcePage, runtimePage) {
  if (sourcePage.id === "city-danang-place-ba-na-hills") {
    validateRuntimeOverride(sourcePage, runtimePage);
    return;
  }
  const editorialSections = sourcePage.editorialImport?.sections ?? [];
  for (const section of editorialSections) {
    const runtimeSection = (runtimePage.sections ?? []).find((candidate) => candidate.id === section.id);
    if (!runtimeSection) {
      fail(`${runtimePage.id} missing runtime section ${section.id}`);
      continue;
    }
    if (runtimeSection.body !== section.body) {
      fail(`${runtimePage.id} runtime section ${section.id} body does not match source editorial section`);
    }
  }
  if (sourcePage.editorialImport?.replaceGeneratedSections === true) {
    const editorialSectionIDs = new Set(editorialSections.map((section) => section.id));
    for (const runtimeSection of runtimePage.sections ?? []) {
      if (!editorialSectionIDs.has(runtimeSection.id)) {
        fail(`${runtimePage.id} has generated fallback section ${runtimeSection.id} mixed into reviewed city copy`);
      }
    }
  }
}

function validateRuntimeOverride(sourcePage, runtimePage) {
  const override = sourcePage.editorialImport?.runtimeOverride;
  if (override?.kind !== "ba-na-hills-journey") {
    fail(`${sourcePage.id} uses a runtime journey override without explicit editorialImport.runtimeOverride metadata`);
    return;
  }

  const expected = override.expectedSectionIDs ?? [];
  const actual = (runtimePage.sections ?? []).map((section) => section.id);
  if (expected.join("|") !== actual.join("|")) {
    fail(`${runtimePage.id} journey override section order changed: expected ${expected.join(", ")}, found ${actual.join(", ")}`);
  }

  const sourceSections = new Map((sourcePage.editorialImport?.sections ?? []).map((section) => [section.id, section]));
  const runtimeSections = new Map((runtimePage.sections ?? []).map((section) => [section.id, section]));
  for (const sectionID of override.sourceSectionIDsPreserved ?? []) {
    const sourceSection = sourceSections.get(sectionID);
    const runtimeSection = runtimeSections.get(sectionID);
    if (!sourceSection || !runtimeSection) {
      fail(`${runtimePage.id} journey override missing preserved section ${sectionID}`);
      continue;
    }
    if (runtimeSection.body !== sourceSection.body) {
      fail(`${runtimePage.id} journey override section ${sectionID} does not match reviewed source body`);
    }
  }

  for (const sectionID of ["getting-there", "tickets", "cable-car", "photos", "getting-back", "food-cash"]) {
    const runtimeSection = runtimeSections.get(sectionID);
    if (!runtimeSection || !(runtimeSection.phrases ?? []).length) {
      fail(`${runtimePage.id} journey override section ${sectionID} needs phrase options`);
    }
  }
}

function main() {
  const source = readJSON(sourcePath);
  const authored = fs.existsSync(authoredPagesPath) ? readJSON(authoredPagesPath) : { pages: [] };
  const reviewReport = fs.existsSync(reviewReportPath) ? readJSON(reviewReportPath) : null;
  const reviewRows = reviewReport ? reviewRowsByPageID(reviewReport) : new Map();
  const cities = source.cities ?? [];
  const nounPages = (source.pages ?? []).filter((page) => page.kind !== "phrase" && page.status === "approved");
  const runtimeCityPages = (authored.pages ?? []).filter((page) => page.tierRole === "city-v1");
  const runtimeByFamilyID = new Map(runtimeCityPages.map((page) => [sourcePageIDForRuntimePage(page), page]));

  if (cities.length !== expectedCityIDs.length) {
    fail(`expected ${expectedCityIDs.length} city hubs, found ${cities.length}`);
  }
  if (!reviewReport || reviewReport.reviewID !== reviewID) {
    fail(`missing city copy review report ${path.relative(repoRoot, reviewReportPath)}`);
  }
  for (const cityID of expectedCityIDs) {
    const city = cities.find((candidate) => candidate.id === cityID);
    if (!city) {
      fail(`missing city hub ${cityID}`);
      continue;
    }
    if (city.hubEditorial?.reviewStatus !== reviewStatus) {
      fail(`${cityID} hub is not marked ${reviewStatus}`);
    }
    const hubText = visibleHubText(city);
    if (hubText.length < 220) {
      fail(`${cityID} hub editorial is too thin`);
    }
    validateNoBannedVisibleText(`city hub ${cityID}`, hubText);
  }

  if (nounPages.length !== expectedNounPageCount) {
    fail(`expected ${expectedNounPageCount} approved city noun pages, found ${nounPages.length}`);
  }

  const countsByCity = new Map();
  const targetHeroNames = new Map();
  const duplicatedBodies = new Map();
  const normalizedTemplateBodies = new Map();

  for (const page of nounPages) {
    countsByCity.set(page.cityID, (countsByCity.get(page.cityID) ?? 0) + 1);
    const editorial = page.editorialImport ?? {};
    if (editorial.reviewStatus !== reviewStatus) {
      fail(`${page.id} is not marked ${reviewStatus}`);
    }
    if (editorial.reviewEvidence?.reviewID !== reviewID || editorial.reviewEvidence?.checklistStatus !== "reviewed") {
      fail(`${page.id} missing durable review evidence`);
    }
    const reviewRow = reviewRows.get(page.id);
    if (!reviewRow || reviewRow.status !== "APPROVE") {
      fail(`${page.id} missing APPROVE row in city copy review report`);
    }
    if (normalize(editorial.summary).length < 120) {
      fail(`${page.id} summary is too thin`);
    }
    if (!Array.isArray(editorial.sections) || editorial.sections.length < 6) {
      fail(`${page.id} needs at least 6 authored editorial sections`);
    }
    if (!editorial.targetHeroImageName) {
      fail(`${page.id} missing editorialImport.targetHeroImageName`);
    } else if (targetHeroNames.has(editorial.targetHeroImageName)) {
      fail(`${page.id} reuses target hero ${editorial.targetHeroImageName} also used by ${targetHeroNames.get(editorial.targetHeroImageName)}`);
    } else {
      targetHeroNames.set(editorial.targetHeroImageName, page.id);
    }

    const text = visibleEditorialText(page);
    validateNoBannedVisibleText(page.id, text);
    validateNoBannedVisibleText(`${page.id} source editorial inputs`, sourceEditorialInputText(page));
    validateProfileUtility(page);

    for (const section of editorial.sections ?? []) {
      const body = normalizedLower(section.body);
      if (body.length < 55) {
        fail(`${page.id} section ${section.id} is too thin`);
      }
      if (body.length >= 80) {
        const rows = duplicatedBodies.get(body) ?? [];
        rows.push(`${page.id}:${section.id}`);
        duplicatedBodies.set(body, rows);
        const normalizedKey = `${profileFor(page)}:${section.id}:${normalizedTemplateKey(page, section.body)}`;
        const normalizedRows = normalizedTemplateBodies.get(normalizedKey) ?? [];
        normalizedRows.push(`${page.id}:${section.id}`);
        normalizedTemplateBodies.set(normalizedKey, normalizedRows);
      }
    }

    const runtimePage = runtimeByFamilyID.get(page.id);
    if (runtimeCityPages.length > 0 && !runtimePage) {
      fail(`${page.id} has no generated runtime page`);
    }
    if (runtimePage) {
      if (runtimePage.summary !== editorial.summary) {
        fail(`${runtimePage.id} runtime summary does not match source editorial summary`);
      }
      validateRuntimeSectionParity(page, runtimePage);
      validateNoBannedVisibleText(runtimePage.id, authoredRuntimeText(runtimePage));
    }
  }

  for (const cityID of expectedCityIDs) {
    const count = countsByCity.get(cityID) ?? 0;
    if (count !== expectedPagesPerCity) {
      fail(`${cityID} expected ${expectedPagesPerCity} city noun pages, found ${count}`);
    }
  }

  for (const [body, rows] of duplicatedBodies.entries()) {
    if (rows.length > 3) {
      fail(`duplicated authored section body appears ${rows.length} times: ${rows.slice(0, 6).join(", ")} :: ${body.slice(0, 120)}`);
    }
  }

  for (const [body, rows] of normalizedTemplateBodies.entries()) {
    if (rows.length > 6) {
      fail(`normalized template body appears ${rows.length} times: ${rows.slice(0, 6).join(", ")} :: ${body.slice(0, 160)}`);
    }
  }

  if (targetHeroNames.size !== expectedNounPageCount) {
    fail(`expected ${expectedNounPageCount} unique target hero names, found ${targetHeroNames.size}`);
  }

  if (process.exitCode) {
    process.exit(process.exitCode);
  }
  console.log(`Validated city production copy: ${cities.length} hubs, ${nounPages.length} city noun pages, ${targetHeroNames.size} unique target heroes`);
}

main();
