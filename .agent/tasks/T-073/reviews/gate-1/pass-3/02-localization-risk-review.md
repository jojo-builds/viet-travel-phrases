Summary: `app/family/presentation/tagalog.ts` is still the right bounded place for a Tagalog-only search-copy tightening. The file is presentation-only, and compared with `app/family/presentation/viet.ts` the search text can be adjusted without touching shared matcher logic or expanding beyond the family shell.

Risks: The copy change will not alter normalization or search behavior, so any real search defect would remain in shared runtime code rather than this localized surface. The only other risk is UX clarity if the wording becomes too specific to Tagalog while the underlying search rules stay shared.

Recommendation: Keep this as a copy-only fix within the explicit write scope. Do not widen into matcher or content-draft work; that would break the bounded-fix premise.

Approval: APPROVE
