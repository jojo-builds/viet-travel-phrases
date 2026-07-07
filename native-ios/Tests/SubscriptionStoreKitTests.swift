import StoreKit
import StoreKitTest
import XCTest
@testable import SpeakLocalNative

@MainActor
final class SubscriptionStoreKitTests: XCTestCase {
    private var session: SKTestSession?
    private var loadedLocalProducts = false

    override func setUpWithError() throws {
        session = try SKTestSession(contentsOf: storeKitConfigurationURL())
    }

    override func tearDownWithError() throws {
        if loadedLocalProducts {
            session?.clearTransactions()
        }
        session = nil
        loadedLocalProducts = false
    }

    func testLocalStoreKitConfigurationLoadsMonthlyTrialProduct() async throws {
        let products = try await loadProductsOrSkip()
        let product = try XCTUnwrap(products.first)

        XCTAssertEqual(products.map(\.id), [SubscriptionProduct.monthlyProductID])
        XCTAssertEqual(product.type, .autoRenewable)
        XCTAssertEqual(product.displayName, "SpeakLocal Vietnam Monthly")
        XCTAssertTrue(product.displayPrice.contains("4.99"), "Expected local U.S. StoreKit price to include 4.99, got \(product.displayPrice)")
        XCTAssertNotNil(product.subscription)
    }

    func testLocalStoreKitPurchaseActivatesSubscriptionStore() async throws {
        _ = try await loadProductsOrSkip()

        let suiteName = "SubscriptionStoreKitTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let store = SubscriptionStore(userDefaults: defaults)
        await store.refresh()

        XCTAssertFalse(store.products.isEmpty)
        XCTAssertEqual(store.entitlementStatus, .inactive)

        session?.disableDialogs = true
        session?.clearTransactions()
        try await session?.buyProduct(identifier: SubscriptionProduct.monthlyProductID)
        await store.refresh()

        XCTAssertEqual(store.entitlementStatus, .active)
        XCTAssertTrue(store.hasUsableCachedAccess)
    }

    private func loadProductsOrSkip() async throws -> [Product] {
        let products = try await Product.products(for: [SubscriptionProduct.monthlyProductID])
        guard !products.isEmpty else {
            throw XCTSkip("Local StoreKit products are unavailable under this xcodebuild/iOS 26.5 simulator run. Keep the static StoreKit config validator as the CLI gate and rerun this test from Xcode IDE, TestFlight, or a fixed simulator runtime.")
        }

        loadedLocalProducts = true
        return products
    }

    private func storeKitConfigurationURL() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Config/StoreKit/SpeakLocalPaywall.storekit")
    }
}
