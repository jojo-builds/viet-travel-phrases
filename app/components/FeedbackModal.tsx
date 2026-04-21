import { useState } from 'react';
import { Modal, View, TextInput, Pressable, Alert, KeyboardAvoidingView, Platform } from 'react-native';
import { currentApp } from '../family/currentApp';
import { ThemedText } from './ui/ThemedText';

type Props = {
  visible: boolean;
  onClose: () => void;
};

export function FeedbackModal({ visible, onClose }: Props) {
  const [message, setMessage] = useState('');
  const [sending, setSending] = useState(false);
  const [sent, setSent] = useState(false);
  const feedback = currentApp.presentation.feedback;

  const handleSend = async () => {
    if (!message.trim()) return;
    setSending(true);
    try {
      await fetch(feedback.formEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({ message: message.trim(), _subject: feedback.subject }),
      });
      setSent(true);
      setMessage('');
      setTimeout(() => {
        setSent(false);
        onClose();
      }, 1800);
    } catch {
      Alert.alert(feedback.errorTitle, feedback.errorBody);
    } finally {
      setSending(false);
    }
  };

  const handleClose = () => {
    setMessage('');
    setSent(false);
    onClose();
  };

  const canSend = message.trim() && !sending;

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={handleClose}>
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        className="flex-1 justify-end"
      >
        <Pressable className="flex-1 bg-black/40" onPress={handleClose} />
        <View className="rounded-t-3xl bg-surface px-5 pb-10 pt-5" testID="feedback-modal">
          <View className="mb-4 flex-row items-center justify-between">
            <ThemedText variant="subtitle">{feedback.title}</ThemedText>
            <Pressable onPress={handleClose} className="p-1" testID="feedback-close-button">
              <ThemedText className="text-lg text-text-secondary">{feedback.closeIcon}</ThemedText>
            </Pressable>
          </View>

          {sent ? (
            <View className="items-center py-8" testID="feedback-success-state">
              <ThemedText className="mb-2 text-2xl">{feedback.successIcon}</ThemedText>
              <ThemedText variant="subtitle">{feedback.successTitle}</ThemedText>
              <ThemedText variant="caption" className="mt-1 text-center">
                {feedback.successBody}
              </ThemedText>
            </View>
          ) : (
            <>
              <TextInput
                value={message}
                onChangeText={setMessage}
                placeholder={feedback.placeholder}
                placeholderTextColor="#9CA3AF"
                multiline
                autoFocus
                className="mb-3.5 min-h-[120px] rounded-xl border-[1.5px] border-border bg-background p-3.5 text-[15px] text-text-primary"
                style={{ textAlignVertical: 'top' }}
                testID="feedback-message-input"
              />
              <Pressable
                onPress={handleSend}
                disabled={!canSend}
                className={`items-center rounded-xl p-3.5 ${canSend ? 'bg-primary' : 'bg-border'}`}
                style={({ pressed }) => ({ opacity: pressed ? 0.85 : 1 })}
                testID="feedback-send-button"
              >
                <ThemedText
                  className={`text-base font-semibold ${canSend ? 'text-white' : 'text-caption'}`}
                >
                  {sending ? feedback.sendingLabel : feedback.sendLabel}
                </ThemedText>
              </Pressable>
            </>
          )}
        </View>
      </KeyboardAvoidingView>
    </Modal>
  );
}
