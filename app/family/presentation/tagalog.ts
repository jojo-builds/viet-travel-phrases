import { AppPresentationConfig } from '../contracts';
import { createSharedPremiumConfig } from './sharedPremium';

export const tagalogPresentation: AppPresentationConfig = {
  labels: {
    targetText: 'Tagalog',
    pronunciation: 'Pronunciation',
    sourceText: 'English',
  },
  tabs: {
    learnTitle: 'Phrasebook',
    savedTitle: 'Saved',
  },
  home: {
    greeting: 'Kumusta!',
    subtitle: 'Travel Tagalog for everyday situations in the Philippines',
    heroTitle: 'Travel phrases that stay practical when the trip gets real.',
    heroBody:
      'Use the essentials now, search quickly, and preview the fuller traveler library planned for real trips in the Philippines.',
    settingsLabel: 'Open settings',
    quickPhrasesTitle: 'Need a fast phrase?',
    quickPhrasesSubtitle: 'Tap a few ride, greeting, and basics phrases before you browse the full trip.',
    scenariosTitle: 'Start with these travel situations',
    scenariosSubtitle: 'The live starter pack already covers the most common travel moments.',
    libraryTitle: 'Browse the full library plan',
    librarySubtitle: 'The shared family frame keeps free access useful while premium expands category depth.',
    quickPhraseIds: [
      'tagalog-polite-basics-1',
      'tagalog-polite-basics-2',
      'tagalog-polite-basics-5',
      'tagalog-asking-price-1',
      'tagalog-polite-basics-4',
    ],
    scenarioOrder: [
      'coffee-shop',
      'street-food',
      'grab-taxi',
      'asking-price',
      'polite-basics',
      'convenience-store',
      'hotel-hostel',
      'directions',
      'simple-problems',
      'small-talk',
    ],
  },
  search: {
    placeholder: 'Search taxi, kumusta, check in, or how it sounds',
    resultsTitle: 'Results',
    emptyTitle: 'No phrases found',
    emptyBody: 'Try a travel word like taxi, kumusta, hotel, or price.',
    clearLabel: 'Clear search',
  },
  saved: {
    title: 'Saved for this trip',
    emptyIcon: 'heart-outline',
    emptyTitle: 'No saved phrases yet',
    emptyBody: 'Save a Tagalog phrase to keep it close for your next ride order or check-in.',
    scenarioPrefix: 'from',
  },
  scenario: {
    notFoundTitle: 'Scenario not found',
    notFoundBody: 'The phrase list for this route is missing or invalid.',
    tipFallback: 'Keep your phone ready and speak one short phrase at a time.',
    tipIcon: 'bulb-outline',
  },
  phrase: {
    audioUnavailableLabel: 'Audio unavailable',
  },
  premium: createSharedPremiumConfig({
    appName: 'SpeakLocal Philippines',
    language: 'Tagalog',
    country: 'the Philippines',
  }),
  settings: {
    title: 'Settings',
    audioSpeedTitle: 'Audio speed presets',
    audioSpeedBody: 'Use the same phrase audio at 0.5x, 0.75x, or 1.0x without downloading extra copies.',
    audioSpeedOptions: {
      halfSpeedLabel: '0.5x Extra Slow',
      halfSpeedBody: 'Best when you want careful listening and repeat-after-me practice.',
      threeQuarterSpeedLabel: '0.75x Slower',
      threeQuarterSpeedBody: 'A slower learner pace that stays closer to the natural rhythm.',
      normalLabel: '1.0x Normal',
      normalBody: 'The recorded phrase at its natural pace.',
    },
    sectionTitles: {
      about: 'About',
      legal: 'Legal',
      feedback: 'Feedback',
    },
    rowLabels: {
      aboutApp: 'About this app',
      privacy: 'Privacy Policy',
      terms: 'Terms of Use',
      sendFeedback: 'Send Feedback',
      rateApp: 'Rate this App',
    },
    aboutAlertTitle: 'SpeakLocal Philippines',
    aboutAlertBody:
      'Offline travel Tagalog for common situations in the Philippines.\n\nBuilt on the shared SpeakLocal family app seam.',
    rateComingSoonTitle: 'Coming soon',
    rateComingSoonBody: 'Store rating flow will be connected after the Tagalog release path is live.',
    footer: 'Version 1.0.0 | SpeakLocal Philippines',
    chevron: 'chevron-forward',
  },
  privacy: {
    title: 'Privacy Policy',
    effectiveDate: 'Effective: April 12, 2026',
    backLabel: 'Back',
    sections: [
      {
        title: 'Overview',
        body: 'SpeakLocal Philippines is an offline travel phrasebook. We do not collect, store, or transmit personal data through normal phrasebook use.',
      },
      {
        title: 'Local Storage',
        body: 'Saved phrases, visited scenarios, and local premium-access state are stored only on your device so you can return to useful phrases quickly.',
      },
      {
        title: 'Network Access',
        body: 'The phrasebook itself works offline. Feedback submission opens a web form only if you choose to send feedback.',
      },
      {
        title: 'Contact',
        body: 'Questions about the app can be sent through the in-app feedback flow.',
      },
    ],
  },
  terms: {
    title: 'Terms of Use',
    effectiveDate: 'Effective: April 12, 2026',
    backLabel: 'Back',
    sections: [
      {
        title: 'App Description',
        body: 'SpeakLocal Philippines is an offline phrasebook app that provides practical Tagalog phrases, pronunciation help, and saved-phrase support for common travel situations.',
      },
      {
        title: 'Content Accuracy',
        body: 'We aim for practical and clear travel phrases, but language varies by speaker and region. Use good judgment in real conversations.',
      },
      {
        title: 'Contact',
        body: 'Questions and correction requests can be sent through the in-app feedback flow.',
      },
    ],
  },
  feedback: {
    title: 'Send Feedback',
    formEndpoint: 'https://formspree.io/f/mojpkagy',
    subject: 'App Feedback - SpeakLocal Philippines',
    errorTitle: 'Error',
    errorBody: 'Could not send feedback. Please try again.',
    successIcon: 'OK',
    successTitle: 'Thanks!',
    successBody: 'Your feedback has been received.',
    placeholder: 'Tell us what felt unclear, awkward, or missing in the Tagalog app...',
    sendLabel: 'Send',
    sendingLabel: 'Sending...',
    closeIcon: 'X',
  },
  capabilities: {
    audio: true,
    favorites: true,
    pronunciation: true,
    search: true,
    flashcards: false,
    recents: false,
  },
};
