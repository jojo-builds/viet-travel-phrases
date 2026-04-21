import { readdir, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { AppPack } from '../family/contracts';
import { tagalogPack } from '../family/packs/tagalog';
import { vietPack } from '../family/packs/viet';

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const APP_ROOT = path.resolve(SCRIPT_DIR, '..');

async function main() {
  const variant = getArgValue('--variant', 'viet');
  const audioDir = resolveAudioDir(variant);
  const registryPath = path.join(audioDir, 'registry.ts');
  const pack = resolvePack(variant);
  const expectedFiles = new Set(pack.phrases.map((phrase) => `${phrase.audioKey}.mp3`));

  const existingFiles = (await readdir(audioDir))
    .filter((file) => file.endsWith('.mp3'))
    .sort((left, right) => left.localeCompare(right));
  const files = existingFiles.filter((file) => expectedFiles.has(file));
  const ignoredExtras = existingFiles.filter((file) => !expectedFiles.has(file));

  const entries = files
    .map((file) => `  ${JSON.stringify(file)}: require(${JSON.stringify(`./${file}`)}),`)
    .join('\n');

  const content = `const audioRegistry: Record<string, number> = {\n${entries}\n};\n\nexport default audioRegistry;\n`;

  await writeFile(registryPath, content);
  console.log(
    `Wrote ${files.length} registry entries to ${registryPath}. Ignored ${ignoredExtras.length} extra on-disk file(s).`,
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
