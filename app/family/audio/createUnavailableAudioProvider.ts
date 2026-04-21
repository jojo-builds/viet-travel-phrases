import { AudioProvider } from '../contracts';

export function createUnavailableAudioProvider(): AudioProvider {
  return {
    resolveAudioSource() {
      return undefined;
    },
    hasAudio() {
      return false;
    },
  };
}
