import Foundation

enum SubscriptionProduct {
    static let monthlyProductID = "app.speaklocal.vietnam.subscription.monthly"
}

enum SubscriptionStorageKey {
    static let hasCompletedOnboarding = "subscription.hasCompletedOnboarding"
    static let cachedAccess = "subscription.cachedAccess"
}

enum SubscriptionEntitlementStatus: Equatable {
    case loading
    case active
    case inactive
    case failed
}

enum SubscriptionGateDestination: Equatable {
    case app
    case onboarding
    case paywall
}

struct SubscriptionAccessSnapshot: Equatable {
    var entitlementStatus: SubscriptionEntitlementStatus
    var hasCompletedOnboarding: Bool
    var hasCachedActiveAccess: Bool
    var isDebugBypassEnabled: Bool
}

enum SubscriptionAccessDecision {
    static func resolve(_ snapshot: SubscriptionAccessSnapshot) -> SubscriptionGateDestination {
        if snapshot.isDebugBypassEnabled || snapshot.entitlementStatus == .active {
            return .app
        }

        if snapshot.entitlementStatus == .loading && snapshot.hasCachedActiveAccess {
            return .app
        }

        return snapshot.hasCompletedOnboarding ? .paywall : .onboarding
    }
}

struct CachedSubscriptionAccess: Codable, Equatable {
    let productID: String
    let unlockedAt: Date
    let expiresAt: Date?

    init(
        productID: String,
        unlockedAt: Date,
        expiresAt: Date? = nil
    ) {
        self.productID = productID
        self.unlockedAt = unlockedAt
        self.expiresAt = expiresAt
    }

    func isUsable(now: Date = Date()) -> Bool {
        guard productID == SubscriptionProduct.monthlyProductID else {
            return false
        }

        guard let expiresAt else {
            return true
        }

        return expiresAt > now
    }
}
