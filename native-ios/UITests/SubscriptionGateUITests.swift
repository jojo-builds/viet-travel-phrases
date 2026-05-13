import XCTest

final class SubscriptionGateUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testSubscriptionBypassLaunchesMainApp() {
        let app = launch(arguments: ["--subscription-bypass"])

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))
    }

    func testForceSubscriptionOnboardingShowsPlaceholderFlow() {
        let app = launch(arguments: ["--force-subscription-onboarding", "--reset-subscription-onboarding"])

        XCTAssertTrue(app.descendants(matching: .any)["SubscriptionOnboardingView"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Try SpeakLocal Vietnam"].exists)
    }

    func testForceSubscriptionPaywallShowsAppleNativePlaceholder() {
        let app = launch(arguments: ["--force-subscription-paywall", "--reset-subscription-onboarding"])

        XCTAssertTrue(app.descendants(matching: .any)["SubscriptionPaywallView"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Start your 7-day free trial"].exists)
        XCTAssertTrue(app.buttons["Restore"].exists)
    }

    private func launch(arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }
}
