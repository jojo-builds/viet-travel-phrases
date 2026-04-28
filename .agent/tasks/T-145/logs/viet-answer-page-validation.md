# T-145 Viet Answer-Page Validation

## Artifact checks

- `content-draft/viet/answer-page-sample-v1.json` parsed successfully.
- `content-draft/viet/relation-sample-v1.json` parsed successfully.
- `content-draft/viet/phrase-source.csv` loaded successfully with UTF-8 BOM preserved.

## Count checks

- answer-page hub count: `24`
- phrase classes present: `4`
  - `greetings-social`
  - `urgent-help-medical`
  - `repair-clarification`
  - `practical-service-navigation`
- module mix count: `4`
- relation-sample cluster count: `43`
- answer-page anchor markers in CSV: `24`
- linked target family count from relation buckets: `32`

## Shape checks

- every answer hub resolved to an existing CSV family
- every anchor/default/quick-say phrase id resolved to the hub family
- every optional clearer / more-polite / alternate phrase id resolved cleanly when present
- every answer hub resolved to an existing relation cluster
- every module used the required shape:
  - `moduleId`
  - `type`
  - `required`
  - `sourcePhraseIds`
  - `sourceFamilyIds`
  - `relationRefs`
  - `content.summary`
  - `content.bullets`
- every module `relationRefs` entry matched a bucket declared on the same hub
- every relation-bucket target family id resolved against `phrase-source.csv`
- exact copied relation-bucket reason strings remaining inside answer-page module bullets after the cleanup pass: `0`

## Manual review points still required

- confirm the module copy reads like compact traveler-answer data instead of generic filler
- confirm the service/document hubs still feel practical enough to justify inclusion in the `24`-hub packet
- confirm urgent-help hubs stay action-first and do not drift into essay-like medical notes
