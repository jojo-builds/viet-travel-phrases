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

            VStack(alignment: .leading, spacing: 10) {
                SubscriptionPaywallBenefitRow(title: "Full Vietnam companion", subtitle: "Unlock the complete curated food, city, place, phrase, audio, search, saved, and Practice library.")
                SubscriptionPaywallBenefitRow(title: "Made for the trip", subtitle: "Keep practical language and local context ready before departure and while traveling.")
                SubscriptionPaywallBenefitRow(title: "Offline by design", subtitle: "No runtime AI calls, no account backend, and no surprise web dependency in this pass.")
            }
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

private struct SubscriptionPaywallBenefitRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
