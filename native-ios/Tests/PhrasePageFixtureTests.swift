import XCTest
@testable import SpeakLocalNative

final class PhrasePageFixtureTests: XCTestCase {
    private let expectedLocalGreetingWays: [String: [String]] = [
        "viet-hello-anh": ["Chào anh", "Xin chào anh", "Dạ, chào anh", "Anh ơi!", "Anh đi đâu đấy?", "Anh ăn cơm chưa?"],
        "viet-hello-chi": ["Chào chị", "Xin chào chị", "Dạ, chào chị", "Chị ơi!", "Chị đi đâu đấy?", "Chị ăn cơm chưa?"],
        "viet-hello-em": ["Chào em", "Xin chào em", "Chào em nhé", "Em ơi!", "Em khỏe không?", "Em ăn cơm chưa?"],
        "viet-hello-ong": ["Chào ông", "Xin chào ông", "Dạ, chào ông", "Ông ơi!", "Ông khỏe không?", "Ông ăn cơm chưa?"],
        "viet-hello-ba": ["Chào bà", "Xin chào bà", "Dạ, chào bà", "Bà ơi!", "Bà khỏe không?", "Bà ăn cơm chưa?"],
        "viet-hello-chu": ["Chào chú", "Xin chào chú", "Dạ, chào chú", "Chú ơi!", "Chú đi đâu đấy?", "Chú ăn cơm chưa?"],
        "viet-hello-co": ["Chào cô", "Xin chào cô", "Dạ, chào cô", "Cô ơi!", "Cô đi đâu đấy?", "Cô ăn cơm chưa?"],
    ]

    func testXinChaoFixtureRepresentsFirstAnswerPageWithoutNumberedSections() {
        let page = PhrasePage.xinChao

        XCTAssertEqual(page.id, "viet-polite-hello")
        XCTAssertEqual(page.title, "Xin chào")
        XCTAssertEqual(page.pronunciation, "sin chow")
        XCTAssertGreaterThanOrEqual(page.sectionTitles.count, 8)
        XCTAssertFalse(page.sectionTitles.contains("When to use it"))
        XCTAssertFalse(page.sectionTitles.contains { title in
            guard let first = title.first else { return false }
            return first.wholeNumberValue != nil
        })
    }

    func testXinChaoFixtureKeepsWikipediaStyleRelationsVisible() {
        let page = PhrasePage.xinChao

        XCTAssertTrue(page.atGlance.contains("relationship word"))
        XCTAssertTrue(page.situationalGreetingsLeadIn.contains("setting"))
        XCTAssertTrue(page.localGreetingsLeadIn.contains("most local pattern"))
        XCTAssertTrue(page.followUpsLeadIn.contains("room to continue"))
        XCTAssertEqual(page.exploreNext.map(\.id), [
            "polite-thank-you",
            "polite-sorry",
            "goodbye",
        ])
        XCTAssertTrue(page.followUps.contains { $0.id == "how-are-you" })
    }

    func testXinChaoFixtureMarksOnlyUsefulSecondLevelDestinations() {
        let page = PhrasePage.xinChao

        XCTAssertNil(page.quickSay.first { $0.id == "polite-5" }?.detailPageID)
        XCTAssertEqual(page.situationalGreetings.first { $0.id == "formal" }?.detailPageID, "viet-respectful-hello")
        XCTAssertEqual(page.situationalGreetings.first { $0.id == "phone" }?.detailPageID, "viet-phone-hello")
        XCTAssertEqual(page.localGreetings.compactMap(\.detailPageID), [
            "viet-hello-anh",
            "viet-hello-chi",
            "viet-hello-em",
            "viet-hello-ong",
            "viet-hello-ba",
            "viet-hello-chu",
            "viet-hello-co",
        ])
        XCTAssertEqual(page.followUps.first { $0.id == "where-going" }?.detailPageID, "viet-where-going")
        XCTAssertEqual(page.exploreNext.first { $0.id == "polite-sorry" }?.detailPageID, "viet-excuse-sorry")
    }

    func testLocalGreetingRowsOpenSpecificPhrasePages() throws {
        let page = PhrasePage.xinChao

        for phrase in page.localGreetings {
            let detailPageID = try XCTUnwrap(phrase.detailPageID)
            XCTAssertNotEqual(detailPageID, "viet-local-greetings")

            let detailPage = try XCTUnwrap(PhraseDetailPage.page(withID: detailPageID))
            XCTAssertEqual(detailPage.title, phrase.vietnamese)
            XCTAssertEqual(detailPage.englishTitle, phrase.english)
            XCTAssertEqual(detailPage.pronunciation, phrase.pronunciation)
            XCTAssertTrue(detailPage.sections.contains { $0.title == "At a glance" })
            XCTAssertTrue(detailPage.sections.contains { $0.title == "Break it down" })
        }
    }

