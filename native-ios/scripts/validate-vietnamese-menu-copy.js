#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const {
  buildRuntimePayload,
  loadAuthoredMenuSource,
} = require("./lib/vietnamese-menu-copy-source");

const repoRoot = path.resolve(__dirname, "..", "..");
const manifestPath = path.join(repoRoot, "native-ios", "Resources", "viet-audio-manifest.json");
const audioDir = path.join(repoRoot, "native-ios", "Resources", "Audio");

const blockedVisibleFragments = [
  "common menu item",
  "easy point-and-order choice",
  "Vietnamese menu item",
  "centered on",
  "the main topping",
  "common anchors",
  "strong café-style finish",
  "cold, simple, or familiar drink order",
  "database",
  "template",
  "generated",
  "content role",
  "page kind",
  "this page helps",
  "the traveler needs",
  "the user should",
  "the likely ingredients are",
  "how sweet or icy",
  "hot version",
  "herbs, broth, grill, or dip",
  "depending on the shop, the balance may lean",
  "useful window",
  "whole eating style",
  "cultural value",
  "the thing to notice is",
  "A plate or bowl of",
  "Vietnamese sweet:",
  "Vietnamese sweet with",
  "thick soup base",
  "vegetarian sauce",
  "mushrooms or tofu",
  "a small dipping bowl",
  "generic fish in sauce",
  "generic chicken-and-rice plate",
  "which make the dish easier to spot",
  "details tell you whether",
  "so the pleasure is in how those pieces meet",
  "The cue is",
  "as the detail to watch for",
  "built around",
  "cautious eaters",
  "Depending on the order",
  "best ordered by cooking style and protein",
  "a sharp a small",
  "chiliping",
  "For a cautious order",
  "hot bowls",
  "grilled plates",
  "rolls before",
  "rice, noodles, greens, or wrapper",
  "hands-on Vietnamese snack eating",
  "herbs, wrappers, crunch",
  "vegetarian soy-lime vegetarian",
  "an useful",
  "the a small dipping bowl",
  "made with winter melon soup",
  "one sandwich of",
  "bBQ",
  "Maggi-style soy seasoning, chili or pâté spread",
  "soy-based muối tiêu",
  "For fish, ask about bones",
  "Pointing at",
  "typically made with",
  "Travelers can read",
  "ordering cue",
  "works in Vietnam",
  "American menus",
  "Americans",
  "For Americans",
];

const unglossedOrderingFragments = [
  "ask it cay",
  "it cay",
  "không cay",
  "không ớt",
  "ít đá",
  "không đá",
  "ít đường",
  "không đường",
  "ít ngọt",
  "ít muối",
  "ít sữa",
  "không sữa",
  "không pate",
  "không pâté",
  "không đậu phộng",
  "không nước mắm",
  "nước mắm riêng",
  "nước chấm",
  "nước-chấm",
  "nuoc cham",
  "ít dầu",
  "thêm rau",
  "thêm cơm",
  "thêm trứng",
  "thêm chanh",
  "khuấy đều",
  "nước dùng chay",
  "có xương không",
  "còn vỏ không",
  "có thịt không",
  "chay được không",
  "có nước mắm không",
  "không rượu",
  "nhẹ tiêu",
  "milk đặc",
  "thêm cà phê",
  "ask hot, đá",
  "cà phê đen hot",
  "cà phê sữa hot",
  "trà hot",
];

const mechanicalCaseFragments = [
  "; Ask",
  ". ask for",
  "then Ask",
  "and Ask",
  "so Ask",
  "no ice for no ice",
];

const vagueSauceFragments = [
  "extra sauce",
  "dipping sauce",
  "house sauce",
  "rich sauce",
  "seasoning sauce",
  "stir-fry sauce",
  "braising sauce",
  "sweet-and-sour sauce",
  "with sauce",
  "and sauce",
  "the sauce",
  "sauce is served separately",
];

const drinkSensoryMarkers = [
  "alcoholic",
  "bitter",
  "body",
  "bubbles",
  "buttery",
  "caffeine",
  "caramel",
  "clean",
  "cold",
  "condensed",
  "cooling",
  "cream",
  "creamy",
  "crisp",
  "earthy",
  "fizzy",
  "floral",
  "fragrant",
  "grassy",
  "herbal",
  "ice",
  "icy",
  "juicy",
  "lager",
  "light",
  "malt",
  "mellow",
  "milk",
  "mineral",
  "neutral",
  "nutty",
  "plain",
  "pulpy",
  "refreshing",
  "roasted",
  "salty",
  "sharp",
  "silky",
  "slippery",
  "smooth",
  "soft",
  "sour",
  "sparkling",
  "strong",
  "sweet",
  "sweetness",
  "syrupy",
  "tangy",
  "tannic",
  "tart",
  "thick",
  "tropical",
];

