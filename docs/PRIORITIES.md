# Priorities

This file is the current roadmap and near-term next-step authority for the repo.
Use `docs/DECISIONS.md` for durable decisions and `docs/V2_BASELINE.md` plus `docs/V2_CONTENT_MODEL.md` for blueprint truth.

## Active focus

1. Continue the native SwiftUI/Xcode app in `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`; this is now the active ship-facing app lane on the Mac.
2. Keep the shared repo authoritative and portable so the native client reads correct product truth instead of rebuilding logic from scratch.
3. Aim product and UX decisions at the excited pre-trip traveler first: someone planning Vietnam who wants food, cities, culture, pronunciation, and useful local phrases to make the trip feel richer. In-country utility should support that promise, not turn the app into a generic translator replacement.
4. Prioritize the surfaces that express that audience wedge most clearly:
   - Home as a destination/culture/phrase gateway
   - Food Menu and Drink Menu as flagship menu exploration
   - city pages as place-first trip exploration
   - noun-first Browse/category rows for food, markets, places, and everyday objects
   - saved/practice loops for building a personal trip phrase set before arrival
5. Finish and keep improving Viet canonical phrase pages as authored offline "Different ways to say [phrase] in Vietnam" article pages using `content-draft/viet/canonical-pages/**` and the `speaklocal-listing-pages` skill.
6. Treat destination-app completeness as a phrase-graph problem: save the real alternate phrasings, relation branches, likely replies, and adjacent next-step phrases for major traveler intents instead of stopping at one visible phrase per page.
7. Keep audio attached to that phrase graph. Speaker icons imply bundled audio or an explicit missing-audio audit item; reuse exact normalized audio before generating new ElevenLabs assets.
8. Add the pre-live Practice/Quiz lane as a native offline rehearsal layer, not a generic game shell. `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` is the current planning source for the first implementation sequence: offline deck generation, native Practice surfaces, listing-page `Practice this`, local missed review, practice audio audit, simulator/device proof, and follow-up mascot integration.
9. Add mascot design/integration as a controlled native asset lane. No real mascot asset is currently present in the native resources, so mascot work must begin with art direction, poses, usage rules, and serious-context restraint before app integration.
10. Tighten native app UX around the flagship surfaces:
   - home
   - dedicated search
   - listing/answer page
   - canonical child phrase pages
   - practice/quiz entrypoints
   - static glass chrome
   - swipe back and forward history
   - search-island-to-search-field morphing
11. Keep the repo native-only for app work. No new product UI should be built in Expo, React Native, Metro, or any resurrected `app/` shell.
12. Keep Viet first. Tagalog and future destinations should inherit the hardened content/listing-page/native-shell/practice pattern rather than forcing simultaneous rewrites.

## Not doing right now

- subscriptions
- account sync
- cloud-backed unlock dependency
- competing with Google Translate, Apple Translate, or general-purpose AI as an arbitrary live translator
- reopening old non-Mac development lanes
- resurrecting Expo/React Native as an app surface
- rewriting all 10+ apps simultaneously before the family shell exists
- a third runtime-wired app before Viet + Tagalog content proof is stronger
- turning the website into the full phrase library
- pretending the current Viet pass is device-proven or broader audio-quality-cleared
- pretending practice/quiz exists before its offline deck, native UX, local progress, mascot lane, practice audio audit, simulator proof, and device proof are implemented and validated
- pretending the repo-side StoreKit pass counts as device proof by itself
- splitting content truth or workflow truth across separate repos during the native cutover
