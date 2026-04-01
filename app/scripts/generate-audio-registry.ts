import { readdir, writeFile } from 'node:fs/promises';
import path from 'node:path';

const AUDIO_DIR = path.resolve(process.cwd(), 'assets/audio');
const REGISTRY_PATH = path.join(AUDIO_DIR, 'registry.ts');

async function main() {
  const files = (await readdir(AUDIO_DIR))
    .filter((file) => file.endsWith('.mp3'))
    .sort((left, right) => left.localeCompare(right));

  const entries = files
    .map((file) => `  ${JSON.stringify(file)}: require(${JSON.stringify(`./${file}`)}),`)
    .join('\n');

  const content = `const audioRegistry: Record<string, number> = {\n${entries}\n};\n\nexport default audioRegistry;\n`;

  await writeFile(REGISTRY_PATH, content);
  console.log(`Wrote ${files.length} registry entries to ${REGISTRY_PATH}`);
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
