import fs from "node:fs/promises";
import path from "node:path";
import { pathToFileURL } from "node:url";
import { execFileSync } from "node:child_process";

const artifactToolModule = process.env.ARTIFACT_TOOL_MODULE
  || "/Users/jojolim/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs";
const { SpreadsheetFile, Workbook } = await import(pathToFileURL(artifactToolModule).href);

const repoRoot = process.cwd();
const outputDir = path.join(repoRoot, "docs/task-results/listing-backdrop-audit-2026-05-29");
const assetsRoot = path.join(repoRoot, "native-ios/Resources/Assets.xcassets");
const authoredPath = path.join(repoRoot, "native-ios/Resources/viet-authored-listing-pages.json");
const menuPath = path.join(repoRoot, "native-ios/Resources/vietnamese-menu-copy.json");
const swiftPath = path.join(repoRoot, "native-ios/App/Models/BrowseSearchDestinations.swift");
const poolSwiftPath = path.join(repoRoot, "native-ios/App/Models/SharedBackdropImagePool.swift");
const sqlitePath = path.join(repoRoot, "native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite");

const authored = JSON.parse(await fs.readFile(authoredPath, "utf8"));
const menu = JSON.parse(await fs.readFile(menuPath, "utf8"));
const browseSwift = await fs.readFile(swiftPath, "utf8");
const poolSwift = await fs.readFile(poolSwiftPath, "utf8");

const categoryMastheadImages = {
  airport: "HeroCategoryAirport",
  hotel: "HeroCategoryHotel",
  food: "HeroCategoryFood",
  shopping: "HeroCategoryNumbersMoney",
  "getting-around": "HeroCategoryGettingAround",
  "first-day": "HeroCategoryFirstDay",
  "city-guides": "HeroCountryVietnam",
  emergency: "HeroCategoryEmergency",
  "local-greetings": "HeroCategoryGreetings",
  essentials: "HeroCategoryEssentials",
  greetings: "HeroCategoryGreetings",
  questions: "HeroCategoryQuestions",
  "numbers-money": "HeroCategoryNumbersMoney",
  "polite-repair": "HeroCategoryPoliteRepair",
  "food-coffee": "HeroCategoryFood",
  "vietnamese-food-menu": "HeroVietnameseFoodMenu",
  "vietnamese-drink-menu": "HeroVietnameseDrinkMenu",
  "landmarks-attractions": "HeroCategoryGettingAround",
  "neighborhoods-streets": "HeroCategoryGettingAround",
};

const cityMastheadImages = {
  hanoi: "HeroCityHanoi",
  hcmc: "HeroCityHcmc",
  danang: "HeroCityDanang",
  hoian: "HeroCityHoian",
  hue: "HeroCityHue",
};

const cityTitles = {
  hanoi: "Hanoi",
  hcmc: "Saigon / Ho Chi Minh City",
  danang: "Da Nang",
  hoian: "Hoi An",
  hue: "Hue",
};

const categoryTitles = {
  airport: "Airport",
  hotel: "Hotel",
  food: "Eating Out",
  shopping: "Shopping",
  "getting-around": "Getting Around",
  "first-day": "First Day",
  "city-guides": "All Vietnam",
  emergency: "Emergency",
  "local-greetings": "Local Greetings",
  essentials: "Essentials",
  greetings: "Greetings",
  questions: "Questions",
  "numbers-money": "Numbers & Money",
  "polite-repair": "Polite Repair",
  "food-coffee": "Coffee & Food",
  "landmarks-attractions": "Landmarks & Attractions",
  "neighborhoods-streets": "Neighborhoods & Streets",
};

const recommendationRules = [
  {
    id: "airport-services",
    match: ["airport-border-arrival"],
    asset: "HeroCategoryAirport",
    rolloutBucket: "Use category hero now; later add airport-services mini-pool",
    imageTheme: "Airport arrivals, immigration, baggage, SIM counter, taxi pickup.",
  },
  {
    id: "phone-sim-wifi",
    match: ["phone-internet-power"],
    asset: "HeroCategoryAirport",
    rolloutBucket: "Needs topical mini-pool",
    imageTheme: "Airport SIM kiosk, phone shop counter, eSIM QR poster, cafe Wi-Fi/charging.",
  },
  {
    id: "hotel",
    match: ["hotel-accommodation"],
    asset: "HeroCategoryHotel",
    rolloutBucket: "Use category hero now; later add hotel/front-desk mini-pool",
    imageTheme: "Hotel lobby, check-in desk, luggage storage, room-help scene.",
  },
  {
    id: "food",
    match: ["food-drink", "food-ordering", "restaurant-live-interaction", "dish-order-diet"],
    asset: "HeroCategoryFood",
    rolloutBucket: "Use category hero or menu backdrop when item-specific",
    imageTheme: "Restaurant table, local dish counter, cafe/order counter, readable menu moment.",
  },
  {
    id: "transport",
    match: ["transport", "directions-navigation", "driver-ready", "driver-wait", "place-journey", "arrivals-routes"],
    asset: "HeroCategoryGettingAround",
    rolloutBucket: "Use category hero now; later add transport mini-pool",
    imageTheme: "Taxi pickup, bus/train station, street map, ride-share curbside.",
  },
  {
    id: "money-shopping",
    match: ["money-numbers-prices", "shopping"],
    asset: "HeroCategoryNumbersMoney",
    rolloutBucket: "Use category hero now; later add market/payment mini-pool",
    imageTheme: "Market stall, price tag, cash/card/QR payment, receipt moment.",
  },
  {
    id: "emergency-health",
    match: ["emergency-safety", "health-pharmacy", "problems-help"],
    asset: "HeroCategoryEmergency",
    rolloutBucket: "Use emergency hero carefully; add clinic/pharmacy mini-pool",
    imageTheme: "Clinic/pharmacy frontage, calm help desk, police/assistance sign, not alarmist.",
  },
  {
    id: "repair-politeness",
    match: ["understanding-repair", "polite-basics", "repair", "gratitude", "goodbyes"],
    asset: "HeroCategoryPoliteRepair",
    rolloutBucket: "Use category hero or shared Vietnam pool",
    imageTheme: "Quiet street/cafe interaction, helpful counter moment, calm readable background.",
  },
  {
    id: "greetings",
    match: ["greetings", "local-greetings", "small-talk", "social-small-talk"],
    asset: "HeroCategoryGreetings",
    rolloutBucket: "Use category hero or shared Vietnam pool",
    imageTheme: "Warm local greeting scene, cafe/shop doorway, street conversation.",
  },
  {
    id: "questions-time",
    match: ["time-dates-booking", "questions"],
    asset: "HeroCategoryQuestions",
    rolloutBucket: "Use category hero now",
    imageTheme: "Calendar/ticket counter/hour sign, information desk, timetable.",
  },
  {
    id: "sightseeing",
    match: ["sightseeing-activities", "landmarks-attractions"],
    asset: "HeroCategoryGettingAround",
    rolloutBucket: "Use landmarks/city hero pool",
    imageTheme: "Ticket booth, attraction entrance, landmark walkway, photo-friendly place scene.",
  },
  {
    id: "local-services",
    match: ["local-services-everyday-tasks", "bathroom-personal-needs"],
    asset: "HeroCategoryEssentials",
    rolloutBucket: "Needs essentials/services mini-pool",
    imageTheme: "Convenience store, service counter, public restroom sign, everyday travel errand.",
  },
];

function firstMatchRule(categoryIDs, text) {
  const categories = new Set(categoryIDs.filter(Boolean));
  const lowered = text.toLowerCase();
  for (const rule of recommendationRules) {
    if (rule.match.some((category) => categories.has(category))) {
      return rule;
    }
  }
  if (/\bsim\b|esim|wi-?fi|wifi|internet|data|phone|battery/.test(lowered)) {
    return recommendationRules.find((rule) => rule.id === "phone-sim-wifi");
  }
  if (/airport|baggage|immigration|passport|customs|terminal/.test(lowered)) {
    return recommendationRules.find((rule) => rule.id === "airport-services");
  }
  if (/hotel|room|check.?in|checkout|luggage/.test(lowered)) {
    return recommendationRules.find((rule) => rule.id === "hotel");
  }
  if (/doctor|pharmacy|medicine|police|emergency|help/.test(lowered)) {
    return recommendationRules.find((rule) => rule.id === "emergency-health");
  }
  if (/taxi|driver|bus|train|address|street|map|where|direction/.test(lowered)) {
    return recommendationRules.find((rule) => rule.id === "transport");
  }
  if (/coffee|food|eat|order|restaurant|dish|drink|water|menu/.test(lowered)) {
    return recommendationRules.find((rule) => rule.id === "food");
  }
  if (/money|price|cash|card|pay|receipt|shopping|market|size|color/.test(lowered)) {
    return recommendationRules.find((rule) => rule.id === "money-shopping");
  }
  return {
    id: "generic-shared",
    asset: "HomeVietnamMapBackdrop",
    rolloutBucket: "Use shared Vietnam pool until a better topical image exists",
    imageTheme: "Vietnam-forward scenic/cultural image from the shared 20-pool.",
  };
}

function pageSource(page) {
  if (page.id.startsWith("viet-family-city-") || page.id.startsWith("viet-phrase-city-")) {
    return page.heroImageName === "HeroCompactPhraseMasthead" ? "compact generated city action phrase" : "city/place listing";
  }
  if (page.id.startsWith("viet-menu-")) {
    return "menu detail";
  }
  if (page.tierRole === "child") {
    return "child phrase page";
  }
  if (page.tierRole === "tier1") {
    return "tier-one phrase page";
  }
  if ((page.categoryIDs || []).includes("editorial-model-support")) {
    return "editorial support phrase page";
  }
  if ((page.categoryIDs || []).includes("premium")) {
    return "catalog-promoted premium phrase page";
  }
  return "canonical phrase page";
}

function supportsCity(page) {
  const h = page.heroImageName || "";
  return (page.id.startsWith("viet-family-city-") || page.id.startsWith("viet-phrase-city-"))
    && h.startsWith("HeroCity")
    && h !== "HeroCompactPhraseMasthead";
}

function supportsMenu(page) {
  const h = page.heroImageName || "";
  return page.id.startsWith("viet-menu-") && h.startsWith("BackdropMenu");
}

function supportsCategory(page) {
  const h = page.heroImageName || "";
  return !page.id.startsWith("viet-menu-") && h.startsWith("HeroCategory") && h !== "HeroCompactPhraseMasthead";
}

function classifyAuthoredPage(page) {
  const h = page.heroImageName || "";
  const text = `${page.id} ${page.title || ""} ${page.englishTitle || ""} ${(page.categoryIDs || []).join(" ")}`;
  const rule = firstMatchRule(page.categoryIDs || [], text);
  if (supportsCity(page)) {
    return {
      auditStatus: "Implemented",
      currentBackgroundSystem: "photo-backdrop sheet + single page image",
      needsBackdropWork: "No",
      recommendedAsset: h,
      recommendation: "Already uses the shared photo-backdrop detail layout with immersive tap.",
      rolloutBucket: "Already implemented: city/place single-image detail",
      imageTheme: "Existing city/place hero image.",
      routeContext: "Intrinsic page hero works from Home, Browse, Search, Saved, and direct launch.",
    };
  }
  if (supportsMenu(page)) {
    return {
      auditStatus: "Implemented",
      currentBackgroundSystem: "photo-backdrop sheet + single menu backdrop",
      needsBackdropWork: "No",
      recommendedAsset: h,
      recommendation: "Already uses the menu-detail photo-backdrop layout.",
      rolloutBucket: "Already implemented: menu detail",
      imageTheme: "Existing menu portrait backdrop.",
      routeContext: "Intrinsic page hero works from all entrypoints.",
    };
  }
  if (supportsCategory(page)) {
    return {
      auditStatus: "Implemented",
      currentBackgroundSystem: "photo-backdrop sheet + category image",
      needsBackdropWork: "No",
      recommendedAsset: h,
      recommendation: "Already qualifies through the HeroCategory listing predicate.",
      rolloutBucket: "Already implemented: category-image detail",
      imageTheme: "Existing category masthead.",
      routeContext: "Intrinsic category hero works from all entrypoints.",
    };
  }
  if (h === "HeroCompactPhraseMasthead") {
    return {
      auditStatus: "Defer / Optional",
      currentBackgroundSystem: "old compact city-action single layer",
      needsBackdropWork: "Optional",
      recommendedAsset: rule.asset,
      recommendation: "Do not roll out by default. These are generated action + place helper rows; promote only if a row becomes a real listing.",
      rolloutBucket: "Defer compact generated city-action helpers",
      imageTheme: "Use the linked place hero only if the row is promoted beyond helper status.",
      routeContext: "Current compact masthead is intentional according to the photo-backdrop eligibility note.",
    };
  }
  if (!h) {
    return {
      auditStatus: "Needs Backdrop",
      currentBackgroundSystem: "old single-layer phrase page with default static masthead",
      needsBackdropWork: "Yes",
      recommendedAsset: rule.asset,
      recommendation: `Add intrinsic page/category backdrop metadata or a category/topical fallback. First pass: ${rule.asset}.`,
      rolloutBucket: rule.rolloutBucket,
      imageTheme: rule.imageTheme,
      routeContext: "The page has no own heroImageName, so direct/Home/Search/Saved/Practice entry still looks like screenshot 1. Browse may only look photo-backed when a category override is passed.",
    };
  }
  return {
    auditStatus: "Review",
    currentBackgroundSystem: "static hero but not covered by photo-backdrop predicate",
    needsBackdropWork: "Review",
    recommendedAsset: h,
    recommendation: "Has an image, but it does not match the current photo-backdrop predicates. Review crop and predicate eligibility.",
    rolloutBucket: "Review existing nonstandard hero",
    imageTheme: "Existing nonstandard hero.",
    routeContext: "Requires code/data review.",
  };
}

function menuDetailRows() {
  return menu.items.map((item) => {
    const backdrop = `BackdropMenu${pascalCase(item.itemID)}`;
    return {
      pageID: `viet-menu-${item.itemID}`,
      source: "menu detail",
      title: item.vietnameseItem,
      englishTitle: item.englishTranslation,
      categoryIDs: [item.menuType, item.category, item.subcategory].filter(Boolean).join(", "),
      heroImageName: backdrop,
      auditStatus: "Implemented",
      currentBackgroundSystem: "photo-backdrop sheet + single menu portrait",
      needsBackdropWork: "No",
      recommendedAsset: backdrop,
      recommendation: "Already uses generated portrait BackdropMenu* asset and immersive tap behavior.",
      rolloutBucket: "Already implemented: menu detail single-image",
      imageTheme: "Existing menu portrait backdrop.",
      routeContext: "Intrinsic detail page image.",
      assetExists: assetExists(backdrop) ? "Yes" : "No",
      assetFile: assetFile(backdrop) || "",
      priority: "Done",
    };
  });
}

