#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const assetsRoot = path.join(repoRoot, "native-ios", "Resources", "Assets.xcassets");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredPagesPath = path.join(repoRoot, "native-ios", "Resources", "viet-authored-listing-pages.json");
const trackerRoot = path.join(repoRoot, "docs", "editorial-exports", "viet-image-assets", "hero-image-production-001");
const generatedReportPath = path.join(trackerRoot, "generated_hero_assets.json");
const trackerPath = path.join(trackerRoot, "asset_tracker.csv");
const queuePath = path.join(trackerRoot, "image_queue.csv");
const browseDestinationsPath = path.join(repoRoot, "native-ios", "App", "Models", "BrowseSearchDestinations.swift");

const EXPECTED_DIMENSIONS = "853 x 1844";

function fail(message) {
  console.error(`ERROR: ${message}`);
  process.exitCode = 1;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function csvRows(filePath) {
  const text = fs.readFileSync(filePath, "utf8").trim();
  if (!text) return [];
  const lines = text.split(/\r?\n/);
  const headers = splitCsv(lines.shift());
  return lines.map((line) => {
    const cells = splitCsv(line);
    return Object.fromEntries(headers.map((header, index) => [header, cells[index] ?? ""]));
  });
}

function splitCsv(line) {
  const cells = [];
  let current = "";
  let quoted = false;
  for (let index = 0; index < line.length; index += 1) {
    const character = line[index];
    if (character === "\"") {
      if (quoted && line[index + 1] === "\"") {
        current += "\"";
        index += 1;
      } else {
        quoted = !quoted;
      }
    } else if (character === "," && !quoted) {
      cells.push(current);
      current = "";
    } else {
      current += character;
    }
  }
  cells.push(current);
  return cells;
}

function firstPngInImageset(heroImageName) {
  const imageset = path.join(assetsRoot, `${heroImageName}.imageset`);
  if (!fs.existsSync(imageset)) return "";
  const png = fs.readdirSync(imageset).find((file) => file.endsWith(".png"));
  return png ? path.join(imageset, png) : "";
}

function pngDimensions(filePath) {
  if (!filePath || !fs.existsSync(filePath)) return "";
  const buffer = fs.readFileSync(filePath);
  if (buffer.length < 24 || buffer.toString("ascii", 1, 4) !== "PNG") return "";
  return `${buffer.readUInt32BE(16)} x ${buffer.readUInt32BE(20)}`;
}

function validateAsset(heroImageName, context) {
  const imageset = path.join(assetsRoot, `${heroImageName}.imageset`);
  if (!fs.existsSync(imageset)) {
    fail(`${context}: missing imageset ${heroImageName}.imageset`);
    return;
  }
  const contents = path.join(imageset, "Contents.json");
  if (!fs.existsSync(contents)) {
    fail(`${context}: missing Contents.json for ${heroImageName}`);
  }
  const png = firstPngInImageset(heroImageName);
  if (!png) {
    fail(`${context}: missing PNG for ${heroImageName}`);
    return;
  }
  const dimensions = pngDimensions(png);
  if (dimensions !== EXPECTED_DIMENSIONS) {
    fail(`${context}: ${heroImageName} is ${dimensions}, expected ${EXPECTED_DIMENSIONS}`);
  }
}

function validateGeneratedReport() {
  const report = readJson(generatedReportPath);
  if (report.targetPixelSize !== EXPECTED_DIMENSIONS) {
    fail(`generated report targetPixelSize is ${report.targetPixelSize}`);
  }
  if (!Array.isArray(report.items) || report.items.length !== report.generatedCount) {
    fail("generated report item count does not match generatedCount");
    return;
  }
  for (const item of report.items) {
    validateAsset(item.heroImageName, `generated report ${item.pageID}`);
  }
}

function validateCityLibraryAndAuthoredPages() {
  const cityLibrary = readJson(cityLibraryPath);
  const authoredPages = readJson(authoredPagesPath);
  const authoredByID = new Map(authoredPages.pages.map((page) => [page.id, page]));
  const approvedPlaces = cityLibrary.pages.filter((page) => page.kind === "place" && page.status === "approved");

  for (const page of approvedPlaces) {
    if (!page.heroImageName) {
      fail(`approved place ${page.id} is missing heroImageName`);
      continue;
    }
    validateAsset(page.heroImageName, `city library ${page.id}`);
    const authoredPageID = `viet-family-${page.id}`;
    const authoredPage = authoredByID.get(authoredPageID);
    if (!authoredPage) {
      fail(`missing authored page ${authoredPageID}`);
      continue;
    }
    if (authoredPage.heroImageName !== page.heroImageName) {
      fail(`${authoredPageID} hero mismatch: authored=${authoredPage.heroImageName}, source=${page.heroImageName}`);
    }
  }

  console.log(`approved city-library places with hero images: ${approvedPlaces.length}`);
}

function validateBrowseMappings() {
  const swift = fs.readFileSync(browseDestinationsPath, "utf8");
  const heroNames = new Set([...swift.matchAll(/"((?:HeroCity|HeroCategory|HeroCountry)[A-Za-z0-9]+)"/g)].map((match) => match[1]));
  for (const heroImageName of heroNames) {
    validateAsset(heroImageName, `browse descriptor mapping`);
  }
  console.log(`browse/category/country hero mappings with assets: ${heroNames.size}`);
}

function validateTracker() {
  const rows = csvRows(trackerPath);
  if (!rows.length) {
    fail("asset tracker has no rows");
    return;
  }
  const open = rows.filter((row) => row.status !== "SHIPPED_REVIEW_CROP");
  if (open.length > 0) {
    fail(`asset tracker still has ${open.length} non-shipped rows`);
  }
  const queueRows = csvRows(queuePath);
  if (queueRows.length > 0) {
    fail(`image queue should be empty after generation, found ${queueRows.length} rows`);
  }
  console.log(`hero tracker shipped rows: ${rows.length}`);
}

validateGeneratedReport();
validateCityLibraryAndAuthoredPages();
validateBrowseMappings();
validateTracker();

if (process.exitCode) {
  process.exit(process.exitCode);
}

console.log("Viet hero image asset validation passed");
