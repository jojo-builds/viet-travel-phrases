# Native Language Packs

Reserved target folder for per-language native bundles.

Current live runtime resources are still root-level Viet files under `native-ios/Resources/` plus `native-ios/Resources/Audio/`. Do not manually move them into this folder.

The migration into `LanguagePacks/<language>/` must update Swift loaders, native generators, XcodeGen resource rules, tests, and docs in one coordinated task.

