import { AudioProvider } from '../contracts';

type Registry = Record<string, number>;

export function createRegistryAudioProvider(registry: Registry): AudioProvider {
  return {
    resolveAudioSource(audioKey) {
      return registry[`${audioKey}.mp3`];
    },
    hasAudio(audioKey) {
      return Object.prototype.hasOwnProperty.call(registry, `${audioKey}.mp3`);
    },
  };
}
