import CoreGraphics
import XCTest
@testable import SpeakLocalNative

final class PhrasePageFixtureTests: XCTestCase {
    override func setUp() {
        super.setUp()
        VietSQLitePhraseGraphRuntime.setEnabledForTesting(false)
        PhraseCatalog.resetCacheForTesting()
    }

    override func tearDown() {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()
        PhraseCatalog.resetCacheForTesting()
        super.tearDown()
    }

    private func skipRetiredGeneratedJSONCatalog(_ reason: String = "Retired generated JSON catalog assertions are covered by the SQLite fixture validators after the native-only migration.") throws {
        throw XCTSkip(reason)
    }

    private func enableSQLiteRuntimeForTesting() {
        VietSQLitePhraseGraphRuntime.setEnabledForTesting(true)
        PhraseCatalog.resetCacheForTesting()
    }

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

    func testNiceToMeetYouUsesDeepAnswerPattern() throws {
        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-nice-to-meet-you"))

        XCTAssertEqual(page.sections.map(\.title), [
            "At a glance",
            "Break it down",
            "Ways to say it",
            "Pronoun refresher",
            "When to use it",
            "Local tip",
        ])

        let breakdown = try XCTUnwrap(page.sections.first { $0.id == "breakdown" })
        XCTAssertEqual(breakdown.breakdown.map(\.vietnamese), [
            "Rất",
            "vui",
            "được gặp",
            "bạn",
            "Rất vui được gặp bạn",
        ])
        XCTAssertEqual(breakdown.breakdown.last?.playbackAudioKey, "audio-phrase-rat-vui-duoc-gap-ban")

        let ways = try XCTUnwrap(page.sections.first { $0.id == "ways-to-say" })
        XCTAssertEqual(ways.phrases.map(\.vietnamese), [
            "Rất vui được gặp bạn",
            "Rất vui được gặp anh",
            "Rất vui được gặp chị",
            "Rất hân hạnh được gặp anh",
            "Rất hân hạnh được gặp chị",
            "Vinh dự được gặp anh",
            "Vinh dự được gặp chị",
            "Vui quá!",
            "Rất vui được gặp lại bạn",
        ])
        XCTAssertTrue(ways.body.contains("relationship"))

        let tip = try XCTUnwrap(page.sections.first { $0.id == "local-tip" })
        XCTAssertTrue(tip.body.contains("Bạn đến từ đâu?"))
        XCTAssertTrue(tip.body.contains("Bạn ở đây lâu chưa?"))
    }

    func testRepairMeaningUsesAuthoredDifferentWaysAnswer() throws {
        try skipRetiredGeneratedJSONCatalog()

        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-repair-meaning"))

        XCTAssertEqual(page.title, "Cái đó nghĩa là gì?")
        XCTAssertEqual(page.englishTitle, "What does that mean?")
        XCTAssertEqual(page.sections.map(\.title), [
            "At a glance",
            "Break it down",
            "The standard way",
            "Natural variations",
            "Pronoun swap",
            "When to use it",
            "Good to know",
            "Local tip",
            "Explore next",
        ])

        let atGlance = try XCTUnwrap(page.sections.first { $0.id == "at-glance" })
        XCTAssertTrue(atGlance.body.contains("when Vietnamese stops making sense"))
        XCTAssertTrue(atGlance.body.contains("word, sign, menu item"))
        XCTAssertFalse(page.sections.map(\.body).joined(separator: " ").contains("repair phrase"))

        let standard = try XCTUnwrap(page.sections.first { $0.id == "standard-way" })
        XCTAssertEqual(standard.phrases.map(\.vietnamese), [
            "Cái đó nghĩa là gì?",
            "Cái này nghĩa là gì?",
        ])
        XCTAssertTrue(standard.body.contains("works in most situations"))

        let variations = try XCTUnwrap(page.sections.first { $0.id == "natural-variations" })
        XCTAssertEqual(variations.phrases.map(\.vietnamese), [
            "Nghĩa là sao?",
            "Ý bạn là gì?",
            "Từ này nghĩa là gì?",
            "Cho hỏi, cái này nghĩa là gì ạ?",
        ])
        XCTAssertTrue(variations.body.contains("not every kind of confusion"))

        let pronounSwap = try XCTUnwrap(page.sections.first { $0.id == "pronoun-swap" })
        XCTAssertTrue(pronounSwap.body.contains("relationship word"))
        XCTAssertEqual(pronounSwap.phrases.map(\.vietnamese), [
            "Anh nói thế nghĩa là sao?",
            "Chị nói thế nghĩa là sao?",
            "Em nói cái này nghĩa là gì?",
            "Cái này nghĩa là gì vậy em?",
        ])
        XCTAssertEqual(pronounSwap.phrases.map(\.english), [
            "To an older man: what do you mean by that?",
            "To an older woman: what do you mean by that?",
            "To someone younger: what does this mean?",
            "Softer, to someone younger: what does this mean?",
        ])

        let goodToKnow = try XCTUnwrap(page.sections.first { $0.id == "good-to-know" })
        XCTAssertEqual(goodToKnow.presentation, .tipCallout)
        XCTAssertTrue(goodToKnow.body.contains("curious tone"))
        XCTAssertFalse(page.sections.contains { $0.id == "watch-out" || $0.title == "Watch out" })

        XCTAssertEqual(PhraseSearchIndex.search("what does that mean").first?.pageID, page.id)
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

    func testLocalGreetingWayPagesStayOneLevelDeep() {
        let expectedChildPageCount = expectedLocalGreetingWays.values.reduce(0) { $0 + $1.count } - expectedLocalGreetingWays.count

        XCTAssertNil(PhraseDetailPage.page(withID: "viet-local-greetings"))
        XCTAssertTrue(PhraseDetailPage.all.flatMap(\.examples).allSatisfy { $0.detailPageID == nil })

        let childPages = PhraseDetailPage.all.filter { $0.id.contains("-way-") }
        XCTAssertEqual(childPages.count, expectedChildPageCount)
        XCTAssertTrue(childPages.flatMap(\.sections).flatMap(\.phrases).allSatisfy { $0.detailPageID == nil })
    }

    func testLegacyLocalGreetingsCatchAllIsNotLinkedFromXinChao() {
        let phraseGroups: [[PhraseOption]] = [
            PhrasePage.xinChao.quickSay,
            PhrasePage.xinChao.situationalGreetings,
            PhrasePage.xinChao.localGreetings,
            PhrasePage.xinChao.followUps,
        ]
        let linkedPageIDs = phraseGroups.flatMap { $0 }.compactMap(\.detailPageID)

        XCTAssertFalse(linkedPageIDs.contains("viet-local-greetings"))
        XCTAssertFalse(PhraseCatalog.isOpenablePageID("viet-local-greetings"))
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

    func testSearchIndexPrioritizesCanonicalHelloPageForHelloQuery() throws {
        let result = try XCTUnwrap(PhraseSearchIndex.search("hello").first)

        XCTAssertEqual(result.pageID, PhrasePage.xinChao.id)
        XCTAssertEqual(result.title, "Xin chào")
    }

    func testSearchIndexPrioritizesCanonicalHelloPageForPhoneticQuery() throws {
        let result = try XCTUnwrap(PhraseSearchIndex.search("sin chow").first)

        XCTAssertEqual(result.pageID, PhrasePage.xinChao.id)
        XCTAssertEqual(result.title, "Xin chào")
    }

    func testStarterSayFirstFamiliesAreTierOneSearchPriority() throws {
        try skipRetiredGeneratedJSONCatalog()

        XCTAssertEqual(GeneratedVietContent.searchPriority(forFamilyID: "airport-baggage"), .tier1)
        XCTAssertEqual(GeneratedVietContent.searchPriority(forFamilyID: "transport-destination"), .tier1)
    }

    func testPremiumSayFirstFamiliesStayBelowTierOneSearchPriority() throws {
        try skipRetiredGeneratedJSONCatalog()

        XCTAssertEqual(GeneratedVietContent.searchPriority(forFamilyID: "hotel-quiet-room"), .deepCatalog)
    }

    func testTierOnePageIDsExposeAuthoredListingUpgradeQueue() throws {
        try skipRetiredGeneratedJSONCatalog()

        let pageIDs = GeneratedVietContent.tierOnePageIDs

        XCTAssertTrue(pageIDs.contains(PhrasePage.xinChao.id))
        XCTAssertTrue(pageIDs.contains("viet-family-airport-baggage"))
        XCTAssertTrue(pageIDs.contains("viet-family-transport-destination"))
        XCTAssertEqual(pageIDs.count, 150)
        XCTAssertEqual(AuthoredVietListingPages.bundledTierOneFamilyCount, 150)
        XCTAssertEqual(AuthoredVietListingPages.bundledMainPageCount, 149)
        XCTAssertEqual(AuthoredVietListingPages.bundledChildPageCount, 15)
    }

    func testAllTierOnePagesAreAuthoredOrCoveredByRootPage() {
        let pageIDs = GeneratedVietContent.tierOnePageIDs
        let missing = pageIDs.filter { pageID in
            pageID != PhrasePage.xinChao.id && !PhraseDetailPage.hasAuthoredPage(withID: pageID)
        }

        XCTAssertTrue(missing.isEmpty, "Tier 1 pages still using generated fallback: \(missing.sorted())")
    }

    func testAllTierOnePagesUseArticleTemplateContract() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)

        for pageID in GeneratedVietContent.tierOnePageIDs.sorted() {
            let article: PhraseArticlePage

            if pageID == PhrasePage.xinChao.id {
                article = PhrasePage.xinChao.articleTemplate
            } else {
                XCTAssertTrue(PhraseDetailPage.hasAuthoredPage(withID: pageID), pageID)
                article = try XCTUnwrap(PhraseDetailPage.page(withID: pageID), pageID).articleTemplate
            }

            let sectionIDs = Set(article.sections.map(\.id))

            XCTAssertTrue(sectionIDs.contains("at-glance"), pageID)
            XCTAssertTrue(sectionIDs.contains("breakdown"), pageID)
            XCTAssertTrue(article.showsCatalogExplore, pageID)
            XCTAssertNotNil(manifest.url(for: article.playbackAudioKey), pageID)
            XCTAssertTrue(article.sections.contains { section in
                !section.phrases.isEmpty
                    && (section.presentation == .phraseList || section.presentation == .horizontalPhraseCards)
            }, pageID)
            XCTAssertTrue(article.sections.allSatisfy { section in
                section.phrases.isEmpty || section.breakdown.isEmpty
            }, pageID)
        }
    }

