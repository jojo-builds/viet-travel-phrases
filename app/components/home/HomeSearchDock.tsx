import { useEffect, useRef } from 'react';
import { Animated, Pressable, TextInput, View } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { currentApp } from '../../family/currentApp';
import { useKeyboardInset } from '../../lib/useKeyboardInset';

type Props = {
  query: string;
  isFocused: boolean;
  isCollapsed: boolean;
  bottomOffset: number;
  onChangeQuery: (next: string) => void;
  onFocus: () => void;
  onBlur: () => void;
  onClearQuery: () => void;
};

export function HomeSearchDock({
  query,
  isFocused,
  isCollapsed,
  bottomOffset,
  onChangeQuery,
  onFocus,
  onBlur,
  onClearQuery,
}: Props) {
  const search = currentApp.presentation.search;
  const keyboardInset = useKeyboardInset();
  const translateY = useRef(new Animated.Value(0)).current;
  const trimmedQuery = query.trim();
  const isExpanded = isFocused || trimmedQuery.length > 0 || !isCollapsed;

  useEffect(() => {
    Animated.timing(translateY, {
      toValue: isCollapsed && !isFocused && trimmedQuery.length === 0 ? 12 : 0,
      duration: 180,
      useNativeDriver: true,
    }).start();
  }, [isCollapsed, isFocused, trimmedQuery.length, translateY]);

  return (
    <Animated.View
      style={{
        bottom: keyboardInset > 0 ? keyboardInset + 4 : bottomOffset + 4,
        transform: [{ translateY }],
      }}
      className="absolute inset-x-0 px-5"
      pointerEvents="box-none"
      testID="home-search-dock"
    >
      <View className={`rounded-[24px] border border-border bg-surface shadow-sm ${isExpanded ? 'px-4 py-2.5' : 'px-4 py-2'}`}>
        <View className="flex-row items-center gap-3">
          <View className="h-9 w-9 items-center justify-center rounded-full bg-surface-soft">
            <Ionicons name="search-outline" size={18} color="#64748B" />
          </View>
          <TextInput
            accessibilityLabel={search.placeholder}
            autoCapitalize="none"
            autoCorrect={false}
            blurOnSubmit={false}
            className="flex-1 text-[16px] text-text-primary"
            onBlur={onBlur}
            onChangeText={onChangeQuery}
            onFocus={onFocus}
            placeholder={search.placeholder}
            placeholderTextColor="#94A3B8"
            returnKeyType="search"
            testID="home-search-input"
            value={query}
          />

          {trimmedQuery.length > 0 ? (
            <Pressable
              accessibilityLabel={search.clearLabel}
              className="h-8 w-8 items-center justify-center"
              onPress={onClearQuery}
              style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
              testID="home-search-clear"
            >
              <Ionicons name="close-circle" size={20} color="#94A3B8" />
            </Pressable>
          ) : null}
        </View>
      </View>
    </Animated.View>
  );
}
