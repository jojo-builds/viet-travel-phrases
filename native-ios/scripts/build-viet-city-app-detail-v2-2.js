#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const defaultSourceDir = path.join(repoRoot, "content-draft", "viet", "city-library", "handwritten-copy");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const phraseCatalogPath = path.join(repoRoot, "native-ios", "Resources", "viet-phrase-catalog.json");
const defaultOutDir = path.join(repoRoot, "content-draft", "viet", "city-library", "app-detail-v2-2");
const v22GatePath = path.join(repoRoot, "docs", "design", "city-pages", "V2_2_RENDER_PILOT_REDO_APP_DETAILS.json");

const contentContract = "speaklocal.place.app-detail.v2.2";
const cityIDs = ["danang", "hanoi", "hcmc", "hoian", "hue"];
const subcategoryLabels = {
  "arrivals-routes": "Arrival",
  "landmarks-attractions": "Attraction",
  "neighborhoods-streets": "Neighborhood",
  "food-coffee": "Food & Coffee",
  "shopping-markets": "Shopping",
  "practical-help-near-places": "Practical Help",
};
const placeKindLabels = {
  airport: "Arrival",
  attraction: "Attraction",
  beach: "Beach",
  cafe: "Cafe",
  dessert: "Dessert",
  dish: "Dish",
  drink: "Drink",
  landmark: "Landmark",
  market: "Market",
  museum: "Museum",
  nature: "Nature",
  neighborhood: "Neighborhood",
  park: "Park",
  port: "Port",
  restaurant: "Restaurant",
  river: "River",
  station: "Station",
  street: "Street",
  village: "Village",
};

function parseArgs(argv) {
  const args = {
    sourceDir: defaultSourceDir,
    outDir: defaultOutDir,
  };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--source-dir") {
      args.sourceDir = path.resolve(repoRoot, requiredArg(argv, index, arg));
      index += 1;
    } else if (arg === "--out-dir") {
      args.outDir = path.resolve(repoRoot, requiredArg(argv, index, arg));
      index += 1;
    } else if (arg === "--help" || arg === "-h") {
      printHelp();
      process.exit(0);
    } else {
      throw new Error(`unknown argument: ${arg}`);
    }
  }
  return args;
}

function requiredArg(argv, index, flag) {
  const value = argv[index + 1];
  if (!value || value.startsWith("--")) {
    throw new Error(`${flag} requires a value`);
  }
  return value;
}

function printHelp() {
  console.log([
    "Usage: node native-ios/scripts/build-viet-city-app-detail-v2-2.js [--out-dir DIR] [--source-dir DIR]",
    "",
    "Builds first-class v2.2 app-detail source JSON from authored handwritten city copy.",
  ].join("\n"));
}

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function normalize(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim();
}

function sourceSlug(value, fallback = "section") {
  const slug = normalize(value)
    .normalize("NFKD")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .replace(/-+/g, "-");
  return slug || fallback;
}

function requiredText(value, label, pageID) {
  const text = normalize(value);
  if (!text) {
    throw new Error(`${pageID} missing ${label}`);
  }
  return text;
}

function titleCase(value) {
  return normalize(value)
    .split(/[\s-]+/)
    .filter(Boolean)
    .map((part) => `${part.slice(0, 1).toUpperCase()}${part.slice(1)}`)
    .join(" ");
}

function displayCityName(cityID, city) {
  if (cityID === "hcmc") return "Saigon";
  return city?.vietnameseName ?? city?.shortTitle ?? cityID;
}

function categoryFor(page) {
  const kind = normalize(page.placeKind || page.kind).toLowerCase();
  return placeKindLabels[kind] ?? subcategoryLabels[page.subcategoryID] ?? titleCase(kind || page.subcategoryID);
}

function loadPhraseCatalog() {
  const catalog = readJSON(phraseCatalogPath);
  return new Map((catalog.phrases ?? []).map((phrase) => [phrase.id, phrase]));
}

