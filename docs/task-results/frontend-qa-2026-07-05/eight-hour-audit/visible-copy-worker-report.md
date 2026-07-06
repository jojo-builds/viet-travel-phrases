# Visible Copy Worker Report

Date: 2026-07-06 Asia/Manila
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
Current source checked: `87d50da00a4b` plus current working-tree visible-copy repairs
Paywall: isolated; no `feature/paywall` files or flows audited.

## Validation Run

- `node native-ios/scripts/audit-visible-product-language.js`
  - Result: passed.
  - Output: `Visible product language audit passed: no retired visible labels found.`
- `node --test native-ios/scripts/audit-visible-product-language.test.js`
  - Result: passed, `1` test, `0` failures.
- Orchestrator follow-up after this worker report:
  - `Conversation break` was changed to `Practice beat`.
  - `node --test ./native-ios/scripts/audit-visible-product-language.test.js ./native-ios/scripts/viet-practice-copy.test.js` passed.
  - `node native-ios/scripts/audit-visible-product-language.js` passed.
- Fresh simulator build/render proof was attempted with XcodeBuildMCP but blocked before compile by local disk pressure:
  - build log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/build_run_sim_2026-07-05T16-03-16-217Z_pid15491_438049b8.log`
  - error: unable to write DerivedData manifest because `Macintosh HD` was out of space.
  - `df -h /` showed about `808Mi` available.

## Current Fixed Labels

The old `Quick conversations` / visible `Messages` card issue should be treated as historical for the current source unless a fresh current build proves otherwise:

- `native-ios/App/Models/BrowseSearchDestinations.swift:281` now sets `BrowseCollectionDescriptor.messageSectionDisplayTitle = "Practice moments"`.
- `native-ios/App/Models/PracticeScenarioModels.swift:495-499` now returns `Market greeting`, `Hotel greeting`, and `Respectful greeting` for the Practice/Browse contact-card names.
- Current working-tree repairs also remove the scenario-thread `MESSAGES` caption and the `Conversation complete` completion headline.
- The new audit command passes for the retired visible phrases it currently knows about.

## Findings

### HARD_BLOCK, RESOLVED IN WORKING TREE: Practice scenario thread showed `MESSAGES`

Evidence:

- Pre-repair source at `native-ios/App/Views/PracticeStorySessionView.swift:574` rendered `Text("MESSAGES")`.
- Current working tree now renders `Text("PRACTICE")` at the same location.
- `node native-ios/scripts/audit-visible-product-language.js` now passes.

Why it matters:

The active direction is Practice-first after Messages was parked. A visible `MESSAGES` caption in a Practice scenario flow directly contradicts the current product language and the operational note that visible Practice `Messages` labels were renamed.

Replacement applied in current working tree:

- `MESSAGES` -> `PRACTICE`.
- `native-ios/scripts/audit-visible-product-language.js` now catches case variants such as `MESSAGES`.

### SAFE_FIX_NOW, RESOLVED IN WORKING TREE: Completion headline said `Conversation complete`

Evidence:

- Pre-repair source at `native-ios/App/Views/PracticeStorySessionView.swift:611` rendered `Text("Conversation complete")`.
- Pre-repair source at `native-ios/App/Views/PracticeStorySessionView.swift:616` followed with `You sent \(summary.practicedCount) useful replies in this thread.`
- Current working tree now renders `Practice complete` and `You sent \(summary.practicedCount) useful replies in this practice run.`
- `node native-ios/scripts/audit-visible-product-language.js` now includes `Conversation complete` in its retired phrase list and passes.

Why it matters:

This is not the exact retired `Messages` label, but it keeps the Practice scenario completion surface framed as a conversation/thread instead of a Practice scenario. It is smaller than the `MESSAGES` caption but still current-source visible copy drift.

Replacement applied in current working tree:

- `Conversation complete` -> `Practice complete`
- `You sent \(summary.practicedCount) useful replies in this thread.` -> `You sent \(summary.practicedCount) useful replies in this practice run.`

### SAFE_FIX_NOW, RESOLVED IN WORKING TREE: Screen-reader fallback said `Conversation break`

Evidence:

- Pre-repair source at `native-ios/App/Views/PracticeStoryTranscriptView.swift:74` set `.accessibilityLabel(turn.text ?? "Conversation break")` on the scene-line spacer.
- Current working tree now uses `.accessibilityLabel(turn.text ?? "Practice beat")`.

Why it matters:

This is not visible text, but it is user-facing accessibility copy inside the Practice story transcript. If `turn.text` is absent, VoiceOver can still encounter old conversation framing.

Replacement applied in current working tree:

- `Conversation break` -> `Practice beat`

### FOLLOW_UP, RESOLVED IN WORKING TREE: Audit command did not cover the a11y fallback

Evidence:

- Pre-repair `node native-ios/scripts/audit-visible-product-language.js` passed even while `PracticeStoryTranscriptView.swift` still had the `Conversation break` fallback.
- Current working tree adds `Conversation break` to the retired phrase list and scans single-line `.accessibilityLabel(... ?? "...")` fallbacks.
- Current `node native-ios/scripts/audit-visible-product-language.js` passes after the source copy fix.

Why it matters:

The new audit now blocks the important retired visible strings from this pass, but the worker goal is broader than direct visible literals. Accessibility fallback copy in Practice views still needs a small scan rule or explicit source cleanup.

Audit coverage applied in current working tree:

- `Conversation break` is now blocked by `native-ios/scripts/audit-visible-product-language.js`.

## Accepted Temporary Risk

- `native-ios/App/Models/PhrasePage.swift:2055` still has an English phrase-page title `Respectful hello`. This appears to be a phrase/content page title, not a Practice contact card or retired Messages label.
- Internal identifiers and type names still include `Messages` / `message` in multiple Practice files. They are not visible copy and are outside this report's default read-only scope, but they make future audits easier to misread.

## Recommendation

Visible retired-label cleanup is repaired in the current working tree: the audit command passes, the old Browse label is fixed, local greeting card/scenario titles are Practice-safe, the Practice thread/completion strings no longer say `MESSAGES` or `Conversation complete`, and the `Conversation break` accessibility fallback is now `Practice beat` with audit coverage.

## Orchestrator Semantic-Copy Follow-Up

After the broad current-main sweeps, a second semantic scan found one data-backed copy leak outside direct SwiftUI labels: the Da Nang terminal SIM proof said `hotel messages`. That now says `hotel check-in details`. The Browse `Hello basics` subtitle was also softened from `Simple ways to start conversations.` to `Simple ways to start speaking.`

The audit script now scans source-backed retired phrases as well as direct `Text` / `Label` / `Button` / accessibility literals. Validation passed with `node native-ios/scripts/audit-visible-product-language.js`, `node --test native-ios/scripts/audit-visible-product-language.test.js`, exact stale-term `rg`, `git diff --check`, and `AppChromeTests/testBrowseTopLevelGreetingCardsHaveDistinctJobs`.
