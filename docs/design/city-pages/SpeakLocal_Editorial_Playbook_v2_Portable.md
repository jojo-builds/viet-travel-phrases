# SpeakLocal Editorial Playbook v2

## Purpose

This playbook is designed to work in a fresh ChatGPT or Codex session when paired with the 16 SpeakLocal example entries. It defines the editorial target, the mobile copy shape, the evidence rules, the scoring rubric, and the handoff prompt for editing existing listings or generating new ones.

The goal is not to create travel-blog copy. The goal is to create **evidence-backed traveler briefings**: short, specific, confidence-building notes that help a first-time traveler understand what to expect, what to do first, what to ask, and why the place is worth their attention.

SpeakLocal should feel like a well-traveled friend answering:

> “What should I know about this place before I go?”

Not:

> “Write a nice destination description.”

---

## 1. Core Product Definition

SpeakLocal is **travel confidence infrastructure**.

The user is usually:

- U.S.-based or English-first.
- Already planning or imagining a trip.
- Excited, but slightly uncertain.
- Not trying to study the language deeply.
- Trying to feel more locally aware before arrival.
- Looking for small, usable language wins.
- Sensitive to generic AI travel copy.

The page should help them:

- Understand why the place matters.
- Picture the experience before arriving.
- Make one smarter decision.
- Avoid an awkward or disappointing first move.
- Learn a few phrases they can actually use there.

The best SpeakLocal copy is **specific, calm, useful, and lightly emotional**.

---

## 2. The Voice Rule

### The first heading must be a traveler-use cue.

The first heading should tell the traveler how to use the place before they read the body.

Good examples:

- **The Food-First Market**
- **Confirm The Set First**
- **Walk Once Before Sitting**
- **Choose Dry Or Close**
- **Go When The Tide Helps**
- **Know You Are Choosing A Theme Park**
- **The Original Egg Coffee Stop**

Weak examples:

- **The Vibe**
- **Why This Works**
- **A Hidden Gem**
- **A Local Favorite**
- **A Vibrant Experience**
- **A Place To Remember**

A good heading is not decorative. It carries decision value.

---

## 3. The SpeakLocal Tone

### SpeakLocal sounds like:

- A calm, experienced traveler.
- A practical friend with good taste.
- Someone who notices real details.
- Someone who can be honest without being cynical.
- Someone who wants the user to enjoy the place, not just consume information.

### SpeakLocal does not sound like:

- A tourism board.
- A generic city guide.
- A restaurant review site.
- A Wikipedia entry.
- A luxury lifestyle magazine.
- A travel influencer caption.
- A chatbot trying to sound poetic.

### The emotional balance

Each entry should usually include:

1. **One grounding truth** — what the place really is.
2. **One emotional reason to care** — why it can still feel memorable.
3. **One practical move** — what the traveler should do first.

Example:

> Ba Na Hills is a theme park, not a quiet mountain escape. But if you go early and the weather opens, the cable-car ride and Golden Bridge can still feel cinematic. Do the bridge first, then decide how much of the park you actually want.

This is the tone: honest, but still generous.

---

## 4. The Main Failure Mode: Replaceable Copy

The biggest problem is not “bad writing.” It is **replaceable writing**.

Fail the copy if it could fit another place by swapping the name.

Bad:

> This vibrant market offers a wide range of local foods, souvenirs, and cultural experiences.

Better:

> Hàn Market gives you a quick read on central Đà Nẵng: jars of mắm, stacks of dried squid, fabric stalls, rattan bags, and breakfast bowls all under one roof.

The second version has evidence density. It could not easily belong to any market in any city.

---

## 5. Evidence-First Workflow

Do not ask the model to discover truth and write polished copy in the same pass.

Use a two-stage process.

### Stage 1: Evidence extraction

Collect concrete details before writing.

Extract:

- Current status: open, closed, uncertain, needs verification.
- Location and role in the city.
- What the place is actually known for.
- Signature items, dishes, experiences, or features.
- Timing cues: morning, sunset, weekend, low tide, showtime, rush hour.
- Traveler risks: crowds, unclear pricing, heat, weather, closures, tourist traps.
- Review patterns, not single random reviews.
- Neighborhood context.
- Phrase opportunities tied to real tasks.

