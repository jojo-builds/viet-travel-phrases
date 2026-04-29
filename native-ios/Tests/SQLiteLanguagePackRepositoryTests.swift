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

        XCTAssertNotNil(GeneratedVietContent.catalog)
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
        XCTAssertEqual(coverage.missingAudioAuditRows, 0)
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
        XCTAssertEqual(page.summary, "Hello (universal greeting)")
        XCTAssertEqual(page.sections.map(\.id), [
            "at-glance",
            "quick-say",
            "breakdown",
            "relationship-words",
            "situational-greetings",
            "local-greetings",
            "common-follow-ups",
            "cultural-note",
            "explore-next",
        ])
        XCTAssertEqual(page.sections.first { $0.id == "cultural-note" }?.presentation, .tipCallout)
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

    func testSQLiteCanonicalPagesShowFullRelationshipWordShelf() throws {
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

        for item in PhraseCatalog.allItems {
            let page = try repository.loadPhraseDetailPage(pageID: item.pageID)
            let section = try XCTUnwrap(page.sections.first { $0.id == "relationship-words" }, item.pageID)

            XCTAssertEqual(section.title, "Relationship words", item.pageID)
            XCTAssertEqual(section.presentation, .relationshipShelf, item.pageID)
            XCTAssertEqual(section.phrases.map(\.vietnamese), expectedVietnamese, item.pageID)
            XCTAssertTrue(section.phrases.allSatisfy { phrase in
                phrase.detailPageID?.hasPrefix("viet-phrase-") == true
            }, item.pageID)
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
        XCTAssertEqual(snapshot.scenarioCategories.count, 18)
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
    }

    struct Validation: Decodable {
        let integrityCheck: String
    }
}
#endif
