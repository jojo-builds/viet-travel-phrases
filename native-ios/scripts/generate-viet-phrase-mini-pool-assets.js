#!/usr/bin/env node

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");
const { execFile } = require("child_process");

const repoRoot = path.resolve(__dirname, "..", "..");
const assetRoot = path.join(repoRoot, "native-ios", "Resources", "Assets.xcassets");
const packetDir = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-image-assets",
  "phrase-backdrop-mini-pools-2026-05-30"
);
const sourceDir = path.join(packetDir, "sources");
const runtimeDir = path.join(packetDir, "runtime");
const manifestPath = path.join(packetDir, "manifest.json");
const runtimeWidth = 720;
const runtimeHeight = 1556;

const sharedPromptTail = [
  "Photorealistic vertical 9:16 editorial travel photograph for SpeakLocal, a premium native iPhone phrasebook for travelers in Vietnam.",
  "The image will sit behind a white scrollable app sheet. Place the primary visual subject in the upper-middle safe zone, roughly 18% to 48% down from the top of the frame, so it remains visible when the content card is pulled down.",
  "Do not leave the top quarter as empty ceiling, blank wall, or plain sky. Keep the lower third calmer because it may sit behind the content card.",
  "Natural daylight or believable warm ambient light, real camera feel, premium travel-documentary style, not CGI, not illustration, not glossy stock.",
  "Vietnam-forward but not tourist-cliche; use practical traveler context, local material texture, tile, wood, glass, street light, greenery, luggage, tableware, or counters as appropriate.",
  "Strictly avoid readable text, signage, labels, logos, brand marks, license plates, watermarks, fake app UI, fake menus, distorted hands, distorted faces, extra fingers, injury, blood, panic, or emergency drama.",
].join(" ");

