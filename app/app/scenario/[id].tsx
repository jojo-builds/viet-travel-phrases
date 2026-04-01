import { useLocalSearchParams } from 'expo-router';
import { FlatList, View } from 'react-native';
import { PhraseCard } from '../../components/PhraseCard';
import { ThemedText } from '../../components/ui/ThemedText';
import { scenarioMap } from '../../content/scenarios';

export default function ScenarioScreen() {
  const { id } = useLocalSearchParams<{ id?: string }>();
  const scenario = id ? scenarioMap[id] : undefined;

  if (!scenario) {
    return (
      <View className="flex-1 items-center justify-center bg-background px-5">
        <ThemedText variant="title" className="text-center text-2xl">
          Scenario not found
        </ThemedText>
        <ThemedText className="mt-3 text-center">
          The phrase list for this route is missing or invalid.
        </ThemedText>
      </View>
    );
  }

  return (
    <FlatList
      className="flex-1 bg-background"
      contentContainerClassName="gap-4 px-5 pb-10 pt-16"
      data={scenario.phrases}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => <PhraseCard phrase={item} />}
      ListHeaderComponent={
        <View className="mb-2 space-y-3">
          <ThemedText variant="title">{scenario.name}</ThemedText>
          <ThemedText>{scenario.tip}</ThemedText>
        </View>
      }
    />
  );
}