### Stage 2: Traveler briefing synthesis

Write from the evidence bundle only.

Do not invent:

- Hours.
- Prices.
- Signature dishes.
- Closure status.
- Schedules.
- Safety claims.
- Awards.
- Neighborhood claims.

If evidence conflicts, flag it instead of smoothing it away.

---

## 6. Source and Verification Rules

### Use source classes in this order

1. Official source: venue site, tourism board, official government/tourism page.
2. Current operational source: official social media, booking page, recent menu, Google Maps live status if available.
3. Reputable editorial source: established travel publication, local guide, newspaper.
4. Review pattern source: Tripadvisor, Google reviews, travel forums, not one-off anecdotes.

### Always verify before publication

Recheck anything that can change:

- Opening hours.
- Branch status.
- Address.
- Ticket prices.
- Menus.
- Show schedules.
- Tour availability.
- Closures or renovations.
- Transit routes.
- Seasonal access.

If status is unclear, return:

```json
{
  "status": "needs_verification",
  "status_issue": "Explain the conflict or missing data clearly."
}
```

Do not write normal app copy for a venue that may be closed.

---

## 7. Source Notes Policy

Source notes are for internal use.

They are useful for:

- Editors.
- Codex.
- QA.
- Regeneration.
- Audits.
- Future updates.

They should not appear inside the normal app experience.

The app should feel effortlessly informed, not researched.

---

## 8. Standard Entry Shape

For internal gold-standard examples, use this structure:

```markdown
## Listing Name - City - Category

### Source notes
- Concrete source-backed detail.
- Concrete source-backed detail.
- Uncertainty or verification detail, if relevant.

### Why go
**Traveler-Use Heading**
2-3 short sentences.

### What it feels like
**Specific Heading**
2-3 short sentences.

### What to do / order / try first
**Action Heading**
2-3 short sentences.

### Best moment
**Timing Heading**
1-2 short sentences.

### Nearby context
**Context Heading**
1-2 short sentences.

### Useful phrases
- **"Vietnamese phrase."** - English meaning.
- **"Vietnamese phrase."** - English meaning.
- **"Vietnamese phrase."** - English meaning.
```

Not every listing needs all sections in the app, but gold examples can include them so future sessions understand the full editorial logic.

---

## 9. Mobile Display Version

The full example entry is for training, editing, and QA.

The actual app should usually show a compressed version first.

### Mobile first-screen target

Aim for:

1. One traveler-use heading.
2. A two-sentence briefing.
3. One practical “do first” cue.
4. Two to four useful phrases.

### Mobile word target

For most listings:

- **Compressed app version:** 55-110 words before phrases.
- **Expanded detail version:** 150-240 words before phrases.
- **Internal source notes:** no strict limit, but keep them factual.

### Example compression

Expanded:

> Dragon Bridge is the city landmark you do not have to overplan. Walk the Hàn River, watch the dragon light up, and, on show nights, stay for the short burst of fire and water. Stand near the bridge if you want to feel the spray; stay on the promenade if you want the view without getting wet. Arrive before 8:30 PM on weekend nights if the show matters.

Mobile:

> **Choose Dry Or Close**  
> Stand near Dragon Bridge if you want to feel the spray; stay on the riverbank if you want the clean view. On show nights, arrive before 8:30 PM and recheck the schedule that week.

---

## 10. Category-Specific Editorial Jobs

### Markets

The job is to reduce sensory overwhelm.

Focus on:

- What to do first.
- Whether it is better for food, gifts, produce, or orientation.
- What to eat first.
- When to go.
- Cash, bargaining, heat, and crowd cues.

Good heading patterns:

- **The Food-First Market**
- **Start With A Bowl**
- **Morning For Food, Later For Gifts**

Avoid:

- “A shopper’s paradise.”
- “A bustling market full of local flavor.”

### Restaurants and food counters

The job is to teach ordering confidence.

Focus on:

- What to order first.
- How the service works.
- Whether to confirm price, spice, set menu, shellfish, or portion size.
- Whether the place is fast, slow, chaotic, formal, casual, touristy, local, or ritual-based.

Good heading patterns:

