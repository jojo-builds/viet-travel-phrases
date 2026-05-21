#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execFile } = require('child_process');

const repoRoot = path.resolve(__dirname, '..', '..');
const manifestPath = path.join(
  repoRoot,
  'docs/editorial-exports/viet-image-assets/city-hero-production-505/manifest.json'
);

const args = parseArgs(process.argv.slice(2));
const model = args.model || 'gpt_image_2';
const city = args.city || 'hue';
const limit = Number(args.limit || 0);
const concurrency = Math.max(1, Number(args.concurrency || 4));
const outDir = path.resolve(
  repoRoot,
  args.outDir || 'native-ios/artifacts/city-hero-production/higgsfield-hue-sources'
);

if (!fs.existsSync(manifestPath)) {
  throw new Error(`Missing manifest: ${manifestPath}`);
}

fs.mkdirSync(outDir, { recursive: true });

const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
const rows = manifest.rows
  .filter((row) => row.cityID === city && row.status === 'needs_generation')
  .slice(0, limit > 0 ? limit : undefined);

if (rows.length === 0) {
  console.log(`No ${city} rows need generation.`);
  process.exit(0);
}

console.log(
  `Generating ${rows.length} ${city} hero images with ${model}, concurrency ${concurrency}`
);

let index = 0;
let completed = 0;
const failures = [];

runPool()
  .then(() => {
    if (failures.length > 0) {
      console.error(`Failed ${failures.length} image(s):`);
      for (const failure of failures) {
        console.error(`- ${failure.name}: ${failure.error}`);
      }
      process.exitCode = 1;
      return;
    }
    console.log(`Generated and marked ${completed} image(s).`);
  })
  .catch((error) => {
    console.error(error.stack || error.message);
    process.exit(1);
  });

async function runPool() {
  const workers = Array.from(
    { length: Math.min(concurrency, rows.length) },
    () => worker()
  );
  await Promise.all(workers);
}

async function worker() {
  while (index < rows.length) {
    const row = rows[index++];
    try {
      await generateRow(row);
      completed += 1;
      console.log(`[${completed}/${rows.length}] ${row.targetHeroImageName}`);
    } catch (error) {
      failures.push({
        name: row.targetHeroImageName,
        error: error.message || String(error),
      });
    }
  }
}

async function generateRow(row) {
  const baseName = row.targetHeroImageName;
  const promptPath = path.join(outDir, `${baseName}.prompt.txt`);
  const jobPath = path.join(outDir, `${baseName}.job.json`);
  const imagePath = path.join(outDir, `${baseName}.png`);

  if (fs.existsSync(imagePath)) {
    const dimensions = await imageDimensions(imagePath);
    markApproved(row, imagePath, dimensions);
    writeManifest();
    return;
  }

  const prompt = buildPrompt(row);
  fs.writeFileSync(promptPath, `${prompt}\n`);

  const stdout = await execFileCapture('higgsfield', [
    'generate',
    'create',
    model,
    '--prompt',
    prompt,
    '--aspect_ratio',
    '9:16',
    '--resolution',
    '2k',
    '--quality',
    'high',
    '--wait',
    '--wait-timeout',
    '20m',
    '--json',
  ]);

  fs.writeFileSync(jobPath, stdout);
  const resultUrl = parseResultUrl(stdout);
  await download(resultUrl, imagePath);

  const dimensions = await imageDimensions(imagePath);
  if (dimensions.width < 1000 || dimensions.height < 1600) {
    throw new Error(`Downloaded image is too small: ${dimensions.width}x${dimensions.height}`);
  }

  markApproved(row, imagePath, dimensions);
  writeManifest();
}

