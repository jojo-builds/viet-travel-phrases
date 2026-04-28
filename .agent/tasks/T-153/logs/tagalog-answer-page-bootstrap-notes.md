# T-153 Tagalog Answer-Page Bootstrap Notes

## Working goal

Land the first additive Tagalog answer-page sidecar so Tagalog can participate in the same listing/detail product direction Viet is proving, without collapsing phrase truth and relation truth into one file.

## Source split

- `phrase-source.csv`
  owns phrase wording, family-local variants, access posture, and the bounded `answer-page-sample=...` trace markers
- `relation-sample-v1.json`
  owns family-to-family relation truth, typed relation buckets for the selected answer-page-ready hubs, and the wider `80`-cluster handoff
- `answer-page-sample-v1.json`
  owns module mixes, hub selection, and compact answer-page microcopy for the bounded `24`-hub proof set

## Selected answer-page set

- total hubs: `24`
- phrase classes:
  - `4` `greetings-social`
  - `4` `urgent-help-medical`
  - `6` `repair-clarification`
  - `10` `practical-service-navigation`
- relation sample after update: `80` total clusters
- answer-page-marked rows in `phrase-source.csv`: `41`

## Module-mix rules

- `greetings-social-v1`
  - required buckets: `likelyReply`, `repairIfMissed`, `askNext`
- `urgent-help-medical-v1`
  - required buckets: `likelyReply`, `repairIfMissed`, `askNext`, `escalateTo`
- `repair-clarification-v1`
  - required buckets: `likelyReply`, `repairIfMissed`, `askNext`
- `practical-service-navigation-v1`
  - required buckets: `likelyReply`, `repairIfMissed`, `askNext`

## Modeling cautions followed in this pass

- phrase classes stay answer-page grouping only and do not replace runtime `scenario` truth
- likely-reply coverage was added only for the bounded `24`-hub subset instead of fabricating a deep reply graph for all `80` clusters
- when no honestly shorter alternate existed, the same anchor row was allowed to serve as both `defaultPhraseId` and `quickSayPhraseId`
- the new greeting hub was added as a bounded relation bridge only; the rest of the wider relation sample stayed intact
