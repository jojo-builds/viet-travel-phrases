import { View } from 'react-native';
import { Stack, useLocalSearchParams } from 'expo-router';
import { AppPreviewSlideView } from '../../components/preview/PreviewSlides';
import { isAppPreviewSlideId } from '../../components/preview/previewContent';
import { ThemedText } from '../../components/ui/ThemedText';

export default function DesignPreviewSlide() {
  const { slide } = useLocalSearchParams<{ slide?: string }>();

  if (!isAppPreviewSlideId(slide)) {
    return (
      <View className="flex-1 items-center justify-center bg-background px-5">
        <Stack.Screen options={{ headerShown: false }} />
        <View className="rounded-[32px] border border-border bg-surface px-6 py-8 shadow-sm">
          <ThemedText variant="subtitle" className="text-center">
            Design preview not found
          </ThemedText>
          <ThemedText className="mt-3 text-center">
            Return to `/design-preview` and open one of the defined concept routes.
          </ThemedText>
        </View>
      </View>
    );
  }

  return (
    <>
      <Stack.Screen options={{ headerShown: false }} />
      <AppPreviewSlideView slideId={slide} />
    </>
  );
}