function buildPrompt(row) {
  const profile = row.profile || 'place';
  const profileGuidance = {
    dish:
      'Make the dish immediately recognizable: clear ingredients, sauce or broth if relevant, real Hue tableware, close enough to feel appetizing without looking like sterile studio stock.',
    restaurantCafe:
      'Show the feeling of the stop without inventing readable branding: table setting, coffee or food details, entrance or terrace atmosphere, and realistic travel context.',
    market:
      'Show a lived-in Vietnamese market scene with produce, food stalls, wet pavement or baskets when appropriate, and small background shoppers only if faces are not the main subject.',
    landmark:
      'Show the actual kind of landmark or cultural site with weathered materials, garden, gate, shrine, river, or palace details that feel specific to Hue.',
    street:
      'Show the street as a place a traveler can recognize for pickup or wandering: scooters, shopfront rhythm, rain-warmed pavement, trees, or river light, but no readable sign text.',
    airportStation:
      'Show practical arrival or transit context with luggage, curb, check-in, platform, or buses as supporting cues. Keep all wayfinding, airline, route, and terminal text blurred, cropped away, or fully unreadable.',
    beachNature:
      'Show the natural setting as realistic travel photography with depth, weather, water, mountain, forest, or shoreline details; avoid fantasy scenery.',
    transport:
      'Show practical arrival or transit context: exterior, concourse, taxi pickup, platform, luggage, or roadway cues with no readable fake signs.',
    experience:
      'Show the activity or cultural moment in a respectful travel-documentary way, with hands or people only as natural secondary details.',
    museumCulture:
      'Show cultural objects, architecture, gallery light, courtyards, or craft details without readable exhibit text or labels.',
  };

  const guidance = specialGuidance(row) || profileGuidance[profile] || profileGuidance.landmark;
  const title = row.title || row.targetHeroImageName;
  const note = sanitizePromptNote(row.imagePromptNote || title);

  return [
    'Photorealistic vertical travel hero image for SpeakLocal Vietnam, a native iPhone app for travelers excited to visit Vietnam.',
    `City/page: Hue, Vietnam. Page title: ${title}.`,
    `Primary scene: ${note}.`,
    guidance,
    'Composition: vertical 9:16. The main subject must be clearly visible in the upper-middle half of the frame so the app masthead crop does not show only ceiling, wall, sky, or empty background. Keep the subject useful in both a small card thumbnail and a full-screen lightbox.',
    'Visual style: realistic editorial travel photography, natural daylight or believable ambient evening light, rich local texture, not CGI, not illustration, not a glossy stock-photo composite.',
    'Avoid: readable signs or labels, fake text, logos, watermarks, distorted hands, distorted faces, extra fingers, over-smoothed food, smeared blur over the subject, and empty top-heavy composition.',
  ].join(' ');
}

function sanitizePromptNote(note) {
  return note
    .replace(/clear local station sign/gi, 'bus terminal wayfinding shapes kept blurred and unreadable')
    .replace(/blue signage/gi, 'blue station color accents without readable lettering')
    .replace(/muted signage/gi, 'muted wayfinding shapes without readable lettering')
    .replace(/signboards/gi, 'shopfront awnings and unreadable sign shapes')
    .replace(/signage/gi, 'unreadable wayfinding shapes');
}

