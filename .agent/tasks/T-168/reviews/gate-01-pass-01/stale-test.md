# Gate 1 Pass 1: Stale Test

Findings:

- Blocking: the focused stale-test gate does not pass cleanly. `xcodebuild test -only-testing:SpeakLocalNativeTests/PhrasePageFixtureTests` exited `65`; the xcresult reports `PhrasePageFixtureTests/testEveryTierOneArticleIsSearchableByExactTitleAndEnglish()` crashed with `signal kill` at `native-ios/Tests/PhrasePageFixtureTests.swift:560`. This means the preserved search coverage is still not gate-green, even though the later restarted run shows the other fixture assertions passing.

Notes:

- Static review looks good on the stale assertion modernization: `watch-out` / `warningCallout` expectations were replaced with `good-to-know` / `tipCallout`, with explicit negative assertions against `watch-out`, `Watch out`, and `warning-callout`.
- Coverage for canonical uniqueness, openable links, audio resolution, search priority/canonical-first behavior, no placeholder copy, and article contract remains present.

Approval: BLOCK
