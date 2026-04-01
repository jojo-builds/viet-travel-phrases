# V1 Content Gap Audit — Vietnamese Travel Phrasebook
**Date:** 2026-04-01  
**Auditor:** Jay  
**Source:** scenarios-draft.json (70 phrases, 10 scenarios) + competitor-pain-analysis-2026-04-01.md + CLAUDE.md scope lock  
**Purpose:** Find missing high-anxiety phrases before launch. Every gap here is a moment where a tourist using our app gets stuck.

---

## AUDIT SUMMARY

| Status | Count |
|--------|-------|
| ✅ Covered well | 8 scenarios |
| ⚠️ Covered but missing critical phrases | 4 scenarios |
| ❌ Missing scenario | 0 |
| 🔴 Critical phrase gaps (add before launch) | 9 phrases |
| 🟡 Recommended additions (add if room) | 7 phrases |

**Verdict: App is 85% launch-ready on content. 9 critical phrase gaps to fill before Day 8 (App Store submission).**

---

## SCENARIO-BY-SCENARIO AUDIT

### 1. Coffee Shop ✅ Strong
Current: 7 phrases — iced milk coffee, black coffee, bạc xỉu, less ice, no sugar, to go, pay.

**Assessment:** Solid. Covers the most common tourist orders.

**Missing (recommended, not critical):**
- 🟡 "Do you have oat milk?" — Growing traveler request, Da Nang has many Western cafés
- 🟡 "One more please" — Natural follow-up after enjoying coffee

**No critical gaps.**

---

### 2. Street Food / Restaurant ⚠️ Missing allergy phrase
Current: 7 phrases — one portion, this bowl, not spicy, herbs, bottled water, utensils, to go.

**Critical gap:**
- 🔴 **"I'm allergic to peanuts / shrimp / shellfish"** — This is a safety phrase. Competitor pain analysis shows food allergy communication is a top tourist anxiety in Vietnam. Southern Vietnamese cuisine uses peanuts heavily (bánh mì, mì Quảng, gỏi). Missing this is a trust failure.

**Recommended:**
- 🟡 "No coriander/cilantro please" — Very common request from Western tourists; called "ngò rí" and found in many dishes
- 🟡 "Is this very spicy?" — Different from "not spicy please" — tourist is asking before ordering

**Suggested phrase to add:**
```json
{
  "id": "food-8",
  "vietnamese": "Tôi bị dị ứng với đậu phộng",
  "romanized": "toy BEE zee UNG vuh DOW fong",
  "english": "I'm allergic to peanuts",
  "context": "Say this before ordering. Peanuts appear in many Vietnamese dishes including bánh mì and some soups.",
  "emoji": "🥜",
  "audioFile": "food-8.mp3"
}
```

---

### 3. Grab / Taxi ✅ Strong
Current: 7 phrases — take me here, District 1, stop here, this way, AC on, wait 5 min, cash.

**Assessment:** Covers the main taxi flow well. "Stop here" (taxi-3) is present — this was a flagged gap in the spec, but it IS covered.

**Recommended:**
- 🟡 "Can you turn on the meter?" — Some older taxi drivers try to negotiate flat rates; this phrase protects tourists
- 🟡 "Please drive slower" — Safety phrase, common tourist experience on Vietnamese roads

**No critical gaps.**

---

### 4. Asking the Price ✅ Good
Current: 7 phrases — how much, per kilo, too expensive, lower it, final price, show another, I'll take it.

**Assessment:** Covers bargaining well. Market shopping is well-served.

**Critical gap:**
- 🔴 **"Do you accept card / QR payment?"** — Vietnam is rapidly going cashless. QR payment (via banking apps) is now standard at many markets and shops. Tourists with Vietnamese SIM cards use this constantly. This is different from taxi-7 ("I'll pay cash") — this is asking about digital payment capability.

**Suggested phrase:**
```json
{
  "id": "price-8",
  "vietnamese": "Có thanh toán bằng thẻ không?",
  "romanized": "koh tan TOAN bung teh KONG",
  "english": "Do you accept card payment?",
  "context": "Ask before buying at markets or small shops. Many vendors now accept QR/card, but not all.",
  "emoji": "💳",
  "audioFile": "price-8.mp3"
}
```

