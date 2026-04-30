#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const sourcePath = path.resolve(__dirname, "../../content-draft/viet/phrase-source.csv");
const cityLibraryPath = path.resolve(__dirname, "../../content-draft/viet/city-library/v1.json");
const outputPath = path.resolve(__dirname, "../Resources/viet-phrase-catalog.json");

function parseCSV(text) {
  const rows = [];
  let row = [];
  let field = "";
  let inQuotes = false;

  for (let index = 0; index < text.length; index += 1) {
    const character = text[index];
    const nextCharacter = text[index + 1];

    if (inQuotes) {
      if (character === "\"" && nextCharacter === "\"") {
        field += "\"";
        index += 1;
      } else if (character === "\"") {
        inQuotes = false;
      } else {
        field += character;
      }
      continue;
    }

    if (character === "\"") {
      inQuotes = true;
    } else if (character === ",") {
      row.push(field);
      field = "";
    } else if (character === "\n") {
      row.push(field);
      rows.push(row);
      row = [];
      field = "";
    } else if (character !== "\r") {
      field += character;
    }
  }

  if (field.length > 0 || row.length > 0) {
    row.push(field);
    rows.push(row);
  }

  return rows;
}

function titleizeScenario(id) {
  return id
    .split("-")
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(" ");
}

const scenarioPresentation = {
  "polite-basics": ["Polite Basics", "hand.wave.fill", "red"],
  "understanding-repair": ["When You Don't Understand", "questionmark.bubble.fill", "blue"],
  transport: ["Transport", "car.fill", "orange"],
  "hotel-accommodation": ["Hotel Accommodation", "bed.double.fill", "purple"],
  "food-drink": ["Food & Drink", "fork.knife", "green"],
  "money-numbers-prices": ["Money, Numbers & Prices", "creditcard.fill", "green"],
  "directions-navigation": ["Directions & Navigation", "location.fill", "blue"],
  "airport-border-arrival": ["Airport Border Arrival", "airplane.arrival", "blue"],
  "health-pharmacy": ["Health & Pharmacy", "cross.case.fill", "red"],
  "problems-help": ["Problems & Help", "exclamationmark.triangle.fill", "orange"],
  "time-dates-booking": ["Time, Dates & Booking", "calendar", "teal"],
  shopping: ["Shopping", "bag.fill", "purple"],
  "phone-internet-power": ["Phone, Internet & Power", "wifi", "blue"],
  "bathroom-personal-needs": ["Bathroom & Personal Needs", "person.fill", "teal"],
  "emergency-safety": ["Emergency & Safety", "cross.circle.fill", "red"],
  "social-small-talk": ["Social Small Talk", "bubble.left.and.bubble.right.fill", "green"],
  "sightseeing-activities": ["Sightseeing & Activities", "camera.fill", "purple"],
  "local-services-everyday-tasks": ["Local Services & Everyday Tasks", "building.2.fill", "teal"],
  "city-guides": ["City Guides", "map.fill", "teal"],
};

function normalizeRow(row) {
  return Object.fromEntries(
    Object.entries(row).map(([key, value]) => [key, String(value || "").trim()])
  );
}

function normalizeCitySearchAliases({ city, place, page }) {
  return [
    city?.title,
    city?.shortTitle,
    city?.vietnameseName,
    place?.englishName,
    place?.vietnameseName,
    page.englishText,
    page.targetText,
    ...(page.searchAliases ?? []),
  ]
    .filter(Boolean)
    .map((alias) => String(alias).trim())
    .filter(Boolean);
}

function loadCityLibraryRecords() {
  if (!fs.existsSync(cityLibraryPath)) {
    return [];
  }

  const library = JSON.parse(fs.readFileSync(cityLibraryPath, "utf8"));
  const cityByID = new Map((library.cities ?? []).map((city) => [city.id, city]));
  const placeByID = new Map((library.places ?? []).map((place) => [place.id, place]));
  const subcategoryByID = new Map((library.subcategories ?? []).map((subcategory) => [subcategory.id, subcategory]));
  const scenarioID = library.scenarioID ?? "city-guides";
  const accessTier = library.accessTier ?? "premium";
  const audioStatus = library.audioStatus ?? "planned";

  return (library.pages ?? [])
    .filter((page) => page.status === "approved")
    .map((page) => {
      const city = cityByID.get(page.cityID);
      const place = placeByID.get(page.placeID);
      const subcategory = subcategoryByID.get(page.subcategoryID);
      if (!city) {
        throw new Error(`City library page ${page.id} references missing city ${page.cityID}`);
      }
      if (!place) {
        throw new Error(`City library page ${page.id} references missing place ${page.placeID}`);
      }
      if (!subcategory) {
        throw new Error(`City library page ${page.id} references missing subcategory ${page.subcategoryID}`);
      }

      const familyTitle = page.familyTitle ?? (page.kind === "place"
        ? `${place.englishName} pronunciation`
        : page.englishText);
      const familySummary = page.summary ?? page.context;
      const searchAliases = normalizeCitySearchAliases({ city, place, page });
      const notes = [
        "city-library-v1",
        `city=${page.cityID}`,
        `subcategory=${page.subcategoryID}`,
        `difficulty=${page.difficulty}`,
        `kind=${page.kind}`,
        `place=${page.placeID}`,
      ].join("; ");

      return {
        phrase_id: page.id,
        family_id: page.id,
        scenario_id: scenarioID,
        family_title: familyTitle,
        family_summary: familySummary,
        audio_key: page.audioKey ?? "",
        english_text: page.englishText,
        target_text: page.targetText,
        canonical_target_text: page.canonicalTargetText ?? page.targetText,
        pronunciation: page.pronunciation,
        access_tier: page.accessTier ?? accessTier,
        variant_role: "say-first",
        context: page.context,
        you_may_hear: page.youMayHear ?? "",
        search_aliases: Array.from(new Set(searchAliases)).join("|"),
        warning_note_type: "",
        audio_status: page.audioStatus ?? audioStatus,
        emoji: city.emoji ?? "🗺️",
        notes,
        cityID: page.cityID,
        cityName: city.title,
        cityShortTitle: city.shortTitle,
        cityVietnameseName: city.vietnameseName,
        citySubcategoryID: page.subcategoryID,
        citySubcategoryTitle: subcategory.title,
        difficulty: page.difficulty,
        placeID: page.placeID,
        placeName: place.englishName,
        placeVietnameseName: place.vietnameseName,
        cityLibraryKind: page.kind,
        spokenChunks: page.spokenChunks,
        sourceIDs: page.sourceIDs ?? [],
      };
    });
}

