import { access, mkdir, readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { resolveScriptRoots } from './resolve-script-roots';

type BaselinePhrase = {
  slotId: string;
  english: string;
  context: string;
  emoji: string;
};

type FamilyBaseline = {
  quickPhraseSlotIds: string[];
  scenarios: BaselineScenario[];
};

type BaselineScenario = {
  id: string;
  name: string;
  emoji: string;
  description: string;
  tip: string;
  phrases: BaselinePhrase[];
};

type StatusTemplate = {
  appId: string;
  variant: string;
  displayName: string;
  country: string;
  language: string;
  stage: string;
  testingGates: Record<string, TestingGateState>;
  hardBlock: HardBlock;
  contentReadiness: string;
  audioReadiness: string;
  baselineParity: string;
  featureEligibility: {
    search: boolean;
    flashcards: boolean;
  };
  pendingFeatureRollouts: string[];
  featureIntakeStatus: string;
  releaseStatus: string;
  blockerTag: string;
  blockerDetail: string;
  nextStep: string;
  sessionRoot: string;
  lastValidatedAt: string;
};

type TestingGateState = {
  status: string;
  evidenceRef: string;
};

type HardBlock = {
  active: boolean;
  type: string;
  owner: string;
  system: string;
  detail: string;
  nextHumanAction: string;
};

type AppManifestContract = {
  canonicalSessionRoot: string;
  defaults: {
    featureEligibility: {
      search: boolean;
      flashcards: boolean;
    };
    pendingFeatureRollouts: string[];
    featureIntakeStatus: string;
    testingGates: Record<string, TestingGateState>;
    hardBlock: HardBlock;
    prepLane: {
      stage: string;
      releaseStatus: string;
      blockerTag: string;
      blockerDetail: string;
      nextStep: string;
    };
  };
};

type CliArgs = {
  variant?: string;
  language?: string;
  country?: string;
  languageCode?: string;
  displayName?: string;
  appId?: string;
  force?: boolean;
};

const { repoRoot: REPO_ROOT } = resolveScriptRoots(import.meta.url);

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const variant = normalizeVariant(args.variant);

  if (!variant || !/^[a-z0-9-]+$/.test(variant)) {
    throw new Error('Missing or invalid --variant. Use lowercase letters, numbers, and hyphens only.');
  }

  if (!args.language?.trim() || !args.country?.trim() || !args.languageCode?.trim() || !args.displayName?.trim()) {
    throw new Error(
      'Missing required metadata. Provide --language, --country, --language-code, and --display-name.',
    );
  }

  const baseline = JSON.parse(
    await readFile(path.join(REPO_ROOT, 'templates', 'FAMILY_TRAVELER_BASELINE.json'), 'utf8'),
  ) as FamilyBaseline;
  const contract = JSON.parse(
    await readFile(path.join(REPO_ROOT, 'ops', 'app-manifest-contract.json'), 'utf8'),
  ) as AppManifestContract;

  const draftDir = path.join(REPO_ROOT, 'content-draft', variant);
  const statusPath = path.join(REPO_ROOT, 'ops', 'apps', `${variant}.json`);

  if ((await exists(draftDir)) && !args.force) {
    throw new Error(`Draft directory already exists for "${variant}": ${draftDir}`);
  }

  if ((await exists(statusPath)) && !args.force) {
    throw new Error(`Status manifest already exists for "${variant}": ${statusPath}`);
  }

  await mkdir(draftDir, { recursive: true });

  const scenarioOrder = baseline.scenarios.map((scenario) => scenario.id);
  const quickPhraseIds = baseline.quickPhraseSlotIds.map((slotId) => `${variant}-${slotId}`);
  const appId = args.appId?.trim() || `${variant}-travel-phrases`;
  const today = new Date().toISOString().slice(0, 10);

  const scenarioPlan = {
    variant,
    appId,
    displayName: args.displayName.trim(),
    language: args.language.trim(),
    languageCode: args.languageCode.trim(),
    country: args.country.trim(),
    scenarioOrder,
    quickPhraseIds,
    scenarios: baseline.scenarios.map((scenario, index) => ({
      order: index + 1,
      id: scenario.id,
      name: scenario.name,
      emoji: scenario.emoji,
      description: scenario.description,
      tip: scenario.tip,
    })),
    notes: `Shared traveler baseline scaffold for ${args.language.trim()}. Fill translation, pronunciation, and audio posture before runtime wiring.`,
  };

  const phraseRows = baseline.scenarios.flatMap((scenario) =>
    scenario.phrases.map((phrase) => {
      const fullPhraseId = `${variant}-${phrase.slotId}`;
      return {
        phrase_id: fullPhraseId,
        scenario_id: scenario.id,
        audio_key: fullPhraseId,
        english_text: phrase.english,
        target_text: '',
        pronunciation: '',
        context: phrase.context,
        emoji: phrase.emoji,
        notes: 'Baseline scaffold from the shared traveler surface',
        status: 'needs-translation',
      };
    }),
  );

  const audioRows = phraseRows.map((phrase) => ({
    phrase_id: phrase.phrase_id,
    target_text: '',
    audio_status: 'pending-source-text',
    source_path: '',
    notes: 'Fill after target text is finalized',
  }));

  const sourceNotes = `# ${args.language.trim()} Source Notes

Current reality:

- This lane is prep-only and is not wired into the runtime app registry yet.
- The shared traveler baseline has been scaffolded from the family baseline surface.

Next content pass should:

- confirm country-specific phrasing for ${args.country.trim()}
- translate the full 10-scenario baseline
- add practical pronunciation guides for English-speaking travelers
- decide the honest short-term audio posture before runtime wiring
`;

  const readme = `# ${args.language.trim()} Content Draft

This folder is the prep lane for the future ${args.displayName.trim()} app.

Use it for:

- scenario review against the shared traveler baseline
- translation and pronunciation drafting
- country-specific localization notes
- audio preparation after source text is stable

Current status:

- prep-only
- not runtime-wired
- safe for parallel content work without touching app/family
`;

  const statusManifest: StatusTemplate = {
    appId,
    variant,
    displayName: args.displayName.trim(),
    country: args.country.trim(),
    language: args.language.trim(),
    stage: contract.defaults.prepLane.stage,
    testingGates: cloneJson(contract.defaults.testingGates),
    hardBlock: cloneJson(contract.defaults.hardBlock),
    contentReadiness: 'baseline-skeleton-created',
    audioReadiness: 'not-decided',
    baselineParity: 'prep-lane-only',
    featureEligibility: cloneJson(contract.defaults.featureEligibility),
    pendingFeatureRollouts: cloneJson(contract.defaults.pendingFeatureRollouts),
    featureIntakeStatus: contract.defaults.featureIntakeStatus,
    releaseStatus: contract.defaults.prepLane.releaseStatus,
    blockerTag: contract.defaults.prepLane.blockerTag,
    blockerDetail: contract.defaults.prepLane.blockerDetail,
    nextStep: contract.defaults.prepLane.nextStep,
    sessionRoot: contract.canonicalSessionRoot,
    lastValidatedAt: today,
  };

  await writeFile(path.join(draftDir, 'README.md'), readme, 'utf8');
  await writeFile(path.join(draftDir, 'source-notes.md'), sourceNotes, 'utf8');
  await writeFile(path.join(draftDir, 'scenario-plan.json'), `${JSON.stringify(scenarioPlan, null, 2)}\n`, 'utf8');
  await writeFile(
    path.join(draftDir, 'phrase-source.csv'),
    toCsv(
      [
        'phrase_id',
        'scenario_id',
        'audio_key',
        'english_text',
        'target_text',
        'pronunciation',
        'context',
        'emoji',
        'notes',
        'status',
      ],
      phraseRows,
    ),
    'utf8',
  );
  await writeFile(
    path.join(draftDir, 'audio-manifest.csv'),
    toCsv(['phrase_id', 'target_text', 'audio_status', 'source_path', 'notes'], audioRows),
    'utf8',
  );
  await writeFile(statusPath, `${JSON.stringify(statusManifest, null, 2)}\n`, 'utf8');

  console.log(`Scaffolded prep lane for "${variant}" in ${draftDir}`);
  console.log(`Created status manifest ${statusPath}`);
}

