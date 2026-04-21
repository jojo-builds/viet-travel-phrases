import { access, copyFile, mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { AppPack } from '../family/contracts';
import { tagalogPack } from '../family/packs/tagalog';
import { vietPack } from '../family/packs/viet';

type WebsitePreviewConfig = {
  schemaVersion: number;
  destinationSlug: string;
  destinationName: string;
  language: string;
  trustDefaults?: WebsitePreviewTrustMetadata;
  modules: WebsitePreviewModuleConfig[];
};

type WebsitePreviewTrustMetadata = {
  sourceLabel?: string;
  sourceNote?: string;
  appBoundary?: string;
  methodologyLabel?: string;
  methodologyUrl?: string;
  correctionsLabel?: string;
  correctionsUrl?: string;
};

type WebsitePreviewModuleConfig = {
  moduleId: string;
  scenarioId: string;
  editorialStatus: string;
  audioStatus: AudioCoverageStatus;
  audioDelivery: string;
  appStatus: string;
  headline: string;
  summary: string;
  travelerStage?: string;
  difficulty?: string;
  formality?: string;
  audioDurationMs?: number | null;
  transcriptChecked?: boolean | null;
  cta: {
    primaryLabel: string;
    primaryUrl: string;
    secondaryLabel: string;
    secondaryUrl: string;
  };
  trustOverrides?: WebsitePreviewTrustMetadata;
  phraseIds: string[];
};

type AudioCoverageStatus = 'planned' | 'mixed' | 'ready';

type WebsitePhraseAudioExport = {
  schemaVersion: number;
  exportType: 'website-phrase-audio-module';
  exportedAt: string;
  moduleId: string;
  moduleSlug: string;
  destinationSlug: string;
  destinationName: string;
  variant: string;
  language: string;
  languageCode: string;
  country: string;
  scenarioId: string;
  scenarioSlug: string;
  scenarioName: string;
  editorialStatus: string;
  appStatus: string;
  websiteAudioStatus: string;
  audioStatus: string;
  audioDelivery: string;
  audioCoverage: {
    status: AudioCoverageStatus;
    readyPhraseCount: number;
    plannedPhraseCount: number;
    totalPhraseCount: number;
  };
  headline: string;
  summary: string;
  travelerStage: string | null;
  difficulty: string | null;
  formality: string | null;
  audioDurationMs: number | null;
  transcriptChecked: boolean | null;
  phraseCount: number;
  familyCount: number;
  articleReference: {
    primaryLabel: string;
    primaryUrl: string;
    secondaryLabel: string;
    secondaryUrl: string;
  };
  trust: {
    sourceLabel: string | null;
    sourceNote: string | null;
    appBoundary: string | null;
    methodologyLabel: string | null;
    methodologyUrl: string | null;
    correctionsLabel: string | null;
    correctionsUrl: string | null;
  };
  cta: {
    primaryLabel: string;
    primaryUrl: string;
    secondaryLabel: string;
    secondaryUrl: string;
  };
  phrases: Array<{
    phraseId: string;
    phraseSlug: string;
    id: string;
    moduleId: string;
    destinationSlug: string;
    variant: string;
    language: string;
    languageCode: string;
    country: string;
    scenarioId: string;
    scenarioSlug: string;
    scenarioName: string;
    familyId: string;
    familySlug: string;
    familyTitle: string;
    familySummary?: string;
    accessTier: 'starter' | 'premium';
    variantRole: string;
    variantLabel: string;
    englishText: string;
    sourceText: string;
    targetText: string;
    canonicalTargetText: string;
    pronunciation: string;
    context: string;
    youMayHear?: string;
    warningNoteType?: string;
    audioStatus: string;
    audioDelivery: string;
    audioUrl: string | null;
    audioReference: {
      provider: 'speaklocal-site';
      delivery: string;
      audioKey: string;
      filename: string;
      relativePath: string;
      url: string | null;
    };
    audioDurationMs: number | null;
    transcriptChecked: boolean | null;
    websiteReferences: {
      moduleId: string;
      articleUrl: string;
    };
  }>;
};

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const { repoRoot: REPO_ROOT } = resolveRoots();
const SITE_OUTPUTS = [
  {
    previewDir: path.join(REPO_ROOT, 'site', 'public', 'data', 'phrase-previews'),
    audioDir: path.join(REPO_ROOT, 'site', 'public', 'data', 'phrase-audio'),
  },
  {
    previewDir: path.join(REPO_ROOT, 'site', 'data', 'phrase-previews'),
    audioDir: path.join(REPO_ROOT, 'site', 'data', 'phrase-audio'),
  },
];
const EXPORT_SCHEMA_VERSION = 3;
const AUDIO_SOURCE_DIR = path.join(REPO_ROOT, 'app', 'assets', 'audio');
const WEBSITE_AUDIO_BASE_PATH = '/data/phrase-audio';

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
  const exportedAt = new Date().toISOString();
  const variantConfigs = await loadVariantConfigs();
  const modules = variantConfigs.flatMap(({ pack, config }) =>
    config.modules.map((moduleConfig) => buildModule(pack, config, moduleConfig, exportedAt)),
  );
  const moduleIds = new Set<string>();

  for (const module of modules) {
    if (moduleIds.has(module.moduleId)) {
      throw new Error(`Duplicate website preview moduleId "${module.moduleId}" would overwrite export output.`);
    }
    moduleIds.add(module.moduleId);
  }

  const exportableAudio = new Map<string, string>();
  for (const module of modules) {
    for (const phrase of module.phrases) {
      if (phrase.audioStatus !== 'ready') {
        continue;
      }

      const sourcePath = path.join(AUDIO_SOURCE_DIR, `${phrase.audioReference.audioKey}.mp3`);
      await access(sourcePath);
      exportableAudio.set(phrase.audioReference.relativePath, sourcePath);
    }
  }

  for (const output of SITE_OUTPUTS) {
    await mkdir(output.previewDir, { recursive: true });
    await rm(output.audioDir, { recursive: true, force: true });
    await mkdir(output.audioDir, { recursive: true });
  }

  for (const output of SITE_OUTPUTS) {
    for (const module of modules) {
      await writeFile(path.join(output.previewDir, `${module.moduleId}.json`), `${JSON.stringify(module, null, 2)}\n`, 'utf8');
    }

    for (const [relativePath, sourcePath] of exportableAudio.entries()) {
      const destinationPath = path.join(output.audioDir, ...relativePath.split('/'));
      await mkdir(path.dirname(destinationPath), { recursive: true });
      await copyFile(sourcePath, destinationPath);
    }
  }

  const manifest = {
    schemaVersion: EXPORT_SCHEMA_VERSION,
    exportType: 'website-phrase-audio-manifest',
    generatedFor: 'website-safe-phrase-audio-export',
    exportedAt,
    moduleCount: modules.length,
    modules: modules.map((module) => ({
      exportedAt: module.exportedAt,
      moduleId: module.moduleId,
      moduleSlug: module.moduleSlug,
      path: `/data/phrase-previews/${module.moduleId}.json`,
      destinationSlug: module.destinationSlug,
      destinationName: module.destinationName,
      variant: module.variant,
      language: module.language,
      languageCode: module.languageCode,
      country: module.country,
      scenarioId: module.scenarioId,
      scenarioName: module.scenarioName,
      editorialStatus: module.editorialStatus,
      appStatus: module.appStatus,
      websiteAudioStatus: module.websiteAudioStatus,
      audioStatus: module.audioStatus,
      audioDelivery: module.audioDelivery,
      audioCoverage: module.audioCoverage,
      headline: module.headline,
      summary: module.summary,
      travelerStage: module.travelerStage,
      difficulty: module.difficulty,
      formality: module.formality,
      audioDurationMs: module.audioDurationMs,
      transcriptChecked: module.transcriptChecked,
      phraseCount: module.phraseCount,
      familyCount: module.familyCount,
      articleUrl: module.articleReference.secondaryUrl,
      trust: module.trust,
    })),
  };

  for (const output of SITE_OUTPUTS) {
    await writeFile(path.join(output.previewDir, 'manifest.json'), `${JSON.stringify(manifest, null, 2)}\n`, 'utf8');
  }

  console.log(`Exported ${modules.length} website phrase preview modules to:`);
  for (const output of SITE_OUTPUTS) {
    console.log(`- ${output.previewDir}`);
    console.log(`- ${output.audioDir}`);
  }
}

