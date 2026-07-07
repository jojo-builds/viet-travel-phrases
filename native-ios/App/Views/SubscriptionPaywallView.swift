import StoreKit
import SwiftUI

enum SubscriptionLegalLinks {
    static let terms = URL(string: "https://speaklocal.app/terms/")!
    static let privacy = URL(string: "https://speaklocal.app/privacy/")!
    static let support = URL(string: "https://speaklocal.app/feedback/")!
}

enum SubscriptionOfferCopy {
    static let detailsLine = "Try 7 days free, then $4.99/month in the U.S. The App Store confirms eligibility, local pricing, renewal date, and cancellation before purchase."
}

struct SubscriptionPaywallBenefit: Equatable {
    let title: String
    let subtitle: String
    let symbolName: String
}

struct SubscriptionPaywallPreviewExample: Equatable {
    let title: String
    let vietnamese: String
    let english: String
    let context: String
    let symbolName: String
}

enum SubscriptionPaywallNarrative {
    static let eyebrow = "SpeakLocal Vietnam Full Access"
    static let headline = "Try the full Vietnam companion free for 7 days"
    static let subtitle = "Food, coffee, city and place guides, phrase pages, supported playable audio, Search, Saved, and Practice for one Vietnam trip."
    static let previewExamples = [
        SubscriptionPaywallPreviewExample(
            title: "Coffee order",
            vietnamese: "Cho toi ca phe sua da",
            english: "I would like iced milk coffee.",
            context: "Cafe and street-stall phrases for first-day ordering.",
            symbolName: "cup.and.saucer.fill"
        ),
        SubscriptionPaywallPreviewExample(
            title: "Hoi An place help",
            vietnamese: "Pho co Hoi An o dau?",
            english: "Where is Hoi An Ancient Town?",
            context: "Place-aware prompts for markets, landmarks, hotels, and city days.",
            symbolName: "mappin.and.ellipse"
        ),
        SubscriptionPaywallPreviewExample(
            title: "When you get stuck",
            vietnamese: "Noi cham giup toi duoc khong?",
            english: "Could you speak slowly for me?",
            context: "Repair phrases for moments when the conversation moves too fast.",
            symbolName: "ear.fill"
        ),
    ]
    static let benefits = [
        SubscriptionPaywallBenefit(
            title: "Trip-first food and place guidance",
            subtitle: "Use curated menus, coffee, city, market, landmark, and hotel moments.",
            symbolName: "map.fill"
        ),
        SubscriptionPaywallBenefit(
            title: "Phrase pages with playable audio",
            subtitle: "Hear supported Vietnamese before you speak and save the lines you will actually use.",
            symbolName: "speaker.wave.2.fill"
        ),
        SubscriptionPaywallBenefit(
            title: "Search, Browse, Saved, and Practice",
            subtitle: "Build a small trip phrase set instead of drilling a classroom course.",
            symbolName: "magnifyingglass.circle.fill"
        ),
    ]
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
        ZStack {
            SubscriptionPaywallBackground()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        header
                            .padding(.horizontal, 24)
                            .padding(.top, 4)

                        if let unavailableMessage {
                            SubscriptionPaywallNotice(message: unavailableMessage)
                                .padding(.horizontal, 24)
                        }

                        storeKitSection
                            .padding(.horizontal, 24)

                        previewSection
                            .padding(.horizontal, 24)

                        benefitsSection
                            .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 20)
                }

                footer
                    .background(.ultraThinMaterial)
            }
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
        VStack(alignment: .leading, spacing: 18) {
            Text(SubscriptionPaywallNarrative.eyebrow)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color(red: 0.74, green: 0.08, blue: 0.09))
                .textCase(.uppercase)

            Text(SubscriptionPaywallNarrative.headline)
                .font(.largeTitle.bold())
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text(SubscriptionPaywallNarrative.subtitle)
                .font(.headline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            SubscriptionPaywallOfferCard()
        }
    }

    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(SubscriptionPaywallNarrative.benefits, id: \.title) { benefit in
                SubscriptionPaywallBenefitRow(benefit: benefit)
            }
        }
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Preview real trip moments")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text("A few examples of the kind of offline help the full companion unlocks.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            ForEach(SubscriptionPaywallNarrative.previewExamples, id: \.title) { example in
                SubscriptionPaywallPreviewRow(example: example)
            }
        }
        .padding(14)
        .nativeGlass(cornerRadius: 22, tint: Color(red: 0.12, green: 0.52, blue: 0.39).opacity(0.10))
    }

    private var storeKitSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Start your 7-day trial")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)

            SubscriptionStoreView(productIDs: [SubscriptionProduct.monthlyProductID])
                .subscriptionStoreButtonLabel(.multiline)
                .storeButton(.visible, for: .restorePurchases)
                .onInAppPurchaseCompletion { _, _ in
                    await store.refresh()
                }
                .frame(maxWidth: .infinity, minHeight: 180)
        }
        .padding(14)
        .nativeGlass(cornerRadius: 26, tint: Color(red: 0.93, green: 0.12, blue: 0.15).opacity(0.12))
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

            footerLinks
                .font(.footnote.weight(.semibold))
        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 26)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var footerLinks: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 18) {
                restoreButton
                Link("Support", destination: SubscriptionLegalLinks.support)
                Link("Terms", destination: SubscriptionLegalLinks.terms)
                Link("Privacy", destination: SubscriptionLegalLinks.privacy)
            }

            VStack(spacing: 10) {
                HStack(spacing: 18) {
                    restoreButton
                    Link("Support", destination: SubscriptionLegalLinks.support)
                }
                HStack(spacing: 18) {
                    Link("Terms", destination: SubscriptionLegalLinks.terms)
                    Link("Privacy", destination: SubscriptionLegalLinks.privacy)
                }
            }
        }
    }

    private var restoreButton: some View {
        Button("Restore") {
            Task {
                await store.restore()
            }
        }
    }
}

private struct SubscriptionPaywallPreviewRow: View {
    let example: SubscriptionPaywallPreviewExample

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: example.symbolName)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color(red: 0.12, green: 0.52, blue: 0.39))
                .frame(width: 28, height: 28)
                .background(Color(red: 0.12, green: 0.52, blue: 0.39).opacity(0.14), in: Circle())
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(example.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(example.vietnamese)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(example.english)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(example.context)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.tertiarySystemBackground).opacity(0.72), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct SubscriptionPaywallBenefitRow: View {
    let benefit: SubscriptionPaywallBenefit

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: benefit.symbolName)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(Color(red: 0.80, green: 0.09, blue: 0.10), in: Circle())
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(benefit.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(benefit.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .nativeGlass(cornerRadius: 18, tint: Color(red: 0.93, green: 0.12, blue: 0.15).opacity(0.10))
    }
}

private struct SubscriptionPaywallOfferCard: View {
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Launch offer")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                Text("7 days free")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text("then $4.99/month")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(Color(red: 0.12, green: 0.52, blue: 0.39))
                .accessibilityHidden(true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .nativeGlass(cornerRadius: 22, tint: Color(red: 0.12, green: 0.52, blue: 0.39).opacity(0.12))
    }
}

private struct SubscriptionPaywallBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.93, blue: 0.88),
                Color(.systemBackground),
                Color(.secondarySystemBackground),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
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
