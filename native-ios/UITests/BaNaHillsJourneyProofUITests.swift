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

        scrollUntilVisible(app: app, text: "Visit flow")
        XCTAssertTrue(app.staticTexts["Getting there"].waitForExistence(timeout: 3))
        capture(name: "ba-na-visit-flow-getting-there.png")

        scrollUntilVisible(app: app, text: "Tickets")
        XCTAssertTrue(app.staticTexts["Cable car"].waitForExistence(timeout: 3))
        capture(name: "ba-na-tickets-cable-car.png")

        scrollUntilVisible(app: app, text: "Good to know")
        XCTAssertTrue(app.staticTexts["Food & cash"].waitForExistence(timeout: 3))
        capture(name: "ba-na-good-to-know-food-cash.png")
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

final class ListingProductionQAProofUITests: XCTestCase {
    private let proofDirectory = URL(
        fileURLWithPath: ProcessInfo.processInfo.environment["SPEAKLOCAL_LISTING_QA_PROOF_DIR"]
            ?? "/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-LISTING-PRODUCTION-QA-LOOP-001",
        isDirectory: true
    )

    private let representativePages: [(label: String, pageID: String, title: String)] = [
        ("understand", "viet-family-repair-understand", "Tôi không hiểu"),
        ("hotel-check-in", "viet-family-hotel-check-in", "Cho tôi nhận phòng nhé"),
        ("ba-na-hills", "viet-phrase-city-danang-place-ba-na-hills", "Bà Nà Hills"),
        ("dragon-bridge", "viet-phrase-city-danang-place-dragon-bridge", "Cầu Rồng"),
        ("nguyen-van-linh", "viet-phrase-city-danang-place-nguyen-van-linh-street", "Đường Nguyễn Văn Linh"),
        ("anan-saigon", "viet-phrase-city-hcmc-place-anan-saigon", "Anăn Sài Gòn"),
        ("post-office-place", "viet-phrase-city-hcmc-place-post-office", "Bưu điện Thành phố"),
    ]

    func testCaptureListingProductionQARepresentativeProof() {
        try? FileManager.default.createDirectory(at: proofDirectory, withIntermediateDirectories: true)

        for page in representativePages {
            let app = XCUIApplication()
            app.launchArguments = ["--detail-page", page.pageID]
            app.launch()

            XCTAssertTrue(app.staticTexts[page.title].waitForExistence(timeout: 8), "\(page.title) did not appear.")
            capture(name: "\(page.label)-top.png")

            app.swipeUp()
            app.swipeUp()
            capture(name: "\(page.label)-middle.png")

            app.swipeUp()
            app.swipeUp()
            app.swipeUp()
            capture(name: "\(page.label)-bottom.png")

            app.terminate()
        }
    }

    private func capture(name: String) {
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: proofDirectory.appendingPathComponent(name))
    }
}

final class ListingProductionQADiverse20ProofUITests: XCTestCase {
    private let proofDirectory = URL(
        fileURLWithPath: ProcessInfo.processInfo.environment["SPEAKLOCAL_LISTING_QA_DIVERSE_PROOF_DIR"]
            ?? "/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-LISTING-QA-DIVERSE-20-001",
        isDirectory: true
    )

