# SpeakLocal Vietnam Audio Release Audit

Audited commit: `4f6462906579e1130a78b8ce6976b0eee3ed9024` (`Harden audio playback stress handling`, 2026-07-05 20:15:59 +0800)

Scope: offline static/content/resource audit on current local `main`. No ElevenLabs or paid generation services were called. Paywall/StoreKit was kept out of scope. I did not edit app code or generated app resources.

## Recommendation

Audio is **not a launch blocker** for the current non-paywall Vietnam app payload based on this audit.

The release still should not claim perfect pronunciation, same-speaker continuity, or fully human-approved audio quality. Static checks prove references, bundled files, and basic duration health; they do not replace a human listen spot-check.

## Command Receipts

| Command | Result |
| --- | --- |
| `node native-ios/scripts/sync-viet-audio.js` | PASS: validated `5353` native audio manifest entries in `native-ios/Resources/Audio`. |
| `node native-ios/scripts/validate-viet-sqlite-fixture.js` | PASS: `1782` clusters, `1800` source phrases, `1793` canonical pages, `11728` relations, `5353` audio assets, `0` missing-audio audit rows, `0` release-blocking missing-audio audit rows, `0` planned missing-audio audit rows. |
| `node native-ios/scripts/validate-tier-one-listing-pages.js` | PASS: `150 / 150` Tier 1 pages strong; `0` thin, awkward, placeholder-like, over-templated, negative-frictional, missing useful child links, or needs-work rows. |
| `node native-ios/scripts/validate-vietnamese-menu-copy.js` | PASS: validated `355` handwritten Vietnamese menu item pages; `15` ready helper phrases. |
| `node native-ios/scripts/audit-viet-listing-production-qa.js --check` | PASS: `1793` pages; `0` blockers; `0` majors; `0` missing-audio priority rows. |
| `node native-ios/scripts/validate-viet-breakdown-audit.js` | PASS: breakdown audit passed. |

## Findings

### Blockers

None found.

### Non-Blockers / Follow-Ups

1. **Orphan audio files: 15**
   - These files exist under `native-ios/Resources/Audio` but are not referenced by `native-ios/Resources/viet-audio-manifest.json`.
   - They do not break playback because no manifest key points at them, but they are cleanup debt before a final size/polish pass.
   - Files:
     - `v500-emer-safe-stop-following-me.mp3`
     - `v500-emer-safe-there-is-a-fire.mp3`
     - `v500-heal-phar-how-do-i-take-this.mp3`
     - `v500-hote-acco-the-toilet-is-not-working.mp3`
     - `v900-food-drin-can-we-sit-by-the-fan.mp3`
     - `v900-food-drin-can-we-sit-inside.mp3`
     - `v900-food-drin-can-we-sit-outside.mp3`
     - `v900-heal-phar-can-i-drink-alcohol-with-this.mp3`
     - `v900-heal-phar-can-i-get-a-medical-report.mp3`
     - `v900-heal-phar-can-i-get-a-receipt-for-insurance.mp3`
     - `v900-heal-phar-should-i-take-it-before-bed.mp3`
     - `v900-hote-acco-can-i-have-a-higher-floor.mp3`
     - `v900-loca-serv-ever-task-can-we-sit-somewhere-quieter.mp3`
     - `v900-sigh-acti-is-there-an-english-guide.mp3`
     - `v900-time-date-book-can-i-have-seats-together.mp3`

2. **Raw blank audio-key fields remain, but no broken manifest references were found**
   - Audited generated resources had `22938` `audioKey` fields across catalog, authored listing pages, and menu copy.
   - `0` non-empty resource audio keys were missing from the manifest.
   - `0` manifest-referenced files were missing on disk.
   - `391` blank catalog keys all resolve by exact Vietnamese text through the app's manifest fallback.
   - `1853` authored listing-page blank keys remain; `285` resolve by exact text and `1568` do not. These are mostly breakdown chunks or secondary phrase rows without a playable speaker promise. If product wants every breakdown card to be playable, this is the next audio-generation queue, but the current production/audio audits do not classify them as release-blocking.
   - Menu copy has `1` blank helper phrase (`menu-with-chicken`) with an explicit `missingAudioReason`: "do not render until exact audio exists."

3. **Duration sanity: no zero/tiny broken files**
   - `afinfo` successfully read all `4047` bundled audio files.
   - `0` files had zero duration.
   - `0` files were shorter than `0.25s`.
   - `1` file was shorter than `0.5s`: `city-name-hue.m4a` at `0.436145s`, text `Huế`. This is plausible for a one-word city name and not a blocker.

4. **Known high-risk example: `Không cay` / not spicy is now covered**
   - `content-draft/viet/canonical-pages/tier-one/food-drink/food-not-spicy.json` now assigns `audioKey: "breakdown-authored-khong-cay"` to the visible `Không cay` breakdown chunk.
   - Manifest entries exist for the main phrase (`food-3`, `Không cay nhé`), clearer variant (`food-not-spicy-clearer`), and standalone breakdown (`breakdown-authored-khong-cay`, `Không cay`).
   - `afinfo` read the relevant files successfully: `food-3.mp3` is about `1.23s`; `breakdown-khong-cay-d717d201da.mp3` is about `1.10s`.
   - Existing fixture coverage includes `PhrasePageFixtureTests.testNotSpicyBreakdownCardHasPlayableAudio`.

5. **Placeholder/TODO scan**
   - No runtime generated-resource placeholder hits were found in `native-ios/Resources/viet-phrase-catalog.json`, `native-ios/Resources/viet-authored-listing-pages.json`, `native-ios/Resources/vietnamese-menu-copy.json`, or `native-ios/Resources/viet-audio-manifest.json`.
   - The only match was instructional text in `content-draft/viet/canonical-pages/README.md`, not user-facing runtime copy.

## Speaker Affordance Check

The shared `AudioSpeakerButton` renders only when `AudioAssetManifest.main?.url(for:)` resolves the supplied key. `BreakdownTokenCard` renders a playable button only when `token.playbackAudioKey` resolves; otherwise it renders static content without a speaker button. This means the static mismatches above do not currently create visible speaker icons with no bundled playback target.

## Exact Follow-Up List

1. Decide whether to delete the 15 orphan audio files or reattach them to intentional manifest keys.
2. If the launch bar becomes "every visible breakdown chunk must have audio," create a separate generation/import queue for the `1568` authored blank breakdown/secondary refs that do not exact-text-resolve today.
3. Human-listen spot-check the most-visible launch paths before marketing/app-store claims: Home starter phrases, Search top results, Browse food/transport/hotel basics, city names, menu helper phrases, and `Không cay` / not-spicy.
4. Keep paywall audio/StoreKit work separate; this audit does not validate paywall release behavior.
