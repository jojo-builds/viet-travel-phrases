# Viet Break It Down Audit

This folder is the source-owned manual review ledger for phrase-detail `Break it down` sections.

Rules:

- One ledger entry per runtime phrase/detail page.
- `reviewStatus: "reviewed"` means the Vietnamese chunks and English glosses have been reviewed by an AI/human reviewer, not generated blindly.
- `visualReview.status: "reviewed"` is reserved for pages that were also opened in the native app at `--detail-scroll first-breakdown`.
- Final completion requires both: every runtime page has `reviewStatus: "reviewed"` and every page has `visualReview.status: "reviewed"`.
- Multi-word non-final chunks must include `keepTogetherReason`; otherwise the phrase should be split smaller.
- Review-only fields are not emitted into `native-ios/Resources/**`.
