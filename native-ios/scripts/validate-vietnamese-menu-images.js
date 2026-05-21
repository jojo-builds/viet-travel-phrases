#!/usr/bin/env node

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const menuJSONPath = path.join(repoRoot, "native-ios", "Resources", "vietnamese-menu-copy.json");
const assetRoot = path.join(repoRoot, "native-ios", "Resources", "Assets.xcassets");
const artifactDir = path.join(repoRoot, "native-ios", "artifacts", "vietnamese-menu");

function pascalCaseIdentifier(itemID) {
  return itemID
    .split("-")
    .filter(Boolean)
    .map((part) => `${part.slice(0, 1).toUpperCase()}${part.slice(1)}`)
    .join("");
}

function thumbnailAssetNameForItemID(itemID) {
  return `HeroMenu${pascalCaseIdentifier(itemID)}`;
}

function backdropAssetNameForItemID(itemID) {
  return `BackdropMenu${pascalCaseIdentifier(itemID)}`;
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

function readAsset(assetName, itemID, role, issues) {
  const imagesetPath = path.join(assetRoot, `${assetName}.imageset`);
  const contentsPath = path.join(imagesetPath, "Contents.json");
  const row = {
    [`${role}AssetName`]: assetName,
    [`${role}ImagesetPath`]: path.relative(repoRoot, imagesetPath),
    [`${role}Filename`]: "",
    [`${role}Width`]: "",
    [`${role}Height`]: "",
    [`${role}Format`]: "",
    [`${role}Bytes`]: "",
    [`${role}Sha256`]: "",
    [`${role}Status`]: "approved",
  };

  const flag = (severity, code, detail) => {
    issues.push({ severity, code, itemID, assetName, role, detail });
    row[`${role}Status`] = severity === "error" ? "error" : row[`${role}Status`] === "approved" ? "warning" : row[`${role}Status`];
  };

  if (!fs.existsSync(contentsPath)) {
    flag("error", `missing-${role}-imageset`, path.relative(repoRoot, contentsPath));
    return row;
  }

  let contents;
  try {
    contents = safeReadJSON(contentsPath);
  } catch (error) {
    flag("error", `invalid-${role}-contents-json`, error.message);
    return row;
  }

  const imageEntry = (contents.images ?? []).find((entry) => entry.filename);
  if (!imageEntry) {
    flag("error", `missing-${role}-filename`, path.relative(repoRoot, contentsPath));
    return row;
  }

  const imagePath = path.join(imagesetPath, imageEntry.filename);
  row[`${role}Filename`] = imageEntry.filename;
  if (!fs.existsSync(imagePath)) {
    flag("error", `missing-${role}-image-file`, path.relative(repoRoot, imagePath));
    return row;
  }

  try {
    const buffer = fs.readFileSync(imagePath);
    const dimensions = readImageDimensions(buffer, imagePath);
    const sha256 = crypto.createHash("sha256").update(buffer).digest("hex");
    row[`${role}Width`] = dimensions.width;
    row[`${role}Height`] = dimensions.height;
    row[`${role}Format`] = dimensions.format;
    row[`${role}Bytes`] = buffer.length;
    row[`${role}Sha256`] = sha256;

    if (role === "thumbnail") {
      if (dimensions.width < 360 || dimensions.height < 360) {
        flag("error", "thumbnail-image-too-small", `${dimensions.width}x${dimensions.height}`);
      }
      if (buffer.length > 700_000) {
        flag("warning", "large-thumbnail-image", `${buffer.length} bytes`);
      }
    } else {
      const ratio = dimensions.width / dimensions.height;
      if (dimensions.format !== "jpeg") {
        flag("error", "backdrop-not-jpeg", dimensions.format);
      }
      if (dimensions.width < 700 || dimensions.height < 1500 || ratio < 0.43 || ratio > 0.49) {
        flag("error", "backdrop-bad-dimensions", `${dimensions.width}x${dimensions.height}`);
      }
      if (buffer.length > 900_000) {
        flag("warning", "large-backdrop-image", `${buffer.length} bytes`);
      }
    }
  } catch (error) {
    flag("error", `${role}-image-read-error`, error.message);
  }

  return row;
}

function main() {
  const payload = safeReadJSON(menuJSONPath);
  const items = payload.items ?? [];
  const issues = [];
  const rows = [];
  const itemIDs = new Set();
  const thumbnailAssetNames = new Set();
  const backdropAssetNames = new Set();
  const thumbnailHashes = new Map();
  const backdropHashes = new Map();

  fs.mkdirSync(artifactDir, { recursive: true });

  for (const item of items) {
    const itemID = item.itemID;
    const thumbnailAssetName = thumbnailAssetNameForItemID(itemID);
    const backdropAssetName = backdropAssetNameForItemID(itemID);
    const row = {
      itemID,
      menuType: item.menuType,
      category: item.category,
      vietnameseItem: item.vietnameseItem,
      englishTranslation: item.englishTranslation,
      status: "approved",
    };

    if (itemIDs.has(itemID)) {
      issues.push({ severity: "error", code: "duplicate-item-id", itemID, assetName: "", role: "item", detail: itemID });
      row.status = "error";
    }
    itemIDs.add(itemID);

    if (thumbnailAssetNames.has(thumbnailAssetName)) {
      issues.push({ severity: "error", code: "duplicate-thumbnail-asset-name", itemID, assetName: thumbnailAssetName, role: "thumbnail", detail: thumbnailAssetName });
      row.status = "error";
    }
    thumbnailAssetNames.add(thumbnailAssetName);

    if (backdropAssetNames.has(backdropAssetName)) {
      issues.push({ severity: "error", code: "duplicate-backdrop-asset-name", itemID, assetName: backdropAssetName, role: "backdrop", detail: backdropAssetName });
      row.status = "error";
    }
    backdropAssetNames.add(backdropAssetName);

    Object.assign(row, readAsset(thumbnailAssetName, itemID, "thumbnail", issues));
    Object.assign(row, readAsset(backdropAssetName, itemID, "backdrop", issues));

    for (const [role, hashes] of [["thumbnail", thumbnailHashes], ["backdrop", backdropHashes]]) {
      const sha = row[`${role}Sha256`];
      if (!sha) continue;
      if (hashes.has(sha)) {
        issues.push({
          severity: "error",
          code: `duplicate-${role}-image-bytes`,
          itemID,
          assetName: row[`${role}AssetName`],
          role,
          detail: `${itemID} matches ${hashes.get(sha)}`,
        });
        row[`${role}Status`] = "error";
      } else {
        hashes.set(sha, itemID);
      }
    }

    if (row.thumbnailStatus === "error" || row.backdropStatus === "error") {
      row.status = "error";
    } else if (row.thumbnailStatus === "warning" || row.backdropStatus === "warning") {
      row.status = "warning";
    }

    rows.push(row);
  }

  const allowedAssets = new Set([...thumbnailAssetNames, ...backdropAssetNames]);
  for (const entry of fs.readdirSync(assetRoot)) {
    if (!entry.endsWith(".imageset")) continue;
    const assetName = entry.replace(/\.imageset$/, "");
    if ((assetName.startsWith("HeroMenu") || assetName.startsWith("BackdropMenu")) && !allowedAssets.has(assetName)) {
      issues.push({
        severity: "error",
        code: "orphan-menu-image-asset",
        itemID: "",
        assetName,
        role: assetName.startsWith("BackdropMenu") ? "backdrop" : "thumbnail",
        detail: path.join("native-ios/Resources/Assets.xcassets", entry),
      });
    }
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
    uniqueThumbnailAssetNames: thumbnailAssetNames.size,
    uniqueBackdropAssetNames: backdropAssetNames.size,
    uniqueThumbnailImageHashes: thumbnailHashes.size,
    uniqueBackdropImageHashes: backdropHashes.size,
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
    "thumbnailAssetName",
    "thumbnailFilename",
    "thumbnailWidth",
    "thumbnailHeight",
    "thumbnailFormat",
    "thumbnailBytes",
    "thumbnailSha256",
    "thumbnailStatus",
    "backdropAssetName",
    "backdropFilename",
    "backdropWidth",
    "backdropHeight",
    "backdropFormat",
    "backdropBytes",
    "backdropSha256",
    "backdropStatus",
    "status",
  ]);
  writeCSV(path.join(artifactDir, "menu-image-issues.csv"), issues, ["severity", "code", "itemID", "assetName", "role", "detail"]);

  console.log(`Validated ${items.length} menu image pairs`);
  console.log(`Unique thumbnail asset names: ${thumbnailAssetNames.size}`);
  console.log(`Unique backdrop asset names: ${backdropAssetNames.size}`);
  console.log(`Unique thumbnail image hashes: ${thumbnailHashes.size}`);
  console.log(`Unique backdrop image hashes: ${backdropHashes.size}`);
  console.log(`Issues: ${issues.length} (${manifest.errorCount} errors, ${manifest.warningCount} warnings)`);

  if (manifest.errorCount > 0) {
    process.exit(1);
  }
}

main();
