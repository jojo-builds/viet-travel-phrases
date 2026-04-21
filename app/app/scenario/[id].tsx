import { useEffect } from 'react';
import { Pressable, ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Stack, router, useLocalSearchParams } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import { AudioPlayButton } from '../../components/AudioPlayButton';
import { PhraseCard } from '../../components/PhraseCard';
import { SaveButton } from '../../components/SaveButton';
import { ThemedText } from '../../components/ui/ThemedText';
import { currentApp } from '../../family/currentApp';
import {
  getAccessibleIntentFamilies,
} from '../../lib/contentAccess';
import { useDesignReview } from '../../lib/designReview';
import { usePremiumAccess } from '../../lib/premiumAccess';

function BackButton() {
  return (
    <Pressable
      accessibilityLabel="Go back"
      onPress={() => router.back()}
      className="h-11 w-11 items-center justify-center rounded-full bg-surface"
      style={({ pressed }) => [{ opacity: pressed ? 0.6 : 1 }]}
      testID="scenario-back-button"
    >
      <Ionicons name="chevron-back" size={22} color="#1F2937" />
    </Pressable>
  );
}

function getWarningLabel(warningNoteType?: string) {
  if (!warningNoteType) {
    return null;
  }

  return (
    {
      formal: 'Formal',
      bookish: 'Bookish',
      'harder-to-say': 'Harder to say',
      'recognition-only': 'You may hear this',
    }[warningNoteType] || warningNoteType.replace(/-/g, ' ')
  );
}

