#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const assetsRoot = path.join(repoRoot, "native-ios", "Resources", "Assets.xcassets");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredPagesPath = path.join(repoRoot, "native-ios", "Resources", "viet-authored-listing-pages.json");
const browseDestinationsPath = path.join(repoRoot, "native-ios", "App", "Models", "BrowseSearchDestinations.swift");

const EXPECTED_DIMENSIONS = "853 x 1844";
const EXPECTED_CITY_DIMENSIONS = "720 x 1556";
const PHOTO_LIKE_MIN_BYTES = 120_000;
const requireUniqueCityPlaceAssets = process.argv.includes("--require-unique-city-place-assets");
const existingNonCityDimensionAllowlist = new Map([
  ["HeroVietnameseFoodMenu", "864 x 1821"],
]);

const retiredHeroNames = new Set([
  "HeroHanMarket",
  "HeroLinhUngPagoda",
  "HeroMarbleMountains",
  "HeroMyKheBeach",
  "HeroNguyenVanLinhStreet",
]);

const requiredStyleReferenceHeroes = [
  "HeroVietnamMasthead",
  "HeroXinChao",
  "HeroDragonBridge",
  "HeroBaNaHills",
  "HeroCityDanang",
  "HeroCityHanoi",
  "HeroCityHcmc",
  "HeroCityHoian",
  "HeroCityHue",
];

function fail(message) {
  console.error(`ERROR: ${message}`);
  process.exitCode = 1;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function isRetiredHeroName(heroImageName) {
  return retiredHeroNames.has(heroImageName);
}

function firstRasterInImageset(heroImageName) {
  const imageset = path.join(assetsRoot, `${heroImageName}.imageset`);
  if (!fs.existsSync(imageset)) return "";
  const raster = fs.readdirSync(imageset).find((file) => /\.(png|jpe?g)$/i.test(file));
  return raster ? path.join(imageset, raster) : "";
}

function pngDimensions(filePath) {
  if (!filePath || !fs.existsSync(filePath)) return "";
  const buffer = fs.readFileSync(filePath);
  if (buffer.length < 24 || buffer.toString("ascii", 1, 4) !== "PNG") return "";
  return `${buffer.readUInt32BE(16)} x ${buffer.readUInt32BE(20)}`;
}

function jpegDimensions(filePath) {
  if (!filePath || !fs.existsSync(filePath)) return "";
  const buffer = fs.readFileSync(filePath);
  if (buffer.length < 4 || buffer[0] !== 0xff || buffer[1] !== 0xd8) return "";

  let offset = 2;
  while (offset + 9 < buffer.length) {
    if (buffer[offset] !== 0xff) {
      offset += 1;
      continue;
    }

    const marker = buffer[offset + 1];
    offset += 2;
    if (marker === 0xd9 || marker === 0xda) break;
    if (offset + 2 > buffer.length) break;

    const length = buffer.readUInt16BE(offset);
    if (length < 2 || offset + length > buffer.length) break;

    const isStartOfFrame = (
      (marker >= 0xc0 && marker <= 0xc3)
      || (marker >= 0xc5 && marker <= 0xc7)
      || (marker >= 0xc9 && marker <= 0xcb)
      || (marker >= 0xcd && marker <= 0xcf)
    );
    if (isStartOfFrame && length >= 7) {
      const height = buffer.readUInt16BE(offset + 3);
      const width = buffer.readUInt16BE(offset + 5);
      return `${width} x ${height}`;
    }
    offset += length;
  }
  return "";
}

function rasterDimensions(filePath) {
  if (/\.png$/i.test(filePath)) return pngDimensions(filePath);
  if (/\.jpe?g$/i.test(filePath)) return jpegDimensions(filePath);
  return "";
}

function validateAsset(heroImageName, context) {
  if (isRetiredHeroName(heroImageName)) {
    fail(`${context}: ${heroImageName} is retired flat/procedural hero art`);
    return;
  }

  const imageset = path.join(assetsRoot, `${heroImageName}.imageset`);
  if (!fs.existsSync(imageset)) {
    fail(`${context}: missing imageset ${heroImageName}.imageset`);
    return;
  }

  const contents = path.join(imageset, "Contents.json");
  if (!fs.existsSync(contents)) {
    fail(`${context}: missing Contents.json for ${heroImageName}`);
  }

  const raster = firstRasterInImageset(heroImageName);
  if (!raster) {
    fail(`${context}: missing PNG/JPEG for ${heroImageName}`);
    return;
  }

  const dimensions = rasterDimensions(raster);
  const expectedDimensions = heroImageName.startsWith("HeroCity")
    ? EXPECTED_CITY_DIMENSIONS
    : EXPECTED_DIMENSIONS;
  const allowedDimensions = existingNonCityDimensionAllowlist.get(heroImageName);
  if (dimensions !== expectedDimensions && dimensions !== allowedDimensions) {
    fail(`${context}: ${heroImageName} is ${dimensions}, expected ${expectedDimensions}`);
  }

  const bytes = fs.statSync(raster).size;
  if (bytes < PHOTO_LIKE_MIN_BYTES) {
    fail(`${context}: ${heroImageName} image is only ${bytes} bytes; likely flat/procedural art`);
  }
}

function addHeroName(set, heroImageName) {
  if (typeof heroImageName === "string" && heroImageName.trim()) {
    set.add(heroImageName);
  }
}

function pascalCaseIdentifier(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "D")
    .split(/[^A-Za-z0-9]+/)
    .filter(Boolean)
    .map((part) => `${part.charAt(0).toUpperCase()}${part.slice(1).toLowerCase()}`)
    .join("");
}