function specialGuidance(row) {
  const guidance = {
    HeroCityDanangPlaceConMarket:
      'Regenerate as Chợ Cồn in Da Nang: a realistic daytime covered central market aisle with fruit, dry goods, snack counters, baskets, Vietnamese market texture, and warm local bustle. It must not read as a night market. No readable signs, stall names, logos, or watermarks.',
    HeroCityDanangPlaceCongCapheBachDang:
      'Regenerate as a vintage Vietnamese cafe near the Bạch Đằng riverfront in Da Nang: muted green retro mood, strong coffee on a small table, balcony or river-light context, lived-in interior details. Do not show readable Cộng branding, logos, menu text, or fake signage.',
    HeroCityDanangPlaceInternationalTerminal:
      'Regenerate as Da Nang international terminal/departures context distinct from a domestic terminal: glass facade or check-in/drop-off cues, travelers with luggage as secondary figures, tropical landscaping, polished airport surfaces. No readable airline names, terminal text, flight boards, logos, or fake signage.',
    HeroCityHcmcPlaceDongKhoiLandmarkWalk:
      'Regenerate as a Dong Khoi landmark walk in Ho Chi Minh City: traveler-scale street scene with colonial facade, Opera House or City Hall-style architectural cue, shaded sidewalks, scooters, and a walkable itinerary feeling. No readable signage, brand text, or logos.',
    HeroCityDanangPlaceMyQuangDung:
      'Regenerate as a Đà Nẵng mì Quảng restaurant/table scene: yellow turmeric noodles, herbs, lime, chili, peanuts, rice crackers, casual local dining table, and rich central-Vietnam noodle texture. It must not show caves, mountains, or stairways. No readable menu or sign text.',
    HeroCityHanoiPlaceImperialCitadel:
      'Regenerate as Hoàng thành Thăng Long / Imperial Citadel of Thăng Long in Hanoi: ancient citadel gate, weathered brick courtyard, heritage walls, archaeology-ground feeling, centered architectural cue. It must not show a generic statue park. No fake text, readable signs, or banners.',
    HeroCityHanoiPlaceTrucBachLake:
      'Regenerate as Hồ Trúc Bạch in Hanoi: calm lake water, lakeside road or rail, small boats or cafe edges, Hanoi urban texture, soft daylight, and a recognizably watery neighborhood scene. It must not show an indoor restaurant table. No readable signs or logos.',
    HeroCityHcmcPlaceHistoryMuseum:
      'Regenerate as the Museum of Vietnamese History in Ho Chi Minh City near the botanical gardens: historic museum architecture, garden approach, warm yellow/ochre colonial-Indochine details, courtyard or leafy museum setting. It must not duplicate the Fine Arts Museum facade. No readable signage or logos.',
  };
  return guidance[row.targetHeroImageName];
}

function markApproved(row, imagePath, dimensions) {
  const relativePath = path.relative(repoRoot, imagePath);
  row.status = 'approved';
  row.sourceImagePath = relativePath;
  row.approvedImagePath = relativePath;
  row.reviewerNotes =
    `Higgsfield ${model} generated ${dimensions.width}x${dimensions.height}; ` +
    'passes production import precheck and remains queued for final two-agent visual audit.';
  row.rejectReason = '';
}

function writeManifest() {
  fs.writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);
}

function parseArgs(rawArgs) {
  const parsed = {};
  for (let i = 0; i < rawArgs.length; i += 1) {
    const arg = rawArgs[i];
    if (!arg.startsWith('--')) continue;
    const [key, inlineValue] = arg.slice(2).split('=');
    parsed[key] = inlineValue !== undefined ? inlineValue : rawArgs[i + 1];
    if (inlineValue === undefined) i += 1;
  }
  return parsed;
}

function parseResultUrl(stdout) {
  let json;
  try {
    json = JSON.parse(stdout);
  } catch (error) {
    throw new Error(`Higgsfield returned non-JSON output: ${stdout.slice(0, 240)}`);
  }
  const job = Array.isArray(json) ? json[0] : json;
  const url = job && (job.result_url || job.url);
  if (!url) {
    throw new Error(`Higgsfield result had no result_url: ${stdout.slice(0, 400)}`);
  }
  return url;
}

function execFileCapture(command, commandArgs) {
  return new Promise((resolve, reject) => {
    execFile(
      command,
      commandArgs,
      { maxBuffer: 1024 * 1024 * 12 },
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

async function imageDimensions(imagePath) {
  const stdout = await execFileCapture('sips', [
    '-g',
    'pixelWidth',
    '-g',
    'pixelHeight',
    imagePath,
  ]);
  const width = Number((stdout.match(/pixelWidth: (\d+)/) || [])[1]);
  const height = Number((stdout.match(/pixelHeight: (\d+)/) || [])[1]);
  if (!width || !height) {
    throw new Error(`Could not read image dimensions for ${imagePath}`);
  }
  return { width, height };
}

async function download(url, destination) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Download failed ${response.status} for ${url}`);
  }
  const arrayBuffer = await response.arrayBuffer();
  fs.writeFileSync(destination, Buffer.from(arrayBuffer));
}