    func testHelloAnhDetailPageUsesLLMStyleStructuredAnswer() throws {
        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-hello-anh"))

        XCTAssertEqual(page.sections.map(\.title), [
            "At a glance",
            "Break it down",
            "Ways to say it",
            "When to use it",
            "Local tip",
        ])

        let ways = try XCTUnwrap(page.sections.first { $0.id == "ways-to-say" })
        XCTAssertTrue(ways.body.contains("setting"))
        XCTAssertEqual(ways.phrases.map(\.vietnamese), [
            "Chào anh",
            "Xin chào anh",
            "Dạ, chào anh",
            "Anh ơi!",
            "Anh đi đâu đấy?",
            "Anh ăn cơm chưa?",
        ])
        XCTAssertTrue(ways.phrases.allSatisfy { $0.detailPageID != nil })
        XCTAssertTrue(ways.phrases.allSatisfy { phrase in
            guard let detailPageID = phrase.detailPageID else { return false }
            return PhraseDetailPage.page(withID: detailPageID)?.title == phrase.vietnamese
        })

        let breakdown = try XCTUnwrap(page.sections.first { $0.id == "breakdown" })
        XCTAssertEqual(breakdown.breakdown.map(\.vietnamese), ["Chào", "anh", "Chào anh"])
        XCTAssertTrue(breakdown.body.contains("same pattern"))

        let tip = try XCTUnwrap(page.sections.first { $0.id == "local-tip" })
        XCTAssertTrue(tip.body.contains("Chào chú"))
        XCTAssertTrue(tip.body.contains("Chào ông"))
    }

    func testAllLocalGreetingDetailsUseDeepAnswerPattern() throws {
        for phrase in PhrasePage.xinChao.localGreetings {
            let detailPageID = try XCTUnwrap(phrase.detailPageID)
            let page = try XCTUnwrap(PhraseDetailPage.page(withID: detailPageID))
            let relationshipWord = try XCTUnwrap(page.title.split(separator: " ").last.map(String.init))

            XCTAssertEqual(page.sections.map(\.title), [
                "At a glance",
                "Break it down",
                "Ways to say it",
                "When to use it",
                "Local tip",
            ], page.id)

            let ways = try XCTUnwrap(page.sections.first { $0.id == "ways-to-say" }, page.id)
            XCTAssertEqual(ways.phrases.map(\.vietnamese), expectedLocalGreetingWays[page.id], page.id)
            XCTAssertTrue(ways.phrases.allSatisfy { $0.detailPageID != nil }, page.id)
            XCTAssertTrue(ways.phrases.allSatisfy { phrase in
                guard let childID = phrase.detailPageID else { return false }
                return PhraseDetailPage.page(withID: childID)?.title == phrase.vietnamese
            }, page.id)

            let breakdown = try XCTUnwrap(page.sections.first { $0.id == "breakdown" }, page.id)
            XCTAssertEqual(breakdown.breakdown.map(\.vietnamese), ["Chào", relationshipWord, page.title], page.id)

            let localTip = try XCTUnwrap(page.sections.first { $0.id == "local-tip" }, page.id)
            XCTAssertFalse(localTip.body.isEmpty, page.id)
        }
    }

    func testDetailPagesStayOneLevelDeep() {
        let expectedChildPageCount = expectedLocalGreetingWays.values.reduce(0) { $0 + $1.count } - expectedLocalGreetingWays.count

        XCTAssertEqual(PhraseDetailPage.all.count, 17 + expectedChildPageCount)
        XCTAssertNotNil(PhraseDetailPage.page(withID: "viet-local-greetings"))
        XCTAssertTrue(PhraseDetailPage.all.flatMap(\.examples).allSatisfy { $0.detailPageID == nil })

        let childPages = PhraseDetailPage.all.filter { $0.id.contains("-way-") }
        XCTAssertEqual(childPages.count, expectedChildPageCount)
        XCTAssertTrue(childPages.flatMap(\.sections).flatMap(\.phrases).allSatisfy { $0.detailPageID == nil })
    }

    func testLocalGreetingStandardWaysUseCanonicalParentPage() throws {
        for phrase in PhrasePage.xinChao.localGreetings {
            let parentID = try XCTUnwrap(phrase.detailPageID)
            let parentPage = try XCTUnwrap(PhraseDetailPage.page(withID: parentID))
            let ways = try XCTUnwrap(parentPage.sections.first { $0.id == "ways-to-say" })
            let standardWay = try XCTUnwrap(ways.phrases.first)

            XCTAssertEqual(standardWay.vietnamese, parentPage.title)
            XCTAssertEqual(standardWay.detailPageID, parentPage.id)
            XCTAssertNil(PhraseDetailPage.page(withID: "\(parentPage.id)-way-standard"))
        }
    }

    func testPhrasePageTitlesAreCanonicalAndUnique() {
        let groupedByTitle = Dictionary(grouping: PhraseDetailPage.all) { page in
            page.title
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                .lowercased()
        }

        let duplicates = groupedByTitle.filter { $0.value.count > 1 }
        XCTAssertTrue(duplicates.isEmpty, "Duplicate canonical page titles: \(duplicates)")
    }

    func testSearchIndexCanOpenWayPhrasePagesDirectly() throws {
        let results = PhraseSearchIndex.search("Anh ơi")
        let result = try XCTUnwrap(results.first)
        let page = try XCTUnwrap(PhraseDetailPage.page(withID: result.pageID))

        XCTAssertEqual(page.title, "Anh ơi!")
        XCTAssertEqual(result.pageID, page.id)
    }

    func testSearchIndexResolvesChaoAnhToOneCanonicalPage() throws {
        let results = PhraseSearchIndex.search("Chào anh")
        let exactMatches = results.filter { $0.title == "Chào anh" }

        XCTAssertEqual(exactMatches.map(\.pageID), ["viet-hello-anh"])
    }
}