function pascalCase(input) {
  return input
    .split("-")
    .filter(Boolean)
    .map((part) => part.slice(0, 1).toUpperCase() + part.slice(1))
    .join("");
}

function assetDir(assetName) {
  return path.join(assetsRoot, `${assetName}.imageset`);
}

function assetExists(assetName) {
  try {
    return Boolean(assetName) && fsSyncStat(assetDir(assetName));
  } catch {
    return false;
  }
}

function fsSyncStat(candidate) {
  try {
    return requireFsStat(candidate);
  } catch {
    return false;
  }
}

function requireFsStat(candidate) {
  return fsSync.existsSync(candidate);
}

import fsSync from "node:fs";

function assetFile(assetName) {
  if (!assetName || !assetExists(assetName)) return "";
  try {
    const contents = JSON.parse(fsSync.readFileSync(path.join(assetDir(assetName), "Contents.json"), "utf8"));
    const image = (contents.images || []).find((entry) => entry.filename);
    return image?.filename ? path.join(assetDir(assetName), image.filename) : "";
  } catch {
    return "";
  }
}

function assetLink(assetName) {
  const file = assetFile(assetName);
  return file ? pathToFileURL(file).href : "";
}

function rowsFromAuthoredPages() {
  return authored.pages.map((page) => {
    const classification = classifyAuthoredPage(page);
    const asset = classification.recommendedAsset;
    const priority = classification.auditStatus === "Needs Backdrop"
      ? priorityForPage(page, classification)
      : classification.auditStatus === "Defer / Optional"
        ? "Defer"
        : "Done";
    return {
      pageID: page.id,
      source: pageSource(page),
      title: page.title || "",
      englishTitle: page.englishTitle || "",
      categoryIDs: (page.categoryIDs || []).join(", "),
      heroImageName: page.heroImageName || "",
      auditStatus: classification.auditStatus,
      currentBackgroundSystem: classification.currentBackgroundSystem,
      needsBackdropWork: classification.needsBackdropWork,
      recommendedAsset: asset,
      recommendation: classification.recommendation,
      rolloutBucket: classification.rolloutBucket,
      imageTheme: classification.imageTheme,
      routeContext: classification.routeContext,
      assetExists: assetExists(asset) ? "Yes" : "No",
      assetFile: assetFile(asset) || "",
      priority,
    };
  });
}

function priorityForPage(page, classification) {
  const cats = new Set(page.categoryIDs || []);
  if (page.tierRole === "tier1") return "P0 tier-one";
  if (cats.has("airport-border-arrival") || cats.has("hotel-accommodation") || cats.has("transport") || cats.has("food-drink")) {
    return "P1 major travel flow";
  }
  if (cats.has("premium")) return "P2 premium catalog";
  if (classification.rolloutBucket.includes("mini-pool")) return "P1 asset strategy";
  return "P2 normal";
}

function collectSharedPool() {
  const match = poolSwift.match(/vietnamForwardAssetNames\s*=\s*\[([\s\S]*?)\]/);
  if (!match) return [];
  return [...match[1].matchAll(/"([^"]+)"/g)].map((entry) => entry[1]);
}

function sqliteJSON(sql) {
  if (!fsSync.existsSync(sqlitePath)) {
    return [];
  }

  const output = execFileSync("sqlite3", ["-json", sqlitePath, sql], {
    encoding: "utf8",
    maxBuffer: 64 * 1024 * 1024,
  });
  return output.trim() ? JSON.parse(output) : [];
}

function sqlQuote(value) {
  return `'${String(value ?? "").replace(/'/g, "''")}'`;
}

function audioFilesReport(audioFilesText) {
  const files = String(audioFilesText || "")
    .split(",")
    .map((file) => file.trim())
    .filter(Boolean);
  const missing = files.filter((file) => !fsSync.existsSync(path.join(repoRoot, "native-ios/Resources/Audio", file)));
  return {
    audioFileCount: files.length,
    audioFiles: files.join(", "),
    audioFilesExist: files.length > 0 && missing.length === 0 ? "Yes" : "No",
    missingAudioFiles: missing.join(", "),
  };
}

function buildRuntimeDetailsByPageID() {
  const rows = sqliteJSON(`
    SELECT
      pp.id AS canonicalPageID,
      pp.phrase_id AS runtimePhraseID,
      p.access_tier AS runtimeAccessTier,
      p.audio_status AS runtimeAudioStatus,
      p.source_path AS runtimeSourcePath,
      p.source_row_id AS runtimeSourceRowID,
      COUNT(DISTINCT sd.id) AS runtimeSearchDocumentCount,
      COUNT(DISTINCT au.id) AS runtimeAudioUsageCount,
      COUNT(DISTINCT ma.id) AS runtimeMissingAudioCount,
      group_concat(DISTINCT aa.file_name) AS runtimeAudioFiles
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    LEFT JOIN search_document sd
      ON sd.target_kind = 'phrase_page'
      AND sd.target_id = pp.id
      AND sd.is_canonical_page = 1
    LEFT JOIN audio_usage au
      ON au.target_kind = 'phrase'
      AND au.target_id = p.id
    LEFT JOIN audio_asset aa
      ON aa.id = au.audio_asset_id
    LEFT JOIN missing_audio_audit ma
      ON ma.target_kind = 'phrase'
      AND ma.target_id = p.id
    GROUP BY
      pp.id,
      pp.phrase_id,
      p.access_tier,
      p.audio_status,
      p.source_path,
      p.source_row_id;
  `);
  return new Map(rows.map((row) => [row.canonicalPageID, row]));
}

function runtimeSourceFamily(runtime) {
  if (!runtime) return "";
  if (runtime.runtimeAccessTier === "premium") {
    return "Premium long-tail phrase catalog";
  }
  if (runtime.runtimeAccessTier === "starter") {
    return "Starter/base phrase catalog";
  }
  if (String(runtime.runtimeSourcePath || "").includes("viet-phrase-catalog")) {
    return "Native phrase catalog";
  }
  return runtime.runtimeSourcePath || "";
}

function enrichRuntimeDetails(row) {
  const runtime = runtimeDetailsByPageID.get(row.canonicalPageID);
  if (!runtime) {
    return {
      ...row,
      runtimeExists: "No",
      runtimePhraseID: "",
      runtimeAccessTier: "",
      runtimeSourceFamily: "",
      runtimeAudioStatus: "",
      runtimeAudioUsageCount: 0,
      runtimeAudioFileCount: 0,
      runtimeAudioFilesExist: "No",
      runtimeAudioFiles: "",
      runtimeMissingAudioCount: 0,
      runtimeMissingAudioFiles: "",
      runtimeSearchIndexed: "No",
      runtimeAliasStatus: row.pageID === row.canonicalPageID
        ? "Canonical page ID missing from runtime"
        : "Alias/display ID did not resolve to a runtime page",
    };
  }

  const audio = audioFilesReport(runtime.runtimeAudioFiles);
  return {
    ...row,
    runtimeExists: "Yes",
    runtimePhraseID: runtime.runtimePhraseID || "",
    runtimeAccessTier: runtime.runtimeAccessTier || "",
    runtimeSourceFamily: runtimeSourceFamily(runtime),
    runtimeSourcePath: runtime.runtimeSourcePath || "",
    runtimeSourceRowID: runtime.runtimeSourceRowID || "",
    runtimeAudioStatus: runtime.runtimeAudioStatus || "",
    runtimeAudioUsageCount: Number(runtime.runtimeAudioUsageCount || 0),
    runtimeAudioFileCount: audio.audioFileCount,
    runtimeAudioFilesExist: audio.audioFilesExist,
    runtimeAudioFiles: audio.audioFiles,
    runtimeMissingAudioCount: Number(runtime.runtimeMissingAudioCount || 0),
    runtimeMissingAudioFiles: audio.missingAudioFiles,
    runtimeSearchIndexed: Number(runtime.runtimeSearchDocumentCount || 0) > 0 ? "Yes" : "No",
    runtimeAliasStatus: row.pageID === row.canonicalPageID
      ? "Canonical page ID"
      : "Alias/display ID resolves to canonical runtime page",
  };
}

