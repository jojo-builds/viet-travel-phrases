import { useState } from 'react';
import { Modal, View, TextInput, Pressable, Alert, KeyboardAvoidingView, Platform } from 'react-native';
import { ThemedText } from './ui/ThemedText';

type Props = {
  visible: boolean;
  onClose: () => void;
};

export function FeedbackModal({ visible, onClose }: Props) {
  const [message, setMessage] = useState('');
  const [sending, setSending] = useState(false);
  const [sent, setSent] = useState(false);

  const handleSend = async () => {
    if (!message.trim()) return;
    setSending(true);
    try {
      await fetch('https://formspree.io/f/mojpkagy', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({ message: message.trim(), _subject: 'App Feedback — Viet Travel Phrasebook' }),
      });
      setSent(true);
      setMessage('');
      setTimeout(() => {
        setSent(false);
        onClose();
      }, 1800);
    } catch {
      Alert.alert('Error', 'Could not send feedback. Please try again.');
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
        <View className="rounded-t-3xl bg-surface px-5 pb-10 pt-5">
          <View className="mb-4 flex-row items-center justify-between">
            <ThemedText variant="subtitle">Send Feedback</ThemedText>
            <Pressable onPress={handleClose} className="p-1">
              <ThemedText className="text-lg text-text-secondary">✕</ThemedText>
            </Pressable>
          </View>

          {sent ? (
            <View className="items-center py-8">
              <ThemedText className="mb-2 text-2xl">✅</ThemedText>
              <ThemedText variant="subtitle">Thanks!</ThemedText>
              <ThemedText variant="caption" className="mt-1 text-center">
                Your feedback has been received.
              </ThemedText>
            </View>
          ) : (
            <>
              <TextInput
                value={message}
                onChangeText={setMessage}
                placeholder="Tell us what you think, report a bug, or suggest a phrase…"
                placeholderTextColor="#9CA3AF"
                multiline
                autoFocus
                className="mb-3.5 min-h-[120px] rounded-xl border-[1.5px] border-border bg-background p-3.5 text-[15px] text-text-primary"
                style={{ textAlignVertical: 'top' }}
              />
              <Pressable
                onPress={handleSend}
                disabled={!canSend}
                className={`items-center rounded-xl p-3.5 ${canSend ? 'bg-primary' : 'bg-border'}`}
                style={({ pressed }) => ({ opacity: pressed ? 0.85 : 1 })}
              >
                <ThemedText
                  className={`text-base font-semibold ${canSend ? 'text-white' : 'text-caption'}`}
                >
                  {sending ? 'Sending…' : 'Send'}
                </ThemedText>
              </Pressable>
            </>
          )}
        </View>
      </KeyboardAvoidingView>
    </Modal>
  );
}
