import StoreKit
import SwiftUI

enum SubscriptionLegalLinks {
    static let terms = URL(string: "https://speaklocal.app/terms/")!
    static let privacy = URL(string: "https://speaklocal.app/privacy/")!
    static let support = URL(string: "https://speaklocal.app/feedback/")!
}

enum SubscriptionOfferCopy {
    static let detailsLine = "Subscription options, trial eligibility, and billing details are shown by the App Store before purchase. Manage or cancel in App Store subscriptions."
}

enum SubscriptionPaywallAvailabilityCopy {
    static func unavailableMessage(
        productsAreEmpty: Bool,
        entitlementStatus: SubscriptionEntitlementStatus
    ) -> String? {
        guard productsAreEmpty else {
            return nil
        }

        switch entitlementStatus {
        case .loading, .active:
            return nil
        case .inactive, .failed:
            return "Subscription options are unavailable right now. Check your App Store connection and try again, or contact support."
        }
    }
}

struct SubscriptionPaywallView: View {
    @ObservedObject var store: SubscriptionStore

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    header
                        .padding(.horizontal, 24)
                        .padding(.top, 0)

                    if let unavailableMessage {
                        SubscriptionPaywallNotice(message: unavailableMessage)
                            .padding(.horizontal, 24)
                    }

                    SubscriptionStoreView(productIDs: [SubscriptionProduct.monthlyProductID])
                        .subscriptionStoreButtonLabel(.multiline)
                        .storeButton(.visible, for: .restorePurchases)
                        .onInAppPurchaseCompletion { _, _ in
                            await store.refresh()
                        }
                        .frame(maxWidth: .infinity, minHeight: 180)
                }
                .padding(.bottom, 20)
            }

            footer
                .background(.bar)
        }
        .accessibilityIdentifier("SubscriptionPaywallView")
    }

    private var unavailableMessage: String? {
        SubscriptionPaywallAvailabilityCopy.unavailableMessage(
            productsAreEmpty: store.products.isEmpty,
            entitlementStatus: store.entitlementStatus
        )
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Keep the full Vietnam companion for your trip")
                .font(.largeTitle.bold())
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Explore food, places, useful phrases, saved trip moments, Practice, and playable Vietnamese audio for planning and traveling in Vietnam.")
                .font(.headline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            VStack(alignment: .leading, spacing: 10) {
                SubscriptionPaywallBenefitRow(title: "Food, coffee, places, and phrase pages", subtitle: "Curated for common Vietnam travel moments, not classroom drills.")
                SubscriptionPaywallBenefitRow(title: "Playable Vietnamese audio", subtitle: "Hear supported phrases before you speak.")
                SubscriptionPaywallBenefitRow(title: "Search, Browse, Save, and Practice", subtitle: "Keep the moments you will actually use close at hand.")
            }

            Text("View subscription options")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
        }
    }

    private var footer: some View {
        VStack(spacing: 12) {
            Text(SubscriptionOfferCopy.detailsLine)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

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

                Link("Support", destination: SubscriptionLegalLinks.support)
                Link("Terms", destination: SubscriptionLegalLinks.terms)
                Link("Privacy", destination: SubscriptionLegalLinks.privacy)
            }
            .font(.footnote.weight(.semibold))
        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 26)
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

private struct SubscriptionPaywallNotice: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
