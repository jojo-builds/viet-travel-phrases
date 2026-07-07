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

    func testHostedUnitTestEnvironmentIsDetectedForAppHostBypass() {
        let environment = [
            "XCInjectBundleInto": "unused",
            "XCTestBundlePath": "PlugIns/SpeakLocalNativeTests.xctest",
            "XCTestConfigurationFilePath": "",
        ]

        XCTAssertTrue(SubscriptionTestEnvironment.isRunningHostedUnitTests(environment))
    }

    func testUITestEnvironmentEnablesDebugBypass() {
        let environment = [
            "XCTestConfigurationFilePath": "/tmp/SpeakLocalNativeUITests.xctestconfiguration",
            "XCInjectBundleInto": "/tmp/SpeakLocalNativeUITests-Runner.app/SpeakLocalNativeUITests-Runner",
        ]

        XCTAssertTrue(SubscriptionTestEnvironment.isRunningUITests(environment))
    }

    func testSubscriptionBypassLaunchArgumentIsIgnoredOutsideDebugPolicy() {
        let isEnabled = SubscriptionDebugBypassPolicy.isEnabled(
            launchArguments: ["--subscription-bypass"],
            launchEnvironment: [:],
            isDebugBuild: false
        )

        XCTAssertFalse(isEnabled)
    }

    func testSubscriptionBypassLaunchArgumentIsAllowedForDebugPolicy() {
        let isEnabled = SubscriptionDebugBypassPolicy.isEnabled(
            launchArguments: ["--subscription-bypass"],
            launchEnvironment: [:],
            isDebugBuild: true
        )

        XCTAssertTrue(isEnabled)
    }

    func testSubscriptionLegalLinksUseSpeakLocalOwnedUrls() {
        XCTAssertEqual(SubscriptionLegalLinks.terms.absoluteString, "https://speaklocal.app/terms/")
        XCTAssertEqual(SubscriptionLegalLinks.privacy.absoluteString, "https://speaklocal.app/privacy/")
        XCTAssertEqual(SubscriptionLegalLinks.support.absoluteString, "https://speaklocal.app/feedback/")
    }

    func testSubscriptionOfferCopyStatesLaunchTrialAndAppStoreConfirmation() {
        XCTAssertEqual(
            SubscriptionOfferCopy.detailsLine,
            "Try 7 days free, then $4.99/month in the U.S. The App Store confirms eligibility, local pricing, renewal date, and cancellation before purchase."
        )
    }

    func testSubscriptionPaywallNarrativeUsesTripCompanionGate() {
        XCTAssertEqual(
            SubscriptionPaywallNarrative.headline,
            "Try the full Vietnam companion free for 7 days"
        )
        XCTAssertEqual(
            SubscriptionPaywallNarrative.subtitle,
            "Food, coffee, city and place guides, phrase pages, supported playable audio, Search, Saved, and Practice for one Vietnam trip."
        )
        XCTAssertEqual(
            SubscriptionPaywallNarrative.benefits.map(\.title),
            [
                "Trip-first food and place guidance",
                "Phrase pages with playable audio",
                "Search, Browse, Saved, and Practice",
            ]
        )
    }

    func testSubscriptionPaywallAvailabilityCopyWaitsWhileLoading() {
        XCTAssertNil(
            SubscriptionPaywallAvailabilityCopy.unavailableMessage(
                productsAreEmpty: true,
                entitlementStatus: .loading
            )
        )
    }

    func testSubscriptionPaywallAvailabilityCopyShowsWhenProductsAreUnavailable() {
        XCTAssertEqual(
            SubscriptionPaywallAvailabilityCopy.unavailableMessage(
                productsAreEmpty: true,
                entitlementStatus: .inactive
            ),
            "Subscription options are unavailable right now. Check your App Store connection and try again, or contact support."
        )
    }

    func testSubscriptionPaywallAvailabilityCopyStaysHiddenWhenProductsExist() {
        XCTAssertNil(
            SubscriptionPaywallAvailabilityCopy.unavailableMessage(
                productsAreEmpty: false,
                entitlementStatus: .inactive
            )
        )
    }
}
