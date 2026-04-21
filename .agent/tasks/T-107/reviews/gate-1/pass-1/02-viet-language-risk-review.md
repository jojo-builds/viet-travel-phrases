Findings
- `content-draft/viet/phrase-source.csv:14`, `:24`, and `:32` show `you_may_hear` is currently free-text guidance, not a stable reply graph, while `docs/PHRASE_RELATIONSHIP_MODEL.md:29-31` and `docs/V2_CONTENT_MODEL.md:39-53` frame reply handling as flexible follow-up guidance. The planned `likely-reply cue or likely-reply link` is too easy for downstream consumers to misread as a deterministic reply edge, which is risky in Vietnamese service contexts where multiple replies can be equally natural.
- `docs/PHRASE_RELATIONSHIP_MODEL.md:38-42` defines `more-polite` as hierarchy-safe or service-safe wording, not a universal upgrade. The sample plan needs an explicit rule that `more-polite` is only authored when it materially changes the interaction; otherwise it can create false politeness assumptions and encourage unnatural “polite” variants that are context-wrong.

Risks
- The sidecar relation-layer direction is sound, but only if reply artifacts stay advisory and polite variants stay optional and context-gated.
- If the sample JSON gets consumed as a general pattern library without those guardrails, it will overstate certainty about both reply behavior and register.

Approval: BLOCK
