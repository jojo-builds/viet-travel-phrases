#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const sourcePath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredPagesPath = path.join(repoRoot, "native-ios", "Resources", "viet-authored-listing-pages.json");
const catalogPath = path.join(repoRoot, "native-ios", "Resources", "viet-phrase-catalog.json");
const audioManifestPath = path.join(repoRoot, "native-ios", "Resources", "viet-audio-manifest.json");
const reviewReportPath = path.join(repoRoot, "docs", "content-audits", "viet-city-copy-production-2026-05-17.json");

const expectedCityIDs = ["hcmc", "hanoi", "danang", "hoian", "hue"];
const expectedPagesByCity = new Map(Object.entries({
  hcmc: 104,
  hanoi: 102,
  danang: 103,
  hoian: 100,
  hue: 100,
}));
const expectedNounPageCount = [...expectedPagesByCity.values()].reduce((sum, count) => sum + count, 0);
const reviewStatus = "handwritten-reviewed";
const reviewID = "viet-city-copy-production-2026-05-17";
const legacyTemplateSectionTitles = new Set([
  "Why go",
  "What you'll get",
  "Say it locally",
  "Worth it if",
  "Good to know",
]);
const reviewLedVenueResearch = new Map([
  [
    "city-hcmc-place-lusine-thao-dien",
    {
      path: path.join(repoRoot, "content-draft", "viet", "city-library", "research", "location-reviews", "hcmc", "lusine-thao-dien.review-research.json"),
      requiredSignals: [
        /eggs benedict/i,
        /squid ink crab pasta/i,
        /premium pho/i,
        /salt caramel coffee/i,
        /high ceilings?/i,
        /thao dien/i,
      ],
    },
  ],
]);
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
  "hear the name",
  "why it belongs",
  "travel moment",
  "map pin",
  "from the app",
  "pronunciation gets noisy",
  "think in sequence",
  "becomes legible",
  "do the real work",
  "exact venue",
  "managed outdoor activity area",
  "confirm the destination",
  "helps travelers",
  "local name noun",
  "travelers",
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
  /\bimage-led tile\b/i,
  /\bkeep the name ready for this job\b/i,
  /\bkeep this in mind\b/i,
  /\bkeep that job in mind\b/i,
  /\bname to keep ready\b/i,
  /\bafter the name lands\b/i,
  /\bthen keep the questions concrete\b/i,
  /\buse the vietnamese name when\b/i,
  /\buse [^,.]+ when the destination is\b/i,
  /\buse this when\b/i,
  /\bpart of how .* becomes legible\b/i,
  /\bthis is a more deliberate restaurant plan\b/i,
  /\bcheck .* ingredients first if you avoid\b/i,
  /\bthe traveler(?:s)?\b/i,
  /\bmap pin\b/i,
  /\bwhy it belongs\b/i,
  /\btravel moment\b/i,
  /\bhear the name\b/i,
  /\bthink in sequence:\s*arrival\b/i,
  /\btable, menu, order, drink, bill, and pickup phrases do the real work\b/i,
  /\bthe traveler(?:s)?\b/i,
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

function visibleSentences(value) {
  return normalize(value)
    .split(/(?<=[.!?])\s+/)
    .map((item) => normalize(item))
    .filter((item) => item.length >= 28);
}

