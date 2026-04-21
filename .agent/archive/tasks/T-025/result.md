status: blocked
truth changed classification: changed

changed files with one-line reasons
- `site/blog/phrases-tourists-actually-need-in-vietnam.html` - added the missing exported essentials module to the phrase article and corrected article copy from six to seven modules
- `site/blog/phrases-tourists-actually-need-in-vietnam/index.html` - mirrored the same phrase-article runtime wiring and copy fix in the routed index file
- `.agent/tasks/T-025/logs/runtime-audit.md` - recorded the runtime fetch, module-loading, and audio reachability audit evidence plus the remaining completion blocker
- `.agent/tasks/T-025/result.md` - recorded this blocked result honestly

validation performed
- verified `site/scripts/phrase-module-loader.js` still reads `/data/phrase-previews/manifest.json` and fetches module payloads by manifest `path`
- verified `site/data/phrase-previews/manifest.json` exports 7 Vietnam modules including `vietnam-essential-basics`
- verified the phrase article previously loaded only 6 module hosts, then updated it to load all 7 exported moduleIds
- verified the phrase article now explicitly states "seven export-driven starter modules"
- verified all 28 referenced audio URLs from the exported Vietnam starter modules exist under both `site/data/phrase-audio/vietnam/**` and `site/public/data/phrase-audio/vietnam/**`
- verified no `app/**`, `ops/**`, or `docs/operations/**` files were edited

review findings and what was fixed
- found a real runtime-facing content mismatch: the export manifest exposed 7 modules, but the main phrase article only rendered 6 and undercounted them in metadata/copy
- fixed by wiring `vietnam-essential-basics` into the route grid and module stack and by correcting the article text to seven modules
- found no missing referenced Vietnam website-audio files in the current starter export seam

gate outcomes
- Gate 1 pass 01: attempted but not completed; no durable 4-reviewer artifact set was produced
- Gate 2: not started because Gate 1 did not complete under the task contract
- Gate 3: not started because Gate 1 did not complete under the task contract

what changed
- the main Vietnam phrase article now matches the current 7-module export seam instead of silently omitting the essentials starter module
- the runtime/audio audit evidence is now captured in the task-local log

what remains open
- mandatory review-gate evidence is still missing, so the task must remain blocked until the 3-gate 4-subagent loop completes

substantive risks or follow-up cautions
- do not mark this task `done` unless Gate 1, Gate 2, and Gate 3 each have a latest pass with exactly 4 review artifacts and unanimous approval
- the bounded site fix is in place, but the queue contract still requires review-gate completion before closure

recommended next step
- resume T-025 and complete the required 3 review gates using the exact 4 reviewer roles before changing task status from `blocked`
