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
        ("table-available", "viet-family-vpe-likely-replies-ban-nay-con-trong", "Bàn này còn trống"),
        ("ba-na-hills", "viet-phrase-city-danang-place-ba-na-hills", "Bà Nà Hills"),
        ("dragon-bridge", "viet-phrase-city-danang-place-dragon-bridge", "Cầu Rồng"),
        ("nguyen-van-linh", "viet-phrase-city-danang-place-nguyen-van-linh-street", "Đường Nguyễn Văn Linh"),
        ("anan-saigon", "viet-phrase-city-hcmc-place-anan-saigon", "Anăn Sài Gòn"),
        ("post-office-where", "viet-phrase-city-hcmc-where-post-office", "Bưu điện Thành phố ở đâu?"),
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
        ("table-available", "viet-family-vpe-likely-replies-ban-nay-con-trong", "Bàn này còn trống", "traveler_may_hear"),
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
        ("post-office-where", "viet-family-city-hcmc-where-post-office", "Bưu điện Thành phố ở đâu?", "derived_place_phrase"),
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
            "garlic-ingredient",
            "viet-family-vpe-food-has-co-toi-khong",
            "Có tỏi không?",
            ["Other ingredients", "More ingredient questions", "tỏi", "garlic"]
        ),
        (
            "taxi-help",
            "viet-family-vpe-pronoun-help-anh-giup-toi-goi-taxi-duoc-khong",
            "Anh giúp tôi gọi taxi được không?",
            ["Getting a ride", "More ride phrases"]
        ),
        (
            "doctor-coming",
            "viet-family-vpe-likely-replies-bac-si-dang-den",
            "Bác sĩ đang đến",
            ["You may hear", "Related replies", "Stay nearby"]
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
            ["Practice asking for help calmly.", "Help!"]
        ),
        (
            "shopping-hub",
            ["--browse-category", "shopping"],
            "Shopping",
            ["Practice prices, sizes, payment, and returns."]
        ),
        (
            "danang-city-hub",
            ["--browse-city", "danang"],
            "Da Nang",
            ["Names to know", "Browse Da Nang", "Practice a Da Nang day"]
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

final class ListingHubRandomLoopProofUITests: XCTestCase {
    private let proofDirectory = URL(
        fileURLWithPath: ProcessInfo.processInfo.environment["SPEAKLOCAL_LISTING_HUB_RANDOM_LOOP_PROOF_DIR"]
            ?? "/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-LISTING-HUB-RANDOM-LOOP-001",
        isDirectory: true
    )

    private let hubPages: [(label: String, arguments: [String], title: String, requiredTexts: [String])] = [
        ("all-vietnam", ["--browse-category", "city-guides"], "All Vietnam", ["Start here", "City guides", "Practice Vietnam basics"]),
        ("hanoi", ["--browse-city", "hanoi"], "Hanoi", ["Names to know", "Browse Hanoi", "Common moments", "Quick phrases"]),
        ("saigon", ["--browse-city", "hcmc"], "Saigon", ["Names to know", "Browse Saigon", "Common moments", "Quick phrases"]),
        ("hoi-an", ["--browse-city", "hoian"], "Hoi An", ["Names to know", "Browse Hoi An", "Common moments", "Quick phrases"]),
        ("hue", ["--browse-city", "hue"], "Hue", ["Names to know", "Browse Hue", "Common moments", "Quick phrases"]),
        ("airport-topic", ["--browse-category", "airport"], "Airport", ["Good first phrases", "Airport Baggage", "Passport Control", "SIM & Cash"]),
        ("hotel-topic", ["--browse-category", "hotel"], "Hotel", ["At the hotel desk", "Hotel Check-In", "Room Help", "Bags & Taxi"]),
        ("food-topic", ["--browse-category", "food"], "Food & coffee", ["Places, dishes, and coffee", "Coffee shops", "Coffee & drinks", "Dishes to order", "Food Allergies", "Restaurant Table", "Beach Snacks"]),
        ("getting-around-topic", ["--browse-category", "getting-around"], "Getting Around", ["Start here", "Grab Pickup", "Taxi Route", "Driver Help"]),
        ("local-greetings-topic", ["--browse-category", "local-greetings"], "Local Greetings", ["Start here", "Market Hello", "Hotel Hello", "Respectful Hello"]),
    ]

    private let detailPages: [(label: String, pageID: String, title: String, requiredTexts: [String])] = [
        ("excuse-sorry", "viet-excuse-sorry", "Xin lỗi", ["Break it down", "Common follow-ups", "Good to know", "Next phrases"]),
        ("cash-only", "viet-family-vpe-likely-replies-chi-nhan-tien-mat", "Chỉ nhận tiền mặt", ["You may hear", "Related replies", "Can I pay by card?", "nearest ATM"]),
        ("gate-changed", "viet-family-vpe-likely-replies-cong-doi-roi", "Cổng đổi rồi", ["You may hear", "confirm the new gate", "Where is the boarding gate?"]),
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
