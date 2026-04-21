import AsyncStorage from '@react-native-async-storage/async-storage';
import { createContext, PropsWithChildren, useContext, useEffect, useState } from 'react';
import { currentApp } from '../family/currentApp';

export type AudioPlaybackSpeedOption = '0.5x' | '0.75x' | '1.0x';

type AudioPlaybackPreferenceContextValue = {
  isLoaded: boolean;
  option: AudioPlaybackSpeedOption;
  rate: number;
  setOption: (nextOption: AudioPlaybackSpeedOption) => Promise<void>;
};

export const AUDIO_PLAYBACK_SPEED_RATES: Record<AudioPlaybackSpeedOption, number> = {
  '0.5x': 0.5,
  '0.75x': 0.75,
  '1.0x': 1,
};

const audioPlaybackPreferenceStorageKey = `audio-playback-speed:${currentApp.variant}`;
const AudioPlaybackPreferenceContext = createContext<AudioPlaybackPreferenceContextValue | null>(null);

function normalizeAudioPlaybackSpeedOption(value: string | null | undefined): AudioPlaybackSpeedOption {
  if (!value) {
    return '1.0x';
  }

  const normalizedValue = value.trim().toLowerCase();
  if (normalizedValue === 'slow') {
    return '0.75x';
  }

  if (normalizedValue === 'normal') {
    return '1.0x';
  }

  if (normalizedValue === '0.5x' || normalizedValue === '0.50x' || normalizedValue === '0.5') {
    return '0.5x';
  }

  if (normalizedValue === '0.75x' || normalizedValue === '0.75') {
    return '0.75x';
  }

  if (
    normalizedValue === '1.0x' ||
    normalizedValue === '1x' ||
    normalizedValue === '1.0' ||
    normalizedValue === '1'
  ) {
    return '1.0x';
  }

  const parsedRate = Number.parseFloat(normalizedValue.replace(/x$/i, ''));
  if (Number.isFinite(parsedRate) && parsedRate > 0) {
    const supportedOptions = Object.entries(AUDIO_PLAYBACK_SPEED_RATES) as Array<
      [AudioPlaybackSpeedOption, number]
    >;

    return supportedOptions.reduce((closestOption, currentOption) => {
      const [, closestRate] = closestOption;
      const [, currentRate] = currentOption;
      return Math.abs(parsedRate - currentRate) < Math.abs(parsedRate - closestRate)
        ? currentOption
        : closestOption;
    })[0];
  }

  return '1.0x';
}

export function getAudioPlaybackRate(option: AudioPlaybackSpeedOption) {
  return AUDIO_PLAYBACK_SPEED_RATES[option];
}

export function formatAudioPlaybackRate(rate: number) {
  if (Math.abs(rate - 1) < 0.001) {
    return '1.0x';
  }

  return `${rate.toFixed(2).replace(/0$/, '').replace(/\.0$/, '')}x`;
}

export function AudioPlaybackPreferenceProvider({ children }: PropsWithChildren) {
  const [isLoaded, setIsLoaded] = useState(false);
  const [option, setOptionState] = useState<AudioPlaybackSpeedOption>('1.0x');

  useEffect(() => {
    let active = true;

    (async () => {
      try {
        const storedValue = await AsyncStorage.getItem(audioPlaybackPreferenceStorageKey);
        const storedOption = normalizeAudioPlaybackSpeedOption(storedValue);

        if (active) {
          setOptionState(storedOption);
        }

        if (storedValue != null && storedValue !== storedOption) {
          if (storedOption === '1.0x') {
            await AsyncStorage.removeItem(audioPlaybackPreferenceStorageKey);
          } else {
            await AsyncStorage.setItem(audioPlaybackPreferenceStorageKey, storedOption);
          }
        }
      } catch (error) {
        console.error('Failed to load audio playback preference', error);
      } finally {
        if (active) {
          setIsLoaded(true);
        }
      }
    })();

    return () => {
      active = false;
    };
  }, []);

  const setOption = async (nextOption: AudioPlaybackSpeedOption) => {
    const normalizedOption = normalizeAudioPlaybackSpeedOption(nextOption);
    setOptionState(normalizedOption);

    try {
      if (normalizedOption === '1.0x') {
        await AsyncStorage.removeItem(audioPlaybackPreferenceStorageKey);
      } else {
        await AsyncStorage.setItem(audioPlaybackPreferenceStorageKey, normalizedOption);
      }
    } catch (error) {
      console.error('Failed to persist audio playback preference', error);
    }
  };

  return (
    <AudioPlaybackPreferenceContext.Provider
      value={{
        isLoaded,
        option,
        rate: getAudioPlaybackRate(option),
        setOption,
      }}
    >
      {children}
    </AudioPlaybackPreferenceContext.Provider>
  );
}

export function useAudioPlaybackPreference() {
  const value = useContext(AudioPlaybackPreferenceContext);
  if (!value) {
    throw new Error('useAudioPlaybackPreference must be used inside AudioPlaybackPreferenceProvider.');
  }

  return value;
}
