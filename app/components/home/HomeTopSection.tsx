import { Pressable, View } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { router } from 'expo-router';
import { ThemedText } from '../ui/ThemedText';
import { currentApp } from '../../family/currentApp';

type Props = {
  showResultsTitle: boolean;
  onOpenPremium: () => void;
  isPremiumUnlocked: boolean;
  starterVisibleCount: number;
  fullVisibleCount: number;
  compact?: boolean;
  resultCount?: number;
};

export function HomeTopSection({
  showResultsTitle,
  onOpenPremium,
  isPremiumUnlocked,
  starterVisibleCount,
  fullVisibleCount,
  compact = false,
  resultCount = 0,
}: Props) {
  const home = currentApp.presentation.home;
  const search = currentApp.presentation.search;
  const premium = currentApp.presentation.premium;
  const statusLabel = isPremiumUnlocked ? premium.statusUnlockedLabel : premium.statusLockedLabel;
  const matchesLabel = resultCount === 1 ? '1 phrase' : `${resultCount} phrases`;
  const liveSituationCount = currentApp.pack.scenarios.length;
  const audioReadyCount = currentApp.pack.phrases.filter((phrase) => currentApp.audio.hasAudio(phrase.audioKey)).length;
  const hasAudioForEveryLivePhrase = audioReadyCount === currentApp.pack.phrases.length;

  if (compact) {
    return (
      <View className="space-y-3" testID="home-top-section">
        <View className="flex-row items-center justify-between">
          <Pressable
            accessibilityLabel={premium.teaserButtonLabel}
            onPress={onOpenPremium}
            style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
            className="rounded-full bg-premium-soft px-3 py-2"
          >
            <ThemedText variant="label" className="text-premium">
              {statusLabel}
            </ThemedText>
          </Pressable>
          <Pressable
            accessibilityLabel={home.settingsLabel}
            onPress={() => router.push('/settings')}
            style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
            className="h-11 w-11 items-center justify-center rounded-full bg-surface"
            testID="home-settings-button"
          >
            <Ionicons name="settings-outline" size={22} color="#1F2937" />
          </Pressable>
        </View>

        {showResultsTitle ? (
          <View className="space-y-1" testID="home-results-title">
            <ThemedText variant="subtitle">{search.resultsTitle}</ThemedText>
            <ThemedText variant="caption">{matchesLabel}</ThemedText>
          </View>
        ) : null}
      </View>
    );
  }

  return (
    <View className="space-y-6" testID="home-top-section">
      <View className="flex-row items-center justify-between">
        {home.greeting ? (
          <View className="rounded-full bg-accent-soft px-3 py-2">
            <ThemedText variant="label" className="text-primary">
              {home.greeting}
            </ThemedText>
          </View>
        ) : (
          <View />
        )}
        <View className="flex-row items-center gap-2">
          <Pressable
            accessibilityLabel={premium.teaserButtonLabel}
            onPress={onOpenPremium}
            style={({ pressed }) => [{ opacity: pressed ? 0.72 : 1 }]}
            className="rounded-full bg-premium-soft px-3 py-2"
          >
            <ThemedText variant="label" className="text-premium">
              {statusLabel}
            </ThemedText>
          </Pressable>
          <Pressable
            accessibilityLabel={home.settingsLabel}
            onPress={() => router.push('/settings')}
            style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
            className="h-11 w-11 items-center justify-center rounded-full bg-surface"
            testID="home-settings-button"
          >
            <Ionicons name="settings-outline" size={22} color="#1F2937" />
          </Pressable>
        </View>
      </View>

      <View className="rounded-[32px] border border-border bg-surface p-5 shadow-sm">
        <ThemedText variant="caption" className="font-semibold text-primary">
          {home.subtitle}
        </ThemedText>
        <ThemedText variant="title" className="mt-2">
          {home.heroTitle}
        </ThemedText>
        <ThemedText className="mt-3">{home.heroBody}</ThemedText>

        <View className="mt-4 flex-row flex-wrap gap-2">
          <View className="rounded-full bg-accent-soft px-3 py-2">
            <ThemedText variant="label" className="text-primary">
              {liveSituationCount} situations live
            </ThemedText>
          </View>
          <View className="rounded-full bg-surface-soft px-3 py-2">
            <ThemedText variant="label">{starterVisibleCount} free now</ThemedText>
          </View>
          <View className="rounded-full bg-premium-soft px-3 py-2">
            <ThemedText variant="label" className="text-premium">
              {fullVisibleCount} total in app
            </ThemedText>
          </View>
        </View>

        <ThemedText variant="caption" className="mt-4 text-text-secondary">
          {hasAudioForEveryLivePhrase
            ? `Audio is live for all ${audioReadyCount} current phrase lines in this build.`
            : `Audio is live for ${audioReadyCount} current phrase lines in this build.`}
        </ThemedText>
        <ThemedText variant="caption" className="mt-2 text-primary">
          Free gets you through the moment. Full Trip Pack adds the follow-up phrases when the first line is not enough.
        </ThemedText>
      </View>
    </View>
  );
}
