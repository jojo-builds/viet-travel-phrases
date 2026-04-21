import { useCallback, useDeferredValue, useEffect, useRef, useState } from 'react';
import { FlatList, NativeScrollEvent, NativeSyntheticEvent, Platform, Pressable, ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { router } from 'expo-router';
import { useBottomTabBarHeight } from '@react-navigation/bottom-tabs';
import Ionicons from '@expo/vector-icons/Ionicons';
import { AudioPlayButton } from '../../components/AudioPlayButton';
import { PhraseCard } from '../../components/PhraseCard';
import { HomeSearchDock } from '../../components/home/HomeSearchDock';
import { HomeTopSection } from '../../components/home/HomeTopSection';
import { LibraryCategoryCard } from '../../components/home/LibraryCategoryCard';
import { PrioritySituationCard } from '../../components/home/PrioritySituationCard';
import { ThemedText } from '../../components/ui/ThemedText';
import { currentApp } from '../../family/currentApp';
import {
  canAccessPhrase,
  getAccessibleVisibleEntryCountForPack,
  getAccessibleVisibleEntryCountForScenario,
} from '../../lib/contentAccess';
import { useDesignReview } from '../../lib/designReview';
import { getHomeSearchState } from '../../lib/homeSearchState';
import { usePremiumAccess } from '../../lib/premiumAccess';
import { useKeyboardInset } from '../../lib/useKeyboardInset';

type ResolvedCategory = (typeof currentApp.presentation.premium.categories)[number] & {
  livePhraseCount: number;
  visited: boolean;
  starterVisibleCount: number;
  fullVisibleCount: number;
};

function isDefined<T>(value: T | undefined): value is T {
  return Boolean(value);
}

function toVisitedScenarioMap(scenarioIds: string[]) {
  return Object.fromEntries(scenarioIds.map((scenarioId) => [scenarioId, true]));
}

export default function HomeScreen() {
  const [visited, setVisited] = useState<Record<string, boolean>>({});
  const [query, setQuery] = useState('');
  const [isSearchFocused, setIsSearchFocused] = useState(false);
  const [isSearchDockCollapsed, setIsSearchDockCollapsed] = useState(false);
  const lastScrollOffset = useRef(0);
  const tabBarHeight = useBottomTabBarHeight();
  const keyboardInset = useKeyboardInset();
  const designReview = useDesignReview();
  const { isUnlocked } = usePremiumAccess();
  const home = currentApp.presentation.home;
  const premium = currentApp.presentation.premium;
  const supportsAudio = currentApp.presentation.capabilities.audio;
  const supportsSearch = currentApp.presentation.capabilities.search;
  const deferredQuery = useDeferredValue(query);
  const searchState = getHomeSearchState(currentApp.pack, supportsSearch, deferredQuery, isUnlocked);
  const starterVisibleCount = getAccessibleVisibleEntryCountForPack(currentApp.pack, false);
  const fullVisibleCount = getAccessibleVisibleEntryCountForPack(currentApp.pack, true);
  const keyboardDismissMode = Platform.OS === 'ios' ? 'interactive' : 'on-drag';
  const contentBottomPadding = (keyboardInset > 0 ? keyboardInset : tabBarHeight) + 132;

  useEffect(() => {
    let active = true;

    if (designReview.isEnabled) {
      setVisited(toVisitedScenarioMap(designReview.visitedScenarioIds ?? []));
      return () => {
        active = false;
      };
    }

    void currentApp.storage.getVisitedScenarioMap(currentApp.scenarios.map((scenario) => scenario.id)).then((nextVisited) => {
      if (active) {
        setVisited(nextVisited);
      }
    });

    return () => {
      active = false;
    };
  }, [designReview.isEnabled, designReview.visitedScenarioIds]);

  useEffect(() => {
    if (!designReview.isEnabled) {
      return;
    }

    const nextQuery = designReview.homeQuery ?? '';
    setQuery(nextQuery);
    setIsSearchFocused(nextQuery.trim().length > 0);
    setIsSearchDockCollapsed(false);
  }, [designReview.homeQuery, designReview.isEnabled, designReview.presetId]);

  useEffect(() => {
    if (query.trim().length > 0 || isSearchFocused) {
      setIsSearchDockCollapsed(false);
    }
  }, [isSearchFocused, query]);

  const openPremium = useCallback(() => router.push('/premium'), []);

  const handleScroll = useCallback(
    (event: NativeSyntheticEvent<NativeScrollEvent>) => {
      const nextOffset = event.nativeEvent.contentOffset.y;
      const delta = nextOffset - lastScrollOffset.current;
      lastScrollOffset.current = nextOffset;

      if (isSearchFocused || query.trim().length > 0) {
        if (isSearchDockCollapsed) {
          setIsSearchDockCollapsed(false);
        }
        return;
      }

      if (nextOffset < 32 || delta < -6) {
        if (isSearchDockCollapsed) {
          setIsSearchDockCollapsed(false);
        }
        return;
      }

      if (delta > 10 && nextOffset > 80 && !isSearchDockCollapsed) {
        setIsSearchDockCollapsed(true);
      }
    },
    [isSearchDockCollapsed, isSearchFocused, query],
  );

  const scenarioOrder = new Map(home.scenarioOrder.map((id, index) => [id, index]));
  const resolvedCategories: ResolvedCategory[] = premium.categories
    .map((category) => {
      const starterCount = category.scenarioId
        ? getAccessibleVisibleEntryCountForScenario(currentApp.pack, category.scenarioId, false)
        : category.starterPhraseTarget;
      const fullCount = category.scenarioId
        ? getAccessibleVisibleEntryCountForScenario(currentApp.pack, category.scenarioId, true)
        : category.totalPhraseTarget;

      return {
        ...category,
        starterVisibleCount: starterCount,
        fullVisibleCount: fullCount,
        livePhraseCount: isUnlocked ? fullCount : starterCount,
        visited: category.scenarioId ? Boolean(visited[category.scenarioId]) : false,
      };
    })
    .sort((left, right) => {
      const leftOrder = left.scenarioId ? (scenarioOrder.get(left.scenarioId) ?? Number.MAX_SAFE_INTEGER) : Number.MAX_SAFE_INTEGER;
      const rightOrder = right.scenarioId ? (scenarioOrder.get(right.scenarioId) ?? Number.MAX_SAFE_INTEGER) : Number.MAX_SAFE_INTEGER;
      return leftOrder - rightOrder;
    });

  const priorityCategories = premium.featuredCategoryIds
    .map((id) => resolvedCategories.find((category) => category.id === id))
    .filter(isDefined);
  const visibleQuickPhrases = currentApp.quickPhrases.filter((phrase) => canAccessPhrase(phrase, isUnlocked));

  const openCategory = useCallback(
    (category: ResolvedCategory) => {
      if (category.access === 'premium-only' && !isUnlocked) {
        openPremium();
        return;
      }

      if (category.scenarioId && currentApp.pack.scenarioMap[category.scenarioId]) {
        router.push(`/scenario/${category.scenarioId}`);
        return;
      }

      openPremium();
    },
    [isUnlocked, openPremium],
  );

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top']}>
      <View className="flex-1">
        {searchState.hasActiveQuery ? (
          <FlatList
            className="flex-1"
            contentContainerStyle={{
              flexGrow: 1,
              gap: 16,
              paddingHorizontal: 20,
              paddingTop: 30,
              paddingBottom: contentBottomPadding,
            }}
            data={searchState.results}
            keyExtractor={(item) => item.phrase.id}
            keyboardDismissMode={keyboardDismissMode}
            keyboardShouldPersistTaps="handled"
            onScroll={handleScroll}
            scrollEventThrottle={16}
            testID="home-results-list"
            ListEmptyComponent={
              searchState.showEmptyState ? (
                <View className="rounded-3xl border border-border bg-surface px-5 py-5 shadow-sm" testID="home-empty-state">
                  <ThemedText variant="subtitle">{currentApp.presentation.search.emptyTitle}</ThemedText>
                  <ThemedText className="mt-2">{currentApp.presentation.search.emptyBody}</ThemedText>
                </View>
              ) : null
            }
            ListHeaderComponent={
              <HomeTopSection
                compact
                fullVisibleCount={fullVisibleCount}
                isPremiumUnlocked={isUnlocked}
                onOpenPremium={openPremium}
                resultCount={searchState.results.length}
                showResultsTitle
                starterVisibleCount={starterVisibleCount}
              />
            }
            renderItem={({ item }) => (
              <PhraseCard
                contextItems={[
                  { label: 'Situation', value: item.scenarioName },
                  ...(item.intentFamilyTitle ? [{ label: 'Need', value: item.intentFamilyTitle }] : []),
                ]}
                phrase={item.phrase}
              />
            )}
          />
        ) : (
          <ScrollView
            className="flex-1"
            contentContainerStyle={{
              paddingHorizontal: 20,
              paddingTop: 30,
              paddingBottom: contentBottomPadding,
            }}
            keyboardDismissMode={keyboardDismissMode}
            keyboardShouldPersistTaps="handled"
            onScroll={handleScroll}
            scrollEventThrottle={16}
            testID="home-root-scroll"
          >
            <View className="space-y-8">
              <HomeTopSection
                fullVisibleCount={fullVisibleCount}
                isPremiumUnlocked={isUnlocked}
                onOpenPremium={openPremium}
                showResultsTitle={false}
                starterVisibleCount={starterVisibleCount}
              />

              {searchState.showQuickPhrases ? (
                <View className="space-y-4" testID="home-quick-phrases">
                  <View className="space-y-1">
                    <ThemedText variant="subtitle">{home.quickPhrasesTitle}</ThemedText>
                    {home.quickPhrasesSubtitle ? <ThemedText>{home.quickPhrasesSubtitle}</ThemedText> : null}
                  </View>
                  <ScrollView horizontal showsHorizontalScrollIndicator={false}>
                    <View className="flex-row gap-3 pb-1">
                      {visibleQuickPhrases.map((phrase) => {
                        const scenarioName = currentApp.pack.scenarioMap[phrase.scenarioId]?.name;
                        const familyTitle = currentApp.pack.intentFamilyMap[phrase.intentFamilyId]?.title;
                        const hasAudio = supportsAudio && currentApp.audio.hasAudio(phrase.audioKey);

                        return (
                          <View
                            key={phrase.id}
                            className="w-[244px] rounded-[28px] border border-border bg-surface p-4 shadow-sm"
                            testID={`quick-phrase-${phrase.id}`}
                          >
                            <View className="flex-row items-start justify-between gap-3">
                              <View className="flex-1">
                                {scenarioName ? (
                                  <View className="self-start rounded-full bg-accent-soft px-3 py-1">
                                    <ThemedText variant="label" className="text-primary">
                                      {scenarioName}
                                    </ThemedText>
                                  </View>
                                ) : null}
                                {familyTitle ? (
                                  <ThemedText variant="caption" className="mt-2 text-text-secondary">
                                    {familyTitle}
                                  </ThemedText>
                                ) : null}
                              </View>
                              {hasAudio ? <AudioPlayButton audioKey={phrase.audioKey} size={44} tone="subtle" /> : null}
                            </View>

                            <ThemedText variant="target" className="mt-4 text-[24px] leading-[30px]">
                              {phrase.targetText}
                            </ThemedText>
                            <ThemedText variant="source" className="mt-2">
                              {phrase.sourceText}
                            </ThemedText>

                            {!hasAudio ? (
                              <ThemedText variant="caption" className="mt-4 text-text-secondary">
                                {currentApp.presentation.phrase.audioUnavailableLabel}
                              </ThemedText>
                            ) : null}
                          </View>
                        );
                      })}
                    </View>
                  </ScrollView>
                </View>
              ) : null}

              {searchState.showScenarios ? (
                <View className="space-y-4" testID="home-scenarios-section">
                  <View className="space-y-1">
                    <ThemedText variant="subtitle">{home.scenariosTitle}</ThemedText>
                    {home.scenariosSubtitle ? <ThemedText>{home.scenariosSubtitle}</ThemedText> : null}
                  </View>
                  <View className="flex-row flex-wrap justify-between gap-y-4">
                    {priorityCategories.map((category) => (
                      <View key={category.id} style={{ width: '48%' }}>
                        <PrioritySituationCard
                          description={category.description}
                          emoji={category.emoji}
                          fullVisibleCount={category.fullVisibleCount}
                          highlights={category.highlights}
                          isPremiumUnlocked={isUnlocked}
                          onPress={() => openCategory(category)}
                          starterVisibleCount={category.starterVisibleCount}
                          title={category.title}
                        />
                      </View>
                    ))}
                  </View>
                </View>
              ) : null}

              {!isUnlocked ? (
                <View className="rounded-[32px] border border-premium bg-premium-soft px-5 py-5 shadow-sm">
                  <View className="flex-row items-start justify-between gap-4">
                    <View className="flex-1">
                      <ThemedText variant="label" className="text-premium">
                        {premium.teaserBadge}
                      </ThemedText>
                      <ThemedText variant="subtitle" className="mt-2">
                        {premium.teaserTitle}
                      </ThemedText>
                      <ThemedText className="mt-2">{premium.teaserBody}</ThemedText>
                    </View>
                    <View className="h-12 w-12 items-center justify-center rounded-2xl bg-white">
                      <Ionicons name="sparkles-outline" size={24} color="#1F6F78" />
                    </View>
                  </View>
                  <Pressable
                    accessibilityLabel={premium.teaserButtonLabel}
                    onPress={openPremium}
                    style={({ pressed }) => [{ opacity: pressed ? 0.82 : 1 }]}
                    className="mt-4 self-start rounded-2xl bg-premium px-4 py-3"
                  >
                    <ThemedText className="font-semibold text-white">{premium.teaserButtonLabel}</ThemedText>
                  </Pressable>
                </View>
              ) : null}

              <View className="space-y-4">
                <View className="space-y-1">
                  <ThemedText variant="subtitle">{home.libraryTitle}</ThemedText>
                  {home.librarySubtitle ? <ThemedText>{home.librarySubtitle}</ThemedText> : null}
                </View>
                <View className="gap-4">
                  {resolvedCategories.map((category) => (
                    <View key={category.id} className="w-full">
                      <LibraryCategoryCard
                        accessLabel={
                          category.access === 'starter' ? premium.includedBadgeLabel : premium.premiumOnlyBadgeLabel
                        }
                        availabilityLabel={
                          category.availability === 'live' ? premium.liveNowBadgeLabel : premium.plannedBadgeLabel
                        }
                        compact
                        description={category.description}
                        emoji={category.emoji}
                        fullVisibleCount={category.fullVisibleCount}
                        highlights={category.highlights}
                        isPremiumUnlocked={isUnlocked}
                        livePhraseCount={category.livePhraseCount}
                        onPress={() => openCategory(category)}
                        starterPhraseTarget={category.starterPhraseTarget}
                        starterVisibleCount={category.starterVisibleCount}
                        title={category.title}
                        totalPhraseTarget={category.totalPhraseTarget}
                        visited={category.visited}
                      />
                    </View>
                  ))}
                </View>
              </View>
            </View>
          </ScrollView>
        )}

        {supportsSearch ? (
          <HomeSearchDock
            bottomOffset={tabBarHeight}
            isCollapsed={isSearchDockCollapsed}
            isFocused={isSearchFocused}
            onBlur={() => setIsSearchFocused(false)}
            onChangeQuery={setQuery}
            onClearQuery={() => setQuery('')}
            onFocus={() => {
              setIsSearchFocused(true);
              setIsSearchDockCollapsed(false);
            }}
            query={query}
          />
        ) : null}
      </View>
    </SafeAreaView>
  );
}
