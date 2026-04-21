import { appRegistry } from '../family/appRegistry';
import { getAccessibleVisibleEntryCountForPack } from '../lib/contentAccess';
import {
  resolvePremiumSource,
  shouldClearStoredPurchaseAccess,
  toStoredPremiumAccess,
} from '../lib/premiumAccessState';
import { searchPhrases } from '../lib/searchPhrases';
import { tagalogPack } from '../family/packs/tagalog';
import { vietPack } from '../family/packs/viet';
import { tagalogPresentation } from '../family/presentation/tagalog';
import { vietPresentation } from '../family/presentation/viet';

function assert(condition: unknown, message: string): asserts condition {
  if (!condition) {
    throw new Error(message);
  }
}

function validateRegistry() {
  const seenProductIds = new Set<string>();

  for (const variant of Object.keys(appRegistry) as Array<keyof typeof appRegistry>) {
    const definition = appRegistry[variant];
    const productId = definition.build.premiumProductId;

    assert(productId, `${variant} is missing premiumProductId.`);
    assert(!seenProductIds.has(productId), `Duplicate premiumProductId "${productId}" detected.`);
    seenProductIds.add(productId);
  }
}

function validateVietBoundary() {
  const starterVisibleCount = getAccessibleVisibleEntryCountForPack(vietPack, false);
  const fullVisibleCount = getAccessibleVisibleEntryCountForPack(vietPack, true);
  const premiumVisibleCount = fullVisibleCount - starterVisibleCount;
  const liveCategoryCount = vietPresentation.premium.categories.filter((category) => category.availability === 'live').length;

  assert(starterVisibleCount === 150, `Expected 150 Viet starter visible entries, found ${starterVisibleCount}.`);
  assert(fullVisibleCount === 900, `Expected 900 Viet total visible entries, found ${fullVisibleCount}.`);
  assert(premiumVisibleCount === 750, `Expected 750 Viet premium visible entries, found ${premiumVisibleCount}.`);
  assert(liveCategoryCount === 18, `Expected 18 Viet live categories, found ${liveCategoryCount}.`);
  assert(vietPresentation.premium.priceLabel === '$4.99', `Expected Viet premium price label to be "$4.99".`);

  const lockedResults = searchPhrases(vietPack, 'charged twice', false);
  const unlockedResults = searchPhrases(vietPack, 'charged twice', true);
  assert(
    !lockedResults.some((result) => result.phrase.id === 'help-4'),
    'Locked Viet search leaked premium phrase "help-4".',
  );
  assert(
    unlockedResults.some((result) => result.phrase.id === 'help-4'),
    'Unlocked Viet search failed to surface premium phrase "help-4".',
  );
}

function validateTagalogInheritance() {
  assert(tagalogPresentation.premium.priceLabel === '$4.99', 'Tagalog premium price label did not inherit $4.99.');
  assert(
    tagalogPresentation.premium.unlockModelLabel === 'One-time unlock',
    'Tagalog premium unlock model drifted away from one-time unlock.',
  );
  assert(tagalogPack.metadata.displayName === 'SpeakLocal Philippines', 'Tagalog pack display name did not inherit the new name.');
}

function validatePremiumStateMachine() {
  const storedPurchase = toStoredPremiumAccess({
    productId: 'com.jojobuilds.viettravelphrases.premiumunlock',
    transactionDate: 123,
    transactionId: 'txn-1',
  });

  assert(
    shouldClearStoredPurchaseAccess(storedPurchase, {
      entitlements: [],
      isLoaded: true,
      status: 'ready',
    }),
    'Stored purchase access should clear when StoreKit is loaded and reports no entitlement.',
  );

  assert(
    !shouldClearStoredPurchaseAccess(storedPurchase, {
      entitlements: [],
      isLoaded: false,
      status: 'ready',
    }),
    'Stored purchase access should not clear before the adapter finishes loading.',
  );

  assert(
    !shouldClearStoredPurchaseAccess(
      {
        source: 'preview',
        unlockedAt: 123,
      },
      {
        entitlements: [],
        isLoaded: true,
        status: 'ready',
      },
    ),
    'Preview unlock state should not be treated like a stale purchase entitlement.',
  );

  assert(resolvePremiumSource(null, []) === 'none', 'Empty premium state should resolve to "none".');
  assert(
    resolvePremiumSource(null, [
      {
        productId: 'com.jojobuilds.viettravelphrases.premiumunlock',
        transactionDate: 123,
      },
    ]) === 'purchase',
    'Live entitlements should resolve premium source to "purchase".',
  );
}

function main() {
  validateRegistry();
  validateVietBoundary();
  validateTagalogInheritance();
  validatePremiumStateMachine();

  console.log('Premium boundary validation passed.');
}

try {
  main();
} catch (error) {
  console.error(error);
  process.exitCode = 1;
}
