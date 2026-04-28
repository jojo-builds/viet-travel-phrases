1. The planned route is safe at Gate 1. It stays inside the spec’s allowed write fence, preserves the existing additive sidecar model where CSV wording truth remains primary and relation/answer behavior stays in the two sidecars, matches the documented marker-density guardrail, and treats the sample-boundary counts as documentation that must move in lockstep if the bounded sample really changes from `99/80/19` to `102/83/19`.

2. Findings: none

3. Evidence:
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\spec.md:36-45` limits writes to T-154 artifacts plus the listed Viet worktree files, with `docs\V2_CONTENT_MODEL.md` and `docs\PHRASE_RELATIONSHIP_MODEL.md` allowed only if mirrored branch truth changes.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json:6-7` defines the current bounded sample as `99` clusters and explicitly calls it an additive handoff that does not replace the `scenario -> family -> phrase-row` model.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json:21` says relation-only supporting clusters may deepen the graph without changing answer-page hub count, which fits the proposed sidecar-only deepening approach.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\answer-page-sample-v1.json:25-30` says phrase wording stays in `phrase-source.csv`, cross-family relation truth stays in `relation-sample-v1.json`, and new answer-page markers should be spread across lower-density adjacent rows instead of saturated legacy rows.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md:14-15` records the current sample truth as `99` relation clusters and `80` answer-page hubs, while `:35-40` reiterates CSV wording ownership, the `6+` marker-density guardrail, and the rule against duplicating phrase wording in the answer-page sidecar.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md:37-43` assigns ownership cleanly across `phrase-source.csv`, `relation-sample-v1.json`, and `answer-page-sample-v1.json`; `:98-99` forbids overriding or duplicating wording truth; `:117-118` preserves the `6+` guardrail and bounded-sample framing.
- Direct CSV inspection shows the guardrail is materially relevant already: high-density legacy rows include `repair-2` with `40` `answer-page-sample=` markers, `taxi-1` with `23`, and `problems-2` with `22`, so the plan to prefer lower-density support rows is the right safety posture for this pass.
- Parsed current sidecar counts confirm the baseline the docs would need to update if the sample grows: `answer-page-sample-v1.json` reports `hubCount=80`, and `relation-sample-v1.json` reports `clusterCount=99`, `relationOnlyClusterCount=19`, and `supportingRowCount=134`.

Approval: APPROVE
