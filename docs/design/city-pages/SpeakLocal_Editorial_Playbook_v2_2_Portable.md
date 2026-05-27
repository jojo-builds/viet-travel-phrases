# SpeakLocal Editorial Playbook v2.2 Portable

## Purpose

This playbook is designed for a fresh ChatGPT, Codex, or agent session.

Use it together with the **SpeakLocal Canonical 31 Example Set v2.2**. The examples are not just samples of tone. They are training anchors. Study the strongest examples first, then imitate their behavior when writing or editing new place pages.

SpeakLocal copy is not travel-blog copy. It is not SEO destination copy. It is not a restaurant review. It is not a generic phrasebook.

SpeakLocal copy is:

> **Evidence-backed traveler briefing + usable language layer.**

It answers:

> “What should I know before I go, what should I do first, what can I say there, and what other app items does this place naturally connect to?”

The user should finish a listing thinking:

> “Now I know how to use this place.”

Not merely:

> “Now I know what this place is.”

---

## What changed in v2.2

v2.2 keeps the v2.1 editorial core, then adds lessons from the live app render.

The new lessons are:

1. **Useful Phrases must be playable phrase cards**, not prose paragraphs.
2. **Mentioned Here** should surface catalog items naturally mentioned in the copy.
3. The app needs an **app-detail render contract**, not a loose mix of mobile and expanded copy.
4. The same paragraph must never render twice.
5. Do not invent Vietnamese phrase variants unless they can be mapped to existing audio or flagged as new phrase requests.
6. If copy mentions a Vietnamese item, place, food, street, district, or experience that exists in the catalog, propose it as a linkable mention.
7. Mention linking should be natural, not forced. The copy comes first; the links follow the copy.

---

# 1. Core product definition

SpeakLocal is **travel confidence infrastructure**.

The user is usually:

- English-first or U.S.-based.
- Already planning, imagining, or close to taking a trip.
- Excited, but slightly uncertain.
- Not trying to study the language deeply.
- Trying to feel locally aware before arrival.
- Looking for small, usable language wins.
- Sensitive to generic AI travel copy.

A listing should help them:

- Understand why the place matters.
- Picture what being there feels like.
- Make one smarter decision.
- Avoid an awkward first move.
- Avoid a disappointing expectation.
- Use a few relevant phrases with audio.
- Discover related catalog items without feeling like the page is keyword-stuffed.

The best SpeakLocal copy is:

- Specific.
- Calm.
- Useful.
- Lightly emotional.
- Honest without being cynical.
- Warm without being promotional.
- App-aware without sounding like a database.

---

# 2. The highest-level writing rule

## The first heading must be a natural traveler-use cue

The first heading should tell the traveler how to use the place before they read the body.

Do not confuse a traveler-use cue with command language. The heading should reveal the place's role in natural English, not label the listing's app function.

Good examples:

- **A Market For First Bearings**
- **Walk Once Before Sitting**
- **Choose Dry Or Close**
- **Pick Three Anchors**
- **Choose A Destination, Not A Cruise**
- **More Theme Park Than Viewpoint**
- **Go For The Craft, Not Just The Color**
- **Start Hot And Classic At The Source**
- **Treat It Like A Food Court Night**
- **Find The Upstairs Room First**

Weak examples:

- **The Vibe**
- **Why This Works**
- **A Hidden Gem**
- **A Local Favorite**
- **A Vibrant Experience**
- **A Place To Remember**
- **An Authentic Stop**
- **A Must-Visit Landmark**

A good heading is not decorative. It carries decision value.

## The anti-drift loop

Before filling fields, choose the one traveler moment this page owns: the arrival sequence, upstairs pause, first lap, crossing decision, ordering moment, indoor restock, route pairing, or another physical situation.

Draft the intro and sections from that moment, then map the prose into the app-detail contract. After drafting, read only the first screen aloud. If the title, first heading, and intro sound like a product function or metadata label, revise the voice before touching the schema again.

