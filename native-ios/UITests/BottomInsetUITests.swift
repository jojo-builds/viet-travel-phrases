import XCTest

final class BottomInsetUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testPrimaryRootRoutesKeepBottomContentAboveSystemTabBar() {
        let routes: [(name: String, arguments: [String], sentinelID: String)] = [
            ("home", [], "Home.BottomSentinel"),
            ("browse", ["--browse"], "Browse.BottomSentinel"),
            ("search", ["--search-query", "hotel"], "Search.BottomSentinel"),
            ("saved", ["--saved", "--reset-demo-state"], "Saved.BottomSentinel"),
            ("practice", ["--practice"], "Practice.BottomSentinel"),
        ]

        for route in routes {
            let app = launchApp(arguments: route.arguments)
            XCTAssertTrue(app.otherElements[route.sentinelID].waitForExistence(timeout: 8), route.name)
            assertBottomSentinelClearsTabBar(route.sentinelID, in: app, routeName: route.name)
            app.terminate()
        }
    }

    func testRepresentativeCollectionAndDetailRoutesKeepBottomContentAboveSystemTabBar() {
        let routes: [(name: String, arguments: [String], sentinelID: String)] = [
            (
                "hotel-category",
                ["--browse-category", "hotel"],
                "BrowseCollection.BottomSentinel.category.hotel"
            ),
            (
                "danang-city",
                ["--browse-city", "danang"],
                "BrowseCollection.BottomSentinel.city.danang"
            ),
            (
                "food-menu",
                ["--browse-category", "vietnamese-food-menu"],
                "VietnameseMenu.BottomSentinel.vietnamese-food-menu"
            ),
            (
                "city-detail",
                ["--detail-page", "viet-phrase-city-danang-place-dragon-bridge"],
                "PhraseArticle.BottomSentinel.viet-phrase-city-danang-place-dragon-bridge"
            ),
            (
                "menu-detail",
                ["--detail-page", "viet-menu-food-pho-bo"],
                "PhraseArticle.BottomSentinel.viet-menu-food-pho-bo"
            ),
        ]

        for route in routes {
            let app = launchApp(arguments: route.arguments)
            XCTAssertTrue(app.otherElements[route.sentinelID].waitForExistence(timeout: 8), route.name)
            assertBottomSentinelClearsTabBar(route.sentinelID, in: app, routeName: route.name)
            app.terminate()
        }
    }

    private func launchApp(arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments + ["--validate-bottom-inset-scroll-to-bottom"]
        app.launch()
        return app
    }

    private func assertBottomSentinelClearsTabBar(
        _ sentinelID: String,
        in app: XCUIApplication,
        routeName: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let sentinel = app.otherElements[sentinelID]
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 4), "\(routeName) tab bar missing", file: file, line: line)

        for _ in 0..<18 {
            if sentinel.exists, frameClearsTabBar(sentinel.frame, app: app, tabBar: tabBar) {
                return
            }

            app.swipeUp()
        }

        XCTAssertTrue(sentinel.exists, "\(routeName) missing \(sentinelID)", file: file, line: line)
        XCTAssertTrue(
            frameClearsTabBar(sentinel.frame, app: app, tabBar: tabBar),
            "\(routeName) bottom sentinel frame \(sentinel.frame) should sit above tab bar frame \(tabBar.frame)",
            file: file,
            line: line
        )
    }

    private func frameClearsTabBar(_ frame: CGRect, app: XCUIApplication, tabBar: XCUIElement) -> Bool {
        guard !frame.isEmpty else {
            return false
        }

        let tabBarTop = tabBar.exists ? tabBar.frame.minY : app.frame.maxY
        let comfortableBottom = tabBarTop - 10
        return frame.minY >= app.frame.minY && frame.maxY <= comfortableBottom
    }
}