function normalizeVariant(value?: string) {
  return value?.trim().toLowerCase();
}

async function exists(targetPath: string) {
  try {
    await access(targetPath);
    return true;
  } catch {
    return false;
  }
}

function parseArgs(argv: string[]): CliArgs {
  const parsed: CliArgs = {};

  for (let index = 0; index < argv.length; index += 1) {
    const token = argv[index];
    const next = argv[index + 1];

    if (token === '--variant') {
      parsed.variant = next;
      index += 1;
      continue;
    }

    if (token === '--language') {
      parsed.language = next;
      index += 1;
      continue;
    }

    if (token === '--country') {
      parsed.country = next;
      index += 1;
      continue;
    }

    if (token === '--language-code') {
      parsed.languageCode = next;
      index += 1;
      continue;
    }

    if (token === '--display-name') {
      parsed.displayName = next;
      index += 1;
      continue;
    }

    if (token === '--app-id') {
      parsed.appId = next;
      index += 1;
      continue;
    }

    if (token === '--force') {
      parsed.force = true;
      continue;
    }

    throw new Error(`Unknown argument "${token}".`);
  }

  return parsed;
}

function toCsv(headers: string[], rows: Record<string, string>[]) {
  const lines = [
    headers.join(','),
    ...rows.map((row) => headers.map((header) => escapeCsv(row[header] ?? '')).join(',')),
  ];

  return `${lines.join('\n')}\n`;
}

function escapeCsv(value: string) {
  if (!/[",\n]/.test(value)) {
    return value;
  }

  return `"${value.replace(/"/g, '""')}"`;
}

function cloneJson<T>(value: T) {
  return JSON.parse(JSON.stringify(value)) as T;
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