function buildModule(
  pack: AppPack,
  config: WebsitePreviewConfig,
  moduleConfig: WebsitePreviewModuleConfig,
  exportedAt: string,
): WebsitePhraseAudioExport {
  const scenario = pack.scenarioMap[moduleConfig.scenarioId];

  if (!scenario) {
    throw new Error(`Website preview module "${moduleConfig.moduleId}" references missing scenario "${moduleConfig.scenarioId}".`);
  }

  const phrases = moduleConfig.phraseIds.map((phraseId) => {
    const phrase = pack.phraseMap[phraseId];
    if (!phrase) {
      throw new Error(`Website preview module "${moduleConfig.moduleId}" references missing phrase "${phraseId}".`);
    }

    if (phrase.scenarioId !== moduleConfig.scenarioId) {
      throw new Error(
        `Website preview module "${moduleConfig.moduleId}" includes phrase "${phraseId}" outside scenario "${moduleConfig.scenarioId}".`,
      );
    }

    if (phrase.accessTier !== 'starter') {
      throw new Error(`Website preview module "${moduleConfig.moduleId}" must stay starter-only. "${phraseId}" is premium.`);
    }

    const family = pack.intentFamilyMap[phrase.intentFamilyId];
    if (!family) {
      throw new Error(`Website preview module "${moduleConfig.moduleId}" references missing family "${phrase.intentFamilyId}".`);
    }

    const relativeAudioPath = path.posix.join(config.destinationSlug, `${phrase.audioKey}.mp3`);
    const audioUrl = phrase.audioStatus === 'planned' ? null : `${WEBSITE_AUDIO_BASE_PATH}/${relativeAudioPath}`;

    return {
      phraseId: phrase.id,
      phraseSlug: phrase.id,
      id: phrase.id,
      moduleId: moduleConfig.moduleId,
      destinationSlug: config.destinationSlug,
      variant: pack.metadata.packId,
      language: pack.metadata.language,
      languageCode: pack.metadata.languageCode,
      country: pack.metadata.country,
      scenarioId: scenario.id,
      scenarioSlug: scenario.id,
      scenarioName: scenario.name,
      familyId: family.id,
      familySlug: family.id,
      familyTitle: family.title,
      familySummary: family.summary,
      accessTier: phrase.accessTier,
      variantRole: phrase.variantRole,
      variantLabel: phrase.variantLabel,
      englishText: phrase.sourceText,
      sourceText: phrase.sourceText,
      targetText: phrase.targetText,
      canonicalTargetText: phrase.canonicalTargetText ?? phrase.targetText,
      pronunciation: phrase.pronunciation,
      context: phrase.usageNote ?? phrase.context ?? '',
      youMayHear: phrase.youMayHear ?? undefined,
      warningNoteType: phrase.warningNoteType ?? undefined,
      audioStatus: phrase.audioStatus,
      audioDelivery: moduleConfig.audioDelivery,
      audioUrl,
      audioReference: {
        provider: 'speaklocal-site' as const,
        delivery: moduleConfig.audioDelivery,
        audioKey: phrase.audioKey,
        filename: `${phrase.audioKey}.mp3`,
        relativePath: relativeAudioPath,
        url: audioUrl,
      },
      audioDurationMs: null,
      transcriptChecked: null,
      websiteReferences: {
        moduleId: moduleConfig.moduleId,
        articleUrl: moduleConfig.cta.secondaryUrl,
      },
    };
  });

  const readyPhraseCount = phrases.filter((phrase) => phrase.audioStatus === 'ready').length;
  const plannedPhraseCount = phrases.length - readyPhraseCount;
  const familyCount = new Set(phrases.map((phrase) => phrase.familyId)).size;
  const resolvedAudioStatus = resolveAudioCoverageStatus(readyPhraseCount, phrases.length);

  if (moduleConfig.audioStatus !== resolvedAudioStatus) {
    throw new Error(
      `Website preview module "${moduleConfig.moduleId}" declares audioStatus "${moduleConfig.audioStatus}" but exports as "${resolvedAudioStatus}".`,
    );
  }

  const trust = resolveTrustMetadata(config.trustDefaults, moduleConfig.trustOverrides);

  return {
    schemaVersion: EXPORT_SCHEMA_VERSION,
    exportType: 'website-phrase-audio-module',
    exportedAt,
    moduleId: moduleConfig.moduleId,
    moduleSlug: moduleConfig.moduleId,
    destinationSlug: config.destinationSlug,
    destinationName: config.destinationName,
    variant: pack.metadata.packId,
    language: pack.metadata.language,
    languageCode: pack.metadata.languageCode,
    country: pack.metadata.country,
    scenarioId: scenario.id,
    scenarioSlug: scenario.id,
    scenarioName: scenario.name,
    editorialStatus: moduleConfig.editorialStatus,
    appStatus: moduleConfig.appStatus,
    websiteAudioStatus: resolvedAudioStatus,
    audioStatus: resolvedAudioStatus,
    audioDelivery: moduleConfig.audioDelivery,
    audioCoverage: {
      status: resolvedAudioStatus,
      readyPhraseCount,
      plannedPhraseCount,
      totalPhraseCount: phrases.length,
    },
    headline: moduleConfig.headline,
    summary: moduleConfig.summary,
    travelerStage: normalizeOptionalText(moduleConfig.travelerStage),
    difficulty: normalizeOptionalText(moduleConfig.difficulty),
    formality: normalizeOptionalText(moduleConfig.formality),
    audioDurationMs: Number.isFinite(moduleConfig.audioDurationMs) ? Number(moduleConfig.audioDurationMs) : null,
    transcriptChecked: typeof moduleConfig.transcriptChecked === 'boolean' ? moduleConfig.transcriptChecked : null,
    phraseCount: phrases.length,
    familyCount,
    articleReference: moduleConfig.cta,
    trust,
    cta: moduleConfig.cta,
    phrases,
  };
}

