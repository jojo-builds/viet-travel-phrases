import { Alert, Pressable, View } from 'react-native';
import * as Linking from 'expo-linking';
import { ThemedText } from '../components/ui/ThemedText';

const privacyUrl = 'https://example.com/privacy';

export default function SettingsScreen() {
  const openPrivacy = async () => {
    const supported = await Linking.canOpenURL(privacyUrl);
    if (!supported) {
      Alert.alert('Unable to open link', 'Please try again later.');
      return;
    }
    await Linking.openURL(privacyUrl);
  };

  return (
    <View className="flex-1 bg-background px-5 pt-16">
      <View className="space-y-6 rounded-2xl border border-border bg-surface p-5 shadow-sm">
        <ThemedText variant="title">Settings</ThemedText>
        <View className="space-y-2">
          <ThemedText variant="subtitle">App Info</ThemedText>
          <ThemedText>Vietnamese Travel Phrasebook V1 offline preview build.</ThemedText>
        </View>
        <Pressable onPress={() => void openPrivacy()} className="rounded-xl bg-primary px-4 py-3">
          <ThemedText className="text-center font-semibold text-white">Privacy Policy</ThemedText>
        </Pressable>
      </View>
    </View>
  );
}
