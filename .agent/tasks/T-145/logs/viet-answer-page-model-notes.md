# T-145 Viet Answer-Page Model Notes

## Working goal

Land an additive answer-page sidecar for Viet so listing pages can behave like compact traveler answer hubs instead of flat phrase cards.

## Planned answer-page seam

- `phrase-source.csv` remains row/phrase truth.
- `relation-sample-v1.json` remains the sole owner of cross-family relation truth, typed follow-up buckets, and reply / repair / escalation rails.
- new `answer-page-sample-v1.json` will own answer-page module mixes plus compact module content, but it must reference relation ids or phrase ids instead of restating the relation graph.
- phrase wording stays in `phrase-source.csv` only; the answer-page sample must not duplicate full Viet/English phrase text inside modules.

## Concrete answer-page contract

Each answer hub should follow this structure:

- top-level required fields:
  - `hubId`
  - `scenarioId`
  - `familyId`
  - `phraseClass`
  - `moduleMixId`
  - `relationClusterId`
  - `anchorPhraseId`
  - `defaultPhraseId`
  - `quickSayPhraseId`
  - `clearerPhraseId`
  - `morePolitePhraseId`
  - `alternatePhraseIds`
  - `relationBuckets`
  - ordered `modules`
- `relationBuckets` on the answer hub is a non-semantic bucket-name list, not a second graph:
  - `likelyReply`
  - `repairIfMissed`
  - `askNext`
  - `escalateTo`
  - `crossClassExit`
- the actual bucket payloads and target-family rails stay in `relation-sample-v1.json`
- every module in `modules` should use a stable object shape:
  - `moduleId`
  - `type`
  - `required`
  - `sourcePhraseIds`
  - `sourceFamilyIds`
  - `relationRefs`
  - `content`
- `content` is bounded structured microcopy only:
  - one short `summary` string plus one short `bullets` array
  - no paragraph prose
  - no duplicated phrase text
  - no independently-authored cross-family graph rules

## Planned phrase classes and module mixes

### `greetings-social`
- modules:
  - `core-phrase`
  - `social-use-case`
  - `likely-reply`
  - `say-next`
  - `graceful-exit`
- required relation buckets:
  - `likelyReply`
  - `askNext`
  - `repairIfMissed`
  - `crossClassExit`

### `urgent-help-medical`
- modules:
  - `urgent-core`
  - `risk-or-symptom-detail`
  - `likely-reply`
  - `immediate-next-step`
  - `local-reality`
  - `repair-branch`
  - `safety-escalation`
- required relation buckets:
  - `likelyReply`
  - `repairIfMissed`
  - `askNext`
  - `escalateTo`
  - `crossClassExit`

### `repair-clarification`
- modules:
  - `repair-core`
  - `show-or-write`
  - `number-check`
  - `likely-response`
  - `next-try`
  - `courtesy-close`
- required relation buckets:
  - `likelyReply`
  - `repairIfMissed`
  - `askNext`
  - `crossClassExit`

### `practical-service-navigation`
- modules:
  - `task-core`
  - `operator-question`
  - `confirm-detail`
  - `what-to-show`
  - `local-reality`
  - `next-step`
  - `fallback`
- required relation buckets:
  - `likelyReply`
  - `repairIfMissed`
  - `askNext`
  - `crossClassExit`

## Planned enriched hubs

### `greetings-social`
- `polite-hello`
- `polite-thank-you`
- `polite-acknowledge`
- `polite-no-thanks`
- `social-how-are-you`
- `social-recommend`

### `urgent-help-medical`
- `emergency-not-safe`
- `emergency-ambulance`
- `emergency-hospital`
- `emergency-following-me`
- `health-pharmacy`
- `v900-heal-phar-i-have-trouble-breathing`

### `repair-clarification`
- `repair-understand`
- `repair-slower`
- `repair-repeat`
- `repair-write-down`
- `repair-number`
- `repair-english-help`

### `practical-service-navigation`
- `transport-destination`
- `transport-stop-here`
- `directions-how-to-get`
- `directions-map-pin`
- `service-print`
- `service-email-file`

## Authoring intent

- keep answer content compact and app-usable, not essay-like
- add trace markers in `phrase-source.csv` for newly enriched hubs only
- strengthen relation links so each hub can surface:
  - best default / quick-say fallback
  - situational alternate or clearer phrasing
  - typed likely-reply rails
  - next useful tap-forward phrase families
  - repair branches where the first attempt fails
  - at least one cross-class exit
- minimum relation-depth rule per enriched hub:
  - at least one alternate or clearer branch
  - at least one likely-reply or operator-question branch
  - at least one repair branch
  - at least one cross-class exit
- extra urgent-help-medical rule per enriched hub:
  - at least one detail branch
  - at least one escalation branch