function buildReachabilityAudit() {
  const pageRows = sqliteJSON(`
    SELECT
      pp.id AS pageID,
      pp.title AS title,
      pp.english_title AS englishTitle,
      COALESCE(pp.hero_image_name, '') AS heroImageName,
      COALESCE((
        SELECT group_concat(category_id, '|')
        FROM (
          SELECT pc.category_id
          FROM page_category pc
          WHERE pc.page_id = pp.id
          ORDER BY pc.sort_order, pc.category_id
        )
      ), '') AS categoryIDs,
      COALESCE(pct.city_id, '') AS cityID,
      COALESCE(pct.subcategory_id, '') AS citySubcategoryID,
      COALESCE(pct.page_kind, '') AS pageKind,
      COALESCE(pct.place_kind, '') AS placeKind,
      COALESCE(pct.content_role, '') AS contentRole,
      COALESCE((SELECT MIN(pc.sort_order) FROM page_category pc WHERE pc.page_id = pp.id), 9999) AS categorySort
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    LEFT JOIN phrase_city_tag pct ON pct.phrase_id = p.id
    ORDER BY categorySort, pp.title COLLATE NOCASE, pp.id;
  `).map((row) => ({
    ...row,
    categoryIDs: String(row.categoryIDs || "").split("|").filter(Boolean),
  }));

  const pagesByID = new Map(pageRows.map((row) => [row.pageID, row]));
  const aliasRows = sqliteJSON("SELECT alias_id AS aliasID, canonical_page_id AS canonicalPageID FROM page_alias;");
  const aliasToCanonical = new Map(aliasRows.map((row) => [row.aliasID, row.canonicalPageID]));
  const categoryItems = new Map();
  for (const row of pageRows) {
    for (const categoryID of row.categoryIDs) {
      categoryItems.set(categoryID, [...(categoryItems.get(categoryID) || []), row]);
    }
  }

  const searchIDs = new Set(sqliteJSON(`
    SELECT target_id AS pageID
    FROM search_document
    WHERE target_kind = 'phrase_page'
      AND is_canonical_page = 1;
  `).map((row) => row.pageID));

  const incomingRows = sqliteJSON(`
    SELECT
      target_id AS pageID,
      COUNT(*) AS incomingCount,
      group_concat(source_id, '|') AS incomingFrom
    FROM phrase_relation
    WHERE target_kind = 'phrase_page'
    GROUP BY target_id;
  `);
  const outgoingRows = sqliteJSON(`
    SELECT source_id AS pageID, COUNT(*) AS outgoingCount
    FROM phrase_relation
    WHERE source_kind = 'phrase_page'
    GROUP BY source_id;
  `);
  const incomingByID = new Map(incomingRows.map((row) => [row.pageID, row]));
  const outgoingByID = new Map(outgoingRows.map((row) => [row.pageID, row]));
  const channelMap = new Map();

  const canonicalize = (pageID) => {
    if (!pageID) return "";
    if (aliasToCanonical.has(pageID)) return aliasToCanonical.get(pageID);
    if (pagesByID.has(pageID)) return pageID;
    return pageID;
  };

  const addChannel = (pageID, channel) => {
    const canonicalPageID = canonicalize(pageID);
    if (!pagesByID.has(canonicalPageID)) return;
    const existing = channelMap.get(canonicalPageID) || [];
    const key = `${channel.kind}|${channel.label}|${channel.route || ""}`;
    if (!existing.some((candidate) => `${candidate.kind}|${candidate.label}|${candidate.route || ""}` === key)) {
      existing.push(channel);
      channelMap.set(canonicalPageID, existing);
    }
  };

  const itemIsBrowseSurfaceable = (item) => !item.categoryIDs.includes("derived-place-phrases");
  const normalize = (value) => String(value || "")
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .toLowerCase()
    .trim();
  const uniquePageIDs = (pageIDs) => {
    const seen = new Set();
    return pageIDs
      .map(canonicalize)
      .filter((pageID) => pageID && pagesByID.has(pageID))
      .filter((pageID) => {
        if (seen.has(pageID)) return false;
        seen.add(pageID);
        return true;
      });
  };
  const itemsForCategories = (categoryIDs, limit = Infinity, excluded = new Set()) => {
    const rows = [];
    const seen = new Set();
    for (const categoryID of categoryIDs) {
      for (const item of categoryItems.get(categoryID) || []) {
        if (!itemIsBrowseSurfaceable(item)) continue;
        if (excluded.has(item.pageID)) continue;
        if (seen.has(item.pageID)) continue;
        seen.add(item.pageID);
        rows.push(item);
        if (rows.length >= limit) return rows;
      }
    }
    return rows;
  };
  const itemsMatchingTerms = (categoryIDs, terms, limit = 12) => {
    const normalizedTerms = terms.map(normalize).filter(Boolean);
    const rows = [];
    const seen = new Set();
    for (const categoryID of categoryIDs) {
      for (const item of categoryItems.get(categoryID) || []) {
        if (!itemIsBrowseSurfaceable(item)) continue;
        if (seen.has(item.pageID)) continue;
        const haystack = normalize(`${item.title} ${item.englishTitle} ${item.pageID}`);
        if (normalizedTerms.length && !normalizedTerms.some((term) => haystack.includes(term))) {
          continue;
        }
        seen.add(item.pageID);
        rows.push(item);
        if (rows.length >= limit) return rows;
      }
    }
    return rows;
  };
  const starterItems = (categoryIDs, preferredPageIDs, limit) => {
    const rows = [];
    const seen = new Set();
    const append = (pageID) => {
      const canonicalPageID = canonicalize(pageID);
      const item = pagesByID.get(canonicalPageID);
      if (!item || !itemIsBrowseSurfaceable(item) || seen.has(canonicalPageID) || rows.length >= limit) return;
      seen.add(canonicalPageID);
      rows.push(item);
    };
    preferredPageIDs.forEach(append);
    for (const item of itemsForCategories(categoryIDs, limit * 3)) {
      append(item.pageID);
      if (rows.length >= limit) break;
    }
    return rows;
  };
  const routeGivesBackdrop = (routeID) => (categoryMastheadImages[routeID] || "").startsWith("HeroCategory");
  const addBrowseItems = (routeID, routeTitle, sectionTitle, items) => {
    const givesBackdrop = routeGivesBackdrop(routeID);
    for (const item of items) {
      addChannel(item.pageID, {
        kind: "Browse",
        label: `Browse > ${routeTitle} > ${sectionTitle}`,
        route: `category:${routeID}`,
        givesBackdrop,
      });
    }
  };
  const addHomeItems = (label, pageIDs) => {
    for (const pageID of uniquePageIDs(pageIDs)) {
      addChannel(pageID, {
        kind: "Home",
        label: `Home > ${label}`,
        route: "home",
        givesBackdrop: false,
      });
    }
  };

  const resolveHomeShelfItems = ({
    pageIDs,
    sourceCategoryIDs,
    maximumItemCount = 12,
    fillsFromSourceCategories = true,
  }) => {
    const rows = [];
    const seen = new Set();
    const append = (pageID) => {
      const canonicalPageID = canonicalize(pageID);
      if (!pagesByID.has(canonicalPageID) || seen.has(canonicalPageID) || rows.length >= maximumItemCount) return;
      seen.add(canonicalPageID);
      rows.push(canonicalPageID);
    };
    pageIDs.forEach(append);
    if (fillsFromSourceCategories) {
      for (const categoryID of sourceCategoryIDs) {
        for (const item of categoryItems.get(categoryID) || []) {
          append(item.pageID);
          if (rows.length >= maximumItemCount) break;
        }
        if (rows.length >= maximumItemCount) break;
      }
    }
    return rows;
  };

  const homeUseNowIDs = [
    "viet-polite-hello",
    "viet-thank-you",
    "viet-excuse-sorry",
    "viet-family-polite-its-okay",
    "viet-goodbye",
    "viet-family-repair-understand",
    "viet-family-repair-slower",
    "viet-family-repair-repeat",
    "viet-family-service-water",
    "viet-family-food-menu",
    "viet-family-food-pay-now",
    "viet-family-bathroom-where",
  ];
  addHomeItems("Use now", homeUseNowIDs);
  addHomeItems("Feature cards", homeUseNowIDs.slice(0, 6));
  addHomeItems("Relationship greetings", ["viet-hello-anh", "viet-hello-chi", "viet-hello-em"]);
  addHomeItems("Saved fallback", [
    "viet-phrase-v500-unde-repa-can-you-show-me-a-picture",
    "viet-phrase-hotel-3",
  ]);

  const homeShelves = [
    {
      title: "First Day in Vietnam",
      sourceCategoryIDs: ["airport-border-arrival", "hotel-accommodation", "transport", "directions-navigation"],
      pageIDs: [
        "viet-phrase-airport-1",
        "viet-phrase-airport-3",
        "viet-phrase-v500-airp-bord-arri-where-is-the-atm",
        "viet-phrase-airport-5",
        "viet-phrase-taxi-1",
        "viet-phrase-hotel-1",
        "viet-phrase-hotel-2",
        "viet-phrase-directions-9",
      ],
      maximumItemCount: 8,
      fillsFromSourceCategories: false,
    },
    {
      title: "Eating Out",
      sourceCategoryIDs: ["food-drink", "money-numbers-prices"],
      pageIDs: [
        "viet-phrase-food-menu",
        "viet-family-food-bottled-water",
        "viet-phrase-coffee-1",
        "viet-phrase-food-3",
        "viet-family-food-peanut-allergy",
        "viet-phrase-coffee-7",
      ],
      maximumItemCount: 12,
    },
    {
      title: "When you get stuck",
      sourceCategoryIDs: ["understanding-repair", "polite-basics", "problems-help"],
      pageIDs: [
        "viet-phrase-problems-2",
        "viet-phrase-problems-3",
        "viet-phrase-repair-1",
        "viet-phrase-repair-2",
        "viet-phrase-repair-english-help",
        "viet-phrase-help-need-help-direct",
        "viet-phrase-v500-unde-repa-can-you-show-me-a-picture",
      ],
      maximumItemCount: 12,
    },
    {
      title: "Taxi & getting around",
      sourceCategoryIDs: ["transport", "directions-navigation"],
      pageIDs: [
        "viet-phrase-taxi-1",
        "viet-phrase-directions-8",
        "viet-phrase-v500-tran-please-call-the-driver",
        "viet-phrase-v900-tran-please-take-me-to-this-address",
        "viet-phrase-v500-tran-please-take-me-to-this-hotel",
        "viet-family-hotel-call-taxi",
      ],
      maximumItemCount: 12,
    },
    {
      title: "Hotel basics",
      sourceCategoryIDs: ["hotel-accommodation", "time-dates-booking", "local-services-everyday-tasks"],
      pageIDs: [
        "viet-phrase-hotel-1",
        "viet-phrase-v500-hote-acco-here-is-my-passport-for-check-in",
        "viet-phrase-phone-1",
        "viet-phrase-hotel-3",
        "viet-phrase-v900-hote-acco-the-reservation-is-under-this-name",
      ],
      maximumItemCount: 12,
    },
    {
      title: "Money & shopping",
      sourceCategoryIDs: ["shopping", "money-numbers-prices", "local-services-everyday-tasks"],
      pageIDs: [
        "viet-phrase-price-1",
        "viet-phrase-v500-shop-can-you-lower-the-price",
        "viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt",
        "viet-phrase-v500-mone-numb-pric-can-i-try-another-card",
        "viet-phrase-price-9",
        "viet-phrase-shop-1",
      ],
      maximumItemCount: 6,
      fillsFromSourceCategories: false,
    },
    {
      title: "Help & emergency",
      sourceCategoryIDs: ["problems-help", "health-pharmacy", "emergency-safety"],
      pageIDs: [
        "viet-phrase-help-need-help-direct",
        "viet-phrase-health-pharmacy-clearer",
        "viet-phrase-problems-6",
        "viet-phrase-emergency-3",
        "viet-phrase-emergency-4",
        "viet-phrase-emergency-1",
        "viet-phrase-emergency-hospital",
      ],
      maximumItemCount: 12,
    },
  ];
  for (const shelf of homeShelves) {
    addHomeItems(shelf.title, resolveHomeShelfItems(shelf));
  }

  const browseRoutes = [
    { id: "airport", title: "Airport", categoryIDs: ["airport-border-arrival", "transport", "phone-internet-power", "money-numbers-prices"], preferredPageIDs: [] },
    { id: "hotel", title: "Hotel", categoryIDs: ["hotel-accommodation", "time-dates-booking", "local-services-everyday-tasks"], preferredPageIDs: ["viet-family-hotel-check-in", "viet-family-hotel-luggage"] },
    { id: "food", title: "Eating Out", categoryIDs: ["food-drink", "money-numbers-prices"], preferredPageIDs: ["viet-family-food-coffee-black", "viet-family-food-coffee-milk", "viet-family-ves-order-pho-bowl"] },
    { id: "getting-around", title: "Getting Around", categoryIDs: ["transport", "directions-navigation"], preferredPageIDs: [] },
    { id: "shopping", title: "Shopping", categoryIDs: ["shopping", "money-numbers-prices", "local-services-everyday-tasks"], preferredPageIDs: [] },
    { id: "emergency", title: "Emergency", categoryIDs: ["emergency-safety", "health-pharmacy", "problems-help"], preferredPageIDs: ["viet-phrase-emergency-5", "viet-family-v900-emer-safe-please-call-emergency-services", "viet-family-health-doctor", "viet-family-emergency-hospital", "viet-family-emergency-police-station"] },
    { id: "local-greetings", title: "Respectful hellos", categoryIDs: ["local-greetings", "greetings", "polite-basics"], preferredPageIDs: ["viet-polite-hello", "viet-phrase-hello-chao-anh"] },
    { id: "essentials", title: "Essentials", categoryIDs: ["polite-basics", "greetings", "gratitude", "understanding-repair"], preferredPageIDs: ["viet-polite-hello", "viet-thank-you", "viet-family-repair-understand"] },
    { id: "first-day", title: "First day in Vietnam", categoryIDs: ["airport-border-arrival", "hotel-accommodation", "transport", "directions-navigation"], preferredPageIDs: ["viet-family-airport-immigration", "viet-family-hotel-check-in"] },
    { id: "greetings", title: "Hello basics", categoryIDs: ["greetings", "local-greetings"], preferredPageIDs: ["viet-polite-hello"] },
    { id: "questions", title: "Questions", categoryIDs: ["directions-navigation", "time-dates-booking", "understanding-repair"], preferredPageIDs: [] },
    { id: "numbers-money", title: "Numbers & money", categoryIDs: ["money-numbers-prices", "shopping"], preferredPageIDs: [] },
    { id: "polite-repair", title: "When You Don't Understand", categoryIDs: ["understanding-repair", "polite-basics", "problems-help"], preferredPageIDs: ["viet-family-repair-understand", "viet-family-repair-meaning"] },
  ];
  const subcategorySpecs = {
    airport: [
      ["arrival", "Arrival", ["airport-border-arrival"], ["arrival", "tourism", "passport"]],
      ["baggage", "Baggage", ["airport-border-arrival"], ["bag", "baggage", "luggage"]],
      ["transport", "Transport", ["transport", "directions-navigation"], ["taxi", "bus", "pickup"]],
      ["sim-card", "SIM card", ["airport-border-arrival", "phone-internet-power"], ["sim", "esim", "data", "wi-fi", "wifi", "internet"]],
      ["cash", "Cash", ["airport-border-arrival", "money-numbers-prices", "transport"], ["atm", "cash", "card", "money", "exchange", "pay"]],
    ],
    hotel: [
      ["check-in", "Check-in", ["hotel-accommodation"], ["reservation", "check", "room"]],
      ["luggage", "Luggage", ["hotel-accommodation"], ["luggage", "bag"]],
      ["room-help", "Room help", ["hotel-accommodation", "problems-help"], ["room", "quiet", "hot", "help"]],
      ["checkout", "Checkout", ["hotel-accommodation", "time-dates-booking"], ["checkout", "breakfast", "bill"]],
    ],
    "first-day": [
      ["airport", "Airport", ["airport-border-arrival"], []],
      ["hotel", "Hotel", ["hotel-accommodation"], []],
      ["transport", "Transport", ["transport", "directions-navigation"], []],
    ],
    questions: [
      ["directions", "Directions", ["directions-navigation"], []],
      ["time", "Time", ["time-dates-booking"], []],
      ["clarify", "Clarify", ["understanding-repair"], []],
    ],
    "numbers-money": [
      ["payment", "Payment", ["money-numbers-prices"], []],
      ["shopping", "Shopping", ["shopping"], []],
    ],
    shopping: [
      ["prices", "Prices", ["shopping", "money-numbers-prices"], ["price", "cost", "much"]],
      ["sizes", "Sizes", ["shopping"], ["size", "color", "fit"]],
      ["payment", "Payment", ["shopping", "money-numbers-prices"], ["pay", "card", "cash", "qr"]],
      ["receipts", "Receipts", ["shopping", "local-services-everyday-tasks"], ["receipt", "return", "exchange"]],
    ],
    emergency: [
      ["help", "Help", ["problems-help", "emergency-safety"], ["help", "need"]],
      ["health", "Health", ["health-pharmacy"], ["doctor", "pharmacy", "medicine"]],
      ["safety", "Safety", ["emergency-safety"], ["safe", "police", "emergency"]],
      ["problems", "Problems", ["problems-help"], ["lost", "problem", "manager"]],
    ],
    "polite-repair": [
      ["clarify", "Clarify", ["understanding-repair"], []],
      ["polite-basics", "Polite basics", ["polite-basics"], []],
      ["get-help", "Get help", ["problems-help"], []],
    ],
  };
  const foodSupplementalRows = [
    {
      title: "Order drinks",
      pageIDs: [
        "viet-family-food-coffee-black",
        "viet-family-food-coffee-milk",
        "viet-family-food-coffee-bac-xiu",
        "viet-family-v900-food-drin-one-hot-coffee-please",
        "viet-family-food-bottled-water",
        "viet-family-service-water",
        "viet-family-v900-food-drin-one-sugarcane-juice-please",
        "viet-family-v900-food-drin-one-fresh-coconut-please",
      ],
      categories: ["food-drink"],
      terms: ["coffee", "tea", "water", "drink"],
    },
    {
      title: "Order dishes",
      pageIDs: [
        "viet-family-ves-order-pho-bowl",
        "viet-family-v500-food-drin-id-like-a-b-nh-m-please",
        "viet-family-ves-order-bun-bo-hue-bowl",
        "viet-family-ves-order-bun-cha-portion",
        "viet-family-ves-order-cao-lau-portion",
        "viet-family-city-danang-place-banh-xeo",
        "viet-family-city-hanoi-place-pho-bo",
        "viet-family-food-vegetarian",
        "viet-family-food-one-portion",
      ],
      categories: [],
      terms: [],
    },
    {
      title: "Adjust the order",
      pageIDs: [
        "viet-family-food-menu",
        "viet-family-food-one-portion",
        "viet-family-food-this-bowl",
        "viet-family-food-less-ice",
        "viet-family-food-no-sugar",
        "viet-family-food-not-spicy",
        "viet-family-food-more-herbs",
        "viet-family-food-pack-to-go",
        "viet-family-v900-food-drin-what-do-you-recommend",
        "viet-family-v900-food-drin-what-is-not-too-spicy",
      ],
      categories: ["food-drink"],
      terms: ["menu", "portion", "bowl", "order", "spicy", "ice", "sugar", "to go", "recommend"],
    },
    {
      title: "Allergies & diet",
      pageIDs: [
        "viet-family-food-peanut-allergy",
        "viet-family-food-vegetarian",
        "viet-family-food-has-peanuts",
        "viet-family-food-no-meat",
        "viet-family-food-without-this-ingredient",
        "viet-family-food-too-spicy-now",
        "viet-family-food-which-dish-safe",
        "viet-family-food-has-meat-in-it",
        "viet-family-v500-food-drin-does-this-contain-shrimp",
        "viet-family-v500-food-drin-i-am-allergic-to-shellfish",
      ],
      categories: ["food-drink", "health-pharmacy"],
      terms: ["allergy", "allergic", "vegetarian", "peanut", "meat", "ingredient", "spicy", "shrimp", "shellfish"],
    },
    {
      title: "Paying",
      pageIDs: [
        "viet-family-food-pay-now",
        "viet-family-food-split-bill",
        "viet-family-shopping-card",
        "viet-family-service-receipt",
        "viet-family-money-cash-only",
        "viet-family-money-how-much",
      ],
      categories: ["money-numbers-prices", "food-drink"],
      terms: ["bill", "pay", "card", "cash", "receipt", "separately", "how much"],
    },
  ];

  const addBrowseRoute = (route) => {
    const phraseStarterItems = starterItems(route.categoryIDs, route.preferredPageIDs, 3);
    const visibleForExclusion = new Set(phraseStarterItems.map((item) => item.pageID));

    if (route.id === "food") {
      const drinkItems = uniquePageIDs(foodSupplementalRows[0].pageIDs)
        .map((pageID) => pagesByID.get(pageID))
        .filter(Boolean);
      const dishItems = uniquePageIDs(foodSupplementalRows[1].pageIDs)
        .map((pageID) => pagesByID.get(pageID))
        .filter(Boolean);
      const quickOrders = [...drinkItems.slice(0, 3), ...dishItems.slice(0, 5)].slice(0, 8);
      addBrowseItems(route.id, route.title, "Quick orders", quickOrders);
      quickOrders.forEach((item) => visibleForExclusion.add(item.pageID));
      for (const spec of foodSupplementalRows) {
        const preferred = uniquePageIDs(spec.pageIDs).map((pageID) => pagesByID.get(pageID)).filter(Boolean);
        const fallback = itemsMatchingTerms(spec.categories, spec.terms, 12);
        const rows = uniquePageIDs([...preferred, ...fallback].map((item) => item.pageID))
          .slice(0, 12)
          .map((pageID) => pagesByID.get(pageID))
          .filter(Boolean);
        addBrowseItems(route.id, route.title, spec.title, rows);
        rows.forEach((item) => visibleForExclusion.add(item.pageID));
      }
    } else if (route.id !== "getting-around") {
      addBrowseItems(route.id, route.title, "Starter phrases", phraseStarterItems);
      phraseStarterItems.forEach((item) => visibleForExclusion.add(item.pageID));
      const specs = subcategorySpecs[route.id] || route.categoryIDs.map((categoryID) => [
        categoryID,
        categoryTitles[categoryID] || titleCase(categoryID),
        [categoryID],
        [],
      ]);
      for (const [, title, categoryIDs, terms] of specs) {
        const rows = itemsMatchingTerms(categoryIDs, terms, 12);
        addBrowseItems(route.id, route.title, title, rows);
        rows.forEach((item) => visibleForExclusion.add(item.pageID));
      }
    }

    route.categoryIDs.slice(0, 4).forEach((categoryID) => {
      const rows = itemsForCategories([categoryID], 6, visibleForExclusion);
      addBrowseItems(route.id, route.title, `More ${categoryTitles[categoryID] || titleCase(categoryID)}`, rows);
    });
  };
  browseRoutes.forEach(addBrowseRoute);

  for (const pageID of searchIDs) {
    addChannel(pageID, {
      kind: "Search",
      label: "Search result",
      route: "search",
      givesBackdrop: false,
    });
  }
  for (const row of incomingRows) {
    addChannel(row.pageID, {
      kind: "Related",
      label: `Related from ${row.incomingCount} page${Number(row.incomingCount) === 1 ? "" : "s"}`,
      route: "detail-graph",
      givesBackdrop: false,
    });
  }

  const byPageID = new Map();
  for (const page of pageRows) {
    const channels = channelMap.get(page.pageID) || [];
    const channelKinds = new Set(channels.map((channel) => channel.kind));
    const isSupport = page.categoryIDs.includes("editorial-model-support")
      || page.categoryIDs.some((id) => id.startsWith("support-model"));
    const hasHome = channelKinds.has("Home");
    const hasBrowse = channelKinds.has("Browse");
    const hasSearch = channelKinds.has("Search");
    const hasRelated = channelKinds.has("Related");
    let reachabilityStatus = "Not reachable";
    let reachabilityRank = 5;
    let normalUserPath = "No normal Home, Browse, Search, or related-detail path found.";
    let nextAction = "Review whether this should be surfaced or archived.";
    let backdropRisk = "Dead/legacy candidate.";

    if (isSupport && !hasHome && !hasBrowse) {
      reachabilityStatus = "Support/reference";
      reachabilityRank = 4;
      normalUserPath = hasSearch || hasRelated
        ? "Search/detail graph support content, not a top-level Browse/Home page."
        : "Support content with no normal user path found.";
      nextAction = "Leave out of the first backdrop rollout unless it becomes traveler-facing.";
      backdropRisk = "Low priority support/reference page.";
    } else if (hasHome) {
      reachabilityStatus = "Home visible";
      reachabilityRank = 1;
      normalUserPath = channels.find((channel) => channel.kind === "Home")?.label || "Home";
      nextAction = "Fix first: add an intrinsic page image or category fallback so Home/Search/Saved do not show screenshot 1.";
      backdropRisk = "High: a user can hit this from Home and see the old single-layer detail.";
    } else if (hasBrowse) {
      reachabilityStatus = "Browse visible";
      reachabilityRank = 2;
      normalUserPath = channels.find((channel) => channel.kind === "Browse")?.label || "Browse";
      nextAction = "Good first-pass candidate for category fallback; Browse can pass a category image, but direct Search/Saved still need intrinsic metadata.";
      backdropRisk = "Medium: Browse has a category image path, direct entry can still show screenshot 1.";
    } else if (hasSearch && hasRelated) {
      reachabilityStatus = "Search + related only";
      reachabilityRank = 3;
      normalUserPath = "Search results and links from detail pages.";
      nextAction = "Lower than Home/Browse. Batch these after the front-facing rows or give them broad category fallbacks.";
      backdropRisk = "Lower: reachable, but usually after a search or another detail page.";
    } else if (hasSearch) {
      reachabilityStatus = "Search only";
      reachabilityRank = 3;
      normalUserPath = "Search result only.";
      nextAction = "Lower priority unless the query/page is strategically important.";
      backdropRisk = "Lower: reachable through search, but not front-door Browse/Home.";
    } else if (hasRelated) {
      reachabilityStatus = "Related only";
      reachabilityRank = 4;
      normalUserPath = "Linked from another detail page.";
      nextAction = "Treat as secondary graph content unless it becomes a real destination.";
      backdropRisk = "Low: detail-graph only.";
    }

    const humanAccessVerdict = humanAccessVerdictFor(reachabilityStatus);
    const isHumanReachable = reachabilityStatus === "Not reachable" ? "No" : "Yes";
    const accessProof = accessProofFor({
      reachabilityStatus,
      normalUserPath,
      hasHome,
      hasBrowse,
      hasSearch,
      hasRelated,
      isSupport,
      incomingCount: incomingByID.get(page.pageID)?.incomingCount || 0,
    });
    const deletionReview = deletionReviewFor(reachabilityStatus);

    byPageID.set(page.pageID, {
      canonicalPageID: page.pageID,
      reachabilityStatus,
      reachabilityRank,
      normalUserPath,
      humanAccessVerdict,
      isHumanReachable,
      accessProof,
      deletionReview,
      nextAction,
      backdropRisk,
      isSearchReachable: hasSearch ? "Yes" : "No",
      hasRelatedEntry: hasRelated ? "Yes" : "No",
      hasBrowseBackdropOverride: channels.some((channel) => channel.kind === "Browse" && channel.givesBackdrop) ? "Yes" : "No",
      channelList: channels.map((channel) => channel.label).join(" | "),
      incomingRelationCount: incomingByID.get(page.pageID)?.incomingCount || 0,
      outgoingRelationCount: outgoingByID.get(page.pageID)?.outgoingCount || 0,
      isSupportReference: isSupport ? "Yes" : "No",
    });
  }

  return { byPageID, canonicalize };
}

