import StoreKit
import SwiftUI

struct SubscriptionPaywallView: View {
    @ObservedObject var store: SubscriptionStore

    private let termsURL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
    private let privacyURL = URL(string: "https://www.apple.com/legal/privacy/")!

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
                .padding(.horizontal, 24)
                .padding(.top, 32)

            SubscriptionStoreView(productIDs: [SubscriptionProduct.monthlyProductID])
                .subscriptionStoreButtonLabel(.multiline)
                .storeButton(.visible, for: .restorePurchases)
                .onInAppPurchaseCompletion { _, _ in
                    await store.refresh()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .safeAreaInset(edge: .bottom) {
            footer
                .background(.bar)
        }
        .accessibilityIdentifier("SubscriptionPaywallView")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Start your 7-day free trial")
                .font(.largeTitle.bold())
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Then $4.99/month. Cancel anytime in App Store subscriptions.")
                .font(.headline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text("This placeholder paywall is intentionally simple while the final feature showcase and design direction are still being shaped.")
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var footer: some View {
        VStack(spacing: 12) {
            if let errorMessage = store.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 18) {
                Button("Restore") {
                    Task {
                        await store.restore()
                    }
                }

                Link("Terms", destination: termsURL)
                Link("Privacy", destination: privacyURL)
            }
            .font(.footnote.weight(.semibold))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
    }
}
