import { useCallback, useEffect } from 'react';
import { FlatList, Pressable, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Stack, router, useLocalSearchParams } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';
import Ionicons from '@expo/vector-icons/Ionicons';
import { Phrase } from '../../content/types';
import { PhraseCard } from '../../components/PhraseCard';
import { ThemedText } from '../../components/ui/ThemedText';
import { scenarioMap } from '../../content/scenarios';

function BackButton() {
  return (
    <Pressable
      accessibilityLabel="Go back"
      onPress={() => router.back()}
      className="h-11 w-11 items-center justify-center rounded-full bg-surface"
      style={({ pressed }) => [{ opacity: pressed ? 0.6 : 1 }]}
    >
      <Ionicons name="chevron-back" size={22} color="#1A1A2E" />
    </Pressable>
  );
}

export default function ScenarioScreen() {
  const { id } = useLocalSearchParams<{ id?: string }>();
  const scenario = id ? scenarioMap[id] : undefined;

  useEffect(() => {
    if (!scenario) return;
    AsyncStorage.setItem(`visited-${scenario.id}`, '1').catch((error) =>
      console.error('Failed to save visited scenario', error),
    );
  }, [scenario]);

  const renderItem = useCallback(
    ({ item, index }: { item: Phrase; index: number }) => (
      <PhraseCard index={index} phrase={item} />
    ),
    [],
  );

  if (!scenario) {
    return (
      <SafeAreaView className="flex-1 bg-background px-5" edges={['top', 'bottom']}>
        <View className="flex-row items-center gap-3 pt-6">
          <BackButton />
          <ThemedText variant="subtitle">Scenario not found</ThemedText>
        </View>
        <View className="flex-1 items-center justify-center">
          <ThemedText className="text-center">
            The phrase list for this route is missing or invalid.
          </ThemedText>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <Stack.Screen options={{ headerShown: false }} />
      <FlatList
        className="flex-1"
        contentContainerClassName="gap-4 px-5 pb-24 pt-6"
        data={scenario.phrases}
        getItemLayout={(_, index) => ({ length: 170, offset: 170 * index, index })}
        keyExtractor={(item) => item.id}
        renderItem={renderItem}
        ListHeaderComponent={
          <View className="mb-2 space-y-4">
            <View className="flex-row items-center gap-3">
              <BackButton />
              <ThemedText
                accessibilityLabel={`${scenario.name} emoji`}
                accessibilityRole="image"
                className="text-3xl"
              >
                {scenario.emoji}
              </ThemedText>
              <View className="flex-1">
                <ThemedText variant="title" className="text-2xl">
                  {scenario.name}
                </ThemedText>
                <ThemedText variant="caption">{scenario.description}</ThemedText>
              </View>
            </View>
            <View className="mt-2 flex-row items-start gap-2 rounded-2xl bg-surface px-4 py-3">
              <ThemedText className="text-lg">💡</ThemedText>
              <ThemedText variant="caption" className="flex-1 text-sm leading-5">
                {scenario.tip || 'Speak slowly, smile, and point to context when needed.'}
              </ThemedText>
            </View>
          </View>
        }
      />
    </SafeAreaView>
  );
}
