import { useState } from 'react';
import { Pressable, Text } from 'react-native';
import { Audio } from 'expo-av';
import { audioRegistry } from '../assets/audio/registry';

export function AudioPlayButton({ audioKey }: { audioKey: string }) {
  const [loading, setLoading] = useState(false);
  const [failed, setFailed] = useState(false);

  const handlePress = async () => {
    const source = audioRegistry[audioKey];
    if (!source) {
      setFailed(true);
      return;
    }
    setLoading(true);
    setFailed(false);
    const { sound } = await Audio.Sound.createAsync(source);
    await sound.playAsync();
    sound.setOnPlaybackStatusUpdate((status) => {
      if (status.isLoaded && status.didJustFinish) {
        void sound.unloadAsync();
      }
    });
    setLoading(false);
  };

  return (
    <Pressable
      accessibilityRole="button"
      onPress={() => void handlePress()}
      className={`h-12 w-12 items-center justify-center rounded-full bg-primary ${loading ? 'opacity-70' : ''}`}
    >
      <Text className="text-base font-semibold text-white">{failed ? '!' : '▶'}</Text>
    </Pressable>
  );
}
