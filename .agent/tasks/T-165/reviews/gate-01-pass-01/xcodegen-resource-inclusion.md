# Gate 1 Pass 1: XcodeGen/Resource Inclusion Review

No blocking findings for Gate 1.

`native-ios/project.yml` intentionally keeps broad `Resources` inclusion while excluding `Audio` and `LanguagePacks`, then re-adds both as explicit folder resources. That preserves root-level JSON packaging through `Resources`, preserves existing `Resources/Audio` folder behavior, and adds `Resources/LanguagePacks` as a bundled folder.

The fixture report and generator/test also reflect that intent: `bundlePackaging.isIncludedInXcodeResources` is `true`, status is `bundle-ready`, and the report notes SQLite is bundled for migration proof while Swift runtime still reads root JSON.

Approval: APPROVE
