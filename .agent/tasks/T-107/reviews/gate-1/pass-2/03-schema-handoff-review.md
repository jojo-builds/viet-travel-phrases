Findings
- None blocking. The revised plan is specific enough for an additive handoff and stays aligned with the current scenario -> family -> phrase-row model described in `docs/PHRASE_RELATIONSHIP_MODEL.md` and `docs/V2_CONTENT_MODEL.md`.

Risks
- The only real integration risk is downstream mapping, not schema shape: `relation_cluster_role` and the `relatedFamilies` relation types will still need a strict one-way mapping into whatever app/runtime relation presentation is built later. Keep that mapping additive and do not infer a graph store.
- The current runtime pack in `app/family/packs/viet.generated.ts` is still flat today, so the handoff must remain sidecar-authored truth rather than expecting runtime code to already consume relation edges.

Approval: APPROVE