const localOrderMarkers = [
  "ask",
  "order",
  "say",
  "choose",
  "start",
  "pour",
  "dip",
  "wrap",
  "share",
  "sip",
  "sweet",
  "ice",
  "hot",
  "cold",
  "broth",
  "herbs",
  "chili",
  "lime",
  "condensed",
  "phin",
  "bottle",
  "glass",
  "bowl",
  "plate",
  "with rice",
  "on the side",
];

const localContextMarkers = [
  "Vietnam",
  "Vietnamese",
  "Hanoi",
  "Hà Nội",
  "Huế",
  "Hội An",
  "Saigon",
  "Sài Gòn",
  "Chợ Lớn",
  "Mekong",
  "Mỹ Tho",
  "Đà Lạt",
  "Nha Trang",
  "Vũng Tàu",
  "Phú Yên",
  "Quảng Nam",
  "Cầu Mống",
  "Sóc Trăng",
  "Tết",
  "northern Vietnam",
  "southern Vietnam",
  "central Vietnam",
  "central coast",
  "Mekong Delta",
  "northern",
  "southern",
  "central",
  "coastal",
  "highland",
  "street",
  "stall",
  "shop",
  "rice-shop",
  "noodle-shop",
  "snack",
  "family",
  "home",
  "homestyle",
  "home-style",
  "breakfast",
  "market",
  "table",
  "party",
  "wedding",
  "gift",
  "Buddhist",
  "Chinese-Vietnamese",
  "French",
  "French-influenced",
  "chay",
  "rice paper",
  "mắm",
  "nước mắm",
  "means",
  "word",
  "signals",
  "points to",
  "origin",
  "story",
];

const ricePaperGuidanceRequirements = {
  "food-banh-xeo": ["rice paper", "herbs", "fish-sauce dip"],
  "food-banh-xeo-chay": ["rice paper", "herbs", "vegetarian"],
  "food-banh-khot": ["rice paper", "herbs", "fish-sauce dip"],
  "food-goi-cuon-chay": ["rice paper", "herbs"],
  "food-nem-nuong": ["rice paper", "herbs"],
  "food-thit-luoc-cuon-banh-trang": ["rice paper", "roll", "herbs"],
  "food-be-thui-cuon-banh-trang": ["rice paper", "roll", "herbs"],
  "food-bo-nhung-dam": ["rice paper", "roll", "herbs"],
  "food-ca-loc-nuong-trui": ["rice paper", "bones", "herbs"],
  "food-chao-tom": ["rice paper", "sugarcane", "herbs"],
  "food-banh-hoi-thit-nuong": ["rice paper", "herbs"],
  "food-banh-hoi-heo-quay": ["rice paper", "herbs"],
  "food-heo-quay-banh-hoi": ["rice paper", "herbs"],
};

const originConnectionRequirements = {
  "drink-ca-phe-trung": ["Hanoi", "1946", "milk"],
  "food-com-tam-suon": ["broken rice", "southern"],
  "food-com-tam-bi-cha-suon": ["broken rice", "southern"],
  "food-com-tam-suon-bi-cha-trung": ["broken-rice", "southern"],
  "food-banh-mi-pate": ["French", "Vietnam", "street"],
  "food-banh-mi-thit": ["French", "Vietnam", "street"],
  "food-banh-mi-dac-biet": ["French", "Vietnam", "street"],
  "food-banh-mi-cha-lua": ["French", "Vietnam"],
  "food-banh-mi-ga": ["French", "Vietnam", "street"],
  "food-banh-mi-heo-quay": ["French", "Vietnam"],
  "food-banh-mi-op-la": ["French", "Vietnam"],
  "food-banh-mi-thit-nuong": ["French", "Vietnam"],
  "food-banh-mi-xiu-mai": ["French", "Vietnam"],
  "food-banh-mi-chay": ["French", "Vietnam"],
};

