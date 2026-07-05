# 30-Second App Preview Shot List

Date: 2026-07-05
Status: script-ready, capture pending
Format target: iPhone portrait App Preview

## Apple Spec Notes

Apple App Preview requirements checked on 2026-07-05:

- Duration: 15 to 30 seconds.
- Maximum file size: 500 MB.
- Accepted formats include H.264 and ProRes 422 HQ.
- Maximum frame rate: 30 fps.
- Supported extensions include `.mov`, `.m4v`, and `.mp4` for H.264.
- For current large iPhone portrait previews, accepted resolution is 886 x 1920 pixels.
- Up to three app previews may be uploaded per localization and device size.

## Creative Brief

Audience segment: English-speaking travelers planning Vietnam.
User problem or travel moment: They want Vietnam to feel vivid and practical before arrival, but they do not want a classroom course or generic translator.
Hook: `Plan Vietnam with food, places, and phrases you can hear.`
Channel: App Store App Preview, reusable as a quiet paid/organic cutdown if final assets pass review.
Offer or CTA: Download before Vietnam; subscription CTA only if StoreKit proof is complete.
Required app evidence: current native screen recordings for Home, Search, food/menu detail, city/place, Saved, and Practice.
Claim risk or feature dependency: `NEEDS_SCREEN_RECORDING`, `NEEDS_SCREENSHOT`, `NEEDS_STOREKIT_PROOF` for any trial mention.
Success metric: App Store product page conversion and video completion.
Next action: capture screen recordings after screenshot set is approved.

## Recommended 30-Second Cut

No voiceover is required for the App Store version. Use visible UI, subtle captions, and natural screen motion. If audio is included, keep it simple and avoid implying every row has identical audio depth.

| Time | Visual | Caption | Capture Need | Risk |
| ---: | --- | --- | --- | --- |
| 0:00-0:03 | Home opens with native chrome and Vietnam trip shelves | `Plan Vietnam before you land` | Fresh Home screen recording | `NEEDS_SCREEN_RECORDING` |
| 0:03-0:07 | Search opens; query `hotel` or `coffee`; result selected | `Search the trip moment` | Search flow | Avoid arbitrary translator claim |
| 0:07-0:12 | Food/menu page opens; tap audio on supported item | `Hear useful Vietnamese` | Food/menu detail with supported audio | Say supported audio, not all audio |
| 0:12-0:17 | City/place page scrolls to context and useful phrases | `Find places with context` | Current place page | Avoid comprehensive guide claim |
| 0:17-0:22 | Save action, then Saved surface with trip pocket | `Save what matters` | Seeded Saved state | No cloud sync claim |
| 0:22-0:27 | Practice round starts from saved/trip content | `Practice without a textbook` | Native Practice recording | No fluency claim |
| 0:27-0:30 | Home or App Store-style end frame from app UI | `SpeakLocal Vietnam` | Current app end state | `NEEDS_JOJO_DECISION` for final CTA |

## Alternate Voiceover For Social Cutdown

This is for TikTok/Reels/Shorts, not necessarily the App Store preview.

> Going to Vietnam? SpeakLocal helps you find what to eat, where to go, and what to say. Search a trip moment, hear the Vietnamese, save what matters, and practice before you land.

Do not use if final screen recordings do not visibly prove each phrase.

## Capture Checklist

- Current native `main` commit recorded.
- Device/simulator recorded.
- Demo state reset and seeded deliberately.
- No personal data, App Store Connect secrets, device IDs, signing identifiers, or Jojo account details visible.
- Audio taps only on supported bundled-audio rows.
- No paywall shot unless StoreKit proof is complete and approved.
- Final export checked against Apple duration, resolution, file size, frame rate, and codec requirements.
