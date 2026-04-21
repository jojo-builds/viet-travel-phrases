Approval: BLOCK

Findings
- `site/data/phrase-previews/vietnam-essential-basics.json`, `site/data/phrase-previews/vietnam-transport-basics.json`, and `site/data/phrase-previews/vietnam-understanding-repair.json` expose only flat phrase preview entries. They do not contain the relation packet fields needed for listing/detail surfaces, such as `possibleTravelerResponses`, `familyRelations`, `shortestFormPhraseId`, `clearerFormPhraseId`, or `morePoliteFormPhraseId`.
- The usable relation model lives in `docs/PHRASE_RELATIONSHIP_MODEL.md` and the bounded sample in `content-draft/viet/relation-sample-v1.json`, but that truth is not carried into the website export seam.
- The current export intersects the relation sample on 14 starter families, so the missing export bridge is still a real blocker for future phrase-detail and article rails.

Rationale
- The pre-edit website artifacts do not leave a consumable packet for future listing/detail work. Downstream surfaces would still need fresh export work rather than being able to consume the existing site data directly.
