Findings
- [BLOCKER] `relation_cluster_role` is single-valued while `relation_cluster_refs` is multi-valued, so a shared row cannot carry different roles in different clusters. That loses authored truth for reuse-heavy phrases like greetings, repair, and polite acknowledgments, and can misroute anchor vs variant vs reply behavior in downstream listing/detail surfaces.
- [BLOCKER] `replyCues` with optional `responseFamilyId` / `responsePhraseId` still risks being consumed as a canonical reply mapping unless the contract explicitly says it is only one possible conversational cue. Vietnamese reply choice is highly register- and pronoun-sensitive, so a single cue can overstate certainty and create misleading what-you-may-hear expectations.

Risks
- The plan is otherwise aligned with the current family/row model and the no-graph-DB direction.
- The main residual risk is semantic, not infrastructural: if `consumptionHints` does not explicitly mark reply cues as approximate and context-dependent, UI consumers may present them too literally.
- If a row can belong to more than one cluster, the schema needs role-per-cluster pairing, not a single global role field.

Approval: BLOCK
