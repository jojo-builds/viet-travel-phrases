import { Tabs } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import { currentApp } from '../../family/currentApp';

export default function TabsLayout() {
  const tabs = currentApp.presentation.tabs;

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: '#D97745',
        tabBarInactiveTintColor: '#64748B',
        tabBarShowLabel: true,
        tabBarLabelStyle: { fontSize: 11, fontWeight: '600' },
        tabBarStyle: {
          height: 74,
          paddingTop: 8,
          paddingBottom: 10,
          backgroundColor: '#FFFCF8',
          borderTopColor: '#E5DED3',
        },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: tabs.learnTitle,
          tabBarButtonTestID: 'tab-learn',
          tabBarIcon: ({ color, focused }) => (
            <Ionicons name={focused ? 'home' : 'home-outline'} size={22} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="saved"
        options={{
          title: tabs.savedTitle,
          tabBarButtonTestID: 'tab-saved',
          tabBarIcon: ({ color, focused }) => (
            <Ionicons name={focused ? 'heart' : 'heart-outline'} size={22} color={color} />
          ),
        }}
      />
    </Tabs>
  );
}