function loadV22Gate() {
  if (!fs.existsSync(v22GatePath)) return new Map();
  const rows = readJSON(v22GatePath);
  const gateByID = new Map();
  for (const row of Array.isArray(rows) ? rows : []) {
    const id = normalize(row.id);
    if (!id) continue;
    const qaValues = Object.entries(row.qa ?? {})
      .filter(([key]) => key !== "notes")
      .map(([, value]) => value);
    const passed = qaValues.length > 0 && qaValues.every((value) => value === "pass");
    if (passed) {
      gateByID.set(id, {
        source: path.relative(repoRoot, v22GatePath),
        score: row.score,
      });
    }
  }
  return gateByID;
}

function cityFilePath(sourceDir, cityID) {
  return path.join(sourceDir, `${cityID}.json`);
}

function entryByID(entries) {
  const byID = new Map();
  for (const entry of entries) {
    const pageID = requiredText(entry.pageID, "pageID", "(unknown)");
    if (byID.has(pageID)) {
      throw new Error(`duplicate handwritten entry ${pageID}`);
    }
    byID.set(pageID, entry);
  }
  return byID;
}

function usefulPhraseCards(entry, page, phraseByID) {
  const quickSay = (entry.sections ?? []).find((section) => section.id === "quick-say");
  const phraseIDs = Array.isArray(quickSay?.phraseIDs) ? quickSay.phraseIDs : [];
  const cards = phraseIDs.map((phraseID) => {
    const phrase = phraseByID.get(phraseID);
    if (!phrase) {
      return {
        vi: phraseID,
        en: phraseID,
        intent: phraseID,
        phraseId: phraseID,
        audioId: null,
        status: "new_phrase_needed",
      };
    }
    return {
      vi: requiredText(phrase.targetText, "phrase targetText", entry.pageID),
      en: requiredText(phrase.englishText, "phrase englishText", entry.pageID),
      intent: normalize(phrase.familyID || phrase.id),
      phraseId: phrase.id,
      audioId: phrase.audioStatus === "ready" ? phrase.audioKey ?? phrase.id : null,
      status: phrase.audioStatus === "ready" ? "mapped" : "hide_until_audio",
    };
  });

  if (cards.length > 0) return cards;
  return [{
    vi: requiredText(page.targetText, "targetText", entry.pageID),
    en: requiredText(page.englishText, "englishText", entry.pageID),
    intent: "recognize_place_name",
    phraseId: page.id,
    audioId: null,
    status: "hide_until_audio",
  }];
}

function appDetailSections(entry) {
  const seenIDs = new Map();
  return (entry.sections ?? [])
    .filter((section) => section.id !== "at-glance" && section.id !== "quick-say")
    .filter((section) => normalize(section.title) && normalize(section.body))
    .slice(0, 4)
    .map((section, index) => {
      const baseID = sourceSlug(section.title, `section-${index + 1}`);
      const count = seenIDs.get(baseID) ?? 0;
      seenIDs.set(baseID, count + 1);
      const id = count === 0 ? baseID : `${baseID}-${count + 1}`;
      return {
        id,
        heading: requiredText(section.title, `section ${section.id} title`, entry.pageID),
        body: requiredText(section.body, `section ${section.id} body`, entry.pageID),
      };
    });
}

function qaFor(status, gate) {
  return {
    replaceabilityTest: "needs_review",
    phraseCardTest: "needs_review",
    mentionedHereTest: "needs_review",
    catalogMentionScan: "needs_review",
    duplicateBodyTest: "needs_review",
    antiCynicismTest: "needs_review",
    notes: [
      "Generated as structured source from handwritten copy only; v2.2 voice, phrase, catalog, and render gates still need review.",
    ],
  };
}

function scoreFor(status, gate) {
  return {
    value: 0,
    max: 30,
    reason: "Not scored by this source refresh; requires v2.2 voice and QA gate.",
  };
}

