# Viet Practice Core Contract

Last updated: 2026-04-29  
Status: prepared package for later native integration  
Task: T-169

## Outcome

Practice Core is now defined as a phrase-sourced rehearsal layer over the existing Viet phrase graph. It is not a generic travel quiz layer. Every generated item in the sample deck anchors its correct answer to a source phrase, authored source page, phrase row, or breakdown token from the bundled SpeakLocal universe.

Current artifacts:

- Generated sample deck: `content-draft/viet/practice/practice-deck.sample.json`
- Prototype-local deck copy: `prototypes/practice-quiz/practice-deck.sample.json`
- Generator and contract test: `scripts/practice/generate-viet-practice-deck.js`, `scripts/practice/generate-viet-practice-deck.test.js`
- Clickable prototype: `prototypes/practice-quiz/index.html`

Current generated counts:

- `70` practice items
- `14` scenarios
- `14` category tag sets
- `7` question types
- `5` prototype practice flows

## Source Truth

The generator reads existing repo truth only:

- `content-draft/viet/phrase-source.csv`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-authored-audio-audit.json`

The generated deck is deterministic and offline. It does not call an AI service, fetch remote data, or mutate native runtime files.

## Contract Shape

The deck root uses:

- `schemaVersion`: current contract name, `speaklocal.practice-core.v0.1`
- `language` and `localeName`: language identity
- `generatorVersion`: deterministic generator identity
- `sourceFiles`: source inputs used to build the sample
- `metadata`: counts, offline/runtime flags, and answer-anchor policy
- `questionTypeDefinitions`: canonical type IDs and answer surfaces
- `scenarios`: represented scenario IDs and display titles
- `practiceFlows`: prototype/session groupings
- `items`: practice prompt templates
- `audioAudit`: required audio keys surfaced by the sample
- `nativeHandoff`: notes for local state and future SQLite integration

Each `items[]` record must include:

- `id`: stable prompt ID
- `language`: `vi`
- `questionType`: one of the supported type IDs
- `prompt`: prompt text plus optional `audioKey`, `english`, `vietnamese`, `situation`, or `variantRole`
- `source`: phrase/page identity, including `phraseID`, `familyID`, `pageID`, `scenarioID`, `sectionID`, `phraseRowID`, and optional `sourceBreakdownTokenIDs`
- `answer`: correct answer anchored to `source.phraseID` or `source.sourceBreakdownTokenIDs`
- `options`: answer choices for choice prompts
- `correctOptionID`: selected correct option for choice prompts
- `distractors`: explainable nearby options or extra chunks
- `feedback`: correct-answer line, contrast/explanation, source page label, and source action
- `tags`: category, scenario, situation, pronoun, skill, sensitivity, and mascot eligibility tags
- `requiresAudio`: true only when the prompt surface depends on audio
- `progress`: future local state fields, initially null/zero
- `audit`: explicit flags that the prompt is offline, source-anchored, and not generic travel trivia

Future progress fields are present on every item so T-167-style local state can attach without changing bundled prompt identity:

- `seenCount`
- `correctStreak`
- `missedCount`
- `lastSeenAt`
- `nextDueAt`
- `lastResult`
- `sourceDeckID`
- `localOnly`

## Question Types

The sample covers seven language-knowledge question types:

- `listening_choice`: play a bundled audio cue and choose the English meaning.
- `english_to_vietnamese`: choose the Vietnamese phrase for an English cue.
- `vietnamese_to_english`: read a Vietnamese phrase and choose its English meaning.
- `situation_pick`: choose the Vietnamese phrase that fits an authored travel moment.
- `pronoun_variant_choice`: choose the authored phrase containing a bounded pronoun/self-reference cue such as `anh/chị`, `bạn`, or `tôi`.
- `phrase_chunk_rebuild`: rebuild the Vietnamese phrase from authored breakdown tokens.
- `natural_phrase_choice`: choose an authored `more-polite`, `clearer`, or `also-common` variant without inventing new phrasing.

The pronoun lane intentionally uses only authored phrase evidence. It does not invent new greeting/pronoun pages.

## Practice Flows

The prototype exposes five realistic flows:

- `Starter essentials`: short first-trip prompts from polite basics, repair, transport, and food.
- `Hotel desk`: hotel/front-desk items.
- `Food counter`: cafe, menu, and ordering items.
- `Pronoun coach`: bounded pronoun/self-reference items from authored phrases.
- `Review missed`: a due-first demo flow over sensitive or high-consequence items using the future progress fields.

These flows are prototype groupings, not a final native navigation decision. Native can assemble sessions from `items[]` using local user intent, selected phrases, saved pages, missed prompts, and source page context.

## Native Handoff

### T-167 Local Saved/Practice State

T-167 owns saved/recent/practice-selected local state at the native app layer. Practice Core should connect by storing local IDs, not by mutating bundled deck data:

- selected practice phrase/page IDs
- prompt progress keyed by `items[].id`
- missed/due state keyed by `items[].id` plus `source.phraseID`
- last selected flow/filter
- local timestamps such as added, practiced, missed, and next due

The bundled `progress` object is a shape contract only. Runtime values remain local and private.

### T-168 SQLite Phrase Graph

T-168 owns the read-only SQLite phrase graph path. Practice Core can later be represented in SQLite as:

- `practice_item`
- `practice_option`
- `practice_flow`
- `practice_item_tag`
- `practice_audio_requirement`

The important integration rule is identity stability: `items[].source.phraseID`, `source.pageID`, `source.familyID`, and `source.sourceBreakdownTokenIDs` must resolve against the canonical phrase graph. SQLite can store or generate the same prompt templates, but user progress stays outside the read-only bundle.

### Native Runtime Files

T-169 intentionally does not touch:

- `native-ios/App/**`
- `native-ios/Tests/**`
- `native-ios/project.yml`
- `native-ios/Resources/LanguagePacks/**`
- `native-ios/Resources/Audio/**`

The deck is ready for a later native task, but it is not wired into runtime.

## Prototype

Run from the repo root:

```bash
python3 -m http.server 8787
```

Then open:

```text
http://127.0.0.1:8787/prototypes/practice-quiz/
```

The prototype loads `prototypes/practice-quiz/practice-deck.sample.json`, which is generated from the same Practice Core data as `content-draft/viet/practice/practice-deck.sample.json`. Running from the repo root also lets the prototype resolve local native audio and the Vietnam masthead image.

## Validation Commands

```bash
node scripts/practice/generate-viet-practice-deck.test.js
node scripts/practice/generate-viet-practice-deck.js --check
node -e "JSON.parse(require('fs').readFileSync('content-draft/viet/practice/practice-deck.sample.json','utf8')); JSON.parse(require('fs').readFileSync('prototypes/practice-quiz/practice-deck.sample.json','utf8')); console.log('deck json parse ok')"
python3 -m http.server 8787
curl -I http://127.0.0.1:8787/prototypes/practice-quiz/
git diff --check
```

