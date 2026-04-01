import AsyncStorage from '@react-native-async-storage/async-storage';

const FAVORITES_KEY = 'viet-travel-phrases:favorites';

export async function getFavoriteIds(): Promise<string[]> {
  const raw = await AsyncStorage.getItem(FAVORITES_KEY);
  return raw ? (JSON.parse(raw) as string[]) : [];
}

export async function setFavoriteIds(ids: string[]): Promise<void> {
  await AsyncStorage.setItem(FAVORITES_KEY, JSON.stringify(ids));
}

export async function toggleFavoriteId(id: string): Promise<string[]> {
  const existing = await getFavoriteIds();
  const next = existing.includes(id)
    ? existing.filter((item) => item !== id)
    : [...existing, id];
  await setFavoriteIds(next);
  return next;
}