- **Confirm The Set First**
- **Go Classic First**
- **The Roll-It-Yourself Meal**

Avoid:

- “Delicious local cuisine.”
- “A must-try restaurant.”

### Cafés

The job is to explain the ritual.

Focus on:

- What to order first.
- The seating or ordering flow.
- Whether it is good for lingering, photos, history, quiet, view, or novelty.
- How sweet/strong/intense the drink is.

Good heading patterns:

- **The Original Egg Coffee Stop**
- **Small Cups, Close Tables**
- **Egg Coffee, Then A Note**

Avoid:

- “Cozy café vibes.”
- “Perfect for coffee lovers.”

### Streets and neighborhoods

The job is to build a mental map.

Focus on:

- Where to start.
- Which direction to walk.
- What anchors matter.
- What this area does and does not represent.
- Whether it is best for food, nightlife, history, shopping, temples, or orientation.

Good heading patterns:

- **Old Saigon In One Walk**
- **Chinatown Needs Anchors**
- **Backpacker District, Not All Saigon**

Avoid:

- “Explore the vibrant streets.”
- “A charming neighborhood.”

### Landmarks and bridges

The job is to explain the experience, not just the object.

Focus on:

- Whether to walk, view, photograph, watch a show, or pair with another stop.
- Best time of day.
- Crowd/weather/safety cues.
- What makes it meaningful locally.

Good heading patterns:

- **Choose Dry Or Close**
- **Better From The Riverbank**
- **Da Nang’s Easy Night Ritual**

Avoid:

- “An iconic landmark.”
- “A breathtaking architectural marvel.”

### Museums

The job is to prevent museum fatigue.

Focus on:

- What to see first.
- Which galleries or objects anchor the visit.
- Why it matters to the city.
- How long to spend.
- Whether English interpretation exists.

Good heading patterns:

- **Pick Three Anchors**
- **Da Nang Before The Beaches**
- **Go Near Opening**

Avoid:

- “A treasure trove of history.”
- “A fascinating collection.”

### Nature, beaches, rivers, lagoons

The job is to explain timing and conditions.

Focus on:

- Tide, weather, sunrise, sunset, heat, fog, rain, visibility, trail difficulty, transport.
- Whether it is a standalone destination or a route stop.
- What to do once there.

Good heading patterns:

- **Go When The Tide Helps**
- **Low Tide Or Soft Light**
- **A Road-Trip Pause**

Avoid:

- “A serene escape.”
- “Nature lover’s paradise.”

### Theme parks and tourist complexes

The job is expectation-setting.

Focus on:

- What the place really is.
- Whether the famous photo is only one part.
- How to reduce crowd disappointment.
- Weather and ticket/time commitment.

Good heading patterns:

- **Know You Are Choosing A Theme Park**
- **Bridge Before The Crowd**
- **Early, With Weather Checked**

Avoid:

- “Magical destination.”
- “Unforgettable experience for everyone.”

### Nightlife streets

The job is safe, calm orientation.

Focus on:

- What the scene is actually like.
- Best window for first-timers.
- Price clarity.
- Phone/bag awareness.
- How to leave.

Good heading patterns:

- **Walk Once Before Sitting**
- **Early Evening Is Kinder**
- **Backpacker District, Not All Saigon**

Avoid:

- “The city comes alive.”
- “Party paradise.”

---

## 11. Phrase Policy

The phrases should be tied to real actions at that listing.

Good phrase tasks:

- Asking for a menu.
- Ordering the signature item.
- Asking for less sugar or no chili.
- Confirming a set price.
- Asking which way to a landmark.
- Asking if photos are okay.
- Asking when a show starts.
- Asking whether a spot gets wet.
- Asking about tide, fog, last cable car, return trip, or life jackets.
- Calling a taxi or returning to the hotel.

Bad phrase tasks:

- Generic travel phrases unrelated to the place.
- Airport phrases on a café page.
- Hotel phrases on a market page.
- Overly complex conversation scripts.
- Phrases the traveler is unlikely to actually say.

### Phrase count

Use 2-4 phrases for mobile.
Use 3-5 phrases for expanded examples.

Each phrase should include:

