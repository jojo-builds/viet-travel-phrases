import { router, Stack } from 'expo-router';
import { Pressable, ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ThemedText } from '../../components/ui/ThemedText';
import { buildDesignReviewTargetPath, designReviewPresets } from '../../lib/designReviewPresets';

export default function DesignLiveIndex() {
  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <Stack.Screen options={{ headerShown: false }} />
      <ScrollView className="flex-1" contentContainerClassName="gap-4 px-5 pb-20 pt-8">
        <View className="rounded-[32px] border border-border bg-surface px-5 py-5 shadow-sm">
          <ThemedText variant="label" className="text-primary">
            Design live presets
          </ThemedText>
          <ThemedText variant="title" className="mt-2">
            Exact app states for fast visual review
          </ThemedText>
          <ThemedText className="mt-3">
            Each preset redirects into a real app route with just enough design-mode state to make the screen deterministic.
          </ThemedText>
        </View>

        <View className="gap-3">
          {designReviewPresets.map((preset) => {
            const targetPath = buildDesignReviewTargetPath(preset.id);

            return (
              <Pressable
                key={preset.id}
                accessibilityLabel={preset.label}
                className="rounded-[28px] border border-border bg-surface px-4 py-4 shadow-sm"
                onPress={() => {
                  if (targetPath) {
                    router.push(targetPath);
                  }
                }}
                style={({ pressed }) => [{ opacity: pressed ? 0.82 : 1 }]}
              >
                <ThemedText variant="subtitle">{preset.label}</ThemedText>
                <ThemedText className="mt-2">{preset.description}</ThemedText>
                <ThemedText variant="caption" className="mt-3 text-text-secondary">
                  {targetPath}
                </ThemedText>
              </Pressable>
            );
          })}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
