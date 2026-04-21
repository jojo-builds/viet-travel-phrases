# Gate 2 Pass 1 Review 02

## Verdict

The Viet phrase-surface scope looks correct. Embedded playback is gated by `data-phrase-audio-mode="playback"` in the loader, the phrase guide and the three article surfaces opt in, and the Vietnam hub stays preview-first without that playback mode.

## Risks

No blocking risks found in the Viet lens. The export seam itself is still bounded; the hub continues to render starter previews without becoming a playback surface.

Approval: APPROVE