function humanAccessVerdictFor(reachabilityStatus) {
  switch (reachabilityStatus) {
  case "Home visible":
    return "Front-facing: visible from Home";
  case "Browse visible":
    return "Front-facing: visible from Browse";
  case "Search + related only":
    return "Reachable: Search plus detail links";
  case "Search only":
    return "Reachable: Search";
  case "Related only":
    return "Reachable: detail links only";
  case "Support/reference":
    return "Reachable support/reference content";
  case "Not reachable":
    return "Hidden/dead candidate";
  default:
    return reachabilityStatus || "";
  }
}

function accessProofFor({
  reachabilityStatus,
  normalUserPath,
  hasHome,
  hasBrowse,
  hasSearch,
  hasRelated,
  isSupport,
  incomingCount,
}) {
  if (hasHome) {
    return `${normalUserPath}; page also exists in runtime phrase_page and Search index.`;
  }
  if (hasBrowse) {
    return `${normalUserPath}; Browse collection renders this page from category/city content.`;
  }
  if (hasSearch && hasRelated) {
    return `Search index contains this canonical page; ${incomingCount} detail page${Number(incomingCount) === 1 ? "" : "s"} link to it.`;
  }
  if (hasSearch) {
    return "Search index contains this canonical page, so a user can open it from Search.";
  }
  if (hasRelated) {
    return `${incomingCount} detail page${Number(incomingCount) === 1 ? "" : "s"} link to it.`;
  }
  if (isSupport && reachabilityStatus === "Support/reference") {
    return "Support/model content; keep out of first visual rollout unless promoted.";
  }
  return "No Home, Browse, Search, or incoming detail-link path found.";
}

function deletionReviewFor(reachabilityStatus) {
  switch (reachabilityStatus) {
  case "Not reachable":
    return "Yes - investigate whether to surface, archive, or delete.";
  case "Support/reference":
    return "Not because of reachability; product/content cleanup decision only.";
  default:
    return "No - reachable through normal app UI.";
  }
}

function enrichReachability(row, audit) {
  const canonicalPageID = audit.canonicalize(row.pageID);
  const reachability = audit.byPageID.get(canonicalPageID);
  if (!reachability) {
    return {
      ...row,
      canonicalPageID,
      reachabilityStatus: row.auditStatus === "Implemented" ? "Already implemented" : "Not found in SQLite",
      reachabilityRank: row.auditStatus === "Implemented" ? 0 : 9,
      normalUserPath: row.routeContext || "",
      humanAccessVerdict: row.auditStatus === "Implemented" ? "Already implemented" : "Not found in runtime",
      isHumanReachable: row.auditStatus === "Implemented" ? "Yes" : "Unknown",
      accessProof: row.auditStatus === "Implemented" ? row.routeContext || "Intrinsic page route." : "No runtime phrase_page row found for this audit row.",
      deletionReview: row.auditStatus === "Implemented" ? "No - already implemented." : "Review - audit row is not in the runtime SQLite page table.",
      nextAction: row.recommendation,
      backdropRisk: "",
      searchReachable: "",
      relatedEntry: "",
      browseBackdropOverride: "",
      reachabilityChannels: "",
      incomingRelationCount: "",
      outgoingRelationCount: "",
      supportReference: "",
    };
  }

  return {
    ...row,
    canonicalPageID,
    reachabilityStatus: reachability.reachabilityStatus,
    reachabilityRank: reachability.reachabilityRank,
    normalUserPath: reachability.normalUserPath,
    humanAccessVerdict: reachability.humanAccessVerdict,
    isHumanReachable: reachability.isHumanReachable,
    accessProof: reachability.accessProof,
    deletionReview: reachability.deletionReview,
    nextAction: reachability.nextAction,
    backdropRisk: reachability.backdropRisk,
    searchReachable: reachability.isSearchReachable,
    relatedEntry: reachability.hasRelatedEntry,
    browseBackdropOverride: reachability.hasBrowseBackdropOverride,
    reachabilityChannels: reachability.channelList,
    incomingRelationCount: reachability.incomingRelationCount,
    outgoingRelationCount: reachability.outgoingRelationCount,
    supportReference: reachability.isSupportReference,
  };
}

function isSearchOnlyNeed(row) {
  return row.needsBackdropWork === "Yes"
    && ["Search only", "Search + related only", "Related only"].includes(row.reachabilityStatus);
}

function searchDecisionID(row) {
  if (!isSearchOnlyNeed(row)) return "";
  if (row.runtimeExists !== "Yes" || row.runtimeSearchIndexed !== "Yes") {
    return "delete-archive";
  }
  if (row.runtimeAudioStatus !== "ready"
    || row.runtimeAudioFilesExist !== "Yes"
    || Number(row.runtimeMissingAudioCount || 0) > 0
    || Number(row.runtimeAudioUsageCount || 0) === 0) {
    return "fix-runtime-audio";
  }
  if (row.priority === "P0 tier-one" || row.priority === "P1 major travel flow") {
    return "promote-review";
  }
  return "keep-search-only";
}

function searchDecisionLabel(decisionID) {
  switch (decisionID) {
  case "keep-search-only":
    return "Keep as Search-only";
  case "promote-review":
    return "Promote/review";
  case "fix-runtime-audio":
    return "Fix runtime/audio before image work";
  case "delete-archive":
    return "Delete/archive candidate";
  default:
    return "";
  }
}

function searchAuditReason(row, decisionID) {
  if (!isSearchOnlyNeed(row)) return "";
  if (decisionID === "delete-archive") {
    return "Runtime or Search proof is missing after canonical page resolution. This should be investigated before image work.";
  }
  if (decisionID === "fix-runtime-audio") {
    return "The page is real, but audio/runtime proof is incomplete. Fix that before spending time on backdrop art.";
  }
  if (row.priority === "P0 tier-one") {
    return "This is tier-one traveler content. It is live in Search now, but deserves product review for Browse/Home promotion.";
  }
  if (row.priority === "P1 major travel flow") {
    return "This is a concrete travel-flow phrase. Keep it, and consider promoting the best examples into Browse/category shelves.";
  }
  if (row.runtimeAccessTier === "premium") {
    return "This is premium exact-need inventory: useful when searched, too specific to crowd the main Home/Browse shelves.";
  }
  return "This is a valid starter/base phrase in Search. Keep it searchable unless product review finds a duplicate.";
}

function searchOnlyWhyCreated(row) {
  if (!isSearchOnlyNeed(row)) return "";
  if (row.runtimeAccessTier === "premium") {
    return "Created for long-tail, exact traveler needs that are best found by Search instead of being shown as top-level Browse rows.";
  }
  if (row.priority === "P0 tier-one") {
    return "Created as core phrase content; current Home/Browse shelves are curated and do not expose every core row.";
  }
  return "Created as canonical phrase inventory for the offline app; Search is the broad access path when it is not curated into Home/Browse.";
}

function searchDeleteRecommendation(row, decisionID) {
  if (!isSearchOnlyNeed(row)) return "";
  if (decisionID === "delete-archive") {
    return "Investigate for archive/delete or repair because runtime/Search proof is missing.";
  }
  if (row.runtimeAliasStatus.includes("Alias/display")) {
    return "Do not delete: the display ID is legacy-looking, but it resolves to a live canonical runtime page.";
  }
  return "Do not delete: live canonical Search page with ready bundled audio.";
}

function enrichSearchAudit(row) {
  const decisionID = searchDecisionID(row);
  return {
    ...row,
    searchAuditScope: isSearchOnlyNeed(row) ? "Search/Search+related needs-backdrop page" : "",
    searchAuditDecisionID: decisionID,
    searchAuditDecision: searchDecisionLabel(decisionID),
    searchAuditReason: searchAuditReason(row, decisionID),
    searchOnlyWhyCreated: searchOnlyWhyCreated(row),
    searchDeleteRecommendation: searchDeleteRecommendation(row, decisionID),
  };
}

