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

    func testForceSubscriptionPaywallShowsTripCompanionGate() {
        let app = launch(arguments: ["--force-subscription-paywall", "--reset-subscription-onboarding"])

        XCTAssertTrue(app.descendants(matching: .any)["SubscriptionPaywallView"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Try the full Vietnam companion free for 7 days"].exists)
        XCTAssertTrue(app.staticTexts["Start your 7-day trial"].isHittable)
        XCTAssertTrue(app.staticTexts["Trip-first food and place guidance"].exists)
        XCTAssertTrue(app.staticTexts["Search, Browse, Saved, and Practice"].exists)
        XCTAssertTrue(staticText("Try 7 days free, then $4.99/month in the U.S. The App Store confirms eligibility, local pricing, renewal date, and cancellation before purchase.", in: app).exists)
        XCTAssertFalse(staticText("complete curated food, city, place, phrase, audio, search, saved, and Practice library.", in: app).exists)
        XCTAssertTrue(app.buttons["Restore"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["Support"].isHittable)
        XCTAssertTrue(app.descendants(matching: .any)["Terms"].isHittable)
        XCTAssertTrue(app.descendants(matching: .any)["Privacy"].isHittable)

        app.swipeUp()
        XCTAssertTrue(app.staticTexts["Preview real trip moments"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Cho toi ca phe sua da"].exists)
        XCTAssertTrue(app.staticTexts["Could you speak slowly for me?"].exists)
    }

    func testCaptureSubscriptionPaywallProofScreenshots() {
        let app = launch(arguments: ["--force-subscription-paywall", "--reset-subscription-onboarding"])

        XCTAssertTrue(app.descendants(matching: .any)["SubscriptionPaywallView"].waitForExistence(timeout: 5))
        attachScreenshot(named: "paywall-trip-companion-forced-2026-07-07")

        app.swipeUp()
        XCTAssertTrue(app.staticTexts["Preview real trip moments"].waitForExistence(timeout: 5))
        attachScreenshot(named: "paywall-trip-companion-scrolled-2026-07-07")
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

    private func attachScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
