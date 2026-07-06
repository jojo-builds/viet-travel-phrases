import XCTest

final class SubscriptionGateUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testSubscriptionBypassLaunchesMainApp() {
        let app = launch(arguments: ["--subscription-bypass"])

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 20))
    }

    func testForceSubscriptionOnboardingShowsPlaceholderFlow() {
        let app = launch(arguments: ["--force-subscription-onboarding", "--reset-subscription-onboarding"])

        XCTAssertTrue(app.descendants(matching: .any)["SubscriptionOnboardingView"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Try SpeakLocal Vietnam"].exists)
    }

    func testForceSubscriptionPaywallShowsAppleNativePlaceholder() {
        let app = launch(arguments: ["--force-subscription-paywall", "--reset-subscription-onboarding"])

        XCTAssertTrue(app.descendants(matching: .any)["SubscriptionPaywallView"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Keep the full Vietnam companion for your trip"].exists)
        XCTAssertTrue(app.staticTexts["View subscription options"].exists)
        XCTAssertTrue(app.staticTexts["Search, Browse, Save, and Practice"].exists)
        XCTAssertTrue(staticText("Subscription options, trial eligibility, and billing details are shown by the App Store before purchase. Manage or cancel in App Store subscriptions.", in: app).exists)
        XCTAssertFalse(staticText("complete curated food, city, place, phrase, audio, search, saved, and Practice library.", in: app).exists)
        XCTAssertTrue(app.buttons["Restore"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["Support"].isHittable)
        XCTAssertTrue(app.descendants(matching: .any)["Terms"].isHittable)
        XCTAssertTrue(app.descendants(matching: .any)["Privacy"].isHittable)
    }

    func testCompletedOnboardingRelaunchesToPaywallWithoutDebugBypass() {
        let app = launch(arguments: [
            "--disable-subscription-ui-test-bypass",
            "--reset-subscription-onboarding",
        ])

        XCTAssertTrue(app.descendants(matching: .any)["SubscriptionOnboardingView"].waitForExistence(timeout: 5))
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["SubscriptionPaywallView"].waitForExistence(timeout: 5))

        app.terminate()
        app.launchArguments = [
            "--disable-subscription-ui-test-bypass",
            "--clear-subscription-cache",
        ]
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["SubscriptionPaywallView"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.descendants(matching: .any)["SubscriptionOnboardingView"].exists)
    }

    private func launch(arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }

    private func staticText(_ label: String, in app: XCUIApplication) -> XCUIElement {
        app.staticTexts
            .matching(NSPredicate(format: "label == %@", label))
            .firstMatch
    }
}
