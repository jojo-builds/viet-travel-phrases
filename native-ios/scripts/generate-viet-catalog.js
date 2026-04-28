#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const sourcePath = path.resolve(__dirname, "../../content-draft/viet/phrase-source.csv");
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
};

function normalizeRow(row) {
  return Object.fromEntries(
    Object.entries(row).map(([key, value]) => [key, String(value || "").trim()])
  );
}

function main() {
  const source = fs.readFileSync(sourcePath, "utf8");
  const rows = parseCSV(source);
  const headers = rows.shift().map((header) => header.replace(/^\uFEFF/, ""));
  const records = rows
    .filter((row) => row.length > 1)
    .map((row) => normalizeRow(Object.fromEntries(headers.map((header, index) => [header, row[index] || ""]))))
    .filter((row) => row.status === "approved");

  const scenariosByID = new Map();
  const familiesByID = new Map();

  for (const row of records) {
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

  const phrases = records.map((row) => ({
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
  }));

  const catalog = {
    metadata: {
      source: path.relative(path.dirname(outputPath), sourcePath),
      phraseCount: phrases.length,
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