function visibleSentenceKey(value) {
  return normalizedLower(value)
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function validateNoRepeatedVisibleSentences(context, sections) {
  const seen = new Map();
  for (const section of sections) {
    for (const sentence of visibleSentences(section.text)) {
      const key = visibleSentenceKey(sentence);
      if (!key) continue;
      const previous = seen.get(key);
      if (previous) {
        fail(`${context} repeats visible sentence in ${previous} and ${section.label}: "${sentence}"`);
      } else {
        seen.set(key, section.label);
      }
    }
  }
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

function visibleEditorialSections(page) {
  const editorial = page.editorialImport ?? {};
  return [
    { label: "summary", text: editorial.summary },
    ...(editorial.sections ?? []).map((section) => ({
      label: section.id,
      text: section.body,
    })),
  ];
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
    fail(`${page.id} missing ${label} audience cue in authored copy`);
  }
}

function profileFor(page) {
  const pageKind = normalizedLower(page.pageKind || page.kind);
  const placeKind = normalizedLower(page.placeKind);
  if (placeKind === "street" || placeKind === "neighborhood") return "street";
  if (["airport", "station", "port", "pier"].includes(placeKind)) return "transit";
  if (placeKind === "market" || page.subcategoryID === "shopping-markets") return "market";
  if (placeKind === "cafe") return "cafe";
  if (pageKind === "restaurant" || placeKind === "restaurant") return "restaurant";
  if (["dish", "drink", "dessert"].includes(pageKind) || ["dish", "drink", "dessert", "local dish", "food spot"].includes(placeKind)) return "dish";
  if (["landmark", "museum", "attraction", "experience", "beach", "nature", "park", "river", "village"].includes(placeKind)) return "attraction";
  return "place";
}

function validateProfileUtility(page) {
  const text = normalizedLower(visibleEditorialText(page));
  switch (profileFor(page)) {
  case "street":
    requireTextIncludes(page, text, [/street/, /shopfront/, /crossing/, /neighborhood/, /hotel edge/, /lane/, /saved place/], "street or neighborhood");
    break;
  case "transit":
    requireTextIncludes(page, text, [/arrival/, /platform/, /route board/, /luggage/, /station door/, /city light/, /sign/, /boat/, /river/, /boarding/, /water/, /pier/], "arrival or water-threshold texture");
    break;
  case "market":
    requireTextIncludes(page, text, [/stall/, /snack/, /gift/, /color/, /bargain/, /market/, /browsing/, /shop/, /storefront/, /food counter/, /cool air/, /fabric/, /fitting/, /measuring tape/, /custom-made/, /handmade/, /workshop/, /tool/, /material/], "market or craft texture");
    break;
  case "cafe":
    requireTextIncludes(page, text, [/coffee/, /ice/, /sweet/, /street stool/, /counter/, /pause/, /espresso/, /cafe/], "cafe texture");
    break;
  case "restaurant":
    requireTextIncludes(page, text, [/table/, /menu/, /drink/, /house dish/, /staff/, /meal/, /dining/], "restaurant texture");
    break;
  case "dish":
    requireTextIncludes(page, text, [/menu/, /texture/, /herb/, /sauce/, /spic/, /sweet/, /ice/, /topping/, /coconut/, /flavor/, /dish/, /beer/, /glass/, /stool/, /snack/, /evening street/], "food or drink texture");
    break;
  case "attraction":
    requireTextIncludes(page, text, [/view/, /entry detail/, /photo/, /local pride/, /stage/, /light/, /water/, /gate/, /courtyard/, /temple/, /visit/, /route/, /dish/, /spice/, /shared plate/, /local appetite/, /food/, /craft/, /hands/, /material/, /skill/, /museum/, /art/, /history/, /objects?/, /artifacts?/], "place significance");
    break;
  default:
    requireTextIncludes(page, text, [/photo/, /market/, /city/, /street/, /view/, /water/, /food/, /culture/], "traveler image");
    break;
  }
}

function validateReasonToGoStructure(page) {
  const sections = page.editorialImport?.sections ?? [];
  const byID = new Map(sections.map((section) => [section.id, section]));
  const requiredSectionIDs = ["at-glance", "place-brief", "use-it-with"];
  for (const sectionID of requiredSectionIDs) {
    const section = byID.get(sectionID);
    if (!section) {
      fail(`${page.id} missing reason-to-go section ${sectionID}`);
    }
  }
  const text = normalizedLower(visibleEditorialText(page));
  const reasonWords = [
    "worth",
    "reason",
    "history",
    "historic",
    "culture",
    "craft",
    "food",
    "dessert",
    "drink",
    "flavor",
    "view",
    "architecture",
    "ritual",
    "story",
    "memory",
    "market",
    "coffee",
    "river",
    "beach",
    "station",
    "airport",
    "ticket",
    "route",
    "luggage",
    "bowl",
    "broth",
    "table",
    "meal",
    "plate",
    "show",
    "theatre",
    "performance",
    "lake",
    "park",
    "pagoda",
    "temple",
    "facade",
    "square",
    "plaza",
    "street",
    "neighborhood",
    "district",
    "loop",
    "puppet",
    "gallery",
  ];
  if (!reasonWords.some((word) => text.includes(word))) {
    fail(`${page.id} missing a reason-to-go or factual hook cue`);
  }
  validateReviewLedVenueStructure(page);
}

function validateReviewLedVenueStructure(page) {
  const expectation = reviewLedVenueResearch.get(page.id);
  if (!expectation) return;

  const researchPath = expectation.path;
  if (!fs.existsSync(researchPath)) {
    fail(`${page.id} missing local review research file ${path.relative(repoRoot, researchPath)}`);
    return;
  }

  const research = readJSON(researchPath);
  const standards = research.googleReviewHarvest ?? {};
  if ((standards.targetReviewCount ?? 0) < 25) {
    fail(`${page.id} review research should target at least 25 reviews`);
  }
  if ((standards.minimumReviewCountForScale ?? 0) < 20) {
    fail(`${page.id} review research should keep 20 reviews as the minimum before scaling`);
  }
  const reviewSignals = Array.isArray(research.targetedReviewSignals) ? research.targetedReviewSignals : research.reviewSignals;
  if ((standards.publiclySurfacedReviewCount ?? 0) < 1 || !Array.isArray(reviewSignals) || reviewSignals.length < 1) {
    fail(`${page.id} review research must record at least one public review signal`);
  }

  const editorial = page.editorialImport ?? {};
  const visibleText = [
    editorial.summary,
    ...(editorial.sections ?? []).flatMap((section) => [section.title, section.body]),
  ].filter(Boolean).join("\n");

  for (const section of editorial.sections ?? []) {
    if (legacyTemplateSectionTitles.has(normalize(section.title))) {
      fail(`${page.id} review-led venue copy drifted back to legacy section title "${section.title}"`);
    }
  }
  for (const pattern of expectation.requiredSignals ?? []) {
    if (!pattern.test(visibleText)) {
      fail(`${page.id} review-led venue copy missing researched signal ${pattern}`);
    }
  }
  if (/\b(reviews? point(?:s|ed)? to|recent reviews?|source signals?|review-backed|publicly surfaced)\b/i.test(visibleText)) {
    fail(`${page.id} exposes research scaffolding in visible venue copy`);
  }
  if (/(^|\n)\s*[A-Z][A-Za-z'’ ]{1,24}:\s/.test(visibleText)) {
    fail(`${page.id} uses field-label copy with a colon in visible venue prose`);
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

function validateRuntimeSectionParity(sourcePage, runtimePage) {
  if (sourcePage.editorialImport?.runtimeOverride?.kind === "ba-na-hills-journey") {
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
    if (runtimeSection.title !== section.title) {
      fail(`${runtimePage.id} runtime section ${section.id} title does not match source editorial section`);
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

function isUsefulPhraseSection(section) {
  return section.id === "quick-say" && normalize(section.title) === "Useful Phrases";
}

function validateSourceMode(page) {
  const sourceMode = normalize(page.editorialImport?.sourceMode);
  if (!sourceMode) return;
  if (!["expanded-detail", "mobile-first"].includes(sourceMode)) {
    fail(`${page.id} must declare one city copy source mode`);
  }
}

function validateUsefulPhraseSource(page, section, catalogPhraseByID, audioManifest) {
  if (!isUsefulPhraseSection(section)) return;
  if (page.editorialImport?.sourceMode !== "expanded-detail") {
    fail(`${page.id} Useful Phrases requires expanded-detail source mode`);
  }
  if (normalize(section.body)) {
    fail(`${page.id} Useful Phrases must render as phrase rows, not prose`);
  }
  const phraseIDs = section.phraseIDs ?? [];
  if (!Array.isArray(phraseIDs) || phraseIDs.length < 2) {
    fail(`${page.id} Useful Phrases needs at least two canonical phrase IDs`);
    return;
  }
  for (const phraseID of phraseIDs) {
    const phrase = catalogPhraseByID.get(phraseID);
    if (!phrase) {
      fail(`${page.id} Useful Phrases references missing phrase ${phraseID}`);
      continue;
    }
    if (phrase.cityLibraryKind) {
      fail(`${page.id} Useful Phrases must use reusable audio-backed phrase IDs, not city-generated phrase ${phraseID}`);
    }
    if (phrase.audioStatus !== "ready" || !phrase.audioKey || !audioManifest[phrase.audioKey]) {
      fail(`${page.id} Useful Phrases phrase ${phraseID} has no ready bundled audio`);
    }
  }
}

function validateUsefulPhraseRuntime(sourcePage, runtimePage, audioManifest) {
  const sourceSection = (sourcePage.editorialImport?.sections ?? []).find(isUsefulPhraseSection);
  if (!sourceSection) return;
  const runtimeSection = (runtimePage.sections ?? []).find((section) => section.id === sourceSection.id);
  if (!runtimeSection) {
    fail(`${runtimePage.id} missing Useful Phrases runtime section`);
    return;
  }
  if (runtimeSection.presentation !== "phrase-list") {
    fail(`${runtimePage.id} Useful Phrases must render as phrase-list`);
  }
  if (normalize(runtimeSection.body)) {
    fail(`${runtimePage.id} Useful Phrases runtime body must be empty so prose is not mixed with phrase cards`);
  }
  if ((runtimeSection.phrases ?? []).length !== (sourceSection.phraseIDs ?? []).length) {
    fail(`${runtimePage.id} Useful Phrases runtime phrase count does not match source phrase IDs`);
  }
  for (const phrase of runtimeSection.phrases ?? []) {
    if (!phrase.audioKey || !audioManifest[phrase.audioKey]) {
      fail(`${runtimePage.id} Useful Phrases runtime phrase ${phrase.id} has no bundled audio`);
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
  const catalog = readJSON(catalogPath);
  const catalogPhraseByID = new Map((catalog.phrases ?? []).map((phrase) => [phrase.id, phrase]));
  const audioManifest = readJSON(audioManifestPath);
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
    if (!Array.isArray(editorial.sections) || editorial.sections.length < 4) {
      fail(`${page.id} needs at least 4 authored editorial sections`);
    }
    validateSourceMode(page);
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
    validateNoRepeatedVisibleSentences(page.id, visibleEditorialSections(page));
    validateProfileUtility(page);
    validateReasonToGoStructure(page);

    for (const section of editorial.sections ?? []) {
      const body = normalizedLower(section.body);
      validateUsefulPhraseSource(page, section, catalogPhraseByID, audioManifest);
      if (!isUsefulPhraseSection(section) && body.length < 55) {
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
      validateRuntimeSectionParity(page, runtimePage);
      validateUsefulPhraseRuntime(page, runtimePage, audioManifest);
      validateNoBannedVisibleText(runtimePage.id, authoredRuntimeText(runtimePage));
    }
  }

  for (const cityID of expectedCityIDs) {
    const count = countsByCity.get(cityID) ?? 0;
    const expectedPages = expectedPagesByCity.get(cityID);
    if (expectedPages !== undefined && count !== expectedPages) {
      fail(`${cityID} expected ${expectedPages} city noun pages, found ${count}`);
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