export default function ScenarioScreen() {
  const { id } = useLocalSearchParams<{ id?: string }>();
  const designReview = useDesignReview();
  const { isUnlocked } = usePremiumAccess();
  const scenario = id ? currentApp.pack.scenarioMap[id] : undefined;
  const scenarioCopy = currentApp.presentation.scenario;
  const premium = currentApp.presentation.premium;
  const accessibleFamilies = scenario ? getAccessibleIntentFamilies(scenario, isUnlocked) : [];
  const starterVisibleCount = scenario
    ? scenario.intentFamilies.filter((family) => family.accessTier === 'starter').length
    : 0;
  const totalVisibleCount = scenario?.intentFamilies.length ?? 0;
  const lockedFamilies =
    scenario && !isUnlocked
      ? scenario.intentFamilies.filter((family) => !accessibleFamilies.some((accessibleFamily) => accessibleFamily.id === family.id))
      : [];
  const scenarioAudioReadyCount = scenario
    ? scenario.phrases.filter((phrase) => currentApp.audio.hasAudio(phrase.audioKey)).length
    : 0;
  const lockedPremiumPhrases = lockedFamilies.flatMap((family) =>
    family.phraseIds
      .map((phraseId) => currentApp.pack.phraseMap[phraseId])
      .filter((phrase): phrase is NonNullable<typeof phrase> => Boolean(phrase)),
  );
  const premiumAudioReadyCount = lockedPremiumPhrases.filter((phrase) => currentApp.audio.hasAudio(phrase.audioKey)).length;
  const premiumAudioPlannedCount = lockedPremiumPhrases.filter(
    (phrase) => phrase.audioStatus === 'planned' && !currentApp.audio.hasAudio(phrase.audioKey),
  ).length;

  useEffect(() => {
    if (!scenario) {
      return;
    }

    if (designReview.isEnabled) {
      designReview.markScenarioVisited(scenario.id);
      return;
    }

    void currentApp.storage.markScenarioVisited(scenario.id);
  }, [designReview, scenario]);

  if (!scenario) {
    return (
      <SafeAreaView className="flex-1 bg-background px-5" edges={['top', 'bottom']}>
        <View className="flex-row items-center gap-3 pt-6">
          <BackButton />
          <ThemedText variant="subtitle">{scenarioCopy.notFoundTitle}</ThemedText>
        </View>
        <View className="flex-1 items-center justify-center">
          <ThemedText className="text-center">{scenarioCopy.notFoundBody}</ThemedText>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <Stack.Screen options={{ headerShown: false }} />
      <ScrollView className="flex-1" contentContainerClassName="gap-6 px-5 pb-28 pt-8" testID="scenario-phrases-list">
        <View className="space-y-4" testID="scenario-screen">
          <View className="flex-row items-start gap-3" testID="scenario-header">
            <BackButton />
            <View className="h-14 w-14 items-center justify-center rounded-2xl bg-accent-soft">
              <ThemedText className="text-3xl">{scenario.emoji}</ThemedText>
            </View>
            <View className="flex-1">
              <ThemedText variant="title" className="text-[26px] leading-[32px]">
                {scenario.name}
              </ThemedText>
              <ThemedText className="mt-1">{scenario.description}</ThemedText>
            </View>
          </View>

          <View className="flex-row items-start gap-3 rounded-3xl bg-surface px-4 py-4 shadow-sm" testID="scenario-tip">
            <Ionicons
              name={scenarioCopy.tipIcon as keyof typeof Ionicons.glyphMap}
              size={20}
              color="#D97745"
              style={{ marginTop: 2 }}
            />
            <View className="flex-1">
              <ThemedText variant="label" className="text-primary">
                Tip
              </ThemedText>
              <ThemedText variant="caption" className="mt-2 text-[14px] leading-6">
                {scenario.tip || scenarioCopy.tipFallback}
              </ThemedText>
            </View>
          </View>

          <View className="flex-row flex-wrap gap-2">
            <View className="rounded-full bg-accent-soft px-3 py-2">
              <ThemedText variant="label" className="text-primary">
                {isUnlocked ? `${totalVisibleCount} live phrase groups` : `${starterVisibleCount} free now`}
              </ThemedText>
            </View>
            {!isUnlocked && lockedFamilies.length > 0 ? (
              <View className="rounded-full bg-premium-soft px-3 py-2">
                <ThemedText variant="label" className="text-premium">
                  +{lockedFamilies.length} more with Full Trip Pack
                </ThemedText>
              </View>
            ) : null}
            <View className="rounded-full bg-surface px-3 py-2">
              <ThemedText variant="label">
                Audio on {scenarioAudioReadyCount === scenario.phrases.length ? 'all ' : ''}{scenarioAudioReadyCount} live lines
              </ThemedText>
            </View>
          </View>

        </View>

        <View className="gap-6">
          {accessibleFamilies.map((family, index) => {
            const familyPhrases = family.phraseIds
              .map((phraseId) => currentApp.pack.phraseMap[phraseId])
              .filter((phrase) => phrase && (isUnlocked || phrase.accessTier === 'starter'));
            const [primaryPhrase, ...variantPhrases] = familyPhrases;

            if (!primaryPhrase) {
              return null;
            }

            return (
              <View key={family.id} className="gap-3">
                <View className="border-l-4 border-primary pl-4 pr-1 py-1">
                  <View className="flex-row items-start justify-between gap-3">
                    <View className="flex-1">
                      <ThemedText variant="subtitle">{family.title}</ThemedText>
                    </View>
                    {variantPhrases.length ? (
                      <View className="rounded-full bg-surface px-3 py-2">
                        <ThemedText variant="caption" className="font-semibold text-text-secondary">
                          {variantPhrases.length} more ways
                        </ThemedText>
                      </View>
                    ) : null}
                  </View>
                </View>

                <PhraseCard phrase={primaryPhrase} />

                {variantPhrases.length ? (
                  <View className="gap-3 rounded-[28px] border border-border bg-background px-4 py-4">
                    <View className="flex-row items-start justify-between gap-3">
                      <View className="flex-1">
                        <ThemedText variant="label" className="text-primary">
                          Other ways to say it
                        </ThemedText>
                        <ThemedText className="mt-2">
                          Try one of these if the first version does not fit.
                        </ThemedText>
                      </View>
                      <View className="rounded-full bg-surface px-3 py-2">
                        <ThemedText variant="caption" className="font-semibold text-text-secondary">
                          {variantPhrases.length} more ways
                        </ThemedText>
                      </View>
                    </View>

                    {variantPhrases.map((phrase) => {
                      const canPlayAudio =
                        currentApp.presentation.capabilities.audio && currentApp.audio.hasAudio(phrase.audioKey);
                      const usageNote = phrase.usageNote ?? phrase.context;
                      const audioLabel = canPlayAudio ? null : currentApp.presentation.phrase.audioUnavailableLabel;

                      return (
                        <View key={phrase.id} className="rounded-2xl border border-border bg-surface px-4 py-4 shadow-sm">
                          <View className="flex-row items-start justify-between gap-3">
                            <View className="flex-1">
                              <View className="flex-row flex-wrap gap-2">
                                <View className="rounded-full bg-surface-soft px-3 py-1">
                                  <ThemedText variant="label">{phrase.variantLabel || 'Another way'}</ThemedText>
                                </View>
                                {audioLabel ? (
                                  <View className="rounded-full bg-background px-3 py-1">
                                    <ThemedText variant="label" className="text-text-secondary">
                                      {audioLabel}
                                    </ThemedText>
                                  </View>
                                ) : null}
                                {getWarningLabel(phrase.warningNoteType) ? (
                                  <View className="rounded-full bg-surface-soft px-3 py-1">
                                    <ThemedText variant="label">{getWarningLabel(phrase.warningNoteType)}</ThemedText>
                                  </View>
                                ) : null}
                              </View>

                              <ThemedText variant="target" className="mt-3 text-[22px] leading-[28px]">
                                {phrase.targetText}
                              </ThemedText>
                              {phrase.pronunciation ? (
                                <ThemedText variant="pronunciation" className="mt-2">
                                  {phrase.pronunciation}
                                </ThemedText>
                              ) : null}
                              <ThemedText variant="source" className="mt-2">
                                {phrase.sourceText}
                              </ThemedText>
                              {usageNote ? (
                                <View className="mt-3 rounded-2xl bg-background px-4 py-3">
                                  <ThemedText variant="caption">{usageNote}</ThemedText>
                                </View>
                              ) : null}
                            </View>

                            <View className="flex-row items-center gap-2">
                              {canPlayAudio ? <AudioPlayButton audioKey={phrase.audioKey} size={44} tone="subtle" /> : null}
                              <SaveButton phraseId={phrase.id} size={44} tone="subtle" />
                            </View>
                          </View>
                        </View>
                      );
                    })}
                  </View>
                ) : null}

                {index === 0 && !isUnlocked && lockedFamilies.length > 0 ? (
                  <View className="rounded-[30px] border border-premium bg-premium-soft px-4 py-4">
                    <ThemedText variant="label" className="text-premium">
                      {premium.scenarioPreviewTitle}
                    </ThemedText>
                    <ThemedText variant="subtitle" className="mt-2">
                      Extra help in this situation
                    </ThemedText>
                    <ThemedText className="mt-2">{premium.scenarioPreviewBody}</ThemedText>

                    {lockedFamilies.length ? (
                      <View className="mt-4 gap-2">
                        {lockedFamilies.slice(0, 3).map((lockedFamily) => (
                          <View key={lockedFamily.id} className="rounded-2xl bg-white px-4 py-3">
                            <ThemedText variant="caption" className="font-semibold text-premium">
                              {lockedFamily.title}
                            </ThemedText>
                          </View>
                        ))}
                        {lockedFamilies.length > 3 ? (
                          <ThemedText variant="caption" className="text-premium">
                            +{lockedFamilies.length - 3} more in this situation.
                          </ThemedText>
                        ) : null}
                      </View>
                    ) : null}

                    {premiumAudioPlannedCount > 0 ? (
                      <ThemedText variant="caption" className="mt-4 text-premium">
                        Some added phrases here are text-only for now.
                      </ThemedText>
                    ) : null}
                    {premiumAudioReadyCount > 0 && premiumAudioPlannedCount === 0 ? (
                      <ThemedText variant="caption" className="mt-4 text-premium">
                        Added phrases in this situation include audio.
                      </ThemedText>
                    ) : null}

                    <Pressable
                      accessibilityLabel={premium.teaserButtonLabel}
                      onPress={() => router.push('/premium')}
                      style={({ pressed }) => [{ opacity: pressed ? 0.82 : 1 }]}
                      className="mt-4 self-start rounded-2xl bg-premium px-4 py-3"
                    >
                      <ThemedText className="font-semibold text-white">{premium.teaserButtonLabel}</ThemedText>
                    </Pressable>
                  </View>
                ) : null}
              </View>
            );
          })}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