const assets = [
  {
    assetName: "BackdropPhrasePhoneCafeCharging",
    pool: "phone-connectivity",
    label: "phone charging at cafe",
    prompt: [
      "Scene: a smartphone face-down beside a charging cable, compact travel adapter, iced coffee glass, and small woven coaster on a Vietnamese cafe table.",
      "Composition: close editorial tabletop crop, camera angled slightly downward, with the phone, cable, adapter, and drink centered around the upper-middle safe zone rather than the lower third.",
      "Background: soft tropical window light, blurred plants and cafe woodwork, no people as the subject.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhrasePhoneSimSetup",
    pool: "phone-connectivity",
    label: "SIM setup still life",
    prompt: [
      "Scene: traveler phone setup still life with a blank SIM tray, SIM eject pin, passport cover turned away from camera, small pouch, and phone on a clean service counter.",
      "Make it clearly about SIM/eSIM setup without printed carrier branding or readable card text.",
      "Composition: close top-down flat-lay crop on the service counter; the phone, SIM tray, and eject pin must fill the upper-middle safe zone between 18% and 45% down from the top.",
      "Avoid street views, windows, distant backgrounds, tall empty counter space, or a person outside the shop; this should read immediately as SIM setup.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhrasePhoneAccessoryCounter",
    pool: "phone-connectivity",
    label: "phone accessory counter",
    prompt: [
      "Scene: small Vietnamese mobile accessories counter with neutral charger cables, power banks, and phone cases arranged neatly.",
      "Composition: close counter crop with accessories filling the upper-middle safe zone, not a distant shop interior.",
      "Use shallow depth of field; crop or blur all packaging so there is no readable text or brand.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhrasePhoneAirportCharging",
    pool: "phone-connectivity",
    label: "airport charging",
    prompt: [
      "Scene: airport lounge charging still life with a phone plugged in beside carry-on luggage, a compact charger, and soft glass terminal light with Vietnamese tropical greenery outside.",
      "Composition: the plugged-in phone, cable, charger, and luggage handle should be visible in the upper-middle safe zone, with calmer floor or counter texture below.",
      "Object-focused composition with no visible people. No flight boards, no signs, no airline branding, no readable terminal text.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseEssentialsWaterCounter",
    pool: "everyday-services",
    label: "water and essentials counter",
    prompt: [
      "Scene: compact Vietnamese convenience-store counter with unbranded water bottles, tissues, hand sanitizer, and a small woven basket.",
      "Make it feel like a practical traveler errand; all packaging must be blank, cropped, turned away, or unreadable.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseEssentialsWashroomSink",
    pool: "everyday-services",
    label: "washroom sink",
    prompt: [
      "Scene: clean public washroom sink area with tile, mirror edge, soap dispenser, folded paper towels, and a small plant.",
      "No bathroom signs, no icons with text, no people, no grime; calm and useful.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseEssentialsLaundryCopy",
    pool: "everyday-services",
    label: "laundry and copy counter",
    prompt: [
      "Scene: small neighborhood service counter with neatly folded laundry, a simple printer/copier corner, receipt paper turned blank, and warm Vietnamese shop light.",
      "No readable notices, no brand logos, no fake flyers.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseEssentialsPersonalCare",
    pool: "everyday-services",
    label: "personal care shelf",
    prompt: [
      "Scene: personal-care travel shelf with sunscreen tube turned away, toothbrush, plain soap, tissues, and water bottle on a quiet service counter.",
      "Keep all labels out of focus or hidden; clean, premium, not medical.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseHealthPharmacyCounter",
    pool: "calm-help-health",
    label: "pharmacy counter",
    prompt: [
      "Scene: calm Vietnamese pharmacy counter with medicine boxes deliberately turned away or blurred, small basket, thermometer, and soft green-white interior light.",
      "No readable medicine names, no patients, no injury; reassuring and practical.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseHealthClinicReception",
    pool: "calm-help-health",
    label: "clinic reception",
    prompt: [
      "Scene: quiet clinic reception desk with a glass of water, appointment clipboard facing down, plant, and clean waiting chairs in the background.",
      "No wall signs, no readable notices, no doctor/patient faces; calm travel-help mood.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseHelpHotelDesk",
    pool: "calm-help-health",
    label: "hotel help desk",
    prompt: [
      "Scene: warm hotel or guesthouse front desk in Vietnam with brass bell, room key without number, phone handset, and small luggage near the counter.",
      "No readable guestbook text, no staff face as subject; helpful and safe.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseHelpQuietServiceDesk",
    pool: "calm-help-health",
    label: "quiet assistance desk",
    prompt: [
      "Scene: calm travel assistance desk with blank notepad, pen, water glass, small plant, and softly blurred lobby background.",
      "Object-focused composition; put the notepad, pen, water glass, and plant clearly in the upper-middle safe zone. No signs, no emergency symbols, no uniforms, no drama; designed for help and problem-solving phrases.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseTransportTaxiCurb",
    pool: "transport-directions",
    label: "taxi curb",
    prompt: [
      "Scene: Vietnam taxi pickup curb with generic taxi shapes, carry-on luggage, shaded sidewalk, and warm late-afternoon city light.",
      "No readable license plates, no company logos, no road signs; traveler movement should be clear.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseTransportStationPlatform",
    pool: "transport-directions",
    label: "station platform",
    prompt: [
      "Scene: train or bus station platform in Vietnam with luggage, benches, tropical light, and vehicles softly in the background.",
      "No readable route signs, no schedule boards, no brand marks; clean and navigational.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseTransportStreetMap",
    pool: "transport-directions",
    label: "street map moment",
    prompt: [
      "Scene: traveler navigation still life on a cafe or hotel table: phone face-down, folded blank map shape, pen, coffee, and motorbike street blur outside.",
      "Composition: close table crop with the phone, folded map, pen, and coffee sitting clearly in the upper-middle safe zone so the navigation objects remain visible behind a lowered app sheet.",
      "No readable map labels or phone UI; make directions and getting-around feel obvious through objects.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseTransportAirportCurb",
    pool: "transport-directions",
    label: "airport curb",
    prompt: [
      "Scene: airport arrivals curb in Vietnam with luggage cart, generic car/taxi silhouettes, palm greenery, and glass terminal architecture.",
      "No airline logos, no terminal text, no license plates, no readable wayfinding.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseMarketPayment",
    pool: "market-payment",
    label: "market payment",
    prompt: [
      "Scene: Vietnamese market stall payment moment with fruit, woven basket, cash, simple calculator with no readable display, and a small receipt turned blank.",
      "No price signs, no readable labels, no faces as subject; useful for money and shopping phrases.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseFoodOrderCounter",
    pool: "food-ordering",
    label: "food order counter",
    prompt: [
      "Scene: casual Vietnamese food order counter with bowl, chopsticks, herbs, condiment jars, and warm street-food light.",
      "No menu boards, no readable labels, no brand marks; inviting but not dish-specific.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseSightTicketBooth",
    pool: "sightseeing-info",
    label: "ticket booth",
    prompt: [
      "Scene: attraction ticket or information counter in Vietnam with blank tickets, pen, shaded courtyard greenery, and heritage-style wood or stone detail.",
      "Object/counter-focused composition with no visible faces. No readable attraction names, signs, prices, or posters; useful for ticket/entrance/tour phrases.",
    ].join(" "),
  },
  {
    assetName: "BackdropPhraseGreetingCafeDoorway",
    pool: "greetings-conversation",
    label: "cafe doorway conversation",
    prompt: [
      "Scene: warm Vietnamese cafe or shop doorway with two people as soft silhouettes only, coffee cups on a small table, plants, and welcoming morning light.",
      "No readable storefront text, no faces in sharp focus; suited to greetings and simple conversation phrases.",
    ].join(" "),
  },
];

function parseArgs(rawArgs) {
  const args = {
    profile: "1k-high",
    concurrency: 2,
    force: false,
    limit: 0,
    assets: [],
  };
  for (let i = 0; i < rawArgs.length; i += 1) {
    const arg = rawArgs[i];
    if (arg === "--force") {
      args.force = true;
    } else if (arg.startsWith("--")) {
      const key = arg.slice(2);
      const value = rawArgs[i + 1];
      if (!value || value.startsWith("--")) usage();
      i += 1;
      if (key === "profile") args.profile = value;
      else if (key === "concurrency") args.concurrency = Math.max(1, Number(value) || args.concurrency);
      else if (key === "limit") args.limit = Number(value) || 0;
      else if (key === "assets") args.assets = value.split(",").map((item) => item.trim()).filter(Boolean);
      else usage();
    } else {
      usage();
    }
  }
  if (!profileSettings()[args.profile]) usage();
  return args;
}

function usage() {
  console.error(`
Usage:
  node native-ios/scripts/generate-viet-phrase-mini-pool-assets.js [--profile 1k-high] [--limit 4] [--concurrency 2] [--force]

Generates app-owned phrase backdrop mini-pool images with Higgsfield gpt_image_2,
normalizes them to ${runtimeWidth}x${runtimeHeight} JPEG, imports each image into
Assets.xcassets, and writes the production manifest.
`);
  process.exit(2);
}

function profileSettings() {
  return {
    "1k-low": { resolution: "1k", quality: "low" },
    "1k-medium": { resolution: "1k", quality: "medium" },
    "1k-high": { resolution: "1k", quality: "high" },
    "2k-low": { resolution: "2k", quality: "low" },
    "2k-medium": { resolution: "2k", quality: "medium" },
    "2k-high": { resolution: "2k", quality: "high" },
  };
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function writeJSON(filePath, value) {
  ensureDir(path.dirname(filePath));
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function readJSONIfExists(filePath) {
  if (!fs.existsSync(filePath)) return null;
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function slug(value) {
  return String(value)
    .replace(/([a-z0-9])([A-Z])/g, "$1-$2")
    .replace(/[^A-Za-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .toLowerCase();
}

function hashFile(filePath) {
  return crypto.createHash("sha256").update(fs.readFileSync(filePath)).digest("hex");
}

function execFileCapture(command, commandArgs) {
  return new Promise((resolve, reject) => {
    execFile(command, commandArgs, { maxBuffer: 1024 * 1024 * 16 }, (error, stdout, stderr) => {
      if (error) {
        reject(new Error(`${command} failed: ${stderr || error.message}`));
        return;
      }
      resolve(stdout);
    });
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

function buildPrompt(asset) {
  return `${asset.prompt} ${sharedPromptTail}`;
}

function writeImageset(assetName, runtimePath) {
  const imagesetPath = path.join(assetRoot, `${assetName}.imageset`);
  ensureDir(imagesetPath);
  for (const file of fs.readdirSync(imagesetPath)) {
    if (/\.(png|jpe?g|webp)$/i.test(file)) {
      fs.unlinkSync(path.join(imagesetPath, file));
    }
  }
  const filename = `${slug(assetName)}-720q86.jpg`;
  const assetPath = path.join(imagesetPath, filename);
  fs.copyFileSync(runtimePath, assetPath);
  writeJSON(path.join(imagesetPath, "Contents.json"), {
    images: [{ filename, idiom: "universal", scale: "1x" }],
    info: { author: "xcode", version: 1 },
  });
  return assetPath;
}

async function generateOne(asset, args) {
  const settings = profileSettings()[args.profile];
  const prompt = buildPrompt(asset);
  const sourcePath = path.join(sourceDir, `${asset.assetName}-${args.profile}.png`);
  const runtimePath = path.join(runtimeDir, `${asset.assetName}-720q86.jpg`);
  const jobPath = path.join(sourceDir, `${asset.assetName}-${args.profile}.job.json`);
  const promptPath = path.join(sourceDir, `${asset.assetName}-${args.profile}.prompt.txt`);

  ensureDir(sourceDir);
  fs.writeFileSync(promptPath, `${prompt}\n`);

  if (!fs.existsSync(sourcePath) || args.force) {
    const stdout = await execFileCapture("higgsfield", [
      "generate",
      "create",
      "gpt_image_2",
      "--prompt", prompt,
      "--aspect_ratio", "9:16",
      "--resolution", settings.resolution,
      "--quality", settings.quality,
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
    throw new Error(`${asset.assetName} normalized to ${dimensions.width}x${dimensions.height}`);
  }
  const assetPath = writeImageset(asset.assetName, runtimePath);

  return {
    ...asset,
    model: "gpt_image_2",
    profile: args.profile,
    sourceImagePath: path.relative(repoRoot, sourcePath),
    runtimeImagePath: path.relative(repoRoot, runtimePath),
    assetPath: path.relative(repoRoot, assetPath),
    promptPath: path.relative(repoRoot, promptPath),
    jobPath: fs.existsSync(jobPath) ? path.relative(repoRoot, jobPath) : "",
    width: dimensions.width,
    height: dimensions.height,
    sha256: hashFile(assetPath),
  };
}

async function runPool(items, concurrency, worker) {
  let index = 0;
  let completed = 0;
  const failures = [];
  const workers = Array.from({ length: Math.min(concurrency, items.length) }, async () => {
    while (index < items.length) {
      const item = items[index++];
      try {
        const result = await worker(item);
        completed += 1;
        console.log(`[${completed}/${items.length}] ${item.assetName}`);
        item.result = result;
      } catch (error) {
        failures.push({ item, error });
        console.error(`[failed] ${item.assetName}: ${error.message}`);
      }
    }
  });
  await Promise.all(workers);
  return failures;
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  let selectedAssets = assets;
  if (args.assets.length > 0) {
    const wanted = new Set(args.assets);
    selectedAssets = assets.filter((asset) => wanted.has(asset.assetName));
  }
  if (args.limit > 0) {
    selectedAssets = selectedAssets.slice(0, args.limit);
  }

  const jobs = selectedAssets.map((asset) => ({ ...asset }));
  const failures = await runPool(jobs, args.concurrency, (asset) => generateOne(asset, args));
  const previousManifest = readJSONIfExists(manifestPath);
  const rowsByAssetName = new Map(
    (previousManifest?.rows ?? []).map((row) => [row.assetName, row])
  );
  for (const asset of jobs) {
    if (asset.result) {
      rowsByAssetName.set(asset.result.assetName, asset.result);
    }
  }
  const rows = assets
    .map((asset) => rowsByAssetName.get(asset.assetName))
    .filter(Boolean);

  writeJSON(manifestPath, {
    generatedAt: "2026-05-30T00:00:00Z",
    source: "Higgsfield gpt_image_2 text-to-image jobs",
    model: "gpt_image_2",
    profile: args.profile,
    targetRuntimeSize: { width: runtimeWidth, height: runtimeHeight },
    intent: "Semantic mini-pool backdrops for Viet phrase/listing pages that use the shared photo-backdrop sheet layout.",
    totalAssets: rows.length,
    pools: [...new Set(rows.map((row) => row.pool))].sort(),
    rows,
  });

  if (failures.length > 0) {
    process.exitCode = 1;
  }

  console.log(JSON.stringify({
    ok: failures.length === 0,
    imported: rows.length,
    failed: failures.length,
    manifest: path.relative(repoRoot, manifestPath),
  }, null, 2));
}

main().catch((error) => {
  console.error(error.stack || error.message);
  process.exit(1);
});
