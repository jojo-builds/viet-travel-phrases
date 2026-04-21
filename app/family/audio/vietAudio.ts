import audioRegistry from '../../assets/audio/registry';
import { createRegistryAudioProvider } from './createRegistryAudioProvider';

export const vietAudioProvider = createRegistryAudioProvider(audioRegistry);
