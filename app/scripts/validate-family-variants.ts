import { access, readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  DEFAULT_APP_VARIANT,
  getAppDefinition,
  resolveAppVariantFromBuildContext,
  supportedAppVariants,
} from '../family/appRegistry';
import { AppPack, AppPresentationConfig } from '../family/contracts';
import { tagalogPack } from '../family/packs/tagalog';
import { vietPack } from '../family/packs/viet';
import { tagalogPresentation } from '../family/presentation/tagalog';
import { vietPresentation } from '../family/presentation/viet';
import { searchPhrases } from '../lib/searchPhrases';
import { parseCsvRows } from './csv';

type DraftScenario = {
  id: string;
};

type DraftPlan = {
  scenarioOrder: string[];
  quickPhraseIds: string[];
  scenarios: DraftScenario[];
};

type DraftPhrase = {
  phrase_id: string;
  scenario_id: string;
  family_id?: string;
  access_tier?: string;
  variant_role?: string;
  context?: string;
  you_may_hear?: string;
  search_aliases?: string;
  audio_status?: string;
};

type WebsitePreviewConfig = {
  schemaVersion?: number;
  destinationSlug?: string;
  destinationName?: string;
  language?: string;
  modules: WebsitePreviewModuleConfig[];
};

type WebsitePreviewModuleConfig = {
  moduleId?: string;
  scenarioId?: string;
  editorialStatus?: string;
  audioStatus?: 'planned' | 'mixed' | 'ready';
  audioDelivery?: string;
  appStatus?: string;
  headline?: string;
  summary?: string;
  travelerStage?: string;
  difficulty?: string;
  formality?: string;
  audioDurationMs?: number | null;
  transcriptChecked?: boolean | null;
  cta?: {
    primaryLabel?: string;
    primaryUrl?: string;
    secondaryLabel?: string;
    secondaryUrl?: string;
  };
  phraseIds: string[];
};

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const { appRoot: APP_ROOT, repoRoot: REPO_ROOT } = resolveRoots();
const VIET_REGISTRY_PATH = path.join(APP_ROOT, 'assets', 'audio', 'registry.ts');
const TAGALOG_REGISTRY_PATH = path.join(APP_ROOT, 'assets', 'audio', 'tagalog', 'registry.ts');

const variantRuntime = {
  viet: {
    pack: vietPack,
    presentation: vietPresentation,
    registryPath: VIET_REGISTRY_PATH,
    draftDir: path.join(REPO_ROOT, 'content-draft', 'viet'),
  },
  tagalog: {
    pack: tagalogPack,
    presentation: tagalogPresentation,
    registryPath: TAGALOG_REGISTRY_PATH,
    draftDir: path.join(REPO_ROOT, 'content-draft', 'tagalog'),
  },
} as const;

function resolveRoots() {
  const cwd = path.resolve(process.cwd());
  if (path.basename(cwd).toLowerCase() === 'app') {
    return {
      appRoot: cwd,
      repoRoot: path.resolve(cwd, '..'),
    };
  }

  const appRoot = path.resolve(SCRIPT_DIR, '..');
  return {
    appRoot,
    repoRoot: path.resolve(appRoot, '..'),
  };
}

async function main() {
  await validateDraftBackedVariant('viet');
  await validateDraftBackedVariant('tagalog');
  validateRuntimeVariantResolution();
  validateSearchBehavior();
  console.log('Family variant validation passed.');
}

async function validateDraftBackedVariant(variant: keyof typeof variantRuntime) {
  const runtime = variantRuntime[variant];
  const draftPlanPath = path.join(runtime.draftDir, 'scenario-plan.json');
  const draftPhrasePath = path.join(runtime.draftDir, 'phrase-source.csv');
  const plan = JSON.parse(await readFile(draftPlanPath, 'utf8')) as DraftPlan;
  const draftPhrases = parseDraftPhrases(await readFile(draftPhrasePath, 'utf8'));
  const audioRegistryKeys = new Set(await readRegistryKeys(runtime.registryPath));

  validateDraftAlignment(variant, runtime.pack, runtime.presentation, plan, draftPhrases);
  validatePackStructure(variant, runtime.pack, runtime.presentation, audioRegistryKeys);
  await validateWebsitePreviewConfig(runtime.pack, runtime.draftDir);
}

