import XCTest
@testable import SpeakLocalNative

final class AppChromeTests: XCTestCase {
    func testPhrasePageChromeUsesSeparateSearchIsland() {
        let chrome = AppChrome(route: .phrasePage)

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved])
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testSearchPageChromeExpandsSearchAndShrinksDock() {
        let chrome = AppChrome(route: .search)

        XCTAssertEqual(chrome.primaryDockItems, [.home])
        XCTAssertEqual(chrome.searchPresentation, .expandedField)
    }

    func testDetailPageChromeMatchesPhrasePageChrome() {
        let chrome = AppChrome(route: .detailPage("viet-local-greetings"))

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved])
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }
}
