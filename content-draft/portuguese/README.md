# Portuguese Content Draft

This folder is the prep lane for a future Portugal / European Portuguese SpeakLocal app variant.

Use it for:

- scenario review against the shared traveler baseline
- source-phrase drafting and rewrite notes
- Portugal-specific localization notes
- prep-only authoring artifacts that make the next translation pass faster
- pronunciation and audio-planning notes after source text is stable

Current status:

- prep-only
- not runtime-wired
- bootstrap research and scenario scaffold complete, but no translation coverage yet

Current durable lane assets:

- `research/language-pipeline/portuguese/PORTUGAL-TRAVEL-RESEARCH.md`
  - durable travel/use research, Portugal-focused register posture, and search implications
- `content-draft/portuguese/source-notes.md`
  - authoring posture, rewrite warnings, and review-risk notes
- `content-draft/portuguese/scenario-plan.json`
  - shared 10-scenario scaffold with Portugal-focused tips and quick phrase candidates
- `content-draft/portuguese/research-backlog.md`
  - next prep work and graduation blockers

Authoring posture for the next pass:

- keep the shared 10-scenario seam
- default to Portugal-focused European Portuguese, not mixed Portuguese and not Brazil-first wording
- keep correct Portuguese spelling visible in later `target_text`
- use `pronunciation` as lightweight ASCII-friendly support, not as a replacement for Portuguese orthography
- treat greetings, repair phrases, cafe ordering, transport, hotel, payment, bathroom, and bill requests as first-wave priorities
- preserve explicit review flags for medical, allergy, complaint, and vocabulary-drift-sensitive wording

Immediate next authoring target:

- create a ranked first-wave authoring shortlist before translation starts
- rewrite weak baseline rows such as bargaining-heavy price lines, generic city-center direction asks, and awkward bill-request or iced-drink scaffolds before literal translation
- decide a consistent pronunciation-helper rule for high-frequency Portugal service phrases
- do not wire this lane into `app/family` yet
