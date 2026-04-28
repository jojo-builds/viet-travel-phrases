# Priorities

This file is the current roadmap and near-term next-step authority for the repo.
Use `docs/DECISIONS.md` for durable decisions and `docs/V2_BASELINE.md` plus `docs/V2_CONTENT_MODEL.md` for blueprint truth.

## Active focus

1. Use the remaining Windows-server time to harden the phrase database, answer-page/listing-page content, relation graph, audio manifests, and export seams that the native app will consume.
2. Keep the shared repo authoritative and portable so the future native client reads correct product truth instead of rebuilding logic from scratch.
3. Keep Viet and Tagalog content expansion moving in parallel so the first native app lands on real answer-page data rather than thin mock data.
4. Treat destination-app completeness as a phrase-graph problem: save the real alternate phrasings, relation branches, likely replies, and adjacent next-step phrases for major traveler intents instead of stopping at one visible phrase per page.
5. Keep audio attached to that phrase graph over time. Newly authored rows may enter with planned audio, but approved traveler-facing rows should stay auditable and move toward full audio coverage rather than silent drift.
6. Prepare and execute the Mac/Xcode cutover while keeping actual Swift/Xcode implementation deferred until the Mac server is commissioned and the overlap period is active.
7. Use Expo only as a bridge/reference lane during the transition. Keep design exploration and structural proof moving there, but stop treating Expo shell polish as the final destination once it stops teaching us something.
8. After the Mac overlap begins, start the first native iOS family shell around the flagship surfaces:
   - home
   - dedicated search
   - listing/answer page
   - prove first with `Xin chào`, then `I need a doctor`

## Not doing right now

- subscriptions
- account sync
- cloud-backed unlock dependency
- speculative Swift/Xcode implementation before the Mac server exists
- deleting Expo or the shared repo before native parity exists
- rewriting all 10+ apps simultaneously before the family shell exists
- a third runtime-wired app before Viet + Tagalog content proof is stronger
- turning the website into the full phrase library
- pretending the current Viet pass is device-proven or broader audio-quality-cleared
- pretending the repo-side StoreKit pass counts as device proof by itself
- splitting content truth or workflow truth across separate repos during the native cutover