    func testAuthoredTierOneSectionPresentationRolesAreExplicit() throws {
        try skipRetiredGeneratedJSONCatalog()

        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-repair-write-down"))
        let sectionsByID = Dictionary(uniqueKeysWithValues: page.articleTemplate.sections.map { ($0.id, $0) })

        XCTAssertEqual(sectionsByID["breakdown"]?.presentation, .breakdownStrip)
        XCTAssertEqual(sectionsByID["standard-way"]?.presentation, .phraseList)
        XCTAssertEqual(sectionsByID["nearby-phrases"]?.presentation, .horizontalPhraseCards)
        XCTAssertEqual(sectionsByID["good-to-know"]?.presentation, .tipCallout)
        XCTAssertEqual(sectionsByID["local-tip"]?.presentation, .tipCallout)
        XCTAssertEqual(sectionsByID["standard-way"]?.title, "Quick say")
        XCTAssertNil(sectionsByID["watch-out"])
        XCTAssertFalse(sectionsByID.values.contains { $0.presentation == .warningCallout })
    }

    func testTierOneArticleVisibleAudioKeysResolve() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)

        for pageID in GeneratedVietContent.tierOnePageIDs.sorted() {
            let article = try articleTemplate(forTierOnePageID: pageID)

            XCTAssertNotNil(manifest.url(for: article.playbackAudioKey), pageID)
            XCTAssertTrue(
                manifest.hasPlayableEntry(for: article.playbackAudioKey, matchingText: article.title),
                pageID
            )

            for phrase in article.sections.flatMap(\.phrases) {
                XCTAssertNotNil(manifest.url(for: phrase.playbackAudioKey), "\(pageID): \(phrase.vietnamese)")
                XCTAssertTrue(
                    manifest.hasPlayableEntry(for: phrase.playbackAudioKey, matchingText: phrase.vietnamese),
                    "\(pageID): \(phrase.vietnamese)"
                )
            }

            for token in article.sections.flatMap(\.breakdown) {
                guard let playbackAudioKey = token.playbackAudioKey else {
                    continue
                }

                XCTAssertNotNil(manifest.url(for: playbackAudioKey), "\(pageID): \(token.vietnamese)")
                XCTAssertTrue(
                    manifest.hasPlayableEntry(for: playbackAudioKey, matchingText: token.vietnamese),
                    "\(pageID): \(token.vietnamese)"
                )
            }
        }
    }

    func testTierOneCatalogAudioKeysMatchVisibleTitles() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)

        for pageID in GeneratedVietContent.tierOnePageIDs.sorted() {
            guard let item = PhraseCatalog.allItems.first(where: { $0.pageID == pageID }) else {
                continue
            }

            XCTAssertTrue(
                manifest.hasPlayableEntry(for: item.playbackAudioKey, matchingText: item.title),
                "\(pageID): \(item.title)"
            )
        }
    }

    func testAuthoredResourceSectionsCarryPresentationMetadata() throws {
        try skipRetiredGeneratedJSONCatalog()

        let url = try XCTUnwrap(Bundle.main.url(
            forResource: "viet-authored-listing-pages",
            withExtension: "json"
        ))
        let data = try Data(contentsOf: url)
        let object = try XCTUnwrap(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        let pages = try XCTUnwrap(object["pages"] as? [[String: Any]])
        let allowedPresentations = Set([
            "plain-text",
            "phrase-list",
            "horizontal-phrase-cards",
            "breakdown-strip",
            "tip-callout",
        ])

        for page in pages {
            let pageID = try XCTUnwrap(page["id"] as? String)
            let sections = try XCTUnwrap(page["sections"] as? [[String: Any]], pageID)

            for section in sections {
                let presentation = try XCTUnwrap(section["presentation"] as? String, pageID)
                XCTAssertTrue(allowedPresentations.contains(presentation), "\(pageID): \(presentation)")
                XCTAssertNotEqual(section["id"] as? String, "watch-out", pageID)
                XCTAssertNotEqual(section["title"] as? String, "Watch out", pageID)
                XCTAssertNotEqual(presentation, "warning-callout", pageID)
            }
        }
    }

    func testCityNounPagesAreHandwrittenReviewedAndUseUniqueTargetHeroes() throws {
        try skipRetiredGeneratedJSONCatalog()

        let url = try XCTUnwrap(Bundle.main.url(
            forResource: "viet-authored-listing-pages",
            withExtension: "json"
        ))
        let data = try Data(contentsOf: url)
        let object = try XCTUnwrap(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        let pages = try XCTUnwrap(object["pages"] as? [[String: Any]])
        let cityNounPages = pages.filter { page in
            guard page["tierRole"] as? String == "city-v1",
                  let metadata = page["cityMetadata"] as? [String: Any],
                  metadata["derivedPlacePhrase"] as? Bool == false,
                  let pageKind = metadata["pageKind"] as? String
            else { return false }

            return ["place", "restaurant", "dish", "drink", "dessert"].contains(pageKind)
        }
        let groupedByCity = Dictionary(grouping: cityNounPages) { page -> String in
            let metadata = page["cityMetadata"] as? [String: Any]
            return metadata?["cityID"] as? String ?? ""
        }
        let targetHeroes = cityNounPages.compactMap { page -> String? in
            let metadata = page["cityMetadata"] as? [String: Any]
            return metadata?["targetHeroImageName"] as? String
        }

        XCTAssertEqual(cityNounPages.count, 500)
        XCTAssertEqual(groupedByCity["hanoi"]?.count, 100)
        XCTAssertEqual(groupedByCity["hcmc"]?.count, 100)
        XCTAssertEqual(groupedByCity["danang"]?.count, 100)
        XCTAssertEqual(groupedByCity["hoian"]?.count, 100)
        XCTAssertEqual(groupedByCity["hue"]?.count, 100)
        XCTAssertEqual(Set(targetHeroes).count, 500)

        for page in cityNounPages {
            let pageID = try XCTUnwrap(page["id"] as? String)
            let metadata = try XCTUnwrap(page["cityMetadata"] as? [String: Any], pageID)
            XCTAssertEqual(metadata["editorialReviewStatus"] as? String, "handwritten-reviewed", pageID)
            XCTAssertFalse((page["summary"] as? String ?? "").isEmpty, pageID)
            XCTAssertFalse((metadata["targetHeroImageName"] as? String ?? "").isEmpty, pageID)
        }
    }

    func testTierOneGeneratedPagesUseExpandedListingPattern() throws {
        try skipRetiredGeneratedJSONCatalog()

        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-repair-write-down"))

        XCTAssertEqual(page.sections.prefix(8).map(\.title), [
            "At a glance",
            "Break it down",
            "The standard way",
            "Why it matters",
            "Traveler insight",
            "When to use it",
            "Good to know",
            "Local tip",
        ])
        XCTAssertEqual(page.sections.last?.title, "Explore next")
        XCTAssertTrue(page.sections.first { $0.id == "at-glance" }?.body.contains("Written text often rescues") == true)
        XCTAssertTrue(page.sections.first { $0.id == "why-it-matters" }?.body.contains("cooperative") == true)
        let linkedFlowCount = (page.sections.first { $0.id == "nearby-phrases" }?.phrases.count ?? 0)
            + (page.sections.first { $0.id == "explore-next" }?.phrases.count ?? 0)
        XCTAssertGreaterThanOrEqual(linkedFlowCount, 6)
    }

    func testAllTierOneGeneratedPagesHaveExpandedListingPattern() throws {
        for pageID in GeneratedVietContent.tierOnePageIDs.sorted() {
            guard pageID != PhrasePage.xinChao.id else {
                continue
            }

            guard pageID.hasPrefix("viet-family-") else {
                continue
            }

            let page = try XCTUnwrap(PhraseDetailPage.page(withID: pageID), pageID)
            let sectionIDs = page.sections.map(\.id)

            XCTAssertTrue(sectionIDs.contains("at-glance"), pageID)
            XCTAssertTrue(sectionIDs.contains("breakdown"), pageID)
            XCTAssertTrue(sectionIDs.contains("when-to-use"), pageID)
            XCTAssertTrue(
                sectionIDs.contains("good-to-know")
                    || sectionIDs.contains("traveler-insight")
                    || sectionIDs.contains("traveler-tip")
                    || sectionIDs.contains("local-tip"),
                pageID
            )
            XCTAssertFalse(sectionIDs.contains("watch-out"), pageID)
            XCTAssertFalse(page.sections.contains { $0.title == "Watch out" || $0.presentation == .warningCallout }, pageID)
            XCTAssertTrue(sectionIDs.contains("explore-next"), pageID)
            XCTAssertGreaterThanOrEqual(sectionIDs.count, 6, pageID)
        }
    }

    func testSearchPrefersTierOneTravelPhraseForBroadRoomQuery() throws {
        try skipRetiredGeneratedJSONCatalog()

        let results = PhraseSearchIndex.search("room")
        let result = try XCTUnwrap(results.first)

        XCTAssertEqual(result.pageID, "viet-family-hotel-room-hot")
        XCTAssertEqual(result.title, "Phòng này nóng quá")
        XCTAssertFalse(results.prefix(5).contains { $0.pageID == PhrasePage.xinChao.id })
    }

    func testExactPremiumMatchStillWinsOverTierOneBoost() throws {
        try skipRetiredGeneratedJSONCatalog()

        let result = try XCTUnwrap(PhraseSearchIndex.search("quiet room").first)

        XCTAssertEqual(result.pageID, "viet-family-hotel-quiet-room")
        XCTAssertEqual(result.title, "Cho tôi phòng yên tĩnh được không?")
    }

    func testSearchReturnsCanonicalAuthoredArticlePagesFirst() throws {
        try skipRetiredGeneratedJSONCatalog()

        let expectations = [
            ("Cái đó nghĩa là gì?", "viet-family-repair-meaning"),
            ("Viết xuống giúp tôi", "viet-family-repair-write-down"),
            ("What time is check-out?", "viet-family-hotel-checkout-time"),
            ("Where is baggage claim?", "viet-family-airport-baggage"),
            ("How much is this?", "viet-family-money-how-much"),
        ]

        for (query, expectedPageID) in expectations {
            let result = try XCTUnwrap(PhraseSearchIndex.search(query).first, query)
            XCTAssertEqual(result.pageID, expectedPageID, query)
            XCTAssertTrue(PhraseCatalog.isOpenablePageID(result.pageID), query)
            XCTAssertTrue(
                result.pageID == PhrasePage.xinChao.id || PhraseDetailPage.hasAuthoredPage(withID: result.pageID),
                query
            )
        }
    }

    func testEveryTierOneArticleIsSearchableByExactTitleAndEnglish() throws {
        for pageID in GeneratedVietContent.tierOnePageIDs.sorted() {
            let article = try articleTemplate(forTierOnePageID: pageID)

            XCTAssertEqual(
                PhraseSearchIndex.search(article.title).first?.pageID,
                pageID,
                "\(pageID): \(article.title)"
            )

            XCTAssertTrue(
                PhraseSearchIndex.search(article.englishTitle).prefix(5).contains { $0.pageID == pageID },
                "\(pageID): \(article.englishTitle)"
            )
        }
    }

    func testExploreCatalogDefaultsToCurrentPageCategory() {
        XCTAssertEqual(PhraseCatalog.defaultCategoryID(forPageID: PhrasePage.xinChao.id), "greetings")
        XCTAssertEqual(PhraseCatalog.defaultCategoryID(forPageID: "viet-hello-anh"), "local-greetings")
        XCTAssertEqual(PhraseCatalog.defaultCategoryID(forPageID: "viet-thank-you"), "gratitude")
    }

    func testRelationshipGreetingCategoryIsSpecificInsteadOfGenericLocal() throws {
        let category = try XCTUnwrap(PhraseCatalog.category(withID: "local-greetings"))

        XCTAssertEqual(category.title, "Relationship greetings")
        XCTAssertEqual(category.symbolName, "person.2.fill")
    }

    func testUnderstandingCategoryUsesTravelerFacingLanguage() throws {
        enableSQLiteRuntimeForTesting()

        let category = try XCTUnwrap(PhraseCatalog.category(withID: "understanding-repair"))

        XCTAssertEqual(category.title, "When You Don't Understand")
        XCTAssertEqual(category.symbolName, "questionmark.bubble.fill")
        XCTAssertFalse(PhraseCatalog.categories.contains { $0.title.contains("Repair") })
    }

    func testTierOneGeneratedPagesExposeEnoughNearbyPhrasesToTestFlow() throws {
        try skipRetiredGeneratedJSONCatalog()

        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-repair-write-down"))
        let nearbyPhrases = page.sections.first { $0.id == "nearby-phrases" }?.phrases ?? []
        let exploreNext = try XCTUnwrap(page.sections.first { $0.id == "explore-next" })
        let linkedFlowPhrases = nearbyPhrases + exploreNext.phrases
        let linkedPageIDs = linkedFlowPhrases.compactMap(\.detailPageID)

        XCTAssertGreaterThanOrEqual(linkedFlowPhrases.count, 7)
        XCTAssertTrue(linkedFlowPhrases.contains { $0.vietnamese == "Tôi không hiểu" })
        XCTAssertTrue(linkedFlowPhrases.contains { $0.vietnamese == "Anh/chị nói tiếng Anh không?" })
        XCTAssertTrue(linkedFlowPhrases.allSatisfy { $0.detailPageID != nil })
        XCTAssertEqual(Set(linkedPageIDs).count, linkedPageIDs.count)
    }

    func testAuthoredTierOneLinksResolveToOpenableCanonicalPages() throws {
        let pageIDs = GeneratedVietContent.tierOnePageIDs
            .filter { $0 != PhrasePage.xinChao.id }

        for pageID in pageIDs {
            let page = try XCTUnwrap(PhraseDetailPage.page(withID: pageID), pageID)
            let links = page.sections.flatMap(\.phrases).compactMap(\.detailPageID)

            XCTAssertFalse(links.isEmpty, pageID)
            XCTAssertTrue(links.allSatisfy { PhraseCatalog.isOpenablePageID($0) }, pageID)
            XCTAssertEqual(Set(links).count, links.count, pageID)
        }
    }

    func testAuthoredTierOneCategoryIDsAreValid() {
        let categoryIDs = Set(PhraseCatalog.categories.map(\.id))

        for pageID in GeneratedVietContent.tierOnePageIDs {
            guard pageID != PhrasePage.xinChao.id else {
                continue
            }

            let authoredCategoryIDs = AuthoredVietListingPages.categoryIDs(for: pageID) ?? []

            XCTAssertFalse(authoredCategoryIDs.isEmpty, pageID)
            XCTAssertTrue(authoredCategoryIDs.allSatisfy { categoryIDs.contains($0) }, pageID)
        }
    }

    func testAuthoredAudioAuditOnlyHasPlannedCityMissingAudio() throws {
        try skipRetiredGeneratedJSONCatalog()

        let audit = try authoredAudioAudit()
        let metadata = try XCTUnwrap(audit["metadata"] as? [String: Any])
        let missing = try XCTUnwrap(audit["missing"] as? [[String: Any]])

        XCTAssertEqual(metadata["tierOneFamilyCount"] as? Int, 150)
        XCTAssertEqual(metadata["cityLibraryPageCount"] as? Int, 750)
        XCTAssertEqual(metadata["cityMissingAudioQueueCount"] as? Int, 749)
        XCTAssertEqual(metadata["missingAudioCount"] as? Int, 749)
        XCTAssertTrue(missing.allSatisfy { ($0["pageID"] as? String)?.hasPrefix("viet-family-city-") == true })
    }

    func testExploreCatalogBrowseSectionsStartWithCurrentCategory() throws {
        try skipRetiredGeneratedJSONCatalog("Retired mixed static/generated browse-section ordering is not valid for the SQLite-first native catalog.")

        XCTAssertEqual(
            PhraseCatalog.browseSections(
                defaultCategoryID: "airport-border-arrival",
                excludingPageID: "viet-family-airport-immigration"
            )
            .prefix(2)
            .map(\.category.id),
            [
                "airport-border-arrival",
                "greetings",
            ]
        )

        let localSections = PhraseCatalog.browseSections(
            defaultCategoryID: "local-greetings",
            excludingPageID: "viet-hello-anh"
        )

        XCTAssertEqual(localSections.first?.category.id, "local-greetings")
        XCTAssertFalse(localSections.map(\.category.id).contains(PhraseCatalog.allCategoryID))
        XCTAssertFalse(localSections.flatMap(\.items).contains { $0.pageID == "viet-hello-anh" })
    }

    func testRenderedExploreCatalogIsCappedAndRelevantForJourneyPages() throws {
        enableSQLiteRuntimeForTesting()
        _ = try VietSQLiteLanguagePackRepository.bundled()

        let sections = ExploreCatalogSection.sections(forPageID: "viet-phrase-city-danang-place-ba-na-hills")

        XCTAssertEqual(ExploreCatalogSection.browseTitle(forPageID: "viet-phrase-city-danang-place-ba-na-hills"), "More place phrases")
        XCTAssertFalse(sections.isEmpty)
        XCTAssertLessThanOrEqual(sections.count, 2)
        XCTAssertFalse(sections.contains { $0.category.id == "city-guides" })
        XCTAssertTrue(sections.allSatisfy { $0.items.count <= 6 })
        let unrelatedItems = sections.flatMap(\.items).filter { item in
            !item.categoryIDs.contains("danang") && !item.categoryIDs.contains("landmarks-attractions")
        }
        XCTAssertTrue(unrelatedItems.isEmpty, unrelatedItems.map(\.pageID).joined(separator: "\n"))
        XCTAssertTrue(sections.flatMap(\.items).allSatisfy { item in
            item.categoryIDs.contains("danang") || item.categoryIDs.contains("landmarks-attractions")
        })
    }

    func testRenderedExploreCatalogUsesContextualTitleForDerivedPlacePhrases() throws {
        enableSQLiteRuntimeForTesting()
        _ = try VietSQLiteLanguagePackRepository.bundled()

        let pageID = "viet-phrase-city-hcmc-where-ben-thanh"
        let sections = ExploreCatalogSection.sections(forPageID: pageID)

        XCTAssertEqual(ExploreCatalogSection.browseTitle(forPageID: pageID), "More Ho Chi Minh City phrases")
        XCTAssertFalse(sections.isEmpty)
        XCTAssertFalse(sections.contains { $0.category.id == "city-guides" })
        XCTAssertTrue(sections.allSatisfy { section in
            section.items.allSatisfy { item in
                item.categoryIDs.contains("hcmc") || item.categoryIDs.contains("shopping-markets")
            }
        })
    }

    func testRenderedSimplePhraseSuppressesSelfOnlySaySection() throws {
        let article = PhraseArticlePage(
            id: "test-simple-phrase",
            destination: "SpeakLocal Vietnam",
            title: "Tôi không hiểu",
            englishTitle: "I don’t understand",
            pronunciation: "toy khong hieu",
            summary: "A simple recovery phrase for when Vietnamese is too fast or unclear.",
            iconName: "message.fill",
            tintName: .red,
            playbackAudioKey: nil,
            sections: [
                PhraseArticleSection(
                    id: "standard-way",
                    title: "Say this",
                    body: "Tôi không hiểu — I don’t understand.",
                    phrases: [
                        PhraseOption(
                            id: "problems-2",
                            vietnamese: "Tôi không hiểu",
                            english: "I don’t understand",
                            pronunciation: "toy khong hieu",
                            symbolName: "speaker.wave.2.fill",
                            tintName: .red
                        ),
                    ],
                    breakdown: [],
                    presentation: .phraseList
                ),
                PhraseArticleSection(
                    id: "traveler-insight",
                    title: "Common follow-ups",
                    body: "",
                    phrases: [
                        PhraseOption(
                            id: "repair-slower",
                            vietnamese: "Nói chậm chút được không?",
                            english: "Can you speak a little slower?",
                            pronunciation: "noy cham chut duoc khong",
                            symbolName: "speaker.wave.2.fill",
                            tintName: .red
                        ),
                    ],
                    breakdown: [],
                    presentation: .phraseList
                ),
            ]
        )

        XCTAssertTrue(article.sections.contains { $0.id == "standard-way" })

        let visibleSections = PhraseArticleTemplateView.visibleSections(for: article)

        XCTAssertFalse(visibleSections.contains { $0.id == "standard-way" })
        XCTAssertFalse(visibleSections.contains { $0.title == "Say this" })
        XCTAssertTrue(visibleSections.contains { $0.title == "Common follow-ups" })
    }

    func testRenderedSimplePhraseSuppressesHeroDuplicateMeaningSection() throws {
        let article = PhraseArticlePage(
            id: "test-meaning-repeat",
            destination: "SpeakLocal Vietnam",
            title: "Nói chậm chút được không?",
            englishTitle: "Can you speak a little slower?",
            pronunciation: "noy cham chut duoc khong",
            summary: "Can you speak a little slower?",
            iconName: "message.fill",
            tintName: .red,
            playbackAudioKey: nil,
            sections: [
                PhraseArticleSection(
                    id: "meaning",
                    title: "Meaning",
                    body: "Nói chậm chút được không? means “Can you speak a little slower?”",
                    phrases: [],
                    breakdown: [],
                    presentation: .plainText
                ),
                PhraseArticleSection(
                    id: "common-follow-ups",
                    title: "Common follow-ups",
                    body: "",
                    phrases: [
                        PhraseOption(
                            id: "repair-repeat",
                            vietnamese: "Làm ơn nói lại",
                            english: "Please say that again",
                            pronunciation: "lam un noy lai",
                            symbolName: "speaker.wave.2.fill",
                            tintName: .red
                        ),
                    ],
                    breakdown: [],
                    presentation: .phraseList
                ),
            ]
        )

        let visibleSections = PhraseArticleTemplateView.visibleSections(for: article)

        XCTAssertFalse(visibleSections.contains { $0.id == "meaning" })
        XCTAssertTrue(visibleSections.contains { $0.title == "Common follow-ups" })
    }

    func testRenderedSimplePhraseKeepsUsefulMeaningContext() throws {
        let article = PhraseArticlePage(
            id: "test-useful-meaning",
            destination: "SpeakLocal Vietnam",
            title: "Tôi không hiểu",
            englishTitle: "I don’t understand",
            pronunciation: "toy khong hieu",
            summary: "A simple recovery phrase for when Vietnamese is too fast or unclear.",
            iconName: "message.fill",
            tintName: .red,
            playbackAudioKey: nil,
            sections: [
                PhraseArticleSection(
                    id: "meaning",
                    title: "Meaning",
                    body: "A simple recovery phrase for when Vietnamese is too fast or unclear.",
                    phrases: [],
                    breakdown: [],
                    presentation: .plainText
                ),
                PhraseArticleSection(
                    id: "common-follow-ups",
                    title: "Common follow-ups",
                    body: "",
                    phrases: [
                        PhraseOption(
                            id: "repair-slower",
                            vietnamese: "Nói chậm chút được không?",
                            english: "Can you speak a little slower?",
                            pronunciation: "noy cham chut duoc khong",
                            symbolName: "speaker.wave.2.fill",
                            tintName: .red
                        ),
                    ],
                    breakdown: [],
                    presentation: .phraseList
                ),
            ]
        )

        let visibleSections = PhraseArticleTemplateView.visibleSections(for: article)

        XCTAssertTrue(visibleSections.contains { $0.id == "meaning" })
        XCTAssertTrue(visibleSections.contains { $0.title == "Common follow-ups" })
    }

    func testExploreCatalogItemsCanFilterByCategoryAndExcludeCurrentPage() {
        let localItems = PhraseCatalog.items(
            selectedCategoryID: "local-greetings",
            excludingPageID: "viet-hello-anh"
        )

        XCTAssertFalse(localItems.contains { $0.pageID == "viet-hello-anh" })
        XCTAssertTrue(localItems.contains { $0.pageID == "viet-hello-chi" })
        XCTAssertTrue(localItems.allSatisfy { $0.categoryIDs.contains("local-greetings") })

        let allItems = PhraseCatalog.items(
            selectedCategoryID: PhraseCatalog.allCategoryID,
            excludingPageID: "viet-hello-anh"
        )

        XCTAssertGreaterThan(allItems.count, localItems.count)
        XCTAssertFalse(allItems.contains { $0.pageID == "viet-hello-anh" })
        XCTAssertTrue(allItems.contains { $0.pageID == PhrasePage.xinChao.id })

        let greetingItems = PhraseCatalog.items(
            selectedCategoryID: "greetings",
            excludingPageID: PhrasePage.xinChao.id
        )

        XCTAssertGreaterThanOrEqual(greetingItems.count, 8)
        XCTAssertTrue(greetingItems.contains { $0.pageID == "viet-hello-anh" })
        XCTAssertTrue(greetingItems.contains { $0.pageID == "viet-phone-hello" })
    }

    func testExploreCatalogUsesCanonicalOpenablePagesOnly() {
        let items = PhraseCatalog.items(selectedCategoryID: PhraseCatalog.allCategoryID)
        let categoryIDs = Set(PhraseCatalog.categories.map(\.id))

        XCTAssertGreaterThan(items.count, PhraseDetailPage.all.count)
        XCTAssertTrue(items.allSatisfy { item in
            item.categoryIDs.contains(item.categoryID)
                && item.categoryIDs.allSatisfy { categoryIDs.contains($0) }
        })
        XCTAssertTrue(items.allSatisfy { PhraseCatalog.isOpenablePageID($0.pageID) })
        XCTAssertEqual(items.filter { $0.title == "Chào anh" }.map(\.pageID), ["viet-hello-anh"])
        XCTAssertEqual(items.filter { $0.title == "Cảm ơn" }.map(\.pageID), ["viet-thank-you"])
        XCTAssertEqual(items.filter { $0.title == "Xin lỗi" }.map(\.pageID), ["viet-excuse-sorry"])
        XCTAssertEqual(Set(items.map(\.pageID)).count, items.count)
    }

    func testGeneratedVietContentBundleLoadsApprovedFamilies() throws {
        try skipRetiredGeneratedJSONCatalog()

        let catalog = try XCTUnwrap(GeneratedVietContent.catalog)

        XCTAssertEqual(catalog.metadata.basePhraseCount, 946)
        XCTAssertEqual(catalog.metadata.cityPhraseCount, 750)
        XCTAssertEqual(catalog.metadata.phraseCount, 1696)
        XCTAssertEqual(catalog.families.count, 1677)
        XCTAssertEqual(catalog.scenarios.count, 19)
        XCTAssertEqual(catalog.scenario(withID: "airport-border-arrival")?.title, "Airport Border Arrival")
        XCTAssertEqual(catalog.scenario(withID: "city-guides")?.title, "City Guides")

        let airport = try XCTUnwrap(catalog.family(withPageID: "viet-family-airport-immigration"))
        XCTAssertEqual(airport.id, "airport-immigration")
        XCTAssertEqual(airport.primaryPhraseID, "airport-1")
        XCTAssertEqual(catalog.phrase(withID: airport.primaryPhraseID)?.targetText, "Nhập cảnh ở đâu?")
    }

    func testGeneratedVietContentBuildsFallbackDetailPageForNonTierOneCatalogFamily() throws {
        try skipRetiredGeneratedJSONCatalog()

        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-hotel-quiet-room"))

        XCTAssertEqual(page.title, "Cho tôi phòng yên tĩnh được không?")
        XCTAssertEqual(page.englishTitle, "Can I have a quiet room?")
        XCTAssertEqual(page.pronunciation, "cho toy fong yen tinh dook khong")
        XCTAssertEqual(page.audioKey, "hotel-quiet-room")
        XCTAssertEqual(page.sections.map(\.title), [
            "At a glance",
            "Break it down",
            "When to use it",
            "Explore next",
        ])
        XCTAssertTrue(page.sections.first { $0.id == "at-glance" }?.body.contains("room location matters") == true)
        XCTAssertEqual(page.sections.first { $0.id == "breakdown" }?.breakdown.map(\.vietnamese), [
            "Cho tôi",
            "phòng",
            "yên tĩnh",
            "được không?",
            "Cho tôi phòng yên tĩnh được không?",
        ])
        XCTAssertNil(page.sections.first { $0.id == "ways-to-say" })
        XCTAssertTrue(page.sections.first { $0.id == "explore-next" }?.phrases.allSatisfy { phrase in
            guard let detailPageID = phrase.detailPageID else { return false }
            return PhraseCatalog.isOpenablePageID(detailPageID)
        } == true)
        XCTAssertTrue(page.examples.isEmpty)
    }

    func testGeneratedMultiPhraseFamiliesKeepWaysToSayVariants() throws {
        try skipRetiredGeneratedJSONCatalog()

        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-repair-slower"))
        let ways = try XCTUnwrap(page.sections.first { $0.id == "natural-variations" })

        XCTAssertFalse(ways.phrases.isEmpty)
        XCTAssertTrue(ways.phrases.allSatisfy { $0.detailPageID != nil })
        XCTAssertEqual(page.examples.first?.vietnamese, page.title)
    }

    func testGeneratedBreakdownTokensExposePlayableAudioKeys() throws {
        try skipRetiredGeneratedJSONCatalog()

        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-airport-baggage"))
        let breakdown = try XCTUnwrap(page.sections.first { $0.id == "breakdown" }?.breakdown)

        XCTAssertEqual(breakdown.map(\.vietnamese), [
            "Lấy",
            "hành lý",
            "ở đâu?",
            "Lấy hành lý ở đâu?",
        ])

        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        for token in breakdown {
            let audioKey = try XCTUnwrap(token.playbackAudioKey, token.vietnamese)
            XCTAssertEqual(manifest.entry(for: audioKey)?.text, token.vietnamese)
            XCTAssertNotNil(manifest.url(for: audioKey), token.vietnamese)
        }
    }

    func testBreakdownSeparatorsUsePlusUntilFinalEquals() {
        XCTAssertEqual(
            (0..<3).compactMap { BreakdownView.separator(afterTokenAt: $0, tokenCount: 4) },
            ["+", "+", "="]
        )

        XCTAssertEqual(
            (0..<2).compactMap { BreakdownView.separator(afterTokenAt: $0, tokenCount: 3) },
            ["+", "="]
        )
    }

    func testGeneratedBreakdownSplitsNumbersIntoTheirOwnCards() throws {
        try skipRetiredGeneratedJSONCatalog()

        let gatePage = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-v500-airp-bord-arri-where-is-gate-10"))
        let gateBreakdown = try XCTUnwrap(gatePage.sections.first { $0.id == "breakdown" }?.breakdown)

        XCTAssertEqual(gateBreakdown.map(\.vietnamese), [
            "Cổng",
            "10",
            "ở đâu?",
            "Cổng 10 ở đâu?",
        ])

        let ticketPage = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-v500-time-date-book-two-tickets-please"))
        let ticketBreakdown = try XCTUnwrap(ticketPage.sections.first { $0.id == "breakdown" }?.breakdown)

        XCTAssertTrue(ticketBreakdown.contains { $0.vietnamese == "hai" && $0.english == "two" })
        XCTAssertTrue(ticketBreakdown.contains { $0.vietnamese == "vé" && $0.english == "ticket" })
    }

    func testGeneratedVisaBreakdownUsesRealMeanings() throws {
        try skipRetiredGeneratedJSONCatalog()

        let visaPage = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-v500-airp-bord-arri-here-is-my-visa"))
        let breakdownSection = try XCTUnwrap(visaPage.sections.first { $0.id == "breakdown" })
        let breakdown = breakdownSection.breakdown

        XCTAssertEqual(breakdown.map(\.vietnamese), [
            "Đây",
            "là",
            "thị thực",
            "của tôi",
            "Đây là thị thực của tôi",
        ])
        XCTAssertEqual(breakdown.map(\.english), [
            "here / this",
            "is",
            "visa",
            "my / mine",
            "Here is my visa",
        ])
        XCTAssertEqual(
            breakdownSection.body,
            "Use this when you are showing a document or item. The phrase points to it, names it, then marks it as yours."
        )

        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        for audioKey in breakdown.compactMap(\.playbackAudioKey) {
            XCTAssertNotNil(manifest.entry(for: audioKey), audioKey)
            XCTAssertNotNil(manifest.url(for: audioKey), audioKey)
        }
    }

    func testGeneratedQuestionBreakdownUsesSmallTeachingPieces() throws {
        try skipRetiredGeneratedJSONCatalog()

        let quietRoomPage = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-hotel-quiet-room"))
        let breakdown = try XCTUnwrap(quietRoomPage.sections.first { $0.id == "breakdown" }?.breakdown)

        XCTAssertEqual(breakdown.map(\.vietnamese), [
            "Cho tôi",
            "phòng",
            "yên tĩnh",
            "được không?",
            "Cho tôi phòng yên tĩnh được không?",
        ])
        XCTAssertEqual(breakdown.map(\.english), [
            "can I have",
            "room",
            "quiet",
            "is it possible?",
            "Can I have a quiet room?",
        ])
    }

    func testGeneratedBreakdownReusesExistingAudioForSharedTokens() throws {
        try skipRetiredGeneratedJSONCatalog()

        let checkoutPage = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-family-hotel-checkout-time"))
        let breakdown = try XCTUnwrap(checkoutPage.sections.first { $0.id == "breakdown" }?.breakdown)
        let manifest = try XCTUnwrap(AudioAssetManifest.main)

        let sharedTokens = breakdown.dropLast()
        XCTAssertEqual(sharedTokens.map(\.vietnamese), ["Mấy", "giờ", "trả phòng"])

        for token in sharedTokens {
            let playbackAudioKey = try XCTUnwrap(token.playbackAudioKey, token.vietnamese)
            XCTAssertNotNil(manifest.url(for: playbackAudioKey), token.vietnamese)
            XCTAssertEqual(manifest.entry(for: playbackAudioKey)?.text, token.vietnamese)
        }
    }

    func testGeneratedBreakdownAvoidsOversizedNonFinalCards() throws {
        try skipRetiredGeneratedJSONCatalog()

        let catalog = try XCTUnwrap(GeneratedVietContent.catalog)

        for family in catalog.families {
            let primaryPhrase = catalog.phrase(withID: family.primaryPhraseID)
            let pageID = GeneratedVietContent.canonicalPageID(for: family, primaryPhrase: primaryPhrase)
            guard pageID == family.pageID else {
                continue
            }

            let page = try XCTUnwrap(PhraseDetailPage.page(withID: pageID), pageID)
            let breakdown = try XCTUnwrap(page.sections.first { $0.id == "breakdown" }?.breakdown, pageID)
            let nonFinalTokens = breakdown.dropLast()

            XCTAssertTrue(nonFinalTokens.allSatisfy { token in
                token.vietnamese.split(separator: " ").count <= 3
            }, pageID)
            XCTAssertTrue(nonFinalTokens.allSatisfy { token in
                token.vietnamese.count <= 24
            }, pageID)
        }
    }

    func testGeneratedBreakdownLabelsDoNotUsePlaceholderCopy() throws {
        try skipRetiredGeneratedJSONCatalog()

        let catalog = try XCTUnwrap(GeneratedVietContent.catalog)
        let forbiddenLabels = Set(["key word", "phrase ending", "word", "action", "place / service"])

        for family in catalog.families {
            let primaryPhrase = catalog.phrase(withID: family.primaryPhraseID)
            let pageID = GeneratedVietContent.canonicalPageID(for: family, primaryPhrase: primaryPhrase)
            guard pageID == family.pageID else {
                continue
            }

            let page = try XCTUnwrap(PhraseDetailPage.page(withID: pageID), pageID)
            let labels = page.sections.flatMap(\.breakdown).map { $0.english.lowercased() }
            XCTAssertTrue(labels.allSatisfy { !forbiddenLabels.contains($0) }, pageID)
        }
    }

    func testGeneratedListingPagesDoNotExposeAuthoringPlaceholderCopy() throws {
        try skipRetiredGeneratedJSONCatalog()

        let catalog = try XCTUnwrap(GeneratedVietContent.catalog)
        let forbiddenSnippets = [
            "placeholder",
            "will appear",
            "main phrase for the situation",
            "related versions",
            "key word",
            "phrase ending",
            "coming soon",
            "todo",
            "tbd",
        ]

        for family in catalog.families {
            let primaryPhrase = catalog.phrase(withID: family.primaryPhraseID)
            let pageID = GeneratedVietContent.canonicalPageID(for: family, primaryPhrase: primaryPhrase)
            guard pageID == family.pageID else {
                continue
            }

            let page = try XCTUnwrap(PhraseDetailPage.page(withID: pageID), pageID)
            let visibleCopy = generatedVisibleCopy(for: page).joined(separator: " ").lowercased()

            XCTAssertTrue(
                forbiddenSnippets.allSatisfy { !visibleCopy.contains($0) },
                pageID
            )
        }
    }

    private func generatedVisibleCopy(for page: PhraseDetailPage) -> [String] {
        let sectionCopy = page.sections.flatMap { section in
            [section.title, section.body]
                + section.phrases.flatMap { [$0.vietnamese, $0.english, $0.pronunciation] }
                + section.breakdown.flatMap { [$0.vietnamese, $0.english] }
        }

        let exampleCopy = page.examples.flatMap { [$0.vietnamese, $0.english, $0.pronunciation] }

        return [page.title, page.englishTitle, page.pronunciation, page.summary] + sectionCopy + exampleCopy
    }

    private func articleTemplate(forTierOnePageID pageID: String) throws -> PhraseArticlePage {
        if pageID == PhrasePage.xinChao.id {
            return PhrasePage.xinChao.articleTemplate
        }

        return try XCTUnwrap(PhraseDetailPage.page(withID: pageID), pageID).articleTemplate
    }

    private func authoredAudioAudit() throws -> [String: Any] {
        let url = try XCTUnwrap(Bundle.main.url(
            forResource: "viet-authored-audio-audit",
            withExtension: "json"
        ))
        let data = try Data(contentsOf: url)
        let object = try JSONSerialization.jsonObject(with: data)

        return try XCTUnwrap(object as? [String: Any])
    }

    func testSearchIndexCanOpenGeneratedPhraseFamilies() throws {
        enableSQLiteRuntimeForTesting()

        let results = PhraseSearchIndex.search("where is the ATM")
        let result = try XCTUnwrap(results.first { $0.pageID == "viet-phrase-v500-airp-bord-arri-where-is-the-atm" })

        XCTAssertEqual(result.title, "ATM ở đâu?")
        XCTAssertEqual(result.subtitle, "Where is the ATM?")
        XCTAssertNotNil(PhraseDetailPage.page(withID: result.pageID))
    }

	func testSearchIndexFindsPassportRecoveryWhenQuerySaysForgotPassport() {
		enableSQLiteRuntimeForTesting()

		let results = PhraseSearchIndex.search("I forgot my passport")
		let topPageIDs = Array(results.prefix(5).map(\.pageID))
		let topThreeText = Self.normalizedSearchAssertionText(Array(results.prefix(3)))

		XCTAssertTrue(
			topPageIDs.contains("viet-phrase-emergency-3"),
			"Expected forgot-passport search to surface I lost my passport near the top, got \(topPageIDs)"
		)
		XCTAssertTrue(
			topThreeText.contains("lost") || topThreeText.contains("missing") || topThreeText.contains("report"),
			"Expected forgot-passport search top rows to prioritize recovery help, got \(results.prefix(3).map { "\($0.title) / \($0.subtitle)" })"
		)
		XCTAssertTrue(
			topPageIDs.contains("viet-phrase-v500-emer-safe-my-passport-is-missing")
				|| topPageIDs.contains("viet-phrase-v500-emer-safe-i-do-not-have-my-passport"),
			"Expected forgot-passport search to include another passport recovery phrase, got \(topPageIDs)"
		)
	}

	func testSearchIndexDoesNotPromoteDefaultPhraseResultsForPureGibberish() {
		enableSQLiteRuntimeForTesting()

		XCTAssertTrue(PhraseSearchIndex.search("zzzzzz", limit: 20).isEmpty)
		XCTAssertTrue(BrowseSearchDestinations.searchResults(for: "zzzzzz", limit: 20).isEmpty)
	}

    func testSearchIndexFindsNaturalIntentAliases() {
        enableSQLiteRuntimeForTesting()

        let cases: [(query: String, expectedPageIDs: Set<String>)] = [
            (
                "I misplaced my passport",
                [
                    "viet-phrase-emergency-3",
                    "viet-phrase-v500-emer-safe-my-passport-is-missing",
                    "viet-phrase-v500-emer-safe-i-do-not-have-my-passport",
                ]
            ),
            (
                "where is my passport",
                [
                    "viet-phrase-emergency-3",
                    "viet-phrase-v500-emer-safe-my-passport-is-missing",
                    "viet-phrase-v500-emer-safe-i-do-not-have-my-passport",
                ]
            ),
            (
                "pass port missing",
                [
                    "viet-phrase-emergency-3",
                    "viet-phrase-v500-emer-safe-my-passport-is-missing",
                    "viet-phrase-v500-emer-safe-i-do-not-have-my-passport",
                ]
            ),
            (
                "where can I get a new passport",
                [
                    "viet-phrase-emergency-3",
                    "viet-phrase-v500-emer-safe-my-passport-is-missing",
                    "viet-phrase-v500-emer-safe-i-do-not-have-my-passport",
                    "viet-phrase-emergency-premium-passport-report",
                ]
            ),
            (
                "no peanuts",
                [
                    "viet-phrase-food-peanut-allergy",
                    "viet-phrase-food-premium-has-peanuts",
                    "viet-phrase-v500-food-drin-does-this-contain-peanuts",
                ]
            ),
            (
                "does this have peanuts",
                [
                    "viet-phrase-food-premium-has-peanuts",
                    "viet-phrase-v500-food-drin-does-this-contain-peanuts",
                ]
            ),
            (
                "toilet",
                [
                    "viet-phrase-bath-1",
                    "viet-phrase-bathroom-use",
                    "viet-phrase-v500-dire-navi-where-is-the-nearest-restroom",
                ]
            ),
            (
                "driver can't find me",
                [
                    "viet-phrase-v900-phon-inte-powe-the-app-says-my-driver-is-here-but-i-cant-find-t",
                    "viet-phrase-v500-airp-bord-arri-i-cannot-find-my-driver",
                    "viet-phrase-v500-tran-please-call-the-driver",
                    "viet-phrase-directions-8",
                ]
            ),
            (
                "hotel reservation",
                [
                    "viet-phrase-hotel-1",
                    "viet-phrase-time-4",
                    "viet-phrase-v500-hote-acco-i-booked-online",
                ]
            ),
            (
                "speak slower",
                [
                    "viet-phrase-problems-3",
                    "viet-phrase-repair-slower-polite",
                ]
            ),
            (
                "nearest hospital",
                [
                    "viet-phrase-emergency-hospital",
                    "viet-phrase-v500-heal-phar-i-need-a-hospital",
                    "viet-phrase-v900-emer-safe-please-take-me-to-the-hospital",
                ]
            ),
        ]

        for testCase in cases {
            let topPageIDs = Array(PhraseSearchIndex.search(testCase.query).prefix(5).map(\.pageID))
            XCTAssertFalse(topPageIDs.isEmpty, "Expected results for \(testCase.query)")
            XCTAssertTrue(
                topPageIDs.contains { testCase.expectedPageIDs.contains($0) },
                "Expected \(testCase.query) to surface one of \(testCase.expectedPageIDs), got \(topPageIDs)"
            )
        }
    }

    func testSearchIndexSalvagesKnownTokensFromNoisyQueries() {
        enableSQLiteRuntimeForTesting()

        let cases: [(query: String, expectedTerms: [String])] = [
            ("heksn shsgs kwodh tickets", ["ticket", "tickets", "vé"]),
            ("asdf bridge random", ["bridge", "cầu"]),
            ("blah blah passport words", ["passport", "hộ chiếu"]),
            ("nonsense hello qqq", ["hello", "chào"]),
        ]

        for testCase in cases {
            let results = Array(PhraseSearchIndex.search(testCase.query).prefix(8))
            let combinedResultText = Self.normalizedSearchAssertionText(results)
            let browseSearchRows = BrowseSearchDestinations.searchResults(for: testCase.query, limit: 8)
            let combinedBrowseText = Self.normalizedSearchAssertionText(browseSearchRows)

            XCTAssertFalse(results.isEmpty, "Expected loose results for \(testCase.query)")
            XCTAssertTrue(
                testCase.expectedTerms.contains { term in
                    combinedResultText.contains(Self.normalizedSearchAssertionText(term))
                },
                "Expected \(testCase.query) to salvage one of \(testCase.expectedTerms), got \(results.map { "\($0.title) / \($0.subtitle)" })"
            )
            XCTAssertFalse(browseSearchRows.isEmpty, "Expected search UI rows for \(testCase.query)")
            XCTAssertTrue(
                testCase.expectedTerms.contains { term in
                    combinedBrowseText.contains(Self.normalizedSearchAssertionText(term))
                },
                "Expected Browse search for \(testCase.query) to surface one of \(testCase.expectedTerms), got \(browseSearchRows.map { "\($0.title) / \($0.subtitle)" })"
            )
        }
    }

    func testSearchIndexNeverDeadEndsForMessyRealWorldQueries() {
        enableSQLiteRuntimeForTesting()

        let cases: [(query: String, expectedVisibleTerms: [String], topLimit: Int)] = [
            ("heksn shsgs kwodh tickets", ["ticket", "tickets", "vé"], 20),
            ("random words tickets", ["ticket", "tickets", "vé"], 20),
            ("refund ticket please", ["refund", "ticket", "tickets", "vé", "hoàn"], 20),
            ("where passport", ["passport", "hộ chiếu"], 20),
            ("where can i get a new passport", ["passport", "hộ chiếu"], 20),
            ("blah blah passport words", ["passport", "hộ chiếu"], 20),
            ("driver cant find me", ["driver", "tài xế", "pickup", "đón"], 20),
            ("grab driver cannot find me", ["driver", "tài xế", "pickup", "đón"], 20),
            ("taxi pickup air random", ["taxi", "driver", "pickup", "đón", "airport", "sân bay"], 20),
            ("black coffee", ["black coffee", "coffee", "cà phê"], 20),
            ("order black coffee", ["black coffee", "coffee", "cà phê"], 20),
            ("salt coffee", ["salt coffee", "coffee", "cà phê", "muối"], 20),
            ("dragon bridge", ["dragon bridge", "cầu rồng", "bridge", "cầu"], 20),
            ("where is dragon bridge", ["dragon bridge", "cầu rồng", "bridge", "cầu"], 20),
            ("asdf bridge random", ["bridge", "cầu"], 20),
            ("no peanuts", ["peanut", "peanuts", "đậu phộng"], 20),
            ("does this have pork", ["pork", "thịt heo"], 20),
            ("peanut allergy", ["peanut", "peanuts", "đậu phộng", "allergy"], 20),
            ("bathroom", ["bathroom", "toilet", "restroom", "nhà vệ sinh"], 20),
            ("toilet please", ["bathroom", "toilet", "restroom", "nhà vệ sinh"], 20),
            ("sim card airport", ["sim", "airport", "sân bay"], 20),
            ("wifi not working", ["wi-fi", "wifi", "working", "hoạt động"], 20),
            ("hotel reservation", ["reservation", "booking", "đặt phòng"], 20),
            ("check in hotel", ["check-in", "check in", "hotel", "đặt phòng"], 20),
            ("table restaurant", ["table", "bàn", "restaurant"], 20),
            ("nonsense hello qqq", ["hello", "chào"], 20),
        ]

        for testCase in cases {
            XCTContext.runActivity(named: testCase.query) { _ in
                let rawResults = PhraseSearchIndex.search(testCase.query, limit: 100)
                let browseRows = BrowseSearchDestinations.searchResults(for: testCase.query, limit: 100)

                XCTAssertFalse(rawResults.isEmpty, "Expected raw search results for \(testCase.query)")
                XCTAssertFalse(browseRows.isEmpty, "Expected visible search rows for \(testCase.query)")

                let visibleTopText = Self.normalizedSearchAssertionText(Array(browseRows.prefix(testCase.topLimit)))
                XCTAssertTrue(
                    testCase.expectedVisibleTerms.contains { term in
                        visibleTopText.contains(Self.normalizedSearchAssertionText(term))
                    },
                    "Expected visible top \(testCase.topLimit) rows for \(testCase.query) to include one of \(testCase.expectedVisibleTerms), got \(browseRows.prefix(testCase.topLimit).map { "\($0.title) / \($0.subtitle)" })"
                )
            }
        }
    }

    func testBrowseSearchPrioritizesExactVietnameseMenuDrinkMatch() throws {
        enableSQLiteRuntimeForTesting()

        let expectedPageID = "viet-menu-drink-ca-phe-sua-da"
        let expectedMenuItem = try XCTUnwrap(VietnameseMenuCatalog.detailItem(withPageID: expectedPageID))
        let expectedAudioKey = try XCTUnwrap(VietnameseMenuCatalog.phraseItem(for: expectedMenuItem).audioKey)
        let exactResults = BrowseSearchDestinations.searchResults(for: "Cà phê sữa đá", limit: 8)
        let foldedResults = BrowseSearchDestinations.searchResults(for: "ca phe sua da", limit: 8)

        XCTAssertEqual(
            exactResults.first?.pageID,
            expectedPageID,
            "Exact Vietnamese drink searches should open the generated menu drink page before cafe/place rows: \(exactResults.map { "\($0.pageID): \($0.title) / \($0.subtitle)" })"
        )
        XCTAssertEqual(exactResults.first?.title, "Cà phê sữa đá")
        XCTAssertEqual(exactResults.first?.audioKey, expectedAudioKey)
        XCTAssertEqual(
            foldedResults.first?.pageID,
            expectedPageID,
            "Tone-free drink searches should also rank the generated menu drink page first: \(foldedResults.map { "\($0.pageID): \($0.title) / \($0.subtitle)" })"
        )
    }

    func testSearchIndexRanksActionSpecificMatchesAheadOfSharedNounNoise() {
        enableSQLiteRuntimeForTesting()

        let cases: [(query: String, expectedTopTerms: [String])] = [
            ("I lost my wallet", ["wallet", "ví"]),
            ("where can i charge phone", ["charge", "charger", "sạc"]),
            ("grab pickup da nang airport", ["pickup", "driver", "đón", "taxi", "grab"]),
            ("restaurant reservation", ["restaurant", "table", "bàn", "reservation"]),
        ]

        for testCase in cases {
            XCTContext.runActivity(named: testCase.query) { _ in
                let topText = Self.normalizedSearchAssertionText(
                    Array(PhraseSearchIndex.search(testCase.query, limit: 100).prefix(5))
                )
                XCTAssertTrue(
                    testCase.expectedTopTerms.contains { topText.contains(Self.normalizedSearchAssertionText($0)) },
                    "Expected top rows for \(testCase.query) to include \(testCase.expectedTopTerms), got \(topText)"
                )
            }
        }
    }

    func testBrowseSearchReturnsScrollableResultSetsForBroadQueries() {
        enableSQLiteRuntimeForTesting()

        let cases: [(query: String, minimumCount: Int)] = [
            ("hello", 12),
            ("hotel", 12),
            ("ticket", 12),
            ("passport", 8),
            ("coffee", 8),
            ("bridge", 8),
        ]

        for testCase in cases {
            let results = BrowseSearchDestinations.searchResults(for: testCase.query, limit: 100)

            XCTAssertGreaterThanOrEqual(
                results.count,
                testCase.minimumCount,
                "\(testCase.query) should expose a scrollable set of phrase results, got \(results.count): \(results.map { "\($0.title) / \($0.subtitle)" })"
            )
            XCTAssertLessThanOrEqual(results.count, 100)
        }
    }

    func testBrowseSearchCanReturnMoreThanFirstScreenOfPhraseResults() {
        enableSQLiteRuntimeForTesting()

        let results = BrowseSearchDestinations.searchResults(for: "hello", limit: 100)

        XCTAssertGreaterThanOrEqual(
            results.count,
            12,
            "Search should expose a scrollable set of phrase results, not just the first few rows: \(results.map { "\($0.title) / \($0.subtitle)" })"
        )
        XCTAssertLessThanOrEqual(results.count, 100)
    }

    func testSearchIndexKeepsGeneratedDuplicatesOnCanonicalDesignedPages() {
        let xinLoiResults = PhraseSearchIndex.search("Xin lỗi").filter { $0.title == "Xin lỗi" }
        let camOnResults = PhraseSearchIndex.search("Cảm ơn").filter { $0.title == "Cảm ơn" }

        XCTAssertEqual(xinLoiResults.map(\.pageID), ["viet-excuse-sorry"])
        XCTAssertEqual(camOnResults.map(\.pageID), ["viet-thank-you"])
    }

    func testExploreCatalogIncludesGeneratedCategoriesAndFamilies() throws {
        try skipRetiredGeneratedJSONCatalog()

        let categoryIDs = Set(PhraseCatalog.categories.map(\.id))
        let airportItems = PhraseCatalog.items(selectedCategoryID: "airport-border-arrival")

        XCTAssertTrue(categoryIDs.contains("airport-border-arrival"))
        XCTAssertTrue(airportItems.contains { $0.pageID == "viet-family-airport-immigration" })
        XCTAssertTrue(airportItems.allSatisfy { $0.categoryIDs.contains("airport-border-arrival") })
        XCTAssertTrue(PhraseCatalog.isOpenablePageID("viet-family-airport-immigration"))
    }

    func testExploreCatalogItemsExposePlayableOrPlannedCityAudio() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        let missingAudioItems = PhraseCatalog.allItems.compactMap { item -> String? in
            if item.categoryIDs.contains("city-guides") {
                return item.playbackAudioKey == nil ? nil : "\(item.pageID): planned city audio should not expose a playable key"
            }
            guard let audioKey = item.playbackAudioKey, manifest.url(for: audioKey) != nil else {
                return "\(item.pageID): \(item.title)"
            }

            return nil
        }

        XCTAssertTrue(missingAudioItems.isEmpty, missingAudioItems.joined(separator: "\n"))
    }

    func testAudioManifestResolvesBundledPhraseAudio() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        let entry = try XCTUnwrap(manifest.entry(for: "airport-1"))

        XCTAssertEqual(entry.fileName, "airport-1.mp3")
        XCTAssertEqual(entry.text, "Nhập cảnh ở đâu?")
        XCTAssertNotNil(manifest.url(for: "airport-1"))
    }

    func testDesignedPhraseAudioFallbackReusesExactTextAudio() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        let politeHello = try XCTUnwrap(PhrasePage.xinChao.quickSay.first { $0.id == "polite-1" })
        let casualHello = try XCTUnwrap(PhrasePage.xinChao.quickSay.first { $0.id == "polite-5" })

        XCTAssertEqual(politeHello.playbackAudioKey, "polite-1")
        let casualAudioKey = try XCTUnwrap(casualHello.playbackAudioKey)
        XCTAssertNotNil(manifest.url(for: casualAudioKey))
        XCTAssertEqual(manifest.entry(for: casualAudioKey)?.text, "Chào")
    }

    func testXinChaoRowsReuseAvailableExactAudio() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        let options = PhrasePage.xinChao.quickSay
            + PhrasePage.xinChao.localGreetings
            + PhrasePage.xinChao.followUps
        let expectedPlayableTexts = [
            "Xin chào",
            "Chào",
            "Chào anh",
            "Chào chị",
            "Chào em",
            "Chào ông",
            "Chào bà",
            "Chào chú",
            "Chào cô",
            "Bạn khỏe không?",
        ]

        for expectedText in expectedPlayableTexts {
            let option = try XCTUnwrap(options.first { $0.vietnamese == expectedText }, expectedText)
            let audioKey = try XCTUnwrap(option.playbackAudioKey, expectedText)

            XCTAssertNotNil(manifest.url(for: audioKey), expectedText)
            XCTAssertEqual(manifest.entry(for: audioKey)?.text, expectedText)
        }
    }

    func testSpeakerButtonOnlyTreatsBundledAudioAsPlayable() {
        XCTAssertTrue(AudioSpeakerButton.isPlayableAudioKey("polite-1"))
        XCTAssertFalse(AudioSpeakerButton.isPlayableAudioKey(nil))
        XCTAssertFalse(AudioSpeakerButton.isPlayableAudioKey("missing-audio-key"))
    }

    func testSpeakerButtonKeepsReliableMinimumTapTarget() {
        XCTAssertGreaterThanOrEqual(AudioSpeakerButton.minimumHitSize, 44)
        XCTAssertEqual(AudioSpeakerButton.tapTargetSize(for: 30), AudioSpeakerButton.minimumHitSize)
        XCTAssertEqual(AudioSpeakerButton.tapTargetSize(for: 48), 48)
    }

    func testBreakdownAudioReliabilityExamplesResolvePlayableAudio() throws {
        enableSQLiteRuntimeForTesting()
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        let examples: [(pageID: String, tokenText: String, expectedAudioKey: String?)] = [
            ("viet-family-food-coffee-black", "cho", "breakdown-taxi-1-first"),
            ("viet-family-food-coffee-black", "tôi", "breakdown-v500-heal-phar-i-feel-dizzy-first"),
            ("viet-phrase-hotel-quiet-room", "cho", nil),
        ]

        for example in examples {
            let page = try XCTUnwrap(PhraseDetailPage.page(withID: example.pageID), example.pageID)
            let token = try XCTUnwrap(
                page.sections.flatMap(\.breakdown).first { $0.vietnamese == example.tokenText },
                "\(example.pageID): \(example.tokenText)"
            )
            let playbackAudioKey = try XCTUnwrap(token.playbackAudioKey, "\(example.pageID): \(example.tokenText)")

            if let expectedAudioKey = example.expectedAudioKey {
                XCTAssertEqual(playbackAudioKey, expectedAudioKey)
            }
            XCTAssertNotNil(manifest.url(for: playbackAudioKey), "\(example.pageID): \(example.tokenText)")
            XCTAssertTrue(
                manifest.hasPlayableEntry(for: playbackAudioKey, matchingText: example.tokenText),
                "\(example.pageID): \(example.tokenText)"
            )
        }

        let xinChaoToken = try XCTUnwrap(PhrasePage.xinChao.breakdown.first { $0.vietnamese == "Xin" })
        let xinChaoAudioKey = try XCTUnwrap(xinChaoToken.playbackAudioKey)
        XCTAssertNotNil(manifest.url(for: xinChaoAudioKey))
        XCTAssertTrue(manifest.hasPlayableEntry(for: xinChaoAudioKey, matchingText: "Xin"))
    }

    func testSQLiteCanonicalPageIDLookupsAreCached() throws {
        enableSQLiteRuntimeForTesting()

        XCTAssertEqual(VietSQLitePhraseGraphRuntime.cachedCanonicalPageIDCountForTesting, 0)
        XCTAssertEqual(VietSQLitePhraseGraphRuntime.canonicalPageID(for: "viet-thank-you"), "viet-phrase-polite-2")
        XCTAssertEqual(VietSQLitePhraseGraphRuntime.canonicalPageID(for: "viet-thank-you"), "viet-phrase-polite-2")
        XCTAssertEqual(VietSQLitePhraseGraphRuntime.cachedCanonicalPageIDCountForTesting, 1)
    }

    func testAudioPlaybackServiceConfiguresSessionBeforeFirstPlayback() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        var events: [String] = []
        var createdPlayer: RecordingAudioPlayer?

        let service = AudioPlaybackService(
            manifest: manifest,
            configureAudioSession: {
                events.append("session")
            },
            makePlayer: { _ in
                events.append("make-player")
                let player = RecordingAudioPlayer { event in
                    events.append(event)
                }
                createdPlayer = player
                return player
            }
        )

        XCTAssertTrue(service.play(audioKey: "polite-1", rate: 0.75))
        XCTAssertEqual(events, ["session", "make-player", "prepare", "play"])
        XCTAssertEqual(createdPlayer?.enableRate, true)
        XCTAssertEqual(createdPlayer?.rate ?? 0, 0.75, accuracy: 0.001)

        events.removeAll()

        XCTAssertTrue(service.play(audioKey: "polite-1"))
        XCTAssertEqual(events, ["stop", "make-player", "prepare", "play"])
    }

    func testAudioPlaybackServiceReusesPlayerForRepeatedSameClipTaps() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        var makePlayerCount = 0
        var playCount = 0

        let service = AudioPlaybackService(
            manifest: manifest,
            configureAudioSession: {},
            makePlayer: { _ in
                makePlayerCount += 1
                return RecordingAudioPlayer { event in
                    if event == "play" {
                        playCount += 1
                    }
                }
            }
        )

        for _ in 0..<10 {
            XCTAssertTrue(service.play(audioKey: "polite-1"))
        }

        XCTAssertEqual(makePlayerCount, 1)
        XCTAssertEqual(playCount, 10)
    }

    func testAudioPlaybackServiceDoesNotCacheFailedFirstStart() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        var events: [String] = []
        var players: [RecordingAudioPlayer] = []

        let service = AudioPlaybackService(
            manifest: manifest,
            configureAudioSession: {},
            makePlayer: { _ in
                events.append("make-player")
                let player = RecordingAudioPlayer { event in
                    events.append(event)
                }
                player.playResult = players.isEmpty ? false : true
                players.append(player)
                return player
            }
        )

        XCTAssertFalse(service.play(audioKey: "polite-1"))
        XCTAssertTrue(service.play(audioKey: "polite-1"))
        XCTAssertEqual(players.count, 2)
        XCTAssertEqual(events, ["make-player", "prepare", "play", "make-player", "prepare", "play"])
    }

    func testAudioPlaybackServiceClearsCachedPlayerAfterFailedReplayPrepare() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        var events: [String] = []
        var players: [RecordingAudioPlayer] = []

        let service = AudioPlaybackService(
            manifest: manifest,
            configureAudioSession: {},
            makePlayer: { _ in
                events.append("make-player")
                let player = RecordingAudioPlayer { event in
                    events.append(event)
                }
                players.append(player)
                return player
            }
        )

        XCTAssertTrue(service.play(audioKey: "polite-1"))
        players[0].prepareResult = false
        XCTAssertFalse(service.play(audioKey: "polite-1"))
        XCTAssertTrue(service.play(audioKey: "polite-1"))
        XCTAssertEqual(players.count, 2)
        XCTAssertEqual(events, [
            "make-player", "prepare", "play",
            "stop", "seek-0", "prepare",
            "make-player", "prepare", "play",
        ])
    }

    func testAllResolvedPhraseOptionAudioKeysPointToBundledFiles() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        let rootOptions = PhrasePage.xinChao.quickSay
            + PhrasePage.xinChao.situationalGreetings
            + PhrasePage.xinChao.localGreetings
            + PhrasePage.xinChao.followUps
        var optionsByContext = rootOptions.map { ("\(PhrasePage.xinChao.id): \($0.vietnamese)", $0) }

        for item in PhraseCatalog.allItems {
            guard let page = PhraseDetailPage.page(withID: item.pageID) else {
                continue
            }

            optionsByContext += page.examples.map { ("\(page.id): \($0.vietnamese)", $0) }
            optionsByContext += page.sections.flatMap { section in
                section.phrases.map { ("\(page.id) / \(section.id): \($0.vietnamese)", $0) }
            }
        }

        for (context, option) in optionsByContext {
            if let audioKey = option.playbackAudioKey {
                XCTAssertNotNil(manifest.url(for: audioKey), context)
            }
        }
    }

    func testAllPhraseOptionsResolvePlayableAudio() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        let rootOptions = PhrasePage.xinChao.quickSay
            + PhrasePage.xinChao.situationalGreetings
            + PhrasePage.xinChao.localGreetings
            + PhrasePage.xinChao.followUps
        var optionsByContext = rootOptions.map { ("\(PhrasePage.xinChao.id): \($0.vietnamese)", $0) }

        for item in PhraseCatalog.allItems {
            guard let page = PhraseDetailPage.page(withID: item.pageID) else {
                continue
            }

            optionsByContext += page.examples.map { ("\(page.id): \($0.vietnamese)", $0) }
            optionsByContext += page.sections.flatMap { section in
                section.phrases.map { ("\(page.id) / \(section.id): \($0.vietnamese)", $0) }
            }
        }

        let missingContexts = optionsByContext.compactMap { context, option -> String? in
            if context.hasPrefix("viet-family-city-"), option.playbackAudioKey == nil {
                return nil
            }

            guard let audioKey = option.playbackAudioKey, manifest.url(for: audioKey) != nil else {
                return context
            }

            return nil
        }

        XCTAssertTrue(missingContexts.isEmpty, missingContexts.joined(separator: "\n"))
    }

    private static func normalizedSearchAssertionText(_ results: [PhraseSearchResult]) -> String {
        normalizedSearchAssertionText(
            results
                .flatMap { [$0.title, $0.subtitle] }
                .joined(separator: " ")
        )
    }

    private static func normalizedSearchAssertionText(_ results: [BrowseSearchPhraseItem]) -> String {
        normalizedSearchAssertionText(
            results
                .flatMap { [$0.title, $0.subtitle] }
                .joined(separator: " ")
        )
    }

    private static func normalizedSearchAssertionText(_ text: String) -> String {
        text
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
    }
}

private final class RecordingAudioPlayer: AudioPlayable {
    var enableRate = false
    var rate: Float = 1.0
    var prepareResult = true
    var playResult = true
    var currentTime: TimeInterval = 0 {
        didSet {
            record("seek-\(Int(currentTime))")
        }
    }

    private let record: (String) -> Void

    init(record: @escaping (String) -> Void) {
        self.record = record
    }

    func prepareToPlay() -> Bool {
        record("prepare")
        return prepareResult
    }

    func stop() {
        record("stop")
    }

    func play() -> Bool {
        record("play")
        return playResult
    }
}
