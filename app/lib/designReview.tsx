import { createContext, PropsWithChildren, useContext, useEffect, useMemo, useState } from 'react';
import { useGlobalSearchParams } from 'expo-router';
import { getDesignReviewPreset, type DesignReviewPreset } from './designReviewPresets';

type DesignReviewContextValue = {
  isEnabled: boolean;
  presetId?: string;
  preset: DesignReviewPreset | null;
  premiumOverride: boolean | null;
  homeQuery?: string;
  savedPhraseIds: string[] | null;
  visitedScenarioIds: string[] | null;
  isPhraseSaved: (phraseId: string) => boolean | undefined;
  togglePhraseSaved: (phraseId: string) => boolean | undefined;
  isScenarioVisited: (scenarioId: string) => boolean | undefined;
  markScenarioVisited: (scenarioId: string) => void;
};

const DesignReviewContext = createContext<DesignReviewContextValue>({
  isEnabled: false,
  preset: null,
  premiumOverride: null,
  savedPhraseIds: null,
  visitedScenarioIds: null,
  isPhraseSaved: () => undefined,
  togglePhraseSaved: () => undefined,
  isScenarioVisited: () => undefined,
  markScenarioVisited: () => undefined,
});

function normalizeDesignPresetId(value?: string | string[]) {
  if (Array.isArray(value)) {
    return value[0];
  }

  return value;
}

function cloneIds(ids?: string[], isEnabled = false) {
  if (!isEnabled) {
    return null;
  }

  return ids ? [...ids] : [];
}

export function DesignReviewProvider({ children }: PropsWithChildren) {
  const params = useGlobalSearchParams<{ designPreset?: string | string[] }>();
  const presetId = normalizeDesignPresetId(params.designPreset);
  const preset = getDesignReviewPreset(presetId);
  const isEnabled = Boolean(preset);
  const [savedPhraseIds, setSavedPhraseIds] = useState<string[] | null>(() => cloneIds(preset?.savedPhraseIds, isEnabled));
  const [visitedScenarioIds, setVisitedScenarioIds] = useState<string[] | null>(() => cloneIds(preset?.visitedScenarioIds, isEnabled));

  useEffect(() => {
    setSavedPhraseIds(cloneIds(preset?.savedPhraseIds, isEnabled));
    setVisitedScenarioIds(cloneIds(preset?.visitedScenarioIds, isEnabled));
  }, [isEnabled, preset?.id, preset?.savedPhraseIds, preset?.visitedScenarioIds]);

  const isPhraseSaved = (phraseId: string) => {
    if (savedPhraseIds === null) {
      return undefined;
    }

    return savedPhraseIds.includes(phraseId);
  };

  const togglePhraseSaved = (phraseId: string) => {
    if (savedPhraseIds === null) {
      return undefined;
    }

    const nextSaved = !savedPhraseIds.includes(phraseId);
    setSavedPhraseIds((current) => {
      const working = current ? [...current] : [];
      if (working.includes(phraseId)) {
        return working.filter((currentPhraseId) => currentPhraseId !== phraseId);
      }

      return [...working, phraseId];
    });
    return nextSaved;
  };

  const isScenarioVisited = (scenarioId: string) => {
    if (visitedScenarioIds === null) {
      return undefined;
    }

    return visitedScenarioIds.includes(scenarioId);
  };

  const markScenarioVisited = (scenarioId: string) => {
    if (visitedScenarioIds === null || visitedScenarioIds.includes(scenarioId)) {
      return;
    }

    setVisitedScenarioIds((current) => [...(current ?? []), scenarioId]);
  };

  const value = useMemo<DesignReviewContextValue>(
    () => ({
      isEnabled,
      presetId,
      preset,
      premiumOverride:
        typeof preset?.premiumUnlocked === 'boolean'
          ? preset.premiumUnlocked
          : null,
      homeQuery: preset?.homeQuery,
      savedPhraseIds,
      visitedScenarioIds,
      isPhraseSaved,
      togglePhraseSaved,
      isScenarioVisited,
      markScenarioVisited,
    }),
    [isEnabled, preset, presetId, savedPhraseIds, visitedScenarioIds],
  );

  return <DesignReviewContext.Provider value={value}>{children}</DesignReviewContext.Provider>;
}

export function useDesignReview() {
  return useContext(DesignReviewContext);
}
