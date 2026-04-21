import { PremiumActionResult } from './premiumAccess';
import { PremiumStoreStatus } from './premiumAccessState';

export function getPremiumStoreStatusMessage(storeStatus: PremiumStoreStatus) {
  switch (storeStatus) {
    case 'unsupported-platform':
      return 'Buy and restore work only in the standalone iPhone app. They are not available in Expo Go, web, or Android.';
    case 'missing-product-id':
      return 'Full Trip Pack is not available in this build.';
    case 'connecting':
      return 'Connecting to the App Store...';
    case 'connection-failed':
      return 'App Store is not available right now. If you are testing purchase, confirm network access and App Store sign-in on this iPhone.';
    case 'product-unavailable':
      return 'We could not load Full Trip Pack from the App Store yet. Confirm the App Store Connect item for this build before testing purchase.';
    case 'ready':
    default:
      return null;
  }
}

export function getPremiumActionAlert(result: PremiumActionResult) {
  if (result.ok || result.type === 'purchase-cancelled') {
    return null;
  }

  switch (result.type) {
    case 'missing-product-id':
      return {
        title: 'Not available right now',
        message: 'Full Trip Pack is not available in this build.',
      };
    case 'unsupported-platform':
      return {
        title: 'App Store purchase unavailable',
        message: 'Use the standalone iPhone app to buy or restore Full Trip Pack.',
      };
    case 'store-connection-failed':
      return {
        title: 'App Store unavailable',
        message: 'App Store is not available right now. Confirm network access and App Store sign-in on this iPhone.',
      };
    case 'product-unavailable':
      return {
        title: 'Full Trip Pack unavailable',
        message: 'We could not load Full Trip Pack from the App Store yet. Confirm the App Store Connect item for this build before testing purchase.',
      };
    case 'nothing-to-restore':
      return {
        title: 'No purchase found to restore',
        message: 'No previous Full Trip Pack purchase was found for this Apple account.',
      };
    case 'store-error':
    default:
      return {
        title: 'Something went wrong',
        message: result.message ?? 'Please try again.',
      };
  }
}
