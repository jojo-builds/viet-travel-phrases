export type AppPhraseVariantRole = 'say-first' | 'more-polite' | 'clearer' | 'also-common';

export type AppPhraseWarningNoteType = 'formal' | 'bookish' | 'harder-to-say' | 'recognition-only';

export type AppPhraseAudioStatus = 'ready' | 'planned';

export type AppPhrase = {
  id: string;
  scenarioId: string;
  targetText: string;
  canonicalTargetText: string;
  pronunciation: string;
  sourceText: string;
  audioKey: string;
  accessTier: 'starter' | 'premium';
  context: string;
  usageNote: string;
  youMayHear?: string;
  searchAliases?: string[];
  intentFamilyId: string;
  variantRole: AppPhraseVariantRole;
  variantLabel: string;
  warningNoteType?: AppPhraseWarningNoteType;
  audioStatus: AppPhraseAudioStatus;
  emoji: string;
};

export type AppIntentFamily = {
  id: string;
  scenarioId: string;
  title: string;
  summary?: string;
  relatedFamilyId?: string;
  accessTier: 'starter' | 'premium';
  primaryPhraseId: string;
  phraseIds: string[];
};

export type AppScenario = {
  id: string;
  name: string;
  emoji: string;
  description: string;
  tip: string;
  intentFamilies: AppIntentFamily[];
  phrases: AppPhrase[];
};

export type AppPackMetadata = {
  appId: string;
  packId: string;
  displayName: string;
  country: string;
  language: string;
  languageCode: string;
  schemaVersion: number;
};

export type AppVariant = 'viet' | 'tagalog';

export type AppPack = {
  metadata: AppPackMetadata;
  scenarios: AppScenario[];
  intentFamilies: AppIntentFamily[];
  phrases: AppPhrase[];
  scenarioMap: Record<string, AppScenario>;
  intentFamilyMap: Record<string, AppIntentFamily>;
  phraseMap: Record<string, AppPhrase>;
};

export type AppPremiumCategory = {
  id: string;
  title: string;
  emoji: string;
  description: string;
  scenarioId?: string;
  access: 'starter' | 'premium-only';
  availability: 'live' | 'planned';
  starterPhraseTarget: number;
  totalPhraseTarget: number;
  highlights: string[];
};

export type AppPremiumConfig = {
  priceLabel: string;
  unlockModelLabel: string;
  freePhraseTarget: number;
  totalPhraseTarget: number;
  categoryTarget: number;
  teaserBadge: string;
  teaserTitle: string;
  teaserBody: string;
  teaserButtonLabel: string;
  statusLockedLabel: string;
  statusUnlockedLabel: string;
  screenTitle: string;
  screenBody: string;
  unlockButtonLabel: string;
  restoreButtonLabel: string;
  storeUnavailableTitle: string;
  storePlaceholderBody: string;
  restoredAlertTitle: string;
  restoredAlertBody: string;
  previewEnableLabel: string;
  previewDisableLabel: string;
  benefits: string[];
  categories: AppPremiumCategory[];
  featuredCategoryIds: string[];
  liveSectionTitle: string;
  liveSectionBody: string;
  plannedSectionTitle: string;
  plannedSectionBody: string;
  scenarioPreviewTitle: string;
  scenarioPreviewBody: string;
  includedBadgeLabel: string;
  premiumOnlyBadgeLabel: string;
  liveNowBadgeLabel: string;
  plannedBadgeLabel: string;
  liveNowStatLabel: string;
  starterStatLabel: string;
  fullLibraryStatLabel: string;
  manageTitle: string;
  manageBody: string;
};

export type PresentationSection = {
  title: string;
  body: string;
};

export type FeatureCapabilities = {
  audio: boolean;
  favorites: boolean;
  pronunciation: boolean;
  search: boolean;
  flashcards: boolean;
  recents: boolean;
};

