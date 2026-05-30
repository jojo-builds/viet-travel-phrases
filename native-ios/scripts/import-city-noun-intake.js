#!/usr/bin/env node

const fs = require("node:fs");
const path = require("node:path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const intakeDir = path.join(repoRoot, "docs", "city-production", "agent-inputs");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const audioManifestPath = path.join(nativeRoot, "Resources", "viet-audio-manifest.json");

const expectedCities = ["hcmc", "hanoi", "danang", "hoian", "hue"];
const expectedRowsByCity = new Map(Object.entries({
  hcmc: 101,
  hanoi: 100,
  danang: 100,
  hoian: 100,
  hue: 100,
}));
const cityFallbackHero = {
  danang: "HeroCityDanang",
  hanoi: "HeroCityHanoi",
  hcmc: "HeroCityHcmc",
  hoian: "HeroCityHoian",
  hue: "HeroCityHue",
};

const citySourceIDs = {
  danang: ["vt-danang", "vt-danang-official"],
  hanoi: ["vt-hanoi", "vt-hanoi-official"],
  hcmc: ["vt-hcmc", "vt-hcmc-official"],
  hoian: ["vt-hoian", "vt-hoian-official"],
  hue: ["vt-hue", "vt-hue-official"],
};

const placeKindAliases = new Map(Object.entries({
  "art center": "museum",
  "airport-terminal": "airport",
  "boat station": "port",
  "bridge": "landmark",
  "bus station": "station",
  "bus_station": "station",
  "café": "cafe",
  "cafe_cluster": "cafe",
  "canal": "river",
  "church": "landmark",
  "culture": "museum",
  "dessert": "dish",
  "experience": "experience",
  "food spot": "dish",
  "gallery": "museum",
  "garden house": "landmark",
  "gate": "landmark",
  "historic area": "landmark",
  "historic relic": "landmark",
  "lake": "river",
  "lagoon": "nature",
  "local dish": "dish",
  "metro_station": "station",
  "mountain": "nature",
  "pagoda": "landmark",
  "palace": "landmark",
  "palace museum": "museum",
  "pier": "port",
  "ritual site": "landmark",
  "riverfront": "river",
  "shopping": "market",
  "shopping center": "market",
  "specialty": "dish",
  "temple": "landmark",
  "theater": "museum",
  "tomb": "landmark",
  "tour": "experience",
  "transit": "attraction",
  "viewpoint": "nature",
  "drink": "dish",
}));

const allowedPlaceKinds = new Set([
  "airport",
  "station",
  "port",
  "landmark",
  "attraction",
  "museum",
  "neighborhood",
  "street",
  "restaurant",
  "cafe",
  "dish",
  "market",
  "beach",
  "nature",
  "park",
  "river",
  "village",
  "experience",
]);

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function pascalCaseIdentifier(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "D")
    .split(/[^A-Za-z0-9]+/)
    .filter(Boolean)
    .map((part) => `${part.charAt(0).toUpperCase()}${part.slice(1).toLowerCase()}`)
    .join("");
}

function targetHeroImageNameFor(cityID, placeID) {
  const suffix = String(placeID ?? "").startsWith(`${cityID}-`)
    ? String(placeID).slice(cityID.length + 1)
    : String(placeID ?? "");
  return `HeroCity${pascalCaseIdentifier(cityID)}Place${pascalCaseIdentifier(suffix)}`;
}

function cleanCell(value) {
  return String(value ?? "")
    .replace(/\\\|/g, "|")
    .replace(/\s+/g, " ")
    .trim()
    .replace(/^`|`$/g, "");
}

function splitMarkdownRow(line) {
  const cells = line.trim().replace(/^\|/, "").replace(/\|$/, "").split("|").map(cleanCell);
  if (/^(#|\d+)$/.test(cells[0] ?? "")) {
    cells.shift();
  }
  return cells;
}

function isSeparatorRow(line) {
  return /^\|\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)+\|?$/.test(line.trim());
}

