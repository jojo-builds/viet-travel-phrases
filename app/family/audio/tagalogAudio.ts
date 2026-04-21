import audioRegistry from '../../assets/audio/tagalog/registry';
import { createRegistryAudioProvider } from './createRegistryAudioProvider';

export const tagalogAudioProvider = createRegistryAudioProvider(audioRegistry);