    private let diversePages: [(label: String, pageID: String, title: String, intent: String)] = [
        ("understand", "viet-family-repair-understand", "Tôi không hiểu", "simple_phrase"),
        ("hotel-check-in", "viet-family-hotel-check-in", "Cho tôi nhận phòng nhé", "practical_flow"),
        ("ba-na-hills", "viet-family-city-danang-place-ba-na-hills", "Bà Nà Hills", "macro_attraction_journey"),
        ("marble-mountains", "viet-family-city-danang-place-marble-mountains", "Ngũ Hành Sơn", "macro_attraction_journey"),
        ("dragon-bridge", "viet-family-city-danang-place-dragon-bridge", "Cầu Rồng", "landmark_micro_place"),
        ("linh-ung-pagoda", "viet-family-city-danang-place-linh-ung-pagoda", "Chùa Linh Ứng", "landmark_micro_place"),
        ("my-khe-beach", "viet-family-city-danang-place-my-khe", "Biển Mỹ Khê", "landmark_micro_place"),
        ("nguyen-van-linh", "viet-family-city-danang-place-nguyen-van-linh-street", "Đường Nguyễn Văn Linh", "street"),
        ("bach-dang", "viet-family-city-danang-place-bach-dang-street", "Đường Bạch Đằng", "street"),
        ("anan-saigon", "viet-family-city-hcmc-place-anan-saigon", "Anăn Sài Gòn", "restaurant"),
        ("bun-cha-huong-lien", "viet-family-city-hanoi-place-bun-cha-huong-lien", "Bún chả Hương Liên", "restaurant"),
        ("pho-bat-dan", "viet-family-city-hanoi-place-pho-bat-dan", "Phở Bát Đàn", "restaurant"),
        ("bun-bo-hue", "viet-family-city-hue-place-bun-bo-city", "Bún bò Huế", "dish"),
        ("cao-lau", "viet-family-city-hoian-place-cao-lau-city", "Cao lầu ở Hội An", "dish"),
        ("post-office-place", "viet-family-city-hcmc-place-post-office", "Bưu điện Thành phố", "landmark_micro_place"),
        ("nen-where", "viet-family-city-danang-where-nen", "Nhà hàng Nén Đà Nẵng ở đâu?", "derived_place_phrase"),
        ("bathroom-where", "viet-family-bathroom-where", "Nhà vệ sinh ở đâu?", "practical_flow"),
        ("hotel-reservation", "viet-family-hotel-reservation", "Tôi có đặt phòng", "practical_flow"),
        ("taxi-counter", "viet-phrase-v500-airp-bord-arri-where-is-the-taxi-counter", "Quầy taxi ở đâu?", "practical_flow"),
        ("call-taxi", "viet-phrase-hotel-9", "Gọi taxi giúp tôi được không?", "practical_flow"),
    ]

    func testCaptureDiverseTwentyListingPages() {
        try? FileManager.default.createDirectory(at: proofDirectory, withIntermediateDirectories: true)

        for (index, page) in diversePages.enumerated() {
            let app = XCUIApplication()
            app.launchArguments = ["--detail-page", page.pageID]
            app.launch()

            XCTAssertTrue(app.staticTexts[page.title].waitForExistence(timeout: 8), "\(page.title) did not appear.")

            let prefix = String(format: "%02d-%@-%@", index + 1, page.intent, page.label)
            capture(name: "\(prefix)-top.png")

            app.swipeUp()
            app.swipeUp()
            capture(name: "\(prefix)-middle.png")

            app.swipeUp()
            app.swipeUp()
            app.swipeUp()
            capture(name: "\(prefix)-bottom.png")

            app.terminate()
        }
    }

    private func capture(name: String) {
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: proofDirectory.appendingPathComponent(name))
    }
}

final class ListingLatestFeedbackProofUITests: XCTestCase {
    private let proofDirectory = URL(
        fileURLWithPath: ProcessInfo.processInfo.environment["SPEAKLOCAL_LISTING_LATEST_FEEDBACK_PROOF_DIR"]
            ?? "/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-LISTING-LATEST-FEEDBACK-001",
        isDirectory: true
    )

