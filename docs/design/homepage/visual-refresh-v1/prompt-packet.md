# Homepage Visual Refresh Prompt Packet

This packet was produced as native-style composed mockups using current SpeakLocal screenshots, existing asset-catalog imagery, and local raster composition. These instructions are the reusable design prompt for future iterations or commissioned visuals.

## Source-Of-Truth Inputs

- Read `docs/design/NATIVE_VISUAL_REFERENCE.md` first.
- Use the locked 2026-05-01 Home/admin/search chrome references as the visual baseline.
- Use existing native imagery from `native-ios/Resources/Assets.xcassets`.
- Match the current SpeakLocal Vietnam feel: native iOS, Liquid Glass, large serif page title, soft white content surfaces, restrained Vietnam red/green/gold accents.

## Product Direction

Design the SpeakLocal Vietnam Home screen as a premium travel phrase utility, not a course dashboard and not a mascot-led game. The first viewport should answer: “What can I tap right now to say something useful in Vietnam?”

Recommended first-launch hierarchy:

1. Vietnam masthead and `SPEAKLOCAL VIETNAM` identity.
2. `Start speaking now`.
3. Search card: `What do you need to say?`
4. `Start with essentials` phrase cards.
5. Image-led discovery cards for Hanoi and high-value categories.
6. Lower shelves for travel situations, relationship greetings, useful phrase pages, and Browse all.

## Visual Rules

- Keep the bottom Home/admin dock and separate Search island stable.
- Use clean white or near-white Liquid Glass cards.
- Avoid crowded card stacks, loud gradients, and decorative blobs.
- Use red only for primary actions and audio.
- Use real or hyper-real category/city imagery, not abstract illustration.
- Do not make Melo prominent on Home.

## Phrase Card Rule

One phrase card must have one clear audio affordance and one clear navigation affordance:

- Red speaker button: plays bundled audio.
- Card body/title plus chevron: opens the canonical phrase page.
- Small label chip: category/status only, not a control.
- Avoid placing a decorative icon next to the real speaker button.

## Direction Prompts

### Conservative Native Refresh

Create a high-fidelity iPhone Home storyboard for SpeakLocal Vietnam. Keep the existing section logic, but clean the card hierarchy, spacing, and icon usage. Show top of Home, mid-page travel situations, and lower Home with bottom chrome. Phrase cards should have a small label chip, one red audio button, title/subtitle text, and a chevron.

### Image-Led Travel Gateway

Create a high-fidelity iPhone Home storyboard where real image cards help users choose Hanoi, Hotel, Airport, Food, and Shopping Browse collections. The first viewport still has Search and useful phrases nearby. Image cards navigate to Browse collection pages; phrase cards remain the only cards with audio buttons.

### Personalized Utility Home

Create a high-fidelity iPhone Home storyboard showing how the screen adapts after real local state exists. Include Continue, Saved for trip, Practice pool, and a city-focused `For your Hanoi arrival` shelf. Make clear these modules are state-gated and should not appear empty on first launch.

## Final Recommendation Prompt

Design the recommended Hybrid Utility Home: Direction 1 structure, Direction 2 image cards below essentials, and Direction 3 personalized modules only after real saved/recent/practice state exists.