function normalizeOptionalText(value?: string) {
  const normalized = value?.trim();
  return normalized ? normalized : null;
}

function resolveAudioCoverageStatus(readyPhraseCount: number, totalPhraseCount: number): AudioCoverageStatus {
  if (readyPhraseCount <= 0) {
    return 'planned';
  }

  if (readyPhraseCount >= totalPhraseCount) {
    return 'ready';
  }

  return 'mixed';
}

function resolveTrustMetadata(
  defaults?: WebsitePreviewTrustMetadata,
  overrides?: WebsitePreviewTrustMetadata,
) {
  return {
    sourceLabel: normalizeOptionalText(overrides?.sourceLabel ?? defaults?.sourceLabel),
    sourceNote: normalizeOptionalText(overrides?.sourceNote ?? defaults?.sourceNote),
    appBoundary: normalizeOptionalText(overrides?.appBoundary ?? defaults?.appBoundary),
    methodologyLabel: normalizeOptionalText(overrides?.methodologyLabel ?? defaults?.methodologyLabel),
    methodologyUrl: normalizeOptionalText(overrides?.methodologyUrl ?? defaults?.methodologyUrl),
    correctionsLabel: normalizeOptionalText(overrides?.correctionsLabel ?? defaults?.correctionsLabel),
    correctionsUrl: normalizeOptionalText(overrides?.correctionsUrl ?? defaults?.correctionsUrl),
  };
}

async function loadVariantConfigs() {
  const candidates: Array<{ pack: AppPack; configPath: string }> = [
    {
      pack: vietPack,
      configPath: path.join(REPO_ROOT, 'content-draft', 'viet', 'website-preview.json'),
    },
    {
      pack: tagalogPack,
      configPath: path.join(REPO_ROOT, 'content-draft', 'tagalog', 'website-preview.json'),
    },
  ];

  const resolved: Array<{ pack: AppPack; config: WebsitePreviewConfig }> = [];

  for (const candidate of candidates) {
    try {
      await access(candidate.configPath);
    } catch {
      continue;
    }

    const config = JSON.parse(await readFile(candidate.configPath, 'utf8')) as WebsitePreviewConfig;
    resolved.push({
      pack: candidate.pack,
      config,
    });
  }

  if (!resolved.length) {
    throw new Error('No website preview configs were found in content-draft.');
  }

  return resolved;
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
