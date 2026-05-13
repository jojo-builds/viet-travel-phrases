import SwiftUI

struct AccessGateView: View {
    @StateObject private var subscriptionStore = SubscriptionStore()
    @AppStorage(SubscriptionStorageKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    private let launchArguments: [String]
    private let launchEnvironment: [String: String]

    init(
        launchArguments: [String] = ProcessInfo.processInfo.arguments,
        launchEnvironment: [String: String] = ProcessInfo.processInfo.environment
    ) {
        self.launchArguments = launchArguments
        self.launchEnvironment = launchEnvironment
    }

    var body: some View {
        Group {
            switch destination {
            case .app:
                AppShellView()
            case .onboarding:
                SubscriptionOnboardingView {
                    hasCompletedOnboarding = true
                }
            case .paywall:
                SubscriptionPaywallView(store: subscriptionStore)
            }
        }
        .task {
            applyLaunchResetsIfNeeded()
            await subscriptionStore.start()
        }
    }

    private var destination: SubscriptionGateDestination {
        if hasLaunchArgument("--force-subscription-onboarding") {
            return .onboarding
        }

        if hasLaunchArgument("--force-subscription-paywall") {
            return .paywall
        }

        let snapshot = SubscriptionAccessSnapshot(
            entitlementStatus: subscriptionStore.entitlementStatus,
            hasCompletedOnboarding: hasCompletedOnboarding,
            hasCachedActiveAccess: subscriptionStore.cachedAccess != nil,
            isDebugBypassEnabled: isDebugBypassEnabled
        )

        return SubscriptionAccessDecision.resolve(snapshot)
    }

    private var isDebugBypassEnabled: Bool {
        if hasLaunchArgument("--subscription-bypass") {
            return true
        }

        #if DEBUG
        return isRunningUITests && !hasAnyForcedSubscriptionState
        #else
        return false
        #endif
    }

    private var isRunningUITests: Bool {
        launchEnvironment["XCTestConfigurationFilePath"] != nil ||
            launchEnvironment["XCInjectBundleInto"] != nil
    }

    private var hasAnyForcedSubscriptionState: Bool {
        hasLaunchArgument("--force-subscription-onboarding") ||
            hasLaunchArgument("--force-subscription-paywall")
    }

    private func applyLaunchResetsIfNeeded() {
        if hasLaunchArgument("--reset-subscription-onboarding") {
            hasCompletedOnboarding = false
        }

        if hasLaunchArgument("--clear-subscription-cache") || hasLaunchArgument("--reset-subscription-onboarding") {
            subscriptionStore.clearLocalStateForTesting()
        }
    }

    private func hasLaunchArgument(_ argument: String) -> Bool {
        launchArguments.contains(argument)
    }
}

private struct SubscriptionOnboardingView: View {
    let onContinueToPaywall: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()

            VStack(alignment: .leading, spacing: 12) {
                Text("Try SpeakLocal Vietnam")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)

                Text("A short placeholder intro will eventually show the real traveler workflows, practice loops, and phrase tools.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 14) {
                SubscriptionPlaceholderRow(title: "Offline phrase help", subtitle: "Placeholder for the core travel phrase experience.")
                SubscriptionPlaceholderRow(title: "Practice before the trip", subtitle: "Placeholder for saved phrase and rehearsal flows.")
                SubscriptionPlaceholderRow(title: "Helpful local context", subtitle: "Placeholder for article and listing-page value.")
            }

            Button(action: onContinueToPaywall) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .accessibilityIdentifier("SubscriptionOnboardingView")
    }
}

private struct SubscriptionPlaceholderRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
