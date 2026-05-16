#!/usr/bin/env node

const crypto = require("node:crypto");
const fs = require("node:fs");
const https = require("node:https");
const os = require("node:os");
const path = require("node:path");

const DEFAULT_VOICE_ID = "EXAVITQu4vr4xnSDxMaL";
const DEFAULT_MODEL_ID = "eleven_multilingual_v2";
const REQUEST_DELAY_MS = 350;
const RETRY_COUNT = 3;
const RETRY_DELAY_MS = 1000;

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const manifestPath = path.join(nativeRoot, "Resources", "viet-audio-manifest.json");
const audioDir = path.join(nativeRoot, "Resources", "Audio");

const browsePageKinds = new Set(["place", "restaurant", "dish"]);
const browsePlaceKinds = new Set([
  "airport",
  "station",
  "port",
  "landmark",
  "attraction",
  "museum",
  "neighborhood",
  "street",
  "restaurant",
  "cafe",
  "dish",
  "market",
  "beach",
  "nature",
  "park",
  "river",
  "village",
  "experience",
]);
const restaurantPlaceKinds = new Set(["restaurant", "cafe"]);
const dishPlaceKinds = new Set(["dish"]);

const args = parseArgs(process.argv.slice(2));

main().catch((error) => {
  console.error(error.message || error);
  process.exitCode = 1;
});

async function main() {
  const cityLibrary = readJson(cityLibraryPath);
  const manifest = readJson(manifestPath);
  const pages = collectCityNounPages(cityLibrary);
  const plan = planGeneration(pages, manifest);

  console.log(
    [
      `City noun audio plan: ${pages.length} page(s)`,
      `${plan.ready.length} already ready`,
      `${plan.toMapOnly.length} exact-text reuse(s)`,
      `${plan.toGenerate.length} to generate`,
      `${plan.estimatedChars} estimated character(s)`,
    ].join(", ")
  );

  if (args.dryRun) {
    for (const item of plan.toGenerate.slice(0, 25)) {
      console.log(`GENERATE ${item.audioKey}: ${item.text}`);
    }
    if (plan.toGenerate.length > 25) {
      console.log(`... ${plan.toGenerate.length - 25} more`);
    }
    for (const item of plan.toMapOnly.slice(0, 15)) {
      console.log(`REUSE ${item.audioKey} -> ${item.fileName}: ${item.text}`);
    }
    if (plan.toMapOnly.length > 15) {
      console.log(`... ${plan.toMapOnly.length - 15} more reused`);
    }
    return;
  }

  fs.mkdirSync(audioDir, { recursive: true });

  for (const item of plan.toMapOnly) {
    writeManifestEntry(manifest, item);
  }
  if (plan.toMapOnly.length > 0) {
    writeJson(manifestPath, manifest);
  }

  let generated = 0;
  let failed = 0;
  const apiKey = plan.toGenerate.length > 0 ? loadApiKey() : null;

  for (const [index, item] of plan.toGenerate.entries()) {
    const outputPath = path.join(audioDir, item.fileName);
    let lastError = null;

    for (let attempt = 1; attempt <= RETRY_COUNT; attempt += 1) {
      try {
        console.log(
          `[${index + 1}/${plan.toGenerate.length}] ${item.audioKey} (${item.text.length} chars, attempt ${attempt})`
        );
        const audio = await synthesizeSpeech(apiKey, args.voiceId, item.text);
        saveAudio(audio, outputPath);
        writeManifestEntry(manifest, item);
        writeJson(manifestPath, manifest);
        generated += 1;
        lastError = null;
        break;
      } catch (error) {
        lastError = error;
        if (attempt < RETRY_COUNT) {
          await sleep(RETRY_DELAY_MS);
        }
      }
    }

    if (lastError) {
      failed += 1;
      console.error(`FAILED ${item.audioKey}: ${lastError.message || lastError}`);
      continue;
    }

    await sleep(REQUEST_DELAY_MS);
  }

  if (failed > 0) {
    throw new Error(`Audio generation failed for ${failed} city noun(s).`);
  }

  const updatedPages = markCityLibraryAudioReady(cityLibrary, pages);
  writeJson(cityLibraryPath, cityLibrary);

  console.log(
    `Done. Generated: ${generated}. Reused exact audio: ${plan.toMapOnly.length}. Marked ready: ${updatedPages}.`
  );
}

