import XCTest

final class ProductLanguageUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testRepresentativeRoutesDoNotExposeRetiredPracticeVocabularyWhileScrolling() {
        for route in RepresentativeRoute.all {
            XCTContext.runActivity(named: route.name) { _ in
                let app = XCUIApplication()
                app.launchArguments = route.launchArguments
                app.launch()

                XCTAssertTrue(
                    app.descendants(matching: .any)[route.anchorIdentifier].waitForExistence(timeout: 6),
                    "\(route.name) did not reach expected anchor \(route.anchorIdentifier)"
                )
                assertNoRetiredPracticeVocabulary(in: app, routeName: route.name)

                for _ in 0..<route.swipeCount {
                    app.swipeUp()
                    RunLoop.current.run(until: Date().addingTimeInterval(0.25))
                    assertNoRetiredPracticeVocabulary(in: app, routeName: route.name)
                }

                app.terminate()
            }
        }
    }

    private func assertNoRetiredPracticeVocabulary(
        in app: XCUIApplication,
        routeName: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let match = app.descendants(matching: .any)
            .matching(Self.retiredExactLabelPredicate)
            .firstMatch
        XCTAssertFalse(
            match.exists,
            "\(routeName) exposed retired Practice-era label: \(match.label)",
            file: file,
            line: line
        )
    }

    private static let retiredExactLabelPredicate = NSPredicate(format: "label IN %@", retiredExactLabels)

    private static let retiredExactLabels = [
        "Quick conversations",
        "Messages",
        "MESSAGES",
        "Back to Messages",
        "Messages thread",
        "Restart conversation",
        "Conversation complete",
        "Conversation break",
        "Unread",
        "Mark Unread",
        "Open thread",
        "Market Hello",
        "Hotel Hello",
        "Respectful Hello",
        "Quick practice",
        "My practice phrases",
        "First day in Vietnam messages"
    ]
}

private struct RepresentativeRoute {
    let name: String
    let launchArguments: [String]
    let anchorIdentifier: String
    let swipeCount: Int

    static let all: [RepresentativeRoute] = [
        RepresentativeRoute(
            name: "Home",
            launchArguments: ["--reset-demo-state"],
            anchorIdentifier: "HomeView",
            swipeCount: 8
        ),
        RepresentativeRoute(
            name: "Browse",
            launchArguments: ["--browse", "--reset-demo-state"],
            anchorIdentifier: "Browse.Title",
            swipeCount: 8
        ),
        RepresentativeRoute(
            name: "Local Greetings",
            launchArguments: ["--browse-category", "local-greetings", "--reset-demo-state"],
            anchorIdentifier: "BrowseCollection.Title.category.local-greetings",
            swipeCount: 8
        ),
        RepresentativeRoute(
            name: "Eating Out",
            launchArguments: ["--browse-category", "food", "--reset-demo-state"],
            anchorIdentifier: "BrowseCollection.Title.category.food",
            swipeCount: 10
        ),
        RepresentativeRoute(
            name: "Airport",
            launchArguments: ["--browse-category", "airport", "--reset-demo-state"],
            anchorIdentifier: "BrowseCollection.Title.category.airport",
            swipeCount: 8
        ),
        RepresentativeRoute(
            name: "Hotel",
            launchArguments: ["--browse-category", "hotel", "--reset-demo-state"],
            anchorIdentifier: "BrowseCollection.Title.category.hotel",
            swipeCount: 8
        ),
        RepresentativeRoute(
            name: "Hoi An",
            launchArguments: ["--browse-city", "hoian", "--reset-demo-state"],
            anchorIdentifier: "BrowseCollection.Title.city.hoian",
            swipeCount: 8
        ),
        RepresentativeRoute(
            name: "Da Nang",
            launchArguments: ["--browse-city", "danang", "--reset-demo-state"],
            anchorIdentifier: "BrowseCollection.Title.city.danang",
            swipeCount: 8
        ),
        RepresentativeRoute(
            name: "Search",
            launchArguments: ["--search-query", "hotel", "--reset-demo-state"],
            anchorIdentifier: "Search.Title",
            swipeCount: 6
        ),
        RepresentativeRoute(
            name: "Saved",
            launchArguments: ["--saved", "--reset-demo-state", "--seed-returning-user-shelves"],
            anchorIdentifier: "SavedPagesView",
            swipeCount: 6
        ),
        RepresentativeRoute(
            name: "Practice",
            launchArguments: ["--practice", "--reset-demo-state"],
            anchorIdentifier: "Practice.BottomSentinel",
            swipeCount: 6
        )
    ]
}
