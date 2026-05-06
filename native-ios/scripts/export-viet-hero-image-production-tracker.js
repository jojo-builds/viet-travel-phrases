#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const outputRoot = path.join(
  repoRoot,
  "docs",
  "editorial-exports",
  "viet-image-assets",
  "hero-image-production-001"
);

const authoredPagesPath = path.join(repoRoot, "native-ios", "Resources", "viet-authored-listing-pages.json");
const heroFollowupsPath = path.join(
  repoRoot,
  "docs",
  "content-audits",
  "viet-canonical-editorial-finish-all-001",
  "hero-image-followups.csv"
);
const assetsRoot = path.join(repoRoot, "native-ios", "Resources", "Assets.xcassets");
const dragonReceiptPath = path.join(repoRoot, "docs", "task-results", "TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001.md");
const baNaReceiptPath = path.join(repoRoot, "docs", "task-results", "TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001.md");

const createdAssetReceipts = new Map([
  ["HeroDragonBridge", "docs/task-results/TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001.md"],
  ["HeroBaNaHills", "docs/task-results/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001.md"],
  ["HeroVietnamMasthead", "native-ios/App/Design/NativeGlass.swift"],
  ["HeroXinChao", "native-ios/Resources/Assets.xcassets/HeroXinChao.imageset/Contents.json"],
]);

const p0IDs = new Set([
  "viet-family-city-danang-place-airport",
  "viet-family-city-danang-place-bach-dang-street",
  "viet-family-city-danang-place-ba-na-hills",
  "viet-family-city-danang-place-dragon-bridge",
  "viet-family-city-danang-place-han-market",
  "viet-family-city-danang-place-linh-ung-pagoda",
  "viet-family-city-danang-place-marble-mountains",
  "viet-family-city-danang-place-my-khe",
  "viet-family-city-danang-place-nen",
  "viet-family-city-danang-place-nguyen-van-linh-street",
  "viet-family-city-danang-place-son-tra",
  "viet-family-city-danang-place-vo-nguyen-giap-street",
  "viet-family-city-hanoi-place-bun-cha-huong-lien",
  "viet-family-city-hanoi-place-pho-bat-dan",
  "viet-family-city-hoian-place-cao-lau-city",
  "viet-family-city-hue-place-bun-bo-city",
]);

