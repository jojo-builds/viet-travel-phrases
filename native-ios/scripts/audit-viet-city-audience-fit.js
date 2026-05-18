#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const sourcePath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const swiftPath = path.join(repoRoot, "native-ios", "App", "Models", "BrowseSearchDestinations.swift");

const expectedCityIDs = ["hcmc", "hanoi", "danang", "hoian", "hue"];
const expectedPagesPerCity = 100;
const logisticsLead = /\b(entrance|tickets?|bathroom|pickup|pick-up|timing|ride back|return ride|driver|luggage|terminal|platform|bill|payment)\b/i;
const logisticsList = /\b(entrance|tickets?|photo|bathroom|pickup|pick-up|timing|ride back|return ride|driver|luggage|terminal|platform|bill|payment)\b/gi;
const templatePhrases = [
  /\bto name clearly before\b/i,
  /\bworth saving offline\b/i,
  /\buseful when\b/i,
  /\buseful for\b/i,
  /\bname to keep ready\b/i,
  /\bsave by name\b/i,
  /\bkeeps the next question short\b/i,
  /\bbefore .*questions take over\b/i,
  /\bnot just another dot on a map\b/i,
  /\bpractical layer is simple\b/i,
];
const sensoryOrCulture = /\b(neon|lights?|skyline|river|bridge|beach|market|coffee|cafes?|restaurants?|food|dish|dishes|taste|sauce|herbs?|noodles?|incense|temple|pagoda|tomb|imperial|royal|lanterns?|boats?|waterways?|coconut|craft|artisan|workshop|marble|stone|museum|art|history|old|modern|village|streets?|alley|promenade|garden|mountain|forest|lake|courtyard|architecture|ritual|worship|decor|scent|color|sound|song|steam|grilled|sweet|spicy|crisp|family|night|sunset|morning|coastal|heritage|culture|scooters?|facades?|buildings?|trees?|boulevard|signs?|vegetarian)\b/i;
const citySpecific = {
  danang: /\b(da nang|han river|dragon|my khe|marble|son tra|ba na|beach|bridge|seafood|central-vietnam|coastal)\b/i,
  hanoi: /\b(hanoi|old quarter|hoan kiem|west lake|lake|northern|temple|old lanes|coffee|bun cha|ba dinh|capital|national-history)\b/i,
  hcmc: /\b(saigon|ho chi minh|district 1|ben thanh|nguyen hue|dong khoi|cho lon|river lights|market|coffee)\b/i,
  hoian: /\b(hoi an|ancient town|lantern|hoai river|thu bon|cam thanh|coconut|tailor|yellow walls|old town)\b/i,
  hue: /\b(hue|imperial|citadel|perfume river|tomb|pagoda|royal|incense|garden house|old capital)\b/i,
};

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value ?? "").replace(/\s+/g, " ").trim();
}

function escapeRegExp(value) {
  return String(value ?? "").replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function firstText(page) {
  const editorial = page.editorialImport || {};
  const firstSection = editorial.sections?.[0]?.body || "";
  return `${editorial.summary || ""} ${firstSection}`.slice(0, 500);
}

function allText(page) {
  const editorial = page.editorialImport || {};
  return normalize([
    editorial.summary,
    ...(editorial.sections || []).flatMap((section) => [section.title, section.body]),
  ].filter(Boolean).join("\n"));
}

function fail(list, message) {
  list.push(message);
}

function auditPage(page) {
  const failures = [];
  const text = allText(page);
  const lead = firstText(page);
  const leadWithoutTitle = [page.englishText, page.targetText]
    .filter(Boolean)
    .reduce((current, title) => current.replace(new RegExp(escapeRegExp(title), "gi"), ""), lead);
  const leadLogisticsMatches = leadWithoutTitle.match(logisticsList) || [];
  if (logisticsLead.test(leadWithoutTitle) && leadLogisticsMatches.length >= 2) {
    fail(failures, "opens with logistics instead of place desire");
  }
  for (const pattern of templatePhrases) {
    if (pattern.test(text)) {
      fail(failures, `contains weak/template wording: ${pattern}`);
    }
  }
  if (!sensoryOrCulture.test(text)) {
    fail(failures, "missing visual, sensory, food, culture, or place cue");
  }
  if (!citySpecific[page.cityID]?.test(text)) {
    fail(failures, "missing city-specific texture");
  }
  const sections = page.editorialImport?.sections || [];
  if (sections.length < 6) {
    fail(failures, "missing expected editorial sections");
  }
  if (page.editorialImport?.audienceRewrite?.reviewID !== "viet-city-audience-rewrite-2026-05-18") {
    fail(failures, "missing audience rewrite evidence");
  }
  return failures;
}

function auditSwiftCountryHub() {
  const swift = fs.readFileSync(swiftPath, "utf8");
  const failures = [];
  if (/Everyday phrases for cities, food, transport, hotels, and help/.test(swift)) {
    fail(failures, "All Vietnam subtitle still uses generic utility-starter copy");
  }
  if (/Arrival, taxi, food, hotel, and help/.test(swift)) {
    fail(failures, "All Vietnam practice subtitle still leads with logistics");
  }
  if (/Start with the city names travelers use most/.test(swift)) {
    fail(failures, "All Vietnam intro still uses generic city-name utility copy");
  }
  return failures;
}

function main() {
  const source = readJSON(sourcePath);
  const pages = (source.pages || []).filter((page) => page.kind !== "phrase" && page.status === "approved");
  const failures = [];
  if ((source.cities || []).length !== expectedCityIDs.length) {
    fail(failures, `expected ${expectedCityIDs.length} source city hubs`);
  }
  for (const cityID of expectedCityIDs) {
    const city = (source.cities || []).find((candidate) => candidate.id === cityID);
    if (!city) {
      fail(failures, `missing city hub ${cityID}`);
      continue;
    }
    if (city.hubEditorial?.audienceRewrite?.reviewID !== "viet-city-audience-rewrite-2026-05-18") {
      fail(failures, `${cityID} hub missing audience rewrite evidence`);
    }
    const cityPages = pages.filter((page) => page.cityID === cityID);
    if (cityPages.length !== expectedPagesPerCity) {
      fail(failures, `${cityID} expected ${expectedPagesPerCity} pages, found ${cityPages.length}`);
    }
  }
  for (const page of pages) {
    const pageFailures = auditPage(page);
    for (const pageFailure of pageFailures) {
      fail(failures, `${page.id}: ${pageFailure}`);
    }
  }
  for (const swiftFailure of auditSwiftCountryHub()) {
    fail(failures, `swift-country-hub: ${swiftFailure}`);
  }
  if (failures.length) {
    console.error(`Audience fit audit failed with ${failures.length} issue(s):`);
    for (const item of failures.slice(0, 200)) {
      console.error(`- ${item}`);
    }
    if (failures.length > 200) {
      console.error(`... ${failures.length - 200} more`);
    }
    process.exit(1);
  }
  console.log(`Audience fit OK: ${(source.cities || []).length} city hubs plus All Vietnam, ${pages.length} city noun/place pages`);
}

main();
