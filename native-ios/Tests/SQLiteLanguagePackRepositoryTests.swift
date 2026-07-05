import XCTest
@testable import SpeakLocalNative

#if DEBUG
final class SQLiteLanguagePackRepositoryTests: XCTestCase {
    private var suiteName: String?
    private var defaults: UserDefaults?

    override func tearDown() {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()

        if let suiteName {
            defaults?.removePersistentDomain(forName: suiteName)
        }
        defaults = nil
        suiteName = nil

        super.tearDown()
    }

    func testBundledVietSQLiteFixtureIsFindableReadOnlyAndHealthy() throws {
        let url = try XCTUnwrap(VietSQLiteLanguagePackRepository.bundledDatabaseURL())

        XCTAssertTrue(url.path.contains("LanguagePacks/viet/speaklocal-viet.sqlite"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))

        let repository = try VietSQLiteLanguagePackRepository.bundled()

        XCTAssertTrue(repository.isReadOnly)
        XCTAssertEqual(try repository.integrityCheck(), "ok")
    }

    func testVietRuntimeDoesNotBundleLegacyJSONFallbackResources() {
        XCTAssertNotNil(VietSQLiteLanguagePackRepository.bundledDatabaseURL())
        XCTAssertNil(Bundle.main.url(forResource: "viet-phrase-catalog", withExtension: "json"))
        XCTAssertNil(Bundle.main.url(forResource: "viet-authored-listing-pages", withExtension: "json"))
        XCTAssertNil(Bundle.main.url(forResource: "viet-authored-audio-audit", withExtension: "json"))
        XCTAssertNil(Bundle.main.url(forResource: "vietnamese-menu-copy", withExtension: "json"))
    }

    func testSQLiteSanityCountsMatchGeneratedReport() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let snapshot = try repository.loadSanitySnapshot()
        let report = try loadBundledReport()

        XCTAssertEqual(report.bundlePackaging.isIncludedInXcodeResources, true)
        XCTAssertEqual(report.bundlePackaging.status, "bundle-ready")
        XCTAssertEqual(report.validation.integrityCheck, "ok")

