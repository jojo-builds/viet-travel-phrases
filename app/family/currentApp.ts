import Constants from 'expo-constants';
import { AppRuntimeBindings, CurrentApp } from './contracts';
import { getAppDefinition, resolveAppVariantFromBuildContext, supportedAppVariants } from './appRegistry';

declare function require(moduleName: string): unknown;

const SUPPORTED_SCHEMA_VERSION = 2;
const runtimeModuleLoaders: Record<string, () => Record<string, unknown>> = {
  './audio/vietAudio': () => require('./audio/vietAudio') as Record<string, unknown>,
  './audio/tagalogAudio': () => require('./audio/tagalogAudio') as Record<string, unknown>,
  './packs/viet': () => require('./packs/viet') as Record<string, unknown>,
  './packs/tagalog': () => require('./packs/tagalog') as Record<string, unknown>,
  './presentation/viet': () => require('./presentation/viet') as Record<string, unknown>,
  './presentation/tagalog': () => require('./presentation/tagalog') as Record<string, unknown>,
  './storage/vietStorage': () => require('./storage/vietStorage') as Record<string, unknown>,
  './storage/tagalogStorage': () => require('./storage/tagalogStorage') as Record<string, unknown>,
};

function loadNamedExport<T>(modulePath: string, exportName: string): T {
  const moduleLoader = runtimeModuleLoaders[modulePath];

  if (!moduleLoader) {
    throw new Error(`App registry runtime module "${modulePath}" does not have a registered loader.`);
  }

  const loadedModule = moduleLoader();
  const resolvedExport = loadedModule[exportName];

  if (!resolvedExport) {
    throw new Error(`App registry runtime module "${modulePath}" is missing export "${exportName}".`);
  }

  return resolvedExport as T;
}

function getRuntimeBindingsForVariant(variant: CurrentApp['variant']): AppRuntimeBindings {
  const definition = getAppDefinition(variant);

  return {
    pack: loadNamedExport(definition.runtime.packModule, definition.runtime.packExport),
    presentation: loadNamedExport(definition.runtime.presentationModule, definition.runtime.presentationExport),
    audio: loadNamedExport(definition.runtime.audioModule, definition.runtime.audioExport),
    storage: loadNamedExport(definition.runtime.storageModule, definition.runtime.storageExport),
  };
}

function validateRuntimeRegistryBridge() {
  for (const variant of supportedAppVariants) {
    const definition = getAppDefinition(variant);
    const runtimeModules = [
      definition.runtime.packModule,
      definition.runtime.presentationModule,
      definition.runtime.audioModule,
      definition.runtime.storageModule,
    ];

    for (const modulePath of runtimeModules) {
      if (!runtimeModuleLoaders[modulePath]) {
        throw new Error(`App registry variant "${variant}" references unmapped runtime module "${modulePath}".`);
      }
    }
  }
}

function resolveScenarioOrder(app: AppRuntimeBindings, ids: string[]) {
  return ids.map((id) => {
    const scenario = app.pack.scenarioMap[id];
    if (!scenario) {
      throw new Error(`Missing scenario "${id}" in current app scenarioOrder.`);
    }
    return scenario;
  });
}

function resolveQuickPhrases(app: AppRuntimeBindings, ids: string[]) {
  return ids.map((id) => {
    const phrase = app.pack.phraseMap[id];
    if (!phrase) {
      throw new Error(`Missing phrase "${id}" in current app quickPhraseIds.`);
    }
    return phrase;
  });
}

