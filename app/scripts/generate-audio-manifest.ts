import { readdir, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { AppPack } from '../family/contracts';
import { tagalogPack } from '../family/packs/tagalog';
import { vietPack } from '../family/packs/viet';

type AudioManifest = Record<string, { fileName: string; text: string }>;

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const APP_ROOT = path.resolve(SCRIPT_DIR, '..');

async function main() {
  const variant = getArgValue('--variant', 'viet');
  const audioDir = resolveAudioDir(variant);
  const manifestPath = path.join(audioDir, 'manifest.json');
  const pack = resolvePack(variant);
  const existingFiles = new Set((await readdir(audioDir)).filter((file) => file.endsWith('.mp3')));

  const manifest: AudioManifest = {};
  let missingFiles = 0;

  for (const phrase of pack.phrases) {
    const fileName = `${phrase.audioKey}.mp3`;
    if (!existingFiles.has(fileName)) {
      missingFiles += 1;
      continue;
    }

    manifest[phrase.audioKey] = {
      fileName,
      text: phrase.targetText,
    };
  }

  await writeFile(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`, 'utf8');
  console.log(
    `Wrote ${Object.keys(manifest).length} manifest entries to ${manifestPath}. Missing expected file(s): ${missingFiles}.`,
  );
}

function getArgValue(flag: string, fallback: string) {
  const index = process.argv.indexOf(flag);
  if (index === -1 || index === process.argv.length - 1) {
    return fallback;
  }

  return process.argv[index + 1];
}

function resolveAudioDir(variant: string) {
  switch (variant) {
    case 'tagalog':
      return path.join(APP_ROOT, 'assets', 'audio', 'tagalog');
    case 'viet':
      return path.join(APP_ROOT, 'assets', 'audio');
    default:
      throw new Error(`Unsupported variant "${variant}". Expected "viet" or "tagalog".`);
  }
}

function resolvePack(variant: string): AppPack {
  switch (variant) {
    case 'tagalog':
      return tagalogPack;
    case 'viet':
      return vietPack;
    default:
      throw new Error(`Unsupported variant "${variant}". Expected "viet" or "tagalog".`);
  }
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
