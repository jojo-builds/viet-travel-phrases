Summary: The actual search normalization lives in `app/lib/searchPhrases.ts:14-88`, which is outside the allowed write scope, while `app/scripts/validate-family-variants.ts:334-375` already exercises that shared helper. The Viet and Tagalog presentation files are copy/config only and do not show a clear family-shell fix path on their own.

Risks: Any attempt to “fix” search behavior here by editing `app/lib` would violate the task boundary. If the bug is truly in normalization, this run cannot safely resolve it without an out-of-scope change. The safer bounded outcome is an honest audit artifact, not forced churn.

Recommendation: Avoid `app/lib` edits in this run. If a concrete issue is found in `app/family` or docs, keep the change tightly bounded there; otherwise finish with a documented audit and no code change.

Approval: APPROVE