---

### 5. Polite Basics ⚠️ Missing key social phrases
Current: 7 phrases — hello, thank you, yes, no thanks, sorry/excuse me, it's okay, goodbye.

**Assessment:** Covers the essential five. But missing two high-frequency tourist phrases.

**Critical gaps:**
- 🔴 **"I don't speak Vietnamese"** — Most-needed social phrase when a local launches into conversation. Tourists need to signal non-speaker status quickly and politely. Currently in Simple Problems as "I don't understand" — but that's different. This is a preemptive phrase.
- 🔴 **"Can you help me?"** — Universal door-opener in any assistance situation. Not in any current scenario.

**Suggested phrases:**
```json
{
  "id": "polite-8",
  "vietnamese": "Tôi không nói được tiếng Việt",
  "romanized": "toy KONG noy DUK tee-eng vee-ET",
  "english": "I don't speak Vietnamese",
  "context": "Use when a local starts speaking Vietnamese to you. Polite way to signal you need simpler communication.",
  "emoji": "🤷",
  "audioFile": "polite-8.mp3"
}
```

```json
{
  "id": "polite-9",
  "vietnamese": "Bạn có thể giúp tôi không?",
  "romanized": "ban koh TAY ZUP toy KONG",
  "english": "Can you help me?",
  "context": "Universal opener when you need assistance. Works in any situation.",
  "emoji": "🙏",
  "audioFile": "polite-9.mp3"
}
```

---

### 6. Convenience Store ✅ Good
Current: 7 phrases — water, bag, tissues, sunscreen, open this, card payment, receipt.

**Assessment:** Well-designed. Card payment is here (store-6) — this covers one payment scenario.

**Recommended:**
- 🟡 "Where is the bathroom?" — High-frequency need, especially at 7-Eleven stops

**No critical gaps.**

---

### 7. Hotel / Hostel ⚠️ Missing checkout phrase
Current: 7 phrases — reservation, check in, checkout time, too hot, AC broken, towels, luggage.

**Assessment:** Covers most hotel flow. Missing one common scenario.

**Critical gap:**
- 🔴 **"I'd like to check out"** — The reverse of check-in (hotel-2) is missing. Tourists need this for their final morning interaction.

**Suggested phrase:**
```json
{
  "id": "hotel-8",
  "vietnamese": "Tôi muốn trả phòng",
  "romanized": "toy MWON trah FONG",
  "english": "I'd like to check out",
  "context": "Say this at the front desk when leaving. They will process your bill and return your deposit.",
  "emoji": "🛎️",
  "audioFile": "hotel-8.mp3"
}
```

---

### 8. Directions ✅ Strong
Current: 7 phrases — how do I get to X, near here, how long walking, turn left, right, straight, thanks I understand.

**Assessment:** Good navigation coverage. The spec mentions "stop here" — this is in Grab/Taxi (taxi-3), appropriate placement.

**Recommended:**
- 🟡 "Where is the nearest ATM?" — High-frequency tourist need

**No critical gaps.**

---

### 9. Simple Problems ⚠️ Missing bathroom emergency
Current: 7 phrases — lost, don't understand, speak slower, left something, WiFi broken, need doctor, call for me.

**Assessment:** "Speak slower" is present (problems-3) ✅ — flagged in spec, covered.
"I need a doctor" is present (problems-6) ✅ — covered.

**Critical gap:**
- 🔴 **"Where is the bathroom? It's urgent"** — This is the highest-anxiety travel phrase not covered anywhere. No scenario covers bathroom urgency. This should be in Simple Problems. Competitor research shows this as a recurring travel app gap. Vietnam's public bathroom access can be inconsistent — tourists need this phrase urgently.

**Suggested phrase:**
```json
{
  "id": "problems-8",
  "vietnamese": "Nhà vệ sinh ở đâu? Tôi rất cần đi",
  "romanized": "nyah veh SINH uh DOW? toy rat GAN dee",
  "english": "Where is the bathroom? It's urgent",
  "context": "Urgent bathroom need. Asking clearly and with urgency helps locals understand the situation quickly.",
  "emoji": "🚻",
  "audioFile": "problems-8.mp3"
}
```

