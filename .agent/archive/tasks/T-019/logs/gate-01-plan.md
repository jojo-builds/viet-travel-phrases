# Gate 1 Revised Execution Plan

## Task
T-019: France research and prep-only lane bootstrap

## Scope
- Allowed writes:
  - `.agent/tasks/T-019/**`
  - `.agent/coordination/locks.yaml`
  - `.agent/coordination/queue-index.json`
  - `research/language-pipeline/french/**`
  - `content-draft/french/**`
- Explicit no-touch surfaces:
  - `app/**`
  - `site/**`
  - `ops/**`
  - `docs/operations/**`
  - runtime registry wiring such as `app/family/appRegistry.js` and `app/family/currentApp.ts`
  - existing `content-draft/viet/**`
  - existing `content-draft/tagalog/**`

## Review Discipline
- Required review roles in every gate:
  - `01-traveler-utility-review.md`
  - `02-language-risk-review.md`
  - `03-authoring-scaffold-review.md`
  - `04-contract-scope-review.md`
- Gate 1: scope and plan review, exactly 4 subagents, exactly 4 review artifacts, unanimous approval required before execution
- Gate 2: working-output review, exactly 4 subagents, exactly 4 review artifacts, unanimous approval required before finalization
- Gate 3: completion review, exactly 4 subagents, exactly 4 review artifacts, unanimous approval required before completion
- Review evidence path pattern:
  - `.agent/tasks/T-019/reviews/gate-01-pass-0x/`
  - `.agent/tasks/T-019/reviews/gate-02-pass-0x/`
  - `.agent/tasks/T-019/reviews/gate-03-pass-0x/`

## Revised Execution Plan
1. Produce `research/language-pipeline/french/FRANCE-TRAVEL-RESEARCH.md` with explicit sections for:
   - France / French destination framing
   - traveler-use reality and baseline 10-scenario fit
   - politeness and register defaults, especially greeting expectations, `tu/vous`, apology/request posture, and closings
   - pronunciation-helper posture: ASCII-friendly helper only, with standard French spelling remaining primary
   - search posture: accent-insensitive aliases and English-intent lookup ideas, without claiming runtime search is solved
   - reply/repair opportunities
   - high-risk phrase buckets: `tu/vous`, greetings/openers, apologies/requests, reply/repair, medical/emergency, bargaining expectations, transit vs taxi assumptions
   - a named ranked first-wave starter-pack recommendation for later authoring
   - source-confidence notes distinguishing repo-local inference from France-specific validation that still needs native review
2. Produce `content-draft/french/README.md` marking the lane prep-only and explaining that it supports future authoring, not runtime wiring.
3. Produce `content-draft/french/source-notes.md` capturing durable authoring defaults:
   - France-first register posture
   - pronunciation-helper limits
   - search alias posture
   - structural scenario notes versus phrase-level wording risks
   - ranked starter-pack framing
4. Produce `content-draft/french/scenario-plan.json` locked to the shared 10-scenario order unless the research shows a minor France-specific emphasis change worth documenting in notes. The file should include France-specific traveler tips and quick phrase candidates, not runtime claims.
5. Produce `content-draft/french/research-backlog.md` with unresolved research questions, native-review needs, phrase-level risk follow-ups, and next authoring priorities.

## Validation Checklist
- required output files exist
- `content-draft/french/scenario-plan.json` parses as valid JSON
- scenario plan stays aligned with the shared 10-scenario baseline or notes any justified minor deviation
- no runtime app files changed
- Gate 1, Gate 2, and Gate 3 latest passes each contain exactly 4 review files
- all 4 reviewers explicitly approve in the latest pass of each gate
- `.agent/tasks/T-019/result.md` records status, truth classification, changed files, validations, review findings, gate outcomes, risks, and recommended next step
- `.agent/tasks/T-019/result.md` also records why completion status is `done`, `partial`, or `blocked` and cannot imply completion from file presence alone