function validateDraftAlignment(
  variant: keyof typeof variantRuntime,
  pack: AppPack,
  presentation: AppPresentationConfig,
  plan: DraftPlan,
  draftPhrases: DraftPhrase[],
) {
  if (!plan.scenarios.length || !draftPhrases.length) {
    throw new Error(`${variant} draft source is unexpectedly empty.`);
  }

  if (pack.scenarios.length !== plan.scenarios.length) {
    throw new Error(`${variant} pack scenario count ${pack.scenarios.length} does not match draft count ${plan.scenarios.length}.`);
  }

  if (pack.phrases.length !== draftPhrases.length) {
    throw new Error(`${variant} pack phrase count ${pack.phrases.length} does not match draft count ${draftPhrases.length}.`);
  }

  for (const draftPhrase of draftPhrases) {
    const builtPhrase = pack.phraseMap[draftPhrase.phrase_id];
    if (!builtPhrase) {
      throw new Error(`${variant} built pack is missing phrase "${draftPhrase.phrase_id}".`);
    }

    if (builtPhrase.scenarioId !== draftPhrase.scenario_id) {
      throw new Error(`${variant} phrase "${draftPhrase.phrase_id}" has stale scenario metadata in the built pack.`);
    }

    if (builtPhrase.intentFamilyId !== normalizeDraftFamilyId(draftPhrase)) {
      throw new Error(`${variant} phrase "${draftPhrase.phrase_id}" has stale family metadata in the built pack.`);
    }

    if (builtPhrase.accessTier !== normalizeDraftAccessTier(draftPhrase.access_tier)) {
      throw new Error(`${variant} phrase "${draftPhrase.phrase_id}" has stale access tier metadata in the built pack.`);
    }

    if ((builtPhrase.variantRole ?? 'say-first') !== normalizeDraftVariantRole(draftPhrase.variant_role)) {
      throw new Error(`${variant} phrase "${draftPhrase.phrase_id}" has stale variant-role metadata in the built pack.`);
    }

    if ((builtPhrase.audioStatus ?? 'ready') !== normalizeDraftAudioStatus(draftPhrase.audio_status)) {
      throw new Error(`${variant} phrase "${draftPhrase.phrase_id}" has stale audio-status metadata in the built pack.`);
    }

    if ((builtPhrase.usageNote ?? builtPhrase.context ?? '') !== (draftPhrase.context ?? '')) {
      throw new Error(`${variant} phrase "${draftPhrase.phrase_id}" has stale usage-note metadata in the built pack.`);
    }

    if ((builtPhrase.youMayHear ?? '') !== (draftPhrase.you_may_hear ?? '')) {
      throw new Error(`${variant} phrase "${draftPhrase.phrase_id}" has stale you-may-hear metadata in the built pack.`);
    }

    if (normalizeDelimited(builtPhrase.searchAliases) !== normalizeDelimited(parseDelimited(draftPhrase.search_aliases))) {
      throw new Error(`${variant} phrase "${draftPhrase.phrase_id}" has stale search alias metadata in the built pack.`);
    }
  }

  if (JSON.stringify(presentation.home.scenarioOrder) !== JSON.stringify(plan.scenarioOrder)) {
    throw new Error(`${variant} presentation.home.scenarioOrder does not match the draft plan order.`);
  }

  for (const quickPhraseId of plan.quickPhraseIds) {
    const phrase = pack.phraseMap[quickPhraseId];
    if (!phrase) {
      throw new Error(`${variant} quick phrase "${quickPhraseId}" is missing from the built pack.`);
    }

    if (phrase.accessTier !== 'starter') {
      throw new Error(`${variant} quick phrase "${quickPhraseId}" must stay starter tier.`);
    }
  }

  if (variant === 'viet' && pack.scenarios.length < 18) {
    throw new Error('Viet v2 should expose at least the 18-category backbone.');
  }
}

