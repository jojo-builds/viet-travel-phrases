import AsyncStorage from '@react-native-async-storage/async-storage';
import {
  endConnection,
  fetchProducts,
  finishTransaction,
  getAvailablePurchases,
  initConnection,
  requestPurchase,
  restorePurchases,
  type Product,
} from 'expo-iap';
import {
  createContext,
  PropsWithChildren,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import { Platform } from 'react-native';
import { currentApp } from '../family/currentApp';
import { useDesignReview } from './designReview';
import {
  getLatestEntitlement,
  hasSamePurchaseAccess,
  matchesProductId,
  normalizeEntitlements,
  normalizeStoredPremiumAccess,
  PremiumEntitlement,
  PremiumStoreStatus,
  resolvePremiumSource,
  shouldClearStoredPurchaseAccess,
  StoredPremiumAccess,
  toStoredPremiumAccess,
} from './premiumAccessState';

export type PremiumActionResult =
  | {
      ok: true;
      type: 'purchased' | 'restored';
      productId: string;
      transactionId?: string;
      unlockedAt: number;
    }
  | {
      ok: false;
      type:
        | 'missing-product-id'
        | 'unsupported-platform'
        | 'store-connection-failed'
        | 'product-unavailable'
        | 'purchase-cancelled'
        | 'nothing-to-restore'
        | 'store-error';
      message?: string;
    };

export type PremiumPurchaseAdapter = {
  isLoaded: boolean;
  ready: boolean;
  restoreReady: boolean;
  priceLabel?: string;
  status: PremiumStoreStatus;
  entitlements: PremiumEntitlement[];
  purchase: (productId: string) => Promise<PremiumActionResult>;
  restore: (productId: string) => Promise<PremiumActionResult>;
};

type PremiumAccessContextValue = {
  isLoaded: boolean;
  isUnlocked: boolean;
  source: 'none' | 'preview' | 'purchase';
  isBusy: boolean;
  storeReady: boolean;
  restoreReady: boolean;
  storeStatus: PremiumStoreStatus;
  priceLabel: string;
  purchase: () => Promise<PremiumActionResult>;
  restore: () => Promise<PremiumActionResult>;
  enablePreviewUnlock: () => Promise<void>;
  clearPreviewUnlock: () => Promise<void>;
};

const premiumAccessStorageKey = `premium-access:${currentApp.variant}`;

function getErrorMessage(error: unknown) {
  if (error instanceof Error && error.message) {
    return error.message;
  }

  return 'Unknown store error.';
}

function getErrorCode(error: unknown) {
  if (typeof error === 'object' && error && 'code' in error && typeof error.code === 'string') {
    return error.code;
  }

  return undefined;
}

async function writeStoredPremiumAccess(next: StoredPremiumAccess | null) {
  if (!next) {
    await AsyncStorage.removeItem(premiumAccessStorageKey);
    return;
  }

  await AsyncStorage.setItem(premiumAccessStorageKey, JSON.stringify(next));
}

export function createPlaceholderPremiumAdapter(): PremiumPurchaseAdapter {
  return {
    isLoaded: true,
    ready: false,
    restoreReady: false,
    status: 'unsupported-platform',
    entitlements: [],
    async purchase(productId) {
      if (!productId) {
        return { ok: false, type: 'missing-product-id' };
      }

      return { ok: false, type: 'unsupported-platform' };
    },
    async restore(productId) {
      if (!productId) {
        return { ok: false, type: 'missing-product-id' };
      }

      return { ok: false, type: 'unsupported-platform' };
    },
  };
}

function useNativePremiumAdapter(productId?: string): PremiumPurchaseAdapter {
  const [isLoaded, setIsLoaded] = useState(false);
  const [status, setStatus] = useState<PremiumStoreStatus>(() => {
    if (!productId) {
      return 'missing-product-id';
    }

    if (Platform.OS !== 'ios') {
      return 'unsupported-platform';
    }

    return 'connecting';
  });
  const [product, setProduct] = useState<Product | undefined>(undefined);
  const [entitlements, setEntitlements] = useState<PremiumEntitlement[]>([]);
  const activeRef = useRef(true);

  const supported = Platform.OS === 'ios' && Boolean(productId);

  const refreshStoreState = useCallback(async () => {
    if (!productId) {
      if (activeRef.current) {
        setProduct(undefined);
        setEntitlements([]);
        setStatus('missing-product-id');
        setIsLoaded(true);
      }

      return {
        product: undefined,
        entitlements: [] as PremiumEntitlement[],
      };
    }

    if (Platform.OS !== 'ios') {
      if (activeRef.current) {
        setProduct(undefined);
        setEntitlements([]);
        setStatus('unsupported-platform');
        setIsLoaded(true);
      }

      return {
        product: undefined,
        entitlements: [] as PremiumEntitlement[],
      };
    }

    let resolvedProduct: Product | undefined;
    try {
      const products =
        (await fetchProducts({
          skus: [productId],
          type: 'in-app',
        })) ?? [];

      resolvedProduct = products.find(
        (candidate): candidate is Product => candidate.type === 'in-app' && candidate.id === productId,
      );
    } catch {
      resolvedProduct = undefined;
    }

    const purchases = await getAvailablePurchases({
      alsoPublishToEventListenerIOS: false,
      onlyIncludeActiveItemsIOS: true,
    });

    const resolvedEntitlements = normalizeEntitlements(
      productId,
      purchases.map((purchase) => ({
        productId: purchase.productId,
        transactionId: purchase.transactionId ?? undefined,
        transactionDate: purchase.transactionDate,
      })),
    );

    if (activeRef.current) {
      setProduct(resolvedProduct);
      setEntitlements(resolvedEntitlements);
      setStatus(resolvedProduct ? 'ready' : 'product-unavailable');
      setIsLoaded(true);
    }

    return {
      product: resolvedProduct,
      entitlements: resolvedEntitlements,
    };
  }, [productId]);

  useEffect(() => {
    activeRef.current = true;

    if (!productId) {
      setStatus('missing-product-id');
      setIsLoaded(true);
      return () => {
        activeRef.current = false;
      };
    }

    if (Platform.OS !== 'ios') {
      setStatus('unsupported-platform');
      setIsLoaded(true);
      return () => {
        activeRef.current = false;
      };
    }

    let shouldCloseConnection = false;

    const connectToStore = async () => {
      setStatus('connecting');
      setIsLoaded(false);

      try {
        const connected = await initConnection();
        shouldCloseConnection = connected;

        if (!connected) {
          if (activeRef.current) {
            setStatus('connection-failed');
            setIsLoaded(true);
          }
          return;
        }

        await refreshStoreState();
      } catch {
        if (activeRef.current) {
          setStatus('connection-failed');
          setIsLoaded(true);
        }
      }
    };

    void connectToStore();

    return () => {
      activeRef.current = false;
      if (shouldCloseConnection) {
        void endConnection().catch(() => undefined);
      }
    };
  }, [productId, refreshStoreState]);

  const purchase = useCallback(
    async (requestedProductId: string): Promise<PremiumActionResult> => {
      if (!requestedProductId) {
        return { ok: false, type: 'missing-product-id' };
      }

      if (Platform.OS !== 'ios') {
        return { ok: false, type: 'unsupported-platform' };
      }

      if (!supported || status === 'connection-failed') {
        return { ok: false, type: 'store-connection-failed' };
      }

      if (!product || product.id !== requestedProductId) {
        return { ok: false, type: 'product-unavailable' };
      }

      try {
        const result = await requestPurchase({
          request: {
            apple: {
              sku: requestedProductId,
            },
          },
          type: 'in-app',
        });

        const purchaseResult = Array.isArray(result) ? result[0] : result;

        if (!purchaseResult) {
          return { ok: false, type: 'purchase-cancelled' };
        }

        if (purchaseResult.purchaseState !== 'purchased') {
          return {
            ok: false,
            type: 'store-error',
            message: `Purchase state returned "${purchaseResult.purchaseState}".`,
          };
        }

        await finishTransaction({
          purchase: purchaseResult,
          isConsumable: false,
        });

        const refreshedState = await refreshStoreState();
        const confirmedEntitlement =
          getLatestEntitlement(refreshedState.entitlements) ??
          (purchaseResult.productId === requestedProductId
            ? {
                productId: purchaseResult.productId,
                transactionId: purchaseResult.transactionId ?? undefined,
                transactionDate: purchaseResult.transactionDate,
              }
            : undefined);

        if (!confirmedEntitlement || !matchesProductId(confirmedEntitlement, requestedProductId)) {
          return {
            ok: false,
            type: 'store-error',
            message: 'Purchase completed but the entitlement could not be confirmed yet.',
          };
        }

        return {
          ok: true,
          type: 'purchased',
          productId: confirmedEntitlement.productId,
          transactionId: confirmedEntitlement.transactionId,
          unlockedAt: confirmedEntitlement.transactionDate ?? Date.now(),
        };
      } catch (error) {
        const errorCode = getErrorCode(error);
        const message = getErrorMessage(error);
        if (errorCode === 'user-cancelled' || message.toLowerCase().includes('user-cancelled')) {
          return { ok: false, type: 'purchase-cancelled' };
        }

        return {
          ok: false,
          type: 'store-error',
          message,
        };
      }
    },
    [product, refreshStoreState, status, supported],
  );

  const restore = useCallback(
    async (requestedProductId: string): Promise<PremiumActionResult> => {
      if (!requestedProductId) {
        return { ok: false, type: 'missing-product-id' };
      }

      if (Platform.OS !== 'ios') {
        return { ok: false, type: 'unsupported-platform' };
      }

      if (!supported || status === 'connection-failed') {
        return { ok: false, type: 'store-connection-failed' };
      }

      try {
        await restorePurchases();
        const refreshedState = await refreshStoreState();
        const restoredEntitlement = getLatestEntitlement(refreshedState.entitlements);

        if (!restoredEntitlement || !matchesProductId(restoredEntitlement, requestedProductId)) {
          return {
            ok: false,
            type: 'nothing-to-restore',
          };
        }

        return {
          ok: true,
          type: 'restored',
          productId: restoredEntitlement.productId,
          transactionId: restoredEntitlement.transactionId,
          unlockedAt: restoredEntitlement.transactionDate ?? Date.now(),
        };
      } catch (error) {
        return {
          ok: false,
          type: 'store-error',
          message: getErrorMessage(error),
        };
      }
    },
    [refreshStoreState, status, supported],
  );

  return useMemo(
    () => ({
      isLoaded,
      ready: supported && status === 'ready' && Boolean(product),
      restoreReady: supported && status !== 'connecting' && status !== 'connection-failed',
      priceLabel: product?.displayPrice,
      status,
      entitlements,
      purchase,
      restore,
    }),
    [entitlements, isLoaded, product, purchase, restore, status, supported],
  );
}

const PremiumAccessContext = createContext<PremiumAccessContextValue | null>(null);

type PremiumAccessProviderProps = PropsWithChildren<{
  adapter?: PremiumPurchaseAdapter;
}>;

type PremiumAccessProviderBridgeProps = PropsWithChildren<{
  adapter: PremiumPurchaseAdapter;
}>;

function PremiumAccessProviderBridge({ children, adapter }: PremiumAccessProviderBridgeProps) {
  const { premiumOverride } = useDesignReview();
  const [storedAccess, setStoredAccess] = useState<StoredPremiumAccess | null>(null);
  const [storageLoaded, setStorageLoaded] = useState(false);
  const [isBusy, setIsBusy] = useState(false);

  useEffect(() => {
    let active = true;

    (async () => {
      try {
        const nextStoredAccess = normalizeStoredPremiumAccess(await AsyncStorage.getItem(premiumAccessStorageKey));
        if (!active) {
          return;
        }

        if (nextStoredAccess?.source === 'preview') {
          if (__DEV__) {
            setStoredAccess(nextStoredAccess);
          } else {
            await writeStoredPremiumAccess(null);
          }
          return;
        }

        setStoredAccess(nextStoredAccess);
      } catch (error) {
        console.error('Failed to load premium access state', error);
      } finally {
        if (active) {
          setStorageLoaded(true);
        }
      }
    })();

    return () => {
      active = false;
    };
  }, []);

  useEffect(() => {
    const latestEntitlement = getLatestEntitlement(adapter.entitlements);
    if (!storageLoaded || !latestEntitlement) {
      return;
    }

    const nextState = toStoredPremiumAccess(latestEntitlement);

    if (hasSamePurchaseAccess(storedAccess, nextState)) {
      return;
    }

    setStoredAccess(nextState);
    void writeStoredPremiumAccess(nextState).catch((error) => {
      console.error('Failed to persist premium access state', error);
    });
  }, [adapter.entitlements, storageLoaded, storedAccess]);

  useEffect(() => {
    if (
      !storageLoaded ||
      !shouldClearStoredPurchaseAccess(storedAccess, {
        entitlements: adapter.entitlements,
        isLoaded: adapter.isLoaded,
        status: adapter.status,
      })
    ) {
      return;
    }

    setStoredAccess(null);
    void writeStoredPremiumAccess(null).catch((error) => {
      console.error('Failed to clear stale premium access state', error);
    });
  }, [adapter.entitlements, adapter.isLoaded, adapter.status, storageLoaded, storedAccess]);

  const purchase = useCallback(async () => {
    setIsBusy(true);
    try {
      const result = await adapter.purchase(currentApp.build.premiumProductId ?? '');
      if (result.ok) {
        const nextState: StoredPremiumAccess = {
          source: 'purchase',
          unlockedAt: result.unlockedAt,
          productId: result.productId,
          transactionId: result.transactionId,
        };
        setStoredAccess(nextState);
        await writeStoredPremiumAccess(nextState);
      }

      return result;
    } finally {
      setIsBusy(false);
    }
  }, [adapter]);

  const restore = useCallback(async () => {
    setIsBusy(true);
    try {
      const result = await adapter.restore(currentApp.build.premiumProductId ?? '');
      if (result.ok) {
        const nextState: StoredPremiumAccess = {
          source: 'purchase',
          unlockedAt: result.unlockedAt,
          productId: result.productId,
          transactionId: result.transactionId,
        };
        setStoredAccess(nextState);
        await writeStoredPremiumAccess(nextState);
      }

      return result;
    } finally {
      setIsBusy(false);
    }
  }, [adapter]);

  const enablePreviewUnlock = useCallback(async () => {
    if (!__DEV__) {
      return;
    }

    const nextState: StoredPremiumAccess = {
      source: 'preview',
      unlockedAt: Date.now(),
    };
    setStoredAccess(nextState);
    await writeStoredPremiumAccess(nextState);
  }, []);

  const clearPreviewUnlock = useCallback(async () => {
    if (!storedAccess || storedAccess.source !== 'preview') {
      return;
    }

    setStoredAccess(null);
    await writeStoredPremiumAccess(null);
  }, [storedAccess]);

  const source =
    typeof premiumOverride === 'boolean'
      ? premiumOverride
        ? 'preview'
        : 'none'
      : resolvePremiumSource(storedAccess, adapter.entitlements);
  const isUnlocked = source !== 'none';
  const storeReady = premiumOverride === null ? adapter.ready : false;
  const restoreReady = premiumOverride === null ? adapter.restoreReady : false;
  const value = useMemo<PremiumAccessContextValue>(
    () => ({
      isLoaded: storageLoaded && adapter.isLoaded,
      isUnlocked,
      source,
      isBusy,
      storeReady,
      restoreReady,
      storeStatus: adapter.status,
      priceLabel: adapter.priceLabel ?? currentApp.presentation.premium.priceLabel,
      purchase,
      restore,
      enablePreviewUnlock,
      clearPreviewUnlock,
    }),
    [
      adapter.isLoaded,
      adapter.priceLabel,
      adapter.status,
      clearPreviewUnlock,
      enablePreviewUnlock,
      isBusy,
      isUnlocked,
      purchase,
      restore,
      restoreReady,
      source,
      storeReady,
      storageLoaded,
    ],
  );

  return <PremiumAccessContext.Provider value={value}>{children}</PremiumAccessContext.Provider>;
}

function NativePremiumAccessProvider({ children }: PropsWithChildren) {
  const adapter = useNativePremiumAdapter(currentApp.build.premiumProductId);
  return <PremiumAccessProviderBridge adapter={adapter}>{children}</PremiumAccessProviderBridge>;
}

export function PremiumAccessProvider({ children, adapter }: PremiumAccessProviderProps) {
  if (adapter) {
    return <PremiumAccessProviderBridge adapter={adapter}>{children}</PremiumAccessProviderBridge>;
  }

  return <NativePremiumAccessProvider>{children}</NativePremiumAccessProvider>;
}

export function usePremiumAccess() {
  const value = useContext(PremiumAccessContext);
  if (!value) {
    throw new Error('usePremiumAccess must be used inside PremiumAccessProvider.');
  }

  return value;
}
