import { View } from 'react-native';
import { Phrase } from '../content/types';
import { AudioPlayButton } from './AudioPlayButton';
import { SaveButton } from './SaveButton';
import { ThemedText } from './ui/ThemedText';

type Props = {
  phrase: Phrase;
  onFavoriteChange?: (isSaved: boolean) => void;
};

export function PhraseCard({ phrase, onFavoriteChange }: Props) {
  return (
    <View className="rounded-2xl border border-border bg-surface p-4 shadow-sm">
      <View className="flex-row items-start justify-between gap-3">
        <View className="flex-1 space-y-2">
          <ThemedText variant="vietnamese">{phrase.vietnamese}</ThemedText>
          <ThemedText variant="romanized">{phrase.romanized}</ThemedText>
          <ThemedText variant="english">{phrase.english}</ThemedText>
        </View>
        <View className="items-center gap-3">
          <AudioPlayButton audioKey={phrase.audioKey} />
          <SaveButton phraseId={phrase.id} onChange={onFavoriteChange} />
        </View>
      </View>
      {phrase.context ? (
        <ThemedText variant="caption" className="mt-3">
          {phrase.context}
        </ThemedText>
      ) : null}
    </View>
  );
}
