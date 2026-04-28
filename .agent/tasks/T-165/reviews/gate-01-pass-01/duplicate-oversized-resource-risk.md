# Gate 1 Pass 1: Duplicate/Oversized Resource Risk Review

No blocking findings. This was reviewed read-only.

The resource wiring looks scoped correctly: `project.yml` excludes `Audio` and `LanguagePacks` from the broad `Resources` entry, then adds `Resources/Audio` and `Resources/LanguagePacks` as separate folder resources. The generated Xcode project has one `Audio in Resources` entry and one `LanguagePacks in Resources` entry, with no individual `.mp3` build-file expansion.

`LanguagePacks/viet` contains only `.gitkeep`, `speaklocal-viet.sqlite`, and `speaklocal-viet-report.json`; `LanguagePacks` overall has 6 files, 0 audio files, about 7.2 MB. `Resources/Audio` has 2,427 MP3s, about 63 MB, and has no diff. The report's `bundlePackaging` field is `bundle-ready` with `isIncludedInXcodeResources: true`.

Approval: APPROVE
