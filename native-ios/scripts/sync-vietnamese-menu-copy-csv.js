#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const menuJSONPath = path.join(repoRoot, "native-ios", "Resources", "vietnamese-menu-copy.json");
const menuCSVPath = path.join(repoRoot, "content-draft", "viet", "menu", "speaklocal_vietnamese_full_menu_detail_copy.csv");
const overridesPath = path.join(__dirname, "vietnamese-menu-cultural-copy-overrides.json");

const overrides = JSON.parse(fs.readFileSync(overridesPath, "utf8"));
const overrideIDs = new Set(Object.keys(overrides));
const payload = JSON.parse(fs.readFileSync(menuJSONPath, "utf8"));
const itemsByID = new Map(payload.items.map((item) => [item.itemID, item]));
const rows = parseCSV(fs.readFileSync(menuCSVPath, "utf8"));
const [header, ...bodyRows] = rows;
const headerIndexes = new Map(header.map((name, index) => [name, index]));

const fieldMap = {
  atAGlance: "at_a_glance",
  usuallyIncludes: "usually_includes",
  goodToKnow: "good_to_know",
  commonOptions: "common_options",
  quickSayVietnamese: "quick_say_vietnamese",
  quickSayEnglish: "quick_say_english",
  quickSaySoundOut: "quick_say_sound_out",
  whatItIs: "what_it_is",
  howToEnjoy: "how_to_enjoy",
  worthKnowing: "worth_knowing",
  regionalAssociation: "regional_association",
  originPosture: "origin_posture",
  travelerCaution: "traveler_caution",
};

let updated = 0;

for (const row of bodyRows) {
  const itemID = row[headerIndexes.get("item_id")];
  if (!overrideIDs.has(itemID)) {
    continue;
  }

  const item = itemsByID.get(itemID);
  if (!item) {
    throw new Error(`Missing JSON item for ${itemID}`);
  }

  for (const [jsonField, csvField] of Object.entries(fieldMap)) {
    if (!Object.prototype.hasOwnProperty.call(overrides[itemID], jsonField)) {
      continue;
    }

    const columnIndex = headerIndexes.get(csvField);
    if (columnIndex == null) {
      throw new Error(`Missing CSV column ${csvField}`);
    }

    row[columnIndex] = csvValue(item[jsonField]);
  }

  updated += 1;
}

fs.writeFileSync(menuCSVPath, stringifyCSV([header, ...bodyRows]));
console.log(`Synced ${updated} Vietnamese menu override rows back to CSV`);

function csvValue(value) {
  if (Array.isArray(value)) {
    return value.join(" | ");
  }
  return value == null ? "" : String(value);
}

function parseCSV(text) {
  const rows = [];
  let row = [];
  let cell = "";
  let inQuotes = false;

  for (let index = 0; index < text.length; index += 1) {
    const character = text[index];
    const next = text[index + 1];

    if (inQuotes) {
      if (character === "\"" && next === "\"") {
        cell += "\"";
        index += 1;
      } else if (character === "\"") {
        inQuotes = false;
      } else {
        cell += character;
      }
      continue;
    }

    if (character === "\"") {
      inQuotes = true;
    } else if (character === ",") {
      row.push(cell);
      cell = "";
    } else if (character === "\n") {
      row.push(cell);
      rows.push(row);
      row = [];
      cell = "";
    } else if (character !== "\r") {
      cell += character;
    }
  }

  if (cell.length > 0 || row.length > 0) {
    row.push(cell);
    rows.push(row);
  }

  return rows;
}

function stringifyCSV(rows) {
  return rows.map((row) => row.map(csvCell).join(",")).join("\n") + "\n";
}

function csvCell(value) {
  const cell = value == null ? "" : String(value);
  return /[",\n\r]/.test(cell) ? `"${cell.replaceAll("\"", "\"\"")}"` : cell;
}