Use `V2_2_PRODUCTION_REVIEW_GATE.md` before any page is called production-ready.

---

# 3. The voice rule

SpeakLocal sounds like:

- A calm, experienced traveler.
- A practical friend with good taste.
- Someone who notices physical details.
- Someone who understands traveler anxiety.
- Someone who wants the user to enjoy the place.
- Someone who can be honest without killing anticipation.

SpeakLocal does not sound like:

- A tourism board.
- A generic city guide.
- A restaurant review site.
- A Wikipedia entry.
- A luxury lifestyle magazine.
- A travel influencer caption.
- A chatbot trying to sound poetic.

## The emotional balance

Each entry should usually contain:

1. **One grounding truth** — what the place really is.
2. **One emotional reason to care** — why it can still feel memorable.
3. **One practical move** — what the traveler should do first.

Example:

> Ba Na Hills is more theme park than quiet viewpoint. But when the sky opens, the cable-car climb from Da Nang heat into cooler mountain air can still feel cinematic. Go early, do the bridge first, then decide how much of the park you actually want.

That is the tone: real, useful, and still worth doing.

---

# 4. App-detail render contract

The app should not render a random blend of mobile copy, expanded copy, and phrase prose. Each listing should produce one **app-detail version** with clear fields.

Recommended output shape:

```json
{
  "contentContract": "speaklocal.place.app-detail.v2.2",
  "id": "viet-family-city-danang-place-han-market",
  "displayName": "Chợ Hàn",
  "englishName": "Han Market",
  "city": "Đà Nẵng",
  "category": "Market",
  "pronunciation": "chuh han",
  "intro": {
    "heading": "A Market For First Bearings",
    "body": "Hàn Market gives you a practical first read on central Đà Nẵng..."
  },
  "usefulPhraseCards": [
    {
      "vi": "Cái này bao nhiêu?",
      "en": "How much is this?",
      "intent": "ask_price",
      "phraseId": "price-1",
      "audioId": "price-1",
      "status": "mapped|close_match|new_phrase_needed|hide_until_audio"
    }
  ],
  "sections": [
    {
      "heading": "Walk Once Before Choosing",
      "body": "The food area is easier after one slow lap..."
    }
  ],
  "mentionedHereCandidates": [
    {
      "label": "Bánh xèo",
      "type": "food",
      "catalogId": "existing_or_null",
      "displaySubtitle": "Traveler-facing card subtitle.",
      "reason": "Named naturally in the food-area section.",
      "status": "render|check_catalog|do_not_render"
    }
  ],
  "relatedPlaceCandidates": [
    {
      "label": "Chợ Cồn",
      "relationship": "market_contrast",
      "catalogId": "existing_or_null",
      "displaySubtitle": "Traveler-facing card subtitle.",
      "reason": "Direct comparison appears in copy.",
      "status": "render|check_catalog|do_not_render"
    }
  ],
  "verificationFlags": [
    {
      "type": "light",
      "reason": "Current hours can change.",
      "blocking": false
    }
  ]
}
```

## App display order

For most listings:

1. Hero / place name / pronunciation / audio controls.
2. Intro heading and body.
3. Useful Phrase cards.
4. Two to four practical sections.
5. Mentioned Here cards, if the copy naturally names catalog items.
6. Optional comparison or related-place section.
7. Verification is internal only, not user-facing unless status-blocking.

Do not render both a compressed mobile body and an expanded body when they repeat the same idea.

---

# 5. Useful Phrase rules

Useful phrases are part of the product. They should be playable whenever possible.

## Phrase cards, not prose

Bad:

> Start with Chợ Hàn ở đâu? for directions, then ask Món này là gì? when standing at a stall.

Better:

- **Cái này bao nhiêu?** — How much is this?
- **Bớt chút được không?** — Can you lower it a little?
- **Cho tôi một phần.** — One portion, please.
- **Trả ở đâu?** — Where do I pay?

Each phrase should map to:

- Vietnamese text.
- English meaning.
- Intent.
- Audio availability.
- Catalog phrase ID if available.

