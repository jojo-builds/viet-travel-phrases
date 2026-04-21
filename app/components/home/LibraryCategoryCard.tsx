import { Pressable, View } from 'react-native';
import * as Haptics from 'expo-haptics';
import Ionicons from '@expo/vector-icons/Ionicons';
import { ThemedText } from '../ui/ThemedText';

type Props = {
  title: string;
  emoji: string;
  description: string;
  accessLabel: string;
  availabilityLabel: string;
  livePhraseCount: number;
  starterPhraseTarget: number;
  totalPhraseTarget: number;
  starterVisibleCount?: number;
  fullVisibleCount?: number;
  highlights: string[];
  visited?: boolean;
  compact?: boolean;
  isPremiumUnlocked?: boolean;
  onPress?: () => void;
};

export function LibraryCategoryCard({
  title,
  emoji,
  description,
  accessLabel,
  availabilityLabel,
  livePhraseCount: _livePhraseCount,
  starterPhraseTarget,
  totalPhraseTarget,
  starterVisibleCount,
  fullVisibleCount,
  highlights,
  visited = false,
  compact = false,
  isPremiumUnlocked: _isPremiumUnlocked = false,
  onPress,
}: Props) {
  const normalizedAvailability = availabilityLabel.toLowerCase();
  const isPlanned = normalizedAvailability.includes('planned') || normalizedAvailability.includes('coming');
  const isInteractive = Boolean(onPress);
  const visibleHighlights = highlights.slice(0, compact ? 2 : 3);
  const starterCount = starterVisibleCount ?? starterPhraseTarget;
  const fullCount = fullVisibleCount ?? totalPhraseTarget;
  const unlockAddsCount = Math.max(fullCount - starterCount, 0);
  const showBadgeRow = !compact || isPlanned;
  const summaryText = isPlanned
    ? 'More phrases are planned for this situation.'
    : unlockAddsCount > 0
      ? 'Free covers the basics. Full Trip Pack adds more follow-up phrases in this situation.'
      : 'Ready to use now in this situation.';

  return (
    <Pressable
      accessibilityLabel={`${title}, ${availabilityLabel}`}
      accessibilityRole={isInteractive ? 'button' : undefined}
      disabled={!isInteractive}
      onPress={() => {
        if (!onPress) {
          return;
        }

        void Haptics.selectionAsync();
        onPress();
      }}
      style={({ pressed }) => [{ opacity: pressed ? 0.92 : 1 }, { transform: [{ scale: isInteractive && pressed ? 0.985 : 1 }] }]}
      className={`rounded-[30px] border p-4 shadow-sm ${compact ? 'min-h-[208px]' : 'min-h-[270px] w-[300px]'} ${isPlanned ? 'border-premium bg-premium-soft' : 'border-border bg-surface'}`}
    >
      <View className="flex-row items-start justify-between gap-3">
        <View className={`h-12 w-12 items-center justify-center rounded-2xl ${isPlanned ? 'bg-white' : 'bg-accent-soft'}`}>
          <ThemedText className="text-2xl">{emoji}</ThemedText>
        </View>
        {visited ? (
          <View className="mt-2 h-2.5 w-2.5 rounded-full bg-success" />
        ) : !isInteractive && isPlanned ? (
          <View className="rounded-full bg-white px-3 py-1">
            <ThemedText variant="label" className="text-premium">
              Planned next
            </ThemedText>
          </View>
        ) : null}
      </View>

      <ThemedText variant="subtitle" className="mt-4">
        {title}
      </ThemedText>
      <ThemedText className="mt-2" numberOfLines={compact ? 3 : 4}>
        {description}
      </ThemedText>

      {showBadgeRow ? (
        <View className="mt-4 flex-row flex-wrap gap-2">
          <View className={`rounded-full px-3 py-1 ${isPlanned ? 'bg-white' : 'bg-surface-soft'}`}>
            <ThemedText variant="label" className={isPlanned ? 'text-premium' : ''}>
              {accessLabel}
            </ThemedText>
          </View>
          <View className={`rounded-full px-3 py-1 ${isPlanned ? 'bg-white' : 'bg-surface-soft'}`}>
            <ThemedText variant="label" className={isPlanned ? 'text-premium' : ''}>
              {availabilityLabel}
            </ThemedText>
          </View>
        </View>
      ) : null}

      {compact ? (
        <View className="mt-4 gap-3">
          <ThemedText variant="caption" className={`font-semibold ${isPlanned ? 'text-premium' : 'text-primary'}`}>
            {summaryText}
          </ThemedText>
          <View className="flex-row flex-wrap gap-2">
            {visibleHighlights.map((highlight) => (
              <View key={highlight} className={`rounded-full px-3 py-1 ${isPlanned ? 'bg-white' : 'bg-surface-soft'}`}>
                <ThemedText variant="caption" className={isPlanned ? 'text-premium' : ''}>
                  {highlight}
                </ThemedText>
              </View>
            ))}
          </View>
        </View>
      ) : (
        <View className="mt-4 gap-3">
          <ThemedText variant="caption" className={`font-semibold ${isPlanned ? 'text-premium' : 'text-primary'}`}>
            {summaryText}
          </ThemedText>
          <View className="flex-row flex-wrap gap-2">
            {visibleHighlights.map((highlight) => (
              <View key={highlight} className={`rounded-full px-3 py-1 ${isPlanned ? 'bg-white' : 'bg-surface-soft'}`}>
                <ThemedText variant="caption" className={isPlanned ? 'text-premium' : ''}>
                  {highlight}
                </ThemedText>
              </View>
            ))}
          </View>
        </View>
      )}

      <View className="mt-auto flex-row items-center justify-between pt-4">
        <ThemedText variant="caption" className={`font-semibold ${isPlanned ? 'text-premium' : 'text-primary'}`}>
          {!isInteractive && isPlanned ? 'Coming later' : 'Open situation'}
        </ThemedText>
        <Ionicons
          name={!isInteractive && isPlanned ? 'time-outline' : isPlanned ? 'sparkles-outline' : 'arrow-forward'}
          size={18}
          color={!isInteractive && isPlanned ? '#1F6F78' : isPlanned ? '#1F6F78' : '#D97745'}
        />
      </View>
    </Pressable>
  );
}
