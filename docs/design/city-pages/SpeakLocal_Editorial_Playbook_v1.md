> **SUPERSEDED — DO NOT USE FOR NEW CITY/PLACE COPY.** Current standard: `speaklocal.place.app-detail.v2.2`. Start with `CURRENT_CITY_PAGE_STANDARD.md`. This file is retained only as historical reference.

# SpeakLocal Editorial Playbook v1

## 1. Editorial Philosophy & User Psychology

SpeakLocal isn’t just a phrasebook; it’s a travel‑confidence companion. The product’s mission is to deliver **ambient traveler intelligence**—concise, culturally aware briefings that reduce anxiety and build anticipation for first‑time travellers, especially those going from the U.S. to Asia. The ideal user has already booked a trip, is excited but slightly nervous, and wants to feel competent and “in the know” before arriving.

### Key characteristics of SpeakLocal copy

- **Confidence‑building:** Focus on reducing uncertainty by describing what to expect rather than listing facts. Copy should feel like a well‑travelled friend texting practical insights.
- **Culturally aware:** Assume adult intelligence and respect local context; avoid patronizing or over‑explaining.
- **Calm and concise:** Strive for restrained, observational writing rather than breathless travel‑blog adjectives. Avoid generic filler phrases such as *bustling*, *vibrant*, *must‑visit*, *offers something for everyone*, etc.
- **Evidence‑backed:** Ground descriptions in specific details extracted from reviews, images and primary sources before synthesizing prose.

## 2. Page Types & Emotional Jobs

Each listing type serves a different emotional job. Tailor content and length accordingly:

| Listing type                 | Emotional job                                                                                                                    | Guidance                                                                                                                   |
|------------------------------|----------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| **City page**                | Orient and reassure travelers. Provide atmosphere and context so users can mentally map the city and reduce pre‑arrival anxiety. | Highlight vibe, core districts, and why people go. Avoid encyclopedic history.                       |
| **Café / restaurant**        | Set expectations and teach choice. Help travelers understand the vibe and how to order.                                          | Mention why locals like it, best moments (e.g., morning vs. evening), and one signature item to try. |
| **Street / transit station** | Build familiarity and pronunciation confidence.                                                                                  | Provide name pronunciation, reason to know it (e.g., major hub), and one situational tip.                                  |
| **Food / dish**              | Remove intimidation and encourage exploration.                                                                                   | Describe flavor profile, how to order or eat it, and social context.                                                       |
| **Landmark / district**      | Spark curiosity and situate the landmark within its neighborhood.                                                                | Give a single evocative detail that explains its significance and why travelers might care.                                |

*If a listing doesn’t need deep context (e.g., a street or single dish), a single insight, pronunciation aid, or expectation cue may suffice. Restraint is premium.*

## 3. Banned Patterns and Words

Avoid structures and phrases that make copy feel generic or artificial. Examples of banned words/phrases include:

- “bustling”, “vibrant”, “nestled”, “offers something for everyone”, “rich culture”, “must‑visit”, “hidden gem”.
- Wikipedia‑style explanations or marketing copy (“serves coffee and pastries in central…”).
- Overly enthusiastic or poetic language that isn’t grounded in evidence.
- Copy that would fit another venue simply by swapping the name. If the description could apply elsewhere, rewrite it to include place‑specific details.

## 4. Desired Tone and Style

Good SpeakLocal copy should feel:

- **Observational and specific:** Draw on concrete details such as seating style, noise level, ordering rituals, or timing cues. This “specificity density” helps eliminate replaceable copy.
- **Calm and quietly confident:** Speak like someone who knows the place intimately; avoid hype or melodrama.
- **Traveler‑first:** Focus on what a traveler needs to know to feel comfortable and engaged, not on exhaustive facts or history.
- **Emotionally grounded:** Convey atmosphere (“cooler inside than the street outside”) and social rhythms (“laptop workers in the morning”) rather than generic adjectives.

## 5. Modular Structure & Evidence‑First Approach

Use a modular structure that delivers brief, focused insights. Not every listing needs all modules; choose only those relevant to the listing. Suggested modules include:

1.  **Why go:** One sentence explaining why a traveler might care about this place.
2.  **What it feels like:** Describe the vibe/atmosphere in a sensory way.
3.  **What to order or try first:** For cafés, restaurants, or food items, give guidance on signature choices.
4.  **Best moment:** Highlight a time of day or condition when the place shines (e.g., rainy afternoon, sunrise, quiet weekdays).
5.  **Neighborhood context:** Explain briefly how the place fits into its area or how to combine it with nearby spots.
6.  **Useful phrase(s):** Provide one or two local phrases that would be helpful at this venue.

### Evidence‑first generation

Rather than asking a model to invent prose and facts in one step, SpeakLocal should **extract evidence first**—reviews, photos, operating data—and then synthesize concise observations. This prevents hallucination and ensures copy remains grounded in reality. Implement a two‑stage pipeline:

1.  **Observation extraction:** Pull specific details (e.g., “laptop workers”, “strong Vietnamese coffee”, “cooler inside”).
2.  **Briefing synthesis:** Assemble these details into the modules above. The final copy should read fluidly, but remain tightly tied to the extracted observations.

## 6. Validation & Specificity Metrics

To maintain quality at scale, build validators around the following principles:

- **Place specificity:** Ensure each description contains details that could not apply to another venue. If removing the venue name doesn’t materially change the description, rewrite it.
- **Evidence alignment:** Check that each statement is supported by extracted evidence. Avoid summarizing beyond what the evidence shows.
- **Tone compliance:** Reject copy containing banned words/phrases or overt hype.
- **Length restraint:** Some listings (e.g., streets, single menu items) may only need a single line. Default to less rather than more.

## 7. Next Steps

With this Playbook in place, the next tasks are:

1.  **Gold‑standard examples:** Manually craft a set of exemplary listings across categories (city, café, food, district, landmark, street) using this framework. These will become canonical anchors for future generations and validator tuning.
2.  **Pipeline design:** Update your generation pipeline to implement the evidence‑first approach, the modular structure, and validators described above.
3.  **Continuous refinement:** Collect user feedback and real traveler observations to refine banned patterns and modules over time.

By following this Playbook, SpeakLocal can scale traveler‑first content without sacrificing trust or authenticity.
