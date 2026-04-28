# T-164 Result: SpeakLocal Homepage Strategy

Status: done

## What changed

- Created `docs/design/homepage-research/README.md` as the homepage research and recommendation packet.
- Recommended **Start Speaking Now with graph-backed discovery shelves** as the V1 Home direction.
- Defined the first viewport: Vietnam identity, primary search entry, 3 to 5 audio-backed "Use now" phrase cards, and a visible hint of the next shelf.
- Compared three directions:
  - `Start Speaking Now`
  - `Explore The Phrase Graph`
  - `Daily Local Companion`
- Mapped recommended Home sections to current and near-future sources: scenarios/categories, relationship greeting pages, authored Tier 1 listing pages, search, saved/recent, practice, mascot, and SQLite graph runtime.

## What was learned

- Current data is enough for a useful V1 Home without waiting for SQLite runtime:
  - `18` scenarios
  - `900` catalog families
  - `919` phrase rows
  - `163` authored listing/detail pages
  - `150` Tier 1 inventory target
  - `3,756` audio manifest entries
  - `2,427` bundled MP3 files
  - `0` missing authored-audio audit entries
- The generated SQLite fixture is useful for planning, but not a V1 Home dependency because `LanguagePacks` is not bundled by `native-ios/project.yml` yet.
- Relationship greetings are already strong enough for a V1 "Who are you speaking to?" shelf through existing `anh`, `chị`, `em`, `ông`, `bà`, `chú`, and `cô` pages.
- Practice and mascot should not be used as V1 Home anchors until deck generation, local progress, mascot assets, and tone rules exist.

## Decisions recommended

- Make Home a utility screen, not a marketing page or course dashboard.
- Keep search primary and visible, aligned with the bottom search-island morph.
- Use "Use now" cards for immediate traveler value.
- Group categories into traveler-task shelves instead of showing every scenario as an equal top-level card.
- Surface relationship words as social choices, not grammar terminology.
- Feature authored "Different ways to say..." pages as product utility cards, not blog cards.
- Avoid streaks, XP, leaderboards, daily guilt, and false-ready practice/mascot modules.

## Risks

- Home can become too crowded if all proposed sections ship at once.
- Saved/recent/practice/mascot shelves must not appear before their runtime state/assets exist.
- Future graph shelves need canonical routing and duplicate normalized phrase audit work.
- Search quality may stay limited until SQLite FTS/search is bundled and read by Swift.

## Review gates

- Gate 1 Research And Asset Reality: `4/4` reviewers approved in `gate-01-pass-01`.
- Gate 2 Homepage Product Architecture: `4/4` reviewers approved in `gate-02-pass-01`.
- Gate 3 Handoff Readiness: `4/4` reviewers approved in `gate-03-pass-01`.
- Latest-pass review artifacts include `Approval: APPROVE` for all reviewer lanes.

## Validation

- `git diff --check -- docs/design/homepage-research/README.md .agent/tasks/T-164` passed.
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy` passed with `status: ok`.
- Local Markdown/source path spot-checks passed for the files and folders referenced by the packet.
- Review artifact scan found `12` latest-pass `Approval: APPROVE` lines and no `Approval: BLOCK` lines.

## Next task candidates

1. Implement native `HomeView` V1 with search, use-now cards, grouped situation shelves, relationship shelf, featured authored pages, and browse-all.
2. Add local recent/saved canonical page ID persistence and Home shelves.
3. Add XcodeGen resource rules for `Resources/LanguagePacks/**` and build a debug-gated SQLite repository spike.
4. After practice concept acceptance, create the practice deck generator and first Home practice entry.

## Process feedback

- NONE: Helper-backed claim, heartbeat, reviewer subagent, review artifact, and result paths all worked for this research/design task.