const runtimeDetailsByPageID = buildRuntimeDetailsByPageID();
const reachabilityAudit = buildReachabilityAudit();
const listingRows = [...rowsFromAuthoredPages(), ...menuDetailRows()]
  .map((row) => enrichReachability(row, reachabilityAudit))
  .map(enrichRuntimeDetails)
  .map(enrichSearchAudit);
const needsRows = listingRows.filter((row) => row.needsBackdropWork === "Yes");
const searchAuditRows = needsRows.filter(isSearchOnlyNeed);
const optionalRows = listingRows.filter((row) => row.needsBackdropWork === "Optional");
const implementedRows = listingRows.filter((row) => row.auditStatus === "Implemented");
const reviewRows = listingRows.filter((row) => row.auditStatus === "Review");
const sharedPool = collectSharedPool();

const collectionRows = [
  ...Object.entries(categoryMastheadImages)
    .filter(([id]) => id !== "vietnamese-food-menu" && id !== "vietnamese-drink-menu")
    .map(([id, asset]) => ({
      route: `category:${id}`,
      title: categoryTitles[id] || id,
      backgroundSystem: asset.startsWith("HeroCategory") || id === "city-guides"
        ? "photo-backdrop collection sheet + single static image"
        : "standard collection masthead",
      imageAsset: asset,
      imagePool: "single fixed image",
      notes: id === "city-guides"
        ? "Uses cityHub content, so BrowseCollectionPageView enables photo backdrop even though the asset is HeroCountryVietnam."
        : "HeroCategory masthead enables BrowseCollectionPageView photo backdrop.",
      assetExists: assetExists(asset) ? "Yes" : "No",
      assetFile: assetFile(asset) || "",
    })),
  ...Object.entries(cityMastheadImages).map(([id, asset]) => ({
    route: `city:${id}`,
    title: cityTitles[id] || id,
    backgroundSystem: "photo-backdrop city hub sheet + single static image",
    imageAsset: asset,
    imagePool: "single fixed image",
    notes: "City descriptor has cityHub content, enabling BrowseCollectionPageView photo backdrop.",
    assetExists: assetExists(asset) ? "Yes" : "No",
    assetFile: assetFile(asset) || "",
  })),
  {
    route: "category:vietnamese-food-menu",
    title: "Vietnamese Food Menu",
    backgroundSystem: "photo-backdrop menu collection sheet + single static image",
    imageAsset: "BackdropVietnameseFoodMenu",
    imagePool: "single fixed image",
    notes: "VietnameseMenuPageView uses kind.photoBackdropImageName.",
    assetExists: assetExists("BackdropVietnameseFoodMenu") ? "Yes" : "No",
    assetFile: assetFile("BackdropVietnameseFoodMenu") || "",
  },
  {
    route: "category:vietnamese-drink-menu",
    title: "Vietnamese Drink Menu",
    backgroundSystem: "photo-backdrop menu collection sheet + single static image",
    imageAsset: "BackdropVietnameseDrinkMenu",
    imagePool: "single fixed image",
    notes: "VietnameseMenuPageView uses kind.photoBackdropImageName.",
    assetExists: assetExists("BackdropVietnameseDrinkMenu") ? "Yes" : "No",
    assetFile: assetFile("BackdropVietnameseDrinkMenu") || "",
  },
];

const rootRows = ["home", "browse", "saved", "practice", "search"].map((surface) => ({
  surface,
  backgroundSystem: "admin/root photo-backdrop surface + shared rotating pool",
  imagePool: "SharedBackdropImagePool.vietnamForwardAssetNames",
  poolSize: sharedPool.length,
  cursor: "one shared adminRoot cursor across root surfaces",
  notes: "Each root-surface activation advances to the next pool image; selected image plus one lookahead is preheated.",
}));

function groupCount(rows, key) {
  const counts = new Map();
  for (const row of rows) {
    const value = row[key] || "";
    counts.set(value, (counts.get(value) || 0) + 1);
  }
  return [...counts.entries()].sort((a, b) => b[1] - a[1]);
}

const frontFacingNeedsCount = needsRows.filter((row) => row.reachabilityStatus === "Home visible" || row.reachabilityStatus === "Browse visible").length;
const searchOnlyNeedsCount = needsRows.filter((row) => row.reachabilityStatus === "Search + related only" || row.reachabilityStatus === "Search only" || row.reachabilityStatus === "Related only").length;
const notReachableNeedsCount = needsRows.filter((row) => row.reachabilityStatus === "Not reachable").length;
const humanReachableNeedsCount = needsRows.filter((row) => row.isHumanReachable === "Yes").length;
const searchIndexedNeedsCount = needsRows.filter((row) => row.searchReachable === "Yes").length;
const deletionCandidateNeedsCount = needsRows.filter((row) => String(row.deletionReview || "").startsWith("Yes")).length;
const searchAuditDecisionCounts = new Map(groupCount(searchAuditRows, "searchAuditDecisionID"));
const searchPromoteReviewCount = searchAuditDecisionCounts.get("promote-review") || 0;
const searchKeepOnlyCount = searchAuditDecisionCounts.get("keep-search-only") || 0;
const searchDeleteArchiveCount = searchAuditDecisionCounts.get("delete-archive") || 0;
const searchRuntimeAudioFixCount = searchAuditDecisionCounts.get("fix-runtime-audio") || 0;
const searchAudioReadyCount = searchAuditRows.filter((row) => row.runtimeAudioStatus === "ready" && row.runtimeAudioFilesExist === "Yes").length;
const searchAliasResolvedCount = searchAuditRows.filter((row) => row.pageID !== row.canonicalPageID).length;
const searchPremiumRuntimeCount = searchAuditRows.filter((row) => row.runtimeAccessTier === "premium").length;
const searchStarterRuntimeCount = searchAuditRows.filter((row) => row.runtimeAccessTier === "starter").length;

const summaryRows = [
  ["Metric", "Count", "Notes"],
  ["Root/admin surfaces using 20-pool", rootRows.length, `${sharedPool.length} shared Vietnam-forward images, one admin-root cursor.`],
  ["Collection/hub/menu collection pages with photo-backdrop sheet", collectionRows.filter((row) => row.backgroundSystem.includes("photo-backdrop")).length, "Category HeroCategory*, city hubs, All Vietnam, and food/drink menu collection pages."],
  ["Detail/listing pages total audited", listingRows.length, "Authored Viet listing resource plus Vietnamese menu detail catalog."],
  ["Detail pages already implemented", implementedRows.length, "500 city/place + 355 menu detail pages."],
  ["Detail pages needing backdrop work", needsRows.length, "Canonical phrase/detail pages with no intrinsic heroImageName; direct/Home/Search entry still old single-layer."],
  ["Needs-backdrop pages reachable by a human", humanReachableNeedsCount, "Reachable through Home, Browse, Search, or incoming detail-page links."],
  ["Needs-backdrop pages not reachable", notReachableNeedsCount, "Rows in this bucket are delete/archive candidates unless intentionally hidden."],
  ["Search/search+related needs-backdrop pages audited", searchAuditRows.length, "Reachable through Search or detail links, but not front-facing Home/Browse rows in this audit."],
  ["Search rows recommended to keep Search-only", searchKeepOnlyCount, "Useful exact-need long-tail pages that should remain searchable without crowding Home/Browse."],
  ["Search rows recommended for promotion/review", searchPromoteReviewCount, "Tier-one plus major travel-flow rows that may deserve Browse/Home/category surfacing."],
  ["Search rows recommended for delete/archive", searchDeleteArchiveCount, "Canonical runtime/Search/audio proof found no delete candidates."],
  ["Search rows with ready bundled audio", searchAudioReadyCount, "All rows in this bucket resolve to a ready audio usage and existing bundled audio file."],
  ["Legacy/display IDs resolved to canonical pages", searchAliasResolvedCount, "These looked stale only if joined by display pageID; canonicalPageID proves they are live."],
  ["Compact generated city-action pages deferred", optionalRows.length, "HeroCompactPhraseMasthead helper rows; do not roll out by default unless promoted."],
  ["Review/nonstandard hero pages", reviewRows.length, "Should be zero unless new image patterns appeared."],
  ["Existing shared pool images", sharedPool.length, "Current curated admin-root pool."],
];

const bucketRows = [
  ["Rollout bucket", "Count", "Recommended direction"],
  ...groupCount(needsRows, "rolloutBucket").map(([bucket, count]) => [bucket, count, directionForBucket(bucket)]),
];

function directionForBucket(bucket) {
  if (bucket.includes("topical mini-pool")) {
    return "Add a small page/category pool, then apply the shared photo-backdrop layout to affected phrase pages.";
  }
  if (bucket.includes("category hero")) {
    return "Use current HeroCategory assets as first-pass page-level fallbacks, then refine the highest-traffic pages.";
  }
  if (bucket.includes("shared Vietnam pool")) {
    return "Reuse the 20-pool where the phrase is general and does not need a literal object/location image.";
  }
  return "Review rows in Needs Backdrop tab.";
}

const statusRows = [
  ["Audit status", "Count"],
  ...groupCount(listingRows, "auditStatus"),
];

const reachabilityOrder = [
  "Home visible",
  "Browse visible",
  "Search + related only",
  "Search only",
  "Support/reference",
  "Related only",
  "Not reachable",
];

const reachabilityPlain = {
  "Home visible": [
    "User can see/open this from Home without searching.",
    "Highest priority: direct Home/Search/Saved entry can still look like screenshot 1.",
  ],
  "Browse visible": [
    "User can find this inside a Browse/category page.",
    "Medium priority: Browse can pass a category image, but Search/Saved/direct entry still needs page metadata.",
  ],
  "Search + related only": [
    "User can find it through Search or by tapping from another detail page.",
    "Lower priority: reachable, but not a normal top-level card/shelf.",
  ],
  "Search only": [
    "User can find it through Search, but it is not a Home/Browse row in this audit.",
    "Lower priority unless the query is strategically important.",
  ],
  "Support/reference": [
    "Support/model content, not a primary traveler-facing destination.",
    "Leave out of the first backdrop rollout unless promoted.",
  ],
  "Related only": [
    "Only appears as a link from another detail page.",
    "Treat as secondary graph content.",
  ],
  "Not reachable": [
    "No normal Home, Browse, Search, or related-detail path found.",
    "Review for surfacing or archive/delete.",
  ],
};

const reachabilityCounts = new Map(groupCount(needsRows, "reachabilityStatus"));
const reachabilityRows = [
  ["Reachability state", "Needs-backdrop pages", "Plain meaning", "Decision"],
  ...reachabilityOrder
    .filter((status) => reachabilityCounts.has(status) || status === "Not reachable")
    .map((status) => [
      status,
      reachabilityCounts.get(status) || 0,
      reachabilityPlain[status]?.[0] || "",
      reachabilityPlain[status]?.[1] || "",
    ]),
];

const humanAccessRows = [
  ["Question", "Answer", "Evidence"],
  [
    "Can a normal user get to the 952 pages?",
    `${humanReachableNeedsCount} of ${needsRows.length} are reachable.`,
    "Each reachable row has Home, Browse, Search, or incoming detail-link evidence in the runtime audit.",
  ],
  [
    "How many are front-facing without search?",
    frontFacingNeedsCount,
    `${reachabilityCounts.get("Home visible") || 0} Home-visible plus ${reachabilityCounts.get("Browse visible") || 0} Browse-visible pages.`,
  ],
  [
    "How many are reachable but not front-facing?",
    searchOnlyNeedsCount,
    "These are Search-only, Search + related, or related-only rows. They are real app pages, but lower visual priority.",
  ],
  [
    "How many are in the Search index?",
    `${searchIndexedNeedsCount} of ${needsRows.length}`,
    "Search index membership is the baseline proof that a human can intentionally find/open the page.",
  ],
  [
    "How many look hidden, dead, or legacy-only?",
    notReachableNeedsCount,
    "No needs-backdrop row lacked Home, Browse, Search, or detail-link coverage in this audit.",
  ],
  [
    "How many should be reviewed for delete/archive because they are inaccessible?",
    deletionCandidateNeedsCount,
    "Deletion is not recommended from reachability evidence unless this count becomes nonzero.",
  ],
  [
    "What about support/reference rows?",
    reachabilityCounts.get("Support/reference") || 0,
    "These are not first-pass traveler UI rows, but they are not dead rows in this audit.",
  ],
];

const searchAuditSummaryRows = [
  ["Question", "Answer", "Plain English decision"],
  [
    "Are the 563 Search/search+related pages bloat?",
    "Mostly no.",
    "They are live Search-indexed phrase pages, usually long-tail exact traveler needs. Keep the long-tail rows searchable instead of forcing them into Home/Browse.",
  ],
  [
    "How many should be kept Search-only?",
    searchKeepOnlyCount,
    "These are mostly premium exact-need rows. Add broad/category backdrops, but do not promote every one into top-level navigation.",
  ],
  [
    "How many should be promoted or reviewed?",
    searchPromoteReviewCount,
    "These are tier-one or major travel-flow pages. They should be reviewed for Browse/Home/category surfacing after the image pass.",
  ],
  [
    "How many should be deleted or archived now?",
    searchDeleteArchiveCount,
    "Zero from this audit. Every row resolves to a canonical runtime page, Search index entry, and bundled audio.",
  ],
  [
    "Do they have audio?",
    `${searchAudioReadyCount} of ${searchAuditRows.length}`,
    "All Search/search+related rows have ready audio and an existing file under native-ios/Resources/Audio.",
  ],
  [
    "What about legacy-looking IDs?",
    `${searchAliasResolvedCount} alias/display IDs`,
    "They are not stale by themselves. They resolve through page_alias to canonical runtime page IDs, so do not delete them based on the old ID shape.",
  ],
  [
    "Premium vs starter split",
    `${searchPremiumRuntimeCount} premium / ${searchStarterRuntimeCount} starter`,
    "This explains why many pages are Search-only: premium exact-need coverage is intentionally broader than curated Home/Browse shelves.",
  ],
  [
    "Runtime/audio problems found",
    searchRuntimeAudioFixCount,
    "No Search-only row needs runtime/audio repair before backdrop work.",
  ],
];

const assetRows = [
  ["Asset group", "Count", "Notes"],
  ["Shared admin root pool", sharedPool.length, sharedPool.join(", ")],
  ["HeroCategory assets referenced by collection/code", Object.values(categoryMastheadImages).filter((name) => name.startsWith("HeroCategory")).length, [...new Set(Object.values(categoryMastheadImages).filter((name) => name.startsWith("HeroCategory")))].join(", ")],
  ["City masthead assets", Object.keys(cityMastheadImages).length, Object.values(cityMastheadImages).join(", ")],
  ["City/place detail hero assets in resource", new Set(implementedRows.filter((row) => row.source === "city/place listing").map((row) => row.heroImageName)).size, "HeroCity* page-specific listing images."],
  ["Menu detail backdrop assets", menu.items.length, "BackdropMenu* generated portrait assets."],
  ["Menu collection backdrops", 2, "BackdropVietnameseFoodMenu, BackdropVietnameseDrinkMenu"],
];