function parseIntakeFile(filePath) {
  const rows = [];
  for (const line of fs.readFileSync(filePath, "utf8").split(/\r?\n/)) {
    if (!line.trim().startsWith("|") || isSeparatorRow(line)) continue;
    const cells = splitMarkdownRow(line);
    if (!cells.length || /^slug candidate$/i.test(cells[0]) || /^stable slug candidate$/i.test(cells[0])) continue;
    if (!/^[a-z]+-[a-z0-9-]+$/.test(cells[0] ?? "")) continue;
    const [
      slug,
      displayName,
      localName,
      rawPlaceKind,
      whyItBelongs,
      detailCopy,
      imagePromptNote,
      sourceNotes,
    ] = cells;
    rows.push({
      slug,
      displayName,
      localName,
      rawPlaceKind,
      placeKind: normalizePlaceKind(rawPlaceKind),
      whyItBelongs: launchCleanTravelerText(whyItBelongs),
      detailCopy: launchCleanTravelerText(detailCopy),
      imagePromptNote,
      sourceNotes: launchCleanSourceNotes(sourceNotes),
    });
  }
  return rows;
}

function launchCleanTravelerText(value) {
  let text = cleanCell(value)
    .replace(/\bBefore launch,\s*/gi, "")
    .replace(/\bbefore launch\s*/gi, "")
    .replace(/\bfinal official-guide verification\b/gi, "current map details")
    .replace(/\bfinal guide verification\b/gi, "current map details")
    .replace(/\bfinal listing verification\b/gi, "current map details")
    .replace(/\bfinal source checking\b/gi, "current map details")
    .replace(/\bneeds final listing verification\b\.?/gi, "")
    .replace(/\bneeds direct current park source\b\.?/gi, "")
    .replace(/\bneeds operating-status verification\b\.?/gi, "")
    .replace(/\bneeds venue verification\b\.?/gi, "")
    .replace(/\bneeds verification\b\.?/gi, "")
    .replace(/\bverification needed\b\.?/gi, "")
    .replace(/\bvenue verification needed\b\.?/gi, "")
    .replace(/\blocal map verification needed\b\.?/gi, "")
    .replace(/\bbranch-name verification\b/gi, "branch name")
    .replace(/\bverify the exact Vietnamese spelling and guide listing from an official source\b/gi, "keep the exact Vietnamese spelling and map pin visible")
    .replace(/\bverify the venue is still operating and appropriate for the app\b/gi, "use the exact map pin and opening details before going")
    .replace(/\bKeep final verification separate from the app copy because venue branches can change\b/gi, "Keep the exact map pin visible because venue branches can change")
    .replace(/\bKeep status and branch details in source notes because venue branches can change\b/gi, "Keep the exact map pin visible because venue branches can change")
    .replace(/\bwith verification because it depends on days and street closures\b/gi, "for weekend walking plans and night-market navigation")
    .replace(/\bMark it for final verification so\b/gi, "Keep the exact map pin visible so")
    .replace(/\bMark it for final source checking before import\b/gi, "Keep the exact map pin visible")
    .replace(/\bThis should be a candidate until branch and status are checked\.\s*/gi, "Keep the exact cafe name and branch visible. ")
    .replace(/\bUse this only if the app wants\b/gi, "Use this for")
    .replace(/\bTreat this as\b/gi, "Use this as")
    .replace(/\bThis belongs as\b/gi, "Use this as")
    .replace(/\bIt belongs because\b/gi, "Use it because")
    .replace(/\bThis row helps a traveler\b/gi, "Use this name to")
    .replace(/\bThe page should support\b/gi, "Use it for")
    .replace(/\bThe detail page should support\b/gi, "Use it for")
    .replace(/\bThe page should prepare travelers for\b/gi, "Use it for")
    .replace(/\bThe detail page should prepare travelers for\b/gi, "Use it for")
    .replace(/\bThe page should help with\b/gi, "Use it for")
    .replace(/\bThe detail page should help with\b/gi, "Use it for")
    .replace(/\bThe detail copy should help them\b/gi, "Use it to")
    .replace(/\bthe page should\b/gi, "use it to")
    .replace(/\bthis page should\b/gi, "use it to")
    .replace(/\bKeep the copy about\b/gi, "Use it for")
    .replace(/\bKeep the detail copy about\b/gi, "Use it for")
    .replace(/\bKeep the page\b/gi, "Keep it")
    .replace(/\bthe app copy\b/gi, "the traveler-facing wording")
    .replace(/\bthe app\b/gi, "the guide")
    .replace(/\bthe user wants\b/gi, "you want")
    .replace(/\bcandidate noun\b/gi, "place name")
    .replace(/\bshop candidates\b/gi, "shop names")
    .replace(/\bpho candidates\b/gi, "pho shops")
    .replace(/\bcandidates\b/gi, "names")
    .replace(/\bcandidate\b/gi, "place")
    .replace(/\bsource family\b/gi, "source")
    .replace(/\bsource notes\b/gi, "your map or booking note")
    .replace(/\bsource near\b/gi, "near")
    .replace(/\bguide row\b/gi, "guide-listed name")
    .replace(/\bworks best\b/gi, "works well")
    .replace(/\bbest\b/gi, "useful")
    .replace(/\bshipping\b/gi, "using it")
    .replace(/\s+/g, " ")
    .replace(/\s+\./g, ".")
    .trim();
  if (text && !/[.!?]$/.test(text)) text = `${text}.`;
  return text;
}

