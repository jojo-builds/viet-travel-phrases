#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const sourcePath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredPagesPath = path.join(repoRoot, "native-ios", "Resources", "viet-authored-listing-pages.json");

const expectedCityIDs = ["hcmc", "hanoi", "danang", "hoian", "hue"];
const expectedPagesPerCity = 100;
const expectedNounPageCount = expectedCityIDs.length * expectedPagesPerCity;
const reviewStatus = "handwritten-reviewed";
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
}

function main() {
  const source = readJSON(sourcePath);
  const authored = fs.existsSync(authoredPagesPath) ? readJSON(authoredPagesPath) : { pages: [] };
  const cities = source.cities ?? [];
  const nounPages = (source.pages ?? []).filter((page) => page.kind !== "phrase" && page.status === "approved");
  const runtimeCityPages = (authored.pages ?? []).filter((page) => page.tierRole === "city-v1");
  const runtimeByFamilyID = new Map(runtimeCityPages.map((page) => [sourcePageIDForRuntimePage(page), page]));

  if (cities.length !== expectedCityIDs.length) {
    fail(`expected ${expectedCityIDs.length} city hubs, found ${cities.length}`);
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

  for (const page of nounPages) {
    countsByCity.set(page.cityID, (countsByCity.get(page.cityID) ?? 0) + 1);
    const editorial = page.editorialImport ?? {};
    if (editorial.reviewStatus !== reviewStatus) {
      fail(`${page.id} is not marked ${reviewStatus}`);
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

  if (targetHeroNames.size !== expectedNounPageCount) {
    fail(`expected ${expectedNounPageCount} unique target hero names, found ${targetHeroNames.size}`);
  }

  if (process.exitCode) {
    process.exit(process.exitCode);
  }
  console.log(`Validated city production copy: ${cities.length} hubs, ${nounPages.length} city noun pages, ${targetHeroNames.size} unique target heroes`);
}

main();