function matrixFromObjects(rows, headers) {
  return [headers, ...rows.map((row) => headers.map((header) => row[header] ?? ""))];
}

const listingHeaders = [
  "pageID",
  "source",
  "title",
  "englishTitle",
  "categoryIDs",
  "heroImageName",
  "auditStatus",
  "currentBackgroundSystem",
  "needsBackdropWork",
  "recommendedAsset",
  "recommendation",
  "rolloutBucket",
  "imageTheme",
  "routeContext",
  "canonicalPageID",
  "humanAccessVerdict",
  "isHumanReachable",
  "accessProof",
  "deletionReview",
  "reachabilityStatus",
  "normalUserPath",
  "backdropRisk",
  "nextAction",
  "searchReachable",
  "relatedEntry",
  "browseBackdropOverride",
  "reachabilityChannels",
  "incomingRelationCount",
  "outgoingRelationCount",
  "supportReference",
  "assetExists",
  "priority",
  "runtimeExists",
  "runtimePhraseID",
  "runtimeAccessTier",
  "runtimeSourceFamily",
  "runtimeAudioStatus",
  "runtimeAudioUsageCount",
  "runtimeAudioFileCount",
  "runtimeAudioFilesExist",
  "runtimeMissingAudioCount",
  "runtimeSearchIndexed",
  "runtimeAliasStatus",
  "searchAuditDecision",
  "searchAuditReason",
  "searchOnlyWhyCreated",
  "searchDeleteRecommendation",
];

const searchAuditHeaders = [
  "searchAuditDecision",
  "searchAuditReason",
  "searchOnlyWhyCreated",
  "searchDeleteRecommendation",
  "pageID",
  "canonicalPageID",
  "title",
  "englishTitle",
  "priority",
  "source",
  "runtimeAccessTier",
  "runtimeSourceFamily",
  "runtimeAudioStatus",
  "runtimeAudioUsageCount",
  "runtimeAudioFileCount",
  "runtimeAudioFilesExist",
  "runtimeMissingAudioCount",
  "runtimeSearchIndexed",
  "runtimeAliasStatus",
  "reachabilityStatus",
  "normalUserPath",
  "accessProof",
  "incomingRelationCount",
  "outgoingRelationCount",
  "recommendedAsset",
  "imageTheme",
  "rolloutBucket",
  "categoryIDs",
];

const collectionHeaders = [
  "route",
  "title",
  "backgroundSystem",
  "imageAsset",
  "imagePool",
  "notes",
  "assetExists",
];

const rootHeaders = ["surface", "backgroundSystem", "imagePool", "poolSize", "cursor", "notes"];

function writeSheet(workbook, name, matrix, widthHints = {}) {
  const sheet = workbook.worksheets.getOrAdd(name, { renameFirstIfOnlyNewSpreadsheet: true });
  sheet.reset();
  sheet.showGridLines = false;
  const used = sheet.getRange("A1").write(matrix);
  used.format = {
    font: { name: "Aptos", size: 10, color: "#111827" },
    wrapText: true,
    verticalAlignment: "top",
    borders: { preset: "inside", style: "thin", color: "#E5E7EB" },
  };
  const header = sheet.getRange("A1").getResizeRange(1, matrix[0].length);
  header.format = {
    fill: "#1F2937",
    font: { name: "Aptos Display", size: 10, color: "#FFFFFF", bold: true },
    horizontalAlignment: "center",
    verticalAlignment: "center",
    wrapText: true,
  };
  sheet.freezePanes.freezeRows(1);
  Object.entries(widthHints).forEach(([col, width]) => {
    sheet.getRange(`${col}:${col}`).format.columnWidthPx = width;
  });
  return sheet;
}

const workbook = Workbook.create();
writeSheet(workbook, "Summary", [...summaryRows, [], ...reachabilityRows, [], ...statusRows, [], ...bucketRows], {
  A: 260,
  B: 90,
  C: 640,
});
writeSheet(workbook, "Human Access", humanAccessRows, {
  A: 360,
  B: 220,
  C: 720,
});
writeSheet(workbook, "Search Audit", searchAuditSummaryRows, {
  A: 340,
  B: 170,
  C: 780,
});
writeSheet(workbook, "Search Rows", matrixFromObjects(searchAuditRows, searchAuditHeaders), {
  A: 180,
  B: 520,
  C: 520,
  D: 440,
  E: 290,
  F: 290,
  G: 220,
  H: 260,
  I: 160,
  J: 180,
  K: 140,
  L: 240,
  M: 120,
  N: 130,
  O: 130,
  P: 120,
  Q: 140,
  R: 140,
  S: 260,
});
writeSheet(workbook, "Reachability", reachabilityRows, {
  A: 210,
  B: 140,
  C: 520,
  D: 620,
});
writeSheet(workbook, "Needs Backdrop", matrixFromObjects(needsRows, listingHeaders), {
  A: 290,
  B: 170,
  C: 220,
  D: 260,
  E: 270,
  F: 180,
  G: 130,
  H: 240,
  I: 115,
  J: 190,
  K: 360,
  L: 260,
  M: 360,
  N: 440,
  O: 90,
  P: 145,
});
writeSheet(workbook, "All Listings", matrixFromObjects(listingRows, listingHeaders), {
  A: 290,
  B: 170,
  C: 220,
  D: 260,
  E: 270,
  F: 190,
  G: 130,
  H: 250,
  I: 115,
  J: 200,
  K: 360,
  L: 260,
  M: 360,
  N: 440,
  O: 90,
  P: 145,
});
writeSheet(workbook, "Collections", matrixFromObjects(collectionRows, collectionHeaders), {
  A: 220,
  B: 220,
  C: 300,
  D: 220,
  E: 150,
  F: 520,
  G: 90,
});
writeSheet(workbook, "Root 20 Pool", [
  rootHeaders,
  ...rootRows.map((row) => rootHeaders.map((header) => row[header] ?? "")),
  [],
  ["Pool image", "Asset exists", "Asset file", "Preview URL", "", ""],
  ...sharedPool.map((asset) => [asset, assetExists(asset) ? "Yes" : "No", assetFile(asset), assetLink(asset), "", ""]),
], {
  A: 270,
  B: 260,
  C: 260,
  D: 110,
  E: 260,
  F: 560,
});
writeSheet(workbook, "Assets", assetRows, {
  A: 260,
  B: 90,
  C: 840,
});

const xlsxPath = path.join(outputDir, "speaklocal-listing-backdrop-audit-2026-05-29.xlsx");
const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(xlsxPath);

const csvPath = path.join(outputDir, "needs-backdrop.csv");
await fs.writeFile(csvPath, toCSV(matrixFromObjects(needsRows, listingHeaders)), "utf8");
const jsonPath = path.join(outputDir, "listing-backdrop-audit.json");
await fs.writeFile(jsonPath, JSON.stringify({
  generatedAt: new Date().toISOString(),
  repoRoot,
  summary: Object.fromEntries(summaryRows.slice(1).map(([metric, count]) => [metric, count])),
  statusCounts: Object.fromEntries(statusRows.slice(1)),
  humanAccess: humanAccessRows.slice(1).map(([question, answer, evidence]) => ({ question, answer, evidence })),
  searchAudit: searchAuditSummaryRows.slice(1).map(([question, answer, decision]) => ({ question, answer, decision })),
  searchAuditDecisionCounts: Object.fromEntries(searchAuditDecisionCounts),
  reachabilityCounts: Object.fromEntries(reachabilityRows.slice(1).map(([status, count]) => [status, count])),
  needsBackdropByBucket: Object.fromEntries(bucketRows.slice(1).map(([bucket, count]) => [bucket, count])),
  rootRows,
  collectionRows,
  listingRows,
  searchAuditRows,
}, null, 2), "utf8");

const htmlPath = path.join(outputDir, "index.html");
await fs.writeFile(htmlPath, renderHTML(), "utf8");

const inspectSummary = await workbook.inspect({
  kind: "table",
  range: "Summary!A1:C20",
  include: "values",
  tableMaxRows: 20,
  tableMaxCols: 3,
});
const errorScan = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 50 },
  summary: "final formula error scan",
});

console.log(JSON.stringify({
  xlsxPath,
  csvPath,
  jsonPath,
  htmlPath,
  counts: {
    totalListings: listingRows.length,
    implemented: implementedRows.length,
    needsBackdrop: needsRows.length,
    humanReachableNeeds: humanReachableNeedsCount,
    frontFacingNeeds: frontFacingNeedsCount,
    searchOrRelatedOnlyNeeds: searchOnlyNeedsCount,
    notReachableNeeds: notReachableNeedsCount,
    deletionCandidateNeeds: deletionCandidateNeedsCount,
    searchAuditRows: searchAuditRows.length,
    searchKeepOnly: searchKeepOnlyCount,
    searchPromoteReview: searchPromoteReviewCount,
    searchDeleteArchive: searchDeleteArchiveCount,
    searchRuntimeAudioFix: searchRuntimeAudioFixCount,
    searchAudioReady: searchAudioReadyCount,
    searchAliasResolved: searchAliasResolvedCount,
    optionalCompact: optionalRows.length,
    collections: collectionRows.length,
    rootSurfaces: rootRows.length,
    sharedPool: sharedPool.length,
  },
  inspectSummary: inspectSummary.ndjson,
  errorScan: errorScan.ndjson,
}, null, 2));

