#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const auditPath = path.join(repoRoot, "docs", "task-results", "listing-backdrop-audit-2026-05-29", "listing-backdrop-audit.json");
const outputPath = path.join(repoRoot, "content-draft", "viet", "phrase-backdrops-v1.json");
const assetsRoot = path.join(nativeRoot, "Resources", "Assets.xcassets");

const semanticPools = {
  "airport-services": [
    "BackdropPhraseTransportAirportCurb",
    "BackdropPhrasePhoneSimSetup",
    "BackdropPhrasePhoneAirportCharging",
    "BackdropPhraseTransportTaxiCurb",
  ],
  "calm-help-health": [
    "BackdropPhraseHealthPharmacyCounter",
    "BackdropPhraseHealthClinicReception",
    "BackdropPhraseHelpHotelDesk",
    "BackdropPhraseHelpQuietServiceDesk",
  ],
  "everyday-services": [
    "BackdropPhraseEssentialsWaterCounter",
    "BackdropPhraseEssentialsWashroomSink",
    "BackdropPhraseEssentialsLaundryCopy",
    "BackdropPhraseEssentialsPersonalCare",
  ],
  "food-ordering": [
    "BackdropPhraseFoodOrderCounter",
  ],
  "greetings-conversation": [
    "BackdropPhraseGreetingCafeDoorway",
  ],
  "hotel-front-desk": [
    "BackdropPhraseHelpHotelDesk",
  ],
  "market-payment": [
    "BackdropPhraseMarketPayment",
  ],
  "phone-connectivity": [
    "BackdropPhrasePhoneCafeCharging",
    "BackdropPhrasePhoneSimSetup",
    "BackdropPhrasePhoneAccessoryCounter",
    "BackdropPhrasePhoneAirportCharging",
    "BackdropPhraseTransportStreetMap",
  ],
  "polite-repair": [
    "BackdropPhraseGreetingCafeDoorway",
    "BackdropPhraseHelpQuietServiceDesk",
    "BackdropPhraseHelpHotelDesk",
  ],
  "questions-info": [
    "BackdropPhraseSightTicketBooth",
    "BackdropPhraseHelpQuietServiceDesk",
  ],
  "sightseeing-info": [
    "BackdropPhraseSightTicketBooth",
  ],
  "transport-directions": [
    "BackdropPhraseTransportTaxiCurb",
    "BackdropPhraseTransportStationPlatform",
    "BackdropPhraseTransportStreetMap",
    "BackdropPhraseTransportAirportCurb",
  ],
};

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function assetExists(assetName) {
  return fs.existsSync(path.join(assetsRoot, `${assetName}.imageset`, "Contents.json"));
}

function stableIndex(value, count) {
  let hash = 0;
  for (const char of String(value)) {
    hash = (hash * 31 + char.charCodeAt(0)) >>> 0;
  }
  return hash % count;
}

function selectPool(row) {
  const bucket = row.rolloutBucket || "";

  if (bucket.includes("topical mini-pool")) return "phone-connectivity";
  if (bucket.includes("essentials/services")) return "everyday-services";
  if (bucket.includes("emergency hero carefully")) return "calm-help-health";
  if (bucket.includes("transport mini-pool")) return "transport-directions";
  if (bucket.includes("hotel/front-desk")) return "hotel-front-desk";
  if (bucket.includes("menu backdrop")) return "food-ordering";
  if (bucket.includes("market/payment")) return "market-payment";
  if (bucket.includes("airport-services")) return "airport-services";
  if (bucket.includes("landmarks/city")) return "sightseeing-info";
  if (bucket === "Use category hero now") return "questions-info";
  if (bucket.includes("shared Vietnam pool")) return "polite-repair";

  return "";
}

function selectPhoneConnectivityAsset(row) {
  const text = [
    row.canonicalPageID,
    row.runtimePhraseID,
    row.englishTitle,
  ].join(" ").toLowerCase();

  if (/\b(wi-?fi|wifi|password|router|network|internet|login page|disconnect|slow)\b/.test(text)) {
    return "BackdropPhrasePhoneCafeCharging";
  }
  if (/\b(charge|charger|charging|battery|cable|power bank)\b/.test(text)) {
    return "BackdropPhrasePhoneAirportCharging";
  }
  if (/\b(map|grab|address|location|pin|app|text message|phone call|driver)\b/.test(text)) {
    return "BackdropPhraseTransportStreetMap";
  }
  if (/\b(fix|repair|screen|broken|wet)\b/.test(text)) {
    return "BackdropPhrasePhoneAccessoryCounter";
  }
  if (/\b(sim|esim|data|signal|top-up|activate|install|gigabytes|valid)\b/.test(text)) {
    return "BackdropPhrasePhoneSimSetup";
  }

  return "";
}

