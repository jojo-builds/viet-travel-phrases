const { getAppDefinition, resolveAppVariantFromEnv } = require('./family/appRegistry');

const SHARED_EXPO_CONFIG = {
  version: '1.0.0',
  orientation: 'portrait',
  icon: './assets/images/icon.png',
  userInterfaceStyle: 'light',
  newArchEnabled: true,
  splash: {
    image: './assets/splash-icon.png',
    resizeMode: 'contain',
    backgroundColor: '#FAFAF8',
  },
  ios: {
    supportsTablet: false,
    buildNumber: '2',
    infoPlist: {
      UIStatusBarStyle: 'UIStatusBarStyleDarkContent',
      ITSAppUsesNonExemptEncryption: false,
    },
  },
  android: {
    adaptiveIcon: {
      foregroundImage: './assets/images/adaptive-icon.png',
      backgroundColor: '#FAFAF8',
    },
    edgeToEdgeEnabled: true,
    predictiveBackGestureEnabled: false,
  },
  web: {
    favicon: './assets/favicon.png',
  },
  plugins: ['expo-router', 'expo-font', 'expo-iap'],
  owner: 'jayopsai',
};

module.exports = () => {
  const activeVariant = resolveAppVariantFromEnv(process.env);
  const definition = getAppDefinition(activeVariant);

  return {
    expo: {
      ...SHARED_EXPO_CONFIG,
      name: definition.build.name,
      slug: definition.build.slug,
      scheme: definition.build.scheme,
      ios: {
        ...SHARED_EXPO_CONFIG.ios,
        bundleIdentifier: definition.build.bundleIdentifier,
      },
      android: {
        ...SHARED_EXPO_CONFIG.android,
        package: definition.build.packageName,
      },
      extra: {
        appVariant: definition.build.appVariant,
        privacyPolicyUrl: definition.build.privacyPolicyUrl,
        termsOfUseUrl: definition.build.termsOfUseUrl,
        router: {},
        ...(definition.build.easProjectId
          ? {
              eas: {
                projectId: definition.build.easProjectId,
              },
            }
          : {}),
      },
    },
  };
};
