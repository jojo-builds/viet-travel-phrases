Summary: The intended audit portion is sound, but the stated write scope is not sufficient for a real search-normalization fix. The actual shared-search behavior lives in `app/lib/searchPhrases.ts` and the result gating in `app/lib/homeSearchState.ts`, while `app/family/presentation/viet.ts` and `app/family/presentation/tagalog.ts` are copy-only presentation files.

Risks: Limiting edits to `app/family/**` and docs would not change the matcher behavior, so any discovered normalization defect would remain unfixed. `app/scripts/validate-family-variants.ts` also shows the search contract is validated against the lib matcher, which reinforces that docs/presentation-only changes would be cosmetic unless the audit concludes no code change is needed.

Recommendation: Use the current pass as a read-only audit only, or expand the allowed write surface to the actual search implementation if a code fix is expected. Do not rely on family presentation/docs edits to address normalization behavior.

Approval: BLOCK
