import { View } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { ThemedText } from '../ui/ThemedText';
import { PreviewCard, PreviewChip, PreviewMiniRow, PreviewShell, PreviewStat } from './PreviewShell';
import { PhraseProductPrototype } from './PhraseProductPrototype';
import { AppPreviewSlideId, previewDeckContent } from './previewContent';

export function AppPreviewSlideView({ slideId }: { slideId: AppPreviewSlideId }) {
  switch (slideId) {
    case 'home':
      return <HomeSlide />;
    case 'phrase':
      return <PhraseSlide />;
    case 'search':
      return <SearchSlide />;
    case 'saved':
      return <SavedSlide />;
    case 'premium':
      return <PremiumSlide />;
  }
}

function HomeSlide() {
  return (
    <PreviewShell
      label="Preview 01"
      title="Travel phrases built around the moment, not a lesson plan."
      body="Lead with live travel situations, honest free-vs-full depth, and a search-first posture for high-friction moments."
      footer={`${previewDeckContent.appName} currently carries ${previewDeckContent.situationCount} live situations, ${previewDeckContent.starterVisibleCount} free phrase cards, and ${previewDeckContent.fullVisibleCount} total cards in app.`}
    >
      <PreviewCard>
        <ThemedText variant="label" className="text-primary">
          Situation-first home
        </ThemedText>
        <ThemedText variant="subtitle" className="mt-2">
          {previewDeckContent.heroTitle}
        </ThemedText>
        <ThemedText className="mt-2">{previewDeckContent.heroBody}</ThemedText>
        <View className="mt-4 flex-row gap-3">
          <PreviewStat label="Live" value={`${previewDeckContent.situationCount}`} tone="warm" />
          <PreviewStat label="Free" value={`${previewDeckContent.starterVisibleCount}`} />
          <PreviewStat label="Total" value={`${previewDeckContent.fullVisibleCount}`} tone="premium" />
        </View>
        <View className="mt-4 flex-row flex-wrap justify-between gap-y-3">
          {previewDeckContent.featuredCategories.map((category) => (
            <View key={category.id} style={{ width: '48%' }} className="rounded-[24px] bg-background px-4 py-4">
              <ThemedText className="text-2xl">{category.emoji}</ThemedText>
              <ThemedText variant="subtitle" className="mt-3 text-[17px] leading-[22px]">
                {category.title}
              </ThemedText>
              <ThemedText variant="caption" className="mt-2">
                {category.starterVisibleCount} free now
              </ThemedText>
            </View>
          ))}
        </View>
      </PreviewCard>
    </PreviewShell>
  );
}

function PhraseSlide() {
  return <PhraseProductPrototype />;
}

function SearchSlide() {
  return (
    <PreviewShell
      label="Preview 03"
      title="Search fast when the moment gets messy."
      body="Show the exact phrase, the situation, and the underlying need together so the traveler can recover from partial memory and punctuation drift."
      footer="This wireframe stays aligned with the current shared search rollout: the query dock remains simple, and the results carry enough context to avoid wrong-tap anxiety."
    >
      <PreviewCard className="gap-3">
        <View className="rounded-[24px] bg-background px-4 py-4">
          <View className="flex-row items-center gap-3">
            <View className="h-10 w-10 items-center justify-center rounded-full bg-surface">
              <Ionicons name="search-outline" size={18} color="#1F2937" />
            </View>
            <View className="flex-1">
              <ThemedText variant="label">Query</ThemedText>
              <ThemedText variant="subtitle" className="mt-1 text-[18px] leading-[22px]">
                wifi
              </ThemedText>
            </View>
            <PreviewChip label={`${previewDeckContent.searchResults.length} matches`} tone="premium" />
          </View>
        </View>
        {previewDeckContent.searchResults.map((result) => (
          <PreviewMiniRow
            key={result.id}
            eyebrow={`${result.scenarioName} • ${result.familyTitle}`}
            title={result.targetText}
            body={result.sourceText}
            trailing={<Ionicons name="arrow-forward-circle-outline" size={22} color="#D97745" />}
          />
        ))}
      </PreviewCard>
    </PreviewShell>
  );
}

function SavedSlide() {
  return (
    <PreviewShell
      label="Preview 04"
      title="Keep the phrases you reach for most one tap away."
      body="Turn favorites into a calm quick-access board for arrivals, payments, repair moments, and other phrases the traveler wants ready without searching again."
      footer="The saved route is also the strongest place to reinforce offline trust: once installed, the app keeps the chosen phrases ready for quick replay and reuse."
    >
      <PreviewCard className="gap-3">
        <View className="flex-row items-center justify-between rounded-[24px] bg-background px-4 py-4">
          <View>
            <ThemedText variant="label" className="text-primary">
              Quick-access favorites
            </ThemedText>
            <ThemedText variant="subtitle" className="mt-2">
              {previewDeckContent.savedItems.length} saved for this trip
            </ThemedText>
          </View>
          <PreviewChip label="Works offline" tone="warm" />
        </View>
        {previewDeckContent.savedItems.map((item) => (
          <PreviewMiniRow
            key={item.id}
            eyebrow={item.scenarioName}
            title={item.targetText}
            body={item.sourceText}
            trailing={<Ionicons name="heart" size={20} color="#D97745" />}
          />
        ))}
      </PreviewCard>
    </PreviewShell>
  );
}

function PremiumSlide() {
  return (
    <PreviewShell
      label="Preview 05"
      title="Free gets you through. Full Trip Pack handles the follow-up."
      body="Explain the one-time unlock honestly: same situations, more recovery depth, no subscription framing, and no fake promise that everything changes after purchase."
      footer={`This route should stay explicit that the unlock is a one-time ${previewDeckContent.priceLabel} purchase and that the live library shape is ${previewDeckContent.starterVisibleCount} free plus ${previewDeckContent.premiumVisibleCount} added phrase cards.`}
      tone="premium"
    >
      <PreviewCard className="gap-4">
        <View className="flex-row gap-3">
          <PreviewStat label="Free" value={`${previewDeckContent.starterVisibleCount}`} />
          <PreviewStat label="Adds" value={`${previewDeckContent.premiumVisibleCount}`} tone="premium" />
          <PreviewStat label="Total" value={`${previewDeckContent.fullVisibleCount}`} tone="warm" />
        </View>
        <View className="rounded-[24px] bg-premium-soft px-4 py-4">
          <ThemedText variant="label" className="text-premium">
            Unlock model
          </ThemedText>
          <ThemedText variant="subtitle" className="mt-2">
            One-time purchase. No subscription.
          </ThemedText>
          <ThemedText className="mt-2">
            Keep the same travel situations and open the deeper repair, payment, and recovery phrases when the first line is not enough.
          </ThemedText>
        </View>
        {previewDeckContent.livePremiumCategories.map((category) => (
          <PreviewMiniRow
            key={category.id}
            eyebrow={`${category.totalPhraseTarget} live phrase targets`}
            title={`${category.emoji} ${category.title}`}
            body={category.highlight}
            trailing={<Ionicons name="sparkles-outline" size={22} color="#1F6F78" />}
          />
        ))}
      </PreviewCard>
    </PreviewShell>
  );
}
