import { ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Pressable } from 'react-native';
import { ThemedText } from '../components/ui/ThemedText';

const sections = [
  {
    title: 'Acceptance of Terms',
    body: 'By downloading or using Vietnamese Travel Phrasebook, you agree to these Terms of Use. If you do not agree, please do not use the app.',
  },
  {
    title: 'App Description',
    body: 'Vietnamese Travel Phrasebook is an offline phrasebook app that provides Vietnamese phrases with pronunciation guides and audio for common travel situations. It is intended as a communication aid, not a language course.',
  },
  {
    title: 'License',
    body: 'We grant you a limited, non-exclusive, non-transferable, revocable license to use the app for personal, non-commercial purposes on any Apple device you own or control, subject to the Apple App Store Terms of Service.',
  },
  {
    title: 'Content Accuracy',
    body: 'We strive for accuracy in all Vietnamese phrases, pronunciation guides, and translations. However, language is nuanced and regional variations exist. The app is a travel aid and may not cover every dialect or context. Use your best judgment in real conversations.',
  },
  {
    title: 'Intellectual Property',
    body: 'All content in the app — including text, audio, design, and code — is owned by JojoBuilds. You may not copy, modify, distribute, or create derivative works from the app content without written permission.',
  },
  {
    title: 'Prohibited Uses',
    body: 'You may not: reverse-engineer the app, extract audio or content for redistribution, use the app for any unlawful purpose, or attempt to interfere with the app\'s functionality.',
  },
  {
    title: 'Disclaimer of Warranties',
    body: 'The app is provided "as is" without warranties of any kind. We do not guarantee that the app will be error-free or that all phrases will be perfectly suited to every situation.',
  },
  {
    title: 'Limitation of Liability',
    body: 'To the maximum extent permitted by law, JojoBuilds shall not be liable for any indirect, incidental, or consequential damages arising from your use of the app.',
  },
  {
    title: 'Changes to Terms',
    body: 'We may update these terms from time to time. Updated terms will be included in the next app update. Continued use after changes constitutes acceptance of the new terms.',
  },
  {
    title: 'Contact',
    body: 'For questions about these terms, contact us at feedback@jayopsai.com.',
  },
];

export default function TermsScreen() {
  const router = useRouter();

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <View className="flex-row items-center justify-between px-5 pb-3 pt-4">
        <Pressable onPress={() => router.back()} hitSlop={12}>
          <ThemedText className="text-primary text-base font-medium">← Back</ThemedText>
        </Pressable>
      </View>
      <ScrollView className="flex-1 px-5" showsVerticalScrollIndicator={false}>
        <ThemedText variant="title" className="mb-2">Terms of Use</ThemedText>
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