function parseArgs(argv) {
  let dryRun = false;
  let force = false;
  let limit = null;
  let voiceId = DEFAULT_VOICE_ID;

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];

    if (arg === "--dry-run") {
      dryRun = true;
    } else if (arg === "--force") {
      force = true;
    } else if (arg === "--limit") {
      limit = Number(argv[++index]);
    } else if (arg === "--voice") {
      voiceId = argv[++index];
    } else if (arg === "--help" || arg === "-h") {
      printUsageAndExit(0);
    } else {
      console.error(`Unknown argument: ${arg}`);
      printUsageAndExit(2);
    }
  }

  if (limit !== null && (!Number.isInteger(limit) || limit < 1)) {
    console.error("--limit must be a positive integer.");
    printUsageAndExit(2);
  }

  return { dryRun, force, limit, voiceId };
}

function printUsageAndExit(code) {
  console.log(`Usage:
  node scripts/generate-city-noun-audio-elevenlabs.js --dry-run
  node scripts/generate-city-noun-audio-elevenlabs.js [--limit 25] [--force]

Generates or reuses ElevenLabs clips for the entity-first nouns surfaced by city Browse pages.
Credentials are read from ELEVENLABS_API_KEY, ~/.speaklocal/secrets.env, or ~/.speaklocal/speaklocal-credentials.json.`);
  process.exit(code);
}

function collectCityNounPages(cityLibrary) {
  const placeByID = new Map((cityLibrary.places ?? []).map((place) => [place.id, place]));

  return (cityLibrary.pages ?? [])
    .filter((page) => page.status === "approved")
    .map((page) => {
      const place = placeByID.get(page.placeID) ?? {};
      return {
        page,
        pageKind: pageKindFor(page, place),
        placeKind: placeKindFor(page, place),
        text: String(page.targetText ?? "").trim(),
      };
    })
    .filter((item) => browsePageKinds.has(item.pageKind))
    .filter((item) => browsePlaceKinds.has(item.placeKind))
    .filter((item) => item.text)
    .map((item) => ({
      ...item,
      audioKey: authoredAudioKey(item.text),
      fileName: authoredAudioFileName(item.text),
    }))
    .sort((left, right) => {
      if (left.page.cityID !== right.page.cityID) {
        return left.page.cityID.localeCompare(right.page.cityID);
      }
      if (left.pageKind !== right.pageKind) {
        return left.pageKind.localeCompare(right.pageKind);
      }
      if (left.placeKind !== right.placeKind) {
        return left.placeKind.localeCompare(right.placeKind);
      }
      return left.text.localeCompare(right.text);
    });
}

function pageKindFor(page, place) {
  if (page.pageKind) return page.pageKind;
  if (page.kind !== "place") return page.kind;
  const legacyKind = normalizeKind(place.kind);
  if (restaurantPlaceKinds.has(legacyKind)) return "restaurant";
  if (dishPlaceKinds.has(legacyKind)) return "dish";
  return "place";
}

function placeKindFor(page, place) {
  const explicitKind = normalizeKind(page.placeKind);
  if (explicitKind) return explicitKind;
  const placeKind = normalizeKind(place.placeKind);
  if (placeKind) return placeKind;
  const legacyKind = normalizeKind(place.kind);
  if (dishPlaceKinds.has(legacyKind)) return "dish";
  return legacyKind;
}

