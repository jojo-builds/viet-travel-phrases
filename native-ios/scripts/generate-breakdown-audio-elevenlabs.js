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

const projectRoot = path.resolve(__dirname, "..");
const resourcesDir = path.join(projectRoot, "Resources");
const catalogPath = path.join(resourcesDir, "viet-phrase-catalog.json");
const manifestPath = path.join(resourcesDir, "viet-audio-manifest.json");
const authoredAudioAuditPath = path.join(resourcesDir, "viet-authored-audio-audit.json");
const audioDir = path.join(resourcesDir, "Audio");

const args = parseArgs(process.argv.slice(2));

main().catch((error) => {
  console.error(error.message || error);
  process.exitCode = 1;
});

async function main() {
  const catalog = readJson(catalogPath);
  const manifest = readJson(manifestPath);
  const wantedEntries = collectWantedEntries(catalog, args);
  const groups = groupByText(wantedEntries);
  const plan = planGeneration(groups, manifest);

  console.log(
    [
      `Breakdown audio plan: ${wantedEntries.length} manifest key(s)`,
      `${groups.length} unique clip(s)`,
      `${plan.toGenerate.length} to generate`,
      `${plan.toMapOnly.length} already on disk`,
      `${plan.estimatedChars} estimated character(s)`,
    ].join(", ")
  );

  if (args.dryRun) {
    for (const item of plan.toGenerate.slice(0, 20)) {
      console.log(`GENERATE ${item.fileName}: ${item.text}`);
    }

    if (plan.toGenerate.length > 20) {
      console.log(`... ${plan.toGenerate.length - 20} more`);
    }

    return;
  }

  if (plan.toGenerate.length === 0 && plan.toMapOnly.length === 0) {
    console.log("All breakdown audio entries are already current.");
    return;
  }

  const apiKey = loadApiKey();
  fs.mkdirSync(audioDir, { recursive: true });

  for (const item of plan.toMapOnly) {
    writeManifestEntries(manifest, item);
  }

  if (plan.toMapOnly.length > 0) {
    writeJson(manifestPath, manifest);
  }

  let generated = 0;
  let failed = 0;

  for (const [index, item] of plan.toGenerate.entries()) {
    const outputPath = path.join(audioDir, item.fileName);
    let lastError = null;

    for (let attempt = 1; attempt <= RETRY_COUNT; attempt += 1) {
      try {
        console.log(
          `[${index + 1}/${plan.toGenerate.length}] ${item.fileName} (${item.text.length} chars, attempt ${attempt})`
        );
        const audio = await synthesizeSpeech(apiKey, args.voiceId, item.text);
        saveAudio(audio, outputPath);
        writeManifestEntries(manifest, item);
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
      console.error(`FAILED ${item.fileName}: ${lastError.message || lastError}`);
      continue;
    }

    await sleep(REQUEST_DELAY_MS);
  }

  console.log(
    `Done. Generated: ${generated}. Reused existing files: ${plan.toMapOnly.length}. Failed: ${failed}.`
  );
}

function parseArgs(argv) {
  const pageIDs = [];
  const customEntries = [];
  let dryRun = false;
  let all = false;
  let authoredAuditMissing = false;
  let force = false;
  let limit = null;
  let voiceId = DEFAULT_VOICE_ID;

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];

    if (arg === "--all") {
      all = true;
    } else if (arg === "--authored-audit-missing") {
      authoredAuditMissing = true;
    } else if (arg === "--dry-run") {
      dryRun = true;
    } else if (arg === "--force") {
      force = true;
    } else if (arg === "--page") {
      pageIDs.push(argv[++index]);
    } else if (arg === "--entry") {
      customEntries.push(parseCustomEntry(argv[++index]));
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

  if (!all && !authoredAuditMissing && pageIDs.length === 0 && customEntries.length === 0) {
    pageIDs.push("viet-family-airport-baggage");
  }

  if ([all, authoredAuditMissing].filter(Boolean).length > 1 || ((all || authoredAuditMissing) && pageIDs.length > 0)) {
    console.error("Use only one of --all, --authored-audit-missing, or --page.");
    printUsageAndExit(2);
  }

  if (limit !== null && (!Number.isInteger(limit) || limit < 1)) {
    console.error("--limit must be a positive integer.");
    printUsageAndExit(2);
  }

  return { pageIDs, customEntries, dryRun, all, authoredAuditMissing, force, limit, voiceId };
}

function printUsageAndExit(code) {
  console.log(`Usage:
  node scripts/generate-breakdown-audio-elevenlabs.js --page viet-family-airport-baggage
  node scripts/generate-breakdown-audio-elevenlabs.js --entry breakdown-token-tra-phong=trả phòng
  node scripts/generate-breakdown-audio-elevenlabs.js --authored-audit-missing --dry-run
  node scripts/generate-breakdown-audio-elevenlabs.js --all --dry-run
  node scripts/generate-breakdown-audio-elevenlabs.js --all [--limit 25] [--force]

Credentials are read from ELEVENLABS_API_KEY, ~/.speaklocal/secrets.env, or ~/.speaklocal/speaklocal-credentials.json.`);
  process.exit(code);
}

function parseCustomEntry(value) {
  const separatorIndex = value?.indexOf("=") ?? -1;

  if (separatorIndex <= 0 || separatorIndex === value.length - 1) {
    console.error("--entry must use key=text");
    printUsageAndExit(2);
  }

  return {
    key: value.slice(0, separatorIndex).trim(),
    text: value.slice(separatorIndex + 1).trim(),
  };
}

function collectWantedEntries(catalog, options) {
  const phrasesByID = new Map(catalog.phrases.map((phrase) => [phrase.id, phrase]));
  let families = catalog.families;

  if (!options.all) {
    const requestedPageIDs = new Set(options.pageIDs);
    families = families.filter((family) => requestedPageIDs.has(family.pageID));
    const foundPageIDs = new Set(families.map((family) => family.pageID));
    const missing = options.pageIDs.filter((pageID) => !foundPageIDs.has(pageID));

    if (missing.length > 0) {
      throw new Error(`Unknown generated page ID(s): ${missing.join(", ")}`);
    }
  }

  const entries = [...options.customEntries];

  if (options.authoredAuditMissing) {
    entries.push(...authoredAuditMissingEntries());
  }

  addDesignedBreakdownEntries(entries, options);

  for (const family of families) {
    const phrase = phrasesByID.get(family.primaryPhraseID);

    if (!phrase) {
      continue;
    }

    entries.push(...breakdownAudioEntriesForPhrase(phrase));
  }

  const uniqueByKey = new Map();
  for (const entry of entries) {
    uniqueByKey.set(entry.key, entry);
  }

  return [...uniqueByKey.values()];
}

function authoredAuditMissingEntries() {
  if (!fs.existsSync(authoredAudioAuditPath)) {
    throw new Error(`Missing authored audio audit: ${authoredAudioAuditPath}`);
  }

  const audit = readJson(authoredAudioAuditPath);
  return (audit.missing ?? [])
    .filter((entry) => entry.audioKey && entry.text)
    .map((entry) => ({
      key: entry.audioKey,
      text: entry.text,
    }));
}

function addDesignedBreakdownEntries(entries, options) {
  const designedEntries = [
    ["breakdown-xin", "Xin"],
    ["breakdown-chao", "Chào"],
    ["breakdown-viet-hello-anh-relationship", "anh"],
    ["breakdown-viet-hello-anh-full", "Chào anh"],
    ["breakdown-viet-hello-chi-relationship", "chị"],
    ["breakdown-viet-hello-chi-full", "Chào chị"],
    ["breakdown-viet-hello-em-relationship", "em"],
    ["breakdown-viet-hello-em-full", "Chào em"],
    ["breakdown-viet-hello-ong-relationship", "ông"],
    ["breakdown-viet-hello-ong-full", "Chào ông"],
    ["breakdown-viet-hello-ba-relationship", "bà"],
    ["breakdown-viet-hello-ba-full", "Chào bà"],
    ["breakdown-viet-hello-chu-relationship", "chú"],
    ["breakdown-viet-hello-chu-full", "Chào chú"],
    ["breakdown-viet-hello-co-relationship", "cô"],
    ["breakdown-viet-hello-co-full", "Chào cô"],
  ];
  const includeDesigned =
    options.all ||
    options.pageIDs.includes("viet-polite-hello") ||
    options.pageIDs.some((pageID) => pageID.startsWith("viet-hello-"));

  if (!includeDesigned) {
    return;
  }

  for (const [key, text] of designedEntries) {
    entries.push({ key, text });
  }
}

function breakdownAudioEntriesForPhrase(phrase) {
  if (phrase.targetText.endsWith(" ở đâu?")) {
    const subject = phrase.targetText.slice(0, -" ở đâu?".length).trim();
    const subjectPieces = subjectBreakdownPieces(subject);
    const subjectEntries = subjectPieces.map((piece, index) => ({
      key:
        subjectPieces.length === 1
          ? `breakdown-${phrase.familyID}-subject`
          : `breakdown-${phrase.familyID}-subject-${index + 1}`,
      text: piece,
    }));

    return [
      ...subjectEntries,
      { key: "breakdown-where", text: "ở đâu?" },
    ];
  }

  const words = phrase.targetText.trim().split(/\s+/);

  if (words.length <= 1) {
    return [];
  }

  const showingPieces = showingPhraseBreakdownPieces(phrase.targetText);
  if (showingPieces) {
    return showingPieces.map((piece, index) => ({
      key: `breakdown-${phrase.id}-piece-${index + 1}`,
      text: piece,
    }));
  }

  if (words.some(isNumberToken)) {
    return words.map((word, index) => ({
      key: `breakdown-${phrase.id}-piece-${index + 1}`,
      text: word,
    }));
  }

  return [
    { key: `breakdown-${phrase.id}-first`, text: words[0] },
    { key: `breakdown-${phrase.id}-rest`, text: words.slice(1).join(" ") },
  ];
}

function showingPhraseBreakdownPieces(targetText) {
  if (!targetText.startsWith("Đây là ")) {
    return null;
  }

  const remainder = targetText.slice("Đây là ".length).trim();
  if (!remainder) {
    return null;
  }

  if (targetText.endsWith(" của tôi")) {
    const item = remainder.slice(0, -" của tôi".length).trim();
    if (!item) {
      return null;
    }

    return ["Đây", "là", item, "của tôi"];
  }

  return ["Đây", "là", remainder];
}

function subjectBreakdownPieces(subject) {
  const words = subject.trim().split(/\s+/).filter(Boolean);

  if (words.length <= 1) {
    return [subject];
  }

  if (subject === "Lấy hành lý") {
    return ["Lấy", "hành lý"];
  }

  if (words.some(isNumberToken) || ["Lấy", "Mua"].includes(words[0])) {
    return words;
  }

  return [subject];
}

function isNumberToken(token) {
  const normalized = token
    .replace(/[.,?!]/g, "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase();

  return /^\d+$/.test(normalized) ||
    ["mot", "hai", "ba", "bon", "nam", "sau", "bay", "tam", "chin", "muoi"].includes(normalized);
}

function groupByText(entries) {
  const groupsByText = new Map();

  for (const entry of entries) {
    const text = entry.text.trim();

    if (!text) {
      continue;
    }

    if (!groupsByText.has(text)) {
      groupsByText.set(text, {
        text,
        fileName: fileNameForText(text),
        keys: [],
      });
    }

    groupsByText.get(text).keys.push(entry.key);
  }

  return [...groupsByText.values()].sort((left, right) => left.text.localeCompare(right.text));
}

function planGeneration(groups, manifest) {
  const canonicalAudioByText = buildCanonicalAudioIndex(manifest);
  const toGenerate = [];
  const toMapOnly = [];

  for (const group of groups) {
    const filePath = path.join(audioDir, group.fileName);
    const hasCurrentEntries = group.keys.every((key) => manifest[key]?.text === group.text);
    const hasAudioFile = fs.existsSync(filePath) && fs.statSync(filePath).size > 1024;

    if (!args.force && hasCurrentEntries && hasAudioFile) {
      continue;
    }

    const canonicalAudio = canonicalAudioByText.get(normalizeAudioText(group.text));
    if (!args.force && canonicalAudio) {
      toMapOnly.push({
        ...group,
        fileName: canonicalAudio.fileName,
      });
      continue;
    }

    if (!args.force && hasAudioFile) {
      toMapOnly.push(group);
      continue;
    }

    toGenerate.push(group);
  }

  const limitedToGenerate = args.limit ? toGenerate.slice(0, args.limit) : toGenerate;

  return {
    toGenerate: limitedToGenerate,
    toMapOnly,
    estimatedChars: limitedToGenerate.reduce((sum, group) => sum + group.text.length, 0),
  };
}

function buildCanonicalAudioIndex(manifest) {
  const candidatesByText = new Map();

  for (const [key, entry] of Object.entries(manifest)) {
    if (!entry?.fileName || !entry?.text) {
      continue;
    }

    const filePath = path.join(audioDir, entry.fileName);
    if (!fs.existsSync(filePath) || fs.statSync(filePath).size <= 1024) {
      continue;
    }

    const normalizedText = normalizeAudioText(entry.text);
    if (!normalizedText) {
      continue;
    }

    const candidate = {
      key,
      fileName: entry.fileName,
    };
    const current = candidatesByText.get(normalizedText);

    if (!current || compareCanonicalAudio(candidate, current) < 0) {
      candidatesByText.set(normalizedText, candidate);
    }
  }

  return candidatesByText;
}

function compareCanonicalAudio(left, right) {
  const leftIsBreakdown = isBreakdownAudio(left);
  const rightIsBreakdown = isBreakdownAudio(right);

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

function isBreakdownAudio(candidate) {
  return candidate.key.startsWith("breakdown-") || candidate.fileName.startsWith("breakdown-");
}

function normalizeAudioText(text) {
  return text
    .normalize("NFC")
    .trim()
    .replace(/\s+/g, " ")
    .toLowerCase();
}

function writeManifestEntries(manifest, item) {
  for (const key of item.keys) {
    manifest[key] = {
      fileName: item.fileName,
      text: item.text,
    };
  }
}

function fileNameForText(text) {
  const normalized = text
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/đ/g, "d")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 52);
  const slug = normalized || "clip";
  const hash = crypto.createHash("sha1").update(text).digest("hex").slice(0, 10);

  return `breakdown-${slug}-${hash}.mp3`;
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

          if (response.statusCode !== 200) {
            reject(new Error(`HTTP ${response.statusCode}: ${buffer.toString("utf8")}`));
            return;
          }

          resolve(buffer);
        });
      }
    );

    request.on("error", reject);
    request.write(body);
    request.end();
  });
}

function saveAudio(buffer, outputPath) {
  const temporaryPath = `${outputPath}.partial.${process.pid}`;

  if (buffer.length < 1024) {
    throw new Error(`Audio response too small (${buffer.length} bytes).`);
  }

  const isID3 = buffer.slice(0, 3).toString("utf8") === "ID3";
  const isMP3 = buffer[0] === 0xff && (buffer[1] & 0xe0) === 0xe0;

  if (!isID3 && !isMP3) {
    throw new Error(`Audio response is not MP3 (head: ${buffer.slice(0, 3).toString("hex")}).`);
  }

  fs.writeFileSync(temporaryPath, buffer);
  fs.renameSync(temporaryPath, outputPath);
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJson(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function sleep(milliseconds) {
  return new Promise((resolve) => setTimeout(resolve, milliseconds));
}
