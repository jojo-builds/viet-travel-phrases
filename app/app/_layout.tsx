import '../global.css';
import { useEffect } from 'react';
import { Stack } from 'expo-router';
import { Audio } from 'expo-av';

export default function RootLayout() {
  useEffect(() => {
    void Audio.setAudioModeAsync({
      playsInSilentModeIOS: true,
      staysActiveInBackground: false,
    });
  }, []);

  return (
    <Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: '#FAFAF8' } }}>
      <Stack.Screen name="(tabs)" />
      <Stack.Screen name="scenario/[id]" />
      <Stack.Screen name="settings" />
    </Stack>
  );
}