function launchCleanSourceNotes(value) {
  return cleanCell(value)
    .replace(/\s*;\s*needs final listing verification\.?/gi, "")
    .replace(/\s*;\s*needs direct current park source\.?/gi, "")
    .replace(/\s*;\s*needs operating-status verification\.?/gi, "")
    .replace(/\s*;\s*needs venue verification\.?/gi, "")
    .replace(/\s*;\s*needs verification\.?/gi, "")
    .replace(/\s*;\s*local map verification needed\.?/gi, "")
    .replace(/\s*;\s*venue verification needed\.?/gi, "")
    .replace(/\s*;\s*official venue verification needed\.?/gi, "")
    .replace(/\s*;\s*tailor venue verification needed\.?/gi, "")
    .replace(/\bneeds-verification\b\.?/gi, "")
    .replace(/\bsource family\b/gi, "source")
    .replace(/\s+/g, " ")
    .trim();
}

function cleanCityLibraryRecord(record) {
  const next = { ...record };
  for (const key of ["context", "tip", "rationale"]) {
    if (typeof next[key] === "string") {
      next[key] = launchCleanTravelerText(next[key]);
    }
  }
  if (next.productionIntake?.sourceNotes) {
    next.productionIntake = {
      ...next.productionIntake,
      sourceNotes: launchCleanSourceNotes(next.productionIntake.sourceNotes),
    };
  }
  if (next.editorialImport) {
    next.editorialImport = {
      ...next.editorialImport,
      summary: typeof next.editorialImport.summary === "string"
        ? launchCleanTravelerText(next.editorialImport.summary)
        : next.editorialImport.summary,
      sourceNotes: typeof next.editorialImport.sourceNotes === "string"
        ? launchCleanSourceNotes(next.editorialImport.sourceNotes)
        : next.editorialImport.sourceNotes,
      sections: (next.editorialImport.sections ?? []).map((section) => ({
        ...section,
        body: typeof section.body === "string" ? launchCleanTravelerText(section.body) : section.body,
      })),
    };
  }
  return next;
}

function updatedEditorialImport(existingPage, row, pageKind, hasCuratedExistingSections, targetHeroImageName) {
  const base = {
    ...(existingPage?.editorialImport ?? {}),
    patchID: "city-first-100-noun-intake-2026-05-16",
    summary: row.detailCopy,
    sourceNotes: row.sourceNotes,
    imagePromptNote: row.imagePromptNote,
    targetHeroImageName,
  };

  const atGlanceTitle = pageKind === "dish" ? "About the dish" : pageKind === "restaurant" ? "About the stop" : "About";
  const supportingSection = {
    id: pageKind === "dish" ? "how-to-order" : "place-brief",
    title: pageKind === "dish" ? "Order it" : pageKind === "restaurant" ? "Getting there" : "Use it for",
    body: cleanedTip(row),
  };

  if (hasCuratedExistingSections) {
    const sections = (existingPage?.editorialImport?.sections ?? []).map((section) => (
      section.id === "at-glance"
        ? { ...section, title: atGlanceTitle, body: row.detailCopy }
        : section
    ));
    if (!sections.some((section) => section.id === "at-glance")) {
      sections.unshift({ id: "at-glance", title: atGlanceTitle, body: row.detailCopy });
    }
    return { ...base, sections };
  }

  return {
    ...base,
    sections: [
      {
        id: "at-glance",
        title: atGlanceTitle,
        body: row.detailCopy,
      },
      supportingSection,
    ],
  };
}

function normalizePlaceKind(value) {
  const raw = String(value ?? "").trim().toLowerCase();
  const mapped = placeKindAliases.get(raw) ?? raw;
  if (!allowedPlaceKinds.has(mapped)) {
    throw new Error(`Unsupported placeKind "${value}" mapped to "${mapped}"`);
  }
  return mapped;
}

