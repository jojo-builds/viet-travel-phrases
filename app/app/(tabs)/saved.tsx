import { useCallback, useEffect, useState } from 'react';
import { FlatList, RefreshControl, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useFocusEffect } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import { PhraseCard } from '../../components/PhraseCard';
import { ThemedText } from '../../components/ui/ThemedText';
import { AppPhrase } from '../../family/contracts';
import { currentApp } from '../../family/currentApp';
import { canAccessPhrase } from '../../lib/contentAccess';
import { useDesignReview } from '../../lib/designReview';
import { usePremiumAccess } from '../../lib/premiumAccess';

type SavedItem = { phrase: AppPhrase; scenarioName?: string; intentFamilyTitle?: string };

function isDefined<T>(value: T | undefined): value is T {
  return Boolean(value);
}

function resolveSavedItems(phraseIds: string[], isUnlocked: boolean) {
  return phraseIds
    .map((id) => currentApp.pack.phraseMap[id])
    .filter(isDefined)
    .filter((phrase) => canAccessPhrase(phrase, isUnlocked))
    .map((phrase) => ({
      phrase,
      scenarioName: currentApp.pack.scenarioMap[phrase.scenarioId]?.name,
      intentFamilyTitle: currentApp.pack.intentFamilyMap[phrase.intentFamilyId]?.title,
    }));
}

export default function SavedScreen() {
  const [items, setItems] = useState<SavedItem[]>([]);
  const [refreshing, setRefreshing] = useState(false);
  const designReview = useDesignReview();
  const { isUnlocked } = usePremiumAccess();
  const savedCopy = currentApp.presentation.saved;

  const refresh = useCallback(async () => {
    setRefreshing(true);
    if (designReview.isEnabled) {
      setItems(resolveSavedItems(designReview.savedPhraseIds ?? [], isUnlocked));
      setRefreshing(false);
      return;
    }

    const meta = await currentApp.storage.getSavedPhraseMeta();
    setItems(resolveSavedItems(meta.map(({ id }) => id), isUnlocked));
    setRefreshing(false);
  }, [designReview.isEnabled, designReview.savedPhraseIds, isUnlocked]);

  useEffect(() => {
    if (!designReview.isEnabled) {
      return;
    }

    setItems(resolveSavedItems(designReview.savedPhraseIds ?? [], isUnlocked));
    setRefreshing(false);
  }, [designReview.isEnabled, designReview.savedPhraseIds, isUnlocked]);

  const handleFavoriteChange = useCallback((phraseId: string, saved: boolean) => {
    if (!saved) {
      setItems((current) => current.filter((item) => item.phrase.id !== phraseId));
    }
  }, []);

  useFocusEffect(
    useCallback(() => {
      void refresh();
    }, [refresh]),
  );

  if (!items.length && !refreshing) {
    return (
      <SafeAreaView
        className="flex-1 items-center justify-center bg-background px-5"
        edges={['top', 'bottom']}
        testID="saved-empty-state"
      >
        <View className="items-center rounded-[32px] border border-border bg-surface px-6 py-8 shadow-sm">
          <View className="h-14 w-14 items-center justify-center rounded-2xl bg-accent-soft">
            <Ionicons name={savedCopy.emptyIcon as keyof typeof Ionicons.glyphMap} size={28} color="#D97745" />
          </View>
          <ThemedText variant="title" className="mt-2 text-center text-[26px] leading-[32px]">
            {savedCopy.emptyTitle}
          </ThemedText>
          <ThemedText className="mt-3 text-center">{savedCopy.emptyBody}</ThemedText>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <FlatList
        className="flex-1"
        contentContainerStyle={{ gap: 16, paddingHorizontal: 20, paddingTop: 28, paddingBottom: 108 }}
        data={items}
        keyExtractor={(item) => item.phrase.id}
        testID="saved-list"
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={() => void refresh()} tintColor="#D97745" />
        }
        renderItem={({ item }) => (
          <PhraseCard
            contextItems={[item.scenarioName, item.intentFamilyTitle]
              .filter(Boolean)
              .map((value) => ({ label: 'Context', value: value as string }))}
            onFavoriteChange={(saved) => handleFavoriteChange(item.phrase.id, saved)}
            phrase={item.phrase}
          />
        )}
        ListHeaderComponent={
          <View className="rounded-[32px] border border-border bg-surface px-5 py-5 shadow-sm">
            <ThemedText variant="title" className="text-[28px] leading-[34px]" testID="saved-title">
              {savedCopy.title}
            </ThemedText>
            <ThemedText className="mt-3">Keep useful phrases one tap away.</ThemedText>
            <View className="mt-4 self-start rounded-full bg-accent-soft px-3 py-2">
              <ThemedText variant="label" className="text-primary">
                {items.length} saved
              </ThemedText>
            </View>
          </View>
        }
      />
    </SafeAreaView>
  );
}