function normalizeKind(value) {
  return String(value ?? "").trim().toLowerCase();
}

function planGeneration(pages, manifest) {
  const canonicalAudioByText = buildCanonicalAudioIndex(manifest);
  const ready = [];
  const toMapOnly = [];
  const toGenerate = [];

  for (const item of pages) {
    const current = manifest[item.audioKey];
    const outputPath = path.join(audioDir, item.fileName);
    const hasCurrentEntry = current?.text === item.text;
    const currentFileName = current?.fileName ?? item.fileName;
    const hasCurrentAudioFile = audioFileIsReady(currentFileName);

    if (!args.force && hasCurrentEntry && hasCurrentAudioFile) {
      ready.push(item);
      continue;
    }

    const canonicalAudio = canonicalAudioByText.get(normalizeAudioText(item.text));
    if (!args.force && canonicalAudio) {
      toMapOnly.push({
        ...item,
        fileName: canonicalAudio.fileName,
      });
      continue;
    }

    if (!args.force && fs.existsSync(outputPath) && fs.statSync(outputPath).size > 1024) {
      toMapOnly.push(item);
      continue;
    }

    toGenerate.push(item);
  }

  const limitedToGenerate = args.limit ? toGenerate.slice(0, args.limit) : toGenerate;

  return {
    ready,
    toMapOnly,
    toGenerate: limitedToGenerate,
    estimatedChars: limitedToGenerate.reduce((sum, item) => sum + item.text.length, 0),
  };
}

function buildCanonicalAudioIndex(manifest) {
  const candidatesByText = new Map();

  for (const [key, entry] of Object.entries(manifest)) {
    if (!entry?.fileName || !entry?.text || !audioFileIsReady(entry.fileName)) {
      continue;
    }

    const normalizedText = normalizeAudioText(entry.text);
    if (!normalizedText) {
      continue;
    }

    const candidate = { key, fileName: entry.fileName };
    const current = candidatesByText.get(normalizedText);
    if (!current || compareCanonicalAudio(candidate, current) < 0) {
      candidatesByText.set(normalizedText, candidate);
    }
  }

  return candidatesByText;
}

function audioFileIsReady(fileName) {
  const filePath = path.join(audioDir, fileName);
  return fs.existsSync(filePath) && fs.statSync(filePath).size > 1024;
}

function compareCanonicalAudio(left, right) {
  const leftIsAuthored = left.key.startsWith("audio-authored-") ? 0 : 1;
  const rightIsAuthored = right.key.startsWith("audio-authored-") ? 0 : 1;
  if (leftIsAuthored !== rightIsAuthored) {
    return leftIsAuthored - rightIsAuthored;
  }

  const leftIsBreakdown = left.key.startsWith("breakdown-") || left.fileName.startsWith("breakdown-");
  const rightIsBreakdown = right.key.startsWith("breakdown-") || right.fileName.startsWith("breakdown-");
  if (leftIsBreakdown !== rightIsBreakdown) {
    return leftIsBreakdown ? 1 : -1;
  }

  if (left.key.length !== right.key.length) {
    return left.key.length - right.key.length;
  }

  const keyComparison = left.key.localeCompare(right.key);
  if (keyComparison !== 0) {
    return keyComparison;
  }

  return left.fileName.localeCompare(right.fileName);
}

function markCityLibraryAudioReady(cityLibrary, pages) {
  const audioKeyByPageID = new Map(pages.map((item) => [item.page.id, item.audioKey]));
  let updated = 0;

  for (const page of cityLibrary.pages ?? []) {
    const audioKey = audioKeyByPageID.get(page.id);
    if (!audioKey) {
      continue;
    }

    if (page.audioKey !== audioKey || page.audioStatus !== "ready") {
      page.audioKey = audioKey;
      page.audioStatus = "ready";
      updated += 1;
    }
  }

  return updated;
}

