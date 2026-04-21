import { Pressable, ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { ThemedText } from '../components/ui/ThemedText';
import { currentApp } from '../family/currentApp';

export default function PrivacyScreen() {
  const router = useRouter();
  const privacy = currentApp.presentation.privacy;

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']} testID="privacy-screen">
      <View className="flex-row items-center justify-between px-5 pb-3 pt-4">
        <Pressable onPress={() => router.back()} hitSlop={12} testID="privacy-back-button">
          <ThemedText className="text-primary text-base font-medium">{privacy.backLabel}</ThemedText>
        </Pressable>
      </View>
      <ScrollView className="flex-1 px-5" showsVerticalScrollIndicator={false}>
        <ThemedText variant="title" className="mb-2">
          {privacy.title}
        </ThemedText>
        <ThemedText variant="caption" className="mb-6">
          {privacy.effectiveDate}
        </ThemedText>
        {privacy.sections.map((section) => (
          <View key={section.title} className="mb-5">
            <ThemedText variant="subtitle" className="mb-1">
              {section.title}
            </ThemedText>
            <ThemedText variant="body">{section.body}</ThemedText>
          </View>
        ))}
        <View className="h-8" />
      </ScrollView>
    </SafeAreaView>
  );
}
