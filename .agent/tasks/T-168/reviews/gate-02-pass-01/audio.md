# Gate 2 Pass 1 - Audio

Status: BLOCK

Reviewer lane: visible audio and offline playback keys.

Blocking finding:
- SQLite detail loading dropped audio keys for visible `authored_phrase` rows. On `viet-phrase-smalltalk-7`, the `relationship-forms` section has three visible authored phrase rows with bundled audio, but the SQLite read path returned nil playback keys and `visibleAudioUsages(forPageID:)` omitted those authored-phrase usages.

Resolution required:
- Join `audio_usage` / `audio_asset` for authored phrase section rows and include `authored_phrase` targets in visible-audio coverage.
- Add a regression test that verifies the visible authored phrases keep playable audio keys.