## Use existing audio first

When picking useful phrases:

1. Prefer phrases already in the app catalog with audio.
2. Prefer reusable travel phrases over hyper-specific one-offs.
3. Use a specific phrase only when the place truly needs it and audio exists or can be created.
4. If a better phrase has no audio, flag it as `new_phrase_needed` instead of silently using it.
5. Do not invent multiple Vietnamese variants for the same intent.

## Phrase count

Most listings need **3–4 phrase cards**.

Use **2–3** for simple streets, viewpoints, or small landmarks.

Use **4–5** for markets, restaurants, tours, theme parks, ticketed attractions, and places with more interaction risk.

## Phrase QA

Every phrase batch needs QA for:

- Diacritics.
- Naturalness.
- Correct place-name order.
- Whether a local would actually say it this way.
- Whether the English gloss matches the Vietnamese.
- Whether the phrase is supported by existing audio.

---

# 6. Mentioned Here rules

**Mentioned Here** turns SpeakLocal into a linked learning system. If the copy naturally mentions an item already in the catalog, surface it as a card.

This can include:

- Foods: mì Quảng, bánh bèo, bánh xèo, nem lụi.
- Places: Dragon Bridge, Chợ Cồn, District 1, Đà Nẵng.
- Streets: Xuân Thủy, Đồng Khởi, Nguyễn Văn Hưởng.
- Landmarks: Golden Bridge, Thien Hau Temple, Hoàn Kiếm Lake.
- Experiences: egg coffee, incense making, river cruise.

## The copy must come first

Do not force item names into copy just to create links.

Good:

> Walk the food area once before choosing; start with mì Quảng, bánh bèo, nem lụi, or a small bánh xèo.

Then surface:

- Mì Quảng
- Bánh bèo
- Bánh xèo
- Nem lụi if available

Bad:

> This market has mì Quảng, bánh bèo, bánh xèo, nem lụi, cao lầu, phở, bún bò Huế, bánh mì, coconut coffee, and Vietnamese coffee.

That is keyword stuffing.

## Mention card count

Most listings should surface **0–4 Mentioned Here cards**.

Use **5–6** only for major markets or food-heavy restaurants where the copy naturally names multiple catalog foods.

## Mention status

Every mention should be labeled internally as:

- `render` — exists in catalog, links to a real target, and should render.
- `check_catalog` — likely exists, needs lookup.
- `do_not_render` — do not render card unless catalog item is created or selected.

## Mention relation types

Use these internal types:

- `food`
- `place`
- `street`
- `neighborhood`
- `landmark`
- `market`
- `museum`
- `experience`
- `phrase`

---

# 7. Duplicate and render validation

Before anything goes live, run these checks:

1. No identical paragraph appears twice in one listing.
2. No section body is identical to the intro body.
3. No section body is identical to another section body.
4. No useful phrase appears as prose and as a phrase card unless intentionally repeated in a sentence.
5. No freeform Vietnamese phrase is shown without phrase QA.
6. No phrase card is rendered without audio status.
7. No mention card is rendered if the item is not in the catalog.
8. Do not render both `mobile_version.body` and `expanded_section.body` if they contain the same sentence.
9. If a sticky audio control overlaps text, UI needs spacing; do not solve that by shortening good copy.

---

# 8. Canonical example anchors to study first

Use the strongest anchors as behavior models, not as rigid templates.

## 1. Chợ Hàn — First-bearings market

Teaches: define the market's job before listing inventory.

Best behavior:

- One roof.
- One first lap.
- One starter food move.
- One timing split between breakfast energy and gifts.
- Mentioned Here food cards if foods exist in catalog.

## 2. The Note Coffee — Touristy ritual without shame

Teaches: admit the place is touristy, then give a simple sequence the traveler can enjoy anyway.

Best behavior:

- Order.
- Climb.
- Read notes.
- Leave a note.
- Do not sneer at the user for wanting the experience.

## 3. Bale Well — Friction to confidence

