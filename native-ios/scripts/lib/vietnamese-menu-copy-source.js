const fs = require("fs");
const path = require("path");

const SOURCE_RELATIVE_DIR = path.join("content-draft", "viet", "menu");
const ITEM_SOURCE_RELATIVE_DIR = path.join(SOURCE_RELATIVE_DIR, "items");
const INDEX_RELATIVE_PATH = path.join(SOURCE_RELATIVE_DIR, "_menu-index.json");
const HELPERS_RELATIVE_PATH = path.join(SOURCE_RELATIVE_DIR, "menu-helper-phrases.json");
const RUNTIME_RELATIVE_PATH = path.join("native-ios", "Resources", "vietnamese-menu-copy.json");
const CSV_RELATIVE_PATH = path.join(SOURCE_RELATIVE_DIR, "speaklocal_vietnamese_full_menu_detail_copy.csv");

const CSV_HEADER = [
  "item_id",
  "menu_type",
  "category",
  "subcategory",
  "popular",
  "vietnamese_item",
  "english_translation",
  "romanized_no_tones",
  "sound_out",
  "notes",
  "at_a_glance",
  "usually_includes",
  "good_to_know",
  "common_options",
  "quick_say_vietnamese",
  "quick_say_english",
  "quick_say_sound_out",
  "what_it_is",
  "how_to_enjoy",
  "how_locals_order",
  "worth_knowing",
  "regional_association",
  "origin_posture",
  "traveler_caution",
  "helper_phrase_ids",
  "order_line_audio_policy",
  "editorial_status",
];

function loadAuthoredMenuSource(repoRoot) {
  const indexPath = path.join(repoRoot, INDEX_RELATIVE_PATH);
  const helpersPath = path.join(repoRoot, HELPERS_RELATIVE_PATH);
  const index = readJSON(indexPath);
  const helperPhrases = readJSON(helpersPath).helperPhrases ?? [];
  const helperIDs = new Set(helperPhrases.map((helper) => helper.id));
  const items = [];

  for (const category of index.categories ?? []) {
    for (const itemID of category.itemIDs ?? []) {
      const itemPath = path.join(repoRoot, ITEM_SOURCE_RELATIVE_DIR, category.id, `${itemID}.json`);
      const item = readJSON(itemPath);
      item.__sourcePath = path.relative(repoRoot, itemPath);

      for (const helperID of item.helperPhraseIDs ?? []) {
        if (!helperIDs.has(helperID)) {
          throw new Error(`${item.itemID} references unknown helper phrase ${helperID}`);
        }
      }

      items.push(item);
    }
  }

  return { index, helperPhrases, items };
}

function buildRuntimePayload(source) {
  const items = source.items.map(runtimeItemForSourceItem);
  const foodCount = items.filter((item) => item.menuType === "Food").length;
  const drinkCount = items.filter((item) => item.menuType === "Drink").length;

  return {
    metadata: {
      source: INDEX_RELATIVE_PATH,
      itemSource: ITEM_SOURCE_RELATIVE_DIR,
      helperSource: HELPERS_RELATIVE_PATH,
      rowCount: items.length,
      foodCount,
      drinkCount,
      handwrittenReviewedCount: items.filter(
        (item) => item.editorialReview?.status === "handwritten-reviewed"
      ).length,
      helperPhraseCount: source.helperPhrases.length,
      orderLineAudioPolicy: "text-only",
    },
    helperPhrases: source.helperPhrases,
    items,
  };
}