- Vietnamese.
- English meaning.
- Optional short usage cue if needed.

---

## 12. Banned and Risky Language

### Ban these unless quoting a source

- hidden gem
- must-visit
- vibrant
- bustling
- nestled
- offers something for everyone
- rich culture
- paradise
- unforgettable experience
- authentic experience
- charming
- iconic landmark
- local favorite
- perfect spot
- culinary gem
- where tradition meets modernity
- a feast for the senses
- bucket-list
- Instagrammable
- magical
- enchanting

### Also avoid

- Empty mood lines.
- Fake enthusiasm.
- Corporate tourism board phrasing.
- Overexplaining obvious facts.
- “This place is known for…” without saying how the traveler should use it.
- Repeating the category as the insight.

Bad:

> This café is known for coffee and a cozy atmosphere.

Better:

> Come for one hot egg coffee, stir slowly, and treat the tiny cup more like dessert than a normal caffeine stop.

---

## 13. Good Heading Patterns

Use headings that create a decision.

### Action headings

- Start With A Bowl
- Ask Before It Arrives
- Walk Once Before Sitting
- Bridge Before The Crowd
- Choose Dry Or Close
- Go To Thiên Mụ
- Confirm The Set First

### Timing headings

- Morning For Food
- Early Evening Is Kinder
- Low Tide Or Soft Light
- Go Near Opening
- Early, With Weather Checked

### Framing headings

- The Food-First Market
- The Original Egg Coffee Stop
- Chinatown Needs Anchors
- Old Saigon In One Walk
- Backpacker District, Not All Saigon
- A Road-Trip Pause

---

## 14. Scoring Rubric

Score each listing from 0-5 in each category.

### 1. Place specificity

5 = Contains concrete details that could only belong here.  
3 = Some real details, but still partly generic.  
1 = Could fit many places.

### 2. Traveler decision value

5 = Teaches the traveler what to do, when to go, what to order, or what to avoid.  
3 = Useful but mostly descriptive.  
1 = No clear decision help.

### 3. Evidence discipline

5 = All claims are sourced or clearly from supplied evidence; uncertainties are flagged.  
3 = Mostly grounded, but a few claims need verification.  
1 = Invents or overstates.

### 4. Mobile readability

5 = Short, scannable, first-screen friendly.  
3 = Strong copy but too long for mobile.  
1 = Dense, essay-like, or repetitive.

### 5. Phrase relevance

5 = Phrases match real tasks at this place.  
3 = Phrases are useful but somewhat generic.  
1 = Phrasebook drift.

### 6. Tone balance

5 = Honest, warm, and still makes the place feel worth doing.  
3 = Either slightly too promotional or slightly too skeptical.  
1 = Hypey, cynical, or flat.

### Passing standard

- **28-30:** Gold standard.
- **24-27:** Strong; minor edit needed.
- **20-23:** Usable draft; revise before publication.
- **Under 20:** Reject and regenerate.

No listing can pass if:

- It invents a fact.
- It ignores closure/status uncertainty.
- It contains banned generic language.
- It fails the replaceability test.
- It gives phrases unrelated to the place.

---

## 15. Five Required QA Tests

### 1. Replaceability test

Remove the place name. Could this copy fit another café, market, bridge, or neighborhood?

If yes, fail.

### 2. Decision test

Does the copy help the traveler make a decision?

Examples:

- What to order first.
- Where to start walking.
- When to go.
- Whether to confirm price.
- Whether to stand close or far.
- Whether this is a standalone destination or route stop.

If no, revise.

### 3. Phrase task test

Would the user realistically say these phrases at this place?

If no, replace them.

### 4. Anti-hype test

Does the copy overpromise?

If yes, ground it with a real expectation.

### 5. Anti-cynicism test

Does the copy become so practical that it kills excitement?

If yes, add one honest emotional reason to care.

---

## 16. Editing Existing Examples to v2

When editing the 16 example entries, do not rewrite from scratch unless necessary.

Use this order:

1. Preserve strong traveler-use headings.
2. Remove or soften headings that are too poetic or too abstract.
3. Add one sensory or physical detail where the entry feels intellectual.
4. Compress long bodies for mobile.
5. Keep honest cautions, but add one reason the place is still worth doing.
6. Remove any source note from app-facing copy.
7. Keep source notes internal.
8. Re-score using the rubric.