Teaches: when pricing, service rhythm, or portion size can be unclear, turn the first action into a confidence cue.

Best behavior:

- Confirm the set first.
- Ask how to roll.
- Ask whether the price is per person.
- Reduce awkwardness before the meal starts.

## 4. Cà phê Giảng — Ritual plus origin story

Teaches: give one first order, one arrival cue, and one origin-story detail without writing a coffee essay.

Best behavior:

- Start hot and classic.
- Explain the texture.
- Keep the story small.
- Link egg coffee if catalog exists.

## 5. Dragon Bridge — Simple landmark with one real decision

Teaches: turn a famous object into a practical experience.

Best behavior:

- Choose close/wet or far/clean view.
- Verify show schedule.
- Link nearby market/bridge/riverfront items naturally.

## 6. Museum of Cham Sculpture — Museum fatigue prevention

Teaches: give the traveler three anchors instead of asking them to read everything.

Best behavior:

- Pick three galleries or forms.
- Slow the museum down.
- Mention linked places like Mỹ Sơn only if catalog exists.

## 7. Perfume River — Scenery needs a route

Teaches: scenic places need route, price, timing, return, and safety questions.

Best behavior:

- Choose a destination, not a vague cruise.
- Verify route and return.
- Add phrase cards for round trip, price, and life jackets if audio exists.

## 8. Bùi Viện — Nightlife safety without fear-mongering

Teaches: look first, sit later, keep valuables close, check prices, and preserve curiosity.

Best behavior:

- Walk once before sitting.
- Explain crowd/noise without moralizing.
- Phrase cards should handle prices, bottle/bucket, and leaving.

## 9. Ba Na Hills — Expectation-setting without deflation

Teaches: name the theme-park reality, then keep the still-worth-it sentence.

Best behavior:

- More theme park than viewpoint.
- Bridge before the crowd.
- Weather checked.
- Half-day minimum.
- Useful phrase cards for tickets, photos, closing time, meeting point.

## 10. Japan Town Saigon — Cluster-neighborhood entry

Teaches: choose one alley/street, read the door before entering, and treat business type as traveler orientation.

Best behavior:

- Avoid broad neighborhood mush.
- Give a first street or alley.
- Explain restaurant/bar/nightlife mix neutrally.

---

# 9. Category review instincts

These are review instincts, not section formulas. Use them to notice missing traveler judgment after the page has a real moment and evidence. Do not paste this section into a writing prompt as required slots.

## Markets

The page should tell the traveler what job this market does.

Examples:

- First bearings.
- Food-first.
- Night-market add-on.
- Organized food-court night.
- Souvenir/gift stop.

Commonly check whether the page needs:

- One first-lap behavior.
- One price or ordering phrase.
- Mentioned Here food cards only when naturally named.

## Restaurants

The page should teach how to order or avoid awkwardness.

Useful patterns:

- Confirm the set first.
- Choose the filling before the counter.
- Start with one local dish.
- Ask about pork, shellfish, or heat.
- Use polished first restaurant when the menu organizes local food for visitors.

## Cafés

The page should teach the ritual.

Useful patterns:

- Find the upstairs room first.
- Start hot and classic.
- Order, climb, leave a note.
- Go for a short pause, not a long work session.

## Museums

The page should prevent fatigue.

Useful patterns:

- Pick three anchors.
- Choose one floor theme.
- Ask about English interpretation.
- Allow short visits.

## Streets and neighborhoods

The page should turn space into a route.

Useful patterns:

- Choose one street first.
- Walk the spine toward the river.
- Start with one anchor, then walk nearby.
- Do not try to “do” the whole district.

## Landmarks and viewpoints

The page should identify the real decision.

Useful patterns:

- Choose dry or close.
- Use it after a tomb stop.
- Go before the crowd.
- Check weather before committing.

## Nature and water

The page should include condition, route, and commitment.

Useful patterns:

- Go when the tide helps.
- Choose a boat plan.
- Check weather.
- Plan the ride back.
- Treat working water with dignity, not just as a view.