function writeManifestEntry(manifest, item) {
  manifest[item.audioKey] = {
    fileName: item.fileName,
    text: item.text,
  };
}

function authoredAudioKey(text) {
  return `audio-authored-${slugForText(text)}-${hashForText(text)}`;
}

function authoredAudioFileName(text) {
  return `breakdown-${slugForText(text)}-${hashForText(text)}.mp3`;
}

function slugForText(text) {
  return text
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/đ/g, "d")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 52) || "clip";
}

function hashForText(text) {
  return crypto.createHash("sha1").update(text).digest("hex").slice(0, 10);
}

function normalizeAudioText(text) {
  return String(text ?? "")
    .normalize("NFC")
    .trim()
    .replace(/\s+/g, " ")
    .toLowerCase();
}

function loadApiKey() {
  if (process.env.ELEVENLABS_API_KEY?.trim()) {
    return process.env.ELEVENLABS_API_KEY.trim();
  }

  const envPath = path.join(os.homedir(), ".speaklocal", "secrets.env");
  const envVars = readEnvFile(envPath);

  if (envVars.ELEVENLABS_API_KEY?.trim()) {
    return envVars.ELEVENLABS_API_KEY.trim();
  }

  const candidateJsonPaths = [
    process.env.SPEAKLOCAL_CREDS_PATH,
    path.join(os.homedir(), ".speaklocal", "speaklocal-credentials.json"),
  ].filter(Boolean);

  for (const jsonPath of candidateJsonPaths) {
    if (!fs.existsSync(jsonPath)) {
      continue;
    }

    const credentials = readJson(jsonPath);
    if (credentials.elevenlabs_api_key?.trim()) {
      return credentials.elevenlabs_api_key.trim();
    }
  }

  throw new Error(
    "Missing ElevenLabs key. Set ELEVENLABS_API_KEY or create ~/.speaklocal/secrets.env."
  );
}

function readEnvFile(filePath) {
  if (!fs.existsSync(filePath)) {
    return {};
  }

  const env = {};
  const raw = fs.readFileSync(filePath, "utf8");

  for (const line of raw.split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) {
      continue;
    }

    const equalsIndex = trimmed.indexOf("=");
    if (equalsIndex === -1) {
      continue;
    }

    const key = trimmed.slice(0, equalsIndex).trim();
    const value = trimmed.slice(equalsIndex + 1).trim().replace(/^["']|["']$/g, "");
    env[key] = value;
  }

  return env;
}

function synthesizeSpeech(apiKey, voiceId, text) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({
      text,
      model_id: DEFAULT_MODEL_ID,
      voice_settings: {
        stability: 0.55,
        similarity_boost: 0.75,
        style: 0,
        use_speaker_boost: true,
      },
    });

    const request = https.request(
      {
        hostname: "api.elevenlabs.io",
        path: `/v1/text-to-speech/${voiceId}?output_format=mp3_44100_128`,
        method: "POST",
        headers: {
          "xi-api-key": apiKey,
          Accept: "audio/mpeg",
          "Content-Type": "application/json",
          "Content-Length": Buffer.byteLength(body),
        },
      },
      (response) => {
        const chunks = [];
        response.on("data", (chunk) => chunks.push(chunk));
        response.on("end", () => {
          const buffer = Buffer.concat(chunks);
          if (response.statusCode >= 200 && response.statusCode < 300) {
            resolve(buffer);
            return;
          }

          reject(
            new Error(`ElevenLabs ${response.statusCode}: ${buffer.toString("utf8").slice(0, 500)}`)
          );
        });
      }
    );

    request.on("error", reject);
    request.write(body);
    request.end();
  });
}

function saveAudio(buffer, outputPath) {
  if (!Buffer.isBuffer(buffer) || buffer.length <= 1024) {
    throw new Error(`Refusing to write tiny audio file: ${outputPath}`);
  }

  fs.writeFileSync(outputPath, buffer);
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJson(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
