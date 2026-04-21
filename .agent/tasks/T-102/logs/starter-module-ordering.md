# T-102 Starter Module Ordering Audit

Date: 2026-04-21
Task: Desktop Codex automation pilot, Vietnam website starter module subset and conversion ordering pass

## Decision

Keep the current Vietnam hub subset and module order. No subset swap was justified from the committed export evidence.

Hub order:

1. `vietnam-arrival-basics`
2. `vietnam-transport-basics`
3. `vietnam-money-basics`
4. `vietnam-phone-basics`

Off-hub exported starter modules:

- `vietnam-essential-basics`
- `vietnam-understanding-repair`
- `vietnam-food-drink-basics`

## Evidence reviewed

- `content-draft/viet/website-preview.json` defines 7 approved Viet starter preview modules.
- `site/data/phrase-previews/manifest.json` mirrors those same 7 exported modules for the live website seam.
- `site/countries/vietnam.html` currently surfaces only 4 module hosts in this order:
  - arrival
  - transport
  - money
  - phone
- `.agent/tasks/T-102/reviews/gate-01-pass-01/*.md` already recorded unanimous pre-edit approval that the current hub slice is the strongest traveler-first conversion subset.

## Why this order still wins

- Arrival and transport carry the highest first-day failure risk: airport handoff, pickup confusion, route confirmation, fare, and meter issues.
- Money stays ahead of phone because pricing, totals, and ATM stress can become expensive immediately, while phone failures usually remain recoverable through offline prep or later shop help.
- Phone remains on-hub because maps, SIM, and connectivity failures still break the trip early enough to deserve direct access from the country page.
- Essentials is useful but lower leverage on the hub because the page already carries broad top-level framing and the phrase/article surfaces can carry polite basics without displacing higher-stress modules.
- Repair and food remain discoverable through the phrase guide, where they support broader browsing without diluting the hub's first-action conversion role.

## Bounded change landed

- Clarified the live Vietnam hub copy to name the exact surfaced order and to state that essentials, repair, and food stay off-hub.
- Updated `docs/website/PHRASE_AUDIO_DELIVERY.md` so the durable website seam doc names the exact 4-of-7 hub subset and its rationale.

## Validation

- `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- Result: passed on 2026-04-21 after the copy/doc update
- Confirmed route-pair parity, internal link integrity, preview JSON parity and phrase/audio schema checks, and preview audio parity
