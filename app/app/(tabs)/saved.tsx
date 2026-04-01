import { useCallback, useState } from 'react';
import { FlatList, RefreshControl, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useFocusEffect } from 'expo-router';
import { PhraseCard } from '../../components/PhraseCard';
import { ThemedText } from '../../components/ui/ThemedText';
import { phraseMap, scenarioMap } from '../../content/scenarios';
import { Phrase } from '../../content/types';
import { getSavedPhraseMeta } from '../../lib/favorites';

type SavedItem = { phrase: Phrase; scenarioName: string };

export default function SavedScreen() {
  const [items, setItems] = useState<SavedItem[]>([]);
  const [refreshing, setRefreshing] = useState(false);

  const refresh = useCallback(async () => {
    setRefreshing(true);
    const meta = await getSavedPhraseMeta();
    setItems(meta.map(({ id }) => phraseMap[id]).filter(Boolean).map((phrase) => ({ phrase, scenarioName: scenarioMap[phrase.scenarioId]?.name ?? 'Unknown' })));
    setRefreshing(false);
  }, []);

  const handleFavoriteChange = useCallback((phraseId: string, saved: boolean) => {
    if (!saved) setItems((current) => current.filter((item) => item.phrase.id !== phraseId));
  }, []);

  useFocusEffect(useCallback(() => { void refresh(); }, [refresh]));

  if (!items.length && !refreshing) {
    return <SafeAreaView className="flex-1 items-center justify-center bg-background px-5" edges={['top', 'bottom']}><ThemedText className="text-6xl text-caption">♡</ThemedText><ThemedText variant="title" className="mt-4 text-center text-2xl">No saved phrases yet</ThemedText><ThemedText className="mt-3 text-center">Tap ♡ on any phrase to save it for quick access</ThemedText></SafeAreaView>;
  }

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <FlatList
        className="flex-1"
        contentContainerClassName="gap-4 px-5 pb-24 pt-6"
        data={items}
        getItemLayout={(_, index) => ({ length: 170, offset: 170 * index, index })}
        keyExtractor={(item) => item.phrase.id}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => void refresh()} tintColor="#FF6B35" />}
        renderItem={({ item, index }) => <PhraseCard footerLabel={`from ${item.scenarioName}`} index={index} onFavoriteChange={(saved) => handleFavoriteChange(item.phrase.id, saved)} phrase={item.phrase} />}
        ListHeaderComponent={<ThemedText variant="title">Saved Phrases</ThemedText>}
      />
    </SafeAreaView>
  );
}
