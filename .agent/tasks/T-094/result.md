- status: done
- truth changed classification: prepared-next

## Changed files

- `content-draft/japanese/phrase-source.csv` - cleared the full `23`-row raw unresolved tail by translating `19` rows and explicitly deferring `4` weak Japan-fit rows.
- `content-draft/japanese/first-wave-priority.csv` - expanded the ranked ledger from `24` to `47` rows so the translated tail and explicit deferrals are visible in one place.
- `content-draft/japanese/README.md` - updated the lane summary to reflect three completed authoring passes and no raw `needs-translation` rows.
- `content-draft/japanese/source-notes.md` - documented the third-pass utility cleanup, the new status posture, and the four explicit deferrals.
- `content-draft/japanese/research-backlog.md` - marked the bounded third-pass cleanup complete and shifted follow-up work toward deferred-row decisions and starter-slice curation.
- `.agent/tasks/T-094/logs/translation-pack-audit.md` - recorded the `19` translated and `4` deferred row outcomes plus the pass intent.
- `.agent/tasks/T-094/reviews/gate-01-pass-01/*` - recorded the initial Gate 1 mixed result, including the false-positive encoding block.
- `.agent/tasks/T-094/reviews/gate-01-pass-02/*` - recorded the latest unanimous Gate 1 approval after Unicode verification.
- `.agent/tasks/T-094/reviews/gate-02-pass-01/*` - recorded the unanimous Gate 2 approval across the 4 required review roles.
- `.agent/tasks/T-094/reviews/gate-03-pass-01/*` - recorded the unanimous Gate 3 approval across the 4 required review roles.

## What changed

- Resolved the remaining Japanese `needs-translation` tail without pretending every baseline row deserved a direct translation.
- Added new drafted Japanese rows for cafe payment and drink variants, Wi-Fi trouble, taxi routing and comfort, purchase commitment, reassurance, directions closure, and a low-priority small-talk cleanup tail.
- Kept `japanese-street-food-4`, `japanese-grab-taxi-2`, and `japanese-asking-price-5` as `deferred-rewrite-needed` because generic herbs requests, city-center routing, and final-price bargaining are still weak Japan-first intents.
- Kept `japanese-small-talk-7` as `deferred-lower-priority` because direct `How are you` small talk is a weak default for brief Japan service interactions.
- Preserved the existing medical holdout on `japanese-simple-problems-6` instead of blurring that risk boundary.

## Validation performed

- Parsed `content-draft/japanese/phrase-source.csv` successfully and confirmed `70` rows.
- Verified `content-draft/japanese/phrase-source.csv` now has `0` `needs-translation` rows.
- Verified `content-draft/japanese/phrase-source.csv` now resolves to `43` `drafted`, `21` `first-wave-promoted-core`, `1` `rewritten-and-drafted`, `1` `first-wave-flagged-holdout`, `3` `deferred-rewrite-needed`, and `1` `deferred-lower-priority`.
- Parsed `content-draft/japanese/first-wave-priority.csv` successfully and confirmed `47` rows.
- Verified `content-draft/japanese/first-wave-priority.csv` now records `41` `drafted-in-phrase-source`, `2` `rewritten-and-drafted`, `3` `deferred-rewrite-needed`, and `1` `deferred-lower-priority` rows.
- Verified stored Japanese script is real Unicode rather than mojibake by checking code points in drafted rows and scanning the full CSV for suspect mojibake patterns.
- Verified task writes stayed inside `.agent/tasks/T-094/**` and `content-draft/japanese/**`.
- Verified Gate 1 latest pass (`gate-01-pass-02`) contains exactly `4` review files and all `4` say `Approval: APPROVE`.
- Verified Gate 2 latest pass (`gate-02-pass-01`) contains exactly `4` review files and all `4` say `Approval: APPROVE`.
- Verified Gate 3 latest pass (`gate-03-pass-01`) contains exactly `4` review files and all `4` say `Approval: APPROVE`.

## Review findings and what was fixed

- Gate 1 pass 01 produced a false-positive Japan-fit block because terminal rendering made valid Japanese Unicode look corrupted; this was resolved by validating actual code points and rerunning Gate 1.
- Gate 2 found no content, ledger, or scope blockers once the third-pass packet was in place.

## Gate outcomes

- Gate 1 pass 01: not unanimous because the Japan-fit reviewer blocked on a false-positive encoding concern.
- Gate 1 pass 02: approved by all 4 reviewers.
- Gate 2 pass 01: approved by all 4 reviewers.
- Gate 3 pass 01: approved by all 4 reviewers.

## Substantive risks or follow-up cautions

- `japanese-simple-problems-6` still needs expert or native medical review before it should be treated as ready.
- The four deferred rows still need a conscious rewrite-or-later decision instead of automatic promotion.
- The drafted small-talk tail now exists, but it still may not belong in any future starter slice.

## Recommended next step

- Use the deferred quartet and the small-talk tail as the next curation surface, while keeping native or expert review focused on medical and other higher-risk wording first.

## Process feedback

- BUG: terminal rendering can make valid Japanese Unicode look mojibaked, so reviewer prompts should include explicit code-point validation facts earlier when non-Latin CSV content is in scope.