    private let detailPages: [(label: String, pageID: String, title: String, requiredTexts: [String])] = [
        (
            "peanut-ingredient",
            "viet-phrase-food-premium-has-peanuts",
            "Cái này có đậu phộng không?",
            ["Break it down", "đậu phộng", "peanuts"]
        ),
        (
            "taxi-help",
            "viet-phrase-hotel-9",
            "Gọi taxi giúp tôi được không?",
            ["Break it down", "taxi"]
        ),
        (
            "emergency-services",
            "viet-phrase-v900-emer-safe-please-call-emergency-services",
            "Vui lòng gọi dịch vụ khẩn cấp",
            ["Break it down", "emergency"]
        ),
        (
            "marble-mountains-hero",
            "viet-family-city-danang-place-marble-mountains",
            "Ngũ Hành Sơn",
            ["Marble Mountains"]
        ),
        (
            "linh-ung-hero",
            "viet-family-city-danang-place-linh-ung-pagoda",
            "Chùa Linh Ứng",
            ["Linh Ung Pagoda"]
        ),
        (
            "my-khe-hero",
            "viet-family-city-danang-place-my-khe",
            "Biển Mỹ Khê",
            ["My Khe Beach"]
        ),
        (
            "han-market-hero",
            "viet-family-city-danang-place-han-market",
            "Chợ Hàn",
            ["Han Market"]
        ),
        (
            "nguyen-van-linh-hero",
            "viet-family-city-danang-place-nguyen-van-linh-street",
            "Đường Nguyễn Văn Linh",
            ["Nguyen Van Linh Street"]
        ),
    ]

    private let hubPages: [(label: String, arguments: [String], title: String, requiredTexts: [String])] = [
        (
            "emergency-hub",
            ["--browse-category", "emergency"],
            "Emergency",
            ["Ask for help calmly.", "Help!"]
        ),
        (
            "shopping-hub",
            ["--browse-category", "shopping"],
            "Shopping",
            ["Prices, sizes, payment, and returns."]
        ),
        (
            "danang-city-hub",
            ["--browse-city", "danang"],
            "Da Nang",
            ["Browse by", "Landmarks", "Restaurants"]
        ),
        (
            "all-vietnam-hub",
            ["--browse-category", "city-guides"],
            "All Vietnam",
            ["Start here", "City guides"]
        ),
    ]

    func testCaptureLatestFeedbackDetailPages() {
        try? FileManager.default.createDirectory(at: proofDirectory, withIntermediateDirectories: true)

        for page in detailPages {
            let app = XCUIApplication()
            app.launchArguments = ["--detail-page", page.pageID]
            app.launch()

            XCTAssertTrue(app.staticTexts[page.title].waitForExistence(timeout: 8), "\(page.title) did not appear.")
            capture(name: "\(page.label)-top.png")

            for text in page.requiredTexts {
                scrollUntilExists(app: app, text: text)
            }

            app.swipeUp()
            app.swipeUp()
            capture(name: "\(page.label)-middle.png")

            app.terminate()
        }
    }

    func testCaptureLatestFeedbackHubPages() {
        try? FileManager.default.createDirectory(at: proofDirectory, withIntermediateDirectories: true)

        for page in hubPages {
            let app = XCUIApplication()
            app.launchArguments = page.arguments
            app.launch()

            XCTAssertTrue(app.staticTexts[page.title].waitForExistence(timeout: 8), "\(page.title) did not appear.")
            capture(name: "\(page.label)-top.png")

            for text in page.requiredTexts {
                scrollUntilExists(app: app, text: text)
            }

            app.swipeUp()
            app.swipeUp()
            capture(name: "\(page.label)-middle.png")

            app.terminate()
        }
    }

    private func capture(name: String) {
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: proofDirectory.appendingPathComponent(name))
    }

    private func scrollUntilExists(app: XCUIApplication, text: String, maxSwipes: Int = 8) {
        for _ in 0..<maxSwipes {
            let element = matchingStaticText(app: app, text: text)
            if element.exists {
                return
            }
            app.swipeUp()
        }
        XCTAssertTrue(matchingStaticText(app: app, text: text).exists, "\(text) did not become available")
    }

    private func matchingStaticText(app: XCUIApplication, text: String) -> XCUIElement {
        let exact = app.staticTexts[text]
        if exact.exists {
            return exact
        }
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        return app.staticTexts.matching(predicate).firstMatch
    }
}

