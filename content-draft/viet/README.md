# Viet Draft Lane

This folder is the canonical authored source for the live Viet v2 content pack.

It now owns:

- the category spine in `scenario-plan.json`
- the phrase and intent-family source in `phrase-source.csv`
- the relation-ready sidecar sample in `relation-sample-v1.json`
- the relation contract notes in `relation-authoring-notes.md`
- the premium expansion lane records in `premium-expansion/`
- the autonomous 500-family audit artifacts in `autonomous-500/`
- the approved website preview slices in `website-preview.json`

Current posture:

- scenario remains the app's category-level runtime seam
- intent families are the visible decision unit inside each category
- starter vs premium is handled at the phrase/family level, not by locking whole categories
- the current live Viet truth is `150 starter / 750 premium / 900 total` visible families
- the current live Viet raw row truth is `919` approved rows, all currently `audio_status=ready`
- the earlier Phase 1A and Phase 1B expansion lanes are now promoted-live historical records, not still-separated prepared-only content
- future premium expansion lanes may still live here before promotion
- relation-ready phrase-detail/listing work now uses a bounded sidecar sample instead of trying to infer family links ad hoc from prose
- existing bundled audio is preserved where legacy phrases already had assets

Current relation-ready handoff:

- `phrase-source.csv` now carries lightweight `relation-sample=...` markers inside the existing `notes` field for the bounded Viet sample clusters only
- `relation-sample-v1.json` now maps `29` starter-safe Viet family clusters across arrival, greeting, transport, food, money, hotel, phone, and repair moments
- the marker seam covers anchor rows plus a small number of real `clearer`, `more-polite`, and `also-common` variants when the CSV already has them
- the sidecar remains additive: it does not replace the current scenario -> family -> phrase-row model
