# Chameleon Style Options

Status: locked Speak Local chameleon direction, with Vietnam as the first country implementation
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

## Shared Brand Principle

Melo is the Speak Local mascot, not a Vietnam mascot.

The chameleon travels country to country to learn different languages. The base character name, silhouette, face, and personality must stay stable across Vietnam, Japan, the Philippines, Italy, and future language packs. Each country can add its own colors, motifs, city bucket-list entries, and pronunciation challenges, but those are unlock layers rather than the mascot's identity.

Core naming should stay cross-country:

- Mascot: **Melo**
- Travel progress unit: **Bucket List Stamp**
- Travel progress surface: **Bucket List Map**
- Country layer example: **Vietnam Bucket List**
- City layer example: **Hanoi Bucket List**
- Vietnamese lesson term: **dấu** for tone marks, inside pronunciation lessons only

Do not use a Vietnamese word as the permanent mascot name or travel progress unit.

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
- Treat country progression as pattern/color growth, not costume or flag paint. Vietnam is the first country layer.
- Use the mascot only where it helps: Practice hub, empty Practice, bucket-list updates, and tiny Bucket List Stamps.
- Keep phrase reading, search, bottom chrome, and sensitive contexts mostly mascot-free.

## Locked Direction

The selected direction is:

1. **Mascot name:** Melo
2. **Mascot style:** Flat Brand Chameleon
3. **Progression language:** neutral base plus six shared country unlock stages
4. **Bucket List product model:** country bucket lists, city bucket lists, and street-name pronunciation drills
5. **Progress surface:** Bucket List Map showing where Melo has been and where Melo still needs to go

Keep **Soft 2.5D Chameleon** only as a backup if the flat mascot later feels too cold.

## Unlock Scale

The first progression pass was directionally correct but too quiet for bucket-list unlocks. The updated rule is:

- early progress should be subtle, so the mascot does not distract from Practice
- bucket-list completion should be visibly different at thumbnail size
- drama comes from color saturation, pattern coverage, posture confidence, and a soft travel glow
- the base silhouette, face, eye shape, smile, and tail stay stable
- the final state reads as local attunement, not costume or flag paint

The locked production stages are:

1. Base
2. First phrases
3. City rhythm
4. Traveler confidence
5. Street ready
6. Vietnam attuned
7. Fully unlocked

## Bucket List And Street-Name Practice

The Bucket List system should become more place-aware while staying cross-country. At the top level, users add or complete country bucket lists. Inside each country, they complete city bucket lists and optional street-name packs.

Vietnam practice can include city bucket lists and street-name packs so travelers learn names they will actually see on maps, signs, receipts, and ride-hailing screens.

Recommended practice formats:

- listen and choose the street name
- repair missing tone marks
- match a street sign to audio
- say a taxi phrase using the destination
- compare city pronunciation variants when useful

Recommended progression surface:

- Bucket List Map with visited, in-progress, and locked country/city nodes
- completed city bucket list preserves the fully unlocked Melo state
- in-progress city bucket list shows partial coloration
- locked city bucket list shows the neutral silhouette

## Name Research

The strongest permanent mascot name is **Melo** because it travels well across countries.

Rationale:

- short, friendly, and easy for English-speaking travelers
- echoes chameleon without spelling out "chameleon"
- hints at melody, voice, and pronunciation
- travels across future languages better than a Vietnam-only name
- avoids making Vietnamese diacritics part of the character name itself

Vietnamese terms are still useful inside the Vietnam Bucket List, but they should not name the shared mascot or travel progress unit:

- **tắc kè hoa** is the Vietnamese word for chameleon.
- **dấu** works well for tone-mark practice and pronunciation lessons.
- **đốm** works as a local nickname or pattern note because it means spot/speckle.
- **màu** means color, but it is less name-like for a mascot.

Recommended naming system:

- Mascot: **Melo**
- Unlock/progress unit: **Bucket List Stamp**
- Progress surface: **Bucket List Map**
- Vietnam-specific lesson term: **dấu** for tone marks
- Vietnam bucket-list completion example: **Melo completed the Hanoi Bucket List**

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
- idle, listening, correct, gentle correction, bucket list updated
- neutral base plus six shared unlock stages
- Vietnam country layer as the first concrete country variant
- transparent PNG/WebP export with consistent canvas and anchor point

After that, use the locked base as the reference for every future prompt or commissioned illustration.

## Next Product Step

Create a Bucket List practice design packet:

- Bucket List Map structure for country and city bucket-list entries
- Vietnam city bucket-list structure as the first implementation
- street-name content model
- proper-noun audio queue requirements
- quiz state types for pronunciation and tone marks
- map UI states for visited, in-progress, locked, and completed
- static asset handoff for Melo bucket-list states

## Research References

- Wiktionary documents `tắc kè hoa` as "a chameleon": https://en.wiktionary.org/wiki/t%E1%BA%AFc_k%C3%A8_hoa
- VDict notes `tắc kè hoa` as a Vietnamese term for chameleon: https://vdict.com/t%E1%BA%AFc%20k%C3%A8%2C2%2C0%2C0.html
- MSU Basic Vietnamese describes Vietnamese as having six tones and five tone marks, and notes `Dấu` means marks: https://openbooks.lib.msu.edu/vietnamese/chapter/section-2-tone-and-tone-marks/
- VDict defines `đốm` as a spot, dot, or speck: https://vdict.com/%C4%91%E1%BB%91m%2C2%2C0%2C0.html
- Wiktionary gives `màu` as color/hue: https://en.wiktionary.org/wiki/m%C3%A0u