function validateCurrentApp(app: AppRuntimeBindings) {
  if (app.pack.metadata.schemaVersion !== SUPPORTED_SCHEMA_VERSION) {
    throw new Error(
      `Unsupported pack schema version ${app.pack.metadata.schemaVersion}. Expected ${SUPPORTED_SCHEMA_VERSION}.`,
    );
  }

  if (new Set(app.pack.scenarios.map((scenario) => scenario.id)).size !== app.pack.scenarios.length) {
    throw new Error('Duplicate scenario IDs detected in the current pack.');
  }

  if (new Set(app.pack.phrases.map((phrase) => phrase.id)).size !== app.pack.phrases.length) {
    throw new Error('Duplicate phrase IDs detected in the current pack.');
  }

  if (new Set(app.pack.intentFamilies.map((family) => family.id)).size !== app.pack.intentFamilies.length) {
    throw new Error('Duplicate intent family IDs detected in the current pack.');
  }

  const flattenedScenarioPhraseIds = app.pack.scenarios.flatMap((scenario) =>
    scenario.phrases.map((phrase) => phrase.id),
  );

  if (new Set(app.presentation.home.scenarioOrder).size !== app.presentation.home.scenarioOrder.length) {
    throw new Error('Duplicate scenario IDs detected in the current presentation scenarioOrder.');
  }

  if (new Set(app.presentation.home.quickPhraseIds).size !== app.presentation.home.quickPhraseIds.length) {
    throw new Error('Duplicate quick phrase IDs detected in the current presentation config.');
  }

  if (flattenedScenarioPhraseIds.length !== app.pack.phrases.length) {
    throw new Error('Pack phrase list length does not match the flattened scenario phrase list length.');
  }

  for (const scenario of app.pack.scenarios) {
    if (!scenario.name.trim() || !scenario.emoji.trim() || !scenario.description.trim() || !scenario.tip.trim()) {
      throw new Error(`Scenario "${scenario.id}" is missing required user-facing content.`);
    }
  }

  for (const phrase of app.pack.phrases) {
    if (!app.pack.scenarioMap[phrase.scenarioId]) {
      throw new Error(`Phrase "${phrase.id}" references missing scenario "${phrase.scenarioId}".`);
    }

    if (!phrase.targetText.trim() || !phrase.sourceText.trim() || !phrase.audioKey.trim()) {
      throw new Error(`Phrase "${phrase.id}" is missing required phrase content.`);
    }

    if (app.presentation.capabilities.pronunciation && !phrase.pronunciation?.trim()) {
      throw new Error(`Phrase "${phrase.id}" is missing pronunciation text.`);
    }

    if (app.pack.phraseMap[phrase.id] !== phrase) {
      throw new Error(`Phrase map entry for "${phrase.id}" does not match the pack phrase list.`);
    }
  }

  for (const family of app.pack.intentFamilies) {
    if (!family.title.trim()) {
      throw new Error(`Intent family "${family.id}" is missing required user-facing content.`);
    }

    const primaryPhrase = app.pack.phraseMap[family.primaryPhraseId];
    if (!primaryPhrase) {
      throw new Error(`Intent family "${family.id}" references missing primary phrase "${family.primaryPhraseId}".`);
    }

    if (primaryPhrase.variantRole !== 'say-first') {
      throw new Error(`Intent family "${family.id}" primary phrase "${family.primaryPhraseId}" must be "say-first".`);
    }

    if (primaryPhrase.scenarioId !== family.scenarioId) {
      throw new Error(`Intent family "${family.id}" primary phrase scenario mismatch.`);
    }

    if (primaryPhrase.accessTier !== family.accessTier) {
      throw new Error(`Intent family "${family.id}" access tier must match its primary phrase.`);
    }

    for (const phraseId of family.phraseIds) {
      const phrase = app.pack.phraseMap[phraseId];
      if (!phrase) {
        throw new Error(`Intent family "${family.id}" references missing phrase "${phraseId}".`);
      }

      if (phrase.intentFamilyId !== family.id) {
        throw new Error(`Phrase "${phrase.id}" does not link back to intent family "${family.id}".`);
      }

      if (phrase.scenarioId !== family.scenarioId) {
        throw new Error(`Intent family "${family.id}" includes phrase "${phrase.id}" from a different scenario.`);
      }
    }
  }

  for (const quickPhraseId of app.presentation.home.quickPhraseIds) {
    const quickPhrase = app.pack.phraseMap[quickPhraseId];
    if (quickPhrase.accessTier !== 'starter') {
      throw new Error(`Quick phrase "${quickPhraseId}" must stay on starter-tier content.`);
    }
  }

  const premiumCategoryIds = new Set<string>();
  for (const category of app.presentation.premium.categories) {
    if (premiumCategoryIds.has(category.id)) {
      throw new Error(`Duplicate premium category ID "${category.id}" detected in presentation config.`);
    }

    premiumCategoryIds.add(category.id);

    if (
      !category.title.trim() ||
      !category.description.trim() ||
      !category.emoji.trim() ||
      !category.highlights.length
    ) {
      throw new Error(`Premium category "${category.id}" is missing required user-facing content.`);
    }

    if (category.scenarioId && !app.pack.scenarioMap[category.scenarioId]) {
      throw new Error(`Premium category "${category.id}" references missing scenario "${category.scenarioId}".`);
    }
  }

  for (const featuredCategoryId of app.presentation.premium.featuredCategoryIds) {
    if (!premiumCategoryIds.has(featuredCategoryId)) {
      throw new Error(`Featured premium category "${featuredCategoryId}" is missing from the category list.`);
    }
  }

  for (const scenario of app.pack.scenarios) {
    for (const phrase of scenario.phrases) {
      if (phrase.scenarioId !== scenario.id) {
        throw new Error(`Scenario "${scenario.id}" contains phrase "${phrase.id}" with mismatched scenarioId.`);
      }

      if (app.pack.phraseMap[phrase.id] !== phrase) {
        throw new Error(`Scenario "${scenario.id}" contains phrase "${phrase.id}" that is missing from phraseMap.`);
      }
    }

    for (const family of scenario.intentFamilies) {
      if (family.scenarioId !== scenario.id) {
        throw new Error(`Scenario "${scenario.id}" contains intent family "${family.id}" with mismatched scenarioId.`);
      }

      if (app.pack.intentFamilyMap[family.id] !== family) {
        throw new Error(`Scenario "${scenario.id}" intent family "${family.id}" is missing from intentFamilyMap.`);
      }
    }
  }

  if (app.presentation.capabilities.audio) {
    for (const phrase of app.pack.phrases) {
      if (phrase.audioStatus === 'planned') {
        continue;
      }

      if (!app.audio.hasAudio(phrase.audioKey)) {
        throw new Error(`Missing audio asset for phrase "${phrase.id}" using audioKey "${phrase.audioKey}".`);
      }
    }
  }
}

function resolveRuntimeAppVariant(): CurrentApp['variant'] {
  const expoExtra = Constants.expoConfig?.extra as
    | {
        appVariant?: string;
        eas?: {
          projectId?: string;
        };
      }
    | undefined;
  const easProjectId = Constants.easConfig?.projectId ?? expoExtra?.eas?.projectId;

  return resolveAppVariantFromBuildContext({
    env: __DEV__ ? process.env : {},
    expoExtra,
    easProjectId,
    allowDefault: __DEV__,
  });
}

validateRuntimeRegistryBridge();

const activeVariant = resolveRuntimeAppVariant();
const activeAppDefinition = getAppDefinition(activeVariant);
const activeDefinition = getRuntimeBindingsForVariant(activeVariant);

validateCurrentApp(activeDefinition);

export const currentApp: CurrentApp = {
  variant: activeVariant,
  build: activeAppDefinition.build,
  ...activeDefinition,
  scenarios: resolveScenarioOrder(activeDefinition, activeDefinition.presentation.home.scenarioOrder),
  quickPhrases: resolveQuickPhrases(activeDefinition, activeDefinition.presentation.home.quickPhraseIds),
};
