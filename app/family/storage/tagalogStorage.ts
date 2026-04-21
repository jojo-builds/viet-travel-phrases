import { createPhrasebookStorage } from './createPhrasebookStorage';

export const tagalogStorage = createPhrasebookStorage({
  favoritePrefix: 'tagalog-saved-',
  favoriteTimestampPrefix: 'tagalog-saved-ts-',
  visitedPrefix: 'tagalog-visited-',
});
