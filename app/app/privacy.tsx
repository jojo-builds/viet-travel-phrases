import { ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Pressable } from 'react-native';
import { ThemedText } from '../components/ui/ThemedText';

const sections = [
  {
    title: 'Overview',
    body: 'Vietnamese Travel Phrasebook is a fully offline app. We do not collect, store, or transmit any personal data. Your privacy is important to us, and we built the app with privacy by design.',
  },
  {
    title: 'Data Collection',
    body: 'We collect no data whatsoever. The app does not require an account, login, email address, or any personal information to use.',
  },
  {
    title: 'Analytics & Tracking',
    body: 'The app contains no analytics SDKs, no tracking pixels, no advertising identifiers, and no third-party services. We do not track your usage, location, or behavior.',
  },
  {
    title: 'Local Storage',
    body: 'The app uses AsyncStorage solely to save your favorite phrases on your device. This data never leaves your device and is not accessible to us or any third party.',
  },
  {
    title: 'Network Access',
    body: 'The app is fully offline. It does not make network requests, connect to servers, or transmit data of any kind after installation.',
  },
  {
    title: 'Third-Party Services',
    body: 'We do not integrate any third-party services, SDKs, or APIs that could collect your data.',
  },
  {
    title: 'Children\'s Privacy',
    body: 'The app does not collect data from anyone, including children. It is safe for users of all ages.',
  },
  {
    title: 'Changes to This Policy',
    body: 'If we update this policy, the updated version will be included in the next app update. The effective date will be noted below.',
  },
  {
    title: 'Contact',
    body: 'If you have questions about this privacy policy, contact us at feedback@jayopsai.com.',
  },
];

export default function PrivacyScreen() {
  const router = useRouter();

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <View className="flex-row items-center justify-between px-5 pb-3 pt-4">
        <Pressable onPress={() => router.back()} hitSlop={12}>
          <ThemedText className="text-primary text-base font-medium">← Back</ThemedText>
        </Pressable>
      </View>
      <ScrollView className="flex-1 px-5" showsVerticalScrollIndicator={false}>
        <ThemedText variant="title" className="mb-2">Privacy Policy</ThemedText>
        <ThemedText variant="caption" className="mb-6">
          Effective: April 1, 2026
        </ThemedText>
        {sections.map((s) => (
          <View key={s.title} className="mb-5">
            <ThemedText variant="subtitle" className="mb-1">{s.title}</ThemedText>
            <ThemedText variant="body">{s.body}</ThemedText>
          </View>
        ))}
        <View className="h-8" />
      </ScrollView>
    </SafeAreaView>
  );
}
