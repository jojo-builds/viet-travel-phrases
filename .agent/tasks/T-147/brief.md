# T-147 feature brief

## Source
- Follow-on after completed `T-144`, `T-145`, and `T-146`
- Orchestrator-approved next move on `2026-04-23`

## Feature
Implement the first real runtime-style consumer for the Viet answer-page content seam inside the Liquid Glass listing-page preview.

## Intent
- bridge the gap between:
  - the new AI-shaped listing-page UI
  - the new Viet modular answer-page content model
- stop relying on mostly hardcoded/demo answer sections in the preview
- prove that the listing-page flow can be driven by structured answer-page data with different module mixes by phrase type

## Required behavior from the source direction
- use the new Viet answer-page sample and relation sample as source truth for the preview consumer
- keep the current Liquid Glass page experience
- replace hardcoded answer blocks with data-driven rendering where practical
- prove multiple phrase classes, not just one phrase

## Product constraints from orchestrator
- this belongs on the winning Liquid Glass branch/worktree
- the Viet content worktree is read-only source context for this task, not a write target
- this must produce visible runtime value, not more prep docs
- this is a meaningful task and must use the full 3-gate / 4-reviewer contract
