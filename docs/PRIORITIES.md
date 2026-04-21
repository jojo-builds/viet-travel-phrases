# Priorities

This file is the current roadmap and near-term next-step authority for the repo.
Use `docs/DECISIONS.md` for durable decisions and `docs/V2_BASELINE.md` plus `docs/V2_CONTENT_MODEL.md` for blueprint truth.

## Active focus

1. Run native iOS device proof for the current 900-family Viet one-time purchase / restore flow.
2. Capture App Store Connect setup truth and device results honestly in `docs/operations/*`.
3. Close as much of the remaining shared-search device-proof debt as the same manual validation lane allows.
4. Treat Viet audio as artifact-complete for the current 900-family pack and only revisit it for continuity benchmarking plus cleanup decisions around the 2 ignored legacy orphan MP3s.
5. Harden the phrase relationship model so Viet and Tagalog evolve toward navigable phrase-detail/listing surfaces rather than flat phrase-database retrieval.
6. Carry the same content model, builder path, and premium plumbing to Tagalog with a real Tagalog v2 pack, starting from the new first-wave shortlist and risk review rather than another broad planning pass.

## Not doing right now

- subscriptions
- account sync
- cloud-backed unlock dependency
- broad repo relocation or family architecture rewrite
- a third runtime-wired app before Viet + Tagalog content proof is stronger
- turning the website into the full phrase library
- pretending the current Viet pass is device-proven or broader audio-quality-cleared
- pretending the repo-side StoreKit pass counts as device proof by itself
