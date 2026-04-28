# Priorities

This file is the current roadmap and near-term next-step authority for the repo.
Use `docs/DECISIONS.md` for durable decisions and `docs/V2_BASELINE.md` plus `docs/V2_CONTENT_MODEL.md` for blueprint truth.

## Active focus

1. Continue the native SwiftUI/Xcode app in `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`; this is now the active ship-facing app lane on the Mac.
2. Keep the shared repo authoritative and portable so the native client reads correct product truth instead of rebuilding logic from scratch.
3. Finish and keep improving the 150 Tier 1 Viet listing pages as authored offline "Different ways to say [phrase] in Vietnam" article pages using `content-draft/viet/listing-pages/**` and the `speaklocal-listing-pages` skill.
4. Treat destination-app completeness as a phrase-graph problem: save the real alternate phrasings, relation branches, likely replies, and adjacent next-step phrases for major traveler intents instead of stopping at one visible phrase per page.
5. Keep audio attached to that phrase graph. Speaker icons imply bundled audio or an explicit missing-audio audit item; reuse exact normalized audio before generating new ElevenLabs assets.
6. Add the pre-live Practice/Quiz lane as a native offline rehearsal layer, not a generic game shell. It should reuse listing-page phrases, category graph, pronunciation audio, breakdown tokens, and local progress so travelers can practice by category, pronoun/social role, saved phrases, missed phrases, or the current listing page.
7. Add mascot design/integration as a controlled native asset lane. No real mascot asset is currently present in the native resources, so mascot work must begin with art direction, poses, and usage rules before app integration.
8. Tighten native app UX around the flagship surfaces:
   - home
   - dedicated search
   - listing/answer page
   - canonical child phrase pages
   - practice/quiz entrypoints
   - static glass chrome
   - swipe back and forward history
   - search-island-to-search-field morphing
9. Use Expo only as a bridge/reference lane during the transition. Keep design exploration and structural proof there when useful, but stop treating Expo shell polish as the final destination once it stops teaching us something.
10. Keep Viet first. Tagalog and future destinations should inherit the hardened content/listing-page/native-shell/practice pattern rather than forcing simultaneous rewrites.

## Not doing right now

- subscriptions
- account sync
- cloud-backed unlock dependency
- treating Windows as the main working machine
- deleting Expo or the shared repo before native parity exists
- rewriting all 10+ apps simultaneously before the family shell exists
- a third runtime-wired app before Viet + Tagalog content proof is stronger
- turning the website into the full phrase library
- pretending the current Viet pass is device-proven or broader audio-quality-cleared
- pretending practice/quiz exists before its offline deck, mascot, audio, and native UX are designed and validated
- pretending the repo-side StoreKit pass counts as device proof by itself
- splitting content truth or workflow truth across separate repos during the native cutover
