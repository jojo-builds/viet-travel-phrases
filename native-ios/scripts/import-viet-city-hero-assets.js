#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");
const crypto = require("crypto");

const repoRoot = path.resolve(__dirname, "..", "..");
const manifestPath = process.argv[2]
  ? path.resolve(process.argv[2])
  : path.join(repoRoot, "docs", "editorial-exports", "viet-image-assets", "city-hero-production-505", "manifest.json");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const assetsRoot = path.join(repoRoot, "native-ios", "Resources", "Assets.xcassets");
const generatedSourceRoot = path.join(repoRoot, "docs", "editorial-exports", "viet-image-assets", "city-hero-production-505", "sources");
const targetWidth = 853;
const targetHeight = 1844;

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`, "utf8");
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function slug(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "D")
    .replace(/([a-z0-9])([A-Z])/g, "$1-$2")
    .replace(/[^A-Za-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .toLowerCase();
}

function hashFile(filePath) {
  return crypto.createHash("sha256").update(fs.readFileSync(filePath)).digest("hex");
}

function normalizeToPng(sourcePath, outputPath) {
  ensureDir(path.dirname(outputPath));
  execFileSync("ffmpeg", [
    "-y",
    "-i", sourcePath,
    "-vf", `scale=${targetWidth}:${targetHeight}:force_original_aspect_ratio=increase,crop=${targetWidth}:${targetHeight}`,
    "-frames:v", "1",
    outputPath,
  ], { stdio: "pipe" });
}

function writeImageset(assetName, sourcePath) {
  const imageset = path.join(assetsRoot, `${assetName}.imageset`);
  ensureDir(imageset);
  for (const file of fs.readdirSync(imageset)) {
    if (/\.(png|jpe?g)$/i.test(file)) {
      fs.unlinkSync(path.join(imageset, file));
    }
  }
  const filename = `${slug(assetName)}.png`;
  const outputPath = path.join(imageset, filename);
  normalizeToPng(sourcePath, outputPath);
  writeJSON(path.join(imageset, "Contents.json"), {
    images: [{ filename, idiom: "universal", scale: "1x" }],
    info: { author: "xcode", version: 1 },
  });
  return outputPath;
}

function main() {
  const manifest = readJSON(manifestPath);
  const library = readJSON(cityLibraryPath);
  const pageByID = new Map((library.pages ?? []).map((page) => [page.id, page]));
  const imported = [];
  const skipped = [];

  for (const row of manifest.rows ?? []) {
    if (row.status !== "approved" && row.status !== "imported") {
      skipped.push({ id: row.id, reason: `status=${row.status}` });
      continue;
    }
    const sourceImagePath = path.resolve(row.approvedImagePath || row.sourceImagePath || "");
    if (!sourceImagePath || !fs.existsSync(sourceImagePath)) {
      throw new Error(`${row.id} is approved but source image does not exist: ${sourceImagePath}`);
    }
    if (!row.targetHeroImageName) {
      throw new Error(`${row.id} missing targetHeroImageName`);
    }

    const sourceReceiptDir = path.join(generatedSourceRoot, row.targetHeroImageName);
    ensureDir(sourceReceiptDir);
    const sourceReceiptPath = path.join(sourceReceiptDir, path.basename(sourceImagePath));
    if (path.resolve(sourceReceiptPath) !== sourceImagePath) {
      fs.copyFileSync(sourceImagePath, sourceReceiptPath);
    }

    const assetPath = writeImageset(row.targetHeroImageName, sourceImagePath);
    const nextRow = {
      ...row,
      status: "imported",
      approvedImagePath: path.relative(repoRoot, sourceReceiptPath),
      assetPath: path.relative(repoRoot, assetPath),
      sha256: hashFile(assetPath),
    };
    Object.assign(row, nextRow);
    imported.push(nextRow);

    if (row.kind === "cityPlace") {
      const page = pageByID.get(row.sourcePageID || row.id);
      if (!page) {
        throw new Error(`missing city-library page for ${row.id}`);
      }
      page.heroImageName = row.targetHeroImageName;
      if (page.editorialImport) {
        page.editorialImport.heroImageName = row.targetHeroImageName;
      }
    }
  }

  writeJSON(manifestPath, manifest);
  writeJSON(cityLibraryPath, library);
  console.log(`Imported ${imported.length} approved city hero images`);
  if (skipped.length) {
    console.log(`Skipped ${skipped.length} rows not marked approved`);
  }
}

main();
