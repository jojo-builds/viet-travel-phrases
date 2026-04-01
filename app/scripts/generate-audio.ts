import 'dotenv/config';
import { mkdir, access, writeFile } from 'node:fs/promises';
import path from 'node:path';
import OpenAI from 'openai';
import { phrases } from '../content/scenarios';

const AUDIO_DIR = path.resolve(process.cwd(), 'assets/audio');
const DELAY_MS = 500;

async function main() {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    throw new Error('OPENAI_API_KEY is not set.');
  }

  const client = new OpenAI({ apiKey });
  await mkdir(AUDIO_DIR, { recursive: true });

  const total = phrases.length;
  let completed = 0;
  let generated = 0;

  for (const phrase of phrases) {
    completed += 1;
    const filename = `${phrase.audioKey}.mp3`;
    const outputPath = path.join(AUDIO_DIR, filename);

    if (await fileExists(outputPath)) {
      console.log(`Skipped ${completed}/${total}: ${filename}`);
      continue;
    }

    const response = await client.audio.speech.create({
      model: 'gpt-4o-mini-tts',
      voice: 'nova',
      input: phrase.vietnamese,
      instructions:
        'Speak slowly and clearly in Vietnamese. This is for language learners. Southern Vietnamese dialect.',
      response_format: 'mp3',
    });

    const buffer = Buffer.from(await response.arrayBuffer());
    await writeFile(outputPath, buffer);
    generated += 1;
    console.log(`Generated ${completed}/${total}: ${filename}`);
    await sleep(DELAY_MS);
  }

  console.log(`Done. ${generated} generated, ${total - generated} already existed, ${total} total.`);
}

async function fileExists(filePath: string) {
  try {
    await access(filePath);
    return true;
  } catch {
    return false;
  }
}

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
