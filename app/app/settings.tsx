import { useState } from 'react';
import { Alert, Pressable, ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import { FeedbackModal } from '../components/FeedbackModal';
import { ThemedText } from '../components/ui/ThemedText';
import { currentApp } from '../family/currentApp';
import { AudioPlaybackSpeedOption, useAudioPlaybackPreference } from '../lib/audioPlaybackPreferences';
import { usePremiumAccess } from '../lib/premiumAccess';
import { getPremiumActionAlert, getPremiumStoreStatusMessage } from '../lib/premiumStoreMessages';

type Row = {
  id: 'about-app' | 'privacy' | 'terms' | 'send-feedback' | 'rate-app';
  section: 'about' | 'legal' | 'feedback';
  label: string;
  action: () => void;
};

export default function SettingsScreen() {
  const router = useRouter();
  const [feedbackVisible, setFeedbackVisible] = useState(false);
  const settings = currentApp.presentation.settings;
  const premium = currentApp.presentation.premium;
  const { option: audioPlaybackSpeed, setOption: setAudioPlaybackSpeed } = useAudioPlaybackPreference();
  const { isBusy, isUnlocked, priceLabel, restore, restoreReady, storeReady, storeStatus } = usePremiumAccess();
  const audioSpeedOptions: Array<{
    id: AudioPlaybackSpeedOption;
    label: string;
    body: string;
  }> = [
    {
      id: '0.5x',
      label: settings.audioSpeedOptions.halfSpeedLabel,
      body: settings.audioSpeedOptions.halfSpeedBody,
    },
    {
      id: '0.75x',
      label: settings.audioSpeedOptions.threeQuarterSpeedLabel,
      body: settings.audioSpeedOptions.threeQuarterSpeedBody,
    },
    {
      id: '1.0x',
      label: settings.audioSpeedOptions.normalLabel,
      body: settings.audioSpeedOptions.normalBody,
    },
  ];

  const rows: Row[] = [
    {
      id: 'about-app',
      section: 'about',
      label: settings.rowLabels.aboutApp,
      action: () => Alert.alert(settings.aboutAlertTitle, settings.aboutAlertBody),
    },
    {
      id: 'privacy',
      section: 'legal',
      label: settings.rowLabels.privacy,
      action: () => router.push('/privacy'),
    },
    {
      id: 'terms',
      section: 'legal',
      label: settings.rowLabels.terms,
      action: () => router.push('/terms'),
    },
    {
      id: 'send-feedback',
      section: 'feedback',
      label: settings.rowLabels.sendFeedback,
      action: () => setFeedbackVisible(true),
    },
    {
      id: 'rate-app',
      section: 'feedback',
      label: settings.rowLabels.rateApp,
      action: () => Alert.alert(settings.rateComingSoonTitle, settings.rateComingSoonBody),
    },
  ];

  const premiumSubtitle = isUnlocked
    ? premium.statusUnlockedLabel
    : storeReady
      ? `${premium.unlockModelLabel} - ${priceLabel}`
      : premium.statusLockedLabel;
  const premiumBody = storeReady
    ? 'Open Full Trip Pack to see what the one-time unlock adds across the same travel situations and to test purchase or restore in a supported iPhone build.'
    : getPremiumStoreStatusMessage(storeStatus) ?? premium.manageBody;

  const handleRestore = async () => {
    const result = await restore();
    if (result.ok) {
      Alert.alert('Purchase restored', 'The Full Trip Pack is unlocked again on this device.');
      return;
    }

    const alertCopy = getPremiumActionAlert(result);
    if (alertCopy) {
      Alert.alert(alertCopy.title, alertCopy.message);
    }
  };

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']} testID="settings-screen">
      <ScrollView className="flex-1 px-5 pt-8" contentContainerClassName="gap-6 pb-28">
        <ThemedText variant="title">{settings.title}</ThemedText>

        <View className="gap-3">
          <View className="rounded-[30px] border border-border bg-surface p-5 shadow-sm">
            <ThemedText variant="subtitle">{settings.audioSpeedTitle}</ThemedText>
            <ThemedText className="mt-2">{settings.audioSpeedBody}</ThemedText>

            <View className="mt-4 gap-3">
              {audioSpeedOptions.map((audioOption) => {
                const isSelected = audioPlaybackSpeed === audioOption.id;

                return (
                  <Pressable
                    key={audioOption.id}
                    accessibilityLabel={audioOption.label}
                    accessibilityRole="button"
                    accessibilityState={{ selected: isSelected }}
                    onPress={() => void setAudioPlaybackSpeed(audioOption.id)}
                    style={({ pressed }) => [{ opacity: pressed ? 0.82 : 1 }]}
                    className={`rounded-2xl border px-4 py-4 ${isSelected ? 'border-primary bg-surface-soft' : 'border-border bg-background'}`}
                  >
                    <View className="flex-row items-start justify-between gap-4">
                      <View className="flex-1">
                        <ThemedText variant="label" className={isSelected ? 'text-primary' : 'text-text-secondary'}>
                          {audioOption.label}
                        </ThemedText>
                        <ThemedText className="mt-2">{audioOption.body}</ThemedText>
                      </View>
                      <View
                        className={`mt-1 h-8 w-8 items-center justify-center rounded-full ${isSelected ? 'bg-primary' : 'bg-surface-soft'}`}
                      >
                        <Ionicons
                          name={isSelected ? 'checkmark' : 'ellipse-outline'}
                          size={18}
                          color={isSelected ? '#FFFFFF' : '#64748B'}
                        />
                      </View>
                    </View>
                  </Pressable>
                );
              })}
            </View>
          </View>

          <Pressable
            accessibilityLabel={premium.manageTitle}
            onPress={() => router.push('/premium')}
            style={({ pressed }) => [{ opacity: pressed ? 0.85 : 1 }]}
            className="rounded-[30px] border border-border bg-surface p-5 shadow-sm"
          >
            <View className="flex-row items-start justify-between gap-4">
              <View className="flex-1">
                <ThemedText variant="label" className="text-premium">
                  {premium.manageTitle}
                </ThemedText>
                <ThemedText variant="subtitle" className="mt-2">
                  {premiumSubtitle}
                </ThemedText>
                <ThemedText className="mt-2">{premiumBody}</ThemedText>
              </View>
              <View className="h-12 w-12 items-center justify-center rounded-2xl bg-premium-soft">
                <Ionicons name="sparkles-outline" size={24} color="#1F6F78" />
              </View>
            </View>
          </Pressable>

          {restoreReady && !isUnlocked ? (
            <Pressable
              accessibilityLabel={premium.restoreButtonLabel}
              disabled={isBusy}
              onPress={() => void handleRestore()}
              style={({ pressed }) => [{ opacity: pressed ? 0.85 : 1 }]}
              className={`items-center rounded-2xl border border-border bg-surface-soft px-4 py-4 ${isBusy ? 'opacity-60' : ''}`}
            >
              <ThemedText className="font-semibold text-text-primary">{premium.restoreButtonLabel}</ThemedText>
            </Pressable>
          ) : null}
        </View>

        {(['about', 'legal', 'feedback'] as const).map((section) => (
          <View key={section} className="space-y-3">
            <ThemedText variant="subtitle">{settings.sectionTitles[section]}</ThemedText>
            <View className="rounded-3xl border border-border bg-surface shadow-sm">
              {rows
                .filter((row) => row.section === section)
                .map((row, index, list) => (
                  <Pressable
                    key={row.id}
                    accessibilityLabel={row.label}
                    onPress={row.action}
                    style={({ pressed }) => [{ opacity: pressed ? 0.78 : 1 }]}
                    className={`flex-row items-center justify-between px-4 py-4 ${index < list.length - 1 ? 'border-b border-border' : ''}`}
                    testID={`settings-row-${row.id}`}
                  >
                    <ThemedText>{row.label}</ThemedText>
                    <Ionicons
                      name={settings.chevron as keyof typeof Ionicons.glyphMap}
                      size={18}
                      color="#64748B"
                    />
                  </Pressable>
                ))}
            </View>
          </View>
        ))}

        <ThemedText variant="caption" className="pt-2 text-center">
          {settings.footer}
        </ThemedText>
      </ScrollView>

      <FeedbackModal visible={feedbackVisible} onClose={() => setFeedbackVisible(false)} />
    </SafeAreaView>
  );
}
