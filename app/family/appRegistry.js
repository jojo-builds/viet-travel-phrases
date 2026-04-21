const DEFAULT_APP_VARIANT = 'viet';

const appRegistry = {
  viet: {
    variant: 'viet',
    build: {
      appVariant: 'viet',
      name: 'SpeakLocal Vietnam',
      slug: 'viet-travel-phrases',
      scheme: 'viet-travel-phrases',
      bundleIdentifier: 'com.jojobuilds.viettravelphrases',
      packageName: 'com.jojobuilds.viettravelphrases',
      easProjectId: 'a87550d4-1656-4ad3-aa90-d76272f8bb90',
      premiumProductId: 'com.jojobuilds.viettravelphrases.premiumunlock',
      submitProfile: 'production',
      privacyPolicyUrl: 'https://speaklocal.app/privacy',
      termsOfUseUrl: 'https://speaklocal.app/terms',
    },
    runtime: {
      packModule: './packs/viet',
      packExport: 'vietPack',
      presentationModule: './presentation/viet',
      presentationExport: 'vietPresentation',
      audioModule: './audio/vietAudio',
      audioExport: 'vietAudioProvider',
      storageModule: './storage/vietStorage',
      storageExport: 'vietStorage',
    },
  },
  tagalog: {
    variant: 'tagalog',
    build: {
      appVariant: 'tagalog',
      name: 'SpeakLocal Philippines',
      slug: 'tagalog-travel-phrases',
      scheme: 'tagalog-travel-phrases',
      bundleIdentifier: 'com.jojobuilds.tagalogtravelphrases',
      packageName: 'com.jojobuilds.tagalogtravelphrases',
      easProjectId: '60fc3a74-5486-4505-b33e-65f95fa52f29',
      premiumProductId: 'com.jojobuilds.tagalogtravelphrases.premiumunlock',
      privacyPolicyUrl: 'https://speaklocal.app/privacy',
      termsOfUseUrl: 'https://speaklocal.app/terms',
    },
    runtime: {
      packModule: './packs/tagalog',
      packExport: 'tagalogPack',
      presentationModule: './presentation/tagalog',
      presentationExport: 'tagalogPresentation',
      audioModule: './audio/tagalogAudio',
      audioExport: 'tagalogAudioProvider',
      storageModule: './storage/tagalogStorage',
      storageExport: 'tagalogStorage',
    },
  },
};

const supportedAppVariants = Object.keys(appRegistry);

function assertSupportedVariant(rawVariant, sourceLabel) {
  if (supportedAppVariants.includes(rawVariant)) {
    return rawVariant;
  }

  throw new Error(
    `Unsupported app variant "${rawVariant}" from ${sourceLabel}. Expected one of: ${supportedAppVariants.join(', ')}.`,
  );
}

function resolveAppVariantFromEnv(env = process.env) {
  const rawVariant = env.EXPO_PUBLIC_APP_VARIANT ?? env.APP_VARIANT;

  if (!rawVariant) {
    return DEFAULT_APP_VARIANT;
  }

  return assertSupportedVariant(rawVariant, 'environment');
}

function findAppVariantByEasProjectId(easProjectId) {
  if (!easProjectId) {
    return undefined;
  }

  for (const variant of supportedAppVariants) {
    const definition = appRegistry[variant];
    if (definition.build.easProjectId === easProjectId) {
      return variant;
    }
  }

  return undefined;
}

function resolveAppVariantFromBuildContext({
  env = process.env,
  expoExtra = undefined,
  easProjectId = undefined,
  allowDefault = true,
} = {}) {
  const rawEnvVariant = env.EXPO_PUBLIC_APP_VARIANT ?? env.APP_VARIANT;
  if (rawEnvVariant) {
    return assertSupportedVariant(rawEnvVariant, 'environment');
  }

  const rawExpoVariant = expoExtra?.appVariant;
  if (rawExpoVariant) {
    return assertSupportedVariant(rawExpoVariant, 'Expo config extra');
  }

  const resolvedEasProjectId = easProjectId ?? expoExtra?.eas?.projectId;
  const easProjectVariant = findAppVariantByEasProjectId(resolvedEasProjectId);
  if (easProjectVariant) {
    return easProjectVariant;
  }

  if (resolvedEasProjectId) {
    throw new Error(
      `Unable to match EAS project ID "${resolvedEasProjectId}" to a supported app variant.`,
    );
  }

  if (allowDefault) {
    return DEFAULT_APP_VARIANT;
  }

  throw new Error(
    'Unable to resolve the active app variant from environment, Expo config, or EAS project identity.',
  );
}

function getAppDefinition(variant) {
  const definition = appRegistry[variant];

  if (!definition) {
    throw new Error(`Missing app definition for variant "${variant}".`);
  }

  if (definition.variant !== variant || definition.build.appVariant !== variant) {
    throw new Error(`App registry entry "${variant}" is internally inconsistent.`);
  }

  return definition;
}

module.exports = {
  DEFAULT_APP_VARIANT,
  appRegistry,
  supportedAppVariants,
  resolveAppVariantFromEnv,
  findAppVariantByEasProjectId,
  resolveAppVariantFromBuildContext,
  getAppDefinition,
};
