import { Pressable, View } from 'react-native';
import * as Haptics from 'expo-haptics';
import { ThemedText } from '../ui/ThemedText';

type Props = {
  title: string;
  emoji: string;
  description: string;
  highlights: string[];
  starterVisibleCount: number;
  fullVisibleCount: number;
  isPremiumUnlocked: boolean;
  onPress: () => void;
};

export function PrioritySituationCard({
  title,
  emoji,
  description,
  highlights,
  starterVisibleCount,
  fullVisibleCount,
  isPremiumUnlocked,
  onPress,
}: Props) {
  const unlockAddsCount = Math.max(fullVisibleCount - starterVisibleCount, 0);

  return (
    <Pressable
      accessibilityLabel={`${title}, open situation`}
      accessibilityRole="button"
      onPress={() => {
        void Haptics.selectionAsync();
        onPress();
      }}
      style={({ pressed }) => [{ opacity: pressed ? 0.92 : 1 }, { transform: [{ scale: pressed ? 0.985 : 1 }] }]}
      className="min-h-[184px] rounded-[26px] border border-border bg-surface p-4 shadow-sm"
    >
      <View className="flex-row items-start justify-between gap-3">
        <View className="h-12 w-12 items-center justify-center rounded-2xl bg-accent-soft">
          <ThemedText className="text-2xl">{emoji}</ThemedText>
        </View>
        <View className="rounded-full bg-surface-soft px-3 py-1">
          <ThemedText variant="label" className="text-primary">
            Situation
          </ThemedText>
        </View>
      </View>

      <ThemedText variant="subtitle" className="mt-4">
        {title}
      </ThemedText>
      <ThemedText className="mt-2" numberOfLines={3}>
        {description}
      </ThemedText>

      <View className="mt-4 flex-row flex-wrap gap-2">
        {highlights.slice(0, 2).map((highlight) => (
          <View key={highlight} className="rounded-full bg-background px-3 py-1">
            <ThemedText variant="caption">{highlight}</ThemedText>
          </View>
        ))}
      </View>

      <View className="mt-auto pt-4">
        <ThemedText variant="caption" className="font-semibold text-primary">
          {isPremiumUnlocked ? `${fullVisibleCount} live phrase groups open now` : `${starterVisibleCount} free now`}
        </ThemedText>
        {!isPremiumUnlocked && unlockAddsCount > 0 ? (
          <ThemedText variant="caption" className="mt-1 text-text-secondary">
            +{unlockAddsCount} more with Full Trip Pack
          </ThemedText>
        ) : null}
      </View>
    </Pressable>
  );
}