function buildEntry(entry, page, city, phraseByID, gateByID, sourceRelPath) {
  const pageID = requiredText(entry.pageID, "pageID", "(unknown)");
  const familyID = `viet-family-${pageID}`;
  const atGlance = (entry.sections ?? []).find((section) => section.id === "at-glance");
  const sections = appDetailSections(entry);
  if (sections.length < 2) {
    throw new Error(`${pageID} must produce at least 2 v2.2 sections`);
  }
  const gate = gateByID.get(familyID);
  const status = "needs_voice_gate";
  const sourceReviewStatus = page.editorialImport?.reviewStatus ?? page.cityMetadata?.editorialReviewStatus ?? null;

  return {
    contentContract,
    id: familyID,
    pageID,
    sourcePageID: pageID,
    displayName: requiredText(page.targetText, "targetText", pageID),
    englishName: requiredText(page.englishText, "englishText", pageID),
    city: displayCityName(page.cityID, city),
    category: categoryFor(page),
    pronunciation: requiredText(page.pronunciation, "pronunciation", pageID),
    travelerMoment: requiredText(entry.context ?? page.context, "travelerMoment", pageID),
    storySpine: requiredText(entry.rationale ?? page.rationale, "storySpine", pageID),
    intro: {
      heading: requiredText(atGlance?.title ?? sections[0]?.heading, "intro heading", pageID),
      body: requiredText(entry.summary ?? page.editorialImport?.summary, "intro body", pageID),
    },
    usefulPhraseCards: usefulPhraseCards(entry, page, phraseByID),
    sections,
    mentionedHereCandidates: [],
    relatedPlaceCandidates: [],
    verificationFlags: [
      {
        type: "native_speaker_qa",
        reason: "Voice gate has not been run by this deterministic source refresh.",
        blocking: true,
      },
      {
        type: "catalog_qa",
        reason: "Mentioned Here and related-place candidates are intentionally not inferred by this script.",
        blocking: false,
      },
      {
        type: "audio_qa",
        reason: "Phrase cards reuse mapped catalog audio when present; fallback place-name cards stay hidden until audio is mapped.",
        blocking: false,
      },
    ],
    qa: qaFor(status, gate),
    score: scoreFor(status, gate),
    sourceNotes: [
      `Migration provenance: created from ${sourceRelPath}; that file is input/projection evidence only.`,
      page.productionIntake?.sourceNotes ? `Production intake source notes: ${page.productionIntake.sourceNotes}` : null,
      gate ? `Prior v2.2 pilot evidence source: ${gate.source}. This is evidence only, not FINAL_PASS approval.` : "No existing v2.2 gate evidence found; this refresh starts at needs_voice_gate.",
    ].filter(Boolean),
    status,
    review: {
      status,
      sourceReviewStatus,
      voiceGateStatus: "needs_review",
      v2_2GateStatus: gate ? "legacy_evidence_found" : "not_found",
      v2_2GateSources: gate ? [gate.source] : [],
      generatedFrom: sourceRelPath,
      notes: [
        "No final-copy generation performed.",
        "Earlier city-library fields were used only as migration input; first-class v2.2 section IDs are heading-derived.",
      ],
    },
  };
}

