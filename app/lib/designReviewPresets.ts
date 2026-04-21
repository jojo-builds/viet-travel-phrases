import { currentApp } from '../family/currentApp';
import { AppPhrase, AppScenario } from '../family/contracts';
import { searchPhrases } from './searchPhrases';

export type DesignReviewPreset = {
  id: string;
  label: string;
  description: string;
  targetPath: string;
  premiumUnlocked?: boolean;
  homeQuery?: string;
  savedPhraseIds?: string[];
  visitedScenarioIds?: string[];
};

function joinRoute(pathname: string, query: Record<string, string>) {
  const params = new URLSearchParams(query);
  const queryString = params.toString();
  if (!queryString) {
    return pathname;
  }

  return `${pathname}${pathname.includes('?') ? '&' : '?'}${queryString}`;
}

function pickScenario(matchers: string[]) {
  const loweredMatchers = matchers.map((matcher) => matcher.toLowerCase());

  return (
    currentApp.scenarios.find((scenario) => {
      const haystack = `${scenario.id} ${scenario.name}`.toLowerCase();
      return loweredMatchers.some((matcher) => haystack.includes(matcher));
    }) ?? currentApp.scenarios[0]
  );
}

function pickScenarioWithPremiumFamilies() {
  return (
    currentApp.scenarios.find((scenario) => scenario.intentFamilies.some((family) => family.accessTier === 'premium')) ??
    pickScenario(['transport', 'airport', 'arrival'])
  );
}

function pickStarterPhrases(count: number) {
  return currentApp.pack.phrases.filter((phrase) => phrase.accessTier === 'starter').slice(0, count);
}

function pickPremiumPhrases(count: number) {
  return currentApp.pack.phrases.filter((phrase) => phrase.accessTier === 'premium').slice(0, count);
}

function pickSearchQuery() {
  const candidates = ['pharmacy', 'airport', 'taxi', 'not spicy', 'thank you', 'help'];

  for (const candidate of candidates) {
    if (searchPhrases(currentApp.pack, candidate, false).length > 0) {
      return candidate;
    }
  }

  const fallbackPhrase = currentApp.quickPhrases[0] ?? pickStarterPhrases(1)[0];
  if (fallbackPhrase?.sourceText) {
    return fallbackPhrase.sourceText.split(/\s+/)[0]?.toLowerCase() || 'hello';
  }

  return 'hello';
}

function phraseIds(phrases: AppPhrase[]) {
  return phrases.map((phrase) => phrase.id);
}

function scenarioIds(scenarios: AppScenario[]) {
  return scenarios.map((scenario) => scenario.id);
}

const featuredVisitedScenarioIds = scenarioIds(currentApp.scenarios.slice(0, 2));
const searchResultsQuery = pickSearchQuery();
const searchEmptyQuery = 'zzzzz';
const starterSavedPhraseIds = phraseIds(pickStarterPhrases(3));
const mixedSavedPhraseIds = phraseIds([...pickStarterPhrases(2), ...pickPremiumPhrases(2)]);
const premiumScenario = pickScenarioWithPremiumFamilies();

export const designReviewPresets: DesignReviewPreset[] = [
  {
    id: 'home-browse',
    label: 'Home browse',
    description: 'Real home route with the browse state intact.',
    targetPath: '/',
    visitedScenarioIds: featuredVisitedScenarioIds,
  },
  {
    id: 'home-search-results',
    label: 'Home search results',
    description: 'Real home route with a live search query already active.',
    targetPath: '/',
    homeQuery: searchResultsQuery,
    visitedScenarioIds: featuredVisitedScenarioIds,
  },
  {
    id: 'home-search-empty',
    label: 'Home search empty',
    description: 'Real home route with an empty-state query so we can inspect no-results copy.',
    targetPath: '/',
    homeQuery: searchEmptyQuery,
  },
  {
    id: 'saved-empty',
    label: 'Saved empty',
    description: 'Saved route with no saved phrases.',
    targetPath: '/saved',
    savedPhraseIds: [],
  },
  {
    id: 'saved-filled',
    label: 'Saved filled',
    description: 'Saved route with a mixed starter and premium sample set.',
    targetPath: '/saved',
    premiumUnlocked: true,
    savedPhraseIds: mixedSavedPhraseIds,
  },
  {
    id: 'premium-locked',
    label: 'Premium locked',
    description: 'Premium route in the locked state.',
    targetPath: '/premium',
    premiumUnlocked: false,
  },
  {
    id: 'premium-unlocked',
    label: 'Premium unlocked',
    description: 'Premium route in the unlocked state.',
    targetPath: '/premium',
    premiumUnlocked: true,
  },
  {
    id: 'scenario-locked',
    label: 'Scenario locked',
    description: 'A live scenario route showing the locked premium preview card.',
    targetPath: `/scenario/${premiumScenario.id}`,
    premiumUnlocked: false,
  },
  {
    id: 'scenario-unlocked',
    label: 'Scenario unlocked',
    description: 'The same live scenario route after premium unlock.',
    targetPath: `/scenario/${premiumScenario.id}`,
    premiumUnlocked: true,
  },
  {
    id: 'settings-locked',
    label: 'Settings locked',
    description: 'Settings route with premium still locked.',
    targetPath: '/settings',
    premiumUnlocked: false,
  },
  {
    id: 'settings-unlocked',
    label: 'Settings unlocked',
    description: 'Settings route with premium unlocked.',
    targetPath: '/settings',
    premiumUnlocked: true,
  },
  {
    id: 'saved-starter',
    label: 'Saved starter-only',
    description: 'Saved route with only starter-tier phrases visible.',
    targetPath: '/saved',
    premiumUnlocked: false,
    savedPhraseIds: starterSavedPhraseIds,
  },
];

export function getDesignReviewPreset(presetId?: string) {
  if (!presetId) {
    return null;
  }

  return designReviewPresets.find((preset) => preset.id === presetId) ?? null;
}

export function buildDesignReviewTargetPath(presetId: string) {
  const preset = getDesignReviewPreset(presetId);
  if (!preset) {
    return null;
  }

  return joinRoute(preset.targetPath, { designPreset: preset.id });
}
