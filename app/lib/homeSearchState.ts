import { AppPack } from '../family/contracts';
import { PhraseSearchResult, searchPhrases } from './searchPhrases';

export type HomeSearchState = {
  hasActiveQuery: boolean;
  mode: 'browse' | 'results';
  showQuickPhrases: boolean;
  showScenarios: boolean;
  showResultsTitle: boolean;
  showEmptyState: boolean;
  results: PhraseSearchResult[];
};

export function getHomeSearchState(
  pack: AppPack,
  supportsSearch: boolean,
  query: string,
  isPremiumUnlocked: boolean,
): HomeSearchState {
  const hasActiveQuery = supportsSearch && query.trim().length > 0;
  const results = hasActiveQuery ? searchPhrases(pack, query, isPremiumUnlocked) : [];

  return {
    hasActiveQuery,
    mode: hasActiveQuery ? 'results' : 'browse',
    showQuickPhrases: !hasActiveQuery,
    showScenarios: !hasActiveQuery,
    showResultsTitle: hasActiveQuery,
    showEmptyState: hasActiveQuery && results.length === 0,
    results,
  };
}