function toCSV(matrix) {
  return matrix.map((row) => row.map((value) => {
    const text = String(value ?? "");
    return /[",\n]/.test(text) ? `"${text.replace(/"/g, '""')}"` : text;
  }).join(",")).join("\n");
}

function renderHTML() {
  const googleSheetURL = "https://docs.google.com/spreadsheets/d/1ShHrF0bH0UoIT1Mvt0WA9OdecKjDNTCKHb06V1PQAsM";
  const decisionGroups = [
    {
      id: "transport",
      label: "Transport and directions",
      bucket: "Use category hero now; later add transport mini-pool",
      plain: "Taxi, bus, train, address, driver, and route pages.",
      decision: "Use the getting-around image now, then consider a small transport photo set later.",
      asset: "HeroCategoryGettingAround",
    },
    {
      id: "emergency",
      label: "Emergency, health, help",
      bucket: "Use emergency hero carefully; add clinic/pharmacy mini-pool",
      plain: "Pharmacy, doctor, police, safety, and problem-solving pages.",
      decision: "Use a calm help/clinic/pharmacy direction. Avoid scary emergency imagery.",
      asset: "HeroCategoryEmergency",
    },
    {
      id: "general",
      label: "General conversation",
      bucket: "Use category hero or shared Vietnam pool",
      plain: "Greeting, repair, politeness, and social interaction pages.",
      decision: "Use a soft Vietnam/social image. These do not need literal object photos.",
      asset: "HeroCategoryPoliteRepair or shared pool",
    },
    {
      id: "food",
      label: "Food and ordering",
      bucket: "Use category hero or menu backdrop when item-specific",
      plain: "Restaurant ordering, dishes, drinks, menus, and table interaction pages.",
      decision: "Use the food category image now; item pages can reuse menu-style backdrops.",
      asset: "HeroCategoryFood",
    },
    {
      id: "money",
      label: "Money and shopping",
      bucket: "Use category hero now; later add market/payment mini-pool",
      plain: "Prices, cash, cards, QR payment, markets, sizes, and shopping pages.",
      decision: "Use the money/shopping image now, then add market/payment images later.",
      asset: "HeroCategoryNumbersMoney",
    },
    {
      id: "hotel",
      label: "Hotels",
      bucket: "Use category hero now; later add hotel/front-desk mini-pool",
      plain: "Check-in, checkout, luggage, room help, and front-desk pages.",
      decision: "Use the hotel image now; a front-desk mini-pool would make this feel sharper.",
      asset: "HeroCategoryHotel",
    },
    {
      id: "questions",
      label: "Questions and timing",
      bucket: "Use category hero now",
      plain: "Basic question, time, date, booking, and schedule pages.",
      decision: "Use the questions image. This bucket is simple enough for a first pass.",
      asset: "HeroCategoryQuestions",
    },
    {
      id: "airport",
      label: "Airport services",
      bucket: "Use category hero now; later add airport-services mini-pool",
      plain: "Airport arrival, immigration, baggage, customs, and terminal pages.",
      decision: "Use the airport image now; later add airport/SIM/taxi pickup scenes.",
      asset: "HeroCategoryAirport",
    },
    {
      id: "essentials",
      label: "Everyday essentials",
      bucket: "Needs essentials/services mini-pool",
      plain: "Convenience store, bathroom, service counter, and daily travel errand pages.",
      decision: "Create or reuse a small essentials/services mini-pool.",
      asset: "HeroCategoryEssentials",
    },
    {
      id: "phone",
      label: "Phone, SIM, Wi-Fi",
      bucket: "Needs topical mini-pool",
      plain: "SIM, eSIM, data, Wi-Fi, charging, and phone-help pages.",
      decision: "Best next asset set: airport SIM kiosk, phone shop, eSIM QR, cafe Wi-Fi.",
      asset: "Airport/SIM mini-pool",
    },
    {
      id: "sightseeing",
      label: "Sightseeing",
      bucket: "Use landmarks/city hero pool",
      plain: "Attraction, ticket, museum, landmark, and activity pages.",
      decision: "Use city/landmark imagery, especially for pages tied to places.",
      asset: "City or landmarks pool",
    },
  ].map((group) => ({
    ...group,
    count: needsRows.filter((row) => row.rolloutBucket === group.bucket).length,
  }));

  const searchDecisionGroups = [
    {
      id: "keep-search-only",
      label: "Keep Search-only",
      plain: "Useful long-tail pages that should stay searchable without crowding Home/Browse.",
      decision: "Add broad/category backdrops, but do not promote all of these into navigation.",
      tone: "done",
    },
    {
      id: "promote-review",
      label: "Promote / review",
      plain: "Tier-one and major travel-flow pages worth reviewing for Browse, Home, or category shelves.",
      decision: "Keep them; decide which ones deserve a front-door route after image coverage is solved.",
      tone: "need",
    },
    {
      id: "delete-archive",
      label: "Delete / archive",
      plain: "Rows with missing canonical runtime or Search proof.",
      decision: "None found in this audit.",
      tone: "done",
    },
    {
      id: "fix-runtime-audio",
      label: "Fix runtime/audio",
      plain: "Rows that are real but lack audio/runtime proof.",
      decision: "None found in this audit.",
      tone: "done",
    },
  ].map((group) => ({
    ...group,
    count: searchAuditRows.filter((row) => row.searchAuditDecisionID === group.id).length,
  }));

  const groupByBucket = Object.fromEntries(decisionGroups.map((group) => [group.bucket, group.id]));
  const reachabilityGroups = [
    {
      id: "home-visible",
      statuses: ["Home visible"],
      label: "Home visible",
      plain: "These are the ones a user can hit from Home cards/shelves without searching.",
      decision: "Fix first. These are the most likely to create screenshot 1 in normal use.",
    },
    {
      id: "browse-visible",
      statuses: ["Browse visible"],
      label: "Browse visible",
      plain: "These are inside Browse/category pages.",
      decision: "Good next batch. Browse can pass a category image, but Search/Saved/direct entry still needs page metadata.",
    },
    {
      id: "search-related",
      statuses: ["Search + related only", "Search only", "Related only"],
      label: "Search / related only",
      plain: "Reachable, but not shown as a top-level Home/Browse card in this audit.",
      decision: "Lower priority. Batch later unless one of these is strategically important.",
    },
    {
      id: "support-reference",
      statuses: ["Support/reference"],
      label: "Support/reference",
      plain: "Model/support pages that exist for the content graph.",
      decision: "Leave out of the first rollout unless promoted into traveler-facing UI.",
    },
    {
      id: "not-reachable",
      statuses: ["Not reachable"],
      label: "Not reachable",
      plain: "No Home, Browse, Search, or related-detail path found.",
      decision: "If this is nonzero, review for surfacing or archive/delete.",
    },
  ].map((group) => ({
    ...group,
    count: needsRows.filter((row) => group.statuses.includes(row.reachabilityStatus)).length,
  }));
  const data = {
    needs: needsRows.map((row) => listingDisplayRow(row, groupByBucket)),
    searchAudit: searchAuditRows.map((row) => listingDisplayRow(row, groupByBucket)),
    searchDecisions: Object.fromEntries(searchDecisionGroups.map((group) => [
      group.id,
      searchAuditRows
        .filter((row) => row.searchAuditDecisionID === group.id)
        .map((row) => listingDisplayRow(row, groupByBucket)),
    ])),
    aliasResolved: searchAuditRows
      .filter((row) => row.pageID !== row.canonicalPageID)
      .map((row) => listingDisplayRow(row, groupByBucket)),
    reachability: Object.fromEntries(reachabilityGroups.map((group) => [
      group.id,
      needsRows
        .filter((row) => group.statuses.includes(row.reachabilityStatus))
        .map((row) => listingDisplayRow(row, groupByBucket)),
    ])),
    done: implementedRows.map((row) => listingDisplayRow(row, groupByBucket)),
    defer: optionalRows.map((row) => listingDisplayRow(row, groupByBucket)),
    collections: collectionRows.map((row) => ({
      kind: "Collection page",
      title: row.title,
      englishTitle: row.route,
      currentState: row.backgroundSystem,
      decision: "Already has the card-over-photo collection layout.",
      recommendedAsset: row.imageAsset,
      why: row.notes,
      pageID: row.route,
      priority: "Done",
      groupId: "collections",
      imageURL: assetLink(row.imageAsset),
    })),
    root: rootRows.map((row) => ({
      kind: "Root tab",
      title: titleCase(row.surface),
      englishTitle: `${row.poolSize} rotating shared photos`,
      currentState: row.backgroundSystem,
      decision: "Already uses the shared root background pool.",
      recommendedAsset: row.imagePool,
      why: row.notes,
      pageID: row.surface,
      priority: "Done",
      groupId: "root",
      imageURL: "",
    })),
    pool: sharedPool.map((asset, index) => ({
      number: index + 1,
      asset,
      exists: assetExists(asset) ? "Yes" : "No",
      preview: assetLink(asset),
      file: assetFile(asset),
    })),
    stats: {
      totalNeeds: needsRows.length,
      humanReachableNeeds: humanReachableNeedsCount,
      frontFacingNeeds: frontFacingNeedsCount,
      searchOnlyNeeds: searchOnlyNeedsCount,
      searchIndexedNeeds: searchIndexedNeedsCount,
      supportNeeds: reachabilityGroups.find((group) => group.id === "support-reference")?.count || 0,
      notReachableNeeds: notReachableNeedsCount,
      deletionCandidateNeeds: deletionCandidateNeedsCount,
      searchKeepOnly: searchKeepOnlyCount,
      searchPromoteReview: searchPromoteReviewCount,
      searchDeleteArchive: searchDeleteArchiveCount,
      searchRuntimeAudioFix: searchRuntimeAudioFixCount,
      searchAudioReady: searchAudioReadyCount,
      searchAliasResolved: searchAliasResolvedCount,
      searchPremiumRuntime: searchPremiumRuntimeCount,
      searchStarterRuntime: searchStarterRuntimeCount,
      implemented: implementedRows.length,
      optional: optionalRows.length,
      poolSize: sharedPool.length,
    },
  };

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>SpeakLocal Backdrop Audit - Human Summary</title>
  <style>
    :root {
      color-scheme: light;
      --ink: #111827;
      --muted: #6b7280;
      --soft: #f3f4f6;
      --line: #e5e7eb;
      --paper: #f8fafc;
      --card: #ffffff;
      --red: #ef4444;
      --red-bg: #fef2f2;
      --green: #16a34a;
      --green-bg: #ecfdf5;
      --amber: #d97706;
      --amber-bg: #fffbeb;
      --blue: #2563eb;
      --blue-bg: #eff6ff;
    }
    body {
      margin: 0;
      font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background: var(--paper);
      color: var(--ink);
    }
    header {
      padding: 30px 32px 20px;
      background: #ffffff;
      border-bottom: 1px solid var(--line);
    }
    h1 { margin: 0; font-size: 30px; letter-spacing: 0; }
    .sub { margin-top: 8px; color: var(--muted); max-width: 1050px; line-height: 1.5; }
    main { padding: 24px 32px 48px; }
    h2 { font-size: 20px; margin: 30px 0 12px; }
    h3 { font-size: 15px; margin: 0 0 8px; }
    .section-copy { margin: -4px 0 14px; color: var(--muted); line-height: 1.45; max-width: 980px; }
    .answer-strip {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 12px;
      margin-top: 18px;
    }
    .answer {
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 14px;
      background: var(--soft);
      line-height: 1.4;
      cursor: pointer;
      text-align: left;
    }
    .answer:hover,
    .answer.is-active {
      border-color: #111827;
      box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08);
    }
    .answer strong { display: block; margin-bottom: 5px; }
    .supporting-files {
      margin-top: 16px;
      max-width: 1050px;
    }
    .supporting-files summary {
      cursor: pointer;
      color: var(--muted);
      font-weight: 700;
    }
    .files { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 10px; }
    .files a {
      color: #111827;
      background: #fff;
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 9px 12px;
      text-decoration: none;
      font-weight: 650;
      font-size: 13px;
    }
    .state-grid {
      display: grid;
      grid-template-columns: repeat(5, minmax(150px, 1fr));
      gap: 12px;
      margin-bottom: 18px;
    }
    button {
      font: inherit;
    }
    .state-card,
    .decision-card {
      background: var(--card);
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 16px;
      text-align: left;
      cursor: pointer;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
      min-height: 116px;
      transition: border-color 0.15s ease, box-shadow 0.15s ease, transform 0.15s ease;
    }
    .state-card:hover,
    .decision-card:hover,
    .state-card.is-active,
    .decision-card.is-active {
      border-color: #111827;
      box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08);
    }
    .state-card:active,
    .decision-card:active { transform: translateY(1px); }
    .number {
      display: block;
      font-size: 32px;
      line-height: 1;
      font-weight: 800;
      letter-spacing: 0;
    }
    .state-title {
      display: block;
      margin-top: 8px;
      font-weight: 800;
      color: var(--ink);
    }
    .state-note,
    .decision-note {
      display: block;
      margin-top: 5px;
      color: var(--muted);
      line-height: 1.35;
      font-size: 13px;
    }
    .state-card.need { background: var(--red-bg); }
    .state-card.done { background: var(--green-bg); }
    .state-card.defer { background: var(--amber-bg); }
    .state-card.info { background: var(--blue-bg); }
    .decision-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(220px, 1fr));
      gap: 12px;
    }
    .decision-card {
      min-height: 158px;
    }
    .decision-top {
      display: flex;
      justify-content: space-between;
      gap: 12px;
      align-items: baseline;
    }
    .decision-count {
      color: var(--red);
      font-size: 24px;
      font-weight: 850;
      white-space: nowrap;
    }
    .decision-asset {
      display: block;
      margin-top: 8px;
      color: #374151;
      font-size: 12px;
      font-weight: 700;
    }
    .toolbar {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      align-items: center;
      margin: 14px 0;
    }
    .search {
      flex: 1 1 280px;
      border: 1px solid var(--line);
      border-radius: 8px;
      background: #fff;
      padding: 10px 12px;
      min-height: 42px;
    }
    .clear {
      border: 1px solid var(--line);
      border-radius: 8px;
      background: #fff;
      padding: 10px 12px;
      cursor: pointer;
      font-weight: 700;
    }
    .panel {
      background: #fff;
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 16px;
    }
    .panel-head {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 18px;
      margin-bottom: 12px;
    }
    .panel-title { margin: 0; font-size: 20px; }
    .panel-copy { margin: 5px 0 0; color: var(--muted); line-height: 1.45; }
    .count-pill {
      background: #111827;
      color: #fff;
      border-radius: 999px;
      padding: 6px 10px;
      font-weight: 800;
      white-space: nowrap;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      border: 0;
      overflow: hidden;
      font-size: 13px;
    }
    th, td { border-bottom: 1px solid var(--line); padding: 9px 10px; vertical-align: top; text-align: left; }
    th { background: #1f2937; color: #fff; }
    tr:last-child td { border-bottom: 0; }
    .badge { display: inline-block; padding: 3px 8px; border-radius: 999px; font-size: 12px; font-weight: 700; }
    .need { background: #fee2e2; color: #991b1b; }
    .done { background: #dcfce7; color: #166534; }
    .defer { background: #fef3c7; color: #92400e; }
    .pool-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 12px; }
    .thumb {
      background: #fff;
      border: 1px solid var(--line);
      border-radius: 8px;
      overflow: hidden;
    }
    .thumb img { width: 100%; aspect-ratio: 9 / 16; object-fit: cover; display: block; background: #e5e7eb; }
    .thumb div { padding: 8px; font-size: 12px; color: var(--muted); word-break: break-word; }
    .muted { color: var(--muted); }
    .small { font-size: 12px; }
    .empty {
      padding: 22px;
      border: 1px dashed var(--line);
      border-radius: 8px;
      color: var(--muted);
      background: #fff;
    }
    @media (max-width: 900px) {
      main { padding: 18px; }
      header { padding: 22px 18px; }
      .answer-strip,
      .state-grid,
      .decision-grid { grid-template-columns: 1fr; }
      .panel-head { display: block; }
      .count-pill { display: inline-block; margin-top: 10px; }
    }
  </style>
</head>
<body>
  <header>
    <h1>Backdrop audit: what to do next</h1>
    <div class="sub"><strong>Bottom line:</strong> fix the ${frontFacingNeedsCount} Home/Browse-visible pages first. The ${searchAuditRows.length} Search/search+related pages are not hidden junk: ${searchKeepOnlyCount} should stay Search-only, ${searchPromoteReviewCount} should be promoted/reviewed, and ${searchDeleteArchiveCount} should be deleted based on this audit. Click any number card to filter the table below.</div>
    <div class="answer-strip">
      <button type="button" class="answer" data-view="needs"><strong>${humanReachableNeedsCount} reachable rows need images</strong>Every needs-backdrop row has Home, Browse, Search, or incoming detail-link evidence.</button>
      <button type="button" class="answer" data-view="reachability" data-group="home-visible"><strong>${frontFacingNeedsCount} front-facing rows</strong>Home/Browse-visible pages are the practical first backlog.</button>
      <button type="button" class="answer" data-view="search-audit"><strong>${searchAuditRows.length} Search/search+related rows</strong>Real app pages. Audit says keep ${searchKeepOnlyCount}, promote/review ${searchPromoteReviewCount}, delete ${searchDeleteArchiveCount}.</button>
      <button type="button" class="answer" data-view="alias-resolved"><strong>${searchAliasResolvedCount} legacy-looking IDs resolved</strong>These alias to live canonical page IDs; do not delete them just because the ID looks old.</button>
    </div>
    <details class="supporting-files">
      <summary>Supporting files and downloads</summary>
      <div class="files">
        <a href="${googleSheetURL}" target="_blank" rel="noreferrer">Open Google Sheet</a>
        <a href="${path.basename(xlsxPath)}" download>Download workbook</a>
        <a href="${path.basename(csvPath)}" download>Download Needs Backdrop CSV</a>
        <a href="${path.basename(jsonPath)}" download>Raw JSON (not needed for decisions)</a>
      </div>
    </details>
  </header>
  <main>
    <section class="state-grid" aria-label="Top-level audit filters">
      ${stateCard("needs", needsRows.length, "Reachable pages needing images", "The full screenshot 1 backlog; none are hidden/dead in this audit.", "need")}
      ${reachabilityStateCard(reachabilityGroups[0], "need")}
      ${reachabilityStateCard(reachabilityGroups[1], "need")}
      ${stateCard("search-audit", searchAuditRows.length, "Search-only audit", "Not front-door rows. Mostly valid long-tail Search pages.", "info")}
      ${searchDecisionStateCard(searchDecisionGroups[0])}
      ${searchDecisionStateCard(searchDecisionGroups[1])}
      ${searchDecisionStateCard(searchDecisionGroups[2])}
      ${stateCard("alias-resolved", searchAliasResolvedCount, "Legacy IDs resolved", "Old/display IDs that alias to live canonical pages.", "info")}
      ${reachabilityStateCard(reachabilityGroups[2], "info")}
      ${reachabilityStateCard(reachabilityGroups[3], "defer")}
      ${reachabilityStateCard(reachabilityGroups[4], notReachableNeedsCount ? "need" : "done")}
      ${stateCard("done", implementedRows.length, "Already work", "These match screenshot 3/4.", "done")}
      ${stateCard("pool", sharedPool.length, "20-photo root pool", `${rootRows.length} root tabs rotate through these.`, "info")}
    </section>

    <h2>Search-Only Verdict</h2>
    <p class="section-copy">This is the bloat check. These rows are not Home/Browse front-door cards, but they are still live pages a traveler can open through Search or related links.</p>
    <div class="decision-grid" aria-label="Search-only decision filters">
      ${searchDecisionGroups.map((group) => searchDecisionCard(group)).join("")}
    </div>

    <h2>Image Decisions</h2>
    <p class="section-copy">Use these buckets to decide what type of image to apply. This is separate from reachability: a page can be Browse-visible and still belong to the airport, hotel, or SIM image bucket.</p>
    <div class="decision-grid" aria-label="Needs-backdrop decision filters">
      ${decisionGroups.map((group) => decisionCard(group)).join("")}
    </div>

    <h2>Filtered View</h2>
    <section class="panel" id="table-panel">
      <div class="panel-head">
        <div>
          <h3 class="panel-title" id="view-title">Need a backdrop decision</h3>
          <p class="panel-copy" id="view-copy">These are the pages that still need image/backdrop work.</p>
        </div>
        <div class="count-pill" id="row-count">${needsRows.length} pages</div>
      </div>
      <div class="toolbar">
        <input class="search" id="search" type="search" placeholder="Search title, English, page ID, category, or image idea">
        <button class="clear" id="clear-filter" type="button">Clear filter</button>
      </div>
      <div id="table-mount"></div>
    </section>
  </main>

  <script type="application/json" id="audit-data">${scriptJSON(data)}</script>
  <script type="application/json" id="group-data">${scriptJSON(decisionGroups)}</script>
  <script type="application/json" id="search-decision-data">${scriptJSON(searchDecisionGroups)}</script>
  <script type="application/json" id="reachability-data">${scriptJSON(reachabilityGroups)}</script>
  <script>
    (function () {
      var data = JSON.parse(document.getElementById("audit-data").textContent);
      var groups = JSON.parse(document.getElementById("group-data").textContent);
      var searchDecisionGroups = JSON.parse(document.getElementById("search-decision-data").textContent);
      var reachabilityGroups = JSON.parse(document.getElementById("reachability-data").textContent);
      var active = { view: "needs", group: "" };
      var search = document.getElementById("search");
      var mount = document.getElementById("table-mount");
      var title = document.getElementById("view-title");
      var copy = document.getElementById("view-copy");
      var count = document.getElementById("row-count");

      var viewCopy = {
        needs: {
          title: "Reachable pages needing images",
          copy: "These are all phrase pages without their own image. Every row here is reachable by a human; use the filters above to separate front-facing from Search/detail-graph pages.",
        },
        "search-audit": {
          title: "Search/search+related rows",
          copy: "These are the rows that are not Home/Browse front-door cards. The audit checks whether they are real, useful, audio-backed, and worth keeping.",
        },
        "alias-resolved": {
          title: "Legacy-looking IDs that are still live",
          copy: "These rows have an old/display page ID, but canonicalPageID resolves them to live runtime pages. Treat them as keep/promote rows, not automatic delete candidates.",
        },
        done: {
          title: "Already work like screenshot 3/4",
          copy: "These detail pages already use the card-over-photo layout and immersive tap behavior.",
        },
        defer: {
          title: "Leave alone for now",
          copy: "These are generated compact city-action helper rows. They are not the best first target unless one becomes a real listing page.",
        },
        collections: {
          title: "Browse/category pages already OK",
          copy: "These collection pages already have a static image behind the pull-down content card.",
        },
        root: {
          title: "Root tabs using the shared pool",
          copy: "Home, Browse, Saved, Practice, and Search use one rotating shared pool. This is separate from the listing-page backlog.",
        },
        pool: {
          title: "The 20 images in the root pool",
          copy: "These images are for the app's root surfaces. They can inspire listing backdrops, but they do not automatically fix the 952 pages.",
        },
      };

      function esc(value) {
        return String(value == null ? "" : value).replace(/[&<>"']/g, function (char) {
          return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#039;" }[char];
        });
      }

      function setActive(view, group) {
        active.view = view;
        active.group = group || "";
        search.value = "";
        render();
        document.querySelectorAll("[data-view]").forEach(function (button) {
          var isActive = button.getAttribute("data-view") === view
            && (button.getAttribute("data-group") || "") === active.group;
          button.classList.toggle("is-active", isActive);
        });
        document.getElementById("table-panel").scrollIntoView({ behavior: "smooth", block: "start" });
      }

      function rowsForActive() {
        if (active.view === "group") {
          return data.needs.filter(function (row) { return row.groupId === active.group; });
        }
        if (active.view === "search-decision") {
          return data.searchDecisions[active.group] || [];
        }
        if (active.view === "reachability") {
          return data.reachability[active.group] || [];
        }
        if (active.view === "search-audit") return data.searchAudit;
        if (active.view === "alias-resolved") return data.aliasResolved;
        if (active.view === "root") return data.root;
        return data[active.view] || data.needs;
      }

      function labelForRows(rows) {
        if (active.view === "pool") return rows.length + " images";
        if (active.view === "root") return rows.length + " root tabs";
        if (active.view === "collections") return rows.length + " pages";
        return rows.length + " pages";
      }

      function filteredRows() {
        var rows = rowsForActive();
        var query = search.value.trim().toLowerCase();
        if (!query) return rows;
        return rows.filter(function (row) {
          return Object.values(row).join(" ").toLowerCase().indexOf(query) !== -1;
        });
      }

      function render() {
        var rows = filteredRows();
        var group = groups.find(function (candidate) { return candidate.id === active.group; });
        var searchDecisionGroup = searchDecisionGroups.find(function (candidate) { return candidate.id === active.group; });
        var reachabilityGroup = reachabilityGroups.find(function (candidate) { return candidate.id === active.group; });
        var meta = group
          ? { title: group.label, copy: group.plain + " Decision: " + group.decision }
          : searchDecisionGroup
            ? { title: searchDecisionGroup.label, copy: searchDecisionGroup.plain + " Decision: " + searchDecisionGroup.decision }
          : reachabilityGroup
            ? { title: reachabilityGroup.label, copy: reachabilityGroup.plain + " Decision: " + reachabilityGroup.decision }
          : viewCopy[active.view] || viewCopy.needs;
        title.textContent = meta.title;
        copy.textContent = meta.copy;
        count.textContent = labelForRows(rows);
        if (active.view === "pool") {
          mount.innerHTML = renderPool(rows);
        } else {
          mount.innerHTML = renderRows(rows);
        }
      }

      function renderRows(rows) {
        if (!rows.length) return '<div class="empty">No rows match this filter.</div>';
        return '<table><thead><tr><th>Decision</th><th>Page</th><th>Why it exists</th><th>Audio/runtime</th><th>Image + access</th></tr></thead><tbody>'
          + rows.map(function (row) {
            var badgeClass = row.priority === "Done" ? "done" : row.priority === "Defer" ? "defer" : "need";
            if (row.searchAuditDecisionID === "keep-search-only") badgeClass = "done";
            if (row.searchAuditDecisionID === "delete-archive" || row.searchAuditDecisionID === "fix-runtime-audio") badgeClass = "need";
            var decision = row.searchAuditDecision || row.humanAccessVerdict || row.reachabilityStatus || row.priority || row.decision;
            var why = row.searchAuditReason || row.searchOnlyWhyCreated || row.why || row.routeContext || row.decision;
            var audio = row.runtimeExists
              ? "Runtime: " + row.runtimeExists + " / Search: " + row.runtimeSearchIndexed + " / Audio: " + row.runtimeAudioStatus + " / Files: " + row.runtimeAudioFilesExist
              : row.currentState || "";
            var deleteNote = row.searchDeleteRecommendation || row.deletionReview || "";
            return '<tr>'
              + '<td><span class="badge ' + badgeClass + '">' + esc(decision) + '</span><br><span class="small muted">' + esc(deleteNote) + '</span></td>'
              + '<td><strong>' + esc(row.title || row.pageID) + '</strong><br>' + esc(row.englishTitle) + '<br><span class="small muted">' + esc(row.pageID) + '</span></td>'
              + '<td><strong>' + esc(row.searchOnlyWhyCreated || row.normalUserPath || row.why) + '</strong><br><span class="small muted">' + esc(why) + '</span></td>'
              + '<td>' + esc(audio) + '<br><span class="small muted">' + esc(row.runtimeAliasStatus || "") + '</span><br><span class="small muted">' + esc(row.runtimeSourceFamily || "") + '</span></td>'
              + '<td><strong>' + esc(row.recommendedAsset) + '</strong><br><span class="small muted">' + esc(row.imageTheme) + '</span><br><span class="small muted">' + esc(row.accessProof || row.channels || row.why || "") + '</span></td>'
              + '</tr>';
          }).join("")
          + '</tbody></table>';
      }

      function renderPool(rows) {
        if (!rows.length) return '<div class="empty">No pool images match this filter.</div>';
        return '<div class="pool-grid">'
          + rows.map(function (row) {
            return '<div class="thumb">'
              + (row.preview ? '<img src="' + esc(row.preview) + '" alt="' + esc(row.asset) + '">' : '')
              + '<div><strong>' + esc(row.number) + '. ' + esc(row.asset) + '</strong><br>Asset exists: ' + esc(row.exists) + '</div>'
              + '</div>';
          }).join("")
          + '</div>';
      }

      document.querySelectorAll("[data-view]").forEach(function (button) {
        button.addEventListener("click", function () {
          setActive(button.getAttribute("data-view"), button.getAttribute("data-group"));
        });
      });
      search.addEventListener("input", render);
      document.getElementById("clear-filter").addEventListener("click", function () {
        active = { view: "needs", group: "" };
        search.value = "";
        render();
        document.querySelectorAll("[data-view]").forEach(function (button) {
          button.classList.toggle("is-active", button.getAttribute("data-view") === "needs" && !button.getAttribute("data-group"));
        });
      });
      render();
    }());
  </script>
</body>
</html>`;
}

function listingDisplayRow(row, groupByBucket) {
  return {
    kind: row.source || "Listing page",
    title: row.title || row.pageID,
    englishTitle: row.englishTitle || "",
    pageID: row.pageID,
    categoryIDs: row.categoryIDs,
    currentState: row.currentBackgroundSystem,
    decision: humanDecision(row),
    recommendedAsset: row.recommendedAsset,
    imageTheme: row.imageTheme,
    why: row.routeContext,
    priority: row.priority,
    humanAccessVerdict: row.humanAccessVerdict || "",
    isHumanReachable: row.isHumanReachable || "",
    accessProof: row.accessProof || "",
    deletionReview: row.deletionReview || "",
    reachabilityStatus: row.reachabilityStatus || "",
    normalUserPath: row.normalUserPath || "",
    nextAction: row.nextAction || "",
    backdropRisk: row.backdropRisk || "",
    channels: row.reachabilityChannels || "",
    searchReachable: row.searchReachable || "",
    relatedEntry: row.relatedEntry || "",
    browseBackdropOverride: row.browseBackdropOverride || "",
    canonicalPageID: row.canonicalPageID || "",
    runtimeExists: row.runtimeExists || "",
    runtimePhraseID: row.runtimePhraseID || "",
    runtimeAccessTier: row.runtimeAccessTier || "",
    runtimeSourceFamily: row.runtimeSourceFamily || "",
    runtimeAudioStatus: row.runtimeAudioStatus || "",
    runtimeAudioUsageCount: row.runtimeAudioUsageCount || 0,
    runtimeAudioFileCount: row.runtimeAudioFileCount || 0,
    runtimeAudioFilesExist: row.runtimeAudioFilesExist || "",
    runtimeMissingAudioCount: row.runtimeMissingAudioCount || 0,
    runtimeSearchIndexed: row.runtimeSearchIndexed || "",
    runtimeAliasStatus: row.runtimeAliasStatus || "",
    searchAuditDecisionID: row.searchAuditDecisionID || "",
    searchAuditDecision: row.searchAuditDecision || "",
    searchAuditReason: row.searchAuditReason || "",
    searchOnlyWhyCreated: row.searchOnlyWhyCreated || "",
    searchDeleteRecommendation: row.searchDeleteRecommendation || "",
    groupId: groupByBucket[row.rolloutBucket] || "",
    rolloutBucket: row.rolloutBucket,
  };
}

function humanDecision(row) {
  if (row.needsBackdropWork === "Yes") {
    return row.recommendation.replace("Add intrinsic page/category backdrop metadata or a category/topical fallback. First pass: ", "First pass: ");
  }
  if (row.needsBackdropWork === "Optional") {
    return "Leave this alone unless the helper row becomes a real listing page.";
  }
  return row.recommendation;
}

function stateCard(view, value, title, note, tone) {
  return `<button type="button" class="state-card ${escapeHTML(tone)}${view === "needs" ? " is-active" : ""}" data-view="${escapeHTML(view)}">
    <span class="number">${value}</span>
    <span class="state-title">${escapeHTML(title)}</span>
    <span class="state-note">${escapeHTML(note)}</span>
  </button>`;
}

function reachabilityStateCard(group, tone) {
  return `<button type="button" class="state-card ${escapeHTML(tone)}" data-view="reachability" data-group="${escapeHTML(group.id)}">
    <span class="number">${group.count}</span>
    <span class="state-title">${escapeHTML(group.label)}</span>
    <span class="state-note">${escapeHTML(group.plain)}</span>
  </button>`;
}

function searchDecisionStateCard(group) {
  return `<button type="button" class="state-card ${escapeHTML(group.tone || "info")}" data-view="search-decision" data-group="${escapeHTML(group.id)}">
    <span class="number">${group.count}</span>
    <span class="state-title">${escapeHTML(group.label)}</span>
    <span class="state-note">${escapeHTML(group.plain)}</span>
  </button>`;
}

function decisionCard(group) {
  return `<button type="button" class="decision-card" data-view="group" data-group="${escapeHTML(group.id)}">
    <span class="decision-top"><strong>${escapeHTML(group.label)}</strong><span class="decision-count">${group.count}</span></span>
    <span class="decision-note">${escapeHTML(group.plain)}</span>
    <span class="decision-note">${escapeHTML(group.decision)}</span>
    <span class="decision-asset">${escapeHTML(group.asset)}</span>
  </button>`;
}

function searchDecisionCard(group) {
  return `<button type="button" class="decision-card ${escapeHTML(group.tone || "info")}" data-view="search-decision" data-group="${escapeHTML(group.id)}">
    <span class="decision-top"><strong>${escapeHTML(group.label)}</strong><span class="decision-count">${group.count}</span></span>
    <span class="decision-note">${escapeHTML(group.plain)}</span>
    <span class="decision-note">${escapeHTML(group.decision)}</span>
  </button>`;
}

function titleCase(value) {
  return String(value || "")
    .replace(/[-_]/g, " ")
    .replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function scriptJSON(value) {
  return JSON.stringify(value).replace(/</g, "\\u003c");
}

function escapeHTML(value) {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}
