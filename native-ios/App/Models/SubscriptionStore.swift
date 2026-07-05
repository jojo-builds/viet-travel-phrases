import Foundation
import StoreKit

@MainActor
final class SubscriptionStore: ObservableObject {
    @Published private(set) var entitlementStatus: SubscriptionEntitlementStatus = .loading
    @Published private(set) var products: [Product] = []
    @Published private(set) var errorMessage: String?

    private let productIDs: [String]
    private let userDefaults: UserDefaults
    private var transactionUpdatesTask: Task<Void, Never>?
    private var hasStarted = false

    init(
        productIDs: [String] = [SubscriptionProduct.monthlyProductID],
        userDefaults: UserDefaults = .standard
    ) {
        self.productIDs = productIDs
        self.userDefaults = userDefaults
    }

    var cachedAccess: CachedSubscriptionAccess? {
        guard let data = userDefaults.data(forKey: SubscriptionStorageKey.cachedAccess) else {
            return nil
        }

        return try? JSONDecoder().decode(CachedSubscriptionAccess.self, from: data)
    }

    var hasUsableCachedAccess: Bool {
        cachedAccess?.isUsable() == true
    }

    func start() async {
        guard !hasStarted else { return }

        hasStarted = true
        transactionUpdatesTask = Task { [weak self] in
            for await update in Transaction.updates {
                await self?.handle(transactionResult: update)
            }
        }

        await refresh()
    }

    func refresh() async {
        entitlementStatus = .loading
        errorMessage = nil

        do {
            products = try await Product.products(for: productIDs)
            let activeEntitlement = await activeEntitlement()

            if let activeEntitlement {
                cacheActiveAccess(expiresAt: activeEntitlement.expirationDate)
                entitlementStatus = .active
            } else {
                clearCachedAccess()
                entitlementStatus = .inactive
            }
        } catch {
            errorMessage = "Unable to check subscription status."
            entitlementStatus = hasUsableCachedAccess ? .loading : .failed
        }
    }

    func restore() async {
        do {
            try await AppStore.sync()
            await refresh()
        } catch {
            errorMessage = "Restore could not be completed."
            entitlementStatus = hasUsableCachedAccess ? entitlementStatus : .failed
        }
    }

    func clearLocalStateForTesting() {
        clearCachedAccess()
        entitlementStatus = .inactive
        errorMessage = nil
    }

    private func handle(transactionResult: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = transactionResult else {
            return
        }

        if productIDs.contains(transaction.productID) {
            await transaction.finish()
            await refresh()
        }
    }

    private func activeEntitlement() async -> ActiveSubscriptionEntitlement? {
        for productID in productIDs {
            for await entitlement in Transaction.currentEntitlements(for: productID) {
                guard case .verified(let transaction) = entitlement else {
                    continue
                }

                guard transaction.revocationDate == nil else {
                    continue
                }

                if let expirationDate = transaction.expirationDate, expirationDate <= Date() {
                    continue
                }

                return ActiveSubscriptionEntitlement(expirationDate: transaction.expirationDate)
            }
        }

        return nil
    }

    private func cacheActiveAccess(expiresAt: Date?) {
        let access = CachedSubscriptionAccess(
            productID: SubscriptionProduct.monthlyProductID,
            unlockedAt: Date(),
            expiresAt: expiresAt
        )

        if let data = try? JSONEncoder().encode(access) {
            userDefaults.set(data, forKey: SubscriptionStorageKey.cachedAccess)
        }
    }

    private func clearCachedAccess() {
        userDefaults.removeObject(forKey: SubscriptionStorageKey.cachedAccess)
    }

    deinit {
        transactionUpdatesTask?.cancel()
    }

    private struct ActiveSubscriptionEntitlement {
        let expirationDate: Date?
    }
}