const cityHubRows = [
  {
    pageID: "browse-city-danang",
    title: "Da Nang / Đà Nẵng",
    profile: "cityHub",
    heroImageName: "HeroCityDanang",
    issue: "",
    followUp: "Created in TASK-VIET-HERO-IMAGE-PRODUCTION-001; keep Dragon Bridge/river cues visible in the live crop.",
  },
  {
    pageID: "browse-city-hanoi",
    title: "Hanoi / Hà Nội",
    profile: "cityHub",
    heroImageName: "HeroCityHanoi",
    issue: "",
    followUp: "Created in TASK-VIET-HERO-IMAGE-PRODUCTION-001; keep Old Quarter/lake cues visible in the live crop.",
  },
  {
    pageID: "browse-city-hoian",
    title: "Hoi An / Hội An",
    profile: "cityHub",
    heroImageName: "HeroCityHoian",
    issue: "",
    followUp: "Created in TASK-VIET-HERO-IMAGE-PRODUCTION-001; keep lantern/old-town cues visible in the live crop.",
  },
  {
    pageID: "browse-city-hue",
    title: "Hue / Huế",
    profile: "cityHub",
    heroImageName: "HeroCityHue",
    issue: "",
    followUp: "Created in TASK-VIET-HERO-IMAGE-PRODUCTION-001; keep citadel/Perfume River cues visible in the live crop.",
  },
  {
    pageID: "browse-city-hcmc",
    title: "Ho Chi Minh City / Thành phố Hồ Chí Minh",
    profile: "cityHub",
    heroImageName: "HeroCityHcmc",
    issue: "",
    followUp: "Created in TASK-VIET-HERO-IMAGE-PRODUCTION-001; keep Saigon skyline/market cues visible in the live crop.",
  },
];

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function csvEscape(value) {
  const text = value == null ? "" : String(value);
  if (/[",\n\r]/.test(text)) {
    return `"${text.replace(/"/g, '""')}"`;
  }
  return text;
}

function writeCsv(filePath, rows) {
  if (rows.length === 0) {
    fs.writeFileSync(filePath, "", "utf8");
    return;
  }
  const headers = Object.keys(rows[0]);
  const lines = [headers.join(",")];
  for (const row of rows) {
    lines.push(headers.map((header) => csvEscape(row[header])).join(","));
  }
  fs.writeFileSync(filePath, `${lines.join("\n")}\n`, "utf8");
}

function parseCsv(text) {
  const rows = [];
  let current = [];
  let value = "";
  let inQuotes = false;

  for (let index = 0; index < text.length; index += 1) {
    const char = text[index];
    const next = text[index + 1];
    if (inQuotes && char === '"' && next === '"') {
      value += '"';
      index += 1;
    } else if (char === '"') {
      inQuotes = !inQuotes;
    } else if (!inQuotes && char === ",") {
      current.push(value);
      value = "";
    } else if (!inQuotes && (char === "\n" || char === "\r")) {
      if (char === "\r" && next === "\n") {
        index += 1;
      }
      current.push(value);
      if (current.some((cell) => cell.length > 0)) {
        rows.push(current);
      }
      current = [];
      value = "";
    } else {
      value += char;
    }
  }

  if (value.length || current.length) {
    current.push(value);
    rows.push(current);
  }

  const [headers, ...bodyRows] = rows;
  return bodyRows.map((row) => Object.fromEntries(headers.map((header, index) => [header, row[index] ?? ""])));
}

function pngDimensions(filePath) {
  if (!fs.existsSync(filePath)) {
    return "";
  }
  const buffer = fs.readFileSync(filePath);
  if (buffer.length < 24 || buffer.toString("ascii", 1, 4) !== "PNG") {
    return "";
  }
  return `${buffer.readUInt32BE(16)} x ${buffer.readUInt32BE(20)}`;
}

function firstPngInImageset(heroImageName) {
  const imageset = path.join(assetsRoot, `${heroImageName}.imageset`);
  if (!fs.existsSync(imageset)) {
    return "";
  }
  const png = fs.readdirSync(imageset).find((file) => file.endsWith(".png"));
  return png ? path.join(imageset, png) : "";
}

function relative(filePath) {
  return filePath ? path.relative(repoRoot, filePath) : "";
}

function pageLookup() {
  const data = JSON.parse(fs.readFileSync(authoredPagesPath, "utf8"));
  return new Map(data.pages.map((page) => [page.id, page]));
}

function imagePromptFor(profile, title) {
  const base =
    "Create an app-owned photographic-style hero image for a Vietnamese travel phrasebook. No readable text, no logos, no watermarks, no faces as the subject. Keep the main landmark/object recognizable inside the upper third because the iOS masthead crops a shallow horizontal band.";
  if (profile === "cityHub") {
    return `${base} Show ${title} as a calm city travel-mode scene with one strong local cue and enough sky/soft background for the page title overlay.`;
  }
  if (profile === "restaurant") {
    return `${base} Show ${title} through a tasteful restaurant/street-food table or entrance mood without copying a real storefront sign or brand logo.`;
  }
  if (profile === "dish") {
    return `${base} Show ${title} as an appetizing Vietnamese dish close-up with clean natural light and room for the masthead fade.`;
  }
  if (profile === "streetDriver") {
    return `${base} Show ${title} as a driver/street context with road, curb, or address cues. Avoid fake readable street-sign text.`;
  }
  return `${base} Show ${title} with the real visual cue a first-time traveler would recognize.`;
}

function priorityFor(row) {
  if (row.heroImageName && row.heroImageName.startsWith("BrowseCollection")) {
    return "P1";
  }
  if (row.heroImageName && !row.issue) {
    return "DONE";
  }
  if (p0IDs.has(row.pageID) || row.pageID === "browse-city-danang") {
    return "P0";
  }
  if (row.pageID.startsWith("browse-city-")) {
    return "P1";
  }
  if (row.profile === "restaurant" || row.profile === "dish") {
    return "P1";
  }
  if (row.profile === "landmark" && /airport|market|bridge|beach|station|museum|pagoda|river|imperial|ancient|cathedral/i.test(row.pageID)) {
    return "P1";
  }
  return "P2";
}

function statusFor(row, assetPath) {
  if (row.heroImageName && row.heroImageName.startsWith("BrowseCollection")) {
    return "HAS_COLLECTION_ASSET_NEEDS_CROP_AUDIT";
  }
  if (isPageSpecificHero(row.heroImageName) && assetPath) {
    return "SHIPPED_REVIEW_CROP";
  }
  if (row.heroImageName === "HeroNeutralMasthead" || row.issue === "neutral_city_fallback") {
    return "NEEDS_OWNED_ASSET";
  }
  if (row.heroImageName && assetPath) {
    return "HAS_GENERIC_OR_SHARED_ASSET";
  }
  return "NEEDS_OWNED_ASSET";
}

function trackerRows() {
  const pages = pageLookup();
  const followups = parseCsv(fs.readFileSync(heroFollowupsPath, "utf8"));
  const rows = [...cityHubRows, ...followups].map((row) => {
    const page = pages.get(row.pageID);
    const currentHeroImageName = page?.heroImageName
      ?? page?.metadata?.editorialImport?.heroImageName
      ?? row.heroImageName
      ?? "";
    const assetPath = currentHeroImageName ? firstPngInImageset(currentHeroImageName) : "";
    const dimensions = pngDimensions(assetPath);
    const currentRow = { ...row, heroImageName: currentHeroImageName };
    const priority = priorityFor(currentRow);
    const status = statusFor(currentRow, assetPath);
    const targetAssetName = currentHeroImageName && currentHeroImageName !== "HeroNeutralMasthead"
      ? currentHeroImageName
      : suggestedHeroName(row.pageID);
    const title = row.title || `${page?.title ?? ""} / ${page?.englishTitle ?? ""}`.trim();
    return {
      priority,
      status,
      pageID: row.pageID,
      title,
      profile: row.profile || pageProfile(page),
      currentHeroImageName,
      targetHeroImageName: targetAssetName,
      assetPath: relative(assetPath),
      currentPx: dimensions,
      targetRepoPx: "853 x 1844",
      sourceMasterPx: ">= 1600 x 2400 preferred",
      targetComponent: page?.id ? "PhraseListingView HeroMastheadImage" : "Browse city/collection masthead",
      focalPoint: focalPointFor(row.profile || pageProfile(page)),
      safeZone: "Recognizable subject must survive the top 276pt masthead crop; keep the key visual in the upper third and center 70% width.",
      currentIssue: row.issue || "",
      nextAction: nextActionFor(status, currentRow),
      generationPrompt: imagePromptFor(row.profile || pageProfile(page), title),
      negativePrompt: "no readable text, no watermark, no logos, no fake signs, no unrelated Ha Long Bay/karst imagery for city-specific pages, no people as the main subject",
      proofRequired: "Simulator screenshot plus phone spot-check before DONE",
      sourceOwnership: sourceOwnership(currentHeroImageName),
      receiptOrProof: receiptForHero(currentHeroImageName) || row.followUp || "",
      notes: notesFor(currentRow),
    };
  });

  return rows.sort((a, b) => {
    const rank = { DONE: 0, P0: 1, P1: 2, P2: 3 };
    return (rank[a.priority] ?? 9) - (rank[b.priority] ?? 9) || a.profile.localeCompare(b.profile) || a.title.localeCompare(b.title);
  });
}

function pageProfile(page) {
  const categories = page?.categoryIDs ?? [];
  if (categories.includes("derived-place-phrases")) return "derivedPhrase";
  if (categories.includes("city-page-kind-place") && categories.includes("content-role-dish")) return "dish";
  if (categories.includes("city-page-kind-place") && categories.includes("place-kind-restaurant")) return "restaurant";
  if (categories.includes("city-page-kind-place") && categories.includes("place-kind-street")) return "streetDriver";
  if (categories.includes("city-page-kind-place")) return "landmark";
  return "phrase";
}

function suggestedHeroName(pageID) {
  return `Hero${pageID
    .replace(/^viet-family-/, "")
    .replace(/^browse-/, "")
    .split(/[-_]+/)
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("")}`;
}

function focalPointFor(profile) {
  switch (profile) {
  case "restaurant":
  case "dish":
    return "center 50%, upper 32%; food or entrance must remain visible after fade";
  case "streetDriver":
    return "center 50%, upper 28%; road/address context, not fake signage";
  case "cityHub":
    return "center 50%, upper 30%; one clear city cue, not a generic Vietnam postcard";
  default:
    return "center 50%, upper 25-35%; landmark silhouette must be recognizable";
  }
}

function sourceOwnership(heroImageName) {
  if (!heroImageName) {
    return "missing";
  }
  if (heroImageName === "HeroNeutralMasthead") {
    return "neutral generated fallback";
  }
  if (isGeneratedHero(heroImageName) || createdAssetReceipts.has(heroImageName)) {
    return "app-owned generated asset";
  }
  return "existing app asset; audit ownership before reusing broadly";
}

function isPageSpecificHero(heroImageName) {
  return Boolean(heroImageName)
    && heroImageName !== "HeroNeutralMasthead"
    && heroImageName !== "HeroVietnamMasthead"
    && !heroImageName.startsWith("BrowseCollection");
}

function isGeneratedHero(heroImageName) {
  return /^Hero(City|Category|Country|Compact)/.test(heroImageName);
}

function receiptForHero(heroImageName) {
  if (createdAssetReceipts.has(heroImageName)) {
    return createdAssetReceipts.get(heroImageName);
  }
  if (isGeneratedHero(heroImageName)) {
    return "docs/editorial-exports/viet-image-assets/hero-image-production-001/generated_hero_assets.json";
  }
  return "";
}

function nextActionFor(status, row) {
  if (status === "SHIPPED_REVIEW_CROP") {
    return "Review the live crop on phone. If the subject is weak in the masthead, regenerate with the subject higher and larger.";
  }
  if (status === "HAS_COLLECTION_ASSET_NEEDS_CROP_AUDIT") {
    return "Audit the existing collection asset against the hero crop standard; replace with a full hero asset if it reads like a small card image.";
  }
  if (row.pageID.startsWith("browse-city-")) {
    return "Generate city hub artwork, wire the masthead image mapping, and capture city hub proof.";
  }
  return "Generate owned/licensed hero, crop to repo target, wire heroImageName through source/resources/SQLite, and capture simulator proof.";
}

function notesFor(row) {
  if (row.heroImageName === "HeroDragonBridge") {
    return "Created in TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001. Improve by checking whether the bridge stays recognizable inside the shallow masthead crop.";
  }
  if (row.heroImageName === "HeroBaNaHills") {
    return "Created in TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001. Keep Golden Bridge/cable-car cues visible in the upper crop.";
  }
  return row.followUp || "";
}

function standardsRows() {
  return [
    {
      area: "Repo asset size",
      standard: "Normalize committed hero PNGs to 853 x 1844 until the native renderer standard changes.",
      why: "Matches existing HeroVietnamMasthead, HeroXinChao, HeroBaNaHills, and HeroDragonBridge assets.",
    },
    {
      area: "Source master",
      standard: "Keep or generate a larger master when possible, preferred >= 1600 x 2400.",
      why: "Lets us recrop if the phone masthead hides the subject.",
    },
    {
      area: "Visible crop",
      standard: "The first app viewport shows a 276pt masthead window with a fade; the subject must be recognizable in the upper third.",
      why: "Standalone images can look good while the phone crop looks weak.",
    },
    {
      area: "Focal zone",
      standard: "Place the primary subject around x=50%, y=25-35%, with no important detail only in the lower half.",
      why: "HeroMastheadImage scales to fill and clips a shallow horizontal band.",
    },
    {
      area: "Copy safety",
      standard: "No baked-in text, fake signs, logos, watermarks, or UI labels inside generated art.",
      why: "Text artifacts are common in generated images and break trust.",
    },
    {
      area: "Place specificity",
      standard: "Specific landmarks must not use generic Vietnam or Ha Long Bay-style images.",
      why: "The image must reassure the traveler that they opened the exact place.",
    },
    {
      area: "Ownership",
      standard: "Use app-owned generated art or a documented licensed source; never scrape an image into the app.",
      why: "Keeps the app legally safe and repeatable.",
    },
    {
      area: "Proof",
      standard: "Every shipped hero needs source/resource/SQLite wiring proof plus simulator screenshot; phone spot-check for P0.",
      why: "The asset is only done after the rendered page looks right.",
    },
  ];
}

function qaGateRows() {
  return [
    { gate: "asset_exists", severity: "FAIL", rule: "targetHeroImageName has an imageset with Contents.json and a PNG." },
    { gate: "metadata_wired", severity: "FAIL", rule: "heroImageName is present in source, generated listing JSON, and SQLite when needed." },
    { gate: "crop_proof", severity: "FAIL", rule: "Simulator screenshot shows the actual masthead crop and page title area." },
    { gate: "phone_spot_check", severity: "WARN", rule: "P0 assets should be checked on the physical phone before marking DONE." },
    { gate: "recognizable_subject", severity: "FAIL", rule: "The page-specific landmark/place/food is recognizable in the first viewport." },
    { gate: "no_generic_vietnam", severity: "FAIL", rule: "Specific places cannot use unrelated generic Vietnam imagery." },
    { gate: "no_text_artifacts", severity: "FAIL", rule: "No readable generated text, fake signs, labels, watermarks, or logos." },
    { gate: "no_wrong_place_cues", severity: "FAIL", rule: "Do not show Ha Long Bay/karst boats for Da Nang, Hanoi, Hue, Hoi An, or restaurant-specific pages." },
    { gate: "focal_zone", severity: "FAIL", rule: "Important visual detail is inside the center 70% width and upper third." },
    { gate: "safe_fade", severity: "WARN", rule: "Bottom fade should blend to page background without making the subject disappear." },
  ];
}

function promptRecipeRows() {
  return [
    {
      profile: "landmark",
      visualRecipe: "A recognizable view of the landmark or its most familiar physical cue, with soft sky/background for the fade.",
      focus: "Landmark in upper third, centered, not tiny.",
      avoid: "generic Vietnam postcards, wrong city cues, fake readable signage",
    },
    {
      profile: "macroAttraction",
      visualRecipe: "A journey-place scene showing the attraction's strongest cue, such as cable car, bridge, entrance, or mountain setting.",
      focus: "One clear attraction cue in upper crop.",
      avoid: "prices, hours, crowds as the subject, blog-poster composition",
    },
    {
      profile: "cityHub",
      visualRecipe: "A calm city travel-mode scene with one or two instantly recognizable city cues.",
      focus: "City cue in upper third; enough soft area for title overlay.",
      avoid: "random tourist collage, generic Vietnam masthead, overbusy skyline",
    },
    {
      profile: "restaurant",
      visualRecipe: "A tasteful restaurant/table/food-service scene tied to the restaurant type without copying private signage.",
      focus: "Dish/table/entrance mood in upper-middle crop.",
      avoid: "fake brand signs, reviews/ratings, awards, staff faces as subject",
    },
    {
      profile: "dish",
      visualRecipe: "Natural-light food close-up with the dish recognizable and not overstyled.",
      focus: "Bowl/plate in center upper crop.",
      avoid: "westernized plating if the dish should look local, text labels",
    },
    {
      profile: "streetDriver",
      visualRecipe: "Driver-facing road/address context, curb, street perspective, or map-like visual language.",
      focus: "Road/curb/driver cue in upper third.",
      avoid: "fake street-sign text, unreadable signs, generic highway",
    },
  ];
}

function manifestRows(rows) {
  const counts = rows.reduce((acc, row) => {
    acc[row.status] = (acc[row.status] ?? 0) + 1;
    return acc;
  }, {});
  return [
    { key: "generatedAt", value: new Date().toISOString() },
    { key: "assetTrackerRows", value: rows.length },
    { key: "sourceAudit", value: path.relative(repoRoot, heroFollowupsPath) },
    { key: "authoredPages", value: path.relative(repoRoot, authoredPagesPath) },
    { key: "existingHeroAssets", value: fs.readdirSync(assetsRoot).filter((name) => name.startsWith("Hero") && name.endsWith(".imageset")).sort().join(", ") },
    { key: "statusCounts", value: JSON.stringify(counts) },
    { key: "rendererComponent", value: "native-ios/App/Design/NativeGlass.swift::HeroMastheadImage" },
    { key: "dragonBridgeReceipt", value: fs.existsSync(dragonReceiptPath) ? path.relative(repoRoot, dragonReceiptPath) : "" },
    { key: "baNaReceipt", value: fs.existsSync(baNaReceiptPath) ? path.relative(repoRoot, baNaReceiptPath) : "" },
  ];
}

function writeReadme(rows) {
  const p0Open = rows.filter((row) => row.priority === "P0" && row.status !== "SHIPPED_REVIEW_CROP");
  const readme = `# Viet Hero Image Production Tracker

This packet is the durable workflow surface for SpeakLocal Vietnam hero images.

The Google Sheet is the easy review surface. These CSV/JSON files are the repo mirror so the queue can be regenerated and audited without relying on memory from a prior thread.

## Why This Exists

The app masthead is a shallow cropped viewport over the source image. A generated image can look good as a standalone file and still fail in the phone hero if the subject lands too low, too small, or outside the crop.

The tracker therefore records:

- the current asset and dimensions;
- the target hero name;
- page type and priority;
- focal-zone requirements;
- generation prompt guidance;
- QA gates;
- simulator/phone proof requirements.

## Current Standard

- Committed repo PNG target: \`853 x 1844\` until the native renderer standard changes.
- Preferred source master: \`>= 1600 x 2400\`.
- The main subject must be visible in the upper third and center 70% width.
- No readable generated text, fake signage, logos, or watermarks.
- Specific pages must not use generic Vietnam imagery.

## Immediate Queue

Open P0 rows: ${p0Open.length}

High-value P0 examples include Da Nang city, Marble Mountains, Linh Ung Pagoda, My Khe Beach, Da Nang Airport, Nén Đà Nẵng, Nguyễn Văn Linh Street, Bạch Đằng Street, Bún chả Hương Liên, Phở Bát Đàn, Bún bò Huế, and Cao lầu.

## Files

- \`asset_tracker.csv\`: all tracked hero image rows.
- \`image_queue.csv\`: incomplete rows sorted by priority.
- \`standards.csv\`: current app asset/crop standards.
- \`prompt_recipes.csv\`: reusable image prompt recipes by page profile.
- \`qa_gates.csv\`: required checks before marking an asset done.
- \`manifest.json\`: counts and source paths.
`;
  fs.writeFileSync(path.join(outputRoot, "README.md"), readme, "utf8");
}

function main() {
  ensureDir(outputRoot);
  const rows = trackerRows();
  const queueRows = rows.filter((row) => row.status !== "SHIPPED_REVIEW_CROP");
  writeCsv(path.join(outputRoot, "asset_tracker.csv"), rows);
  if (queueRows.length > 0) {
    writeCsv(path.join(outputRoot, "image_queue.csv"), queueRows);
  } else {
    fs.writeFileSync(path.join(outputRoot, "image_queue.csv"), `${Object.keys(rows[0]).join(",")}\n`, "utf8");
  }
  writeCsv(path.join(outputRoot, "standards.csv"), standardsRows());
  writeCsv(path.join(outputRoot, "qa_gates.csv"), qaGateRows());
  writeCsv(path.join(outputRoot, "prompt_recipes.csv"), promptRecipeRows());
  const manifest = Object.fromEntries(manifestRows(rows).map((row) => [row.key, row.value]));
  fs.writeFileSync(path.join(outputRoot, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`, "utf8");
  writeCsv(path.join(outputRoot, "manifest.csv"), manifestRows(rows));
  writeReadme(rows);

  console.log(`wrote ${rows.length} hero tracker rows`);
  console.log(`wrote ${queueRows.length} queued image rows`);
  console.log(outputRoot);
}

main();
