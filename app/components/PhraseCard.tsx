import { memo } from 'react';
import { View } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { AppPhrase } from '../family/contracts';
import { currentApp } from '../family/currentApp';
import { AudioPlayButton } from './AudioPlayButton';
import { SaveButton } from './SaveButton';
import { ThemedText } from './ui/ThemedText';

type ContextItem = {
  label: string;
  value: string;
};

type Props = {
  phrase: AppPhrase;
  onFavoriteChange?: (isSaved: boolean) => void;
  contextItems?: ContextItem[];
};

function getWarningLabel(phrase: AppPhrase) {
  if (!phrase.warningNoteType) {
    return null;
  }

  return (
    {
      formal: 'Formal',
      bookish: 'Bookish',
      'harder-to-say': 'Harder to say',
      'recognition-only': 'You may hear this',
    }[phrase.warningNoteType] || phrase.warningNoteType.replace(/-/g, ' ')
  );
}

function getRoleLabel(phrase: AppPhrase) {
  if (phrase.variantRole === 'say-first') {
    return 'Main phrase';
  }

  return (
    phrase.variantLabel ||
    {
      'more-polite': 'More polite',
      clearer: 'Clearer',
      'also-common': 'Also common',
    }[phrase.variantRole] ||
    'Another way'
  );
}

function PhraseCardBase({ phrase, onFavoriteChange, contextItems }: Props) {
  const canPlayAudio = currentApp.presentation.capabilities.audio && currentApp.audio.hasAudio(phrase.audioKey);
  const canSave = currentApp.presentation.capabilities.favorites;
  const labels = currentApp.presentation.labels;
  const usageNote = phrase.usageNote ?? phrase.context;
  const audioLabel = canPlayAudio ? null : currentApp.presentation.phrase.audioUnavailableLabel;
  const roleLabel = getRoleLabel(phrase);
  const warningLabel = getWarningLabel(phrase);
  const showRoleBadge = phrase.variantRole !== 'say-first';
  const breadcrumb = contextItems?.map((item) => item.value).filter(Boolean).join(' · ');
  const showMetaRow = showRoleBadge || Boolean(audioLabel) || Boolean(warningLabel);

  return (
    <View className="rounded-[28px] border border-border bg-surface p-4 shadow-sm" testID={`phrase-card-${phrase.id}`}>
      <View className="flex-row items-start justify-between gap-4">
        <View className="flex-1">
          {showMetaRow ? (
            <View className="flex-row flex-wrap gap-2">
              {showRoleBadge ? (
                <View className="rounded-full bg-surface-soft px-3 py-1">
                  <ThemedText variant="label">{roleLabel}</ThemedText>
                </View>
              ) : null}
              {audioLabel ? (
                <View className="rounded-full bg-background px-3 py-1">
                  <ThemedText variant="label" className="text-text-secondary">
                    {audioLabel}
                  </ThemedText>
                </View>
              ) : null}
              {warningLabel ? (
                <View className="rounded-full bg-surface-soft px-3 py-1">
                  <ThemedText variant="label">{warningLabel}</ThemedText>
                </View>
              ) : null}
            </View>
          ) : null}

          <ThemedText variant="target" className={showMetaRow ? 'mt-3' : ''}>
            {phrase.targetText}
          </ThemedText>

          {phrase.pronunciation ? (
            <View className="mt-4">
              <ThemedText variant="label">{labels.pronunciation}</ThemedText>
              <ThemedText variant="pronunciation" className="mt-1">
                {phrase.pronunciation}
              </ThemedText>
            </View>
          ) : null}

          <View className="mt-4">
            <ThemedText variant="label">{labels.sourceText}</ThemedText>
            <ThemedText variant="source" className="mt-1">
              {phrase.sourceText}
            </ThemedText>
          </View>
        </View>

        <View className="flex-row items-center gap-2">
          {canPlayAudio ? <AudioPlayButton audioKey={phrase.audioKey} size={44} tone="subtle" /> : null}
          {canSave ? <SaveButton phraseId={phrase.id} onChange={onFavoriteChange} size={44} tone="subtle" /> : null}
        </View>
      </View>

      {breadcrumb ? (
        <View className="mt-4 rounded-2xl bg-background px-4 py-3">
          <View className="flex-row items-center gap-2">
            <Ionicons name="location-outline" size={16} color="#64748B" />
            <ThemedText variant="caption" className="text-text-secondary">
              {breadcrumb}
            </ThemedText>
          </View>
        </View>
      ) : null}

      {usageNote ? (
        <View className="mt-4 rounded-2xl bg-surface-soft px-4 py-3">
          <ThemedText variant="label">Use this when</ThemedText>
          <ThemedText variant="caption" className="mt-2">
            {usageNote}
          </ThemedText>
        </View>
      ) : null}

      {phrase.youMayHear ? (
        <View className="mt-3 rounded-2xl border border-border bg-background px-4 py-3">
          <ThemedText variant="label">You might hear</ThemedText>
          <ThemedText variant="caption" className="mt-2">
            {phrase.youMayHear}
          </ThemedText>
        </View>
      ) : null}
    </View>
  );
}

export const PhraseCard = memo(PhraseCardBase);
