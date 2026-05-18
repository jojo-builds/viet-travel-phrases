#!/usr/bin/env node

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");
const { execFile } = require("child_process");

const repoRoot = path.resolve(__dirname, "..", "..");
const menuJSONPath = path.join(repoRoot, "native-ios", "Resources", "vietnamese-menu-copy.json");
const assetRoot = path.join(repoRoot, "native-ios", "Resources", "Assets.xcassets");
const packetDir = path.join(repoRoot, "docs", "editorial-exports", "viet-image-assets", "menu-backdrop-production-355");
const manifestPath = path.join(packetDir, "manifest.json");
const promptExtrasPath = path.join(packetDir, "prompt-extra-instructions.json");
const sourceRoot = path.join(packetDir, "sources");
const bakeoffRoot = path.join(packetDir, "bakeoff");
const runtimeWidth = 720;
const runtimeHeight = 1556;

const defaultBakeoffItemIDs = [
  "food-pho-bo",
  "food-bun-bo-hue",
  "food-banh-mi-thit-nuong",
  "food-com-tam-suon",
  "food-goi-cuon",
  "food-banh-xeo",
  "food-ca-kho-to",
  "food-che-ba-mau",
  "drink-ca-phe-sua-da",
  "drink-ca-phe-trung",
  "drink-nuoc-mia",
  "drink-sinh-to-bo",
];

const profileSettings = {
  "1k-low": { resolution: "1k", quality: "low" },
  "1k-medium": { resolution: "1k", quality: "medium" },
  "1k-high": { resolution: "1k", quality: "high" },
  "2k-low": { resolution: "2k", quality: "low" },
  "2k-medium": { resolution: "2k", quality: "medium" },
  "2k-high": { resolution: "2k", quality: "high" },
};

function usage() {
  console.error(`
Usage:
  node native-ios/scripts/generate-vietnamese-menu-backdrops.js --build-manifest
  node native-ios/scripts/generate-vietnamese-menu-backdrops.js --bakeoff [--items id,id] [--profiles 1k-low,1k-medium,1k-high,2k-low] [--concurrency 2]
  node native-ios/scripts/generate-vietnamese-menu-backdrops.js --generate --profile 1k-high [--items id,id] [--limit 20] [--concurrency 4]

Generates app-owned 9:16 Vietnamese menu backdrop images with Higgsfield GPT Image 2,
normalizes runtime assets to ${runtimeWidth}x${runtimeHeight} JPEG, and updates the
menu backdrop production manifest.
`);
  process.exit(2);
}