function validatePackStructure(
  variant: keyof typeof variantRuntime,
  pack: AppPack,
  presentation: AppPresentationConfig,
  audioRegistryKeys: Set<string>,
) {
  if (!pack.intentFamilies.length) {
    throw new Error(`${variant} pack is missing intent families.`);
  }

  const phraseIds = new Set<string>();
  const familyIds = new Set<string>();

  for (const phrase of pack.phrases) {
    if (phraseIds.has(phrase.id)) {
      throw new Error(`${variant} pack contains duplicate phrase "${phrase.id}".`);
    }
    phraseIds.add(phrase.id);

    if (!phrase.intentFamilyId || !pack.intentFamilyMap[phrase.intentFamilyId]) {
      throw new Error(`${variant} phrase "${phrase.id}" is missing an intent family link.`);
    }

    if (phrase.audioStatus !== 'planned' && !audioRegistryKeys.has(`${phrase.audioKey}.mp3`)) {
      throw new Error(`${variant} phrase "${phrase.id}" expects ready audio but no asset exists for "${phrase.audioKey}".`);
    }
  }

  for (const family of pack.intentFamilies) {
    if (familyIds.has(family.id)) {
      throw new Error(`${variant} pack contains duplicate intent family "${family.id}".`);
    }
    familyIds.add(family.id);

    const primary = pack.phraseMap[family.primaryPhraseId];
    if (!primary || primary.variantRole !== 'say-first') {
      throw new Error(`${variant} family "${family.id}" does not point at a valid say-first phrase.`);
    }

    if (family.accessTier !== primary.accessTier) {
      throw new Error(`${variant} family "${family.id}" access tier must match its primary phrase.`);
    }
  }

  for (const scenario of pack.scenarios) {
    if (!scenario.intentFamilies.length) {
      throw new Error(`${variant} scenario "${scenario.id}" is missing intent families.`);
    }

    if (!scenario.phrases.length) {
      throw new Error(`${variant} scenario "${scenario.id}" is missing phrases.`);
    }
  }

  for (const category of presentation.premium.categories) {
    if (category.scenarioId && !pack.scenarioMap[category.scenarioId]) {
      throw new Error(`${variant} premium category "${category.id}" references missing scenario "${category.scenarioId}".`);
    }
  }

  if (variant === 'viet') {
    const requiredStarterScenarioIds = [
      'understanding-repair',
      'health-pharmacy',
      'emergency-safety',
      'airport-border-arrival',
      'problems-help',
    ];

    for (const scenarioId of requiredStarterScenarioIds) {
      const scenario = pack.scenarioMap[scenarioId];
      if (!scenario) {
        throw new Error(`Viet v2 is missing required scenario "${scenarioId}".`);
      }

      const starterFamilies = scenario.intentFamilies.filter((family) => family.accessTier === 'starter');
      if (!starterFamilies.length) {
        throw new Error(`Viet scenario "${scenarioId}" must keep at least one starter intent family.`);
      }
    }
  }
}

function validateRuntimeVariantResolution() {
  const explicitDefault = resolveAppVariantFromBuildContext({
    env: {},
    allowDefault: true,
  });

  if (explicitDefault !== DEFAULT_APP_VARIANT) {
    throw new Error(`Expected default variant "${DEFAULT_APP_VARIANT}" but resolved "${explicitDefault}".`);
  }

  let threwOnMissingStandaloneResolution = false;
  try {
    resolveAppVariantFromBuildContext({
      env: {},
      allowDefault: false,
    });
  } catch {
    threwOnMissingStandaloneResolution = true;
  }

  if (!threwOnMissingStandaloneResolution) {
    throw new Error('Standalone-style resolution must fail when no variant markers are present.');
  }

  for (const variant of supportedAppVariants) {
    const definition = getAppDefinition(variant);
    const resolvedFromExpoExtra = resolveAppVariantFromBuildContext({
      env: {},
      expoExtra: {
        appVariant: definition.build.appVariant,
        eas: definition.build.easProjectId
          ? {
              projectId: definition.build.easProjectId,
            }
          : undefined,
      },
      allowDefault: false,
    });

    if (resolvedFromExpoExtra !== variant) {
      throw new Error(`Expo extra resolution returned "${resolvedFromExpoExtra}" for variant "${variant}".`);
    }
  }
}

function validateSearchBehavior() {
  validateSearchExpectations('viet', vietPack, [
    { query: 'hello', expectedPhraseId: 'polite-1', unlocked: false },
    { query: 'xin chao', expectedPhraseId: 'polite-1', unlocked: false },
    { query: 'restroom', expectedPhraseId: 'bath-1', unlocked: false },
    { query: 'pharmacy', expectedPhraseId: 'health-pharmacy-clearer', unlocked: false },
    { query: 'charged twice', expectedPhraseId: 'help-4', unlocked: true, lockedShouldHide: true },
    { query: 'embassy', expectedPhraseId: 'emergency-7', unlocked: true, lockedShouldHide: true },
  ]);

  validateSearchExpectations('tagalog', tagalogPack, [
    { query: 'hello', expectedPhraseId: 'tagalog-polite-basics-1', unlocked: false },
    { query: 'kumusta', expectedPhraseId: 'tagalog-polite-basics-1', unlocked: false },
    { query: 'taxi', expectedPhraseId: 'tagalog-grab-taxi-1', unlocked: false },
  ]);
}

