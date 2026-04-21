# Task Spec: T-033

## Title
Desktop Codex automation pilot, Viet allowlisted audio follow-up batch

## Objective
Use the existing Viet audio benchmark truth to promote one meaningful, allowlisted batch of high-value `audioStatus=planned` rows toward app-usable coverage without overstating continuity quality. This is a bounded follow-up to the benchmark, not a broad regeneration campaign.

## Allowed write scopes
- .agent/tasks/T-033/**
- .agent/coordination/queue-index.json
- content-draft/viet/**
- app/assets/audio/** only for the exact allowlisted outputs produced in this task
- app/family/packs/** only if required to keep mapping truth consistent

## Must not touch
- site/**
- ops/**
- docs/operations/**
- release/build/TestFlight files
- unrelated language lanes

## Concrete execution requirement
- prefer a coherent high-value batch, usually at least `24` row outcomes unless the allowlisted candidate set is smaller
- preserve honest caution language about mixed-speaker continuity
- leave behind exact evidence of what changed and what remains pending

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate and require unanimous approval before advancement.
