# SpeakLocal Vietnam Premium Expansion Plan

Status: live allocation and future-only planning authority after the 900-family completion  
Last updated: 2026-04-16  
Scope: Viet content allocation, premium philosophy, and future-only expansion guardrails

## Why this doc exists

- lock the current live Viet content truth at the completed `150 / 750 / 900` boundary
- preserve the active unlock price at `$4.99` one-time
- show how the live 900-family pack is distributed across the 18 traveler scenarios
- protect future planning from drifting back into the now-completed live target

## Locked live truth

- Current live authored reality:
  - `150` starter visible intent families
  - `750` premium visible intent families
  - `900` total visible intent families
  - `919` approved phrase rows
  - `919` approved rows currently marked `audioStatus=ready`
  - `0` approved rows currently marked `audioStatus=planned`
- Current live unlock target:
  - `$4.99` one-time
- Explicit future option only:
  - `200` starter visible intent families
  - `800` premium visible intent families
  - `1000` total visible intent families

## Counting and authority rules

- Planning unit = intent-family primary, not raw phrase rows.
- One family = one travel situation, one best phrase to say first, plus only a few nearby variants when they materially help.
- Starter vs premium boundary lives on the family primary.
- Use `content-draft/viet/phrase-source.csv`, `app/family/packs/viet.generated.ts`, `app/scripts/validate-premium-boundary.ts`, and `app/family/presentation/vietPremium.ts` for current live-build truth.
- Use this doc for live scenario allocation and any future-only thinking beyond the current live 900-family pack.
- Do not treat `200 / 1000` as current live truth.

## Premium philosophy

- SpeakLocal Vietnam is a destination-first travel phrasebook, not an academic language-learning app.
- Free = get by.
- Premium = do not get stuck.
- Premium must earn belief through recovery, clarification, confidence, cost-control, and help under stress.
- The app should behave like a traveler decision engine, not a random phrase warehouse.
- Premium should deepen the same categories travelers already open in free instead of hiding whole categories behind the paywall.
- Emergency, pharmacy, and understanding/repair basics stay in starter access.

## Website and monetization guardrails

- The website may use the live `150 / 750 / 900` boundary to explain starter scope and why premium exists.
- For Vietnam, the website should expose only the starter/free layer that matches the app's starter surface and route deeper value into the app.
- Destination articles should reinforce those same starter phrases instead of becoming a separate web-only product layer.
- Premium remains app-first in current truth. Do not add website premium, cross-platform entitlement sync, login/account architecture, or code-redemption flow in this plan.
- Any future website monetization idea stays deferred until app sales proof justifies revisiting it.

## Live 900-family allocation snapshot

| Scenario | Starter / Premium / Total | Why it now feels credible |
| --- | ---: | --- |
| Polite Basics | `8 / 12 / 20` | compact tact and courtesy depth without turning into etiquette filler |
| Understanding & Repair | `8 / 47 / 55` | enough repair coverage to keep misunderstandings from stalling the trip |
| Transport | `10 / 83 / 93` | ride, route, pickup, fare, and correction depth now feels like a real traveler lane |
| Hotel & Accommodation | `9 / 70 / 79` | check-in, room problems, invoices, and front-desk recovery now cover the real stay lifecycle |
| Food & Drink | `18 / 74 / 92` | broad free ordering plus strong premium allergy, correction, and payment follow-up |
| Money, Numbers & Prices | `9 / 53 / 62` | totals, change, fees, receipts, refunds, and banking friction now feel practical |
| Directions & Navigation | `8 / 44 / 52` | enough detail to recover from route drift without padding the category |
| Airport, Border & Arrival | `8 / 47 / 55` | arrival, baggage, pickup, and airport logistics now feel complete enough for real trips |
| Health & Pharmacy | `8 / 57 / 65` | symptoms, medicine, dosing, clinic follow-up, and insurance requests now feel credible |
| Problems & Help | `6 / 35 / 41` | support and escalation coverage now goes beyond generic distress phrases |
| Time, Dates & Booking | `7 / 52 / 59` | reservations, refunds, rescheduling, and waitlist language now feel fully useful |
| Shopping | `7 / 30 / 37` | fit, comparison, bargaining, and post-purchase fixes stay compact but believable |
| Phone, Internet & Power | `8 / 39 / 47` | SIM, Wi-Fi, OTP, repair, and map-app recovery now cover the common failure points |
| Bathroom & Personal Needs | `6 / 8 / 14` | intentionally compact, but no longer underbuilt for real travel use |
| Emergency & Safety | `9 / 34 / 43` | urgent help stays easy to reach while premium adds the next-step specifics |
| Social & Small Talk | `7 / 10 / 17` | still deliberately restrained and not padded with classroom chatter |
| Sightseeing & Activities | `6 / 22 / 28` | enough ticket, schedule, and meeting-point depth to support day-trip use |
| Local Services & Everyday Tasks | `8 / 33 / 41` | errands, print/fix/help requests, and practical support now feel genuinely useful |
| **Total** | **`150 / 750 / 900`** | **current live Vietnam milestone** |

## What the completion lanes changed

- `phase1-repair-recovery-core` and `phase1-food-connectivity-help` remain promoted-live historical manifests under `content-draft/viet/premium-expansion/`.
- The autonomous completion audits now live at:
  - `content-draft/viet/autonomous-500/generated-rows.csv`
  - `content-draft/viet/autonomous-500/selection-summary.json`
  - `content-draft/viet/autonomous-900/generated-rows.csv`
  - `content-draft/viet/autonomous-900/selection-summary.json`
- The current live allocation is no longer a planning target. It is the repo-real content boundary.

## Future-only expansion rules

- Preserve the current `150` free-family starter layer unless there is a deliberate source-of-truth decision to change it.
- Only consider future growth if the live `150 / 750 / 900` shape already feels complete on device and the next families still map to real traveler decisions.
- Keep avoiding:
  - synonym-only growth
  - classroom grammar coverage
  - etiquette filler with no travel decision attached
  - decorative polite rewrites of already-free families
  - variant-only growth without new intent families

## Implementation handoff rules

- Future content-generation prompts should ask for intent families, not flat phrase lists.
- Prompts should name:
  - scenario ID
  - priority bucket
  - access tier
  - family count requested
  - whether the lane is a live maintenance pass or a future-only `200 / 1000` exploration
- Audio batching should follow traveler value and proof needs, not simple file-order generation.
- Website, App Store, and paywall copy may now use the live `150 / 750 / 900` boundary.
- Do not claim `200 / 1000` in customer-facing copy until the live build actually reaches those numbers.
