import { Pressable, ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { router } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import { appPreviewSlides, previewDeckContent } from '../../components/preview/previewContent';
import { ThemedText } from '../../components/ui/ThemedText';

export default function DesignPreviewIndex() {
  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <ScrollView className="flex-1" contentContainerClassName="gap-4 px-5 pb-12 pt-8">
        <View className="rounded-[32px] border border-border bg-surface p-5 shadow-sm">
          <ThemedText variant="label" className="text-primary">
            Design preview mode
          </ThemedText>
          <ThemedText variant="title" className="mt-2">
            Visual review routes for {previewDeckContent.appName}
          </ThemedText>
          <ThemedText className="mt-3">
            This route is meant for quick visual iteration in Expo web or native preview without touching App Store builds.
            Open a concept below to review a full-screen wireframe.
          </ThemedText>
        </View>

        {appPreviewSlides.map((slide) => (
          <Pressable
            key={slide.id}
            accessibilityRole="button"
            onPress={() => router.push(`/design-preview/${slide.id}`)}
            style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1 }, { transform: [{ scale: pressed ? 0.99 : 1 }] }]}
            className="rounded-[30px] border border-border bg-surface p-5 shadow-sm"
          >
            <View className="flex-row items-start justify-between gap-3">
              <View className="flex-1">
                <ThemedText variant="label" className="text-primary">
                  {slide.label}
                </ThemedText>
                <ThemedText variant="subtitle" className="mt-2">
                  {slide.title}
                </ThemedText>
                <ThemedText className="mt-2">{slide.body}</ThemedText>
              </View>
              <View className="h-11 w-11 items-center justify-center rounded-full bg-accent-soft">
                <Ionicons name="arrow-forward" size={20} color="#D97745" />
              </View>
            </View>
          </Pressable>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}
