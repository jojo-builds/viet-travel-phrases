import { readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { parseCsvRows } from './csv';

type DraftScenario = {
  order: number;
  id: string;
  name: string;
  emoji: string;
  description: string;
  tip: string;
};

type DraftPhrase = {
  phrase_id: string;
  scenario_id: string;
  audio_key: string;
  english_text: string;
  target_text: string;
  pronunciation: string;
  access_tier?: string;
  context: string;
  emoji: string;
};

type DraftPlan = {
  appId: string;
  language: string;
  country: string;
  scenarioOrder: string[];
  quickPhraseIds: string[];
  scenarios: DraftScenario[];
};

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const APP_ROOT = path.resolve(SCRIPT_DIR, '..');
const REPO_ROOT = path.resolve(APP_ROOT, '..');
const DRAFT_DIR = path.join(REPO_ROOT, 'content-draft', 'tagalog');
const PLAN_PATH = path.join(DRAFT_DIR, 'scenario-plan.json');
const PHRASE_PATH = path.join(DRAFT_DIR, 'phrase-source.csv');
const OUTPUT_PATH = path.join(APP_ROOT, 'family', 'packs', 'tagalog.generated.ts');

async function main() {
  const plan = JSON.parse(await readFile(PLAN_PATH, 'utf8')) as DraftPlan;
  const phrases = parseCsv(await readFile(PHRASE_PATH, 'utf8'));

  const scenarioMap = new Map(plan.scenarios.map((scenario) => [scenario.id, scenario]));
  const scenarios = [...plan.scenarios]
    .sort((left, right) => left.order - right.order)
    .map((scenario) => ({
      id: scenario.id,
      name: scenario.name,
      emoji: scenario.emoji,
      description: scenario.description,
      tip: scenario.tip,
      phrases: phrases
        .filter((phrase) => phrase.scenario_id === scenario.id)
        .map((phrase) => ({
          id: phrase.phrase_id,
          scenarioId: phrase.scenario_id,
          targetText: phrase.target_text,
          pronunciation: phrase.pronunciation,
          sourceText: phrase.english_text,
          audioKey: phrase.audio_key,
          accessTier: normalizeAccessTier(phrase.access_tier),
          context: phrase.context,
          emoji: phrase.emoji,
        })),
    }));

  const scenarioCount = scenarios.length;
  const phraseCount = scenarios.flatMap((scenario) => scenario.phrases).length;

  if (scenarioCount !== plan.scenarioOrder.length || scenarioCount !== scenarioMap.size) {
    throw new Error('Scenario plan order is inconsistent with the declared scenario list.');
  }

  const output = `import { AppPack, AppPhrase, AppScenario } from '../contracts';

const scenarios: AppScenario[] = ${JSON.stringify(scenarios, null, 2)};

const phrases = scenarios.flatMap((scenario) => scenario.phrases);

export const tagalogPack: AppPack = {
  metadata: {
    appId: ${JSON.stringify(plan.appId)},
    packId: 'tagalog',
    displayName: 'Tagalog Travel Phrasebook',
    country: ${JSON.stringify(plan.country)},
    language: ${JSON.stringify(plan.language)},
    languageCode: 'tl',
    schemaVersion: 1,
  },
  scenarios,
  phrases,
  scenarioMap: Object.fromEntries(
    scenarios.map((scenario) => [scenario.id, scenario]),
  ) as Record<string, AppScenario>,
  phraseMap: Object.fromEntries(
    phrases.map((phrase) => [phrase.id, phrase]),
  ) as Record<string, AppPhrase>,
};
`;

  await writeFile(OUTPUT_PATH, output);
  console.log(`Wrote Tagalog pack with ${scenarioCount} scenarios and ${phraseCount} phrases.`);
}

function parseCsv(text: string): DraftPhrase[] {
  const [headerRow, ...rows] = parseCsvRows(text);
  const headers = headerRow.map((cell) => cell.trim());

  return rows.map((row) => {
    const entry = Object.fromEntries(headers.map((header, index) => [header, row[index]?.trim() ?? '']));
    return entry as DraftPhrase;
  });
}

function normalizeAccessTier(value?: string): 'starter' | 'premium' {
  const normalizedValue = value?.trim().toLowerCase();

  if (!normalizedValue) {
    return 'starter';
  }

  if (normalizedValue === 'starter' || normalizedValue === 'premium') {
    return normalizedValue;
  }

  throw new Error(`Unsupported access tier "${value}". Expected "starter" or "premium".`);
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
