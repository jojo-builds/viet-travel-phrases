#!/usr/bin/env node

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const menuJSONPath = path.join(repoRoot, "native-ios", "Resources", "vietnamese-menu-copy.json");
const assetRoot = path.join(repoRoot, "native-ios", "Resources", "Assets.xcassets");
const artifactDir = path.join(repoRoot, "native-ios", "artifacts", "vietnamese-menu");

function assetNameForItemID(itemID) {
  return `HeroMenu${itemID
    .split("-")
    .filter(Boolean)
    .map((part) => `${part.slice(0, 1).toUpperCase()}${part.slice(1)}`)
    .join("")}`;
}

function readImageDimensions(buffer, filePath) {
  if (buffer.slice(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) {
    return {
      width: buffer.readUInt32BE(16),
      height: buffer.readUInt32BE(20),
      format: "png",
    };
  }

  if (buffer[0] === 0xff && buffer[1] === 0xd8) {
    let offset = 2;
    while (offset < buffer.length) {
      if (buffer[offset] !== 0xff) break;
      const marker = buffer[offset + 1];
      const length = buffer.readUInt16BE(offset + 2);
      if (marker >= 0xc0 && marker <= 0xc3) {
        return {
          width: buffer.readUInt16BE(offset + 7),
          height: buffer.readUInt16BE(offset + 5),
          format: "jpeg",
        };
      }
      offset += 2 + length;
    }
  }

  throw new Error(`Unsupported image format: ${filePath}`);
}

function csvEscape(value) {
  const text = String(value ?? "");
  return /[",\n]/.test(text) ? `"${text.replace(/"/g, '""')}"` : text;
}

function writeCSV(filePath, rows, columns) {
  const lines = [columns.join(",")];
  for (const row of rows) {
    lines.push(columns.map((column) => csvEscape(row[column])).join(","));
  }
  fs.writeFileSync(filePath, `${lines.join("\n")}\n`);
}

function safeReadJSON(filePath) {
  try {
    return JSON.parse(fs.readFileSync(filePath, "utf8"));
  } catch (error) {
    throw new Error(`Could not read JSON ${filePath}: ${error.message}`);
  }
}

function main() {
  const payload = safeReadJSON(menuJSONPath);
  const items = payload.items ?? [];
  const issues = [];
  const rows = [];
  const assetNames = new Set();
  const itemIDs = new Set();
  const hashes = new Map();

  fs.mkdirSync(artifactDir, { recursive: true });

  for (const item of items) {
    const itemID = item.itemID;
    const assetName = assetNameForItemID(itemID);
    const imagesetPath = path.join(assetRoot, `${assetName}.imageset`);
    const contentsPath = path.join(imagesetPath, "Contents.json");
    const row = {
      itemID,
      menuType: item.menuType,
      category: item.category,
      vietnameseItem: item.vietnameseItem,
      englishTranslation: item.englishTranslation,
      assetName,
      imagesetPath: path.relative(repoRoot, imagesetPath),
      filename: "",
      width: "",
      height: "",
      bytes: "",
      sha256: "",
      status: "approved",
    };

    if (itemIDs.has(itemID)) {
      issues.push({ severity: "error", code: "duplicate-item-id", itemID, detail: itemID });
      row.status = "error";
    }
    itemIDs.add(itemID);

    if (assetNames.has(assetName)) {
      issues.push({ severity: "error", code: "duplicate-asset-name", itemID, detail: assetName });
      row.status = "error";
    }
    assetNames.add(assetName);

    if (!fs.existsSync(contentsPath)) {
      issues.push({ severity: "error", code: "missing-imageset", itemID, detail: path.relative(repoRoot, contentsPath) });
      row.status = "error";
      rows.push(row);
      continue;
    }

    let contents;
    try {
      contents = safeReadJSON(contentsPath);
    } catch (error) {
      issues.push({ severity: "error", code: "invalid-contents-json", itemID, detail: error.message });
      row.status = "error";
      rows.push(row);
      continue;
    }

    const imageEntry = (contents.images ?? []).find((entry) => entry.filename);
    if (!imageEntry) {
      issues.push({ severity: "error", code: "missing-filename", itemID, detail: path.relative(repoRoot, contentsPath) });
      row.status = "error";
      rows.push(row);
      continue;
    }

    const imagePath = path.join(imagesetPath, imageEntry.filename);
    row.filename = imageEntry.filename;
    if (!fs.existsSync(imagePath)) {
      issues.push({ severity: "error", code: "missing-image-file", itemID, detail: path.relative(repoRoot, imagePath) });
      row.status = "error";
      rows.push(row);
      continue;
    }

    try {
      const buffer = fs.readFileSync(imagePath);
      const dimensions = readImageDimensions(buffer, imagePath);
      const sha256 = crypto.createHash("sha256").update(buffer).digest("hex");
      row.width = dimensions.width;
      row.height = dimensions.height;
      row.bytes = buffer.length;
      row.sha256 = sha256;

      if (dimensions.width < 360 || dimensions.height < 360) {
        issues.push({ severity: "error", code: "image-too-small", itemID, detail: `${dimensions.width}x${dimensions.height}` });
        row.status = "error";
      }

      if (buffer.length > 700_000) {
        issues.push({ severity: "warning", code: "large-menu-image", itemID, detail: `${buffer.length} bytes` });
        row.status = row.status === "approved" ? "warning" : row.status;
      }

      if (hashes.has(sha256)) {
        issues.push({ severity: "error", code: "duplicate-image-bytes", itemID, detail: `${itemID} matches ${hashes.get(sha256)}` });
        row.status = "error";
      } else {
        hashes.set(sha256, itemID);
      }
    } catch (error) {
      issues.push({ severity: "error", code: "image-read-error", itemID, detail: error.message });
      row.status = "error";
    }

    rows.push(row);
  }

  const categorySummary = new Map();
  for (const row of rows) {
    const key = `${row.menuType} / ${row.category}`;
    const current = categorySummary.get(key) ?? { menuType: row.menuType, category: row.category, itemCount: 0, approvedCount: 0 };
    current.itemCount += 1;
    if (row.status === "approved" || row.status === "warning") {
      current.approvedCount += 1;
    }
    categorySummary.set(key, current);
  }

  const manifest = {
    generatedAt: new Date().toISOString(),
    source: path.relative(repoRoot, menuJSONPath),
    totalItems: items.length,
    uniqueAssetNames: assetNames.size,
    uniqueImageHashes: hashes.size,
    issueCount: issues.length,
    errorCount: issues.filter((issue) => issue.severity === "error").length,
    warningCount: issues.filter((issue) => issue.severity === "warning").length,
    categorySummary: Array.from(categorySummary.values()),
    items: rows,
    issues,
  };

  fs.writeFileSync(path.join(artifactDir, "menu-image-manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
  writeCSV(path.join(artifactDir, "menu-image-qa.csv"), rows, [
    "itemID",
    "menuType",
    "category",
    "vietnameseItem",
    "englishTranslation",
    "assetName",
    "filename",
    "width",
    "height",
    "bytes",
    "sha256",
    "status",
  ]);
  writeCSV(path.join(artifactDir, "menu-image-issues.csv"), issues, ["severity", "code", "itemID", "detail"]);

  console.log(`Validated ${items.length} menu images`);
  console.log(`Unique asset names: ${assetNames.size}`);
  console.log(`Unique image hashes: ${hashes.size}`);
  console.log(`Issues: ${issues.length} (${manifest.errorCount} errors, ${manifest.warningCount} warnings)`);

  if (manifest.errorCount > 0) {
    process.exit(1);
  }
}

main();
