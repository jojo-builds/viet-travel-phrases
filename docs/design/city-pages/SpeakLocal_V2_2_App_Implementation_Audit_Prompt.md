# SpeakLocal v2.2 App Implementation Audit Prompt

Use this prompt with Codex or a new implementation agent after uploading:

1. `SpeakLocal_Editorial_Playbook_v2_2_Portable.md`
2. `SpeakLocal_Canonical_31_Example_Set_V2_2_App_Ready.md`
3. The current app/database source files for place detail pages, phrase catalog, audio catalog, and linked listing/catalog items.

---

## Prompt

You are auditing and updating the SpeakLocal app content pipeline.

The editorial direction is already defined. Do not rewrite the whole style system. Your job is to make sure the app renders the editorial content correctly and connects copy to useful audio phrase cards and Mentioned Here catalog cards.

### 1. Source-of-truth check

Confirm which file/source currently generates live place detail pages.

For each live page, determine whether it is using:

- old mobile-only copy,
- expanded editorial copy,
- generated hybrid copy,
- database fields,
- or a frontend fallback.

Report any mismatch against `SpeakLocal_Canonical_31_Example_Set_V2_2_App_Ready.md`.

### 2. Duplicate copy check

Add a validation check that fails an entry if:

- the same paragraph appears twice,
- a section body repeats the intro body,
- two section bodies are identical,
- both mobile and expanded versions render the same sentence,
- or Useful Phrases render both as prose and as phrase cards.

Specifically test the previous Hàn Market issue where the paragraph beginning “The food area is easier after one slow lap” appeared twice.

### 3. Useful Phrase card mapping

Useful phrases must be rendered as playable phrase cards, not prose.

For every listing:

- Map each useful phrase to an existing phrase/audio ID when possible.
- If exact text does not exist, search for a close canonical phrase with the same intent.
- If no phrase exists, mark `new_phrase_needed` rather than rendering unsupported Vietnamese text.
- Prefer existing audio over inventing slightly better phrasing.
- Preserve Vietnamese diacritics.

Required output per phrase:

```json
{
  "vi": "Cái này bao nhiêu?",
  "en": "How much is this?",
  "intent": "ask_price",
  "phraseId": "existing_or_null",
  "audioId": "existing_or_null",
  "status": "mapped|close_match|new_phrase_needed|hide_until_audio"
}
```

### 4. Mentioned Here catalog mapping

If the copy naturally mentions an item already in the app catalog, surface it as a Mentioned Here card.

Check for:

- foods,
- places,
- streets,
- neighborhoods,
- museums,
- markets,
- landmarks,
- experiences,
- cities.

Do not force new mentions into copy just to create cards.

For every candidate, output:

```json
{
  "label": "Bánh xèo",
  "type": "food",
  "catalogId": "existing_or_null",
  "displaySubtitle": "Traveler-facing card subtitle.",
  "reason": "Named naturally in food-area guidance.",
  "status": "render|check_catalog|do_not_render"
}
```

Render `displaySubtitle` when present. If it is missing, fall back to a catalog subtitle or description when available; otherwise render only the card label. Never render `reason`, which is internal QA/source rationale.

### 5. Hàn Market reference implementation

For Hàn Market, target this behavior:

- Intro: `A Market For First Bearings`
- Useful phrases as cards:
  - `Cái này bao nhiêu?` — How much is this?
  - `Bớt chút được không?` — Can you lower it a little?
  - `Cho tôi một phần.` — One portion, please.
  - `Trả ở đâu?` — Where do I pay?
- Sections:
  - `Walk Once Before Choosing`
  - `Morning Food, Later Gifts`
  - `Different Job Than Cồn`
- Mentioned Here candidates:
  - Mì Quảng or specific available variants like Mì Quảng gà / Mì Quảng tôm thịt
  - Bánh bèo
  - Bánh xèo
  - Nem lụi, if available
  - Chợ Cồn, if available
  - Đà Nẵng, if city cards are supported

Do not duplicate the `Walk Once Before Choosing` body.

### 6. Ba Na Hills reference implementation

For Ba Na Hills, target this behavior:

- Intro heading: `More Theme Park Than Viewpoint`
- Useful phrases as cards:
  - `Vé bao nhiêu?` — How much is the ticket?
  - `Tôi chụp hình ở đây được không?` — Can I take photos here?
  - `Mấy giờ đóng cửa?` — What time does it close?
  - `Điểm gặp ở đâu?` — Where is the meeting point?
- Sections:
  - `Cooler Air, Bigger Production`
  - `Bridge Before The Crowd`
  - `Early, With Weather Checked`
  - `A Half-Day Minimum`
- Mentioned Here candidates:
  - Golden Bridge / Cầu Vàng
  - French Village, if catalog exists
  - Đà Nẵng
  - Cable car / Ba Na Hills cable car, if catalog exists

Use softer expectation-setting language. Avoid phrases like “least painful crowd strategy.”

### 7. Output report

Return:

1. A summary of what source generated the live pages.
2. A list of duplicate-render bugs found.
3. A phrase mapping table by listing.
4. A Mentioned Here candidate table by listing.
5. Entries blocked by missing audio or missing catalog items.
6. Code/data changes made.
7. Remaining manual QA tasks.

After rendering, run the thin screenshot review gate in `V2_2_SCREENSHOT_REVIEW_GATE.md`, then close with `V2_2_PRODUCTION_REVIEW_GATE.md`. Keep mechanical contract results separate from voice results, especially when a page has the right modules but sounds like it is describing the listing's function instead of the traveler's experience of the place.

Do not treat the existing five-page proof tests as coverage for future pages. For each scoped page ID, capture equivalent native proof: the page title, intro heading, Useful Phrases, expected Mentioned Here or related card, bottom chrome clearance, and a scrolled screenshot.

Do not rewrite the 31-example editorial set unless implementation requires field normalization.
