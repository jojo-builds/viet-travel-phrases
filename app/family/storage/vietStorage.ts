import { createPhrasebookStorage } from './createPhrasebookStorage';

export const vietStorage = createPhrasebookStorage({
  favoritePrefix: 'saved-',
  favoriteTimestampPrefix: 'saved-ts-',
  visitedPrefix: 'visited-',
});
