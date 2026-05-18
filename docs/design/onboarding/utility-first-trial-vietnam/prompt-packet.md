# Utility-First Trial Onboarding Prompt Packet

Status: source prompts for generated raster design assets
Last updated: 2026-05-01

## Design Intent

This packet moves first-run onboarding from setup-first to utility-first. The user should hear and save one useful Vietnamese phrase before trip setup and before the 7-day trial paywall.

Shared constraints used across prompts:

- Native iOS Liquid Glass, current SpeakLocal Vietnam style.
- Calm Vietnam scenic masthead fading into white content.
- Large black serif headlines, gray supporting copy, translucent cards.
- Restrained SpeakLocal red for audio and primary action.
- No account, notification, analytics, or permission prompts.
- No free-tier, limited-preview, maybe-later, or skip-paywall CTA.
- Melo only as a small subtle companion on setup/preview/phrase-check moments.
- Real Vietnamese phrase recognition, not generic travel trivia.

## Recommended Flow Prompts

### 1. Arrival Phrase Value

```text
Create screen 1 of the recommended SpeakLocal Vietnam utility-first onboarding flow: Arrival Phrase Value. Headline: "Say the right thing first". Supporting copy: "A useful hotel phrase, ready offline before you need it." Main card: "At the hotel desk", "Toi da dat phong", "I have a reservation", red audio/play button, "Works offline", CTA "Hear phrase", secondary "Set up my trip". No Melo, no paywall, no account, no permissions.
```

### 2. Hear And Save Phrase

```text
Create screen 2: Hear And Save Phrase. Headline: "Now keep it for the trip". Explain audio is saved with the phrase. Show "Saved starter phrase", phrase/audio card, saved badge, chips "Offline audio" and "Hotel desk", CTA "Personalize my start", secondary "Browse all phrases later". No paywall or free-tier language.
```

### 3. Trip Focus

```text
Create screen 3: Trip Focus. Headline: "Where should we start?" Copy: "This tunes your first suggestions. Everything stays available." City chips: Hanoi selected, Ho Chi Minh City, Da Nang, Hoi An, Hue, All Vietnam. Situation cards: Hotel, Airport, Food, Getting Around, Shopping, Emergency, Local greetings. CTA "Build my start", secondary "Choose later". No Melo.
```

### 4. Tiny Phrase Check

```text
Create screen 4: Tiny Phrase Check. Headline: "Want us to set your pace?" Copy: "One quick phrase helps tune practice. You can skip." Quiz card: "You hear 'Cam on'. What does it mean?" Red audio button. Choices: Thank you, Hello, How much?, I need help. CTA "Use this level", secondary "Skip and set Beginner". Small flat-brand Melo companion only, not inside controls.
```

### 5. Personalized Preview

```text
Create screen 5: Personalized Preview. Headline: "For your Hanoi hotel arrival". Copy: "Prepared from the phrase you saved and the situations you chose." Show "Start with these first" phrase rows, Hotel check-in, Getting around, Practice before you land, "Saved on this device", CTA "Continue to trial", secondary "Adjust setup". Small subtle Melo near preview list.
```

### 6. Trial Paywall

```text
Create screen 6: 7-Day Trial Paywall. Headline: "Try Speak Local Vietnam free for 7 days". Benefits: Offline Vietnam phrase map, Bundled audio for real phrases, City and situation guidance, Practice tuned to your level, Personalized recommendations. Reassurance: "No charge during the 7-day trial." CTA "Start 7-day trial". Secondary links only: Restore purchase, Terms, Privacy. No limited-preview CTA, Maybe later, Skip, Free plan, or ongoing free-tier language. No Melo.
```

## Compact Alternate Prompts

### A1. Phrase First Welcome

```text
Create compact alternate screen A1: Phrase First Welcome. Headline: "Build your Vietnam phrase map". Copy: "Start with one phrase you can use at the hotel desk." Show starter phrase/audio card, "Works offline", city chips with Hanoi selected and All Vietnam available, CTA "Hear phrase", secondary "Choose my trip". No Melo.
```

### A2. Trip Setup

```text
Create compact alternate screen A2: Trip Setup. Headline: "What should we prepare?" Copy: "Pick a few. Everything stays available." City selector and situation cards, CTA "Prepare my phrases", secondary "Skip setup". Optional tiny Melo only in corner.
```

### A3. Preview With Optional Check

```text
Create compact alternate screen A3: Preview With Optional Check. Headline: "Your Hanoi start is ready". Show Hotel check-in, Food basics, Getting around, optional "Tune practice?" module with "Take quick phrase check" and "Skip and set Beginner", CTA "Continue to trial". Small Melo near prepared list.
```

### A4. Trial Paywall

```text
Use the same no-free-tier 7-day trial paywall model as recommended screen 6.
```

## Contact Sheets

Contact sheets were composed from the final individual PNG assets:

- `assets/recommended-flow-contact-sheet.png`
- `assets/compact-flow-contact-sheet.png`
