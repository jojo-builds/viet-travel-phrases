import { useState } from 'react';
import { Alert, Pressable, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { ThemedText } from '../components/ui/ThemedText';
import { FeedbackModal } from '../components/FeedbackModal';

type Row = { section: 'About' | 'Legal' | 'Feedback'; label: string; action: () => void };

const openAbout = () =>
  Alert.alert(
    'Vietnamese Travel Phrasebook',
    'Offline travel Vietnamese for everyday situations.\n\nMade with ❤️ in Vietnam',
  );

const openRate = () =>
  Alert.alert('Coming soon', 'Store rating link will be added post-launch.');

export default function SettingsScreen() {
  const router = useRouter();
  const [feedbackVisible, setFeedbackVisible] = useState(false);

  const rows: Row[] = [
    { section: 'About', label: 'About this app', action: openAbout },
    { section: 'Legal', label: 'Privacy Policy', action: () => router.push('/privacy') },
    { section: 'Legal', label: 'Terms of Use', action: () => router.push('/terms') },
    { section: 'Feedback', label: 'Send Feedback', action: () => setFeedbackVisible(true) },
    { section: 'Feedback', label: 'Rate this App', action: openRate },
  ];

  return (
    <SafeAreaView className="flex-1 bg-background px-5 pt-6" edges={['top', 'bottom']}>
      <View className="space-y-6">
        <ThemedText variant="title">Settings</ThemedText>
        {(['About', 'Legal', 'Feedback'] as const).map((section) => (
          <View key={section} className="space-y-3">
            <ThemedText variant="subtitle">{section}</ThemedText>
            <View className="rounded-2xl border border-border bg-surface shadow-sm">
              {rows
                .filter((row) => row.section === section)
                .map((row, index, list) => (
                  <Pressable
                    key={row.label}
                    accessibilityLabel={row.label}
                    onPress={row.action}
                    style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
                    className={`flex-row items-center justify-between px-4 py-4 ${
                      index < list.length - 1 ? 'border-b border-border' : ''
                    }`}
                  >
                    <ThemedText>{row.label}</ThemedText>
                    <ThemedText className="text-caption">›</ThemedText>
                  </Pressable>
                ))}
            </View>
          </View>
        ))}
        <ThemedText variant="caption" className="pt-4 text-center">
          Version 1.0.0 • Made with ❤️ in Vietnam
        </ThemedText>
      </View>

      <FeedbackModal visible={feedbackVisible} onClose={() => setFeedbackVisible(false)} />
    </SafeAreaView>
  );
}
