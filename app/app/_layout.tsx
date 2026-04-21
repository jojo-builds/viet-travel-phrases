import '../global.css';
import { useEffect } from 'react';
import { Stack } from 'expo-router';
import { Audio } from 'expo-av';
import { AudioPlaybackPreferenceProvider } from '../lib/audioPlaybackPreferences';
import { DesignReviewProvider } from '../lib/designReview';
import { PremiumAccessProvider } from '../lib/premiumAccess';

export default function RootLayout() {
  useEffect(() => {
    void Audio.setAudioModeAsync({
      playsInSilentModeIOS: true,
      staysActiveInBackground: false,
    });
  }, []);

  return (
    <AudioPlaybackPreferenceProvider>
      <DesignReviewProvider>
        <PremiumAccessProvider>
          <Stack screenOptions={{ headerShown: false, animation: 'slide_from_right' }}>
            <Stack.Screen name="(tabs)" />
            <Stack.Screen name="design-live/index" />
            <Stack.Screen name="design-live/[preset]" />
            <Stack.Screen name="scenario/[id]" />
            <Stack.Screen name="premium" options={{ presentation: 'modal' }} />
            <Stack.Screen name="settings" options={{ presentation: 'modal' }} />
            <Stack.Screen name="privacy" options={{ presentation: 'modal' }} />
            <Stack.Screen name="terms" options={{ presentation: 'modal' }} />
          </Stack>
        </PremiumAccessProvider>
      </DesignReviewProvider>
    </AudioPlaybackPreferenceProvider>
  );
}
