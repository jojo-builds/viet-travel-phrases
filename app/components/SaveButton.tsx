import { useEffect, useState } from 'react';
import { Pressable, Text } from 'react-native';
import { getFavoriteIds, toggleFavoriteId } from '../lib/favorites';

type Props = {
  phraseId: string;
  onChange?: (isSaved: boolean) => void;
};

export function SaveButton({ phraseId, onChange }: Props) {
  const [isSaved, setIsSaved] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;
    getFavoriteIds()
      .then((ids) => active && setIsSaved(ids.includes(phraseId)))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [phraseId]);

  const handlePress = async () => {
    const ids = await toggleFavoriteId(phraseId);
    const next = ids.includes(phraseId);
    setIsSaved(next);
    onChange?.(next);
  };

  return (
    <Pressable
      accessibilityRole="button"
      disabled={loading}
      onPress={() => void handlePress()}
      className={`h-12 w-12 items-center justify-center rounded-xl border border-primary ${
        isSaved ? 'bg-primary' : 'bg-surface'
      } ${loading ? 'opacity-50' : ''}`}
    >
      <Text className={`text-xl ${isSaved ? 'text-white' : 'text-primary'}`}>♥</Text>
    </Pressable>
  );
}