function expectedTargetHeroName(page) {
  if (page.productionIntake?.targetHeroImageName) {
    return page.productionIntake.targetHeroImageName;
  }
  if (page.editorialImport?.targetHeroImageName) {
    return page.editorialImport.targetHeroImageName;
  }
  const cityID = String(page.cityID ?? "");
  const placeID = String(page.placeID ?? "");
  const suffix = placeID.startsWith(`${cityID}-`) ? placeID.slice(cityID.length + 1) : placeID;
  return `HeroCity${pascalCaseIdentifier(cityID)}Place${pascalCaseIdentifier(suffix)}`;
}

function collectCityLibraryHeroNames() {
  const cityLibrary = readJson(cityLibraryPath);
  const heroNames = new Set();
  for (const page of cityLibrary.pages || []) {
    addHeroName(heroNames, page.heroImageName);
    addHeroName(heroNames, page.editorialImport?.heroImageName);
  }
  return heroNames;
}

function collectAuthoredPageHeroNames() {
  const authoredPages = readJson(authoredPagesPath);
  const heroNames = new Set();
  for (const page of authoredPages.pages || []) {
    addHeroName(heroNames, page.heroImageName);
  }
  return heroNames;
}

function collectBrowseHeroNames() {
  const swift = fs.readFileSync(browseDestinationsPath, "utf8");
  return new Set([...swift.matchAll(/"((?:HeroCity|HeroCategory|HeroCountry|HeroVietnam|HeroXinChao)[A-Za-z0-9]*)"/g)].map((match) => match[1]));
}

function validateCityLibraryAndAuthoredPages() {
  const cityLibrary = readJson(cityLibraryPath);
  const authoredPages = readJson(authoredPagesPath);
  const authoredByID = new Map(authoredPages.pages.map((page) => [page.id, page]));
  const approvedPlaces = cityLibrary.pages.filter((page) => page.kind === "place" && page.status === "approved");
  const sourceLegacyOrSharedHeroPages = [];
  const authoredLegacyOrSharedHeroPages = [];
  const missingTargetAssets = [];

  for (const page of approvedPlaces) {
    if (!page.heroImageName) {
      fail(`approved place ${page.id} is missing heroImageName`);
      continue;
    }

    const targetHeroImageName = expectedTargetHeroName(page);
    if (!page.productionIntake?.targetHeroImageName) {
      fail(`approved place ${page.id} is missing productionIntake.targetHeroImageName`);
    }
    if (requireUniqueCityPlaceAssets && page.heroImageName !== targetHeroImageName) {
      sourceLegacyOrSharedHeroPages.push(`${page.id}: current=${page.heroImageName}, target=${targetHeroImageName}`);
    }
    if (requireUniqueCityPlaceAssets && !firstRasterInImageset(targetHeroImageName)) {
      missingTargetAssets.push(`${page.id}: ${targetHeroImageName}.imageset`);
    }

    const authoredPageID = `viet-family-${page.id}`;
    const authoredPage = authoredByID.get(authoredPageID);
    if (!authoredPage) {
      fail(`missing authored page ${authoredPageID}`);
      continue;
    }

    if (authoredPage.heroImageName !== page.heroImageName) {
      fail(`${authoredPageID} hero mismatch: authored=${authoredPage.heroImageName}, source=${page.heroImageName}`);
    }
    if (requireUniqueCityPlaceAssets && authoredPage.heroImageName !== targetHeroImageName) {
      authoredLegacyOrSharedHeroPages.push(`${authoredPageID}: current=${authoredPage.heroImageName}, target=${targetHeroImageName}`);
    }
  }

  if (sourceLegacyOrSharedHeroPages.length > 0) {
    fail(`${sourceLegacyOrSharedHeroPages.length} approved city source places still use shared/legacy hero names instead of unique generated assets; examples: ${sourceLegacyOrSharedHeroPages.slice(0, 8).join(" | ")}`);
  }
  if (authoredLegacyOrSharedHeroPages.length > 0) {
    fail(`${authoredLegacyOrSharedHeroPages.length} rendered city place pages still use shared/legacy hero names instead of unique generated assets; examples: ${authoredLegacyOrSharedHeroPages.slice(0, 8).join(" | ")}`);
  }
  if (missingTargetAssets.length > 0) {
    fail(`${missingTargetAssets.length} approved city places are missing their target unique realistic imagesets; examples: ${missingTargetAssets.slice(0, 8).join(" | ")}`);
  }

  console.log(`approved city-library places checked: ${approvedPlaces.length}`);
  if (!requireUniqueCityPlaceAssets) {
    console.log("unique city-place hero asset gate skipped; run with --require-unique-city-place-assets for production-image completion");
  }
}

function validateRetiredAssetsAreGone() {
  const imagesets = fs.readdirSync(assetsRoot).filter((name) => name.endsWith(".imageset"));
  const retiredImagesets = imagesets.filter((name) => isRetiredHeroName(name.replace(/\.imageset$/, "")));
  if (retiredImagesets.length > 0) {
    fail(`retired flat/procedural hero imagesets still exist: ${retiredImagesets.slice(0, 20).join(", ")}${retiredImagesets.length > 20 ? "..." : ""}`);
  }
}

const activeHeroNames = new Set([
  ...requiredStyleReferenceHeroes,
  ...collectCityLibraryHeroNames(),
  ...collectAuthoredPageHeroNames(),
  ...collectBrowseHeroNames(),
]);

for (const heroImageName of [...activeHeroNames].sort()) {
  validateAsset(heroImageName, "active hero");
}

validateCityLibraryAndAuthoredPages();
validateRetiredAssetsAreGone();

if (process.exitCode) {
  process.exit(process.exitCode);
}

console.log(`active premium hero assets checked: ${activeHeroNames.size}`);
console.log("Viet hero image asset validation passed");
