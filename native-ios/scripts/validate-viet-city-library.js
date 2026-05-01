#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const sourcePath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const audioAuditPath = path.join(nativeRoot, "Resources", "viet-authored-audio-audit.json");
const audioQueuePath = path.join(repoRoot, "docs", "audio-queues", "viet-planned-missing-audio.csv");

const expectedCities = new Set(["hcmc", "hanoi", "danang", "hoian", "hue"]);
const expectedSubcategories = new Set([
  "arrivals-routes",
  "landmarks-attractions",
  "neighborhoods-streets",
  "food-coffee",
  "shopping-markets",
  "practical-help-near-places",
]);
const difficultyValues = new Set(["beginner", "intermediate", "advanced"]);
const bannedSourcePhrases = /\b(top|best|#1|number one|must-visit|must visit)\b/i;
const expectedApprovedPageCount = 750;
const expectedPagesPerCity = 150;
const minimumSubcategoryPagesPerCity = 8;
const minimumPlacePagesPerCity = 25;

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalizeText(value) {
  return String(value ?? "")
    .normalize("NFC")
    .replace(/\s+/g, " ")
    .trim()
    .toLowerCase();
}

function placeAnchorVariants(place) {
  const vietnamese = normalizeText(place.vietnameseName);
  const english = normalizeText(place.englishName);
  const vietnameseCore = vietnamese
    .replace(/^(phố|đường|chợ|cầu|hồ|biển|sông|chùa|dinh|nhà hàng|quán|quán cà phê|sân bay|làng rau|làng gốm|bán đảo|kinh thành|lăng)\s+/u, "")
    .trim();
  const englishCore = english
    .replace(/\b(street|market|bridge|lake|beach|river|pagoda|restaurant|cafe|airport|village|peninsula|imperial city)\b/gu, "")
    .replace(/\s+/g, " ")
    .trim();
  return [vietnamese, english, vietnameseCore, englishCore].filter((value) => value.length >= 3);
}

function cityAnchorVariants(city) {
  return [city.vietnameseName, city.shortTitle, city.title]
    .map((value) => normalizeText(value))
    .filter((value) => value.length >= 3);
}

function phraseContainsPlace(page, place) {
  const target = normalizeText(page.targetText);
  const english = normalizeText(page.englishText);
  return placeAnchorVariants(place).some((anchor) => target.includes(anchor) || english.includes(anchor));
}

function phraseContainsCity(page, city) {
  const target = normalizeText(page.targetText);
  const english = normalizeText(page.englishText);
  return cityAnchorVariants(city).some((anchor) => target.includes(anchor) || english.includes(anchor));
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function countBy(rows, keyFn) {
  const counts = new Map();
  for (const row of rows) {
    const key = keyFn(row);
    counts.set(key, (counts.get(key) ?? 0) + 1);
  }
  return counts;
}

function csvDataRowCount(filePath) {
  if (!fs.existsSync(filePath)) return 0;
  return fs.readFileSync(filePath, "utf8").split(/\r?\n/).filter(Boolean).length - 1;
}

function main() {
  const library = readJSON(sourcePath);
  const catalog = readJSON(catalogPath);
  const authoredPages = readJSON(authoredPagesPath);
  const audioAudit = readJSON(audioAuditPath);
  const cities = new Map((library.cities ?? []).map((city) => [city.id, city]));
  const places = new Map((library.places ?? []).map((place) => [place.id, place]));
  const subcategories = new Map((library.subcategories ?? []).map((subcategory) => [subcategory.id, subcategory]));
  const sources = new Map((library.sources ?? []).map((source) => [source.id, source]));
  const pages = (library.pages ?? []).filter((page) => page.status === "approved");
  const catalogPhrases = new Map((catalog.phrases ?? []).map((phrase) => [phrase.id, phrase]));
  const authoredCityPages = (authoredPages.pages ?? []).filter((page) => page.tierRole === "city-v1");
  const authoredCityPagesByID = new Map(authoredCityPages.map((page) => [page.id, page]));

  assert(library.scenarioID === "city-guides", "city library scenarioID must be city-guides");
  assert(cities.size === expectedCities.size, `expected ${expectedCities.size} cities, found ${cities.size}`);
  for (const cityID of expectedCities) {
    assert(cities.has(cityID), `missing city ${cityID}`);
    for (const sourceID of cities.get(cityID).sourceIDs ?? []) {
      assert(sources.has(sourceID), `${cityID} references missing source ${sourceID}`);
    }
  }
  assert(subcategories.size === expectedSubcategories.size, `expected ${expectedSubcategories.size} subcategories, found ${subcategories.size}`);
  for (const subcategoryID of expectedSubcategories) {
    assert(subcategories.has(subcategoryID), `missing subcategory ${subcategoryID}`);
  }

  const pagesByCity = countBy(pages, (page) => page.cityID);
  assert(pages.length >= expectedApprovedPageCount, `expected at least ${expectedApprovedPageCount} approved pages, found ${pages.length}`);
  for (const cityID of expectedCities) {
    const count = pagesByCity.get(cityID) ?? 0;
    assert(count >= expectedPagesPerCity, `${cityID} must have at least ${expectedPagesPerCity} approved pages, found ${count}`);
    const cityPages = pages.filter((page) => page.cityID === cityID);
    for (const subcategoryID of expectedSubcategories) {
      const subcategoryCount = cityPages.filter((page) => page.subcategoryID === subcategoryID).length;
      assert(
        subcategoryCount >= minimumSubcategoryPagesPerCity,
        `${cityID} needs at least ${minimumSubcategoryPagesPerCity} pages in ${subcategoryID}, found ${subcategoryCount}`
      );
    }
    const cityPlacePages = cityPages.filter((page) => page.kind === "place");
    assert(cityPlacePages.length >= minimumPlacePagesPerCity, `${cityID} should have at least ${minimumPlacePagesPerCity} place-only pages`);
  }

  const difficultyCounts = Object.fromEntries(countBy(pages, (page) => page.difficulty).entries());
  const beginnerRatio = (difficultyCounts.beginner ?? 0) / pages.length;
  const advancedRatio = (difficultyCounts.advanced ?? 0) / pages.length;
  assert(beginnerRatio >= 0.7, `beginner ratio must be at least 70%, got ${(beginnerRatio * 100).toFixed(1)}%`);
  assert(advancedRatio <= 0.05, `advanced ratio must be at most 5%, got ${(advancedRatio * 100).toFixed(1)}%`);

  const normalizedToIDs = new Map();
  for (const place of places.values()) {
    assert(cities.has(place.cityID), `${place.id} references missing city ${place.cityID}`);
    for (const sourceID of place.sourceIDs ?? []) {
      assert(sources.has(sourceID), `${place.id} references missing source ${sourceID}`);
    }
  }

  for (const page of pages) {
    assert(page.id && page.id.startsWith("city-"), `bad page id ${page.id}`);
    assert(page.kind === "place" || page.kind === "phrase", `${page.id} has bad kind ${page.kind}`);
    assert(cities.has(page.cityID), `${page.id} references missing city ${page.cityID}`);
    assert(subcategories.has(page.subcategoryID), `${page.id} references missing subcategory ${page.subcategoryID}`);
    assert(places.has(page.placeID), `${page.id} references missing place ${page.placeID}`);
    assert(difficultyValues.has(page.difficulty), `${page.id} has bad difficulty ${page.difficulty}`);
    assert(page.targetText && page.englishText && page.pronunciation, `${page.id} is missing phrase text`);
    assert(page.context && page.context.length >= 40, `${page.id} needs specific context`);
    assert(page.tip && page.tip.length >= 35, `${page.id} needs a useful traveler tip`);
    assert(page.rationale && page.rationale.length >= 40, `${page.id} needs rationale`);
    assert(Array.isArray(page.chunks) && page.chunks.length >= 2, `${page.id} needs meaningful chunks`);
    assert(Array.isArray(page.sourceIDs) && page.sourceIDs.length > 0, `${page.id} needs sourceIDs`);
    for (const sourceID of page.sourceIDs) {
      assert(sources.has(sourceID), `${page.id} references missing source ${sourceID}`);
    }
    assert(!bannedSourcePhrases.test(`${page.context} ${page.tip} ${page.rationale}`), `${page.id} has unsupported top/best style wording`);

    const place = places.get(page.placeID);
    const city = cities.get(page.cityID);
    const target = normalizeText(page.targetText);
    const english = normalizeText(page.englishText);
    const hasPlaceAnchor = phraseContainsPlace(page, place);
    const hasCityAnchor = phraseContainsCity(page, city);
    const hasAnchor = hasPlaceAnchor
      || hasCityAnchor
      || page.kind === "place";
    assert(hasAnchor, `${page.id} is not tied to its place anchor`);

    if (page.difficulty === "beginner") {
      assert(Number(page.spokenChunks) <= 6, `${page.id} beginner phrase exceeds 6 spoken chunks`);
    }

    const normalized = normalizeText(page.targetText);
    if (!normalizedToIDs.has(normalized)) normalizedToIDs.set(normalized, []);
    normalizedToIDs.get(normalized).push(page.id);

    const catalogPhrase = catalogPhrases.get(page.id);
    assert(catalogPhrase, `${page.id} missing from generated catalog`);
    assert(catalogPhrase.scenarioID === "city-guides", `${page.id} catalog scenario is not city-guides`);
    assert(catalogPhrase.cityID === page.cityID, `${page.id} catalog city metadata mismatch`);
    assert(catalogPhrase.difficulty === page.difficulty, `${page.id} catalog difficulty mismatch`);
    assert(catalogPhrase.audioStatus === "planned", `${page.id} catalog audio status must be planned until city audio is recorded`);

    const authoredPageID = `viet-family-${page.id}`;
    const authoredPage = authoredCityPagesByID.get(authoredPageID);
    assert(authoredPage, `${page.id} missing authored page ${authoredPageID}`);
    assert(authoredPage.cityMetadata?.cityID === page.cityID, `${page.id} authored page city metadata mismatch`);
    assert(catalogPhrase.familyID === page.id, `${page.id} catalog family metadata mismatch`);
    const atAGlance = (authoredPage.sections ?? []).find((section) => section.id === "at-glance");
    const whenToUse = (authoredPage.sections ?? []).find((section) => section.id === "when-to-use");
    assert(atAGlance?.body && whenToUse?.body, `${page.id} authored page needs at-glance and when-to-use bodies`);
    assert(
      normalizeText(atAGlance.body) !== normalizeText(whenToUse.body),
      `${page.id} repeats the same copy in At a glance and When to use it`
    );
    if (page.kind !== "place") {
      const anchorName = hasPlaceAnchor ? place.vietnameseName : city.shortTitle;
      const placeAnchor = (authoredPage.sections ?? []).find((section) => section.id === "place-anchor");
      assert(placeAnchor?.body, `${page.id} needs a place-anchor body`);
      assert(
        normalizeText(placeAnchor.body).includes(normalizeText(anchorName)),
        `${page.id} uses the wrong generated city/place anchor`
      );
    }
  }

  const duplicates = Array.from(normalizedToIDs.entries()).filter(([, ids]) => ids.length > 1);
  assert(duplicates.length === 0, `duplicate city Vietnamese phrases: ${JSON.stringify(duplicates.slice(0, 5))}`);
  assert(authoredCityPages.length === pages.length, `expected ${pages.length} authored city pages, found ${authoredCityPages.length}`);

  for (const authoredPage of authoredCityPages) {
    const sourcePageID = authoredPage.id.replace(/^viet-family-/, "");
    const sourcePage = pages.find((page) => page.id === sourcePageID);
    assert(sourcePage, `${authoredPage.id} does not map back to city source`);

    const linkedPageIDs = (authoredPage.sections ?? [])
      .flatMap((section) => section.phrases ?? [])
      .map((phrase) => phrase.detailPageID)
      .filter(Boolean);
    for (const linkedPageID of linkedPageIDs) {
      assert(authoredCityPagesByID.has(linkedPageID), `${authoredPage.id} links to non-city or missing page ${linkedPageID}`);
      const linkedPage = authoredCityPagesByID.get(linkedPageID);
      assert(
        linkedPage.cityMetadata?.cityID === sourcePage.cityID,
        `${authoredPage.id} links outside ${sourcePage.cityID}: ${linkedPageID}`
      );
    }
  }

  const cityMissingAudio = (audioAudit.missing ?? []).filter((entry) => String(entry.pageID ?? "").startsWith("viet-family-city-"));
  const queueRows = csvDataRowCount(audioQueuePath);
  assert(queueRows >= cityMissingAudio.length, `planned missing-audio queue should cover unresolved city audio, found ${queueRows} queue rows for ${cityMissingAudio.length} city missing rows`);
  assert(
    cityMissingAudio.length <= pages.length,
    `city missing-audio queue should not exceed city pages, got ${cityMissingAudio.length} missing rows for ${pages.length} pages`
  );

  console.log(`City library OK: ${pages.length} pages, ${difficultyCounts.beginner ?? 0} beginner, ${difficultyCounts.intermediate ?? 0} intermediate, ${difficultyCounts.advanced ?? 0} advanced`);
}

main();