function parseArgs(rawArgs) {
  const args = {
    buildManifest: false,
    bakeoff: false,
    generate: false,
    profile: "1k-high",
    profiles: ["1k-low", "1k-medium", "1k-high", "2k-low"],
    items: [],
    limit: 0,
    concurrency: 3,
    force: false,
  };

  for (let i = 0; i < rawArgs.length; i += 1) {
    const arg = rawArgs[i];
    if (arg === "--build-manifest") {
      args.buildManifest = true;
    } else if (arg === "--bakeoff") {
      args.bakeoff = true;
    } else if (arg === "--generate") {
      args.generate = true;
    } else if (arg === "--force") {
      args.force = true;
    } else if (arg.startsWith("--")) {
      const key = arg.slice(2);
      const value = rawArgs[i + 1];
      if (!value || value.startsWith("--")) usage();
      i += 1;
      switch (key) {
      case "profile":
        args.profile = value;
        break;
      case "profiles":
        args.profiles = value.split(",").map((item) => item.trim()).filter(Boolean);
        break;
      case "items":
        args.items = value.split(",").map((item) => item.trim()).filter(Boolean);
        break;
      case "limit":
        args.limit = Number(value) || 0;
        break;
      case "concurrency":
        args.concurrency = Math.max(1, Number(value) || args.concurrency);
        break;
      default:
        usage();
      }
    } else {
      usage();
    }
  }

  if (!args.buildManifest && !args.bakeoff && !args.generate) usage();
  if (args.generate && !profileSettings[args.profile]) usage();
  for (const profile of args.profiles) {
    if (!profileSettings[profile]) usage();
  }
  return args;
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  ensureDir(path.dirname(filePath));
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
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

function hashFile(filePath) {
  return crypto.createHash("sha256").update(fs.readFileSync(filePath)).digest("hex");
}

function existingRelativePath(relativePath) {
  if (!relativePath) return "";
  return fs.existsSync(path.join(repoRoot, relativePath)) ? relativePath : "";
}

function filterExistingBakeoffImages(bakeoff) {
  return Object.fromEntries(
    Object.entries(bakeoff ?? {}).filter(([, value]) => existingRelativePath(value.runtimeImagePath))
  );
}

function readAssetImagePath(assetName) {
  const imagesetPath = path.join(assetRoot, `${assetName}.imageset`);
  const contentsPath = path.join(imagesetPath, "Contents.json");
  if (!fs.existsSync(contentsPath)) {
    throw new Error(`Missing asset Contents.json for ${assetName}: ${contentsPath}`);
  }
  const contents = readJSON(contentsPath);
  const imageEntry = (contents.images ?? []).find((entry) => entry.filename);
  if (!imageEntry) {
    throw new Error(`Missing image filename for ${assetName}`);
  }
  const imagePath = path.join(imagesetPath, imageEntry.filename);
  if (!fs.existsSync(imagePath)) {
    throw new Error(`Missing image file for ${assetName}: ${imagePath}`);
  }
  return imagePath;
}

function readOptionalAssetImagePath(assetName) {
  try {
    return readAssetImagePath(assetName);
  } catch {
    return null;
  }
}

function buildManifest() {
  const payload = readJSON(menuJSONPath);
  const promptExtras = fs.existsSync(promptExtrasPath) ? readJSON(promptExtrasPath) : {};
  const previousRows = fs.existsSync(manifestPath)
    ? new Map((readJSON(manifestPath).rows ?? []).map((row) => [row.itemID, row]))
    : new Map();

  const rows = (payload.items ?? []).map((item, index) => {
    const thumbnailAssetName = thumbnailAssetNameForItemID(item.itemID);
    const backdropAssetName = backdropAssetNameForItemID(item.itemID);
    const previous = previousRows.get(item.itemID) ?? {};
    const existingBackdropPath = readOptionalAssetImagePath(backdropAssetName);
    const reconciledAssetPath = previous.assetPath || (existingBackdropPath ? path.relative(repoRoot, existingBackdropPath) : "");
    const reconciledSha256 = previous.sha256 || (existingBackdropPath ? hashFile(existingBackdropPath) : "");
    const reconciledStatus = reconciledAssetPath
      ? (previous.status === "failed" ? previous.status : "imported")
      : (previous.status === "imported" ? "needs_generation" : previous.status ?? "needs_generation");
    const reconciledReviewStatus = previous.reviewStatus && previous.reviewStatus !== "PENDING"
      ? previous.reviewStatus
      : (reconciledAssetPath ? "READY_FOR_REVIEW" : "PENDING");

    return {
      id: `menu-backdrop-${item.itemID}`,
      queueIndex: index + 1,
      itemID: item.itemID,
      menuType: item.menuType,
      category: item.category,
      subcategory: item.subcategory,
      popular: Boolean(item.popular),
      vietnameseItem: item.vietnameseItem,
      englishTranslation: item.englishTranslation,
      romanizedNoTones: item.romanizedNoTones,
      soundOut: item.soundOut,
      atAGlance: item.atAGlance,
      whatItIs: item.whatItIs ?? "",
      usuallyIncludes: item.usuallyIncludes ?? [],
      notes: item.notes ?? "",
      goodToKnow: item.goodToKnow ?? "",
      commonOptions: item.commonOptions ?? [],
      thumbnailAssetName,
      thumbnailAssetPath: path.relative(repoRoot, readAssetImagePath(thumbnailAssetName)),
      backdropAssetName,
      promptExtraInstruction: promptExtras[item.itemID] ?? "",
      prompt: [buildPrompt(item), promptExtras[item.itemID] ?? ""].filter(Boolean).join(" "),
      status: reconciledStatus,
      selectedProfile: previous.selectedProfile ?? (reconciledAssetPath ? "existing" : ""),
      sourceImagePath: existingRelativePath(previous.sourceImagePath),
      assetPath: reconciledAssetPath,
      sha256: reconciledSha256,
      reviewStatus: reconciledReviewStatus,
      reviewAgentA: previous.reviewAgentA ?? "",
      reviewAgentB: previous.reviewAgentB ?? "",
      reviewerNotes: previous.reviewerNotes ?? "",
      bakeoff: filterExistingBakeoffImages(previous.bakeoff),
    };
  });

  const manifest = {
    generatedAt: new Date().toISOString(),
    source: path.relative(repoRoot, menuJSONPath),
    targetRuntimeSize: { width: runtimeWidth, height: runtimeHeight },
    model: "gpt_image_2",
    totalRows: rows.length,
    statusCounts: countBy(rows, "status"),
    reviewStatusCounts: countBy(rows, "reviewStatus"),
    rows,
  };
  writeJSON(manifestPath, manifest);
  return manifest;
}

function loadOrBuildManifest() {
  if (!fs.existsSync(manifestPath)) {
    return buildManifest();
  }
  return buildManifest();
}

function countBy(rows, key) {
  return rows.reduce((counts, row) => {
    const value = row[key] || "";
    counts[value] = (counts[value] ?? 0) + 1;
    return counts;
  }, {});
}

function buildPrompt(item) {
  const includes = (item.usuallyIncludes ?? []).filter(Boolean).slice(0, 7).join(", ");
  const options = (item.commonOptions ?? []).filter(Boolean).slice(0, 5).join(", ");
  const kind = item.menuType === "Drink" ? "drink" : "dish";
  return [
    "Photorealistic vertical 9:16 Vietnamese food and travel photo for SpeakLocal, a premium native iPhone app for travelers excited to visit Vietnam.",
    `Menu ${kind}: ${item.vietnameseItem} (${item.englishTranslation}).`,
    `Category: ${item.category}${item.subcategory ? ` / ${item.subcategory}` : ""}.`,
    item.whatItIs || item.atAGlance ? `What it should show: ${item.whatItIs || item.atAGlance}.` : "",
    includes ? `Recognizable components: ${includes}.` : "",
    options ? `Optional visual cues only if natural: ${options}.` : "",
    item.notes ? `Context note: ${item.notes}.` : "",
    "Use the reference image only for dish or drink identity; create a new vertical editorial photo, not a square crop or collage.",
    "Composition: Instagram-worthy Vietnamese food photography, appetizing and realistic, subject clearly visible in the upper-middle half, enough table/background texture for a scrolling app sheet to sit over the lower part.",
    "Style: natural daylight or believable cafe/street-food lighting, premium but not glossy stock-photo artificial, realistic Vietnamese tableware, herbs, ice, broth, coffee, sauce, or steam where appropriate.",
    "Avoid: readable text, menus, labels, logos, watermarks, fake signage, distorted hands, distorted faces, extra fingers, plastic-looking food, generic unrelated dishes, empty top-heavy framing, heavy blur over the main subject.",
  ].filter(Boolean).join(" ");
}

function execFileCapture(command, commandArgs, options = {}) {
  return new Promise((resolve, reject) => {
    execFile(
      command,
      commandArgs,
      { maxBuffer: 1024 * 1024 * 16, ...options },
      (error, stdout, stderr) => {
        if (error) {
          reject(new Error(`${command} failed: ${stderr || error.message}`));
          return;
        }
        resolve(stdout);
      }
    );
  });
}

function parseResultUrl(stdout) {
  let json;
  try {
    json = JSON.parse(stdout);
  } catch {
    throw new Error(`Higgsfield returned non-JSON output: ${stdout.slice(0, 240)}`);
  }
  const job = Array.isArray(json) ? json[0] : json;
  const url = job && (job.result_url || job.url || job.results?.[0]?.url);
  if (!url) {
    throw new Error(`Higgsfield result had no result_url: ${stdout.slice(0, 400)}`);
  }
  return url;
}

async function download(url, destination) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Download failed ${response.status} for ${url}`);
  }
  const arrayBuffer = await response.arrayBuffer();
  ensureDir(path.dirname(destination));
  fs.writeFileSync(destination, Buffer.from(arrayBuffer));
}

async function imageDimensions(imagePath) {
  const stdout = await execFileCapture("sips", [
    "-g",
    "pixelWidth",
    "-g",
    "pixelHeight",
    imagePath,
  ]);
  const width = Number((stdout.match(/pixelWidth: (\d+)/) || [])[1]);
  const height = Number((stdout.match(/pixelHeight: (\d+)/) || [])[1]);
  if (!width || !height) {
    throw new Error(`Could not read image dimensions for ${imagePath}`);
  }
  return { width, height };
}

async function normalizeToRuntimeJPEG(sourcePath, outputPath) {
  ensureDir(path.dirname(outputPath));
  await execFileCapture("ffmpeg", [
    "-y",
    "-i", sourcePath,
    "-vf", `scale=${runtimeWidth}:${runtimeHeight}:force_original_aspect_ratio=increase,crop=${runtimeWidth}:${runtimeHeight}`,
    "-frames:v", "1",
    "-q:v", "4",
    outputPath,
  ]);
}

function writeImageset(assetName, imagePath) {
  const imagesetPath = path.join(assetRoot, `${assetName}.imageset`);
  ensureDir(imagesetPath);
  for (const file of fs.readdirSync(imagesetPath)) {
    if (/\.(png|jpe?g)$/i.test(file)) {
      fs.unlinkSync(path.join(imagesetPath, file));
    }
  }
  const filename = `${slug(assetName)}-720q86.jpg`;
  const assetPath = path.join(imagesetPath, filename);
  fs.copyFileSync(imagePath, assetPath);
  writeJSON(path.join(imagesetPath, "Contents.json"), {
    images: [{ filename, idiom: "universal", scale: "1x" }],
    info: { author: "xcode", version: 1 },
  });
  return assetPath;
}

async function generateOne(row, profile, mode, force) {
  const settings = profileSettings[profile];
  const thumbnailPath = path.join(repoRoot, row.thumbnailAssetPath);
  const outputRoot = mode === "bakeoff" ? path.join(bakeoffRoot, profile, row.backdropAssetName) : path.join(sourceRoot, row.backdropAssetName);
  const sourcePath = path.join(outputRoot, `${row.backdropAssetName}-${profile}.png`);
  const jobPath = path.join(outputRoot, `${row.backdropAssetName}-${profile}.job.json`);
  const promptPath = path.join(outputRoot, `${row.backdropAssetName}-${profile}.prompt.txt`);
  const runtimePath = path.join(outputRoot, `${row.backdropAssetName}-${profile}-720q86.jpg`);

  ensureDir(outputRoot);
  fs.writeFileSync(promptPath, `${row.prompt}\n`);

  if (mode === "generate" && !force && !fs.existsSync(sourcePath)) {
    const bakeoff = row.bakeoff?.[profile];
    if (bakeoff?.sourceImagePath) {
      const bakeoffSourcePath = path.join(repoRoot, bakeoff.sourceImagePath);
      if (fs.existsSync(bakeoffSourcePath)) {
        fs.copyFileSync(bakeoffSourcePath, sourcePath);
      }
    }
  }

  if (!fs.existsSync(sourcePath) || force) {
    const stdout = await execFileCapture("higgsfield", [
      "generate",
      "create",
      "gpt_image_2",
      "--prompt", row.prompt,
      "--aspect_ratio", "9:16",
      "--resolution", settings.resolution,
      "--quality", settings.quality,
      "--image", thumbnailPath,
      "--wait",
      "--wait-timeout", "20m",
      "--json",
    ]);
    fs.writeFileSync(jobPath, stdout);
    await download(parseResultUrl(stdout), sourcePath);
  }

  await normalizeToRuntimeJPEG(sourcePath, runtimePath);
  const dimensions = await imageDimensions(runtimePath);
  if (dimensions.width !== runtimeWidth || dimensions.height !== runtimeHeight) {
    throw new Error(`${row.itemID} normalized to ${dimensions.width}x${dimensions.height}, expected ${runtimeWidth}x${runtimeHeight}`);
  }

  return { sourcePath, runtimePath, dimensions };
}

function selectRows(manifest, args, bakeoff) {
  let itemIDs = args.items;
  if (bakeoff && itemIDs.length === 0) {
    itemIDs = defaultBakeoffItemIDs;
  }
  let rows = manifest.rows ?? [];
  if (itemIDs.length > 0) {
    const wanted = new Set(itemIDs);
    rows = rows.filter((row) => wanted.has(row.itemID));
  } else if (!args.force) {
    rows = rows.filter((row) => row.status !== "imported" || !row.assetPath);
  }
  if (args.limit > 0) {
    rows = rows.slice(0, args.limit);
  }
  return rows;
}

async function runPool(items, concurrency, worker) {
  let index = 0;
  const failures = [];
  let completed = 0;
  const workers = Array.from({ length: Math.min(concurrency, items.length) }, async () => {
    while (index < items.length) {
      const item = items[index++];
      try {
        await worker(item);
        completed += 1;
        console.log(`[${completed}/${items.length}] ${item.label}`);
      } catch (error) {
        failures.push({ item, error });
        console.error(`[failed] ${item.label}: ${error.message}`);
      }
    }
  });
  await Promise.all(workers);
  return failures;
}

async function runBakeoff(args) {
  const manifest = loadOrBuildManifest();
  const rows = selectRows(manifest, args, true);
  const jobs = rows.flatMap((row) => args.profiles.map((profile) => ({ row, profile, label: `${row.itemID} ${profile}` })));
  console.log(`Generating bakeoff: ${jobs.length} image(s), concurrency ${args.concurrency}`);
  const failures = await runPool(jobs, args.concurrency, async ({ row, profile }) => {
    const result = await generateOne(row, profile, "bakeoff", args.force);
    row.bakeoff = {
      ...(row.bakeoff ?? {}),
      [profile]: {
        sourceImagePath: path.relative(repoRoot, result.sourcePath),
        runtimeImagePath: path.relative(repoRoot, result.runtimePath),
        width: result.dimensions.width,
        height: result.dimensions.height,
        sha256: hashFile(result.runtimePath),
      },
    };
  });
  manifest.generatedAt = new Date().toISOString();
  writeJSON(manifestPath, manifest);
  if (failures.length > 0) process.exit(1);
}

async function runGenerate(args) {
  const manifest = loadOrBuildManifest();
  const rows = selectRows(manifest, args, false);
  const jobs = rows.map((row) => ({ row, label: `${row.itemID} ${args.profile}` }));
  console.log(`Generating/importing ${jobs.length} menu backdrop image(s) with ${args.profile}, concurrency ${args.concurrency}`);
  const failures = await runPool(jobs, args.concurrency, async ({ row }) => {
    const result = await generateOne(row, args.profile, "generate", args.force);
    const assetPath = writeImageset(row.backdropAssetName, result.runtimePath);
    row.status = "imported";
    row.selectedProfile = args.profile;
    row.sourceImagePath = path.relative(repoRoot, result.sourcePath);
    row.assetPath = path.relative(repoRoot, assetPath);
    row.sha256 = hashFile(assetPath);
    row.reviewStatus = row.reviewStatus === "PENDING" ? "READY_FOR_REVIEW" : row.reviewStatus;
    row.reviewerNotes = `Higgsfield gpt_image_2 ${args.profile}; normalized to ${runtimeWidth}x${runtimeHeight} JPEG for menu photo backdrop review.`;
  });
  manifest.generatedAt = new Date().toISOString();
  manifest.statusCounts = countBy(manifest.rows, "status");
  manifest.reviewStatusCounts = countBy(manifest.rows, "reviewStatus");
  writeJSON(manifestPath, manifest);
  if (failures.length > 0) process.exit(1);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.buildManifest) {
    const manifest = buildManifest();
    console.log(`Wrote ${path.relative(repoRoot, manifestPath)} with ${manifest.rows.length} rows`);
  }
  if (args.bakeoff) {
    await runBakeoff(args);
  }
  if (args.generate) {
    await runGenerate(args);
  }
}

main().catch((error) => {
  console.error(error.stack || error.message);
  process.exit(1);
});
