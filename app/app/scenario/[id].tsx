import { useCallback, useEffect } from 'react';
import { FlatList, Pressable, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Stack, router, useLocalSearchParams } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Phrase } from '../../content/types';
import { PhraseCard } from '../../components/PhraseCard';
import { ThemedText } from '../../components/ui/ThemedText';
import { scenarioMap } from '../../content/scenarios';

export default function ScenarioScreen() {
  const { id } = useLocalSearchParams<{ id?: string }>();
  const scenario = id ? scenarioMap[id] : undefined;

  useEffect(() => {
    if (!scenario) return;
    AsyncStorage.setItem(`visited-${scenario.id}`, '1').catch((error) => console.error('Failed to save visited scenario', error));
  }, [scenario]);

  const renderItem = useCallback(({ item, index }: { item: Phrase; index: number }) => <PhraseCard index={index} phrase={item} />, []);

  if (!scenario) {
    return (
      <SafeAreaView className="flex-1 bg-background px-5" edges={['top', 'bottom']}>
        <View className="flex-row items-center gap-3 pt-6"><Pressable accessibilityLabel="Go back" onPress={() => router.back()}><ThemedText className="text-2xl">←</ThemedText></Pressable><ThemedText variant="subtitle">Scenario not found</ThemedText></View>
        <View className="flex-1 items-center justify-center"><ThemedText className="text-center">The phrase list for this route is missing or invalid.</ThemedText></View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <Stack.Screen options={{ headerShown: false, statusBarStyle: 'dark' }} />
      <FlatList
        className="flex-1"
        contentContainerClassName="gap-4 px-5 pb-24 pt-6"
        data={scenario.phrases}
        getItemLayout={(_, index) => ({ length: 170, offset: 170 * index, index })}
        keyExtractor={(item) => item.id}
        renderItem={renderItem}
        ListHeaderComponent={<View className="mb-2 space-y-4"><View className="flex-row items-center gap-3"><Pressable accessibilityLabel="Go back" onPress={() => router.back()}><ThemedText className="text-2xl">←</ThemedText></Pressable><ThemedText accessibilityLabel={`${scenario.name} emoji`} accessibilityRole="image" className="text-2xl">{scenario.emoji}</ThemedText><ThemedText variant="subtitle">{scenario.name}</ThemedText></View><View className="space-y-2"><ThemedText accessibilityLabel={`${scenario.name} emoji`} accessibilityRole="image" className="text-5xl">{scenario.emoji}</ThemedText><ThemedText variant="title">{scenario.name}</ThemedText><ThemedText variant="caption">{scenario.description}</ThemedText></View><View className="rounded-2xl border-l-4 border-primary bg-[#FFF4ED] p-3"><ThemedText>Pro tip: {scenario.tip || 'Speak slowly, smile, and point to context when needed.'}</ThemedText></View></View>}
      />
    </SafeAreaView>
  );
}
