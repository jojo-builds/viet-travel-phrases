import { useEffect, useMemo, useRef, useState } from 'react';
import { Animated, Pressable, Text, View } from 'react-native';
import * as Haptics from 'expo-haptics';
import { Audio, AVPlaybackStatus } from 'expo-av';
import audioRegistry from '../assets/audio/registry';

type Props = {
  audioFile: string;
  size?: number;
};

let activeSound: Audio.Sound | null = null;
let activeStop: (() => Promise<void>) | null = null;

export function AudioPlayButton({ audioFile, size = 48 }: Props) {
  const [isPlaying, setIsPlaying] = useState(false);
  const [hasError, setHasError] = useState(false);
  const scale = useRef(new Animated.Value(1)).current;

  useEffect(() => () => {
    if (activeStop) {
      void activeStop();
    }
  }, []);

  useEffect(() => {
    if (!isPlaying) {
      scale.stopAnimation();
      scale.setValue(1);
      return;
    }

    const loop = Animated.loop(
      Animated.sequence([
        Animated.timing(scale, { toValue: 1.06, duration: 450, useNativeDriver: true }),
        Animated.timing(scale, { toValue: 1, duration: 450, useNativeDriver: true }),
      ]),
    );
    loop.start();
    return () => loop.stop();
  }, [isPlaying, scale]);

  const iconSize = useMemo(() => Math.round(size * 0.42), [size]);

  const handlePress = async () => {
    await Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);

    if (isPlaying && activeStop) {
      await activeStop();
      return;
    }

    const source = audioRegistry[audioFile];
    if (!source) {
      setHasError(true);
      return;
    }

    try {
      if (activeStop) {
        await activeStop();
      }

      setHasError(false);
      const { sound } = await Audio.Sound.createAsync(source);
      activeSound = sound;
      setIsPlaying(true);

      activeStop = async () => {
        try {
          if (activeSound) {
            await activeSound.stopAsync().catch(() => undefined);
            await activeSound.unloadAsync().catch(() => undefined);
          }
        } finally {
          activeSound = null;
          activeStop = null;
          setIsPlaying(false);
        }
      };

      sound.setOnPlaybackStatusUpdate((status: AVPlaybackStatus) => {
        if (status.isLoaded && status.didJustFinish && activeStop) {
          void activeStop();
        }
      });

      await sound.playAsync();
    } catch {
      setHasError(true);
      setIsPlaying(false);
      if (activeStop) {
        await activeStop();
      }
    }
  };

  return (
    <View className="items-center">
      <Animated.View style={{ transform: [{ scale }] }}>
        <Pressable
          accessibilityLabel={isPlaying ? 'Stop phrase audio' : 'Play phrase audio'}
          accessibilityRole="button"
          onPress={() => void handlePress()}
          className="items-center justify-center rounded-full bg-primary"
          style={{ height: size, width: size }}
        >
          <Text className="font-semibold text-white" style={{ fontSize: iconSize }}>
            {isPlaying ? '■' : '▶'}
          </Text>
        </Pressable>
      </Animated.View>
      {hasError ? <Text className="mt-1 text-xs text-primary">!</Text> : null}
    </View>
  );
}