function validateSearchExpectations(
  variant: 'viet' | 'tagalog',
  pack: AppPack,
  expectations: Array<{
    query: string;
    expectedPhraseId: string;
    unlocked: boolean;
    lockedShouldHide?: boolean;
  }>,
) {
  for (const expectation of expectations) {
    if (expectation.lockedShouldHide) {
      const lockedResults = searchPhrases(pack, expectation.query, false);
      if (lockedResults.some((result) => result.phrase.id === expectation.expectedPhraseId)) {
        throw new Error(`${variant} search leaked premium phrase "${expectation.expectedPhraseId}" while locked.`);
      }
    }

    const results = searchPhrases(pack, expectation.query, expectation.unlocked);
    if (!results.some((result) => result.phrase.id === expectation.expectedPhraseId)) {
      throw new Error(
        `${variant} search failed to return "${expectation.expectedPhraseId}" for query "${expectation.query}".`,
      );
    }
  }
}

function parseDraftPhrases(text: string) {
  const [headerRow, ...rows] = parseCsvRows(text);
  const headers = headerRow.map((cell) => cell.trim());

  return rows.map((row) => {
    return Object.fromEntries(headers.map((header, index) => [header, row[index]?.trim() ?? ''])) as DraftPhrase;
  });
}

async function validateWebsitePreviewConfig(pack: AppPack, draftDir: string) {
  const configPath = path.join(draftDir, 'website-preview.json');

  try {
    await access(configPath);
  } catch {
    return;
  }

  const config = JSON.parse(await readFile(configPath, 'utf8')) as WebsitePreviewConfig;
  if (!Number.isInteger(config.schemaVersion) || (config.schemaVersion ?? 0) < 1) {
    throw new Error(`Website preview config "${configPath}" must declare a positive schemaVersion.`);
  }

  if (!config.destinationSlug?.trim() || !config.destinationName?.trim() || !config.language?.trim()) {
    throw new Error(`Website preview config "${configPath}" is missing destination or language metadata.`);
  }

  const moduleIds = new Set<string>();

  for (const module of config.modules) {
    const moduleId = module.moduleId?.trim();
    if (!moduleId) {
      throw new Error(`Website preview config "${configPath}" contains a module without moduleId.`);
    }

    if (moduleIds.has(moduleId)) {
      throw new Error(`Website preview config contains duplicate moduleId "${moduleId}".`);
    }
    moduleIds.add(moduleId);

    if (!module.scenarioId?.trim()) {
      throw new Error(`Website preview module "${moduleId}" is missing scenarioId.`);
    }

    if (!module.editorialStatus?.trim() || !module.audioStatus?.trim() || !module.audioDelivery?.trim() || !module.appStatus?.trim()) {
      throw new Error(`Website preview module "${moduleId}" is missing editorial/audio/app metadata.`);
    }

    if (!['planned', 'mixed', 'ready'].includes(module.audioStatus)) {
      throw new Error(`Website preview module "${moduleId}" has invalid audioStatus "${module.audioStatus}".`);
    }

    if (!module.headline?.trim() || !module.summary?.trim()) {
      throw new Error(`Website preview module "${moduleId}" is missing headline or summary.`);
    }

    for (const optionalTextField of ['travelerStage', 'difficulty', 'formality'] as const) {
      const value = module[optionalTextField];
      if (value != null && !String(value).trim()) {
        throw new Error(`Website preview module "${moduleId}" has blank ${optionalTextField} metadata.`);
      }
    }

    if (module.audioDurationMs != null && (!Number.isInteger(module.audioDurationMs) || module.audioDurationMs < 0)) {
      throw new Error(`Website preview module "${moduleId}" has invalid audioDurationMs metadata.`);
    }

    if (module.transcriptChecked != null && typeof module.transcriptChecked !== 'boolean') {
      throw new Error(`Website preview module "${moduleId}" has invalid transcriptChecked metadata.`);
    }

    if (!module.cta?.primaryLabel?.trim() || !module.cta?.secondaryLabel?.trim()) {
      throw new Error(`Website preview module "${moduleId}" is missing CTA labels.`);
    }

    if (!isHttpUrl(module.cta.primaryUrl) || !isHttpUrl(module.cta.secondaryUrl) && !isRootRelativePath(module.cta.secondaryUrl)) {
      throw new Error(`Website preview module "${moduleId}" has invalid CTA URLs.`);
    }

    if (!module.phraseIds.length) {
      throw new Error(`Website preview module "${moduleId}" must include at least one phraseId.`);
    }

    if (new Set(module.phraseIds).size !== module.phraseIds.length) {
      throw new Error(`Website preview module "${moduleId}" contains duplicate phraseIds.`);
    }

    const scenario = pack.scenarioMap[module.scenarioId];
    if (!scenario) {
      throw new Error(`Website preview module "${moduleId}" references missing scenario "${module.scenarioId}".`);
    }

    const familyIds = new Set<string>();
    let readyPhraseCount = 0;

    for (const phraseId of module.phraseIds) {
      const phrase = pack.phraseMap[phraseId];
      if (!phrase) {
        throw new Error(`Website preview module "${moduleId}" references missing phrase "${phraseId}".`);
      }

      if (phrase.scenarioId !== module.scenarioId) {
        throw new Error(`Website preview module "${moduleId}" includes phrase "${phraseId}" outside its scenario.`);
      }

      if (phrase.accessTier !== 'starter') {
        throw new Error(`Website preview module "${moduleId}" includes premium phrase "${phraseId}".`);
      }

      const family = pack.intentFamilyMap[phrase.intentFamilyId];
      if (!family) {
        throw new Error(`Website preview module "${moduleId}" references phrase "${phraseId}" without a family.`);
      }

      if (family.primaryPhraseId !== phrase.id || phrase.variantRole !== 'say-first') {
        throw new Error(`Website preview module "${moduleId}" must stay default-first. "${phraseId}" is not a family primary.`);
      }

      if (phrase.audioStatus === 'ready') {
        readyPhraseCount += 1;
      }

      if (familyIds.has(family.id)) {
        throw new Error(`Website preview module "${moduleId}" includes multiple phrases from family "${family.id}".`);
      }
      familyIds.add(family.id);
    }

    const resolvedAudioStatus = resolveWebsitePreviewAudioStatus(readyPhraseCount, module.phraseIds.length);
    if (module.audioStatus !== resolvedAudioStatus) {
      throw new Error(
        `Website preview module "${moduleId}" declares audioStatus "${module.audioStatus}" but pack-backed coverage resolves to "${resolvedAudioStatus}".`,
      );
    }
  }
}