export type AppPresentationConfig = {
  labels: {
    targetText: string;
    pronunciation: string;
    sourceText: string;
  };
  tabs: {
    learnTitle: string;
    savedTitle: string;
  };
  home: {
    greeting: string;
    subtitle: string;
    heroTitle: string;
    heroBody: string;
    settingsLabel: string;
    quickPhrasesTitle: string;
    quickPhrasesSubtitle: string;
    scenariosTitle: string;
    scenariosSubtitle: string;
    libraryTitle: string;
    librarySubtitle: string;
    quickPhraseIds: string[];
    scenarioOrder: string[];
  };
  search: {
    placeholder: string;
    resultsTitle: string;
    emptyTitle: string;
    emptyBody: string;
    clearLabel: string;
  };
  saved: {
    title: string;
    emptyIcon: string;
    emptyTitle: string;
    emptyBody: string;
    scenarioPrefix: string;
  };
  scenario: {
    notFoundTitle: string;
    notFoundBody: string;
    tipFallback: string;
    tipIcon: string;
  };
  phrase: {
    audioUnavailableLabel: string;
  };
  premium: AppPremiumConfig;
  settings: {
    title: string;
    audioSpeedTitle: string;
    audioSpeedBody: string;
    audioSpeedOptions: {
      halfSpeedLabel: string;
      halfSpeedBody: string;
      threeQuarterSpeedLabel: string;
      threeQuarterSpeedBody: string;
      normalLabel: string;
      normalBody: string;
    };
    sectionTitles: {
      about: string;
      legal: string;
      feedback: string;
    };
    rowLabels: {
      aboutApp: string;
      privacy: string;
      terms: string;
      sendFeedback: string;
      rateApp: string;
    };
    aboutAlertTitle: string;
    aboutAlertBody: string;
    rateComingSoonTitle: string;
    rateComingSoonBody: string;
    footer: string;
    chevron: string;
  };
  privacy: {
    title: string;
    effectiveDate: string;
    backLabel: string;
    sections: PresentationSection[];
  };
  terms: {
    title: string;
    effectiveDate: string;
    backLabel: string;
    sections: PresentationSection[];
  };
  feedback: {
    title: string;
    formEndpoint: string;
    subject: string;
    errorTitle: string;
    errorBody: string;
    successIcon: string;
    successTitle: string;
    successBody: string;
    placeholder: string;
    sendLabel: string;
    sendingLabel: string;
    closeIcon: string;
  };
  capabilities: FeatureCapabilities;
};

export type AudioProvider = {
  resolveAudioSource: (audioKey: string) => number | undefined;
  hasAudio: (audioKey: string) => boolean;
};

export type SavedPhraseMeta = {
  id: string;
  savedAt: number;
};

export type PhrasebookStorage = {
  getFavoriteIds: () => Promise<string[]>;
  getSavedPhraseMeta: () => Promise<SavedPhraseMeta[]>;
  isFavorite: (id: string) => Promise<boolean>;
  setFavorite: (id: string, next: boolean) => Promise<boolean>;
  toggleFavoriteId: (id: string) => Promise<string[]>;
  getVisitedScenarioMap: (scenarioIds: string[]) => Promise<Record<string, boolean>>;
  markScenarioVisited: (scenarioId: string) => Promise<void>;
};

export type AppRuntimeBindings = {
  pack: AppPack;
  presentation: AppPresentationConfig;
  audio: AudioProvider;
  storage: PhrasebookStorage;
};

export type AppBuildDefinition = {
  appVariant: AppVariant;
  name: string;
  slug: string;
  scheme: string;
  bundleIdentifier: string;
  packageName: string;
  easProjectId?: string;
  premiumProductId?: string;
  privacyPolicyUrl: string;
  termsOfUseUrl: string;
};

export type AppDefinition = {
  variant: AppVariant;
  build: AppBuildDefinition;
  runtime: {
    packModule: string;
    packExport: string;
    presentationModule: string;
    presentationExport: string;
    audioModule: string;
    audioExport: string;
    storageModule: string;
    storageExport: string;
  };
};

export type CurrentApp = {
  variant: AppVariant;
  build: AppBuildDefinition;
  pack: AppPack;
  presentation: AppPresentationConfig;
  audio: AudioProvider;
  storage: PhrasebookStorage;
  scenarios: AppScenario[];
  quickPhrases: AppPhrase[];
};
