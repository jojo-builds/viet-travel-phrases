# Viet Travel Phrasebook Post-Launch Release-Anchor Audit

Date: 2026-04-11
Lane: app
Primary repo: `C:\Users\Administrator\.openclaw\workspace\projects\viet-travel-phrases`
App status: Apple has accepted app version `1.0` for distribution

## Executive Summary

The repo is not yet clean enough to treat `HEAD` as a trustworthy release anchor.

- Current branch: `master`
- Remote relationship: `master` is `ahead 5` of `origin/master`
- Working tree: dirty, with tracked modifications plus untracked files
- Most defensible commit anchor: `35293a4` (`Checkpoint App Store submission status`)
- Most likely accepted submission state: not a single clean commit, but `35293a4` plus a dirty local working tree that included some app/legal/icon changes

The core ambiguity is that several changes described in local release notes as part of the submission/review-ready state are still uncommitted today. That means the accepted `1.0.0 (2)` app likely does not map perfectly to one git commit.

## 1. Release-Anchor Audit

### Current branch state

- Branch: `master`
- Upstream: `origin/master`
- Divergence: `ahead 5`
- `HEAD`: `35293a4` on `2026-04-09`

### The 5 commits ahead of origin

1. `5620913` - `Checkpoint TestFlight release state`
   - Adds local release tracking docs
   - Updates `app/eas.json`

2. `48cc042` - `Align release config and verify feedback endpoint`
   - Updates `app/app.json`
   - Aligns local iOS build number to `2`

3. `3afddd3` - `Refine App Store metadata and support page`
   - Updates App Store listing copy
   - Adds `docs/feedback.html`

4. `f1cae4f` - `Polish support page for App Store review`
   - Further adjusts `docs/feedback.html`

5. `35293a4` - `Checkpoint App Store submission status`
   - Updates local docs/checklists to reflect submission status

### Uncommitted tracked changes

Product-adjacent tracked changes still sitting outside git history:

- `app/app/privacy.tsx`
- `app/app/settings.tsx`
- `app/app/terms.tsx`
- `app/assets/icon.png`
- `app/assets/images/icon.png`
- `app/components/FeedbackModal.tsx`
- `app/package.json`
- `app/package-lock.json`
- `app/scripts/generate-audio.ts` (deleted)
- `docs/index.html`
- `docs/privacy.html`
- `docs/terms.html`

Non-product/admin tracked changes also present:

- `CLAUDE.md`
- `app/CLAUDE.md`
- `overnight-task.md`
- `prompt-library.md`

### Untracked files

Untracked items are mostly marketing/research/admin notes:

- `code-review-prompt.txt`
- `content/...`
- `reviews/RECOVERED-HANDOFF-2026-04-08.md`
- `reviews/pre-submission-review-opus-2026-04-07.md`
- `strategy/...`

### Best estimate of the accepted 1.0 submission state

What we can say with high confidence:

- `origin/master` is too old to be the accepted submission anchor because it still shows iOS `buildNumber: "1"`.
- The accepted build was `1.0.0 (2)`, so the accepted submission is newer than `origin/master`.
- The 5 local commits on `2026-04-09` clearly track TestFlight, submission, and review work.
- `35293a4` is the strongest single commit candidate because it is the tip of that submission sequence and explicitly checkpoints App Store submission status.

What remains uncertain:

- Some changes described locally as already part of the review-ready/shipping state are still uncommitted:
  - opaque icon replacements
  - `expo-font` dependency addition
  - in-app privacy/terms/feedback copy alignment
  - public privacy/terms/index copy alignment
  - removal of stale audio-generation script
- Because those changes are not represented in the 5 local commits, the accepted binary was likely produced from a dirty local tree, not from a perfectly clean tagged commit.

### Working conclusion

- Best repo anchor candidate: `35293a4`
- Best likely submission state: `35293a4` plus then-current dirty working tree changes related to icon/legal/feedback/support alignment

This is good enough to anchor retrospectively as an app release reference, but it should be labeled as a reconstructed release anchor, not a perfect provenance match.

## 2. Git Hygiene Recommendation

Smallest safe sequence:

