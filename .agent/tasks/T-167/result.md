# T-167 Result: Native Home V1 And Local User Intent State

## Status

done

## Home V1 Behavior Implemented

- Native app now launches to a real Home route instead of dropping directly onto `PhraseListingView(page: .xinChao)`.
- First-launch Home uses real bundled JSON/catalog data for search, starter phrase cards, travel situations, relationship/social greeting cards, featured authored pages, and Browse entry.
- Returning-user Home shelves are honest: Continue, Saved, and Practice Pool appear only when local state contains resolvable page IDs.
- Bottom chrome now has real Home/Browse/Saved actions, route-selected dock state, a Saved page, and search Home control semantics that return Home.
- Back/forward history remains browser-like, including explicit back-preview routing so hidden root pages do not leak during swipe previews.

## Local User-Intent State Implemented

- Added `LocalUserIntentStore` for device-local `UserDefaults` persistence of:
  - recent canonical page IDs with opened timestamp and source;
  - saved canonical page IDs;
  - practice-pool canonical page IDs.
- Store validates IDs with `PhraseCatalog.isOpenablePageID`, de-dupes recents, caps recents at 12, and ignores unknown IDs.
- Phrase root/detail pages now expose saved and page-level Add/Remove Practice affordances backed by the local store.
- No account, sync, analytics, network personalization, runtime AI, or production SQLite switch was added.

## Files Changed

- `.agent/coordination/queue-index.json`
- `.agent/tasks/T-167/result.md`
- `.agent/tasks/T-167/state.json`
- `.agent/tasks/T-167/proof/home-v1-iphone-17-pro-final.png`
- `.agent/tasks/T-167/reviews/**`
- `docs/DECISIONS.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/design/homepage-research/README.md`
- `native-ios/App/Models/AppChrome.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/App/Views/AudioControls.swift`
- `native-ios/App/Views/PhraseDetailView.swift`
- `native-ios/App/Views/PhraseListingView.swift`
- `native-ios/Tests/AppChromeTests.swift`

## Decisions Locked In

- Home is now the native default route; `Xin chào` remains the flagship listing page and Browse doorway, not the whole home screen.
- User intent state persists page IDs only and stays private, deterministic, offline, and device-local.
- Production Home/Search/listing runtime remains JSON/catalog-backed while T-165's bundled SQLite read path stays DEBUG validation infrastructure.
- Practice affordance is page-level local selection only. Full deck generation, quiz UI, progress, missed/due state, and practice audio audits remain future work.

## Validation

- `python3 .agent/queue_tool.py repair --fail-on-unhealthy` passed with `status: ok`.
- `cd native-ios && xcodegen generate` passed and left no generated project diff.
- `git diff --check` passed.
- `cd native-ios && xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build` passed with `** BUILD SUCCEEDED **`.
- `cd native-ios && xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests -only-testing:SpeakLocalNativeTests/LocalUserIntentStoreTests` passed: 39 tests, 0 failures.
- Full-suite check `cd native-ios && xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` was run for transparency and failed: 105 tests, 146 failures, all in existing `PhrasePageFixtureTests` content-pattern assertions (`testAllTierOneGeneratedPagesHaveExpandedListingPattern`, `testAuthoredTierOneSectionPresentationRolesAreExplicit`, `testTierOneGeneratedPagesUseExpandedListingPattern`). T-167 did not touch generated phrase content or `PhrasePageFixtureTests.swift`; the T-167 local-state/navigation test lane passed fresh after the final source fold.
- The iPhone 17 Pro simulator was booted, the app was installed and launched with bundle id `app.speaklocal.vietnam.native`, and the refreshed screenshot shows Home V1.

## Simulator Proof

- Screenshot: `.agent/tasks/T-167/proof/home-v1-iphone-17-pro-final.png`
- Visual check: iPhone 17 Pro simulator displayed the new Home first viewport with Vietnam masthead, "Start speaking now", search entry, Start with essentials shelf, and selected Home bottom chrome.

## Review Artifacts

- Gate 1 latest passing review: `.agent/tasks/T-167/reviews/gate-01-pass-03/*.md` with 4/4 approvals.
- Gate 2 latest passing review: `.agent/tasks/T-167/reviews/gate-02-pass-01/*.md` with 4/4 approvals.
- Gate 3 earlier passes found stale source-truth/result/scope blockers; those were corrected before the final Gate 3 pass.
- Gate 3 latest passing review: `.agent/tasks/T-167/reviews/gate-03-pass-05/*.md` with 4/4 approvals.

## Remaining Risks

- Saved route is intentionally minimal and local-only; richer saved management can wait until Practice/Search/Browse state is fuller.
- Browse still opens the existing `Xin chào` catalog doorway rather than a separate all-pages destination.
- Home rendering has compile/unit coverage through routing/state tests and simulator screenshot proof, but no UI snapshot assertion yet.
- Practice Pool is only local page selection; it does not yet generate decks or sessions.
- The unrelated full-suite `PhrasePageFixtureTests` content-pattern failures should be handled by a separate generated-content/source-truth cleanup task.

## Recommended Next Tasks

- Build the offline Viet practice deck generator from canonical page/audio IDs.
- Add the native Practice destination and listing-page Practice entrypoints against generated deck resources.
- Add local practice progress, missed/due state, and practice-specific audio audit behavior after the deck/UI path exists.
- Resolve the existing `PhrasePageFixtureTests` generated-content pattern drift so the full native suite can return to green.
- Add SQLite search/page-renderer parity behind DEBUG before switching any visible production Home/search/listing route.

## Process Feedback

- NONE: The task flow worked. Gate 1 caught real navigation issues and Gate 3 caught stale source-truth/result/scope gaps before closeout.
