#!/usr/bin/env node

import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";

const repoRoot = path.resolve(process.cwd());
const reportRoot = path.join(repoRoot, "docs/task-results/launch-readiness-audit-2026-07-04/media");
const resourcesRoot = path.join(repoRoot, "native-ios/Resources");
const assetsRoot = path.join(resourcesRoot, "Assets.xcassets");
const sqlitePath = path.join(resourcesRoot, "LanguagePacks/viet/speaklocal-viet.sqlite");

function readJSON(relativePath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relativePath), "utf8"));
}

function csvCell(value) {
  const text = String(value ?? "");
  return /[",\n]/.test(text) ? `"${text.replaceAll('"', '""')}"` : text;
}

function writeCSV(filePath, rows, headers) {
  fs.writeFileSync(
    filePath,
    `${[headers.join(","), ...rows.map((row) => headers.map((header) => csvCell(row[header])).join(","))].join("\n")}\n`
  );
}

function sqliteJSON(sql) {
  const result = spawnSync("sqlite3", ["-json", sqlitePath, sql], {
    cwd: repoRoot,
    encoding: "utf8",
    maxBuffer: 64 * 1024 * 1024,
  });
  if (result.status !== 0) {
    throw new Error(result.stderr || result.stdout);
  }
  return JSON.parse(result.stdout || "[]");
}

function imageDimensions(buffer) {
  if (buffer.slice(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) {
    return { format: "png", width: buffer.readUInt32BE(16), height: buffer.readUInt32BE(20) };
  }
  if (buffer[0] === 0xff && buffer[1] === 0xd8) {
    let offset = 2;
    while (offset + 9 < buffer.length) {
      if (buffer[offset] !== 0xff) {
        offset += 1;
        continue;
      }
      const marker = buffer[offset + 1];
      const length = buffer.readUInt16BE(offset + 2);
      if (marker >= 0xc0 && marker <= 0xc3) {
        return {
          format: "jpeg",
          width: buffer.readUInt16BE(offset + 7),
          height: buffer.readUInt16BE(offset + 5),
        };
      }
      offset += 2 + length;
    }
  }
  return { format: "unknown", width: 0, height: 0 };
}

function imagesetNames() {
  return new Set(
    fs.readdirSync(assetsRoot)
      .filter((entry) => entry.endsWith(".imageset"))
      .map((entry) => entry.replace(/\.imageset$/, ""))
  );
}

function firstRaster(assetName) {
  const imageset = path.join(assetsRoot, `${assetName}.imageset`);
  if (!fs.existsSync(imageset)) return null;
  const raster = fs.readdirSync(imageset).find((entry) => /\.(png|jpe?g)$/i.test(entry));
  return raster ? path.join(imageset, raster) : null;
}

function menuAssetName(itemID, prefix) {
  return `${prefix}${String(itemID)
    .split("-")
    .filter(Boolean)
    .map((part) => `${part.charAt(0).toUpperCase()}${part.slice(1)}`)
    .join("")}`;
}

function inspectMenuImages(menuItems, assetSet) {
  const issues = [];
  const thumbnailHashes = new Map();
  const backdropHashes = new Map();
  for (const item of menuItems) {
    for (const [role, prefix, hashes] of [
      ["thumbnail", "HeroMenu", thumbnailHashes],
      ["backdrop", "BackdropMenu", backdropHashes],
    ]) {
      const assetName = menuAssetName(item.itemID, prefix);
      if (!assetSet.has(assetName)) {
        issues.push({ itemID: item.itemID, role, assetName, issue: "missing-imageset" });
        continue;
      }
      const raster = firstRaster(assetName);
      if (!raster) {
        issues.push({ itemID: item.itemID, role, assetName, issue: "missing-raster" });
        continue;
      }
      const buffer = fs.readFileSync(raster);
      const dimensions = imageDimensions(buffer);
      const hash = crypto.createHash("sha256").update(buffer).digest("hex");
      if (hashes.has(hash)) {
        issues.push({ itemID: item.itemID, role, assetName, issue: `duplicate-bytes:${hashes.get(hash)}` });
      } else {
        hashes.set(hash, item.itemID);
      }
      if (role === "backdrop" && (dimensions.format !== "jpeg" || dimensions.width < 700 || dimensions.height < 1500)) {
        issues.push({ itemID: item.itemID, role, assetName, issue: `bad-dimensions:${dimensions.width}x${dimensions.height}:${dimensions.format}` });
      }
    }
  }
  return {
    itemCount: menuItems.length,
    expectedThumbnailAssets: menuItems.length,
    expectedBackdropAssets: menuItems.length,
    uniqueThumbnailHashes: thumbnailHashes.size,
    uniqueBackdropHashes: backdropHashes.size,
    issueCount: issues.length,
    issues,
  };
}

const assetSet = imagesetNames();
const catalog = readJSON("native-ios/Resources/viet-phrase-catalog.json");
const authored = readJSON("native-ios/Resources/viet-authored-listing-pages.json");
const audioManifest = readJSON("native-ios/Resources/viet-audio-manifest.json");
const menu = readJSON("native-ios/Resources/vietnamese-menu-copy.json");
const phraseBackdrops = readJSON("content-draft/viet/phrase-backdrops-v1.json");
const plannedAudioQueueLines = fs.readFileSync(path.join(repoRoot, "docs/audio-queues/viet-planned-missing-audio.csv"), "utf8").trim().split(/\r?\n/);

const explicitHeroRefs = authored.pages
  .filter((page) => page.heroImageName)
  .map((page) => ({
    pageID: page.id,
    title: page.title,
    englishTitle: page.englishTitle,
    heroImageName: page.heroImageName,
    status: assetSet.has(page.heroImageName) ? "present" : "missing",
  }));
const missingHeroRefs = explicitHeroRefs.filter((row) => row.status === "missing");
const menuImageSummary = inspectMenuImages(menu.items ?? [], assetSet);

const sqliteCounts = sqliteJSON(`
  SELECT 'scenario' AS table_name, count(*) AS count FROM scenario
  UNION ALL SELECT 'phrase_cluster', count(*) FROM phrase_cluster
  UNION ALL SELECT 'phrase', count(*) FROM phrase
  UNION ALL SELECT 'phrase_ready_audio', count(*) FROM phrase WHERE audio_status = 'ready'
  UNION ALL SELECT 'phrase_planned_audio', count(*) FROM phrase WHERE audio_status = 'planned'
  UNION ALL SELECT 'phrase_page', count(*) FROM phrase_page
  UNION ALL SELECT 'missing_audio_audit', count(*) FROM missing_audio_audit
  UNION ALL SELECT 'release_blocking_missing_audio', count(*) FROM missing_audio_audit WHERE release_blocking = 1
  UNION ALL SELECT 'search_document', count(*) FROM search_document
  UNION ALL SELECT 'city_place', count(*) FROM city_place
  UNION ALL SELECT 'vietnamese_menu_item', count(*) FROM vietnamese_menu_item;
`);

const missingAudioRows = sqliteJSON(`
  SELECT target_kind, target_id, expected_text, severity, release_blocking, source_path, reason
  FROM missing_audio_audit
  ORDER BY target_id
  LIMIT 80;
`);

const summary = {
  generatedAt: new Date().toISOString(),
  gitCommit: spawnSync("git", ["rev-parse", "--short", "HEAD"], { cwd: repoRoot, encoding: "utf8" }).stdout.trim(),
  catalog: {
    families: catalog.families?.length ?? 0,
    phrases: catalog.phrases?.length ?? 0,
    scenarios: catalog.scenarios?.length ?? 0,
  },
  authoredListingPages: {
    pages: authored.pages?.length ?? 0,
    explicitHeroRefs: explicitHeroRefs.length,
    uniqueExplicitHeroRefs: new Set(explicitHeroRefs.map((row) => row.heroImageName)).size,
    missingExplicitHeroRefs: missingHeroRefs.length,
  },
  audio: {
    manifestEntries: Object.keys(audioManifest).length,
    plannedMissingAudioQueueRows: Math.max(0, plannedAudioQueueLines.length - 1),
  },
  images: {
    totalImagesets: assetSet.size,
    heroImagesets: [...assetSet].filter((name) => name.startsWith("Hero")).length,
    heroCityImagesets: [...assetSet].filter((name) => name.startsWith("HeroCity")).length,
    heroCategoryImagesets: [...assetSet].filter((name) => name.startsWith("HeroCategory")).length,
    heroMenuImagesets: [...assetSet].filter((name) => name.startsWith("HeroMenu")).length,
    backdropImagesets: [...assetSet].filter((name) => name.startsWith("Backdrop")).length,
    backdropMenuImagesets: [...assetSet].filter((name) => name.startsWith("BackdropMenu")).length,
    backdropPhraseImagesets: [...assetSet].filter((name) => name.startsWith("BackdropPhrase")).length,
  },
  phraseBackdrops: {
    placements: phraseBackdrops.placements?.length ?? 0,
    semanticPools: Object.keys(phraseBackdrops.semanticPools ?? {}).length,
    semanticPoolAssets: new Set(Object.values(phraseBackdrops.semanticPools ?? {}).flat()).size,
  },
  menuImages: menuImageSummary,
  sqliteCounts,
};

fs.writeFileSync(path.join(reportRoot, "media-coverage-summary.json"), `${JSON.stringify(summary, null, 2)}\n`);
writeCSV(path.join(reportRoot, "missing-hero-assets.csv"), missingHeroRefs, ["pageID", "title", "englishTitle", "heroImageName", "status"]);
writeCSV(path.join(reportRoot, "missing-audio-sample.csv"), missingAudioRows, ["target_kind", "target_id", "expected_text", "severity", "release_blocking", "source_path", "reason"]);
if (menuImageSummary.issueCount > 0) {
  writeCSV(path.join(reportRoot, "menu-image-issues.csv"), menuImageSummary.issues, ["itemID", "role", "assetName", "issue"]);
}

console.log(JSON.stringify(summary, null, 2));
