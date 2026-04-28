# Gate 2 Pass 1: Canonical ID

Findings: none blocking.

Saved/recent/practice writes go through `LocalUserIntentStore.swift`, which rejects non-openable IDs and stores page IDs only. Home resolves stored IDs back through the shared page graph before rendering/opening them in `HomeView.swift`, and navigation revalidates route IDs in `AppShellView.swift`. The canonical/openable boundary is centralized in `PhrasePage.swift`, with generated families mapped to canonical page IDs in `GeneratedVietContent.swift`.

Validation: `LocalUserIntentStoreTests` passed, 3 tests / 0 failures, via targeted `xcodebuild ... -only-testing:SpeakLocalNativeTests/LocalUserIntentStoreTests test`.

Approval: APPROVE