final class CityAppDetailV22RenderProofUITests: XCTestCase {
    private struct Page: Decodable {
        let label: String
        let pageID: String
        let title: String
        let city: String
        let category: String
    }

    private let environment = ProcessInfo.processInfo.environment

    func testCaptureCityAppDetailV22RenderProofBatch() throws {
        let pages = try loadPages()
        let offset = Int(environment["SPEAKLOCAL_V2_2_RENDER_PROOF_OFFSET"] ?? "0") ?? 0
        let limit = Int(environment["SPEAKLOCAL_V2_2_RENDER_PROOF_LIMIT"] ?? "\(pages.count)") ?? pages.count
        let selectedPages = Array(pages.dropFirst(offset).prefix(limit))

        XCTAssertFalse(selectedPages.isEmpty, "No V2.2 render-proof pages selected.")
        try FileManager.default.createDirectory(at: proofDirectory, withIntermediateDirectories: true)

        for (index, page) in selectedPages.enumerated() {
            let globalIndex = offset + index + 1
            let prefix = String(format: "%03d-%@-%@-%@", globalIndex, page.city, page.category, page.label)
                .replacingOccurrences(of: "[^A-Za-z0-9._-]", with: "-", options: .regularExpression)

            let app = XCUIApplication()
            app.launchArguments = ["--detail-page", page.pageID]
            app.launch()

            XCTAssertTrue(
                matchingStaticText(app: app, text: page.title).waitForExistence(timeout: 8),
                "\(page.pageID) title \(page.title) did not appear."
            )
            capture(name: "\(prefix)-top.png")

            app.swipeUp()
            app.swipeUp()
            capture(name: "\(prefix)-middle.png")
            app.terminate()

            let bottomApp = XCUIApplication()
            bottomApp.launchArguments = [
                "--detail-page",
                page.pageID,
                "--validate-bottom-inset-scroll-to-bottom"
            ]
            bottomApp.launch()
            assertBottomSentinelClearsTabBar(
                sentinelIDs(for: page.pageID),
                in: bottomApp,
                routeName: page.pageID
            )
            capture(name: "\(prefix)-bottom.png")
            bottomApp.terminate()
        }
    }

    private var proofDirectory: URL {
        URL(
            fileURLWithPath: environment["SPEAKLOCAL_V2_2_RENDER_PROOF_DIR"]
                ?? "/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/CITY_APP_DETAIL_V2_2_RENDER_PROOF",
            isDirectory: true
        )
    }