        XCTAssertEqual(snapshot.languagePackID, "viet")
        XCTAssertEqual(snapshot.integrityCheck, "ok")
        XCTAssertEqual(snapshot.counts.scenarios, report.generatedCounts.scenarios)
        XCTAssertEqual(snapshot.counts.clusters, report.generatedCounts.clusters)
        XCTAssertEqual(snapshot.counts.phrases, report.generatedCounts.phrases)
        XCTAssertEqual(snapshot.counts.pages, report.generatedCounts.pages)
        XCTAssertEqual(snapshot.counts.aliases, report.generatedCounts.aliases)
        XCTAssertEqual(snapshot.counts.searchDocuments, report.generatedCounts.searchDocuments)
    }

    func testSQLiteIncludesCityAndVietnameseMenuRuntimeSurfaces() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let report = try loadBundledReport()
        let menuPayload = try repository.loadVietnameseMenuPayload()
        let phoBo = try XCTUnwrap(menuPayload.items.first { $0.itemID == "food-pho-bo" })

        XCTAssertEqual(report.validation.cityCount, 5)
        XCTAssertGreaterThan(report.validation.cityPlaceCount, 0)
        XCTAssertGreaterThan(report.validation.cityTagCount, 0)
        XCTAssertEqual(menuPayload.items.count, report.generatedCounts.vietnameseMenuItems)
        XCTAssertEqual(menuPayload.helperPhrases?.count, report.generatedCounts.vietnameseMenuHelperPhrases)
        XCTAssertEqual(phoBo.vietnameseItem, "Phở bò")
        XCTAssertEqual(phoBo.englishTranslation, "Beef noodle soup")
        XCTAssertTrue(phoBo.usuallyIncludes.contains("beef broth"))
        XCTAssertTrue(phoBo.helperPhraseIDs?.contains("menu-not-spicy") == true)
    }

    func testSQLiteBackdropsGiveNeedsBackdropPhrasePagesPhotoBackdropLayout() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let expectations = [
            ("viet-phrase-polite-1", "BackdropPhraseHelpQuietServiceDesk"),
            ("viet-phrase-taxi-1", "BackdropPhraseTransportAirportCurb"),
            ("viet-phrase-problems-6", "BackdropPhraseHelpHotelDesk"),
            ("viet-phrase-airport-1", "BackdropPhrasePhoneAirportCharging"),
            ("viet-phrase-bath-1", "BackdropPhraseEssentialsWaterCounter"),
            ("viet-phrase-sight-1", "BackdropPhraseSightTicketBooth"),
            ("viet-phrase-phone-1", "BackdropPhrasePhoneCafeCharging"),
            ("viet-phrase-food-menu", "BackdropPhraseFoodOrderCounter"),
            ("viet-phrase-price-1", "BackdropPhraseMarketPayment"),
            ("viet-phrase-hotel-1", "BackdropPhraseHelpHotelDesk"),
        ]

        for (pageID, expectedHeroImageName) in expectations {
            let page = try repository.loadPhraseDetailPage(pageID: pageID)

            XCTAssertEqual(page.heroImageName, expectedHeroImageName, pageID)
            XCTAssertTrue(
                PhrasePhotoBackdropLayout.supportsListingPage(pageID: page.id, heroImageName: page.heroImageName),
                "\(pageID) should use the shared photo-backdrop sheet interaction"
            )
        }

        XCTAssertGreaterThanOrEqual(
            PhrasePhotoBackdropLayout.backdropVerticalFocusOffset(
                for: CGSize(width: 393, height: 852),
                pageID: "viet-phrase-phone-1",
                heroImageName: "BackdropPhrasePhoneSimSetup"
            ),
            180,
            "low tabletop phrase photos should shift the subject band into the visible resting area"
        )
        XCTAssertEqual(
            PhrasePhotoBackdropLayout.backdropVerticalFocusOffset(
                for: CGSize(width: 393, height: 852),
                pageID: "viet-phrase-airport-1",
                heroImageName: "HeroCategoryAirport"
            ),
            0,
            "existing category mastheads keep their original crop"
        )
    }

    func testStaticDesignedPhrasePagesUsePhotoBackdropLayout() throws {
        let staticDetailPagesByID = Dictionary(uniqueKeysWithValues: PhraseDetailPage.all.map { ($0.id, $0) })
        let expectations = [
            (PhrasePage.xinChao.articleTemplate, "BackdropPhraseGreetingCafeDoorway"),
            (try XCTUnwrap(staticDetailPagesByID["viet-respectful-hello"]).articleTemplate, "BackdropPhraseGreetingCafeDoorway"),
            (try XCTUnwrap(staticDetailPagesByID["viet-phone-hello"]).articleTemplate, "BackdropPhrasePhoneCafeCharging"),
            (try XCTUnwrap(staticDetailPagesByID["viet-thank-you"]).articleTemplate, "BackdropPhraseHelpQuietServiceDesk"),
        ]

        for (page, expectedHeroImageName) in expectations {
            XCTAssertEqual(page.heroImageName, expectedHeroImageName, page.id)
            XCTAssertTrue(
                PhrasePhotoBackdropLayout.supportsListingPage(pageID: page.id, heroImageName: page.heroImageName),
                "\(page.id) should use the shared photo-backdrop sheet interaction"
            )
        }
    }

    func testRuntimeHeroImageLookupDoesNotLoadFullDetailPage() throws {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()
        defer { VietSQLitePhraseGraphRuntime.resetTestingOverrides() }

        XCTAssertEqual(
            VietSQLitePhraseGraphRuntime.heroImageName(for: "viet-phrase-phone-1"),
            "BackdropPhrasePhoneCafeCharging"
        )
        XCTAssertEqual(VietSQLitePhraseGraphRuntime.cachedDetailPageCountForTesting, 0)
    }

    func testRuntimeDetailPageLoadReusesCatalogCanonicalSeedForKnownPageID() throws {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()
        VietSQLiteLanguagePackRepository.resetCanonicalPageIDLookupCountForTesting()
        defer {
            VietSQLitePhraseGraphRuntime.resetTestingOverrides()
            VietSQLiteLanguagePackRepository.resetCanonicalPageIDLookupCountForTesting()
        }

        XCTAssertTrue(PhraseCatalog.allItems.contains { $0.pageID == "viet-phrase-phone-1" })
        XCTAssertEqual(PhraseCatalog.canonicalPageID(forOpenablePageID: "viet-phrase-phone-1"), "viet-phrase-phone-1")
        VietSQLiteLanguagePackRepository.resetCanonicalPageIDLookupCountForTesting()

        let page = try XCTUnwrap(VietSQLitePhraseGraphRuntime.detailPage(withID: "viet-phrase-phone-1"))

        XCTAssertEqual(page.id, "viet-phrase-phone-1")
        XCTAssertEqual(
            VietSQLiteLanguagePackRepository.canonicalPageIDLookupCountForTesting,
            0,
            "Catalog/Home/Browse already know canonical listing page IDs, so the detail loader should reuse that seed instead of spending one SQL alias lookup per rapid new-page open."
        )
    }

    func testRuntimeDetailPageLoadCanonicalizesAliasOnlyOncePerNewPage() throws {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()
        VietSQLiteLanguagePackRepository.resetCanonicalPageIDLookupCountForTesting()
        defer {
            VietSQLitePhraseGraphRuntime.resetTestingOverrides()
            VietSQLiteLanguagePackRepository.resetCanonicalPageIDLookupCountForTesting()
        }

        let page = try XCTUnwrap(VietSQLitePhraseGraphRuntime.detailPage(withID: "viet-family-phone-wifi-password"))

        XCTAssertEqual(page.id, "viet-phrase-phone-1")
        XCTAssertEqual(
            VietSQLiteLanguagePackRepository.canonicalPageIDLookupCountForTesting,
            1,
            "Alias listing page IDs still need one SQL alias lookup before loading the canonical page."
        )
    }

    func testRuntimeDetailPageLoadBatchesSectionItemQueriesPerNewPage() throws {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()
        VietSQLiteLanguagePackRepository.resetPreparedStatementCountForTesting()
        defer {
            VietSQLitePhraseGraphRuntime.resetTestingOverrides()
            VietSQLiteLanguagePackRepository.resetPreparedStatementCountForTesting()
        }

        let page = try XCTUnwrap(VietSQLitePhraseGraphRuntime.detailPage(withID: "viet-phrase-phone-1"))

        XCTAssertFalse(page.sections.isEmpty)
        XCTAssertLessThanOrEqual(
            VietSQLiteLanguagePackRepository.preparedStatementCountForTesting,
            5,
            "Opening a new SQLite-backed listing page should batch section phrase/breakdown item loading instead of preparing one phrase query and one breakdown query per section."
        )
    }

    func testDefaultRuntimeLoadsVietnameseMenuFromSQLiteWithoutJSONBundle() throws {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()

        let report = try loadBundledReport()

        XCTAssertNil(Bundle.main.url(forResource: "vietnamese-menu-copy", withExtension: "json"))
        XCTAssertEqual(VietnameseMenuCatalog.allItems.count, report.generatedCounts.vietnameseMenuItems)
        XCTAssertEqual(VietnameseMenuCatalog.helperPhrases.count, report.generatedCounts.vietnameseMenuHelperPhrases)
        XCTAssertEqual(VietnameseMenuCatalog.detailPage(withID: "viet-menu-food-pho-bo")?.title, "Phở bò")
    }

    func testSQLitePreviewMapsRepresentativePhraseTowardExistingAppConcepts() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let snapshot = try repository.loadSanitySnapshot(previewPhraseID: "polite-1")
        let preview = snapshot.preview

        XCTAssertEqual(preview.phraseID, "polite-1")
        XCTAssertEqual(preview.pageID, "viet-phrase-polite-1")
        XCTAssertEqual(preview.title, "Xin chào")
        XCTAssertEqual(preview.englishTitle, "Hello")
        XCTAssertEqual(preview.pronunciation, "sin chow")
        XCTAssertEqual(preview.accessTier, "starter")

        XCTAssertEqual(preview.catalogItem.pageID, preview.pageID)
        XCTAssertEqual(preview.catalogItem.title, preview.title)
        XCTAssertEqual(preview.catalogItem.subtitle, preview.englishTitle)
        XCTAssertEqual(preview.searchResult.pageID, preview.pageID)
        XCTAssertEqual(preview.searchResult.title, preview.title)

        XCTAssertEqual(PhrasePage.xinChao.title, "Xin chào")
    }

    func testPhraseRowsDoNotNavigateToCurrentCanonicalPage() {
        XCTAssertNil(PhraseRowNavigation.destinationPageID(
            for: "viet-phrase-directions-2",
            currentPageID: "viet-phrase-directions-2"
        ))
        XCTAssertNil(PhraseRowNavigation.destinationPageID(
            for: "viet-polite-hello",
            currentPageID: "viet-phrase-polite-1"
        ))
        XCTAssertEqual(
            PhraseRowNavigation.destinationPageID(
                for: "viet-phrase-polite-2",
                currentPageID: "viet-phrase-polite-1"
            ),
            "viet-phrase-polite-2"
        )
    }

    func testSQLiteCoverageProvesEverySourcePhraseResolvesToCanonicalPage() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let coverage = try repository.loadGraphCoverage()
        let report = try loadBundledReport()

        XCTAssertEqual(coverage.sourcePhraseRows, report.generatedCounts.phrases)
        XCTAssertEqual(coverage.canonicalPhrasePages, report.generatedCounts.pages)
        XCTAssertEqual(coverage.resolvedPhraseRows, coverage.sourcePhraseRows)
        XCTAssertEqual(coverage.searchDocuments, coverage.sourcePhraseRows)
        XCTAssertEqual(coverage.duplicateCanonicalPageGroups, 0)
        XCTAssertEqual(coverage.brokenRelationEdges, 0)
        XCTAssertEqual(coverage.searchDocumentsWithMissingPageTargets, 0)
        XCTAssertEqual(coverage.audioUsageMismatches, 0)
        XCTAssertEqual(coverage.missingAudioAuditRows, report.audio.missingAudioAuditRows)
        XCTAssertEqual(report.audio.plannedMissingAudioAuditRows, report.audio.missingAudioAuditRows)
        XCTAssertEqual(report.audio.releaseBlockingMissingAudioAuditRows, 0)
    }

    func testSQLiteCityPagesUsePremiumHeroImages() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let cityHeroNames = try repository.loadCityPageHeroImageNames()
        let report = try loadBundledReport()
        let retiredHeroNames = Set([
            "HeroHanMarket",
            "HeroLinhUngPagoda",
            "HeroMarbleMountains",
            "HeroMyKheBeach",
            "HeroNguyenVanLinhStreet",
        ])
        let allowedSharedHeroNames = Set([
            "HeroCompactPhraseMasthead",
            "HeroCityDanang",
            "HeroCityHanoi",
            "HeroCityHcmc",
            "HeroCityHoian",
            "HeroCityHue",
            "HeroDragonBridge",
            "HeroBaNaHills",
        ])

        XCTAssertEqual(cityHeroNames.count, report.validation.cityPrefixedPageCount)
        XCTAssertEqual(cityHeroNames["city-hcmc-place-anan-saigon"], "HeroCityHcmcPlaceAnanSaigon")
        XCTAssertEqual(cityHeroNames["city-hcmc-where-anan-saigon"], "HeroCompactPhraseMasthead")
        XCTAssertEqual(cityHeroNames["city-danang-go-ba-na-hills"], "HeroCompactPhraseMasthead")
        XCTAssertEqual(cityHeroNames["city-danang-where-ba-na-hills"], "HeroCompactPhraseMasthead")

        let invalidHeroRows = cityHeroNames.filter { _, heroName in
            let isCityPlaceHero = heroName.range(
                of: "^HeroCity[A-Za-z]+Place[A-Za-z0-9]+$",
                options: .regularExpression
            ) != nil

            return heroName.isEmpty
                || retiredHeroNames.contains(heroName)
                || (!allowedSharedHeroNames.contains(heroName) && !isCityPlaceHero)
        }

        XCTAssertTrue(
            invalidHeroRows.isEmpty,
            "City pages should use compact, city-level, or asset-backed place hero images only: \(invalidHeroRows)"
        )
    }

    func testSQLiteCanonicalLookupResolvesAliasesAndDuplicatePhraseRows() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()

        XCTAssertEqual(try repository.canonicalPageID(forPageIDOrAlias: "viet-excuse-sorry"), "viet-phrase-polite-5")
        XCTAssertEqual(try repository.canonicalPageID(forPageIDOrAlias: "viet-polite-hello"), "viet-phrase-polite-1")
        XCTAssertEqual(try repository.canonicalPageID(forPageIDOrAlias: "viet-family-polite-hello"), "viet-phrase-polite-1")
        XCTAssertEqual(try repository.canonicalPageID(forPageIDOrAlias: "viet-hello-anh"), "viet-phrase-hello-chao-anh")
        XCTAssertEqual(try repository.canonicalPageID(forPageIDOrAlias: "viet-hello-chi"), "viet-phrase-hello-chao-chi")
        XCTAssertEqual(try repository.canonicalPageID(forPageIDOrAlias: "viet-phone-hello"), "viet-phrase-hello-alo")
        XCTAssertEqual(try repository.canonicalPageID(forPageIDOrAlias: "viet-where-going"), "viet-phrase-smalltalk-di-dau-day")
        XCTAssertEqual(try repository.canonicalPageID(forPageIDOrAlias: "viet-nice-to-meet-you"), "viet-phrase-smalltalk-nice-to-meet-you")
        XCTAssertEqual(try repository.canonicalPageID(forPageIDOrAlias: "viet-hello-anh-way-respectful"), "viet-phrase-acknowledge-da-chao-anh")
        XCTAssertEqual(try repository.canonicalPageID(forPhraseID: "v500-poli-basi-excuse-me"), "viet-phrase-polite-5")
        XCTAssertEqual(try repository.canonicalPageID(forPhraseID: "polite-5"), "viet-phrase-polite-5")
        XCTAssertTrue(try repository.canOpenPage(pageIDOrAlias: "viet-phrase-polite-5"))
    }

    func testSQLiteLoadsDatabaseBackedArticleSections() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()

        let page = try repository.loadPhraseDetailPage(pageID: "viet-phrase-polite-1")
        XCTAssertEqual(page.id, "viet-phrase-polite-1")
        XCTAssertEqual(page.title, "Xin chào")
        XCTAssertEqual(page.englishTitle, "Hello")
        XCTAssertEqual(page.summary, "A safe first hello for shops, hotels, tours, and any moment where the relationship word is not obvious yet.")
        XCTAssertEqual(page.sections.map(\.id), [
            "at-glance",
            "breakdown",
            "good-to-know",
            "relationship-words",
            "explore-next",
        ])
        XCTAssertEqual(page.sections.first { $0.id == "good-to-know" }?.presentation, .tipCallout)
        XCTAssertEqual(page.sections.first { $0.id == "breakdown" }?.breakdown.map(\.vietnamese), [
            "Xin",
            "chào",
            "Xin chào",
        ])
        XCTAssertTrue(page.sections.contains { section in
            section.phrases.contains { $0.detailPageID == "viet-phrase-polite-2" }
        })
        XCTAssertTrue(page.showsCatalogExplore)
    }

    func testSQLiteCanonicalPagesShowCatalogExploreShelf() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()

        for item in PhraseCatalog.allItems {
            let page = try repository.loadPhraseDetailPage(pageID: item.pageID)

            XCTAssertTrue(page.showsCatalogExplore, item.pageID)
            let sections = ExploreCatalogSection.sections(forPageID: item.pageID)
            XCTAssertFalse(sections.isEmpty, item.pageID)
            XCTAssertTrue(sections.allSatisfy { section in
                section.items.allSatisfy { $0.pageID != item.pageID }
            }, item.pageID)
        }
    }

    func testSQLiteRelationshipWordShelfIsContextual() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let expectedVietnamese = [
            "Chào anh",
            "Chào chị",
            "Chào em",
            "Chào ông",
            "Chào bà",
            "Chào chú",
            "Chào cô",
        ]

        let pageExpectations: [(pageID: String, phrases: [String])] = [
            ("viet-phrase-polite-1", expectedVietnamese),
            ("viet-phrase-hello-chao", expectedVietnamese),
        ]

        for expectation in pageExpectations {
            let pageID = expectation.pageID
            let page = try repository.loadPhraseDetailPage(pageID: pageID)
            let section = try XCTUnwrap(page.sections.first { $0.id == "relationship-words" }, pageID)

            XCTAssertEqual(section.title, "Relationship words", pageID)
            XCTAssertEqual(section.presentation, .relationshipShelf, pageID)
            XCTAssertEqual(section.phrases.map(\.vietnamese), expectation.phrases, pageID)
            XCTAssertTrue(section.phrases.allSatisfy { phrase in
                phrase.detailPageID?.hasPrefix("viet-phrase-") == true
            }, pageID)
        }

        let chaoAnhPage = try repository.loadPhraseDetailPage(pageID: "viet-phrase-hello-chao-anh")
        let chaoAnhShelf = try XCTUnwrap(chaoAnhPage.sections.first { $0.id == "relationship-words" })
        XCTAssertFalse(chaoAnhShelf.phrases.contains { $0.vietnamese == "Chào anh" })
        XCTAssertEqual(chaoAnhShelf.phrases.map(\.vietnamese), Array(expectedVietnamese.dropFirst()))

        let howAreYouPage = try repository.loadPhraseDetailPage(pageID: "viet-phrase-smalltalk-7")
        XCTAssertFalse(howAreYouPage.sections.contains { $0.id == "relationship-words" })
        let relationshipForms = try XCTUnwrap(howAreYouPage.sections.first { $0.id == "relationship-forms" })
        XCTAssertEqual(relationshipForms.phrases.map(\.vietnamese), [
            "Anh khỏe không?",
            "Chị khỏe không?",
            "Em khỏe không?",
        ])

        let fromUnitedStatesPage = try repository.loadPhraseDetailPage(pageID: "viet-phrase-smalltalk-1")
        XCTAssertFalse(
            fromUnitedStatesPage.sections.contains { $0.id == "relationship-words" },
            "Tôi đến từ Mỹ should not get a greeting relationship shelf"
        )
    }

    func testSQLitePhraseRowsResolveToOpenableCanonicalPages() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()

        let xinChao = try repository.loadPhraseDetailPage(pageID: "viet-phrase-polite-1")
        XCTAssertFalse(xinChao.sections.contains { $0.id == "quick-say" })

        for pageID in ["viet-phrase-hello-chao", "viet-phrase-directions-2", "viet-phrase-health-1"] {
            let page = try repository.loadPhraseDetailPage(pageID: pageID)
            let phraseRows = page.sections.flatMap(\.phrases)

            XCTAssertFalse(phraseRows.isEmpty, pageID)
            for phrase in phraseRows {
                if let detailPageID = phrase.detailPageID {
                    XCTAssertTrue(try repository.canOpenPage(pageIDOrAlias: detailPageID), "\(pageID) -> \(detailPageID)")
                }
            }
        }
    }

    func testSQLiteRelationsAndVisibleAudioKeysResolveFromGraph() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let related = try repository.relatedPages(forPageID: "viet-phrase-polite-1", limit: 6)
        let visibleAudioUsages = try repository.visibleAudioUsages(forPageID: "viet-phrase-polite-1")
        let manifest = try XCTUnwrap(AudioAssetManifest.main)

        XCTAssertFalse(related.isEmpty)
        XCTAssertTrue(related.allSatisfy { $0.detailPageID?.hasPrefix("viet-phrase-") == true })
        XCTAssertTrue(related.contains { $0.detailPageID == "viet-phrase-polite-2" })

        XCTAssertFalse(visibleAudioUsages.isEmpty)
        for usage in visibleAudioUsages {
            XCTAssertTrue(
                manifest.hasPlayableEntry(for: usage.audioKey, matchingText: usage.expectedText),
                "\(usage.targetKind): \(usage.targetID)"
            )
        }
    }

    func testSQLiteRelationLookupUsesSourceIndexForLargerGraphs() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()

        XCTAssertTrue(try repository.hasIndex(named: "idx_phrase_relation_source"))
        XCTAssertTrue(
            try repository.relatedPagesLookupPlan(forPageID: "viet-phrase-polite-1").contains { detail in
                detail.contains("idx_phrase_relation_source")
            }
        )
    }

    func testSQLiteRuntimeIsNormalDefaultWithoutLaunchFlag() throws {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()

        XCTAssertTrue(VietSQLitePhraseGraphRuntime.isEnabled)
        XCTAssertTrue(PhraseSearchIndex.search("hello").allSatisfy { PhraseCatalog.isOpenablePageID($0.pageID) })
        XCTAssertEqual(PhraseDetailPage.page(withID: PhrasePage.xinChao.id)?.id, "viet-phrase-polite-1")
    }

    func testSQLiteCatalogSnapshotBacksDefaultHomeAndBrowseSurfaces() throws {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()

        let snapshot = try XCTUnwrap(VietSQLitePhraseGraphRuntime.catalogSnapshot())
        let report = try loadBundledReport()
        let xinChaoItem = try XCTUnwrap(snapshot.catalogItems.first { $0.pageID == "viet-phrase-polite-1" })
        let politeBasicsItems = PhraseCatalog.items(selectedCategoryID: "polite-basics")

        XCTAssertEqual(snapshot.catalogItems.count, report.generatedCounts.pages)
        XCTAssertEqual(snapshot.scenarioCategories.count, report.generatedCounts.scenarios)
        XCTAssertNotNil(snapshot.scenarioCategories.first { $0.id == "city-guides" })
        XCTAssertEqual(xinChaoItem.title, "Xin chào")
        XCTAssertEqual(xinChaoItem.subtitle, "Hello")
        XCTAssertEqual(PhraseCatalog.category(withID: "polite-basics")?.title, "Polite Basics")
        XCTAssertEqual(PhraseCatalog.defaultCategoryID(forPageID: PhrasePage.xinChao.id), "greetings")
        XCTAssertTrue(politeBasicsItems.contains { $0.pageID == "viet-phrase-polite-1" })
        XCTAssertFalse(PhraseCatalog.allItems.contains { $0.pageID == PhrasePage.xinChao.id })
    }

    func testDefaultRuntimeCanonicalizesLegacyHomeIDsIntoSQLiteCatalogPages() throws {
        VietSQLitePhraseGraphRuntime.resetTestingOverrides()

        XCTAssertEqual(PhraseCatalog.canonicalPageID(forOpenablePageID: "viet-thank-you"), "viet-phrase-polite-2")
        XCTAssertEqual(PhraseCatalog.canonicalPageID(forOpenablePageID: "viet-family-repair-understand"), "viet-phrase-problems-2")
        XCTAssertEqual(PhraseCatalog.canonicalPageID(forOpenablePageID: "viet-family-bathroom-where"), "viet-phrase-bath-1")
        XCTAssertEqual(PhraseCatalog.canonicalPageID(forOpenablePageID: "viet-family-health-doctor"), "viet-phrase-problems-6")
        XCTAssertTrue(PhraseCatalog.allItems.contains { $0.pageID == "viet-phrase-problems-2" })
    }

    func testSQLiteRuntimeDrivesSearchDetailRelatedAndHistoryRoute() throws {
        VietSQLitePhraseGraphRuntime.setEnabledForTesting(true)

        let searchResult = try XCTUnwrap(PhraseSearchIndex.search("hello").first)
        XCTAssertTrue(PhraseCatalog.isOpenablePageID(searchResult.pageID))

        let page = try XCTUnwrap(PhraseDetailPage.page(withID: "viet-phrase-polite-1"))
        let relatedPageID = try XCTUnwrap(page.sections.flatMap(\.phrases).first { phrase in
            phrase.detailPageID == "viet-phrase-polite-2"
        }?.detailPageID)

        var navigation = AppShellNavigationState()
        navigation.openSearch()
        navigation.openDetail(page.id)
        navigation.openDetail(relatedPageID)

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-polite-2"))

        navigation.goBack()
        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-polite-1"))
        XCTAssertEqual(navigation.forwardPreviewRoute, .detailPage("viet-phrase-polite-2"))

        navigation.goForward()
        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-polite-2"))
        XCTAssertTrue(navigation.forwardStack.isEmpty)

        var rootNavigation = AppShellNavigationState()
        rootNavigation.openDetail(PhrasePage.xinChao.id)
        XCTAssertEqual(rootNavigation.currentRoute, .detailPage("viet-phrase-polite-1"))
    }

    func testSQLiteAliasesAreStoredAsCanonicalIDsForLocalState() throws {
        VietSQLitePhraseGraphRuntime.setEnabledForTesting(true)
        let defaults = makeIsolatedDefaults()
        let encoder = JSONEncoder()
        let aliasRecentPages = [
            RecentPhrasePage(pageID: "viet-excuse-sorry", openedAt: Date(timeIntervalSince1970: 2), source: .search),
            RecentPhrasePage(pageID: "viet-phrase-polite-5", openedAt: Date(timeIntervalSince1970: 1), source: .article),
        ]
        defaults.set(try encoder.encode(aliasRecentPages), forKey: "SpeakLocal.LocalIntent.recentPages.v1")
        defaults.set(try encoder.encode(["viet-excuse-sorry"]), forKey: "SpeakLocal.LocalIntent.savedPageIDs.v1")
        defaults.set(try encoder.encode(["viet-excuse-sorry"]), forKey: "SpeakLocal.LocalIntent.practicePageIDs.v1")

        let store = LocalUserIntentStore(defaults: defaults)

        XCTAssertEqual(store.recentPageIDs, ["viet-phrase-polite-5"])
        XCTAssertEqual(store.savedPageIDs, ["viet-phrase-polite-5"])
        XCTAssertEqual(store.practicePageIDs, ["viet-phrase-polite-5"])
        XCTAssertTrue(store.isPageSaved("viet-excuse-sorry"))
        XCTAssertTrue(store.isPageInPractice("viet-excuse-sorry"))

        store.toggleSavedPage("viet-phrase-polite-5")
        store.togglePracticePage("viet-phrase-polite-5")

        XCTAssertTrue(store.savedPageIDs.isEmpty)
        XCTAssertTrue(store.practicePageIDs.isEmpty)
    }

    func testSQLiteAuthoredPhraseRowsKeepVisibleAudioKeys() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let page = try repository.loadPhraseDetailPage(pageID: "viet-phrase-smalltalk-7")
        let relationshipForms = try XCTUnwrap(page.sections.first { $0.id == "relationship-forms" })
        let visibleAudioUsages = try repository.visibleAudioUsages(forPageID: page.id)
        let authoredUsages = visibleAudioUsages.filter { $0.targetKind == "authored_phrase" }
        let manifest = try XCTUnwrap(AudioAssetManifest.main)

        XCTAssertEqual(relationshipForms.phrases.map(\.vietnamese), [
            "Anh khỏe không?",
            "Chị khỏe không?",
            "Em khỏe không?",
        ])
        XCTAssertTrue(authoredUsages.allSatisfy { usage in
            manifest.hasPlayableEntry(for: usage.audioKey, matchingText: usage.expectedText)
        })

        let visibleAudioTexts = Set(visibleAudioUsages.map(\.expectedText))
        for phrase in relationshipForms.phrases {
            XCTAssertTrue(visibleAudioTexts.contains(phrase.vietnamese), phrase.vietnamese)
            let audioKey = try XCTUnwrap(phrase.playbackAudioKey, phrase.vietnamese)
            XCTAssertTrue(
                manifest.hasPlayableEntry(for: audioKey, matchingText: phrase.vietnamese),
                phrase.vietnamese
            )
        }

        for usage in authoredUsages {
            XCTAssertTrue(
                manifest.hasPlayableEntry(for: usage.audioKey, matchingText: usage.expectedText),
                "\(usage.targetKind): \(usage.targetID)"
            )
        }
    }

    private func loadBundledReport() throws -> VietSQLiteFixtureReport {
        let url = try XCTUnwrap(Bundle.main.url(
            forResource: "speaklocal-viet-report",
            withExtension: "json",
            subdirectory: VietSQLiteLanguagePackRepository.databaseSubdirectory
        ))
        let data = try Data(contentsOf: url)

        return try JSONDecoder().decode(VietSQLiteFixtureReport.self, from: data)
    }

    private func makeIsolatedDefaults() -> UserDefaults {
        let suiteName = "SQLiteLanguagePackRepositoryTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        self.suiteName = suiteName
        self.defaults = defaults
        return defaults
    }
}

private struct VietSQLiteFixtureReport: Decodable {
    let bundlePackaging: BundlePackaging
    let generatedCounts: GeneratedCounts
    let validation: Validation
    let audio: Audio

    struct BundlePackaging: Decodable {
        let isIncludedInXcodeResources: Bool
        let status: String
    }

    struct GeneratedCounts: Decodable {
        let scenarios: Int
        let clusters: Int
        let phrases: Int
        let pages: Int
        let aliases: Int
        let searchDocuments: Int
        let vietnameseMenuHelperPhrases: Int
        let vietnameseMenuItems: Int
    }

    struct Validation: Decodable {
        let integrityCheck: String
        let cityCount: Int
        let cityLibraryPageCount: Int
        let cityPrefixedPageCount: Int
        let cityPlaceCount: Int
        let cityTagCount: Int
    }

    struct Audio: Decodable {
        let missingAudioAuditRows: Int
        let plannedMissingAudioAuditRows: Int
        let releaseBlockingMissingAudioAuditRows: Int
    }
}
#endif