function isHttpUrl(value?: string) {
  return !!value?.trim() && /^https?:\/\//i.test(value.trim());
}

function isRootRelativePath(value?: string) {
  return !!value?.trim() && value.trim().startsWith('/');
}

function normalizeDraftFamilyId(phrase: DraftPhrase) {
  return phrase.family_id?.trim() || phrase.phrase_id;
}

function normalizeDraftAccessTier(value?: string) {
  return value?.trim().toLowerCase() === 'premium' ? 'premium' : 'starter';
}

function normalizeDraftVariantRole(value?: string) {
  const normalized = value?.trim().toLowerCase();
  return normalized || 'say-first';
}

function normalizeDraftAudioStatus(value?: string) {
  return value?.trim().toLowerCase() === 'planned' ? 'planned' : 'ready';
}

function resolveWebsitePreviewAudioStatus(readyPhraseCount: number, totalPhraseCount: number) {
  if (readyPhraseCount <= 0) {
    return 'planned' as const;
  }

  if (readyPhraseCount >= totalPhraseCount) {
    return 'ready' as const;
  }

  return 'mixed' as const;
}

function parseDelimited(value?: string) {
  return value
    ?.split('|')
    .map((item) => item.trim())
    .filter(Boolean);
}

function normalizeDelimited(value?: string[]) {
  return JSON.stringify((value ?? []).slice().sort());
}

async function readRegistryKeys(registryPath: string) {
  const text = await readFile(registryPath, 'utf8');
  const keys = [...text.matchAll(/^\s*"([^"]+\.mp3)":/gm)].map((match) => match[1]);

  if (!keys.length) {
    throw new Error(`No audio registry entries found in ${registryPath}.`);
  }

  return keys;
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