const itemSpecificBlockedFragments = {
  "food-hu-tieu-my-tho": ["fish-sauce caramel braise"],
  "food-cao-lau": ["fish-sauce dip"],
  "food-hu-tieu-kho": ["fish-sauce caramel braise"],
  "food-com-tam-suon": ["muối tiêu chanh"],
  "food-com-bo-luc-lac": ["fish-sauce dip"],
  "food-com-chien-hai-san": ["muối tiêu chanh", "ginger fish sauce"],
  "food-com-chien-ga": ["muối tiêu chanh"],
  "food-com-chien-bo": ["fish-sauce dip"],
  "food-com-chien-trung": ["fish-sauce dip"],
  "food-xoi-bap": ["fish-sauce dip"],
  "food-banh-beo": ["rolls"],
  "food-khoai-lang-chien": ["fish-sauce caramel braise"],
  "food-khoai-tay-chien": ["fish-sauce caramel braise"],
  "food-cha-ca-la-vong": ["lime-pepper/ginger fish sauce"],
  "food-tom-chien-xu": ["fish-sauce caramel braise"],
  "food-muc-xao-chua-ngot": ["garlic-fish-sauce glaze"],
  "food-ngheu-xao-bo-toi": ["garlic-fish-sauce glaze", "generated correction"],
  "food-thit-kho-tau": ["creamy coconut sauce"],
  "food-gio-heo-ham": ["fish-sauce caramel braise", "caramel sauce"],
  "food-ga-hap-hanh": ["tamarind sauce"],
  "food-ga-nuong-la-chanh": ["tamarind sauce"],
  "food-bo-luc-lac": ["tamarind sauce"],
  "food-bo-ne": ["fish-sauce dip"],
  "food-bo-kho-banh-mi": ["fish-sauce caramel braise"],
  "food-de-hap-tia-to": ["tamarind sauce"],
  "food-ca-ri-de": ["lime-pepper", "ginger fish sauce"],
  "food-de-xao-lan": ["garlic-fish-sauce glaze"],
  "food-vit-om-sau": ["muối tiêu chanh"],
  "food-bo-xao-luc-lac": ["garlic-fish-sauce stir-fry glaze"],
  "food-bo-xao-rau-cai": ["garlic-fish-sauce stir-fry glaze"],
  "food-bo-xao-sa-ot": ["garlic-fish-sauce stir-fry glaze"],
  "food-bun-bo-hue-chay": ["vegetarian sauce"],
  "food-hu-tieu-chay": ["vegetarian sauce"],
  "food-pho-chay": ["vegetarian sauce"],
};

const helperContextMarkers = {
  "menu-ask-peanuts": ["peanut"],
  "menu-peanut-allergy": ["peanut"],
  "menu-sauce-on-side": ["sauce", "dip", "dressing", "glaze", "gravy", "nước", "mắm", "soy", "tương", "broth"],
  "menu-less-sugar": ["sweet", "sugar", "syrup", "condensed", "caramel", "dessert", "cake", "chè", "milk", "coconut", "chocolate", "honey"],
  "menu-no-sugar": ["sweet", "sugar", "syrup", "condensed", "caramel", "dessert", "cake", "chè", "milk", "coconut", "chocolate", "honey"],
  "menu-less-ice": ["ice", "iced", "cold", "chilled", "bottle", "can", "glass", "sparkling", "water", "smoothie", "juice", "tea", "coffee"],
  "menu-no-ice": ["ice", "iced", "cold", "chilled", "bottle", "can", "glass", "sparkling", "water", "smoothie", "juice", "tea", "coffee"],
};

main();

