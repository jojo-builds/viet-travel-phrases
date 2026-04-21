import { useEffect, useRef, useState } from 'react';
import { Animated, Pressable, View } from 'react-native';
import * as Haptics from 'expo-haptics';
import Ionicons from '@expo/vector-icons/Ionicons';
import { Audio, AVPlaybackStatus, PitchCorrectionQuality } from 'expo-av';
import { currentApp } from '../family/currentApp';
import { formatAudioPlaybackRate, useAudioPlaybackPreference } from '../lib/audioPlaybackPreferences';
import { ThemedText } from './ui/ThemedText';

type Props = {
  audioKey: string;
  size?: number;
  showLabel?: boolean;
  tone?: 'solid' | 'subtle';
};

let activeSound: Audio.Sound | null = null;
let activeStop: (() => Promise<void>) | null = null;
let activeOwnerId: symbol | null = null;

async function applyPlaybackRate(sound: Audio.Sound, playbackRate: number) {
  if (playbackRate === 1) {
    await sound.setRateAsync(1, false, PitchCorrectionQuality.Medium).catch(() => undefined);
    return;
  }

  await sound.setRateAsync(playbackRate, true, PitchCorrectionQuality.Medium).catch(async () => {
    await sound.setRateAsync(1, false, PitchCorrectionQuality.Medium).catch(() => undefined);
  });
}

export function AudioPlayButton({ audioKey, size = 48, showLabel = false, tone = 'solid' }: Props) {
  const [isPlaying, setIsPlaying] = useState(false);
  const [hasError, setHasError] = useState(false);
  const scale = useRef(new Animated.Value(1)).current;
  const ownerId = useRef(Symbol(audioKey));
  const { option: playbackSpeedOption, rate: playbackRate } = useAudioPlaybackPreference();
  const iconSize = Math.round(size * 0.42);
  const isSubtle = tone === 'subtle';
  const speedLabel = formatAudioPlaybackRate(playbackRate);
  const showSpeedBadge = playbackSpeedOption !== '1.0x';
  const buttonClassName = isSubtle
    ? `items-center justify-center rounded-full border ${isPlaying ? 'border-premium bg-premium' : 'border-border bg-background'}`
    : `items-center justify-center rounded-2xl shadow-sm ${isPlaying ? 'bg-premium' : 'bg-primary'}`;
  const iconColor = isSubtle ? (isPlaying ? '#FFFFFF' : '#D97745') : '#FFFFFF';

  useEffect(
    () => () => {
      if (activeOwnerId === ownerId.current && activeStop) {
        void activeStop();
      }
    },
    [],
  );

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

  useEffect(() => {
    if (!isPlaying || activeOwnerId !== ownerId.current || !activeSound) {
      return;
    }

    void applyPlaybackRate(activeSound, playbackRate).catch(() => undefined);
  }, [isPlaying, playbackRate]);

  const handlePress = async () => {
    await Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);

    if (isPlaying && activeOwnerId === ownerId.current && activeStop) {
      await activeStop();
      return;
    }

    const source = currentApp.audio.resolveAudioSource(audioKey);
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
      await applyPlaybackRate(sound, playbackRate);
      activeSound = sound;
      activeOwnerId = ownerId.current;
      setIsPlaying(true);

      activeStop = async () => {
        try {
          if (activeSound) {
            await activeSound.stopAsync().catch(() => undefined);
            await activeSound.unloadAsync().catch(() => undefined);
          }
        } finally {
          if (activeOwnerId === ownerId.current) {
            activeOwnerId = null;
          }
          activeSound = null;
          activeStop = null;
          setIsPlaying(false);
        }
      };

      sound.setOnPlaybackStatusUpdate((status: AVPlaybackStatus) => {
        if (status.isLoaded && status.didJustFinish && activeOwnerId === ownerId.current && activeStop) {
          void activeStop();
        }
      });

      await sound.playAsync();
    } catch {
      setHasError(true);
      setIsPlaying(false);
      if (activeOwnerId === ownerId.current && activeStop) {
        await activeStop();
      }
    }
  };

  return (
    <View className="items-center">
      <View className="relative">
        <Animated.View style={{ transform: [{ scale }] }}>
          <Pressable
            accessibilityHint={showSpeedBadge ? 'Uses the same phrase audio clip at a slower playback speed.' : undefined}
            accessibilityLabel={isPlaying ? 'Stop phrase audio' : `Play phrase audio at ${speedLabel}`}
            accessibilityRole="button"
            onPress={() => void handlePress()}
            className={buttonClassName}
            style={{ height: size, width: size }}
            testID={`audio-play-${audioKey}`}
          >
            <Ionicons name={isPlaying ? 'stop' : 'volume-high'} size={iconSize} color={iconColor} />
          </Pressable>
        </Animated.View>
        {showSpeedBadge ? (
          <View className="absolute -right-1 -top-1 rounded-full border border-border bg-surface px-1.5 py-[2px]">
            <ThemedText variant="caption" className="text-[10px] font-semibold leading-3 text-text-primary">
              {speedLabel}
            </ThemedText>
          </View>
        ) : null}
      </View>
      {showLabel ? (
        <ThemedText variant="caption" className="mt-2 font-semibold text-text-secondary">
          {isPlaying ? 'Stop audio' : `Play audio${showSpeedBadge ? ` at ${speedLabel}` : ''}`}
        </ThemedText>
      ) : null}
      {hasError ? (
        <ThemedText variant="caption" className="mt-2 font-semibold text-primary">
          Audio unavailable
        </ThemedText>
      ) : null}
    </View>
  );
}
