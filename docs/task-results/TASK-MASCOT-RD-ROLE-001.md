# TASK-MASCOT-RD-ROLE-001 Result

status: done

commit hash: `5da5d040d7fc6689132ce76cb99aa8226b3e33ce`

## Report Path

- `docs/research/mascot-role-001/README.md`

## Source Count And Categories

- Public source count: 31 unique public URLs.
- Source categories: iOS platform/App Store guidance, translation/travel utility and serious-language comparators, language learning competitors, companion/premium-wellness examples, learning science/HCI, and public user/forum evidence.
- Repo source truth used separately: native visual reference, mascot docs, high-fidelity mascot packet, Practice storyboard, onboarding packets, Practice reward/mascot handoff, existing onboarding video digest, and completed Practice/onboarding/mascot task results.

## Video Digest Artifact Paths

- No new video digest artifacts were created.
- Existing relevant digest referenced: `docs/research/video-digests/onboarding-flows-1460-001/README.md`.

## Top Recommendation

Keep the chameleon mascot, but reduce and formalize its role.

Melo should be a restrained Practice/progress/empty-state companion, not the app narrator, phrase-page decoration, paywall salesperson, bottom/search/playback chrome element, or app icon centerpiece at launch.

## Top 5 Fold-In Changes

1. Adopt the rule: mascot as Practice companion, not product narrator.
2. Keep Melo out of phrase pages, search, playback controls, bottom chrome, paywall/trial benefits, and sensitive contexts.
3. Tie mascot progression only to source-anchored Practice readiness, route marks, and review queues.
4. Keep high-fidelity base/early-jade assets as current visual direction, but revise completion ornament density before production.
5. Require a small native Practice proof before any mascot-heavy App Store, app-icon, or brand commitment.

## Jojo Plan Steering

None. Jojo accepted the implementation plan as written for this task.

## What Needs Jojo Decision

- Approve or reject the recommendation that the launch app icon should not be mascot-first.
- Decide whether the first App Store screenshot set should include one Practice/Melo screen or no mascot at all.
- Decide whether the native Practice proof should use static PNGs only or include one reduced-motion-aware micro-animation.
- Pick the canonical route-readiness copy target, such as `Vietnam route updated`, `Ready for hotel desk`, or `Jade route mark unlocked`.

## Peer Review Outcome

Focused read-only reviewer outcome: CONCERNS, addressed before closeout.

Required fixes addressed in the report:

- Reconciled source-count wording by naming 31 unique public URLs and explaining why the pass exceeded the rough 18-25 source target.
- Added the exact `Fold-In Recommendation` section while preserving the R&D lane's `Fold-In Options` taxonomy.
- Replaced the pending peer-review note with a closeout summary.

Optional improvements addressed:

- Added `Tests Before Mascot-Heavy Commitment`.
- Clarified that Pimsleur is used as a premium serious-language comparator.

Residual reviewer risk: external pages are linked with access date, but not archived. Future launch-art or App Store work should re-check current screenshots and claims before using them.

## Validation

- `git diff --check` passed before the research report commit.
- `git diff --cached --check` passed before the research report commit.
- Staged-scope check before report commit found no `native-ios/**` paths staged.
- No app build or tests were run because this is a docs-only R&D task.
- An unrelated unstaged `native-ios/App/Views/AppShellView.swift` modification was present during closeout and was left untouched and unstaged.

## Recommended Next Prompt Or Task

Create `TASK-MASCOT-PRACTICE-NATIVE-SURFACE-001` for the `Native UI / Simulator` lane:

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family.
Read docs/research/mascot-role-001/README.md and docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md.
Design or implement the smallest native Practice surface that proves Melo as a restrained companion: Practice hub route card, eligible standard-prompt tiny mark, completion route update, and sensitive no-mascot state.
Do not put Melo in phrase pages, playback/search/bottom chrome, paywall, or sensitive prompts.
Commit when done and write the task result.
```