1. Do not rewrite history.
2. Create an annotated tag on `35293a4` that explicitly marks it as the best clean release anchor candidate, not as perfect binary provenance.
3. Before any cleanup, make a reversible savepoint for the current dirty tree, including untracked files.
4. Continue v1.1 work on a separate branch after the savepoint exists.
5. Only then sort the dirty tree into very small, purpose-based commits.

Recommended naming:

- Tag: `ios-v1.0.0-build2-accepted-candidate`
- Branch for next work: `v1.1-prep`
- Optional savepoint: named stash such as `post-acceptance-audit-2026-04-11`

Recommended commit grouping for the current dirty tree:

1. `shipping-parity-and-compliance`
   - icon assets
   - in-app privacy/terms/feedback copy
   - public support/privacy/terms pages
   - `expo-font`
   - stale script removal

2. `docs-and-admin-followups`
   - `CLAUDE.md`
   - prompt/admin notes
   - marketing/research/supporting docs

Why this is the smallest safe path:

- It creates one trustworthy anchor without pretending provenance is cleaner than it is.
- It avoids broad cleanup.
- It keeps v1.1 work from landing on top of an ambiguous release checkpoint.

## 3. Product Baseline

### What the app really is today

Viet Travel Phrasebook is a focused offline travel phrasebook for Vietnam with:

- 10 travel scenarios
- 70 phrases
- bundled audio playback
- romanized pronunciation
- English translations
- quick phrases on the home screen
- saved favorites
- local persistence via AsyncStorage
- settings, privacy, terms, and in-app feedback flow
- simple two-tab navigation (`Learn`, `Saved`)

### What is already good enough in v1.0

- Very clear product scope
- Offline-first utility
- Fast access to practical travel situations
- Audio on every phrase
- No account, no ads, no analytics overhead
- Favorites are enough for repeat-use value
- App Store/legal/support basics exist

### Top weak points worth improving in v1.1

1. Release provenance is weak
   - shipped state is not cleanly anchored in git

2. Phrase retrieval is browse-first only
   - there is no global search or faster lookup path when a traveler is under time pressure

3. Trust/polish still needs a pass
   - support/legal copy was still being aligned after submission
   - icon/legal/support changes are not fully anchored
   - terminal inspection showed encoding ambiguity for Vietnamese text, which should be verified on-device before v1.1

## 4. v1.1 Roadmap Recommendation

Highest-value next 3 items:

1. Add global phrase search
   - Search across Vietnamese, romanized, and English
   - Biggest user-value improvement for low-to-moderate implementation cost

2. Improve fast-access flow on the home screen
   - Add recents and/or pinned essentials alongside existing quick phrases
   - Helps repeat real-world use without expanding app scope

3. Run a focused content-and-trust polish pass
   - Verify phrase text rendering, diacritics, romanization consistency, audio labeling, and support/legal parity on device
   - High user trust impact with relatively low technical risk

Items intentionally kept secondary for now:

- multi-language expansion
- major redesign
- large analytics build-out
- architecture changes

## 5. Post-Launch Notes To Capture Now

### Release notes hygiene

- Preserve the exact App Store `What's New` text used for `1.0`
- Record accepted version as `1.0.0 (2)`
- Record that acceptance happened by `2026-04-11`

### Version tracking

- Keep one durable table with:
  - app version
  - iOS build number
  - App Store status
  - best anchor commit
  - known provenance caveat

### Screenshots and metadata follow-up

- Save the exact approved screenshots into durable storage
- Preserve final listing metadata text used for submission
- Keep support/privacy/terms URLs in one place so future updates stay aligned

### Analytics and feedback hooks

- Do not add a broad analytics SDK by default
- Do create a lightweight manual loop:
  - monitor Formspree inbox
  - track App Store reviews
  - maintain a simple issue/request log

### Review and bug capture loop

- Start a single live feedback log for:
  - App Store reviews
  - support messages
  - reproducible bugs
  - common phrase requests
- Review it weekly until enough signal exists for stronger prioritization

## Recommended Next Action

Create the release anchor first, but label it honestly:

- tag `35293a4` as the best clean accepted-build candidate
- preserve the current dirty tree with a reversible savepoint
- branch into `v1.1-prep`
- then sort the dirty tree into two narrow commit groups

That gives the cleanest path into `v1.1` without pretending the current repo already has perfect release provenance.
