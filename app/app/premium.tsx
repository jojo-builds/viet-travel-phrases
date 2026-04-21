import { Alert, Pressable, ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { router } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import { currentApp } from '../family/currentApp';
import {
  getAccessibleVisibleEntryCountForPack,
  getAccessibleVisibleEntryCountForScenario,
} from '../lib/contentAccess';
import { usePremiumAccess } from '../lib/premiumAccess';
import { getPremiumActionAlert, getPremiumStoreStatusMessage } from '../lib/premiumStoreMessages';
import { LibraryCategoryCard } from '../components/home/LibraryCategoryCard';
import { ThemedText } from '../components/ui/ThemedText';

type ResolvedCategory = (typeof currentApp.presentation.premium.categories)[number] & {
  livePhraseCount: number;
  starterVisibleCount: number;
  fullVisibleCount: number;
};

export default function PremiumScreen() {
  const premium = currentApp.presentation.premium;
  const {
    clearPreviewUnlock,
    enablePreviewUnlock,
    isBusy,
    isLoaded,
    isUnlocked,
    priceLabel,
    purchase,
    restore,
    restoreReady,
    source,
    storeReady,
    storeStatus,
  } = usePremiumAccess();

  const categories: ResolvedCategory[] = premium.categories.map((category) => {
    const starterCount = category.scenarioId
      ? getAccessibleVisibleEntryCountForScenario(currentApp.pack, category.scenarioId, false)
      : category.starterPhraseTarget;
    const fullCount = category.scenarioId
      ? getAccessibleVisibleEntryCountForScenario(currentApp.pack, category.scenarioId, true)
      : category.totalPhraseTarget;

    return {
      ...category,
      starterVisibleCount: starterCount,
      fullVisibleCount: fullCount,
      livePhraseCount: isUnlocked ? fullCount : starterCount,
    };
  });

  const priorityOrder = new Map(premium.featuredCategoryIds.map((id, index) => [id, index]));
  const liveCategories = categories
    .filter((category) => category.availability === 'live')
    .sort(
      (left, right) =>
        (priorityOrder.get(left.id) ?? Number.MAX_SAFE_INTEGER) -
        (priorityOrder.get(right.id) ?? Number.MAX_SAFE_INTEGER),
    );
  const plannedCategories = categories.filter((category) => category.availability === 'planned');
  const starterVisibleCount = getAccessibleVisibleEntryCountForPack(currentApp.pack, false);
  const fullVisibleCount = getAccessibleVisibleEntryCountForPack(currentApp.pack, true);
  const premiumVisibleCount = fullVisibleCount - starterVisibleCount;
  const premiumPhrases = currentApp.pack.phrases.filter((phrase) => phrase.accessTier === 'premium');
  const premiumAudioReadyCount = premiumPhrases.filter((phrase) => currentApp.audio.hasAudio(phrase.audioKey)).length;
  const premiumAudioPlannedCount = premiumPhrases.filter(
    (phrase) => phrase.audioStatus === 'planned' && !currentApp.audio.hasAudio(phrase.audioKey),
  ).length;
  const primaryButtonLabel = isUnlocked
    ? premium.statusUnlockedLabel
    : storeReady
      ? `Unlock for ${priceLabel}`
      : premium.storeUnavailableTitle;
  const storeStatusMessage = getPremiumStoreStatusMessage(storeStatus);

  const handlePurchase = async () => {
    const result = await purchase();
    const alertCopy = getPremiumActionAlert(result);

    if (alertCopy) {
      Alert.alert(alertCopy.title, alertCopy.message);
    }
  };

  const handleRestore = async () => {
    const result = await restore();

    if (result.ok) {
      Alert.alert(premium.restoredAlertTitle, premium.restoredAlertBody);
      return;
    }

    const alertCopy = getPremiumActionAlert(result);
    if (alertCopy) {
      Alert.alert(alertCopy.title, alertCopy.message);
    }
  };

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <ScrollView className="flex-1" contentContainerClassName="gap-6 px-5 pb-28 pt-8">
        <View className="flex-row items-center justify-between">
          <Pressable
            accessibilityLabel="Go back"
            onPress={() => router.back()}
            className="h-11 w-11 items-center justify-center rounded-full bg-surface"
            style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
          >
            <Ionicons name="chevron-back" size={22} color="#1F2937" />
          </Pressable>
          <View className="rounded-full bg-premium-soft px-3 py-2">
            <ThemedText variant="label" className="text-premium">
              {isUnlocked ? premium.statusUnlockedLabel : premium.statusLockedLabel}
            </ThemedText>
          </View>
        </View>

        <View className="rounded-[32px] border border-border bg-surface p-5 shadow-sm">
          <ThemedText variant="label" className="text-premium">
            {premium.unlockModelLabel}
          </ThemedText>
          <ThemedText variant="title" className="mt-2">
            {isUnlocked ? 'Full Trip Pack is unlocked' : premium.screenTitle}
          </ThemedText>
          <ThemedText className="mt-3">
            {isUnlocked ? 'You now have the extra follow-up phrases across the app.' : premium.screenBody}
          </ThemedText>
          {!isUnlocked ? (
            <ThemedText variant="caption" className="mt-3 text-text-secondary">
              Today it adds {premiumVisibleCount} more phrase cards across the same {liveCategories.length} travel situations.
            </ThemedText>
          ) : null}

          <View className="mt-5 rounded-3xl bg-background px-4 py-4">
            <ThemedText variant="label" className="text-primary">
              Free = get by
            </ThemedText>
            <ThemedText className="mt-2">
              Full Trip Pack = do not get stuck. It keeps the same travel situations and opens deeper follow-up,
              repair, and recovery phrases inside them.
            </ThemedText>
          </View>

          <View className="mt-5 flex-row flex-wrap gap-3">
            <View className="rounded-2xl bg-surface-soft px-4 py-3">
              <ThemedText variant="label">Free</ThemedText>
              <ThemedText variant="stat" className="mt-1">
                {starterVisibleCount}
              </ThemedText>
            </View>
            <View className="rounded-2xl bg-premium-soft px-4 py-3">
              <ThemedText variant="label">Adds</ThemedText>
              <ThemedText variant="stat" className="mt-1">
                {premiumVisibleCount}
              </ThemedText>
            </View>
            <View className="rounded-2xl bg-accent-soft px-4 py-3">
              <ThemedText variant="label">Total</ThemedText>
              <ThemedText variant="stat" className="mt-1">
                {fullVisibleCount}
              </ThemedText>
            </View>
          </View>

          <View className="mt-5 rounded-3xl bg-premium-soft px-4 py-4">
            <ThemedText variant="label" className="text-premium">
              What changes after unlock
            </ThemedText>
            <ThemedText className="mt-2">
              Nothing moves. You keep using the same travel situations, with more follow-up phrases inside them.
            </ThemedText>
            {premiumAudioPlannedCount > 0 ? (
              <ThemedText variant="caption" className="mt-4 text-premium">
                Some added phrases are text-only for now.
              </ThemedText>
            ) : (
              <ThemedText variant="caption" className="mt-4 text-premium">
                Added phrases that are live today include audio.
              </ThemedText>
            )}
          </View>

          <View className="mt-5 gap-3">
            <Pressable
              accessibilityLabel={premium.unlockButtonLabel}
              disabled={!isLoaded || isBusy || isUnlocked || !storeReady}
              onPress={() => void handlePurchase()}
              style={({ pressed }) => [{ opacity: pressed ? 0.85 : 1 }]}
              className={`items-center rounded-2xl px-4 py-4 ${isUnlocked ? 'bg-premium' : storeReady ? 'bg-primary' : 'bg-border'} ${!isLoaded || isBusy || (!storeReady && !isUnlocked) ? 'opacity-60' : ''}`}
            >
              <ThemedText className={`font-semibold ${storeReady || isUnlocked ? 'text-white' : 'text-caption'}`}>
                {primaryButtonLabel}
              </ThemedText>
            </Pressable>
            {restoreReady ? (
              <Pressable
                accessibilityLabel={premium.restoreButtonLabel}
                disabled={isBusy}
                onPress={() => void handleRestore()}
                style={({ pressed }) => [{ opacity: pressed ? 0.78 : 1 }]}
                className={`items-center rounded-2xl border border-border bg-surface-soft px-4 py-4 ${isBusy ? 'opacity-60' : ''}`}
              >
                <ThemedText className="font-semibold text-text-primary">{premium.restoreButtonLabel}</ThemedText>
              </Pressable>
            ) : null}
            {__DEV__ && !storeReady ? (
              <Pressable
                accessibilityLabel={source === 'preview' ? premium.previewDisableLabel : premium.previewEnableLabel}
                disabled={isBusy}
                onPress={() => void (source === 'preview' ? clearPreviewUnlock() : enablePreviewUnlock())}
                style={({ pressed }) => [{ opacity: pressed ? 0.78 : 1 }]}
                className="items-center rounded-2xl border border-premium bg-premium-soft px-4 py-4"
              >
                <ThemedText className="font-semibold text-premium">
                  {source === 'preview' ? premium.previewDisableLabel : premium.previewEnableLabel}
                </ThemedText>
              </Pressable>
            ) : null}
          </View>

          {storeStatusMessage ? (
            <ThemedText variant="caption" className="mt-4 text-premium">
              {storeStatusMessage}
            </ThemedText>
          ) : (
            <ThemedText variant="caption" className="mt-4 text-premium">
              Buy and restore only work when this build can reach the App Store.
            </ThemedText>
          )}
          {!storeReady ? (
            <ThemedText variant="caption" className="mt-2 text-premium">
              For the next real purchase test, this build still depends on the App Store item being ready in App Store
              Connect and a supported iPhone purchase session.
            </ThemedText>
          ) : null}

          <ThemedText variant="caption" className="mt-4 text-premium">
            One-time purchase. No subscription.
          </ThemedText>

          {source === 'preview' ? (
            <ThemedText variant="caption" className="mt-4 text-premium">
              Preview unlock is enabled on this device. It is not a real App Store purchase.
            </ThemedText>
          ) : null}
        </View>

        <View className="rounded-3xl border border-border bg-surface p-5 shadow-sm">
          <ThemedText variant="subtitle">{premium.manageTitle}</ThemedText>
          <ThemedText className="mt-2">{premium.manageBody}</ThemedText>
          <View className="mt-4 gap-3">
            {premium.benefits.map((benefit) => (
              <View key={benefit} className="flex-row items-start gap-3">
                <Ionicons name="checkmark-circle" size={18} color="#1F6F78" style={{ marginTop: 2 }} />
                <ThemedText className="flex-1">{benefit}</ThemedText>
              </View>
            ))}
          </View>
        </View>

        <View className="space-y-4">
          <View className="space-y-1">
            <ThemedText variant="subtitle">{premium.liveSectionTitle}</ThemedText>
            <ThemedText>{premium.liveSectionBody}</ThemedText>
          </View>
          <ScrollView horizontal showsHorizontalScrollIndicator={false}>
            <View className="flex-row gap-4 pb-1">
              {liveCategories.map((category) => (
                <LibraryCategoryCard
                  key={category.id}
                  accessLabel={premium.includedBadgeLabel}
                  availabilityLabel={premium.liveNowBadgeLabel}
                  compact={false}
                  description={category.description}
                  emoji={category.emoji}
                  fullVisibleCount={category.fullVisibleCount}
                  highlights={category.highlights}
                  isPremiumUnlocked={isUnlocked}
                  livePhraseCount={category.livePhraseCount}
                  onPress={category.scenarioId ? () => router.push(`/scenario/${category.scenarioId}`) : undefined}
                  starterPhraseTarget={category.starterPhraseTarget}
                  starterVisibleCount={category.starterVisibleCount}
                  title={category.title}
                  totalPhraseTarget={category.totalPhraseTarget}
                />
              ))}
            </View>
          </ScrollView>
        </View>

        {plannedCategories.length ? (
          <View className="space-y-4">
            <View className="space-y-1">
              <ThemedText variant="subtitle">{premium.plannedSectionTitle}</ThemedText>
              <ThemedText>{premium.plannedSectionBody}</ThemedText>
            </View>
            <View className="gap-4">
              {plannedCategories.map((category) => (
                <LibraryCategoryCard
                  key={category.id}
                  accessLabel={premium.premiumOnlyBadgeLabel}
                  availabilityLabel={premium.plannedBadgeLabel}
                  compact={false}
                  description={category.description}
                  emoji={category.emoji}
                  fullVisibleCount={category.fullVisibleCount}
                  highlights={category.highlights}
                  isPremiumUnlocked={isUnlocked}
                  livePhraseCount={category.livePhraseCount}
                  starterPhraseTarget={category.starterPhraseTarget}
                  starterVisibleCount={category.starterVisibleCount}
                  title={category.title}
                  totalPhraseTarget={category.totalPhraseTarget}
                />
              ))}
            </View>
          </View>
        ) : null}
      </ScrollView>
    </SafeAreaView>
  );
}