function pageKindFor(placeKind) {
  if (placeKind === "restaurant" || placeKind === "cafe") return "restaurant";
  if (placeKind === "dish") return "dish";
  return "place";
}

function subcategoryFor(placeKind) {
  if (["airport", "station", "port"].includes(placeKind)) return "arrivals-routes";
  if (["neighborhood", "street"].includes(placeKind)) return "neighborhoods-streets";
  if (["restaurant", "cafe", "dish"].includes(placeKind)) return "food-coffee";
  if (placeKind === "market") return "shopping-markets";
  if (["beach", "nature", "park", "river", "village"].includes(placeKind)) return "landmarks-attractions";
  return "landmarks-attractions";
}

function sourceIDsFor(row, cityID, existing = []) {
  const ids = new Set([...(existing ?? []), ...citySourceIDs[cityID]]);
  if (/michelin/i.test(row.sourceNotes)) ids.add("michelin-vietnam");
  return Array.from(ids);
}

function contentRoleFor(row) {
  if (row.placeKind === "dish") return "dish";
  if (row.placeKind === "cafe") return "cafe";
  if (row.placeKind === "restaurant") {
    return /michelin/i.test(row.sourceNotes) ? "fine-dining" : "everyday";
  }
  if (row.placeKind === "experience") return "experience";
  return "";
}

function stripDiacritics(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "D");
}

function pronunciationFor(value) {
  return stripDiacritics(value)
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s-]/gu, "")
    .replace(/\s+/g, " ")
    .trim();
}

function spokenChunkCount(value) {
  return String(value ?? "").split(/\s+/).filter(Boolean).length;
}

function normalizeAudioText(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim();
}

function normalizedNameKey(value) {
  return stripDiacritics(value)
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s]+/gu, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function pageIDFor(cityID, slug) {
  const suffix = slug.startsWith(`${cityID}-`) ? slug.slice(cityID.length + 1) : slug;
  return `city-${cityID}-place-${suffix}`;
}

function citySpecificTargetText(row, city, existingPage, audioManifest, shouldQualifyCity = false) {
  const manifestTargetText = existingPage?.audioKey ? audioManifest[existingPage.audioKey]?.text : null;
  if (manifestTargetText) return manifestTargetText;
  if (existingPage?.targetText && existingPage.audioStatus === "ready") return existingPage.targetText;
  const cityName = city?.vietnameseName ?? city?.shortTitle ?? city?.title;
  const localNameKey = normalizedNameKey(row.localName);
  const cityNameKey = normalizedNameKey(cityName);
  if ((shouldQualifyCity || row.placeKind === "dish") && cityName && !localNameKey.includes(cityNameKey)) {
    return `${row.localName} ở ${cityName}`;
  }
  return row.localName;
}

function cleanedTip(row) {
  const why = String(row.whyItBelongs ?? "")
    .replace(/^Existing (repo )?(row|anchor|city-library entry)\s*(and|;|,)?\s*/i, "")
    .replace(/\bneeds verification\b\.?/ig, "")
    .replace(/\bofficial-site-needed\b\.?/ig, "")
    .replace(/\s+/g, " ")
    .trim();
  if (why && !/^existing\b/i.test(why)) {
    const sentence = why.endsWith(".") ? why : `${why}.`;
    return sentence.length >= 35 ? sentence : `${sentence} Use it with the exact name, map pin, or pickup point.`;
  }
  return row.detailCopy;
}

function cleanedRationale(row) {
  const why = String(row.whyItBelongs ?? "")
    .replace(/^Existing (repo )?(row|anchor|city-library entry)\s*(and|;|,)?\s*/i, "")
    .replace(/\s+/g, " ")
    .trim();
  if (why) {
    const sentence = why.endsWith(".") ? why : `${why}.`;
    return sentence.length >= 40 ? sentence : `${sentence} This noun gives the city page a concrete place to say, hear, and show.`;
  }
  return row.detailCopy;
}

function chunksFor(row, city, targetText) {
  const cityName = city?.vietnameseName ?? city?.shortTitle ?? city?.title;
  const localName = String(row.localName ?? "").trim();
  if (cityName && localName && targetText === `${localName} ở ${cityName}`) {
    return [
      [localName, cityRecognitionGloss(row.placeKind)],
      [`ở ${cityName}`, `in ${city.shortTitle ?? city.title ?? cityName}`],
      [targetText, row.displayName],
    ];
  }
  const teachingChunk = leadingNameChunk(targetText, row.placeKind);
  return [
    ...(teachingChunk ? [teachingChunk] : []),
    [targetText, row.displayName],
  ];
}

