import { Redirect, Stack, useLocalSearchParams } from 'expo-router';
import { ActivityIndicator, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ThemedText } from '../../components/ui/ThemedText';
import { buildDesignReviewTargetPath, getDesignReviewPreset } from '../../lib/designReviewPresets';

function normalizePreset(value?: string | string[]) {
  if (Array.isArray(value)) {
    return value[0];
  }

  return value;
}

export default function DesignLivePresetScreen() {
  const params = useLocalSearchParams<{ preset?: string | string[] }>();
  const presetId = normalizePreset(params.preset);
  const preset = getDesignReviewPreset(presetId);
  const targetPath = presetId ? buildDesignReviewTargetPath(presetId) : null;

  if (!preset || !targetPath) {
    return (
      <SafeAreaView className="flex-1 bg-background px-5" edges={['top', 'bottom']}>
        <Stack.Screen options={{ headerShown: false }} />
        <View className="flex-1 items-center justify-center gap-4">
          <ThemedText variant="subtitle">Design preset not found</ThemedText>
          <ThemedText className="text-center">
            Return to `/design-live` and choose one of the defined real-app state presets.
          </ThemedText>
        </View>
      </SafeAreaView>
    );
  }

  return <Redirect href={targetPath} />;
}
