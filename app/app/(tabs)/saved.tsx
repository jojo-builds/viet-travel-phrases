import { useCallback, useState } from 'react';
import { FlatList, View } from 'react-native';
import { useFocusEffect } from 'expo-router';
import { PhraseCard } from '../../components/PhraseCard';
import { ThemedText } from '../../components/ui/ThemedText';
import { phraseMap } from '../../content/scenarios';
import { getFavoriteIds } from '../../lib/favorites';
import { Phrase } from '../../content/types';

export default function SavedScreen() {
  const [phrases, setPhrases] = useState<Phrase[]>([]);

  const refresh = useCallback(() => {
    getFavoriteIds().then((ids) => setPhrases(ids.map((id) => phraseMap[id]).filter(Boolean)));
  }, []);

  useFocusEffect(refresh);

  if (!phrases.length) {
    return (
      <View className="flex-1 items-center justify-center bg-background px-5">
        <ThemedText variant="title" className="text-center text-2xl">
          No saved phrases yet
        </ThemedText>
        <ThemedText className="mt-3 text-center">
          Tap the heart on any phrase card to keep it handy offline.
        </ThemedText>
      </View>
    );
  }

  return (
    <FlatList
      className="flex-1 bg-background"
      contentContainerClassName="gap-4 px-5 pb-10 pt-16"
      data={phrases}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => <PhraseCard phrase={item} onFavoriteChange={() => refresh()} />}
      ListHeaderComponent={<ThemedText variant="title">Saved Phrases</ThemedText>}
    />
  );
}
