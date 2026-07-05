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
            hasCachedActiveAccess: subscriptionStore.hasUsableCachedAccess,
            isDebugBypassEnabled: isDebugBypassEnabled
        )

        return SubscriptionAccessDecision.resolve(snapshot)
    }

    private var isDebugBypassEnabled: Bool {
        if hasLaunchArgument("--subscription-bypass") {
            return true
        }

        if hasLaunchArgument("--disable-subscription-ui-test-bypass") {
            return false
        }

        #if DEBUG
        return SubscriptionTestEnvironment.isRunningUITests(launchEnvironment) && !hasAnyForcedSubscriptionState
        #else
        return false
        #endif
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

enum SubscriptionTestEnvironment {
    static func isRunningUITests(_ environment: [String: String]) -> Bool {
        guard hasXCTestEnvironment(environment) else {
            return false
        }

        return !isRunningHostedUnitTests(environment)
    }

    private static func hasXCTestEnvironment(_ environment: [String: String]) -> Bool {
        environment["XCTestConfigurationFilePath"] != nil ||
            environment["XCInjectBundleInto"] != nil
    }

    private static func isRunningHostedUnitTests(_ environment: [String: String]) -> Bool {
        let testHints = [
            environment["XCTestConfigurationFilePath"],
            environment["XCInjectBundleInto"],
        ].compactMap { $0 }

        return testHints.contains { hint in
            hint.contains("SpeakLocalNativeTests") &&
                !hint.contains("SpeakLocalNativeUITests")
        }
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

                Text("Get a calm first pass at the phrases, food, places, and pronunciation that make Vietnam feel easier before you land.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 14) {
                SubscriptionPlaceholderRow(title: "Hear useful Vietnamese", subtitle: "Practice natural travel phrases with bundled audio.")
                SubscriptionPlaceholderRow(title: "Prepare for real moments", subtitle: "Browse food, transport, hotels, shopping, health, and repair situations.")
                SubscriptionPlaceholderRow(title: "Carry local context", subtitle: "Use curated phrase pages, city/place guidance, search, saved phrases, and Practice offline.")
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
