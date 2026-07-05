import XCTest
@testable import SpeakLocalNative

final class SubscriptionAccessStateTests: XCTestCase {
    func testActiveEntitlementOpensApp() {
        let snapshot = SubscriptionAccessSnapshot(
            entitlementStatus: .active,
            hasCompletedOnboarding: false,
            hasCachedActiveAccess: false,
            isDebugBypassEnabled: false
        )

        XCTAssertEqual(SubscriptionAccessDecision.resolve(snapshot), .app)
    }

    func testDebugBypassOpensAppWithoutEntitlement() {
        let snapshot = SubscriptionAccessSnapshot(
            entitlementStatus: .inactive,
            hasCompletedOnboarding: false,
            hasCachedActiveAccess: false,
            isDebugBypassEnabled: true
        )

        XCTAssertEqual(SubscriptionAccessDecision.resolve(snapshot), .app)
    }

    func testInactiveBeforeOnboardingShowsOnboarding() {
        let snapshot = SubscriptionAccessSnapshot(
            entitlementStatus: .inactive,
            hasCompletedOnboarding: false,
            hasCachedActiveAccess: false,
            isDebugBypassEnabled: false
        )

        XCTAssertEqual(SubscriptionAccessDecision.resolve(snapshot), .onboarding)
    }

    func testInactiveAfterOnboardingShowsPaywall() {
        let snapshot = SubscriptionAccessSnapshot(
            entitlementStatus: .inactive,
            hasCompletedOnboarding: true,
            hasCachedActiveAccess: false,
            isDebugBypassEnabled: false
        )

        XCTAssertEqual(SubscriptionAccessDecision.resolve(snapshot), .paywall)
    }

    func testLoadingWithCachedActiveAccessOpensAppWhileStoreKitRefreshes() {
        let snapshot = SubscriptionAccessSnapshot(
            entitlementStatus: .loading,
            hasCompletedOnboarding: true,
            hasCachedActiveAccess: true,
            isDebugBypassEnabled: false
        )

        XCTAssertEqual(SubscriptionAccessDecision.resolve(snapshot), .app)
    }

    func testLoadingWithoutCacheShowsOnboardingBeforeSetupCompletes() {
        let snapshot = SubscriptionAccessSnapshot(
            entitlementStatus: .loading,
            hasCompletedOnboarding: false,
            hasCachedActiveAccess: false,
            isDebugBypassEnabled: false
        )

        XCTAssertEqual(SubscriptionAccessDecision.resolve(snapshot), .onboarding)
    }

    func testFailedAfterOnboardingWithoutCacheShowsPaywall() {
        let snapshot = SubscriptionAccessSnapshot(
            entitlementStatus: .failed,
            hasCompletedOnboarding: true,
            hasCachedActiveAccess: false,
            isDebugBypassEnabled: false
        )

        XCTAssertEqual(SubscriptionAccessDecision.resolve(snapshot), .paywall)
    }

    func testCachedAccessEncodesAndDecodesLaunchContinuityData() throws {
        let unlockedAt = Date(timeIntervalSince1970: 1_777_123_456)
        let expiresAt = unlockedAt.addingTimeInterval(60 * 60 * 24 * 7)
        let cached = CachedSubscriptionAccess(
            productID: SubscriptionProduct.monthlyProductID,
            unlockedAt: unlockedAt,
            expiresAt: expiresAt
        )

        let data = try JSONEncoder().encode(cached)
        let decoded = try JSONDecoder().decode(CachedSubscriptionAccess.self, from: data)

        XCTAssertEqual(decoded.productID, "app.speaklocal.vietnam.subscription.monthly")
        XCTAssertEqual(decoded.unlockedAt, unlockedAt)
        XCTAssertEqual(decoded.expiresAt, expiresAt)
    }

    func testCachedAccessIsUsableUntilItsExpirationDate() {
        let now = Date(timeIntervalSince1970: 1_777_123_456)
        let cached = CachedSubscriptionAccess(
            productID: SubscriptionProduct.monthlyProductID,
            unlockedAt: now.addingTimeInterval(-60),
            expiresAt: now.addingTimeInterval(60)
        )

        XCTAssertTrue(cached.isUsable(now: now))
    }

    func testExpiredCachedAccessIsNotUsableForLaunchContinuity() {
        let now = Date(timeIntervalSince1970: 1_777_123_456)
        let cached = CachedSubscriptionAccess(
            productID: SubscriptionProduct.monthlyProductID,
            unlockedAt: now.addingTimeInterval(-120),
            expiresAt: now.addingTimeInterval(-60)
        )

        XCTAssertFalse(cached.isUsable(now: now))
    }

    func testHostedUnitTestEnvironmentDoesNotEnableDebugBypass() {
        let environment = [
            "XCTestConfigurationFilePath": "/tmp/SpeakLocalNativeTests.xctestconfiguration",
            "XCInjectBundleInto": "/tmp/SpeakLocalNative.app/SpeakLocalNative",
        ]

        XCTAssertFalse(SubscriptionTestEnvironment.isRunningUITests(environment))
    }

    func testUITestEnvironmentEnablesDebugBypass() {
        let environment = [
            "XCTestConfigurationFilePath": "/tmp/SpeakLocalNativeUITests.xctestconfiguration",
            "XCInjectBundleInto": "/tmp/SpeakLocalNativeUITests-Runner.app/SpeakLocalNativeUITests-Runner",
        ]

        XCTAssertTrue(SubscriptionTestEnvironment.isRunningUITests(environment))
    }
}
