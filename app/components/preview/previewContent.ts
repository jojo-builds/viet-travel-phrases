import { currentApp } from '../../family/currentApp';
import {
  getAccessibleVisibleEntryCountForPack,
  getAccessibleVisibleEntryCountForScenario,
} from '../../lib/contentAccess';

export type AppPreviewSlideId = 'home' | 'phrase' | 'search' | 'saved' | 'premium';

export const appPreviewSlides: {
  id: AppPreviewSlideId;
  label: string;
  title: string;
  body: string;
}[] = [
  {
    id: 'home',
    label: 'Preview 01',
    title: 'Situation-first home',
    body: 'Lead with the travel moment, the free-vs-full boundary, and the current live depth.',
  },
  {
    id: 'phrase',
    label: 'Preview 02',
    title: 'Phrase product page',
    body: 'Prototype the hero phrase, in-place variant swaps, and deeper next-step taps as one guided flow.',
  },
  {
    id: 'search',
    label: 'Preview 03',
    title: 'Fast search under pressure',
    body: 'Surface exact phrases with situation context when the traveler only remembers part of the need.',
  },
  {
    id: 'saved',
    label: 'Preview 04',
    title: 'Quick-access favorites',
    body: 'Reassure users that the phrases they keep reaching for stay one tap away offline.',
  },
  {
    id: 'premium',
    label: 'Preview 05',
    title: 'One-time unlock depth',
    body: 'Explain the unlock model without changing the core travel situations or implying a subscription.',
  },
];

export function isAppPreviewSlideId(value?: string): value is AppPreviewSlideId {
  return appPreviewSlides.some((slide) => slide.id === value);
}

function isDefined<T>(value: T | undefined): value is T {
  return Boolean(value);
}

const starterVisibleCount = getAccessibleVisibleEntryCountForPack(currentApp.pack, false);
const fullVisibleCount = getAccessibleVisibleEntryCountForPack(currentApp.pack, true);
const featuredCategories = currentApp.presentation.premium.featuredCategoryIds
  .map((id) => currentApp.presentation.premium.categories.find((category) => category.id === id))
  .filter(isDefined)
  .slice(0, 4)
  .map((category) => ({
    id: category.id,
    title: category.title,
    emoji: category.emoji,
    description: category.description,
    starterVisibleCount: category.scenarioId
      ? getAccessibleVisibleEntryCountForScenario(currentApp.pack, category.scenarioId, false)
      : category.starterPhraseTarget,
    fullVisibleCount: category.scenarioId
      ? getAccessibleVisibleEntryCountForScenario(currentApp.pack, category.scenarioId, true)
      : category.totalPhraseTarget,
  }));
const previewScenario =
  (featuredCategories[0]?.id
    ? currentApp.pack.scenarioMap[currentApp.presentation.premium.categories.find((category) => category.id === featuredCategories[0]?.id)?.scenarioId || '']
    : undefined) ?? currentApp.scenarios[0]!;
const previewPrimaryFamily = previewScenario.intentFamilies[0]!;
const previewPrimaryPhrase = currentApp.pack.phraseMap[previewPrimaryFamily.primaryPhraseId]!;
const scenarioFollowUps = previewScenario.intentFamilies
  .slice(1, 4)
  .map((family) => family.title);
const searchKeywords = ['wifi', 'wi-fi', 'internet', 'sim', 'map', 'address'];
const rawSearchResults = currentApp.pack.phrases
  .filter((phrase) => {
    const haystack = [
      phrase.targetText,
      phrase.sourceText,
      phrase.pronunciation,
      phrase.context,
      phrase.usageNote,
      ...(phrase.searchAliases ?? []),
    ]
      .join(' ')
      .toLowerCase();
    return searchKeywords.some((keyword) => haystack.includes(keyword));
  })
  .slice(0, 3);
const searchResults = (rawSearchResults.length ? rawSearchResults : currentApp.quickPhrases.slice(0, 3)).map((phrase) => ({
  id: phrase.id,
  targetText: phrase.targetText,
  sourceText: phrase.sourceText,
  scenarioName: currentApp.pack.scenarioMap[phrase.scenarioId]?.name ?? 'Situation',
  familyTitle: currentApp.pack.intentFamilyMap[phrase.intentFamilyId]?.title ?? 'Need',
}));
const savedItems = currentApp.quickPhrases.slice(0, 3).map((phrase) => ({
  id: phrase.id,
  targetText: phrase.targetText,
  sourceText: phrase.sourceText,
  scenarioName: currentApp.pack.scenarioMap[phrase.scenarioId]?.name ?? 'Situation',
}));

export const previewDeckContent = {
  appName: currentApp.build.name,
  heroTitle: currentApp.presentation.home.heroTitle,
  heroBody: currentApp.presentation.home.heroBody,
  starterVisibleCount,
  fullVisibleCount,
  premiumVisibleCount: fullVisibleCount - starterVisibleCount,
  situationCount: currentApp.pack.scenarios.length,
  audioReadyCount: currentApp.pack.phrases.filter((phrase) => currentApp.audio.hasAudio(phrase.audioKey)).length,
  priceLabel: currentApp.presentation.premium.priceLabel,
  featuredCategories,
  previewScenario: {
    name: previewScenario.name,
    emoji: previewScenario.emoji,
    description: previewScenario.description,
    phraseCount: previewScenario.intentFamilies.length,
    primaryPhrase: previewPrimaryPhrase,
    followUpTitles: scenarioFollowUps,
  },
  searchResults,
  savedItems,
  livePremiumCategories: currentApp.presentation.premium.categories
    .filter((category) => category.availability === 'live')
    .slice(0, 3)
    .map((category) => ({
      id: category.id,
      title: category.title,
      emoji: category.emoji,
      highlight: category.highlights[0] ?? category.description,
      totalPhraseTarget: category.totalPhraseTarget,
    })),
};