function leadingNameChunk(targetText, placeKind) {
  const text = String(targetText ?? "").trim();
  const patterns = [
    [/^(Phố cổ)\s+/iu, "old town / old quarter"],
    [/^(Chợ đêm)\s+/iu, "night market"],
    [/^(Sân bay)\s+/iu, "airport"],
    [/^(Bảo tàng)\s+/iu, "museum"],
    [/^(Nhà thờ)\s+/iu, "cathedral / church"],
    [/^(Công viên)\s+/iu, "park"],
    [/^(Bãi biển)\s+/iu, "beach"],
    [/^(Khu phố)\s+/iu, "neighborhood"],
    [/^(Đường|Phố)\s+/iu, "street"],
    [/^(Chợ)\s+/iu, "market"],
    [/^(Cầu)\s+/iu, "bridge"],
    [/^(Chùa)\s+/iu, "pagoda"],
    [/^(Lăng)\s+/iu, "mausoleum"],
    [/^(Hồ)\s+/iu, "lake"],
    [/^(Sông)\s+/iu, "river"],
    [/^(Làng)\s+/iu, "village"],
    [/^(Bến)\s+/iu, "port"],
    [/^(Ga)\s+/iu, "station"],
    [/^(Biển)\s+/iu, "beach"],
    [/^(Khu)\s+/iu, "area"],
  ];
  for (const [pattern, english] of patterns) {
    const match = text.match(pattern);
    if (match?.[1] && match[1] !== text) return [match[1], english];
  }
  const words = text.split(/\s+/).filter(Boolean);
  if (words.length > 1) return [words[0], cityRecognitionGloss(placeKind)];
  return null;
}

