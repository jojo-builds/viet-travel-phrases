Summary: The scope is appropriately bounded for a family-shell localization/search-copy review. The relevant code and docs point to a narrow pass on shared search normalization plus localized presentation copy in `app/family/presentation/viet.ts`, `app/family/presentation/tagalog.ts`, and `app/lib/searchPhrases.ts`, without any clear need to widen into content-draft, registry, or runtime-variant work.

Risks: The visible copy gaps are mostly UX consistency issues, not scope breakers. `searchPhrases.ts` only normalizes Latin-script accents, `đ/Đ`, punctuation, and whitespace, so it is still limited to the current Viet/Tagalog Latin-script pair. On the copy side, the Tagalog search strings are more generic than Viet’s and may underspecify what users should type, while the Viet copy mixes search guidance with “how it sounds,” which is understandable but not especially precise.

Recommendation: Proceed with a bounded fix pass, but keep it strictly inside family-shell search behavior and localized search-facing copy. Do not expand into broader content authoring or language-prep changes unless a concrete defect appears while validating the search flow.

Approval: APPROVE