    private func loadPages() throws -> [Page] {
        guard let manifestPath = environment["SPEAKLOCAL_V2_2_RENDER_PROOF_MANIFEST"] else {
            XCTFail("SPEAKLOCAL_V2_2_RENDER_PROOF_MANIFEST is required.")
            return []
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: manifestPath))
        return try JSONDecoder().decode([Page].self, from: data)
    }

    private func capture(name: String) {
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: proofDirectory.appendingPathComponent(name))
    }

    private func matchingStaticText(app: XCUIApplication, text: String) -> XCUIElement {
        let exact = app.staticTexts[text]
        if exact.exists {
            return exact
        }
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        return app.staticTexts.matching(predicate).firstMatch
    }

    private func sentinelIDs(for pageID: String) -> [String] {
        var ids = ["PhraseArticle.BottomSentinel.\(pageID)"]
        if pageID.hasPrefix("viet-family-city-") {
            ids.append("PhraseArticle.BottomSentinel.\(pageID.replacingOccurrences(of: "viet-family-city-", with: "viet-phrase-city-"))")
        }
        return ids
    }

    private func assertBottomSentinelClearsTabBar(
        _ sentinelIDs: [String],
        in app: XCUIApplication,
        routeName: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 4), "\(routeName) tab bar missing", file: file, line: line)

        for _ in 0..<18 {
            if let sentinel = firstExistingElement(sentinelIDs, in: app),
               frameClearsTabBar(sentinel.frame, app: app, tabBar: tabBar) {
                return
            }
            app.swipeUp()
        }

        guard let sentinel = firstExistingElement(sentinelIDs, in: app) else {
            XCTFail("\(routeName) missing bottom sentinel from \(sentinelIDs.joined(separator: ", "))", file: file, line: line)
            return
        }

        XCTAssertTrue(
            frameClearsTabBar(sentinel.frame, app: app, tabBar: tabBar),
            "\(routeName) bottom sentinel frame \(sentinel.frame) should sit above tab bar frame \(tabBar.frame)",
            file: file,
            line: line
        )
    }

    private func firstExistingElement(_ identifiers: [String], in app: XCUIApplication) -> XCUIElement? {
        for identifier in identifiers {
            let element = app.otherElements[identifier]
            if element.exists {
                return element
            }
        }
        return nil
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

final class ListingHubRandomLoopProofUITests: XCTestCase {
    private let proofDirectory = URL(
        fileURLWithPath: ProcessInfo.processInfo.environment["SPEAKLOCAL_LISTING_HUB_RANDOM_LOOP_PROOF_DIR"]
            ?? "/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-LISTING-HUB-RANDOM-LOOP-001",
        isDirectory: true
    )

    private let hubPages: [(label: String, arguments: [String], title: String, requiredTexts: [String])] = [
        ("all-vietnam", ["--browse-category", "city-guides"], "All Vietnam", ["Start here", "City guides", "Vietnam basics"]),
        ("hanoi", ["--browse-city", "hanoi"], "Hanoi", ["Browse by", "Landmarks", "Restaurants"]),
        ("saigon", ["--browse-city", "hcmc"], "Saigon", ["Browse by", "Landmarks", "Restaurants"]),
        ("hoi-an", ["--browse-city", "hoian"], "Hoi An", ["Browse by", "Landmarks", "Restaurants"]),
        ("hue", ["--browse-city", "hue"], "Hue", ["Browse by", "Landmarks", "Restaurants"]),
        ("airport-topic", ["--browse-category", "airport"], "Airport", ["Good first phrases", "Airport Baggage", "Passport Control", "SIM & Cash"]),
        ("hotel-topic", ["--browse-category", "hotel"], "Hotel", ["At the hotel desk", "Hotel Check-In", "Room Help", "Bags & Taxi"]),
        ("food-topic", ["--browse-category", "food"], "Eating Out", ["Quick orders", "Order drinks", "Order dishes", "Places to eat & drink", "Food Allergies", "Restaurant Table", "Beach Snacks"]),
        ("getting-around-topic", ["--browse-category", "getting-around"], "Getting Around", ["Start here", "Grab Pickup", "Taxi Route", "Driver Help"]),
        ("local-greetings-topic", ["--browse-category", "local-greetings"], "Local Greetings", ["Start here", "Market Hello", "Hotel Hello", "Respectful Hello"]),
    ]

    private let detailPages: [(label: String, pageID: String, title: String, requiredTexts: [String])] = [
        ("excuse-sorry", "viet-excuse-sorry", "Xin lỗi", ["Break it down", "Common follow-ups", "Good to know", "Next phrases"]),
        ("cash", "viet-family-transport-cash", "Tôi trả bằng tiền mặt", ["Break it down", "Common follow-ups"]),
        ("gate", "viet-phrase-v500-airp-bord-arri-where-is-gate-10", "Cổng 10 ở đâu?", ["Break it down", "Good to know"]),
        ("atm-cathedral", "viet-family-city-danang-atm-cathedral", "Có ATM gần Nhà thờ Con Gà Đà Nẵng không?", ["Break it down", "Related phrases", "Tip"]),
        ("vo-nguyen-giap", "viet-family-city-danang-place-vo-nguyen-giap-street", "Đường Võ Nguyên Giáp", ["About", "Hear the street", "Driver phrases", "Confirm"]),
        ("hang-bac", "viet-family-city-hanoi-place-hang-bac-street", "Phố Hàng Bạc", ["About", "Hear the street", "Driver phrases", "Good to know"]),
        ("golden-bridge", "viet-family-city-danang-place-golden-bridge", "Cầu Vàng", ["About", "Hear the name", "Getting there", "Good to know"]),
        ("pho-hoa-pasteur", "viet-family-city-hcmc-place-pho-hoa-pasteur", "Phở Hòa Pasteur", ["Getting there", "Table & menu", "Order", "Pay"]),
        ("banh-mi-phuong", "viet-family-city-hoian-place-banh-mi-phuong", "Bánh mì Phượng", ["Getting there", "Table & menu", "Drinks", "Pay"]),
        ("take-me-here", "viet-family-transport-destination", "Cho tôi tới đây", ["Break it down", "Common follow-ups", "More ride phrases"]),
        ("fare", "viet-family-transport-fare", "Tiền xe bao nhiêu?", ["Break it down", "Common follow-ups", "Good to know"]),
    ]

    func testCaptureHubPagesForCityCountryTopicQA() {
        try? FileManager.default.createDirectory(at: proofDirectory, withIntermediateDirectories: true)

        for hub in hubPages {
            let app = XCUIApplication()
            app.launchArguments = hub.arguments
            app.launch()

            XCTAssertTrue(app.staticTexts[hub.title].waitForExistence(timeout: 8), "\(hub.title) did not appear.")
            capture(name: "hub-\(hub.label)-top.png")

            for text in hub.requiredTexts {
                scrollUntilExists(app: app, text: text)
            }

            XCTAssertFalse(app.staticTexts["Practice nearby"].exists, "Practice nearby should not render on \(hub.label).")
            XCTAssertFalse(app.staticTexts["Nearby needs"].exists, "Nearby needs should not render on \(hub.label).")

            app.swipeUp()
            app.swipeUp()
            capture(name: "hub-\(hub.label)-middle.png")

            app.terminate()
        }
    }

    func testCaptureFreshDiverseListingLoopPages() {
        try? FileManager.default.createDirectory(at: proofDirectory, withIntermediateDirectories: true)

        for (index, page) in detailPages.enumerated() {
            let app = XCUIApplication()
            app.launchArguments = ["--detail-page", page.pageID]
            app.launch()

            XCTAssertTrue(app.staticTexts[page.title].waitForExistence(timeout: 8), "\(page.title) did not appear.")
            capture(name: String(format: "listing-%02d-%@-top.png", index + 1, page.label))

            for text in page.requiredTexts {
                scrollUntilExists(app: app, text: text)
            }

            XCTAssertFalse(app.staticTexts["Practice nearby"].exists, "Practice nearby should not render on \(page.label).")
            XCTAssertFalse(app.staticTexts["Nearby needs"].exists, "Nearby needs should not render on \(page.label).")

            app.swipeUp()
            app.swipeUp()
            capture(name: String(format: "listing-%02d-%@-middle.png", index + 1, page.label))

            app.terminate()
        }
    }

    private func capture(name: String) {
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: proofDirectory.appendingPathComponent(name))
    }

    private func scrollUntilExists(app: XCUIApplication, text: String, maxSwipes: Int = 10) {
        for _ in 0..<maxSwipes {
            let element = matchingStaticText(app: app, text: text)
            if element.exists {
                return
            }
            app.swipeUp()
        }
        XCTAssertTrue(matchingStaticText(app: app, text: text).exists, "\(text) did not become available")
    }

    private func matchingStaticText(app: XCUIApplication, text: String) -> XCUIElement {
        let exact = app.staticTexts[text]
        if exact.exists {
            return exact
        }
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        return app.staticTexts.matching(predicate).firstMatch
    }
}
