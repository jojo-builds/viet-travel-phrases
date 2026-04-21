# T-025 Runtime Audit

Date: 2026-04-18
Status: bounded website fix applied; task blocked on mandatory review-gate completion

## Audit scope

- Vietnam website starter runtime fetch paths
- Phrase article starter-module loading assumptions
- Website-safe audio reachability for exported Vietnam starter modules

## Files reviewed

- `site/scripts/phrase-module-loader.js`
- `site/blog/phrases-tourists-actually-need-in-vietnam.html`
- `site/blog/phrases-tourists-actually-need-in-vietnam/index.html`
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- `site/data/phrase-previews/manifest.json`
- `site/data/phrase-previews/vietnam-essential-basics.json`
- `content-draft/viet/website-preview.json`
- `.agent/tasks/T-015/result.md`

## Findings

1. The export seam remained intact: `site/data/phrase-previews/manifest.json` still exported 7 Vietnam modules and the loader still fetched manifest/module JSON from `/data/phrase-previews/**`.
2. The main Vietnam phrase article was out of sync with the export seam:
   - export manifest contained `vietnam-essential-basics`
   - article markup rendered only 6 `data-phrase-module-id` hosts
   - article metadata and copy still claimed "six export-driven starter modules"
3. Vietnam website-safe audio reachability was clean for the exported starter seam:
   - 28 referenced audio URLs were present under `site/data/phrase-audio/vietnam/**`
   - the same 28 referenced audio URLs were present under `site/public/data/phrase-audio/vietnam/**`
   - no missing referenced MP3 files were found

## Bounded fix applied

- Added `vietnam-essential-basics` to the main phrase article route grid and phrase-module stack
- Updated phrase-article metadata/copy from six modules to seven modules
- Refreshed visible freshness dates in the phrase article to April 18, 2026
- Kept changes inside website-safe HTML surfaces only

## Validation evidence

- Node check: article `data-phrase-module-id` list now matches all 7 manifest moduleIds exactly
- Node check: phrase article now explicitly mentions "seven export-driven starter modules"
- Node check: 28 of 28 referenced audio URLs resolve in both `site/data` and `site/public`

## Remaining blocker

- Task contract requires 3 review gates with exactly 4 Codex subagents each and unanimous approval in the latest pass of every gate
- Attempted to start Gate 1 reviewers, but the subagent loop did not complete cleanly in this automation run, so no review-gate artifacts were written
- Because those artifacts are missing, the task cannot be marked `done`