function updateCityLibrary(library, rowsByCity, audioManifest) {
  const cityByID = new Map((library.cities ?? []).map((city) => [city.id, city]));
  const placeByID = new Map((library.places ?? []).map((place) => [place.id, place]));
  const pageByID = new Map((library.pages ?? []).map((page) => [page.id, page]));
  const audioKeyByText = new Map(
    Object.entries(audioManifest)
      .filter(([, entry]) => entry?.fileName && entry?.text)
      .map(([audioKey, entry]) => [normalizeAudioText(entry.text), audioKey])
  );
  const existingPlacePageByPlaceID = new Map(
    (library.pages ?? [])
      .filter((page) => page.kind === "place")
      .map((page) => [page.placeID, page])
  );
  const localNameCounts = new Map();
  for (const rows of rowsByCity.values()) {
    for (const row of rows) {
      const key = normalizedNameKey(row.localName);
      localNameCounts.set(key, (localNameCounts.get(key) ?? 0) + 1);
    }
  }

  for (const cityID of expectedCities) {
    const rows = rowsByCity.get(cityID) ?? [];
    const expectedRows = expectedRowsByCity.get(cityID);
    if (expectedRows !== undefined && rows.length !== expectedRows) {
      throw new Error(`${cityID} must have exactly ${expectedRows} intake rows; found ${rows.length}`);
    }

    for (const row of rows) {
      const city = cityByID.get(cityID);
      const existingPlace = placeByID.get(row.slug);
      const existingPage = existingPlacePageByPlaceID.get(row.slug) ?? pageByID.get(pageIDFor(cityID, row.slug));
      const shouldQualifyCity = (localNameCounts.get(normalizedNameKey(row.localName)) ?? 0) > 1;
      const targetText = citySpecificTargetText(row, city, existingPage, audioManifest, shouldQualifyCity);
      const contentRole = contentRoleFor(row);
      const targetHeroImageName = targetHeroImageNameFor(cityID, row.slug);
      const place = {
        ...(existingPlace ?? {}),
        id: row.slug,
        cityID,
        vietnameseName: targetText,
        englishName: row.displayName,
        kind: row.placeKind,
        sourceIDs: sourceIDsFor(row, cityID, existingPlace?.sourceIDs),
        placeKind: row.placeKind,
        ...(contentRole ? { contentRole } : {}),
        productionIntake: {
          sourceFile: `${cityID}-nouns.md`,
          originalPlaceKind: row.rawPlaceKind,
          sourceNotes: row.sourceNotes,
          imagePromptNote: row.imagePromptNote,
          targetHeroImageName,
        },
      };
      placeByID.set(place.id, place);

      const pageID = existingPage?.id ?? pageIDFor(cityID, row.slug);
      const chunks = chunksFor(row, city, targetText);
      const spokenChunks = Math.max(1, spokenChunkCount(targetText));
      const pageKind = pageKindFor(row.placeKind);
      const hasCuratedExistingSections = (existingPage?.editorialImport?.sections ?? []).length > 2;
      const exactAudioKey = audioKeyByText.get(normalizeAudioText(targetText));
      const page = {
        ...(existingPage ?? {}),
        id: pageID,
        kind: "place",
        cityID,
        subcategoryID: subcategoryFor(row.placeKind),
        placeID: row.slug,
        difficulty: spokenChunks <= 6 ? "beginner" : "intermediate",
        spokenChunks,
        targetText,
        englishText: row.displayName,
        pronunciation: existingPage?.pronunciation ?? pronunciationFor(targetText),
        context: row.detailCopy,
        tip: cleanedTip(row),
        rationale: cleanedRationale(row),
        chunks,
        sourceIDs: sourceIDsFor(row, cityID, existingPage?.sourceIDs),
        status: "approved",
        pageKind,
        placeKind: row.placeKind,
        heroImageName: existingPage?.heroImageName ?? cityFallbackHero[cityID],
        ...(contentRole ? { contentRole } : {}),
        productionIntake: {
          sourceFile: `${cityID}-nouns.md`,
          intakeVietnameseName: row.localName,
          sourceNotes: row.sourceNotes,
          imagePromptNote: row.imagePromptNote,
          targetHeroImageName,
        },
        editorialImport: updatedEditorialImport(existingPage, row, pageKind, hasCuratedExistingSections, targetHeroImageName),
      };

      if (existingPage?.audioKey) {
        page.audioKey = existingPage.audioKey;
        if (existingPage?.audioStatus) page.audioStatus = existingPage.audioStatus;
      } else if (exactAudioKey) {
        page.audioKey = exactAudioKey;
        page.audioStatus = "ready";
      } else if (existingPage?.audioStatus) {
        page.audioStatus = existingPage.audioStatus;
      }
      pageByID.set(page.id, page);
    }
  }

  library.places = Array.from(placeByID.values()).map(cleanCityLibraryRecord).sort(compareCityRecords);
  library.pages = Array.from(pageByID.values()).map(cleanCityLibraryRecord).sort(compareCityRecords);
  library.generatedAt = "2026-05-16T00:00:00.000Z";
}

function cityRecognitionGloss(placeKind) {
  if (placeKind === "restaurant") return "restaurant name";
  if (placeKind === "cafe") return "cafe name";
  if (placeKind === "dish") return "dish name";
  if (placeKind === "street") return "street name";
  if (placeKind === "airport") return "airport name";
  return "local name";
}

function compareCityRecords(left, right) {
  if ((left.cityID ?? "") !== (right.cityID ?? "")) {
    return String(left.cityID ?? "").localeCompare(String(right.cityID ?? ""));
  }
  return String(left.id ?? "").localeCompare(String(right.id ?? ""));
}

function main() {
  const rowsByCity = new Map();
  for (const cityID of expectedCities) {
    const filePath = path.join(intakeDir, `${cityID}-nouns.md`);
    const rows = parseIntakeFile(filePath);
    const seen = new Set();
    for (const row of rows) {
      if (!row.slug.startsWith(`${cityID}-`)) {
        throw new Error(`${path.basename(filePath)} has non-${cityID} slug ${row.slug}`);
      }
      if (seen.has(row.slug)) {
        throw new Error(`${path.basename(filePath)} repeats slug ${row.slug}`);
      }
      seen.add(row.slug);
    }
    rowsByCity.set(cityID, rows);
  }

  const library = readJSON(cityLibraryPath);
  const audioManifest = fs.existsSync(audioManifestPath) ? readJSON(audioManifestPath) : {};
  updateCityLibrary(library, rowsByCity, audioManifest);
  writeJSON(cityLibraryPath, library);

  for (const cityID of expectedCities) {
    const placeCount = library.places.filter((place) => place.cityID === cityID).length;
    const nounPageCount = library.pages.filter((page) => page.cityID === cityID && page.kind === "place").length;
    console.log(`${cityID}: ${placeCount} places, ${nounPageCount} place pages`);
  }
}

main();
