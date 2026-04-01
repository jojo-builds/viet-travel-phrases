import { Pressable, View } from 'react-native';
import { Scenario } from '../content/types';
import { ThemedText } from './ui/ThemedText';

type Props = { scenario: Scenario; onPress: () => void; visited?: boolean; index?: number };

export function ScenarioCard({ scenario, onPress, visited = false, index = 0 }: Props) {
  return (
    <View>
      <Pressable
        accessibilityLabel={`${scenario.name}, ${scenario.phrases.length} phrases`}
        accessibilityRole="button"
        onPress={onPress}
        style={({ pressed }) => [{ transform: [{ scale: pressed ? 0.97 : 1 }] }, { opacity: pressed ? 0.92 : 1 }]}
        className="flex-1 rounded-2xl border border-border bg-surface p-4 shadow-sm"
      >
        <View className="space-y-3">
          <View className="flex-row items-center justify-between">
            <ThemedText accessibilityLabel={`${scenario.name} emoji`} accessibilityRole="image" className="text-3xl">{scenario.emoji}</ThemedText>
            {visited ? <View className="h-2.5 w-2.5 rounded-full bg-success" /> : null}
          </View>
          <ThemedText variant="subtitle">{scenario.name}</ThemedText>
          <ThemedText variant="caption">{scenario.description}</ThemedText>
          <ThemedText variant="caption">{scenario.phrases.length} phrases</ThemedText>
        </View>
      </Pressable>
    </View>
  );
}