### Specific known v1 improvements

Apply these principles to the existing 16 examples:

- **Thủy Xuân Incense Village:** Change “Color Is The Doorway” to something more practical, such as **Go For The Craft, Not Just The Color**.
- **The Note Coffee:** Keep the touristy honesty, but make it warmer and less reviewer-ish.
- **Ba Na Hills:** Keep the theme-park expectation, but add one line that preserves excitement when weather and timing are good.
- **Đồng Khởi Street:** Add one physical/sensory detail so it feels walked, not just mapped.
- **Dragon Bridge:** Keep “Choose Dry Or Close.” It is a strong SpeakLocal heading.
- **Bale Well:** Keep “Confirm The Set First.” This is a strong example of turning review ambiguity into traveler confidence.
- **Bùi Viện:** Keep the calm safety guidance and the “Backpacker District, Not All Saigon” framing.

---

## 17. Creating Five New Listings

When creating new listings from a list, choose a mix of categories if possible.

Prioritize:

- One restaurant or café.
- One landmark or museum.
- One market.
- One neighborhood or street.
- One nature/tour/experience listing.

For each new listing:

1. Gather source notes first.
2. Check status and recency.
3. Identify the category job.
4. Create the traveler-use heading.
5. Write expanded example version.
6. Write mobile compressed version if requested.
7. Add 2-4 useful phrases.
8. Score with rubric.

---

## 18. Preferred Output for New Sessions

When a new session is asked to use this playbook and the 16 examples, it should produce three sections.

### Section A: V2 edits to the 16 examples

For each edited listing:

```markdown
## Listing Name - Category

### Edit notes
- What changed and why.

### Revised expanded version
[Full revised entry]

### Mobile version
[Compressed app copy]

### Score
[Rubric score with short notes]
```

### Section B: Five new entries

Same format:

```markdown
## Listing Name - Category

### Source notes
- Source-backed details.

### Expanded version
[Full entry]

### Mobile version
[Compressed app copy]

### Useful phrases
- Phrase.

### Score
[Rubric score]
```

### Section C: Pattern report

A short report answering:

- Which headings worked best?
- Which categories were hardest?
- Where was evidence sparse?
- Which entries need same-week verification?
- What should be added to the playbook?

---

## 19. Copy-Paste Handoff Prompt for a Fresh Session

Use this prompt when testing whether another ChatGPT/Codex session can follow the style.

```text
You are the SpeakLocal city-copy editor.

I am giving you:
1. SpeakLocal Editorial Playbook v2.
2. A file with 16 SpeakLocal example entries.
3. A list of real app listings to use for new examples.

Your job:
- First, read the playbook and infer the style from the 16 examples.
- Then edit the 16 examples into v2 quality.
- Then create 5 new example entries from the supplied listing list.

Core editorial target:
Write evidence-backed traveler briefings, not travel-blog copy.
The user is a first-time traveler who wants to know what to expect, what to do first, what to order or ask, and which small local phrases will help.

Hard rules:
- The first heading must be a traveler-use cue.
- Every entry must teach at least one decision.
- Every entry must contain concrete place-specific details.
- Useful phrases must be tied to real tasks at that place.
- Do not invent facts, hours, prices, menus, schedules, or current status.
- If status is uncertain, flag needs_verification.
- Keep source notes internal; do not make the app copy feel researched.
- Avoid banned travel-blog language from the playbook.
- Balance honesty with anticipation: real version, but still worth doing.

For each revised or new listing, output:
1. Edit/source notes.
2. Revised expanded version.
3. Mobile version.
4. Useful phrases.
5. Rubric score.
6. Verification flags, if any.

Before finalizing, run these checks:
- Replaceability test.
- Decision test.
- Phrase task test.
- Anti-hype test.
- Anti-cynicism test.

If a listing fails, revise it before presenting the final output.
```

---

## 20. Final Standard

A finished SpeakLocal listing should make the traveler think:

> “Now I know how to use this place.”

Not merely:

> “Now I know what this place is.”

That is the difference between content and traveler intelligence.
