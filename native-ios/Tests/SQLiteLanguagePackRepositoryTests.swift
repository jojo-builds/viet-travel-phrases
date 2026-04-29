import XCTest
@testable import SpeakLocalNative

#if DEBUG
final class SQLiteLanguagePackRepositoryTests: XCTestCase {
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

    func testSQLiteCoverageProvesEverySourcePhraseResolvesToCanonicalPage() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let coverage = try repository.loadGraphCoverage()

        XCTAssertEqual(coverage.sourcePhraseRows, 919)
        XCTAssertEqual(coverage.canonicalPhrasePages, 911)
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
        XCTAssertEqual(try repository.canonicalPageID(forPhraseID: "v500-poli-basi-excuse-me"), "viet-phrase-polite-5")
        XCTAssertEqual(try repository.canonicalPageID(forPhraseID: "polite-5"), "viet-phrase-polite-5")
        XCTAssertTrue(try repository.canOpenPage(pageIDOrAlias: "viet-phrase-polite-5"))
    }

    func testSQLiteSearchOpensDatabaseBackedArticleSections() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let result = try XCTUnwrap(try repository.search("hello", limit: 5).first)

        XCTAssertEqual(result.pageID, "viet-phrase-polite-1")
        XCTAssertEqual(result.title, "Xin chào")

        let page = try repository.loadPhraseDetailPage(pageID: result.pageID)
        XCTAssertEqual(page.id, "viet-phrase-polite-1")
        XCTAssertEqual(page.title, "Xin chào")
        XCTAssertEqual(page.englishTitle, "Hello")
        XCTAssertEqual(page.sections.map(\.id), [
            "quick-say",
            "when-to-use",
            "good-to-know",
            "nearby-phrases",
        ])
        XCTAssertEqual(page.sections.first { $0.id == "good-to-know" }?.presentation, .tipCallout)
        XCTAssertTrue(page.sections.contains { section in
            section.phrases.contains { $0.detailPageID == "viet-phrase-polite-2" }
        })
        XCTAssertFalse(page.showsCatalogExplore)
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
        XCTAssertEqual(Set(authoredUsages.map(\.targetID)), [
            "authored:how-are-you-anh",
            "authored:how-are-you-chi",
            "authored:how-are-you-em",
        ])

        for phrase in relationshipForms.phrases {
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
