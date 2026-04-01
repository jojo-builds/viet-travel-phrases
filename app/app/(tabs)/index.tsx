import { useCallback, useEffect, useState } from 'react';
import { Pressable, ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { router } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { AudioPlayButton } from '../../components/AudioPlayButton';
import { ScenarioCard } from '../../components/ScenarioCard';
import { ThemedText } from '../../components/ui/ThemedText';
import { quickPhrases, scenarios } from '../../content/scenarios';

export default function HomeScreen() {
  const [visited, setVisited] = useState<Record<string, boolean>>({});

  useEffect(() => {
    (async () => {
      try {
        const pairs = await AsyncStorage.multiGet(scenarios.map((item) => `visited-${item.id}`));
        setVisited(Object.fromEntries(pairs.map(([key, value]) => [key.replace('visited-', ''), value === '1'])));
      } catch (error) {
        console.error('Failed to read visited scenarios', error);
      }
    })();
  }, []);

  const openScenario = useCallback((id: string) => router.push(`/scenario/${id}`), []);

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <ScrollView className="flex-1" contentContainerClassName="px-5 pb-24 pt-6">
        <View className="space-y-8">
          <View className="flex-row items-start justify-between">
            <View className="flex-1 space-y-2 pr-4">
              <ThemedText variant="title">Xin chào!</ThemedText>
              <ThemedText>Travel Vietnamese for everyday situations</ThemedText>
            </View>
            <Pressable accessibilityLabel="Open settings" onPress={() => router.push('/settings')} style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}>
              <ThemedText className="text-2xl">⚙</ThemedText>
            </Pressable>
          </View>
          <View className="space-y-4">
            <ThemedText variant="subtitle">Quick Phrases</ThemedText>
            <ScrollView horizontal showsHorizontalScrollIndicator={false}>
              <View className="flex-row gap-3 pb-1">
                {quickPhrases.map((phrase) => (
                  <View key={phrase.id} className="flex-row items-center gap-3 rounded-full border border-primary bg-surface px-4 py-3">
                    <View className="max-w-[140px]">
                      <ThemedText variant="romanized" className="text-base">{phrase.vietnamese}</ThemedText>
                    </View>
                    <AudioPlayButton audioFile={`${phrase.audioKey}.mp3`} />
                  </View>
                ))}
              </View>
            </ScrollView>
          </View>
          <View className="space-y-4">
            <ThemedText variant="subtitle">Scenarios</ThemedText>
            <View className="flex-row flex-wrap gap-4">
              {scenarios.map((scenario, index) => (
                <View key={scenario.id} className="w-[47%]">
                  <ScenarioCard index={index} onPress={() => openScenario(scenario.id)} scenario={scenario} visited={visited[scenario.id]} />
                </View>
              ))}
            </View>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
