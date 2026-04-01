import { Tabs } from 'expo-router';
import { Text } from 'react-native';

export default function TabsLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: '#FF6B35',
        tabBarStyle: { backgroundColor: '#FFFFFF', borderTopColor: '#E5E7EB' },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{ title: 'Learn', tabBarIcon: ({ color }) => <TabIcon color={color} label="⌂" /> }}
      />
      <Tabs.Screen
        name="saved"
        options={{ title: 'Saved', tabBarIcon: ({ color }) => <TabIcon color={color} label="♥" /> }}
      />
    </Tabs>
  );
}

function TabIcon({ color, label }: { color: string; label: string }) {
  return <Text style={{ color, fontSize: 16 }}>{label}</Text>;
}
