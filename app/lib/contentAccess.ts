import { AppPack, AppPhrase, AppScenario } from '../family/contracts';

export function canAccessPhrase(phrase: AppPhrase, isPremiumUnlocked: boolean) {
  return phrase.accessTier !== 'premium' || isPremiumUnlocked;
}

export function getAccessiblePhrases(phrases: AppPhrase[], isPremiumUnlocked: boolean) {
  return phrases.filter((phrase) => canAccessPhrase(phrase, isPremiumUnlocked));
}

export function getAccessibleScenarioPhrases(scenario: AppScenario, isPremiumUnlocked: boolean) {
  return getAccessiblePhrases(scenario.phrases, isPremiumUnlocked);
}

export function getAccessibleIntentFamilies(scenario: AppScenario, isPremiumUnlocked: boolean) {
  return scenario.intentFamilies.filter((family) => {
    const primaryPhrase = scenario.phrases.find((phrase) => phrase.id === family.primaryPhraseId);
    if (!primaryPhrase) {
      return false;
    }

    return canAccessPhrase(primaryPhrase, isPremiumUnlocked);
  });
}

export function getAccessiblePhraseCountForScenario(
  pack: AppPack,
  scenarioId: string,
  isPremiumUnlocked: boolean,
) {
  const scenario = pack.scenarioMap[scenarioId];
  if (!scenario) {
    return 0;
  }

  return getAccessibleScenarioPhrases(scenario, isPremiumUnlocked).length;
}

export function getAccessibleVisibleEntryCountForScenario(
  pack: AppPack,
  scenarioId: string,
  isPremiumUnlocked: boolean,
) {
  const scenario = pack.scenarioMap[scenarioId];
  if (!scenario) {
    return 0;
  }

  return getAccessibleIntentFamilies(scenario, isPremiumUnlocked).length;
}

export function getAccessibleVisibleEntryCountForPack(pack: AppPack, isPremiumUnlocked: boolean) {
  return pack.intentFamilies.filter((family) => {
    const primaryPhrase = pack.phraseMap[family.primaryPhraseId];
    if (!primaryPhrase) {
      return false;
    }

    return canAccessPhrase(primaryPhrase, isPremiumUnlocked);
  }).length;
}
