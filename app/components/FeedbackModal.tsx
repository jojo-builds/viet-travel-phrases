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
      await fetch('https://formspree.io/f/xpwzgwrb', {
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

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={handleClose}>
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        className="flex-1 justify-end"
      >
        <Pressable className="flex-1 bg-black/40" onPress={handleClose} />
        <View className="bg-surface rounded-t-3xl px-5 pt-5 pb-10">
          <View className="flex-row items-center justify-between mb-4">
            <ThemedText variant="subtitle">Send Feedback</ThemedText>
            <Pressable onPress={handleClose} className="p-1">
              <ThemedText className="text-text-secondary text-lg">✕</ThemedText>
            </Pressable>
          </View>

          {sent ? (
            <View className="items-center py-8">
              <ThemedText className="text-2xl mb-2">✅</ThemedText>
              <ThemedText variant="subtitle">Thanks!</ThemedText>
              <ThemedText variant="caption" className="text-center mt-1">
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
                style={{
                  borderWidth: 1.5,
                  borderColor: '#E5E7EB',
                  borderRadius: 12,
                  padding: 14,
                  fontSize: 15,
                  color: '#1A1A2E',
                  minHeight: 120,
                  textAlignVertical: 'top',
                  marginBottom: 14,
                  backgroundColor: '#FAFAF8',
                }}
              />
              <Pressable
                onPress={handleSend}
                disabled={!message.trim() || sending}
                style={({ pressed }) => ({
                  backgroundColor: message.trim() && !sending ? '#FF6B35' : '#E5E7EB',
                  borderRadius: 12,
                  padding: 14,
                  alignItems: 'center',
                  opacity: pressed ? 0.85 : 1,
                })}
              >
                <ThemedText
                  style={{
                    color: message.trim() && !sending ? '#fff' : '#9CA3AF',
                    fontWeight: '600',
                    fontSize: 16,
                  }}
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
