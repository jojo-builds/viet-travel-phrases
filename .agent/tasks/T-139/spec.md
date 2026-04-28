# Task Spec: T-139

## Title
Tagalog v2 substantial expansion packet and relation-ready phrase-hub growth pass

## Objective
Author and land the first truly substantial Tagalog v2 expansion packet so the app meaningfully moves beyond the current thin pack and gains a larger set of high-value traveler phrase hubs, nearby variants, and relation-ready follow-ons that support the listing/product/detail direction.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-139/brief.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/relation-sample-v1.json`
- `content-draft/tagalog/scenario-plan.json`

## Task type
- tagalog content expansion
- relation-ready phrase-hub authoring
- runtime-pack growth

## Scope
### Allowed write scopes
- `.agent/tasks/T-139/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\packs\tagalog.generated.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\presentation\tagalog.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\presentation\tagalogPremium.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\V2_CONTENT_MODEL.md` only if durable truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\PHRASE_RELATIONSHIP_MODEL.md` only if durable truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\DECISIONS.md` only if durable repo truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\PRIORITIES.md` only if durable roadmap truth changes

### Allowed read scopes
- `docs/**`
- `content-draft/tagalog/**`
- `app/family/**`
- `app/scripts/**`

### Must not touch
- the Liquid Glass UI lanes
- the Viet expansion lane
- `ops/**`
- `docs/operations/**`
- unrelated future-language lanes

## Source-of-truth notes
- Tagalog is still the thin runtime/content lane and needs a real step up in content depth.
- The product direction is toward richer listing/product/detail pages, so a larger increase in raw rows is expected when it improves phrase hubs.
- This task exists specifically because smaller content passes are not worth the heavy review-gate cost.
- Internal ambiguity about exact row mix is not a blocker; the task should use bounded authoring judgment and review to produce a meaningful batch.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\first-wave-priority.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\tagalog-v2-first-wave.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\source-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\packs\tagalog.generated.ts`
- `.agent/tasks/T-139/logs/tagalog-substantial-expansion-notes.md`
- `.agent/tasks/T-139/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-139/reviews/` for each required gate

## Concrete requirements
- land a substantial batch of at least `120` new row outcomes and at least `60` new or materially deepened phrase hubs unless a hard validated limitation makes the bounded high-value set genuinely smaller
- focus the batch on practical traveler scenarios such as:
  - transport / ride-hailing
  - hotel / check-in / room issues
  - food / ordering / restrictions
  - money / payment / totals
  - directions / landmarks / map help
  - misunderstanding repair
  - pharmacy / acute help
- keep the compact variant roles:
  - `say-first`
  - `clearer`
  - `more-polite`
  - `also-common`
- apply the core rule:
  - same intent, same traveler moment = variant row
  - different moment/context/next likely need = new listing/detail page family
- materially improve Tagalog relation-ready handoff surfaces instead of only inflating raw row count
- rebuild the Tagalog pack and leave the branch in a pack-valid state
- leave a concise but real batch note explaining what was added and why it improves the phrase-hub system

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-variant-discipline-review.md`
3. `03-relation-depth-review.md`
4. `04-batch-size-and-runtime-handoff-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app`:
- `npm run build:tagalog-pack`
- `npm run validate:family`
- `npm run validate:premium-boundary`
- `npm run validate:premium-expansion`

Also verify:
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate
- the task did not spill into the Viet or Liquid Glass lanes

## Definition of done
- Tagalog gains a genuinely substantial phrase-hub/content increase rather than a token cleanup
- the batch justifies the heavy review process
- the relation-ready handoff becomes meaningfully richer
- the fixed variant-role model remains intact
- Tagalog pack build and validators pass
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because the perfect long-term Tagalog master plan is not settled
- only report a blocker if it requires real user intervention, external service access, or a hard dependency outside the task scope

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
