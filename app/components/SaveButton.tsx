import { useEffect, useState } from 'react';
import { Pressable, View } from 'react-native';
import Animated, { useAnimatedStyle, useSharedValue, withSequence, withTiming } from 'react-native-reanimated';
import * as Haptics from 'expo-haptics';
import Ionicons from '@expo/vector-icons/Ionicons';
import { currentApp } from '../family/currentApp';
import { useDesignReview } from '../lib/designReview';
import { ThemedText } from './ui/ThemedText';

const AnimatedPressable = Animated.createAnimatedComponent(Pressable);

type Props = {
  phraseId: string;
  onChange?: (isSaved: boolean) => void;
  size?: number;
  showLabel?: boolean;
  tone?: 'solid' | 'subtle';
};

export function SaveButton({ phraseId, onChange, size = 50, showLabel = false, tone = 'solid' }: Props) {
  const designReview = useDesignReview();
  const [saved, setSaved] = useState(false);
  const [loading, setLoading] = useState(true);
  const scale = useSharedValue(1);
  const iconSize = Math.round(size * 0.44);
  const isSubtle = tone === 'subtle';
  const buttonClassName = isSubtle
    ? `items-center justify-center rounded-full border ${saved ? 'border-primary bg-accent-soft' : 'border-border bg-background'}`
    : `items-center justify-center rounded-2xl border ${saved ? 'border-primary bg-primary' : 'border-border bg-surface-soft'}`;
  const iconColor = saved ? (isSubtle ? '#D97745' : '#FFFFFF') : '#D97745';

  useEffect(() => {
    if (designReview.isEnabled) {
      setSaved(designReview.isPhraseSaved(phraseId) ?? false);
      setLoading(false);
      return;
    }

    let active = true;

    (async () => {
      try {
        const next = await currentApp.storage.isFavorite(phraseId);
        if (active) {
          setSaved(next);
        }
      } finally {
        if (active) {
          setLoading(false);
        }
      }
    })();

    return () => {
      active = false;
    };
  }, [designReview, phraseId]);

  const animatedStyle = useAnimatedStyle(() => ({ transform: [{ scale: scale.value }] }));

  const handlePress = async () => {
    await Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    const nextSaved = designReview.isEnabled
      ? (designReview.togglePhraseSaved(phraseId) ?? false)
      : (await currentApp.storage.toggleFavoriteId(phraseId)).includes(phraseId);
    setSaved(nextSaved);
    if (nextSaved) {
      scale.value = withSequence(withTiming(1.3, { duration: 100 }), withTiming(1, { duration: 100 }));
    }
    onChange?.(nextSaved);
  };

  return (
    <View className="items-center">
      <AnimatedPressable
        accessibilityLabel={saved ? 'Unsave phrase' : 'Save phrase'}
        accessibilityRole="button"
        disabled={loading}
        onPress={() => void handlePress()}
        style={[animatedStyle, { height: size, width: size }]}
        className={`${buttonClassName} ${loading ? 'opacity-50' : ''}`}
        testID={`save-button-${phraseId}`}
      >
        <Ionicons name={saved ? 'heart' : 'heart-outline'} size={iconSize} color={iconColor} />
      </AnimatedPressable>
      {showLabel ? (
        <ThemedText variant="caption" className="mt-2 font-semibold text-text-secondary">
          {saved ? 'Saved' : 'Save'}
        </ThemedText>
      ) : null}
    </View>
  );
}