function main() {
  const source = fs.readFileSync(sourcePath, "utf8");
  const rows = parseCSV(source);
  const headers = rows.shift().map((header) => header.replace(/^\uFEFF/, ""));
  const records = rows
    .filter((row) => row.length > 1)
    .map((row) => normalizeRow(Object.fromEntries(headers.map((header, index) => [header, row[index] || ""]))))
    .filter((row) => row.status === "approved");
  const cityRecords = loadCityLibraryRecords();
  const approvedRecords = [...records, ...cityRecords];

  const scenariosByID = new Map();
  const familiesByID = new Map();

  for (const row of approvedRecords) {
    if (!scenariosByID.has(row.scenario_id)) {
      const presentation = scenarioPresentation[row.scenario_id] || [
        titleizeScenario(row.scenario_id),
        "text.bubble.fill",
        "gray",
      ];

      scenariosByID.set(row.scenario_id, {
        id: row.scenario_id,
        title: presentation[0],
        symbolName: presentation[1],
        tintName: presentation[2],
      });
    }

    if (!familiesByID.has(row.family_id)) {
      familiesByID.set(row.family_id, {
        id: row.family_id,
        pageID: `viet-family-${row.family_id}`,
        scenarioID: row.scenario_id,
        familyTitle: row.family_title,
        summary: row.family_summary,
        primaryPhraseID: row.phrase_id,
        accessTier: row.access_tier,
        phraseIDs: [],
      });
    }

    const family = familiesByID.get(row.family_id);
    family.phraseIDs.push(row.phrase_id);

    if (row.variant_role === "say-first") {
      family.primaryPhraseID = row.phrase_id;
    }

    if (row.access_tier === "starter") {
      family.accessTier = "starter";
    }
  }

  const phrases = approvedRecords.map((row) => ({
    id: row.phrase_id,
    familyID: row.family_id,
    scenarioID: row.scenario_id,
    audioKey: row.audio_key,
    englishText: row.english_text,
    targetText: row.target_text,
    canonicalTargetText: row.canonical_target_text,
    pronunciation: row.pronunciation,
    accessTier: row.access_tier,
    variantRole: row.variant_role,
    context: row.context,
    youMayHear: row.you_may_hear,
    searchAliases: row.search_aliases
      .split("|")
      .map((alias) => alias.trim())
      .filter(Boolean),
    warningNoteType: row.warning_note_type,
    audioStatus: row.audio_status,
    emoji: row.emoji,
    notes: row.notes,
    cityID: row.cityID ?? null,
    cityName: row.cityName ?? null,
    cityShortTitle: row.cityShortTitle ?? null,
    cityVietnameseName: row.cityVietnameseName ?? null,
    citySubcategoryID: row.citySubcategoryID ?? null,
    citySubcategoryTitle: row.citySubcategoryTitle ?? null,
    difficulty: row.difficulty ?? null,
    placeID: row.placeID ?? null,
    placeName: row.placeName ?? null,
    placeVietnameseName: row.placeVietnameseName ?? null,
    cityLibraryKind: row.cityLibraryKind ?? null,
    spokenChunks: row.spokenChunks ?? null,
    sourceIDs: row.sourceIDs ?? [],
  }));

  const catalog = {
    metadata: {
      source: path.relative(path.dirname(outputPath), sourcePath),
      cityLibrarySource: fs.existsSync(cityLibraryPath) ? path.relative(path.dirname(outputPath), cityLibraryPath) : null,
      phraseCount: phrases.length,
      basePhraseCount: records.length,
      cityPhraseCount: cityRecords.length,
      familyCount: familiesByID.size,
      scenarioCount: scenariosByID.size,
    },
    scenarios: Array.from(scenariosByID.values()),
    families: Array.from(familiesByID.values()),
    phrases,
  };

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, `${JSON.stringify(catalog, null, 2)}\n`);
  console.log(`Wrote ${outputPath}`);
  console.log(`${catalog.metadata.familyCount} families, ${catalog.metadata.phraseCount} phrases`);
}

main();
