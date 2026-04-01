import AsyncStorage from '@react-native-async-storage/async-storage';

const SAVED_PREFIX = 'saved-';
const SAVED_TS_PREFIX = 'saved-ts-';

export type SavedPhraseMeta = { id: string; savedAt: number };

const savedKey = (id: string) => `${SAVED_PREFIX}${id}`;
const tsKey = (id: string) => `${SAVED_TS_PREFIX}${id}`;

export async function getFavoriteIds(): Promise<string[]> {
  try {
    const keys = await AsyncStorage.getAllKeys();
    return keys
      .filter((key) => key.startsWith(SAVED_PREFIX) && !key.startsWith(SAVED_TS_PREFIX))
      .map((key) => key.replace(SAVED_PREFIX, ''));
  } catch (error) {
    console.error('Failed to read favorites', error);
    return [];
  }
}

export async function getSavedPhraseMeta(): Promise<SavedPhraseMeta[]> {
  try {
    const ids = await getFavoriteIds();
    const tsKeys = ids.map(tsKey);
    const tsPairs = await AsyncStorage.multiGet(tsKeys);
    return ids
      .map((id, index) => ({ id, savedAt: Number(tsPairs[index]?.[1] ?? '0') || 0 }))
      .sort((a, b) => b.savedAt - a.savedAt);
  } catch (error) {
    console.error('Failed to read saved phrase metadata', error);
    return [];
  }
}

export async function isFavorite(id: string): Promise<boolean> {
  try {
    return (await AsyncStorage.getItem(savedKey(id))) === '1';
  } catch (error) {
    console.error('Failed to read favorite state', error);
    return false;
  }
}

export async function setFavorite(id: string, next: boolean): Promise<boolean> {
  try {
    if (next) {
      const now = Date.now().toString();
      await AsyncStorage.multiSet([[savedKey(id), '1'], [tsKey(id), now]]);
      return true;
    }
    await AsyncStorage.multiRemove([savedKey(id), tsKey(id)]);
    return false;
  } catch (error) {
    console.error('Failed to write favorite state', error);
    return !(await isFavorite(id));
  }
}

export async function toggleFavoriteId(id: string): Promise<string[]> {
  const next = !(await isFavorite(id));
  await setFavorite(id, next);
  return getFavoriteIds();
}