function main() {
  const source = loadAuthoredMenuSource(repoRoot);
  const payload = buildRuntimePayload(source);
  const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
  const failures = [];

  if (payload.items.length !== 355) {
    failures.push(`Expected 355 menu items, found ${payload.items.length}`);
  }
  if (payload.metadata.foodCount !== 269) {
    failures.push(`Expected 269 food items, found ${payload.metadata.foodCount}`);
  }
  if (payload.metadata.drinkCount !== 86) {
    failures.push(`Expected 86 drink items, found ${payload.metadata.drinkCount}`);
  }

  const ids = new Set();
  for (const item of payload.items) {
    const context = item.itemID || "<missing id>";
    if (ids.has(item.itemID)) {
      failures.push(`${context}: duplicate itemID`);
    }
    ids.add(item.itemID);

    for (const field of [
      "itemID",
      "menuType",
      "category",
      "vietnameseItem",
      "englishTranslation",
      "soundOut",
      "atAGlance",
      "whatItIs",
      "howToEnjoy",
      "howLocalsOrder",
      "worthKnowing",
      "goodToKnow",
    ]) {
      if (!String(item[field] ?? "").trim()) {
        failures.push(`${context}: missing ${field}`);
      }
    }

    if (!Array.isArray(item.usuallyIncludes) || item.usuallyIncludes.length === 0) {
      failures.push(`${context}: missing usuallyIncludes`);
    }
    if (!Array.isArray(item.commonOptions) || item.commonOptions.length === 0) {
      failures.push(`${context}: missing commonOptions`);
    }
    if (item.editorialReview?.status !== "handwritten-reviewed") {
      failures.push(`${context}: editorialReview.status must be handwritten-reviewed`);
    }
    if (
      item.menuType === "Drink" &&
      new RegExp(`^${escapeRegExp(item.vietnameseItem)}\\\\s+is\\\\s+[^:]+:`, "i").test(item.atAGlance)
    ) {
      failures.push(`${context}: drink atAGlance still uses item-is-translation template wording`);
    }
    if (item.orderLine?.audioPolicy !== "text-only") {
      failures.push(`${context}: orderLine.audioPolicy must be text-only`);
    }
    const howLocalsOrder = String(item.howLocalsOrder ?? "").trim();
    if (howLocalsOrder.split(/\s+/).length < 18) {
      failures.push(`${context}: howLocalsOrder needs a specific traveler-facing ordering note`);
    }
    if (
      howLocalsOrder &&
      !localOrderMarkers.some((marker) => howLocalsOrder.toLowerCase().includes(marker))
    ) {
      failures.push(`${context}: howLocalsOrder should describe an actual ordering/eating/drinking move`);
    }
    if (!hasPlayableExactAudio(manifest, item.vietnameseItem)) {
      failures.push(`${context}: missing playable exact menu-name audio for ${item.vietnameseItem}`);
    }

    const visibleText = [
      item.atAGlance,
      item.whatItIs,
      item.howToEnjoy,
      item.howLocalsOrder,
      item.worthKnowing,
      item.goodToKnow,
      item.travelerCaution,
      item.usuallyIncludes.join(" "),
      item.commonOptions.join(" "),
    ].join("\n");
    const blocked = blockedVisibleFragments.find((fragment) =>
      visibleText.toLowerCase().includes(fragment.toLowerCase())
    );
    if (blocked) {
      failures.push(`${context}: visible copy contains blocked fragment "${blocked}"`);
    }
    const unglossedOrdering = unglossedOrderingFragments.find((fragment) =>
      visibleText.toLowerCase().includes(fragment.toLowerCase())
    );
    if (unglossedOrdering) {
      failures.push(`${context}: visible copy contains unglossed ordering phrase "${unglossedOrdering}"`);
    }
    if (
      visibleText.toLowerCase().includes("ít cay") &&
      !/less spicy[^.\n]{0,80}ít cay/i.test(visibleText)
    ) {
      failures.push(`${context}: visible copy uses "ít cay" without giving "less spicy" before it`);
    }
    const mechanicalCase = mechanicalCaseFragments.find((fragment) => visibleText.includes(fragment));
    if (mechanicalCase) {
      failures.push(`${context}: visible copy contains mechanical case fragment "${mechanicalCase}"`);
    }
    if (/\bIn Vietnam,[^.\n]*\bin Vietnam\b/i.test(visibleText)) {
      failures.push(`${context}: visible copy repeats "in Vietnam" in the same sentence`);
    }
    if (!localContextMarkers.some((marker) => String(item.worthKnowing ?? "").toLowerCase().includes(marker.toLowerCase()))) {
      failures.push(`${context}: worthKnowing needs Vietnam-specific culture, origin, region, or local-use context`);
    }
    const vagueSauce = vagueSauceFragments.find((fragment) =>
      visibleText.toLowerCase().includes(fragment.toLowerCase())
    );
    if (vagueSauce) {
      failures.push(`${context}: sauce copy must name or explain the sauce instead of "${vagueSauce}"`);
    }

    const ricePaperRequiredTerms = ricePaperGuidanceRequirements[item.itemID] ?? [];
    if (ricePaperRequiredTerms.length > 0) {
      const ricePaperGuidanceText = [
        item.whatItIs,
        item.howToEnjoy,
        item.howLocalsOrder,
        item.usuallyIncludes.join(" "),
        item.commonOptions.join(" "),
      ].join("\n").toLowerCase();
      for (const term of ricePaperRequiredTerms) {
        if (!ricePaperGuidanceText.includes(term.toLowerCase())) {
          failures.push(`${context}: rice-paper/local eating guidance is missing "${term}"`);
        }
      }
    }

    const originRequiredTerms = originConnectionRequirements[item.itemID] ?? [];
    if (originRequiredTerms.length > 0) {
      const originConnectionText = [
        item.atAGlance,
        item.whatItIs,
        item.howToEnjoy,
        item.howLocalsOrder,
        item.worthKnowing,
        item.goodToKnow,
        item.regionalAssociation,
        item.originPosture,
      ].join("\n").toLowerCase();
      for (const term of originRequiredTerms) {
        if (!originConnectionText.includes(term.toLowerCase())) {
          failures.push(`${context}: origin/Vietnam story guidance is missing "${term}"`);
        }
      }
    }

    const itemBlocked = itemSpecificBlockedFragments[item.itemID] ?? [];
    for (const fragment of itemBlocked) {
      if (visibleText.toLowerCase().includes(fragment.toLowerCase())) {
        failures.push(`${context}: item-specific semantic guard blocks "${fragment}"`);
      }
    }
    for (const helperID of item.helperPhraseIDs ?? []) {
      const requiredMarkers = helperContextMarkers[helperID] ?? [];
      if (
        requiredMarkers.length > 0 &&
        !requiredMarkers.some((marker) => visibleText.toLowerCase().includes(marker.toLowerCase()))
      ) {
        failures.push(`${context}: helper ${helperID} lacks visible copy context`);
      }
    }

    if (item.menuType === "Drink" && /spicy|pork|beef|chicken|seafood/i.test(item.travelerCaution ?? "")) {
      failures.push(`${context}: drink caution looks like food copy`);
    }
    if (
      item.menuType === "Drink" &&
      !drinkSensoryMarkers.some((marker) => visibleText.toLowerCase().includes(marker.toLowerCase()))
    ) {
      failures.push(`${context}: drink copy needs flavor, body, texture, or experience descriptors`);
    }
    if (item.category === "Vegetarian" && /pork|beef|chicken|duck|fish|shrimp|crab|seafood/i.test(item.usuallyIncludes.join(" "))) {
      failures.push(`${context}: vegetarian usuallyIncludes mention meat or seafood`);
    }
  }

  const helperByID = new Map(source.helperPhrases.map((helper) => [helper.id, helper]));
  for (const helper of source.helperPhrases) {
    if (helper.audioStatus === "ready" && !hasPlayableExactAudio(manifest, helper.vietnamese, helper.audioKey)) {
      failures.push(`${helper.id}: ready helper phrase lacks playable exact audio`);
    }
  }

  for (const item of payload.items) {
    for (const helperID of item.helperPhraseIDs) {
      const helper = helperByID.get(helperID);
      if (!helper) {
        failures.push(`${item.itemID}: unknown helper ${helperID}`);
      } else if (helper.audioStatus !== "ready") {
        failures.push(`${item.itemID}: rendered helper ${helperID} is not audio-ready`);
      } else if (!hasPlayableExactAudio(manifest, helper.vietnamese, helper.audioKey)) {
        failures.push(`${item.itemID}: rendered helper ${helperID} lacks playable exact audio`);
      }
    }
  }

  if (failures.length > 0) {
    console.error(`Vietnamese menu copy validation failed with ${failures.length} issue(s):`);
    for (const failure of failures.slice(0, 120)) {
      console.error(`- ${failure}`);
    }
    if (failures.length > 120) {
      console.error(`... ${failures.length - 120} more`);
    }
    process.exit(1);
  }

  console.log(`Validated ${payload.items.length} handwritten Vietnamese menu item pages`);
  console.log(`Ready helper phrases: ${source.helperPhrases.filter((helper) => helper.audioStatus === "ready").length}`);
}

function hasPlayableExactAudio(manifest, text, preferredKey = null) {
  if (preferredKey) {
    const entry = manifest[preferredKey];
    if (entry && normalized(entry.text) === normalized(text) && audioFileIsReady(entry.fileName)) {
      return true;
    }
  }

  return Object.values(manifest).some((entry) =>
    normalized(entry?.text) === normalized(text) && audioFileIsReady(entry?.fileName)
  );
}

function audioFileIsReady(fileName) {
  return Boolean(fileName)
    && fs.existsSync(path.join(audioDir, fileName))
    && fs.statSync(path.join(audioDir, fileName)).size > 1024;
}

function normalized(text) {
  return String(text ?? "")
    .normalize("NFC")
    .trim()
    .toLowerCase()
    .replace(/[.!?]+$/g, "");
}

function escapeRegExp(text) {
  return String(text).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}
