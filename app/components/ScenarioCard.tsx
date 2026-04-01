import { Pressable, View } from 'react-native';
import { ThemedText } from './ui/ThemedText';
import { Scenario } from '../content/types';

type Props = {
  scenario: Scenario;
  onPress: () => void;
};

export function ScenarioCard({ scenario, onPress }: Props) {
  return (
    <Pressable
      onPress={onPress}
      className="flex-1 rounded-2xl border border-border bg-surface p-4 shadow-sm"
    >
      <View className="space-y-3">
        <ThemedText className="text-3xl">{scenario.emoji}</ThemedText>
        <ThemedText variant="subtitle">{scenario.name}</ThemedText>
        <ThemedText variant="caption" numberOfLines={2}>
          {scenario.description}
        </ThemedText>
        <ThemedText variant="caption">{scenario.phrases.length} phrases</ThemedText>
      </View>
    </Pressable>
  );
}