function runtimeItemForSourceItem(item) {
  return {
    itemID: item.itemID,
    menuType: item.menuType,
    category: item.category,
    subcategory: item.subcategory ?? "",
    popular: Boolean(item.popular),
    vietnameseItem: item.vietnameseItem,
    englishTranslation: item.englishTranslation,
    romanizedNoTones: item.romanizedNoTones,
    soundOut: item.soundOut,
    notes: item.notes ?? "",
    atAGlance: item.atAGlance,
    usuallyIncludes: item.usuallyIncludes ?? [],
    goodToKnow: item.goodToKnow,
    commonOptions: item.commonOptions ?? [],
    quickSayVietnamese: item.orderLine?.vietnamese ?? item.quickSayVietnamese,
    quickSayEnglish: item.orderLine?.english ?? item.quickSayEnglish,
    quickSaySoundOut: item.orderLine?.pronunciation ?? item.quickSaySoundOut,
    orderLine: {
      vietnamese: item.orderLine?.vietnamese ?? item.quickSayVietnamese,
      english: item.orderLine?.english ?? item.quickSayEnglish,
      pronunciation: item.orderLine?.pronunciation ?? item.quickSaySoundOut,
      audioPolicy: "text-only",
    },
    whatItIs: item.whatItIs,
    howToEnjoy: item.howToEnjoy,
    howLocalsOrder: item.howLocalsOrder,
    worthKnowing: item.worthKnowing,
    regionalAssociation: item.regionalAssociation ?? "",
    originPosture: item.originPosture ?? "",
    travelerCaution: item.travelerCaution ?? "",
    helperPhraseIDs: item.helperPhraseIDs ?? [],
    editorialReview: item.editorialReview ?? { status: "needs-review" },
  };
}

function buildCSV(source) {
  const rows = [CSV_HEADER];

  for (const item of source.items.map(runtimeItemForSourceItem)) {
    rows.push([
      item.itemID,
      item.menuType,
      item.category,
      item.subcategory,
      item.popular ? "true" : "false",
      item.vietnameseItem,
      item.englishTranslation,
      item.romanizedNoTones,
      item.soundOut,
      item.notes,
      item.atAGlance,
      item.usuallyIncludes.join(" | "),
      item.goodToKnow,
      item.commonOptions.join(" | "),
      item.quickSayVietnamese,
      item.quickSayEnglish,
      item.quickSaySoundOut,
      item.whatItIs,
      item.howToEnjoy,
      item.howLocalsOrder,
      item.worthKnowing,
      item.regionalAssociation,
      item.originPosture,
      item.travelerCaution,
      item.helperPhraseIDs.join(" | "),
      item.orderLine.audioPolicy,
      item.editorialReview?.status ?? "needs-review",
    ]);
  }

  return stringifyCSV(rows);
}

function readRuntimePayload(repoRoot) {
  return readJSON(path.join(repoRoot, RUNTIME_RELATIVE_PATH));
}

function writeRuntimeAndCSV(repoRoot, payload, csvText) {
  writeJSON(path.join(repoRoot, RUNTIME_RELATIVE_PATH), payload);
  fs.writeFileSync(path.join(repoRoot, CSV_RELATIVE_PATH), csvText);
}

function stableStringify(value) {
  return `${JSON.stringify(value, null, 2)}\n`;
}

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, stableStringify(value));
}

function stringifyCSV(rows) {
  return rows.map((row) => row.map(csvCell).join(",")).join("\n") + "\n";
}

function csvCell(value) {
  const cell = value == null ? "" : String(value);
  return /[",\n\r]/.test(cell) ? `"${cell.replaceAll("\"", "\"\"")}"` : cell;
}

function slug(value) {
  return String(value)
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/đ/g, "d")
    .replace(/&/g, " and ")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "") || "menu-items";
}

module.exports = {
  CSV_RELATIVE_PATH,
  HELPERS_RELATIVE_PATH,
  INDEX_RELATIVE_PATH,
  ITEM_SOURCE_RELATIVE_DIR,
  RUNTIME_RELATIVE_PATH,
  buildCSV,
  buildRuntimePayload,
  loadAuthoredMenuSource,
  readRuntimePayload,
  slug,
  stableStringify,
  writeJSON,
  writeRuntimeAndCSV,
};
