import { AppPack, AppPhrase } from '../family/contracts';
import { canAccessPhrase } from './contentAccess';

export type PhraseSearchResult = {
  phrase: AppPhrase;
  scenarioId: string;
  scenarioName: string;
  intentFamilyId?: string;
  intentFamilyTitle?: string;
  scenarioIndex: number;
  phraseIndex: number;
};

export function normalizeSearchText(value: string) {
  return value
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[\u0111\u0110]/g, 'd')
    .replace(/[-_/.,!?;:'"()\u2019]+/g, ' ')
    .toLowerCase()
    .replace(/\s+/g, ' ')
    .trim();
}

function compactSearchText(value: string) {
  return value.replace(/\s+/g, '');
}

export function searchPhrases(pack: AppPack, query: string, isPremiumUnlocked: boolean): PhraseSearchResult[] {
  const normalizedQuery = normalizeSearchText(query);

  if (!normalizedQuery) {
    return [];
  }

  const compactQuery = compactSearchText(normalizedQuery);

  const results: PhraseSearchResult[] = [];

  pack.scenarios.forEach((scenario, scenarioIndex) => {
    scenario.intentFamilies.forEach((family) => {
      const primaryPhrase = pack.phraseMap[family.primaryPhraseId];
      if (!primaryPhrase || !canAccessPhrase(primaryPhrase, isPremiumUnlocked)) {
        return;
      }

      const accessibleFamilyPhrases = family.phraseIds
        .map((phraseId) => pack.phraseMap[phraseId])
        .filter((phrase): phrase is NonNullable<typeof phrase> => Boolean(phrase))
        .filter((phrase) => canAccessPhrase(phrase, isPremiumUnlocked));

      const searchableText = normalizeSearchText(
        [
          family.title,
          family.summary ?? '',
          scenario.name,
          ...accessibleFamilyPhrases.flatMap((phrase) => [
            phrase.sourceText,
            phrase.targetText,
            phrase.canonicalTargetText ?? '',
            phrase.pronunciation ?? '',
            phrase.usageNote ?? phrase.context ?? '',
            phrase.youMayHear ?? '',
            phrase.searchAliases?.join(' ') ?? '',
          ]),
        ].join(' '),
      );

      if (
        !searchableText.includes(normalizedQuery) &&
        !compactSearchText(searchableText).includes(compactQuery)
      ) {
        return;
      }

      results.push({
        phrase: primaryPhrase,
        scenarioId: scenario.id,
        scenarioName: scenario.name,
        intentFamilyId: family.id,
        intentFamilyTitle: family.title,
        scenarioIndex,
        phraseIndex: scenario.phrases.findIndex((phrase) => phrase.id === primaryPhrase.id),
      });
    });
  });

  return results;
}
