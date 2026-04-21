status: blocked
truth changed classification: unchanged

changed files with one-line reasons
- `app/family/presentation/vietPremium.ts` - tightened Viet purchase and locked-state copy for clearer small-screen scanning without changing purchase logic
- `docs/operations/LATEST_VALIDATION.md` - recorded the repo-side Viet purchase-surface audit as bounded copy validation only
- `.agent/tasks/T-023/logs/shell-audit.md` - captured the audit scope, findings, bounded fixes, and validation notes
- `.agent/tasks/T-023/state.json` - tracked claim, implementation, validation, and blocked closeout state
- `.agent/coordination/queue-index.json` - moved `T-023` from `queued` to `in_progress` for this run; final blocked sync still required at closeout

validation performed
- reviewed the active Viet purchase/locked-state render paths in `app/app/premium.tsx`, `app/app/settings.tsx`, `app/app/(tabs)/index.tsx`, `app/components/home/HomeTopSection.tsx`, and `app/app/scenario/[id].tsx`
- verified repo truth against `docs/PRIORITIES.md`, `docs/V2_BASELINE.md`, and `docs/operations/CURRENT_BLOCKERS.md`
- ran `npx --no-install tsc --noEmit` from `E:\AI\SpeakLocal-App-Family\app`
- attempted `npm run validate:family` from `E:\AI\SpeakLocal-App-Family\app`, but it failed in this runtime because `tsx/esbuild` hit `spawn EPERM`
- verified the required task-local audit artifact exists at `.agent/tasks/T-023/logs/shell-audit.md`

review findings and what was fixed
- the Viet locked/unlocked badge copy was too vague at a glance across the home header, compact result header, premium screen badge, and settings card
- the Viet teaser and premium explanatory copy carried honest truth but was denser than necessary for small-phone layouts
- fixed by tightening Viet-only presentation copy in `app/family/presentation/vietPremium.ts` and leaving purchase/store logic untouched

gate outcomes
- Gate 1: not run
- Gate 2: not run
- Gate 3: not run

what changed
- Viet purchase-state labels now read as a matched pair: `Trip Pack locked` / `Trip Pack unlocked`
- the Viet home teaser, premium screen body, manage copy, scenario preview copy, and store-unavailable placeholder are shorter and more explicit
- the operations validation log now distinguishes this repo-side clarity audit from missing device-proof purchase evidence

what remains open
- the mandatory 3-gate review workflow was not completed
- no new device purchase proof, restore proof, restart-persistence proof, or small-iPhone walkthrough evidence exists

substantive risks or follow-up cautions
- this task improved repo-side copy clarity only; it does not prove the final premium surfaces are comfortable on a real small iPhone
- the family validator could not be rerun in this runtime because of the `spawn EPERM` restriction around `tsx/esbuild`

recommended next step
- rerun T-023 in a session that explicitly permits subagent delegation so the required 3 review gates can be completed and the bounded Viet-shell changes can be closed honestly