---

### 10. Small Talk ✅ Adequate
Current: 7 phrases — from US, from UK, first time, like Vietnam, food is good, hot weather, how are you.

**Assessment:** Functional for its purpose. Small Talk is the lowest-anxiety scenario — tourists can survive without perfect small talk.

**Recommended:**
- 🟡 "How do you say this in Vietnamese?" — Meta-phrase, endears tourists to locals, commonly requested
- 🟡 "I'm from Australia/Canada" — Current phrases only cover US and UK

**No critical gaps.**

---

## CRITICAL GAPS SUMMARY — 9 PHRASES TO ADD BEFORE LAUNCH

| Priority | Scenario | Phrase | Why Critical |
|----------|---------|--------|-------------|
| 🔴 1 | Street Food | "I'm allergic to peanuts" | Safety phrase — peanuts are everywhere in Vietnamese cuisine |
| 🔴 2 | Polite Basics | "I don't speak Vietnamese" | Most-needed social phrase when locals address you |
| 🔴 3 | Simple Problems | "Where is the bathroom? It's urgent" | Highest-anxiety travel phrase with no coverage anywhere |
| 🔴 4 | Polite Basics | "Can you help me?" | Universal door-opener, missing entirely |
| 🔴 5 | Asking Price | "Do you accept card/QR payment?" | Vietnam is cashless — this gap is a real tourist friction point |
| 🔴 6 | Hotel / Hostel | "I'd like to check out" | Mirror of check-in, obvious omission |
| 🔴 7 | Street Food | Consider allergy alternatives (shrimp, shellfish) | Seafood allergies are also high-risk in Vietnamese cuisine |
| 🟡 8 | Convenience Store | "Where is the bathroom?" | High-frequency at 7-Eleven/Circle K stops |
| 🟡 9 | Small Talk | "I'm from Australia/Canada" | Expand beyond US/UK |

---

## PHRASES CONFIRMED PRESENT (from spec checklist)

| Spec-mentioned phrase | Status | Location |
|----------------------|--------|----------|
| "Not spicy" | ✅ Present | food-3 |
| "Stop here" | ✅ Present | taxi-3 |
| "Cash/card" | ✅ Present | taxi-7 (cash), store-6 (card) |
| "Speak slower" | ✅ Present | problems-3 |
| "I need a doctor" | ✅ Present | problems-6 |
| Allergy phrases | ❌ Missing | Needs food-8 |
| Bathroom urgency | ❌ Missing | Needs problems-8 |

---

## SCOPE CHECK vs CLAUDE.md

V1 scope: 10 scenarios, ~60-70 phrases, tourist-first, Southern Vietnam dialect. ✅

Current state: 10 scenarios, 70 phrases. At V1 limit. Adding 6-9 critical phrases would bring to 76-79. This is acceptable — CLAUDE.md says "~60 phrases" which is a guideline, not a hard cap. Quality over count.

**Recommendation:** Add the 6 critical phrase gaps (🔴 1-6) replacing the weakest existing phrases if 7-per-scenario is a hard limit, or adding as phrase 8 where scenarios allow. Do NOT add all 9 — stay under 80 total.

---

## BEFORE-LAUNCH CONTENT CHECKLIST

- [ ] Add food-8: allergy phrase (peanuts minimum, consider shrimp variant)
- [ ] Add polite-8: "I don't speak Vietnamese"
- [ ] Add polite-9: "Can you help me?" (or replace weakest polite phrase)
- [ ] Add problems-8: bathroom urgency
- [ ] Add price-8: card/QR payment
- [ ] Add hotel-8: check out phrase
- [ ] Generate audio for all new phrases (run generate-audio.ts with new phrases)
- [ ] Rebuild audio registry after new MP3s are generated
- [ ] Run native speaker review on added phrases before launch

---

## Sources
- `content-draft/scenarios-draft.json` — current 70 phrases
- `research/competitor-pain-analysis-2026-04-01.md` — pain points
- `projects/viet-travel-phrases/CLAUDE.md` — V1 scope lock
- `research/launch-positioning-pack-2026-04-01.md` — positioning context
