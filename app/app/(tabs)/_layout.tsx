import { Tabs } from 'expo-router';
import { ThemedText } from '../../components/ui/ThemedText';

export default function TabsLayout() {
  return (
    <Tabs
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarActiveTintColor: '#FF6B35',
        tabBarInactiveTintColor: '#9CA3AF',
        tabBarShowLabel: false,
        tabBarStyle: { backgroundColor: '#FFFFFF', borderTopColor: '#E5E7EB' },
        tabBarIcon: ({ color, focused }) => (
          <ThemedText className="text-lg" style={{ color }}>
            {route.name === 'saved' ? (focused ? '♥' : '♡') : focused ? '⌂' : '⌂'}
          </ThemedText>
        ),
      })}
    >
      <Tabs.Screen name="index" options={{ title: 'Home' }} />
      <Tabs.Screen name="saved" options={{ title: 'Saved' }} />
    </Tabs>
  );
}