function buildCityFile(cityID, sourceDir, cityLibrary, phraseByID, gateByID) {
  const sourcePath = cityFilePath(sourceDir, cityID);
  const sourceRelPath = path.relative(repoRoot, sourcePath);
  const source = readJSON(sourcePath);
  if (source.cityID !== cityID) {
    throw new Error(`${sourceRelPath} has cityID ${source.cityID}, expected ${cityID}`);
  }
  const entries = Array.isArray(source.entries) ? source.entries : [];
  const sourceEntriesByID = entryByID(entries);
  const city = cityLibrary.cities.find((row) => row.id === cityID);
  const pagesByID = new Map(cityLibrary.pages.map((page) => [page.id, page]));

  const appEntries = [...sourceEntriesByID.keys()].sort().map((pageID) => {
    const entry = sourceEntriesByID.get(pageID);
    const page = pagesByID.get(pageID);
    if (!page) {
      throw new Error(`${pageID} missing from content-draft/viet/city-library/v1.json`);
    }
    return buildEntry(entry, page, city, phraseByID, gateByID, sourceRelPath);
  });

  return {
    contentContract,
    schemaVersion: 1,
    cityID,
    source: {
      handwrittenCopy: sourceRelPath,
      cityLibrary: path.relative(repoRoot, cityLibraryPath),
      phraseCatalog: path.relative(repoRoot, phraseCatalogPath),
    },
    counts: {
      entries: appEntries.length,
      needsVoiceGate: appEntries.filter((entry) => entry.status === "needs_voice_gate").length,
      legacyV2_2GateEvidence: appEntries.filter((entry) => entry.review.v2_2GateStatus === "legacy_evidence_found").length,
    },
    entries: appEntries,
  };
}

function buildAll({ sourceDir, outDir }) {
  const cityLibrary = readJSON(cityLibraryPath);
  const phraseByID = loadPhraseCatalog();
  const gateByID = loadV22Gate();
  const cityFiles = cityIDs.map((cityID) => buildCityFile(cityID, sourceDir, cityLibrary, phraseByID, gateByID));
  fs.mkdirSync(outDir, { recursive: true });

  for (const cityFile of cityFiles) {
    writeJSON(path.join(outDir, `${cityFile.cityID}.json`), cityFile);
  }

  const byCity = Object.fromEntries(cityFiles.map((cityFile) => [cityFile.cityID, cityFile.counts.entries]));
  const needsVoiceGate = cityFiles.reduce((sum, cityFile) => sum + cityFile.counts.needsVoiceGate, 0);
  const legacyV2_2GateEvidence = cityFiles.reduce((sum, cityFile) => sum + cityFile.counts.legacyV2_2GateEvidence, 0);
  const finalPass = cityFiles.reduce((sum, cityFile) => (
    sum + cityFile.entries.filter((entry) => entry.status === "FINAL_PASS").length
  ), 0);
  const index = {
    contentContract,
    schemaVersion: 1,
    source: {
      handwrittenCopyDir: path.relative(repoRoot, sourceDir),
      cityLibrary: path.relative(repoRoot, cityLibraryPath),
      phraseCatalog: path.relative(repoRoot, phraseCatalogPath),
      v2_2Gate: fs.existsSync(v22GatePath) ? path.relative(repoRoot, v22GatePath) : null,
    },
    output: {
      directory: path.relative(repoRoot, outDir),
      files: ["_index.json", ...cityIDs.map((cityID) => `${cityID}.json`)],
    },
    counts: {
      cities: cityFiles.length,
      entries: cityFiles.reduce((sum, cityFile) => sum + cityFile.counts.entries, 0),
      byCity,
      needsVoiceGate,
      legacyV2_2GateEvidence,
      finalPass,
    },
    entries: cityFiles.flatMap((cityFile) => cityFile.entries.map((entry) => ({
      id: entry.id,
      pageID: entry.pageID,
      cityID: cityFile.cityID,
      status: entry.status,
      file: `${cityFile.cityID}.json`,
    }))),
  };
  writeJSON(path.join(outDir, "_index.json"), index);
  return index;
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  const index = buildAll(args);
  console.log(`built v2.2 app-detail source: cities: ${index.counts.cities}; entries: ${index.counts.entries}; needs_voice_gate: ${index.counts.needsVoiceGate}; legacy_v2_2_gate_evidence: ${index.counts.legacyV2_2GateEvidence}; out: ${path.relative(repoRoot, args.outDir)}`);
}

if (require.main === module) {
  try {
    main();
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}

module.exports = {
  buildAll,
};
