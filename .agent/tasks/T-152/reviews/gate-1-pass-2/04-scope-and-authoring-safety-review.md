The revised plan clears the pass-1 safety blocker. The clarified rule keeps `phrase-source.csv` marker usage bounded by freezing already saturated legacy rows and capping newly touched rows below the same seam-breaking threshold, which preserves the documented additive contract: wording stays in `phrase-source.csv`, graph truth stays in `relation-sample-v1.json`, and page modules stay in `answer-page-sample-v1.json`. That is the right fix for the exact risk called out in `docs/V2_CONTENT_MODEL.md` and `content-draft/viet/relation-authoring-notes.md`.

I do not see a remaining scope, schema, or lifecycle blocker. The current relation-only pool is large enough, and many candidate anchor rows are still low-density, so promoting 30 clusters and adding 3 phrase classes can stay inside the same authoring model as long as the clarified guardrail is enforced literally and saturated legacy rows receive zero new answer-page markers in this pass.

Approval: APPROVE
