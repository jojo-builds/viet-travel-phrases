# Task Spec: T-136

## Title
Viet batch 1 expansion, high-friction relation-ready row pack on the dedicated content branch

## Objective
Author and land the first meaningful Viet expansion batch on the dedicated content branch so the app gains a stronger set of high-friction traveler phrases, same-intent variants, and adjacent next-step coverage that better support the richer listing/detail page model.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-136/brief.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `content-draft/viet/README.md` if present
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/scenario-plan.json`

## Task type
- viet content expansion
- relation-ready listing-page depth
- high-friction batch authoring

## Scope
### Allowed write scopes
- `.agent/tasks/T-136/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\V2_CONTENT_MODEL.md` only if durable content truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\PHRASE_RELATIONSHIP_MODEL.md` only if durable relation truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\DECISIONS.md` only if durable repo truth changes

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `app/family/**`
- `app/scripts/**`

### Must not touch
- the Liquid Glass shell lane
- `app/components/preview/**`
- `ops/**`
- `docs/operations/**`
- unrelated language lanes unless a bounded cross-lane reference is genuinely needed

## Source-of-truth notes
- this task is intentionally parallel-safe with `T-135` because it lives on the Viet content expansion branch and should not touch `ios_family_shared_ui`
- the visible product direction is moving toward richer listing/detail pages, so increased raw row density is expected when it improves phrase hubs
- scenario/category count should not be treated as a forced fixed cap if a justified split/addition improves clarity
- internal uncertainty about exact row mix is not a blocker; bounded authoring judgment and review should resolve it inside the task

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\scenario-plan.json` only if the task adds or splits categories
- `.agent/tasks/T-136/logs/viet-batch-1-expansion-notes.md`
- `.agent/tasks/T-136/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-136/reviews/` for each required gate

## Concrete requirements
- land a meaningful first batch of at least `24` row outcomes unless the bounded high-value set discovered during execution is genuinely smaller
- prioritize high-friction traveler moments such as:
  - understanding/repair
  - transport
  - health/pharmacy
  - problems/help
  - phone/internet/power
- keep the fixed compact variant roles:
  - `say-first`
  - `clearer`
  - `more-polite`
  - `also-common`
- apply the core rule:
  - same intent, same traveler moment = variant row
  - different moment/context/next likely need = new listing/detail page family
- improve adjacent-family usefulness rather than only inflating raw count
- leave a concise batch note that explains what was added and why it improves listing-page depth

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-variant-discipline-review.md`
3. `03-relation-depth-review.md`
4. `04-batch-scope-and-handoff-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\app` when relevant commands exist:
- `npm run build:viet-pack`
- `npm run validate:family`
- `npm run validate:premium-boundary`
- `npm run validate:premium-expansion`

Also verify:
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate
- the task did not spill into the Liquid Glass shell files

## Definition of done
- the first Viet expansion batch is materially larger and more useful than a token cleanup
- the batch improves listing/detail-page depth in high-friction traveler areas
- the fixed variant-role model remains intact
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because of ordinary authoring ambiguity or because a perfect long-term batch plan does not yet exist
- only report a blocker if it requires real user intervention, external service access, or a hard dependency outside the task scope

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
