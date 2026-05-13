# Variant Matrix

Last updated: 2026-05-13
Authority lane: live app operational truth

## Current Matrix

| Variant | Operational role | Runtime content status | Build status | Release status | Audio status | Authority note |
|---|---|---|---|---|---|---|
| `viet` | current native proof app | native Viet resources bundled under `native-ios/Resources/` with authored source in `content-draft/viet/` | native simulator/device builds from `native-ios/` | published app exists; current native build needs fresh device proof | native `viet-audio-manifest.json` plus bundled `Resources/Audio/` own current app audio truth | App work is native-only. Paywall/StoreKit proof remains separate until approved. |
| `tagalog` | future second-app candidate | planning/content prep only until a real native language-pack pass is done | not current native runtime | not released | not current native runtime | Should inherit the native shell and language-pack pattern after Viet is stable. |

## Operational Takeaway

- Viet is the active app lane.
- `native-ios/` is the only product app surface.
- Tagalog and future languages should not reintroduce Expo/React Native; they should inherit the SwiftUI shell and native resource model.
