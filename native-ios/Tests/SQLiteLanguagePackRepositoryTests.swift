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
