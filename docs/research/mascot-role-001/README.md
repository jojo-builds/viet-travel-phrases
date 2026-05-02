# SpeakLocal Mascot Role R&D

Research date: 2026-05-02
Research question: Should SpeakLocal keep, reduce, remove, or reposition the chameleon mascot, and where should it appear in a premium native iOS travel phrasebook?
Decision this should inform: Mascot role in onboarding, Practice, progress/rewards, app icon/brand, App Store screenshots, empty states, paywall/trial, phrase pages, search, playback, bottom chrome, and sensitive scenarios.
Assignment source: `docs/task-cards/TASK-MASCOT-RD-ROLE-001.md`
Research owner: Research / Product Strategy lane

## Executive Takeaway

Keep the chameleon, but reduce and formalize its role.

The mascot should not become SpeakLocal's product frame, app navigation, phrase-page decoration, paywall salesperson, or app icon centerpiece at launch. It should become a restrained premium travel companion used mainly in Practice, progress completion, and gentle empty states. The phrase remains the hero, bundled audio remains the action, and the mascot supplies optional warmth only when it makes the user feel more ready to speak.

The current repo direction is mostly right: the high-fidelity Melo assets are worth keeping as visual direction, while the older placeholder board stays rejected for implementation. Public evidence does not support mascot-heavy design for a premium travel utility. It does support mascot-light design when the mascot is tied to learning support, clear progress, social presence, and brand memory without adding clutter or game pressure.

Top recommendation: adopt a "mascot as Practice companion, not product narrator" rule now, then create a focused native Practice/UI test before letting Melo into broader brand or App Store surfaces.

## Audience And Source Map

### Repo Truth Used

| Source | How It Was Used |
| --- | --- |
| `docs/DECISIONS.md` | Current product boundary: chameleon only as restrained Practice companion, old visual board rejected for implementation. |
| `docs/design/NATIVE_VISUAL_REFERENCE.md` | Native visual taste bar and surface exclusions. |
| `docs/design/mascot/README.md` | Mascot art-direction contract and sensitivity rules. |
| `docs/design/mascot/high-fidelity/README.md` | Production-like mascot direction and strongest asset set. |
| `docs/design/mascot/practice-flow-storyboard/README.md` | Practice-flow placement and animation intent. |
| `docs/design/onboarding/first-run-vietnam/README.md` | First-run mascot warmth versus premium restraint tradeoff. |
| `docs/design/onboarding/utility-first-trial-vietnam/README.md` | Accepted Jojo decision: Melo subtle only, not guide/product centerpiece. |
| `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md` | Native-ready reward and mascot gating contract. |
| `docs/research/video-digests/onboarding-flows-1460-001/README.md` | Existing video evidence for value-before-explanation onboarding. |
| `docs/task-results/TASK-MASCOT-HIGH-FIDELITY-CONCEPTS-001.md` | Current visual verdict and recommended next task. |
| `docs/task-results/TASK-MASCOT-VISUAL-SYSTEM-001.md` | Historical concept result, now superseded/rejected for implementation. |
| `docs/task-results/TASK-PRACTICE-REWARD-MASCOT-001.md` | Prior reward-loop and gated-mascot handoff. |
| `docs/task-results/TASK-ONBOARDING-UTILITY-FIRST-DESIGN-001.md` | Accepted onboarding decisions, especially no mascot in paywall benefits. |

### Public Sources Used

This pass used 31 public sources across 6 categories. The original target was roughly 18-25 sources, but this pass kept extra platform/accessibility references because mascot animation, App Store screenshots, and app-icon use are separate decision surfaces. Access date for all public sources: 2026-05-02.

