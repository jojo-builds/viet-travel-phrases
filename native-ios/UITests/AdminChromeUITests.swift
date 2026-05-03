import XCTest

final class AdminChromeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testHomeAndSearchIslandCanSwitchRepeatedly() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        for iteration in 1...8 {
            openSearch(in: app, expectedOrigin: "Home", iteration: iteration)
            openOrigin(in: app, title: "Home", iteration: iteration)
            assertHomeVisible(in: app)
        }
    }

    func testPrimaryTabsPreserveSearchOriginIcon() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        openSearch(in: app, expectedOrigin: "Home", iteration: 1)
        openOrigin(in: app, title: "Home", iteration: 1)
        assertHomeVisible(in: app)

        openDock("Browse", in: app)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        openSearch(in: app, expectedOrigin: "Browse", iteration: 2)
        openOrigin(in: app, title: "Browse", iteration: 2)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        openSearch(in: app, expectedOrigin: "Saved", iteration: 3)
        openOrigin(in: app, title: "Saved", iteration: 3)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))

        openDock("Practice", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
        openSearch(in: app, expectedOrigin: "Practice", iteration: 4)
        openOrigin(in: app, title: "Practice", iteration: 4)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
    }

    func testDetailSearchBrowseOriginRoundTripKeepsChromeResponsive() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-phrase-hello-chao-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))

        openSearch(in: app, expectedOrigin: "Browse", iteration: 1)
        openOrigin(in: app, title: "Browse", iteration: 1)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))

        openSearch(in: app, expectedOrigin: "Browse", iteration: 2)
        XCTAssertTrue(app.staticTexts["Search"].waitForExistence(timeout: 2))
    }

    func testBottomChromeControlsWinEdgeBiasedTapsOverDenseDetailContent() {
        verifyDockTapFromDenseDetail("Browse", point: .center) { app in
            XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Browse", point: .leadingEdge) { app in
            XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Browse", point: .trailingEdge) { app in
            XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Home", point: .trailingEdge) { app in
            XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Saved", point: .leadingEdge) { app in
            XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Practice", point: .bottomEdge) { app in
            XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
        }

        let app = launchDenseDetail()
        tapChrome(app.buttons["AppChrome.SearchButton"], point: .topEdge)
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.textFields["AppChrome.SearchField"].waitForExistence(timeout: 2))
    }

    func testBottomChromeGradientProofScreenshots() {
        var app = launchApp(arguments: ["--detail-page", "viet-phrase-hello-chao-anh"])
        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "detail-bottom-chrome.png")

        app = launchApp()
        assertHomeVisible(in: app)
        captureProofIfRequested(app: app, name: "home-bottom-chrome.png")
        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        captureProofIfRequested(app: app, name: "saved-bottom-chrome.png")

        app = launchApp(arguments: ["--browse"])
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "browse-bottom-chrome.png")

        app = launchApp(arguments: ["--search"])
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "search-bottom-chrome.png")

        app = launchApp(arguments: ["--practice"])
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "practice-bottom-chrome.png")
    }

    private func openSearch(in app: XCUIApplication, expectedOrigin: String, iteration: Int) {
        let searchButton = app.buttons["AppChrome.SearchButton"]
        XCTAssertTrue(
            searchButton.waitForExistence(timeout: 2),
            "Search island did not become tappable before iteration \(iteration)."
        )
        searchButton.tap()

        XCTAssertTrue(
            app.textFields["AppChrome.SearchField"].waitForExistence(timeout: 2),
            "Search field did not appear after tapping search on iteration \(iteration)."
        )
        XCTAssertTrue(
            app.buttons["AppChrome.SearchOriginButton.\(expectedOrigin)"].waitForExistence(timeout: 2),
            "Search origin did not preserve \(expectedOrigin) before iteration \(iteration)."
        )
    }

    private func openOrigin(in app: XCUIApplication, title: String, iteration: Int) {
        let originButton = app.buttons["AppChrome.SearchOriginButton.\(title)"]
        XCTAssertTrue(
            originButton.waitForExistence(timeout: 2),
            "Search \(title) origin did not become tappable before iteration \(iteration)."
        )
        originButton.tap()
        XCTAssertTrue(
            app.textFields["AppChrome.SearchField"].waitForNonExistence(timeout: 2),
            "Search field stayed visible after tapping \(title) origin on iteration \(iteration)."
        )
    }

    private func openDock(_ title: String, in app: XCUIApplication) {
        let dockButton = app.buttons["AppChrome.Dock.\(title)"]
        XCTAssertTrue(dockButton.waitForExistence(timeout: 2), "\(title) dock button was not available.")
        dockButton.tap()
    }

    private func assertHomeVisible(in app: XCUIApplication) {
        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["AppChrome.SearchButton"].waitForExistence(timeout: 2))
    }

    private func verifyDockTapFromDenseDetail(
        _ title: String,
        point: ChromeTapPoint,
        assertion: (XCUIApplication) -> Void
    ) {
        let app = launchDenseDetail()
        tapChrome(app.buttons["AppChrome.Dock.\(title)"], point: point)
        assertion(app)
        XCTAssertFalse(app.staticTexts["Hello, older brother / slightly older man"].isHittable)
    }

    private func launchDenseDetail() -> XCUIApplication {
        let app = launchApp(arguments: ["--detail-page", "viet-phrase-hello-chao-anh"])
        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))
        return app
    }

    private func launchApp(arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }

    private enum ChromeTapPoint {
        case center
        case leadingEdge
        case trailingEdge
        case topEdge
        case bottomEdge

        var offset: CGVector {
            switch self {
            case .center:
                return CGVector(dx: 0.5, dy: 0.5)
            case .leadingEdge:
                return CGVector(dx: 0.08, dy: 0.5)
            case .trailingEdge:
                return CGVector(dx: 0.92, dy: 0.5)
            case .topEdge:
                return CGVector(dx: 0.5, dy: 0.12)
            case .bottomEdge:
                return CGVector(dx: 0.5, dy: 0.88)
            }
        }
    }

    private func tapChrome(_ element: XCUIElement, point: ChromeTapPoint) {
        XCTAssertTrue(element.waitForExistence(timeout: 2), "\(element) was not available.")
        element.coordinate(withNormalizedOffset: point.offset).tap()
    }

    private func captureProofIfRequested(app: XCUIApplication, name: String) {
        let sentinelPath = "/tmp/speaklocal-bottom-chrome-proof-enabled"
        let environmentPath = ProcessInfo.processInfo.environment["SPEAKLOCAL_BOTTOM_CHROME_PROOF_DIR"]
        guard
            FileManager.default.fileExists(atPath: sentinelPath) || environmentPath?.isEmpty == false,
            let directoryURL = proofDirectoryURL(environmentPath: environmentPath)
        else {
            return
        }

        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directoryURL.appendingPathComponent(name))
    }

    private func proofDirectoryURL(environmentPath: String?) -> URL? {
        if let environmentPath, !environmentPath.isEmpty {
            return URL(fileURLWithPath: environmentPath, isDirectory: true)
        }

        let testFileURL = URL(fileURLWithPath: #filePath)
        let repoRootURL = testFileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        return repoRootURL
            .appendingPathComponent("docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001", isDirectory: true)
    }
}
