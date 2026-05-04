import XCTest

final class BaNaHillsJourneyProofUITests: XCTestCase {
    private let proofDirectory = URL(
        fileURLWithPath: "/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001",
        isDirectory: true
    )

    func testCaptureBaNaHillsJourneyProof() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-phrase-city-danang-place-ba-na-hills"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Bà Nà Hills"].waitForExistence(timeout: 6))
        XCTAssertTrue(app.staticTexts["Ba Na Hills"].waitForExistence(timeout: 3))
        capture(name: "ba-na-top-hero.png")

        scrollUntilVisible(app: app, text: "Journey flow")
        XCTAssertTrue(app.staticTexts["Key phrases"].waitForExistence(timeout: 3))
        capture(name: "ba-na-journey-key-phrases.png")

        scrollUntilVisible(app: app, text: "Name guide")
        capture(name: "ba-na-name-guide.png")

        scrollUntilVisible(app: app, text: "Good to know")
        XCTAssertTrue(app.staticTexts["Explore next"].waitForExistence(timeout: 3))
        capture(name: "ba-na-good-to-know-explore-next.png")
    }

    private func scrollUntilVisible(app: XCUIApplication, text: String, maxSwipes: Int = 8) {
        let element = app.staticTexts[text]
        for _ in 0..<maxSwipes {
            if element.exists && element.isHittable {
                return
            }
            app.swipeUp()
        }
        XCTAssertTrue(element.exists && element.isHittable, "\(text) did not become visible")
    }

    private func capture(name: String) {
        try? FileManager.default.createDirectory(at: proofDirectory, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: proofDirectory.appendingPathComponent(name))
    }
}
