import { access, mkdir, readFile, stat, writeFile } from 'node:fs/promises';
import path from 'node:path';
import https from 'node:https';
import { fileURLToPath } from 'node:url';
import { AppPack } from '../family/contracts';
import { tagalogPack } from '../family/packs/tagalog';
import { vietPack } from '../family/packs/viet';

const DEFAULT_VOICE_ID = 'EXAVITQu4vr4xnSDxMaL';
const DEFAULT_MODEL_ID = 'eleven_multilingual_v2';
const DOWNLOADS_SECRET_PATH = 'C:/Users/Administrator/Downloads/secrets/ElevenLabs.txt';
const RETRY_COUNT = 3;
const RETRY_DELAY_MS = 1000;
const REQUEST_DELAY_MS = 500;
const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const APP_ROOT = path.resolve(SCRIPT_DIR, '..');

type AudioManifest = Record<string, { fileName: string; text: string }>;

async function main() {
  const variant = getArgValue('--variant', 'tagalog');
  const voiceId = getArgValue('--voice', DEFAULT_VOICE_ID);
  const filterCsvPath = getOptionalArgValue('--filter-csv');
  const force = process.argv.includes('--force');
  const apiKey = await resolveApiKey();
  const pack = loadPack(variant);
  const filteredPhrases = await filterPhrases(pack.phrases, filterCsvPath);
  const outputDir = getAudioDir(variant);
  const manifestPath = path.join(outputDir, 'manifest.json');
  const manifest = await readManifest(manifestPath);

  await mkdir(outputDir, { recursive: true });

  let generated = 0;
  let skipped = 0;
  let failed = 0;

  console.log(
    `Preparing ${filteredPhrases.length} phrase(s) for ${variant}${filterCsvPath ? ` using filter ${filterCsvPath}` : ''}.`,
  );

  for (const [index, phrase] of filteredPhrases.entries()) {
    const fileName = `${phrase.audioKey}.mp3`;
    const outputPath = path.join(outputDir, fileName);
    const manifestEntry = manifest[phrase.audioKey];
    const hasCurrentManifest = manifestEntry?.text === phrase.targetText && manifestEntry.fileName === fileName;

    if (!force && (await fileExists(outputPath)) && (await stat(outputPath)).size > 1024 && hasCurrentManifest) {
      console.log(`[${index + 1}/${filteredPhrases.length}] SKIP ${phrase.id}: ${fileName}`);
      skipped += 1;
      continue;
    }

    let lastError: unknown;

    for (let attempt = 1; attempt <= RETRY_COUNT; attempt += 1) {
      try {
        console.log(`[${index + 1}/${filteredPhrases.length}] ${phrase.id} -> ${fileName} (attempt ${attempt})`);
        const audio = await synthesizeSpeech(apiKey, voiceId, phrase.targetText);
        await writeFile(outputPath, audio);
        manifest[phrase.audioKey] = {
          fileName,
          text: phrase.targetText,
        };
        generated += 1;
        lastError = undefined;
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
      console.error(`FAILED ${phrase.id}: ${String(lastError)}`);
      continue;
    }

    await sleep(REQUEST_DELAY_MS);
  }

  await writeFile(manifestPath, JSON.stringify(manifest, null, 2));
  console.log(
    `Done for ${variant}. Generated: ${generated}. Skipped: ${skipped}. Failed: ${failed}. Output: ${outputDir}`,
  );
}

async function filterPhrases(phrases: AppPack['phrases'], filterCsvPath?: string) {
  if (!filterCsvPath) {
    return phrases;
  }

  const resolvedCsvPath = path.resolve(process.cwd(), filterCsvPath);
  const filterKeys = await readFilterKeys(resolvedCsvPath);
  const filtered = phrases.filter((phrase) => filterKeys.has(phrase.id) || filterKeys.has(phrase.audioKey));
  const missingKeys = [...filterKeys].filter(
    (key) => !phrases.some((phrase) => phrase.id === key || phrase.audioKey === key),
  );

  if (missingKeys.length > 0) {
    throw new Error(
      `Filter CSV ${resolvedCsvPath} includes ${missingKeys.length} missing phrase/audio key(s): ${missingKeys.join(', ')}`,
    );
  }

  if (filtered.length === 0) {
    throw new Error(`Filter CSV ${resolvedCsvPath} did not match any phrases for variant "${variantNameForError(phrases)}".`);
  }

  return filtered;
}

function loadPack(variant: string): AppPack {
  switch (variant) {
    case 'tagalog':
      return tagalogPack;
    case 'viet':
      return vietPack;
    default:
      throw new Error(`Unsupported variant "${variant}". Expected "viet" or "tagalog".`);
  }
}

function getAudioDir(variant: string) {
  if (variant === 'tagalog') {
    return path.join(APP_ROOT, 'assets', 'audio', 'tagalog');
  }

  return path.join(APP_ROOT, 'assets', 'audio');
}

async function resolveApiKey() {
  if (process.env.ELEVENLABS_API_KEY?.trim()) {
    return process.env.ELEVENLABS_API_KEY.trim();
  }

  const raw = await readFile(DOWNLOADS_SECRET_PATH, 'utf8');
  return raw.replace(/^API:\s*/i, '').trim();
}

async function readManifest(manifestPath: string) {
  if (!(await fileExists(manifestPath))) {
    return {} as AudioManifest;
  }

  return JSON.parse(await readFile(manifestPath, 'utf8')) as AudioManifest;
}

async function readFilterKeys(csvPath: string) {
  const raw = await readFile(csvPath, 'utf8');
  const rows = parseCsv(raw);
  if (rows.length === 0) {
    throw new Error(`Filter CSV ${csvPath} is empty.`);
  }

  const header = rows[0].map((value) => value.trim());
  const keyColumn =
    header.find((column) => ['repo_ref', 'audio_key', 'phrase_id'].includes(column)) ?? null;

  if (!keyColumn) {
    throw new Error(
      `Filter CSV ${csvPath} must contain one of these columns: repo_ref, audio_key, phrase_id.`,
    );
  }

  const keyIndex = header.indexOf(keyColumn);
  const keys = new Set<string>();

  for (const row of rows.slice(1)) {
    const rawKey = row[keyIndex]?.trim();
    if (!rawKey) {
      continue;
    }

    keys.add(rawKey);
  }

  if (keys.size === 0) {
    throw new Error(`Filter CSV ${csvPath} did not include any keys in column "${keyColumn}".`);
  }

  return keys;
}

function parseCsv(raw: string) {
  const normalized = raw.replace(/^\uFEFF/, '').trim();
  if (!normalized) {
    return [] as string[][];
  }

  const rows: string[][] = [];
  let current = '';
  let row: string[] = [];
  let inQuotes = false;

  for (let index = 0; index < normalized.length; index += 1) {
    const char = normalized[index];

    if (char === '"') {
      if (inQuotes && normalized[index + 1] === '"') {
        current += '"';
        index += 1;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }

    if (char === ',' && !inQuotes) {
      row.push(current);
      current = '';
      continue;
    }

    if ((char === '\n' || char === '\r') && !inQuotes) {
      if (char === '\r' && normalized[index + 1] === '\n') {
        index += 1;
      }

      row.push(current);
      rows.push(row);
      row = [];
      current = '';
      continue;
    }

    current += char;
  }

  row.push(current);
  rows.push(row);
  return rows;
}

function synthesizeSpeech(apiKey: string, voiceId: string, text: string) {
  return new Promise<Buffer>((resolve, reject) => {
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
        hostname: 'api.elevenlabs.io',
        path: `/v1/text-to-speech/${voiceId}?output_format=mp3_44100_128`,
        method: 'POST',
        headers: {
          'xi-api-key': apiKey,
          Accept: 'audio/mpeg',
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(body),
        },
      },
      (response) => {
        const chunks: Buffer[] = [];
        response.on('data', (chunk: Buffer) => chunks.push(chunk));
        response.on('end', () => {
          const buffer = Buffer.concat(chunks);

          if (response.statusCode !== 200) {
            reject(new Error(`HTTP ${response.statusCode}: ${buffer.toString('utf8')}`));
            return;
          }

          if (buffer.length < 1024) {
            reject(new Error(`Audio response too small for text "${text}".`));
            return;
          }

          resolve(buffer);
        });
      },
    );

    request.on('error', reject);
    request.write(body);
    request.end();
  });
}

async function fileExists(filePath: string) {
  try {
    await access(filePath);
    return true;
  } catch {
    return false;
  }
}

function getArgValue(flag: string, fallback: string) {
  const index = process.argv.indexOf(flag);
  if (index === -1 || index === process.argv.length - 1) {
    return fallback;
  }

  return process.argv[index + 1];
}

function getOptionalArgValue(flag: string) {
  const index = process.argv.indexOf(flag);
  if (index === -1 || index === process.argv.length - 1) {
    return undefined;
  }

  return process.argv[index + 1];
}

function variantNameForError(phrases: AppPack['phrases']) {
  return phrases[0]?.scenarioId ? 'requested pack' : 'unknown';
}

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