## Theme parks / high-commitment attractions

The page should set expectations without deflating.

Useful patterns:

- More theme park than viewpoint.
- Half-day minimum.
- Weather checked.
- One priority first, then optional exploration.

---

# 10. Verification taxonomy

## Light verification

Use for facts that commonly change but do not block publication:

- Hours.
- Ticket price.
- Photo policy.
- Entrance route.
- Current menu.
- Temporary exhibits.
- English interpretation.

## Same-week verification

Use when timing or conditions materially affect the visit:

- Fire shows.
- Night-market hours.
- Boat routes.
- Cable cars.
- Weather-dependent views.
- Trail conditions.
- Festival programming.
- Restaurant closures around holidays.

## Status-blocking verification

Use when normal copy should not publish until resolved:

- Possible closure.
- Conflicting official sources.
- Food-safety reopening uncertainty.
- Relocation.
- Major renovation.
- Ticketed attraction suspended.

If status is blocking, return a `status_issue` instead of normal page copy.

---

# 11. Scarce-evidence fallback

For small markets, streets, minor viewpoints, or thin-source listings, do not pretend you have deep evidence.

When evidence is sparse:

- Write shorter copy.
- Make fewer claims.
- Use one anchor behavior.
- Use softer language.
- Include a stronger verification note.
- Avoid creating many Mentioned Here links unless catalog evidence supports them.

Good scarce-evidence pattern:

> Use this as a snack stop near Mỹ An, not a destination market.

Bad:

> This vibrant local market offers an unforgettable journey through authentic Vietnamese culture.

---

# 12. Scoring rubric

Score strictly. 30/30 should be rare.

## 30/30

Publish-quality after factual verification. No editorial rewrite needed.

## 27–29

Strong draft. Minor editorial, phrase QA, or verification pass needed.

## 24–26

Usable draft. Needs better evidence, specificity, phrase mapping, or mention cleanup.

## 21–23

Weak. Rewrite sections.

## 20 or below

Reject.

Cap scores automatically:

- Max 29 if any same-week verification is required.
- Max 28 if phrase audio mapping is unknown.
- Max 27 if evidence is sparse.
- Max 26 if the entry lacks Mentioned Here candidates despite naturally naming catalog items.
- Max 25 if the first heading is a mood label rather than a traveler-use cue.
- Max 24 if the copy has no concrete place-specific detail.
- Max 24 if no rendered page or screenshot review proves the app-detail modules.
- Max 24 if phrase/audio mapping proof is missing.
- Max 24 if natural catalog mentions were not evaluated for Mentioned Here.
- Max 23 if the copy includes duplicate paragraphs.
- Max 23 if phrase cards render below practical sections instead of immediately after the intro.
- Max 22 if Useful Phrases are prose instead of phrase cards.
- Max 22 if the frontend drops required phrase, Mentioned Here, or related modules.
- Duplicate body text in the rendered page is blocking until fixed.

---

# 13. Writer → grader → phrase QA → catalog QA workflow

The writing agent should not be the final judge.

Recommended workflow:

1. **Writer** creates the app-detail entry.
2. **Editorial grader** checks traveler-use heading, specificity, tone, and duplicate content.
3. **Phrase QA** checks Vietnamese, diacritics, naturalness, and audio availability.
4. **Catalog QA** maps Mentioned Here and related place candidates to existing app items.
5. **Freshness QA** handles hours, prices, status, schedules, weather, and closures.
6. **Implementation QA** confirms the UI does not render repeated fields or unsupported phrase prose.

---

# 14. Output instructions for new sessions

When asked to write or revise entries, produce:

1. Closest canonical anchor.
2. App-detail entry.
3. Useful phrase cards with audio status.
4. Mentioned Here candidates.
5. Related place candidates.
6. Verification flags.
7. Strict score.
8. QA notes.

Do not add more abstract rules unless the same failure appears across multiple entries.

Improve by imitation of the strongest examples.
