# Practice Travel Stories

This is the product contract for Practice / Scenario Mode.

Practice should feel like short guided Travel Stories for adult travelers. It should not feel like a quiz, language test, score screen, or generic saved-phrase review.

## Product Frame

- Keep the tab name `Practice`.
- Use `Travel Stories` inside the Practice surface.
- A story is a short second-person travel path: the user moves through real moments they may hit in Vietnam.
- Use story structure to give phrases context. Do not add long fictional chapters.
- The mascot may act as a light guide, but the traveler in the story is the user.

Preferred:

> You have just landed in Da Nang. First, find baggage claim.

Avoid:

> Alex lands in Da Nang.

## Tone

- Adult traveler.
- Calm, simple, useful.
- Beginner-friendly by default.
- Audio-first and low cognitive load.
- No childish game copy.
- No grammar lesson unless the user explicitly enters an advanced layer.

## User-Facing Terms

Use:

- Travel Stories
- Story
- Moment
- You hear
- Say this
- Best quick reply
- More ways to say it
- If unsure
- What do you want to do?
- Continue
- Next moment
- Finish story
- Story complete
- Saved from this story

Avoid:

- quiz
- answer
- correct
- wrong
- missed
- score
- check fit
- good fit
- source page
- phrase pages
- reply options
- review missed

## Story Cards

Story cards must show the travel path, not internal stats.

Do not show confusing count boxes such as:

- `2 steps`
- `4 saved`
- `1 follow-up`

Use journey chips instead:

- `Airport`
- `Ride`
- `Hotel`
- `Food`

Example:

```text
First day in Da Nang
Land, get a ride, check in, and order your first meal.
Airport · Ride · Hotel · Food
Start story
```

## Moment Types

Every story moment should be one of:

- `ask`: the traveler needs to say or play a phrase.
- `listen`: a local/staff/driver may say something, then the traveler replies.
- `recovery`: something is unclear or wrong; the user needs a safe fallback.

Keep each moment small:

- one scene line
- one primary phrase or one short choice prompt
- up to two alternatives
- one optional fallback
- one short tip only when it adds real travel value

## Levels

Support levels in the model, but default new users to Level 1.

Level 1: Survival

- simplest path
- few choices
- short phrases
- no grammar explanation
- no pronoun nuance unless necessary

Level 2: Choose your path

- user chooses what they want to do
- two to four choices per branch
- good for restaurants, shopping, taxi, and city-day stories

Level 3: Local polish

- optional advanced layer
- softer phrasing, relationship terms, local variants
- hidden by default for beginners

## Phrase Strategy

Stories must reuse existing phrase/listing pages whenever possible.

For each story phrase:

1. Search exact Vietnamese.
2. Search normalized Vietnamese.
3. Search English equivalent.
4. Search aliases and phrase families.
5. Reuse an existing phrase ID when it fits.
6. If missing, create a normal phrase page.
7. Mark missing audio as `NEEDS_AUDIO`.
8. Mark uncertain Vietnamese as `NEEDS_NATIVE_REVIEW`.

Do not create hidden scenario-only phrases. Practice should help expose the breadth of the phrase catalog, not fork a separate content universe.

Scenario phrases may be shorter than listing-page phrases when story context already carries the setup.

Example:

- Listing phrase: `Here is my passport for check-in.`
- Story phrase: `Here is my passport.`

The goal is not the shortest phrase. The goal is the shortest natural playable phrase for that moment.

## First Shipped Stories

The first three Travel Stories are:

1. `First day in Da Nang`
   - Path: `Airport · Ride · Hotel · Food`
   - Guided story from arrival to first meal.
2. `At the hotel`
   - Path: `Booking · Passport · Wi-Fi · Room help`
   - Guided hotel desk and room-basics story.
3. `Da Nang day`
   - Path: `Beach · Food · Photo · Ride back`
   - Guided city-day story.

Next likely pilot:

- `Restaurant ordering`
- Path: `Table · Menu · Order · Pay`
- This should be the first branching `choose your path` story.

## Acceptance

Before shipping Practice changes, render and inspect:

- Practice / Travel Stories home
- First day in Da Nang moment 1
- At the hotel moment 1
- Da Nang day moment 1
- Story complete

Pass only if:

- it feels like a guided travel story
- it does not feel like a quiz
- story cards show paths, not stats
- no user first names
- no right/wrong or score language
- visible copy is short
- primary CTA is reachable without long scrolling
- phrase IDs resolve through the catalog instead of hidden scenario-only data
