import { useEffect, useState } from 'react';
import { Pressable } from 'react-native';
import Animated, { useAnimatedStyle, useSharedValue, withSequence, withTiming } from 'react-native-reanimated';
import * as Haptics from 'expo-haptics';
import { isFavorite, toggleFavoriteId } from '../lib/favorites';
import { ThemedText } from './ui/ThemedText';

const AnimatedPressable = Animated.createAnimatedComponent(Pressable);

type Props = { phraseId: string; onChange?: (isSaved: boolean) => void };

export function SaveButton({ phraseId, onChange }: Props) {
  const [saved, setSaved] = useState(false);
  const [loading, setLoading] = useState(true);
  const scale = useSharedValue(1);

  useEffect(() => {
    let active = true;
    (async () => {
      try {
        const next = await isFavorite(phraseId);
        if (active) setSaved(next);
      } finally {
        if (active) setLoading(false);
      }
    })();
    return () => {
      active = false;
    };
  }, [phraseId]);

  const animatedStyle = useAnimatedStyle(() => ({ transform: [{ scale: scale.value }] }));

  const handlePress = async () => {
    await Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    const nextIds = await toggleFavoriteId(phraseId);
    const nextSaved = nextIds.includes(phraseId);
    setSaved(nextSaved);
    if (nextSaved) scale.value = withSequence(withTiming(1.3, { duration: 100 }), withTiming(1, { duration: 100 }));
    onChange?.(nextSaved);
  };

  return (
    <AnimatedPressable
      accessibilityLabel={saved ? 'Unsave phrase' : 'Save phrase'}
      accessibilityRole="button"
      disabled={loading}
      onPress={() => void handlePress()}
      style={animatedStyle}
      className={`h-12 w-12 items-center justify-center rounded-xl border border-primary ${saved ? 'bg-primary' : 'bg-surface'} ${loading ? 'opacity-50' : ''}`}
    >
      <ThemedText className={`text-xl ${saved ? 'text-white' : 'text-primary'}`}>{saved ? '♥' : '♡'}</ThemedText>
    </AnimatedPressable>
  );
}