| Category | Sources | What They Helped Decide |
| --- | --- | --- |
| iOS platform and App Store guidance | [Apple HIG Motion](https://developer.apple.com/design/human-interface-guidelines/motion), [Apple Reduce Motion support](https://support.apple.com/en-us/111781), [Apple Reduced Motion criteria](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/reduced-motion-evaluation-criteria), [Apple HIG App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons/), [Apple HIG Materials](https://developer.apple.com/design/human-interface-guidelines/materials), [App Store screenshot upload guidance](https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots), [App Review metadata rules](https://developer.apple.com/app-store/review/guidelines/), [App Store marketing guidelines](https://developer.apple.com/app-store/marketing/guidelines/), [iOS energy guide](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/AvoidExtraneousGraphicsAndAnimations.html) | Restraint, screenshot truthfulness, motion/accessibility, performance, icon caution. |
| Translation, travel utility, and serious-language comparators | [Google Translate App Store](https://apps.apple.com/us/app/google-translate/id414706506), [Google Translate offline help](https://support.google.com/translate/answer/6142473?co=GENIE.Platform%3DiOS&hl=en-GB), [Apple Translate settings](https://support.apple.com/en-ie/guide/iphone/iphddb6e7264/ios), [DeepL mobile apps](https://www.deepl.com/en/mobile-apps), [Microsoft Translator apps](https://www.microsoft.com/en-us/translator/apps/), [Pimsleur app](https://www.pimsleur.com/pimsleur-app/) | Utility competitors sell actions, offline readiness, audio, phrasebook/favorites, and camera/conversation flows rather than mascots; Pimsleur is used as a premium audio/practice comparator. |
| Language learning competitors | [Duolingo App Store](https://apps.apple.com/us/app/duolingo-language-chess/id570060128), [Duolingo character design blog](https://blog.duolingo.com/building-character/), [Duolingo streak habit blog](https://blog.duolingo.com/how-duolingo-streak-builds-habit/), [Duolingo streak animation blog](https://blog.duolingo.com/streak-milestone-design-animation/), [Axios on Duo brand moment](https://www.axios.com/2025/02/15/duolingo-mascot-dead-duo-owl-social-media-marketing), [Drops App Store](https://apps.apple.com/us/app/drops-language-learning-games/id939540371), [Ling App Store](https://apps.apple.com/us/app/language-learning-ling/id1403783779), [Rosetta Stone App Store](https://apps.apple.com/us/app/rosetta-stone-learn-languages/id435588892) | Mascots and game elements work best when the product is explicitly lesson/game/companion shaped. Premium learning apps can also sell seriousness, audio, and confidence without mascots. |
| Companion and premium-wellness examples | [Finch App Store](https://apps.apple.com/us/app/finch-self-care-pet/id1528595748), [Headspace screenshot breakdown](https://appscreenmagic.com/top-screenshots/headspace) | A companion can be central when that is the product promise; premium apps can use friendly visuals without letting them displace the core action. |
| Learning science and HCI | [Gamification meta-analysis](https://link.springer.com/article/10.1007/s11423-023-10337-7), [Gamification misuse in Duolingo](https://arxiv.org/abs/2203.16175), [Pedagogical-agent design review](https://www.frontiersin.org/articles/10.3389/fpsyg.2023.1205338/full), [Embodied pedagogical agents](https://pubmed.ncbi.nlm.nih.gov/22642688/) | Agents and gamification can help motivation/social presence, but effects are contextual and can distract from learning if rewards or character behavior become the goal. |
| Public user/forum evidence | [Duolingo streaks and XP Reddit thread](https://www.reddit.com/r/duolingo/comments/xf0y5s/unpopular_opinion_streaks_and_xp_are/), [Offline translator travel Reddit thread](https://www.reddit.com/r/travel/comments/vdx722/translator_app_that_doesnt_need_internet/) | Directional user language: some learners value streaks/companions as motivation, while others resent fake progress; travelers ask for offline translation and need clear setup help. |

X was not used. Public X access is often gated/noisy, and the available evidence mix was already sufficient without bypassing login or rate limits.

No new YouTube digest was created. The existing onboarding video digest covers the main onboarding implication, and no single mascot-specific video looked likely to improve the decision enough to justify new transcript/frame artifacts.

Source-count note: the total unique public URL count in this report is 31.

## Findings

### 1. The repo already has the right instinct: keep the mascot small

SpeakLocal's source truth consistently frames Melo as a restrained travel companion, not the product itself. The key existing rules are: keep the mascot out of phrase reading, playback, search chrome, bottom chrome, monetization, and sensitive contexts; use it in Practice, completion/progress, and friendly empty states; tie visual progression to real phrase readiness rather than app opens, XP, or streaks.

That direction matches the public evidence. Utility apps win by making the task obvious. Learning/companion apps can support mascots, but only when the mascot is part of the learning relationship or product promise.

Confidence: high.

### 2. Premium iOS utility patterns argue for restraint

Apple's platform guidance repeatedly rewards purposeful motion, accurate screenshots, content-first app metadata, and accessibility support. Apple also treats reduced motion and motion sensitivity as first-class user preferences. The practical implication is that a constantly animated mascot would become design debt quickly: it adds motion states, accessibility variants, energy cost, layout risk, and screenshot truth requirements.

For SpeakLocal, this means:

- no mascot in persistent navigation or playback chrome;
- no mascot animation that must finish before the user can act;
- no mascot-only communication of readiness, error state, or unlock status;
- no App Store screenshots that make the product look mascot-first if the actual app is phrase-first.

Confidence: high.

### 3. Travel and translation competitors sell action, not character

Google Translate, Apple Translate, DeepL, and Microsoft Translator position around direct capabilities: offline language packs, camera translation, speech, conversation, phrasebook/favorites, and privacy/on-device modes. The public travel thread also shows the actual traveler job: users ask how to get offline language support working, not how to be entertained by the app.

SpeakLocal is not a general translator, but it sits closer to traveler utility than to a children's course app. The mascot should therefore help the user trust and rehearse actions, not decorate the primary utility surfaces.

Confidence: high.

### 4. Language apps show two viable paths: mascot-first game or serious practice

Duolingo is the clearest mascot success case. Duo is a brand asset, product character, streak motivator, and social-media system. Duolingo's own design writing shows that its characters are built as a coherent world around the owl. Its streak-writing shows that animation and mascot transformation can improve early retention, but also explicitly uses loss aversion and game-like celebration.

That is useful evidence, but not a direct model for SpeakLocal. SpeakLocal's goal is not "come back every day for lessons"; it is "be ready to say the right phrase while traveling." Competitors such as Rosetta Stone and Pimsleur sell confidence, audio, pronunciation, and offline lesson access with far less character weight. Drops and Ling use game/reward language, but their App Store positioning is more explicitly lesson-game oriented.

Confidence: high.

### 5. User evidence says gamification helps some people and annoys others

The Duolingo Reddit thread is mixed in a useful way. Some users say streaks keep them returning when they otherwise would stop. Others say XP, leagues, and streak-preservation can make them optimize for points instead of language progress. This matches the academic HCI evidence: gamification can support motivation, autonomy, and relatedness, but misuse can shift attention away from learning.

SpeakLocal should avoid importing XP, streak anxiety, leaderboards, lives, red-failure loops, or collectible-mascot pressure. If Melo tracks progress, it should track "ready phrase routes" and review queues tied to canonical phrase practice.

Confidence: medium-high.

### 6. Pedagogical agents can help, but only when they serve the task

Learning-science evidence is nuanced. Embodied agents can create a sense of social partnership and improve transfer in some contexts, while broader reviews warn that agents can become distracting or context-dependent. The safest interpretation for SpeakLocal is not "mascots teach better." It is "a small social cue can help users feel accompanied during practice when it is aligned with the learning task."

This supports Melo in Practice and completion, not on phrase pages where the user is reading, listening, comparing variants, or searching under travel pressure.

Confidence: medium-high.

### 7. Mascot-heavy paywalls are a bad fit for SpeakLocal

The utility-first onboarding packet already decided that users should hear and save a useful phrase before the 7-day trial ask, and that Melo should not appear inside paywall benefits. Public evidence reinforces this. App Store metadata must accurately reflect the app experience, premium utility competitors sell outcomes, and users are sensitive to subscription clarity.

Melo should not sell the trial, hold keys, block the user, cry, celebrate payment, or imply unlock pressure. If present at all near monetization, it should be absent or a tiny neutral brand mark outside the benefit list. Best default: no mascot on the paywall.

Confidence: high.

### 8. The app icon should not be mascot-first at launch

Apple's app-icon guidance emphasizes a memorable icon that fits platform shape and branding, but also cautions against using screenshots or standard UI as icons. Competitor evidence is split: Duolingo can use Duo because the owl is inseparable from the brand; translation and premium learning apps often use abstract marks, wordmarks, or utility symbols.

SpeakLocal has not yet proven that users understand Melo as the product. A mascot-first icon could make the app feel like a children's language game and undercut the premium travel phrasebook promise. The safer launch path is a SpeakLocal/Vietnam language-pack mark with optional tiny companion testing later.

Confidence: medium-high.

### 9. App Store screenshots can test one mascot moment, but should lead with utility

Apple says screenshots should show the app in use. For SpeakLocal, the first screenshots should show real travel value: phrase page, audio, offline readiness, search/browse, saved/practice flow, and a calm native interface. One later screenshot can include a Practice completion or route-readiness moment with Melo if the native screen exists and looks premium.

Do not lead the App Store gallery with a mascot illustration. Do not show Melo in screenshots if the shipped native flow does not include that actual surface.

Confidence: high.

## Evidence Table

| Signal | Source | Evidence | Product Meaning | Confidence |
| --- | --- | --- | --- | --- |
| Purposeful motion matters in iOS | [Apple HIG Motion](https://developer.apple.com/design/human-interface-guidelines/motion), [Reduce Motion support](https://support.apple.com/en-us/111781), [Reduced Motion criteria](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/reduced-motion-evaluation-criteria) | Apple frames motion as useful for feedback and status, but excessive motion can distract or cause discomfort; reduced-motion support may replace motion with fades/highlights. | Mascot animation must be brief, optional, and never the only information channel. | High |
| Custom visual effects have energy and performance cost | [iOS Energy Guide](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/AvoidExtraneousGraphicsAndAnimations.html) | Apple warns against unnecessary refreshes, opacity over changing content, and excessive animation. | Avoid always-on mascot loops, especially near Liquid Glass chrome and scroll-heavy phrase pages. | High |
| App Store screenshots must show the real app | [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), [App Store Connect screenshots](https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots) | Screenshots and previews should accurately reflect the core app experience and show the app in use. | Do not market SpeakLocal as mascot-first if the shipped app is phrase-first. | High |
| App icon should carry brand, not unproven character dependency | [Apple HIG App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons/) | Icon guidance stresses distinct brand identity and platform fit. | Test mascot icon later; do not make Melo the launch icon until recognition is proven. | Medium-high |
| Translation utilities emphasize offline, camera, speech, conversation, and phrasebook actions | [Google Translate App Store](https://apps.apple.com/us/app/google-translate/id414706506), [Google offline help](https://support.google.com/translate/answer/6142473?co=GENIE.Platform%3DiOS&hl=en-GB), [Apple Translate settings](https://support.apple.com/en-ie/guide/iphone/iphddb6e7264/ios), [DeepL mobile apps](https://www.deepl.com/en/mobile-apps), [Microsoft Translator apps](https://www.microsoft.com/en-us/translator/apps/) | Competitors sell task capability, offline readiness, camera/speech, favorites, and on-device/private modes. | SpeakLocal should lead with phrase/audio/offline readiness, not character. | High |
| Travelers need clear offline setup and trust | [Offline translator travel Reddit thread](https://www.reddit.com/r/travel/comments/vdx722/translator_app_that_doesnt_need_internet/) | Public thread centers on how to use offline translation and whether downloaded languages work. | Empty states and onboarding should explain offline readiness; mascot can soften only after task clarity. | Medium |
| Duolingo proves mascot power when the whole brand supports it | [Duolingo App Store](https://apps.apple.com/us/app/duolingo-language-chess/id570060128), [Duolingo character design](https://blog.duolingo.com/building-character/), [Axios on Duo brand moment](https://www.axios.com/2025/02/15/duolingo-mascot-dead-duo-owl-social-media-marketing) | Duo is deeply integrated into brand, lessons, retention, and social voice. | SpeakLocal can borrow character consistency, not mascot dominance. | High |
| Duolingo also shows the risk of retention mechanics | [Duolingo streak habit](https://blog.duolingo.com/how-duolingo-streak-builds-habit/), [Duolingo streak animation](https://blog.duolingo.com/streak-milestone-design-animation/) | Official posts connect streak animation and Duo transformations to habit, loss aversion, and celebratory game energy. | Avoid streak pressure and mascot-as-retention-guilt. Use readiness progress instead. | High |
| Public learners are divided on streaks and XP | [Duolingo Reddit thread](https://www.reddit.com/r/duolingo/comments/xf0y5s/unpopular_opinion_streaks_and_xp_are/) | Comments show both motivation benefits and frustration with XP farming/fake progress. | Do not use mascot as a points economy. Let users opt into calm practice. | Medium |
| Visual/game language is common in vocabulary apps | [Drops App Store](https://apps.apple.com/us/app/drops-language-learning-games/id939540371), [Ling App Store](https://apps.apple.com/us/app/language-learning-ling/id1403783779) | Drops and Ling lean on bite-size lessons, rewards, daily practice, cultural notes, native audio, and game-like language. | SpeakLocal can use tiny encouragement, but should not sound like a game-first course. | Medium-high |
| Serious language apps can sell confidence without mascots | [Rosetta Stone App Store](https://apps.apple.com/us/app/rosetta-stone-learn-languages/id435588892), [Pimsleur app](https://www.pimsleur.com/pimsleur-app/) | These apps emphasize speaking confidence, pronunciation, audio, progress, offline lessons, and practice tools. | Premium seriousness is viable; mascot is optional, not required for language credibility. | High |
| Companion-first apps work when the companion is the product | [Finch App Store](https://apps.apple.com/us/app/finch-self-care-pet/id1528595748) | Finch describes the companion as core to self-care and habit journeys. | Melo should not become central unless SpeakLocal intentionally pivots to companion-first. | Medium-high |
| Friendly illustration can be premium if it stays calm | [Headspace screenshot breakdown](https://appscreenmagic.com/top-screenshots/headspace) | Headspace-style friendly visuals can communicate warmth without displacing content. | Melo can soften Practice/empty states if its scale and tone stay quiet. | Medium |
| Gamification has small/contextual motivation effects | [Gamification meta-analysis](https://link.springer.com/article/10.1007/s11423-023-10337-7) | The meta-analysis found statistically significant but small effects and high heterogeneity. | Use gamified mascot cues sparingly and tie them to autonomy/competence/relatedness. | Medium-high |
| Gamification misuse can distract from learning | [Gamification misuse paper](https://arxiv.org/abs/2203.16175) | The paper identifies fixation on badges, points, and leaderboards as a risk in language-learning apps. | Reject XP, leaderboards, lives, coins, guilt, and mascot pressure. | High |
| Pedagogical agents can support social presence, but effects vary | [Frontiers pedagogical-agent review](https://www.frontiersin.org/articles/10.3389/fpsyg.2023.1205338/full), [Mayer and DaPra PubMed abstract](https://pubmed.ncbi.nlm.nih.gov/22642688/) | Agents can support motivation/social partnership, but reviews note heterogeneity and possible seductive-detail distraction. | Use Melo where social support helps Practice, not as decoration on every learning surface. | Medium-high |
| Existing SpeakLocal video digest supports utility before explanation | `docs/research/video-digests/onboarding-flows-1460-001/README.md` | Onboarding evidence favors first useful action over tours, heavy setup, and early paywalls. | Onboarding can show Melo only after phrase/audio value is visible. | High |

## Competitor Pain Points

- Translation utilities have strong capability but users still struggle with offline setup, trust, and knowing what will work without connectivity.
- Duolingo-style gamification motivates some users but can make others chase streaks, XP, or leaderboards instead of language progress.
- Companion-first apps create affection, but they also make the companion the product. That would be a different promise than a premium travel phrasebook.
- Premium language apps that avoid mascots can still feel credible by leaning on audio, pronunciation, offline lessons, confidence, and clear learning plans.
- App Store screenshots can over-promise if they show character art rather than shipped app behavior.

## SpeakLocal Opportunities

1. Own the middle ground: warmer than Google Translate, calmer and more traveler-specific than Duolingo.
2. Use Melo to make Practice feel less sterile without turning SpeakLocal into a game.
3. Tie mascot progression to real offline phrase readiness: source phrase practiced, review queue cleared, route mark earned.
4. Use no-mascot states as a premium signal in urgent/sensitive contexts.
5. Let App Store screenshots lead with phrase/audio/offline value, then optionally show one Practice companion moment.
6. Make mascot motion a polish layer after native Practice exists, not a prerequisite for the MVP.

## Role By Surface

| Surface | Recommendation | Rationale | Fold-In Class |
| --- | --- | --- | --- |
| Onboarding | Use sparingly after first phrase/audio value is visible. Melo can appear near setup or personalized preview, not as the narrator. | Existing onboarding research says utility before explanation; public utility apps lead with action. | Adopt now |
| Practice hub | Keep. This is Melo's primary home. One compact companion row/card tied to selected route or readiness. | Pedagogical-agent evidence is strongest when the agent supports the learning task. | Adopt now |
| Practice prompt | Use only as tiny eligible-prompt mark when sensitivity is standard and layout has room. Never inside answer targets. | Avoid distraction and false hierarchy; phrase answer remains the task. | Adopt now |
| Practice completion | Keep a compact route-readiness reveal. Use readiness copy, not game copy. | Completion is the best place for warm celebration without interrupting learning. | Design next |
| Progress/rewards | Keep only route marks and local readiness state tied to practiced source phrases. | Avoid gamification misuse and fake progress. | Adopt now |
| Empty states | Use gently for calm, low-risk states: no saved phrases, review queue clear, Practice ready. | Mascot can reduce coldness when no urgent task is being blocked. | Design next |
| Paywall/trial | Default no mascot. If used at all, tiny neutral brand mark outside benefit list. | Avoid conversion pressure, childish tone, and mascot-as-salesperson. | Remove/avoid |
| App icon | Do not use mascot-first icon at launch. Consider a tiny companion alternate icon later only after testing. | Character recognition is unproven; phrasebook should not look like a kids game. | Test later / Jojo decision |
| App Store screenshots | Lead with real phrase/audio/offline/search value. Use at most one later Practice screenshot with Melo if shipped. | Screenshots must show app in use and match actual product promise. | Test later |
| Phrase pages | No mascot decoration. Use phrase title, audio, variants, local guidance, and Add to Practice. | Phrase is hero; audio is action; mascot competes with reading. | Adopt now |
| Search | No mascot. Search should be fast, native, and low-friction. | Utility competitor evidence and native chrome direction both favor restraint. | Adopt now |
| Playback controls | No mascot. Speaker icon promises bundled audio. | Audio action must stay direct and trustworthy. | Adopt now |
| Bottom chrome | No mascot. | Persistent chrome should stay stable and native. | Adopt now |
| Sensitive scenarios | Hide mascot or reduce to neutral non-character mark. | Emergency, medical, police, harassment, safety, and high-stress content should preserve calm and seriousness. | Adopt now |

## Risks And Controls

| Risk | Severity | Control |
| --- | --- | --- |
| Childish tone | High | Keep Melo away from phrase pages, paywall, and app icon at launch; use premium 3D tactile direction only. |
| Clutter | High | One mascot surface per flow; never persistent chrome. |
| Animation/accessibility | High | Support Reduce Motion; no looping mascot; no animation-only meaning. |
| Cultural cliche | High | Use jade/sea-glass, subtle lotus/ceramic/lantern hints; avoid flag body paint, costumes, hats, stars, and country caricature. |
| Conversion harm | Medium-high | No mascot pressure on trial/paywall; test screenshot variants before mascot-heavy marketing. |
| Performance/design debt | Medium-high | Ship static or minimally animated assets first; avoid custom high-frequency animation until native performance is proven. |
| Fake progress | High | No XP, lives, coins, streak loss, or leaderboard; progress only from source-anchored phrase practice. |
| Brand confusion | Medium-high | App icon and first screenshots should communicate travel phrase utility before companion identity. |

## Mascot Animation Moments

Worth exploring later:

- Practice hub idle: one subtle breathing/blink loop, disabled under Reduce Motion.
- Correct standard prompt: small posture lift or route-mark glow, shorter than one second.
- Completion: compact jade/lantern warmth reveal tied to "route updated" copy.
- Empty state: still pose plus one optional micro-expression, no bounce loop.
- Review queue cleared: tiny relaxed state, no confetti.

Avoid:

- Mascot inside answer options, bottom chrome, playback dock, or search field.
- Mascot reacting to wrong answers in sensitive contexts.
- Crying, guilt, anger, threats, begging, or "you broke your streak" behavior.
- Coins, XP, lives, power-ups, leaderboard pressure, fire/flame streak language, or casino-style reward loops.
- Full-screen mascot animations before the user can act.
- Costumes, flag paint, tourist hats, or country caricature.

## Existing SpeakLocal Assets And Docs

| Asset / Doc | Keep, Revise, Or Discard | Note |
| --- | --- | --- |
| `docs/design/mascot/high-fidelity/assets/mascot-base-traveler.png` | Keep | Strongest base production direction. |
| `docs/design/mascot/high-fidelity/assets/mascot-early-vietnam-jade.png` | Keep | Best first Vietnam progression state. |
| `docs/design/mascot/high-fidelity/assets/mascot-mid-vietnam-motif.png` | Keep as direction | Good motif direction; production should stay subtle. |
| `docs/design/mascot/high-fidelity/assets/mascot-completion-lantern.png` | Revise before production | Useful, but ornament density risks collectible/game energy. |
| `docs/design/mascot/high-fidelity/assets/screen-practice-hub.png` | Keep as direction | Best native placement proof. |
| `docs/design/mascot/high-fidelity/assets/screen-normal-prompt.png` | Keep as spacing direction | Native implementation must preserve SF typography and source-authored copy. |
| `docs/design/mascot/high-fidelity/assets/screen-practice-completion.png` | Revise before production | Reduce visual weight and reward density. |
| `docs/design/mascot/high-fidelity/assets/screen-listing-add-to-practice.png` | Keep rule direction | Shows listing pages can stay phrase-first. |
| `docs/design/mascot/high-fidelity/assets/screen-sensitive-no-mascot.png` | Keep | Strong rule proof. |
| `docs/design/mascot/assets/**` | Discard for implementation | Keep only as process history. |
| `docs/design/mascot/mascot-visual-system.html` | Discard for implementation | Useful behavior notes, not a visual bar. |
| `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md` | Keep, then update only after Jojo approval | Its contract still matches this research. |
| `docs/design/onboarding/utility-first-trial-vietnam/README.md` | Keep | Already records correct Melo restraint. |

## Recommendations

### Product Recommendation

Keep Melo as a restrained companion, with a strict "Practice first, phrase never second" rule.

Melo should be treated as:

- a Practice companion;
- a route-readiness/progress receipt;
- a friendly empty-state accent;
- a future optional brand asset to test.

Melo should not be treated as:

- app narrator;
- paywall salesperson;
- persistent chrome;
- phrase-page character;
- app icon centerpiece at launch;
- game economy host;
- sensitive-context emotional character.

## Tests Before Mascot-Heavy Commitment

- First-run usability: compare utility-first onboarding with no mascot versus subtle setup/preview mascot; success metric is first useful phrase heard/saved before trial.
- Practice comprehension: test whether the tiny mascot mark helps users understand route readiness or distracts from answer choices.
- App Store positioning: compare first screenshot set with no mascot versus one later Practice/Melo screenshot; avoid a mascot-led first image unless it improves premium-travel comprehension.
- Icon recognition: compare brand/language-pack icon against subtle companion icon only after native Practice includes Melo.
- Accessibility/performance: verify Reduce Motion, VoiceOver labels, dynamic type, and no always-on animation cost before shipping motion-rich mascot states.

### Native UI / Simulator Handoff

Recommended next task: create `TASK-MASCOT-PRACTICE-NATIVE-SURFACE-001`.

Tiny prompt:

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family.
Read docs/research/mascot-role-001/README.md and docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md.
Design or implement the smallest native Practice surface that proves Melo as a restrained companion: Practice hub route card, eligible standard-prompt tiny mark, completion route update, and sensitive no-mascot state.
Do not put Melo in phrase pages, playback/search/bottom chrome, paywall, or sensitive prompts.
Commit when done and write the task result.
```

### Practice / Quiz Handoff

Keep reward state local and source-anchored. Use route marks, ready/review counts, and missed-review queues. Do not add XP, lives, coins, streak losses, leaderboards, or mascot guilt.

### Content + Listing Pages Handoff

No immediate task. Listing/phrase pages should keep Add to Practice but not add mascot explanation. If a future content task touches Practice entry copy, it can mention "Practice this phrase" rather than Melo.

### Tester / QA Handoff

Create acceptance checks after native implementation exists:

- mascot absent from urgent/sensitive phrase pages and prompts;
- mascot absent from playback/search/bottom chrome;
- Reduce Motion path removes or reduces mascot animation;
- VoiceOver/readability does not depend on mascot state;
- App Store screenshots reflect shipped screens.

## What Not To Do

- Do not remove the mascot entirely. The current high-fidelity direction has enough premium fit to keep testing.
- Do not make the mascot the app icon or first screenshot yet.
- Do not make Melo host the paywall, sell the trial, or express sadness/urgency around payment.
- Do not put mascot art on phrase pages to "add warmth." Warmth should come from useful local guidance and audio confidence.
- Do not use Duolingo as the direct model. Duolingo's mascot success is tied to a game-like brand, social voice, and retention mechanics that SpeakLocal should not copy wholesale.
- Do not treat the old HTML/SVG board as production quality.

## Open Questions

- Does Jojo want the app icon to remain language-pack/brand-first, or should a future task generate two alternate icon families for testing: no mascot versus subtle mascot?
- Should the first native Practice MVP include static mascot assets only, or one reduced-motion-aware micro-animation?
- What is the exact first "route mark" copy Jojo wants: "Vietnam route updated," "Ready for hotel desk," "Jade route mark unlocked," or another calmer phrase?
- Should App Store screenshots include Melo in the first launch submission, or hold all mascot marketing until after Practice is live?

## Fold-In Recommendation

Adopt the restrained mascot contract now: keep Melo as a Practice/progress/empty-state companion, remove it from utility chrome, paywall, phrase-reading, and sensitive contexts, and require a native Practice proof before any mascot-heavy brand or App Store commitment.

## Fold-In Options

### Adopt Now

- Formalize the rule: mascot as Practice companion, not product narrator.
- Keep mascot out of phrase pages, search, playback controls, bottom chrome, paywall/trial benefits, and sensitive contexts.
- Keep progress mascot states tied only to source-anchored Practice readiness.
- Use high-fidelity base/early-jade assets as the current visual direction.
- Keep utility-first onboarding with Melo subtle only after phrase/audio value is visible.

### Create Task Card

- Native UI / Simulator: `TASK-MASCOT-PRACTICE-NATIVE-SURFACE-001` for a small native Practice proof.
- Native UI / Simulator or Design: `TASK-MASCOT-ICON-SCREENSHOT-TEST-001` to generate and compare app icon/App Store screenshot variants after Practice exists.
- Tester / QA: mascot surface audit once native implementation begins.

### Hold For Later

- Mascot-first App Store screenshot.
- Mascot alternate app icon.
- Destination-specific mascot progression beyond Vietnam jade/motif/completion.
- Motion-rich mascot animation.
- Mascot-guided onboarding.

### Reject

- Mascot in phrase-reading surfaces.
- Mascot in playback, search, or bottom chrome.
- Mascot as paywall host or trial salesperson.
- XP, coins, lives, streak pressure, leaderboards, guilt, or threat humor.
- Cultural costume/cliche treatments.
- Full-screen mascot animation that delays user action.

### Needs Jojo Decision

- Whether to approve the "no mascot-first app icon at launch" recommendation.
- Whether the first App Store screenshot set should include one Practice/Melo screen or no mascot at all.
- Whether the native Practice proof should use static PNGs only or include a single reduced-motion-aware micro-animation.
- Which route-readiness copy phrase should become the canonical tone target.

## Peer Review

Completed 2026-05-02 as a focused read-only review for evidence quality, iOS taste, actionability, overreach, required sections, source-count clarity, and fold-in clarity.

Reviewer outcome: CONCERNS, addressed before closeout.

Required reviewer fixes addressed:

- Reconciled source-count wording by naming the 31 unique public URLs and why this pass exceeded the rough source target.
- Added the exact `Fold-In Recommendation` section while preserving the lane's `Fold-In Options` taxonomy.
- Replaced the pending peer-review note with this review summary.

Optional reviewer improvements addressed:

- Added `Tests Before Mascot-Heavy Commitment`.
- Clarified that Pimsleur is used as a premium serious-language comparator, not a translation utility.

Residual risk: this report links current public evidence and records access date, but it does not archive external pages or screenshots. Future implementation tasks should re-check App Store pages before using specific screenshots or claims in launch assets.

## Folded Into

Pending Jojo/orchestrator review. No product code, app resources, task cards, or source-truth docs have been changed from this research yet.

This report itself is the folded research artifact for:

- `docs/research/mascot-role-001/README.md`
- `docs/task-results/TASK-MASCOT-RD-ROLE-001.md`
