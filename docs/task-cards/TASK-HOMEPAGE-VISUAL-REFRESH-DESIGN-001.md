# TASK-HOMEPAGE-VISUAL-REFRESH-DESIGN-001

## Task Done
Create a production-quality visual design packet for a SpeakLocal Vietnam homepage refresh that makes the current homepage feel cleaner, more native iOS, more image-rich, and easier for a first-time traveler to tap through.

The finished packet must give Jojo multiple concrete homepage directions to review before native implementation. It should reduce the current card clutter, clarify the audio/icon hierarchy, and show how category/city image cards can become useful entry points without making the homepage feel busy.

## Context
The current homepage structure is useful, but the visual design feels messy. Some phrase cards show two icons at once, which makes it unclear what is decorative, what plays audio, and what opens the page. The homepage needs a facelift, not a full product reset.

Current product direction:
- Native iOS 26 / Liquid Glass feel.
- Calm premium travel utility, not a cartoon-heavy language game.
- The phrase is the content; audio is the action; images should guide exploration.
- The app is offline-first and should feel fast.
- The homepage should help users continue, practice, browse, and discover useful travel phrases without overwhelming them.

Useful references to read before designing:
- `/Users/jojolim/Developer/products/speaklocal/app-family/docs/design/homepage-research/README.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/docs/design/browse-search/README.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/docs/design/category-pages/README.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/docs/design/reference-shots/2026-05-01/README.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/docs/task-results/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001.md`

Relevant native image assets exist under:
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/Resources/Assets.xcassets/BrowseCollectionAirport.imageset`
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/Resources/Assets.xcassets/BrowseCollectionFood.imageset`
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/Resources/Assets.xcassets/BrowseCollectionHanoi.imageset`
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/Resources/Assets.xcassets/BrowseCollectionHotel.imageset`
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/Resources/Assets.xcassets/BrowseCollectionShopping.imageset`
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/Resources/Assets.xcassets/HeroVietnamMasthead.imageset`

## Worker Judgment
Use GPT-5.5 product and visual judgment. Do not treat this as a mechanical mockup task.

Before producing the final packet, ask Jojo any clarifying questions needed and show a short plan. If Jojo steers the plan, record the accepted steer in the final result.

Think through:
- whether saved/practice/use-now/travel/category/city sections should stay separate or be visually grouped;
- whether phrase cards need one clear audio affordance plus a separate navigation affordance;
- where image-led cards help exploration instead of adding noise;
- how the homepage should relate to Browse, Search, category pages, city pages, and Practice;
- how to keep the bottom chrome readable and the first screen immediately useful.

## Required Outcome
Create a durable visual packet under:

`/Users/jojolim/Developer/products/speaklocal/app-family/docs/design/homepage/visual-refresh-v1/`

Include:
- `README.md` with the recommendation, design rationale, tradeoffs, and implementation notes.
- `index.html` review gallery that opens cleanly in the in-app browser.
- `prompt-packet.md` with the final image/design prompts or design-system instructions used.
- High-resolution PNG storyboard sheets or screen images.
- At least one clear image showing the current homepage issue and how the redesign resolves it.

Produce at least three homepage directions:
1. Conservative native refresh: keep the current section logic, but clean up card structure, spacing, hierarchy, and audio/navigation affordances.
2. Image-led travel gateway: use category/city image cards as strong entry points mixed with phrase rails.
3. Personalized utility home: emphasize saved phrases, practice pool, recent use, city focus, and beginner-friendly next actions without clutter.

For each direction, show:
- top-of-home first viewport;
- mid-page section behavior;
- lower section / bottom chrome interaction;
- how phrase cards, image category cards, and city cards navigate;
- how audio buttons are represented without confusing double-icon cards.

The final recommendation should name one direction or hybrid direction to implement first.

## Boundaries
- Work only in `/Users/jojolim/Developer/products/speaklocal/app-family`.
- This is a design artifact task only.
- Do not edit Swift files, SQLite files, generated content resources, audio assets, or Xcode project files.
- Do not implement the homepage in native code in this task.
- Do not create placeholder copy. Use real SpeakLocal phrase/category/city labels already present in the app.
- Do not make the mascot prominent unless it directly improves homepage clarity and stays restrained.

## Validation
- Open the gallery locally and verify all images render.
- Verify referenced native image assets exist.
- Run `git diff --check`.
- Use one focused peer review before committing. The reviewer should check:
  - first-time traveler clarity;
  - iOS/Liquid Glass fit;
  - reduced visual clutter;
  - clear audio versus navigation behavior;
  - whether the design can realistically become native SwiftUI.

## Result Contract
Write the result to:

`/Users/jojolim/Developer/products/speaklocal/app-family/docs/task-results/TASK-HOMEPAGE-VISUAL-REFRESH-DESIGN-001.md`

Include:
- status;
- commit hash;
- design packet path;
- gallery path;
- included screens/assets;
- recommended direction;
- how the design handles category/city image cards;
- how the design handles phrase card audio/navigation hierarchy;
- peer review summary;
- validation run;
- implementation follow-up task suggestions.

Commit the design packet and result when done.
