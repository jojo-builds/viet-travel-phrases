# Chameleon Style Options

Status: locked Speak Global chameleon direction, with Vietnam as the first country-route implementation
Last updated: 2026-04-29

## Local Review

From the repo root:

```bash
python3 -m http.server 8787
```

Open:

```text
http://127.0.0.1:8787/docs/design/mascot/chameleon-style-options/index.html
```

## Global Brand Principle

Melo is the Speak Global mascot, not a Vietnam mascot.

The chameleon travels country to country to learn different languages. The base character name, silhouette, face, and personality must stay stable across Vietnam, Japan, the Philippines, Italy, and future language packs. Each country can add its own route colors, motifs, city routes, and pronunciation challenges, but those are unlock layers rather than the mascot's identity.

Core naming should therefore be global:

- Mascot: **Melo**
- Global progress unit: **Route Mark** or **Passport Mark**
- Global route surface: **Passport Map**
- Country layer example: **Vietnam Route**
- City layer example: **Hanoi Route**
- Vietnamese lesson term: **dấu** for tone marks, inside pronunciation lessons only

Do not use a Vietnamese word as the permanent mascot name or global progress unit.

## Why This Pass Exists

The prior video-informed board moved the mascot from static art toward a product system, but the visual treatment still leaned too much toward a soft 3D object. That solved the "do not scare people with a realistic lizard" problem, but it also drifted into plush doll territory.

The transcript and Dribbble pass point to a different target: a brandable app mascot with a strong silhouette, simple expression, clean shape language, repeatable poses, and tiny in-product use cases. The mascot should feel like part of a native app, not a physical collectible photographed for a product page.

## How The Referenced Prompting Differed

The videos' mascot prompts differed from our first prompts in five important ways:

- They start with a base character or reference image, then riff from it. Our first prompts asked the model to invent the final production style from a large written brief.
- They make one or two changes per iteration. Our prompts carried many constraints at once: premium, non-scary, not childish, travel, Vietnam progression, no game rewards, and 3D material polish.
- They protect style consistency by restarting or returning to the base when drift appears. Our first pass let each generated screen reinterpret the mascot.
- They use the mascot in concrete app jobs: empty states, onboarding, small feedback moments, widgets, and animation states. Our first pass focused more on beautiful static renders.
- They optimize for motion-ready character systems. Our first pass optimized for polished still images.

## What Was Folded Into This Direction

- Keep the chameleon as the product metaphor: the user practices, the chameleon becomes more locally attuned.
- Make the character app-native: flatter, graphic, readable at small sizes, easy to animate.
- Treat country-route progression as pattern/color growth, not costume or flag paint. Vietnam is the first route layer.
- Use the mascot only where it helps: Practice hub, empty Practice, route updates, and tiny progress marks.
- Keep phrase reading, search, bottom chrome, and sensitive contexts mostly mascot-free.

## Locked Direction

The selected direction is:

1. **Mascot name:** Melo
2. **Mascot style:** Flat Brand Chameleon
3. **Progression language:** six-stage country-route camouflage
4. **Route product model:** country routes, city routes, and street-name pronunciation drills
5. **Progress surface:** Passport Map showing where Melo has been and where Melo still needs to go

Keep **Soft 2.5D Chameleon** only as a backup if the flat mascot later feels too cold.

## Unlock Scale

The first progression pass was directionally correct but too quiet for route unlocks. The updated rule is:

- early progress should be subtle, so the mascot does not distract from Practice
- route completion should be visibly different at thumbnail size
- drama comes from color saturation, pattern coverage, posture confidence, and a soft route glow
- the base silhouette, face, eye shape, smile, and tail stay stable
- the final state reads as local attunement, not costume or flag paint

The locked six stages are:

1. Base
2. First phrases
3. Local rhythm
4. Traveler confidence
5. Vietnam attuned
6. Fully unlocked

## Route And Street-Name Practice

The route system should become more place-aware while staying global. At the global level, users unlock country routes. Inside each country, they unlock city routes and optional street-name packs.

Vietnam practice can include city routes and street-name packs so travelers learn names they will actually see on maps, signs, receipts, and ride-hailing screens.

Recommended practice formats:

- listen and choose the street name
- repair missing tone marks
- match a street sign to audio
- say a taxi phrase using the destination
- compare city pronunciation variants when useful

Recommended progression surface:

- Passport Map with visited, in-progress, and locked country/city route nodes
- completed city route preserves the fully unlocked Melo state
- in-progress route shows partial coloration
- locked route shows the neutral silhouette

## Name Research

The strongest permanent mascot name is **Melo** because it is global.

Rationale:

- short, friendly, and easy for English-speaking travelers
- echoes chameleon without spelling out "chameleon"
- hints at melody, voice, and pronunciation
- travels across future languages better than a Vietnam-only name
- avoids making Vietnamese diacritics part of the character name itself

Vietnamese terms are still useful inside the Vietnam route, but they should not name the global mascot or global progress unit:

- **tắc kè hoa** is the Vietnamese word for chameleon.
- **dấu** works well for tone-mark practice and pronunciation lessons.
- **đốm** works as a local nickname or pattern note because it means spot/speckle.
- **màu** means color, but it is less name-like for a mascot.

Recommended naming system:

- Mascot: **Melo**
- Global unlock/progress unit: **Route Mark** or **Passport Mark**
- Global progress surface: **Passport Map**
- Vietnam-specific lesson term: **dấu** for tone marks
- Vietnam route completion example: **Melo completed the Hanoi Route**

## Assets

- `assets/chameleon-style-six-options.png`
- `assets/chameleon-flat-progression.png`
- `assets/chameleon-soft-2-5d-progression.png`
- `assets/chameleon-in-app-context.png`
- `assets/flat-brand-dramatic-unlock-ladder.png`
- `assets/flat-brand-unlock-in-app.png`

## Next Art Step

Create a locked Melo base sheet:

- front, three-quarter, side, tiny icon size
- idle, listening, correct, gentle correction, route updated
- base plus six global progression stages
- Vietnam route layer as the first concrete country variant
- transparent PNG/WebP export with consistent canvas and anchor point

After that, use the locked base as the reference for every future prompt or commissioned illustration.

## Next Product Step

Create a global route practice design packet:

- Passport Map structure for country and city routes
- Vietnam city route structure as the first implementation
- street-name content model
- proper-noun audio queue requirements
- quiz state types for pronunciation and tone marks
- map UI states for visited, in-progress, locked, and completed
- static asset handoff for Melo route states

## Research References

- Wiktionary documents `tắc kè hoa` as "a chameleon": https://en.wiktionary.org/wiki/t%E1%BA%AFc_k%C3%A8_hoa
- VDict notes `tắc kè hoa` as a Vietnamese term for chameleon: https://vdict.com/t%E1%BA%AFc%20k%C3%A8%2C2%2C0%2C0.html
- MSU Basic Vietnamese describes Vietnamese as having six tones and five tone marks, and notes `Dấu` means marks: https://openbooks.lib.msu.edu/vietnamese/chapter/section-2-tone-and-tone-marks/
- VDict defines `đốm` as a spot, dot, or speck: https://vdict.com/%C4%91%E1%BB%91m%2C2%2C0%2C0.html
- Wiktionary gives `màu` as color/hue: https://en.wiktionary.org/wiki/m%C3%A0u