function selectAsset(row) {
  const semanticPool = selectPool(row);
  const assets = semanticPools[semanticPool] ?? [];
  if (assets.length === 0) {
    return {
      assetName: row.recommendedAsset,
      fallbackAssetName: row.recommendedAsset,
      source: "category-fallback",
      semanticPool: "",
    };
  }

  if (semanticPool === "phone-connectivity") {
    const phoneAssetName = selectPhoneConnectivityAsset(row);
    if (phoneAssetName) {
      return {
        assetName: phoneAssetName,
        fallbackAssetName: row.recommendedAsset,
        source: "semantic-mini-pool",
        semanticPool,
      };
    }
  }

  const assetName = assets[stableIndex(row.canonicalPageID, assets.length)];
  return {
    assetName,
    fallbackAssetName: row.recommendedAsset,
    source: "semantic-mini-pool",
    semanticPool,
  };
}

function sortPlacements(rows) {
  return [...rows].sort((a, b) => {
    const aKey = [a.assetName, a.pageID].join("\u0000");
    const bKey = [b.assetName, b.pageID].join("\u0000");
    return aKey.localeCompare(bKey);
  });
}

function buildPlacements(audit) {
  const needsRows = (audit.listingRows ?? [])
    .filter((row) => row.auditStatus === "Needs Backdrop" || row.needsBackdropWork === "Yes");
  const seenPageIDs = new Set();
  const placements = [];

  for (const row of needsRows) {
    if (seenPageIDs.has(row.canonicalPageID)) {
      throw new Error(`Duplicate needs-backdrop page ID: ${row.canonicalPageID}`);
    }
    seenPageIDs.add(row.canonicalPageID);

    if (!row.recommendedAsset) {
      throw new Error(`Missing recommendedAsset for ${row.canonicalPageID}`);
    }
    if (!row.recommendedAsset.startsWith("HeroCategory")) {
      throw new Error(`Expected HeroCategory recommendedAsset for ${row.canonicalPageID}, found ${row.recommendedAsset}`);
    }
    if (!assetExists(row.recommendedAsset)) {
      throw new Error(`Missing asset catalog image for ${row.canonicalPageID}: ${row.recommendedAsset}`);
    }

    const assetSelection = selectAsset(row);
    if (!assetExists(assetSelection.assetName)) {
      throw new Error(`Missing asset catalog image for ${row.canonicalPageID}: ${assetSelection.assetName}`);
    }

    placements.push({
      pageID: row.canonicalPageID,
      phraseID: row.runtimePhraseID,
      englishTitle: row.englishTitle,
      assetName: assetSelection.assetName,
      fallbackAssetName: assetSelection.fallbackAssetName,
      source: assetSelection.source,
      semanticPool: assetSelection.semanticPool,
      priority: row.priority,
      reachabilityStatus: row.reachabilityStatus,
      rolloutBucket: row.rolloutBucket,
      imageTheme: row.imageTheme,
    });
  }

  if (placements.length !== 952) {
    throw new Error(`Expected 952 needs-backdrop placements, found ${placements.length}`);
  }

  return sortPlacements(placements);
}

function main() {
  const audit = readJSON(auditPath);
  const placements = buildPlacements(audit);
  const counts = new Map();
  for (const placement of placements) {
    counts.set(placement.assetName, (counts.get(placement.assetName) ?? 0) + 1);
  }

  const payload = {
    version: 1,
    generatedAt: "source:listing-backdrop-audit-2026-05-29",
    sourceAudit: "docs/task-results/listing-backdrop-audit-2026-05-29/listing-backdrop-audit.json",
    intent: "Give all 952 human-reachable Viet phrase/listing pages a production semantic backdrop image so direct, Search, Saved, Practice, and Browse entry use the shared photo-backdrop sheet interaction.",
    strategy: "Semantic mini-pools use app-owned BackdropPhrase* portrait assets for higher-fit traveler moments while keeping the original HeroCategory* audit recommendation as fallbackAssetName.",
    semanticPools,
    placements,
  };

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, `${JSON.stringify(payload, null, 2)}\n`);

  console.log(JSON.stringify({
    ok: true,
    placements: placements.length,
    assets: Object.fromEntries([...counts.entries()].sort((a, b) => a[0].localeCompare(b[0]))),
  }, null, 2));
}

main();
