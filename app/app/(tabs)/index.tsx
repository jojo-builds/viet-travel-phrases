import { router } from 'expo-router';
import * as Haptics from 'expo-haptics';
import { Pressable, ScrollView, View } from 'react-native';
import { ScenarioCard } from '../../components/ScenarioCard';
import { ThemedText } from '../../components/ui/ThemedText';
import { quickPhrases, scenarios } from '../../content/scenarios';

export default function HomeScreen() {
  return (
    <ScrollView className="flex-1 bg-background" contentContainerClassName="px-5 pb-10 pt-16">
      <View className="space-y-8">
        <View className="space-y-3">
          <ThemedText variant="title">Vietnamese Travel Phrasebook</ThemedText>
          <ThemedText>
            Quick essentials for cafés, taxis, markets, hotels, and everyday travel moments.
          </ThemedText>
        </View>

        <View className="space-y-4">
          <ThemedText variant="subtitle">Quick Phrases</ThemedText>
          <ScrollView horizontal showsHorizontalScrollIndicator={false}>
            <View className="flex-row gap-3">
              {quickPhrases.map((phrase) => (
                <Pressable
                  key={phrase.id}
                  onPress={() => void Haptics.selectionAsync()}
                  className="rounded-xl bg-surface px-4 py-3 shadow-sm"
                >
                  <ThemedText variant="romanized" className="text-sm">
                    {phrase.vietnamese}
                  </ThemedText>
                </Pressable>
              ))}
            </View>
          </ScrollView>
        </View>

        <View className="space-y-4">
          <ThemedText variant="subtitle">Scenarios</ThemedText>
          <View className="flex-row flex-wrap gap-4">
            {scenarios.map((scenario) => (
              <View key={scenario.id} className="w-[47%]">
                <ScenarioCard scenario={scenario} onPress={() => router.push(`/scenario/${scenario.id}`)} />
              </View>
            ))}
          </View>
        </View>
      </View>
    </ScrollView>
  );
}
