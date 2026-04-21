export type StoredPremiumAccess = {
  source: 'preview' | 'purchase';
  unlockedAt: number;
  productId?: string;
  transactionId?: string;
};

export type PremiumStoreStatus =
  | 'unsupported-platform'
  | 'missing-product-id'
  | 'connecting'
  | 'ready'
  | 'product-unavailable'
  | 'connection-failed';

export type PremiumEntitlement = {
  productId: string;
  transactionId?: string;
  transactionDate?: number;
};

type PremiumAdapterSnapshot = {
  entitlements: PremiumEntitlement[];
  isLoaded: boolean;
  status: PremiumStoreStatus;
};

export function normalizeStoredPremiumAccess(rawValue: string | null) {
  if (!rawValue) {
    return null;
  }

  const parsed = JSON.parse(rawValue) as Partial<StoredPremiumAccess>;

  if (parsed?.source !== 'preview' && parsed?.source !== 'purchase') {
    return null;
  }

  return {
    source: parsed.source,
    unlockedAt: typeof parsed.unlockedAt === 'number' ? parsed.unlockedAt : Date.now(),
    productId: typeof parsed.productId === 'string' ? parsed.productId : undefined,
    transactionId: typeof parsed.transactionId === 'string' ? parsed.transactionId : undefined,
  } satisfies StoredPremiumAccess;
}

export function getLatestEntitlement(entitlements: PremiumEntitlement[]) {
  return [...entitlements].sort((left, right) => (right.transactionDate ?? 0) - (left.transactionDate ?? 0))[0];
}

export function toStoredPremiumAccess(entitlement: PremiumEntitlement): StoredPremiumAccess {
  return {
    source: 'purchase',
    unlockedAt: entitlement.transactionDate ?? Date.now(),
    productId: entitlement.productId,
    transactionId: entitlement.transactionId,
  };
}

export function hasSamePurchaseAccess(current: StoredPremiumAccess | null, next: StoredPremiumAccess) {
  return (
    current?.source === 'purchase' &&
    current.productId === next.productId &&
    current.transactionId === next.transactionId &&
    current.unlockedAt === next.unlockedAt
  );
}

export function matchesProductId(entitlement: PremiumEntitlement, productId: string) {
  return entitlement.productId === productId;
}

export function normalizeEntitlements(productId: string, purchases: PremiumEntitlement[]) {
  return purchases.filter((purchase) => matchesProductId(purchase, productId));
}

export function shouldClearStoredPurchaseAccess(
  storedAccess: StoredPremiumAccess | null,
  adapterSnapshot: PremiumAdapterSnapshot,
) {
  return (
    storedAccess?.source === 'purchase' &&
    adapterSnapshot.isLoaded &&
    adapterSnapshot.status === 'ready' &&
    adapterSnapshot.entitlements.length === 0
  );
}

export function resolvePremiumSource(storedAccess: StoredPremiumAccess | null, entitlements: PremiumEntitlement[]) {
  return storedAccess?.source ?? (entitlements.length > 0 ? 'purchase' : 'none');
}
