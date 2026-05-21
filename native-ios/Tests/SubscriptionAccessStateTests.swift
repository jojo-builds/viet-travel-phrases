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
        let cached = CachedSubscriptionAccess(
            productID: SubscriptionProduct.monthlyProductID,
            unlockedAt: unlockedAt
        )

        let data = try JSONEncoder().encode(cached)
        let decoded = try JSONDecoder().decode(CachedSubscriptionAccess.self, from: data)

        XCTAssertEqual(decoded.productID, "app.speaklocal.vietnam.subscription.monthly")
        XCTAssertEqual(decoded.unlockedAt, unlockedAt)
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
