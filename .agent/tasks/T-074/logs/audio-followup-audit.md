# T-074 Cross-Language Prep Audio Audit

## Scope
- Task: `T-074`
- Batch: `elevenlabs-prep-batch-2026-04-20`
- Languages audited: `german`, `japanese`, `spanish`, `italian`, `turkish`
- Voice: `EXAVITQu4vr4xnSDxMaL`
- Model: `eleven_multilingual_v2`
- Source summary: `.agent/coordination/elevenlabs-prep-audio-batch-summary-2026-04-20.json`

## Batch summary
- Total generated: `150`
- Total skipped: `0`
- Total failed: `0`
- Total chars: `2747`
- Runtime wiring touched: `none`
- Out-of-scope surfaces touched: `none`

## Lane reconciliation

### German
- Phrase source: `content-draft/german/phrase-source.csv`
- Batch dir: `content-draft/german/audio-draft/elevenlabs-prep-batch-2026-04-20`
- Translated rows with non-empty `target_text`: `30`
- Manifest entries: `30`
- MP3 files: `30`
- Missing manifest coverage for translated rows: `0`
- Manifest entries without translated rows: `0`
- Manifest entries missing physical MP3s: `0`
- Extra physical MP3s outside manifest: `0`
- Status breakdown:
- `first-wave-translated`: `29`
- `first-wave-translated-sensitive`: `1`

### Japanese
- Phrase source: `content-draft/japanese/phrase-source.csv`
- Batch dir: `content-draft/japanese/audio-draft/elevenlabs-prep-batch-2026-04-20`
- Translated rows with non-empty `target_text`: `47`
- Manifest entries: `47`
- MP3 files: `47`
- Missing manifest coverage for translated rows: `0`
- Manifest entries without translated rows: `0`
- Manifest entries missing physical MP3s: `0`
- Extra physical MP3s outside manifest: `0`
- Status breakdown:
- `drafted`: `24`
- `first-wave-promoted-core`: `21`
- `rewritten-and-drafted`: `1`
- `first-wave-flagged-holdout`: `1`

### Spanish
- Phrase source: `content-draft/spanish/phrase-source.csv`
- Batch dir: `content-draft/spanish/audio-draft/elevenlabs-prep-batch-2026-04-20`
- Translated rows with non-empty `target_text`: `25`
- Manifest entries: `25`
- MP3 files: `25`
- Missing manifest coverage for translated rows: `0`
- Manifest entries without translated rows: `0`
- Manifest entries missing physical MP3s: `0`
- Extra physical MP3s outside manifest: `0`
- Status breakdown:
- `first-wave-promoted-core`: `24`
- `first-wave-flagged-holdout`: `1`

### Italian
- Phrase source: `content-draft/italian/phrase-source.csv`
- Batch dir: `content-draft/italian/audio-draft/elevenlabs-prep-batch-2026-04-20`
- Translated rows with non-empty `target_text`: `24`
- Manifest entries: `24`
- MP3 files: `24`
- Missing manifest coverage for translated rows: `0`
- Manifest entries without translated rows: `0`
- Manifest entries missing physical MP3s: `0`
- Extra physical MP3s outside manifest: `0`
- Status breakdown:
- `first-wave-promoted-core`: `16`
- `first-wave-translated`: `7`
- `first-wave-translated-sensitive`: `1`

### Turkish
- Phrase source: `content-draft/turkish/phrase-source.csv`
- Batch dir: `content-draft/turkish/audio-draft/elevenlabs-prep-batch-2026-04-20`
- Translated rows with non-empty `target_text`: `24`
- Manifest entries: `24`
- MP3 files: `24`
- Missing manifest coverage for translated rows: `0`
- Manifest entries without translated rows: `0`
- Manifest entries missing physical MP3s: `0`
- Extra physical MP3s outside manifest: `0`
- Status breakdown:
- `translated-draft`: `19`
- `translated-draft-needs-localization-check`: `2`
- `translated-draft-contextual-only`: `2`
- `translated-draft-needs-expert-review`: `1`

## Findings
- The coordination summary and all five lane-local batch folders agree on the same `150` generated prep clips.
- Every currently translated non-empty row in the five named lanes has matching prep audio coverage in the `2026-04-20` batch.
- Every manifest entry points to a present MP3 file, and no extra MP3 files sit outside the manifest in the audited batch folders.
- The batch remains prep-only evidence. Nothing in this audit proves native review, production readiness, or same-speaker continuity.
- Some translated rows still carry risk-marking statuses such as `first-wave-flagged-holdout`, `translated-draft-needs-localization-check`, and `translated-draft-needs-expert-review`; those are content-quality cautions, not manifest-coverage failures.

## Remaining cautions
- Shell output shows mojibake for some non-ASCII text when printed directly, but the underlying CSV and JSON files still reconcile on keys, counts, and metadata.
- Future translation passes in any of the five lanes will need follow-up audio generation to preserve full translated-row coverage.
