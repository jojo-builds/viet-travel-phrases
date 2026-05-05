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
