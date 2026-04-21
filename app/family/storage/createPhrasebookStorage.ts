import AsyncStorage from '@react-native-async-storage/async-storage';
import { PhrasebookStorage, SavedPhraseMeta } from '../contracts';

type StorageConfig = {
  favoritePrefix: string;
  favoriteTimestampPrefix: string;
  visitedPrefix: string;
};

export function createPhrasebookStorage(config: StorageConfig): PhrasebookStorage {
  const favoriteKey = (id: string) => `${config.favoritePrefix}${id}`;
  const favoriteTimestampKey = (id: string) => `${config.favoriteTimestampPrefix}${id}`;
  const visitedKey = (id: string) => `${config.visitedPrefix}${id}`;

  async function getFavoriteIds(): Promise<string[]> {
    try {
      const keys = await AsyncStorage.getAllKeys();
      return keys
        .filter(
          (key) =>
            key.startsWith(config.favoritePrefix) &&
            !key.startsWith(config.favoriteTimestampPrefix),
        )
        .map((key) => key.replace(config.favoritePrefix, ''));
    } catch (error) {
      console.error('Failed to read favorites', error);
      return [];
    }
  }

  async function getSavedPhraseMeta(): Promise<SavedPhraseMeta[]> {
    try {
      const ids = await getFavoriteIds();
      const timestampPairs = await AsyncStorage.multiGet(ids.map(favoriteTimestampKey));
      return ids
        .map((id, index) => ({ id, savedAt: Number(timestampPairs[index]?.[1] ?? '0') || 0 }))
        .sort((left, right) => right.savedAt - left.savedAt);
    } catch (error) {
      console.error('Failed to read saved phrase metadata', error);
      return [];
    }
  }

  async function isFavorite(id: string): Promise<boolean> {
    try {
      return (await AsyncStorage.getItem(favoriteKey(id))) === '1';
    } catch (error) {
      console.error('Failed to read favorite state', error);
      return false;
    }
  }

  async function setFavorite(id: string, next: boolean): Promise<boolean> {
    try {
      if (next) {
        const now = Date.now().toString();
        await AsyncStorage.multiSet([[favoriteKey(id), '1'], [favoriteTimestampKey(id), now]]);
        return true;
      }

      await AsyncStorage.multiRemove([favoriteKey(id), favoriteTimestampKey(id)]);
      return false;
    } catch (error) {
      console.error('Failed to write favorite state', error);
      return !(await isFavorite(id));
    }
  }

  async function toggleFavoriteId(id: string): Promise<string[]> {
    const next = !(await isFavorite(id));
    await setFavorite(id, next);
    return getFavoriteIds();
  }

  async function getVisitedScenarioMap(scenarioIds: string[]): Promise<Record<string, boolean>> {
    try {
      const pairs = await AsyncStorage.multiGet(scenarioIds.map(visitedKey));
      return Object.fromEntries(
        pairs.map(([key, value]) => [key.replace(config.visitedPrefix, ''), value === '1']),
      );
    } catch (error) {
      console.error('Failed to read visited scenarios', error);
      return {};
    }
  }

  async function markScenarioVisited(scenarioId: string): Promise<void> {
    try {
      await AsyncStorage.setItem(visitedKey(scenarioId), '1');
    } catch (error) {
      console.error('Failed to save visited scenario', error);
    }
  }

  return {
    getFavoriteIds,
    getSavedPhraseMeta,
    isFavorite,
    setFavorite,
    toggleFavoriteId,
    getVisitedScenarioMap,
    markScenarioVisited,
  };
}
