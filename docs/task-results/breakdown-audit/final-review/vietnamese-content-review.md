# Vietnamese Content Review

Status: HARD_BLOCK

Reviewed evidence:
- Ran `node native-ios/scripts/validate-viet-breakdown-audit.js --json`: PASS for non-strict mode with `2770` runtime pages, `2770` pages with breakdowns, `5` ledger entries, and `5` reviewed entries.
- Ran `node native-ios/scripts/validate-viet-breakdown-audit.js --require-all-reviewed --json`: FAIL as expected with `2765` missing reviewed ledger entries and all `5` current entries still `visualReview.status: pending`.
- Ran `node native-ios/scripts/viet-breakdown-audit.test.js`: PASS, 3/3 tests.
- Inspected the five current ledger entries and matching generated runtime breakdowns. The reviewed email pages are materially improved and learner-facing:
  - `Bạn = you`, `có thể = can`, `gửi = send`, `email = email`, `cho = to / for`, `tôi = me`, `được không? = is that possible?`
  - `báo cáo = report`, `hóa đơn = invoice / bill` or `receipt / bill` are context-appropriate.
  - `Vui lòng = please`, `qua = by / via` are acceptable traveler-facing glosses.
- Multi-word non-final reviewed tokens include `keepTogetherReason` in the ledger, including `có thể`, `báo cáo`, `hóa đơn`, `được không?`, and `Vui lòng`.

Findings:
- HARD_BLOCK: This cannot be called fully done under the user's plan. The ledger currently covers only `5 / 2770` runtime pages, and none of those five have completed visual app review.
- HARD_BLOCK: The rendered audit export still shows legacy placeholder/sloppy runtime glosses on missing pages, including `Đi xe máy = the action`, `Đi taxi = the action`, `Hills = English word in the attraction name`, and `Ngũ Hành = attraction name`. The reviewed subset fixes the screenshot-style email issue, but the full corpus still contains content that violates the requested standard.
- The non-strict validator is useful for allowing partial progress, but it passes while the export still contains placeholder glosses on unreviewed pages. Full completion must use the strict gate, not the non-strict validator.
- The rendered audit export lists `reviewStatus` and breakdowns, but it does not expose `visualReview.status`, `reviewNotes`, or `keepTogetherReason`. That makes the export less useful as a standalone final-review artifact; reviewers must inspect ledger JSON files to verify the full review state and multi-word rationale.

Required fixes before full completion:
- Add reviewed ledger entries for all `2770` runtime detail pages.
- Open every page in the app at `--detail-page <pageID> --detail-scroll first-breakdown` and set `visualReview.status: reviewed` only after visual inspection.
- Remove or override all remaining placeholder/malformed runtime breakdown glosses through reviewed ledger entries.
- Re-run the strict validator and require it to pass with `missingReviewedEntries: 0`.
- Improve the rendered audit export so final reviewers can see visual-review status and keep-together reasons without opening every ledger file separately.
- Re-run this Vietnamese/content review after the full ledger exists; the current approval is only for the quality direction of the five reviewed email pages, not for the corpus.

Coordinator follow-up:
- After this review, the rendered audit export was updated to include summary counts, `visualReview`, notes, and review-facing `keepTogetherReason` fields. The HARD_BLOCK remains because ledger coverage and visual review are still incomplete.
